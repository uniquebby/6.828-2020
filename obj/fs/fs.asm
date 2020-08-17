
obj/fs/fs：     文件格式 elf32-i386


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
  80002c:	e8 8d 1a 00 00       	call   801abe <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	53                   	push   %ebx
  800063:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	e8 c3 ff ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800070:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800075:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007a:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007b:	b9 00 00 00 00       	mov    $0x0,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800080:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800085:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800086:	a8 a1                	test   $0xa1,%al
  800088:	74 0b                	je     800095 <ide_probe_disk1+0x36>
	     x++)
  80008a:	83 c1 01             	add    $0x1,%ecx
	for (x = 0;
  80008d:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800093:	75 f0                	jne    800085 <ide_probe_disk1+0x26>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800095:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009a:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80009f:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a0:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a6:	0f 9e c3             	setle  %bl
  8000a9:	83 ec 08             	sub    $0x8,%esp
  8000ac:	0f b6 c3             	movzbl %bl,%eax
  8000af:	50                   	push   %eax
  8000b0:	68 80 3d 80 00       	push   $0x803d80
  8000b5:	e8 3f 1b 00 00       	call   801bf9 <cprintf>
	return (x < 1000);
}
  8000ba:	89 d8                	mov    %ebx,%eax
  8000bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000bf:	c9                   	leave  
  8000c0:	c3                   	ret    

008000c1 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
  8000c7:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000ca:	83 f8 01             	cmp    $0x1,%eax
  8000cd:	77 07                	ja     8000d6 <ide_set_disk+0x15>
		panic("bad disk number");
	diskno = d;
  8000cf:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
		panic("bad disk number");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 97 3d 80 00       	push   $0x803d97
  8000de:	6a 3a                	push   $0x3a
  8000e0:	68 a7 3d 80 00       	push   $0x803da7
  8000e5:	e8 34 1a 00 00       	call   801b1e <_panic>

008000ea <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8000f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  8000fc:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800102:	0f 87 87 00 00 00    	ja     80018f <ide_read+0xa5>

	ide_wait_ready(0);
  800108:	b8 00 00 00 00       	mov    $0x0,%eax
  80010d:	e8 21 ff ff ff       	call   800033 <ide_wait_ready>
  800112:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800117:	89 f0                	mov    %esi,%eax
  800119:	ee                   	out    %al,(%dx)
  80011a:	ba f3 01 00 00       	mov    $0x1f3,%edx
  80011f:	89 f8                	mov    %edi,%eax
  800121:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  800122:	89 f8                	mov    %edi,%eax
  800124:	c1 e8 08             	shr    $0x8,%eax
  800127:	ba f4 01 00 00       	mov    $0x1f4,%edx
  80012c:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  80012d:	89 f8                	mov    %edi,%eax
  80012f:	c1 e8 10             	shr    $0x10,%eax
  800132:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800137:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800138:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  80013f:	c1 e0 04             	shl    $0x4,%eax
  800142:	83 e0 10             	and    $0x10,%eax
  800145:	c1 ef 18             	shr    $0x18,%edi
  800148:	83 e7 0f             	and    $0xf,%edi
  80014b:	09 f8                	or     %edi,%eax
  80014d:	83 c8 e0             	or     $0xffffffe0,%eax
  800150:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800155:	ee                   	out    %al,(%dx)
  800156:	b8 20 00 00 00       	mov    $0x20,%eax
  80015b:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800160:	ee                   	out    %al,(%dx)
  800161:	c1 e6 09             	shl    $0x9,%esi
  800164:	01 de                	add    %ebx,%esi
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800166:	39 f3                	cmp    %esi,%ebx
  800168:	74 3b                	je     8001a5 <ide_read+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  80016a:	b8 01 00 00 00       	mov    $0x1,%eax
  80016f:	e8 bf fe ff ff       	call   800033 <ide_wait_ready>
  800174:	85 c0                	test   %eax,%eax
  800176:	78 32                	js     8001aa <ide_read+0xc0>
	asm volatile("cld\n\trepne\n\tinsl"
  800178:	89 df                	mov    %ebx,%edi
  80017a:	b9 80 00 00 00       	mov    $0x80,%ecx
  80017f:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800184:	fc                   	cld    
  800185:	f2 6d                	repnz insl (%dx),%es:(%edi)
	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800187:	81 c3 00 02 00 00    	add    $0x200,%ebx
  80018d:	eb d7                	jmp    800166 <ide_read+0x7c>
	assert(nsecs <= 256);
  80018f:	68 b0 3d 80 00       	push   $0x803db0
  800194:	68 bd 3d 80 00       	push   $0x803dbd
  800199:	6a 44                	push   $0x44
  80019b:	68 a7 3d 80 00       	push   $0x803da7
  8001a0:	e8 79 19 00 00       	call   801b1e <_panic>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ad:	5b                   	pop    %ebx
  8001ae:	5e                   	pop    %esi
  8001af:	5f                   	pop    %edi
  8001b0:	5d                   	pop    %ebp
  8001b1:	c3                   	ret    

008001b2 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	57                   	push   %edi
  8001b6:	56                   	push   %esi
  8001b7:	53                   	push   %ebx
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8001be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001c1:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001c4:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001ca:	0f 87 87 00 00 00    	ja     800257 <ide_write+0xa5>

	ide_wait_ready(0);
  8001d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d5:	e8 59 fe ff ff       	call   800033 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001da:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8001df:	89 f8                	mov    %edi,%eax
  8001e1:	ee                   	out    %al,(%dx)
  8001e2:	ba f3 01 00 00       	mov    $0x1f3,%edx
  8001e7:	89 f0                	mov    %esi,%eax
  8001e9:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  8001ea:	89 f0                	mov    %esi,%eax
  8001ec:	c1 e8 08             	shr    $0x8,%eax
  8001ef:	ba f4 01 00 00       	mov    $0x1f4,%edx
  8001f4:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8001f5:	89 f0                	mov    %esi,%eax
  8001f7:	c1 e8 10             	shr    $0x10,%eax
  8001fa:	ba f5 01 00 00       	mov    $0x1f5,%edx
  8001ff:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800200:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800207:	c1 e0 04             	shl    $0x4,%eax
  80020a:	83 e0 10             	and    $0x10,%eax
  80020d:	c1 ee 18             	shr    $0x18,%esi
  800210:	83 e6 0f             	and    $0xf,%esi
  800213:	09 f0                	or     %esi,%eax
  800215:	83 c8 e0             	or     $0xffffffe0,%eax
  800218:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80021d:	ee                   	out    %al,(%dx)
  80021e:	b8 30 00 00 00       	mov    $0x30,%eax
  800223:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800228:	ee                   	out    %al,(%dx)
  800229:	c1 e7 09             	shl    $0x9,%edi
  80022c:	01 df                	add    %ebx,%edi
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80022e:	39 fb                	cmp    %edi,%ebx
  800230:	74 3b                	je     80026d <ide_write+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  800232:	b8 01 00 00 00       	mov    $0x1,%eax
  800237:	e8 f7 fd ff ff       	call   800033 <ide_wait_ready>
  80023c:	85 c0                	test   %eax,%eax
  80023e:	78 32                	js     800272 <ide_write+0xc0>
}

static inline void
outsl(int port, const void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\toutsl"
  800240:	89 de                	mov    %ebx,%esi
  800242:	b9 80 00 00 00       	mov    $0x80,%ecx
  800247:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80024c:	fc                   	cld    
  80024d:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80024f:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800255:	eb d7                	jmp    80022e <ide_write+0x7c>
	assert(nsecs <= 256);
  800257:	68 b0 3d 80 00       	push   $0x803db0
  80025c:	68 bd 3d 80 00       	push   $0x803dbd
  800261:	6a 5d                	push   $0x5d
  800263:	68 a7 3d 80 00       	push   $0x803da7
  800268:	e8 b1 18 00 00       	call   801b1e <_panic>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	57                   	push   %edi
  80027e:	56                   	push   %esi
  80027f:	53                   	push   %ebx
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  800286:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800288:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80028e:	89 c6                	mov    %eax,%esi
  800290:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800293:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800298:	0f 87 98 00 00 00    	ja     800336 <bc_pgfault+0xbc>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80029e:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8002a3:	85 c0                	test   %eax,%eax
  8002a5:	74 09                	je     8002b0 <bc_pgfault+0x36>
  8002a7:	39 70 04             	cmp    %esi,0x4(%eax)
  8002aa:	0f 86 a1 00 00 00    	jbe    800351 <bc_pgfault+0xd7>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
  r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE), PTE_U|PTE_P|PTE_W);
  8002b0:	89 df                	mov    %ebx,%edi
  8002b2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  8002b8:	83 ec 04             	sub    $0x4,%esp
  8002bb:	6a 07                	push   $0x7
  8002bd:	57                   	push   %edi
  8002be:	6a 00                	push   $0x0
  8002c0:	e8 02 23 00 00       	call   8025c7 <sys_page_alloc>
  if (r < 0) panic("bc_pgfault: falied to alloc a page.\n");
  8002c5:	83 c4 10             	add    $0x10,%esp
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	0f 88 93 00 00 00    	js     800363 <bc_pgfault+0xe9>

  r = ide_read(blockno*8, ROUNDDOWN(addr, PGSIZE), 8);
  8002d0:	83 ec 04             	sub    $0x4,%esp
  8002d3:	6a 08                	push   $0x8
  8002d5:	57                   	push   %edi
  8002d6:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  8002dd:	50                   	push   %eax
  8002de:	e8 07 fe ff ff       	call   8000ea <ide_read>
  if (r < 0) panic("bc_pgfault: ide_read failed.\n");
  8002e3:	83 c4 10             	add    $0x10,%esp
  8002e6:	85 c0                	test   %eax,%eax
  8002e8:	0f 88 89 00 00 00    	js     800377 <bc_pgfault+0xfd>

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8002ee:	89 d8                	mov    %ebx,%eax
  8002f0:	c1 e8 0c             	shr    $0xc,%eax
  8002f3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	25 07 0e 00 00       	and    $0xe07,%eax
  800302:	50                   	push   %eax
  800303:	53                   	push   %ebx
  800304:	6a 00                	push   $0x0
  800306:	53                   	push   %ebx
  800307:	6a 00                	push   $0x0
  800309:	e8 fc 22 00 00       	call   80260a <sys_page_map>
  80030e:	83 c4 20             	add    $0x20,%esp
  800311:	85 c0                	test   %eax,%eax
  800313:	78 76                	js     80038b <bc_pgfault+0x111>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  800315:	83 3d 08 a0 80 00 00 	cmpl   $0x0,0x80a008
  80031c:	74 10                	je     80032e <bc_pgfault+0xb4>
  80031e:	83 ec 0c             	sub    $0xc,%esp
  800321:	56                   	push   %esi
  800322:	e8 0c 05 00 00       	call   800833 <block_is_free>
  800327:	83 c4 10             	add    $0x10,%esp
  80032a:	84 c0                	test   %al,%al
  80032c:	75 6f                	jne    80039d <bc_pgfault+0x123>
		panic("reading free block %08x\n", blockno);
}
  80032e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800331:	5b                   	pop    %ebx
  800332:	5e                   	pop    %esi
  800333:	5f                   	pop    %edi
  800334:	5d                   	pop    %ebp
  800335:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800336:	83 ec 08             	sub    $0x8,%esp
  800339:	ff 72 04             	pushl  0x4(%edx)
  80033c:	53                   	push   %ebx
  80033d:	ff 72 28             	pushl  0x28(%edx)
  800340:	68 d4 3d 80 00       	push   $0x803dd4
  800345:	6a 27                	push   $0x27
  800347:	68 00 3f 80 00       	push   $0x803f00
  80034c:	e8 cd 17 00 00       	call   801b1e <_panic>
		panic("reading non-existent block %08x\n", blockno);
  800351:	56                   	push   %esi
  800352:	68 04 3e 80 00       	push   $0x803e04
  800357:	6a 2b                	push   $0x2b
  800359:	68 00 3f 80 00       	push   $0x803f00
  80035e:	e8 bb 17 00 00       	call   801b1e <_panic>
  if (r < 0) panic("bc_pgfault: falied to alloc a page.\n");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 28 3e 80 00       	push   $0x803e28
  80036b:	6a 34                	push   $0x34
  80036d:	68 00 3f 80 00       	push   $0x803f00
  800372:	e8 a7 17 00 00       	call   801b1e <_panic>
  if (r < 0) panic("bc_pgfault: ide_read failed.\n");
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	68 08 3f 80 00       	push   $0x803f08
  80037f:	6a 37                	push   $0x37
  800381:	68 00 3f 80 00       	push   $0x803f00
  800386:	e8 93 17 00 00       	call   801b1e <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  80038b:	50                   	push   %eax
  80038c:	68 50 3e 80 00       	push   $0x803e50
  800391:	6a 3c                	push   $0x3c
  800393:	68 00 3f 80 00       	push   $0x803f00
  800398:	e8 81 17 00 00       	call   801b1e <_panic>
		panic("reading free block %08x\n", blockno);
  80039d:	56                   	push   %esi
  80039e:	68 26 3f 80 00       	push   $0x803f26
  8003a3:	6a 42                	push   $0x42
  8003a5:	68 00 3f 80 00       	push   $0x803f00
  8003aa:	e8 6f 17 00 00       	call   801b1e <_panic>

008003af <diskaddr>:
{
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
  8003b2:	83 ec 08             	sub    $0x8,%esp
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8003b8:	85 c0                	test   %eax,%eax
  8003ba:	74 19                	je     8003d5 <diskaddr+0x26>
  8003bc:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8003c2:	85 d2                	test   %edx,%edx
  8003c4:	74 05                	je     8003cb <diskaddr+0x1c>
  8003c6:	39 42 04             	cmp    %eax,0x4(%edx)
  8003c9:	76 0a                	jbe    8003d5 <diskaddr+0x26>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  8003cb:	05 00 00 01 00       	add    $0x10000,%eax
  8003d0:	c1 e0 0c             	shl    $0xc,%eax
}
  8003d3:	c9                   	leave  
  8003d4:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  8003d5:	50                   	push   %eax
  8003d6:	68 70 3e 80 00       	push   $0x803e70
  8003db:	6a 09                	push   $0x9
  8003dd:	68 00 3f 80 00       	push   $0x803f00
  8003e2:	e8 37 17 00 00       	call   801b1e <_panic>

008003e7 <va_is_mapped>:
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  8003ed:	89 d0                	mov    %edx,%eax
  8003ef:	c1 e8 16             	shr    $0x16,%eax
  8003f2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  8003f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fe:	f6 c1 01             	test   $0x1,%cl
  800401:	74 0d                	je     800410 <va_is_mapped+0x29>
  800403:	c1 ea 0c             	shr    $0xc,%edx
  800406:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80040d:	83 e0 01             	and    $0x1,%eax
  800410:	83 e0 01             	and    $0x1,%eax
}
  800413:	5d                   	pop    %ebp
  800414:	c3                   	ret    

00800415 <va_is_dirty>:
{
  800415:	55                   	push   %ebp
  800416:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  800418:	8b 45 08             	mov    0x8(%ebp),%eax
  80041b:	c1 e8 0c             	shr    $0xc,%eax
  80041e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800425:	c1 e8 06             	shr    $0x6,%eax
  800428:	83 e0 01             	and    $0x1,%eax
}
  80042b:	5d                   	pop    %ebp
  80042c:	c3                   	ret    

0080042d <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	56                   	push   %esi
  800431:	53                   	push   %ebx
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800435:	8d b0 00 00 00 f0    	lea    -0x10000000(%eax),%esi

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80043b:	81 fe ff ff ff bf    	cmp    $0xbfffffff,%esi
  800441:	77 1e                	ja     800461 <flush_block+0x34>
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	//panic("flush_block not implemented");
  int r;
  addr = (void*)ROUNDDOWN(addr, PGSIZE);
  800443:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800448:	89 c3                	mov    %eax,%ebx
  if (va_is_mapped(addr) && va_is_dirty(addr)) {
  80044a:	83 ec 0c             	sub    $0xc,%esp
  80044d:	50                   	push   %eax
  80044e:	e8 94 ff ff ff       	call   8003e7 <va_is_mapped>
  800453:	83 c4 10             	add    $0x10,%esp
  800456:	84 c0                	test   %al,%al
  800458:	75 19                	jne    800473 <flush_block+0x46>
    if (r < 0) panic("flush_block: ide_write failed %e", r);

    r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL); 
    if (r < 0) panic("flush_block: sys_page_map failed %e", r);
  }
}
  80045a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80045d:	5b                   	pop    %ebx
  80045e:	5e                   	pop    %esi
  80045f:	5d                   	pop    %ebp
  800460:	c3                   	ret    
		panic("flush_block of bad va %08x", addr);
  800461:	50                   	push   %eax
  800462:	68 3f 3f 80 00       	push   $0x803f3f
  800467:	6a 52                	push   $0x52
  800469:	68 00 3f 80 00       	push   $0x803f00
  80046e:	e8 ab 16 00 00       	call   801b1e <_panic>
  if (va_is_mapped(addr) && va_is_dirty(addr)) {
  800473:	83 ec 0c             	sub    $0xc,%esp
  800476:	53                   	push   %ebx
  800477:	e8 99 ff ff ff       	call   800415 <va_is_dirty>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	84 c0                	test   %al,%al
  800481:	74 d7                	je     80045a <flush_block+0x2d>
    r = ide_write(blockno*8, addr, 8);
  800483:	83 ec 04             	sub    $0x4,%esp
  800486:	6a 08                	push   $0x8
  800488:	53                   	push   %ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800489:	c1 ee 0c             	shr    $0xc,%esi
    r = ide_write(blockno*8, addr, 8);
  80048c:	c1 e6 03             	shl    $0x3,%esi
  80048f:	56                   	push   %esi
  800490:	e8 1d fd ff ff       	call   8001b2 <ide_write>
    if (r < 0) panic("flush_block: ide_write failed %e", r);
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	85 c0                	test   %eax,%eax
  80049a:	78 39                	js     8004d5 <flush_block+0xa8>
    r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL); 
  80049c:	89 d8                	mov    %ebx,%eax
  80049e:	c1 e8 0c             	shr    $0xc,%eax
  8004a1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8004a8:	83 ec 0c             	sub    $0xc,%esp
  8004ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8004b0:	50                   	push   %eax
  8004b1:	53                   	push   %ebx
  8004b2:	6a 00                	push   $0x0
  8004b4:	53                   	push   %ebx
  8004b5:	6a 00                	push   $0x0
  8004b7:	e8 4e 21 00 00       	call   80260a <sys_page_map>
    if (r < 0) panic("flush_block: sys_page_map failed %e", r);
  8004bc:	83 c4 20             	add    $0x20,%esp
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	79 97                	jns    80045a <flush_block+0x2d>
  8004c3:	50                   	push   %eax
  8004c4:	68 b8 3e 80 00       	push   $0x803eb8
  8004c9:	6a 5d                	push   $0x5d
  8004cb:	68 00 3f 80 00       	push   $0x803f00
  8004d0:	e8 49 16 00 00       	call   801b1e <_panic>
    if (r < 0) panic("flush_block: ide_write failed %e", r);
  8004d5:	50                   	push   %eax
  8004d6:	68 94 3e 80 00       	push   $0x803e94
  8004db:	6a 5a                	push   $0x5a
  8004dd:	68 00 3f 80 00       	push   $0x803f00
  8004e2:	e8 37 16 00 00       	call   801b1e <_panic>

008004e7 <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	53                   	push   %ebx
  8004eb:	81 ec 20 02 00 00    	sub    $0x220,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  8004f1:	68 7a 02 80 00       	push   $0x80027a
  8004f6:	e8 dc 22 00 00       	call   8027d7 <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  8004fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800502:	e8 a8 fe ff ff       	call   8003af <diskaddr>
  800507:	83 c4 0c             	add    $0xc,%esp
  80050a:	68 08 01 00 00       	push   $0x108
  80050f:	50                   	push   %eax
  800510:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  800516:	50                   	push   %eax
  800517:	e8 47 1e 00 00       	call   802363 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  80051c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800523:	e8 87 fe ff ff       	call   8003af <diskaddr>
  800528:	83 c4 08             	add    $0x8,%esp
  80052b:	68 5a 3f 80 00       	push   $0x803f5a
  800530:	50                   	push   %eax
  800531:	e8 9f 1c 00 00       	call   8021d5 <strcpy>
	flush_block(diskaddr(1));
  800536:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80053d:	e8 6d fe ff ff       	call   8003af <diskaddr>
  800542:	89 04 24             	mov    %eax,(%esp)
  800545:	e8 e3 fe ff ff       	call   80042d <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  80054a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800551:	e8 59 fe ff ff       	call   8003af <diskaddr>
  800556:	89 04 24             	mov    %eax,(%esp)
  800559:	e8 89 fe ff ff       	call   8003e7 <va_is_mapped>
  80055e:	83 c4 10             	add    $0x10,%esp
  800561:	84 c0                	test   %al,%al
  800563:	0f 84 d1 01 00 00    	je     80073a <bc_init+0x253>
	assert(!va_is_dirty(diskaddr(1)));
  800569:	83 ec 0c             	sub    $0xc,%esp
  80056c:	6a 01                	push   $0x1
  80056e:	e8 3c fe ff ff       	call   8003af <diskaddr>
  800573:	89 04 24             	mov    %eax,(%esp)
  800576:	e8 9a fe ff ff       	call   800415 <va_is_dirty>
  80057b:	83 c4 10             	add    $0x10,%esp
  80057e:	84 c0                	test   %al,%al
  800580:	0f 85 ca 01 00 00    	jne    800750 <bc_init+0x269>
	sys_page_unmap(0, diskaddr(1));
  800586:	83 ec 0c             	sub    $0xc,%esp
  800589:	6a 01                	push   $0x1
  80058b:	e8 1f fe ff ff       	call   8003af <diskaddr>
  800590:	83 c4 08             	add    $0x8,%esp
  800593:	50                   	push   %eax
  800594:	6a 00                	push   $0x0
  800596:	e8 b1 20 00 00       	call   80264c <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  80059b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005a2:	e8 08 fe ff ff       	call   8003af <diskaddr>
  8005a7:	89 04 24             	mov    %eax,(%esp)
  8005aa:	e8 38 fe ff ff       	call   8003e7 <va_is_mapped>
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	84 c0                	test   %al,%al
  8005b4:	0f 85 ac 01 00 00    	jne    800766 <bc_init+0x27f>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8005ba:	83 ec 0c             	sub    $0xc,%esp
  8005bd:	6a 01                	push   $0x1
  8005bf:	e8 eb fd ff ff       	call   8003af <diskaddr>
  8005c4:	83 c4 08             	add    $0x8,%esp
  8005c7:	68 5a 3f 80 00       	push   $0x803f5a
  8005cc:	50                   	push   %eax
  8005cd:	e8 ae 1c 00 00       	call   802280 <strcmp>
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	85 c0                	test   %eax,%eax
  8005d7:	0f 85 9f 01 00 00    	jne    80077c <bc_init+0x295>
	memmove(diskaddr(1), &backup, sizeof backup);
  8005dd:	83 ec 0c             	sub    $0xc,%esp
  8005e0:	6a 01                	push   $0x1
  8005e2:	e8 c8 fd ff ff       	call   8003af <diskaddr>
  8005e7:	83 c4 0c             	add    $0xc,%esp
  8005ea:	68 08 01 00 00       	push   $0x108
  8005ef:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  8005f5:	53                   	push   %ebx
  8005f6:	50                   	push   %eax
  8005f7:	e8 67 1d 00 00       	call   802363 <memmove>
	flush_block(diskaddr(1));
  8005fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800603:	e8 a7 fd ff ff       	call   8003af <diskaddr>
  800608:	89 04 24             	mov    %eax,(%esp)
  80060b:	e8 1d fe ff ff       	call   80042d <flush_block>
	memmove(&backup, diskaddr(1), sizeof backup);
  800610:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800617:	e8 93 fd ff ff       	call   8003af <diskaddr>
  80061c:	83 c4 0c             	add    $0xc,%esp
  80061f:	68 08 01 00 00       	push   $0x108
  800624:	50                   	push   %eax
  800625:	53                   	push   %ebx
  800626:	e8 38 1d 00 00       	call   802363 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  80062b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800632:	e8 78 fd ff ff       	call   8003af <diskaddr>
  800637:	83 c4 08             	add    $0x8,%esp
  80063a:	68 5a 3f 80 00       	push   $0x803f5a
  80063f:	50                   	push   %eax
  800640:	e8 90 1b 00 00       	call   8021d5 <strcpy>
	flush_block(diskaddr(1) + 20);
  800645:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80064c:	e8 5e fd ff ff       	call   8003af <diskaddr>
  800651:	83 c0 14             	add    $0x14,%eax
  800654:	89 04 24             	mov    %eax,(%esp)
  800657:	e8 d1 fd ff ff       	call   80042d <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  80065c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800663:	e8 47 fd ff ff       	call   8003af <diskaddr>
  800668:	89 04 24             	mov    %eax,(%esp)
  80066b:	e8 77 fd ff ff       	call   8003e7 <va_is_mapped>
  800670:	83 c4 10             	add    $0x10,%esp
  800673:	84 c0                	test   %al,%al
  800675:	0f 84 17 01 00 00    	je     800792 <bc_init+0x2ab>
	sys_page_unmap(0, diskaddr(1));
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	6a 01                	push   $0x1
  800680:	e8 2a fd ff ff       	call   8003af <diskaddr>
  800685:	83 c4 08             	add    $0x8,%esp
  800688:	50                   	push   %eax
  800689:	6a 00                	push   $0x0
  80068b:	e8 bc 1f 00 00       	call   80264c <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800690:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800697:	e8 13 fd ff ff       	call   8003af <diskaddr>
  80069c:	89 04 24             	mov    %eax,(%esp)
  80069f:	e8 43 fd ff ff       	call   8003e7 <va_is_mapped>
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	84 c0                	test   %al,%al
  8006a9:	0f 85 fc 00 00 00    	jne    8007ab <bc_init+0x2c4>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006af:	83 ec 0c             	sub    $0xc,%esp
  8006b2:	6a 01                	push   $0x1
  8006b4:	e8 f6 fc ff ff       	call   8003af <diskaddr>
  8006b9:	83 c4 08             	add    $0x8,%esp
  8006bc:	68 5a 3f 80 00       	push   $0x803f5a
  8006c1:	50                   	push   %eax
  8006c2:	e8 b9 1b 00 00       	call   802280 <strcmp>
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	85 c0                	test   %eax,%eax
  8006cc:	0f 85 f2 00 00 00    	jne    8007c4 <bc_init+0x2dd>
	memmove(diskaddr(1), &backup, sizeof backup);
  8006d2:	83 ec 0c             	sub    $0xc,%esp
  8006d5:	6a 01                	push   $0x1
  8006d7:	e8 d3 fc ff ff       	call   8003af <diskaddr>
  8006dc:	83 c4 0c             	add    $0xc,%esp
  8006df:	68 08 01 00 00       	push   $0x108
  8006e4:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  8006ea:	52                   	push   %edx
  8006eb:	50                   	push   %eax
  8006ec:	e8 72 1c 00 00       	call   802363 <memmove>
	flush_block(diskaddr(1));
  8006f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006f8:	e8 b2 fc ff ff       	call   8003af <diskaddr>
  8006fd:	89 04 24             	mov    %eax,(%esp)
  800700:	e8 28 fd ff ff       	call   80042d <flush_block>
	cprintf("block cache is good\n");
  800705:	c7 04 24 96 3f 80 00 	movl   $0x803f96,(%esp)
  80070c:	e8 e8 14 00 00       	call   801bf9 <cprintf>
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800711:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800718:	e8 92 fc ff ff       	call   8003af <diskaddr>
  80071d:	83 c4 0c             	add    $0xc,%esp
  800720:	68 08 01 00 00       	push   $0x108
  800725:	50                   	push   %eax
  800726:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072c:	50                   	push   %eax
  80072d:	e8 31 1c 00 00       	call   802363 <memmove>
}
  800732:	83 c4 10             	add    $0x10,%esp
  800735:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800738:	c9                   	leave  
  800739:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  80073a:	68 7c 3f 80 00       	push   $0x803f7c
  80073f:	68 bd 3d 80 00       	push   $0x803dbd
  800744:	6a 6e                	push   $0x6e
  800746:	68 00 3f 80 00       	push   $0x803f00
  80074b:	e8 ce 13 00 00       	call   801b1e <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  800750:	68 61 3f 80 00       	push   $0x803f61
  800755:	68 bd 3d 80 00       	push   $0x803dbd
  80075a:	6a 6f                	push   $0x6f
  80075c:	68 00 3f 80 00       	push   $0x803f00
  800761:	e8 b8 13 00 00       	call   801b1e <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800766:	68 7b 3f 80 00       	push   $0x803f7b
  80076b:	68 bd 3d 80 00       	push   $0x803dbd
  800770:	6a 73                	push   $0x73
  800772:	68 00 3f 80 00       	push   $0x803f00
  800777:	e8 a2 13 00 00       	call   801b1e <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80077c:	68 dc 3e 80 00       	push   $0x803edc
  800781:	68 bd 3d 80 00       	push   $0x803dbd
  800786:	6a 76                	push   $0x76
  800788:	68 00 3f 80 00       	push   $0x803f00
  80078d:	e8 8c 13 00 00       	call   801b1e <_panic>
	assert(va_is_mapped(diskaddr(1)));
  800792:	68 7c 3f 80 00       	push   $0x803f7c
  800797:	68 bd 3d 80 00       	push   $0x803dbd
  80079c:	68 87 00 00 00       	push   $0x87
  8007a1:	68 00 3f 80 00       	push   $0x803f00
  8007a6:	e8 73 13 00 00       	call   801b1e <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  8007ab:	68 7b 3f 80 00       	push   $0x803f7b
  8007b0:	68 bd 3d 80 00       	push   $0x803dbd
  8007b5:	68 8f 00 00 00       	push   $0x8f
  8007ba:	68 00 3f 80 00       	push   $0x803f00
  8007bf:	e8 5a 13 00 00       	call   801b1e <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8007c4:	68 dc 3e 80 00       	push   $0x803edc
  8007c9:	68 bd 3d 80 00       	push   $0x803dbd
  8007ce:	68 92 00 00 00       	push   $0x92
  8007d3:	68 00 3f 80 00       	push   $0x803f00
  8007d8:	e8 41 13 00 00       	call   801b1e <_panic>

008007dd <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  8007e3:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8007e8:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8007ee:	75 1b                	jne    80080b <check_super+0x2e>
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  8007f0:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  8007f7:	77 26                	ja     80081f <check_super+0x42>
		panic("file system is too large");

	cprintf("superblock is good\n");
  8007f9:	83 ec 0c             	sub    $0xc,%esp
  8007fc:	68 e9 3f 80 00       	push   $0x803fe9
  800801:	e8 f3 13 00 00       	call   801bf9 <cprintf>
}
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	c9                   	leave  
  80080a:	c3                   	ret    
		panic("bad file system magic number");
  80080b:	83 ec 04             	sub    $0x4,%esp
  80080e:	68 ab 3f 80 00       	push   $0x803fab
  800813:	6a 0f                	push   $0xf
  800815:	68 c8 3f 80 00       	push   $0x803fc8
  80081a:	e8 ff 12 00 00       	call   801b1e <_panic>
		panic("file system is too large");
  80081f:	83 ec 04             	sub    $0x4,%esp
  800822:	68 d0 3f 80 00       	push   $0x803fd0
  800827:	6a 12                	push   $0x12
  800829:	68 c8 3f 80 00       	push   $0x803fc8
  80082e:	e8 eb 12 00 00       	call   801b1e <_panic>

00800833 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	53                   	push   %ebx
  800837:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  80083a:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  800840:	85 d2                	test   %edx,%edx
  800842:	74 25                	je     800869 <block_is_free+0x36>
		return 0;
  800844:	b8 00 00 00 00       	mov    $0x0,%eax
	if (super == 0 || blockno >= super->s_nblocks)
  800849:	39 4a 04             	cmp    %ecx,0x4(%edx)
  80084c:	76 18                	jbe    800866 <block_is_free+0x33>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  80084e:	89 cb                	mov    %ecx,%ebx
  800850:	c1 eb 05             	shr    $0x5,%ebx
  800853:	b8 01 00 00 00       	mov    $0x1,%eax
  800858:	d3 e0                	shl    %cl,%eax
  80085a:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  800860:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  800863:	0f 95 c0             	setne  %al
		return 1;
	return 0;
}
  800866:	5b                   	pop    %ebx
  800867:	5d                   	pop    %ebp
  800868:	c3                   	ret    
		return 0;
  800869:	b8 00 00 00 00       	mov    $0x0,%eax
  80086e:	eb f6                	jmp    800866 <block_is_free+0x33>

00800870 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	53                   	push   %ebx
  800874:	83 ec 04             	sub    $0x4,%esp
  800877:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  80087a:	85 c9                	test   %ecx,%ecx
  80087c:	74 1a                	je     800898 <free_block+0x28>
		panic("attempt to free zero block");
	bitmap[blockno/32] |= 1<<(blockno%32);
  80087e:	89 cb                	mov    %ecx,%ebx
  800880:	c1 eb 05             	shr    $0x5,%ebx
  800883:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  800889:	b8 01 00 00 00       	mov    $0x1,%eax
  80088e:	d3 e0                	shl    %cl,%eax
  800890:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  800893:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800896:	c9                   	leave  
  800897:	c3                   	ret    
		panic("attempt to free zero block");
  800898:	83 ec 04             	sub    $0x4,%esp
  80089b:	68 fd 3f 80 00       	push   $0x803ffd
  8008a0:	6a 2d                	push   $0x2d
  8008a2:	68 c8 3f 80 00       	push   $0x803fc8
  8008a7:	e8 72 12 00 00       	call   801b1e <_panic>

008008ac <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	56                   	push   %esi
  8008b0:	53                   	push   %ebx
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	//panic("alloc_block not implemented");
  for (int i = 3; i < super->s_nblocks; i++) {
  8008b1:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8008b6:	8b 70 04             	mov    0x4(%eax),%esi
  8008b9:	bb 03 00 00 00       	mov    $0x3,%ebx
  8008be:	39 de                	cmp    %ebx,%esi
  8008c0:	76 58                	jbe    80091a <alloc_block+0x6e>
    if (block_is_free(i)) {
  8008c2:	83 ec 0c             	sub    $0xc,%esp
  8008c5:	53                   	push   %ebx
  8008c6:	e8 68 ff ff ff       	call   800833 <block_is_free>
  8008cb:	83 c4 10             	add    $0x10,%esp
  8008ce:	84 c0                	test   %al,%al
  8008d0:	75 05                	jne    8008d7 <alloc_block+0x2b>
  for (int i = 3; i < super->s_nblocks; i++) {
  8008d2:	83 c3 01             	add    $0x1,%ebx
  8008d5:	eb e7                	jmp    8008be <alloc_block+0x12>
	    bitmap[i/32] &= ~(1 << (i%32)); 
  8008d7:	8d 43 1f             	lea    0x1f(%ebx),%eax
  8008da:	85 db                	test   %ebx,%ebx
  8008dc:	0f 49 c3             	cmovns %ebx,%eax
  8008df:	c1 f8 05             	sar    $0x5,%eax
  8008e2:	c1 e0 02             	shl    $0x2,%eax
  8008e5:	89 c2                	mov    %eax,%edx
  8008e7:	03 15 08 a0 80 00    	add    0x80a008,%edx
  8008ed:	89 de                	mov    %ebx,%esi
  8008ef:	c1 fe 1f             	sar    $0x1f,%esi
  8008f2:	c1 ee 1b             	shr    $0x1b,%esi
  8008f5:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
  8008f8:	83 e1 1f             	and    $0x1f,%ecx
  8008fb:	29 f1                	sub    %esi,%ecx
  8008fd:	be fe ff ff ff       	mov    $0xfffffffe,%esi
  800902:	d3 c6                	rol    %cl,%esi
  800904:	21 32                	and    %esi,(%edx)
      flush_block(&bitmap[i/32]);
  800906:	83 ec 0c             	sub    $0xc,%esp
  800909:	03 05 08 a0 80 00    	add    0x80a008,%eax
  80090f:	50                   	push   %eax
  800910:	e8 18 fb ff ff       	call   80042d <flush_block>
      return i;
  800915:	83 c4 10             	add    $0x10,%esp
  800918:	eb 05                	jmp    80091f <alloc_block+0x73>
    }
  }
	return -E_NO_DISK;
  80091a:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
}
  80091f:	89 d8                	mov    %ebx,%eax
  800921:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800924:	5b                   	pop    %ebx
  800925:	5e                   	pop    %esi
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	57                   	push   %edi
  80092c:	56                   	push   %esi
  80092d:	53                   	push   %ebx
  80092e:	83 ec 1c             	sub    $0x1c,%esp
  800931:	8b 7d 08             	mov    0x8(%ebp),%edi
       // LAB 5: Your code here.
       //panic("file_block_walk not implemented");
  int r;

  if (filebno >= NDIRECT + NINDIRECT) return -E_INVAL;
  800934:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  80093a:	0f 87 86 00 00 00    	ja     8009c6 <file_block_walk+0x9e>
  if (filebno >= NDIRECT){
  800940:	83 fa 09             	cmp    $0x9,%edx
  800943:	76 6b                	jbe    8009b0 <file_block_walk+0x88>
  800945:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800948:	89 d3                	mov    %edx,%ebx
  80094a:	89 c6                	mov    %eax,%esi
    if (f->f_indirect == 0 && alloc) {
  80094c:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  800952:	85 c0                	test   %eax,%eax
  800954:	75 06                	jne    80095c <file_block_walk+0x34>
  800956:	89 f9                	mov    %edi,%ecx
  800958:	84 c9                	test   %cl,%cl
  80095a:	75 25                	jne    800981 <file_block_walk+0x59>
      r = alloc_block();
      if (r < 0) return -E_NO_DISK;
      memset(diskaddr(r), 0, BLKSIZE);
      f->f_indirect = r;
    } else if (f->f_indirect == 0) return -E_NOT_FOUND;
  80095c:	85 c0                	test   %eax,%eax
  80095e:	74 74                	je     8009d4 <file_block_walk+0xac>

    *ppdiskbno = ((uint32_t*)diskaddr(f->f_indirect)) + (filebno-NDIRECT);
  800960:	83 ec 0c             	sub    $0xc,%esp
  800963:	ff b6 b0 00 00 00    	pushl  0xb0(%esi)
  800969:	e8 41 fa ff ff       	call   8003af <diskaddr>
  80096e:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  800972:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800975:	89 03                	mov    %eax,(%ebx)
    return 0;
  800977:	83 c4 10             	add    $0x10,%esp
  80097a:	b8 00 00 00 00       	mov    $0x0,%eax
  80097f:	eb 3d                	jmp    8009be <file_block_walk+0x96>
      r = alloc_block();
  800981:	e8 26 ff ff ff       	call   8008ac <alloc_block>
  800986:	89 c7                	mov    %eax,%edi
      if (r < 0) return -E_NO_DISK;
  800988:	85 c0                	test   %eax,%eax
  80098a:	78 41                	js     8009cd <file_block_walk+0xa5>
      memset(diskaddr(r), 0, BLKSIZE);
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 1a fa ff ff       	call   8003af <diskaddr>
  800995:	83 c4 0c             	add    $0xc,%esp
  800998:	68 00 10 00 00       	push   $0x1000
  80099d:	6a 00                	push   $0x0
  80099f:	50                   	push   %eax
  8009a0:	e8 76 19 00 00       	call   80231b <memset>
      f->f_indirect = r;
  8009a5:	89 be b0 00 00 00    	mov    %edi,0xb0(%esi)
  8009ab:	83 c4 10             	add    $0x10,%esp
  8009ae:	eb b0                	jmp    800960 <file_block_walk+0x38>
  }

  *ppdiskbno = &(f->f_direct[filebno]);
  8009b0:	8d 84 90 88 00 00 00 	lea    0x88(%eax,%edx,4),%eax
  8009b7:	89 01                	mov    %eax,(%ecx)
  return 0;
  8009b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009c1:	5b                   	pop    %ebx
  8009c2:	5e                   	pop    %esi
  8009c3:	5f                   	pop    %edi
  8009c4:	5d                   	pop    %ebp
  8009c5:	c3                   	ret    
  if (filebno >= NDIRECT + NINDIRECT) return -E_INVAL;
  8009c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009cb:	eb f1                	jmp    8009be <file_block_walk+0x96>
      if (r < 0) return -E_NO_DISK;
  8009cd:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8009d2:	eb ea                	jmp    8009be <file_block_walk+0x96>
    } else if (f->f_indirect == 0) return -E_NOT_FOUND;
  8009d4:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8009d9:	eb e3                	jmp    8009be <file_block_walk+0x96>

008009db <check_bitmap>:
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	56                   	push   %esi
  8009df:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8009e0:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8009e5:	8b 70 04             	mov    0x4(%eax),%esi
  8009e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009ed:	89 d8                	mov    %ebx,%eax
  8009ef:	c1 e0 0f             	shl    $0xf,%eax
  8009f2:	39 c6                	cmp    %eax,%esi
  8009f4:	76 2e                	jbe    800a24 <check_bitmap+0x49>
		assert(!block_is_free(2+i));
  8009f6:	83 ec 0c             	sub    $0xc,%esp
  8009f9:	8d 43 02             	lea    0x2(%ebx),%eax
  8009fc:	50                   	push   %eax
  8009fd:	e8 31 fe ff ff       	call   800833 <block_is_free>
  800a02:	83 c4 10             	add    $0x10,%esp
  800a05:	84 c0                	test   %al,%al
  800a07:	75 05                	jne    800a0e <check_bitmap+0x33>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800a09:	83 c3 01             	add    $0x1,%ebx
  800a0c:	eb df                	jmp    8009ed <check_bitmap+0x12>
		assert(!block_is_free(2+i));
  800a0e:	68 18 40 80 00       	push   $0x804018
  800a13:	68 bd 3d 80 00       	push   $0x803dbd
  800a18:	6a 57                	push   $0x57
  800a1a:	68 c8 3f 80 00       	push   $0x803fc8
  800a1f:	e8 fa 10 00 00       	call   801b1e <_panic>
	assert(!block_is_free(0));
  800a24:	83 ec 0c             	sub    $0xc,%esp
  800a27:	6a 00                	push   $0x0
  800a29:	e8 05 fe ff ff       	call   800833 <block_is_free>
  800a2e:	83 c4 10             	add    $0x10,%esp
  800a31:	84 c0                	test   %al,%al
  800a33:	75 28                	jne    800a5d <check_bitmap+0x82>
	assert(!block_is_free(1));
  800a35:	83 ec 0c             	sub    $0xc,%esp
  800a38:	6a 01                	push   $0x1
  800a3a:	e8 f4 fd ff ff       	call   800833 <block_is_free>
  800a3f:	83 c4 10             	add    $0x10,%esp
  800a42:	84 c0                	test   %al,%al
  800a44:	75 2d                	jne    800a73 <check_bitmap+0x98>
	cprintf("bitmap is good\n");
  800a46:	83 ec 0c             	sub    $0xc,%esp
  800a49:	68 50 40 80 00       	push   $0x804050
  800a4e:	e8 a6 11 00 00       	call   801bf9 <cprintf>
}
  800a53:	83 c4 10             	add    $0x10,%esp
  800a56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a59:	5b                   	pop    %ebx
  800a5a:	5e                   	pop    %esi
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    
	assert(!block_is_free(0));
  800a5d:	68 2c 40 80 00       	push   $0x80402c
  800a62:	68 bd 3d 80 00       	push   $0x803dbd
  800a67:	6a 5a                	push   $0x5a
  800a69:	68 c8 3f 80 00       	push   $0x803fc8
  800a6e:	e8 ab 10 00 00       	call   801b1e <_panic>
	assert(!block_is_free(1));
  800a73:	68 3e 40 80 00       	push   $0x80403e
  800a78:	68 bd 3d 80 00       	push   $0x803dbd
  800a7d:	6a 5b                	push   $0x5b
  800a7f:	68 c8 3f 80 00       	push   $0x803fc8
  800a84:	e8 95 10 00 00       	call   801b1e <_panic>

00800a89 <fs_init>:
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800a8f:	e8 cb f5 ff ff       	call   80005f <ide_probe_disk1>
  800a94:	84 c0                	test   %al,%al
  800a96:	74 41                	je     800ad9 <fs_init+0x50>
		ide_set_disk(1);
  800a98:	83 ec 0c             	sub    $0xc,%esp
  800a9b:	6a 01                	push   $0x1
  800a9d:	e8 1f f6 ff ff       	call   8000c1 <ide_set_disk>
  800aa2:	83 c4 10             	add    $0x10,%esp
	bc_init();
  800aa5:	e8 3d fa ff ff       	call   8004e7 <bc_init>
	super = diskaddr(1);
  800aaa:	83 ec 0c             	sub    $0xc,%esp
  800aad:	6a 01                	push   $0x1
  800aaf:	e8 fb f8 ff ff       	call   8003af <diskaddr>
  800ab4:	a3 0c a0 80 00       	mov    %eax,0x80a00c
	check_super();
  800ab9:	e8 1f fd ff ff       	call   8007dd <check_super>
	bitmap = diskaddr(2);
  800abe:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800ac5:	e8 e5 f8 ff ff       	call   8003af <diskaddr>
  800aca:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_bitmap();
  800acf:	e8 07 ff ff ff       	call   8009db <check_bitmap>
}
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    
		ide_set_disk(0);
  800ad9:	83 ec 0c             	sub    $0xc,%esp
  800adc:	6a 00                	push   $0x0
  800ade:	e8 de f5 ff ff       	call   8000c1 <ide_set_disk>
  800ae3:	83 c4 10             	add    $0x10,%esp
  800ae6:	eb bd                	jmp    800aa5 <fs_init+0x1c>

00800ae8 <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	83 ec 24             	sub    $0x24,%esp
       // LAB 5: Your code here.
       //panic("file_get_block not implemented");
  uint32_t *pdiskbno; 
  int r;

  r = file_block_walk(f, filebno, &pdiskbno, true);
  800aee:	6a 01                	push   $0x1
  800af0:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	e8 2a fe ff ff       	call   800928 <file_block_walk>
  if (r < 0) return r;
  800afe:	83 c4 10             	add    $0x10,%esp
  800b01:	85 c0                	test   %eax,%eax
  800b03:	78 30                	js     800b35 <file_get_block+0x4d>

  if (*pdiskbno == 0) {
  800b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b08:	83 38 00             	cmpl   $0x0,(%eax)
  800b0b:	75 0e                	jne    800b1b <file_get_block+0x33>
    r = alloc_block();
  800b0d:	e8 9a fd ff ff       	call   8008ac <alloc_block>
    if (r < 0) return -E_NO_DISK;
  800b12:	85 c0                	test   %eax,%eax
  800b14:	78 21                	js     800b37 <file_get_block+0x4f>

    *pdiskbno = r;
  800b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b19:	89 02                	mov    %eax,(%edx)
  }

  //BUG:说明取好变量名的重要性
  //*blk = (char*)diskaddr(r);
  *blk = (char*)diskaddr(*pdiskbno);
  800b1b:	83 ec 0c             	sub    $0xc,%esp
  800b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b21:	ff 30                	pushl  (%eax)
  800b23:	e8 87 f8 ff ff       	call   8003af <diskaddr>
  800b28:	8b 55 10             	mov    0x10(%ebp),%edx
  800b2b:	89 02                	mov    %eax,(%edx)
  return 0;
  800b2d:	83 c4 10             	add    $0x10,%esp
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b35:	c9                   	leave  
  800b36:	c3                   	ret    
    if (r < 0) return -E_NO_DISK;
  800b37:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800b3c:	eb f7                	jmp    800b35 <file_get_block+0x4d>

00800b3e <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	57                   	push   %edi
  800b42:	56                   	push   %esi
  800b43:	53                   	push   %ebx
  800b44:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  800b4a:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800b50:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
  800b56:	eb 03                	jmp    800b5b <walk_path+0x1d>
		p++;
  800b58:	83 c0 01             	add    $0x1,%eax
	while (*p == '/')
  800b5b:	80 38 2f             	cmpb   $0x2f,(%eax)
  800b5e:	74 f8                	je     800b58 <walk_path+0x1a>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800b60:	8b 0d 0c a0 80 00    	mov    0x80a00c,%ecx
  800b66:	83 c1 08             	add    $0x8,%ecx
  800b69:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;
  800b6f:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800b76:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800b7c:	85 c9                	test   %ecx,%ecx
  800b7e:	74 06                	je     800b86 <walk_path+0x48>
		*pdir = 0;
  800b80:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800b86:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800b8c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	dir = 0;
  800b92:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0') {
  800b97:	e9 c6 01 00 00       	jmp    800d62 <walk_path+0x224>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800b9c:	83 c6 01             	add    $0x1,%esi
		while (*path != '/' && *path != '\0')
  800b9f:	0f b6 16             	movzbl (%esi),%edx
  800ba2:	80 fa 2f             	cmp    $0x2f,%dl
  800ba5:	74 04                	je     800bab <walk_path+0x6d>
  800ba7:	84 d2                	test   %dl,%dl
  800ba9:	75 f1                	jne    800b9c <walk_path+0x5e>
		if (path - p >= MAXNAMELEN)
  800bab:	89 f3                	mov    %esi,%ebx
  800bad:	29 c3                	sub    %eax,%ebx
  800baf:	83 fb 7f             	cmp    $0x7f,%ebx
  800bb2:	0f 8f 72 01 00 00    	jg     800d2a <walk_path+0x1ec>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800bb8:	83 ec 04             	sub    $0x4,%esp
  800bbb:	53                   	push   %ebx
  800bbc:	50                   	push   %eax
  800bbd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800bc3:	50                   	push   %eax
  800bc4:	e8 9a 17 00 00       	call   802363 <memmove>
		name[path - p] = '\0';
  800bc9:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800bd0:	00 
  800bd1:	83 c4 10             	add    $0x10,%esp
  800bd4:	eb 03                	jmp    800bd9 <walk_path+0x9b>
		p++;
  800bd6:	83 c6 01             	add    $0x1,%esi
	while (*p == '/')
  800bd9:	80 3e 2f             	cmpb   $0x2f,(%esi)
  800bdc:	74 f8                	je     800bd6 <walk_path+0x98>
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800bde:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800be4:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800beb:	0f 85 40 01 00 00    	jne    800d31 <walk_path+0x1f3>
	assert((dir->f_size % BLKSIZE) == 0);
  800bf1:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800bf7:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800bfc:	0f 85 98 00 00 00    	jne    800c9a <walk_path+0x15c>
	nblock = dir->f_size / BLKSIZE;
  800c02:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800c08:	85 c0                	test   %eax,%eax
  800c0a:	0f 48 c2             	cmovs  %edx,%eax
  800c0d:	c1 f8 0c             	sar    $0xc,%eax
  800c10:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	for (i = 0; i < nblock; i++) {
  800c16:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
  800c1d:	00 00 00 
			if (strcmp(f[j].f_name, name) == 0) {
  800c20:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
  800c26:	89 b5 44 ff ff ff    	mov    %esi,-0xbc(%ebp)
	for (i = 0; i < nblock; i++) {
  800c2c:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800c32:	39 8d 48 ff ff ff    	cmp    %ecx,-0xb8(%ebp)
  800c38:	74 79                	je     800cb3 <walk_path+0x175>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800c3a:	83 ec 04             	sub    $0x4,%esp
  800c3d:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800c43:	50                   	push   %eax
  800c44:	ff b5 50 ff ff ff    	pushl  -0xb0(%ebp)
  800c4a:	ff b5 4c ff ff ff    	pushl  -0xb4(%ebp)
  800c50:	e8 93 fe ff ff       	call   800ae8 <file_get_block>
  800c55:	83 c4 10             	add    $0x10,%esp
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	0f 88 d8 00 00 00    	js     800d38 <walk_path+0x1fa>
  800c60:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  800c66:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
			if (strcmp(f[j].f_name, name) == 0) {
  800c6c:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	57                   	push   %edi
  800c76:	53                   	push   %ebx
  800c77:	e8 04 16 00 00       	call   802280 <strcmp>
  800c7c:	83 c4 10             	add    $0x10,%esp
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	0f 84 c1 00 00 00    	je     800d48 <walk_path+0x20a>
  800c87:	81 c3 00 01 00 00    	add    $0x100,%ebx
		for (j = 0; j < BLKFILES; j++)
  800c8d:	39 f3                	cmp    %esi,%ebx
  800c8f:	75 db                	jne    800c6c <walk_path+0x12e>
	for (i = 0; i < nblock; i++) {
  800c91:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  800c98:	eb 92                	jmp    800c2c <walk_path+0xee>
	assert((dir->f_size % BLKSIZE) == 0);
  800c9a:	68 60 40 80 00       	push   $0x804060
  800c9f:	68 bd 3d 80 00       	push   $0x803dbd
  800ca4:	68 d5 00 00 00       	push   $0xd5
  800ca9:	68 c8 3f 80 00       	push   $0x803fc8
  800cae:	e8 6b 0e 00 00       	call   801b1e <_panic>
  800cb3:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800cb9:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
			if (r == -E_NOT_FOUND && *path == '\0') {
  800cbe:	80 3e 00             	cmpb   $0x0,(%esi)
  800cc1:	75 5f                	jne    800d22 <walk_path+0x1e4>
				if (pdir)
  800cc3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cc9:	85 c0                	test   %eax,%eax
  800ccb:	74 08                	je     800cd5 <walk_path+0x197>
					*pdir = dir;
  800ccd:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800cd3:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800cd5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cd9:	74 15                	je     800cf0 <walk_path+0x1b2>
					strcpy(lastelem, name);
  800cdb:	83 ec 08             	sub    $0x8,%esp
  800cde:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800ce4:	50                   	push   %eax
  800ce5:	ff 75 08             	pushl  0x8(%ebp)
  800ce8:	e8 e8 14 00 00       	call   8021d5 <strcpy>
  800ced:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  800cf0:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cf6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			return r;
  800cfc:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d01:	eb 1f                	jmp    800d22 <walk_path+0x1e4>
		}
	}

	if (pdir)
  800d03:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d09:	85 c0                	test   %eax,%eax
  800d0b:	74 02                	je     800d0f <walk_path+0x1d1>
		*pdir = dir;
  800d0d:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800d0f:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d15:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d1b:	89 08                	mov    %ecx,(%eax)
	return 0;
  800d1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    
			return -E_BAD_PATH;
  800d2a:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800d2f:	eb f1                	jmp    800d22 <walk_path+0x1e4>
			return -E_NOT_FOUND;
  800d31:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d36:	eb ea                	jmp    800d22 <walk_path+0x1e4>
  800d38:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
			if (r == -E_NOT_FOUND && *path == '\0') {
  800d3e:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800d41:	75 df                	jne    800d22 <walk_path+0x1e4>
  800d43:	e9 71 ff ff ff       	jmp    800cb9 <walk_path+0x17b>
  800d48:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
  800d4e:	89 f0                	mov    %esi,%eax
  800d50:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
			if (strcmp(f[j].f_name, name) == 0) {
  800d56:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  800d5c:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	while (*path != '\0') {
  800d62:	80 38 00             	cmpb   $0x0,(%eax)
  800d65:	74 9c                	je     800d03 <walk_path+0x1c5>
  800d67:	89 c6                	mov    %eax,%esi
  800d69:	e9 31 fe ff ff       	jmp    800b9f <walk_path+0x61>

00800d6e <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  800d74:	6a 00                	push   $0x0
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	e8 b8 fd ff ff       	call   800b3e <walk_path>
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
  800d8e:	83 ec 2c             	sub    $0x2c,%esp
  800d91:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d94:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d97:	8b 4d 14             	mov    0x14(%ebp),%ecx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (offset >= f->f_size)
  800da8:	39 ca                	cmp    %ecx,%edx
  800daa:	7e 7e                	jle    800e2a <file_read+0xa2>

	count = MIN(count, f->f_size - offset);
  800dac:	29 ca                	sub    %ecx,%edx
  800dae:	39 da                	cmp    %ebx,%edx
  800db0:	89 d8                	mov    %ebx,%eax
  800db2:	0f 46 c2             	cmovbe %edx,%eax
  800db5:	89 45 d0             	mov    %eax,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800db8:	89 cb                	mov    %ecx,%ebx
  800dba:	01 c1                	add    %eax,%ecx
  800dbc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800dbf:	89 de                	mov    %ebx,%esi
  800dc1:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800dc4:	76 61                	jbe    800e27 <file_read+0x9f>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800dc6:	83 ec 04             	sub    $0x4,%esp
  800dc9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800dcc:	50                   	push   %eax
  800dcd:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800dd3:	85 db                	test   %ebx,%ebx
  800dd5:	0f 49 c3             	cmovns %ebx,%eax
  800dd8:	c1 f8 0c             	sar    $0xc,%eax
  800ddb:	50                   	push   %eax
  800ddc:	ff 75 08             	pushl  0x8(%ebp)
  800ddf:	e8 04 fd ff ff       	call   800ae8 <file_get_block>
  800de4:	83 c4 10             	add    $0x10,%esp
  800de7:	85 c0                	test   %eax,%eax
  800de9:	78 3f                	js     800e2a <file_read+0xa2>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800deb:	89 da                	mov    %ebx,%edx
  800ded:	c1 fa 1f             	sar    $0x1f,%edx
  800df0:	c1 ea 14             	shr    $0x14,%edx
  800df3:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800df6:	25 ff 0f 00 00       	and    $0xfff,%eax
  800dfb:	29 d0                	sub    %edx,%eax
  800dfd:	ba 00 10 00 00       	mov    $0x1000,%edx
  800e02:	29 c2                	sub    %eax,%edx
  800e04:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800e07:	29 f1                	sub    %esi,%ecx
  800e09:	89 ce                	mov    %ecx,%esi
  800e0b:	39 ca                	cmp    %ecx,%edx
  800e0d:	0f 46 f2             	cmovbe %edx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	56                   	push   %esi
  800e14:	03 45 e4             	add    -0x1c(%ebp),%eax
  800e17:	50                   	push   %eax
  800e18:	57                   	push   %edi
  800e19:	e8 45 15 00 00       	call   802363 <memmove>
		pos += bn;
  800e1e:	01 f3                	add    %esi,%ebx
		buf += bn;
  800e20:	01 f7                	add    %esi,%edi
  800e22:	83 c4 10             	add    $0x10,%esp
  800e25:	eb 98                	jmp    800dbf <file_read+0x37>
	}

	return count;
  800e27:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2d:	5b                   	pop    %ebx
  800e2e:	5e                   	pop    %esi
  800e2f:	5f                   	pop    %edi
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    

00800e32 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	57                   	push   %edi
  800e36:	56                   	push   %esi
  800e37:	53                   	push   %ebx
  800e38:	83 ec 2c             	sub    $0x2c,%esp
  800e3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800e3e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if (f->f_size > newsize)
  800e41:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  800e47:	39 f8                	cmp    %edi,%eax
  800e49:	7f 1c                	jg     800e67 <file_set_size+0x35>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800e4b:	89 bb 80 00 00 00    	mov    %edi,0x80(%ebx)
	flush_block(f);
  800e51:	83 ec 0c             	sub    $0xc,%esp
  800e54:	53                   	push   %ebx
  800e55:	e8 d3 f5 ff ff       	call   80042d <flush_block>
	return 0;
}
  800e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e62:	5b                   	pop    %ebx
  800e63:	5e                   	pop    %esi
  800e64:	5f                   	pop    %edi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800e67:	8d 90 fe 1f 00 00    	lea    0x1ffe(%eax),%edx
  800e6d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800e72:	0f 48 c2             	cmovs  %edx,%eax
  800e75:	c1 f8 0c             	sar    $0xc,%eax
  800e78:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800e7b:	8d 87 fe 1f 00 00    	lea    0x1ffe(%edi),%eax
  800e81:	89 fa                	mov    %edi,%edx
  800e83:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800e89:	0f 49 c2             	cmovns %edx,%eax
  800e8c:	c1 f8 0c             	sar    $0xc,%eax
  800e8f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800e92:	89 c6                	mov    %eax,%esi
  800e94:	eb 3c                	jmp    800ed2 <file_set_size+0xa0>
	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800e96:	83 7d d0 0a          	cmpl   $0xa,-0x30(%ebp)
  800e9a:	77 af                	ja     800e4b <file_set_size+0x19>
  800e9c:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	74 a5                	je     800e4b <file_set_size+0x19>
		free_block(f->f_indirect);
  800ea6:	83 ec 0c             	sub    $0xc,%esp
  800ea9:	50                   	push   %eax
  800eaa:	e8 c1 f9 ff ff       	call   800870 <free_block>
		f->f_indirect = 0;
  800eaf:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
  800eb6:	00 00 00 
  800eb9:	83 c4 10             	add    $0x10,%esp
  800ebc:	eb 8d                	jmp    800e4b <file_set_size+0x19>
			cprintf("warning: file_free_block: %e", r);
  800ebe:	83 ec 08             	sub    $0x8,%esp
  800ec1:	50                   	push   %eax
  800ec2:	68 7d 40 80 00       	push   $0x80407d
  800ec7:	e8 2d 0d 00 00       	call   801bf9 <cprintf>
  800ecc:	83 c4 10             	add    $0x10,%esp
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800ecf:	83 c6 01             	add    $0x1,%esi
  800ed2:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800ed5:	76 bf                	jbe    800e96 <file_set_size+0x64>
	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800ed7:	83 ec 0c             	sub    $0xc,%esp
  800eda:	6a 00                	push   $0x0
  800edc:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800edf:	89 f2                	mov    %esi,%edx
  800ee1:	89 d8                	mov    %ebx,%eax
  800ee3:	e8 40 fa ff ff       	call   800928 <file_block_walk>
  800ee8:	83 c4 10             	add    $0x10,%esp
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	78 cf                	js     800ebe <file_set_size+0x8c>
	if (*ptr) {
  800eef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ef2:	8b 00                	mov    (%eax),%eax
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	74 d7                	je     800ecf <file_set_size+0x9d>
		free_block(*ptr);
  800ef8:	83 ec 0c             	sub    $0xc,%esp
  800efb:	50                   	push   %eax
  800efc:	e8 6f f9 ff ff       	call   800870 <free_block>
		*ptr = 0;
  800f01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800f0a:	83 c4 10             	add    $0x10,%esp
  800f0d:	eb c0                	jmp    800ecf <file_set_size+0x9d>

00800f0f <file_write>:
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
  800f15:	83 ec 2c             	sub    $0x2c,%esp
  800f18:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f1b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	if (offset + count > f->f_size)
  800f1e:	89 d8                	mov    %ebx,%eax
  800f20:	03 45 10             	add    0x10(%ebp),%eax
  800f23:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800f26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f29:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  800f2f:	77 68                	ja     800f99 <file_write+0x8a>
	for (pos = offset; pos < offset + count; ) {
  800f31:	89 de                	mov    %ebx,%esi
  800f33:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800f36:	76 74                	jbe    800fac <file_write+0x9d>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800f38:	83 ec 04             	sub    $0x4,%esp
  800f3b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f3e:	50                   	push   %eax
  800f3f:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800f45:	85 db                	test   %ebx,%ebx
  800f47:	0f 49 c3             	cmovns %ebx,%eax
  800f4a:	c1 f8 0c             	sar    $0xc,%eax
  800f4d:	50                   	push   %eax
  800f4e:	ff 75 08             	pushl  0x8(%ebp)
  800f51:	e8 92 fb ff ff       	call   800ae8 <file_get_block>
  800f56:	83 c4 10             	add    $0x10,%esp
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	78 52                	js     800faf <file_write+0xa0>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800f5d:	89 da                	mov    %ebx,%edx
  800f5f:	c1 fa 1f             	sar    $0x1f,%edx
  800f62:	c1 ea 14             	shr    $0x14,%edx
  800f65:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800f68:	25 ff 0f 00 00       	and    $0xfff,%eax
  800f6d:	29 d0                	sub    %edx,%eax
  800f6f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800f74:	29 c1                	sub    %eax,%ecx
  800f76:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f79:	29 f2                	sub    %esi,%edx
  800f7b:	39 d1                	cmp    %edx,%ecx
  800f7d:	89 d6                	mov    %edx,%esi
  800f7f:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  800f82:	83 ec 04             	sub    $0x4,%esp
  800f85:	56                   	push   %esi
  800f86:	57                   	push   %edi
  800f87:	03 45 e4             	add    -0x1c(%ebp),%eax
  800f8a:	50                   	push   %eax
  800f8b:	e8 d3 13 00 00       	call   802363 <memmove>
		pos += bn;
  800f90:	01 f3                	add    %esi,%ebx
		buf += bn;
  800f92:	01 f7                	add    %esi,%edi
  800f94:	83 c4 10             	add    $0x10,%esp
  800f97:	eb 98                	jmp    800f31 <file_write+0x22>
		if ((r = file_set_size(f, offset + count)) < 0)
  800f99:	83 ec 08             	sub    $0x8,%esp
  800f9c:	50                   	push   %eax
  800f9d:	51                   	push   %ecx
  800f9e:	e8 8f fe ff ff       	call   800e32 <file_set_size>
  800fa3:	83 c4 10             	add    $0x10,%esp
  800fa6:	85 c0                	test   %eax,%eax
  800fa8:	79 87                	jns    800f31 <file_write+0x22>
  800faa:	eb 03                	jmp    800faf <file_write+0xa0>
	return count;
  800fac:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb2:	5b                   	pop    %ebx
  800fb3:	5e                   	pop    %esi
  800fb4:	5f                   	pop    %edi
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    

00800fb7 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
  800fbc:	83 ec 10             	sub    $0x10,%esp
  800fbf:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800fc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc7:	eb 03                	jmp    800fcc <file_flush+0x15>
  800fc9:	83 c3 01             	add    $0x1,%ebx
  800fcc:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  800fd2:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  800fd8:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  800fde:	85 c9                	test   %ecx,%ecx
  800fe0:	0f 49 c1             	cmovns %ecx,%eax
  800fe3:	c1 f8 0c             	sar    $0xc,%eax
  800fe6:	39 d8                	cmp    %ebx,%eax
  800fe8:	7e 3b                	jle    801025 <file_flush+0x6e>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800fea:	83 ec 0c             	sub    $0xc,%esp
  800fed:	6a 00                	push   $0x0
  800fef:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800ff2:	89 da                	mov    %ebx,%edx
  800ff4:	89 f0                	mov    %esi,%eax
  800ff6:	e8 2d f9 ff ff       	call   800928 <file_block_walk>
  800ffb:	83 c4 10             	add    $0x10,%esp
  800ffe:	85 c0                	test   %eax,%eax
  801000:	78 c7                	js     800fc9 <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  801002:	8b 45 f4             	mov    -0xc(%ebp),%eax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801005:	85 c0                	test   %eax,%eax
  801007:	74 c0                	je     800fc9 <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  801009:	8b 00                	mov    (%eax),%eax
  80100b:	85 c0                	test   %eax,%eax
  80100d:	74 ba                	je     800fc9 <file_flush+0x12>
			continue;
		flush_block(diskaddr(*pdiskbno));
  80100f:	83 ec 0c             	sub    $0xc,%esp
  801012:	50                   	push   %eax
  801013:	e8 97 f3 ff ff       	call   8003af <diskaddr>
  801018:	89 04 24             	mov    %eax,(%esp)
  80101b:	e8 0d f4 ff ff       	call   80042d <flush_block>
  801020:	83 c4 10             	add    $0x10,%esp
  801023:	eb a4                	jmp    800fc9 <file_flush+0x12>
	}
	flush_block(f);
  801025:	83 ec 0c             	sub    $0xc,%esp
  801028:	56                   	push   %esi
  801029:	e8 ff f3 ff ff       	call   80042d <flush_block>
	if (f->f_indirect)
  80102e:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  801034:	83 c4 10             	add    $0x10,%esp
  801037:	85 c0                	test   %eax,%eax
  801039:	75 07                	jne    801042 <file_flush+0x8b>
		flush_block(diskaddr(f->f_indirect));
}
  80103b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5d                   	pop    %ebp
  801041:	c3                   	ret    
		flush_block(diskaddr(f->f_indirect));
  801042:	83 ec 0c             	sub    $0xc,%esp
  801045:	50                   	push   %eax
  801046:	e8 64 f3 ff ff       	call   8003af <diskaddr>
  80104b:	89 04 24             	mov    %eax,(%esp)
  80104e:	e8 da f3 ff ff       	call   80042d <flush_block>
  801053:	83 c4 10             	add    $0x10,%esp
}
  801056:	eb e3                	jmp    80103b <file_flush+0x84>

00801058 <file_create>:
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	57                   	push   %edi
  80105c:	56                   	push   %esi
  80105d:	53                   	push   %ebx
  80105e:	81 ec b8 00 00 00    	sub    $0xb8,%esp
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801064:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  80106a:	50                   	push   %eax
  80106b:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  801071:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	e8 bf fa ff ff       	call   800b3e <walk_path>
  80107f:	83 c4 10             	add    $0x10,%esp
  801082:	85 c0                	test   %eax,%eax
  801084:	0f 84 0d 01 00 00    	je     801197 <file_create+0x13f>
	if (r != -E_NOT_FOUND || dir == 0)
  80108a:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80108d:	0f 85 cc 00 00 00    	jne    80115f <file_create+0x107>
  801093:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
  801099:	85 f6                	test   %esi,%esi
  80109b:	0f 84 be 00 00 00    	je     80115f <file_create+0x107>
	assert((dir->f_size % BLKSIZE) == 0);
  8010a1:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  8010a7:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8010ac:	75 5c                	jne    80110a <file_create+0xb2>
	nblock = dir->f_size / BLKSIZE;
  8010ae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	0f 48 c2             	cmovs  %edx,%eax
  8010b9:	c1 f8 0c             	sar    $0xc,%eax
  8010bc:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
  8010c2:	bb 00 00 00 00       	mov    $0x0,%ebx
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8010c7:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
	for (i = 0; i < nblock; i++) {
  8010cd:	39 9d 54 ff ff ff    	cmp    %ebx,-0xac(%ebp)
  8010d3:	0f 84 8e 00 00 00    	je     801167 <file_create+0x10f>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8010d9:	83 ec 04             	sub    $0x4,%esp
  8010dc:	57                   	push   %edi
  8010dd:	53                   	push   %ebx
  8010de:	56                   	push   %esi
  8010df:	e8 04 fa ff ff       	call   800ae8 <file_get_block>
  8010e4:	83 c4 10             	add    $0x10,%esp
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	78 74                	js     80115f <file_create+0x107>
  8010eb:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8010f1:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
			if (f[j].f_name[0] == '\0') {
  8010f7:	80 38 00             	cmpb   $0x0,(%eax)
  8010fa:	74 27                	je     801123 <file_create+0xcb>
  8010fc:	05 00 01 00 00       	add    $0x100,%eax
		for (j = 0; j < BLKFILES; j++)
  801101:	39 d0                	cmp    %edx,%eax
  801103:	75 f2                	jne    8010f7 <file_create+0x9f>
	for (i = 0; i < nblock; i++) {
  801105:	83 c3 01             	add    $0x1,%ebx
  801108:	eb c3                	jmp    8010cd <file_create+0x75>
	assert((dir->f_size % BLKSIZE) == 0);
  80110a:	68 60 40 80 00       	push   $0x804060
  80110f:	68 bd 3d 80 00       	push   $0x803dbd
  801114:	68 ee 00 00 00       	push   $0xee
  801119:	68 c8 3f 80 00       	push   $0x803fc8
  80111e:	e8 fb 09 00 00       	call   801b1e <_panic>
				*file = &f[j];
  801123:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  801129:	83 ec 08             	sub    $0x8,%esp
  80112c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801132:	50                   	push   %eax
  801133:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  801139:	e8 97 10 00 00       	call   8021d5 <strcpy>
	*pf = f;
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  801147:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  801149:	83 c4 04             	add    $0x4,%esp
  80114c:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
  801152:	e8 60 fe ff ff       	call   800fb7 <file_flush>
	return 0;
  801157:	83 c4 10             	add    $0x10,%esp
  80115a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80115f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801162:	5b                   	pop    %ebx
  801163:	5e                   	pop    %esi
  801164:	5f                   	pop    %edi
  801165:	5d                   	pop    %ebp
  801166:	c3                   	ret    
	dir->f_size += BLKSIZE;
  801167:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  80116e:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801171:	83 ec 04             	sub    $0x4,%esp
  801174:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  80117a:	50                   	push   %eax
  80117b:	53                   	push   %ebx
  80117c:	56                   	push   %esi
  80117d:	e8 66 f9 ff ff       	call   800ae8 <file_get_block>
  801182:	83 c4 10             	add    $0x10,%esp
  801185:	85 c0                	test   %eax,%eax
  801187:	78 d6                	js     80115f <file_create+0x107>
	*file = &f[0];
  801189:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80118f:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  801195:	eb 92                	jmp    801129 <file_create+0xd1>
		return -E_FILE_EXISTS;
  801197:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80119c:	eb c1                	jmp    80115f <file_create+0x107>

0080119e <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	53                   	push   %ebx
  8011a2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8011a5:	bb 01 00 00 00       	mov    $0x1,%ebx
  8011aa:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8011af:	39 58 04             	cmp    %ebx,0x4(%eax)
  8011b2:	76 19                	jbe    8011cd <fs_sync+0x2f>
		flush_block(diskaddr(i));
  8011b4:	83 ec 0c             	sub    $0xc,%esp
  8011b7:	53                   	push   %ebx
  8011b8:	e8 f2 f1 ff ff       	call   8003af <diskaddr>
  8011bd:	89 04 24             	mov    %eax,(%esp)
  8011c0:	e8 68 f2 ff ff       	call   80042d <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  8011c5:	83 c3 01             	add    $0x1,%ebx
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	eb dd                	jmp    8011aa <fs_sync+0xc>
}
  8011cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    

008011d2 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  8011d8:	e8 c1 ff ff ff       	call   80119e <fs_sync>
	return 0;
}
  8011dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <serve_init>:
{
  8011e4:	ba 60 50 80 00       	mov    $0x805060,%edx
	uintptr_t va = FILEVA;
  8011e9:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  8011ee:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  8011f3:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  8011f5:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  8011f8:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  8011fe:	83 c0 01             	add    $0x1,%eax
  801201:	83 c2 10             	add    $0x10,%edx
  801204:	3d 00 04 00 00       	cmp    $0x400,%eax
  801209:	75 e8                	jne    8011f3 <serve_init+0xf>
}
  80120b:	c3                   	ret    

0080120c <openfile_alloc>:
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	57                   	push   %edi
  801210:	56                   	push   %esi
  801211:	53                   	push   %ebx
  801212:	83 ec 0c             	sub    $0xc,%esp
  801215:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  801218:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121d:	89 de                	mov    %ebx,%esi
  80121f:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  801222:	83 ec 0c             	sub    $0xc,%esp
  801225:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
  80122b:	e8 95 1f 00 00       	call   8031c5 <pageref>
  801230:	83 c4 10             	add    $0x10,%esp
  801233:	85 c0                	test   %eax,%eax
  801235:	74 17                	je     80124e <openfile_alloc+0x42>
  801237:	83 f8 01             	cmp    $0x1,%eax
  80123a:	74 30                	je     80126c <openfile_alloc+0x60>
	for (i = 0; i < MAXOPEN; i++) {
  80123c:	83 c3 01             	add    $0x1,%ebx
  80123f:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801245:	75 d6                	jne    80121d <openfile_alloc+0x11>
	return -E_MAX_OPEN;
  801247:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80124c:	eb 4f                	jmp    80129d <openfile_alloc+0x91>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  80124e:	83 ec 04             	sub    $0x4,%esp
  801251:	6a 07                	push   $0x7
  801253:	89 d8                	mov    %ebx,%eax
  801255:	c1 e0 04             	shl    $0x4,%eax
  801258:	ff b0 6c 50 80 00    	pushl  0x80506c(%eax)
  80125e:	6a 00                	push   $0x0
  801260:	e8 62 13 00 00       	call   8025c7 <sys_page_alloc>
  801265:	83 c4 10             	add    $0x10,%esp
  801268:	85 c0                	test   %eax,%eax
  80126a:	78 31                	js     80129d <openfile_alloc+0x91>
			opentab[i].o_fileid += MAXOPEN;
  80126c:	c1 e3 04             	shl    $0x4,%ebx
  80126f:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  801276:	04 00 00 
			*o = &opentab[i];
  801279:	81 c6 60 50 80 00    	add    $0x805060,%esi
  80127f:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  801281:	83 ec 04             	sub    $0x4,%esp
  801284:	68 00 10 00 00       	push   $0x1000
  801289:	6a 00                	push   $0x0
  80128b:	ff b3 6c 50 80 00    	pushl  0x80506c(%ebx)
  801291:	e8 85 10 00 00       	call   80231b <memset>
			return (*o)->o_fileid;
  801296:	8b 07                	mov    (%edi),%eax
  801298:	8b 00                	mov    (%eax),%eax
  80129a:	83 c4 10             	add    $0x10,%esp
}
  80129d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a0:	5b                   	pop    %ebx
  8012a1:	5e                   	pop    %esi
  8012a2:	5f                   	pop    %edi
  8012a3:	5d                   	pop    %ebp
  8012a4:	c3                   	ret    

008012a5 <openfile_lookup>:
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	57                   	push   %edi
  8012a9:	56                   	push   %esi
  8012aa:	53                   	push   %ebx
  8012ab:	83 ec 18             	sub    $0x18,%esp
  8012ae:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  8012b1:	89 fb                	mov    %edi,%ebx
  8012b3:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8012b9:	89 de                	mov    %ebx,%esi
  8012bb:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8012be:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
	o = &opentab[fileid % MAXOPEN];
  8012c4:	81 c6 60 50 80 00    	add    $0x805060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8012ca:	e8 f6 1e 00 00       	call   8031c5 <pageref>
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	83 f8 01             	cmp    $0x1,%eax
  8012d5:	7e 1d                	jle    8012f4 <openfile_lookup+0x4f>
  8012d7:	c1 e3 04             	shl    $0x4,%ebx
  8012da:	39 bb 60 50 80 00    	cmp    %edi,0x805060(%ebx)
  8012e0:	75 19                	jne    8012fb <openfile_lookup+0x56>
	*po = o;
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	89 30                	mov    %esi,(%eax)
	return 0;
  8012e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ef:	5b                   	pop    %ebx
  8012f0:	5e                   	pop    %esi
  8012f1:	5f                   	pop    %edi
  8012f2:	5d                   	pop    %ebp
  8012f3:	c3                   	ret    
		return -E_INVAL;
  8012f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f9:	eb f1                	jmp    8012ec <openfile_lookup+0x47>
  8012fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801300:	eb ea                	jmp    8012ec <openfile_lookup+0x47>

00801302 <serve_set_size>:
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	53                   	push   %ebx
  801306:	83 ec 18             	sub    $0x18,%esp
  801309:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80130c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130f:	50                   	push   %eax
  801310:	ff 33                	pushl  (%ebx)
  801312:	ff 75 08             	pushl  0x8(%ebp)
  801315:	e8 8b ff ff ff       	call   8012a5 <openfile_lookup>
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	78 14                	js     801335 <serve_set_size+0x33>
	return file_set_size(o->o_file, req->req_size);
  801321:	83 ec 08             	sub    $0x8,%esp
  801324:	ff 73 04             	pushl  0x4(%ebx)
  801327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132a:	ff 70 04             	pushl  0x4(%eax)
  80132d:	e8 00 fb ff ff       	call   800e32 <file_set_size>
  801332:	83 c4 10             	add    $0x10,%esp
}
  801335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <serve_read>:
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	56                   	push   %esi
  80133e:	53                   	push   %ebx
  80133f:	83 ec 14             	sub    $0x14,%esp
  801342:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  r = openfile_lookup(envid, req->req_fileid, &of);
  801345:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801348:	50                   	push   %eax
  801349:	ff 33                	pushl  (%ebx)
  80134b:	ff 75 08             	pushl  0x8(%ebp)
  80134e:	e8 52 ff ff ff       	call   8012a5 <openfile_lookup>
  if (r < 0) return r;
  801353:	83 c4 10             	add    $0x10,%esp
  801356:	85 c0                	test   %eax,%eax
  801358:	78 1f                	js     801379 <serve_read+0x3f>
  f = of->o_file;
  80135a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  fd = of->o_fd;
  80135d:	8b 70 0c             	mov    0xc(%eax),%esi
  r = file_read(f, ret->ret_buf, req->req_n, fd->fd_offset);
  801360:	ff 76 04             	pushl  0x4(%esi)
  801363:	ff 73 04             	pushl  0x4(%ebx)
  801366:	53                   	push   %ebx
  801367:	ff 70 04             	pushl  0x4(%eax)
  80136a:	e8 19 fa ff ff       	call   800d88 <file_read>
  if (r > 0)
  80136f:	83 c4 10             	add    $0x10,%esp
  801372:	85 c0                	test   %eax,%eax
  801374:	7e 03                	jle    801379 <serve_read+0x3f>
    fd->fd_offset += r;
  801376:	01 46 04             	add    %eax,0x4(%esi)
}
  801379:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80137c:	5b                   	pop    %ebx
  80137d:	5e                   	pop    %esi
  80137e:	5d                   	pop    %ebp
  80137f:	c3                   	ret    

00801380 <serve_write>:
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	56                   	push   %esi
  801384:	53                   	push   %ebx
  801385:	83 ec 14             	sub    $0x14,%esp
  801388:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  r = openfile_lookup(envid, req->req_fileid, &of);
  80138b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138e:	50                   	push   %eax
  80138f:	ff 33                	pushl  (%ebx)
  801391:	ff 75 08             	pushl  0x8(%ebp)
  801394:	e8 0c ff ff ff       	call   8012a5 <openfile_lookup>
  if (r < 0) return r;
  801399:	83 c4 10             	add    $0x10,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	78 22                	js     8013c2 <serve_write+0x42>
  f = of->o_file;
  8013a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  fd = of->o_fd;
  8013a3:	8b 70 0c             	mov    0xc(%eax),%esi
  r = file_write(f, req->req_buf, req->req_n, fd->fd_offset);
  8013a6:	ff 76 04             	pushl  0x4(%esi)
  8013a9:	ff 73 04             	pushl  0x4(%ebx)
  8013ac:	83 c3 08             	add    $0x8,%ebx
  8013af:	53                   	push   %ebx
  8013b0:	ff 70 04             	pushl  0x4(%eax)
  8013b3:	e8 57 fb ff ff       	call   800f0f <file_write>
  if (r > 0)
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	85 c0                	test   %eax,%eax
  8013bd:	7e 03                	jle    8013c2 <serve_write+0x42>
    fd->fd_offset += r;
  8013bf:	01 46 04             	add    %eax,0x4(%esi)
}
  8013c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013c5:	5b                   	pop    %ebx
  8013c6:	5e                   	pop    %esi
  8013c7:	5d                   	pop    %ebp
  8013c8:	c3                   	ret    

008013c9 <serve_stat>:
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	53                   	push   %ebx
  8013cd:	83 ec 18             	sub    $0x18,%esp
  8013d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8013d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d6:	50                   	push   %eax
  8013d7:	ff 33                	pushl  (%ebx)
  8013d9:	ff 75 08             	pushl  0x8(%ebp)
  8013dc:	e8 c4 fe ff ff       	call   8012a5 <openfile_lookup>
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	78 3f                	js     801427 <serve_stat+0x5e>
	strcpy(ret->ret_name, o->o_file->f_name);
  8013e8:	83 ec 08             	sub    $0x8,%esp
  8013eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ee:	ff 70 04             	pushl  0x4(%eax)
  8013f1:	53                   	push   %ebx
  8013f2:	e8 de 0d 00 00       	call   8021d5 <strcpy>
	ret->ret_size = o->o_file->f_size;
  8013f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fa:	8b 50 04             	mov    0x4(%eax),%edx
  8013fd:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  801403:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  801409:	8b 40 04             	mov    0x4(%eax),%eax
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  801416:	0f 94 c0             	sete   %al
  801419:	0f b6 c0             	movzbl %al,%eax
  80141c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801422:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801427:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    

0080142c <serve_flush>:
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801432:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801435:	50                   	push   %eax
  801436:	8b 45 0c             	mov    0xc(%ebp),%eax
  801439:	ff 30                	pushl  (%eax)
  80143b:	ff 75 08             	pushl  0x8(%ebp)
  80143e:	e8 62 fe ff ff       	call   8012a5 <openfile_lookup>
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	85 c0                	test   %eax,%eax
  801448:	78 16                	js     801460 <serve_flush+0x34>
	file_flush(o->o_file);
  80144a:	83 ec 0c             	sub    $0xc,%esp
  80144d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801450:	ff 70 04             	pushl  0x4(%eax)
  801453:	e8 5f fb ff ff       	call   800fb7 <file_flush>
	return 0;
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <serve_open>:
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	53                   	push   %ebx
  801466:	81 ec 18 04 00 00    	sub    $0x418,%esp
  80146c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  80146f:	68 00 04 00 00       	push   $0x400
  801474:	53                   	push   %ebx
  801475:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80147b:	50                   	push   %eax
  80147c:	e8 e2 0e 00 00       	call   802363 <memmove>
	path[MAXPATHLEN-1] = 0;
  801481:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  801485:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  80148b:	89 04 24             	mov    %eax,(%esp)
  80148e:	e8 79 fd ff ff       	call   80120c <openfile_alloc>
  801493:	83 c4 10             	add    $0x10,%esp
  801496:	85 c0                	test   %eax,%eax
  801498:	0f 88 f0 00 00 00    	js     80158e <serve_open+0x12c>
	if (req->req_omode & O_CREAT) {
  80149e:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  8014a5:	74 33                	je     8014da <serve_open+0x78>
		if ((r = file_create(path, &f)) < 0) {
  8014a7:	83 ec 08             	sub    $0x8,%esp
  8014aa:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8014b0:	50                   	push   %eax
  8014b1:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014b7:	50                   	push   %eax
  8014b8:	e8 9b fb ff ff       	call   801058 <file_create>
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	79 37                	jns    8014fb <serve_open+0x99>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8014c4:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  8014cb:	0f 85 bd 00 00 00    	jne    80158e <serve_open+0x12c>
  8014d1:	83 f8 f3             	cmp    $0xfffffff3,%eax
  8014d4:	0f 85 b4 00 00 00    	jne    80158e <serve_open+0x12c>
		if ((r = file_open(path, &f)) < 0) {
  8014da:	83 ec 08             	sub    $0x8,%esp
  8014dd:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8014e3:	50                   	push   %eax
  8014e4:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014ea:	50                   	push   %eax
  8014eb:	e8 7e f8 ff ff       	call   800d6e <file_open>
  8014f0:	83 c4 10             	add    $0x10,%esp
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	0f 88 93 00 00 00    	js     80158e <serve_open+0x12c>
	if (req->req_omode & O_TRUNC) {
  8014fb:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  801502:	74 17                	je     80151b <serve_open+0xb9>
		if ((r = file_set_size(f, 0)) < 0) {
  801504:	83 ec 08             	sub    $0x8,%esp
  801507:	6a 00                	push   $0x0
  801509:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  80150f:	e8 1e f9 ff ff       	call   800e32 <file_set_size>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	85 c0                	test   %eax,%eax
  801519:	78 73                	js     80158e <serve_open+0x12c>
	if ((r = file_open(path, &f)) < 0) {
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801524:	50                   	push   %eax
  801525:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80152b:	50                   	push   %eax
  80152c:	e8 3d f8 ff ff       	call   800d6e <file_open>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 56                	js     80158e <serve_open+0x12c>
	o->o_file = f;
  801538:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  80153e:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  801544:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  801547:	8b 50 0c             	mov    0xc(%eax),%edx
  80154a:	8b 08                	mov    (%eax),%ecx
  80154c:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  80154f:	8b 48 0c             	mov    0xc(%eax),%ecx
  801552:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801558:	83 e2 03             	and    $0x3,%edx
  80155b:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  80155e:	8b 40 0c             	mov    0xc(%eax),%eax
  801561:	8b 15 64 90 80 00    	mov    0x809064,%edx
  801567:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  801569:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  80156f:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801575:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  801578:	8b 50 0c             	mov    0xc(%eax),%edx
  80157b:	8b 45 10             	mov    0x10(%ebp),%eax
  80157e:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  801580:	8b 45 14             	mov    0x14(%ebp),%eax
  801583:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  801589:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801591:	c9                   	leave  
  801592:	c3                   	ret    

00801593 <serve>:
	[FSREQ_SYNC] =		serve_sync
};

void
serve(void)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
  801596:	56                   	push   %esi
  801597:	53                   	push   %ebx
  801598:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  80159b:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  80159e:	8d 75 f4             	lea    -0xc(%ebp),%esi
  8015a1:	e9 82 00 00 00       	jmp    801628 <serve+0x95>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  8015a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  8015ad:	83 f8 01             	cmp    $0x1,%eax
  8015b0:	74 23                	je     8015d5 <serve+0x42>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  8015b2:	83 f8 08             	cmp    $0x8,%eax
  8015b5:	77 36                	ja     8015ed <serve+0x5a>
  8015b7:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  8015be:	85 d2                	test   %edx,%edx
  8015c0:	74 2b                	je     8015ed <serve+0x5a>
			r = handlers[req](whom, fsreq);
  8015c2:	83 ec 08             	sub    $0x8,%esp
  8015c5:	ff 35 44 50 80 00    	pushl  0x805044
  8015cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ce:	ff d2                	call   *%edx
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	eb 31                	jmp    801606 <serve+0x73>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8015d5:	53                   	push   %ebx
  8015d6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015d9:	50                   	push   %eax
  8015da:	ff 35 44 50 80 00    	pushl  0x805044
  8015e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e3:	e8 7a fe ff ff       	call   801462 <serve_open>
  8015e8:	83 c4 10             	add    $0x10,%esp
  8015eb:	eb 19                	jmp    801606 <serve+0x73>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  8015ed:	83 ec 04             	sub    $0x4,%esp
  8015f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f3:	50                   	push   %eax
  8015f4:	68 cc 40 80 00       	push   $0x8040cc
  8015f9:	e8 fb 05 00 00       	call   801bf9 <cprintf>
  8015fe:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  801601:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  801606:	ff 75 f0             	pushl  -0x10(%ebp)
  801609:	ff 75 ec             	pushl  -0x14(%ebp)
  80160c:	50                   	push   %eax
  80160d:	ff 75 f4             	pushl  -0xc(%ebp)
  801610:	e8 d2 12 00 00       	call   8028e7 <ipc_send>
		sys_page_unmap(0, fsreq);
  801615:	83 c4 08             	add    $0x8,%esp
  801618:	ff 35 44 50 80 00    	pushl  0x805044
  80161e:	6a 00                	push   $0x0
  801620:	e8 27 10 00 00       	call   80264c <sys_page_unmap>
  801625:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  801628:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	53                   	push   %ebx
  801633:	ff 35 44 50 80 00    	pushl  0x805044
  801639:	56                   	push   %esi
  80163a:	e8 35 12 00 00       	call   802874 <ipc_recv>
		if (!(perm & PTE_P)) {
  80163f:	83 c4 10             	add    $0x10,%esp
  801642:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  801646:	0f 85 5a ff ff ff    	jne    8015a6 <serve+0x13>
			cprintf("Invalid request from %08x: no argument page\n",
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	ff 75 f4             	pushl  -0xc(%ebp)
  801652:	68 9c 40 80 00       	push   $0x80409c
  801657:	e8 9d 05 00 00       	call   801bf9 <cprintf>
			continue; // just leave it hanging...
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	eb c7                	jmp    801628 <serve+0x95>

00801661 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  801667:	c7 05 60 90 80 00 ef 	movl   $0x8040ef,0x809060
  80166e:	40 80 00 
	cprintf("FS is running\n");
  801671:	68 f2 40 80 00       	push   $0x8040f2
  801676:	e8 7e 05 00 00       	call   801bf9 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  80167b:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  801680:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801685:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  801687:	c7 04 24 01 41 80 00 	movl   $0x804101,(%esp)
  80168e:	e8 66 05 00 00       	call   801bf9 <cprintf>

	serve_init();
  801693:	e8 4c fb ff ff       	call   8011e4 <serve_init>
	fs_init();
  801698:	e8 ec f3 ff ff       	call   800a89 <fs_init>
	serve();
  80169d:	e8 f1 fe ff ff       	call   801593 <serve>

008016a2 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	53                   	push   %ebx
  8016a6:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8016a9:	6a 07                	push   $0x7
  8016ab:	68 00 10 00 00       	push   $0x1000
  8016b0:	6a 00                	push   $0x0
  8016b2:	e8 10 0f 00 00       	call   8025c7 <sys_page_alloc>
  8016b7:	83 c4 10             	add    $0x10,%esp
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	0f 88 68 02 00 00    	js     80192a <fs_test+0x288>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  8016c2:	83 ec 04             	sub    $0x4,%esp
  8016c5:	68 00 10 00 00       	push   $0x1000
  8016ca:	ff 35 08 a0 80 00    	pushl  0x80a008
  8016d0:	68 00 10 00 00       	push   $0x1000
  8016d5:	e8 89 0c 00 00       	call   802363 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  8016da:	e8 cd f1 ff ff       	call   8008ac <alloc_block>
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	85 c0                	test   %eax,%eax
  8016e4:	0f 88 52 02 00 00    	js     80193c <fs_test+0x29a>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  8016ea:	8d 50 1f             	lea    0x1f(%eax),%edx
  8016ed:	0f 49 d0             	cmovns %eax,%edx
  8016f0:	c1 fa 05             	sar    $0x5,%edx
  8016f3:	89 c3                	mov    %eax,%ebx
  8016f5:	c1 fb 1f             	sar    $0x1f,%ebx
  8016f8:	c1 eb 1b             	shr    $0x1b,%ebx
  8016fb:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  8016fe:	83 e1 1f             	and    $0x1f,%ecx
  801701:	29 d9                	sub    %ebx,%ecx
  801703:	b8 01 00 00 00       	mov    $0x1,%eax
  801708:	d3 e0                	shl    %cl,%eax
  80170a:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  801711:	0f 84 37 02 00 00    	je     80194e <fs_test+0x2ac>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801717:	8b 0d 08 a0 80 00    	mov    0x80a008,%ecx
  80171d:	85 04 91             	test   %eax,(%ecx,%edx,4)
  801720:	0f 85 3e 02 00 00    	jne    801964 <fs_test+0x2c2>
	cprintf("alloc_block is good\n");
  801726:	83 ec 0c             	sub    $0xc,%esp
  801729:	68 58 41 80 00       	push   $0x804158
  80172e:	e8 c6 04 00 00       	call   801bf9 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  801733:	83 c4 08             	add    $0x8,%esp
  801736:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801739:	50                   	push   %eax
  80173a:	68 6d 41 80 00       	push   $0x80416d
  80173f:	e8 2a f6 ff ff       	call   800d6e <file_open>
  801744:	83 c4 10             	add    $0x10,%esp
  801747:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80174a:	74 08                	je     801754 <fs_test+0xb2>
  80174c:	85 c0                	test   %eax,%eax
  80174e:	0f 88 26 02 00 00    	js     80197a <fs_test+0x2d8>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  801754:	85 c0                	test   %eax,%eax
  801756:	0f 84 30 02 00 00    	je     80198c <fs_test+0x2ea>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  80175c:	83 ec 08             	sub    $0x8,%esp
  80175f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801762:	50                   	push   %eax
  801763:	68 91 41 80 00       	push   $0x804191
  801768:	e8 01 f6 ff ff       	call   800d6e <file_open>
  80176d:	83 c4 10             	add    $0x10,%esp
  801770:	85 c0                	test   %eax,%eax
  801772:	0f 88 28 02 00 00    	js     8019a0 <fs_test+0x2fe>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  801778:	83 ec 0c             	sub    $0xc,%esp
  80177b:	68 b1 41 80 00       	push   $0x8041b1
  801780:	e8 74 04 00 00       	call   801bf9 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  801785:	83 c4 0c             	add    $0xc,%esp
  801788:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178b:	50                   	push   %eax
  80178c:	6a 00                	push   $0x0
  80178e:	ff 75 f4             	pushl  -0xc(%ebp)
  801791:	e8 52 f3 ff ff       	call   800ae8 <file_get_block>
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	85 c0                	test   %eax,%eax
  80179b:	0f 88 11 02 00 00    	js     8019b2 <fs_test+0x310>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	68 f8 42 80 00       	push   $0x8042f8
  8017a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ac:	e8 cf 0a 00 00       	call   802280 <strcmp>
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	0f 85 08 02 00 00    	jne    8019c4 <fs_test+0x322>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  8017bc:	83 ec 0c             	sub    $0xc,%esp
  8017bf:	68 d7 41 80 00       	push   $0x8041d7
  8017c4:	e8 30 04 00 00       	call   801bf9 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  8017c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cc:	0f b6 10             	movzbl (%eax),%edx
  8017cf:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8017d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d4:	c1 e8 0c             	shr    $0xc,%eax
  8017d7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	a8 40                	test   $0x40,%al
  8017e3:	0f 84 ef 01 00 00    	je     8019d8 <fs_test+0x336>
	file_flush(f);
  8017e9:	83 ec 0c             	sub    $0xc,%esp
  8017ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ef:	e8 c3 f7 ff ff       	call   800fb7 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8017f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f7:	c1 e8 0c             	shr    $0xc,%eax
  8017fa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801801:	83 c4 10             	add    $0x10,%esp
  801804:	a8 40                	test   $0x40,%al
  801806:	0f 85 e2 01 00 00    	jne    8019ee <fs_test+0x34c>
	cprintf("file_flush is good\n");
  80180c:	83 ec 0c             	sub    $0xc,%esp
  80180f:	68 0b 42 80 00       	push   $0x80420b
  801814:	e8 e0 03 00 00       	call   801bf9 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801819:	83 c4 08             	add    $0x8,%esp
  80181c:	6a 00                	push   $0x0
  80181e:	ff 75 f4             	pushl  -0xc(%ebp)
  801821:	e8 0c f6 ff ff       	call   800e32 <file_set_size>
  801826:	83 c4 10             	add    $0x10,%esp
  801829:	85 c0                	test   %eax,%eax
  80182b:	0f 88 d3 01 00 00    	js     801a04 <fs_test+0x362>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  801831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801834:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  80183b:	0f 85 d5 01 00 00    	jne    801a16 <fs_test+0x374>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801841:	c1 e8 0c             	shr    $0xc,%eax
  801844:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80184b:	a8 40                	test   $0x40,%al
  80184d:	0f 85 d9 01 00 00    	jne    801a2c <fs_test+0x38a>
	cprintf("file_truncate is good\n");
  801853:	83 ec 0c             	sub    $0xc,%esp
  801856:	68 5f 42 80 00       	push   $0x80425f
  80185b:	e8 99 03 00 00       	call   801bf9 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801860:	c7 04 24 f8 42 80 00 	movl   $0x8042f8,(%esp)
  801867:	e8 30 09 00 00       	call   80219c <strlen>
  80186c:	83 c4 08             	add    $0x8,%esp
  80186f:	50                   	push   %eax
  801870:	ff 75 f4             	pushl  -0xc(%ebp)
  801873:	e8 ba f5 ff ff       	call   800e32 <file_set_size>
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	85 c0                	test   %eax,%eax
  80187d:	0f 88 bf 01 00 00    	js     801a42 <fs_test+0x3a0>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801886:	89 c2                	mov    %eax,%edx
  801888:	c1 ea 0c             	shr    $0xc,%edx
  80188b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801892:	f6 c2 40             	test   $0x40,%dl
  801895:	0f 85 b9 01 00 00    	jne    801a54 <fs_test+0x3b2>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  80189b:	83 ec 04             	sub    $0x4,%esp
  80189e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8018a1:	52                   	push   %edx
  8018a2:	6a 00                	push   $0x0
  8018a4:	50                   	push   %eax
  8018a5:	e8 3e f2 ff ff       	call   800ae8 <file_get_block>
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	0f 88 b5 01 00 00    	js     801a6a <fs_test+0x3c8>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  8018b5:	83 ec 08             	sub    $0x8,%esp
  8018b8:	68 f8 42 80 00       	push   $0x8042f8
  8018bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8018c0:	e8 10 09 00 00       	call   8021d5 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8018c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c8:	c1 e8 0c             	shr    $0xc,%eax
  8018cb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	a8 40                	test   $0x40,%al
  8018d7:	0f 84 9f 01 00 00    	je     801a7c <fs_test+0x3da>
	file_flush(f);
  8018dd:	83 ec 0c             	sub    $0xc,%esp
  8018e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e3:	e8 cf f6 ff ff       	call   800fb7 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8018e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018eb:	c1 e8 0c             	shr    $0xc,%eax
  8018ee:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	a8 40                	test   $0x40,%al
  8018fa:	0f 85 92 01 00 00    	jne    801a92 <fs_test+0x3f0>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801903:	c1 e8 0c             	shr    $0xc,%eax
  801906:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80190d:	a8 40                	test   $0x40,%al
  80190f:	0f 85 93 01 00 00    	jne    801aa8 <fs_test+0x406>
	cprintf("file rewrite is good\n");
  801915:	83 ec 0c             	sub    $0xc,%esp
  801918:	68 9f 42 80 00       	push   $0x80429f
  80191d:	e8 d7 02 00 00       	call   801bf9 <cprintf>
}
  801922:	83 c4 10             	add    $0x10,%esp
  801925:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801928:	c9                   	leave  
  801929:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80192a:	50                   	push   %eax
  80192b:	68 10 41 80 00       	push   $0x804110
  801930:	6a 12                	push   $0x12
  801932:	68 23 41 80 00       	push   $0x804123
  801937:	e8 e2 01 00 00       	call   801b1e <_panic>
		panic("alloc_block: %e", r);
  80193c:	50                   	push   %eax
  80193d:	68 2d 41 80 00       	push   $0x80412d
  801942:	6a 17                	push   $0x17
  801944:	68 23 41 80 00       	push   $0x804123
  801949:	e8 d0 01 00 00       	call   801b1e <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  80194e:	68 3d 41 80 00       	push   $0x80413d
  801953:	68 bd 3d 80 00       	push   $0x803dbd
  801958:	6a 19                	push   $0x19
  80195a:	68 23 41 80 00       	push   $0x804123
  80195f:	e8 ba 01 00 00       	call   801b1e <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801964:	68 b8 42 80 00       	push   $0x8042b8
  801969:	68 bd 3d 80 00       	push   $0x803dbd
  80196e:	6a 1b                	push   $0x1b
  801970:	68 23 41 80 00       	push   $0x804123
  801975:	e8 a4 01 00 00       	call   801b1e <_panic>
		panic("file_open /not-found: %e", r);
  80197a:	50                   	push   %eax
  80197b:	68 78 41 80 00       	push   $0x804178
  801980:	6a 1f                	push   $0x1f
  801982:	68 23 41 80 00       	push   $0x804123
  801987:	e8 92 01 00 00       	call   801b1e <_panic>
		panic("file_open /not-found succeeded!");
  80198c:	83 ec 04             	sub    $0x4,%esp
  80198f:	68 d8 42 80 00       	push   $0x8042d8
  801994:	6a 21                	push   $0x21
  801996:	68 23 41 80 00       	push   $0x804123
  80199b:	e8 7e 01 00 00       	call   801b1e <_panic>
		panic("file_open /newmotd: %e", r);
  8019a0:	50                   	push   %eax
  8019a1:	68 9a 41 80 00       	push   $0x80419a
  8019a6:	6a 23                	push   $0x23
  8019a8:	68 23 41 80 00       	push   $0x804123
  8019ad:	e8 6c 01 00 00       	call   801b1e <_panic>
		panic("file_get_block: %e", r);
  8019b2:	50                   	push   %eax
  8019b3:	68 c4 41 80 00       	push   $0x8041c4
  8019b8:	6a 27                	push   $0x27
  8019ba:	68 23 41 80 00       	push   $0x804123
  8019bf:	e8 5a 01 00 00       	call   801b1e <_panic>
		panic("file_get_block returned wrong data");
  8019c4:	83 ec 04             	sub    $0x4,%esp
  8019c7:	68 20 43 80 00       	push   $0x804320
  8019cc:	6a 29                	push   $0x29
  8019ce:	68 23 41 80 00       	push   $0x804123
  8019d3:	e8 46 01 00 00       	call   801b1e <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8019d8:	68 f0 41 80 00       	push   $0x8041f0
  8019dd:	68 bd 3d 80 00       	push   $0x803dbd
  8019e2:	6a 2d                	push   $0x2d
  8019e4:	68 23 41 80 00       	push   $0x804123
  8019e9:	e8 30 01 00 00       	call   801b1e <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8019ee:	68 ef 41 80 00       	push   $0x8041ef
  8019f3:	68 bd 3d 80 00       	push   $0x803dbd
  8019f8:	6a 2f                	push   $0x2f
  8019fa:	68 23 41 80 00       	push   $0x804123
  8019ff:	e8 1a 01 00 00       	call   801b1e <_panic>
		panic("file_set_size: %e", r);
  801a04:	50                   	push   %eax
  801a05:	68 1f 42 80 00       	push   $0x80421f
  801a0a:	6a 33                	push   $0x33
  801a0c:	68 23 41 80 00       	push   $0x804123
  801a11:	e8 08 01 00 00       	call   801b1e <_panic>
	assert(f->f_direct[0] == 0);
  801a16:	68 31 42 80 00       	push   $0x804231
  801a1b:	68 bd 3d 80 00       	push   $0x803dbd
  801a20:	6a 34                	push   $0x34
  801a22:	68 23 41 80 00       	push   $0x804123
  801a27:	e8 f2 00 00 00       	call   801b1e <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a2c:	68 45 42 80 00       	push   $0x804245
  801a31:	68 bd 3d 80 00       	push   $0x803dbd
  801a36:	6a 35                	push   $0x35
  801a38:	68 23 41 80 00       	push   $0x804123
  801a3d:	e8 dc 00 00 00       	call   801b1e <_panic>
		panic("file_set_size 2: %e", r);
  801a42:	50                   	push   %eax
  801a43:	68 76 42 80 00       	push   $0x804276
  801a48:	6a 39                	push   $0x39
  801a4a:	68 23 41 80 00       	push   $0x804123
  801a4f:	e8 ca 00 00 00       	call   801b1e <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a54:	68 45 42 80 00       	push   $0x804245
  801a59:	68 bd 3d 80 00       	push   $0x803dbd
  801a5e:	6a 3a                	push   $0x3a
  801a60:	68 23 41 80 00       	push   $0x804123
  801a65:	e8 b4 00 00 00       	call   801b1e <_panic>
		panic("file_get_block 2: %e", r);
  801a6a:	50                   	push   %eax
  801a6b:	68 8a 42 80 00       	push   $0x80428a
  801a70:	6a 3c                	push   $0x3c
  801a72:	68 23 41 80 00       	push   $0x804123
  801a77:	e8 a2 00 00 00       	call   801b1e <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801a7c:	68 f0 41 80 00       	push   $0x8041f0
  801a81:	68 bd 3d 80 00       	push   $0x803dbd
  801a86:	6a 3e                	push   $0x3e
  801a88:	68 23 41 80 00       	push   $0x804123
  801a8d:	e8 8c 00 00 00       	call   801b1e <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801a92:	68 ef 41 80 00       	push   $0x8041ef
  801a97:	68 bd 3d 80 00       	push   $0x803dbd
  801a9c:	6a 40                	push   $0x40
  801a9e:	68 23 41 80 00       	push   $0x804123
  801aa3:	e8 76 00 00 00       	call   801b1e <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801aa8:	68 45 42 80 00       	push   $0x804245
  801aad:	68 bd 3d 80 00       	push   $0x803dbd
  801ab2:	6a 41                	push   $0x41
  801ab4:	68 23 41 80 00       	push   $0x804123
  801ab9:	e8 60 00 00 00       	call   801b1e <_panic>

00801abe <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	56                   	push   %esi
  801ac2:	53                   	push   %ebx
  801ac3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801ac6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801ac9:	e8 bb 0a 00 00       	call   802589 <sys_getenvid>
  801ace:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ad3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ad6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801adb:	a3 10 a0 80 00       	mov    %eax,0x80a010

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801ae0:	85 db                	test   %ebx,%ebx
  801ae2:	7e 07                	jle    801aeb <libmain+0x2d>
		binaryname = argv[0];
  801ae4:	8b 06                	mov    (%esi),%eax
  801ae6:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801aeb:	83 ec 08             	sub    $0x8,%esp
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
  801af0:	e8 6c fb ff ff       	call   801661 <umain>

	// exit gracefully
	exit();
  801af5:	e8 0a 00 00 00       	call   801b04 <exit>
}
  801afa:	83 c4 10             	add    $0x10,%esp
  801afd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b00:	5b                   	pop    %ebx
  801b01:	5e                   	pop    %esi
  801b02:	5d                   	pop    %ebp
  801b03:	c3                   	ret    

00801b04 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 08             	sub    $0x8,%esp
	close_all();
  801b0a:	e8 55 10 00 00       	call   802b64 <close_all>
	sys_env_destroy(0);
  801b0f:	83 ec 0c             	sub    $0xc,%esp
  801b12:	6a 00                	push   $0x0
  801b14:	e8 2f 0a 00 00       	call   802548 <sys_env_destroy>
}
  801b19:	83 c4 10             	add    $0x10,%esp
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	56                   	push   %esi
  801b22:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801b23:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b26:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801b2c:	e8 58 0a 00 00       	call   802589 <sys_getenvid>
  801b31:	83 ec 0c             	sub    $0xc,%esp
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	56                   	push   %esi
  801b3b:	50                   	push   %eax
  801b3c:	68 50 43 80 00       	push   $0x804350
  801b41:	e8 b3 00 00 00       	call   801bf9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801b46:	83 c4 18             	add    $0x18,%esp
  801b49:	53                   	push   %ebx
  801b4a:	ff 75 10             	pushl  0x10(%ebp)
  801b4d:	e8 56 00 00 00       	call   801ba8 <vcprintf>
	cprintf("\n");
  801b52:	c7 04 24 5f 3f 80 00 	movl   $0x803f5f,(%esp)
  801b59:	e8 9b 00 00 00       	call   801bf9 <cprintf>
  801b5e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b61:	cc                   	int3   
  801b62:	eb fd                	jmp    801b61 <_panic+0x43>

00801b64 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	53                   	push   %ebx
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801b6e:	8b 13                	mov    (%ebx),%edx
  801b70:	8d 42 01             	lea    0x1(%edx),%eax
  801b73:	89 03                	mov    %eax,(%ebx)
  801b75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b78:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801b7c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801b81:	74 09                	je     801b8c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801b83:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801b87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801b8c:	83 ec 08             	sub    $0x8,%esp
  801b8f:	68 ff 00 00 00       	push   $0xff
  801b94:	8d 43 08             	lea    0x8(%ebx),%eax
  801b97:	50                   	push   %eax
  801b98:	e8 6e 09 00 00       	call   80250b <sys_cputs>
		b->idx = 0;
  801b9d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ba3:	83 c4 10             	add    $0x10,%esp
  801ba6:	eb db                	jmp    801b83 <putch+0x1f>

00801ba8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801bb1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801bb8:	00 00 00 
	b.cnt = 0;
  801bbb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801bc2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801bc5:	ff 75 0c             	pushl  0xc(%ebp)
  801bc8:	ff 75 08             	pushl  0x8(%ebp)
  801bcb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801bd1:	50                   	push   %eax
  801bd2:	68 64 1b 80 00       	push   $0x801b64
  801bd7:	e8 19 01 00 00       	call   801cf5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801bdc:	83 c4 08             	add    $0x8,%esp
  801bdf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801be5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801beb:	50                   	push   %eax
  801bec:	e8 1a 09 00 00       	call   80250b <sys_cputs>

	return b.cnt;
}
  801bf1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801bff:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801c02:	50                   	push   %eax
  801c03:	ff 75 08             	pushl  0x8(%ebp)
  801c06:	e8 9d ff ff ff       	call   801ba8 <vcprintf>
	va_end(ap);

	return cnt;
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	57                   	push   %edi
  801c11:	56                   	push   %esi
  801c12:	53                   	push   %ebx
  801c13:	83 ec 1c             	sub    $0x1c,%esp
  801c16:	89 c7                	mov    %eax,%edi
  801c18:	89 d6                	mov    %edx,%esi
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c20:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c23:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801c26:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c29:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c2e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801c31:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801c34:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c37:	89 d0                	mov    %edx,%eax
  801c39:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  801c3c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c3f:	73 15                	jae    801c56 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801c41:	83 eb 01             	sub    $0x1,%ebx
  801c44:	85 db                	test   %ebx,%ebx
  801c46:	7e 43                	jle    801c8b <printnum+0x7e>
			putch(padc, putdat);
  801c48:	83 ec 08             	sub    $0x8,%esp
  801c4b:	56                   	push   %esi
  801c4c:	ff 75 18             	pushl  0x18(%ebp)
  801c4f:	ff d7                	call   *%edi
  801c51:	83 c4 10             	add    $0x10,%esp
  801c54:	eb eb                	jmp    801c41 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801c56:	83 ec 0c             	sub    $0xc,%esp
  801c59:	ff 75 18             	pushl  0x18(%ebp)
  801c5c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801c62:	53                   	push   %ebx
  801c63:	ff 75 10             	pushl  0x10(%ebp)
  801c66:	83 ec 08             	sub    $0x8,%esp
  801c69:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c6c:	ff 75 e0             	pushl  -0x20(%ebp)
  801c6f:	ff 75 dc             	pushl  -0x24(%ebp)
  801c72:	ff 75 d8             	pushl  -0x28(%ebp)
  801c75:	e8 b6 1e 00 00       	call   803b30 <__udivdi3>
  801c7a:	83 c4 18             	add    $0x18,%esp
  801c7d:	52                   	push   %edx
  801c7e:	50                   	push   %eax
  801c7f:	89 f2                	mov    %esi,%edx
  801c81:	89 f8                	mov    %edi,%eax
  801c83:	e8 85 ff ff ff       	call   801c0d <printnum>
  801c88:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801c8b:	83 ec 08             	sub    $0x8,%esp
  801c8e:	56                   	push   %esi
  801c8f:	83 ec 04             	sub    $0x4,%esp
  801c92:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c95:	ff 75 e0             	pushl  -0x20(%ebp)
  801c98:	ff 75 dc             	pushl  -0x24(%ebp)
  801c9b:	ff 75 d8             	pushl  -0x28(%ebp)
  801c9e:	e8 9d 1f 00 00       	call   803c40 <__umoddi3>
  801ca3:	83 c4 14             	add    $0x14,%esp
  801ca6:	0f be 80 73 43 80 00 	movsbl 0x804373(%eax),%eax
  801cad:	50                   	push   %eax
  801cae:	ff d7                	call   *%edi
}
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb6:	5b                   	pop    %ebx
  801cb7:	5e                   	pop    %esi
  801cb8:	5f                   	pop    %edi
  801cb9:	5d                   	pop    %ebp
  801cba:	c3                   	ret    

00801cbb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801cc1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801cc5:	8b 10                	mov    (%eax),%edx
  801cc7:	3b 50 04             	cmp    0x4(%eax),%edx
  801cca:	73 0a                	jae    801cd6 <sprintputch+0x1b>
		*b->buf++ = ch;
  801ccc:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ccf:	89 08                	mov    %ecx,(%eax)
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	88 02                	mov    %al,(%edx)
}
  801cd6:	5d                   	pop    %ebp
  801cd7:	c3                   	ret    

00801cd8 <printfmt>:
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801cde:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801ce1:	50                   	push   %eax
  801ce2:	ff 75 10             	pushl  0x10(%ebp)
  801ce5:	ff 75 0c             	pushl  0xc(%ebp)
  801ce8:	ff 75 08             	pushl  0x8(%ebp)
  801ceb:	e8 05 00 00 00       	call   801cf5 <vprintfmt>
}
  801cf0:	83 c4 10             	add    $0x10,%esp
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <vprintfmt>:
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	57                   	push   %edi
  801cf9:	56                   	push   %esi
  801cfa:	53                   	push   %ebx
  801cfb:	83 ec 3c             	sub    $0x3c,%esp
  801cfe:	8b 75 08             	mov    0x8(%ebp),%esi
  801d01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d04:	8b 7d 10             	mov    0x10(%ebp),%edi
  801d07:	eb 0a                	jmp    801d13 <vprintfmt+0x1e>
			putch(ch, putdat);
  801d09:	83 ec 08             	sub    $0x8,%esp
  801d0c:	53                   	push   %ebx
  801d0d:	50                   	push   %eax
  801d0e:	ff d6                	call   *%esi
  801d10:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801d13:	83 c7 01             	add    $0x1,%edi
  801d16:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801d1a:	83 f8 25             	cmp    $0x25,%eax
  801d1d:	74 0c                	je     801d2b <vprintfmt+0x36>
			if (ch == '\0')
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	75 e6                	jne    801d09 <vprintfmt+0x14>
}
  801d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d26:	5b                   	pop    %ebx
  801d27:	5e                   	pop    %esi
  801d28:	5f                   	pop    %edi
  801d29:	5d                   	pop    %ebp
  801d2a:	c3                   	ret    
		padc = ' ';
  801d2b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801d2f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801d36:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801d3d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801d44:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801d49:	8d 47 01             	lea    0x1(%edi),%eax
  801d4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d4f:	0f b6 17             	movzbl (%edi),%edx
  801d52:	8d 42 dd             	lea    -0x23(%edx),%eax
  801d55:	3c 55                	cmp    $0x55,%al
  801d57:	0f 87 ba 03 00 00    	ja     802117 <vprintfmt+0x422>
  801d5d:	0f b6 c0             	movzbl %al,%eax
  801d60:	ff 24 85 c0 44 80 00 	jmp    *0x8044c0(,%eax,4)
  801d67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801d6a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801d6e:	eb d9                	jmp    801d49 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801d70:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801d73:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801d77:	eb d0                	jmp    801d49 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801d79:	0f b6 d2             	movzbl %dl,%edx
  801d7c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d84:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801d87:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801d8a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801d8e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801d91:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801d94:	83 f9 09             	cmp    $0x9,%ecx
  801d97:	77 55                	ja     801dee <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  801d99:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801d9c:	eb e9                	jmp    801d87 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  801d9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801da1:	8b 00                	mov    (%eax),%eax
  801da3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801da6:	8b 45 14             	mov    0x14(%ebp),%eax
  801da9:	8d 40 04             	lea    0x4(%eax),%eax
  801dac:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801daf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801db2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801db6:	79 91                	jns    801d49 <vprintfmt+0x54>
				width = precision, precision = -1;
  801db8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801dbe:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801dc5:	eb 82                	jmp    801d49 <vprintfmt+0x54>
  801dc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd1:	0f 49 d0             	cmovns %eax,%edx
  801dd4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801dd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801dda:	e9 6a ff ff ff       	jmp    801d49 <vprintfmt+0x54>
  801ddf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801de2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801de9:	e9 5b ff ff ff       	jmp    801d49 <vprintfmt+0x54>
  801dee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801df1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801df4:	eb bc                	jmp    801db2 <vprintfmt+0xbd>
			lflag++;
  801df6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801df9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801dfc:	e9 48 ff ff ff       	jmp    801d49 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  801e01:	8b 45 14             	mov    0x14(%ebp),%eax
  801e04:	8d 78 04             	lea    0x4(%eax),%edi
  801e07:	83 ec 08             	sub    $0x8,%esp
  801e0a:	53                   	push   %ebx
  801e0b:	ff 30                	pushl  (%eax)
  801e0d:	ff d6                	call   *%esi
			break;
  801e0f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801e12:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801e15:	e9 9c 02 00 00       	jmp    8020b6 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  801e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801e1d:	8d 78 04             	lea    0x4(%eax),%edi
  801e20:	8b 00                	mov    (%eax),%eax
  801e22:	99                   	cltd   
  801e23:	31 d0                	xor    %edx,%eax
  801e25:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801e27:	83 f8 0f             	cmp    $0xf,%eax
  801e2a:	7f 23                	jg     801e4f <vprintfmt+0x15a>
  801e2c:	8b 14 85 20 46 80 00 	mov    0x804620(,%eax,4),%edx
  801e33:	85 d2                	test   %edx,%edx
  801e35:	74 18                	je     801e4f <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  801e37:	52                   	push   %edx
  801e38:	68 cf 3d 80 00       	push   $0x803dcf
  801e3d:	53                   	push   %ebx
  801e3e:	56                   	push   %esi
  801e3f:	e8 94 fe ff ff       	call   801cd8 <printfmt>
  801e44:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801e47:	89 7d 14             	mov    %edi,0x14(%ebp)
  801e4a:	e9 67 02 00 00       	jmp    8020b6 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  801e4f:	50                   	push   %eax
  801e50:	68 8b 43 80 00       	push   $0x80438b
  801e55:	53                   	push   %ebx
  801e56:	56                   	push   %esi
  801e57:	e8 7c fe ff ff       	call   801cd8 <printfmt>
  801e5c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801e5f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801e62:	e9 4f 02 00 00       	jmp    8020b6 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  801e67:	8b 45 14             	mov    0x14(%ebp),%eax
  801e6a:	83 c0 04             	add    $0x4,%eax
  801e6d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801e70:	8b 45 14             	mov    0x14(%ebp),%eax
  801e73:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801e75:	85 d2                	test   %edx,%edx
  801e77:	b8 84 43 80 00       	mov    $0x804384,%eax
  801e7c:	0f 45 c2             	cmovne %edx,%eax
  801e7f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801e82:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e86:	7e 06                	jle    801e8e <vprintfmt+0x199>
  801e88:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801e8c:	75 0d                	jne    801e9b <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801e8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e91:	89 c7                	mov    %eax,%edi
  801e93:	03 45 e0             	add    -0x20(%ebp),%eax
  801e96:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e99:	eb 3f                	jmp    801eda <vprintfmt+0x1e5>
  801e9b:	83 ec 08             	sub    $0x8,%esp
  801e9e:	ff 75 d8             	pushl  -0x28(%ebp)
  801ea1:	50                   	push   %eax
  801ea2:	e8 0d 03 00 00       	call   8021b4 <strnlen>
  801ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eaa:	29 c2                	sub    %eax,%edx
  801eac:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801eaf:	83 c4 10             	add    $0x10,%esp
  801eb2:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801eb4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801eb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801ebb:	85 ff                	test   %edi,%edi
  801ebd:	7e 58                	jle    801f17 <vprintfmt+0x222>
					putch(padc, putdat);
  801ebf:	83 ec 08             	sub    $0x8,%esp
  801ec2:	53                   	push   %ebx
  801ec3:	ff 75 e0             	pushl  -0x20(%ebp)
  801ec6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801ec8:	83 ef 01             	sub    $0x1,%edi
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	eb eb                	jmp    801ebb <vprintfmt+0x1c6>
					putch(ch, putdat);
  801ed0:	83 ec 08             	sub    $0x8,%esp
  801ed3:	53                   	push   %ebx
  801ed4:	52                   	push   %edx
  801ed5:	ff d6                	call   *%esi
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801edd:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801edf:	83 c7 01             	add    $0x1,%edi
  801ee2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801ee6:	0f be d0             	movsbl %al,%edx
  801ee9:	85 d2                	test   %edx,%edx
  801eeb:	74 45                	je     801f32 <vprintfmt+0x23d>
  801eed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801ef1:	78 06                	js     801ef9 <vprintfmt+0x204>
  801ef3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801ef7:	78 35                	js     801f2e <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  801ef9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801efd:	74 d1                	je     801ed0 <vprintfmt+0x1db>
  801eff:	0f be c0             	movsbl %al,%eax
  801f02:	83 e8 20             	sub    $0x20,%eax
  801f05:	83 f8 5e             	cmp    $0x5e,%eax
  801f08:	76 c6                	jbe    801ed0 <vprintfmt+0x1db>
					putch('?', putdat);
  801f0a:	83 ec 08             	sub    $0x8,%esp
  801f0d:	53                   	push   %ebx
  801f0e:	6a 3f                	push   $0x3f
  801f10:	ff d6                	call   *%esi
  801f12:	83 c4 10             	add    $0x10,%esp
  801f15:	eb c3                	jmp    801eda <vprintfmt+0x1e5>
  801f17:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801f1a:	85 d2                	test   %edx,%edx
  801f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f21:	0f 49 c2             	cmovns %edx,%eax
  801f24:	29 c2                	sub    %eax,%edx
  801f26:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801f29:	e9 60 ff ff ff       	jmp    801e8e <vprintfmt+0x199>
  801f2e:	89 cf                	mov    %ecx,%edi
  801f30:	eb 02                	jmp    801f34 <vprintfmt+0x23f>
  801f32:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  801f34:	85 ff                	test   %edi,%edi
  801f36:	7e 10                	jle    801f48 <vprintfmt+0x253>
				putch(' ', putdat);
  801f38:	83 ec 08             	sub    $0x8,%esp
  801f3b:	53                   	push   %ebx
  801f3c:	6a 20                	push   $0x20
  801f3e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801f40:	83 ef 01             	sub    $0x1,%edi
  801f43:	83 c4 10             	add    $0x10,%esp
  801f46:	eb ec                	jmp    801f34 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  801f48:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f4b:	89 45 14             	mov    %eax,0x14(%ebp)
  801f4e:	e9 63 01 00 00       	jmp    8020b6 <vprintfmt+0x3c1>
	if (lflag >= 2)
  801f53:	83 f9 01             	cmp    $0x1,%ecx
  801f56:	7f 1b                	jg     801f73 <vprintfmt+0x27e>
	else if (lflag)
  801f58:	85 c9                	test   %ecx,%ecx
  801f5a:	74 63                	je     801fbf <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  801f5c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f5f:	8b 00                	mov    (%eax),%eax
  801f61:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f64:	99                   	cltd   
  801f65:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801f68:	8b 45 14             	mov    0x14(%ebp),%eax
  801f6b:	8d 40 04             	lea    0x4(%eax),%eax
  801f6e:	89 45 14             	mov    %eax,0x14(%ebp)
  801f71:	eb 17                	jmp    801f8a <vprintfmt+0x295>
		return va_arg(*ap, long long);
  801f73:	8b 45 14             	mov    0x14(%ebp),%eax
  801f76:	8b 50 04             	mov    0x4(%eax),%edx
  801f79:	8b 00                	mov    (%eax),%eax
  801f7b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f7e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801f81:	8b 45 14             	mov    0x14(%ebp),%eax
  801f84:	8d 40 08             	lea    0x8(%eax),%eax
  801f87:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801f8a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f8d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801f90:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801f95:	85 c9                	test   %ecx,%ecx
  801f97:	0f 89 ff 00 00 00    	jns    80209c <vprintfmt+0x3a7>
				putch('-', putdat);
  801f9d:	83 ec 08             	sub    $0x8,%esp
  801fa0:	53                   	push   %ebx
  801fa1:	6a 2d                	push   $0x2d
  801fa3:	ff d6                	call   *%esi
				num = -(long long) num;
  801fa5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fa8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801fab:	f7 da                	neg    %edx
  801fad:	83 d1 00             	adc    $0x0,%ecx
  801fb0:	f7 d9                	neg    %ecx
  801fb2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801fb5:	b8 0a 00 00 00       	mov    $0xa,%eax
  801fba:	e9 dd 00 00 00       	jmp    80209c <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  801fbf:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc2:	8b 00                	mov    (%eax),%eax
  801fc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fc7:	99                   	cltd   
  801fc8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801fcb:	8b 45 14             	mov    0x14(%ebp),%eax
  801fce:	8d 40 04             	lea    0x4(%eax),%eax
  801fd1:	89 45 14             	mov    %eax,0x14(%ebp)
  801fd4:	eb b4                	jmp    801f8a <vprintfmt+0x295>
	if (lflag >= 2)
  801fd6:	83 f9 01             	cmp    $0x1,%ecx
  801fd9:	7f 1e                	jg     801ff9 <vprintfmt+0x304>
	else if (lflag)
  801fdb:	85 c9                	test   %ecx,%ecx
  801fdd:	74 32                	je     802011 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  801fdf:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe2:	8b 10                	mov    (%eax),%edx
  801fe4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fe9:	8d 40 04             	lea    0x4(%eax),%eax
  801fec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801fef:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ff4:	e9 a3 00 00 00       	jmp    80209c <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801ff9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ffc:	8b 10                	mov    (%eax),%edx
  801ffe:	8b 48 04             	mov    0x4(%eax),%ecx
  802001:	8d 40 08             	lea    0x8(%eax),%eax
  802004:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  802007:	b8 0a 00 00 00       	mov    $0xa,%eax
  80200c:	e9 8b 00 00 00       	jmp    80209c <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  802011:	8b 45 14             	mov    0x14(%ebp),%eax
  802014:	8b 10                	mov    (%eax),%edx
  802016:	b9 00 00 00 00       	mov    $0x0,%ecx
  80201b:	8d 40 04             	lea    0x4(%eax),%eax
  80201e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  802021:	b8 0a 00 00 00       	mov    $0xa,%eax
  802026:	eb 74                	jmp    80209c <vprintfmt+0x3a7>
	if (lflag >= 2)
  802028:	83 f9 01             	cmp    $0x1,%ecx
  80202b:	7f 1b                	jg     802048 <vprintfmt+0x353>
	else if (lflag)
  80202d:	85 c9                	test   %ecx,%ecx
  80202f:	74 2c                	je     80205d <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  802031:	8b 45 14             	mov    0x14(%ebp),%eax
  802034:	8b 10                	mov    (%eax),%edx
  802036:	b9 00 00 00 00       	mov    $0x0,%ecx
  80203b:	8d 40 04             	lea    0x4(%eax),%eax
  80203e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802041:	b8 08 00 00 00       	mov    $0x8,%eax
  802046:	eb 54                	jmp    80209c <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  802048:	8b 45 14             	mov    0x14(%ebp),%eax
  80204b:	8b 10                	mov    (%eax),%edx
  80204d:	8b 48 04             	mov    0x4(%eax),%ecx
  802050:	8d 40 08             	lea    0x8(%eax),%eax
  802053:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802056:	b8 08 00 00 00       	mov    $0x8,%eax
  80205b:	eb 3f                	jmp    80209c <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80205d:	8b 45 14             	mov    0x14(%ebp),%eax
  802060:	8b 10                	mov    (%eax),%edx
  802062:	b9 00 00 00 00       	mov    $0x0,%ecx
  802067:	8d 40 04             	lea    0x4(%eax),%eax
  80206a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80206d:	b8 08 00 00 00       	mov    $0x8,%eax
  802072:	eb 28                	jmp    80209c <vprintfmt+0x3a7>
			putch('0', putdat);
  802074:	83 ec 08             	sub    $0x8,%esp
  802077:	53                   	push   %ebx
  802078:	6a 30                	push   $0x30
  80207a:	ff d6                	call   *%esi
			putch('x', putdat);
  80207c:	83 c4 08             	add    $0x8,%esp
  80207f:	53                   	push   %ebx
  802080:	6a 78                	push   $0x78
  802082:	ff d6                	call   *%esi
			num = (unsigned long long)
  802084:	8b 45 14             	mov    0x14(%ebp),%eax
  802087:	8b 10                	mov    (%eax),%edx
  802089:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80208e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  802091:	8d 40 04             	lea    0x4(%eax),%eax
  802094:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802097:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80209c:	83 ec 0c             	sub    $0xc,%esp
  80209f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8020a3:	57                   	push   %edi
  8020a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8020a7:	50                   	push   %eax
  8020a8:	51                   	push   %ecx
  8020a9:	52                   	push   %edx
  8020aa:	89 da                	mov    %ebx,%edx
  8020ac:	89 f0                	mov    %esi,%eax
  8020ae:	e8 5a fb ff ff       	call   801c0d <printnum>
			break;
  8020b3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8020b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8020b9:	e9 55 fc ff ff       	jmp    801d13 <vprintfmt+0x1e>
	if (lflag >= 2)
  8020be:	83 f9 01             	cmp    $0x1,%ecx
  8020c1:	7f 1b                	jg     8020de <vprintfmt+0x3e9>
	else if (lflag)
  8020c3:	85 c9                	test   %ecx,%ecx
  8020c5:	74 2c                	je     8020f3 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8020c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ca:	8b 10                	mov    (%eax),%edx
  8020cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020d1:	8d 40 04             	lea    0x4(%eax),%eax
  8020d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8020d7:	b8 10 00 00 00       	mov    $0x10,%eax
  8020dc:	eb be                	jmp    80209c <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8020de:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e1:	8b 10                	mov    (%eax),%edx
  8020e3:	8b 48 04             	mov    0x4(%eax),%ecx
  8020e6:	8d 40 08             	lea    0x8(%eax),%eax
  8020e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8020ec:	b8 10 00 00 00       	mov    $0x10,%eax
  8020f1:	eb a9                	jmp    80209c <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8020f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8020f6:	8b 10                	mov    (%eax),%edx
  8020f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020fd:	8d 40 04             	lea    0x4(%eax),%eax
  802100:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802103:	b8 10 00 00 00       	mov    $0x10,%eax
  802108:	eb 92                	jmp    80209c <vprintfmt+0x3a7>
			putch(ch, putdat);
  80210a:	83 ec 08             	sub    $0x8,%esp
  80210d:	53                   	push   %ebx
  80210e:	6a 25                	push   $0x25
  802110:	ff d6                	call   *%esi
			break;
  802112:	83 c4 10             	add    $0x10,%esp
  802115:	eb 9f                	jmp    8020b6 <vprintfmt+0x3c1>
			putch('%', putdat);
  802117:	83 ec 08             	sub    $0x8,%esp
  80211a:	53                   	push   %ebx
  80211b:	6a 25                	push   $0x25
  80211d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80211f:	83 c4 10             	add    $0x10,%esp
  802122:	89 f8                	mov    %edi,%eax
  802124:	eb 03                	jmp    802129 <vprintfmt+0x434>
  802126:	83 e8 01             	sub    $0x1,%eax
  802129:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80212d:	75 f7                	jne    802126 <vprintfmt+0x431>
  80212f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802132:	eb 82                	jmp    8020b6 <vprintfmt+0x3c1>

00802134 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	83 ec 18             	sub    $0x18,%esp
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  802140:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802143:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802147:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80214a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  802151:	85 c0                	test   %eax,%eax
  802153:	74 26                	je     80217b <vsnprintf+0x47>
  802155:	85 d2                	test   %edx,%edx
  802157:	7e 22                	jle    80217b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802159:	ff 75 14             	pushl  0x14(%ebp)
  80215c:	ff 75 10             	pushl  0x10(%ebp)
  80215f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802162:	50                   	push   %eax
  802163:	68 bb 1c 80 00       	push   $0x801cbb
  802168:	e8 88 fb ff ff       	call   801cf5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80216d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802170:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	83 c4 10             	add    $0x10,%esp
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    
		return -E_INVAL;
  80217b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802180:	eb f7                	jmp    802179 <vsnprintf+0x45>

00802182 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802188:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80218b:	50                   	push   %eax
  80218c:	ff 75 10             	pushl  0x10(%ebp)
  80218f:	ff 75 0c             	pushl  0xc(%ebp)
  802192:	ff 75 08             	pushl  0x8(%ebp)
  802195:	e8 9a ff ff ff       	call   802134 <vsnprintf>
	va_end(ap);

	return rc;
}
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8021a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8021ab:	74 05                	je     8021b2 <strlen+0x16>
		n++;
  8021ad:	83 c0 01             	add    $0x1,%eax
  8021b0:	eb f5                	jmp    8021a7 <strlen+0xb>
	return n;
}
  8021b2:	5d                   	pop    %ebp
  8021b3:	c3                   	ret    

008021b4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021ba:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8021bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c2:	39 c2                	cmp    %eax,%edx
  8021c4:	74 0d                	je     8021d3 <strnlen+0x1f>
  8021c6:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8021ca:	74 05                	je     8021d1 <strnlen+0x1d>
		n++;
  8021cc:	83 c2 01             	add    $0x1,%edx
  8021cf:	eb f1                	jmp    8021c2 <strnlen+0xe>
  8021d1:	89 d0                	mov    %edx,%eax
	return n;
}
  8021d3:	5d                   	pop    %ebp
  8021d4:	c3                   	ret    

008021d5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	53                   	push   %ebx
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8021df:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e4:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8021e8:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8021eb:	83 c2 01             	add    $0x1,%edx
  8021ee:	84 c9                	test   %cl,%cl
  8021f0:	75 f2                	jne    8021e4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8021f2:	5b                   	pop    %ebx
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    

008021f5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	53                   	push   %ebx
  8021f9:	83 ec 10             	sub    $0x10,%esp
  8021fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8021ff:	53                   	push   %ebx
  802200:	e8 97 ff ff ff       	call   80219c <strlen>
  802205:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  802208:	ff 75 0c             	pushl  0xc(%ebp)
  80220b:	01 d8                	add    %ebx,%eax
  80220d:	50                   	push   %eax
  80220e:	e8 c2 ff ff ff       	call   8021d5 <strcpy>
	return dst;
}
  802213:	89 d8                	mov    %ebx,%eax
  802215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	56                   	push   %esi
  80221e:	53                   	push   %ebx
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802225:	89 c6                	mov    %eax,%esi
  802227:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80222a:	89 c2                	mov    %eax,%edx
  80222c:	39 f2                	cmp    %esi,%edx
  80222e:	74 11                	je     802241 <strncpy+0x27>
		*dst++ = *src;
  802230:	83 c2 01             	add    $0x1,%edx
  802233:	0f b6 19             	movzbl (%ecx),%ebx
  802236:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  802239:	80 fb 01             	cmp    $0x1,%bl
  80223c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80223f:	eb eb                	jmp    80222c <strncpy+0x12>
	}
	return ret;
}
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    

00802245 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	56                   	push   %esi
  802249:	53                   	push   %ebx
  80224a:	8b 75 08             	mov    0x8(%ebp),%esi
  80224d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802250:	8b 55 10             	mov    0x10(%ebp),%edx
  802253:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802255:	85 d2                	test   %edx,%edx
  802257:	74 21                	je     80227a <strlcpy+0x35>
  802259:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80225d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80225f:	39 c2                	cmp    %eax,%edx
  802261:	74 14                	je     802277 <strlcpy+0x32>
  802263:	0f b6 19             	movzbl (%ecx),%ebx
  802266:	84 db                	test   %bl,%bl
  802268:	74 0b                	je     802275 <strlcpy+0x30>
			*dst++ = *src++;
  80226a:	83 c1 01             	add    $0x1,%ecx
  80226d:	83 c2 01             	add    $0x1,%edx
  802270:	88 5a ff             	mov    %bl,-0x1(%edx)
  802273:	eb ea                	jmp    80225f <strlcpy+0x1a>
  802275:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  802277:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80227a:	29 f0                	sub    %esi,%eax
}
  80227c:	5b                   	pop    %ebx
  80227d:	5e                   	pop    %esi
  80227e:	5d                   	pop    %ebp
  80227f:	c3                   	ret    

00802280 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802286:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802289:	0f b6 01             	movzbl (%ecx),%eax
  80228c:	84 c0                	test   %al,%al
  80228e:	74 0c                	je     80229c <strcmp+0x1c>
  802290:	3a 02                	cmp    (%edx),%al
  802292:	75 08                	jne    80229c <strcmp+0x1c>
		p++, q++;
  802294:	83 c1 01             	add    $0x1,%ecx
  802297:	83 c2 01             	add    $0x1,%edx
  80229a:	eb ed                	jmp    802289 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80229c:	0f b6 c0             	movzbl %al,%eax
  80229f:	0f b6 12             	movzbl (%edx),%edx
  8022a2:	29 d0                	sub    %edx,%eax
}
  8022a4:	5d                   	pop    %ebp
  8022a5:	c3                   	ret    

008022a6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	53                   	push   %ebx
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b0:	89 c3                	mov    %eax,%ebx
  8022b2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8022b5:	eb 06                	jmp    8022bd <strncmp+0x17>
		n--, p++, q++;
  8022b7:	83 c0 01             	add    $0x1,%eax
  8022ba:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8022bd:	39 d8                	cmp    %ebx,%eax
  8022bf:	74 16                	je     8022d7 <strncmp+0x31>
  8022c1:	0f b6 08             	movzbl (%eax),%ecx
  8022c4:	84 c9                	test   %cl,%cl
  8022c6:	74 04                	je     8022cc <strncmp+0x26>
  8022c8:	3a 0a                	cmp    (%edx),%cl
  8022ca:	74 eb                	je     8022b7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8022cc:	0f b6 00             	movzbl (%eax),%eax
  8022cf:	0f b6 12             	movzbl (%edx),%edx
  8022d2:	29 d0                	sub    %edx,%eax
}
  8022d4:	5b                   	pop    %ebx
  8022d5:	5d                   	pop    %ebp
  8022d6:	c3                   	ret    
		return 0;
  8022d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022dc:	eb f6                	jmp    8022d4 <strncmp+0x2e>

008022de <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8022e8:	0f b6 10             	movzbl (%eax),%edx
  8022eb:	84 d2                	test   %dl,%dl
  8022ed:	74 09                	je     8022f8 <strchr+0x1a>
		if (*s == c)
  8022ef:	38 ca                	cmp    %cl,%dl
  8022f1:	74 0a                	je     8022fd <strchr+0x1f>
	for (; *s; s++)
  8022f3:	83 c0 01             	add    $0x1,%eax
  8022f6:	eb f0                	jmp    8022e8 <strchr+0xa>
			return (char *) s;
	return 0;
  8022f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022fd:	5d                   	pop    %ebp
  8022fe:	c3                   	ret    

008022ff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	8b 45 08             	mov    0x8(%ebp),%eax
  802305:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802309:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80230c:	38 ca                	cmp    %cl,%dl
  80230e:	74 09                	je     802319 <strfind+0x1a>
  802310:	84 d2                	test   %dl,%dl
  802312:	74 05                	je     802319 <strfind+0x1a>
	for (; *s; s++)
  802314:	83 c0 01             	add    $0x1,%eax
  802317:	eb f0                	jmp    802309 <strfind+0xa>
			break;
	return (char *) s;
}
  802319:	5d                   	pop    %ebp
  80231a:	c3                   	ret    

0080231b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	57                   	push   %edi
  80231f:	56                   	push   %esi
  802320:	53                   	push   %ebx
  802321:	8b 7d 08             	mov    0x8(%ebp),%edi
  802324:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802327:	85 c9                	test   %ecx,%ecx
  802329:	74 31                	je     80235c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80232b:	89 f8                	mov    %edi,%eax
  80232d:	09 c8                	or     %ecx,%eax
  80232f:	a8 03                	test   $0x3,%al
  802331:	75 23                	jne    802356 <memset+0x3b>
		c &= 0xFF;
  802333:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802337:	89 d3                	mov    %edx,%ebx
  802339:	c1 e3 08             	shl    $0x8,%ebx
  80233c:	89 d0                	mov    %edx,%eax
  80233e:	c1 e0 18             	shl    $0x18,%eax
  802341:	89 d6                	mov    %edx,%esi
  802343:	c1 e6 10             	shl    $0x10,%esi
  802346:	09 f0                	or     %esi,%eax
  802348:	09 c2                	or     %eax,%edx
  80234a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80234c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80234f:	89 d0                	mov    %edx,%eax
  802351:	fc                   	cld    
  802352:	f3 ab                	rep stos %eax,%es:(%edi)
  802354:	eb 06                	jmp    80235c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802356:	8b 45 0c             	mov    0xc(%ebp),%eax
  802359:	fc                   	cld    
  80235a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80235c:	89 f8                	mov    %edi,%eax
  80235e:	5b                   	pop    %ebx
  80235f:	5e                   	pop    %esi
  802360:	5f                   	pop    %edi
  802361:	5d                   	pop    %ebp
  802362:	c3                   	ret    

00802363 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
  802366:	57                   	push   %edi
  802367:	56                   	push   %esi
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80236e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802371:	39 c6                	cmp    %eax,%esi
  802373:	73 32                	jae    8023a7 <memmove+0x44>
  802375:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802378:	39 c2                	cmp    %eax,%edx
  80237a:	76 2b                	jbe    8023a7 <memmove+0x44>
		s += n;
		d += n;
  80237c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80237f:	89 fe                	mov    %edi,%esi
  802381:	09 ce                	or     %ecx,%esi
  802383:	09 d6                	or     %edx,%esi
  802385:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80238b:	75 0e                	jne    80239b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80238d:	83 ef 04             	sub    $0x4,%edi
  802390:	8d 72 fc             	lea    -0x4(%edx),%esi
  802393:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  802396:	fd                   	std    
  802397:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802399:	eb 09                	jmp    8023a4 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80239b:	83 ef 01             	sub    $0x1,%edi
  80239e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8023a1:	fd                   	std    
  8023a2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8023a4:	fc                   	cld    
  8023a5:	eb 1a                	jmp    8023c1 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8023a7:	89 c2                	mov    %eax,%edx
  8023a9:	09 ca                	or     %ecx,%edx
  8023ab:	09 f2                	or     %esi,%edx
  8023ad:	f6 c2 03             	test   $0x3,%dl
  8023b0:	75 0a                	jne    8023bc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8023b2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8023b5:	89 c7                	mov    %eax,%edi
  8023b7:	fc                   	cld    
  8023b8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8023ba:	eb 05                	jmp    8023c1 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8023bc:	89 c7                	mov    %eax,%edi
  8023be:	fc                   	cld    
  8023bf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8023c1:	5e                   	pop    %esi
  8023c2:	5f                   	pop    %edi
  8023c3:	5d                   	pop    %ebp
  8023c4:	c3                   	ret    

008023c5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8023cb:	ff 75 10             	pushl  0x10(%ebp)
  8023ce:	ff 75 0c             	pushl  0xc(%ebp)
  8023d1:	ff 75 08             	pushl  0x8(%ebp)
  8023d4:	e8 8a ff ff ff       	call   802363 <memmove>
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	56                   	push   %esi
  8023df:	53                   	push   %ebx
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e6:	89 c6                	mov    %eax,%esi
  8023e8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8023eb:	39 f0                	cmp    %esi,%eax
  8023ed:	74 1c                	je     80240b <memcmp+0x30>
		if (*s1 != *s2)
  8023ef:	0f b6 08             	movzbl (%eax),%ecx
  8023f2:	0f b6 1a             	movzbl (%edx),%ebx
  8023f5:	38 d9                	cmp    %bl,%cl
  8023f7:	75 08                	jne    802401 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8023f9:	83 c0 01             	add    $0x1,%eax
  8023fc:	83 c2 01             	add    $0x1,%edx
  8023ff:	eb ea                	jmp    8023eb <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  802401:	0f b6 c1             	movzbl %cl,%eax
  802404:	0f b6 db             	movzbl %bl,%ebx
  802407:	29 d8                	sub    %ebx,%eax
  802409:	eb 05                	jmp    802410 <memcmp+0x35>
	}

	return 0;
  80240b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802410:	5b                   	pop    %ebx
  802411:	5e                   	pop    %esi
  802412:	5d                   	pop    %ebp
  802413:	c3                   	ret    

00802414 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80241d:	89 c2                	mov    %eax,%edx
  80241f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802422:	39 d0                	cmp    %edx,%eax
  802424:	73 09                	jae    80242f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  802426:	38 08                	cmp    %cl,(%eax)
  802428:	74 05                	je     80242f <memfind+0x1b>
	for (; s < ends; s++)
  80242a:	83 c0 01             	add    $0x1,%eax
  80242d:	eb f3                	jmp    802422 <memfind+0xe>
			break;
	return (void *) s;
}
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    

00802431 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	57                   	push   %edi
  802435:	56                   	push   %esi
  802436:	53                   	push   %ebx
  802437:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80243a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80243d:	eb 03                	jmp    802442 <strtol+0x11>
		s++;
  80243f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  802442:	0f b6 01             	movzbl (%ecx),%eax
  802445:	3c 20                	cmp    $0x20,%al
  802447:	74 f6                	je     80243f <strtol+0xe>
  802449:	3c 09                	cmp    $0x9,%al
  80244b:	74 f2                	je     80243f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80244d:	3c 2b                	cmp    $0x2b,%al
  80244f:	74 2a                	je     80247b <strtol+0x4a>
	int neg = 0;
  802451:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  802456:	3c 2d                	cmp    $0x2d,%al
  802458:	74 2b                	je     802485 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80245a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  802460:	75 0f                	jne    802471 <strtol+0x40>
  802462:	80 39 30             	cmpb   $0x30,(%ecx)
  802465:	74 28                	je     80248f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802467:	85 db                	test   %ebx,%ebx
  802469:	b8 0a 00 00 00       	mov    $0xa,%eax
  80246e:	0f 44 d8             	cmove  %eax,%ebx
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
  802476:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802479:	eb 50                	jmp    8024cb <strtol+0x9a>
		s++;
  80247b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80247e:	bf 00 00 00 00       	mov    $0x0,%edi
  802483:	eb d5                	jmp    80245a <strtol+0x29>
		s++, neg = 1;
  802485:	83 c1 01             	add    $0x1,%ecx
  802488:	bf 01 00 00 00       	mov    $0x1,%edi
  80248d:	eb cb                	jmp    80245a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80248f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  802493:	74 0e                	je     8024a3 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  802495:	85 db                	test   %ebx,%ebx
  802497:	75 d8                	jne    802471 <strtol+0x40>
		s++, base = 8;
  802499:	83 c1 01             	add    $0x1,%ecx
  80249c:	bb 08 00 00 00       	mov    $0x8,%ebx
  8024a1:	eb ce                	jmp    802471 <strtol+0x40>
		s += 2, base = 16;
  8024a3:	83 c1 02             	add    $0x2,%ecx
  8024a6:	bb 10 00 00 00       	mov    $0x10,%ebx
  8024ab:	eb c4                	jmp    802471 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8024ad:	8d 72 9f             	lea    -0x61(%edx),%esi
  8024b0:	89 f3                	mov    %esi,%ebx
  8024b2:	80 fb 19             	cmp    $0x19,%bl
  8024b5:	77 29                	ja     8024e0 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8024b7:	0f be d2             	movsbl %dl,%edx
  8024ba:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8024bd:	3b 55 10             	cmp    0x10(%ebp),%edx
  8024c0:	7d 30                	jge    8024f2 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8024c2:	83 c1 01             	add    $0x1,%ecx
  8024c5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8024c9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8024cb:	0f b6 11             	movzbl (%ecx),%edx
  8024ce:	8d 72 d0             	lea    -0x30(%edx),%esi
  8024d1:	89 f3                	mov    %esi,%ebx
  8024d3:	80 fb 09             	cmp    $0x9,%bl
  8024d6:	77 d5                	ja     8024ad <strtol+0x7c>
			dig = *s - '0';
  8024d8:	0f be d2             	movsbl %dl,%edx
  8024db:	83 ea 30             	sub    $0x30,%edx
  8024de:	eb dd                	jmp    8024bd <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8024e0:	8d 72 bf             	lea    -0x41(%edx),%esi
  8024e3:	89 f3                	mov    %esi,%ebx
  8024e5:	80 fb 19             	cmp    $0x19,%bl
  8024e8:	77 08                	ja     8024f2 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8024ea:	0f be d2             	movsbl %dl,%edx
  8024ed:	83 ea 37             	sub    $0x37,%edx
  8024f0:	eb cb                	jmp    8024bd <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8024f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024f6:	74 05                	je     8024fd <strtol+0xcc>
		*endptr = (char *) s;
  8024f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024fb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8024fd:	89 c2                	mov    %eax,%edx
  8024ff:	f7 da                	neg    %edx
  802501:	85 ff                	test   %edi,%edi
  802503:	0f 45 c2             	cmovne %edx,%eax
}
  802506:	5b                   	pop    %ebx
  802507:	5e                   	pop    %esi
  802508:	5f                   	pop    %edi
  802509:	5d                   	pop    %ebp
  80250a:	c3                   	ret    

0080250b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
  80250e:	57                   	push   %edi
  80250f:	56                   	push   %esi
  802510:	53                   	push   %ebx
	asm volatile("int %1\n"
  802511:	b8 00 00 00 00       	mov    $0x0,%eax
  802516:	8b 55 08             	mov    0x8(%ebp),%edx
  802519:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80251c:	89 c3                	mov    %eax,%ebx
  80251e:	89 c7                	mov    %eax,%edi
  802520:	89 c6                	mov    %eax,%esi
  802522:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  802524:	5b                   	pop    %ebx
  802525:	5e                   	pop    %esi
  802526:	5f                   	pop    %edi
  802527:	5d                   	pop    %ebp
  802528:	c3                   	ret    

00802529 <sys_cgetc>:

int
sys_cgetc(void)
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	57                   	push   %edi
  80252d:	56                   	push   %esi
  80252e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80252f:	ba 00 00 00 00       	mov    $0x0,%edx
  802534:	b8 01 00 00 00       	mov    $0x1,%eax
  802539:	89 d1                	mov    %edx,%ecx
  80253b:	89 d3                	mov    %edx,%ebx
  80253d:	89 d7                	mov    %edx,%edi
  80253f:	89 d6                	mov    %edx,%esi
  802541:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  802543:	5b                   	pop    %ebx
  802544:	5e                   	pop    %esi
  802545:	5f                   	pop    %edi
  802546:	5d                   	pop    %ebp
  802547:	c3                   	ret    

00802548 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
  80254b:	57                   	push   %edi
  80254c:	56                   	push   %esi
  80254d:	53                   	push   %ebx
  80254e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802551:	b9 00 00 00 00       	mov    $0x0,%ecx
  802556:	8b 55 08             	mov    0x8(%ebp),%edx
  802559:	b8 03 00 00 00       	mov    $0x3,%eax
  80255e:	89 cb                	mov    %ecx,%ebx
  802560:	89 cf                	mov    %ecx,%edi
  802562:	89 ce                	mov    %ecx,%esi
  802564:	cd 30                	int    $0x30
	if(check && ret > 0)
  802566:	85 c0                	test   %eax,%eax
  802568:	7f 08                	jg     802572 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80256a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80256d:	5b                   	pop    %ebx
  80256e:	5e                   	pop    %esi
  80256f:	5f                   	pop    %edi
  802570:	5d                   	pop    %ebp
  802571:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802572:	83 ec 0c             	sub    $0xc,%esp
  802575:	50                   	push   %eax
  802576:	6a 03                	push   $0x3
  802578:	68 7f 46 80 00       	push   $0x80467f
  80257d:	6a 23                	push   $0x23
  80257f:	68 9c 46 80 00       	push   $0x80469c
  802584:	e8 95 f5 ff ff       	call   801b1e <_panic>

00802589 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
  80258c:	57                   	push   %edi
  80258d:	56                   	push   %esi
  80258e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80258f:	ba 00 00 00 00       	mov    $0x0,%edx
  802594:	b8 02 00 00 00       	mov    $0x2,%eax
  802599:	89 d1                	mov    %edx,%ecx
  80259b:	89 d3                	mov    %edx,%ebx
  80259d:	89 d7                	mov    %edx,%edi
  80259f:	89 d6                	mov    %edx,%esi
  8025a1:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8025a3:	5b                   	pop    %ebx
  8025a4:	5e                   	pop    %esi
  8025a5:	5f                   	pop    %edi
  8025a6:	5d                   	pop    %ebp
  8025a7:	c3                   	ret    

008025a8 <sys_yield>:

void
sys_yield(void)
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
  8025ab:	57                   	push   %edi
  8025ac:	56                   	push   %esi
  8025ad:	53                   	push   %ebx
	asm volatile("int %1\n"
  8025ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8025b8:	89 d1                	mov    %edx,%ecx
  8025ba:	89 d3                	mov    %edx,%ebx
  8025bc:	89 d7                	mov    %edx,%edi
  8025be:	89 d6                	mov    %edx,%esi
  8025c0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8025c2:	5b                   	pop    %ebx
  8025c3:	5e                   	pop    %esi
  8025c4:	5f                   	pop    %edi
  8025c5:	5d                   	pop    %ebp
  8025c6:	c3                   	ret    

008025c7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8025c7:	55                   	push   %ebp
  8025c8:	89 e5                	mov    %esp,%ebp
  8025ca:	57                   	push   %edi
  8025cb:	56                   	push   %esi
  8025cc:	53                   	push   %ebx
  8025cd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8025d0:	be 00 00 00 00       	mov    $0x0,%esi
  8025d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025db:	b8 04 00 00 00       	mov    $0x4,%eax
  8025e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025e3:	89 f7                	mov    %esi,%edi
  8025e5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	7f 08                	jg     8025f3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8025eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025ee:	5b                   	pop    %ebx
  8025ef:	5e                   	pop    %esi
  8025f0:	5f                   	pop    %edi
  8025f1:	5d                   	pop    %ebp
  8025f2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8025f3:	83 ec 0c             	sub    $0xc,%esp
  8025f6:	50                   	push   %eax
  8025f7:	6a 04                	push   $0x4
  8025f9:	68 7f 46 80 00       	push   $0x80467f
  8025fe:	6a 23                	push   $0x23
  802600:	68 9c 46 80 00       	push   $0x80469c
  802605:	e8 14 f5 ff ff       	call   801b1e <_panic>

0080260a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	57                   	push   %edi
  80260e:	56                   	push   %esi
  80260f:	53                   	push   %ebx
  802610:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802613:	8b 55 08             	mov    0x8(%ebp),%edx
  802616:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802619:	b8 05 00 00 00       	mov    $0x5,%eax
  80261e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802621:	8b 7d 14             	mov    0x14(%ebp),%edi
  802624:	8b 75 18             	mov    0x18(%ebp),%esi
  802627:	cd 30                	int    $0x30
	if(check && ret > 0)
  802629:	85 c0                	test   %eax,%eax
  80262b:	7f 08                	jg     802635 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80262d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802630:	5b                   	pop    %ebx
  802631:	5e                   	pop    %esi
  802632:	5f                   	pop    %edi
  802633:	5d                   	pop    %ebp
  802634:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802635:	83 ec 0c             	sub    $0xc,%esp
  802638:	50                   	push   %eax
  802639:	6a 05                	push   $0x5
  80263b:	68 7f 46 80 00       	push   $0x80467f
  802640:	6a 23                	push   $0x23
  802642:	68 9c 46 80 00       	push   $0x80469c
  802647:	e8 d2 f4 ff ff       	call   801b1e <_panic>

0080264c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	57                   	push   %edi
  802650:	56                   	push   %esi
  802651:	53                   	push   %ebx
  802652:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802655:	bb 00 00 00 00       	mov    $0x0,%ebx
  80265a:	8b 55 08             	mov    0x8(%ebp),%edx
  80265d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802660:	b8 06 00 00 00       	mov    $0x6,%eax
  802665:	89 df                	mov    %ebx,%edi
  802667:	89 de                	mov    %ebx,%esi
  802669:	cd 30                	int    $0x30
	if(check && ret > 0)
  80266b:	85 c0                	test   %eax,%eax
  80266d:	7f 08                	jg     802677 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80266f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802672:	5b                   	pop    %ebx
  802673:	5e                   	pop    %esi
  802674:	5f                   	pop    %edi
  802675:	5d                   	pop    %ebp
  802676:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802677:	83 ec 0c             	sub    $0xc,%esp
  80267a:	50                   	push   %eax
  80267b:	6a 06                	push   $0x6
  80267d:	68 7f 46 80 00       	push   $0x80467f
  802682:	6a 23                	push   $0x23
  802684:	68 9c 46 80 00       	push   $0x80469c
  802689:	e8 90 f4 ff ff       	call   801b1e <_panic>

0080268e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	57                   	push   %edi
  802692:	56                   	push   %esi
  802693:	53                   	push   %ebx
  802694:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802697:	bb 00 00 00 00       	mov    $0x0,%ebx
  80269c:	8b 55 08             	mov    0x8(%ebp),%edx
  80269f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026a2:	b8 08 00 00 00       	mov    $0x8,%eax
  8026a7:	89 df                	mov    %ebx,%edi
  8026a9:	89 de                	mov    %ebx,%esi
  8026ab:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	7f 08                	jg     8026b9 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8026b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026b4:	5b                   	pop    %ebx
  8026b5:	5e                   	pop    %esi
  8026b6:	5f                   	pop    %edi
  8026b7:	5d                   	pop    %ebp
  8026b8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026b9:	83 ec 0c             	sub    $0xc,%esp
  8026bc:	50                   	push   %eax
  8026bd:	6a 08                	push   $0x8
  8026bf:	68 7f 46 80 00       	push   $0x80467f
  8026c4:	6a 23                	push   $0x23
  8026c6:	68 9c 46 80 00       	push   $0x80469c
  8026cb:	e8 4e f4 ff ff       	call   801b1e <_panic>

008026d0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
  8026d3:	57                   	push   %edi
  8026d4:	56                   	push   %esi
  8026d5:	53                   	push   %ebx
  8026d6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8026d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026de:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026e4:	b8 09 00 00 00       	mov    $0x9,%eax
  8026e9:	89 df                	mov    %ebx,%edi
  8026eb:	89 de                	mov    %ebx,%esi
  8026ed:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	7f 08                	jg     8026fb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8026f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026f6:	5b                   	pop    %ebx
  8026f7:	5e                   	pop    %esi
  8026f8:	5f                   	pop    %edi
  8026f9:	5d                   	pop    %ebp
  8026fa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026fb:	83 ec 0c             	sub    $0xc,%esp
  8026fe:	50                   	push   %eax
  8026ff:	6a 09                	push   $0x9
  802701:	68 7f 46 80 00       	push   $0x80467f
  802706:	6a 23                	push   $0x23
  802708:	68 9c 46 80 00       	push   $0x80469c
  80270d:	e8 0c f4 ff ff       	call   801b1e <_panic>

00802712 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802712:	55                   	push   %ebp
  802713:	89 e5                	mov    %esp,%ebp
  802715:	57                   	push   %edi
  802716:	56                   	push   %esi
  802717:	53                   	push   %ebx
  802718:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80271b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802720:	8b 55 08             	mov    0x8(%ebp),%edx
  802723:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802726:	b8 0a 00 00 00       	mov    $0xa,%eax
  80272b:	89 df                	mov    %ebx,%edi
  80272d:	89 de                	mov    %ebx,%esi
  80272f:	cd 30                	int    $0x30
	if(check && ret > 0)
  802731:	85 c0                	test   %eax,%eax
  802733:	7f 08                	jg     80273d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802735:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802738:	5b                   	pop    %ebx
  802739:	5e                   	pop    %esi
  80273a:	5f                   	pop    %edi
  80273b:	5d                   	pop    %ebp
  80273c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80273d:	83 ec 0c             	sub    $0xc,%esp
  802740:	50                   	push   %eax
  802741:	6a 0a                	push   $0xa
  802743:	68 7f 46 80 00       	push   $0x80467f
  802748:	6a 23                	push   $0x23
  80274a:	68 9c 46 80 00       	push   $0x80469c
  80274f:	e8 ca f3 ff ff       	call   801b1e <_panic>

00802754 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	57                   	push   %edi
  802758:	56                   	push   %esi
  802759:	53                   	push   %ebx
	asm volatile("int %1\n"
  80275a:	8b 55 08             	mov    0x8(%ebp),%edx
  80275d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802760:	b8 0c 00 00 00       	mov    $0xc,%eax
  802765:	be 00 00 00 00       	mov    $0x0,%esi
  80276a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80276d:	8b 7d 14             	mov    0x14(%ebp),%edi
  802770:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802772:	5b                   	pop    %ebx
  802773:	5e                   	pop    %esi
  802774:	5f                   	pop    %edi
  802775:	5d                   	pop    %ebp
  802776:	c3                   	ret    

00802777 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
  80277a:	57                   	push   %edi
  80277b:	56                   	push   %esi
  80277c:	53                   	push   %ebx
  80277d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802780:	b9 00 00 00 00       	mov    $0x0,%ecx
  802785:	8b 55 08             	mov    0x8(%ebp),%edx
  802788:	b8 0d 00 00 00       	mov    $0xd,%eax
  80278d:	89 cb                	mov    %ecx,%ebx
  80278f:	89 cf                	mov    %ecx,%edi
  802791:	89 ce                	mov    %ecx,%esi
  802793:	cd 30                	int    $0x30
	if(check && ret > 0)
  802795:	85 c0                	test   %eax,%eax
  802797:	7f 08                	jg     8027a1 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802799:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80279c:	5b                   	pop    %ebx
  80279d:	5e                   	pop    %esi
  80279e:	5f                   	pop    %edi
  80279f:	5d                   	pop    %ebp
  8027a0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8027a1:	83 ec 0c             	sub    $0xc,%esp
  8027a4:	50                   	push   %eax
  8027a5:	6a 0d                	push   $0xd
  8027a7:	68 7f 46 80 00       	push   $0x80467f
  8027ac:	6a 23                	push   $0x23
  8027ae:	68 9c 46 80 00       	push   $0x80469c
  8027b3:	e8 66 f3 ff ff       	call   801b1e <_panic>

008027b8 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
  8027bb:	57                   	push   %edi
  8027bc:	56                   	push   %esi
  8027bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8027be:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c3:	b8 0e 00 00 00       	mov    $0xe,%eax
  8027c8:	89 d1                	mov    %edx,%ecx
  8027ca:	89 d3                	mov    %edx,%ebx
  8027cc:	89 d7                	mov    %edx,%edi
  8027ce:	89 d6                	mov    %edx,%esi
  8027d0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8027d2:	5b                   	pop    %ebx
  8027d3:	5e                   	pop    %esi
  8027d4:	5f                   	pop    %edi
  8027d5:	5d                   	pop    %ebp
  8027d6:	c3                   	ret    

008027d7 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027d7:	55                   	push   %ebp
  8027d8:	89 e5                	mov    %esp,%ebp
  8027da:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027dd:	83 3d 14 a0 80 00 00 	cmpl   $0x0,0x80a014
  8027e4:	74 0a                	je     8027f0 <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e9:	a3 14 a0 80 00       	mov    %eax,0x80a014
}
  8027ee:	c9                   	leave  
  8027ef:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8027f0:	a1 10 a0 80 00       	mov    0x80a010,%eax
  8027f5:	8b 40 48             	mov    0x48(%eax),%eax
  8027f8:	83 ec 04             	sub    $0x4,%esp
  8027fb:	6a 07                	push   $0x7
  8027fd:	68 00 f0 bf ee       	push   $0xeebff000
  802802:	50                   	push   %eax
  802803:	e8 bf fd ff ff       	call   8025c7 <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802808:	83 c4 10             	add    $0x10,%esp
  80280b:	85 c0                	test   %eax,%eax
  80280d:	78 2c                	js     80283b <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80280f:	e8 75 fd ff ff       	call   802589 <sys_getenvid>
  802814:	83 ec 08             	sub    $0x8,%esp
  802817:	68 4d 28 80 00       	push   $0x80284d
  80281c:	50                   	push   %eax
  80281d:	e8 f0 fe ff ff       	call   802712 <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802822:	83 c4 10             	add    $0x10,%esp
  802825:	85 c0                	test   %eax,%eax
  802827:	79 bd                	jns    8027e6 <set_pgfault_handler+0xf>
  802829:	50                   	push   %eax
  80282a:	68 aa 46 80 00       	push   $0x8046aa
  80282f:	6a 23                	push   $0x23
  802831:	68 c2 46 80 00       	push   $0x8046c2
  802836:	e8 e3 f2 ff ff       	call   801b1e <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80283b:	50                   	push   %eax
  80283c:	68 aa 46 80 00       	push   $0x8046aa
  802841:	6a 21                	push   $0x21
  802843:	68 c2 46 80 00       	push   $0x8046c2
  802848:	e8 d1 f2 ff ff       	call   801b1e <_panic>

0080284d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80284d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80284e:	a1 14 a0 80 00       	mov    0x80a014,%eax
	call *%eax
  802853:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802855:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  802858:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  80285c:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  80285f:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  802863:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  802867:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80286a:	83 c4 08             	add    $0x8,%esp
	popal
  80286d:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  80286e:	83 c4 04             	add    $0x4,%esp
	popfl
  802871:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802872:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802873:	c3                   	ret    

00802874 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	56                   	push   %esi
  802878:	53                   	push   %ebx
  802879:	8b 75 08             	mov    0x8(%ebp),%esi
  80287c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802882:	85 c0                	test   %eax,%eax
  802884:	74 4f                	je     8028d5 <ipc_recv+0x61>
  802886:	83 ec 0c             	sub    $0xc,%esp
  802889:	50                   	push   %eax
  80288a:	e8 e8 fe ff ff       	call   802777 <sys_ipc_recv>
  80288f:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  802892:	85 f6                	test   %esi,%esi
  802894:	74 14                	je     8028aa <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802896:	ba 00 00 00 00       	mov    $0x0,%edx
  80289b:	85 c0                	test   %eax,%eax
  80289d:	75 09                	jne    8028a8 <ipc_recv+0x34>
  80289f:	8b 15 10 a0 80 00    	mov    0x80a010,%edx
  8028a5:	8b 52 74             	mov    0x74(%edx),%edx
  8028a8:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8028aa:	85 db                	test   %ebx,%ebx
  8028ac:	74 14                	je     8028c2 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8028ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	75 09                	jne    8028c0 <ipc_recv+0x4c>
  8028b7:	8b 15 10 a0 80 00    	mov    0x80a010,%edx
  8028bd:	8b 52 78             	mov    0x78(%edx),%edx
  8028c0:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	75 08                	jne    8028ce <ipc_recv+0x5a>
  8028c6:	a1 10 a0 80 00       	mov    0x80a010,%eax
  8028cb:	8b 40 70             	mov    0x70(%eax),%eax
}
  8028ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028d1:	5b                   	pop    %ebx
  8028d2:	5e                   	pop    %esi
  8028d3:	5d                   	pop    %ebp
  8028d4:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8028d5:	83 ec 0c             	sub    $0xc,%esp
  8028d8:	68 00 00 c0 ee       	push   $0xeec00000
  8028dd:	e8 95 fe ff ff       	call   802777 <sys_ipc_recv>
  8028e2:	83 c4 10             	add    $0x10,%esp
  8028e5:	eb ab                	jmp    802892 <ipc_recv+0x1e>

008028e7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028e7:	55                   	push   %ebp
  8028e8:	89 e5                	mov    %esp,%ebp
  8028ea:	57                   	push   %edi
  8028eb:	56                   	push   %esi
  8028ec:	53                   	push   %ebx
  8028ed:	83 ec 0c             	sub    $0xc,%esp
  8028f0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028f3:	8b 75 10             	mov    0x10(%ebp),%esi
  8028f6:	eb 20                	jmp    802918 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8028f8:	6a 00                	push   $0x0
  8028fa:	68 00 00 c0 ee       	push   $0xeec00000
  8028ff:	ff 75 0c             	pushl  0xc(%ebp)
  802902:	57                   	push   %edi
  802903:	e8 4c fe ff ff       	call   802754 <sys_ipc_try_send>
  802908:	89 c3                	mov    %eax,%ebx
  80290a:	83 c4 10             	add    $0x10,%esp
  80290d:	eb 1f                	jmp    80292e <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  80290f:	e8 94 fc ff ff       	call   8025a8 <sys_yield>
	while(retval != 0) {
  802914:	85 db                	test   %ebx,%ebx
  802916:	74 33                	je     80294b <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802918:	85 f6                	test   %esi,%esi
  80291a:	74 dc                	je     8028f8 <ipc_send+0x11>
  80291c:	ff 75 14             	pushl  0x14(%ebp)
  80291f:	56                   	push   %esi
  802920:	ff 75 0c             	pushl  0xc(%ebp)
  802923:	57                   	push   %edi
  802924:	e8 2b fe ff ff       	call   802754 <sys_ipc_try_send>
  802929:	89 c3                	mov    %eax,%ebx
  80292b:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  80292e:	83 fb f9             	cmp    $0xfffffff9,%ebx
  802931:	74 dc                	je     80290f <ipc_send+0x28>
  802933:	85 db                	test   %ebx,%ebx
  802935:	74 d8                	je     80290f <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802937:	83 ec 04             	sub    $0x4,%esp
  80293a:	68 d0 46 80 00       	push   $0x8046d0
  80293f:	6a 35                	push   $0x35
  802941:	68 00 47 80 00       	push   $0x804700
  802946:	e8 d3 f1 ff ff       	call   801b1e <_panic>
	}
}
  80294b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80294e:	5b                   	pop    %ebx
  80294f:	5e                   	pop    %esi
  802950:	5f                   	pop    %edi
  802951:	5d                   	pop    %ebp
  802952:	c3                   	ret    

00802953 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802953:	55                   	push   %ebp
  802954:	89 e5                	mov    %esp,%ebp
  802956:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802959:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80295e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802961:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802967:	8b 52 50             	mov    0x50(%edx),%edx
  80296a:	39 ca                	cmp    %ecx,%edx
  80296c:	74 11                	je     80297f <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80296e:	83 c0 01             	add    $0x1,%eax
  802971:	3d 00 04 00 00       	cmp    $0x400,%eax
  802976:	75 e6                	jne    80295e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802978:	b8 00 00 00 00       	mov    $0x0,%eax
  80297d:	eb 0b                	jmp    80298a <ipc_find_env+0x37>
			return envs[i].env_id;
  80297f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802982:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802987:	8b 40 48             	mov    0x48(%eax),%eax
}
  80298a:	5d                   	pop    %ebp
  80298b:	c3                   	ret    

0080298c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	05 00 00 00 30       	add    $0x30000000,%eax
  802997:	c1 e8 0c             	shr    $0xc,%eax
}
  80299a:	5d                   	pop    %ebp
  80299b:	c3                   	ret    

0080299c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80299c:	55                   	push   %ebp
  80299d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8029a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8029ac:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8029b1:	5d                   	pop    %ebp
  8029b2:	c3                   	ret    

008029b3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8029b3:	55                   	push   %ebp
  8029b4:	89 e5                	mov    %esp,%ebp
  8029b6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8029bb:	89 c2                	mov    %eax,%edx
  8029bd:	c1 ea 16             	shr    $0x16,%edx
  8029c0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8029c7:	f6 c2 01             	test   $0x1,%dl
  8029ca:	74 2d                	je     8029f9 <fd_alloc+0x46>
  8029cc:	89 c2                	mov    %eax,%edx
  8029ce:	c1 ea 0c             	shr    $0xc,%edx
  8029d1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8029d8:	f6 c2 01             	test   $0x1,%dl
  8029db:	74 1c                	je     8029f9 <fd_alloc+0x46>
  8029dd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8029e2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8029e7:	75 d2                	jne    8029bb <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8029e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8029f2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8029f7:	eb 0a                	jmp    802a03 <fd_alloc+0x50>
			*fd_store = fd;
  8029f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029fc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8029fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a03:	5d                   	pop    %ebp
  802a04:	c3                   	ret    

00802a05 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802a05:	55                   	push   %ebp
  802a06:	89 e5                	mov    %esp,%ebp
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802a0b:	83 f8 1f             	cmp    $0x1f,%eax
  802a0e:	77 30                	ja     802a40 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802a10:	c1 e0 0c             	shl    $0xc,%eax
  802a13:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802a18:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802a1e:	f6 c2 01             	test   $0x1,%dl
  802a21:	74 24                	je     802a47 <fd_lookup+0x42>
  802a23:	89 c2                	mov    %eax,%edx
  802a25:	c1 ea 0c             	shr    $0xc,%edx
  802a28:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802a2f:	f6 c2 01             	test   $0x1,%dl
  802a32:	74 1a                	je     802a4e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a37:	89 02                	mov    %eax,(%edx)
	return 0;
  802a39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a3e:	5d                   	pop    %ebp
  802a3f:	c3                   	ret    
		return -E_INVAL;
  802a40:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a45:	eb f7                	jmp    802a3e <fd_lookup+0x39>
		return -E_INVAL;
  802a47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a4c:	eb f0                	jmp    802a3e <fd_lookup+0x39>
  802a4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a53:	eb e9                	jmp    802a3e <fd_lookup+0x39>

00802a55 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802a55:	55                   	push   %ebp
  802a56:	89 e5                	mov    %esp,%ebp
  802a58:	83 ec 08             	sub    $0x8,%esp
  802a5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802a5e:	ba 00 00 00 00       	mov    $0x0,%edx
  802a63:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802a68:	39 08                	cmp    %ecx,(%eax)
  802a6a:	74 38                	je     802aa4 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  802a6c:	83 c2 01             	add    $0x1,%edx
  802a6f:	8b 04 95 8c 47 80 00 	mov    0x80478c(,%edx,4),%eax
  802a76:	85 c0                	test   %eax,%eax
  802a78:	75 ee                	jne    802a68 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802a7a:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802a7f:	8b 40 48             	mov    0x48(%eax),%eax
  802a82:	83 ec 04             	sub    $0x4,%esp
  802a85:	51                   	push   %ecx
  802a86:	50                   	push   %eax
  802a87:	68 0c 47 80 00       	push   $0x80470c
  802a8c:	e8 68 f1 ff ff       	call   801bf9 <cprintf>
	*dev = 0;
  802a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802a9a:	83 c4 10             	add    $0x10,%esp
  802a9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802aa2:	c9                   	leave  
  802aa3:	c3                   	ret    
			*dev = devtab[i];
  802aa4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802aa7:	89 01                	mov    %eax,(%ecx)
			return 0;
  802aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  802aae:	eb f2                	jmp    802aa2 <dev_lookup+0x4d>

00802ab0 <fd_close>:
{
  802ab0:	55                   	push   %ebp
  802ab1:	89 e5                	mov    %esp,%ebp
  802ab3:	57                   	push   %edi
  802ab4:	56                   	push   %esi
  802ab5:	53                   	push   %ebx
  802ab6:	83 ec 24             	sub    $0x24,%esp
  802ab9:	8b 75 08             	mov    0x8(%ebp),%esi
  802abc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802abf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802ac2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802ac3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802ac9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802acc:	50                   	push   %eax
  802acd:	e8 33 ff ff ff       	call   802a05 <fd_lookup>
  802ad2:	89 c3                	mov    %eax,%ebx
  802ad4:	83 c4 10             	add    $0x10,%esp
  802ad7:	85 c0                	test   %eax,%eax
  802ad9:	78 05                	js     802ae0 <fd_close+0x30>
	    || fd != fd2)
  802adb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802ade:	74 16                	je     802af6 <fd_close+0x46>
		return (must_exist ? r : 0);
  802ae0:	89 f8                	mov    %edi,%eax
  802ae2:	84 c0                	test   %al,%al
  802ae4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae9:	0f 44 d8             	cmove  %eax,%ebx
}
  802aec:	89 d8                	mov    %ebx,%eax
  802aee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802af1:	5b                   	pop    %ebx
  802af2:	5e                   	pop    %esi
  802af3:	5f                   	pop    %edi
  802af4:	5d                   	pop    %ebp
  802af5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802af6:	83 ec 08             	sub    $0x8,%esp
  802af9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802afc:	50                   	push   %eax
  802afd:	ff 36                	pushl  (%esi)
  802aff:	e8 51 ff ff ff       	call   802a55 <dev_lookup>
  802b04:	89 c3                	mov    %eax,%ebx
  802b06:	83 c4 10             	add    $0x10,%esp
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	78 1a                	js     802b27 <fd_close+0x77>
		if (dev->dev_close)
  802b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b10:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802b13:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	74 0b                	je     802b27 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802b1c:	83 ec 0c             	sub    $0xc,%esp
  802b1f:	56                   	push   %esi
  802b20:	ff d0                	call   *%eax
  802b22:	89 c3                	mov    %eax,%ebx
  802b24:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802b27:	83 ec 08             	sub    $0x8,%esp
  802b2a:	56                   	push   %esi
  802b2b:	6a 00                	push   $0x0
  802b2d:	e8 1a fb ff ff       	call   80264c <sys_page_unmap>
	return r;
  802b32:	83 c4 10             	add    $0x10,%esp
  802b35:	eb b5                	jmp    802aec <fd_close+0x3c>

00802b37 <close>:

int
close(int fdnum)
{
  802b37:	55                   	push   %ebp
  802b38:	89 e5                	mov    %esp,%ebp
  802b3a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b40:	50                   	push   %eax
  802b41:	ff 75 08             	pushl  0x8(%ebp)
  802b44:	e8 bc fe ff ff       	call   802a05 <fd_lookup>
  802b49:	83 c4 10             	add    $0x10,%esp
  802b4c:	85 c0                	test   %eax,%eax
  802b4e:	79 02                	jns    802b52 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  802b50:	c9                   	leave  
  802b51:	c3                   	ret    
		return fd_close(fd, 1);
  802b52:	83 ec 08             	sub    $0x8,%esp
  802b55:	6a 01                	push   $0x1
  802b57:	ff 75 f4             	pushl  -0xc(%ebp)
  802b5a:	e8 51 ff ff ff       	call   802ab0 <fd_close>
  802b5f:	83 c4 10             	add    $0x10,%esp
  802b62:	eb ec                	jmp    802b50 <close+0x19>

00802b64 <close_all>:

void
close_all(void)
{
  802b64:	55                   	push   %ebp
  802b65:	89 e5                	mov    %esp,%ebp
  802b67:	53                   	push   %ebx
  802b68:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802b6b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802b70:	83 ec 0c             	sub    $0xc,%esp
  802b73:	53                   	push   %ebx
  802b74:	e8 be ff ff ff       	call   802b37 <close>
	for (i = 0; i < MAXFD; i++)
  802b79:	83 c3 01             	add    $0x1,%ebx
  802b7c:	83 c4 10             	add    $0x10,%esp
  802b7f:	83 fb 20             	cmp    $0x20,%ebx
  802b82:	75 ec                	jne    802b70 <close_all+0xc>
}
  802b84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b87:	c9                   	leave  
  802b88:	c3                   	ret    

00802b89 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b89:	55                   	push   %ebp
  802b8a:	89 e5                	mov    %esp,%ebp
  802b8c:	57                   	push   %edi
  802b8d:	56                   	push   %esi
  802b8e:	53                   	push   %ebx
  802b8f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b92:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802b95:	50                   	push   %eax
  802b96:	ff 75 08             	pushl  0x8(%ebp)
  802b99:	e8 67 fe ff ff       	call   802a05 <fd_lookup>
  802b9e:	89 c3                	mov    %eax,%ebx
  802ba0:	83 c4 10             	add    $0x10,%esp
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	0f 88 81 00 00 00    	js     802c2c <dup+0xa3>
		return r;
	close(newfdnum);
  802bab:	83 ec 0c             	sub    $0xc,%esp
  802bae:	ff 75 0c             	pushl  0xc(%ebp)
  802bb1:	e8 81 ff ff ff       	call   802b37 <close>

	newfd = INDEX2FD(newfdnum);
  802bb6:	8b 75 0c             	mov    0xc(%ebp),%esi
  802bb9:	c1 e6 0c             	shl    $0xc,%esi
  802bbc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802bc2:	83 c4 04             	add    $0x4,%esp
  802bc5:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bc8:	e8 cf fd ff ff       	call   80299c <fd2data>
  802bcd:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802bcf:	89 34 24             	mov    %esi,(%esp)
  802bd2:	e8 c5 fd ff ff       	call   80299c <fd2data>
  802bd7:	83 c4 10             	add    $0x10,%esp
  802bda:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802bdc:	89 d8                	mov    %ebx,%eax
  802bde:	c1 e8 16             	shr    $0x16,%eax
  802be1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802be8:	a8 01                	test   $0x1,%al
  802bea:	74 11                	je     802bfd <dup+0x74>
  802bec:	89 d8                	mov    %ebx,%eax
  802bee:	c1 e8 0c             	shr    $0xc,%eax
  802bf1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802bf8:	f6 c2 01             	test   $0x1,%dl
  802bfb:	75 39                	jne    802c36 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802bfd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c00:	89 d0                	mov    %edx,%eax
  802c02:	c1 e8 0c             	shr    $0xc,%eax
  802c05:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802c0c:	83 ec 0c             	sub    $0xc,%esp
  802c0f:	25 07 0e 00 00       	and    $0xe07,%eax
  802c14:	50                   	push   %eax
  802c15:	56                   	push   %esi
  802c16:	6a 00                	push   $0x0
  802c18:	52                   	push   %edx
  802c19:	6a 00                	push   $0x0
  802c1b:	e8 ea f9 ff ff       	call   80260a <sys_page_map>
  802c20:	89 c3                	mov    %eax,%ebx
  802c22:	83 c4 20             	add    $0x20,%esp
  802c25:	85 c0                	test   %eax,%eax
  802c27:	78 31                	js     802c5a <dup+0xd1>
		goto err;

	return newfdnum;
  802c29:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802c2c:	89 d8                	mov    %ebx,%eax
  802c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c31:	5b                   	pop    %ebx
  802c32:	5e                   	pop    %esi
  802c33:	5f                   	pop    %edi
  802c34:	5d                   	pop    %ebp
  802c35:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802c36:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802c3d:	83 ec 0c             	sub    $0xc,%esp
  802c40:	25 07 0e 00 00       	and    $0xe07,%eax
  802c45:	50                   	push   %eax
  802c46:	57                   	push   %edi
  802c47:	6a 00                	push   $0x0
  802c49:	53                   	push   %ebx
  802c4a:	6a 00                	push   $0x0
  802c4c:	e8 b9 f9 ff ff       	call   80260a <sys_page_map>
  802c51:	89 c3                	mov    %eax,%ebx
  802c53:	83 c4 20             	add    $0x20,%esp
  802c56:	85 c0                	test   %eax,%eax
  802c58:	79 a3                	jns    802bfd <dup+0x74>
	sys_page_unmap(0, newfd);
  802c5a:	83 ec 08             	sub    $0x8,%esp
  802c5d:	56                   	push   %esi
  802c5e:	6a 00                	push   $0x0
  802c60:	e8 e7 f9 ff ff       	call   80264c <sys_page_unmap>
	sys_page_unmap(0, nva);
  802c65:	83 c4 08             	add    $0x8,%esp
  802c68:	57                   	push   %edi
  802c69:	6a 00                	push   $0x0
  802c6b:	e8 dc f9 ff ff       	call   80264c <sys_page_unmap>
	return r;
  802c70:	83 c4 10             	add    $0x10,%esp
  802c73:	eb b7                	jmp    802c2c <dup+0xa3>

00802c75 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802c75:	55                   	push   %ebp
  802c76:	89 e5                	mov    %esp,%ebp
  802c78:	53                   	push   %ebx
  802c79:	83 ec 1c             	sub    $0x1c,%esp
  802c7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802c82:	50                   	push   %eax
  802c83:	53                   	push   %ebx
  802c84:	e8 7c fd ff ff       	call   802a05 <fd_lookup>
  802c89:	83 c4 10             	add    $0x10,%esp
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	78 3f                	js     802ccf <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c90:	83 ec 08             	sub    $0x8,%esp
  802c93:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c96:	50                   	push   %eax
  802c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9a:	ff 30                	pushl  (%eax)
  802c9c:	e8 b4 fd ff ff       	call   802a55 <dev_lookup>
  802ca1:	83 c4 10             	add    $0x10,%esp
  802ca4:	85 c0                	test   %eax,%eax
  802ca6:	78 27                	js     802ccf <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802ca8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cab:	8b 42 08             	mov    0x8(%edx),%eax
  802cae:	83 e0 03             	and    $0x3,%eax
  802cb1:	83 f8 01             	cmp    $0x1,%eax
  802cb4:	74 1e                	je     802cd4 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 40 08             	mov    0x8(%eax),%eax
  802cbc:	85 c0                	test   %eax,%eax
  802cbe:	74 35                	je     802cf5 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802cc0:	83 ec 04             	sub    $0x4,%esp
  802cc3:	ff 75 10             	pushl  0x10(%ebp)
  802cc6:	ff 75 0c             	pushl  0xc(%ebp)
  802cc9:	52                   	push   %edx
  802cca:	ff d0                	call   *%eax
  802ccc:	83 c4 10             	add    $0x10,%esp
}
  802ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802cd2:	c9                   	leave  
  802cd3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802cd4:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802cd9:	8b 40 48             	mov    0x48(%eax),%eax
  802cdc:	83 ec 04             	sub    $0x4,%esp
  802cdf:	53                   	push   %ebx
  802ce0:	50                   	push   %eax
  802ce1:	68 50 47 80 00       	push   $0x804750
  802ce6:	e8 0e ef ff ff       	call   801bf9 <cprintf>
		return -E_INVAL;
  802ceb:	83 c4 10             	add    $0x10,%esp
  802cee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cf3:	eb da                	jmp    802ccf <read+0x5a>
		return -E_NOT_SUPP;
  802cf5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802cfa:	eb d3                	jmp    802ccf <read+0x5a>

00802cfc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802cfc:	55                   	push   %ebp
  802cfd:	89 e5                	mov    %esp,%ebp
  802cff:	57                   	push   %edi
  802d00:	56                   	push   %esi
  802d01:	53                   	push   %ebx
  802d02:	83 ec 0c             	sub    $0xc,%esp
  802d05:	8b 7d 08             	mov    0x8(%ebp),%edi
  802d08:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d10:	39 f3                	cmp    %esi,%ebx
  802d12:	73 23                	jae    802d37 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802d14:	83 ec 04             	sub    $0x4,%esp
  802d17:	89 f0                	mov    %esi,%eax
  802d19:	29 d8                	sub    %ebx,%eax
  802d1b:	50                   	push   %eax
  802d1c:	89 d8                	mov    %ebx,%eax
  802d1e:	03 45 0c             	add    0xc(%ebp),%eax
  802d21:	50                   	push   %eax
  802d22:	57                   	push   %edi
  802d23:	e8 4d ff ff ff       	call   802c75 <read>
		if (m < 0)
  802d28:	83 c4 10             	add    $0x10,%esp
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	78 06                	js     802d35 <readn+0x39>
			return m;
		if (m == 0)
  802d2f:	74 06                	je     802d37 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  802d31:	01 c3                	add    %eax,%ebx
  802d33:	eb db                	jmp    802d10 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802d35:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802d37:	89 d8                	mov    %ebx,%eax
  802d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d3c:	5b                   	pop    %ebx
  802d3d:	5e                   	pop    %esi
  802d3e:	5f                   	pop    %edi
  802d3f:	5d                   	pop    %ebp
  802d40:	c3                   	ret    

00802d41 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d41:	55                   	push   %ebp
  802d42:	89 e5                	mov    %esp,%ebp
  802d44:	53                   	push   %ebx
  802d45:	83 ec 1c             	sub    $0x1c,%esp
  802d48:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802d4e:	50                   	push   %eax
  802d4f:	53                   	push   %ebx
  802d50:	e8 b0 fc ff ff       	call   802a05 <fd_lookup>
  802d55:	83 c4 10             	add    $0x10,%esp
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	78 3a                	js     802d96 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d5c:	83 ec 08             	sub    $0x8,%esp
  802d5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d62:	50                   	push   %eax
  802d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d66:	ff 30                	pushl  (%eax)
  802d68:	e8 e8 fc ff ff       	call   802a55 <dev_lookup>
  802d6d:	83 c4 10             	add    $0x10,%esp
  802d70:	85 c0                	test   %eax,%eax
  802d72:	78 22                	js     802d96 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d77:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802d7b:	74 1e                	je     802d9b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802d7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d80:	8b 52 0c             	mov    0xc(%edx),%edx
  802d83:	85 d2                	test   %edx,%edx
  802d85:	74 35                	je     802dbc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802d87:	83 ec 04             	sub    $0x4,%esp
  802d8a:	ff 75 10             	pushl  0x10(%ebp)
  802d8d:	ff 75 0c             	pushl  0xc(%ebp)
  802d90:	50                   	push   %eax
  802d91:	ff d2                	call   *%edx
  802d93:	83 c4 10             	add    $0x10,%esp
}
  802d96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d99:	c9                   	leave  
  802d9a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d9b:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802da0:	8b 40 48             	mov    0x48(%eax),%eax
  802da3:	83 ec 04             	sub    $0x4,%esp
  802da6:	53                   	push   %ebx
  802da7:	50                   	push   %eax
  802da8:	68 6c 47 80 00       	push   $0x80476c
  802dad:	e8 47 ee ff ff       	call   801bf9 <cprintf>
		return -E_INVAL;
  802db2:	83 c4 10             	add    $0x10,%esp
  802db5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dba:	eb da                	jmp    802d96 <write+0x55>
		return -E_NOT_SUPP;
  802dbc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802dc1:	eb d3                	jmp    802d96 <write+0x55>

00802dc3 <seek>:

int
seek(int fdnum, off_t offset)
{
  802dc3:	55                   	push   %ebp
  802dc4:	89 e5                	mov    %esp,%ebp
  802dc6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802dc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802dcc:	50                   	push   %eax
  802dcd:	ff 75 08             	pushl  0x8(%ebp)
  802dd0:	e8 30 fc ff ff       	call   802a05 <fd_lookup>
  802dd5:	83 c4 10             	add    $0x10,%esp
  802dd8:	85 c0                	test   %eax,%eax
  802dda:	78 0e                	js     802dea <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802ddc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dea:	c9                   	leave  
  802deb:	c3                   	ret    

00802dec <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802dec:	55                   	push   %ebp
  802ded:	89 e5                	mov    %esp,%ebp
  802def:	53                   	push   %ebx
  802df0:	83 ec 1c             	sub    $0x1c,%esp
  802df3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802df6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802df9:	50                   	push   %eax
  802dfa:	53                   	push   %ebx
  802dfb:	e8 05 fc ff ff       	call   802a05 <fd_lookup>
  802e00:	83 c4 10             	add    $0x10,%esp
  802e03:	85 c0                	test   %eax,%eax
  802e05:	78 37                	js     802e3e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e07:	83 ec 08             	sub    $0x8,%esp
  802e0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e0d:	50                   	push   %eax
  802e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e11:	ff 30                	pushl  (%eax)
  802e13:	e8 3d fc ff ff       	call   802a55 <dev_lookup>
  802e18:	83 c4 10             	add    $0x10,%esp
  802e1b:	85 c0                	test   %eax,%eax
  802e1d:	78 1f                	js     802e3e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e22:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802e26:	74 1b                	je     802e43 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802e28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2b:	8b 52 18             	mov    0x18(%edx),%edx
  802e2e:	85 d2                	test   %edx,%edx
  802e30:	74 32                	je     802e64 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802e32:	83 ec 08             	sub    $0x8,%esp
  802e35:	ff 75 0c             	pushl  0xc(%ebp)
  802e38:	50                   	push   %eax
  802e39:	ff d2                	call   *%edx
  802e3b:	83 c4 10             	add    $0x10,%esp
}
  802e3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e41:	c9                   	leave  
  802e42:	c3                   	ret    
			thisenv->env_id, fdnum);
  802e43:	a1 10 a0 80 00       	mov    0x80a010,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e48:	8b 40 48             	mov    0x48(%eax),%eax
  802e4b:	83 ec 04             	sub    $0x4,%esp
  802e4e:	53                   	push   %ebx
  802e4f:	50                   	push   %eax
  802e50:	68 2c 47 80 00       	push   $0x80472c
  802e55:	e8 9f ed ff ff       	call   801bf9 <cprintf>
		return -E_INVAL;
  802e5a:	83 c4 10             	add    $0x10,%esp
  802e5d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e62:	eb da                	jmp    802e3e <ftruncate+0x52>
		return -E_NOT_SUPP;
  802e64:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e69:	eb d3                	jmp    802e3e <ftruncate+0x52>

00802e6b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e6b:	55                   	push   %ebp
  802e6c:	89 e5                	mov    %esp,%ebp
  802e6e:	53                   	push   %ebx
  802e6f:	83 ec 1c             	sub    $0x1c,%esp
  802e72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e75:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e78:	50                   	push   %eax
  802e79:	ff 75 08             	pushl  0x8(%ebp)
  802e7c:	e8 84 fb ff ff       	call   802a05 <fd_lookup>
  802e81:	83 c4 10             	add    $0x10,%esp
  802e84:	85 c0                	test   %eax,%eax
  802e86:	78 4b                	js     802ed3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e88:	83 ec 08             	sub    $0x8,%esp
  802e8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e8e:	50                   	push   %eax
  802e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e92:	ff 30                	pushl  (%eax)
  802e94:	e8 bc fb ff ff       	call   802a55 <dev_lookup>
  802e99:	83 c4 10             	add    $0x10,%esp
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	78 33                	js     802ed3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802ea7:	74 2f                	je     802ed8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802ea9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802eac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802eb3:	00 00 00 
	stat->st_isdir = 0;
  802eb6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802ebd:	00 00 00 
	stat->st_dev = dev;
  802ec0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802ec6:	83 ec 08             	sub    $0x8,%esp
  802ec9:	53                   	push   %ebx
  802eca:	ff 75 f0             	pushl  -0x10(%ebp)
  802ecd:	ff 50 14             	call   *0x14(%eax)
  802ed0:	83 c4 10             	add    $0x10,%esp
}
  802ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ed6:	c9                   	leave  
  802ed7:	c3                   	ret    
		return -E_NOT_SUPP;
  802ed8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802edd:	eb f4                	jmp    802ed3 <fstat+0x68>

00802edf <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802edf:	55                   	push   %ebp
  802ee0:	89 e5                	mov    %esp,%ebp
  802ee2:	56                   	push   %esi
  802ee3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ee4:	83 ec 08             	sub    $0x8,%esp
  802ee7:	6a 00                	push   $0x0
  802ee9:	ff 75 08             	pushl  0x8(%ebp)
  802eec:	e8 2f 02 00 00       	call   803120 <open>
  802ef1:	89 c3                	mov    %eax,%ebx
  802ef3:	83 c4 10             	add    $0x10,%esp
  802ef6:	85 c0                	test   %eax,%eax
  802ef8:	78 1b                	js     802f15 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802efa:	83 ec 08             	sub    $0x8,%esp
  802efd:	ff 75 0c             	pushl  0xc(%ebp)
  802f00:	50                   	push   %eax
  802f01:	e8 65 ff ff ff       	call   802e6b <fstat>
  802f06:	89 c6                	mov    %eax,%esi
	close(fd);
  802f08:	89 1c 24             	mov    %ebx,(%esp)
  802f0b:	e8 27 fc ff ff       	call   802b37 <close>
	return r;
  802f10:	83 c4 10             	add    $0x10,%esp
  802f13:	89 f3                	mov    %esi,%ebx
}
  802f15:	89 d8                	mov    %ebx,%eax
  802f17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f1a:	5b                   	pop    %ebx
  802f1b:	5e                   	pop    %esi
  802f1c:	5d                   	pop    %ebp
  802f1d:	c3                   	ret    

00802f1e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f1e:	55                   	push   %ebp
  802f1f:	89 e5                	mov    %esp,%ebp
  802f21:	56                   	push   %esi
  802f22:	53                   	push   %ebx
  802f23:	89 c6                	mov    %eax,%esi
  802f25:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802f27:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  802f2e:	74 27                	je     802f57 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f30:	6a 07                	push   $0x7
  802f32:	68 00 b0 80 00       	push   $0x80b000
  802f37:	56                   	push   %esi
  802f38:	ff 35 00 a0 80 00    	pushl  0x80a000
  802f3e:	e8 a4 f9 ff ff       	call   8028e7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802f43:	83 c4 0c             	add    $0xc,%esp
  802f46:	6a 00                	push   $0x0
  802f48:	53                   	push   %ebx
  802f49:	6a 00                	push   $0x0
  802f4b:	e8 24 f9 ff ff       	call   802874 <ipc_recv>
}
  802f50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f53:	5b                   	pop    %ebx
  802f54:	5e                   	pop    %esi
  802f55:	5d                   	pop    %ebp
  802f56:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f57:	83 ec 0c             	sub    $0xc,%esp
  802f5a:	6a 01                	push   $0x1
  802f5c:	e8 f2 f9 ff ff       	call   802953 <ipc_find_env>
  802f61:	a3 00 a0 80 00       	mov    %eax,0x80a000
  802f66:	83 c4 10             	add    $0x10,%esp
  802f69:	eb c5                	jmp    802f30 <fsipc+0x12>

00802f6b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802f6b:	55                   	push   %ebp
  802f6c:	89 e5                	mov    %esp,%ebp
  802f6e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	8b 40 0c             	mov    0xc(%eax),%eax
  802f77:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  802f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7f:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f84:	ba 00 00 00 00       	mov    $0x0,%edx
  802f89:	b8 02 00 00 00       	mov    $0x2,%eax
  802f8e:	e8 8b ff ff ff       	call   802f1e <fsipc>
}
  802f93:	c9                   	leave  
  802f94:	c3                   	ret    

00802f95 <devfile_flush>:
{
  802f95:	55                   	push   %ebp
  802f96:	89 e5                	mov    %esp,%ebp
  802f98:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa1:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  802fa6:	ba 00 00 00 00       	mov    $0x0,%edx
  802fab:	b8 06 00 00 00       	mov    $0x6,%eax
  802fb0:	e8 69 ff ff ff       	call   802f1e <fsipc>
}
  802fb5:	c9                   	leave  
  802fb6:	c3                   	ret    

00802fb7 <devfile_stat>:
{
  802fb7:	55                   	push   %ebp
  802fb8:	89 e5                	mov    %esp,%ebp
  802fba:	53                   	push   %ebx
  802fbb:	83 ec 04             	sub    $0x4,%esp
  802fbe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc7:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802fcc:	ba 00 00 00 00       	mov    $0x0,%edx
  802fd1:	b8 05 00 00 00       	mov    $0x5,%eax
  802fd6:	e8 43 ff ff ff       	call   802f1e <fsipc>
  802fdb:	85 c0                	test   %eax,%eax
  802fdd:	78 2c                	js     80300b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802fdf:	83 ec 08             	sub    $0x8,%esp
  802fe2:	68 00 b0 80 00       	push   $0x80b000
  802fe7:	53                   	push   %ebx
  802fe8:	e8 e8 f1 ff ff       	call   8021d5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802fed:	a1 80 b0 80 00       	mov    0x80b080,%eax
  802ff2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ff8:	a1 84 b0 80 00       	mov    0x80b084,%eax
  802ffd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  803003:	83 c4 10             	add    $0x10,%esp
  803006:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80300b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80300e:	c9                   	leave  
  80300f:	c3                   	ret    

00803010 <devfile_write>:
{
  803010:	55                   	push   %ebp
  803011:	89 e5                	mov    %esp,%ebp
  803013:	53                   	push   %ebx
  803014:	83 ec 04             	sub    $0x4,%esp
  803017:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  80301a:	85 db                	test   %ebx,%ebx
  80301c:	75 07                	jne    803025 <devfile_write+0x15>
	return n_all;
  80301e:	89 d8                	mov    %ebx,%eax
}
  803020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803023:	c9                   	leave  
  803024:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	8b 40 0c             	mov    0xc(%eax),%eax
  80302b:	a3 00 b0 80 00       	mov    %eax,0x80b000
	  fsipcbuf.write.req_n = n_left;
  803030:	89 1d 04 b0 80 00    	mov    %ebx,0x80b004
    memmove(fsipcbuf.write.req_buf, buf, n);
  803036:	83 ec 04             	sub    $0x4,%esp
  803039:	53                   	push   %ebx
  80303a:	ff 75 0c             	pushl  0xc(%ebp)
  80303d:	68 08 b0 80 00       	push   $0x80b008
  803042:	e8 1c f3 ff ff       	call   802363 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803047:	ba 00 00 00 00       	mov    $0x0,%edx
  80304c:	b8 04 00 00 00       	mov    $0x4,%eax
  803051:	e8 c8 fe ff ff       	call   802f1e <fsipc>
  803056:	83 c4 10             	add    $0x10,%esp
  803059:	85 c0                	test   %eax,%eax
  80305b:	78 c3                	js     803020 <devfile_write+0x10>
	  assert(r <= n_left);
  80305d:	39 d8                	cmp    %ebx,%eax
  80305f:	77 0b                	ja     80306c <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  803061:	3d 00 10 00 00       	cmp    $0x1000,%eax
  803066:	7f 1d                	jg     803085 <devfile_write+0x75>
    n_all += r;
  803068:	89 c3                	mov    %eax,%ebx
  80306a:	eb b2                	jmp    80301e <devfile_write+0xe>
	  assert(r <= n_left);
  80306c:	68 a0 47 80 00       	push   $0x8047a0
  803071:	68 bd 3d 80 00       	push   $0x803dbd
  803076:	68 9f 00 00 00       	push   $0x9f
  80307b:	68 ac 47 80 00       	push   $0x8047ac
  803080:	e8 99 ea ff ff       	call   801b1e <_panic>
	  assert(r <= PGSIZE);
  803085:	68 b7 47 80 00       	push   $0x8047b7
  80308a:	68 bd 3d 80 00       	push   $0x803dbd
  80308f:	68 a0 00 00 00       	push   $0xa0
  803094:	68 ac 47 80 00       	push   $0x8047ac
  803099:	e8 80 ea ff ff       	call   801b1e <_panic>

0080309e <devfile_read>:
{
  80309e:	55                   	push   %ebp
  80309f:	89 e5                	mov    %esp,%ebp
  8030a1:	56                   	push   %esi
  8030a2:	53                   	push   %ebx
  8030a3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ac:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  8030b1:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8030b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8030bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8030c1:	e8 58 fe ff ff       	call   802f1e <fsipc>
  8030c6:	89 c3                	mov    %eax,%ebx
  8030c8:	85 c0                	test   %eax,%eax
  8030ca:	78 1f                	js     8030eb <devfile_read+0x4d>
	assert(r <= n);
  8030cc:	39 f0                	cmp    %esi,%eax
  8030ce:	77 24                	ja     8030f4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8030d0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8030d5:	7f 33                	jg     80310a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8030d7:	83 ec 04             	sub    $0x4,%esp
  8030da:	50                   	push   %eax
  8030db:	68 00 b0 80 00       	push   $0x80b000
  8030e0:	ff 75 0c             	pushl  0xc(%ebp)
  8030e3:	e8 7b f2 ff ff       	call   802363 <memmove>
	return r;
  8030e8:	83 c4 10             	add    $0x10,%esp
}
  8030eb:	89 d8                	mov    %ebx,%eax
  8030ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030f0:	5b                   	pop    %ebx
  8030f1:	5e                   	pop    %esi
  8030f2:	5d                   	pop    %ebp
  8030f3:	c3                   	ret    
	assert(r <= n);
  8030f4:	68 c3 47 80 00       	push   $0x8047c3
  8030f9:	68 bd 3d 80 00       	push   $0x803dbd
  8030fe:	6a 7c                	push   $0x7c
  803100:	68 ac 47 80 00       	push   $0x8047ac
  803105:	e8 14 ea ff ff       	call   801b1e <_panic>
	assert(r <= PGSIZE);
  80310a:	68 b7 47 80 00       	push   $0x8047b7
  80310f:	68 bd 3d 80 00       	push   $0x803dbd
  803114:	6a 7d                	push   $0x7d
  803116:	68 ac 47 80 00       	push   $0x8047ac
  80311b:	e8 fe e9 ff ff       	call   801b1e <_panic>

00803120 <open>:
{
  803120:	55                   	push   %ebp
  803121:	89 e5                	mov    %esp,%ebp
  803123:	56                   	push   %esi
  803124:	53                   	push   %ebx
  803125:	83 ec 1c             	sub    $0x1c,%esp
  803128:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80312b:	56                   	push   %esi
  80312c:	e8 6b f0 ff ff       	call   80219c <strlen>
  803131:	83 c4 10             	add    $0x10,%esp
  803134:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803139:	7f 6c                	jg     8031a7 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80313b:	83 ec 0c             	sub    $0xc,%esp
  80313e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803141:	50                   	push   %eax
  803142:	e8 6c f8 ff ff       	call   8029b3 <fd_alloc>
  803147:	89 c3                	mov    %eax,%ebx
  803149:	83 c4 10             	add    $0x10,%esp
  80314c:	85 c0                	test   %eax,%eax
  80314e:	78 3c                	js     80318c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  803150:	83 ec 08             	sub    $0x8,%esp
  803153:	56                   	push   %esi
  803154:	68 00 b0 80 00       	push   $0x80b000
  803159:	e8 77 f0 ff ff       	call   8021d5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80315e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803161:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803166:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803169:	b8 01 00 00 00       	mov    $0x1,%eax
  80316e:	e8 ab fd ff ff       	call   802f1e <fsipc>
  803173:	89 c3                	mov    %eax,%ebx
  803175:	83 c4 10             	add    $0x10,%esp
  803178:	85 c0                	test   %eax,%eax
  80317a:	78 19                	js     803195 <open+0x75>
	return fd2num(fd);
  80317c:	83 ec 0c             	sub    $0xc,%esp
  80317f:	ff 75 f4             	pushl  -0xc(%ebp)
  803182:	e8 05 f8 ff ff       	call   80298c <fd2num>
  803187:	89 c3                	mov    %eax,%ebx
  803189:	83 c4 10             	add    $0x10,%esp
}
  80318c:	89 d8                	mov    %ebx,%eax
  80318e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803191:	5b                   	pop    %ebx
  803192:	5e                   	pop    %esi
  803193:	5d                   	pop    %ebp
  803194:	c3                   	ret    
		fd_close(fd, 0);
  803195:	83 ec 08             	sub    $0x8,%esp
  803198:	6a 00                	push   $0x0
  80319a:	ff 75 f4             	pushl  -0xc(%ebp)
  80319d:	e8 0e f9 ff ff       	call   802ab0 <fd_close>
		return r;
  8031a2:	83 c4 10             	add    $0x10,%esp
  8031a5:	eb e5                	jmp    80318c <open+0x6c>
		return -E_BAD_PATH;
  8031a7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8031ac:	eb de                	jmp    80318c <open+0x6c>

008031ae <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8031ae:	55                   	push   %ebp
  8031af:	89 e5                	mov    %esp,%ebp
  8031b1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8031b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8031b9:	b8 08 00 00 00       	mov    $0x8,%eax
  8031be:	e8 5b fd ff ff       	call   802f1e <fsipc>
}
  8031c3:	c9                   	leave  
  8031c4:	c3                   	ret    

008031c5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8031c5:	55                   	push   %ebp
  8031c6:	89 e5                	mov    %esp,%ebp
  8031c8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8031cb:	89 d0                	mov    %edx,%eax
  8031cd:	c1 e8 16             	shr    $0x16,%eax
  8031d0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8031d7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8031dc:	f6 c1 01             	test   $0x1,%cl
  8031df:	74 1d                	je     8031fe <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8031e1:	c1 ea 0c             	shr    $0xc,%edx
  8031e4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8031eb:	f6 c2 01             	test   $0x1,%dl
  8031ee:	74 0e                	je     8031fe <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8031f0:	c1 ea 0c             	shr    $0xc,%edx
  8031f3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8031fa:	ef 
  8031fb:	0f b7 c0             	movzwl %ax,%eax
}
  8031fe:	5d                   	pop    %ebp
  8031ff:	c3                   	ret    

00803200 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803200:	55                   	push   %ebp
  803201:	89 e5                	mov    %esp,%ebp
  803203:	56                   	push   %esi
  803204:	53                   	push   %ebx
  803205:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803208:	83 ec 0c             	sub    $0xc,%esp
  80320b:	ff 75 08             	pushl  0x8(%ebp)
  80320e:	e8 89 f7 ff ff       	call   80299c <fd2data>
  803213:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803215:	83 c4 08             	add    $0x8,%esp
  803218:	68 ca 47 80 00       	push   $0x8047ca
  80321d:	53                   	push   %ebx
  80321e:	e8 b2 ef ff ff       	call   8021d5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803223:	8b 46 04             	mov    0x4(%esi),%eax
  803226:	2b 06                	sub    (%esi),%eax
  803228:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80322e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803235:	00 00 00 
	stat->st_dev = &devpipe;
  803238:	c7 83 88 00 00 00 80 	movl   $0x809080,0x88(%ebx)
  80323f:	90 80 00 
	return 0;
}
  803242:	b8 00 00 00 00       	mov    $0x0,%eax
  803247:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80324a:	5b                   	pop    %ebx
  80324b:	5e                   	pop    %esi
  80324c:	5d                   	pop    %ebp
  80324d:	c3                   	ret    

0080324e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80324e:	55                   	push   %ebp
  80324f:	89 e5                	mov    %esp,%ebp
  803251:	53                   	push   %ebx
  803252:	83 ec 0c             	sub    $0xc,%esp
  803255:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803258:	53                   	push   %ebx
  803259:	6a 00                	push   $0x0
  80325b:	e8 ec f3 ff ff       	call   80264c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803260:	89 1c 24             	mov    %ebx,(%esp)
  803263:	e8 34 f7 ff ff       	call   80299c <fd2data>
  803268:	83 c4 08             	add    $0x8,%esp
  80326b:	50                   	push   %eax
  80326c:	6a 00                	push   $0x0
  80326e:	e8 d9 f3 ff ff       	call   80264c <sys_page_unmap>
}
  803273:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803276:	c9                   	leave  
  803277:	c3                   	ret    

00803278 <_pipeisclosed>:
{
  803278:	55                   	push   %ebp
  803279:	89 e5                	mov    %esp,%ebp
  80327b:	57                   	push   %edi
  80327c:	56                   	push   %esi
  80327d:	53                   	push   %ebx
  80327e:	83 ec 1c             	sub    $0x1c,%esp
  803281:	89 c7                	mov    %eax,%edi
  803283:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  803285:	a1 10 a0 80 00       	mov    0x80a010,%eax
  80328a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80328d:	83 ec 0c             	sub    $0xc,%esp
  803290:	57                   	push   %edi
  803291:	e8 2f ff ff ff       	call   8031c5 <pageref>
  803296:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803299:	89 34 24             	mov    %esi,(%esp)
  80329c:	e8 24 ff ff ff       	call   8031c5 <pageref>
		nn = thisenv->env_runs;
  8032a1:	8b 15 10 a0 80 00    	mov    0x80a010,%edx
  8032a7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8032aa:	83 c4 10             	add    $0x10,%esp
  8032ad:	39 cb                	cmp    %ecx,%ebx
  8032af:	74 1b                	je     8032cc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8032b1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8032b4:	75 cf                	jne    803285 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8032b6:	8b 42 58             	mov    0x58(%edx),%eax
  8032b9:	6a 01                	push   $0x1
  8032bb:	50                   	push   %eax
  8032bc:	53                   	push   %ebx
  8032bd:	68 d1 47 80 00       	push   $0x8047d1
  8032c2:	e8 32 e9 ff ff       	call   801bf9 <cprintf>
  8032c7:	83 c4 10             	add    $0x10,%esp
  8032ca:	eb b9                	jmp    803285 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8032cc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8032cf:	0f 94 c0             	sete   %al
  8032d2:	0f b6 c0             	movzbl %al,%eax
}
  8032d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8032d8:	5b                   	pop    %ebx
  8032d9:	5e                   	pop    %esi
  8032da:	5f                   	pop    %edi
  8032db:	5d                   	pop    %ebp
  8032dc:	c3                   	ret    

008032dd <devpipe_write>:
{
  8032dd:	55                   	push   %ebp
  8032de:	89 e5                	mov    %esp,%ebp
  8032e0:	57                   	push   %edi
  8032e1:	56                   	push   %esi
  8032e2:	53                   	push   %ebx
  8032e3:	83 ec 28             	sub    $0x28,%esp
  8032e6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8032e9:	56                   	push   %esi
  8032ea:	e8 ad f6 ff ff       	call   80299c <fd2data>
  8032ef:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8032f1:	83 c4 10             	add    $0x10,%esp
  8032f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8032fc:	74 4f                	je     80334d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8032fe:	8b 43 04             	mov    0x4(%ebx),%eax
  803301:	8b 0b                	mov    (%ebx),%ecx
  803303:	8d 51 20             	lea    0x20(%ecx),%edx
  803306:	39 d0                	cmp    %edx,%eax
  803308:	72 14                	jb     80331e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80330a:	89 da                	mov    %ebx,%edx
  80330c:	89 f0                	mov    %esi,%eax
  80330e:	e8 65 ff ff ff       	call   803278 <_pipeisclosed>
  803313:	85 c0                	test   %eax,%eax
  803315:	75 3b                	jne    803352 <devpipe_write+0x75>
			sys_yield();
  803317:	e8 8c f2 ff ff       	call   8025a8 <sys_yield>
  80331c:	eb e0                	jmp    8032fe <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80331e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803321:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803325:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803328:	89 c2                	mov    %eax,%edx
  80332a:	c1 fa 1f             	sar    $0x1f,%edx
  80332d:	89 d1                	mov    %edx,%ecx
  80332f:	c1 e9 1b             	shr    $0x1b,%ecx
  803332:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  803335:	83 e2 1f             	and    $0x1f,%edx
  803338:	29 ca                	sub    %ecx,%edx
  80333a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80333e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803342:	83 c0 01             	add    $0x1,%eax
  803345:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  803348:	83 c7 01             	add    $0x1,%edi
  80334b:	eb ac                	jmp    8032f9 <devpipe_write+0x1c>
	return i;
  80334d:	8b 45 10             	mov    0x10(%ebp),%eax
  803350:	eb 05                	jmp    803357 <devpipe_write+0x7a>
				return 0;
  803352:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803357:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80335a:	5b                   	pop    %ebx
  80335b:	5e                   	pop    %esi
  80335c:	5f                   	pop    %edi
  80335d:	5d                   	pop    %ebp
  80335e:	c3                   	ret    

0080335f <devpipe_read>:
{
  80335f:	55                   	push   %ebp
  803360:	89 e5                	mov    %esp,%ebp
  803362:	57                   	push   %edi
  803363:	56                   	push   %esi
  803364:	53                   	push   %ebx
  803365:	83 ec 18             	sub    $0x18,%esp
  803368:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80336b:	57                   	push   %edi
  80336c:	e8 2b f6 ff ff       	call   80299c <fd2data>
  803371:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803373:	83 c4 10             	add    $0x10,%esp
  803376:	be 00 00 00 00       	mov    $0x0,%esi
  80337b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80337e:	75 14                	jne    803394 <devpipe_read+0x35>
	return i;
  803380:	8b 45 10             	mov    0x10(%ebp),%eax
  803383:	eb 02                	jmp    803387 <devpipe_read+0x28>
				return i;
  803385:	89 f0                	mov    %esi,%eax
}
  803387:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80338a:	5b                   	pop    %ebx
  80338b:	5e                   	pop    %esi
  80338c:	5f                   	pop    %edi
  80338d:	5d                   	pop    %ebp
  80338e:	c3                   	ret    
			sys_yield();
  80338f:	e8 14 f2 ff ff       	call   8025a8 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  803394:	8b 03                	mov    (%ebx),%eax
  803396:	3b 43 04             	cmp    0x4(%ebx),%eax
  803399:	75 18                	jne    8033b3 <devpipe_read+0x54>
			if (i > 0)
  80339b:	85 f6                	test   %esi,%esi
  80339d:	75 e6                	jne    803385 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80339f:	89 da                	mov    %ebx,%edx
  8033a1:	89 f8                	mov    %edi,%eax
  8033a3:	e8 d0 fe ff ff       	call   803278 <_pipeisclosed>
  8033a8:	85 c0                	test   %eax,%eax
  8033aa:	74 e3                	je     80338f <devpipe_read+0x30>
				return 0;
  8033ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b1:	eb d4                	jmp    803387 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8033b3:	99                   	cltd   
  8033b4:	c1 ea 1b             	shr    $0x1b,%edx
  8033b7:	01 d0                	add    %edx,%eax
  8033b9:	83 e0 1f             	and    $0x1f,%eax
  8033bc:	29 d0                	sub    %edx,%eax
  8033be:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8033c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8033c6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8033c9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8033cc:	83 c6 01             	add    $0x1,%esi
  8033cf:	eb aa                	jmp    80337b <devpipe_read+0x1c>

008033d1 <pipe>:
{
  8033d1:	55                   	push   %ebp
  8033d2:	89 e5                	mov    %esp,%ebp
  8033d4:	56                   	push   %esi
  8033d5:	53                   	push   %ebx
  8033d6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8033d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8033dc:	50                   	push   %eax
  8033dd:	e8 d1 f5 ff ff       	call   8029b3 <fd_alloc>
  8033e2:	89 c3                	mov    %eax,%ebx
  8033e4:	83 c4 10             	add    $0x10,%esp
  8033e7:	85 c0                	test   %eax,%eax
  8033e9:	0f 88 23 01 00 00    	js     803512 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033ef:	83 ec 04             	sub    $0x4,%esp
  8033f2:	68 07 04 00 00       	push   $0x407
  8033f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8033fa:	6a 00                	push   $0x0
  8033fc:	e8 c6 f1 ff ff       	call   8025c7 <sys_page_alloc>
  803401:	89 c3                	mov    %eax,%ebx
  803403:	83 c4 10             	add    $0x10,%esp
  803406:	85 c0                	test   %eax,%eax
  803408:	0f 88 04 01 00 00    	js     803512 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80340e:	83 ec 0c             	sub    $0xc,%esp
  803411:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803414:	50                   	push   %eax
  803415:	e8 99 f5 ff ff       	call   8029b3 <fd_alloc>
  80341a:	89 c3                	mov    %eax,%ebx
  80341c:	83 c4 10             	add    $0x10,%esp
  80341f:	85 c0                	test   %eax,%eax
  803421:	0f 88 db 00 00 00    	js     803502 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803427:	83 ec 04             	sub    $0x4,%esp
  80342a:	68 07 04 00 00       	push   $0x407
  80342f:	ff 75 f0             	pushl  -0x10(%ebp)
  803432:	6a 00                	push   $0x0
  803434:	e8 8e f1 ff ff       	call   8025c7 <sys_page_alloc>
  803439:	89 c3                	mov    %eax,%ebx
  80343b:	83 c4 10             	add    $0x10,%esp
  80343e:	85 c0                	test   %eax,%eax
  803440:	0f 88 bc 00 00 00    	js     803502 <pipe+0x131>
	va = fd2data(fd0);
  803446:	83 ec 0c             	sub    $0xc,%esp
  803449:	ff 75 f4             	pushl  -0xc(%ebp)
  80344c:	e8 4b f5 ff ff       	call   80299c <fd2data>
  803451:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803453:	83 c4 0c             	add    $0xc,%esp
  803456:	68 07 04 00 00       	push   $0x407
  80345b:	50                   	push   %eax
  80345c:	6a 00                	push   $0x0
  80345e:	e8 64 f1 ff ff       	call   8025c7 <sys_page_alloc>
  803463:	89 c3                	mov    %eax,%ebx
  803465:	83 c4 10             	add    $0x10,%esp
  803468:	85 c0                	test   %eax,%eax
  80346a:	0f 88 82 00 00 00    	js     8034f2 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803470:	83 ec 0c             	sub    $0xc,%esp
  803473:	ff 75 f0             	pushl  -0x10(%ebp)
  803476:	e8 21 f5 ff ff       	call   80299c <fd2data>
  80347b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  803482:	50                   	push   %eax
  803483:	6a 00                	push   $0x0
  803485:	56                   	push   %esi
  803486:	6a 00                	push   $0x0
  803488:	e8 7d f1 ff ff       	call   80260a <sys_page_map>
  80348d:	89 c3                	mov    %eax,%ebx
  80348f:	83 c4 20             	add    $0x20,%esp
  803492:	85 c0                	test   %eax,%eax
  803494:	78 4e                	js     8034e4 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  803496:	a1 80 90 80 00       	mov    0x809080,%eax
  80349b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80349e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8034a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034a3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8034aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ad:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8034af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8034b9:	83 ec 0c             	sub    $0xc,%esp
  8034bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8034bf:	e8 c8 f4 ff ff       	call   80298c <fd2num>
  8034c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8034c7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8034c9:	83 c4 04             	add    $0x4,%esp
  8034cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8034cf:	e8 b8 f4 ff ff       	call   80298c <fd2num>
  8034d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8034d7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8034da:	83 c4 10             	add    $0x10,%esp
  8034dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8034e2:	eb 2e                	jmp    803512 <pipe+0x141>
	sys_page_unmap(0, va);
  8034e4:	83 ec 08             	sub    $0x8,%esp
  8034e7:	56                   	push   %esi
  8034e8:	6a 00                	push   $0x0
  8034ea:	e8 5d f1 ff ff       	call   80264c <sys_page_unmap>
  8034ef:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8034f2:	83 ec 08             	sub    $0x8,%esp
  8034f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8034f8:	6a 00                	push   $0x0
  8034fa:	e8 4d f1 ff ff       	call   80264c <sys_page_unmap>
  8034ff:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803502:	83 ec 08             	sub    $0x8,%esp
  803505:	ff 75 f4             	pushl  -0xc(%ebp)
  803508:	6a 00                	push   $0x0
  80350a:	e8 3d f1 ff ff       	call   80264c <sys_page_unmap>
  80350f:	83 c4 10             	add    $0x10,%esp
}
  803512:	89 d8                	mov    %ebx,%eax
  803514:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803517:	5b                   	pop    %ebx
  803518:	5e                   	pop    %esi
  803519:	5d                   	pop    %ebp
  80351a:	c3                   	ret    

0080351b <pipeisclosed>:
{
  80351b:	55                   	push   %ebp
  80351c:	89 e5                	mov    %esp,%ebp
  80351e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803521:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803524:	50                   	push   %eax
  803525:	ff 75 08             	pushl  0x8(%ebp)
  803528:	e8 d8 f4 ff ff       	call   802a05 <fd_lookup>
  80352d:	83 c4 10             	add    $0x10,%esp
  803530:	85 c0                	test   %eax,%eax
  803532:	78 18                	js     80354c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  803534:	83 ec 0c             	sub    $0xc,%esp
  803537:	ff 75 f4             	pushl  -0xc(%ebp)
  80353a:	e8 5d f4 ff ff       	call   80299c <fd2data>
	return _pipeisclosed(fd, p);
  80353f:	89 c2                	mov    %eax,%edx
  803541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803544:	e8 2f fd ff ff       	call   803278 <_pipeisclosed>
  803549:	83 c4 10             	add    $0x10,%esp
}
  80354c:	c9                   	leave  
  80354d:	c3                   	ret    

0080354e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80354e:	55                   	push   %ebp
  80354f:	89 e5                	mov    %esp,%ebp
  803551:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  803554:	68 e9 47 80 00       	push   $0x8047e9
  803559:	ff 75 0c             	pushl  0xc(%ebp)
  80355c:	e8 74 ec ff ff       	call   8021d5 <strcpy>
	return 0;
}
  803561:	b8 00 00 00 00       	mov    $0x0,%eax
  803566:	c9                   	leave  
  803567:	c3                   	ret    

00803568 <devsock_close>:
{
  803568:	55                   	push   %ebp
  803569:	89 e5                	mov    %esp,%ebp
  80356b:	53                   	push   %ebx
  80356c:	83 ec 10             	sub    $0x10,%esp
  80356f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803572:	53                   	push   %ebx
  803573:	e8 4d fc ff ff       	call   8031c5 <pageref>
  803578:	83 c4 10             	add    $0x10,%esp
		return 0;
  80357b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  803580:	83 f8 01             	cmp    $0x1,%eax
  803583:	74 07                	je     80358c <devsock_close+0x24>
}
  803585:	89 d0                	mov    %edx,%eax
  803587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80358a:	c9                   	leave  
  80358b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80358c:	83 ec 0c             	sub    $0xc,%esp
  80358f:	ff 73 0c             	pushl  0xc(%ebx)
  803592:	e8 b9 02 00 00       	call   803850 <nsipc_close>
  803597:	89 c2                	mov    %eax,%edx
  803599:	83 c4 10             	add    $0x10,%esp
  80359c:	eb e7                	jmp    803585 <devsock_close+0x1d>

0080359e <devsock_write>:
{
  80359e:	55                   	push   %ebp
  80359f:	89 e5                	mov    %esp,%ebp
  8035a1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8035a4:	6a 00                	push   $0x0
  8035a6:	ff 75 10             	pushl  0x10(%ebp)
  8035a9:	ff 75 0c             	pushl  0xc(%ebp)
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	ff 70 0c             	pushl  0xc(%eax)
  8035b2:	e8 76 03 00 00       	call   80392d <nsipc_send>
}
  8035b7:	c9                   	leave  
  8035b8:	c3                   	ret    

008035b9 <devsock_read>:
{
  8035b9:	55                   	push   %ebp
  8035ba:	89 e5                	mov    %esp,%ebp
  8035bc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8035bf:	6a 00                	push   $0x0
  8035c1:	ff 75 10             	pushl  0x10(%ebp)
  8035c4:	ff 75 0c             	pushl  0xc(%ebp)
  8035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ca:	ff 70 0c             	pushl  0xc(%eax)
  8035cd:	e8 ef 02 00 00       	call   8038c1 <nsipc_recv>
}
  8035d2:	c9                   	leave  
  8035d3:	c3                   	ret    

008035d4 <fd2sockid>:
{
  8035d4:	55                   	push   %ebp
  8035d5:	89 e5                	mov    %esp,%ebp
  8035d7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8035da:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8035dd:	52                   	push   %edx
  8035de:	50                   	push   %eax
  8035df:	e8 21 f4 ff ff       	call   802a05 <fd_lookup>
  8035e4:	83 c4 10             	add    $0x10,%esp
  8035e7:	85 c0                	test   %eax,%eax
  8035e9:	78 10                	js     8035fb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8035eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ee:	8b 0d 9c 90 80 00    	mov    0x80909c,%ecx
  8035f4:	39 08                	cmp    %ecx,(%eax)
  8035f6:	75 05                	jne    8035fd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8035f8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8035fb:	c9                   	leave  
  8035fc:	c3                   	ret    
		return -E_NOT_SUPP;
  8035fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803602:	eb f7                	jmp    8035fb <fd2sockid+0x27>

00803604 <alloc_sockfd>:
{
  803604:	55                   	push   %ebp
  803605:	89 e5                	mov    %esp,%ebp
  803607:	56                   	push   %esi
  803608:	53                   	push   %ebx
  803609:	83 ec 1c             	sub    $0x1c,%esp
  80360c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80360e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803611:	50                   	push   %eax
  803612:	e8 9c f3 ff ff       	call   8029b3 <fd_alloc>
  803617:	89 c3                	mov    %eax,%ebx
  803619:	83 c4 10             	add    $0x10,%esp
  80361c:	85 c0                	test   %eax,%eax
  80361e:	78 43                	js     803663 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803620:	83 ec 04             	sub    $0x4,%esp
  803623:	68 07 04 00 00       	push   $0x407
  803628:	ff 75 f4             	pushl  -0xc(%ebp)
  80362b:	6a 00                	push   $0x0
  80362d:	e8 95 ef ff ff       	call   8025c7 <sys_page_alloc>
  803632:	89 c3                	mov    %eax,%ebx
  803634:	83 c4 10             	add    $0x10,%esp
  803637:	85 c0                	test   %eax,%eax
  803639:	78 28                	js     803663 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363e:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803644:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803649:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803650:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803653:	83 ec 0c             	sub    $0xc,%esp
  803656:	50                   	push   %eax
  803657:	e8 30 f3 ff ff       	call   80298c <fd2num>
  80365c:	89 c3                	mov    %eax,%ebx
  80365e:	83 c4 10             	add    $0x10,%esp
  803661:	eb 0c                	jmp    80366f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  803663:	83 ec 0c             	sub    $0xc,%esp
  803666:	56                   	push   %esi
  803667:	e8 e4 01 00 00       	call   803850 <nsipc_close>
		return r;
  80366c:	83 c4 10             	add    $0x10,%esp
}
  80366f:	89 d8                	mov    %ebx,%eax
  803671:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803674:	5b                   	pop    %ebx
  803675:	5e                   	pop    %esi
  803676:	5d                   	pop    %ebp
  803677:	c3                   	ret    

00803678 <accept>:
{
  803678:	55                   	push   %ebp
  803679:	89 e5                	mov    %esp,%ebp
  80367b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80367e:	8b 45 08             	mov    0x8(%ebp),%eax
  803681:	e8 4e ff ff ff       	call   8035d4 <fd2sockid>
  803686:	85 c0                	test   %eax,%eax
  803688:	78 1b                	js     8036a5 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80368a:	83 ec 04             	sub    $0x4,%esp
  80368d:	ff 75 10             	pushl  0x10(%ebp)
  803690:	ff 75 0c             	pushl  0xc(%ebp)
  803693:	50                   	push   %eax
  803694:	e8 0e 01 00 00       	call   8037a7 <nsipc_accept>
  803699:	83 c4 10             	add    $0x10,%esp
  80369c:	85 c0                	test   %eax,%eax
  80369e:	78 05                	js     8036a5 <accept+0x2d>
	return alloc_sockfd(r);
  8036a0:	e8 5f ff ff ff       	call   803604 <alloc_sockfd>
}
  8036a5:	c9                   	leave  
  8036a6:	c3                   	ret    

008036a7 <bind>:
{
  8036a7:	55                   	push   %ebp
  8036a8:	89 e5                	mov    %esp,%ebp
  8036aa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8036ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b0:	e8 1f ff ff ff       	call   8035d4 <fd2sockid>
  8036b5:	85 c0                	test   %eax,%eax
  8036b7:	78 12                	js     8036cb <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8036b9:	83 ec 04             	sub    $0x4,%esp
  8036bc:	ff 75 10             	pushl  0x10(%ebp)
  8036bf:	ff 75 0c             	pushl  0xc(%ebp)
  8036c2:	50                   	push   %eax
  8036c3:	e8 31 01 00 00       	call   8037f9 <nsipc_bind>
  8036c8:	83 c4 10             	add    $0x10,%esp
}
  8036cb:	c9                   	leave  
  8036cc:	c3                   	ret    

008036cd <shutdown>:
{
  8036cd:	55                   	push   %ebp
  8036ce:	89 e5                	mov    %esp,%ebp
  8036d0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	e8 f9 fe ff ff       	call   8035d4 <fd2sockid>
  8036db:	85 c0                	test   %eax,%eax
  8036dd:	78 0f                	js     8036ee <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8036df:	83 ec 08             	sub    $0x8,%esp
  8036e2:	ff 75 0c             	pushl  0xc(%ebp)
  8036e5:	50                   	push   %eax
  8036e6:	e8 43 01 00 00       	call   80382e <nsipc_shutdown>
  8036eb:	83 c4 10             	add    $0x10,%esp
}
  8036ee:	c9                   	leave  
  8036ef:	c3                   	ret    

008036f0 <connect>:
{
  8036f0:	55                   	push   %ebp
  8036f1:	89 e5                	mov    %esp,%ebp
  8036f3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8036f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f9:	e8 d6 fe ff ff       	call   8035d4 <fd2sockid>
  8036fe:	85 c0                	test   %eax,%eax
  803700:	78 12                	js     803714 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  803702:	83 ec 04             	sub    $0x4,%esp
  803705:	ff 75 10             	pushl  0x10(%ebp)
  803708:	ff 75 0c             	pushl  0xc(%ebp)
  80370b:	50                   	push   %eax
  80370c:	e8 59 01 00 00       	call   80386a <nsipc_connect>
  803711:	83 c4 10             	add    $0x10,%esp
}
  803714:	c9                   	leave  
  803715:	c3                   	ret    

00803716 <listen>:
{
  803716:	55                   	push   %ebp
  803717:	89 e5                	mov    %esp,%ebp
  803719:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80371c:	8b 45 08             	mov    0x8(%ebp),%eax
  80371f:	e8 b0 fe ff ff       	call   8035d4 <fd2sockid>
  803724:	85 c0                	test   %eax,%eax
  803726:	78 0f                	js     803737 <listen+0x21>
	return nsipc_listen(r, backlog);
  803728:	83 ec 08             	sub    $0x8,%esp
  80372b:	ff 75 0c             	pushl  0xc(%ebp)
  80372e:	50                   	push   %eax
  80372f:	e8 6b 01 00 00       	call   80389f <nsipc_listen>
  803734:	83 c4 10             	add    $0x10,%esp
}
  803737:	c9                   	leave  
  803738:	c3                   	ret    

00803739 <socket>:

int
socket(int domain, int type, int protocol)
{
  803739:	55                   	push   %ebp
  80373a:	89 e5                	mov    %esp,%ebp
  80373c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80373f:	ff 75 10             	pushl  0x10(%ebp)
  803742:	ff 75 0c             	pushl  0xc(%ebp)
  803745:	ff 75 08             	pushl  0x8(%ebp)
  803748:	e8 3e 02 00 00       	call   80398b <nsipc_socket>
  80374d:	83 c4 10             	add    $0x10,%esp
  803750:	85 c0                	test   %eax,%eax
  803752:	78 05                	js     803759 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  803754:	e8 ab fe ff ff       	call   803604 <alloc_sockfd>
}
  803759:	c9                   	leave  
  80375a:	c3                   	ret    

0080375b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80375b:	55                   	push   %ebp
  80375c:	89 e5                	mov    %esp,%ebp
  80375e:	53                   	push   %ebx
  80375f:	83 ec 04             	sub    $0x4,%esp
  803762:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  803764:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  80376b:	74 26                	je     803793 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80376d:	6a 07                	push   $0x7
  80376f:	68 00 c0 80 00       	push   $0x80c000
  803774:	53                   	push   %ebx
  803775:	ff 35 04 a0 80 00    	pushl  0x80a004
  80377b:	e8 67 f1 ff ff       	call   8028e7 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803780:	83 c4 0c             	add    $0xc,%esp
  803783:	6a 00                	push   $0x0
  803785:	6a 00                	push   $0x0
  803787:	6a 00                	push   $0x0
  803789:	e8 e6 f0 ff ff       	call   802874 <ipc_recv>
}
  80378e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803791:	c9                   	leave  
  803792:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803793:	83 ec 0c             	sub    $0xc,%esp
  803796:	6a 02                	push   $0x2
  803798:	e8 b6 f1 ff ff       	call   802953 <ipc_find_env>
  80379d:	a3 04 a0 80 00       	mov    %eax,0x80a004
  8037a2:	83 c4 10             	add    $0x10,%esp
  8037a5:	eb c6                	jmp    80376d <nsipc+0x12>

008037a7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8037a7:	55                   	push   %ebp
  8037a8:	89 e5                	mov    %esp,%ebp
  8037aa:	56                   	push   %esi
  8037ab:	53                   	push   %ebx
  8037ac:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8037af:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b2:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8037b7:	8b 06                	mov    (%esi),%eax
  8037b9:	a3 04 c0 80 00       	mov    %eax,0x80c004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8037be:	b8 01 00 00 00       	mov    $0x1,%eax
  8037c3:	e8 93 ff ff ff       	call   80375b <nsipc>
  8037c8:	89 c3                	mov    %eax,%ebx
  8037ca:	85 c0                	test   %eax,%eax
  8037cc:	79 09                	jns    8037d7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8037ce:	89 d8                	mov    %ebx,%eax
  8037d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8037d3:	5b                   	pop    %ebx
  8037d4:	5e                   	pop    %esi
  8037d5:	5d                   	pop    %ebp
  8037d6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8037d7:	83 ec 04             	sub    $0x4,%esp
  8037da:	ff 35 10 c0 80 00    	pushl  0x80c010
  8037e0:	68 00 c0 80 00       	push   $0x80c000
  8037e5:	ff 75 0c             	pushl  0xc(%ebp)
  8037e8:	e8 76 eb ff ff       	call   802363 <memmove>
		*addrlen = ret->ret_addrlen;
  8037ed:	a1 10 c0 80 00       	mov    0x80c010,%eax
  8037f2:	89 06                	mov    %eax,(%esi)
  8037f4:	83 c4 10             	add    $0x10,%esp
	return r;
  8037f7:	eb d5                	jmp    8037ce <nsipc_accept+0x27>

008037f9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037f9:	55                   	push   %ebp
  8037fa:	89 e5                	mov    %esp,%ebp
  8037fc:	53                   	push   %ebx
  8037fd:	83 ec 08             	sub    $0x8,%esp
  803800:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803803:	8b 45 08             	mov    0x8(%ebp),%eax
  803806:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80380b:	53                   	push   %ebx
  80380c:	ff 75 0c             	pushl  0xc(%ebp)
  80380f:	68 04 c0 80 00       	push   $0x80c004
  803814:	e8 4a eb ff ff       	call   802363 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803819:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_BIND);
  80381f:	b8 02 00 00 00       	mov    $0x2,%eax
  803824:	e8 32 ff ff ff       	call   80375b <nsipc>
}
  803829:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80382c:	c9                   	leave  
  80382d:	c3                   	ret    

0080382e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80382e:	55                   	push   %ebp
  80382f:	89 e5                	mov    %esp,%ebp
  803831:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803834:	8b 45 08             	mov    0x8(%ebp),%eax
  803837:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.shutdown.req_how = how;
  80383c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80383f:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_SHUTDOWN);
  803844:	b8 03 00 00 00       	mov    $0x3,%eax
  803849:	e8 0d ff ff ff       	call   80375b <nsipc>
}
  80384e:	c9                   	leave  
  80384f:	c3                   	ret    

00803850 <nsipc_close>:

int
nsipc_close(int s)
{
  803850:	55                   	push   %ebp
  803851:	89 e5                	mov    %esp,%ebp
  803853:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803856:	8b 45 08             	mov    0x8(%ebp),%eax
  803859:	a3 00 c0 80 00       	mov    %eax,0x80c000
	return nsipc(NSREQ_CLOSE);
  80385e:	b8 04 00 00 00       	mov    $0x4,%eax
  803863:	e8 f3 fe ff ff       	call   80375b <nsipc>
}
  803868:	c9                   	leave  
  803869:	c3                   	ret    

0080386a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80386a:	55                   	push   %ebp
  80386b:	89 e5                	mov    %esp,%ebp
  80386d:	53                   	push   %ebx
  80386e:	83 ec 08             	sub    $0x8,%esp
  803871:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803874:	8b 45 08             	mov    0x8(%ebp),%eax
  803877:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80387c:	53                   	push   %ebx
  80387d:	ff 75 0c             	pushl  0xc(%ebp)
  803880:	68 04 c0 80 00       	push   $0x80c004
  803885:	e8 d9 ea ff ff       	call   802363 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80388a:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_CONNECT);
  803890:	b8 05 00 00 00       	mov    $0x5,%eax
  803895:	e8 c1 fe ff ff       	call   80375b <nsipc>
}
  80389a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80389d:	c9                   	leave  
  80389e:	c3                   	ret    

0080389f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80389f:	55                   	push   %ebp
  8038a0:	89 e5                	mov    %esp,%ebp
  8038a2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8038a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a8:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.listen.req_backlog = backlog;
  8038ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b0:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_LISTEN);
  8038b5:	b8 06 00 00 00       	mov    $0x6,%eax
  8038ba:	e8 9c fe ff ff       	call   80375b <nsipc>
}
  8038bf:	c9                   	leave  
  8038c0:	c3                   	ret    

008038c1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8038c1:	55                   	push   %ebp
  8038c2:	89 e5                	mov    %esp,%ebp
  8038c4:	56                   	push   %esi
  8038c5:	53                   	push   %ebx
  8038c6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8038c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cc:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.recv.req_len = len;
  8038d1:	89 35 04 c0 80 00    	mov    %esi,0x80c004
	nsipcbuf.recv.req_flags = flags;
  8038d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8038da:	a3 08 c0 80 00       	mov    %eax,0x80c008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8038df:	b8 07 00 00 00       	mov    $0x7,%eax
  8038e4:	e8 72 fe ff ff       	call   80375b <nsipc>
  8038e9:	89 c3                	mov    %eax,%ebx
  8038eb:	85 c0                	test   %eax,%eax
  8038ed:	78 1f                	js     80390e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8038ef:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8038f4:	7f 21                	jg     803917 <nsipc_recv+0x56>
  8038f6:	39 c6                	cmp    %eax,%esi
  8038f8:	7c 1d                	jl     803917 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8038fa:	83 ec 04             	sub    $0x4,%esp
  8038fd:	50                   	push   %eax
  8038fe:	68 00 c0 80 00       	push   $0x80c000
  803903:	ff 75 0c             	pushl  0xc(%ebp)
  803906:	e8 58 ea ff ff       	call   802363 <memmove>
  80390b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80390e:	89 d8                	mov    %ebx,%eax
  803910:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803913:	5b                   	pop    %ebx
  803914:	5e                   	pop    %esi
  803915:	5d                   	pop    %ebp
  803916:	c3                   	ret    
		assert(r < 1600 && r <= len);
  803917:	68 f5 47 80 00       	push   $0x8047f5
  80391c:	68 bd 3d 80 00       	push   $0x803dbd
  803921:	6a 62                	push   $0x62
  803923:	68 0a 48 80 00       	push   $0x80480a
  803928:	e8 f1 e1 ff ff       	call   801b1e <_panic>

0080392d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80392d:	55                   	push   %ebp
  80392e:	89 e5                	mov    %esp,%ebp
  803930:	53                   	push   %ebx
  803931:	83 ec 04             	sub    $0x4,%esp
  803934:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803937:	8b 45 08             	mov    0x8(%ebp),%eax
  80393a:	a3 00 c0 80 00       	mov    %eax,0x80c000
	assert(size < 1600);
  80393f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803945:	7f 2e                	jg     803975 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803947:	83 ec 04             	sub    $0x4,%esp
  80394a:	53                   	push   %ebx
  80394b:	ff 75 0c             	pushl  0xc(%ebp)
  80394e:	68 0c c0 80 00       	push   $0x80c00c
  803953:	e8 0b ea ff ff       	call   802363 <memmove>
	nsipcbuf.send.req_size = size;
  803958:	89 1d 04 c0 80 00    	mov    %ebx,0x80c004
	nsipcbuf.send.req_flags = flags;
  80395e:	8b 45 14             	mov    0x14(%ebp),%eax
  803961:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SEND);
  803966:	b8 08 00 00 00       	mov    $0x8,%eax
  80396b:	e8 eb fd ff ff       	call   80375b <nsipc>
}
  803970:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803973:	c9                   	leave  
  803974:	c3                   	ret    
	assert(size < 1600);
  803975:	68 16 48 80 00       	push   $0x804816
  80397a:	68 bd 3d 80 00       	push   $0x803dbd
  80397f:	6a 6d                	push   $0x6d
  803981:	68 0a 48 80 00       	push   $0x80480a
  803986:	e8 93 e1 ff ff       	call   801b1e <_panic>

0080398b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80398b:	55                   	push   %ebp
  80398c:	89 e5                	mov    %esp,%ebp
  80398e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803991:	8b 45 08             	mov    0x8(%ebp),%eax
  803994:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.socket.req_type = type;
  803999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80399c:	a3 04 c0 80 00       	mov    %eax,0x80c004
	nsipcbuf.socket.req_protocol = protocol;
  8039a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8039a4:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SOCKET);
  8039a9:	b8 09 00 00 00       	mov    $0x9,%eax
  8039ae:	e8 a8 fd ff ff       	call   80375b <nsipc>
}
  8039b3:	c9                   	leave  
  8039b4:	c3                   	ret    

008039b5 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8039b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ba:	c3                   	ret    

008039bb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8039bb:	55                   	push   %ebp
  8039bc:	89 e5                	mov    %esp,%ebp
  8039be:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8039c1:	68 22 48 80 00       	push   $0x804822
  8039c6:	ff 75 0c             	pushl  0xc(%ebp)
  8039c9:	e8 07 e8 ff ff       	call   8021d5 <strcpy>
	return 0;
}
  8039ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8039d3:	c9                   	leave  
  8039d4:	c3                   	ret    

008039d5 <devcons_write>:
{
  8039d5:	55                   	push   %ebp
  8039d6:	89 e5                	mov    %esp,%ebp
  8039d8:	57                   	push   %edi
  8039d9:	56                   	push   %esi
  8039da:	53                   	push   %ebx
  8039db:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8039e1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8039e6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8039ec:	3b 75 10             	cmp    0x10(%ebp),%esi
  8039ef:	73 31                	jae    803a22 <devcons_write+0x4d>
		m = n - tot;
  8039f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8039f4:	29 f3                	sub    %esi,%ebx
  8039f6:	83 fb 7f             	cmp    $0x7f,%ebx
  8039f9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8039fe:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  803a01:	83 ec 04             	sub    $0x4,%esp
  803a04:	53                   	push   %ebx
  803a05:	89 f0                	mov    %esi,%eax
  803a07:	03 45 0c             	add    0xc(%ebp),%eax
  803a0a:	50                   	push   %eax
  803a0b:	57                   	push   %edi
  803a0c:	e8 52 e9 ff ff       	call   802363 <memmove>
		sys_cputs(buf, m);
  803a11:	83 c4 08             	add    $0x8,%esp
  803a14:	53                   	push   %ebx
  803a15:	57                   	push   %edi
  803a16:	e8 f0 ea ff ff       	call   80250b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  803a1b:	01 de                	add    %ebx,%esi
  803a1d:	83 c4 10             	add    $0x10,%esp
  803a20:	eb ca                	jmp    8039ec <devcons_write+0x17>
}
  803a22:	89 f0                	mov    %esi,%eax
  803a24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803a27:	5b                   	pop    %ebx
  803a28:	5e                   	pop    %esi
  803a29:	5f                   	pop    %edi
  803a2a:	5d                   	pop    %ebp
  803a2b:	c3                   	ret    

00803a2c <devcons_read>:
{
  803a2c:	55                   	push   %ebp
  803a2d:	89 e5                	mov    %esp,%ebp
  803a2f:	83 ec 08             	sub    $0x8,%esp
  803a32:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803a37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803a3b:	74 21                	je     803a5e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  803a3d:	e8 e7 ea ff ff       	call   802529 <sys_cgetc>
  803a42:	85 c0                	test   %eax,%eax
  803a44:	75 07                	jne    803a4d <devcons_read+0x21>
		sys_yield();
  803a46:	e8 5d eb ff ff       	call   8025a8 <sys_yield>
  803a4b:	eb f0                	jmp    803a3d <devcons_read+0x11>
	if (c < 0)
  803a4d:	78 0f                	js     803a5e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  803a4f:	83 f8 04             	cmp    $0x4,%eax
  803a52:	74 0c                	je     803a60 <devcons_read+0x34>
	*(char*)vbuf = c;
  803a54:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a57:	88 02                	mov    %al,(%edx)
	return 1;
  803a59:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a5e:	c9                   	leave  
  803a5f:	c3                   	ret    
		return 0;
  803a60:	b8 00 00 00 00       	mov    $0x0,%eax
  803a65:	eb f7                	jmp    803a5e <devcons_read+0x32>

00803a67 <cputchar>:
{
  803a67:	55                   	push   %ebp
  803a68:	89 e5                	mov    %esp,%ebp
  803a6a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  803a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a70:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  803a73:	6a 01                	push   $0x1
  803a75:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803a78:	50                   	push   %eax
  803a79:	e8 8d ea ff ff       	call   80250b <sys_cputs>
}
  803a7e:	83 c4 10             	add    $0x10,%esp
  803a81:	c9                   	leave  
  803a82:	c3                   	ret    

00803a83 <getchar>:
{
  803a83:	55                   	push   %ebp
  803a84:	89 e5                	mov    %esp,%ebp
  803a86:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  803a89:	6a 01                	push   $0x1
  803a8b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803a8e:	50                   	push   %eax
  803a8f:	6a 00                	push   $0x0
  803a91:	e8 df f1 ff ff       	call   802c75 <read>
	if (r < 0)
  803a96:	83 c4 10             	add    $0x10,%esp
  803a99:	85 c0                	test   %eax,%eax
  803a9b:	78 06                	js     803aa3 <getchar+0x20>
	if (r < 1)
  803a9d:	74 06                	je     803aa5 <getchar+0x22>
	return c;
  803a9f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  803aa3:	c9                   	leave  
  803aa4:	c3                   	ret    
		return -E_EOF;
  803aa5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803aaa:	eb f7                	jmp    803aa3 <getchar+0x20>

00803aac <iscons>:
{
  803aac:	55                   	push   %ebp
  803aad:	89 e5                	mov    %esp,%ebp
  803aaf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ab2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ab5:	50                   	push   %eax
  803ab6:	ff 75 08             	pushl  0x8(%ebp)
  803ab9:	e8 47 ef ff ff       	call   802a05 <fd_lookup>
  803abe:	83 c4 10             	add    $0x10,%esp
  803ac1:	85 c0                	test   %eax,%eax
  803ac3:	78 11                	js     803ad6 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  803ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac8:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803ace:	39 10                	cmp    %edx,(%eax)
  803ad0:	0f 94 c0             	sete   %al
  803ad3:	0f b6 c0             	movzbl %al,%eax
}
  803ad6:	c9                   	leave  
  803ad7:	c3                   	ret    

00803ad8 <opencons>:
{
  803ad8:	55                   	push   %ebp
  803ad9:	89 e5                	mov    %esp,%ebp
  803adb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  803ade:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ae1:	50                   	push   %eax
  803ae2:	e8 cc ee ff ff       	call   8029b3 <fd_alloc>
  803ae7:	83 c4 10             	add    $0x10,%esp
  803aea:	85 c0                	test   %eax,%eax
  803aec:	78 3a                	js     803b28 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803aee:	83 ec 04             	sub    $0x4,%esp
  803af1:	68 07 04 00 00       	push   $0x407
  803af6:	ff 75 f4             	pushl  -0xc(%ebp)
  803af9:	6a 00                	push   $0x0
  803afb:	e8 c7 ea ff ff       	call   8025c7 <sys_page_alloc>
  803b00:	83 c4 10             	add    $0x10,%esp
  803b03:	85 c0                	test   %eax,%eax
  803b05:	78 21                	js     803b28 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  803b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0a:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803b10:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b15:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803b1c:	83 ec 0c             	sub    $0xc,%esp
  803b1f:	50                   	push   %eax
  803b20:	e8 67 ee ff ff       	call   80298c <fd2num>
  803b25:	83 c4 10             	add    $0x10,%esp
}
  803b28:	c9                   	leave  
  803b29:	c3                   	ret    
  803b2a:	66 90                	xchg   %ax,%ax
  803b2c:	66 90                	xchg   %ax,%ax
  803b2e:	66 90                	xchg   %ax,%ax

00803b30 <__udivdi3>:
  803b30:	f3 0f 1e fb          	endbr32 
  803b34:	55                   	push   %ebp
  803b35:	57                   	push   %edi
  803b36:	56                   	push   %esi
  803b37:	53                   	push   %ebx
  803b38:	83 ec 1c             	sub    $0x1c,%esp
  803b3b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803b3f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803b43:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b47:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803b4b:	85 d2                	test   %edx,%edx
  803b4d:	75 49                	jne    803b98 <__udivdi3+0x68>
  803b4f:	39 f3                	cmp    %esi,%ebx
  803b51:	76 15                	jbe    803b68 <__udivdi3+0x38>
  803b53:	31 ff                	xor    %edi,%edi
  803b55:	89 e8                	mov    %ebp,%eax
  803b57:	89 f2                	mov    %esi,%edx
  803b59:	f7 f3                	div    %ebx
  803b5b:	89 fa                	mov    %edi,%edx
  803b5d:	83 c4 1c             	add    $0x1c,%esp
  803b60:	5b                   	pop    %ebx
  803b61:	5e                   	pop    %esi
  803b62:	5f                   	pop    %edi
  803b63:	5d                   	pop    %ebp
  803b64:	c3                   	ret    
  803b65:	8d 76 00             	lea    0x0(%esi),%esi
  803b68:	89 d9                	mov    %ebx,%ecx
  803b6a:	85 db                	test   %ebx,%ebx
  803b6c:	75 0b                	jne    803b79 <__udivdi3+0x49>
  803b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b73:	31 d2                	xor    %edx,%edx
  803b75:	f7 f3                	div    %ebx
  803b77:	89 c1                	mov    %eax,%ecx
  803b79:	31 d2                	xor    %edx,%edx
  803b7b:	89 f0                	mov    %esi,%eax
  803b7d:	f7 f1                	div    %ecx
  803b7f:	89 c6                	mov    %eax,%esi
  803b81:	89 e8                	mov    %ebp,%eax
  803b83:	89 f7                	mov    %esi,%edi
  803b85:	f7 f1                	div    %ecx
  803b87:	89 fa                	mov    %edi,%edx
  803b89:	83 c4 1c             	add    $0x1c,%esp
  803b8c:	5b                   	pop    %ebx
  803b8d:	5e                   	pop    %esi
  803b8e:	5f                   	pop    %edi
  803b8f:	5d                   	pop    %ebp
  803b90:	c3                   	ret    
  803b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803b98:	39 f2                	cmp    %esi,%edx
  803b9a:	77 1c                	ja     803bb8 <__udivdi3+0x88>
  803b9c:	0f bd fa             	bsr    %edx,%edi
  803b9f:	83 f7 1f             	xor    $0x1f,%edi
  803ba2:	75 2c                	jne    803bd0 <__udivdi3+0xa0>
  803ba4:	39 f2                	cmp    %esi,%edx
  803ba6:	72 06                	jb     803bae <__udivdi3+0x7e>
  803ba8:	31 c0                	xor    %eax,%eax
  803baa:	39 eb                	cmp    %ebp,%ebx
  803bac:	77 ad                	ja     803b5b <__udivdi3+0x2b>
  803bae:	b8 01 00 00 00       	mov    $0x1,%eax
  803bb3:	eb a6                	jmp    803b5b <__udivdi3+0x2b>
  803bb5:	8d 76 00             	lea    0x0(%esi),%esi
  803bb8:	31 ff                	xor    %edi,%edi
  803bba:	31 c0                	xor    %eax,%eax
  803bbc:	89 fa                	mov    %edi,%edx
  803bbe:	83 c4 1c             	add    $0x1c,%esp
  803bc1:	5b                   	pop    %ebx
  803bc2:	5e                   	pop    %esi
  803bc3:	5f                   	pop    %edi
  803bc4:	5d                   	pop    %ebp
  803bc5:	c3                   	ret    
  803bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803bcd:	8d 76 00             	lea    0x0(%esi),%esi
  803bd0:	89 f9                	mov    %edi,%ecx
  803bd2:	b8 20 00 00 00       	mov    $0x20,%eax
  803bd7:	29 f8                	sub    %edi,%eax
  803bd9:	d3 e2                	shl    %cl,%edx
  803bdb:	89 54 24 08          	mov    %edx,0x8(%esp)
  803bdf:	89 c1                	mov    %eax,%ecx
  803be1:	89 da                	mov    %ebx,%edx
  803be3:	d3 ea                	shr    %cl,%edx
  803be5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803be9:	09 d1                	or     %edx,%ecx
  803beb:	89 f2                	mov    %esi,%edx
  803bed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803bf1:	89 f9                	mov    %edi,%ecx
  803bf3:	d3 e3                	shl    %cl,%ebx
  803bf5:	89 c1                	mov    %eax,%ecx
  803bf7:	d3 ea                	shr    %cl,%edx
  803bf9:	89 f9                	mov    %edi,%ecx
  803bfb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803bff:	89 eb                	mov    %ebp,%ebx
  803c01:	d3 e6                	shl    %cl,%esi
  803c03:	89 c1                	mov    %eax,%ecx
  803c05:	d3 eb                	shr    %cl,%ebx
  803c07:	09 de                	or     %ebx,%esi
  803c09:	89 f0                	mov    %esi,%eax
  803c0b:	f7 74 24 08          	divl   0x8(%esp)
  803c0f:	89 d6                	mov    %edx,%esi
  803c11:	89 c3                	mov    %eax,%ebx
  803c13:	f7 64 24 0c          	mull   0xc(%esp)
  803c17:	39 d6                	cmp    %edx,%esi
  803c19:	72 15                	jb     803c30 <__udivdi3+0x100>
  803c1b:	89 f9                	mov    %edi,%ecx
  803c1d:	d3 e5                	shl    %cl,%ebp
  803c1f:	39 c5                	cmp    %eax,%ebp
  803c21:	73 04                	jae    803c27 <__udivdi3+0xf7>
  803c23:	39 d6                	cmp    %edx,%esi
  803c25:	74 09                	je     803c30 <__udivdi3+0x100>
  803c27:	89 d8                	mov    %ebx,%eax
  803c29:	31 ff                	xor    %edi,%edi
  803c2b:	e9 2b ff ff ff       	jmp    803b5b <__udivdi3+0x2b>
  803c30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c33:	31 ff                	xor    %edi,%edi
  803c35:	e9 21 ff ff ff       	jmp    803b5b <__udivdi3+0x2b>
  803c3a:	66 90                	xchg   %ax,%ax
  803c3c:	66 90                	xchg   %ax,%ax
  803c3e:	66 90                	xchg   %ax,%ax

00803c40 <__umoddi3>:
  803c40:	f3 0f 1e fb          	endbr32 
  803c44:	55                   	push   %ebp
  803c45:	57                   	push   %edi
  803c46:	56                   	push   %esi
  803c47:	53                   	push   %ebx
  803c48:	83 ec 1c             	sub    $0x1c,%esp
  803c4b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803c4f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c53:	8b 74 24 30          	mov    0x30(%esp),%esi
  803c57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c5b:	89 da                	mov    %ebx,%edx
  803c5d:	85 c0                	test   %eax,%eax
  803c5f:	75 3f                	jne    803ca0 <__umoddi3+0x60>
  803c61:	39 df                	cmp    %ebx,%edi
  803c63:	76 13                	jbe    803c78 <__umoddi3+0x38>
  803c65:	89 f0                	mov    %esi,%eax
  803c67:	f7 f7                	div    %edi
  803c69:	89 d0                	mov    %edx,%eax
  803c6b:	31 d2                	xor    %edx,%edx
  803c6d:	83 c4 1c             	add    $0x1c,%esp
  803c70:	5b                   	pop    %ebx
  803c71:	5e                   	pop    %esi
  803c72:	5f                   	pop    %edi
  803c73:	5d                   	pop    %ebp
  803c74:	c3                   	ret    
  803c75:	8d 76 00             	lea    0x0(%esi),%esi
  803c78:	89 fd                	mov    %edi,%ebp
  803c7a:	85 ff                	test   %edi,%edi
  803c7c:	75 0b                	jne    803c89 <__umoddi3+0x49>
  803c7e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c83:	31 d2                	xor    %edx,%edx
  803c85:	f7 f7                	div    %edi
  803c87:	89 c5                	mov    %eax,%ebp
  803c89:	89 d8                	mov    %ebx,%eax
  803c8b:	31 d2                	xor    %edx,%edx
  803c8d:	f7 f5                	div    %ebp
  803c8f:	89 f0                	mov    %esi,%eax
  803c91:	f7 f5                	div    %ebp
  803c93:	89 d0                	mov    %edx,%eax
  803c95:	eb d4                	jmp    803c6b <__umoddi3+0x2b>
  803c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803c9e:	66 90                	xchg   %ax,%ax
  803ca0:	89 f1                	mov    %esi,%ecx
  803ca2:	39 d8                	cmp    %ebx,%eax
  803ca4:	76 0a                	jbe    803cb0 <__umoddi3+0x70>
  803ca6:	89 f0                	mov    %esi,%eax
  803ca8:	83 c4 1c             	add    $0x1c,%esp
  803cab:	5b                   	pop    %ebx
  803cac:	5e                   	pop    %esi
  803cad:	5f                   	pop    %edi
  803cae:	5d                   	pop    %ebp
  803caf:	c3                   	ret    
  803cb0:	0f bd e8             	bsr    %eax,%ebp
  803cb3:	83 f5 1f             	xor    $0x1f,%ebp
  803cb6:	75 20                	jne    803cd8 <__umoddi3+0x98>
  803cb8:	39 d8                	cmp    %ebx,%eax
  803cba:	0f 82 b0 00 00 00    	jb     803d70 <__umoddi3+0x130>
  803cc0:	39 f7                	cmp    %esi,%edi
  803cc2:	0f 86 a8 00 00 00    	jbe    803d70 <__umoddi3+0x130>
  803cc8:	89 c8                	mov    %ecx,%eax
  803cca:	83 c4 1c             	add    $0x1c,%esp
  803ccd:	5b                   	pop    %ebx
  803cce:	5e                   	pop    %esi
  803ccf:	5f                   	pop    %edi
  803cd0:	5d                   	pop    %ebp
  803cd1:	c3                   	ret    
  803cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803cd8:	89 e9                	mov    %ebp,%ecx
  803cda:	ba 20 00 00 00       	mov    $0x20,%edx
  803cdf:	29 ea                	sub    %ebp,%edx
  803ce1:	d3 e0                	shl    %cl,%eax
  803ce3:	89 44 24 08          	mov    %eax,0x8(%esp)
  803ce7:	89 d1                	mov    %edx,%ecx
  803ce9:	89 f8                	mov    %edi,%eax
  803ceb:	d3 e8                	shr    %cl,%eax
  803ced:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803cf1:	89 54 24 04          	mov    %edx,0x4(%esp)
  803cf5:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cf9:	09 c1                	or     %eax,%ecx
  803cfb:	89 d8                	mov    %ebx,%eax
  803cfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d01:	89 e9                	mov    %ebp,%ecx
  803d03:	d3 e7                	shl    %cl,%edi
  803d05:	89 d1                	mov    %edx,%ecx
  803d07:	d3 e8                	shr    %cl,%eax
  803d09:	89 e9                	mov    %ebp,%ecx
  803d0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d0f:	d3 e3                	shl    %cl,%ebx
  803d11:	89 c7                	mov    %eax,%edi
  803d13:	89 d1                	mov    %edx,%ecx
  803d15:	89 f0                	mov    %esi,%eax
  803d17:	d3 e8                	shr    %cl,%eax
  803d19:	89 e9                	mov    %ebp,%ecx
  803d1b:	89 fa                	mov    %edi,%edx
  803d1d:	d3 e6                	shl    %cl,%esi
  803d1f:	09 d8                	or     %ebx,%eax
  803d21:	f7 74 24 08          	divl   0x8(%esp)
  803d25:	89 d1                	mov    %edx,%ecx
  803d27:	89 f3                	mov    %esi,%ebx
  803d29:	f7 64 24 0c          	mull   0xc(%esp)
  803d2d:	89 c6                	mov    %eax,%esi
  803d2f:	89 d7                	mov    %edx,%edi
  803d31:	39 d1                	cmp    %edx,%ecx
  803d33:	72 06                	jb     803d3b <__umoddi3+0xfb>
  803d35:	75 10                	jne    803d47 <__umoddi3+0x107>
  803d37:	39 c3                	cmp    %eax,%ebx
  803d39:	73 0c                	jae    803d47 <__umoddi3+0x107>
  803d3b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  803d3f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803d43:	89 d7                	mov    %edx,%edi
  803d45:	89 c6                	mov    %eax,%esi
  803d47:	89 ca                	mov    %ecx,%edx
  803d49:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803d4e:	29 f3                	sub    %esi,%ebx
  803d50:	19 fa                	sbb    %edi,%edx
  803d52:	89 d0                	mov    %edx,%eax
  803d54:	d3 e0                	shl    %cl,%eax
  803d56:	89 e9                	mov    %ebp,%ecx
  803d58:	d3 eb                	shr    %cl,%ebx
  803d5a:	d3 ea                	shr    %cl,%edx
  803d5c:	09 d8                	or     %ebx,%eax
  803d5e:	83 c4 1c             	add    $0x1c,%esp
  803d61:	5b                   	pop    %ebx
  803d62:	5e                   	pop    %esi
  803d63:	5f                   	pop    %edi
  803d64:	5d                   	pop    %ebp
  803d65:	c3                   	ret    
  803d66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803d6d:	8d 76 00             	lea    0x0(%esi),%esi
  803d70:	89 da                	mov    %ebx,%edx
  803d72:	29 fe                	sub    %edi,%esi
  803d74:	19 c2                	sbb    %eax,%edx
  803d76:	89 f1                	mov    %esi,%ecx
  803d78:	89 c8                	mov    %ecx,%eax
  803d7a:	e9 4b ff ff ff       	jmp    803cca <__umoddi3+0x8a>
