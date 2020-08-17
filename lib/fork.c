// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>

// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800

//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
// In the case of page table does not exist, return 0(representing no mapping)
static pte_t get_pte(void* addr)
{
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
		return 0;
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	int r;
	pte_t pte = get_pte(addr);

	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  }
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  memmove(PFTEMP, addr, PGSIZE);
  if ((r = sys_page_unmap(envid, addr)) < 0)
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
      panic("pgfault: page unmap failed (%e)", r);

}

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
	void* addr = (void*)(pn << PTXSHIFT);
	int error_code = 0;
	// LAB 4: Your code here.
	// First check whether this virtual page exists
	// The syscall also does check, but we need this double check because
	// Then we need to use this PTE to check whether it is read-only
	pte_t pte = get_pte((void*)(pn * PGSIZE));
	if(!(pte & PTE_P))
		return -1;
	// Case 1: This page is read-only, check uvpt for it
	if(!(pte & PTE_W) && !(pte & PTE_COW))
	{
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
			panic("Page Map Failed: %e", error_code);
	}
	// LAB5: page share copes with pages concerning fds 
	else if(pte & PTE_SHARE)
	{
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
			panic("Page Map Failed: %e", error_code);
	}
	else
	{
		// Map this page to the child, and make it COW
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
			panic("Page Map Failed: %e", error_code);
		// Make this page mapping in curenv COW
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
			panic("Page Map Failed: %e", error_code);
	}
	return 0;
}

static int
duppagefuck(envid_t envid, unsigned pn)
{
  int r;
  int perm = 0;
  // LAB 4: Your code here.
  // panic("duppage not implemented");

  envid_t this_env_id = sys_getenvid();
  void * va = (void *)(pn * PGSIZE);

  if (!(uvpd[pn] & PTE_P)) return -1; 
  
  perm = uvpt[pn] & 0xFFF;
  if ((perm & PTE_P) == 0) 
      panic("duppage: %e");
  else if (perm & PTE_SHARE) {
    perm |= PTE_U;
  } else if ((perm & PTE_W) || (perm & PTE_COW) ) {
      perm |= PTE_COW;
      perm |= PTE_U;
  }
  // IMPORTANT: adjust permission to the syscall
  perm &= PTE_SYSCALL;
  if((r = sys_page_map(this_env_id, va, envid, va, perm)) < 0) 
      panic("duppage: %e",r);
  if((r = sys_page_map(this_env_id, va, this_env_id, va, perm)) < 0) 
      panic("duppage: %e",r);
  return 0;
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  if (e_id == 0) {
      // child
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  if (r < 0) panic("fork: %e",r);

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  if (r < 0) panic("fork: set upcall for child fail, %e", r);

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
      panic("sys_env_set_status: %e", r);

  return e_id;
}

// Challenge!
int
sfork(void)
{
	panic("sfork not implemented");
	return -E_INVAL;
}
