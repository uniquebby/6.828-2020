
obj/user/faultbadhandler.debug：     文件格式 elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 3a 01 00 00       	call   800181 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 ef be ad de       	push   $0xdeadbeef
  80004f:	6a 00                	push   $0x0
  800051:	e8 76 02 00 00       	call   8002cc <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800070:	e8 ce 00 00 00       	call   800143 <sys_getenvid>
  800075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800082:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800087:	85 db                	test   %ebx,%ebx
  800089:	7e 07                	jle    800092 <libmain+0x2d>
		binaryname = argv[0];
  80008b:	8b 06                	mov    (%esi),%eax
  80008d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	56                   	push   %esi
  800096:	53                   	push   %ebx
  800097:	e8 97 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009c:	e8 0a 00 00 00       	call   8000ab <exit>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a7:	5b                   	pop    %ebx
  8000a8:	5e                   	pop    %esi
  8000a9:	5d                   	pop    %ebp
  8000aa:	c3                   	ret    

008000ab <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ab:	55                   	push   %ebp
  8000ac:	89 e5                	mov    %esp,%ebp
  8000ae:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000b1:	e8 b3 04 00 00       	call   800569 <close_all>
	sys_env_destroy(0);
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	6a 00                	push   $0x0
  8000bb:	e8 42 00 00 00       	call   800102 <sys_env_destroy>
}
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	c9                   	leave  
  8000c4:	c3                   	ret    

008000c5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c5:	55                   	push   %ebp
  8000c6:	89 e5                	mov    %esp,%ebp
  8000c8:	57                   	push   %edi
  8000c9:	56                   	push   %esi
  8000ca:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d6:	89 c3                	mov    %eax,%ebx
  8000d8:	89 c7                	mov    %eax,%edi
  8000da:	89 c6                	mov    %eax,%esi
  8000dc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000de:	5b                   	pop    %ebx
  8000df:	5e                   	pop    %esi
  8000e0:	5f                   	pop    %edi
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    

008000e3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	57                   	push   %edi
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f3:	89 d1                	mov    %edx,%ecx
  8000f5:	89 d3                	mov    %edx,%ebx
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	89 d6                	mov    %edx,%esi
  8000fb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000fd:	5b                   	pop    %ebx
  8000fe:	5e                   	pop    %esi
  8000ff:	5f                   	pop    %edi
  800100:	5d                   	pop    %ebp
  800101:	c3                   	ret    

00800102 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	57                   	push   %edi
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80010b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800110:	8b 55 08             	mov    0x8(%ebp),%edx
  800113:	b8 03 00 00 00       	mov    $0x3,%eax
  800118:	89 cb                	mov    %ecx,%ebx
  80011a:	89 cf                	mov    %ecx,%edi
  80011c:	89 ce                	mov    %ecx,%esi
  80011e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800120:	85 c0                	test   %eax,%eax
  800122:	7f 08                	jg     80012c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800124:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800127:	5b                   	pop    %ebx
  800128:	5e                   	pop    %esi
  800129:	5f                   	pop    %edi
  80012a:	5d                   	pop    %ebp
  80012b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80012c:	83 ec 0c             	sub    $0xc,%esp
  80012f:	50                   	push   %eax
  800130:	6a 03                	push   $0x3
  800132:	68 aa 22 80 00       	push   $0x8022aa
  800137:	6a 23                	push   $0x23
  800139:	68 c7 22 80 00       	push   $0x8022c7
  80013e:	e8 b1 13 00 00       	call   8014f4 <_panic>

00800143 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	57                   	push   %edi
  800147:	56                   	push   %esi
  800148:	53                   	push   %ebx
	asm volatile("int %1\n"
  800149:	ba 00 00 00 00       	mov    $0x0,%edx
  80014e:	b8 02 00 00 00       	mov    $0x2,%eax
  800153:	89 d1                	mov    %edx,%ecx
  800155:	89 d3                	mov    %edx,%ebx
  800157:	89 d7                	mov    %edx,%edi
  800159:	89 d6                	mov    %edx,%esi
  80015b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80015d:	5b                   	pop    %ebx
  80015e:	5e                   	pop    %esi
  80015f:	5f                   	pop    %edi
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <sys_yield>:

void
sys_yield(void)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	57                   	push   %edi
  800166:	56                   	push   %esi
  800167:	53                   	push   %ebx
	asm volatile("int %1\n"
  800168:	ba 00 00 00 00       	mov    $0x0,%edx
  80016d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800172:	89 d1                	mov    %edx,%ecx
  800174:	89 d3                	mov    %edx,%ebx
  800176:	89 d7                	mov    %edx,%edi
  800178:	89 d6                	mov    %edx,%esi
  80017a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80017c:	5b                   	pop    %ebx
  80017d:	5e                   	pop    %esi
  80017e:	5f                   	pop    %edi
  80017f:	5d                   	pop    %ebp
  800180:	c3                   	ret    

00800181 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	57                   	push   %edi
  800185:	56                   	push   %esi
  800186:	53                   	push   %ebx
  800187:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80018a:	be 00 00 00 00       	mov    $0x0,%esi
  80018f:	8b 55 08             	mov    0x8(%ebp),%edx
  800192:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800195:	b8 04 00 00 00       	mov    $0x4,%eax
  80019a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80019d:	89 f7                	mov    %esi,%edi
  80019f:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001a1:	85 c0                	test   %eax,%eax
  8001a3:	7f 08                	jg     8001ad <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a8:	5b                   	pop    %ebx
  8001a9:	5e                   	pop    %esi
  8001aa:	5f                   	pop    %edi
  8001ab:	5d                   	pop    %ebp
  8001ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	50                   	push   %eax
  8001b1:	6a 04                	push   $0x4
  8001b3:	68 aa 22 80 00       	push   $0x8022aa
  8001b8:	6a 23                	push   $0x23
  8001ba:	68 c7 22 80 00       	push   $0x8022c7
  8001bf:	e8 30 13 00 00       	call   8014f4 <_panic>

008001c4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	57                   	push   %edi
  8001c8:	56                   	push   %esi
  8001c9:	53                   	push   %ebx
  8001ca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d3:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001db:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001de:	8b 75 18             	mov    0x18(%ebp),%esi
  8001e1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e3:	85 c0                	test   %eax,%eax
  8001e5:	7f 08                	jg     8001ef <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ea:	5b                   	pop    %ebx
  8001eb:	5e                   	pop    %esi
  8001ec:	5f                   	pop    %edi
  8001ed:	5d                   	pop    %ebp
  8001ee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	50                   	push   %eax
  8001f3:	6a 05                	push   $0x5
  8001f5:	68 aa 22 80 00       	push   $0x8022aa
  8001fa:	6a 23                	push   $0x23
  8001fc:	68 c7 22 80 00       	push   $0x8022c7
  800201:	e8 ee 12 00 00       	call   8014f4 <_panic>

00800206 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	57                   	push   %edi
  80020a:	56                   	push   %esi
  80020b:	53                   	push   %ebx
  80020c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80020f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800214:	8b 55 08             	mov    0x8(%ebp),%edx
  800217:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021a:	b8 06 00 00 00       	mov    $0x6,%eax
  80021f:	89 df                	mov    %ebx,%edi
  800221:	89 de                	mov    %ebx,%esi
  800223:	cd 30                	int    $0x30
	if(check && ret > 0)
  800225:	85 c0                	test   %eax,%eax
  800227:	7f 08                	jg     800231 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800229:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022c:	5b                   	pop    %ebx
  80022d:	5e                   	pop    %esi
  80022e:	5f                   	pop    %edi
  80022f:	5d                   	pop    %ebp
  800230:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	50                   	push   %eax
  800235:	6a 06                	push   $0x6
  800237:	68 aa 22 80 00       	push   $0x8022aa
  80023c:	6a 23                	push   $0x23
  80023e:	68 c7 22 80 00       	push   $0x8022c7
  800243:	e8 ac 12 00 00       	call   8014f4 <_panic>

00800248 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	57                   	push   %edi
  80024c:	56                   	push   %esi
  80024d:	53                   	push   %ebx
  80024e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800251:	bb 00 00 00 00       	mov    $0x0,%ebx
  800256:	8b 55 08             	mov    0x8(%ebp),%edx
  800259:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025c:	b8 08 00 00 00       	mov    $0x8,%eax
  800261:	89 df                	mov    %ebx,%edi
  800263:	89 de                	mov    %ebx,%esi
  800265:	cd 30                	int    $0x30
	if(check && ret > 0)
  800267:	85 c0                	test   %eax,%eax
  800269:	7f 08                	jg     800273 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80026b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026e:	5b                   	pop    %ebx
  80026f:	5e                   	pop    %esi
  800270:	5f                   	pop    %edi
  800271:	5d                   	pop    %ebp
  800272:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	50                   	push   %eax
  800277:	6a 08                	push   $0x8
  800279:	68 aa 22 80 00       	push   $0x8022aa
  80027e:	6a 23                	push   $0x23
  800280:	68 c7 22 80 00       	push   $0x8022c7
  800285:	e8 6a 12 00 00       	call   8014f4 <_panic>

0080028a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	57                   	push   %edi
  80028e:	56                   	push   %esi
  80028f:	53                   	push   %ebx
  800290:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800293:	bb 00 00 00 00       	mov    $0x0,%ebx
  800298:	8b 55 08             	mov    0x8(%ebp),%edx
  80029b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80029e:	b8 09 00 00 00       	mov    $0x9,%eax
  8002a3:	89 df                	mov    %ebx,%edi
  8002a5:	89 de                	mov    %ebx,%esi
  8002a7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002a9:	85 c0                	test   %eax,%eax
  8002ab:	7f 08                	jg     8002b5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b0:	5b                   	pop    %ebx
  8002b1:	5e                   	pop    %esi
  8002b2:	5f                   	pop    %edi
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	6a 09                	push   $0x9
  8002bb:	68 aa 22 80 00       	push   $0x8022aa
  8002c0:	6a 23                	push   $0x23
  8002c2:	68 c7 22 80 00       	push   $0x8022c7
  8002c7:	e8 28 12 00 00       	call   8014f4 <_panic>

008002cc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	57                   	push   %edi
  8002d0:	56                   	push   %esi
  8002d1:	53                   	push   %ebx
  8002d2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002da:	8b 55 08             	mov    0x8(%ebp),%edx
  8002dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002e5:	89 df                	mov    %ebx,%edi
  8002e7:	89 de                	mov    %ebx,%esi
  8002e9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002eb:	85 c0                	test   %eax,%eax
  8002ed:	7f 08                	jg     8002f7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f2:	5b                   	pop    %ebx
  8002f3:	5e                   	pop    %esi
  8002f4:	5f                   	pop    %edi
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	50                   	push   %eax
  8002fb:	6a 0a                	push   $0xa
  8002fd:	68 aa 22 80 00       	push   $0x8022aa
  800302:	6a 23                	push   $0x23
  800304:	68 c7 22 80 00       	push   $0x8022c7
  800309:	e8 e6 11 00 00       	call   8014f4 <_panic>

0080030e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	57                   	push   %edi
  800312:	56                   	push   %esi
  800313:	53                   	push   %ebx
	asm volatile("int %1\n"
  800314:	8b 55 08             	mov    0x8(%ebp),%edx
  800317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80031a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80031f:	be 00 00 00 00       	mov    $0x0,%esi
  800324:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800327:	8b 7d 14             	mov    0x14(%ebp),%edi
  80032a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80032c:	5b                   	pop    %ebx
  80032d:	5e                   	pop    %esi
  80032e:	5f                   	pop    %edi
  80032f:	5d                   	pop    %ebp
  800330:	c3                   	ret    

00800331 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	57                   	push   %edi
  800335:	56                   	push   %esi
  800336:	53                   	push   %ebx
  800337:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80033a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80033f:	8b 55 08             	mov    0x8(%ebp),%edx
  800342:	b8 0d 00 00 00       	mov    $0xd,%eax
  800347:	89 cb                	mov    %ecx,%ebx
  800349:	89 cf                	mov    %ecx,%edi
  80034b:	89 ce                	mov    %ecx,%esi
  80034d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80034f:	85 c0                	test   %eax,%eax
  800351:	7f 08                	jg     80035b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800353:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800356:	5b                   	pop    %ebx
  800357:	5e                   	pop    %esi
  800358:	5f                   	pop    %edi
  800359:	5d                   	pop    %ebp
  80035a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80035b:	83 ec 0c             	sub    $0xc,%esp
  80035e:	50                   	push   %eax
  80035f:	6a 0d                	push   $0xd
  800361:	68 aa 22 80 00       	push   $0x8022aa
  800366:	6a 23                	push   $0x23
  800368:	68 c7 22 80 00       	push   $0x8022c7
  80036d:	e8 82 11 00 00       	call   8014f4 <_panic>

00800372 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	57                   	push   %edi
  800376:	56                   	push   %esi
  800377:	53                   	push   %ebx
	asm volatile("int %1\n"
  800378:	ba 00 00 00 00       	mov    $0x0,%edx
  80037d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800382:	89 d1                	mov    %edx,%ecx
  800384:	89 d3                	mov    %edx,%ebx
  800386:	89 d7                	mov    %edx,%edi
  800388:	89 d6                	mov    %edx,%esi
  80038a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80038c:	5b                   	pop    %ebx
  80038d:	5e                   	pop    %esi
  80038e:	5f                   	pop    %edi
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    

00800391 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800394:	8b 45 08             	mov    0x8(%ebp),%eax
  800397:	05 00 00 00 30       	add    $0x30000000,%eax
  80039c:	c1 e8 0c             	shr    $0xc,%eax
}
  80039f:	5d                   	pop    %ebp
  8003a0:	c3                   	ret    

008003a1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003b6:	5d                   	pop    %ebp
  8003b7:	c3                   	ret    

008003b8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003c0:	89 c2                	mov    %eax,%edx
  8003c2:	c1 ea 16             	shr    $0x16,%edx
  8003c5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003cc:	f6 c2 01             	test   $0x1,%dl
  8003cf:	74 2d                	je     8003fe <fd_alloc+0x46>
  8003d1:	89 c2                	mov    %eax,%edx
  8003d3:	c1 ea 0c             	shr    $0xc,%edx
  8003d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003dd:	f6 c2 01             	test   $0x1,%dl
  8003e0:	74 1c                	je     8003fe <fd_alloc+0x46>
  8003e2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003e7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003ec:	75 d2                	jne    8003c0 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8003f7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003fc:	eb 0a                	jmp    800408 <fd_alloc+0x50>
			*fd_store = fd;
  8003fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800401:	89 01                	mov    %eax,(%ecx)
			return 0;
  800403:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800408:	5d                   	pop    %ebp
  800409:	c3                   	ret    

0080040a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800410:	83 f8 1f             	cmp    $0x1f,%eax
  800413:	77 30                	ja     800445 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800415:	c1 e0 0c             	shl    $0xc,%eax
  800418:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80041d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800423:	f6 c2 01             	test   $0x1,%dl
  800426:	74 24                	je     80044c <fd_lookup+0x42>
  800428:	89 c2                	mov    %eax,%edx
  80042a:	c1 ea 0c             	shr    $0xc,%edx
  80042d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800434:	f6 c2 01             	test   $0x1,%dl
  800437:	74 1a                	je     800453 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800439:	8b 55 0c             	mov    0xc(%ebp),%edx
  80043c:	89 02                	mov    %eax,(%edx)
	return 0;
  80043e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800443:	5d                   	pop    %ebp
  800444:	c3                   	ret    
		return -E_INVAL;
  800445:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80044a:	eb f7                	jmp    800443 <fd_lookup+0x39>
		return -E_INVAL;
  80044c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800451:	eb f0                	jmp    800443 <fd_lookup+0x39>
  800453:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800458:	eb e9                	jmp    800443 <fd_lookup+0x39>

0080045a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	83 ec 08             	sub    $0x8,%esp
  800460:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800463:	ba 00 00 00 00       	mov    $0x0,%edx
  800468:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80046d:	39 08                	cmp    %ecx,(%eax)
  80046f:	74 38                	je     8004a9 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800471:	83 c2 01             	add    $0x1,%edx
  800474:	8b 04 95 54 23 80 00 	mov    0x802354(,%edx,4),%eax
  80047b:	85 c0                	test   %eax,%eax
  80047d:	75 ee                	jne    80046d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80047f:	a1 08 40 80 00       	mov    0x804008,%eax
  800484:	8b 40 48             	mov    0x48(%eax),%eax
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	51                   	push   %ecx
  80048b:	50                   	push   %eax
  80048c:	68 d8 22 80 00       	push   $0x8022d8
  800491:	e8 39 11 00 00       	call   8015cf <cprintf>
	*dev = 0;
  800496:	8b 45 0c             	mov    0xc(%ebp),%eax
  800499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004a7:	c9                   	leave  
  8004a8:	c3                   	ret    
			*dev = devtab[i];
  8004a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ac:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b3:	eb f2                	jmp    8004a7 <dev_lookup+0x4d>

008004b5 <fd_close>:
{
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	57                   	push   %edi
  8004b9:	56                   	push   %esi
  8004ba:	53                   	push   %ebx
  8004bb:	83 ec 24             	sub    $0x24,%esp
  8004be:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004c7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004c8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004ce:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004d1:	50                   	push   %eax
  8004d2:	e8 33 ff ff ff       	call   80040a <fd_lookup>
  8004d7:	89 c3                	mov    %eax,%ebx
  8004d9:	83 c4 10             	add    $0x10,%esp
  8004dc:	85 c0                	test   %eax,%eax
  8004de:	78 05                	js     8004e5 <fd_close+0x30>
	    || fd != fd2)
  8004e0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004e3:	74 16                	je     8004fb <fd_close+0x46>
		return (must_exist ? r : 0);
  8004e5:	89 f8                	mov    %edi,%eax
  8004e7:	84 c0                	test   %al,%al
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	0f 44 d8             	cmove  %eax,%ebx
}
  8004f1:	89 d8                	mov    %ebx,%eax
  8004f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004f6:	5b                   	pop    %ebx
  8004f7:	5e                   	pop    %esi
  8004f8:	5f                   	pop    %edi
  8004f9:	5d                   	pop    %ebp
  8004fa:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800501:	50                   	push   %eax
  800502:	ff 36                	pushl  (%esi)
  800504:	e8 51 ff ff ff       	call   80045a <dev_lookup>
  800509:	89 c3                	mov    %eax,%ebx
  80050b:	83 c4 10             	add    $0x10,%esp
  80050e:	85 c0                	test   %eax,%eax
  800510:	78 1a                	js     80052c <fd_close+0x77>
		if (dev->dev_close)
  800512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800515:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800518:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80051d:	85 c0                	test   %eax,%eax
  80051f:	74 0b                	je     80052c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	56                   	push   %esi
  800525:	ff d0                	call   *%eax
  800527:	89 c3                	mov    %eax,%ebx
  800529:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80052c:	83 ec 08             	sub    $0x8,%esp
  80052f:	56                   	push   %esi
  800530:	6a 00                	push   $0x0
  800532:	e8 cf fc ff ff       	call   800206 <sys_page_unmap>
	return r;
  800537:	83 c4 10             	add    $0x10,%esp
  80053a:	eb b5                	jmp    8004f1 <fd_close+0x3c>

0080053c <close>:

int
close(int fdnum)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800542:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800545:	50                   	push   %eax
  800546:	ff 75 08             	pushl  0x8(%ebp)
  800549:	e8 bc fe ff ff       	call   80040a <fd_lookup>
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	85 c0                	test   %eax,%eax
  800553:	79 02                	jns    800557 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800555:	c9                   	leave  
  800556:	c3                   	ret    
		return fd_close(fd, 1);
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	6a 01                	push   $0x1
  80055c:	ff 75 f4             	pushl  -0xc(%ebp)
  80055f:	e8 51 ff ff ff       	call   8004b5 <fd_close>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	eb ec                	jmp    800555 <close+0x19>

00800569 <close_all>:

void
close_all(void)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	53                   	push   %ebx
  80056d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800570:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800575:	83 ec 0c             	sub    $0xc,%esp
  800578:	53                   	push   %ebx
  800579:	e8 be ff ff ff       	call   80053c <close>
	for (i = 0; i < MAXFD; i++)
  80057e:	83 c3 01             	add    $0x1,%ebx
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	83 fb 20             	cmp    $0x20,%ebx
  800587:	75 ec                	jne    800575 <close_all+0xc>
}
  800589:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	57                   	push   %edi
  800592:	56                   	push   %esi
  800593:	53                   	push   %ebx
  800594:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800597:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80059a:	50                   	push   %eax
  80059b:	ff 75 08             	pushl  0x8(%ebp)
  80059e:	e8 67 fe ff ff       	call   80040a <fd_lookup>
  8005a3:	89 c3                	mov    %eax,%ebx
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	85 c0                	test   %eax,%eax
  8005aa:	0f 88 81 00 00 00    	js     800631 <dup+0xa3>
		return r;
	close(newfdnum);
  8005b0:	83 ec 0c             	sub    $0xc,%esp
  8005b3:	ff 75 0c             	pushl  0xc(%ebp)
  8005b6:	e8 81 ff ff ff       	call   80053c <close>

	newfd = INDEX2FD(newfdnum);
  8005bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005be:	c1 e6 0c             	shl    $0xc,%esi
  8005c1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005c7:	83 c4 04             	add    $0x4,%esp
  8005ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005cd:	e8 cf fd ff ff       	call   8003a1 <fd2data>
  8005d2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005d4:	89 34 24             	mov    %esi,(%esp)
  8005d7:	e8 c5 fd ff ff       	call   8003a1 <fd2data>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005e1:	89 d8                	mov    %ebx,%eax
  8005e3:	c1 e8 16             	shr    $0x16,%eax
  8005e6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005ed:	a8 01                	test   $0x1,%al
  8005ef:	74 11                	je     800602 <dup+0x74>
  8005f1:	89 d8                	mov    %ebx,%eax
  8005f3:	c1 e8 0c             	shr    $0xc,%eax
  8005f6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005fd:	f6 c2 01             	test   $0x1,%dl
  800600:	75 39                	jne    80063b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800602:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800605:	89 d0                	mov    %edx,%eax
  800607:	c1 e8 0c             	shr    $0xc,%eax
  80060a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800611:	83 ec 0c             	sub    $0xc,%esp
  800614:	25 07 0e 00 00       	and    $0xe07,%eax
  800619:	50                   	push   %eax
  80061a:	56                   	push   %esi
  80061b:	6a 00                	push   $0x0
  80061d:	52                   	push   %edx
  80061e:	6a 00                	push   $0x0
  800620:	e8 9f fb ff ff       	call   8001c4 <sys_page_map>
  800625:	89 c3                	mov    %eax,%ebx
  800627:	83 c4 20             	add    $0x20,%esp
  80062a:	85 c0                	test   %eax,%eax
  80062c:	78 31                	js     80065f <dup+0xd1>
		goto err;

	return newfdnum;
  80062e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800631:	89 d8                	mov    %ebx,%eax
  800633:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800636:	5b                   	pop    %ebx
  800637:	5e                   	pop    %esi
  800638:	5f                   	pop    %edi
  800639:	5d                   	pop    %ebp
  80063a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80063b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	25 07 0e 00 00       	and    $0xe07,%eax
  80064a:	50                   	push   %eax
  80064b:	57                   	push   %edi
  80064c:	6a 00                	push   $0x0
  80064e:	53                   	push   %ebx
  80064f:	6a 00                	push   $0x0
  800651:	e8 6e fb ff ff       	call   8001c4 <sys_page_map>
  800656:	89 c3                	mov    %eax,%ebx
  800658:	83 c4 20             	add    $0x20,%esp
  80065b:	85 c0                	test   %eax,%eax
  80065d:	79 a3                	jns    800602 <dup+0x74>
	sys_page_unmap(0, newfd);
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	56                   	push   %esi
  800663:	6a 00                	push   $0x0
  800665:	e8 9c fb ff ff       	call   800206 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80066a:	83 c4 08             	add    $0x8,%esp
  80066d:	57                   	push   %edi
  80066e:	6a 00                	push   $0x0
  800670:	e8 91 fb ff ff       	call   800206 <sys_page_unmap>
	return r;
  800675:	83 c4 10             	add    $0x10,%esp
  800678:	eb b7                	jmp    800631 <dup+0xa3>

0080067a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	53                   	push   %ebx
  80067e:	83 ec 1c             	sub    $0x1c,%esp
  800681:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800684:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800687:	50                   	push   %eax
  800688:	53                   	push   %ebx
  800689:	e8 7c fd ff ff       	call   80040a <fd_lookup>
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	85 c0                	test   %eax,%eax
  800693:	78 3f                	js     8006d4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800695:	83 ec 08             	sub    $0x8,%esp
  800698:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80069b:	50                   	push   %eax
  80069c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069f:	ff 30                	pushl  (%eax)
  8006a1:	e8 b4 fd ff ff       	call   80045a <dev_lookup>
  8006a6:	83 c4 10             	add    $0x10,%esp
  8006a9:	85 c0                	test   %eax,%eax
  8006ab:	78 27                	js     8006d4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006b0:	8b 42 08             	mov    0x8(%edx),%eax
  8006b3:	83 e0 03             	and    $0x3,%eax
  8006b6:	83 f8 01             	cmp    $0x1,%eax
  8006b9:	74 1e                	je     8006d9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006be:	8b 40 08             	mov    0x8(%eax),%eax
  8006c1:	85 c0                	test   %eax,%eax
  8006c3:	74 35                	je     8006fa <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	ff 75 10             	pushl  0x10(%ebp)
  8006cb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ce:	52                   	push   %edx
  8006cf:	ff d0                	call   *%eax
  8006d1:	83 c4 10             	add    $0x10,%esp
}
  8006d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006d7:	c9                   	leave  
  8006d8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006d9:	a1 08 40 80 00       	mov    0x804008,%eax
  8006de:	8b 40 48             	mov    0x48(%eax),%eax
  8006e1:	83 ec 04             	sub    $0x4,%esp
  8006e4:	53                   	push   %ebx
  8006e5:	50                   	push   %eax
  8006e6:	68 19 23 80 00       	push   $0x802319
  8006eb:	e8 df 0e 00 00       	call   8015cf <cprintf>
		return -E_INVAL;
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006f8:	eb da                	jmp    8006d4 <read+0x5a>
		return -E_NOT_SUPP;
  8006fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006ff:	eb d3                	jmp    8006d4 <read+0x5a>

00800701 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800701:	55                   	push   %ebp
  800702:	89 e5                	mov    %esp,%ebp
  800704:	57                   	push   %edi
  800705:	56                   	push   %esi
  800706:	53                   	push   %ebx
  800707:	83 ec 0c             	sub    $0xc,%esp
  80070a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80070d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800710:	bb 00 00 00 00       	mov    $0x0,%ebx
  800715:	39 f3                	cmp    %esi,%ebx
  800717:	73 23                	jae    80073c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800719:	83 ec 04             	sub    $0x4,%esp
  80071c:	89 f0                	mov    %esi,%eax
  80071e:	29 d8                	sub    %ebx,%eax
  800720:	50                   	push   %eax
  800721:	89 d8                	mov    %ebx,%eax
  800723:	03 45 0c             	add    0xc(%ebp),%eax
  800726:	50                   	push   %eax
  800727:	57                   	push   %edi
  800728:	e8 4d ff ff ff       	call   80067a <read>
		if (m < 0)
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	85 c0                	test   %eax,%eax
  800732:	78 06                	js     80073a <readn+0x39>
			return m;
		if (m == 0)
  800734:	74 06                	je     80073c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  800736:	01 c3                	add    %eax,%ebx
  800738:	eb db                	jmp    800715 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80073a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80073c:	89 d8                	mov    %ebx,%eax
  80073e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800741:	5b                   	pop    %ebx
  800742:	5e                   	pop    %esi
  800743:	5f                   	pop    %edi
  800744:	5d                   	pop    %ebp
  800745:	c3                   	ret    

00800746 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	53                   	push   %ebx
  80074a:	83 ec 1c             	sub    $0x1c,%esp
  80074d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800750:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800753:	50                   	push   %eax
  800754:	53                   	push   %ebx
  800755:	e8 b0 fc ff ff       	call   80040a <fd_lookup>
  80075a:	83 c4 10             	add    $0x10,%esp
  80075d:	85 c0                	test   %eax,%eax
  80075f:	78 3a                	js     80079b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800767:	50                   	push   %eax
  800768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80076b:	ff 30                	pushl  (%eax)
  80076d:	e8 e8 fc ff ff       	call   80045a <dev_lookup>
  800772:	83 c4 10             	add    $0x10,%esp
  800775:	85 c0                	test   %eax,%eax
  800777:	78 22                	js     80079b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80077c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800780:	74 1e                	je     8007a0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800782:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800785:	8b 52 0c             	mov    0xc(%edx),%edx
  800788:	85 d2                	test   %edx,%edx
  80078a:	74 35                	je     8007c1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80078c:	83 ec 04             	sub    $0x4,%esp
  80078f:	ff 75 10             	pushl  0x10(%ebp)
  800792:	ff 75 0c             	pushl  0xc(%ebp)
  800795:	50                   	push   %eax
  800796:	ff d2                	call   *%edx
  800798:	83 c4 10             	add    $0x10,%esp
}
  80079b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80079e:	c9                   	leave  
  80079f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007a0:	a1 08 40 80 00       	mov    0x804008,%eax
  8007a5:	8b 40 48             	mov    0x48(%eax),%eax
  8007a8:	83 ec 04             	sub    $0x4,%esp
  8007ab:	53                   	push   %ebx
  8007ac:	50                   	push   %eax
  8007ad:	68 35 23 80 00       	push   $0x802335
  8007b2:	e8 18 0e 00 00       	call   8015cf <cprintf>
		return -E_INVAL;
  8007b7:	83 c4 10             	add    $0x10,%esp
  8007ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007bf:	eb da                	jmp    80079b <write+0x55>
		return -E_NOT_SUPP;
  8007c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007c6:	eb d3                	jmp    80079b <write+0x55>

008007c8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007d1:	50                   	push   %eax
  8007d2:	ff 75 08             	pushl  0x8(%ebp)
  8007d5:	e8 30 fc ff ff       	call   80040a <fd_lookup>
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	78 0e                	js     8007ef <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007ef:	c9                   	leave  
  8007f0:	c3                   	ret    

008007f1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007f1:	55                   	push   %ebp
  8007f2:	89 e5                	mov    %esp,%ebp
  8007f4:	53                   	push   %ebx
  8007f5:	83 ec 1c             	sub    $0x1c,%esp
  8007f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007fe:	50                   	push   %eax
  8007ff:	53                   	push   %ebx
  800800:	e8 05 fc ff ff       	call   80040a <fd_lookup>
  800805:	83 c4 10             	add    $0x10,%esp
  800808:	85 c0                	test   %eax,%eax
  80080a:	78 37                	js     800843 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800812:	50                   	push   %eax
  800813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800816:	ff 30                	pushl  (%eax)
  800818:	e8 3d fc ff ff       	call   80045a <dev_lookup>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	85 c0                	test   %eax,%eax
  800822:	78 1f                	js     800843 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800827:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80082b:	74 1b                	je     800848 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80082d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800830:	8b 52 18             	mov    0x18(%edx),%edx
  800833:	85 d2                	test   %edx,%edx
  800835:	74 32                	je     800869 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	50                   	push   %eax
  80083e:	ff d2                	call   *%edx
  800840:	83 c4 10             	add    $0x10,%esp
}
  800843:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800846:	c9                   	leave  
  800847:	c3                   	ret    
			thisenv->env_id, fdnum);
  800848:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80084d:	8b 40 48             	mov    0x48(%eax),%eax
  800850:	83 ec 04             	sub    $0x4,%esp
  800853:	53                   	push   %ebx
  800854:	50                   	push   %eax
  800855:	68 f8 22 80 00       	push   $0x8022f8
  80085a:	e8 70 0d 00 00       	call   8015cf <cprintf>
		return -E_INVAL;
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800867:	eb da                	jmp    800843 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800869:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80086e:	eb d3                	jmp    800843 <ftruncate+0x52>

00800870 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	53                   	push   %ebx
  800874:	83 ec 1c             	sub    $0x1c,%esp
  800877:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80087a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80087d:	50                   	push   %eax
  80087e:	ff 75 08             	pushl  0x8(%ebp)
  800881:	e8 84 fb ff ff       	call   80040a <fd_lookup>
  800886:	83 c4 10             	add    $0x10,%esp
  800889:	85 c0                	test   %eax,%eax
  80088b:	78 4b                	js     8008d8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800897:	ff 30                	pushl  (%eax)
  800899:	e8 bc fb ff ff       	call   80045a <dev_lookup>
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	85 c0                	test   %eax,%eax
  8008a3:	78 33                	js     8008d8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8008a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008ac:	74 2f                	je     8008dd <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008ae:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008b1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008b8:	00 00 00 
	stat->st_isdir = 0;
  8008bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008c2:	00 00 00 
	stat->st_dev = dev;
  8008c5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	53                   	push   %ebx
  8008cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8008d2:	ff 50 14             	call   *0x14(%eax)
  8008d5:	83 c4 10             	add    $0x10,%esp
}
  8008d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    
		return -E_NOT_SUPP;
  8008dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008e2:	eb f4                	jmp    8008d8 <fstat+0x68>

008008e4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	56                   	push   %esi
  8008e8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	6a 00                	push   $0x0
  8008ee:	ff 75 08             	pushl  0x8(%ebp)
  8008f1:	e8 2f 02 00 00       	call   800b25 <open>
  8008f6:	89 c3                	mov    %eax,%ebx
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	85 c0                	test   %eax,%eax
  8008fd:	78 1b                	js     80091a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	50                   	push   %eax
  800906:	e8 65 ff ff ff       	call   800870 <fstat>
  80090b:	89 c6                	mov    %eax,%esi
	close(fd);
  80090d:	89 1c 24             	mov    %ebx,(%esp)
  800910:	e8 27 fc ff ff       	call   80053c <close>
	return r;
  800915:	83 c4 10             	add    $0x10,%esp
  800918:	89 f3                	mov    %esi,%ebx
}
  80091a:	89 d8                	mov    %ebx,%eax
  80091c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091f:	5b                   	pop    %ebx
  800920:	5e                   	pop    %esi
  800921:	5d                   	pop    %ebp
  800922:	c3                   	ret    

00800923 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	56                   	push   %esi
  800927:	53                   	push   %ebx
  800928:	89 c6                	mov    %eax,%esi
  80092a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80092c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800933:	74 27                	je     80095c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800935:	6a 07                	push   $0x7
  800937:	68 00 50 80 00       	push   $0x805000
  80093c:	56                   	push   %esi
  80093d:	ff 35 00 40 80 00    	pushl  0x804000
  800943:	e8 0c 16 00 00       	call   801f54 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800948:	83 c4 0c             	add    $0xc,%esp
  80094b:	6a 00                	push   $0x0
  80094d:	53                   	push   %ebx
  80094e:	6a 00                	push   $0x0
  800950:	e8 8c 15 00 00       	call   801ee1 <ipc_recv>
}
  800955:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800958:	5b                   	pop    %ebx
  800959:	5e                   	pop    %esi
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80095c:	83 ec 0c             	sub    $0xc,%esp
  80095f:	6a 01                	push   $0x1
  800961:	e8 5a 16 00 00       	call   801fc0 <ipc_find_env>
  800966:	a3 00 40 80 00       	mov    %eax,0x804000
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	eb c5                	jmp    800935 <fsipc+0x12>

00800970 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8b 40 0c             	mov    0xc(%eax),%eax
  80097c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800989:	ba 00 00 00 00       	mov    $0x0,%edx
  80098e:	b8 02 00 00 00       	mov    $0x2,%eax
  800993:	e8 8b ff ff ff       	call   800923 <fsipc>
}
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <devfile_flush>:
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8009a6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b0:	b8 06 00 00 00       	mov    $0x6,%eax
  8009b5:	e8 69 ff ff ff       	call   800923 <fsipc>
}
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <devfile_stat>:
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	53                   	push   %ebx
  8009c0:	83 ec 04             	sub    $0x4,%esp
  8009c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8009cc:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d6:	b8 05 00 00 00       	mov    $0x5,%eax
  8009db:	e8 43 ff ff ff       	call   800923 <fsipc>
  8009e0:	85 c0                	test   %eax,%eax
  8009e2:	78 2c                	js     800a10 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	68 00 50 80 00       	push   $0x805000
  8009ec:	53                   	push   %ebx
  8009ed:	e8 b9 11 00 00       	call   801bab <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009f2:	a1 80 50 80 00       	mov    0x805080,%eax
  8009f7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009fd:	a1 84 50 80 00       	mov    0x805084,%eax
  800a02:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a13:	c9                   	leave  
  800a14:	c3                   	ret    

00800a15 <devfile_write>:
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	53                   	push   %ebx
  800a19:	83 ec 04             	sub    $0x4,%esp
  800a1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  800a1f:	85 db                	test   %ebx,%ebx
  800a21:	75 07                	jne    800a2a <devfile_write+0x15>
	return n_all;
  800a23:	89 d8                	mov    %ebx,%eax
}
  800a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	8b 40 0c             	mov    0xc(%eax),%eax
  800a30:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  800a35:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  800a3b:	83 ec 04             	sub    $0x4,%esp
  800a3e:	53                   	push   %ebx
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	68 08 50 80 00       	push   $0x805008
  800a47:	e8 ed 12 00 00       	call   801d39 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a51:	b8 04 00 00 00       	mov    $0x4,%eax
  800a56:	e8 c8 fe ff ff       	call   800923 <fsipc>
  800a5b:	83 c4 10             	add    $0x10,%esp
  800a5e:	85 c0                	test   %eax,%eax
  800a60:	78 c3                	js     800a25 <devfile_write+0x10>
	  assert(r <= n_left);
  800a62:	39 d8                	cmp    %ebx,%eax
  800a64:	77 0b                	ja     800a71 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  800a66:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a6b:	7f 1d                	jg     800a8a <devfile_write+0x75>
    n_all += r;
  800a6d:	89 c3                	mov    %eax,%ebx
  800a6f:	eb b2                	jmp    800a23 <devfile_write+0xe>
	  assert(r <= n_left);
  800a71:	68 68 23 80 00       	push   $0x802368
  800a76:	68 74 23 80 00       	push   $0x802374
  800a7b:	68 9f 00 00 00       	push   $0x9f
  800a80:	68 89 23 80 00       	push   $0x802389
  800a85:	e8 6a 0a 00 00       	call   8014f4 <_panic>
	  assert(r <= PGSIZE);
  800a8a:	68 94 23 80 00       	push   $0x802394
  800a8f:	68 74 23 80 00       	push   $0x802374
  800a94:	68 a0 00 00 00       	push   $0xa0
  800a99:	68 89 23 80 00       	push   $0x802389
  800a9e:	e8 51 0a 00 00       	call   8014f4 <_panic>

00800aa3 <devfile_read>:
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	56                   	push   %esi
  800aa7:	53                   	push   %ebx
  800aa8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8b 40 0c             	mov    0xc(%eax),%eax
  800ab1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ab6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800abc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ac6:	e8 58 fe ff ff       	call   800923 <fsipc>
  800acb:	89 c3                	mov    %eax,%ebx
  800acd:	85 c0                	test   %eax,%eax
  800acf:	78 1f                	js     800af0 <devfile_read+0x4d>
	assert(r <= n);
  800ad1:	39 f0                	cmp    %esi,%eax
  800ad3:	77 24                	ja     800af9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800ad5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ada:	7f 33                	jg     800b0f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800adc:	83 ec 04             	sub    $0x4,%esp
  800adf:	50                   	push   %eax
  800ae0:	68 00 50 80 00       	push   $0x805000
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	e8 4c 12 00 00       	call   801d39 <memmove>
	return r;
  800aed:	83 c4 10             	add    $0x10,%esp
}
  800af0:	89 d8                	mov    %ebx,%eax
  800af2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800af5:	5b                   	pop    %ebx
  800af6:	5e                   	pop    %esi
  800af7:	5d                   	pop    %ebp
  800af8:	c3                   	ret    
	assert(r <= n);
  800af9:	68 a0 23 80 00       	push   $0x8023a0
  800afe:	68 74 23 80 00       	push   $0x802374
  800b03:	6a 7c                	push   $0x7c
  800b05:	68 89 23 80 00       	push   $0x802389
  800b0a:	e8 e5 09 00 00       	call   8014f4 <_panic>
	assert(r <= PGSIZE);
  800b0f:	68 94 23 80 00       	push   $0x802394
  800b14:	68 74 23 80 00       	push   $0x802374
  800b19:	6a 7d                	push   $0x7d
  800b1b:	68 89 23 80 00       	push   $0x802389
  800b20:	e8 cf 09 00 00       	call   8014f4 <_panic>

00800b25 <open>:
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	56                   	push   %esi
  800b29:	53                   	push   %ebx
  800b2a:	83 ec 1c             	sub    $0x1c,%esp
  800b2d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b30:	56                   	push   %esi
  800b31:	e8 3c 10 00 00       	call   801b72 <strlen>
  800b36:	83 c4 10             	add    $0x10,%esp
  800b39:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b3e:	7f 6c                	jg     800bac <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b40:	83 ec 0c             	sub    $0xc,%esp
  800b43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b46:	50                   	push   %eax
  800b47:	e8 6c f8 ff ff       	call   8003b8 <fd_alloc>
  800b4c:	89 c3                	mov    %eax,%ebx
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	85 c0                	test   %eax,%eax
  800b53:	78 3c                	js     800b91 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	56                   	push   %esi
  800b59:	68 00 50 80 00       	push   $0x805000
  800b5e:	e8 48 10 00 00       	call   801bab <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  800b73:	e8 ab fd ff ff       	call   800923 <fsipc>
  800b78:	89 c3                	mov    %eax,%ebx
  800b7a:	83 c4 10             	add    $0x10,%esp
  800b7d:	85 c0                	test   %eax,%eax
  800b7f:	78 19                	js     800b9a <open+0x75>
	return fd2num(fd);
  800b81:	83 ec 0c             	sub    $0xc,%esp
  800b84:	ff 75 f4             	pushl  -0xc(%ebp)
  800b87:	e8 05 f8 ff ff       	call   800391 <fd2num>
  800b8c:	89 c3                	mov    %eax,%ebx
  800b8e:	83 c4 10             	add    $0x10,%esp
}
  800b91:	89 d8                	mov    %ebx,%eax
  800b93:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b96:	5b                   	pop    %ebx
  800b97:	5e                   	pop    %esi
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    
		fd_close(fd, 0);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	6a 00                	push   $0x0
  800b9f:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba2:	e8 0e f9 ff ff       	call   8004b5 <fd_close>
		return r;
  800ba7:	83 c4 10             	add    $0x10,%esp
  800baa:	eb e5                	jmp    800b91 <open+0x6c>
		return -E_BAD_PATH;
  800bac:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bb1:	eb de                	jmp    800b91 <open+0x6c>

00800bb3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbe:	b8 08 00 00 00       	mov    $0x8,%eax
  800bc3:	e8 5b fd ff ff       	call   800923 <fsipc>
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	56                   	push   %esi
  800bce:	53                   	push   %ebx
  800bcf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bd2:	83 ec 0c             	sub    $0xc,%esp
  800bd5:	ff 75 08             	pushl  0x8(%ebp)
  800bd8:	e8 c4 f7 ff ff       	call   8003a1 <fd2data>
  800bdd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bdf:	83 c4 08             	add    $0x8,%esp
  800be2:	68 a7 23 80 00       	push   $0x8023a7
  800be7:	53                   	push   %ebx
  800be8:	e8 be 0f 00 00       	call   801bab <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bed:	8b 46 04             	mov    0x4(%esi),%eax
  800bf0:	2b 06                	sub    (%esi),%eax
  800bf2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bf8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bff:	00 00 00 
	stat->st_dev = &devpipe;
  800c02:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c09:	30 80 00 
	return 0;
}
  800c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c14:	5b                   	pop    %ebx
  800c15:	5e                   	pop    %esi
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	53                   	push   %ebx
  800c1c:	83 ec 0c             	sub    $0xc,%esp
  800c1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c22:	53                   	push   %ebx
  800c23:	6a 00                	push   $0x0
  800c25:	e8 dc f5 ff ff       	call   800206 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c2a:	89 1c 24             	mov    %ebx,(%esp)
  800c2d:	e8 6f f7 ff ff       	call   8003a1 <fd2data>
  800c32:	83 c4 08             	add    $0x8,%esp
  800c35:	50                   	push   %eax
  800c36:	6a 00                	push   $0x0
  800c38:	e8 c9 f5 ff ff       	call   800206 <sys_page_unmap>
}
  800c3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <_pipeisclosed>:
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	57                   	push   %edi
  800c46:	56                   	push   %esi
  800c47:	53                   	push   %ebx
  800c48:	83 ec 1c             	sub    $0x1c,%esp
  800c4b:	89 c7                	mov    %eax,%edi
  800c4d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c4f:	a1 08 40 80 00       	mov    0x804008,%eax
  800c54:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c57:	83 ec 0c             	sub    $0xc,%esp
  800c5a:	57                   	push   %edi
  800c5b:	e8 99 13 00 00       	call   801ff9 <pageref>
  800c60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c63:	89 34 24             	mov    %esi,(%esp)
  800c66:	e8 8e 13 00 00       	call   801ff9 <pageref>
		nn = thisenv->env_runs;
  800c6b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c71:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c74:	83 c4 10             	add    $0x10,%esp
  800c77:	39 cb                	cmp    %ecx,%ebx
  800c79:	74 1b                	je     800c96 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c7b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c7e:	75 cf                	jne    800c4f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c80:	8b 42 58             	mov    0x58(%edx),%eax
  800c83:	6a 01                	push   $0x1
  800c85:	50                   	push   %eax
  800c86:	53                   	push   %ebx
  800c87:	68 ae 23 80 00       	push   $0x8023ae
  800c8c:	e8 3e 09 00 00       	call   8015cf <cprintf>
  800c91:	83 c4 10             	add    $0x10,%esp
  800c94:	eb b9                	jmp    800c4f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c96:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c99:	0f 94 c0             	sete   %al
  800c9c:	0f b6 c0             	movzbl %al,%eax
}
  800c9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5f                   	pop    %edi
  800ca5:	5d                   	pop    %ebp
  800ca6:	c3                   	ret    

00800ca7 <devpipe_write>:
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	57                   	push   %edi
  800cab:	56                   	push   %esi
  800cac:	53                   	push   %ebx
  800cad:	83 ec 28             	sub    $0x28,%esp
  800cb0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800cb3:	56                   	push   %esi
  800cb4:	e8 e8 f6 ff ff       	call   8003a1 <fd2data>
  800cb9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cbb:	83 c4 10             	add    $0x10,%esp
  800cbe:	bf 00 00 00 00       	mov    $0x0,%edi
  800cc3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800cc6:	74 4f                	je     800d17 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800cc8:	8b 43 04             	mov    0x4(%ebx),%eax
  800ccb:	8b 0b                	mov    (%ebx),%ecx
  800ccd:	8d 51 20             	lea    0x20(%ecx),%edx
  800cd0:	39 d0                	cmp    %edx,%eax
  800cd2:	72 14                	jb     800ce8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800cd4:	89 da                	mov    %ebx,%edx
  800cd6:	89 f0                	mov    %esi,%eax
  800cd8:	e8 65 ff ff ff       	call   800c42 <_pipeisclosed>
  800cdd:	85 c0                	test   %eax,%eax
  800cdf:	75 3b                	jne    800d1c <devpipe_write+0x75>
			sys_yield();
  800ce1:	e8 7c f4 ff ff       	call   800162 <sys_yield>
  800ce6:	eb e0                	jmp    800cc8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cef:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cf2:	89 c2                	mov    %eax,%edx
  800cf4:	c1 fa 1f             	sar    $0x1f,%edx
  800cf7:	89 d1                	mov    %edx,%ecx
  800cf9:	c1 e9 1b             	shr    $0x1b,%ecx
  800cfc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cff:	83 e2 1f             	and    $0x1f,%edx
  800d02:	29 ca                	sub    %ecx,%edx
  800d04:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d08:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d0c:	83 c0 01             	add    $0x1,%eax
  800d0f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d12:	83 c7 01             	add    $0x1,%edi
  800d15:	eb ac                	jmp    800cc3 <devpipe_write+0x1c>
	return i;
  800d17:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1a:	eb 05                	jmp    800d21 <devpipe_write+0x7a>
				return 0;
  800d1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <devpipe_read>:
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
  800d2f:	83 ec 18             	sub    $0x18,%esp
  800d32:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d35:	57                   	push   %edi
  800d36:	e8 66 f6 ff ff       	call   8003a1 <fd2data>
  800d3b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d3d:	83 c4 10             	add    $0x10,%esp
  800d40:	be 00 00 00 00       	mov    $0x0,%esi
  800d45:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d48:	75 14                	jne    800d5e <devpipe_read+0x35>
	return i;
  800d4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4d:	eb 02                	jmp    800d51 <devpipe_read+0x28>
				return i;
  800d4f:	89 f0                	mov    %esi,%eax
}
  800d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    
			sys_yield();
  800d59:	e8 04 f4 ff ff       	call   800162 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d5e:	8b 03                	mov    (%ebx),%eax
  800d60:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d63:	75 18                	jne    800d7d <devpipe_read+0x54>
			if (i > 0)
  800d65:	85 f6                	test   %esi,%esi
  800d67:	75 e6                	jne    800d4f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  800d69:	89 da                	mov    %ebx,%edx
  800d6b:	89 f8                	mov    %edi,%eax
  800d6d:	e8 d0 fe ff ff       	call   800c42 <_pipeisclosed>
  800d72:	85 c0                	test   %eax,%eax
  800d74:	74 e3                	je     800d59 <devpipe_read+0x30>
				return 0;
  800d76:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7b:	eb d4                	jmp    800d51 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d7d:	99                   	cltd   
  800d7e:	c1 ea 1b             	shr    $0x1b,%edx
  800d81:	01 d0                	add    %edx,%eax
  800d83:	83 e0 1f             	and    $0x1f,%eax
  800d86:	29 d0                	sub    %edx,%eax
  800d88:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d90:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d93:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d96:	83 c6 01             	add    $0x1,%esi
  800d99:	eb aa                	jmp    800d45 <devpipe_read+0x1c>

00800d9b <pipe>:
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
  800da0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800da3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800da6:	50                   	push   %eax
  800da7:	e8 0c f6 ff ff       	call   8003b8 <fd_alloc>
  800dac:	89 c3                	mov    %eax,%ebx
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	85 c0                	test   %eax,%eax
  800db3:	0f 88 23 01 00 00    	js     800edc <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800db9:	83 ec 04             	sub    $0x4,%esp
  800dbc:	68 07 04 00 00       	push   $0x407
  800dc1:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc4:	6a 00                	push   $0x0
  800dc6:	e8 b6 f3 ff ff       	call   800181 <sys_page_alloc>
  800dcb:	89 c3                	mov    %eax,%ebx
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	0f 88 04 01 00 00    	js     800edc <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  800dd8:	83 ec 0c             	sub    $0xc,%esp
  800ddb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dde:	50                   	push   %eax
  800ddf:	e8 d4 f5 ff ff       	call   8003b8 <fd_alloc>
  800de4:	89 c3                	mov    %eax,%ebx
  800de6:	83 c4 10             	add    $0x10,%esp
  800de9:	85 c0                	test   %eax,%eax
  800deb:	0f 88 db 00 00 00    	js     800ecc <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800df1:	83 ec 04             	sub    $0x4,%esp
  800df4:	68 07 04 00 00       	push   $0x407
  800df9:	ff 75 f0             	pushl  -0x10(%ebp)
  800dfc:	6a 00                	push   $0x0
  800dfe:	e8 7e f3 ff ff       	call   800181 <sys_page_alloc>
  800e03:	89 c3                	mov    %eax,%ebx
  800e05:	83 c4 10             	add    $0x10,%esp
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	0f 88 bc 00 00 00    	js     800ecc <pipe+0x131>
	va = fd2data(fd0);
  800e10:	83 ec 0c             	sub    $0xc,%esp
  800e13:	ff 75 f4             	pushl  -0xc(%ebp)
  800e16:	e8 86 f5 ff ff       	call   8003a1 <fd2data>
  800e1b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e1d:	83 c4 0c             	add    $0xc,%esp
  800e20:	68 07 04 00 00       	push   $0x407
  800e25:	50                   	push   %eax
  800e26:	6a 00                	push   $0x0
  800e28:	e8 54 f3 ff ff       	call   800181 <sys_page_alloc>
  800e2d:	89 c3                	mov    %eax,%ebx
  800e2f:	83 c4 10             	add    $0x10,%esp
  800e32:	85 c0                	test   %eax,%eax
  800e34:	0f 88 82 00 00 00    	js     800ebc <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e3a:	83 ec 0c             	sub    $0xc,%esp
  800e3d:	ff 75 f0             	pushl  -0x10(%ebp)
  800e40:	e8 5c f5 ff ff       	call   8003a1 <fd2data>
  800e45:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e4c:	50                   	push   %eax
  800e4d:	6a 00                	push   $0x0
  800e4f:	56                   	push   %esi
  800e50:	6a 00                	push   $0x0
  800e52:	e8 6d f3 ff ff       	call   8001c4 <sys_page_map>
  800e57:	89 c3                	mov    %eax,%ebx
  800e59:	83 c4 20             	add    $0x20,%esp
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	78 4e                	js     800eae <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  800e60:	a1 20 30 80 00       	mov    0x803020,%eax
  800e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e68:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e77:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e83:	83 ec 0c             	sub    $0xc,%esp
  800e86:	ff 75 f4             	pushl  -0xc(%ebp)
  800e89:	e8 03 f5 ff ff       	call   800391 <fd2num>
  800e8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e91:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e93:	83 c4 04             	add    $0x4,%esp
  800e96:	ff 75 f0             	pushl  -0x10(%ebp)
  800e99:	e8 f3 f4 ff ff       	call   800391 <fd2num>
  800e9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800ea4:	83 c4 10             	add    $0x10,%esp
  800ea7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eac:	eb 2e                	jmp    800edc <pipe+0x141>
	sys_page_unmap(0, va);
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	56                   	push   %esi
  800eb2:	6a 00                	push   $0x0
  800eb4:	e8 4d f3 ff ff       	call   800206 <sys_page_unmap>
  800eb9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 f0             	pushl  -0x10(%ebp)
  800ec2:	6a 00                	push   $0x0
  800ec4:	e8 3d f3 ff ff       	call   800206 <sys_page_unmap>
  800ec9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800ecc:	83 ec 08             	sub    $0x8,%esp
  800ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed2:	6a 00                	push   $0x0
  800ed4:	e8 2d f3 ff ff       	call   800206 <sys_page_unmap>
  800ed9:	83 c4 10             	add    $0x10,%esp
}
  800edc:	89 d8                	mov    %ebx,%eax
  800ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    

00800ee5 <pipeisclosed>:
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800eeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800eee:	50                   	push   %eax
  800eef:	ff 75 08             	pushl  0x8(%ebp)
  800ef2:	e8 13 f5 ff ff       	call   80040a <fd_lookup>
  800ef7:	83 c4 10             	add    $0x10,%esp
  800efa:	85 c0                	test   %eax,%eax
  800efc:	78 18                	js     800f16 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800efe:	83 ec 0c             	sub    $0xc,%esp
  800f01:	ff 75 f4             	pushl  -0xc(%ebp)
  800f04:	e8 98 f4 ff ff       	call   8003a1 <fd2data>
	return _pipeisclosed(fd, p);
  800f09:	89 c2                	mov    %eax,%edx
  800f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f0e:	e8 2f fd ff ff       	call   800c42 <_pipeisclosed>
  800f13:	83 c4 10             	add    $0x10,%esp
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800f1e:	68 c6 23 80 00       	push   $0x8023c6
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	e8 80 0c 00 00       	call   801bab <strcpy>
	return 0;
}
  800f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <devsock_close>:
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	53                   	push   %ebx
  800f36:	83 ec 10             	sub    $0x10,%esp
  800f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f3c:	53                   	push   %ebx
  800f3d:	e8 b7 10 00 00       	call   801ff9 <pageref>
  800f42:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f45:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f4a:	83 f8 01             	cmp    $0x1,%eax
  800f4d:	74 07                	je     800f56 <devsock_close+0x24>
}
  800f4f:	89 d0                	mov    %edx,%eax
  800f51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f54:	c9                   	leave  
  800f55:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f56:	83 ec 0c             	sub    $0xc,%esp
  800f59:	ff 73 0c             	pushl  0xc(%ebx)
  800f5c:	e8 b9 02 00 00       	call   80121a <nsipc_close>
  800f61:	89 c2                	mov    %eax,%edx
  800f63:	83 c4 10             	add    $0x10,%esp
  800f66:	eb e7                	jmp    800f4f <devsock_close+0x1d>

00800f68 <devsock_write>:
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f6e:	6a 00                	push   $0x0
  800f70:	ff 75 10             	pushl  0x10(%ebp)
  800f73:	ff 75 0c             	pushl  0xc(%ebp)
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	ff 70 0c             	pushl  0xc(%eax)
  800f7c:	e8 76 03 00 00       	call   8012f7 <nsipc_send>
}
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    

00800f83 <devsock_read>:
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f89:	6a 00                	push   $0x0
  800f8b:	ff 75 10             	pushl  0x10(%ebp)
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	ff 70 0c             	pushl  0xc(%eax)
  800f97:	e8 ef 02 00 00       	call   80128b <nsipc_recv>
}
  800f9c:	c9                   	leave  
  800f9d:	c3                   	ret    

00800f9e <fd2sockid>:
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800fa4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800fa7:	52                   	push   %edx
  800fa8:	50                   	push   %eax
  800fa9:	e8 5c f4 ff ff       	call   80040a <fd_lookup>
  800fae:	83 c4 10             	add    $0x10,%esp
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	78 10                	js     800fc5 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb8:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800fbe:	39 08                	cmp    %ecx,(%eax)
  800fc0:	75 05                	jne    800fc7 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800fc2:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800fc5:	c9                   	leave  
  800fc6:	c3                   	ret    
		return -E_NOT_SUPP;
  800fc7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800fcc:	eb f7                	jmp    800fc5 <fd2sockid+0x27>

00800fce <alloc_sockfd>:
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	56                   	push   %esi
  800fd2:	53                   	push   %ebx
  800fd3:	83 ec 1c             	sub    $0x1c,%esp
  800fd6:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fdb:	50                   	push   %eax
  800fdc:	e8 d7 f3 ff ff       	call   8003b8 <fd_alloc>
  800fe1:	89 c3                	mov    %eax,%ebx
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	78 43                	js     80102d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fea:	83 ec 04             	sub    $0x4,%esp
  800fed:	68 07 04 00 00       	push   $0x407
  800ff2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff5:	6a 00                	push   $0x0
  800ff7:	e8 85 f1 ff ff       	call   800181 <sys_page_alloc>
  800ffc:	89 c3                	mov    %eax,%ebx
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	85 c0                	test   %eax,%eax
  801003:	78 28                	js     80102d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801008:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80100e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801013:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80101a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80101d:	83 ec 0c             	sub    $0xc,%esp
  801020:	50                   	push   %eax
  801021:	e8 6b f3 ff ff       	call   800391 <fd2num>
  801026:	89 c3                	mov    %eax,%ebx
  801028:	83 c4 10             	add    $0x10,%esp
  80102b:	eb 0c                	jmp    801039 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80102d:	83 ec 0c             	sub    $0xc,%esp
  801030:	56                   	push   %esi
  801031:	e8 e4 01 00 00       	call   80121a <nsipc_close>
		return r;
  801036:	83 c4 10             	add    $0x10,%esp
}
  801039:	89 d8                	mov    %ebx,%eax
  80103b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5d                   	pop    %ebp
  801041:	c3                   	ret    

00801042 <accept>:
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	e8 4e ff ff ff       	call   800f9e <fd2sockid>
  801050:	85 c0                	test   %eax,%eax
  801052:	78 1b                	js     80106f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801054:	83 ec 04             	sub    $0x4,%esp
  801057:	ff 75 10             	pushl  0x10(%ebp)
  80105a:	ff 75 0c             	pushl  0xc(%ebp)
  80105d:	50                   	push   %eax
  80105e:	e8 0e 01 00 00       	call   801171 <nsipc_accept>
  801063:	83 c4 10             	add    $0x10,%esp
  801066:	85 c0                	test   %eax,%eax
  801068:	78 05                	js     80106f <accept+0x2d>
	return alloc_sockfd(r);
  80106a:	e8 5f ff ff ff       	call   800fce <alloc_sockfd>
}
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <bind>:
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	e8 1f ff ff ff       	call   800f9e <fd2sockid>
  80107f:	85 c0                	test   %eax,%eax
  801081:	78 12                	js     801095 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801083:	83 ec 04             	sub    $0x4,%esp
  801086:	ff 75 10             	pushl  0x10(%ebp)
  801089:	ff 75 0c             	pushl  0xc(%ebp)
  80108c:	50                   	push   %eax
  80108d:	e8 31 01 00 00       	call   8011c3 <nsipc_bind>
  801092:	83 c4 10             	add    $0x10,%esp
}
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <shutdown>:
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	e8 f9 fe ff ff       	call   800f9e <fd2sockid>
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	78 0f                	js     8010b8 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 0c             	pushl  0xc(%ebp)
  8010af:	50                   	push   %eax
  8010b0:	e8 43 01 00 00       	call   8011f8 <nsipc_shutdown>
  8010b5:	83 c4 10             	add    $0x10,%esp
}
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <connect>:
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	e8 d6 fe ff ff       	call   800f9e <fd2sockid>
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	78 12                	js     8010de <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8010cc:	83 ec 04             	sub    $0x4,%esp
  8010cf:	ff 75 10             	pushl  0x10(%ebp)
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	50                   	push   %eax
  8010d6:	e8 59 01 00 00       	call   801234 <nsipc_connect>
  8010db:	83 c4 10             	add    $0x10,%esp
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <listen>:
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	e8 b0 fe ff ff       	call   800f9e <fd2sockid>
  8010ee:	85 c0                	test   %eax,%eax
  8010f0:	78 0f                	js     801101 <listen+0x21>
	return nsipc_listen(r, backlog);
  8010f2:	83 ec 08             	sub    $0x8,%esp
  8010f5:	ff 75 0c             	pushl  0xc(%ebp)
  8010f8:	50                   	push   %eax
  8010f9:	e8 6b 01 00 00       	call   801269 <nsipc_listen>
  8010fe:	83 c4 10             	add    $0x10,%esp
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <socket>:

int
socket(int domain, int type, int protocol)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801109:	ff 75 10             	pushl  0x10(%ebp)
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	ff 75 08             	pushl  0x8(%ebp)
  801112:	e8 3e 02 00 00       	call   801355 <nsipc_socket>
  801117:	83 c4 10             	add    $0x10,%esp
  80111a:	85 c0                	test   %eax,%eax
  80111c:	78 05                	js     801123 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80111e:	e8 ab fe ff ff       	call   800fce <alloc_sockfd>
}
  801123:	c9                   	leave  
  801124:	c3                   	ret    

00801125 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	53                   	push   %ebx
  801129:	83 ec 04             	sub    $0x4,%esp
  80112c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80112e:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801135:	74 26                	je     80115d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801137:	6a 07                	push   $0x7
  801139:	68 00 60 80 00       	push   $0x806000
  80113e:	53                   	push   %ebx
  80113f:	ff 35 04 40 80 00    	pushl  0x804004
  801145:	e8 0a 0e 00 00       	call   801f54 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80114a:	83 c4 0c             	add    $0xc,%esp
  80114d:	6a 00                	push   $0x0
  80114f:	6a 00                	push   $0x0
  801151:	6a 00                	push   $0x0
  801153:	e8 89 0d 00 00       	call   801ee1 <ipc_recv>
}
  801158:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	6a 02                	push   $0x2
  801162:	e8 59 0e 00 00       	call   801fc0 <ipc_find_env>
  801167:	a3 04 40 80 00       	mov    %eax,0x804004
  80116c:	83 c4 10             	add    $0x10,%esp
  80116f:	eb c6                	jmp    801137 <nsipc+0x12>

00801171 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	56                   	push   %esi
  801175:	53                   	push   %ebx
  801176:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801181:	8b 06                	mov    (%esi),%eax
  801183:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801188:	b8 01 00 00 00       	mov    $0x1,%eax
  80118d:	e8 93 ff ff ff       	call   801125 <nsipc>
  801192:	89 c3                	mov    %eax,%ebx
  801194:	85 c0                	test   %eax,%eax
  801196:	79 09                	jns    8011a1 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801198:	89 d8                	mov    %ebx,%eax
  80119a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80119d:	5b                   	pop    %ebx
  80119e:	5e                   	pop    %esi
  80119f:	5d                   	pop    %ebp
  8011a0:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8011a1:	83 ec 04             	sub    $0x4,%esp
  8011a4:	ff 35 10 60 80 00    	pushl  0x806010
  8011aa:	68 00 60 80 00       	push   $0x806000
  8011af:	ff 75 0c             	pushl  0xc(%ebp)
  8011b2:	e8 82 0b 00 00       	call   801d39 <memmove>
		*addrlen = ret->ret_addrlen;
  8011b7:	a1 10 60 80 00       	mov    0x806010,%eax
  8011bc:	89 06                	mov    %eax,(%esi)
  8011be:	83 c4 10             	add    $0x10,%esp
	return r;
  8011c1:	eb d5                	jmp    801198 <nsipc_accept+0x27>

008011c3 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	53                   	push   %ebx
  8011c7:	83 ec 08             	sub    $0x8,%esp
  8011ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011d5:	53                   	push   %ebx
  8011d6:	ff 75 0c             	pushl  0xc(%ebp)
  8011d9:	68 04 60 80 00       	push   $0x806004
  8011de:	e8 56 0b 00 00       	call   801d39 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011e3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011e9:	b8 02 00 00 00       	mov    $0x2,%eax
  8011ee:	e8 32 ff ff ff       	call   801125 <nsipc>
}
  8011f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f6:	c9                   	leave  
  8011f7:	c3                   	ret    

008011f8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801206:	8b 45 0c             	mov    0xc(%ebp),%eax
  801209:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80120e:	b8 03 00 00 00       	mov    $0x3,%eax
  801213:	e8 0d ff ff ff       	call   801125 <nsipc>
}
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <nsipc_close>:

int
nsipc_close(int s)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801228:	b8 04 00 00 00       	mov    $0x4,%eax
  80122d:	e8 f3 fe ff ff       	call   801125 <nsipc>
}
  801232:	c9                   	leave  
  801233:	c3                   	ret    

00801234 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
  801237:	53                   	push   %ebx
  801238:	83 ec 08             	sub    $0x8,%esp
  80123b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801246:	53                   	push   %ebx
  801247:	ff 75 0c             	pushl  0xc(%ebp)
  80124a:	68 04 60 80 00       	push   $0x806004
  80124f:	e8 e5 0a 00 00       	call   801d39 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801254:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80125a:	b8 05 00 00 00       	mov    $0x5,%eax
  80125f:	e8 c1 fe ff ff       	call   801125 <nsipc>
}
  801264:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801267:	c9                   	leave  
  801268:	c3                   	ret    

00801269 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80127f:	b8 06 00 00 00       	mov    $0x6,%eax
  801284:	e8 9c fe ff ff       	call   801125 <nsipc>
}
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	56                   	push   %esi
  80128f:	53                   	push   %ebx
  801290:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80129b:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8012a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a4:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8012a9:	b8 07 00 00 00       	mov    $0x7,%eax
  8012ae:	e8 72 fe ff ff       	call   801125 <nsipc>
  8012b3:	89 c3                	mov    %eax,%ebx
  8012b5:	85 c0                	test   %eax,%eax
  8012b7:	78 1f                	js     8012d8 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8012b9:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8012be:	7f 21                	jg     8012e1 <nsipc_recv+0x56>
  8012c0:	39 c6                	cmp    %eax,%esi
  8012c2:	7c 1d                	jl     8012e1 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8012c4:	83 ec 04             	sub    $0x4,%esp
  8012c7:	50                   	push   %eax
  8012c8:	68 00 60 80 00       	push   $0x806000
  8012cd:	ff 75 0c             	pushl  0xc(%ebp)
  8012d0:	e8 64 0a 00 00       	call   801d39 <memmove>
  8012d5:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012d8:	89 d8                	mov    %ebx,%eax
  8012da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012dd:	5b                   	pop    %ebx
  8012de:	5e                   	pop    %esi
  8012df:	5d                   	pop    %ebp
  8012e0:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012e1:	68 d2 23 80 00       	push   $0x8023d2
  8012e6:	68 74 23 80 00       	push   $0x802374
  8012eb:	6a 62                	push   $0x62
  8012ed:	68 e7 23 80 00       	push   $0x8023e7
  8012f2:	e8 fd 01 00 00       	call   8014f4 <_panic>

008012f7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	53                   	push   %ebx
  8012fb:	83 ec 04             	sub    $0x4,%esp
  8012fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801309:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80130f:	7f 2e                	jg     80133f <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801311:	83 ec 04             	sub    $0x4,%esp
  801314:	53                   	push   %ebx
  801315:	ff 75 0c             	pushl  0xc(%ebp)
  801318:	68 0c 60 80 00       	push   $0x80600c
  80131d:	e8 17 0a 00 00       	call   801d39 <memmove>
	nsipcbuf.send.req_size = size;
  801322:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801328:	8b 45 14             	mov    0x14(%ebp),%eax
  80132b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801330:	b8 08 00 00 00       	mov    $0x8,%eax
  801335:	e8 eb fd ff ff       	call   801125 <nsipc>
}
  80133a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    
	assert(size < 1600);
  80133f:	68 f3 23 80 00       	push   $0x8023f3
  801344:	68 74 23 80 00       	push   $0x802374
  801349:	6a 6d                	push   $0x6d
  80134b:	68 e7 23 80 00       	push   $0x8023e7
  801350:	e8 9f 01 00 00       	call   8014f4 <_panic>

00801355 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80136b:	8b 45 10             	mov    0x10(%ebp),%eax
  80136e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801373:	b8 09 00 00 00       	mov    $0x9,%eax
  801378:	e8 a8 fd ff ff       	call   801125 <nsipc>
}
  80137d:	c9                   	leave  
  80137e:	c3                   	ret    

0080137f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80137f:	b8 00 00 00 00       	mov    $0x0,%eax
  801384:	c3                   	ret    

00801385 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80138b:	68 ff 23 80 00       	push   $0x8023ff
  801390:	ff 75 0c             	pushl  0xc(%ebp)
  801393:	e8 13 08 00 00       	call   801bab <strcpy>
	return 0;
}
  801398:	b8 00 00 00 00       	mov    $0x0,%eax
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <devcons_write>:
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	57                   	push   %edi
  8013a3:	56                   	push   %esi
  8013a4:	53                   	push   %ebx
  8013a5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8013ab:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8013b0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8013b6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013b9:	73 31                	jae    8013ec <devcons_write+0x4d>
		m = n - tot;
  8013bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013be:	29 f3                	sub    %esi,%ebx
  8013c0:	83 fb 7f             	cmp    $0x7f,%ebx
  8013c3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8013c8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013cb:	83 ec 04             	sub    $0x4,%esp
  8013ce:	53                   	push   %ebx
  8013cf:	89 f0                	mov    %esi,%eax
  8013d1:	03 45 0c             	add    0xc(%ebp),%eax
  8013d4:	50                   	push   %eax
  8013d5:	57                   	push   %edi
  8013d6:	e8 5e 09 00 00       	call   801d39 <memmove>
		sys_cputs(buf, m);
  8013db:	83 c4 08             	add    $0x8,%esp
  8013de:	53                   	push   %ebx
  8013df:	57                   	push   %edi
  8013e0:	e8 e0 ec ff ff       	call   8000c5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013e5:	01 de                	add    %ebx,%esi
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	eb ca                	jmp    8013b6 <devcons_write+0x17>
}
  8013ec:	89 f0                	mov    %esi,%eax
  8013ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013f1:	5b                   	pop    %ebx
  8013f2:	5e                   	pop    %esi
  8013f3:	5f                   	pop    %edi
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    

008013f6 <devcons_read>:
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	83 ec 08             	sub    $0x8,%esp
  8013fc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801401:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801405:	74 21                	je     801428 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801407:	e8 d7 ec ff ff       	call   8000e3 <sys_cgetc>
  80140c:	85 c0                	test   %eax,%eax
  80140e:	75 07                	jne    801417 <devcons_read+0x21>
		sys_yield();
  801410:	e8 4d ed ff ff       	call   800162 <sys_yield>
  801415:	eb f0                	jmp    801407 <devcons_read+0x11>
	if (c < 0)
  801417:	78 0f                	js     801428 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801419:	83 f8 04             	cmp    $0x4,%eax
  80141c:	74 0c                	je     80142a <devcons_read+0x34>
	*(char*)vbuf = c;
  80141e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801421:	88 02                	mov    %al,(%edx)
	return 1;
  801423:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801428:	c9                   	leave  
  801429:	c3                   	ret    
		return 0;
  80142a:	b8 00 00 00 00       	mov    $0x0,%eax
  80142f:	eb f7                	jmp    801428 <devcons_read+0x32>

00801431 <cputchar>:
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80143d:	6a 01                	push   $0x1
  80143f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801442:	50                   	push   %eax
  801443:	e8 7d ec ff ff       	call   8000c5 <sys_cputs>
}
  801448:	83 c4 10             	add    $0x10,%esp
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <getchar>:
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801453:	6a 01                	push   $0x1
  801455:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801458:	50                   	push   %eax
  801459:	6a 00                	push   $0x0
  80145b:	e8 1a f2 ff ff       	call   80067a <read>
	if (r < 0)
  801460:	83 c4 10             	add    $0x10,%esp
  801463:	85 c0                	test   %eax,%eax
  801465:	78 06                	js     80146d <getchar+0x20>
	if (r < 1)
  801467:	74 06                	je     80146f <getchar+0x22>
	return c;
  801469:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    
		return -E_EOF;
  80146f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801474:	eb f7                	jmp    80146d <getchar+0x20>

00801476 <iscons>:
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80147c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147f:	50                   	push   %eax
  801480:	ff 75 08             	pushl  0x8(%ebp)
  801483:	e8 82 ef ff ff       	call   80040a <fd_lookup>
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	85 c0                	test   %eax,%eax
  80148d:	78 11                	js     8014a0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80148f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801492:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801498:	39 10                	cmp    %edx,(%eax)
  80149a:	0f 94 c0             	sete   %al
  80149d:	0f b6 c0             	movzbl %al,%eax
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <opencons>:
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8014a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ab:	50                   	push   %eax
  8014ac:	e8 07 ef ff ff       	call   8003b8 <fd_alloc>
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	78 3a                	js     8014f2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8014b8:	83 ec 04             	sub    $0x4,%esp
  8014bb:	68 07 04 00 00       	push   $0x407
  8014c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014c3:	6a 00                	push   $0x0
  8014c5:	e8 b7 ec ff ff       	call   800181 <sys_page_alloc>
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	78 21                	js     8014f2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014da:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014df:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014e6:	83 ec 0c             	sub    $0xc,%esp
  8014e9:	50                   	push   %eax
  8014ea:	e8 a2 ee ff ff       	call   800391 <fd2num>
  8014ef:	83 c4 10             	add    $0x10,%esp
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	56                   	push   %esi
  8014f8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014f9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014fc:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801502:	e8 3c ec ff ff       	call   800143 <sys_getenvid>
  801507:	83 ec 0c             	sub    $0xc,%esp
  80150a:	ff 75 0c             	pushl  0xc(%ebp)
  80150d:	ff 75 08             	pushl  0x8(%ebp)
  801510:	56                   	push   %esi
  801511:	50                   	push   %eax
  801512:	68 0c 24 80 00       	push   $0x80240c
  801517:	e8 b3 00 00 00       	call   8015cf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80151c:	83 c4 18             	add    $0x18,%esp
  80151f:	53                   	push   %ebx
  801520:	ff 75 10             	pushl  0x10(%ebp)
  801523:	e8 56 00 00 00       	call   80157e <vcprintf>
	cprintf("\n");
  801528:	c7 04 24 bf 23 80 00 	movl   $0x8023bf,(%esp)
  80152f:	e8 9b 00 00 00       	call   8015cf <cprintf>
  801534:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801537:	cc                   	int3   
  801538:	eb fd                	jmp    801537 <_panic+0x43>

0080153a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	53                   	push   %ebx
  80153e:	83 ec 04             	sub    $0x4,%esp
  801541:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801544:	8b 13                	mov    (%ebx),%edx
  801546:	8d 42 01             	lea    0x1(%edx),%eax
  801549:	89 03                	mov    %eax,(%ebx)
  80154b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801552:	3d ff 00 00 00       	cmp    $0xff,%eax
  801557:	74 09                	je     801562 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801559:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80155d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801560:	c9                   	leave  
  801561:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801562:	83 ec 08             	sub    $0x8,%esp
  801565:	68 ff 00 00 00       	push   $0xff
  80156a:	8d 43 08             	lea    0x8(%ebx),%eax
  80156d:	50                   	push   %eax
  80156e:	e8 52 eb ff ff       	call   8000c5 <sys_cputs>
		b->idx = 0;
  801573:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	eb db                	jmp    801559 <putch+0x1f>

0080157e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801587:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80158e:	00 00 00 
	b.cnt = 0;
  801591:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801598:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80159b:	ff 75 0c             	pushl  0xc(%ebp)
  80159e:	ff 75 08             	pushl  0x8(%ebp)
  8015a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8015a7:	50                   	push   %eax
  8015a8:	68 3a 15 80 00       	push   $0x80153a
  8015ad:	e8 19 01 00 00       	call   8016cb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8015b2:	83 c4 08             	add    $0x8,%esp
  8015b5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8015bb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8015c1:	50                   	push   %eax
  8015c2:	e8 fe ea ff ff       	call   8000c5 <sys_cputs>

	return b.cnt;
}
  8015c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015d5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015d8:	50                   	push   %eax
  8015d9:	ff 75 08             	pushl  0x8(%ebp)
  8015dc:	e8 9d ff ff ff       	call   80157e <vcprintf>
	va_end(ap);

	return cnt;
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	57                   	push   %edi
  8015e7:	56                   	push   %esi
  8015e8:	53                   	push   %ebx
  8015e9:	83 ec 1c             	sub    $0x1c,%esp
  8015ec:	89 c7                	mov    %eax,%edi
  8015ee:	89 d6                	mov    %edx,%esi
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801604:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801607:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80160a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80160d:	89 d0                	mov    %edx,%eax
  80160f:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  801612:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801615:	73 15                	jae    80162c <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801617:	83 eb 01             	sub    $0x1,%ebx
  80161a:	85 db                	test   %ebx,%ebx
  80161c:	7e 43                	jle    801661 <printnum+0x7e>
			putch(padc, putdat);
  80161e:	83 ec 08             	sub    $0x8,%esp
  801621:	56                   	push   %esi
  801622:	ff 75 18             	pushl  0x18(%ebp)
  801625:	ff d7                	call   *%edi
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	eb eb                	jmp    801617 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80162c:	83 ec 0c             	sub    $0xc,%esp
  80162f:	ff 75 18             	pushl  0x18(%ebp)
  801632:	8b 45 14             	mov    0x14(%ebp),%eax
  801635:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801638:	53                   	push   %ebx
  801639:	ff 75 10             	pushl  0x10(%ebp)
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801642:	ff 75 e0             	pushl  -0x20(%ebp)
  801645:	ff 75 dc             	pushl  -0x24(%ebp)
  801648:	ff 75 d8             	pushl  -0x28(%ebp)
  80164b:	e8 f0 09 00 00       	call   802040 <__udivdi3>
  801650:	83 c4 18             	add    $0x18,%esp
  801653:	52                   	push   %edx
  801654:	50                   	push   %eax
  801655:	89 f2                	mov    %esi,%edx
  801657:	89 f8                	mov    %edi,%eax
  801659:	e8 85 ff ff ff       	call   8015e3 <printnum>
  80165e:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801661:	83 ec 08             	sub    $0x8,%esp
  801664:	56                   	push   %esi
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	ff 75 e4             	pushl  -0x1c(%ebp)
  80166b:	ff 75 e0             	pushl  -0x20(%ebp)
  80166e:	ff 75 dc             	pushl  -0x24(%ebp)
  801671:	ff 75 d8             	pushl  -0x28(%ebp)
  801674:	e8 d7 0a 00 00       	call   802150 <__umoddi3>
  801679:	83 c4 14             	add    $0x14,%esp
  80167c:	0f be 80 2f 24 80 00 	movsbl 0x80242f(%eax),%eax
  801683:	50                   	push   %eax
  801684:	ff d7                	call   *%edi
}
  801686:	83 c4 10             	add    $0x10,%esp
  801689:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80168c:	5b                   	pop    %ebx
  80168d:	5e                   	pop    %esi
  80168e:	5f                   	pop    %edi
  80168f:	5d                   	pop    %ebp
  801690:	c3                   	ret    

00801691 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801697:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80169b:	8b 10                	mov    (%eax),%edx
  80169d:	3b 50 04             	cmp    0x4(%eax),%edx
  8016a0:	73 0a                	jae    8016ac <sprintputch+0x1b>
		*b->buf++ = ch;
  8016a2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016a5:	89 08                	mov    %ecx,(%eax)
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	88 02                	mov    %al,(%edx)
}
  8016ac:	5d                   	pop    %ebp
  8016ad:	c3                   	ret    

008016ae <printfmt>:
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8016b4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8016b7:	50                   	push   %eax
  8016b8:	ff 75 10             	pushl  0x10(%ebp)
  8016bb:	ff 75 0c             	pushl  0xc(%ebp)
  8016be:	ff 75 08             	pushl  0x8(%ebp)
  8016c1:	e8 05 00 00 00       	call   8016cb <vprintfmt>
}
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <vprintfmt>:
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	57                   	push   %edi
  8016cf:	56                   	push   %esi
  8016d0:	53                   	push   %ebx
  8016d1:	83 ec 3c             	sub    $0x3c,%esp
  8016d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8016d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016da:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016dd:	eb 0a                	jmp    8016e9 <vprintfmt+0x1e>
			putch(ch, putdat);
  8016df:	83 ec 08             	sub    $0x8,%esp
  8016e2:	53                   	push   %ebx
  8016e3:	50                   	push   %eax
  8016e4:	ff d6                	call   *%esi
  8016e6:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016e9:	83 c7 01             	add    $0x1,%edi
  8016ec:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016f0:	83 f8 25             	cmp    $0x25,%eax
  8016f3:	74 0c                	je     801701 <vprintfmt+0x36>
			if (ch == '\0')
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	75 e6                	jne    8016df <vprintfmt+0x14>
}
  8016f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016fc:	5b                   	pop    %ebx
  8016fd:	5e                   	pop    %esi
  8016fe:	5f                   	pop    %edi
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    
		padc = ' ';
  801701:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801705:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80170c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801713:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80171a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80171f:	8d 47 01             	lea    0x1(%edi),%eax
  801722:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801725:	0f b6 17             	movzbl (%edi),%edx
  801728:	8d 42 dd             	lea    -0x23(%edx),%eax
  80172b:	3c 55                	cmp    $0x55,%al
  80172d:	0f 87 ba 03 00 00    	ja     801aed <vprintfmt+0x422>
  801733:	0f b6 c0             	movzbl %al,%eax
  801736:	ff 24 85 80 25 80 00 	jmp    *0x802580(,%eax,4)
  80173d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801740:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801744:	eb d9                	jmp    80171f <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801746:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801749:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80174d:	eb d0                	jmp    80171f <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80174f:	0f b6 d2             	movzbl %dl,%edx
  801752:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80175d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801760:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801764:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801767:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80176a:	83 f9 09             	cmp    $0x9,%ecx
  80176d:	77 55                	ja     8017c4 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80176f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801772:	eb e9                	jmp    80175d <vprintfmt+0x92>
			precision = va_arg(ap, int);
  801774:	8b 45 14             	mov    0x14(%ebp),%eax
  801777:	8b 00                	mov    (%eax),%eax
  801779:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80177c:	8b 45 14             	mov    0x14(%ebp),%eax
  80177f:	8d 40 04             	lea    0x4(%eax),%eax
  801782:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801785:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801788:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80178c:	79 91                	jns    80171f <vprintfmt+0x54>
				width = precision, precision = -1;
  80178e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801791:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801794:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80179b:	eb 82                	jmp    80171f <vprintfmt+0x54>
  80179d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a7:	0f 49 d0             	cmovns %eax,%edx
  8017aa:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8017ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8017b0:	e9 6a ff ff ff       	jmp    80171f <vprintfmt+0x54>
  8017b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8017b8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8017bf:	e9 5b ff ff ff       	jmp    80171f <vprintfmt+0x54>
  8017c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8017c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8017ca:	eb bc                	jmp    801788 <vprintfmt+0xbd>
			lflag++;
  8017cc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017d2:	e9 48 ff ff ff       	jmp    80171f <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8017d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017da:	8d 78 04             	lea    0x4(%eax),%edi
  8017dd:	83 ec 08             	sub    $0x8,%esp
  8017e0:	53                   	push   %ebx
  8017e1:	ff 30                	pushl  (%eax)
  8017e3:	ff d6                	call   *%esi
			break;
  8017e5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017e8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017eb:	e9 9c 02 00 00       	jmp    801a8c <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8017f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f3:	8d 78 04             	lea    0x4(%eax),%edi
  8017f6:	8b 00                	mov    (%eax),%eax
  8017f8:	99                   	cltd   
  8017f9:	31 d0                	xor    %edx,%eax
  8017fb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017fd:	83 f8 0f             	cmp    $0xf,%eax
  801800:	7f 23                	jg     801825 <vprintfmt+0x15a>
  801802:	8b 14 85 e0 26 80 00 	mov    0x8026e0(,%eax,4),%edx
  801809:	85 d2                	test   %edx,%edx
  80180b:	74 18                	je     801825 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  80180d:	52                   	push   %edx
  80180e:	68 86 23 80 00       	push   $0x802386
  801813:	53                   	push   %ebx
  801814:	56                   	push   %esi
  801815:	e8 94 fe ff ff       	call   8016ae <printfmt>
  80181a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80181d:	89 7d 14             	mov    %edi,0x14(%ebp)
  801820:	e9 67 02 00 00       	jmp    801a8c <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  801825:	50                   	push   %eax
  801826:	68 47 24 80 00       	push   $0x802447
  80182b:	53                   	push   %ebx
  80182c:	56                   	push   %esi
  80182d:	e8 7c fe ff ff       	call   8016ae <printfmt>
  801832:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801835:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801838:	e9 4f 02 00 00       	jmp    801a8c <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80183d:	8b 45 14             	mov    0x14(%ebp),%eax
  801840:	83 c0 04             	add    $0x4,%eax
  801843:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80184b:	85 d2                	test   %edx,%edx
  80184d:	b8 40 24 80 00       	mov    $0x802440,%eax
  801852:	0f 45 c2             	cmovne %edx,%eax
  801855:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801858:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80185c:	7e 06                	jle    801864 <vprintfmt+0x199>
  80185e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801862:	75 0d                	jne    801871 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801864:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801867:	89 c7                	mov    %eax,%edi
  801869:	03 45 e0             	add    -0x20(%ebp),%eax
  80186c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80186f:	eb 3f                	jmp    8018b0 <vprintfmt+0x1e5>
  801871:	83 ec 08             	sub    $0x8,%esp
  801874:	ff 75 d8             	pushl  -0x28(%ebp)
  801877:	50                   	push   %eax
  801878:	e8 0d 03 00 00       	call   801b8a <strnlen>
  80187d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801880:	29 c2                	sub    %eax,%edx
  801882:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80188a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80188e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801891:	85 ff                	test   %edi,%edi
  801893:	7e 58                	jle    8018ed <vprintfmt+0x222>
					putch(padc, putdat);
  801895:	83 ec 08             	sub    $0x8,%esp
  801898:	53                   	push   %ebx
  801899:	ff 75 e0             	pushl  -0x20(%ebp)
  80189c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80189e:	83 ef 01             	sub    $0x1,%edi
  8018a1:	83 c4 10             	add    $0x10,%esp
  8018a4:	eb eb                	jmp    801891 <vprintfmt+0x1c6>
					putch(ch, putdat);
  8018a6:	83 ec 08             	sub    $0x8,%esp
  8018a9:	53                   	push   %ebx
  8018aa:	52                   	push   %edx
  8018ab:	ff d6                	call   *%esi
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8018b3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018b5:	83 c7 01             	add    $0x1,%edi
  8018b8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8018bc:	0f be d0             	movsbl %al,%edx
  8018bf:	85 d2                	test   %edx,%edx
  8018c1:	74 45                	je     801908 <vprintfmt+0x23d>
  8018c3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018c7:	78 06                	js     8018cf <vprintfmt+0x204>
  8018c9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8018cd:	78 35                	js     801904 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8018cf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8018d3:	74 d1                	je     8018a6 <vprintfmt+0x1db>
  8018d5:	0f be c0             	movsbl %al,%eax
  8018d8:	83 e8 20             	sub    $0x20,%eax
  8018db:	83 f8 5e             	cmp    $0x5e,%eax
  8018de:	76 c6                	jbe    8018a6 <vprintfmt+0x1db>
					putch('?', putdat);
  8018e0:	83 ec 08             	sub    $0x8,%esp
  8018e3:	53                   	push   %ebx
  8018e4:	6a 3f                	push   $0x3f
  8018e6:	ff d6                	call   *%esi
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	eb c3                	jmp    8018b0 <vprintfmt+0x1e5>
  8018ed:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8018f0:	85 d2                	test   %edx,%edx
  8018f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f7:	0f 49 c2             	cmovns %edx,%eax
  8018fa:	29 c2                	sub    %eax,%edx
  8018fc:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8018ff:	e9 60 ff ff ff       	jmp    801864 <vprintfmt+0x199>
  801904:	89 cf                	mov    %ecx,%edi
  801906:	eb 02                	jmp    80190a <vprintfmt+0x23f>
  801908:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  80190a:	85 ff                	test   %edi,%edi
  80190c:	7e 10                	jle    80191e <vprintfmt+0x253>
				putch(' ', putdat);
  80190e:	83 ec 08             	sub    $0x8,%esp
  801911:	53                   	push   %ebx
  801912:	6a 20                	push   $0x20
  801914:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801916:	83 ef 01             	sub    $0x1,%edi
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	eb ec                	jmp    80190a <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  80191e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801921:	89 45 14             	mov    %eax,0x14(%ebp)
  801924:	e9 63 01 00 00       	jmp    801a8c <vprintfmt+0x3c1>
	if (lflag >= 2)
  801929:	83 f9 01             	cmp    $0x1,%ecx
  80192c:	7f 1b                	jg     801949 <vprintfmt+0x27e>
	else if (lflag)
  80192e:	85 c9                	test   %ecx,%ecx
  801930:	74 63                	je     801995 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  801932:	8b 45 14             	mov    0x14(%ebp),%eax
  801935:	8b 00                	mov    (%eax),%eax
  801937:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80193a:	99                   	cltd   
  80193b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80193e:	8b 45 14             	mov    0x14(%ebp),%eax
  801941:	8d 40 04             	lea    0x4(%eax),%eax
  801944:	89 45 14             	mov    %eax,0x14(%ebp)
  801947:	eb 17                	jmp    801960 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  801949:	8b 45 14             	mov    0x14(%ebp),%eax
  80194c:	8b 50 04             	mov    0x4(%eax),%edx
  80194f:	8b 00                	mov    (%eax),%eax
  801951:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801954:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801957:	8b 45 14             	mov    0x14(%ebp),%eax
  80195a:	8d 40 08             	lea    0x8(%eax),%eax
  80195d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801960:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801963:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801966:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80196b:	85 c9                	test   %ecx,%ecx
  80196d:	0f 89 ff 00 00 00    	jns    801a72 <vprintfmt+0x3a7>
				putch('-', putdat);
  801973:	83 ec 08             	sub    $0x8,%esp
  801976:	53                   	push   %ebx
  801977:	6a 2d                	push   $0x2d
  801979:	ff d6                	call   *%esi
				num = -(long long) num;
  80197b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80197e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801981:	f7 da                	neg    %edx
  801983:	83 d1 00             	adc    $0x0,%ecx
  801986:	f7 d9                	neg    %ecx
  801988:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80198b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801990:	e9 dd 00 00 00       	jmp    801a72 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  801995:	8b 45 14             	mov    0x14(%ebp),%eax
  801998:	8b 00                	mov    (%eax),%eax
  80199a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80199d:	99                   	cltd   
  80199e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a4:	8d 40 04             	lea    0x4(%eax),%eax
  8019a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8019aa:	eb b4                	jmp    801960 <vprintfmt+0x295>
	if (lflag >= 2)
  8019ac:	83 f9 01             	cmp    $0x1,%ecx
  8019af:	7f 1e                	jg     8019cf <vprintfmt+0x304>
	else if (lflag)
  8019b1:	85 c9                	test   %ecx,%ecx
  8019b3:	74 32                	je     8019e7 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8019b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b8:	8b 10                	mov    (%eax),%edx
  8019ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019bf:	8d 40 04             	lea    0x4(%eax),%eax
  8019c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019ca:	e9 a3 00 00 00       	jmp    801a72 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8019cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d2:	8b 10                	mov    (%eax),%edx
  8019d4:	8b 48 04             	mov    0x4(%eax),%ecx
  8019d7:	8d 40 08             	lea    0x8(%eax),%eax
  8019da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019e2:	e9 8b 00 00 00       	jmp    801a72 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8019e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ea:	8b 10                	mov    (%eax),%edx
  8019ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f1:	8d 40 04             	lea    0x4(%eax),%eax
  8019f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019fc:	eb 74                	jmp    801a72 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8019fe:	83 f9 01             	cmp    $0x1,%ecx
  801a01:	7f 1b                	jg     801a1e <vprintfmt+0x353>
	else if (lflag)
  801a03:	85 c9                	test   %ecx,%ecx
  801a05:	74 2c                	je     801a33 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  801a07:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0a:	8b 10                	mov    (%eax),%edx
  801a0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a11:	8d 40 04             	lea    0x4(%eax),%eax
  801a14:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a17:	b8 08 00 00 00       	mov    $0x8,%eax
  801a1c:	eb 54                	jmp    801a72 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a21:	8b 10                	mov    (%eax),%edx
  801a23:	8b 48 04             	mov    0x4(%eax),%ecx
  801a26:	8d 40 08             	lea    0x8(%eax),%eax
  801a29:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a2c:	b8 08 00 00 00       	mov    $0x8,%eax
  801a31:	eb 3f                	jmp    801a72 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801a33:	8b 45 14             	mov    0x14(%ebp),%eax
  801a36:	8b 10                	mov    (%eax),%edx
  801a38:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a3d:	8d 40 04             	lea    0x4(%eax),%eax
  801a40:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a43:	b8 08 00 00 00       	mov    $0x8,%eax
  801a48:	eb 28                	jmp    801a72 <vprintfmt+0x3a7>
			putch('0', putdat);
  801a4a:	83 ec 08             	sub    $0x8,%esp
  801a4d:	53                   	push   %ebx
  801a4e:	6a 30                	push   $0x30
  801a50:	ff d6                	call   *%esi
			putch('x', putdat);
  801a52:	83 c4 08             	add    $0x8,%esp
  801a55:	53                   	push   %ebx
  801a56:	6a 78                	push   $0x78
  801a58:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5d:	8b 10                	mov    (%eax),%edx
  801a5f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a64:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a67:	8d 40 04             	lea    0x4(%eax),%eax
  801a6a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a6d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a72:	83 ec 0c             	sub    $0xc,%esp
  801a75:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801a79:	57                   	push   %edi
  801a7a:	ff 75 e0             	pushl  -0x20(%ebp)
  801a7d:	50                   	push   %eax
  801a7e:	51                   	push   %ecx
  801a7f:	52                   	push   %edx
  801a80:	89 da                	mov    %ebx,%edx
  801a82:	89 f0                	mov    %esi,%eax
  801a84:	e8 5a fb ff ff       	call   8015e3 <printnum>
			break;
  801a89:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801a8c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a8f:	e9 55 fc ff ff       	jmp    8016e9 <vprintfmt+0x1e>
	if (lflag >= 2)
  801a94:	83 f9 01             	cmp    $0x1,%ecx
  801a97:	7f 1b                	jg     801ab4 <vprintfmt+0x3e9>
	else if (lflag)
  801a99:	85 c9                	test   %ecx,%ecx
  801a9b:	74 2c                	je     801ac9 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  801a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa0:	8b 10                	mov    (%eax),%edx
  801aa2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa7:	8d 40 04             	lea    0x4(%eax),%eax
  801aaa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aad:	b8 10 00 00 00       	mov    $0x10,%eax
  801ab2:	eb be                	jmp    801a72 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801ab4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab7:	8b 10                	mov    (%eax),%edx
  801ab9:	8b 48 04             	mov    0x4(%eax),%ecx
  801abc:	8d 40 08             	lea    0x8(%eax),%eax
  801abf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ac2:	b8 10 00 00 00       	mov    $0x10,%eax
  801ac7:	eb a9                	jmp    801a72 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801ac9:	8b 45 14             	mov    0x14(%ebp),%eax
  801acc:	8b 10                	mov    (%eax),%edx
  801ace:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad3:	8d 40 04             	lea    0x4(%eax),%eax
  801ad6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ad9:	b8 10 00 00 00       	mov    $0x10,%eax
  801ade:	eb 92                	jmp    801a72 <vprintfmt+0x3a7>
			putch(ch, putdat);
  801ae0:	83 ec 08             	sub    $0x8,%esp
  801ae3:	53                   	push   %ebx
  801ae4:	6a 25                	push   $0x25
  801ae6:	ff d6                	call   *%esi
			break;
  801ae8:	83 c4 10             	add    $0x10,%esp
  801aeb:	eb 9f                	jmp    801a8c <vprintfmt+0x3c1>
			putch('%', putdat);
  801aed:	83 ec 08             	sub    $0x8,%esp
  801af0:	53                   	push   %ebx
  801af1:	6a 25                	push   $0x25
  801af3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801af5:	83 c4 10             	add    $0x10,%esp
  801af8:	89 f8                	mov    %edi,%eax
  801afa:	eb 03                	jmp    801aff <vprintfmt+0x434>
  801afc:	83 e8 01             	sub    $0x1,%eax
  801aff:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b03:	75 f7                	jne    801afc <vprintfmt+0x431>
  801b05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b08:	eb 82                	jmp    801a8c <vprintfmt+0x3c1>

00801b0a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 18             	sub    $0x18,%esp
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b16:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b19:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b1d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b27:	85 c0                	test   %eax,%eax
  801b29:	74 26                	je     801b51 <vsnprintf+0x47>
  801b2b:	85 d2                	test   %edx,%edx
  801b2d:	7e 22                	jle    801b51 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b2f:	ff 75 14             	pushl  0x14(%ebp)
  801b32:	ff 75 10             	pushl  0x10(%ebp)
  801b35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b38:	50                   	push   %eax
  801b39:	68 91 16 80 00       	push   $0x801691
  801b3e:	e8 88 fb ff ff       	call   8016cb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b46:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4c:	83 c4 10             	add    $0x10,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    
		return -E_INVAL;
  801b51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b56:	eb f7                	jmp    801b4f <vsnprintf+0x45>

00801b58 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b5e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b61:	50                   	push   %eax
  801b62:	ff 75 10             	pushl  0x10(%ebp)
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	e8 9a ff ff ff       	call   801b0a <vsnprintf>
	va_end(ap);

	return rc;
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b78:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b81:	74 05                	je     801b88 <strlen+0x16>
		n++;
  801b83:	83 c0 01             	add    $0x1,%eax
  801b86:	eb f5                	jmp    801b7d <strlen+0xb>
	return n;
}
  801b88:	5d                   	pop    %ebp
  801b89:	c3                   	ret    

00801b8a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b90:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b93:	ba 00 00 00 00       	mov    $0x0,%edx
  801b98:	39 c2                	cmp    %eax,%edx
  801b9a:	74 0d                	je     801ba9 <strnlen+0x1f>
  801b9c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801ba0:	74 05                	je     801ba7 <strnlen+0x1d>
		n++;
  801ba2:	83 c2 01             	add    $0x1,%edx
  801ba5:	eb f1                	jmp    801b98 <strnlen+0xe>
  801ba7:	89 d0                	mov    %edx,%eax
	return n;
}
  801ba9:	5d                   	pop    %ebp
  801baa:	c3                   	ret    

00801bab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	53                   	push   %ebx
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801bb5:	ba 00 00 00 00       	mov    $0x0,%edx
  801bba:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801bbe:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801bc1:	83 c2 01             	add    $0x1,%edx
  801bc4:	84 c9                	test   %cl,%cl
  801bc6:	75 f2                	jne    801bba <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801bc8:	5b                   	pop    %ebx
  801bc9:	5d                   	pop    %ebp
  801bca:	c3                   	ret    

00801bcb <strcat>:

char *
strcat(char *dst, const char *src)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	53                   	push   %ebx
  801bcf:	83 ec 10             	sub    $0x10,%esp
  801bd2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801bd5:	53                   	push   %ebx
  801bd6:	e8 97 ff ff ff       	call   801b72 <strlen>
  801bdb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801bde:	ff 75 0c             	pushl  0xc(%ebp)
  801be1:	01 d8                	add    %ebx,%eax
  801be3:	50                   	push   %eax
  801be4:	e8 c2 ff ff ff       	call   801bab <strcpy>
	return dst;
}
  801be9:	89 d8                	mov    %ebx,%eax
  801beb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	56                   	push   %esi
  801bf4:	53                   	push   %ebx
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bfb:	89 c6                	mov    %eax,%esi
  801bfd:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c00:	89 c2                	mov    %eax,%edx
  801c02:	39 f2                	cmp    %esi,%edx
  801c04:	74 11                	je     801c17 <strncpy+0x27>
		*dst++ = *src;
  801c06:	83 c2 01             	add    $0x1,%edx
  801c09:	0f b6 19             	movzbl (%ecx),%ebx
  801c0c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801c0f:	80 fb 01             	cmp    $0x1,%bl
  801c12:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801c15:	eb eb                	jmp    801c02 <strncpy+0x12>
	}
	return ret;
}
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5d                   	pop    %ebp
  801c1a:	c3                   	ret    

00801c1b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	56                   	push   %esi
  801c1f:	53                   	push   %ebx
  801c20:	8b 75 08             	mov    0x8(%ebp),%esi
  801c23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c26:	8b 55 10             	mov    0x10(%ebp),%edx
  801c29:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c2b:	85 d2                	test   %edx,%edx
  801c2d:	74 21                	je     801c50 <strlcpy+0x35>
  801c2f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801c33:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801c35:	39 c2                	cmp    %eax,%edx
  801c37:	74 14                	je     801c4d <strlcpy+0x32>
  801c39:	0f b6 19             	movzbl (%ecx),%ebx
  801c3c:	84 db                	test   %bl,%bl
  801c3e:	74 0b                	je     801c4b <strlcpy+0x30>
			*dst++ = *src++;
  801c40:	83 c1 01             	add    $0x1,%ecx
  801c43:	83 c2 01             	add    $0x1,%edx
  801c46:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c49:	eb ea                	jmp    801c35 <strlcpy+0x1a>
  801c4b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801c4d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c50:	29 f0                	sub    %esi,%eax
}
  801c52:	5b                   	pop    %ebx
  801c53:	5e                   	pop    %esi
  801c54:	5d                   	pop    %ebp
  801c55:	c3                   	ret    

00801c56 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c5c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c5f:	0f b6 01             	movzbl (%ecx),%eax
  801c62:	84 c0                	test   %al,%al
  801c64:	74 0c                	je     801c72 <strcmp+0x1c>
  801c66:	3a 02                	cmp    (%edx),%al
  801c68:	75 08                	jne    801c72 <strcmp+0x1c>
		p++, q++;
  801c6a:	83 c1 01             	add    $0x1,%ecx
  801c6d:	83 c2 01             	add    $0x1,%edx
  801c70:	eb ed                	jmp    801c5f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c72:	0f b6 c0             	movzbl %al,%eax
  801c75:	0f b6 12             	movzbl (%edx),%edx
  801c78:	29 d0                	sub    %edx,%eax
}
  801c7a:	5d                   	pop    %ebp
  801c7b:	c3                   	ret    

00801c7c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	53                   	push   %ebx
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c86:	89 c3                	mov    %eax,%ebx
  801c88:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c8b:	eb 06                	jmp    801c93 <strncmp+0x17>
		n--, p++, q++;
  801c8d:	83 c0 01             	add    $0x1,%eax
  801c90:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c93:	39 d8                	cmp    %ebx,%eax
  801c95:	74 16                	je     801cad <strncmp+0x31>
  801c97:	0f b6 08             	movzbl (%eax),%ecx
  801c9a:	84 c9                	test   %cl,%cl
  801c9c:	74 04                	je     801ca2 <strncmp+0x26>
  801c9e:	3a 0a                	cmp    (%edx),%cl
  801ca0:	74 eb                	je     801c8d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ca2:	0f b6 00             	movzbl (%eax),%eax
  801ca5:	0f b6 12             	movzbl (%edx),%edx
  801ca8:	29 d0                	sub    %edx,%eax
}
  801caa:	5b                   	pop    %ebx
  801cab:	5d                   	pop    %ebp
  801cac:	c3                   	ret    
		return 0;
  801cad:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb2:	eb f6                	jmp    801caa <strncmp+0x2e>

00801cb4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cbe:	0f b6 10             	movzbl (%eax),%edx
  801cc1:	84 d2                	test   %dl,%dl
  801cc3:	74 09                	je     801cce <strchr+0x1a>
		if (*s == c)
  801cc5:	38 ca                	cmp    %cl,%dl
  801cc7:	74 0a                	je     801cd3 <strchr+0x1f>
	for (; *s; s++)
  801cc9:	83 c0 01             	add    $0x1,%eax
  801ccc:	eb f0                	jmp    801cbe <strchr+0xa>
			return (char *) s;
	return 0;
  801cce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    

00801cd5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cdf:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801ce2:	38 ca                	cmp    %cl,%dl
  801ce4:	74 09                	je     801cef <strfind+0x1a>
  801ce6:	84 d2                	test   %dl,%dl
  801ce8:	74 05                	je     801cef <strfind+0x1a>
	for (; *s; s++)
  801cea:	83 c0 01             	add    $0x1,%eax
  801ced:	eb f0                	jmp    801cdf <strfind+0xa>
			break;
	return (char *) s;
}
  801cef:	5d                   	pop    %ebp
  801cf0:	c3                   	ret    

00801cf1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	57                   	push   %edi
  801cf5:	56                   	push   %esi
  801cf6:	53                   	push   %ebx
  801cf7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cfa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801cfd:	85 c9                	test   %ecx,%ecx
  801cff:	74 31                	je     801d32 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801d01:	89 f8                	mov    %edi,%eax
  801d03:	09 c8                	or     %ecx,%eax
  801d05:	a8 03                	test   $0x3,%al
  801d07:	75 23                	jne    801d2c <memset+0x3b>
		c &= 0xFF;
  801d09:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801d0d:	89 d3                	mov    %edx,%ebx
  801d0f:	c1 e3 08             	shl    $0x8,%ebx
  801d12:	89 d0                	mov    %edx,%eax
  801d14:	c1 e0 18             	shl    $0x18,%eax
  801d17:	89 d6                	mov    %edx,%esi
  801d19:	c1 e6 10             	shl    $0x10,%esi
  801d1c:	09 f0                	or     %esi,%eax
  801d1e:	09 c2                	or     %eax,%edx
  801d20:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801d22:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d25:	89 d0                	mov    %edx,%eax
  801d27:	fc                   	cld    
  801d28:	f3 ab                	rep stos %eax,%es:(%edi)
  801d2a:	eb 06                	jmp    801d32 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2f:	fc                   	cld    
  801d30:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801d32:	89 f8                	mov    %edi,%eax
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    

00801d39 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	57                   	push   %edi
  801d3d:	56                   	push   %esi
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d44:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d47:	39 c6                	cmp    %eax,%esi
  801d49:	73 32                	jae    801d7d <memmove+0x44>
  801d4b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d4e:	39 c2                	cmp    %eax,%edx
  801d50:	76 2b                	jbe    801d7d <memmove+0x44>
		s += n;
		d += n;
  801d52:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d55:	89 fe                	mov    %edi,%esi
  801d57:	09 ce                	or     %ecx,%esi
  801d59:	09 d6                	or     %edx,%esi
  801d5b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d61:	75 0e                	jne    801d71 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d63:	83 ef 04             	sub    $0x4,%edi
  801d66:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d69:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d6c:	fd                   	std    
  801d6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d6f:	eb 09                	jmp    801d7a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d71:	83 ef 01             	sub    $0x1,%edi
  801d74:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d77:	fd                   	std    
  801d78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d7a:	fc                   	cld    
  801d7b:	eb 1a                	jmp    801d97 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d7d:	89 c2                	mov    %eax,%edx
  801d7f:	09 ca                	or     %ecx,%edx
  801d81:	09 f2                	or     %esi,%edx
  801d83:	f6 c2 03             	test   $0x3,%dl
  801d86:	75 0a                	jne    801d92 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d88:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d8b:	89 c7                	mov    %eax,%edi
  801d8d:	fc                   	cld    
  801d8e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d90:	eb 05                	jmp    801d97 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801d92:	89 c7                	mov    %eax,%edi
  801d94:	fc                   	cld    
  801d95:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d97:	5e                   	pop    %esi
  801d98:	5f                   	pop    %edi
  801d99:	5d                   	pop    %ebp
  801d9a:	c3                   	ret    

00801d9b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801da1:	ff 75 10             	pushl  0x10(%ebp)
  801da4:	ff 75 0c             	pushl  0xc(%ebp)
  801da7:	ff 75 08             	pushl  0x8(%ebp)
  801daa:	e8 8a ff ff ff       	call   801d39 <memmove>
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	56                   	push   %esi
  801db5:	53                   	push   %ebx
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbc:	89 c6                	mov    %eax,%esi
  801dbe:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801dc1:	39 f0                	cmp    %esi,%eax
  801dc3:	74 1c                	je     801de1 <memcmp+0x30>
		if (*s1 != *s2)
  801dc5:	0f b6 08             	movzbl (%eax),%ecx
  801dc8:	0f b6 1a             	movzbl (%edx),%ebx
  801dcb:	38 d9                	cmp    %bl,%cl
  801dcd:	75 08                	jne    801dd7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801dcf:	83 c0 01             	add    $0x1,%eax
  801dd2:	83 c2 01             	add    $0x1,%edx
  801dd5:	eb ea                	jmp    801dc1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801dd7:	0f b6 c1             	movzbl %cl,%eax
  801dda:	0f b6 db             	movzbl %bl,%ebx
  801ddd:	29 d8                	sub    %ebx,%eax
  801ddf:	eb 05                	jmp    801de6 <memcmp+0x35>
	}

	return 0;
  801de1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de6:	5b                   	pop    %ebx
  801de7:	5e                   	pop    %esi
  801de8:	5d                   	pop    %ebp
  801de9:	c3                   	ret    

00801dea <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801df3:	89 c2                	mov    %eax,%edx
  801df5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801df8:	39 d0                	cmp    %edx,%eax
  801dfa:	73 09                	jae    801e05 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dfc:	38 08                	cmp    %cl,(%eax)
  801dfe:	74 05                	je     801e05 <memfind+0x1b>
	for (; s < ends; s++)
  801e00:	83 c0 01             	add    $0x1,%eax
  801e03:	eb f3                	jmp    801df8 <memfind+0xe>
			break;
	return (void *) s;
}
  801e05:	5d                   	pop    %ebp
  801e06:	c3                   	ret    

00801e07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	57                   	push   %edi
  801e0b:	56                   	push   %esi
  801e0c:	53                   	push   %ebx
  801e0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e13:	eb 03                	jmp    801e18 <strtol+0x11>
		s++;
  801e15:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801e18:	0f b6 01             	movzbl (%ecx),%eax
  801e1b:	3c 20                	cmp    $0x20,%al
  801e1d:	74 f6                	je     801e15 <strtol+0xe>
  801e1f:	3c 09                	cmp    $0x9,%al
  801e21:	74 f2                	je     801e15 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801e23:	3c 2b                	cmp    $0x2b,%al
  801e25:	74 2a                	je     801e51 <strtol+0x4a>
	int neg = 0;
  801e27:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e2c:	3c 2d                	cmp    $0x2d,%al
  801e2e:	74 2b                	je     801e5b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e30:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e36:	75 0f                	jne    801e47 <strtol+0x40>
  801e38:	80 39 30             	cmpb   $0x30,(%ecx)
  801e3b:	74 28                	je     801e65 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e3d:	85 db                	test   %ebx,%ebx
  801e3f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801e44:	0f 44 d8             	cmove  %eax,%ebx
  801e47:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e4f:	eb 50                	jmp    801ea1 <strtol+0x9a>
		s++;
  801e51:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e54:	bf 00 00 00 00       	mov    $0x0,%edi
  801e59:	eb d5                	jmp    801e30 <strtol+0x29>
		s++, neg = 1;
  801e5b:	83 c1 01             	add    $0x1,%ecx
  801e5e:	bf 01 00 00 00       	mov    $0x1,%edi
  801e63:	eb cb                	jmp    801e30 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e65:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e69:	74 0e                	je     801e79 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801e6b:	85 db                	test   %ebx,%ebx
  801e6d:	75 d8                	jne    801e47 <strtol+0x40>
		s++, base = 8;
  801e6f:	83 c1 01             	add    $0x1,%ecx
  801e72:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e77:	eb ce                	jmp    801e47 <strtol+0x40>
		s += 2, base = 16;
  801e79:	83 c1 02             	add    $0x2,%ecx
  801e7c:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e81:	eb c4                	jmp    801e47 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e83:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e86:	89 f3                	mov    %esi,%ebx
  801e88:	80 fb 19             	cmp    $0x19,%bl
  801e8b:	77 29                	ja     801eb6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801e8d:	0f be d2             	movsbl %dl,%edx
  801e90:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e93:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e96:	7d 30                	jge    801ec8 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801e98:	83 c1 01             	add    $0x1,%ecx
  801e9b:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e9f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801ea1:	0f b6 11             	movzbl (%ecx),%edx
  801ea4:	8d 72 d0             	lea    -0x30(%edx),%esi
  801ea7:	89 f3                	mov    %esi,%ebx
  801ea9:	80 fb 09             	cmp    $0x9,%bl
  801eac:	77 d5                	ja     801e83 <strtol+0x7c>
			dig = *s - '0';
  801eae:	0f be d2             	movsbl %dl,%edx
  801eb1:	83 ea 30             	sub    $0x30,%edx
  801eb4:	eb dd                	jmp    801e93 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801eb6:	8d 72 bf             	lea    -0x41(%edx),%esi
  801eb9:	89 f3                	mov    %esi,%ebx
  801ebb:	80 fb 19             	cmp    $0x19,%bl
  801ebe:	77 08                	ja     801ec8 <strtol+0xc1>
			dig = *s - 'A' + 10;
  801ec0:	0f be d2             	movsbl %dl,%edx
  801ec3:	83 ea 37             	sub    $0x37,%edx
  801ec6:	eb cb                	jmp    801e93 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ec8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ecc:	74 05                	je     801ed3 <strtol+0xcc>
		*endptr = (char *) s;
  801ece:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ed1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801ed3:	89 c2                	mov    %eax,%edx
  801ed5:	f7 da                	neg    %edx
  801ed7:	85 ff                	test   %edi,%edi
  801ed9:	0f 45 c2             	cmovne %edx,%eax
}
  801edc:	5b                   	pop    %ebx
  801edd:	5e                   	pop    %esi
  801ede:	5f                   	pop    %edi
  801edf:	5d                   	pop    %ebp
  801ee0:	c3                   	ret    

00801ee1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	56                   	push   %esi
  801ee5:	53                   	push   %ebx
  801ee6:	8b 75 08             	mov    0x8(%ebp),%esi
  801ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	74 4f                	je     801f42 <ipc_recv+0x61>
  801ef3:	83 ec 0c             	sub    $0xc,%esp
  801ef6:	50                   	push   %eax
  801ef7:	e8 35 e4 ff ff       	call   800331 <sys_ipc_recv>
  801efc:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801eff:	85 f6                	test   %esi,%esi
  801f01:	74 14                	je     801f17 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801f03:	ba 00 00 00 00       	mov    $0x0,%edx
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	75 09                	jne    801f15 <ipc_recv+0x34>
  801f0c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f12:	8b 52 74             	mov    0x74(%edx),%edx
  801f15:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801f17:	85 db                	test   %ebx,%ebx
  801f19:	74 14                	je     801f2f <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801f1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f20:	85 c0                	test   %eax,%eax
  801f22:	75 09                	jne    801f2d <ipc_recv+0x4c>
  801f24:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f2a:	8b 52 78             	mov    0x78(%edx),%edx
  801f2d:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	75 08                	jne    801f3b <ipc_recv+0x5a>
  801f33:	a1 08 40 80 00       	mov    0x804008,%eax
  801f38:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f3e:	5b                   	pop    %ebx
  801f3f:	5e                   	pop    %esi
  801f40:	5d                   	pop    %ebp
  801f41:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f42:	83 ec 0c             	sub    $0xc,%esp
  801f45:	68 00 00 c0 ee       	push   $0xeec00000
  801f4a:	e8 e2 e3 ff ff       	call   800331 <sys_ipc_recv>
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	eb ab                	jmp    801eff <ipc_recv+0x1e>

00801f54 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	57                   	push   %edi
  801f58:	56                   	push   %esi
  801f59:	53                   	push   %ebx
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f60:	8b 75 10             	mov    0x10(%ebp),%esi
  801f63:	eb 20                	jmp    801f85 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f65:	6a 00                	push   $0x0
  801f67:	68 00 00 c0 ee       	push   $0xeec00000
  801f6c:	ff 75 0c             	pushl  0xc(%ebp)
  801f6f:	57                   	push   %edi
  801f70:	e8 99 e3 ff ff       	call   80030e <sys_ipc_try_send>
  801f75:	89 c3                	mov    %eax,%ebx
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	eb 1f                	jmp    801f9b <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801f7c:	e8 e1 e1 ff ff       	call   800162 <sys_yield>
	while(retval != 0) {
  801f81:	85 db                	test   %ebx,%ebx
  801f83:	74 33                	je     801fb8 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f85:	85 f6                	test   %esi,%esi
  801f87:	74 dc                	je     801f65 <ipc_send+0x11>
  801f89:	ff 75 14             	pushl  0x14(%ebp)
  801f8c:	56                   	push   %esi
  801f8d:	ff 75 0c             	pushl  0xc(%ebp)
  801f90:	57                   	push   %edi
  801f91:	e8 78 e3 ff ff       	call   80030e <sys_ipc_try_send>
  801f96:	89 c3                	mov    %eax,%ebx
  801f98:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801f9b:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801f9e:	74 dc                	je     801f7c <ipc_send+0x28>
  801fa0:	85 db                	test   %ebx,%ebx
  801fa2:	74 d8                	je     801f7c <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801fa4:	83 ec 04             	sub    $0x4,%esp
  801fa7:	68 40 27 80 00       	push   $0x802740
  801fac:	6a 35                	push   $0x35
  801fae:	68 70 27 80 00       	push   $0x802770
  801fb3:	e8 3c f5 ff ff       	call   8014f4 <_panic>
	}
}
  801fb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fbb:	5b                   	pop    %ebx
  801fbc:	5e                   	pop    %esi
  801fbd:	5f                   	pop    %edi
  801fbe:	5d                   	pop    %ebp
  801fbf:	c3                   	ret    

00801fc0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fc6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fcb:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fce:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fd4:	8b 52 50             	mov    0x50(%edx),%edx
  801fd7:	39 ca                	cmp    %ecx,%edx
  801fd9:	74 11                	je     801fec <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fdb:	83 c0 01             	add    $0x1,%eax
  801fde:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fe3:	75 e6                	jne    801fcb <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fea:	eb 0b                	jmp    801ff7 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fec:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ff4:	8b 40 48             	mov    0x48(%eax),%eax
}
  801ff7:	5d                   	pop    %ebp
  801ff8:	c3                   	ret    

00801ff9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fff:	89 d0                	mov    %edx,%eax
  802001:	c1 e8 16             	shr    $0x16,%eax
  802004:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80200b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802010:	f6 c1 01             	test   $0x1,%cl
  802013:	74 1d                	je     802032 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802015:	c1 ea 0c             	shr    $0xc,%edx
  802018:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80201f:	f6 c2 01             	test   $0x1,%dl
  802022:	74 0e                	je     802032 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802024:	c1 ea 0c             	shr    $0xc,%edx
  802027:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80202e:	ef 
  80202f:	0f b7 c0             	movzwl %ax,%eax
}
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    
  802034:	66 90                	xchg   %ax,%ax
  802036:	66 90                	xchg   %ax,%ax
  802038:	66 90                	xchg   %ax,%ax
  80203a:	66 90                	xchg   %ax,%ax
  80203c:	66 90                	xchg   %ax,%ax
  80203e:	66 90                	xchg   %ax,%ax

00802040 <__udivdi3>:
  802040:	f3 0f 1e fb          	endbr32 
  802044:	55                   	push   %ebp
  802045:	57                   	push   %edi
  802046:	56                   	push   %esi
  802047:	53                   	push   %ebx
  802048:	83 ec 1c             	sub    $0x1c,%esp
  80204b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80204f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802053:	8b 74 24 34          	mov    0x34(%esp),%esi
  802057:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80205b:	85 d2                	test   %edx,%edx
  80205d:	75 49                	jne    8020a8 <__udivdi3+0x68>
  80205f:	39 f3                	cmp    %esi,%ebx
  802061:	76 15                	jbe    802078 <__udivdi3+0x38>
  802063:	31 ff                	xor    %edi,%edi
  802065:	89 e8                	mov    %ebp,%eax
  802067:	89 f2                	mov    %esi,%edx
  802069:	f7 f3                	div    %ebx
  80206b:	89 fa                	mov    %edi,%edx
  80206d:	83 c4 1c             	add    $0x1c,%esp
  802070:	5b                   	pop    %ebx
  802071:	5e                   	pop    %esi
  802072:	5f                   	pop    %edi
  802073:	5d                   	pop    %ebp
  802074:	c3                   	ret    
  802075:	8d 76 00             	lea    0x0(%esi),%esi
  802078:	89 d9                	mov    %ebx,%ecx
  80207a:	85 db                	test   %ebx,%ebx
  80207c:	75 0b                	jne    802089 <__udivdi3+0x49>
  80207e:	b8 01 00 00 00       	mov    $0x1,%eax
  802083:	31 d2                	xor    %edx,%edx
  802085:	f7 f3                	div    %ebx
  802087:	89 c1                	mov    %eax,%ecx
  802089:	31 d2                	xor    %edx,%edx
  80208b:	89 f0                	mov    %esi,%eax
  80208d:	f7 f1                	div    %ecx
  80208f:	89 c6                	mov    %eax,%esi
  802091:	89 e8                	mov    %ebp,%eax
  802093:	89 f7                	mov    %esi,%edi
  802095:	f7 f1                	div    %ecx
  802097:	89 fa                	mov    %edi,%edx
  802099:	83 c4 1c             	add    $0x1c,%esp
  80209c:	5b                   	pop    %ebx
  80209d:	5e                   	pop    %esi
  80209e:	5f                   	pop    %edi
  80209f:	5d                   	pop    %ebp
  8020a0:	c3                   	ret    
  8020a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020a8:	39 f2                	cmp    %esi,%edx
  8020aa:	77 1c                	ja     8020c8 <__udivdi3+0x88>
  8020ac:	0f bd fa             	bsr    %edx,%edi
  8020af:	83 f7 1f             	xor    $0x1f,%edi
  8020b2:	75 2c                	jne    8020e0 <__udivdi3+0xa0>
  8020b4:	39 f2                	cmp    %esi,%edx
  8020b6:	72 06                	jb     8020be <__udivdi3+0x7e>
  8020b8:	31 c0                	xor    %eax,%eax
  8020ba:	39 eb                	cmp    %ebp,%ebx
  8020bc:	77 ad                	ja     80206b <__udivdi3+0x2b>
  8020be:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c3:	eb a6                	jmp    80206b <__udivdi3+0x2b>
  8020c5:	8d 76 00             	lea    0x0(%esi),%esi
  8020c8:	31 ff                	xor    %edi,%edi
  8020ca:	31 c0                	xor    %eax,%eax
  8020cc:	89 fa                	mov    %edi,%edx
  8020ce:	83 c4 1c             	add    $0x1c,%esp
  8020d1:	5b                   	pop    %ebx
  8020d2:	5e                   	pop    %esi
  8020d3:	5f                   	pop    %edi
  8020d4:	5d                   	pop    %ebp
  8020d5:	c3                   	ret    
  8020d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020dd:	8d 76 00             	lea    0x0(%esi),%esi
  8020e0:	89 f9                	mov    %edi,%ecx
  8020e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020e7:	29 f8                	sub    %edi,%eax
  8020e9:	d3 e2                	shl    %cl,%edx
  8020eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020ef:	89 c1                	mov    %eax,%ecx
  8020f1:	89 da                	mov    %ebx,%edx
  8020f3:	d3 ea                	shr    %cl,%edx
  8020f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020f9:	09 d1                	or     %edx,%ecx
  8020fb:	89 f2                	mov    %esi,%edx
  8020fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802101:	89 f9                	mov    %edi,%ecx
  802103:	d3 e3                	shl    %cl,%ebx
  802105:	89 c1                	mov    %eax,%ecx
  802107:	d3 ea                	shr    %cl,%edx
  802109:	89 f9                	mov    %edi,%ecx
  80210b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80210f:	89 eb                	mov    %ebp,%ebx
  802111:	d3 e6                	shl    %cl,%esi
  802113:	89 c1                	mov    %eax,%ecx
  802115:	d3 eb                	shr    %cl,%ebx
  802117:	09 de                	or     %ebx,%esi
  802119:	89 f0                	mov    %esi,%eax
  80211b:	f7 74 24 08          	divl   0x8(%esp)
  80211f:	89 d6                	mov    %edx,%esi
  802121:	89 c3                	mov    %eax,%ebx
  802123:	f7 64 24 0c          	mull   0xc(%esp)
  802127:	39 d6                	cmp    %edx,%esi
  802129:	72 15                	jb     802140 <__udivdi3+0x100>
  80212b:	89 f9                	mov    %edi,%ecx
  80212d:	d3 e5                	shl    %cl,%ebp
  80212f:	39 c5                	cmp    %eax,%ebp
  802131:	73 04                	jae    802137 <__udivdi3+0xf7>
  802133:	39 d6                	cmp    %edx,%esi
  802135:	74 09                	je     802140 <__udivdi3+0x100>
  802137:	89 d8                	mov    %ebx,%eax
  802139:	31 ff                	xor    %edi,%edi
  80213b:	e9 2b ff ff ff       	jmp    80206b <__udivdi3+0x2b>
  802140:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802143:	31 ff                	xor    %edi,%edi
  802145:	e9 21 ff ff ff       	jmp    80206b <__udivdi3+0x2b>
  80214a:	66 90                	xchg   %ax,%ax
  80214c:	66 90                	xchg   %ax,%ax
  80214e:	66 90                	xchg   %ax,%ax

00802150 <__umoddi3>:
  802150:	f3 0f 1e fb          	endbr32 
  802154:	55                   	push   %ebp
  802155:	57                   	push   %edi
  802156:	56                   	push   %esi
  802157:	53                   	push   %ebx
  802158:	83 ec 1c             	sub    $0x1c,%esp
  80215b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80215f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802163:	8b 74 24 30          	mov    0x30(%esp),%esi
  802167:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80216b:	89 da                	mov    %ebx,%edx
  80216d:	85 c0                	test   %eax,%eax
  80216f:	75 3f                	jne    8021b0 <__umoddi3+0x60>
  802171:	39 df                	cmp    %ebx,%edi
  802173:	76 13                	jbe    802188 <__umoddi3+0x38>
  802175:	89 f0                	mov    %esi,%eax
  802177:	f7 f7                	div    %edi
  802179:	89 d0                	mov    %edx,%eax
  80217b:	31 d2                	xor    %edx,%edx
  80217d:	83 c4 1c             	add    $0x1c,%esp
  802180:	5b                   	pop    %ebx
  802181:	5e                   	pop    %esi
  802182:	5f                   	pop    %edi
  802183:	5d                   	pop    %ebp
  802184:	c3                   	ret    
  802185:	8d 76 00             	lea    0x0(%esi),%esi
  802188:	89 fd                	mov    %edi,%ebp
  80218a:	85 ff                	test   %edi,%edi
  80218c:	75 0b                	jne    802199 <__umoddi3+0x49>
  80218e:	b8 01 00 00 00       	mov    $0x1,%eax
  802193:	31 d2                	xor    %edx,%edx
  802195:	f7 f7                	div    %edi
  802197:	89 c5                	mov    %eax,%ebp
  802199:	89 d8                	mov    %ebx,%eax
  80219b:	31 d2                	xor    %edx,%edx
  80219d:	f7 f5                	div    %ebp
  80219f:	89 f0                	mov    %esi,%eax
  8021a1:	f7 f5                	div    %ebp
  8021a3:	89 d0                	mov    %edx,%eax
  8021a5:	eb d4                	jmp    80217b <__umoddi3+0x2b>
  8021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021ae:	66 90                	xchg   %ax,%ax
  8021b0:	89 f1                	mov    %esi,%ecx
  8021b2:	39 d8                	cmp    %ebx,%eax
  8021b4:	76 0a                	jbe    8021c0 <__umoddi3+0x70>
  8021b6:	89 f0                	mov    %esi,%eax
  8021b8:	83 c4 1c             	add    $0x1c,%esp
  8021bb:	5b                   	pop    %ebx
  8021bc:	5e                   	pop    %esi
  8021bd:	5f                   	pop    %edi
  8021be:	5d                   	pop    %ebp
  8021bf:	c3                   	ret    
  8021c0:	0f bd e8             	bsr    %eax,%ebp
  8021c3:	83 f5 1f             	xor    $0x1f,%ebp
  8021c6:	75 20                	jne    8021e8 <__umoddi3+0x98>
  8021c8:	39 d8                	cmp    %ebx,%eax
  8021ca:	0f 82 b0 00 00 00    	jb     802280 <__umoddi3+0x130>
  8021d0:	39 f7                	cmp    %esi,%edi
  8021d2:	0f 86 a8 00 00 00    	jbe    802280 <__umoddi3+0x130>
  8021d8:	89 c8                	mov    %ecx,%eax
  8021da:	83 c4 1c             	add    $0x1c,%esp
  8021dd:	5b                   	pop    %ebx
  8021de:	5e                   	pop    %esi
  8021df:	5f                   	pop    %edi
  8021e0:	5d                   	pop    %ebp
  8021e1:	c3                   	ret    
  8021e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021e8:	89 e9                	mov    %ebp,%ecx
  8021ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8021ef:	29 ea                	sub    %ebp,%edx
  8021f1:	d3 e0                	shl    %cl,%eax
  8021f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021f7:	89 d1                	mov    %edx,%ecx
  8021f9:	89 f8                	mov    %edi,%eax
  8021fb:	d3 e8                	shr    %cl,%eax
  8021fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802201:	89 54 24 04          	mov    %edx,0x4(%esp)
  802205:	8b 54 24 04          	mov    0x4(%esp),%edx
  802209:	09 c1                	or     %eax,%ecx
  80220b:	89 d8                	mov    %ebx,%eax
  80220d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802211:	89 e9                	mov    %ebp,%ecx
  802213:	d3 e7                	shl    %cl,%edi
  802215:	89 d1                	mov    %edx,%ecx
  802217:	d3 e8                	shr    %cl,%eax
  802219:	89 e9                	mov    %ebp,%ecx
  80221b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80221f:	d3 e3                	shl    %cl,%ebx
  802221:	89 c7                	mov    %eax,%edi
  802223:	89 d1                	mov    %edx,%ecx
  802225:	89 f0                	mov    %esi,%eax
  802227:	d3 e8                	shr    %cl,%eax
  802229:	89 e9                	mov    %ebp,%ecx
  80222b:	89 fa                	mov    %edi,%edx
  80222d:	d3 e6                	shl    %cl,%esi
  80222f:	09 d8                	or     %ebx,%eax
  802231:	f7 74 24 08          	divl   0x8(%esp)
  802235:	89 d1                	mov    %edx,%ecx
  802237:	89 f3                	mov    %esi,%ebx
  802239:	f7 64 24 0c          	mull   0xc(%esp)
  80223d:	89 c6                	mov    %eax,%esi
  80223f:	89 d7                	mov    %edx,%edi
  802241:	39 d1                	cmp    %edx,%ecx
  802243:	72 06                	jb     80224b <__umoddi3+0xfb>
  802245:	75 10                	jne    802257 <__umoddi3+0x107>
  802247:	39 c3                	cmp    %eax,%ebx
  802249:	73 0c                	jae    802257 <__umoddi3+0x107>
  80224b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80224f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802253:	89 d7                	mov    %edx,%edi
  802255:	89 c6                	mov    %eax,%esi
  802257:	89 ca                	mov    %ecx,%edx
  802259:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80225e:	29 f3                	sub    %esi,%ebx
  802260:	19 fa                	sbb    %edi,%edx
  802262:	89 d0                	mov    %edx,%eax
  802264:	d3 e0                	shl    %cl,%eax
  802266:	89 e9                	mov    %ebp,%ecx
  802268:	d3 eb                	shr    %cl,%ebx
  80226a:	d3 ea                	shr    %cl,%edx
  80226c:	09 d8                	or     %ebx,%eax
  80226e:	83 c4 1c             	add    $0x1c,%esp
  802271:	5b                   	pop    %ebx
  802272:	5e                   	pop    %esi
  802273:	5f                   	pop    %edi
  802274:	5d                   	pop    %ebp
  802275:	c3                   	ret    
  802276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80227d:	8d 76 00             	lea    0x0(%esi),%esi
  802280:	89 da                	mov    %ebx,%edx
  802282:	29 fe                	sub    %edi,%esi
  802284:	19 c2                	sbb    %eax,%edx
  802286:	89 f1                	mov    %esi,%ecx
  802288:	89 c8                	mov    %ecx,%eax
  80228a:	e9 4b ff ff ff       	jmp    8021da <__umoddi3+0x8a>
