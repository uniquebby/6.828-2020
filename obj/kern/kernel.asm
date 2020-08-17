
obj/kern/kernel：     文件格式 elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 30 12 00       	mov    $0x123000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 30 12 f0       	mov    $0xf0123000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 5e 00 00 00       	call   f010009c <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100048:	83 3d 98 3e 53 f0 00 	cmpl   $0x0,0xf0533e98
f010004f:	74 0f                	je     f0100060 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100051:	83 ec 0c             	sub    $0xc,%esp
f0100054:	6a 00                	push   $0x0
f0100056:	e8 30 09 00 00       	call   f010098b <monitor>
f010005b:	83 c4 10             	add    $0x10,%esp
f010005e:	eb f1                	jmp    f0100051 <_panic+0x11>
	panicstr = fmt;
f0100060:	89 35 98 3e 53 f0    	mov    %esi,0xf0533e98
	asm volatile("cli; cld");
f0100066:	fa                   	cli    
f0100067:	fc                   	cld    
	va_start(ap, fmt);
f0100068:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006b:	e8 ee 5d 00 00       	call   f0105e5e <cpunum>
f0100070:	ff 75 0c             	pushl  0xc(%ebp)
f0100073:	ff 75 08             	pushl  0x8(%ebp)
f0100076:	50                   	push   %eax
f0100077:	68 20 6a 10 f0       	push   $0xf0106a20
f010007c:	e8 59 39 00 00       	call   f01039da <cprintf>
	vcprintf(fmt, ap);
f0100081:	83 c4 08             	add    $0x8,%esp
f0100084:	53                   	push   %ebx
f0100085:	56                   	push   %esi
f0100086:	e8 29 39 00 00       	call   f01039b4 <vcprintf>
	cprintf("\n");
f010008b:	c7 04 24 c3 7c 10 f0 	movl   $0xf0107cc3,(%esp)
f0100092:	e8 43 39 00 00       	call   f01039da <cprintf>
f0100097:	83 c4 10             	add    $0x10,%esp
f010009a:	eb b5                	jmp    f0100051 <_panic+0x11>

f010009c <i386_init>:
{
f010009c:	55                   	push   %ebp
f010009d:	89 e5                	mov    %esp,%ebp
f010009f:	53                   	push   %ebx
f01000a0:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000a3:	e8 d4 05 00 00       	call   f010067c <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000a8:	83 ec 08             	sub    $0x8,%esp
f01000ab:	68 ac 1a 00 00       	push   $0x1aac
f01000b0:	68 8c 6a 10 f0       	push   $0xf0106a8c
f01000b5:	e8 20 39 00 00       	call   f01039da <cprintf>
	mem_init();
f01000ba:	e8 34 13 00 00       	call   f01013f3 <mem_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000bf:	83 c4 08             	add    $0x8,%esp
f01000c2:	68 ac 1a 00 00       	push   $0x1aac
f01000c7:	68 8c 6a 10 f0       	push   $0xf0106a8c
f01000cc:	e8 09 39 00 00       	call   f01039da <cprintf>
	env_init();
f01000d1:	e8 24 31 00 00       	call   f01031fa <env_init>
	trap_init();
f01000d6:	e8 e1 39 00 00       	call   f0103abc <trap_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000db:	83 c4 08             	add    $0x8,%esp
f01000de:	68 ac 1a 00 00       	push   $0x1aac
f01000e3:	68 8c 6a 10 f0       	push   $0xf0106a8c
f01000e8:	e8 ed 38 00 00       	call   f01039da <cprintf>
	mp_init();
f01000ed:	e8 75 5a 00 00       	call   f0105b67 <mp_init>
	lapic_init();
f01000f2:	e8 7d 5d 00 00       	call   f0105e74 <lapic_init>
	pic_init();
f01000f7:	e8 ed 37 00 00       	call   f01038e9 <pic_init>
	time_init();
f01000fc:	e8 7c 66 00 00       	call   f010677d <time_init>
	pci_init();
f0100101:	e8 57 66 00 00       	call   f010675d <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f0100106:	c7 04 24 c0 53 12 f0 	movl   $0xf01253c0,(%esp)
f010010d:	e8 bc 5f 00 00       	call   f01060ce <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100112:	83 c4 10             	add    $0x10,%esp
f0100115:	83 3d a0 3e 53 f0 07 	cmpl   $0x7,0xf0533ea0
f010011c:	76 27                	jbe    f0100145 <i386_init+0xa9>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f010011e:	83 ec 04             	sub    $0x4,%esp
f0100121:	b8 ca 5a 10 f0       	mov    $0xf0105aca,%eax
f0100126:	2d 50 5a 10 f0       	sub    $0xf0105a50,%eax
f010012b:	50                   	push   %eax
f010012c:	68 50 5a 10 f0       	push   $0xf0105a50
f0100131:	68 00 70 00 f0       	push   $0xf0007000
f0100136:	e8 6c 57 00 00       	call   f01058a7 <memmove>
f010013b:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f010013e:	bb 20 40 53 f0       	mov    $0xf0534020,%ebx
f0100143:	eb 19                	jmp    f010015e <i386_init+0xc2>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100145:	68 00 70 00 00       	push   $0x7000
f010014a:	68 44 6a 10 f0       	push   $0xf0106a44
f010014f:	6a 68                	push   $0x68
f0100151:	68 a7 6a 10 f0       	push   $0xf0106aa7
f0100156:	e8 e5 fe ff ff       	call   f0100040 <_panic>
f010015b:	83 c3 74             	add    $0x74,%ebx
f010015e:	6b 05 c4 43 53 f0 74 	imul   $0x74,0xf05343c4,%eax
f0100165:	05 20 40 53 f0       	add    $0xf0534020,%eax
f010016a:	39 c3                	cmp    %eax,%ebx
f010016c:	73 4d                	jae    f01001bb <i386_init+0x11f>
		if (c == cpus + cpunum())  // We've started already.
f010016e:	e8 eb 5c 00 00       	call   f0105e5e <cpunum>
f0100173:	6b c0 74             	imul   $0x74,%eax,%eax
f0100176:	05 20 40 53 f0       	add    $0xf0534020,%eax
f010017b:	39 c3                	cmp    %eax,%ebx
f010017d:	74 dc                	je     f010015b <i386_init+0xbf>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f010017f:	89 d8                	mov    %ebx,%eax
f0100181:	2d 20 40 53 f0       	sub    $0xf0534020,%eax
f0100186:	c1 f8 02             	sar    $0x2,%eax
f0100189:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f010018f:	c1 e0 0f             	shl    $0xf,%eax
f0100192:	8d 80 00 d0 53 f0    	lea    -0xfac3000(%eax),%eax
f0100198:	a3 9c 3e 53 f0       	mov    %eax,0xf0533e9c
		lapic_startap(c->cpu_id, PADDR(code));
f010019d:	83 ec 08             	sub    $0x8,%esp
f01001a0:	68 00 70 00 00       	push   $0x7000
f01001a5:	0f b6 03             	movzbl (%ebx),%eax
f01001a8:	50                   	push   %eax
f01001a9:	e8 18 5e 00 00       	call   f0105fc6 <lapic_startap>
f01001ae:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f01001b1:	8b 43 04             	mov    0x4(%ebx),%eax
f01001b4:	83 f8 01             	cmp    $0x1,%eax
f01001b7:	75 f8                	jne    f01001b1 <i386_init+0x115>
f01001b9:	eb a0                	jmp    f010015b <i386_init+0xbf>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f01001bb:	83 ec 08             	sub    $0x8,%esp
f01001be:	6a 01                	push   $0x1
f01001c0:	68 20 48 3b f0       	push   $0xf03b4820
f01001c5:	e8 00 32 00 00       	call   f01033ca <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001ca:	83 c4 08             	add    $0x8,%esp
f01001cd:	6a 00                	push   $0x0
f01001cf:	68 90 1f 3d f0       	push   $0xf03d1f90
f01001d4:	e8 f1 31 00 00       	call   f01033ca <env_create>
  cprintf("init: %x\n", &envs[0]);
f01001d9:	83 c4 08             	add    $0x8,%esp
f01001dc:	ff 35 48 32 53 f0    	pushl  0xf0533248
f01001e2:	68 b3 6a 10 f0       	push   $0xf0106ab3
f01001e7:	e8 ee 37 00 00       	call   f01039da <cprintf>
	env_run(&envs[0]);
f01001ec:	83 c4 04             	add    $0x4,%esp
f01001ef:	ff 35 48 32 53 f0    	pushl  0xf0533248
f01001f5:	e8 a6 35 00 00       	call   f01037a0 <env_run>

f01001fa <mp_main>:
{
f01001fa:	55                   	push   %ebp
f01001fb:	89 e5                	mov    %esp,%ebp
f01001fd:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f0100200:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
	if ((uint32_t)kva < KERNBASE)
f0100205:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010020a:	76 52                	jbe    f010025e <mp_main+0x64>
	return (physaddr_t)kva - KERNBASE;
f010020c:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0100211:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f0100214:	e8 45 5c 00 00       	call   f0105e5e <cpunum>
f0100219:	83 ec 08             	sub    $0x8,%esp
f010021c:	50                   	push   %eax
f010021d:	68 bd 6a 10 f0       	push   $0xf0106abd
f0100222:	e8 b3 37 00 00       	call   f01039da <cprintf>
	lapic_init();
f0100227:	e8 48 5c 00 00       	call   f0105e74 <lapic_init>
	env_init_percpu();
f010022c:	e8 9d 2f 00 00       	call   f01031ce <env_init_percpu>
	trap_init_percpu();
f0100231:	e8 b8 37 00 00       	call   f01039ee <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100236:	e8 23 5c 00 00       	call   f0105e5e <cpunum>
f010023b:	6b d0 74             	imul   $0x74,%eax,%edx
f010023e:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100241:	b8 01 00 00 00       	mov    $0x1,%eax
f0100246:	f0 87 82 20 40 53 f0 	lock xchg %eax,-0xfacbfe0(%edx)
f010024d:	c7 04 24 c0 53 12 f0 	movl   $0xf01253c0,(%esp)
f0100254:	e8 75 5e 00 00       	call   f01060ce <spin_lock>
  sched_yield();
f0100259:	e8 01 44 00 00       	call   f010465f <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010025e:	50                   	push   %eax
f010025f:	68 68 6a 10 f0       	push   $0xf0106a68
f0100264:	6a 7f                	push   $0x7f
f0100266:	68 a7 6a 10 f0       	push   $0xf0106aa7
f010026b:	e8 d0 fd ff ff       	call   f0100040 <_panic>

f0100270 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100270:	55                   	push   %ebp
f0100271:	89 e5                	mov    %esp,%ebp
f0100273:	53                   	push   %ebx
f0100274:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100277:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f010027a:	ff 75 0c             	pushl  0xc(%ebp)
f010027d:	ff 75 08             	pushl  0x8(%ebp)
f0100280:	68 d3 6a 10 f0       	push   $0xf0106ad3
f0100285:	e8 50 37 00 00       	call   f01039da <cprintf>
	vcprintf(fmt, ap);
f010028a:	83 c4 08             	add    $0x8,%esp
f010028d:	53                   	push   %ebx
f010028e:	ff 75 10             	pushl  0x10(%ebp)
f0100291:	e8 1e 37 00 00       	call   f01039b4 <vcprintf>
	cprintf("\n");
f0100296:	c7 04 24 c3 7c 10 f0 	movl   $0xf0107cc3,(%esp)
f010029d:	e8 38 37 00 00       	call   f01039da <cprintf>
	va_end(ap);
}
f01002a2:	83 c4 10             	add    $0x10,%esp
f01002a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01002a8:	c9                   	leave  
f01002a9:	c3                   	ret    

f01002aa <serial_proc_data>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01002aa:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01002af:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f01002b0:	a8 01                	test   $0x1,%al
f01002b2:	74 0a                	je     f01002be <serial_proc_data+0x14>
f01002b4:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01002b9:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f01002ba:	0f b6 c0             	movzbl %al,%eax
f01002bd:	c3                   	ret    
		return -1;
f01002be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f01002c3:	c3                   	ret    

f01002c4 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f01002c4:	55                   	push   %ebp
f01002c5:	89 e5                	mov    %esp,%ebp
f01002c7:	53                   	push   %ebx
f01002c8:	83 ec 04             	sub    $0x4,%esp
f01002cb:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f01002cd:	ff d3                	call   *%ebx
f01002cf:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002d2:	74 29                	je     f01002fd <cons_intr+0x39>
		if (c == 0)
f01002d4:	85 c0                	test   %eax,%eax
f01002d6:	74 f5                	je     f01002cd <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01002d8:	8b 0d 24 32 53 f0    	mov    0xf0533224,%ecx
f01002de:	8d 51 01             	lea    0x1(%ecx),%edx
f01002e1:	88 81 20 30 53 f0    	mov    %al,-0xfaccfe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002e7:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01002ed:	b8 00 00 00 00       	mov    $0x0,%eax
f01002f2:	0f 44 d0             	cmove  %eax,%edx
f01002f5:	89 15 24 32 53 f0    	mov    %edx,0xf0533224
f01002fb:	eb d0                	jmp    f01002cd <cons_intr+0x9>
	}
}
f01002fd:	83 c4 04             	add    $0x4,%esp
f0100300:	5b                   	pop    %ebx
f0100301:	5d                   	pop    %ebp
f0100302:	c3                   	ret    

f0100303 <kbd_proc_data>:
{
f0100303:	55                   	push   %ebp
f0100304:	89 e5                	mov    %esp,%ebp
f0100306:	53                   	push   %ebx
f0100307:	83 ec 04             	sub    $0x4,%esp
f010030a:	ba 64 00 00 00       	mov    $0x64,%edx
f010030f:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f0100310:	a8 01                	test   $0x1,%al
f0100312:	0f 84 f2 00 00 00    	je     f010040a <kbd_proc_data+0x107>
	if (stat & KBS_TERR)
f0100318:	a8 20                	test   $0x20,%al
f010031a:	0f 85 f1 00 00 00    	jne    f0100411 <kbd_proc_data+0x10e>
f0100320:	ba 60 00 00 00       	mov    $0x60,%edx
f0100325:	ec                   	in     (%dx),%al
f0100326:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100328:	3c e0                	cmp    $0xe0,%al
f010032a:	74 61                	je     f010038d <kbd_proc_data+0x8a>
	} else if (data & 0x80) {
f010032c:	84 c0                	test   %al,%al
f010032e:	78 70                	js     f01003a0 <kbd_proc_data+0x9d>
	} else if (shift & E0ESC) {
f0100330:	8b 0d 00 30 53 f0    	mov    0xf0533000,%ecx
f0100336:	f6 c1 40             	test   $0x40,%cl
f0100339:	74 0e                	je     f0100349 <kbd_proc_data+0x46>
		data |= 0x80;
f010033b:	83 c8 80             	or     $0xffffff80,%eax
f010033e:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100340:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100343:	89 0d 00 30 53 f0    	mov    %ecx,0xf0533000
	shift |= shiftcode[data];
f0100349:	0f b6 d2             	movzbl %dl,%edx
f010034c:	0f b6 82 40 6c 10 f0 	movzbl -0xfef93c0(%edx),%eax
f0100353:	0b 05 00 30 53 f0    	or     0xf0533000,%eax
	shift ^= togglecode[data];
f0100359:	0f b6 8a 40 6b 10 f0 	movzbl -0xfef94c0(%edx),%ecx
f0100360:	31 c8                	xor    %ecx,%eax
f0100362:	a3 00 30 53 f0       	mov    %eax,0xf0533000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100367:	89 c1                	mov    %eax,%ecx
f0100369:	83 e1 03             	and    $0x3,%ecx
f010036c:	8b 0c 8d 20 6b 10 f0 	mov    -0xfef94e0(,%ecx,4),%ecx
f0100373:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100377:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f010037a:	a8 08                	test   $0x8,%al
f010037c:	74 61                	je     f01003df <kbd_proc_data+0xdc>
		if ('a' <= c && c <= 'z')
f010037e:	89 da                	mov    %ebx,%edx
f0100380:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100383:	83 f9 19             	cmp    $0x19,%ecx
f0100386:	77 4b                	ja     f01003d3 <kbd_proc_data+0xd0>
			c += 'A' - 'a';
f0100388:	83 eb 20             	sub    $0x20,%ebx
f010038b:	eb 0c                	jmp    f0100399 <kbd_proc_data+0x96>
		shift |= E0ESC;
f010038d:	83 0d 00 30 53 f0 40 	orl    $0x40,0xf0533000
		return 0;
f0100394:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0100399:	89 d8                	mov    %ebx,%eax
f010039b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010039e:	c9                   	leave  
f010039f:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f01003a0:	8b 0d 00 30 53 f0    	mov    0xf0533000,%ecx
f01003a6:	89 cb                	mov    %ecx,%ebx
f01003a8:	83 e3 40             	and    $0x40,%ebx
f01003ab:	83 e0 7f             	and    $0x7f,%eax
f01003ae:	85 db                	test   %ebx,%ebx
f01003b0:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01003b3:	0f b6 d2             	movzbl %dl,%edx
f01003b6:	0f b6 82 40 6c 10 f0 	movzbl -0xfef93c0(%edx),%eax
f01003bd:	83 c8 40             	or     $0x40,%eax
f01003c0:	0f b6 c0             	movzbl %al,%eax
f01003c3:	f7 d0                	not    %eax
f01003c5:	21 c8                	and    %ecx,%eax
f01003c7:	a3 00 30 53 f0       	mov    %eax,0xf0533000
		return 0;
f01003cc:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003d1:	eb c6                	jmp    f0100399 <kbd_proc_data+0x96>
		else if ('A' <= c && c <= 'Z')
f01003d3:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003d6:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003d9:	83 fa 1a             	cmp    $0x1a,%edx
f01003dc:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01003df:	f7 d0                	not    %eax
f01003e1:	a8 06                	test   $0x6,%al
f01003e3:	75 b4                	jne    f0100399 <kbd_proc_data+0x96>
f01003e5:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01003eb:	75 ac                	jne    f0100399 <kbd_proc_data+0x96>
		cprintf("Rebooting!\n");
f01003ed:	83 ec 0c             	sub    $0xc,%esp
f01003f0:	68 ed 6a 10 f0       	push   $0xf0106aed
f01003f5:	e8 e0 35 00 00       	call   f01039da <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003fa:	b8 03 00 00 00       	mov    $0x3,%eax
f01003ff:	ba 92 00 00 00       	mov    $0x92,%edx
f0100404:	ee                   	out    %al,(%dx)
f0100405:	83 c4 10             	add    $0x10,%esp
f0100408:	eb 8f                	jmp    f0100399 <kbd_proc_data+0x96>
		return -1;
f010040a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f010040f:	eb 88                	jmp    f0100399 <kbd_proc_data+0x96>
		return -1;
f0100411:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100416:	eb 81                	jmp    f0100399 <kbd_proc_data+0x96>

f0100418 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100418:	55                   	push   %ebp
f0100419:	89 e5                	mov    %esp,%ebp
f010041b:	57                   	push   %edi
f010041c:	56                   	push   %esi
f010041d:	53                   	push   %ebx
f010041e:	83 ec 1c             	sub    $0x1c,%esp
f0100421:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f0100423:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100428:	bf fd 03 00 00       	mov    $0x3fd,%edi
f010042d:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100432:	89 fa                	mov    %edi,%edx
f0100434:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100435:	a8 20                	test   $0x20,%al
f0100437:	75 13                	jne    f010044c <cons_putc+0x34>
f0100439:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010043f:	7f 0b                	jg     f010044c <cons_putc+0x34>
f0100441:	89 da                	mov    %ebx,%edx
f0100443:	ec                   	in     (%dx),%al
f0100444:	ec                   	in     (%dx),%al
f0100445:	ec                   	in     (%dx),%al
f0100446:	ec                   	in     (%dx),%al
	     i++)
f0100447:	83 c6 01             	add    $0x1,%esi
f010044a:	eb e6                	jmp    f0100432 <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f010044c:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010044f:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100454:	89 c8                	mov    %ecx,%eax
f0100456:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100457:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010045c:	bf 79 03 00 00       	mov    $0x379,%edi
f0100461:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100466:	89 fa                	mov    %edi,%edx
f0100468:	ec                   	in     (%dx),%al
f0100469:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010046f:	7f 0f                	jg     f0100480 <cons_putc+0x68>
f0100471:	84 c0                	test   %al,%al
f0100473:	78 0b                	js     f0100480 <cons_putc+0x68>
f0100475:	89 da                	mov    %ebx,%edx
f0100477:	ec                   	in     (%dx),%al
f0100478:	ec                   	in     (%dx),%al
f0100479:	ec                   	in     (%dx),%al
f010047a:	ec                   	in     (%dx),%al
f010047b:	83 c6 01             	add    $0x1,%esi
f010047e:	eb e6                	jmp    f0100466 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100480:	ba 78 03 00 00       	mov    $0x378,%edx
f0100485:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100489:	ee                   	out    %al,(%dx)
f010048a:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010048f:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100494:	ee                   	out    %al,(%dx)
f0100495:	b8 08 00 00 00       	mov    $0x8,%eax
f010049a:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f010049b:	89 ca                	mov    %ecx,%edx
f010049d:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f01004a3:	89 c8                	mov    %ecx,%eax
f01004a5:	80 cc 07             	or     $0x7,%ah
f01004a8:	85 d2                	test   %edx,%edx
f01004aa:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f01004ad:	0f b6 c1             	movzbl %cl,%eax
f01004b0:	83 f8 09             	cmp    $0x9,%eax
f01004b3:	0f 84 b0 00 00 00    	je     f0100569 <cons_putc+0x151>
f01004b9:	7e 73                	jle    f010052e <cons_putc+0x116>
f01004bb:	83 f8 0a             	cmp    $0xa,%eax
f01004be:	0f 84 98 00 00 00    	je     f010055c <cons_putc+0x144>
f01004c4:	83 f8 0d             	cmp    $0xd,%eax
f01004c7:	0f 85 d3 00 00 00    	jne    f01005a0 <cons_putc+0x188>
		crt_pos -= (crt_pos % CRT_COLS);
f01004cd:	0f b7 05 28 32 53 f0 	movzwl 0xf0533228,%eax
f01004d4:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004da:	c1 e8 16             	shr    $0x16,%eax
f01004dd:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004e0:	c1 e0 04             	shl    $0x4,%eax
f01004e3:	66 a3 28 32 53 f0    	mov    %ax,0xf0533228
	if (crt_pos >= CRT_SIZE) {
f01004e9:	66 81 3d 28 32 53 f0 	cmpw   $0x7cf,0xf0533228
f01004f0:	cf 07 
f01004f2:	0f 87 cb 00 00 00    	ja     f01005c3 <cons_putc+0x1ab>
	outb(addr_6845, 14);
f01004f8:	8b 0d 30 32 53 f0    	mov    0xf0533230,%ecx
f01004fe:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100503:	89 ca                	mov    %ecx,%edx
f0100505:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100506:	0f b7 1d 28 32 53 f0 	movzwl 0xf0533228,%ebx
f010050d:	8d 71 01             	lea    0x1(%ecx),%esi
f0100510:	89 d8                	mov    %ebx,%eax
f0100512:	66 c1 e8 08          	shr    $0x8,%ax
f0100516:	89 f2                	mov    %esi,%edx
f0100518:	ee                   	out    %al,(%dx)
f0100519:	b8 0f 00 00 00       	mov    $0xf,%eax
f010051e:	89 ca                	mov    %ecx,%edx
f0100520:	ee                   	out    %al,(%dx)
f0100521:	89 d8                	mov    %ebx,%eax
f0100523:	89 f2                	mov    %esi,%edx
f0100525:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100526:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100529:	5b                   	pop    %ebx
f010052a:	5e                   	pop    %esi
f010052b:	5f                   	pop    %edi
f010052c:	5d                   	pop    %ebp
f010052d:	c3                   	ret    
	switch (c & 0xff) {
f010052e:	83 f8 08             	cmp    $0x8,%eax
f0100531:	75 6d                	jne    f01005a0 <cons_putc+0x188>
		if (crt_pos > 0) {
f0100533:	0f b7 05 28 32 53 f0 	movzwl 0xf0533228,%eax
f010053a:	66 85 c0             	test   %ax,%ax
f010053d:	74 b9                	je     f01004f8 <cons_putc+0xe0>
			crt_pos--;
f010053f:	83 e8 01             	sub    $0x1,%eax
f0100542:	66 a3 28 32 53 f0    	mov    %ax,0xf0533228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100548:	0f b7 c0             	movzwl %ax,%eax
f010054b:	b1 00                	mov    $0x0,%cl
f010054d:	83 c9 20             	or     $0x20,%ecx
f0100550:	8b 15 2c 32 53 f0    	mov    0xf053322c,%edx
f0100556:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f010055a:	eb 8d                	jmp    f01004e9 <cons_putc+0xd1>
		crt_pos += CRT_COLS;
f010055c:	66 83 05 28 32 53 f0 	addw   $0x50,0xf0533228
f0100563:	50 
f0100564:	e9 64 ff ff ff       	jmp    f01004cd <cons_putc+0xb5>
		cons_putc(' ');
f0100569:	b8 20 00 00 00       	mov    $0x20,%eax
f010056e:	e8 a5 fe ff ff       	call   f0100418 <cons_putc>
		cons_putc(' ');
f0100573:	b8 20 00 00 00       	mov    $0x20,%eax
f0100578:	e8 9b fe ff ff       	call   f0100418 <cons_putc>
		cons_putc(' ');
f010057d:	b8 20 00 00 00       	mov    $0x20,%eax
f0100582:	e8 91 fe ff ff       	call   f0100418 <cons_putc>
		cons_putc(' ');
f0100587:	b8 20 00 00 00       	mov    $0x20,%eax
f010058c:	e8 87 fe ff ff       	call   f0100418 <cons_putc>
		cons_putc(' ');
f0100591:	b8 20 00 00 00       	mov    $0x20,%eax
f0100596:	e8 7d fe ff ff       	call   f0100418 <cons_putc>
f010059b:	e9 49 ff ff ff       	jmp    f01004e9 <cons_putc+0xd1>
		crt_buf[crt_pos++] = c;		/* write the character */
f01005a0:	0f b7 05 28 32 53 f0 	movzwl 0xf0533228,%eax
f01005a7:	8d 50 01             	lea    0x1(%eax),%edx
f01005aa:	66 89 15 28 32 53 f0 	mov    %dx,0xf0533228
f01005b1:	0f b7 c0             	movzwl %ax,%eax
f01005b4:	8b 15 2c 32 53 f0    	mov    0xf053322c,%edx
f01005ba:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f01005be:	e9 26 ff ff ff       	jmp    f01004e9 <cons_putc+0xd1>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005c3:	a1 2c 32 53 f0       	mov    0xf053322c,%eax
f01005c8:	83 ec 04             	sub    $0x4,%esp
f01005cb:	68 00 0f 00 00       	push   $0xf00
f01005d0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005d6:	52                   	push   %edx
f01005d7:	50                   	push   %eax
f01005d8:	e8 ca 52 00 00       	call   f01058a7 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005dd:	8b 15 2c 32 53 f0    	mov    0xf053322c,%edx
f01005e3:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005e9:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005ef:	83 c4 10             	add    $0x10,%esp
f01005f2:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005f7:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005fa:	39 d0                	cmp    %edx,%eax
f01005fc:	75 f4                	jne    f01005f2 <cons_putc+0x1da>
		crt_pos -= CRT_COLS;
f01005fe:	66 83 2d 28 32 53 f0 	subw   $0x50,0xf0533228
f0100605:	50 
f0100606:	e9 ed fe ff ff       	jmp    f01004f8 <cons_putc+0xe0>

f010060b <serial_intr>:
	if (serial_exists)
f010060b:	80 3d 34 32 53 f0 00 	cmpb   $0x0,0xf0533234
f0100612:	75 01                	jne    f0100615 <serial_intr+0xa>
f0100614:	c3                   	ret    
{
f0100615:	55                   	push   %ebp
f0100616:	89 e5                	mov    %esp,%ebp
f0100618:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f010061b:	b8 aa 02 10 f0       	mov    $0xf01002aa,%eax
f0100620:	e8 9f fc ff ff       	call   f01002c4 <cons_intr>
}
f0100625:	c9                   	leave  
f0100626:	c3                   	ret    

f0100627 <kbd_intr>:
{
f0100627:	55                   	push   %ebp
f0100628:	89 e5                	mov    %esp,%ebp
f010062a:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f010062d:	b8 03 03 10 f0       	mov    $0xf0100303,%eax
f0100632:	e8 8d fc ff ff       	call   f01002c4 <cons_intr>
}
f0100637:	c9                   	leave  
f0100638:	c3                   	ret    

f0100639 <cons_getc>:
{
f0100639:	55                   	push   %ebp
f010063a:	89 e5                	mov    %esp,%ebp
f010063c:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f010063f:	e8 c7 ff ff ff       	call   f010060b <serial_intr>
	kbd_intr();
f0100644:	e8 de ff ff ff       	call   f0100627 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100649:	8b 15 20 32 53 f0    	mov    0xf0533220,%edx
	return 0;
f010064f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100654:	3b 15 24 32 53 f0    	cmp    0xf0533224,%edx
f010065a:	74 1e                	je     f010067a <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f010065c:	8d 4a 01             	lea    0x1(%edx),%ecx
f010065f:	0f b6 82 20 30 53 f0 	movzbl -0xfaccfe0(%edx),%eax
			cons.rpos = 0;
f0100666:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f010066c:	ba 00 00 00 00       	mov    $0x0,%edx
f0100671:	0f 44 ca             	cmove  %edx,%ecx
f0100674:	89 0d 20 32 53 f0    	mov    %ecx,0xf0533220
}
f010067a:	c9                   	leave  
f010067b:	c3                   	ret    

f010067c <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f010067c:	55                   	push   %ebp
f010067d:	89 e5                	mov    %esp,%ebp
f010067f:	57                   	push   %edi
f0100680:	56                   	push   %esi
f0100681:	53                   	push   %ebx
f0100682:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100685:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010068c:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100693:	5a a5 
	if (*cp != 0xA55A) {
f0100695:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010069c:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01006a0:	0f 84 de 00 00 00    	je     f0100784 <cons_init+0x108>
		addr_6845 = MONO_BASE;
f01006a6:	c7 05 30 32 53 f0 b4 	movl   $0x3b4,0xf0533230
f01006ad:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006b0:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f01006b5:	8b 3d 30 32 53 f0    	mov    0xf0533230,%edi
f01006bb:	b8 0e 00 00 00       	mov    $0xe,%eax
f01006c0:	89 fa                	mov    %edi,%edx
f01006c2:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01006c3:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006c6:	89 ca                	mov    %ecx,%edx
f01006c8:	ec                   	in     (%dx),%al
f01006c9:	0f b6 c0             	movzbl %al,%eax
f01006cc:	c1 e0 08             	shl    $0x8,%eax
f01006cf:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006d1:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006d6:	89 fa                	mov    %edi,%edx
f01006d8:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006d9:	89 ca                	mov    %ecx,%edx
f01006db:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006dc:	89 35 2c 32 53 f0    	mov    %esi,0xf053322c
	pos |= inb(addr_6845 + 1);
f01006e2:	0f b6 c0             	movzbl %al,%eax
f01006e5:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006e7:	66 a3 28 32 53 f0    	mov    %ax,0xf0533228
	kbd_intr();
f01006ed:	e8 35 ff ff ff       	call   f0100627 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006f2:	83 ec 0c             	sub    $0xc,%esp
f01006f5:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f01006fc:	25 fd ff 00 00       	and    $0xfffd,%eax
f0100701:	50                   	push   %eax
f0100702:	e8 64 31 00 00       	call   f010386b <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100707:	bb 00 00 00 00       	mov    $0x0,%ebx
f010070c:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f0100711:	89 d8                	mov    %ebx,%eax
f0100713:	89 ca                	mov    %ecx,%edx
f0100715:	ee                   	out    %al,(%dx)
f0100716:	bf fb 03 00 00       	mov    $0x3fb,%edi
f010071b:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100720:	89 fa                	mov    %edi,%edx
f0100722:	ee                   	out    %al,(%dx)
f0100723:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100728:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010072d:	ee                   	out    %al,(%dx)
f010072e:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100733:	89 d8                	mov    %ebx,%eax
f0100735:	89 f2                	mov    %esi,%edx
f0100737:	ee                   	out    %al,(%dx)
f0100738:	b8 03 00 00 00       	mov    $0x3,%eax
f010073d:	89 fa                	mov    %edi,%edx
f010073f:	ee                   	out    %al,(%dx)
f0100740:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100745:	89 d8                	mov    %ebx,%eax
f0100747:	ee                   	out    %al,(%dx)
f0100748:	b8 01 00 00 00       	mov    $0x1,%eax
f010074d:	89 f2                	mov    %esi,%edx
f010074f:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100750:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100755:	ec                   	in     (%dx),%al
f0100756:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100758:	83 c4 10             	add    $0x10,%esp
f010075b:	3c ff                	cmp    $0xff,%al
f010075d:	0f 95 05 34 32 53 f0 	setne  0xf0533234
f0100764:	89 ca                	mov    %ecx,%edx
f0100766:	ec                   	in     (%dx),%al
f0100767:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010076c:	ec                   	in     (%dx),%al
	if (serial_exists)
f010076d:	80 fb ff             	cmp    $0xff,%bl
f0100770:	75 2d                	jne    f010079f <cons_init+0x123>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f0100772:	83 ec 0c             	sub    $0xc,%esp
f0100775:	68 f9 6a 10 f0       	push   $0xf0106af9
f010077a:	e8 5b 32 00 00       	call   f01039da <cprintf>
f010077f:	83 c4 10             	add    $0x10,%esp
}
f0100782:	eb 3c                	jmp    f01007c0 <cons_init+0x144>
		*cp = was;
f0100784:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010078b:	c7 05 30 32 53 f0 d4 	movl   $0x3d4,0xf0533230
f0100792:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100795:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f010079a:	e9 16 ff ff ff       	jmp    f01006b5 <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f010079f:	83 ec 0c             	sub    $0xc,%esp
f01007a2:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f01007a9:	25 ef ff 00 00       	and    $0xffef,%eax
f01007ae:	50                   	push   %eax
f01007af:	e8 b7 30 00 00       	call   f010386b <irq_setmask_8259A>
	if (!serial_exists)
f01007b4:	83 c4 10             	add    $0x10,%esp
f01007b7:	80 3d 34 32 53 f0 00 	cmpb   $0x0,0xf0533234
f01007be:	74 b2                	je     f0100772 <cons_init+0xf6>
}
f01007c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007c3:	5b                   	pop    %ebx
f01007c4:	5e                   	pop    %esi
f01007c5:	5f                   	pop    %edi
f01007c6:	5d                   	pop    %ebp
f01007c7:	c3                   	ret    

f01007c8 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007c8:	55                   	push   %ebp
f01007c9:	89 e5                	mov    %esp,%ebp
f01007cb:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007ce:	8b 45 08             	mov    0x8(%ebp),%eax
f01007d1:	e8 42 fc ff ff       	call   f0100418 <cons_putc>
}
f01007d6:	c9                   	leave  
f01007d7:	c3                   	ret    

f01007d8 <getchar>:

int
getchar(void)
{
f01007d8:	55                   	push   %ebp
f01007d9:	89 e5                	mov    %esp,%ebp
f01007db:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007de:	e8 56 fe ff ff       	call   f0100639 <cons_getc>
f01007e3:	85 c0                	test   %eax,%eax
f01007e5:	74 f7                	je     f01007de <getchar+0x6>
		/* do nothing */;
	return c;
}
f01007e7:	c9                   	leave  
f01007e8:	c3                   	ret    

f01007e9 <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f01007e9:	b8 01 00 00 00       	mov    $0x1,%eax
f01007ee:	c3                   	ret    

f01007ef <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007ef:	55                   	push   %ebp
f01007f0:	89 e5                	mov    %esp,%ebp
f01007f2:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007f5:	68 40 6d 10 f0       	push   $0xf0106d40
f01007fa:	68 5e 6d 10 f0       	push   $0xf0106d5e
f01007ff:	68 63 6d 10 f0       	push   $0xf0106d63
f0100804:	e8 d1 31 00 00       	call   f01039da <cprintf>
f0100809:	83 c4 0c             	add    $0xc,%esp
f010080c:	68 00 6e 10 f0       	push   $0xf0106e00
f0100811:	68 6c 6d 10 f0       	push   $0xf0106d6c
f0100816:	68 63 6d 10 f0       	push   $0xf0106d63
f010081b:	e8 ba 31 00 00       	call   f01039da <cprintf>
f0100820:	83 c4 0c             	add    $0xc,%esp
f0100823:	68 28 6e 10 f0       	push   $0xf0106e28
f0100828:	68 75 6d 10 f0       	push   $0xf0106d75
f010082d:	68 63 6d 10 f0       	push   $0xf0106d63
f0100832:	e8 a3 31 00 00       	call   f01039da <cprintf>
	return 0;
}
f0100837:	b8 00 00 00 00       	mov    $0x0,%eax
f010083c:	c9                   	leave  
f010083d:	c3                   	ret    

f010083e <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f010083e:	55                   	push   %ebp
f010083f:	89 e5                	mov    %esp,%ebp
f0100841:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100844:	68 7f 6d 10 f0       	push   $0xf0106d7f
f0100849:	e8 8c 31 00 00       	call   f01039da <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f010084e:	83 c4 08             	add    $0x8,%esp
f0100851:	68 0c 00 10 00       	push   $0x10000c
f0100856:	68 4c 6e 10 f0       	push   $0xf0106e4c
f010085b:	e8 7a 31 00 00       	call   f01039da <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100860:	83 c4 0c             	add    $0xc,%esp
f0100863:	68 0c 00 10 00       	push   $0x10000c
f0100868:	68 0c 00 10 f0       	push   $0xf010000c
f010086d:	68 74 6e 10 f0       	push   $0xf0106e74
f0100872:	e8 63 31 00 00       	call   f01039da <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100877:	83 c4 0c             	add    $0xc,%esp
f010087a:	68 1f 6a 10 00       	push   $0x106a1f
f010087f:	68 1f 6a 10 f0       	push   $0xf0106a1f
f0100884:	68 98 6e 10 f0       	push   $0xf0106e98
f0100889:	e8 4c 31 00 00       	call   f01039da <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010088e:	83 c4 0c             	add    $0xc,%esp
f0100891:	68 00 30 53 00       	push   $0x533000
f0100896:	68 00 30 53 f0       	push   $0xf0533000
f010089b:	68 bc 6e 10 f0       	push   $0xf0106ebc
f01008a0:	e8 35 31 00 00       	call   f01039da <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01008a5:	83 c4 0c             	add    $0xc,%esp
f01008a8:	68 08 50 57 00       	push   $0x575008
f01008ad:	68 08 50 57 f0       	push   $0xf0575008
f01008b2:	68 e0 6e 10 f0       	push   $0xf0106ee0
f01008b7:	e8 1e 31 00 00       	call   f01039da <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008bc:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f01008bf:	b8 08 50 57 f0       	mov    $0xf0575008,%eax
f01008c4:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008c9:	c1 f8 0a             	sar    $0xa,%eax
f01008cc:	50                   	push   %eax
f01008cd:	68 04 6f 10 f0       	push   $0xf0106f04
f01008d2:	e8 03 31 00 00       	call   f01039da <cprintf>
	return 0;
}
f01008d7:	b8 00 00 00 00       	mov    $0x0,%eax
f01008dc:	c9                   	leave  
f01008dd:	c3                   	ret    

f01008de <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01008de:	55                   	push   %ebp
f01008df:	89 e5                	mov    %esp,%ebp
f01008e1:	56                   	push   %esi
f01008e2:	53                   	push   %ebx
f01008e3:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01008e6:	89 eb                	mov    %ebp,%ebx
	// Your code here.
  uint32_t *ebp_ptr =  (uint32_t*)read_ebp();
  cprintf("Stack backtrace:\n");
f01008e8:	68 98 6d 10 f0       	push   $0xf0106d98
f01008ed:	e8 e8 30 00 00       	call   f01039da <cprintf>
  struct Eipdebuginfo info;
  while (ebp_ptr) {
f01008f2:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp %x eip %x args %08x %08x %08x %08x %08x\n",
            ebp_ptr, ebp_ptr[1], ebp_ptr[2], ebp_ptr[3], ebp_ptr[4], ebp_ptr[5]);
    if (debuginfo_eip((uintptr_t)ebp_ptr[1], &info) == 0) {
f01008f5:	8d 75 e0             	lea    -0x20(%ebp),%esi
  while (ebp_ptr) {
f01008f8:	eb 12                	jmp    f010090c <mon_backtrace+0x2e>
      cprintf("       %s:%d:", info.eip_file, info.eip_line);
      cprintf(" %.*s", info.eip_fn_namelen, info.eip_fn_name);
      cprintf("+%d\n", ebp_ptr[1] - info.eip_fn_addr);
    } else {
      cprintf("mon_backtrace: calling debuginfo_eip filled.\n");
f01008fa:	83 ec 0c             	sub    $0xc,%esp
f01008fd:	68 60 6f 10 f0       	push   $0xf0106f60
f0100902:	e8 d3 30 00 00       	call   f01039da <cprintf>
f0100907:	83 c4 10             	add    $0x10,%esp
    }
    ebp_ptr = (uint32_t*)ebp_ptr[0];
f010090a:	8b 1b                	mov    (%ebx),%ebx
  while (ebp_ptr) {
f010090c:	85 db                	test   %ebx,%ebx
f010090e:	74 6f                	je     f010097f <mon_backtrace+0xa1>
    cprintf("  ebp %x eip %x args %08x %08x %08x %08x %08x\n",
f0100910:	83 ec 04             	sub    $0x4,%esp
f0100913:	ff 73 14             	pushl  0x14(%ebx)
f0100916:	ff 73 10             	pushl  0x10(%ebx)
f0100919:	ff 73 0c             	pushl  0xc(%ebx)
f010091c:	ff 73 08             	pushl  0x8(%ebx)
f010091f:	ff 73 04             	pushl  0x4(%ebx)
f0100922:	53                   	push   %ebx
f0100923:	68 30 6f 10 f0       	push   $0xf0106f30
f0100928:	e8 ad 30 00 00       	call   f01039da <cprintf>
    if (debuginfo_eip((uintptr_t)ebp_ptr[1], &info) == 0) {
f010092d:	83 c4 18             	add    $0x18,%esp
f0100930:	56                   	push   %esi
f0100931:	ff 73 04             	pushl  0x4(%ebx)
f0100934:	e8 3a 44 00 00       	call   f0104d73 <debuginfo_eip>
f0100939:	83 c4 10             	add    $0x10,%esp
f010093c:	85 c0                	test   %eax,%eax
f010093e:	75 ba                	jne    f01008fa <mon_backtrace+0x1c>
      cprintf("       %s:%d:", info.eip_file, info.eip_line);
f0100940:	83 ec 04             	sub    $0x4,%esp
f0100943:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100946:	ff 75 e0             	pushl  -0x20(%ebp)
f0100949:	68 aa 6d 10 f0       	push   $0xf0106daa
f010094e:	e8 87 30 00 00       	call   f01039da <cprintf>
      cprintf(" %.*s", info.eip_fn_namelen, info.eip_fn_name);
f0100953:	83 c4 0c             	add    $0xc,%esp
f0100956:	ff 75 e8             	pushl  -0x18(%ebp)
f0100959:	ff 75 ec             	pushl  -0x14(%ebp)
f010095c:	68 b8 6d 10 f0       	push   $0xf0106db8
f0100961:	e8 74 30 00 00       	call   f01039da <cprintf>
      cprintf("+%d\n", ebp_ptr[1] - info.eip_fn_addr);
f0100966:	83 c4 08             	add    $0x8,%esp
f0100969:	8b 43 04             	mov    0x4(%ebx),%eax
f010096c:	2b 45 f0             	sub    -0x10(%ebp),%eax
f010096f:	50                   	push   %eax
f0100970:	68 be 6d 10 f0       	push   $0xf0106dbe
f0100975:	e8 60 30 00 00       	call   f01039da <cprintf>
f010097a:	83 c4 10             	add    $0x10,%esp
f010097d:	eb 8b                	jmp    f010090a <mon_backtrace+0x2c>
  }
	return 0;
}
f010097f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100984:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100987:	5b                   	pop    %ebx
f0100988:	5e                   	pop    %esi
f0100989:	5d                   	pop    %ebp
f010098a:	c3                   	ret    

f010098b <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f010098b:	55                   	push   %ebp
f010098c:	89 e5                	mov    %esp,%ebp
f010098e:	57                   	push   %edi
f010098f:	56                   	push   %esi
f0100990:	53                   	push   %ebx
f0100991:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100994:	68 90 6f 10 f0       	push   $0xf0106f90
f0100999:	e8 3c 30 00 00       	call   f01039da <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f010099e:	c7 04 24 b4 6f 10 f0 	movl   $0xf0106fb4,(%esp)
f01009a5:	e8 30 30 00 00       	call   f01039da <cprintf>

	if (tf != NULL)
f01009aa:	83 c4 10             	add    $0x10,%esp
f01009ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f01009b1:	0f 84 d9 00 00 00    	je     f0100a90 <monitor+0x105>
		print_trapframe(tf);
f01009b7:	83 ec 0c             	sub    $0xc,%esp
f01009ba:	ff 75 08             	pushl  0x8(%ebp)
f01009bd:	e8 f3 35 00 00       	call   f0103fb5 <print_trapframe>
f01009c2:	83 c4 10             	add    $0x10,%esp
f01009c5:	e9 c6 00 00 00       	jmp    f0100a90 <monitor+0x105>
		while (*buf && strchr(WHITESPACE, *buf))
f01009ca:	83 ec 08             	sub    $0x8,%esp
f01009cd:	0f be c0             	movsbl %al,%eax
f01009d0:	50                   	push   %eax
f01009d1:	68 c7 6d 10 f0       	push   $0xf0106dc7
f01009d6:	e8 47 4e 00 00       	call   f0105822 <strchr>
f01009db:	83 c4 10             	add    $0x10,%esp
f01009de:	85 c0                	test   %eax,%eax
f01009e0:	74 63                	je     f0100a45 <monitor+0xba>
			*buf++ = 0;
f01009e2:	c6 03 00             	movb   $0x0,(%ebx)
f01009e5:	89 f7                	mov    %esi,%edi
f01009e7:	8d 5b 01             	lea    0x1(%ebx),%ebx
f01009ea:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f01009ec:	0f b6 03             	movzbl (%ebx),%eax
f01009ef:	84 c0                	test   %al,%al
f01009f1:	75 d7                	jne    f01009ca <monitor+0x3f>
	argv[argc] = 0;
f01009f3:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01009fa:	00 
	if (argc == 0)
f01009fb:	85 f6                	test   %esi,%esi
f01009fd:	0f 84 8d 00 00 00    	je     f0100a90 <monitor+0x105>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a03:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100a08:	83 ec 08             	sub    $0x8,%esp
f0100a0b:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a0e:	ff 34 85 e0 6f 10 f0 	pushl  -0xfef9020(,%eax,4)
f0100a15:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a18:	e8 a7 4d 00 00       	call   f01057c4 <strcmp>
f0100a1d:	83 c4 10             	add    $0x10,%esp
f0100a20:	85 c0                	test   %eax,%eax
f0100a22:	0f 84 8f 00 00 00    	je     f0100ab7 <monitor+0x12c>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a28:	83 c3 01             	add    $0x1,%ebx
f0100a2b:	83 fb 03             	cmp    $0x3,%ebx
f0100a2e:	75 d8                	jne    f0100a08 <monitor+0x7d>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100a30:	83 ec 08             	sub    $0x8,%esp
f0100a33:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a36:	68 e9 6d 10 f0       	push   $0xf0106de9
f0100a3b:	e8 9a 2f 00 00       	call   f01039da <cprintf>
f0100a40:	83 c4 10             	add    $0x10,%esp
f0100a43:	eb 4b                	jmp    f0100a90 <monitor+0x105>
		if (*buf == 0)
f0100a45:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a48:	74 a9                	je     f01009f3 <monitor+0x68>
		if (argc == MAXARGS-1) {
f0100a4a:	83 fe 0f             	cmp    $0xf,%esi
f0100a4d:	74 2f                	je     f0100a7e <monitor+0xf3>
		argv[argc++] = buf;
f0100a4f:	8d 7e 01             	lea    0x1(%esi),%edi
f0100a52:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a56:	0f b6 03             	movzbl (%ebx),%eax
f0100a59:	84 c0                	test   %al,%al
f0100a5b:	74 8d                	je     f01009ea <monitor+0x5f>
f0100a5d:	83 ec 08             	sub    $0x8,%esp
f0100a60:	0f be c0             	movsbl %al,%eax
f0100a63:	50                   	push   %eax
f0100a64:	68 c7 6d 10 f0       	push   $0xf0106dc7
f0100a69:	e8 b4 4d 00 00       	call   f0105822 <strchr>
f0100a6e:	83 c4 10             	add    $0x10,%esp
f0100a71:	85 c0                	test   %eax,%eax
f0100a73:	0f 85 71 ff ff ff    	jne    f01009ea <monitor+0x5f>
			buf++;
f0100a79:	83 c3 01             	add    $0x1,%ebx
f0100a7c:	eb d8                	jmp    f0100a56 <monitor+0xcb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a7e:	83 ec 08             	sub    $0x8,%esp
f0100a81:	6a 10                	push   $0x10
f0100a83:	68 cc 6d 10 f0       	push   $0xf0106dcc
f0100a88:	e8 4d 2f 00 00       	call   f01039da <cprintf>
f0100a8d:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100a90:	83 ec 0c             	sub    $0xc,%esp
f0100a93:	68 c3 6d 10 f0       	push   $0xf0106dc3
f0100a98:	e8 55 4b 00 00       	call   f01055f2 <readline>
f0100a9d:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100a9f:	83 c4 10             	add    $0x10,%esp
f0100aa2:	85 c0                	test   %eax,%eax
f0100aa4:	74 ea                	je     f0100a90 <monitor+0x105>
	argv[argc] = 0;
f0100aa6:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100aad:	be 00 00 00 00       	mov    $0x0,%esi
f0100ab2:	e9 35 ff ff ff       	jmp    f01009ec <monitor+0x61>
			return commands[i].func(argc, argv, tf);
f0100ab7:	83 ec 04             	sub    $0x4,%esp
f0100aba:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100abd:	ff 75 08             	pushl  0x8(%ebp)
f0100ac0:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100ac3:	52                   	push   %edx
f0100ac4:	56                   	push   %esi
f0100ac5:	ff 14 85 e8 6f 10 f0 	call   *-0xfef9018(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100acc:	83 c4 10             	add    $0x10,%esp
f0100acf:	85 c0                	test   %eax,%eax
f0100ad1:	79 bd                	jns    f0100a90 <monitor+0x105>
				break;
	}
}
f0100ad3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100ad6:	5b                   	pop    %ebx
f0100ad7:	5e                   	pop    %esi
f0100ad8:	5f                   	pop    %edi
f0100ad9:	5d                   	pop    %ebp
f0100ada:	c3                   	ret    

f0100adb <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100adb:	55                   	push   %ebp
f0100adc:	89 e5                	mov    %esp,%ebp
f0100ade:	56                   	push   %esi
f0100adf:	53                   	push   %ebx
f0100ae0:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100ae2:	83 ec 0c             	sub    $0xc,%esp
f0100ae5:	50                   	push   %eax
f0100ae6:	e8 52 2d 00 00       	call   f010383d <mc146818_read>
f0100aeb:	89 c3                	mov    %eax,%ebx
f0100aed:	83 c6 01             	add    $0x1,%esi
f0100af0:	89 34 24             	mov    %esi,(%esp)
f0100af3:	e8 45 2d 00 00       	call   f010383d <mc146818_read>
f0100af8:	c1 e0 08             	shl    $0x8,%eax
f0100afb:	09 d8                	or     %ebx,%eax
}
f0100afd:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100b00:	5b                   	pop    %ebx
f0100b01:	5e                   	pop    %esi
f0100b02:	5d                   	pop    %ebp
f0100b03:	c3                   	ret    

f0100b04 <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100b04:	89 d1                	mov    %edx,%ecx
f0100b06:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100b09:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100b0c:	a8 01                	test   $0x1,%al
f0100b0e:	74 52                	je     f0100b62 <check_va2pa+0x5e>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100b10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100b15:	89 c1                	mov    %eax,%ecx
f0100b17:	c1 e9 0c             	shr    $0xc,%ecx
f0100b1a:	3b 0d a0 3e 53 f0    	cmp    0xf0533ea0,%ecx
f0100b20:	73 25                	jae    f0100b47 <check_va2pa+0x43>
	if (!(p[PTX(va)] & PTE_P))
f0100b22:	c1 ea 0c             	shr    $0xc,%edx
f0100b25:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100b2b:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100b32:	89 c2                	mov    %eax,%edx
f0100b34:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100b37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b3c:	85 d2                	test   %edx,%edx
f0100b3e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100b43:	0f 44 c2             	cmove  %edx,%eax
f0100b46:	c3                   	ret    
{
f0100b47:	55                   	push   %ebp
f0100b48:	89 e5                	mov    %esp,%ebp
f0100b4a:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100b4d:	50                   	push   %eax
f0100b4e:	68 44 6a 10 f0       	push   $0xf0106a44
f0100b53:	68 94 03 00 00       	push   $0x394
f0100b58:	68 6d 79 10 f0       	push   $0xf010796d
f0100b5d:	e8 de f4 ff ff       	call   f0100040 <_panic>
		return ~0;
f0100b62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100b67:	c3                   	ret    

f0100b68 <boot_alloc>:
{
f0100b68:	55                   	push   %ebp
f0100b69:	89 e5                	mov    %esp,%ebp
f0100b6b:	53                   	push   %ebx
f0100b6c:	83 ec 04             	sub    $0x4,%esp
f0100b6f:	89 c2                	mov    %eax,%edx
	if (!nextfree) {
f0100b71:	83 3d 38 32 53 f0 00 	cmpl   $0x0,0xf0533238
f0100b78:	74 39                	je     f0100bb3 <boot_alloc+0x4b>
  char *res = nextfree;
f0100b7a:	a1 38 32 53 f0       	mov    0xf0533238,%eax
  if (PGSIZE * npages <= PADDR(nextfree) + n)
f0100b7f:	8b 0d a0 3e 53 f0    	mov    0xf0533ea0,%ecx
f0100b85:	c1 e1 0c             	shl    $0xc,%ecx
	if ((uint32_t)kva < KERNBASE)
f0100b88:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100b8d:	76 35                	jbe    f0100bc4 <boot_alloc+0x5c>
f0100b8f:	8d 9c 10 00 00 00 10 	lea    0x10000000(%eax,%edx,1),%ebx
f0100b96:	39 d9                	cmp    %ebx,%ecx
f0100b98:	76 3c                	jbe    f0100bd6 <boot_alloc+0x6e>
	nextfree += ROUNDUP(n , PGSIZE);
f0100b9a:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0100ba0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100ba6:	01 c2                	add    %eax,%edx
f0100ba8:	89 15 38 32 53 f0    	mov    %edx,0xf0533238
}
f0100bae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100bb1:	c9                   	leave  
f0100bb2:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100bb3:	b8 07 60 57 f0       	mov    $0xf0576007,%eax
f0100bb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100bbd:	a3 38 32 53 f0       	mov    %eax,0xf0533238
f0100bc2:	eb b6                	jmp    f0100b7a <boot_alloc+0x12>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100bc4:	50                   	push   %eax
f0100bc5:	68 68 6a 10 f0       	push   $0xf0106a68
f0100bca:	6a 70                	push   $0x70
f0100bcc:	68 6d 79 10 f0       	push   $0xf010796d
f0100bd1:	e8 6a f4 ff ff       	call   f0100040 <_panic>
    panic("boot_allc: out of memory!\n");
f0100bd6:	83 ec 04             	sub    $0x4,%esp
f0100bd9:	68 79 79 10 f0       	push   $0xf0107979
f0100bde:	6a 71                	push   $0x71
f0100be0:	68 6d 79 10 f0       	push   $0xf010796d
f0100be5:	e8 56 f4 ff ff       	call   f0100040 <_panic>

f0100bea <check_page_free_list>:
{
f0100bea:	55                   	push   %ebp
f0100beb:	89 e5                	mov    %esp,%ebp
f0100bed:	57                   	push   %edi
f0100bee:	56                   	push   %esi
f0100bef:	53                   	push   %ebx
f0100bf0:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100bf3:	84 c0                	test   %al,%al
f0100bf5:	0f 85 77 02 00 00    	jne    f0100e72 <check_page_free_list+0x288>
	if (!page_free_list)
f0100bfb:	83 3d 40 32 53 f0 00 	cmpl   $0x0,0xf0533240
f0100c02:	74 0a                	je     f0100c0e <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100c04:	be 00 04 00 00       	mov    $0x400,%esi
f0100c09:	e9 bf 02 00 00       	jmp    f0100ecd <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100c0e:	83 ec 04             	sub    $0x4,%esp
f0100c11:	68 04 70 10 f0       	push   $0xf0107004
f0100c16:	68 c7 02 00 00       	push   $0x2c7
f0100c1b:	68 6d 79 10 f0       	push   $0xf010796d
f0100c20:	e8 1b f4 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100c25:	50                   	push   %eax
f0100c26:	68 44 6a 10 f0       	push   $0xf0106a44
f0100c2b:	6a 58                	push   $0x58
f0100c2d:	68 94 79 10 f0       	push   $0xf0107994
f0100c32:	e8 09 f4 ff ff       	call   f0100040 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100c37:	8b 1b                	mov    (%ebx),%ebx
f0100c39:	85 db                	test   %ebx,%ebx
f0100c3b:	74 41                	je     f0100c7e <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100c3d:	89 d8                	mov    %ebx,%eax
f0100c3f:	2b 05 a8 3e 53 f0    	sub    0xf0533ea8,%eax
f0100c45:	c1 f8 03             	sar    $0x3,%eax
f0100c48:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100c4b:	89 c2                	mov    %eax,%edx
f0100c4d:	c1 ea 16             	shr    $0x16,%edx
f0100c50:	39 f2                	cmp    %esi,%edx
f0100c52:	73 e3                	jae    f0100c37 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100c54:	89 c2                	mov    %eax,%edx
f0100c56:	c1 ea 0c             	shr    $0xc,%edx
f0100c59:	3b 15 a0 3e 53 f0    	cmp    0xf0533ea0,%edx
f0100c5f:	73 c4                	jae    f0100c25 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100c61:	83 ec 04             	sub    $0x4,%esp
f0100c64:	68 80 00 00 00       	push   $0x80
f0100c69:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100c6e:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100c73:	50                   	push   %eax
f0100c74:	e8 e6 4b 00 00       	call   f010585f <memset>
f0100c79:	83 c4 10             	add    $0x10,%esp
f0100c7c:	eb b9                	jmp    f0100c37 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100c7e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c83:	e8 e0 fe ff ff       	call   f0100b68 <boot_alloc>
f0100c88:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c8b:	8b 15 40 32 53 f0    	mov    0xf0533240,%edx
		assert(pp >= pages);
f0100c91:	8b 0d a8 3e 53 f0    	mov    0xf0533ea8,%ecx
		assert(pp < pages + npages);
f0100c97:	a1 a0 3e 53 f0       	mov    0xf0533ea0,%eax
f0100c9c:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100c9f:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100ca2:	bf 00 00 00 00       	mov    $0x0,%edi
f0100ca7:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100caa:	e9 f9 00 00 00       	jmp    f0100da8 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100caf:	68 a2 79 10 f0       	push   $0xf01079a2
f0100cb4:	68 ae 79 10 f0       	push   $0xf01079ae
f0100cb9:	68 e1 02 00 00       	push   $0x2e1
f0100cbe:	68 6d 79 10 f0       	push   $0xf010796d
f0100cc3:	e8 78 f3 ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0100cc8:	68 c3 79 10 f0       	push   $0xf01079c3
f0100ccd:	68 ae 79 10 f0       	push   $0xf01079ae
f0100cd2:	68 e2 02 00 00       	push   $0x2e2
f0100cd7:	68 6d 79 10 f0       	push   $0xf010796d
f0100cdc:	e8 5f f3 ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100ce1:	68 28 70 10 f0       	push   $0xf0107028
f0100ce6:	68 ae 79 10 f0       	push   $0xf01079ae
f0100ceb:	68 e3 02 00 00       	push   $0x2e3
f0100cf0:	68 6d 79 10 f0       	push   $0xf010796d
f0100cf5:	e8 46 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != 0);
f0100cfa:	68 d7 79 10 f0       	push   $0xf01079d7
f0100cff:	68 ae 79 10 f0       	push   $0xf01079ae
f0100d04:	68 e6 02 00 00       	push   $0x2e6
f0100d09:	68 6d 79 10 f0       	push   $0xf010796d
f0100d0e:	e8 2d f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100d13:	68 e8 79 10 f0       	push   $0xf01079e8
f0100d18:	68 ae 79 10 f0       	push   $0xf01079ae
f0100d1d:	68 e7 02 00 00       	push   $0x2e7
f0100d22:	68 6d 79 10 f0       	push   $0xf010796d
f0100d27:	e8 14 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100d2c:	68 5c 70 10 f0       	push   $0xf010705c
f0100d31:	68 ae 79 10 f0       	push   $0xf01079ae
f0100d36:	68 e8 02 00 00       	push   $0x2e8
f0100d3b:	68 6d 79 10 f0       	push   $0xf010796d
f0100d40:	e8 fb f2 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100d45:	68 01 7a 10 f0       	push   $0xf0107a01
f0100d4a:	68 ae 79 10 f0       	push   $0xf01079ae
f0100d4f:	68 e9 02 00 00       	push   $0x2e9
f0100d54:	68 6d 79 10 f0       	push   $0xf010796d
f0100d59:	e8 e2 f2 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0100d5e:	89 c3                	mov    %eax,%ebx
f0100d60:	c1 eb 0c             	shr    $0xc,%ebx
f0100d63:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0100d66:	76 0f                	jbe    f0100d77 <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f0100d68:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d6d:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0100d70:	77 17                	ja     f0100d89 <check_page_free_list+0x19f>
			++nfree_extmem;
f0100d72:	83 c7 01             	add    $0x1,%edi
f0100d75:	eb 2f                	jmp    f0100da6 <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100d77:	50                   	push   %eax
f0100d78:	68 44 6a 10 f0       	push   $0xf0106a44
f0100d7d:	6a 58                	push   $0x58
f0100d7f:	68 94 79 10 f0       	push   $0xf0107994
f0100d84:	e8 b7 f2 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d89:	68 80 70 10 f0       	push   $0xf0107080
f0100d8e:	68 ae 79 10 f0       	push   $0xf01079ae
f0100d93:	68 ea 02 00 00       	push   $0x2ea
f0100d98:	68 6d 79 10 f0       	push   $0xf010796d
f0100d9d:	e8 9e f2 ff ff       	call   f0100040 <_panic>
			++nfree_basemem;
f0100da2:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100da6:	8b 12                	mov    (%edx),%edx
f0100da8:	85 d2                	test   %edx,%edx
f0100daa:	74 74                	je     f0100e20 <check_page_free_list+0x236>
		assert(pp >= pages);
f0100dac:	39 d1                	cmp    %edx,%ecx
f0100dae:	0f 87 fb fe ff ff    	ja     f0100caf <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f0100db4:	39 d6                	cmp    %edx,%esi
f0100db6:	0f 86 0c ff ff ff    	jbe    f0100cc8 <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100dbc:	89 d0                	mov    %edx,%eax
f0100dbe:	29 c8                	sub    %ecx,%eax
f0100dc0:	a8 07                	test   $0x7,%al
f0100dc2:	0f 85 19 ff ff ff    	jne    f0100ce1 <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f0100dc8:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0100dcb:	c1 e0 0c             	shl    $0xc,%eax
f0100dce:	0f 84 26 ff ff ff    	je     f0100cfa <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f0100dd4:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100dd9:	0f 84 34 ff ff ff    	je     f0100d13 <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100ddf:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100de4:	0f 84 42 ff ff ff    	je     f0100d2c <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100dea:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100def:	0f 84 50 ff ff ff    	je     f0100d45 <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100df5:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100dfa:	0f 87 5e ff ff ff    	ja     f0100d5e <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100e00:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100e05:	75 9b                	jne    f0100da2 <check_page_free_list+0x1b8>
f0100e07:	68 1b 7a 10 f0       	push   $0xf0107a1b
f0100e0c:	68 ae 79 10 f0       	push   $0xf01079ae
f0100e11:	68 ec 02 00 00       	push   $0x2ec
f0100e16:	68 6d 79 10 f0       	push   $0xf010796d
f0100e1b:	e8 20 f2 ff ff       	call   f0100040 <_panic>
f0100e20:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f0100e23:	85 db                	test   %ebx,%ebx
f0100e25:	7e 19                	jle    f0100e40 <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f0100e27:	85 ff                	test   %edi,%edi
f0100e29:	7e 2e                	jle    f0100e59 <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f0100e2b:	83 ec 0c             	sub    $0xc,%esp
f0100e2e:	68 c8 70 10 f0       	push   $0xf01070c8
f0100e33:	e8 a2 2b 00 00       	call   f01039da <cprintf>
}
f0100e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e3b:	5b                   	pop    %ebx
f0100e3c:	5e                   	pop    %esi
f0100e3d:	5f                   	pop    %edi
f0100e3e:	5d                   	pop    %ebp
f0100e3f:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100e40:	68 38 7a 10 f0       	push   $0xf0107a38
f0100e45:	68 ae 79 10 f0       	push   $0xf01079ae
f0100e4a:	68 f4 02 00 00       	push   $0x2f4
f0100e4f:	68 6d 79 10 f0       	push   $0xf010796d
f0100e54:	e8 e7 f1 ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0100e59:	68 4a 7a 10 f0       	push   $0xf0107a4a
f0100e5e:	68 ae 79 10 f0       	push   $0xf01079ae
f0100e63:	68 f5 02 00 00       	push   $0x2f5
f0100e68:	68 6d 79 10 f0       	push   $0xf010796d
f0100e6d:	e8 ce f1 ff ff       	call   f0100040 <_panic>
	if (!page_free_list)
f0100e72:	a1 40 32 53 f0       	mov    0xf0533240,%eax
f0100e77:	85 c0                	test   %eax,%eax
f0100e79:	0f 84 8f fd ff ff    	je     f0100c0e <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100e7f:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100e82:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100e85:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100e88:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100e8b:	89 c2                	mov    %eax,%edx
f0100e8d:	2b 15 a8 3e 53 f0    	sub    0xf0533ea8,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100e93:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100e99:	0f 95 c2             	setne  %dl
f0100e9c:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100e9f:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100ea3:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100ea5:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100ea9:	8b 00                	mov    (%eax),%eax
f0100eab:	85 c0                	test   %eax,%eax
f0100ead:	75 dc                	jne    f0100e8b <check_page_free_list+0x2a1>
		*tp[1] = 0;
f0100eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100eb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100eb8:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100ebb:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100ebe:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100ec0:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100ec3:	a3 40 32 53 f0       	mov    %eax,0xf0533240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ec8:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100ecd:	8b 1d 40 32 53 f0    	mov    0xf0533240,%ebx
f0100ed3:	e9 61 fd ff ff       	jmp    f0100c39 <check_page_free_list+0x4f>

f0100ed8 <page_init>:
{
f0100ed8:	55                   	push   %ebp
f0100ed9:	89 e5                	mov    %esp,%ebp
f0100edb:	57                   	push   %edi
f0100edc:	56                   	push   %esi
f0100edd:	53                   	push   %ebx
f0100ede:	83 ec 0c             	sub    $0xc,%esp
	for (i = 1; i < npages_basemem; i++) {
f0100ee1:	8b 35 44 32 53 f0    	mov    0xf0533244,%esi
f0100ee7:	8b 1d 40 32 53 f0    	mov    0xf0533240,%ebx
f0100eed:	ba 00 00 00 00       	mov    $0x0,%edx
f0100ef2:	b8 01 00 00 00       	mov    $0x1,%eax
		page_free_list = &pages[i]; //头插法
f0100ef7:	bf 01 00 00 00       	mov    $0x1,%edi
	for (i = 1; i < npages_basemem; i++) {
f0100efc:	eb 03                	jmp    f0100f01 <page_init+0x29>
f0100efe:	83 c0 01             	add    $0x1,%eax
f0100f01:	39 c6                	cmp    %eax,%esi
f0100f03:	76 28                	jbe    f0100f2d <page_init+0x55>
    if (PGNUM(MPENTRY_PADDR) == i) continue;
f0100f05:	83 f8 07             	cmp    $0x7,%eax
f0100f08:	74 f4                	je     f0100efe <page_init+0x26>
f0100f0a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100f11:	89 d1                	mov    %edx,%ecx
f0100f13:	03 0d a8 3e 53 f0    	add    0xf0533ea8,%ecx
f0100f19:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100f1f:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i]; //头插法
f0100f21:	89 d3                	mov    %edx,%ebx
f0100f23:	03 1d a8 3e 53 f0    	add    0xf0533ea8,%ebx
f0100f29:	89 fa                	mov    %edi,%edx
f0100f2b:	eb d1                	jmp    f0100efe <page_init+0x26>
f0100f2d:	84 d2                	test   %dl,%dl
f0100f2f:	74 06                	je     f0100f37 <page_init+0x5f>
f0100f31:	89 1d 40 32 53 f0    	mov    %ebx,0xf0533240
  void *nextfree = boot_alloc(0);
f0100f37:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f3c:	e8 27 fc ff ff       	call   f0100b68 <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0100f41:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100f46:	76 1a                	jbe    f0100f62 <page_init+0x8a>
	return (physaddr_t)kva - KERNBASE;
f0100f48:	05 00 00 00 10       	add    $0x10000000,%eax
  i = PADDR(nextfree) / PGSIZE;
f0100f4d:	c1 e8 0c             	shr    $0xc,%eax
f0100f50:	8b 1d 40 32 53 f0    	mov    0xf0533240,%ebx
	for (; i < npages; i++) {
f0100f56:	ba 00 00 00 00       	mov    $0x0,%edx
f0100f5b:	be 01 00 00 00       	mov    $0x1,%esi
f0100f60:	eb 39                	jmp    f0100f9b <page_init+0xc3>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100f62:	50                   	push   %eax
f0100f63:	68 68 6a 10 f0       	push   $0xf0106a68
f0100f68:	68 5b 01 00 00       	push   $0x15b
f0100f6d:	68 6d 79 10 f0       	push   $0xf010796d
f0100f72:	e8 c9 f0 ff ff       	call   f0100040 <_panic>
f0100f77:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100f7e:	89 d1                	mov    %edx,%ecx
f0100f80:	03 0d a8 3e 53 f0    	add    0xf0533ea8,%ecx
f0100f86:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100f8c:	89 19                	mov    %ebx,(%ecx)
	for (; i < npages; i++) {
f0100f8e:	83 c0 01             	add    $0x1,%eax
		page_free_list = &pages[i]; //头插法
f0100f91:	89 d3                	mov    %edx,%ebx
f0100f93:	03 1d a8 3e 53 f0    	add    0xf0533ea8,%ebx
f0100f99:	89 f2                	mov    %esi,%edx
	for (; i < npages; i++) {
f0100f9b:	39 05 a0 3e 53 f0    	cmp    %eax,0xf0533ea0
f0100fa1:	77 d4                	ja     f0100f77 <page_init+0x9f>
f0100fa3:	84 d2                	test   %dl,%dl
f0100fa5:	74 06                	je     f0100fad <page_init+0xd5>
f0100fa7:	89 1d 40 32 53 f0    	mov    %ebx,0xf0533240
}
f0100fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100fb0:	5b                   	pop    %ebx
f0100fb1:	5e                   	pop    %esi
f0100fb2:	5f                   	pop    %edi
f0100fb3:	5d                   	pop    %ebp
f0100fb4:	c3                   	ret    

f0100fb5 <page_alloc>:
{
f0100fb5:	55                   	push   %ebp
f0100fb6:	89 e5                	mov    %esp,%ebp
f0100fb8:	53                   	push   %ebx
f0100fb9:	83 ec 04             	sub    $0x4,%esp
  if (page_free_list == NULL) return NULL;
f0100fbc:	8b 1d 40 32 53 f0    	mov    0xf0533240,%ebx
f0100fc2:	85 db                	test   %ebx,%ebx
f0100fc4:	74 13                	je     f0100fd9 <page_alloc+0x24>
  page_free_list = page_free_list->pp_link;
f0100fc6:	8b 03                	mov    (%ebx),%eax
f0100fc8:	a3 40 32 53 f0       	mov    %eax,0xf0533240
  res->pp_link = NULL;
f0100fcd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if (alloc_flags & ALLOC_ZERO)
f0100fd3:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0100fd7:	75 07                	jne    f0100fe0 <page_alloc+0x2b>
}
f0100fd9:	89 d8                	mov    %ebx,%eax
f0100fdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100fde:	c9                   	leave  
f0100fdf:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0100fe0:	89 d8                	mov    %ebx,%eax
f0100fe2:	2b 05 a8 3e 53 f0    	sub    0xf0533ea8,%eax
f0100fe8:	c1 f8 03             	sar    $0x3,%eax
f0100feb:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0100fee:	89 c2                	mov    %eax,%edx
f0100ff0:	c1 ea 0c             	shr    $0xc,%edx
f0100ff3:	3b 15 a0 3e 53 f0    	cmp    0xf0533ea0,%edx
f0100ff9:	73 1a                	jae    f0101015 <page_alloc+0x60>
    memset(page2kva(res), 0, PGSIZE);
f0100ffb:	83 ec 04             	sub    $0x4,%esp
f0100ffe:	68 00 10 00 00       	push   $0x1000
f0101003:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0101005:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010100a:	50                   	push   %eax
f010100b:	e8 4f 48 00 00       	call   f010585f <memset>
f0101010:	83 c4 10             	add    $0x10,%esp
f0101013:	eb c4                	jmp    f0100fd9 <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101015:	50                   	push   %eax
f0101016:	68 44 6a 10 f0       	push   $0xf0106a44
f010101b:	6a 58                	push   $0x58
f010101d:	68 94 79 10 f0       	push   $0xf0107994
f0101022:	e8 19 f0 ff ff       	call   f0100040 <_panic>

f0101027 <page_free>:
{
f0101027:	55                   	push   %ebp
f0101028:	89 e5                	mov    %esp,%ebp
f010102a:	83 ec 08             	sub    $0x8,%esp
f010102d:	8b 45 08             	mov    0x8(%ebp),%eax
  if (pp->pp_ref != 0 || pp->pp_link != NULL)
f0101030:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101035:	75 14                	jne    f010104b <page_free+0x24>
f0101037:	83 38 00             	cmpl   $0x0,(%eax)
f010103a:	75 0f                	jne    f010104b <page_free+0x24>
  pp->pp_link = page_free_list;  
f010103c:	8b 15 40 32 53 f0    	mov    0xf0533240,%edx
f0101042:	89 10                	mov    %edx,(%eax)
  page_free_list = pp;
f0101044:	a3 40 32 53 f0       	mov    %eax,0xf0533240
}
f0101049:	c9                   	leave  
f010104a:	c3                   	ret    
    panic("page_free: can't free this page!");
f010104b:	83 ec 04             	sub    $0x4,%esp
f010104e:	68 ec 70 10 f0       	push   $0xf01070ec
f0101053:	68 88 01 00 00       	push   $0x188
f0101058:	68 6d 79 10 f0       	push   $0xf010796d
f010105d:	e8 de ef ff ff       	call   f0100040 <_panic>

f0101062 <page_decref>:
{
f0101062:	55                   	push   %ebp
f0101063:	89 e5                	mov    %esp,%ebp
f0101065:	83 ec 08             	sub    $0x8,%esp
f0101068:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f010106b:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f010106f:	83 e8 01             	sub    $0x1,%eax
f0101072:	66 89 42 04          	mov    %ax,0x4(%edx)
f0101076:	66 85 c0             	test   %ax,%ax
f0101079:	74 02                	je     f010107d <page_decref+0x1b>
}
f010107b:	c9                   	leave  
f010107c:	c3                   	ret    
		page_free(pp);
f010107d:	83 ec 0c             	sub    $0xc,%esp
f0101080:	52                   	push   %edx
f0101081:	e8 a1 ff ff ff       	call   f0101027 <page_free>
f0101086:	83 c4 10             	add    $0x10,%esp
}
f0101089:	eb f0                	jmp    f010107b <page_decref+0x19>

f010108b <pgdir_walk>:
{
f010108b:	55                   	push   %ebp
f010108c:	89 e5                	mov    %esp,%ebp
f010108e:	56                   	push   %esi
f010108f:	53                   	push   %ebx
f0101090:	8b 75 0c             	mov    0xc(%ebp),%esi
  pde_t cur_pde = pgdir[PDX(va)];
f0101093:	89 f3                	mov    %esi,%ebx
f0101095:	c1 eb 16             	shr    $0x16,%ebx
f0101098:	c1 e3 02             	shl    $0x2,%ebx
f010109b:	03 5d 08             	add    0x8(%ebp),%ebx
f010109e:	8b 03                	mov    (%ebx),%eax
  if (!(cur_pde & PTE_P)) {
f01010a0:	a8 01                	test   $0x1,%al
f01010a2:	75 68                	jne    f010110c <pgdir_walk+0x81>
    if (!create) return NULL;
f01010a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01010a8:	0f 84 9c 00 00 00    	je     f010114a <pgdir_walk+0xbf>
    struct PageInfo *page = page_alloc(ALLOC_ZERO);
f01010ae:	83 ec 0c             	sub    $0xc,%esp
f01010b1:	6a 01                	push   $0x1
f01010b3:	e8 fd fe ff ff       	call   f0100fb5 <page_alloc>
    if (page == NULL) return NULL;
f01010b8:	83 c4 10             	add    $0x10,%esp
f01010bb:	85 c0                	test   %eax,%eax
f01010bd:	0f 84 8e 00 00 00    	je     f0101151 <pgdir_walk+0xc6>
    page->pp_ref++;
f01010c3:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01010c8:	2b 05 a8 3e 53 f0    	sub    0xf0533ea8,%eax
f01010ce:	c1 f8 03             	sar    $0x3,%eax
f01010d1:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01010d4:	89 c2                	mov    %eax,%edx
f01010d6:	c1 ea 0c             	shr    $0xc,%edx
f01010d9:	3b 15 a0 3e 53 f0    	cmp    0xf0533ea0,%edx
f01010df:	73 19                	jae    f01010fa <pgdir_walk+0x6f>
    pgdir[PDX(va)] = page2pa(page) | (PTE_U|PTE_P|PTE_W);
f01010e1:	89 c2                	mov    %eax,%edx
f01010e3:	83 ca 07             	or     $0x7,%edx
f01010e6:	89 13                	mov    %edx,(%ebx)
    res += PTX(va);
f01010e8:	c1 ee 0a             	shr    $0xa,%esi
f01010eb:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f01010f1:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f01010f8:	eb 34                	jmp    f010112e <pgdir_walk+0xa3>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01010fa:	50                   	push   %eax
f01010fb:	68 44 6a 10 f0       	push   $0xf0106a44
f0101100:	6a 58                	push   $0x58
f0101102:	68 94 79 10 f0       	push   $0xf0107994
f0101107:	e8 34 ef ff ff       	call   f0100040 <_panic>
    res = (pte_t*)KADDR(PTE_ADDR(cur_pde)) + PTX(va);
f010110c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101111:	89 c2                	mov    %eax,%edx
f0101113:	c1 ea 0c             	shr    $0xc,%edx
f0101116:	3b 15 a0 3e 53 f0    	cmp    0xf0533ea0,%edx
f010111c:	73 17                	jae    f0101135 <pgdir_walk+0xaa>
f010111e:	c1 ee 0a             	shr    $0xa,%esi
f0101121:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101127:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
}
f010112e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101131:	5b                   	pop    %ebx
f0101132:	5e                   	pop    %esi
f0101133:	5d                   	pop    %ebp
f0101134:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101135:	50                   	push   %eax
f0101136:	68 44 6a 10 f0       	push   $0xf0106a44
f010113b:	68 c6 01 00 00       	push   $0x1c6
f0101140:	68 6d 79 10 f0       	push   $0xf010796d
f0101145:	e8 f6 ee ff ff       	call   f0100040 <_panic>
    if (!create) return NULL;
f010114a:	b8 00 00 00 00       	mov    $0x0,%eax
f010114f:	eb dd                	jmp    f010112e <pgdir_walk+0xa3>
    if (page == NULL) return NULL;
f0101151:	b8 00 00 00 00       	mov    $0x0,%eax
f0101156:	eb d6                	jmp    f010112e <pgdir_walk+0xa3>

f0101158 <boot_map_region>:
{
f0101158:	55                   	push   %ebp
f0101159:	89 e5                	mov    %esp,%ebp
f010115b:	57                   	push   %edi
f010115c:	56                   	push   %esi
f010115d:	53                   	push   %ebx
f010115e:	83 ec 1c             	sub    $0x1c,%esp
f0101161:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  assert(va % PGSIZE == 0);
f0101164:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f010116a:	75 4f                	jne    f01011bb <boot_map_region+0x63>
f010116c:	89 d7                	mov    %edx,%edi
  assert(size % PGSIZE == 0);
f010116e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0101171:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
f0101177:	75 5b                	jne    f01011d4 <boot_map_region+0x7c>
  assert(pa % PGSIZE == 0);
f0101179:	f7 45 08 ff 0f 00 00 	testl  $0xfff,0x8(%ebp)
f0101180:	75 6b                	jne    f01011ed <boot_map_region+0x95>
f0101182:	89 f3                	mov    %esi,%ebx
f0101184:	03 5d 08             	add    0x8(%ebp),%ebx
  for (size_t i = 0; i < size; i += PGSIZE, pa += PGSIZE, va += PGSIZE) {
f0101187:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
f010118a:	0f 83 8f 00 00 00    	jae    f010121f <boot_map_region+0xc7>
    pte_t *pte_ptr = pgdir_walk(kern_pgdir, (void*)va, true);
f0101190:	83 ec 04             	sub    $0x4,%esp
f0101193:	6a 01                	push   $0x1
f0101195:	8d 04 3e             	lea    (%esi,%edi,1),%eax
f0101198:	50                   	push   %eax
f0101199:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f010119f:	e8 e7 fe ff ff       	call   f010108b <pgdir_walk>
    assert(pte_ptr != NULL);
f01011a4:	83 c4 10             	add    $0x10,%esp
f01011a7:	85 c0                	test   %eax,%eax
f01011a9:	74 5b                	je     f0101206 <boot_map_region+0xae>
    *pte_ptr = pa | (perm|PTE_P);
f01011ab:	0b 5d 0c             	or     0xc(%ebp),%ebx
f01011ae:	83 cb 01             	or     $0x1,%ebx
f01011b1:	89 18                	mov    %ebx,(%eax)
  for (size_t i = 0; i < size; i += PGSIZE, pa += PGSIZE, va += PGSIZE) {
f01011b3:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01011b9:	eb c7                	jmp    f0101182 <boot_map_region+0x2a>
  assert(va % PGSIZE == 0);
f01011bb:	68 5b 7a 10 f0       	push   $0xf0107a5b
f01011c0:	68 ae 79 10 f0       	push   $0xf01079ae
f01011c5:	68 dc 01 00 00       	push   $0x1dc
f01011ca:	68 6d 79 10 f0       	push   $0xf010796d
f01011cf:	e8 6c ee ff ff       	call   f0100040 <_panic>
  assert(size % PGSIZE == 0);
f01011d4:	68 6c 7a 10 f0       	push   $0xf0107a6c
f01011d9:	68 ae 79 10 f0       	push   $0xf01079ae
f01011de:	68 dd 01 00 00       	push   $0x1dd
f01011e3:	68 6d 79 10 f0       	push   $0xf010796d
f01011e8:	e8 53 ee ff ff       	call   f0100040 <_panic>
  assert(pa % PGSIZE == 0);
f01011ed:	68 7f 7a 10 f0       	push   $0xf0107a7f
f01011f2:	68 ae 79 10 f0       	push   $0xf01079ae
f01011f7:	68 de 01 00 00       	push   $0x1de
f01011fc:	68 6d 79 10 f0       	push   $0xf010796d
f0101201:	e8 3a ee ff ff       	call   f0100040 <_panic>
    assert(pte_ptr != NULL);
f0101206:	68 90 7a 10 f0       	push   $0xf0107a90
f010120b:	68 ae 79 10 f0       	push   $0xf01079ae
f0101210:	68 e1 01 00 00       	push   $0x1e1
f0101215:	68 6d 79 10 f0       	push   $0xf010796d
f010121a:	e8 21 ee ff ff       	call   f0100040 <_panic>
}
f010121f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101222:	5b                   	pop    %ebx
f0101223:	5e                   	pop    %esi
f0101224:	5f                   	pop    %edi
f0101225:	5d                   	pop    %ebp
f0101226:	c3                   	ret    

f0101227 <page_lookup>:
{
f0101227:	55                   	push   %ebp
f0101228:	89 e5                	mov    %esp,%ebp
f010122a:	53                   	push   %ebx
f010122b:	83 ec 08             	sub    $0x8,%esp
f010122e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  pte_t *pte_ptr = pgdir_walk(pgdir, va, false);
f0101231:	6a 00                	push   $0x0
f0101233:	ff 75 0c             	pushl  0xc(%ebp)
f0101236:	ff 75 08             	pushl  0x8(%ebp)
f0101239:	e8 4d fe ff ff       	call   f010108b <pgdir_walk>
  if (pte_ptr == NULL || PTE_ADDR(*pte_ptr) == 0) return NULL;
f010123e:	83 c4 10             	add    $0x10,%esp
f0101241:	85 c0                	test   %eax,%eax
f0101243:	74 3d                	je     f0101282 <page_lookup+0x5b>
f0101245:	f7 00 00 f0 ff ff    	testl  $0xfffff000,(%eax)
f010124b:	74 3c                	je     f0101289 <page_lookup+0x62>
  if (pte_store) *pte_store = pte_ptr; 
f010124d:	85 db                	test   %ebx,%ebx
f010124f:	74 02                	je     f0101253 <page_lookup+0x2c>
f0101251:	89 03                	mov    %eax,(%ebx)
f0101253:	8b 00                	mov    (%eax),%eax
f0101255:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101258:	39 05 a0 3e 53 f0    	cmp    %eax,0xf0533ea0
f010125e:	76 0e                	jbe    f010126e <page_lookup+0x47>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101260:	8b 15 a8 3e 53 f0    	mov    0xf0533ea8,%edx
f0101266:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101269:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010126c:	c9                   	leave  
f010126d:	c3                   	ret    
		panic("pa2page called with invalid pa");
f010126e:	83 ec 04             	sub    $0x4,%esp
f0101271:	68 10 71 10 f0       	push   $0xf0107110
f0101276:	6a 51                	push   $0x51
f0101278:	68 94 79 10 f0       	push   $0xf0107994
f010127d:	e8 be ed ff ff       	call   f0100040 <_panic>
  if (pte_ptr == NULL || PTE_ADDR(*pte_ptr) == 0) return NULL;
f0101282:	b8 00 00 00 00       	mov    $0x0,%eax
f0101287:	eb e0                	jmp    f0101269 <page_lookup+0x42>
f0101289:	b8 00 00 00 00       	mov    $0x0,%eax
f010128e:	eb d9                	jmp    f0101269 <page_lookup+0x42>

f0101290 <tlb_invalidate>:
{
f0101290:	55                   	push   %ebp
f0101291:	89 e5                	mov    %esp,%ebp
f0101293:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f0101296:	e8 c3 4b 00 00       	call   f0105e5e <cpunum>
f010129b:	6b c0 74             	imul   $0x74,%eax,%eax
f010129e:	83 b8 28 40 53 f0 00 	cmpl   $0x0,-0xfacbfd8(%eax)
f01012a5:	74 16                	je     f01012bd <tlb_invalidate+0x2d>
f01012a7:	e8 b2 4b 00 00       	call   f0105e5e <cpunum>
f01012ac:	6b c0 74             	imul   $0x74,%eax,%eax
f01012af:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f01012b5:	8b 55 08             	mov    0x8(%ebp),%edx
f01012b8:	39 50 60             	cmp    %edx,0x60(%eax)
f01012bb:	75 06                	jne    f01012c3 <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
f01012c0:	0f 01 38             	invlpg (%eax)
}
f01012c3:	c9                   	leave  
f01012c4:	c3                   	ret    

f01012c5 <page_remove>:
{
f01012c5:	55                   	push   %ebp
f01012c6:	89 e5                	mov    %esp,%ebp
f01012c8:	56                   	push   %esi
f01012c9:	53                   	push   %ebx
f01012ca:	83 ec 14             	sub    $0x14,%esp
f01012cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01012d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct PageInfo *pp = page_lookup(pgdir, va, &pte_ptr);
f01012d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01012d6:	50                   	push   %eax
f01012d7:	56                   	push   %esi
f01012d8:	53                   	push   %ebx
f01012d9:	e8 49 ff ff ff       	call   f0101227 <page_lookup>
  if (pp == NULL) return;
f01012de:	83 c4 10             	add    $0x10,%esp
f01012e1:	85 c0                	test   %eax,%eax
f01012e3:	74 1f                	je     f0101304 <page_remove+0x3f>
  page_decref(pp);
f01012e5:	83 ec 0c             	sub    $0xc,%esp
f01012e8:	50                   	push   %eax
f01012e9:	e8 74 fd ff ff       	call   f0101062 <page_decref>
  *pte_ptr= 0;
f01012ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01012f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  tlb_invalidate(pgdir, va);
f01012f7:	83 c4 08             	add    $0x8,%esp
f01012fa:	56                   	push   %esi
f01012fb:	53                   	push   %ebx
f01012fc:	e8 8f ff ff ff       	call   f0101290 <tlb_invalidate>
f0101301:	83 c4 10             	add    $0x10,%esp
}
f0101304:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101307:	5b                   	pop    %ebx
f0101308:	5e                   	pop    %esi
f0101309:	5d                   	pop    %ebp
f010130a:	c3                   	ret    

f010130b <page_insert>:
{
f010130b:	55                   	push   %ebp
f010130c:	89 e5                	mov    %esp,%ebp
f010130e:	57                   	push   %edi
f010130f:	56                   	push   %esi
f0101310:	53                   	push   %ebx
f0101311:	83 ec 10             	sub    $0x10,%esp
f0101314:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101317:	8b 7d 10             	mov    0x10(%ebp),%edi
  pte_t *old_pte_ptr = pgdir_walk(pgdir, va, true);
f010131a:	6a 01                	push   $0x1
f010131c:	57                   	push   %edi
f010131d:	ff 75 08             	pushl  0x8(%ebp)
f0101320:	e8 66 fd ff ff       	call   f010108b <pgdir_walk>
  if (old_pte_ptr == NULL) return -E_NO_MEM;
f0101325:	83 c4 10             	add    $0x10,%esp
f0101328:	85 c0                	test   %eax,%eax
f010132a:	74 41                	je     f010136d <page_insert+0x62>
f010132c:	89 c6                	mov    %eax,%esi
  ++pp->pp_ref;
f010132e:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
  if (PTE_ADDR(*old_pte_ptr) != 0) page_remove(pgdir, va);
f0101333:	f7 00 00 f0 ff ff    	testl  $0xfffff000,(%eax)
f0101339:	75 21                	jne    f010135c <page_insert+0x51>
	return (pp - pages) << PGSHIFT;
f010133b:	2b 1d a8 3e 53 f0    	sub    0xf0533ea8,%ebx
f0101341:	c1 fb 03             	sar    $0x3,%ebx
f0101344:	c1 e3 0c             	shl    $0xc,%ebx
  *old_pte_ptr = page2pa(pp) | (perm|PTE_P);
f0101347:	0b 5d 14             	or     0x14(%ebp),%ebx
f010134a:	83 cb 01             	or     $0x1,%ebx
f010134d:	89 1e                	mov    %ebx,(%esi)
	return 0;
f010134f:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101354:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101357:	5b                   	pop    %ebx
f0101358:	5e                   	pop    %esi
f0101359:	5f                   	pop    %edi
f010135a:	5d                   	pop    %ebp
f010135b:	c3                   	ret    
  if (PTE_ADDR(*old_pte_ptr) != 0) page_remove(pgdir, va);
f010135c:	83 ec 08             	sub    $0x8,%esp
f010135f:	57                   	push   %edi
f0101360:	ff 75 08             	pushl  0x8(%ebp)
f0101363:	e8 5d ff ff ff       	call   f01012c5 <page_remove>
f0101368:	83 c4 10             	add    $0x10,%esp
f010136b:	eb ce                	jmp    f010133b <page_insert+0x30>
  if (old_pte_ptr == NULL) return -E_NO_MEM;
f010136d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101372:	eb e0                	jmp    f0101354 <page_insert+0x49>

f0101374 <mmio_map_region>:
{
f0101374:	55                   	push   %ebp
f0101375:	89 e5                	mov    %esp,%ebp
f0101377:	56                   	push   %esi
f0101378:	53                   	push   %ebx
f0101379:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  if (MMIOLIM < ROUNDUP(size + base, PGSIZE)) 
f010137c:	8b 1d 00 53 12 f0    	mov    0xf0125300,%ebx
f0101382:	8d 84 0b ff 0f 00 00 	lea    0xfff(%ebx,%ecx,1),%eax
f0101389:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010138e:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f0101393:	77 47                	ja     f01013dc <mmio_map_region+0x68>
  boot_map_region(kern_pgdir, ROUNDDOWN(base, PGSIZE), ROUNDUP(size, PGSIZE), pa, (PTE_PCD|PTE_PWT|PTE_W));
f0101395:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
f010139b:	89 ce                	mov    %ecx,%esi
f010139d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f01013a3:	89 da                	mov    %ebx,%edx
f01013a5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01013ab:	83 ec 08             	sub    $0x8,%esp
f01013ae:	6a 1a                	push   $0x1a
f01013b0:	ff 75 08             	pushl  0x8(%ebp)
f01013b3:	89 f1                	mov    %esi,%ecx
f01013b5:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
f01013ba:	e8 99 fd ff ff       	call   f0101158 <boot_map_region>
  base = ROUNDDOWN(base, PGSIZE) + ROUNDUP(size, PGSIZE);
f01013bf:	8b 0d 00 53 12 f0    	mov    0xf0125300,%ecx
f01013c5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01013cb:	01 f1                	add    %esi,%ecx
f01013cd:	89 0d 00 53 12 f0    	mov    %ecx,0xf0125300
}
f01013d3:	89 d8                	mov    %ebx,%eax
f01013d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01013d8:	5b                   	pop    %ebx
f01013d9:	5e                   	pop    %esi
f01013da:	5d                   	pop    %ebp
f01013db:	c3                   	ret    
	  panic("mmio_map_region: overflow MMIOLIM\n");
f01013dc:	83 ec 04             	sub    $0x4,%esp
f01013df:	68 30 71 10 f0       	push   $0xf0107130
f01013e4:	68 6e 02 00 00       	push   $0x26e
f01013e9:	68 6d 79 10 f0       	push   $0xf010796d
f01013ee:	e8 4d ec ff ff       	call   f0100040 <_panic>

f01013f3 <mem_init>:
{
f01013f3:	55                   	push   %ebp
f01013f4:	89 e5                	mov    %esp,%ebp
f01013f6:	57                   	push   %edi
f01013f7:	56                   	push   %esi
f01013f8:	53                   	push   %ebx
f01013f9:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f01013fc:	b8 15 00 00 00       	mov    $0x15,%eax
f0101401:	e8 d5 f6 ff ff       	call   f0100adb <nvram_read>
f0101406:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f0101408:	b8 17 00 00 00       	mov    $0x17,%eax
f010140d:	e8 c9 f6 ff ff       	call   f0100adb <nvram_read>
f0101412:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101414:	b8 34 00 00 00       	mov    $0x34,%eax
f0101419:	e8 bd f6 ff ff       	call   f0100adb <nvram_read>
	if (ext16mem)
f010141e:	c1 e0 06             	shl    $0x6,%eax
f0101421:	0f 84 08 01 00 00    	je     f010152f <mem_init+0x13c>
		totalmem = 16 * 1024 + ext16mem;
f0101427:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f010142c:	89 c2                	mov    %eax,%edx
f010142e:	c1 ea 02             	shr    $0x2,%edx
f0101431:	89 15 a0 3e 53 f0    	mov    %edx,0xf0533ea0
	npages_basemem = basemem / (PGSIZE / 1024);
f0101437:	89 da                	mov    %ebx,%edx
f0101439:	c1 ea 02             	shr    $0x2,%edx
f010143c:	89 15 44 32 53 f0    	mov    %edx,0xf0533244
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101442:	89 c2                	mov    %eax,%edx
f0101444:	29 da                	sub    %ebx,%edx
f0101446:	52                   	push   %edx
f0101447:	53                   	push   %ebx
f0101448:	50                   	push   %eax
f0101449:	68 54 71 10 f0       	push   $0xf0107154
f010144e:	e8 87 25 00 00       	call   f01039da <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101453:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101458:	e8 0b f7 ff ff       	call   f0100b68 <boot_alloc>
f010145d:	a3 a4 3e 53 f0       	mov    %eax,0xf0533ea4
	memset(kern_pgdir, 0, PGSIZE);
f0101462:	83 c4 0c             	add    $0xc,%esp
f0101465:	68 00 10 00 00       	push   $0x1000
f010146a:	6a 00                	push   $0x0
f010146c:	50                   	push   %eax
f010146d:	e8 ed 43 00 00       	call   f010585f <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101472:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
	if ((uint32_t)kva < KERNBASE)
f0101477:	83 c4 10             	add    $0x10,%esp
f010147a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010147f:	0f 86 ba 00 00 00    	jbe    f010153f <mem_init+0x14c>
	return (physaddr_t)kva - KERNBASE;
f0101485:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010148b:	83 ca 05             	or     $0x5,%edx
f010148e:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
  uint32_t bytes_to_alloc = sizeof(struct PageInfo) * npages;
f0101494:	8b 35 a0 3e 53 f0    	mov    0xf0533ea0,%esi
f010149a:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
  pages = (struct PageInfo *)boot_alloc(bytes_to_alloc);
f01014a1:	89 d8                	mov    %ebx,%eax
f01014a3:	e8 c0 f6 ff ff       	call   f0100b68 <boot_alloc>
f01014a8:	a3 a8 3e 53 f0       	mov    %eax,0xf0533ea8
  cprintf("mem_init: pages = %x\n", pages + bytes_to_alloc);
f01014ad:	83 ec 08             	sub    $0x8,%esp
f01014b0:	c1 e6 06             	shl    $0x6,%esi
f01014b3:	01 f0                	add    %esi,%eax
f01014b5:	50                   	push   %eax
f01014b6:	68 a0 7a 10 f0       	push   $0xf0107aa0
f01014bb:	e8 1a 25 00 00       	call   f01039da <cprintf>
  memset(pages, 0, ROUNDUP(bytes_to_alloc, PGSIZE));
f01014c0:	83 c4 0c             	add    $0xc,%esp
f01014c3:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
f01014c9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f01014cf:	53                   	push   %ebx
f01014d0:	6a 00                	push   $0x0
f01014d2:	ff 35 a8 3e 53 f0    	pushl  0xf0533ea8
f01014d8:	e8 82 43 00 00       	call   f010585f <memset>
  envs = (struct Env *)boot_alloc(bytes_to_alloc);
f01014dd:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f01014e2:	e8 81 f6 ff ff       	call   f0100b68 <boot_alloc>
f01014e7:	a3 48 32 53 f0       	mov    %eax,0xf0533248
  memset(envs, 0, ROUNDUP(bytes_to_alloc, PGSIZE));
f01014ec:	83 c4 0c             	add    $0xc,%esp
f01014ef:	68 00 f0 01 00       	push   $0x1f000
f01014f4:	6a 00                	push   $0x0
f01014f6:	50                   	push   %eax
f01014f7:	e8 63 43 00 00       	call   f010585f <memset>
	page_init();
f01014fc:	e8 d7 f9 ff ff       	call   f0100ed8 <page_init>
	check_page_free_list(1);
f0101501:	b8 01 00 00 00       	mov    $0x1,%eax
f0101506:	e8 df f6 ff ff       	call   f0100bea <check_page_free_list>
	if (!pages)
f010150b:	83 c4 10             	add    $0x10,%esp
f010150e:	83 3d a8 3e 53 f0 00 	cmpl   $0x0,0xf0533ea8
f0101515:	74 3d                	je     f0101554 <mem_init+0x161>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101517:	a1 40 32 53 f0       	mov    0xf0533240,%eax
f010151c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f0101523:	85 c0                	test   %eax,%eax
f0101525:	74 44                	je     f010156b <mem_init+0x178>
		++nfree;
f0101527:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010152b:	8b 00                	mov    (%eax),%eax
f010152d:	eb f4                	jmp    f0101523 <mem_init+0x130>
		totalmem = 1 * 1024 + extmem;
f010152f:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0101535:	85 f6                	test   %esi,%esi
f0101537:	0f 44 c3             	cmove  %ebx,%eax
f010153a:	e9 ed fe ff ff       	jmp    f010142c <mem_init+0x39>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010153f:	50                   	push   %eax
f0101540:	68 68 6a 10 f0       	push   $0xf0106a68
f0101545:	68 99 00 00 00       	push   $0x99
f010154a:	68 6d 79 10 f0       	push   $0xf010796d
f010154f:	e8 ec ea ff ff       	call   f0100040 <_panic>
		panic("'pages' is a null pointer!");
f0101554:	83 ec 04             	sub    $0x4,%esp
f0101557:	68 b6 7a 10 f0       	push   $0xf0107ab6
f010155c:	68 08 03 00 00       	push   $0x308
f0101561:	68 6d 79 10 f0       	push   $0xf010796d
f0101566:	e8 d5 ea ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f010156b:	83 ec 0c             	sub    $0xc,%esp
f010156e:	6a 00                	push   $0x0
f0101570:	e8 40 fa ff ff       	call   f0100fb5 <page_alloc>
f0101575:	89 c3                	mov    %eax,%ebx
f0101577:	83 c4 10             	add    $0x10,%esp
f010157a:	85 c0                	test   %eax,%eax
f010157c:	0f 84 00 02 00 00    	je     f0101782 <mem_init+0x38f>
	assert((pp1 = page_alloc(0)));
f0101582:	83 ec 0c             	sub    $0xc,%esp
f0101585:	6a 00                	push   $0x0
f0101587:	e8 29 fa ff ff       	call   f0100fb5 <page_alloc>
f010158c:	89 c6                	mov    %eax,%esi
f010158e:	83 c4 10             	add    $0x10,%esp
f0101591:	85 c0                	test   %eax,%eax
f0101593:	0f 84 02 02 00 00    	je     f010179b <mem_init+0x3a8>
	assert((pp2 = page_alloc(0)));
f0101599:	83 ec 0c             	sub    $0xc,%esp
f010159c:	6a 00                	push   $0x0
f010159e:	e8 12 fa ff ff       	call   f0100fb5 <page_alloc>
f01015a3:	89 c7                	mov    %eax,%edi
f01015a5:	83 c4 10             	add    $0x10,%esp
f01015a8:	85 c0                	test   %eax,%eax
f01015aa:	0f 84 04 02 00 00    	je     f01017b4 <mem_init+0x3c1>
	assert(pp1 && pp1 != pp0);
f01015b0:	39 f3                	cmp    %esi,%ebx
f01015b2:	0f 84 15 02 00 00    	je     f01017cd <mem_init+0x3da>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01015b8:	39 c6                	cmp    %eax,%esi
f01015ba:	0f 84 26 02 00 00    	je     f01017e6 <mem_init+0x3f3>
f01015c0:	39 c3                	cmp    %eax,%ebx
f01015c2:	0f 84 1e 02 00 00    	je     f01017e6 <mem_init+0x3f3>
	return (pp - pages) << PGSHIFT;
f01015c8:	8b 0d a8 3e 53 f0    	mov    0xf0533ea8,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f01015ce:	8b 15 a0 3e 53 f0    	mov    0xf0533ea0,%edx
f01015d4:	c1 e2 0c             	shl    $0xc,%edx
f01015d7:	89 d8                	mov    %ebx,%eax
f01015d9:	29 c8                	sub    %ecx,%eax
f01015db:	c1 f8 03             	sar    $0x3,%eax
f01015de:	c1 e0 0c             	shl    $0xc,%eax
f01015e1:	39 d0                	cmp    %edx,%eax
f01015e3:	0f 83 16 02 00 00    	jae    f01017ff <mem_init+0x40c>
f01015e9:	89 f0                	mov    %esi,%eax
f01015eb:	29 c8                	sub    %ecx,%eax
f01015ed:	c1 f8 03             	sar    $0x3,%eax
f01015f0:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f01015f3:	39 c2                	cmp    %eax,%edx
f01015f5:	0f 86 1d 02 00 00    	jbe    f0101818 <mem_init+0x425>
f01015fb:	89 f8                	mov    %edi,%eax
f01015fd:	29 c8                	sub    %ecx,%eax
f01015ff:	c1 f8 03             	sar    $0x3,%eax
f0101602:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f0101605:	39 c2                	cmp    %eax,%edx
f0101607:	0f 86 24 02 00 00    	jbe    f0101831 <mem_init+0x43e>
	fl = page_free_list;
f010160d:	a1 40 32 53 f0       	mov    0xf0533240,%eax
f0101612:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101615:	c7 05 40 32 53 f0 00 	movl   $0x0,0xf0533240
f010161c:	00 00 00 
	assert(!page_alloc(0));
f010161f:	83 ec 0c             	sub    $0xc,%esp
f0101622:	6a 00                	push   $0x0
f0101624:	e8 8c f9 ff ff       	call   f0100fb5 <page_alloc>
f0101629:	83 c4 10             	add    $0x10,%esp
f010162c:	85 c0                	test   %eax,%eax
f010162e:	0f 85 16 02 00 00    	jne    f010184a <mem_init+0x457>
	page_free(pp0);
f0101634:	83 ec 0c             	sub    $0xc,%esp
f0101637:	53                   	push   %ebx
f0101638:	e8 ea f9 ff ff       	call   f0101027 <page_free>
	page_free(pp1);
f010163d:	89 34 24             	mov    %esi,(%esp)
f0101640:	e8 e2 f9 ff ff       	call   f0101027 <page_free>
	page_free(pp2);
f0101645:	89 3c 24             	mov    %edi,(%esp)
f0101648:	e8 da f9 ff ff       	call   f0101027 <page_free>
	assert((pp0 = page_alloc(0)));
f010164d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101654:	e8 5c f9 ff ff       	call   f0100fb5 <page_alloc>
f0101659:	89 c3                	mov    %eax,%ebx
f010165b:	83 c4 10             	add    $0x10,%esp
f010165e:	85 c0                	test   %eax,%eax
f0101660:	0f 84 fd 01 00 00    	je     f0101863 <mem_init+0x470>
	assert((pp1 = page_alloc(0)));
f0101666:	83 ec 0c             	sub    $0xc,%esp
f0101669:	6a 00                	push   $0x0
f010166b:	e8 45 f9 ff ff       	call   f0100fb5 <page_alloc>
f0101670:	89 c6                	mov    %eax,%esi
f0101672:	83 c4 10             	add    $0x10,%esp
f0101675:	85 c0                	test   %eax,%eax
f0101677:	0f 84 ff 01 00 00    	je     f010187c <mem_init+0x489>
	assert((pp2 = page_alloc(0)));
f010167d:	83 ec 0c             	sub    $0xc,%esp
f0101680:	6a 00                	push   $0x0
f0101682:	e8 2e f9 ff ff       	call   f0100fb5 <page_alloc>
f0101687:	89 c7                	mov    %eax,%edi
f0101689:	83 c4 10             	add    $0x10,%esp
f010168c:	85 c0                	test   %eax,%eax
f010168e:	0f 84 01 02 00 00    	je     f0101895 <mem_init+0x4a2>
	assert(pp1 && pp1 != pp0);
f0101694:	39 f3                	cmp    %esi,%ebx
f0101696:	0f 84 12 02 00 00    	je     f01018ae <mem_init+0x4bb>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010169c:	39 c3                	cmp    %eax,%ebx
f010169e:	0f 84 23 02 00 00    	je     f01018c7 <mem_init+0x4d4>
f01016a4:	39 c6                	cmp    %eax,%esi
f01016a6:	0f 84 1b 02 00 00    	je     f01018c7 <mem_init+0x4d4>
	assert(!page_alloc(0));
f01016ac:	83 ec 0c             	sub    $0xc,%esp
f01016af:	6a 00                	push   $0x0
f01016b1:	e8 ff f8 ff ff       	call   f0100fb5 <page_alloc>
f01016b6:	83 c4 10             	add    $0x10,%esp
f01016b9:	85 c0                	test   %eax,%eax
f01016bb:	0f 85 1f 02 00 00    	jne    f01018e0 <mem_init+0x4ed>
f01016c1:	89 d8                	mov    %ebx,%eax
f01016c3:	2b 05 a8 3e 53 f0    	sub    0xf0533ea8,%eax
f01016c9:	c1 f8 03             	sar    $0x3,%eax
f01016cc:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01016cf:	89 c2                	mov    %eax,%edx
f01016d1:	c1 ea 0c             	shr    $0xc,%edx
f01016d4:	3b 15 a0 3e 53 f0    	cmp    0xf0533ea0,%edx
f01016da:	0f 83 19 02 00 00    	jae    f01018f9 <mem_init+0x506>
	memset(page2kva(pp0), 1, PGSIZE);
f01016e0:	83 ec 04             	sub    $0x4,%esp
f01016e3:	68 00 10 00 00       	push   $0x1000
f01016e8:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01016ea:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01016ef:	50                   	push   %eax
f01016f0:	e8 6a 41 00 00       	call   f010585f <memset>
	page_free(pp0);
f01016f5:	89 1c 24             	mov    %ebx,(%esp)
f01016f8:	e8 2a f9 ff ff       	call   f0101027 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01016fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101704:	e8 ac f8 ff ff       	call   f0100fb5 <page_alloc>
f0101709:	83 c4 10             	add    $0x10,%esp
f010170c:	85 c0                	test   %eax,%eax
f010170e:	0f 84 f7 01 00 00    	je     f010190b <mem_init+0x518>
	assert(pp && pp0 == pp);
f0101714:	39 c3                	cmp    %eax,%ebx
f0101716:	0f 85 08 02 00 00    	jne    f0101924 <mem_init+0x531>
	return (pp - pages) << PGSHIFT;
f010171c:	2b 05 a8 3e 53 f0    	sub    0xf0533ea8,%eax
f0101722:	c1 f8 03             	sar    $0x3,%eax
f0101725:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101728:	89 c2                	mov    %eax,%edx
f010172a:	c1 ea 0c             	shr    $0xc,%edx
f010172d:	3b 15 a0 3e 53 f0    	cmp    0xf0533ea0,%edx
f0101733:	0f 83 04 02 00 00    	jae    f010193d <mem_init+0x54a>
	return (void *)(pa + KERNBASE);
f0101739:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f010173f:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
		assert(c[i] == 0);
f0101744:	80 3a 00             	cmpb   $0x0,(%edx)
f0101747:	0f 85 02 02 00 00    	jne    f010194f <mem_init+0x55c>
f010174d:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < PGSIZE; i++)
f0101750:	39 c2                	cmp    %eax,%edx
f0101752:	75 f0                	jne    f0101744 <mem_init+0x351>
	page_free_list = fl;
f0101754:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101757:	a3 40 32 53 f0       	mov    %eax,0xf0533240
	page_free(pp0);
f010175c:	83 ec 0c             	sub    $0xc,%esp
f010175f:	53                   	push   %ebx
f0101760:	e8 c2 f8 ff ff       	call   f0101027 <page_free>
	page_free(pp1);
f0101765:	89 34 24             	mov    %esi,(%esp)
f0101768:	e8 ba f8 ff ff       	call   f0101027 <page_free>
	page_free(pp2);
f010176d:	89 3c 24             	mov    %edi,(%esp)
f0101770:	e8 b2 f8 ff ff       	call   f0101027 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101775:	a1 40 32 53 f0       	mov    0xf0533240,%eax
f010177a:	83 c4 10             	add    $0x10,%esp
f010177d:	e9 ec 01 00 00       	jmp    f010196e <mem_init+0x57b>
	assert((pp0 = page_alloc(0)));
f0101782:	68 d1 7a 10 f0       	push   $0xf0107ad1
f0101787:	68 ae 79 10 f0       	push   $0xf01079ae
f010178c:	68 10 03 00 00       	push   $0x310
f0101791:	68 6d 79 10 f0       	push   $0xf010796d
f0101796:	e8 a5 e8 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f010179b:	68 e7 7a 10 f0       	push   $0xf0107ae7
f01017a0:	68 ae 79 10 f0       	push   $0xf01079ae
f01017a5:	68 11 03 00 00       	push   $0x311
f01017aa:	68 6d 79 10 f0       	push   $0xf010796d
f01017af:	e8 8c e8 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01017b4:	68 fd 7a 10 f0       	push   $0xf0107afd
f01017b9:	68 ae 79 10 f0       	push   $0xf01079ae
f01017be:	68 12 03 00 00       	push   $0x312
f01017c3:	68 6d 79 10 f0       	push   $0xf010796d
f01017c8:	e8 73 e8 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f01017cd:	68 13 7b 10 f0       	push   $0xf0107b13
f01017d2:	68 ae 79 10 f0       	push   $0xf01079ae
f01017d7:	68 15 03 00 00       	push   $0x315
f01017dc:	68 6d 79 10 f0       	push   $0xf010796d
f01017e1:	e8 5a e8 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01017e6:	68 90 71 10 f0       	push   $0xf0107190
f01017eb:	68 ae 79 10 f0       	push   $0xf01079ae
f01017f0:	68 16 03 00 00       	push   $0x316
f01017f5:	68 6d 79 10 f0       	push   $0xf010796d
f01017fa:	e8 41 e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f01017ff:	68 25 7b 10 f0       	push   $0xf0107b25
f0101804:	68 ae 79 10 f0       	push   $0xf01079ae
f0101809:	68 17 03 00 00       	push   $0x317
f010180e:	68 6d 79 10 f0       	push   $0xf010796d
f0101813:	e8 28 e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101818:	68 42 7b 10 f0       	push   $0xf0107b42
f010181d:	68 ae 79 10 f0       	push   $0xf01079ae
f0101822:	68 18 03 00 00       	push   $0x318
f0101827:	68 6d 79 10 f0       	push   $0xf010796d
f010182c:	e8 0f e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101831:	68 5f 7b 10 f0       	push   $0xf0107b5f
f0101836:	68 ae 79 10 f0       	push   $0xf01079ae
f010183b:	68 19 03 00 00       	push   $0x319
f0101840:	68 6d 79 10 f0       	push   $0xf010796d
f0101845:	e8 f6 e7 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010184a:	68 7c 7b 10 f0       	push   $0xf0107b7c
f010184f:	68 ae 79 10 f0       	push   $0xf01079ae
f0101854:	68 20 03 00 00       	push   $0x320
f0101859:	68 6d 79 10 f0       	push   $0xf010796d
f010185e:	e8 dd e7 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0101863:	68 d1 7a 10 f0       	push   $0xf0107ad1
f0101868:	68 ae 79 10 f0       	push   $0xf01079ae
f010186d:	68 27 03 00 00       	push   $0x327
f0101872:	68 6d 79 10 f0       	push   $0xf010796d
f0101877:	e8 c4 e7 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f010187c:	68 e7 7a 10 f0       	push   $0xf0107ae7
f0101881:	68 ae 79 10 f0       	push   $0xf01079ae
f0101886:	68 28 03 00 00       	push   $0x328
f010188b:	68 6d 79 10 f0       	push   $0xf010796d
f0101890:	e8 ab e7 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101895:	68 fd 7a 10 f0       	push   $0xf0107afd
f010189a:	68 ae 79 10 f0       	push   $0xf01079ae
f010189f:	68 29 03 00 00       	push   $0x329
f01018a4:	68 6d 79 10 f0       	push   $0xf010796d
f01018a9:	e8 92 e7 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f01018ae:	68 13 7b 10 f0       	push   $0xf0107b13
f01018b3:	68 ae 79 10 f0       	push   $0xf01079ae
f01018b8:	68 2b 03 00 00       	push   $0x32b
f01018bd:	68 6d 79 10 f0       	push   $0xf010796d
f01018c2:	e8 79 e7 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01018c7:	68 90 71 10 f0       	push   $0xf0107190
f01018cc:	68 ae 79 10 f0       	push   $0xf01079ae
f01018d1:	68 2c 03 00 00       	push   $0x32c
f01018d6:	68 6d 79 10 f0       	push   $0xf010796d
f01018db:	e8 60 e7 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01018e0:	68 7c 7b 10 f0       	push   $0xf0107b7c
f01018e5:	68 ae 79 10 f0       	push   $0xf01079ae
f01018ea:	68 2d 03 00 00       	push   $0x32d
f01018ef:	68 6d 79 10 f0       	push   $0xf010796d
f01018f4:	e8 47 e7 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01018f9:	50                   	push   %eax
f01018fa:	68 44 6a 10 f0       	push   $0xf0106a44
f01018ff:	6a 58                	push   $0x58
f0101901:	68 94 79 10 f0       	push   $0xf0107994
f0101906:	e8 35 e7 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f010190b:	68 8b 7b 10 f0       	push   $0xf0107b8b
f0101910:	68 ae 79 10 f0       	push   $0xf01079ae
f0101915:	68 32 03 00 00       	push   $0x332
f010191a:	68 6d 79 10 f0       	push   $0xf010796d
f010191f:	e8 1c e7 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f0101924:	68 a9 7b 10 f0       	push   $0xf0107ba9
f0101929:	68 ae 79 10 f0       	push   $0xf01079ae
f010192e:	68 33 03 00 00       	push   $0x333
f0101933:	68 6d 79 10 f0       	push   $0xf010796d
f0101938:	e8 03 e7 ff ff       	call   f0100040 <_panic>
f010193d:	50                   	push   %eax
f010193e:	68 44 6a 10 f0       	push   $0xf0106a44
f0101943:	6a 58                	push   $0x58
f0101945:	68 94 79 10 f0       	push   $0xf0107994
f010194a:	e8 f1 e6 ff ff       	call   f0100040 <_panic>
		assert(c[i] == 0);
f010194f:	68 b9 7b 10 f0       	push   $0xf0107bb9
f0101954:	68 ae 79 10 f0       	push   $0xf01079ae
f0101959:	68 36 03 00 00       	push   $0x336
f010195e:	68 6d 79 10 f0       	push   $0xf010796d
f0101963:	e8 d8 e6 ff ff       	call   f0100040 <_panic>
		--nfree;
f0101968:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f010196c:	8b 00                	mov    (%eax),%eax
f010196e:	85 c0                	test   %eax,%eax
f0101970:	75 f6                	jne    f0101968 <mem_init+0x575>
	assert(nfree == 0);
f0101972:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101976:	0f 85 6f 09 00 00    	jne    f01022eb <mem_init+0xef8>
	cprintf("check_page_alloc() succeeded!\n");
f010197c:	83 ec 0c             	sub    $0xc,%esp
f010197f:	68 b0 71 10 f0       	push   $0xf01071b0
f0101984:	e8 51 20 00 00       	call   f01039da <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101989:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101990:	e8 20 f6 ff ff       	call   f0100fb5 <page_alloc>
f0101995:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101998:	83 c4 10             	add    $0x10,%esp
f010199b:	85 c0                	test   %eax,%eax
f010199d:	0f 84 61 09 00 00    	je     f0102304 <mem_init+0xf11>
	assert((pp1 = page_alloc(0)));
f01019a3:	83 ec 0c             	sub    $0xc,%esp
f01019a6:	6a 00                	push   $0x0
f01019a8:	e8 08 f6 ff ff       	call   f0100fb5 <page_alloc>
f01019ad:	89 c7                	mov    %eax,%edi
f01019af:	83 c4 10             	add    $0x10,%esp
f01019b2:	85 c0                	test   %eax,%eax
f01019b4:	0f 84 63 09 00 00    	je     f010231d <mem_init+0xf2a>
	assert((pp2 = page_alloc(0)));
f01019ba:	83 ec 0c             	sub    $0xc,%esp
f01019bd:	6a 00                	push   $0x0
f01019bf:	e8 f1 f5 ff ff       	call   f0100fb5 <page_alloc>
f01019c4:	89 c3                	mov    %eax,%ebx
f01019c6:	83 c4 10             	add    $0x10,%esp
f01019c9:	85 c0                	test   %eax,%eax
f01019cb:	0f 84 65 09 00 00    	je     f0102336 <mem_init+0xf43>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f01019d1:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f01019d4:	0f 84 75 09 00 00    	je     f010234f <mem_init+0xf5c>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01019da:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f01019dd:	0f 84 85 09 00 00    	je     f0102368 <mem_init+0xf75>
f01019e3:	39 c7                	cmp    %eax,%edi
f01019e5:	0f 84 7d 09 00 00    	je     f0102368 <mem_init+0xf75>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f01019eb:	a1 40 32 53 f0       	mov    0xf0533240,%eax
f01019f0:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f01019f3:	c7 05 40 32 53 f0 00 	movl   $0x0,0xf0533240
f01019fa:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f01019fd:	83 ec 0c             	sub    $0xc,%esp
f0101a00:	6a 00                	push   $0x0
f0101a02:	e8 ae f5 ff ff       	call   f0100fb5 <page_alloc>
f0101a07:	83 c4 10             	add    $0x10,%esp
f0101a0a:	85 c0                	test   %eax,%eax
f0101a0c:	0f 85 6f 09 00 00    	jne    f0102381 <mem_init+0xf8e>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101a12:	83 ec 04             	sub    $0x4,%esp
f0101a15:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101a18:	50                   	push   %eax
f0101a19:	6a 00                	push   $0x0
f0101a1b:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101a21:	e8 01 f8 ff ff       	call   f0101227 <page_lookup>
f0101a26:	83 c4 10             	add    $0x10,%esp
f0101a29:	85 c0                	test   %eax,%eax
f0101a2b:	0f 85 69 09 00 00    	jne    f010239a <mem_init+0xfa7>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101a31:	6a 02                	push   $0x2
f0101a33:	6a 00                	push   $0x0
f0101a35:	57                   	push   %edi
f0101a36:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101a3c:	e8 ca f8 ff ff       	call   f010130b <page_insert>
f0101a41:	83 c4 10             	add    $0x10,%esp
f0101a44:	85 c0                	test   %eax,%eax
f0101a46:	0f 89 67 09 00 00    	jns    f01023b3 <mem_init+0xfc0>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101a4c:	83 ec 0c             	sub    $0xc,%esp
f0101a4f:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101a52:	e8 d0 f5 ff ff       	call   f0101027 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101a57:	6a 02                	push   $0x2
f0101a59:	6a 00                	push   $0x0
f0101a5b:	57                   	push   %edi
f0101a5c:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101a62:	e8 a4 f8 ff ff       	call   f010130b <page_insert>
f0101a67:	83 c4 20             	add    $0x20,%esp
f0101a6a:	85 c0                	test   %eax,%eax
f0101a6c:	0f 85 5a 09 00 00    	jne    f01023cc <mem_init+0xfd9>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101a72:	8b 35 a4 3e 53 f0    	mov    0xf0533ea4,%esi
	return (pp - pages) << PGSHIFT;
f0101a78:	8b 0d a8 3e 53 f0    	mov    0xf0533ea8,%ecx
f0101a7e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101a81:	8b 16                	mov    (%esi),%edx
f0101a83:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101a89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101a8c:	29 c8                	sub    %ecx,%eax
f0101a8e:	c1 f8 03             	sar    $0x3,%eax
f0101a91:	c1 e0 0c             	shl    $0xc,%eax
f0101a94:	39 c2                	cmp    %eax,%edx
f0101a96:	0f 85 49 09 00 00    	jne    f01023e5 <mem_init+0xff2>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101a9c:	ba 00 00 00 00       	mov    $0x0,%edx
f0101aa1:	89 f0                	mov    %esi,%eax
f0101aa3:	e8 5c f0 ff ff       	call   f0100b04 <check_va2pa>
f0101aa8:	89 fa                	mov    %edi,%edx
f0101aaa:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101aad:	c1 fa 03             	sar    $0x3,%edx
f0101ab0:	c1 e2 0c             	shl    $0xc,%edx
f0101ab3:	39 d0                	cmp    %edx,%eax
f0101ab5:	0f 85 43 09 00 00    	jne    f01023fe <mem_init+0x100b>
	assert(pp1->pp_ref == 1);
f0101abb:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101ac0:	0f 85 51 09 00 00    	jne    f0102417 <mem_init+0x1024>
	assert(pp0->pp_ref == 1);
f0101ac6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ac9:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101ace:	0f 85 5c 09 00 00    	jne    f0102430 <mem_init+0x103d>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101ad4:	6a 02                	push   $0x2
f0101ad6:	68 00 10 00 00       	push   $0x1000
f0101adb:	53                   	push   %ebx
f0101adc:	56                   	push   %esi
f0101add:	e8 29 f8 ff ff       	call   f010130b <page_insert>
f0101ae2:	83 c4 10             	add    $0x10,%esp
f0101ae5:	85 c0                	test   %eax,%eax
f0101ae7:	0f 85 5c 09 00 00    	jne    f0102449 <mem_init+0x1056>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101aed:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101af2:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
f0101af7:	e8 08 f0 ff ff       	call   f0100b04 <check_va2pa>
f0101afc:	89 da                	mov    %ebx,%edx
f0101afe:	2b 15 a8 3e 53 f0    	sub    0xf0533ea8,%edx
f0101b04:	c1 fa 03             	sar    $0x3,%edx
f0101b07:	c1 e2 0c             	shl    $0xc,%edx
f0101b0a:	39 d0                	cmp    %edx,%eax
f0101b0c:	0f 85 50 09 00 00    	jne    f0102462 <mem_init+0x106f>
	assert(pp2->pp_ref == 1);
f0101b12:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101b17:	0f 85 5e 09 00 00    	jne    f010247b <mem_init+0x1088>

	// should be no free memory
	assert(!page_alloc(0));
f0101b1d:	83 ec 0c             	sub    $0xc,%esp
f0101b20:	6a 00                	push   $0x0
f0101b22:	e8 8e f4 ff ff       	call   f0100fb5 <page_alloc>
f0101b27:	83 c4 10             	add    $0x10,%esp
f0101b2a:	85 c0                	test   %eax,%eax
f0101b2c:	0f 85 62 09 00 00    	jne    f0102494 <mem_init+0x10a1>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101b32:	6a 02                	push   $0x2
f0101b34:	68 00 10 00 00       	push   $0x1000
f0101b39:	53                   	push   %ebx
f0101b3a:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101b40:	e8 c6 f7 ff ff       	call   f010130b <page_insert>
f0101b45:	83 c4 10             	add    $0x10,%esp
f0101b48:	85 c0                	test   %eax,%eax
f0101b4a:	0f 85 5d 09 00 00    	jne    f01024ad <mem_init+0x10ba>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101b50:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b55:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
f0101b5a:	e8 a5 ef ff ff       	call   f0100b04 <check_va2pa>
f0101b5f:	89 da                	mov    %ebx,%edx
f0101b61:	2b 15 a8 3e 53 f0    	sub    0xf0533ea8,%edx
f0101b67:	c1 fa 03             	sar    $0x3,%edx
f0101b6a:	c1 e2 0c             	shl    $0xc,%edx
f0101b6d:	39 d0                	cmp    %edx,%eax
f0101b6f:	0f 85 51 09 00 00    	jne    f01024c6 <mem_init+0x10d3>
	assert(pp2->pp_ref == 1);
f0101b75:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101b7a:	0f 85 5f 09 00 00    	jne    f01024df <mem_init+0x10ec>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101b80:	83 ec 0c             	sub    $0xc,%esp
f0101b83:	6a 00                	push   $0x0
f0101b85:	e8 2b f4 ff ff       	call   f0100fb5 <page_alloc>
f0101b8a:	83 c4 10             	add    $0x10,%esp
f0101b8d:	85 c0                	test   %eax,%eax
f0101b8f:	0f 85 63 09 00 00    	jne    f01024f8 <mem_init+0x1105>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101b95:	8b 15 a4 3e 53 f0    	mov    0xf0533ea4,%edx
f0101b9b:	8b 02                	mov    (%edx),%eax
f0101b9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101ba2:	89 c1                	mov    %eax,%ecx
f0101ba4:	c1 e9 0c             	shr    $0xc,%ecx
f0101ba7:	3b 0d a0 3e 53 f0    	cmp    0xf0533ea0,%ecx
f0101bad:	0f 83 5e 09 00 00    	jae    f0102511 <mem_init+0x111e>
	return (void *)(pa + KERNBASE);
f0101bb3:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101bb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101bbb:	83 ec 04             	sub    $0x4,%esp
f0101bbe:	6a 00                	push   $0x0
f0101bc0:	68 00 10 00 00       	push   $0x1000
f0101bc5:	52                   	push   %edx
f0101bc6:	e8 c0 f4 ff ff       	call   f010108b <pgdir_walk>
f0101bcb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101bce:	8d 51 04             	lea    0x4(%ecx),%edx
f0101bd1:	83 c4 10             	add    $0x10,%esp
f0101bd4:	39 d0                	cmp    %edx,%eax
f0101bd6:	0f 85 4a 09 00 00    	jne    f0102526 <mem_init+0x1133>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101bdc:	6a 06                	push   $0x6
f0101bde:	68 00 10 00 00       	push   $0x1000
f0101be3:	53                   	push   %ebx
f0101be4:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101bea:	e8 1c f7 ff ff       	call   f010130b <page_insert>
f0101bef:	83 c4 10             	add    $0x10,%esp
f0101bf2:	85 c0                	test   %eax,%eax
f0101bf4:	0f 85 45 09 00 00    	jne    f010253f <mem_init+0x114c>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101bfa:	8b 35 a4 3e 53 f0    	mov    0xf0533ea4,%esi
f0101c00:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c05:	89 f0                	mov    %esi,%eax
f0101c07:	e8 f8 ee ff ff       	call   f0100b04 <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101c0c:	89 da                	mov    %ebx,%edx
f0101c0e:	2b 15 a8 3e 53 f0    	sub    0xf0533ea8,%edx
f0101c14:	c1 fa 03             	sar    $0x3,%edx
f0101c17:	c1 e2 0c             	shl    $0xc,%edx
f0101c1a:	39 d0                	cmp    %edx,%eax
f0101c1c:	0f 85 36 09 00 00    	jne    f0102558 <mem_init+0x1165>
	assert(pp2->pp_ref == 1);
f0101c22:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101c27:	0f 85 44 09 00 00    	jne    f0102571 <mem_init+0x117e>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101c2d:	83 ec 04             	sub    $0x4,%esp
f0101c30:	6a 00                	push   $0x0
f0101c32:	68 00 10 00 00       	push   $0x1000
f0101c37:	56                   	push   %esi
f0101c38:	e8 4e f4 ff ff       	call   f010108b <pgdir_walk>
f0101c3d:	83 c4 10             	add    $0x10,%esp
f0101c40:	f6 00 04             	testb  $0x4,(%eax)
f0101c43:	0f 84 41 09 00 00    	je     f010258a <mem_init+0x1197>
	assert(kern_pgdir[0] & PTE_U);
f0101c49:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
f0101c4e:	f6 00 04             	testb  $0x4,(%eax)
f0101c51:	0f 84 4c 09 00 00    	je     f01025a3 <mem_init+0x11b0>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101c57:	6a 02                	push   $0x2
f0101c59:	68 00 10 00 00       	push   $0x1000
f0101c5e:	53                   	push   %ebx
f0101c5f:	50                   	push   %eax
f0101c60:	e8 a6 f6 ff ff       	call   f010130b <page_insert>
f0101c65:	83 c4 10             	add    $0x10,%esp
f0101c68:	85 c0                	test   %eax,%eax
f0101c6a:	0f 85 4c 09 00 00    	jne    f01025bc <mem_init+0x11c9>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101c70:	83 ec 04             	sub    $0x4,%esp
f0101c73:	6a 00                	push   $0x0
f0101c75:	68 00 10 00 00       	push   $0x1000
f0101c7a:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101c80:	e8 06 f4 ff ff       	call   f010108b <pgdir_walk>
f0101c85:	83 c4 10             	add    $0x10,%esp
f0101c88:	f6 00 02             	testb  $0x2,(%eax)
f0101c8b:	0f 84 44 09 00 00    	je     f01025d5 <mem_init+0x11e2>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101c91:	83 ec 04             	sub    $0x4,%esp
f0101c94:	6a 00                	push   $0x0
f0101c96:	68 00 10 00 00       	push   $0x1000
f0101c9b:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101ca1:	e8 e5 f3 ff ff       	call   f010108b <pgdir_walk>
f0101ca6:	83 c4 10             	add    $0x10,%esp
f0101ca9:	f6 00 04             	testb  $0x4,(%eax)
f0101cac:	0f 85 3c 09 00 00    	jne    f01025ee <mem_init+0x11fb>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101cb2:	6a 02                	push   $0x2
f0101cb4:	68 00 00 40 00       	push   $0x400000
f0101cb9:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101cbc:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101cc2:	e8 44 f6 ff ff       	call   f010130b <page_insert>
f0101cc7:	83 c4 10             	add    $0x10,%esp
f0101cca:	85 c0                	test   %eax,%eax
f0101ccc:	0f 89 35 09 00 00    	jns    f0102607 <mem_init+0x1214>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101cd2:	6a 02                	push   $0x2
f0101cd4:	68 00 10 00 00       	push   $0x1000
f0101cd9:	57                   	push   %edi
f0101cda:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101ce0:	e8 26 f6 ff ff       	call   f010130b <page_insert>
f0101ce5:	83 c4 10             	add    $0x10,%esp
f0101ce8:	85 c0                	test   %eax,%eax
f0101cea:	0f 85 30 09 00 00    	jne    f0102620 <mem_init+0x122d>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101cf0:	83 ec 04             	sub    $0x4,%esp
f0101cf3:	6a 00                	push   $0x0
f0101cf5:	68 00 10 00 00       	push   $0x1000
f0101cfa:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101d00:	e8 86 f3 ff ff       	call   f010108b <pgdir_walk>
f0101d05:	83 c4 10             	add    $0x10,%esp
f0101d08:	f6 00 04             	testb  $0x4,(%eax)
f0101d0b:	0f 85 28 09 00 00    	jne    f0102639 <mem_init+0x1246>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101d11:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
f0101d16:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101d19:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d1e:	e8 e1 ed ff ff       	call   f0100b04 <check_va2pa>
f0101d23:	89 fe                	mov    %edi,%esi
f0101d25:	2b 35 a8 3e 53 f0    	sub    0xf0533ea8,%esi
f0101d2b:	c1 fe 03             	sar    $0x3,%esi
f0101d2e:	c1 e6 0c             	shl    $0xc,%esi
f0101d31:	39 f0                	cmp    %esi,%eax
f0101d33:	0f 85 19 09 00 00    	jne    f0102652 <mem_init+0x125f>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101d39:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101d41:	e8 be ed ff ff       	call   f0100b04 <check_va2pa>
f0101d46:	39 c6                	cmp    %eax,%esi
f0101d48:	0f 85 1d 09 00 00    	jne    f010266b <mem_init+0x1278>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101d4e:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f0101d53:	0f 85 2b 09 00 00    	jne    f0102684 <mem_init+0x1291>
	assert(pp2->pp_ref == 0);
f0101d59:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101d5e:	0f 85 39 09 00 00    	jne    f010269d <mem_init+0x12aa>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101d64:	83 ec 0c             	sub    $0xc,%esp
f0101d67:	6a 00                	push   $0x0
f0101d69:	e8 47 f2 ff ff       	call   f0100fb5 <page_alloc>
f0101d6e:	83 c4 10             	add    $0x10,%esp
f0101d71:	85 c0                	test   %eax,%eax
f0101d73:	0f 84 3d 09 00 00    	je     f01026b6 <mem_init+0x12c3>
f0101d79:	39 c3                	cmp    %eax,%ebx
f0101d7b:	0f 85 35 09 00 00    	jne    f01026b6 <mem_init+0x12c3>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101d81:	83 ec 08             	sub    $0x8,%esp
f0101d84:	6a 00                	push   $0x0
f0101d86:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101d8c:	e8 34 f5 ff ff       	call   f01012c5 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101d91:	8b 35 a4 3e 53 f0    	mov    0xf0533ea4,%esi
f0101d97:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d9c:	89 f0                	mov    %esi,%eax
f0101d9e:	e8 61 ed ff ff       	call   f0100b04 <check_va2pa>
f0101da3:	83 c4 10             	add    $0x10,%esp
f0101da6:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101da9:	0f 85 20 09 00 00    	jne    f01026cf <mem_init+0x12dc>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101daf:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101db4:	89 f0                	mov    %esi,%eax
f0101db6:	e8 49 ed ff ff       	call   f0100b04 <check_va2pa>
f0101dbb:	89 fa                	mov    %edi,%edx
f0101dbd:	2b 15 a8 3e 53 f0    	sub    0xf0533ea8,%edx
f0101dc3:	c1 fa 03             	sar    $0x3,%edx
f0101dc6:	c1 e2 0c             	shl    $0xc,%edx
f0101dc9:	39 d0                	cmp    %edx,%eax
f0101dcb:	0f 85 17 09 00 00    	jne    f01026e8 <mem_init+0x12f5>
	assert(pp1->pp_ref == 1);
f0101dd1:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101dd6:	0f 85 25 09 00 00    	jne    f0102701 <mem_init+0x130e>
	assert(pp2->pp_ref == 0);
f0101ddc:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101de1:	0f 85 33 09 00 00    	jne    f010271a <mem_init+0x1327>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101de7:	6a 00                	push   $0x0
f0101de9:	68 00 10 00 00       	push   $0x1000
f0101dee:	57                   	push   %edi
f0101def:	56                   	push   %esi
f0101df0:	e8 16 f5 ff ff       	call   f010130b <page_insert>
f0101df5:	83 c4 10             	add    $0x10,%esp
f0101df8:	85 c0                	test   %eax,%eax
f0101dfa:	0f 85 33 09 00 00    	jne    f0102733 <mem_init+0x1340>
	assert(pp1->pp_ref);
f0101e00:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101e05:	0f 84 41 09 00 00    	je     f010274c <mem_init+0x1359>
	assert(pp1->pp_link == NULL);
f0101e0b:	83 3f 00             	cmpl   $0x0,(%edi)
f0101e0e:	0f 85 51 09 00 00    	jne    f0102765 <mem_init+0x1372>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101e14:	83 ec 08             	sub    $0x8,%esp
f0101e17:	68 00 10 00 00       	push   $0x1000
f0101e1c:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101e22:	e8 9e f4 ff ff       	call   f01012c5 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101e27:	8b 35 a4 3e 53 f0    	mov    0xf0533ea4,%esi
f0101e2d:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e32:	89 f0                	mov    %esi,%eax
f0101e34:	e8 cb ec ff ff       	call   f0100b04 <check_va2pa>
f0101e39:	83 c4 10             	add    $0x10,%esp
f0101e3c:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e3f:	0f 85 39 09 00 00    	jne    f010277e <mem_init+0x138b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101e45:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e4a:	89 f0                	mov    %esi,%eax
f0101e4c:	e8 b3 ec ff ff       	call   f0100b04 <check_va2pa>
f0101e51:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e54:	0f 85 3d 09 00 00    	jne    f0102797 <mem_init+0x13a4>
	assert(pp1->pp_ref == 0);
f0101e5a:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101e5f:	0f 85 4b 09 00 00    	jne    f01027b0 <mem_init+0x13bd>
	assert(pp2->pp_ref == 0);
f0101e65:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101e6a:	0f 85 59 09 00 00    	jne    f01027c9 <mem_init+0x13d6>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101e70:	83 ec 0c             	sub    $0xc,%esp
f0101e73:	6a 00                	push   $0x0
f0101e75:	e8 3b f1 ff ff       	call   f0100fb5 <page_alloc>
f0101e7a:	83 c4 10             	add    $0x10,%esp
f0101e7d:	39 c7                	cmp    %eax,%edi
f0101e7f:	0f 85 5d 09 00 00    	jne    f01027e2 <mem_init+0x13ef>
f0101e85:	85 c0                	test   %eax,%eax
f0101e87:	0f 84 55 09 00 00    	je     f01027e2 <mem_init+0x13ef>

	// should be no free memory
	assert(!page_alloc(0));
f0101e8d:	83 ec 0c             	sub    $0xc,%esp
f0101e90:	6a 00                	push   $0x0
f0101e92:	e8 1e f1 ff ff       	call   f0100fb5 <page_alloc>
f0101e97:	83 c4 10             	add    $0x10,%esp
f0101e9a:	85 c0                	test   %eax,%eax
f0101e9c:	0f 85 59 09 00 00    	jne    f01027fb <mem_init+0x1408>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101ea2:	8b 0d a4 3e 53 f0    	mov    0xf0533ea4,%ecx
f0101ea8:	8b 11                	mov    (%ecx),%edx
f0101eaa:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101eb0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101eb3:	2b 05 a8 3e 53 f0    	sub    0xf0533ea8,%eax
f0101eb9:	c1 f8 03             	sar    $0x3,%eax
f0101ebc:	c1 e0 0c             	shl    $0xc,%eax
f0101ebf:	39 c2                	cmp    %eax,%edx
f0101ec1:	0f 85 4d 09 00 00    	jne    f0102814 <mem_init+0x1421>
	kern_pgdir[0] = 0;
f0101ec7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101ecd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ed0:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101ed5:	0f 85 52 09 00 00    	jne    f010282d <mem_init+0x143a>
	pp0->pp_ref = 0;
f0101edb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ede:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101ee4:	83 ec 0c             	sub    $0xc,%esp
f0101ee7:	50                   	push   %eax
f0101ee8:	e8 3a f1 ff ff       	call   f0101027 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101eed:	83 c4 0c             	add    $0xc,%esp
f0101ef0:	6a 01                	push   $0x1
f0101ef2:	68 00 10 40 00       	push   $0x401000
f0101ef7:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101efd:	e8 89 f1 ff ff       	call   f010108b <pgdir_walk>
f0101f02:	89 c1                	mov    %eax,%ecx
f0101f04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101f07:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
f0101f0c:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101f0f:	8b 40 04             	mov    0x4(%eax),%eax
f0101f12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101f17:	8b 35 a0 3e 53 f0    	mov    0xf0533ea0,%esi
f0101f1d:	89 c2                	mov    %eax,%edx
f0101f1f:	c1 ea 0c             	shr    $0xc,%edx
f0101f22:	83 c4 10             	add    $0x10,%esp
f0101f25:	39 f2                	cmp    %esi,%edx
f0101f27:	0f 83 19 09 00 00    	jae    f0102846 <mem_init+0x1453>
	assert(ptep == ptep1 + PTX(va));
f0101f2d:	2d fc ff ff 0f       	sub    $0xffffffc,%eax
f0101f32:	39 c1                	cmp    %eax,%ecx
f0101f34:	0f 85 21 09 00 00    	jne    f010285b <mem_init+0x1468>
	kern_pgdir[PDX(va)] = 0;
f0101f3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101f3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f0101f44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f47:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101f4d:	2b 05 a8 3e 53 f0    	sub    0xf0533ea8,%eax
f0101f53:	c1 f8 03             	sar    $0x3,%eax
f0101f56:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101f59:	89 c2                	mov    %eax,%edx
f0101f5b:	c1 ea 0c             	shr    $0xc,%edx
f0101f5e:	39 d6                	cmp    %edx,%esi
f0101f60:	0f 86 0e 09 00 00    	jbe    f0102874 <mem_init+0x1481>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0101f66:	83 ec 04             	sub    $0x4,%esp
f0101f69:	68 00 10 00 00       	push   $0x1000
f0101f6e:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0101f73:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101f78:	50                   	push   %eax
f0101f79:	e8 e1 38 00 00       	call   f010585f <memset>
	page_free(pp0);
f0101f7e:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0101f81:	89 34 24             	mov    %esi,(%esp)
f0101f84:	e8 9e f0 ff ff       	call   f0101027 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0101f89:	83 c4 0c             	add    $0xc,%esp
f0101f8c:	6a 01                	push   $0x1
f0101f8e:	6a 00                	push   $0x0
f0101f90:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0101f96:	e8 f0 f0 ff ff       	call   f010108b <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0101f9b:	89 f0                	mov    %esi,%eax
f0101f9d:	2b 05 a8 3e 53 f0    	sub    0xf0533ea8,%eax
f0101fa3:	c1 f8 03             	sar    $0x3,%eax
f0101fa6:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101fa9:	89 c2                	mov    %eax,%edx
f0101fab:	c1 ea 0c             	shr    $0xc,%edx
f0101fae:	83 c4 10             	add    $0x10,%esp
f0101fb1:	3b 15 a0 3e 53 f0    	cmp    0xf0533ea0,%edx
f0101fb7:	0f 83 c9 08 00 00    	jae    f0102886 <mem_init+0x1493>
	return (void *)(pa + KERNBASE);
f0101fbd:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	ptep = (pte_t *) page2kva(pp0);
f0101fc3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101fc6:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0101fcb:	f6 02 01             	testb  $0x1,(%edx)
f0101fce:	0f 85 c4 08 00 00    	jne    f0102898 <mem_init+0x14a5>
f0101fd4:	83 c2 04             	add    $0x4,%edx
	for(i=0; i<NPTENTRIES; i++)
f0101fd7:	39 c2                	cmp    %eax,%edx
f0101fd9:	75 f0                	jne    f0101fcb <mem_init+0xbd8>
	kern_pgdir[0] = 0;
f0101fdb:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
f0101fe0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0101fe6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101fe9:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0101fef:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0101ff2:	89 0d 40 32 53 f0    	mov    %ecx,0xf0533240

	// free the pages we took
	page_free(pp0);
f0101ff8:	83 ec 0c             	sub    $0xc,%esp
f0101ffb:	50                   	push   %eax
f0101ffc:	e8 26 f0 ff ff       	call   f0101027 <page_free>
	page_free(pp1);
f0102001:	89 3c 24             	mov    %edi,(%esp)
f0102004:	e8 1e f0 ff ff       	call   f0101027 <page_free>
	page_free(pp2);
f0102009:	89 1c 24             	mov    %ebx,(%esp)
f010200c:	e8 16 f0 ff ff       	call   f0101027 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0102011:	83 c4 08             	add    $0x8,%esp
f0102014:	68 01 10 00 00       	push   $0x1001
f0102019:	6a 00                	push   $0x0
f010201b:	e8 54 f3 ff ff       	call   f0101374 <mmio_map_region>
f0102020:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0102022:	83 c4 08             	add    $0x8,%esp
f0102025:	68 00 10 00 00       	push   $0x1000
f010202a:	6a 00                	push   $0x0
f010202c:	e8 43 f3 ff ff       	call   f0101374 <mmio_map_region>
f0102031:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102033:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f0102039:	83 c4 10             	add    $0x10,%esp
f010203c:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102042:	0f 86 69 08 00 00    	jbe    f01028b1 <mem_init+0x14be>
f0102048:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f010204d:	0f 87 5e 08 00 00    	ja     f01028b1 <mem_init+0x14be>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102053:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f0102059:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f010205f:	0f 87 65 08 00 00    	ja     f01028ca <mem_init+0x14d7>
f0102065:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f010206b:	0f 86 59 08 00 00    	jbe    f01028ca <mem_init+0x14d7>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102071:	89 da                	mov    %ebx,%edx
f0102073:	09 f2                	or     %esi,%edx
f0102075:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f010207b:	0f 85 62 08 00 00    	jne    f01028e3 <mem_init+0x14f0>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f0102081:	39 c6                	cmp    %eax,%esi
f0102083:	0f 82 73 08 00 00    	jb     f01028fc <mem_init+0x1509>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102089:	8b 3d a4 3e 53 f0    	mov    0xf0533ea4,%edi
f010208f:	89 da                	mov    %ebx,%edx
f0102091:	89 f8                	mov    %edi,%eax
f0102093:	e8 6c ea ff ff       	call   f0100b04 <check_va2pa>
f0102098:	85 c0                	test   %eax,%eax
f010209a:	0f 85 75 08 00 00    	jne    f0102915 <mem_init+0x1522>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f01020a0:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f01020a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01020a9:	89 c2                	mov    %eax,%edx
f01020ab:	89 f8                	mov    %edi,%eax
f01020ad:	e8 52 ea ff ff       	call   f0100b04 <check_va2pa>
f01020b2:	3d 00 10 00 00       	cmp    $0x1000,%eax
f01020b7:	0f 85 71 08 00 00    	jne    f010292e <mem_init+0x153b>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f01020bd:	89 f2                	mov    %esi,%edx
f01020bf:	89 f8                	mov    %edi,%eax
f01020c1:	e8 3e ea ff ff       	call   f0100b04 <check_va2pa>
f01020c6:	85 c0                	test   %eax,%eax
f01020c8:	0f 85 79 08 00 00    	jne    f0102947 <mem_init+0x1554>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f01020ce:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f01020d4:	89 f8                	mov    %edi,%eax
f01020d6:	e8 29 ea ff ff       	call   f0100b04 <check_va2pa>
f01020db:	83 f8 ff             	cmp    $0xffffffff,%eax
f01020de:	0f 85 7c 08 00 00    	jne    f0102960 <mem_init+0x156d>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f01020e4:	83 ec 04             	sub    $0x4,%esp
f01020e7:	6a 00                	push   $0x0
f01020e9:	53                   	push   %ebx
f01020ea:	57                   	push   %edi
f01020eb:	e8 9b ef ff ff       	call   f010108b <pgdir_walk>
f01020f0:	83 c4 10             	add    $0x10,%esp
f01020f3:	f6 00 1a             	testb  $0x1a,(%eax)
f01020f6:	0f 84 7d 08 00 00    	je     f0102979 <mem_init+0x1586>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f01020fc:	83 ec 04             	sub    $0x4,%esp
f01020ff:	6a 00                	push   $0x0
f0102101:	53                   	push   %ebx
f0102102:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0102108:	e8 7e ef ff ff       	call   f010108b <pgdir_walk>
f010210d:	83 c4 10             	add    $0x10,%esp
f0102110:	f6 00 04             	testb  $0x4,(%eax)
f0102113:	0f 85 79 08 00 00    	jne    f0102992 <mem_init+0x159f>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102119:	83 ec 04             	sub    $0x4,%esp
f010211c:	6a 00                	push   $0x0
f010211e:	53                   	push   %ebx
f010211f:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0102125:	e8 61 ef ff ff       	call   f010108b <pgdir_walk>
f010212a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0102130:	83 c4 0c             	add    $0xc,%esp
f0102133:	6a 00                	push   $0x0
f0102135:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102138:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f010213e:	e8 48 ef ff ff       	call   f010108b <pgdir_walk>
f0102143:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102149:	83 c4 0c             	add    $0xc,%esp
f010214c:	6a 00                	push   $0x0
f010214e:	56                   	push   %esi
f010214f:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0102155:	e8 31 ef ff ff       	call   f010108b <pgdir_walk>
f010215a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102160:	c7 04 24 ac 7c 10 f0 	movl   $0xf0107cac,(%esp)
f0102167:	e8 6e 18 00 00       	call   f01039da <cprintf>
  boot_map_region(kern_pgdir, UPAGES, ROUNDUP(sizeof(struct PageInfo) * npages, PGSIZE), PADDR(pages), (PTE_U|PTE_P));  
f010216c:	a1 a8 3e 53 f0       	mov    0xf0533ea8,%eax
	if ((uint32_t)kva < KERNBASE)
f0102171:	83 c4 10             	add    $0x10,%esp
f0102174:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102179:	0f 86 2c 08 00 00    	jbe    f01029ab <mem_init+0x15b8>
f010217f:	8b 15 a0 3e 53 f0    	mov    0xf0533ea0,%edx
f0102185:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f010218c:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102192:	83 ec 08             	sub    $0x8,%esp
f0102195:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f0102197:	05 00 00 00 10       	add    $0x10000000,%eax
f010219c:	50                   	push   %eax
f010219d:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01021a2:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
f01021a7:	e8 ac ef ff ff       	call   f0101158 <boot_map_region>
  boot_map_region(kern_pgdir, UENVS, ROUNDUP(sizeof(struct Env) * NENV, PGSIZE), PADDR(envs), (PTE_U|PTE_P));  
f01021ac:	a1 48 32 53 f0       	mov    0xf0533248,%eax
	if ((uint32_t)kva < KERNBASE)
f01021b1:	83 c4 10             	add    $0x10,%esp
f01021b4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01021b9:	0f 86 01 08 00 00    	jbe    f01029c0 <mem_init+0x15cd>
f01021bf:	83 ec 08             	sub    $0x8,%esp
f01021c2:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f01021c4:	05 00 00 00 10       	add    $0x10000000,%eax
f01021c9:	50                   	push   %eax
f01021ca:	b9 00 f0 01 00       	mov    $0x1f000,%ecx
f01021cf:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01021d4:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
f01021d9:	e8 7a ef ff ff       	call   f0101158 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f01021de:	83 c4 10             	add    $0x10,%esp
f01021e1:	b8 00 b0 11 f0       	mov    $0xf011b000,%eax
f01021e6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01021eb:	0f 86 e4 07 00 00    	jbe    f01029d5 <mem_init+0x15e2>
  boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, ROUNDUP(KSTKSIZE, PGSIZE), PADDR(bootstack), (PTE_W|PTE_P)); 
f01021f1:	83 ec 08             	sub    $0x8,%esp
f01021f4:	6a 03                	push   $0x3
f01021f6:	68 00 b0 11 00       	push   $0x11b000
f01021fb:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102200:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102205:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
f010220a:	e8 49 ef ff ff       	call   f0101158 <boot_map_region>
  boot_map_region(kern_pgdir, KERNBASE, ROUNDUP(0xffffffff-KERNBASE, PGSIZE), 0, (PTE_W|PTE_P)); 
f010220f:	83 c4 08             	add    $0x8,%esp
f0102212:	6a 03                	push   $0x3
f0102214:	6a 00                	push   $0x0
f0102216:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f010221b:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102220:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
f0102225:	e8 2e ef ff ff       	call   f0101158 <boot_map_region>
f010222a:	c7 45 d0 00 50 53 f0 	movl   $0xf0535000,-0x30(%ebp)
f0102231:	83 c4 10             	add    $0x10,%esp
f0102234:	bb 00 50 53 f0       	mov    $0xf0535000,%ebx
f0102239:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f010223e:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102244:	0f 86 a0 07 00 00    	jbe    f01029ea <mem_init+0x15f7>
    boot_map_region(kern_pgdir, ROUNDDOWN(kstacktop_i-KSTKSIZE,PGSIZE), ROUNDUP(KSTKSIZE, PGSIZE), PADDR(percpu_kstacks + i), (PTE_W|PTE_P));
f010224a:	83 ec 08             	sub    $0x8,%esp
f010224d:	6a 03                	push   $0x3
f010224f:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0102255:	50                   	push   %eax
f0102256:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010225b:	89 f2                	mov    %esi,%edx
f010225d:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
f0102262:	e8 f1 ee ff ff       	call   f0101158 <boot_map_region>
f0102267:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f010226d:	81 ee 00 00 01 00    	sub    $0x10000,%esi
  for (int i = 0; i < NCPU; i++) {
f0102273:	83 c4 10             	add    $0x10,%esp
f0102276:	81 fb 00 50 57 f0    	cmp    $0xf0575000,%ebx
f010227c:	75 c0                	jne    f010223e <mem_init+0xe4b>
	pgdir = kern_pgdir;
f010227e:	8b 3d a4 3e 53 f0    	mov    0xf0533ea4,%edi
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0102284:	a1 a0 3e 53 f0       	mov    0xf0533ea0,%eax
f0102289:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f010228c:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102293:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102298:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010229b:	8b 35 a8 3e 53 f0    	mov    0xf0533ea8,%esi
f01022a1:	89 75 cc             	mov    %esi,-0x34(%ebp)
	return (physaddr_t)kva - KERNBASE;
f01022a4:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01022aa:	89 45 c8             	mov    %eax,-0x38(%ebp)
  for (i = 0; i < n; i += PGSIZE) 
f01022ad:	bb 00 00 00 00       	mov    $0x0,%ebx
f01022b2:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f01022b5:	0f 86 72 07 00 00    	jbe    f0102a2d <mem_init+0x163a>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01022bb:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f01022c1:	89 f8                	mov    %edi,%eax
f01022c3:	e8 3c e8 ff ff       	call   f0100b04 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01022c8:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f01022cf:	0f 86 2a 07 00 00    	jbe    f01029ff <mem_init+0x160c>
f01022d5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01022d8:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f01022db:	39 d0                	cmp    %edx,%eax
f01022dd:	0f 85 31 07 00 00    	jne    f0102a14 <mem_init+0x1621>
  for (i = 0; i < n; i += PGSIZE) 
f01022e3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01022e9:	eb c7                	jmp    f01022b2 <mem_init+0xebf>
	assert(nfree == 0);
f01022eb:	68 c3 7b 10 f0       	push   $0xf0107bc3
f01022f0:	68 ae 79 10 f0       	push   $0xf01079ae
f01022f5:	68 43 03 00 00       	push   $0x343
f01022fa:	68 6d 79 10 f0       	push   $0xf010796d
f01022ff:	e8 3c dd ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102304:	68 d1 7a 10 f0       	push   $0xf0107ad1
f0102309:	68 ae 79 10 f0       	push   $0xf01079ae
f010230e:	68 a9 03 00 00       	push   $0x3a9
f0102313:	68 6d 79 10 f0       	push   $0xf010796d
f0102318:	e8 23 dd ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f010231d:	68 e7 7a 10 f0       	push   $0xf0107ae7
f0102322:	68 ae 79 10 f0       	push   $0xf01079ae
f0102327:	68 aa 03 00 00       	push   $0x3aa
f010232c:	68 6d 79 10 f0       	push   $0xf010796d
f0102331:	e8 0a dd ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102336:	68 fd 7a 10 f0       	push   $0xf0107afd
f010233b:	68 ae 79 10 f0       	push   $0xf01079ae
f0102340:	68 ab 03 00 00       	push   $0x3ab
f0102345:	68 6d 79 10 f0       	push   $0xf010796d
f010234a:	e8 f1 dc ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f010234f:	68 13 7b 10 f0       	push   $0xf0107b13
f0102354:	68 ae 79 10 f0       	push   $0xf01079ae
f0102359:	68 ae 03 00 00       	push   $0x3ae
f010235e:	68 6d 79 10 f0       	push   $0xf010796d
f0102363:	e8 d8 dc ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102368:	68 90 71 10 f0       	push   $0xf0107190
f010236d:	68 ae 79 10 f0       	push   $0xf01079ae
f0102372:	68 af 03 00 00       	push   $0x3af
f0102377:	68 6d 79 10 f0       	push   $0xf010796d
f010237c:	e8 bf dc ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102381:	68 7c 7b 10 f0       	push   $0xf0107b7c
f0102386:	68 ae 79 10 f0       	push   $0xf01079ae
f010238b:	68 b6 03 00 00       	push   $0x3b6
f0102390:	68 6d 79 10 f0       	push   $0xf010796d
f0102395:	e8 a6 dc ff ff       	call   f0100040 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f010239a:	68 d0 71 10 f0       	push   $0xf01071d0
f010239f:	68 ae 79 10 f0       	push   $0xf01079ae
f01023a4:	68 b9 03 00 00       	push   $0x3b9
f01023a9:	68 6d 79 10 f0       	push   $0xf010796d
f01023ae:	e8 8d dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01023b3:	68 08 72 10 f0       	push   $0xf0107208
f01023b8:	68 ae 79 10 f0       	push   $0xf01079ae
f01023bd:	68 bc 03 00 00       	push   $0x3bc
f01023c2:	68 6d 79 10 f0       	push   $0xf010796d
f01023c7:	e8 74 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01023cc:	68 38 72 10 f0       	push   $0xf0107238
f01023d1:	68 ae 79 10 f0       	push   $0xf01079ae
f01023d6:	68 c0 03 00 00       	push   $0x3c0
f01023db:	68 6d 79 10 f0       	push   $0xf010796d
f01023e0:	e8 5b dc ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01023e5:	68 68 72 10 f0       	push   $0xf0107268
f01023ea:	68 ae 79 10 f0       	push   $0xf01079ae
f01023ef:	68 c1 03 00 00       	push   $0x3c1
f01023f4:	68 6d 79 10 f0       	push   $0xf010796d
f01023f9:	e8 42 dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01023fe:	68 90 72 10 f0       	push   $0xf0107290
f0102403:	68 ae 79 10 f0       	push   $0xf01079ae
f0102408:	68 c2 03 00 00       	push   $0x3c2
f010240d:	68 6d 79 10 f0       	push   $0xf010796d
f0102412:	e8 29 dc ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102417:	68 ce 7b 10 f0       	push   $0xf0107bce
f010241c:	68 ae 79 10 f0       	push   $0xf01079ae
f0102421:	68 c3 03 00 00       	push   $0x3c3
f0102426:	68 6d 79 10 f0       	push   $0xf010796d
f010242b:	e8 10 dc ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102430:	68 df 7b 10 f0       	push   $0xf0107bdf
f0102435:	68 ae 79 10 f0       	push   $0xf01079ae
f010243a:	68 c4 03 00 00       	push   $0x3c4
f010243f:	68 6d 79 10 f0       	push   $0xf010796d
f0102444:	e8 f7 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102449:	68 c0 72 10 f0       	push   $0xf01072c0
f010244e:	68 ae 79 10 f0       	push   $0xf01079ae
f0102453:	68 c7 03 00 00       	push   $0x3c7
f0102458:	68 6d 79 10 f0       	push   $0xf010796d
f010245d:	e8 de db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102462:	68 fc 72 10 f0       	push   $0xf01072fc
f0102467:	68 ae 79 10 f0       	push   $0xf01079ae
f010246c:	68 c8 03 00 00       	push   $0x3c8
f0102471:	68 6d 79 10 f0       	push   $0xf010796d
f0102476:	e8 c5 db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010247b:	68 f0 7b 10 f0       	push   $0xf0107bf0
f0102480:	68 ae 79 10 f0       	push   $0xf01079ae
f0102485:	68 c9 03 00 00       	push   $0x3c9
f010248a:	68 6d 79 10 f0       	push   $0xf010796d
f010248f:	e8 ac db ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102494:	68 7c 7b 10 f0       	push   $0xf0107b7c
f0102499:	68 ae 79 10 f0       	push   $0xf01079ae
f010249e:	68 cc 03 00 00       	push   $0x3cc
f01024a3:	68 6d 79 10 f0       	push   $0xf010796d
f01024a8:	e8 93 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01024ad:	68 c0 72 10 f0       	push   $0xf01072c0
f01024b2:	68 ae 79 10 f0       	push   $0xf01079ae
f01024b7:	68 cf 03 00 00       	push   $0x3cf
f01024bc:	68 6d 79 10 f0       	push   $0xf010796d
f01024c1:	e8 7a db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01024c6:	68 fc 72 10 f0       	push   $0xf01072fc
f01024cb:	68 ae 79 10 f0       	push   $0xf01079ae
f01024d0:	68 d0 03 00 00       	push   $0x3d0
f01024d5:	68 6d 79 10 f0       	push   $0xf010796d
f01024da:	e8 61 db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01024df:	68 f0 7b 10 f0       	push   $0xf0107bf0
f01024e4:	68 ae 79 10 f0       	push   $0xf01079ae
f01024e9:	68 d1 03 00 00       	push   $0x3d1
f01024ee:	68 6d 79 10 f0       	push   $0xf010796d
f01024f3:	e8 48 db ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01024f8:	68 7c 7b 10 f0       	push   $0xf0107b7c
f01024fd:	68 ae 79 10 f0       	push   $0xf01079ae
f0102502:	68 d5 03 00 00       	push   $0x3d5
f0102507:	68 6d 79 10 f0       	push   $0xf010796d
f010250c:	e8 2f db ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102511:	50                   	push   %eax
f0102512:	68 44 6a 10 f0       	push   $0xf0106a44
f0102517:	68 d8 03 00 00       	push   $0x3d8
f010251c:	68 6d 79 10 f0       	push   $0xf010796d
f0102521:	e8 1a db ff ff       	call   f0100040 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102526:	68 2c 73 10 f0       	push   $0xf010732c
f010252b:	68 ae 79 10 f0       	push   $0xf01079ae
f0102530:	68 d9 03 00 00       	push   $0x3d9
f0102535:	68 6d 79 10 f0       	push   $0xf010796d
f010253a:	e8 01 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f010253f:	68 6c 73 10 f0       	push   $0xf010736c
f0102544:	68 ae 79 10 f0       	push   $0xf01079ae
f0102549:	68 dc 03 00 00       	push   $0x3dc
f010254e:	68 6d 79 10 f0       	push   $0xf010796d
f0102553:	e8 e8 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102558:	68 fc 72 10 f0       	push   $0xf01072fc
f010255d:	68 ae 79 10 f0       	push   $0xf01079ae
f0102562:	68 dd 03 00 00       	push   $0x3dd
f0102567:	68 6d 79 10 f0       	push   $0xf010796d
f010256c:	e8 cf da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102571:	68 f0 7b 10 f0       	push   $0xf0107bf0
f0102576:	68 ae 79 10 f0       	push   $0xf01079ae
f010257b:	68 de 03 00 00       	push   $0x3de
f0102580:	68 6d 79 10 f0       	push   $0xf010796d
f0102585:	e8 b6 da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f010258a:	68 ac 73 10 f0       	push   $0xf01073ac
f010258f:	68 ae 79 10 f0       	push   $0xf01079ae
f0102594:	68 df 03 00 00       	push   $0x3df
f0102599:	68 6d 79 10 f0       	push   $0xf010796d
f010259e:	e8 9d da ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01025a3:	68 01 7c 10 f0       	push   $0xf0107c01
f01025a8:	68 ae 79 10 f0       	push   $0xf01079ae
f01025ad:	68 e0 03 00 00       	push   $0x3e0
f01025b2:	68 6d 79 10 f0       	push   $0xf010796d
f01025b7:	e8 84 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01025bc:	68 c0 72 10 f0       	push   $0xf01072c0
f01025c1:	68 ae 79 10 f0       	push   $0xf01079ae
f01025c6:	68 e3 03 00 00       	push   $0x3e3
f01025cb:	68 6d 79 10 f0       	push   $0xf010796d
f01025d0:	e8 6b da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01025d5:	68 e0 73 10 f0       	push   $0xf01073e0
f01025da:	68 ae 79 10 f0       	push   $0xf01079ae
f01025df:	68 e4 03 00 00       	push   $0x3e4
f01025e4:	68 6d 79 10 f0       	push   $0xf010796d
f01025e9:	e8 52 da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01025ee:	68 14 74 10 f0       	push   $0xf0107414
f01025f3:	68 ae 79 10 f0       	push   $0xf01079ae
f01025f8:	68 e5 03 00 00       	push   $0x3e5
f01025fd:	68 6d 79 10 f0       	push   $0xf010796d
f0102602:	e8 39 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102607:	68 4c 74 10 f0       	push   $0xf010744c
f010260c:	68 ae 79 10 f0       	push   $0xf01079ae
f0102611:	68 e8 03 00 00       	push   $0x3e8
f0102616:	68 6d 79 10 f0       	push   $0xf010796d
f010261b:	e8 20 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102620:	68 84 74 10 f0       	push   $0xf0107484
f0102625:	68 ae 79 10 f0       	push   $0xf01079ae
f010262a:	68 eb 03 00 00       	push   $0x3eb
f010262f:	68 6d 79 10 f0       	push   $0xf010796d
f0102634:	e8 07 da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102639:	68 14 74 10 f0       	push   $0xf0107414
f010263e:	68 ae 79 10 f0       	push   $0xf01079ae
f0102643:	68 ec 03 00 00       	push   $0x3ec
f0102648:	68 6d 79 10 f0       	push   $0xf010796d
f010264d:	e8 ee d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102652:	68 c0 74 10 f0       	push   $0xf01074c0
f0102657:	68 ae 79 10 f0       	push   $0xf01079ae
f010265c:	68 ef 03 00 00       	push   $0x3ef
f0102661:	68 6d 79 10 f0       	push   $0xf010796d
f0102666:	e8 d5 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010266b:	68 ec 74 10 f0       	push   $0xf01074ec
f0102670:	68 ae 79 10 f0       	push   $0xf01079ae
f0102675:	68 f0 03 00 00       	push   $0x3f0
f010267a:	68 6d 79 10 f0       	push   $0xf010796d
f010267f:	e8 bc d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 2);
f0102684:	68 17 7c 10 f0       	push   $0xf0107c17
f0102689:	68 ae 79 10 f0       	push   $0xf01079ae
f010268e:	68 f2 03 00 00       	push   $0x3f2
f0102693:	68 6d 79 10 f0       	push   $0xf010796d
f0102698:	e8 a3 d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f010269d:	68 28 7c 10 f0       	push   $0xf0107c28
f01026a2:	68 ae 79 10 f0       	push   $0xf01079ae
f01026a7:	68 f3 03 00 00       	push   $0x3f3
f01026ac:	68 6d 79 10 f0       	push   $0xf010796d
f01026b1:	e8 8a d9 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f01026b6:	68 1c 75 10 f0       	push   $0xf010751c
f01026bb:	68 ae 79 10 f0       	push   $0xf01079ae
f01026c0:	68 f6 03 00 00       	push   $0x3f6
f01026c5:	68 6d 79 10 f0       	push   $0xf010796d
f01026ca:	e8 71 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01026cf:	68 40 75 10 f0       	push   $0xf0107540
f01026d4:	68 ae 79 10 f0       	push   $0xf01079ae
f01026d9:	68 fa 03 00 00       	push   $0x3fa
f01026de:	68 6d 79 10 f0       	push   $0xf010796d
f01026e3:	e8 58 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01026e8:	68 ec 74 10 f0       	push   $0xf01074ec
f01026ed:	68 ae 79 10 f0       	push   $0xf01079ae
f01026f2:	68 fb 03 00 00       	push   $0x3fb
f01026f7:	68 6d 79 10 f0       	push   $0xf010796d
f01026fc:	e8 3f d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102701:	68 ce 7b 10 f0       	push   $0xf0107bce
f0102706:	68 ae 79 10 f0       	push   $0xf01079ae
f010270b:	68 fc 03 00 00       	push   $0x3fc
f0102710:	68 6d 79 10 f0       	push   $0xf010796d
f0102715:	e8 26 d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f010271a:	68 28 7c 10 f0       	push   $0xf0107c28
f010271f:	68 ae 79 10 f0       	push   $0xf01079ae
f0102724:	68 fd 03 00 00       	push   $0x3fd
f0102729:	68 6d 79 10 f0       	push   $0xf010796d
f010272e:	e8 0d d9 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102733:	68 64 75 10 f0       	push   $0xf0107564
f0102738:	68 ae 79 10 f0       	push   $0xf01079ae
f010273d:	68 00 04 00 00       	push   $0x400
f0102742:	68 6d 79 10 f0       	push   $0xf010796d
f0102747:	e8 f4 d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f010274c:	68 39 7c 10 f0       	push   $0xf0107c39
f0102751:	68 ae 79 10 f0       	push   $0xf01079ae
f0102756:	68 01 04 00 00       	push   $0x401
f010275b:	68 6d 79 10 f0       	push   $0xf010796d
f0102760:	e8 db d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f0102765:	68 45 7c 10 f0       	push   $0xf0107c45
f010276a:	68 ae 79 10 f0       	push   $0xf01079ae
f010276f:	68 02 04 00 00       	push   $0x402
f0102774:	68 6d 79 10 f0       	push   $0xf010796d
f0102779:	e8 c2 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010277e:	68 40 75 10 f0       	push   $0xf0107540
f0102783:	68 ae 79 10 f0       	push   $0xf01079ae
f0102788:	68 06 04 00 00       	push   $0x406
f010278d:	68 6d 79 10 f0       	push   $0xf010796d
f0102792:	e8 a9 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102797:	68 9c 75 10 f0       	push   $0xf010759c
f010279c:	68 ae 79 10 f0       	push   $0xf01079ae
f01027a1:	68 07 04 00 00       	push   $0x407
f01027a6:	68 6d 79 10 f0       	push   $0xf010796d
f01027ab:	e8 90 d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f01027b0:	68 5a 7c 10 f0       	push   $0xf0107c5a
f01027b5:	68 ae 79 10 f0       	push   $0xf01079ae
f01027ba:	68 08 04 00 00       	push   $0x408
f01027bf:	68 6d 79 10 f0       	push   $0xf010796d
f01027c4:	e8 77 d8 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01027c9:	68 28 7c 10 f0       	push   $0xf0107c28
f01027ce:	68 ae 79 10 f0       	push   $0xf01079ae
f01027d3:	68 09 04 00 00       	push   $0x409
f01027d8:	68 6d 79 10 f0       	push   $0xf010796d
f01027dd:	e8 5e d8 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f01027e2:	68 c4 75 10 f0       	push   $0xf01075c4
f01027e7:	68 ae 79 10 f0       	push   $0xf01079ae
f01027ec:	68 0c 04 00 00       	push   $0x40c
f01027f1:	68 6d 79 10 f0       	push   $0xf010796d
f01027f6:	e8 45 d8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01027fb:	68 7c 7b 10 f0       	push   $0xf0107b7c
f0102800:	68 ae 79 10 f0       	push   $0xf01079ae
f0102805:	68 0f 04 00 00       	push   $0x40f
f010280a:	68 6d 79 10 f0       	push   $0xf010796d
f010280f:	e8 2c d8 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102814:	68 68 72 10 f0       	push   $0xf0107268
f0102819:	68 ae 79 10 f0       	push   $0xf01079ae
f010281e:	68 12 04 00 00       	push   $0x412
f0102823:	68 6d 79 10 f0       	push   $0xf010796d
f0102828:	e8 13 d8 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f010282d:	68 df 7b 10 f0       	push   $0xf0107bdf
f0102832:	68 ae 79 10 f0       	push   $0xf01079ae
f0102837:	68 14 04 00 00       	push   $0x414
f010283c:	68 6d 79 10 f0       	push   $0xf010796d
f0102841:	e8 fa d7 ff ff       	call   f0100040 <_panic>
f0102846:	50                   	push   %eax
f0102847:	68 44 6a 10 f0       	push   $0xf0106a44
f010284c:	68 1b 04 00 00       	push   $0x41b
f0102851:	68 6d 79 10 f0       	push   $0xf010796d
f0102856:	e8 e5 d7 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f010285b:	68 6b 7c 10 f0       	push   $0xf0107c6b
f0102860:	68 ae 79 10 f0       	push   $0xf01079ae
f0102865:	68 1c 04 00 00       	push   $0x41c
f010286a:	68 6d 79 10 f0       	push   $0xf010796d
f010286f:	e8 cc d7 ff ff       	call   f0100040 <_panic>
f0102874:	50                   	push   %eax
f0102875:	68 44 6a 10 f0       	push   $0xf0106a44
f010287a:	6a 58                	push   $0x58
f010287c:	68 94 79 10 f0       	push   $0xf0107994
f0102881:	e8 ba d7 ff ff       	call   f0100040 <_panic>
f0102886:	50                   	push   %eax
f0102887:	68 44 6a 10 f0       	push   $0xf0106a44
f010288c:	6a 58                	push   $0x58
f010288e:	68 94 79 10 f0       	push   $0xf0107994
f0102893:	e8 a8 d7 ff ff       	call   f0100040 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102898:	68 83 7c 10 f0       	push   $0xf0107c83
f010289d:	68 ae 79 10 f0       	push   $0xf01079ae
f01028a2:	68 26 04 00 00       	push   $0x426
f01028a7:	68 6d 79 10 f0       	push   $0xf010796d
f01028ac:	e8 8f d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f01028b1:	68 e8 75 10 f0       	push   $0xf01075e8
f01028b6:	68 ae 79 10 f0       	push   $0xf01079ae
f01028bb:	68 36 04 00 00       	push   $0x436
f01028c0:	68 6d 79 10 f0       	push   $0xf010796d
f01028c5:	e8 76 d7 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f01028ca:	68 10 76 10 f0       	push   $0xf0107610
f01028cf:	68 ae 79 10 f0       	push   $0xf01079ae
f01028d4:	68 37 04 00 00       	push   $0x437
f01028d9:	68 6d 79 10 f0       	push   $0xf010796d
f01028de:	e8 5d d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f01028e3:	68 38 76 10 f0       	push   $0xf0107638
f01028e8:	68 ae 79 10 f0       	push   $0xf01079ae
f01028ed:	68 39 04 00 00       	push   $0x439
f01028f2:	68 6d 79 10 f0       	push   $0xf010796d
f01028f7:	e8 44 d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 + 8192 <= mm2);
f01028fc:	68 9a 7c 10 f0       	push   $0xf0107c9a
f0102901:	68 ae 79 10 f0       	push   $0xf01079ae
f0102906:	68 3b 04 00 00       	push   $0x43b
f010290b:	68 6d 79 10 f0       	push   $0xf010796d
f0102910:	e8 2b d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102915:	68 60 76 10 f0       	push   $0xf0107660
f010291a:	68 ae 79 10 f0       	push   $0xf01079ae
f010291f:	68 3d 04 00 00       	push   $0x43d
f0102924:	68 6d 79 10 f0       	push   $0xf010796d
f0102929:	e8 12 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f010292e:	68 84 76 10 f0       	push   $0xf0107684
f0102933:	68 ae 79 10 f0       	push   $0xf01079ae
f0102938:	68 3e 04 00 00       	push   $0x43e
f010293d:	68 6d 79 10 f0       	push   $0xf010796d
f0102942:	e8 f9 d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102947:	68 b4 76 10 f0       	push   $0xf01076b4
f010294c:	68 ae 79 10 f0       	push   $0xf01079ae
f0102951:	68 3f 04 00 00       	push   $0x43f
f0102956:	68 6d 79 10 f0       	push   $0xf010796d
f010295b:	e8 e0 d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102960:	68 d8 76 10 f0       	push   $0xf01076d8
f0102965:	68 ae 79 10 f0       	push   $0xf01079ae
f010296a:	68 40 04 00 00       	push   $0x440
f010296f:	68 6d 79 10 f0       	push   $0xf010796d
f0102974:	e8 c7 d6 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102979:	68 04 77 10 f0       	push   $0xf0107704
f010297e:	68 ae 79 10 f0       	push   $0xf01079ae
f0102983:	68 42 04 00 00       	push   $0x442
f0102988:	68 6d 79 10 f0       	push   $0xf010796d
f010298d:	e8 ae d6 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102992:	68 48 77 10 f0       	push   $0xf0107748
f0102997:	68 ae 79 10 f0       	push   $0xf01079ae
f010299c:	68 43 04 00 00       	push   $0x443
f01029a1:	68 6d 79 10 f0       	push   $0xf010796d
f01029a6:	e8 95 d6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01029ab:	50                   	push   %eax
f01029ac:	68 68 6a 10 f0       	push   $0xf0106a68
f01029b1:	68 cc 00 00 00       	push   $0xcc
f01029b6:	68 6d 79 10 f0       	push   $0xf010796d
f01029bb:	e8 80 d6 ff ff       	call   f0100040 <_panic>
f01029c0:	50                   	push   %eax
f01029c1:	68 68 6a 10 f0       	push   $0xf0106a68
f01029c6:	68 d6 00 00 00       	push   $0xd6
f01029cb:	68 6d 79 10 f0       	push   $0xf010796d
f01029d0:	e8 6b d6 ff ff       	call   f0100040 <_panic>
f01029d5:	50                   	push   %eax
f01029d6:	68 68 6a 10 f0       	push   $0xf0106a68
f01029db:	68 e3 00 00 00       	push   $0xe3
f01029e0:	68 6d 79 10 f0       	push   $0xf010796d
f01029e5:	e8 56 d6 ff ff       	call   f0100040 <_panic>
f01029ea:	53                   	push   %ebx
f01029eb:	68 68 6a 10 f0       	push   $0xf0106a68
f01029f0:	68 26 01 00 00       	push   $0x126
f01029f5:	68 6d 79 10 f0       	push   $0xf010796d
f01029fa:	e8 41 d6 ff ff       	call   f0100040 <_panic>
f01029ff:	56                   	push   %esi
f0102a00:	68 68 6a 10 f0       	push   $0xf0106a68
f0102a05:	68 5b 03 00 00       	push   $0x35b
f0102a0a:	68 6d 79 10 f0       	push   $0xf010796d
f0102a0f:	e8 2c d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102a14:	68 7c 77 10 f0       	push   $0xf010777c
f0102a19:	68 ae 79 10 f0       	push   $0xf01079ae
f0102a1e:	68 5b 03 00 00       	push   $0x35b
f0102a23:	68 6d 79 10 f0       	push   $0xf010796d
f0102a28:	e8 13 d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102a2d:	a1 48 32 53 f0       	mov    0xf0533248,%eax
f0102a32:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102a35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102a38:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102a3d:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102a43:	89 da                	mov    %ebx,%edx
f0102a45:	89 f8                	mov    %edi,%eax
f0102a47:	e8 b8 e0 ff ff       	call   f0100b04 <check_va2pa>
f0102a4c:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f0102a53:	76 3d                	jbe    f0102a92 <mem_init+0x169f>
f0102a55:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102a58:	39 d0                	cmp    %edx,%eax
f0102a5a:	75 4d                	jne    f0102aa9 <mem_init+0x16b6>
f0102a5c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102a62:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f0102a68:	75 d9                	jne    f0102a43 <mem_init+0x1650>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102a6a:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0102a6d:	c1 e6 0c             	shl    $0xc,%esi
f0102a70:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102a75:	39 f3                	cmp    %esi,%ebx
f0102a77:	73 62                	jae    f0102adb <mem_init+0x16e8>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102a79:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102a7f:	89 f8                	mov    %edi,%eax
f0102a81:	e8 7e e0 ff ff       	call   f0100b04 <check_va2pa>
f0102a86:	39 c3                	cmp    %eax,%ebx
f0102a88:	75 38                	jne    f0102ac2 <mem_init+0x16cf>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102a8a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102a90:	eb e3                	jmp    f0102a75 <mem_init+0x1682>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102a92:	ff 75 cc             	pushl  -0x34(%ebp)
f0102a95:	68 68 6a 10 f0       	push   $0xf0106a68
f0102a9a:	68 60 03 00 00       	push   $0x360
f0102a9f:	68 6d 79 10 f0       	push   $0xf010796d
f0102aa4:	e8 97 d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102aa9:	68 b0 77 10 f0       	push   $0xf01077b0
f0102aae:	68 ae 79 10 f0       	push   $0xf01079ae
f0102ab3:	68 60 03 00 00       	push   $0x360
f0102ab8:	68 6d 79 10 f0       	push   $0xf010796d
f0102abd:	e8 7e d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102ac2:	68 e4 77 10 f0       	push   $0xf01077e4
f0102ac7:	68 ae 79 10 f0       	push   $0xf01079ae
f0102acc:	68 64 03 00 00       	push   $0x364
f0102ad1:	68 6d 79 10 f0       	push   $0xf010796d
f0102ad6:	e8 65 d5 ff ff       	call   f0100040 <_panic>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102adb:	b8 00 50 53 f0       	mov    $0xf0535000,%eax
f0102ae0:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102ae5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0102ae8:	89 c7                	mov    %eax,%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102aea:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f0102aed:	89 f3                	mov    %esi,%ebx
f0102aef:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102af2:	05 00 80 00 20       	add    $0x20008000,%eax
f0102af7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102afa:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0102b00:	89 45 c8             	mov    %eax,-0x38(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102b03:	89 da                	mov    %ebx,%edx
f0102b05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b08:	e8 f7 df ff ff       	call   f0100b04 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102b0d:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f0102b13:	76 59                	jbe    f0102b6e <mem_init+0x177b>
f0102b15:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102b18:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f0102b1b:	39 d0                	cmp    %edx,%eax
f0102b1d:	75 66                	jne    f0102b85 <mem_init+0x1792>
f0102b1f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102b25:	3b 5d c8             	cmp    -0x38(%ebp),%ebx
f0102b28:	75 d9                	jne    f0102b03 <mem_init+0x1710>
f0102b2a:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102b30:	89 da                	mov    %ebx,%edx
f0102b32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b35:	e8 ca df ff ff       	call   f0100b04 <check_va2pa>
f0102b3a:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102b3d:	75 5f                	jne    f0102b9e <mem_init+0x17ab>
f0102b3f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102b45:	39 f3                	cmp    %esi,%ebx
f0102b47:	75 e7                	jne    f0102b30 <mem_init+0x173d>
f0102b49:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102b4f:	81 45 d0 00 80 01 00 	addl   $0x18000,-0x30(%ebp)
f0102b56:	81 c7 00 80 00 00    	add    $0x8000,%edi
	for (n = 0; n < NCPU; n++) {
f0102b5c:	81 ff 00 50 57 f0    	cmp    $0xf0575000,%edi
f0102b62:	75 86                	jne    f0102aea <mem_init+0x16f7>
f0102b64:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	for (i = 0; i < NPDENTRIES; i++) {
f0102b67:	b8 00 00 00 00       	mov    $0x0,%eax
f0102b6c:	eb 7f                	jmp    f0102bed <mem_init+0x17fa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102b6e:	ff 75 c4             	pushl  -0x3c(%ebp)
f0102b71:	68 68 6a 10 f0       	push   $0xf0106a68
f0102b76:	68 6c 03 00 00       	push   $0x36c
f0102b7b:	68 6d 79 10 f0       	push   $0xf010796d
f0102b80:	e8 bb d4 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102b85:	68 0c 78 10 f0       	push   $0xf010780c
f0102b8a:	68 ae 79 10 f0       	push   $0xf01079ae
f0102b8f:	68 6c 03 00 00       	push   $0x36c
f0102b94:	68 6d 79 10 f0       	push   $0xf010796d
f0102b99:	e8 a2 d4 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102b9e:	68 54 78 10 f0       	push   $0xf0107854
f0102ba3:	68 ae 79 10 f0       	push   $0xf01079ae
f0102ba8:	68 6e 03 00 00       	push   $0x36e
f0102bad:	68 6d 79 10 f0       	push   $0xf010796d
f0102bb2:	e8 89 d4 ff ff       	call   f0100040 <_panic>
			assert(pgdir[i] & PTE_P);
f0102bb7:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f0102bbb:	75 48                	jne    f0102c05 <mem_init+0x1812>
f0102bbd:	68 c5 7c 10 f0       	push   $0xf0107cc5
f0102bc2:	68 ae 79 10 f0       	push   $0xf01079ae
f0102bc7:	68 79 03 00 00       	push   $0x379
f0102bcc:	68 6d 79 10 f0       	push   $0xf010796d
f0102bd1:	e8 6a d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102bd6:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0102bd9:	f6 c2 01             	test   $0x1,%dl
f0102bdc:	74 2c                	je     f0102c0a <mem_init+0x1817>
				assert(pgdir[i] & PTE_W);
f0102bde:	f6 c2 02             	test   $0x2,%dl
f0102be1:	74 40                	je     f0102c23 <mem_init+0x1830>
	for (i = 0; i < NPDENTRIES; i++) {
f0102be3:	83 c0 01             	add    $0x1,%eax
f0102be6:	3d 00 04 00 00       	cmp    $0x400,%eax
f0102beb:	74 68                	je     f0102c55 <mem_init+0x1862>
		switch (i) {
f0102bed:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0102bf3:	83 fa 04             	cmp    $0x4,%edx
f0102bf6:	76 bf                	jbe    f0102bb7 <mem_init+0x17c4>
			if (i >= PDX(KERNBASE)) {
f0102bf8:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0102bfd:	77 d7                	ja     f0102bd6 <mem_init+0x17e3>
				assert(pgdir[i] == 0);
f0102bff:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0102c03:	75 37                	jne    f0102c3c <mem_init+0x1849>
	for (i = 0; i < NPDENTRIES; i++) {
f0102c05:	83 c0 01             	add    $0x1,%eax
f0102c08:	eb e3                	jmp    f0102bed <mem_init+0x17fa>
				assert(pgdir[i] & PTE_P);
f0102c0a:	68 c5 7c 10 f0       	push   $0xf0107cc5
f0102c0f:	68 ae 79 10 f0       	push   $0xf01079ae
f0102c14:	68 7d 03 00 00       	push   $0x37d
f0102c19:	68 6d 79 10 f0       	push   $0xf010796d
f0102c1e:	e8 1d d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_W);
f0102c23:	68 d6 7c 10 f0       	push   $0xf0107cd6
f0102c28:	68 ae 79 10 f0       	push   $0xf01079ae
f0102c2d:	68 7e 03 00 00       	push   $0x37e
f0102c32:	68 6d 79 10 f0       	push   $0xf010796d
f0102c37:	e8 04 d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] == 0);
f0102c3c:	68 e7 7c 10 f0       	push   $0xf0107ce7
f0102c41:	68 ae 79 10 f0       	push   $0xf01079ae
f0102c46:	68 80 03 00 00       	push   $0x380
f0102c4b:	68 6d 79 10 f0       	push   $0xf010796d
f0102c50:	e8 eb d3 ff ff       	call   f0100040 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102c55:	83 ec 0c             	sub    $0xc,%esp
f0102c58:	68 78 78 10 f0       	push   $0xf0107878
f0102c5d:	e8 78 0d 00 00       	call   f01039da <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102c62:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
	if ((uint32_t)kva < KERNBASE)
f0102c67:	83 c4 10             	add    $0x10,%esp
f0102c6a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102c6f:	0f 86 fb 01 00 00    	jbe    f0102e70 <mem_init+0x1a7d>
	return (physaddr_t)kva - KERNBASE;
f0102c75:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102c7a:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102c7d:	b8 00 00 00 00       	mov    $0x0,%eax
f0102c82:	e8 63 df ff ff       	call   f0100bea <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102c87:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102c8a:	83 e0 f3             	and    $0xfffffff3,%eax
f0102c8d:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102c92:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102c95:	83 ec 0c             	sub    $0xc,%esp
f0102c98:	6a 00                	push   $0x0
f0102c9a:	e8 16 e3 ff ff       	call   f0100fb5 <page_alloc>
f0102c9f:	89 c6                	mov    %eax,%esi
f0102ca1:	83 c4 10             	add    $0x10,%esp
f0102ca4:	85 c0                	test   %eax,%eax
f0102ca6:	0f 84 d9 01 00 00    	je     f0102e85 <mem_init+0x1a92>
	assert((pp1 = page_alloc(0)));
f0102cac:	83 ec 0c             	sub    $0xc,%esp
f0102caf:	6a 00                	push   $0x0
f0102cb1:	e8 ff e2 ff ff       	call   f0100fb5 <page_alloc>
f0102cb6:	89 c7                	mov    %eax,%edi
f0102cb8:	83 c4 10             	add    $0x10,%esp
f0102cbb:	85 c0                	test   %eax,%eax
f0102cbd:	0f 84 db 01 00 00    	je     f0102e9e <mem_init+0x1aab>
	assert((pp2 = page_alloc(0)));
f0102cc3:	83 ec 0c             	sub    $0xc,%esp
f0102cc6:	6a 00                	push   $0x0
f0102cc8:	e8 e8 e2 ff ff       	call   f0100fb5 <page_alloc>
f0102ccd:	89 c3                	mov    %eax,%ebx
f0102ccf:	83 c4 10             	add    $0x10,%esp
f0102cd2:	85 c0                	test   %eax,%eax
f0102cd4:	0f 84 dd 01 00 00    	je     f0102eb7 <mem_init+0x1ac4>
	page_free(pp0);
f0102cda:	83 ec 0c             	sub    $0xc,%esp
f0102cdd:	56                   	push   %esi
f0102cde:	e8 44 e3 ff ff       	call   f0101027 <page_free>
	return (pp - pages) << PGSHIFT;
f0102ce3:	89 f8                	mov    %edi,%eax
f0102ce5:	2b 05 a8 3e 53 f0    	sub    0xf0533ea8,%eax
f0102ceb:	c1 f8 03             	sar    $0x3,%eax
f0102cee:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102cf1:	89 c2                	mov    %eax,%edx
f0102cf3:	c1 ea 0c             	shr    $0xc,%edx
f0102cf6:	83 c4 10             	add    $0x10,%esp
f0102cf9:	3b 15 a0 3e 53 f0    	cmp    0xf0533ea0,%edx
f0102cff:	0f 83 cb 01 00 00    	jae    f0102ed0 <mem_init+0x1add>
	memset(page2kva(pp1), 1, PGSIZE);
f0102d05:	83 ec 04             	sub    $0x4,%esp
f0102d08:	68 00 10 00 00       	push   $0x1000
f0102d0d:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102d0f:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102d14:	50                   	push   %eax
f0102d15:	e8 45 2b 00 00       	call   f010585f <memset>
	return (pp - pages) << PGSHIFT;
f0102d1a:	89 d8                	mov    %ebx,%eax
f0102d1c:	2b 05 a8 3e 53 f0    	sub    0xf0533ea8,%eax
f0102d22:	c1 f8 03             	sar    $0x3,%eax
f0102d25:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102d28:	89 c2                	mov    %eax,%edx
f0102d2a:	c1 ea 0c             	shr    $0xc,%edx
f0102d2d:	83 c4 10             	add    $0x10,%esp
f0102d30:	3b 15 a0 3e 53 f0    	cmp    0xf0533ea0,%edx
f0102d36:	0f 83 a6 01 00 00    	jae    f0102ee2 <mem_init+0x1aef>
	memset(page2kva(pp2), 2, PGSIZE);
f0102d3c:	83 ec 04             	sub    $0x4,%esp
f0102d3f:	68 00 10 00 00       	push   $0x1000
f0102d44:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102d46:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102d4b:	50                   	push   %eax
f0102d4c:	e8 0e 2b 00 00       	call   f010585f <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102d51:	6a 02                	push   $0x2
f0102d53:	68 00 10 00 00       	push   $0x1000
f0102d58:	57                   	push   %edi
f0102d59:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0102d5f:	e8 a7 e5 ff ff       	call   f010130b <page_insert>
	assert(pp1->pp_ref == 1);
f0102d64:	83 c4 20             	add    $0x20,%esp
f0102d67:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102d6c:	0f 85 82 01 00 00    	jne    f0102ef4 <mem_init+0x1b01>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102d72:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102d79:	01 01 01 
f0102d7c:	0f 85 8b 01 00 00    	jne    f0102f0d <mem_init+0x1b1a>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102d82:	6a 02                	push   $0x2
f0102d84:	68 00 10 00 00       	push   $0x1000
f0102d89:	53                   	push   %ebx
f0102d8a:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0102d90:	e8 76 e5 ff ff       	call   f010130b <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102d95:	83 c4 10             	add    $0x10,%esp
f0102d98:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102d9f:	02 02 02 
f0102da2:	0f 85 7e 01 00 00    	jne    f0102f26 <mem_init+0x1b33>
	assert(pp2->pp_ref == 1);
f0102da8:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102dad:	0f 85 8c 01 00 00    	jne    f0102f3f <mem_init+0x1b4c>
	assert(pp1->pp_ref == 0);
f0102db3:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102db8:	0f 85 9a 01 00 00    	jne    f0102f58 <mem_init+0x1b65>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102dbe:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102dc5:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102dc8:	89 d8                	mov    %ebx,%eax
f0102dca:	2b 05 a8 3e 53 f0    	sub    0xf0533ea8,%eax
f0102dd0:	c1 f8 03             	sar    $0x3,%eax
f0102dd3:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102dd6:	89 c2                	mov    %eax,%edx
f0102dd8:	c1 ea 0c             	shr    $0xc,%edx
f0102ddb:	3b 15 a0 3e 53 f0    	cmp    0xf0533ea0,%edx
f0102de1:	0f 83 8a 01 00 00    	jae    f0102f71 <mem_init+0x1b7e>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102de7:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0102dee:	03 03 03 
f0102df1:	0f 85 8c 01 00 00    	jne    f0102f83 <mem_init+0x1b90>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102df7:	83 ec 08             	sub    $0x8,%esp
f0102dfa:	68 00 10 00 00       	push   $0x1000
f0102dff:	ff 35 a4 3e 53 f0    	pushl  0xf0533ea4
f0102e05:	e8 bb e4 ff ff       	call   f01012c5 <page_remove>
	assert(pp2->pp_ref == 0);
f0102e0a:	83 c4 10             	add    $0x10,%esp
f0102e0d:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102e12:	0f 85 84 01 00 00    	jne    f0102f9c <mem_init+0x1ba9>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102e18:	8b 0d a4 3e 53 f0    	mov    0xf0533ea4,%ecx
f0102e1e:	8b 11                	mov    (%ecx),%edx
f0102e20:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102e26:	89 f0                	mov    %esi,%eax
f0102e28:	2b 05 a8 3e 53 f0    	sub    0xf0533ea8,%eax
f0102e2e:	c1 f8 03             	sar    $0x3,%eax
f0102e31:	c1 e0 0c             	shl    $0xc,%eax
f0102e34:	39 c2                	cmp    %eax,%edx
f0102e36:	0f 85 79 01 00 00    	jne    f0102fb5 <mem_init+0x1bc2>
	kern_pgdir[0] = 0;
f0102e3c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102e42:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102e47:	0f 85 81 01 00 00    	jne    f0102fce <mem_init+0x1bdb>
	pp0->pp_ref = 0;
f0102e4d:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0102e53:	83 ec 0c             	sub    $0xc,%esp
f0102e56:	56                   	push   %esi
f0102e57:	e8 cb e1 ff ff       	call   f0101027 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102e5c:	c7 04 24 0c 79 10 f0 	movl   $0xf010790c,(%esp)
f0102e63:	e8 72 0b 00 00       	call   f01039da <cprintf>
}
f0102e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102e6b:	5b                   	pop    %ebx
f0102e6c:	5e                   	pop    %esi
f0102e6d:	5f                   	pop    %edi
f0102e6e:	5d                   	pop    %ebp
f0102e6f:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102e70:	50                   	push   %eax
f0102e71:	68 68 6a 10 f0       	push   $0xf0106a68
f0102e76:	68 fd 00 00 00       	push   $0xfd
f0102e7b:	68 6d 79 10 f0       	push   $0xf010796d
f0102e80:	e8 bb d1 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102e85:	68 d1 7a 10 f0       	push   $0xf0107ad1
f0102e8a:	68 ae 79 10 f0       	push   $0xf01079ae
f0102e8f:	68 58 04 00 00       	push   $0x458
f0102e94:	68 6d 79 10 f0       	push   $0xf010796d
f0102e99:	e8 a2 d1 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0102e9e:	68 e7 7a 10 f0       	push   $0xf0107ae7
f0102ea3:	68 ae 79 10 f0       	push   $0xf01079ae
f0102ea8:	68 59 04 00 00       	push   $0x459
f0102ead:	68 6d 79 10 f0       	push   $0xf010796d
f0102eb2:	e8 89 d1 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102eb7:	68 fd 7a 10 f0       	push   $0xf0107afd
f0102ebc:	68 ae 79 10 f0       	push   $0xf01079ae
f0102ec1:	68 5a 04 00 00       	push   $0x45a
f0102ec6:	68 6d 79 10 f0       	push   $0xf010796d
f0102ecb:	e8 70 d1 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102ed0:	50                   	push   %eax
f0102ed1:	68 44 6a 10 f0       	push   $0xf0106a44
f0102ed6:	6a 58                	push   $0x58
f0102ed8:	68 94 79 10 f0       	push   $0xf0107994
f0102edd:	e8 5e d1 ff ff       	call   f0100040 <_panic>
f0102ee2:	50                   	push   %eax
f0102ee3:	68 44 6a 10 f0       	push   $0xf0106a44
f0102ee8:	6a 58                	push   $0x58
f0102eea:	68 94 79 10 f0       	push   $0xf0107994
f0102eef:	e8 4c d1 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102ef4:	68 ce 7b 10 f0       	push   $0xf0107bce
f0102ef9:	68 ae 79 10 f0       	push   $0xf01079ae
f0102efe:	68 5f 04 00 00       	push   $0x45f
f0102f03:	68 6d 79 10 f0       	push   $0xf010796d
f0102f08:	e8 33 d1 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102f0d:	68 98 78 10 f0       	push   $0xf0107898
f0102f12:	68 ae 79 10 f0       	push   $0xf01079ae
f0102f17:	68 60 04 00 00       	push   $0x460
f0102f1c:	68 6d 79 10 f0       	push   $0xf010796d
f0102f21:	e8 1a d1 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102f26:	68 bc 78 10 f0       	push   $0xf01078bc
f0102f2b:	68 ae 79 10 f0       	push   $0xf01079ae
f0102f30:	68 62 04 00 00       	push   $0x462
f0102f35:	68 6d 79 10 f0       	push   $0xf010796d
f0102f3a:	e8 01 d1 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102f3f:	68 f0 7b 10 f0       	push   $0xf0107bf0
f0102f44:	68 ae 79 10 f0       	push   $0xf01079ae
f0102f49:	68 63 04 00 00       	push   $0x463
f0102f4e:	68 6d 79 10 f0       	push   $0xf010796d
f0102f53:	e8 e8 d0 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102f58:	68 5a 7c 10 f0       	push   $0xf0107c5a
f0102f5d:	68 ae 79 10 f0       	push   $0xf01079ae
f0102f62:	68 64 04 00 00       	push   $0x464
f0102f67:	68 6d 79 10 f0       	push   $0xf010796d
f0102f6c:	e8 cf d0 ff ff       	call   f0100040 <_panic>
f0102f71:	50                   	push   %eax
f0102f72:	68 44 6a 10 f0       	push   $0xf0106a44
f0102f77:	6a 58                	push   $0x58
f0102f79:	68 94 79 10 f0       	push   $0xf0107994
f0102f7e:	e8 bd d0 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102f83:	68 e0 78 10 f0       	push   $0xf01078e0
f0102f88:	68 ae 79 10 f0       	push   $0xf01079ae
f0102f8d:	68 66 04 00 00       	push   $0x466
f0102f92:	68 6d 79 10 f0       	push   $0xf010796d
f0102f97:	e8 a4 d0 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102f9c:	68 28 7c 10 f0       	push   $0xf0107c28
f0102fa1:	68 ae 79 10 f0       	push   $0xf01079ae
f0102fa6:	68 68 04 00 00       	push   $0x468
f0102fab:	68 6d 79 10 f0       	push   $0xf010796d
f0102fb0:	e8 8b d0 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102fb5:	68 68 72 10 f0       	push   $0xf0107268
f0102fba:	68 ae 79 10 f0       	push   $0xf01079ae
f0102fbf:	68 6b 04 00 00       	push   $0x46b
f0102fc4:	68 6d 79 10 f0       	push   $0xf010796d
f0102fc9:	e8 72 d0 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102fce:	68 df 7b 10 f0       	push   $0xf0107bdf
f0102fd3:	68 ae 79 10 f0       	push   $0xf01079ae
f0102fd8:	68 6d 04 00 00       	push   $0x46d
f0102fdd:	68 6d 79 10 f0       	push   $0xf010796d
f0102fe2:	e8 59 d0 ff ff       	call   f0100040 <_panic>

f0102fe7 <user_mem_check>:
{
f0102fe7:	55                   	push   %ebp
f0102fe8:	89 e5                	mov    %esp,%ebp
f0102fea:	57                   	push   %edi
f0102feb:	56                   	push   %esi
f0102fec:	53                   	push   %ebx
f0102fed:	83 ec 1c             	sub    $0x1c,%esp
  perm = perm | PTE_P;
f0102ff0:	8b 75 14             	mov    0x14(%ebp),%esi
f0102ff3:	83 ce 01             	or     $0x1,%esi
  if (va+len >= (void*)ULIM) {
f0102ff6:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0102ff9:	03 7d 10             	add    0x10(%ebp),%edi
f0102ffc:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0103002:	77 1c                	ja     f0103020 <user_mem_check+0x39>
    void *start = (void*)ROUNDDOWN(va, PGSIZE);
f0103004:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103007:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010300a:	89 c3                	mov    %eax,%ebx
f010300c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    void *end = (void*)ROUNDUP(va + len, PGSIZE);
f0103012:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
f0103018:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    for (; start < end; start += PGSIZE) {
f010301e:	eb 15                	jmp    f0103035 <user_mem_check+0x4e>
    user_mem_check_addr = (uintptr_t)va;
f0103020:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103023:	a3 3c 32 53 f0       	mov    %eax,0xf053323c
    return -E_FAULT;
f0103028:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f010302d:	eb 3c                	jmp    f010306b <user_mem_check+0x84>
    for (; start < end; start += PGSIZE) {
f010302f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103035:	39 fb                	cmp    %edi,%ebx
f0103037:	73 3a                	jae    f0103073 <user_mem_check+0x8c>
      pte_t *pte_ptr = pgdir_walk(env->env_pgdir, start, false);
f0103039:	83 ec 04             	sub    $0x4,%esp
f010303c:	6a 00                	push   $0x0
f010303e:	53                   	push   %ebx
f010303f:	8b 45 08             	mov    0x8(%ebp),%eax
f0103042:	ff 70 60             	pushl  0x60(%eax)
f0103045:	e8 41 e0 ff ff       	call   f010108b <pgdir_walk>
      if (pte_ptr == NULL || ((*pte_ptr & perm) != perm)) {
f010304a:	83 c4 10             	add    $0x10,%esp
f010304d:	85 c0                	test   %eax,%eax
f010304f:	74 08                	je     f0103059 <user_mem_check+0x72>
f0103051:	89 f2                	mov    %esi,%edx
f0103053:	23 10                	and    (%eax),%edx
f0103055:	39 d6                	cmp    %edx,%esi
f0103057:	74 d6                	je     f010302f <user_mem_check+0x48>
        user_mem_check_addr = (uintptr_t)(start < va ? va : start);
f0103059:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f010305c:	0f 42 5d e4          	cmovb  -0x1c(%ebp),%ebx
f0103060:	89 1d 3c 32 53 f0    	mov    %ebx,0xf053323c
        return -E_FAULT;
f0103066:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f010306b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010306e:	5b                   	pop    %ebx
f010306f:	5e                   	pop    %esi
f0103070:	5f                   	pop    %edi
f0103071:	5d                   	pop    %ebp
f0103072:	c3                   	ret    
	return 0;
f0103073:	b8 00 00 00 00       	mov    $0x0,%eax
f0103078:	eb f1                	jmp    f010306b <user_mem_check+0x84>

f010307a <user_mem_assert>:
{
f010307a:	55                   	push   %ebp
f010307b:	89 e5                	mov    %esp,%ebp
f010307d:	53                   	push   %ebx
f010307e:	83 ec 04             	sub    $0x4,%esp
f0103081:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103084:	8b 45 14             	mov    0x14(%ebp),%eax
f0103087:	83 c8 04             	or     $0x4,%eax
f010308a:	50                   	push   %eax
f010308b:	ff 75 10             	pushl  0x10(%ebp)
f010308e:	ff 75 0c             	pushl  0xc(%ebp)
f0103091:	53                   	push   %ebx
f0103092:	e8 50 ff ff ff       	call   f0102fe7 <user_mem_check>
f0103097:	83 c4 10             	add    $0x10,%esp
f010309a:	85 c0                	test   %eax,%eax
f010309c:	78 05                	js     f01030a3 <user_mem_assert+0x29>
}
f010309e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01030a1:	c9                   	leave  
f01030a2:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f01030a3:	83 ec 04             	sub    $0x4,%esp
f01030a6:	ff 35 3c 32 53 f0    	pushl  0xf053323c
f01030ac:	ff 73 48             	pushl  0x48(%ebx)
f01030af:	68 38 79 10 f0       	push   $0xf0107938
f01030b4:	e8 21 09 00 00       	call   f01039da <cprintf>
		env_destroy(env);	// may not return
f01030b9:	89 1c 24             	mov    %ebx,(%esp)
f01030bc:	e8 40 06 00 00       	call   f0103701 <env_destroy>
f01030c1:	83 c4 10             	add    $0x10,%esp
}
f01030c4:	eb d8                	jmp    f010309e <user_mem_assert+0x24>

f01030c6 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f01030c6:	55                   	push   %ebp
f01030c7:	89 e5                	mov    %esp,%ebp
f01030c9:	57                   	push   %edi
f01030ca:	56                   	push   %esi
f01030cb:	53                   	push   %ebx
f01030cc:	83 ec 0c             	sub    $0xc,%esp
f01030cf:	89 c7                	mov    %eax,%edi
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
  void *end = ROUNDUP(va+len, PGSIZE);
f01030d1:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f01030d8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  void *start = ROUNDDOWN(va, PGSIZE);
f01030de:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01030e4:	89 d3                	mov    %edx,%ebx
  for (; start < end; start += PGSIZE) {
f01030e6:	39 f3                	cmp    %esi,%ebx
f01030e8:	73 3f                	jae    f0103129 <region_alloc+0x63>
    struct PageInfo *p = page_alloc(~ALLOC_ZERO);
f01030ea:	83 ec 0c             	sub    $0xc,%esp
f01030ed:	6a fe                	push   $0xfffffffe
f01030ef:	e8 c1 de ff ff       	call   f0100fb5 <page_alloc>
    if (!p) panic("region_alloc: alloc filled.");
f01030f4:	83 c4 10             	add    $0x10,%esp
f01030f7:	85 c0                	test   %eax,%eax
f01030f9:	74 17                	je     f0103112 <region_alloc+0x4c>

    page_insert(e->env_pgdir, p, start, PTE_U|PTE_W);
f01030fb:	6a 06                	push   $0x6
f01030fd:	53                   	push   %ebx
f01030fe:	50                   	push   %eax
f01030ff:	ff 77 60             	pushl  0x60(%edi)
f0103102:	e8 04 e2 ff ff       	call   f010130b <page_insert>
  for (; start < end; start += PGSIZE) {
f0103107:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010310d:	83 c4 10             	add    $0x10,%esp
f0103110:	eb d4                	jmp    f01030e6 <region_alloc+0x20>
    if (!p) panic("region_alloc: alloc filled.");
f0103112:	83 ec 04             	sub    $0x4,%esp
f0103115:	68 f5 7c 10 f0       	push   $0xf0107cf5
f010311a:	68 2d 01 00 00       	push   $0x12d
f010311f:	68 11 7d 10 f0       	push   $0xf0107d11
f0103124:	e8 17 cf ff ff       	call   f0100040 <_panic>
  }
  
}
f0103129:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010312c:	5b                   	pop    %ebx
f010312d:	5e                   	pop    %esi
f010312e:	5f                   	pop    %edi
f010312f:	5d                   	pop    %ebp
f0103130:	c3                   	ret    

f0103131 <envid2env>:
{
f0103131:	55                   	push   %ebp
f0103132:	89 e5                	mov    %esp,%ebp
f0103134:	56                   	push   %esi
f0103135:	53                   	push   %ebx
f0103136:	8b 45 08             	mov    0x8(%ebp),%eax
f0103139:	8b 55 10             	mov    0x10(%ebp),%edx
	if (envid == 0) {
f010313c:	85 c0                	test   %eax,%eax
f010313e:	74 2e                	je     f010316e <envid2env+0x3d>
	e = &envs[ENVX(envid)];
f0103140:	89 c3                	mov    %eax,%ebx
f0103142:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103148:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f010314b:	03 1d 48 32 53 f0    	add    0xf0533248,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103151:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103155:	74 31                	je     f0103188 <envid2env+0x57>
f0103157:	39 43 48             	cmp    %eax,0x48(%ebx)
f010315a:	75 2c                	jne    f0103188 <envid2env+0x57>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010315c:	84 d2                	test   %dl,%dl
f010315e:	75 38                	jne    f0103198 <envid2env+0x67>
	*env_store = e;
f0103160:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103163:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103165:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010316a:	5b                   	pop    %ebx
f010316b:	5e                   	pop    %esi
f010316c:	5d                   	pop    %ebp
f010316d:	c3                   	ret    
		*env_store = curenv;
f010316e:	e8 eb 2c 00 00       	call   f0105e5e <cpunum>
f0103173:	6b c0 74             	imul   $0x74,%eax,%eax
f0103176:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f010317c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010317f:	89 01                	mov    %eax,(%ecx)
		return 0;
f0103181:	b8 00 00 00 00       	mov    $0x0,%eax
f0103186:	eb e2                	jmp    f010316a <envid2env+0x39>
		*env_store = 0;
f0103188:	8b 45 0c             	mov    0xc(%ebp),%eax
f010318b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103191:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103196:	eb d2                	jmp    f010316a <envid2env+0x39>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103198:	e8 c1 2c 00 00       	call   f0105e5e <cpunum>
f010319d:	6b c0 74             	imul   $0x74,%eax,%eax
f01031a0:	39 98 28 40 53 f0    	cmp    %ebx,-0xfacbfd8(%eax)
f01031a6:	74 b8                	je     f0103160 <envid2env+0x2f>
f01031a8:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01031ab:	e8 ae 2c 00 00       	call   f0105e5e <cpunum>
f01031b0:	6b c0 74             	imul   $0x74,%eax,%eax
f01031b3:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f01031b9:	3b 70 48             	cmp    0x48(%eax),%esi
f01031bc:	74 a2                	je     f0103160 <envid2env+0x2f>
		*env_store = 0;
f01031be:	8b 45 0c             	mov    0xc(%ebp),%eax
f01031c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01031c7:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01031cc:	eb 9c                	jmp    f010316a <envid2env+0x39>

f01031ce <env_init_percpu>:
	asm volatile("lgdt (%0)" : : "r" (p));
f01031ce:	b8 20 53 12 f0       	mov    $0xf0125320,%eax
f01031d3:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f01031d6:	b8 23 00 00 00       	mov    $0x23,%eax
f01031db:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f01031dd:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f01031df:	b8 10 00 00 00       	mov    $0x10,%eax
f01031e4:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f01031e6:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f01031e8:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f01031ea:	ea f1 31 10 f0 08 00 	ljmp   $0x8,$0xf01031f1
	asm volatile("lldt %0" : : "r" (sel));
f01031f1:	b8 00 00 00 00       	mov    $0x0,%eax
f01031f6:	0f 00 d0             	lldt   %ax
}
f01031f9:	c3                   	ret    

f01031fa <env_init>:
{
f01031fa:	55                   	push   %ebp
f01031fb:	89 e5                	mov    %esp,%ebp
f01031fd:	56                   	push   %esi
f01031fe:	53                   	push   %ebx
    envs[i].env_status = ENV_FREE;
f01031ff:	8b 35 48 32 53 f0    	mov    0xf0533248,%esi
f0103205:	8b 15 4c 32 53 f0    	mov    0xf053324c,%edx
f010320b:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
f0103211:	89 f3                	mov    %esi,%ebx
f0103213:	eb 02                	jmp    f0103217 <env_init+0x1d>
f0103215:	89 c8                	mov    %ecx,%eax
f0103217:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
    envs[i].env_id = 0;
f010321e:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
    envs[i].env_link = env_free_list;
f0103225:	89 50 44             	mov    %edx,0x44(%eax)
f0103228:	8d 48 84             	lea    -0x7c(%eax),%ecx
    env_free_list = &envs[i]; 
f010322b:	89 c2                	mov    %eax,%edx
  for (int i = NENV-1; i >= 0; i--) {
f010322d:	39 d8                	cmp    %ebx,%eax
f010322f:	75 e4                	jne    f0103215 <env_init+0x1b>
f0103231:	89 35 4c 32 53 f0    	mov    %esi,0xf053324c
	env_init_percpu();
f0103237:	e8 92 ff ff ff       	call   f01031ce <env_init_percpu>
}
f010323c:	5b                   	pop    %ebx
f010323d:	5e                   	pop    %esi
f010323e:	5d                   	pop    %ebp
f010323f:	c3                   	ret    

f0103240 <env_alloc>:
{
f0103240:	55                   	push   %ebp
f0103241:	89 e5                	mov    %esp,%ebp
f0103243:	56                   	push   %esi
f0103244:	53                   	push   %ebx
	if (!(e = env_free_list))
f0103245:	8b 1d 4c 32 53 f0    	mov    0xf053324c,%ebx
f010324b:	85 db                	test   %ebx,%ebx
f010324d:	0f 84 69 01 00 00    	je     f01033bc <env_alloc+0x17c>
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103253:	83 ec 0c             	sub    $0xc,%esp
f0103256:	6a 01                	push   $0x1
f0103258:	e8 58 dd ff ff       	call   f0100fb5 <page_alloc>
f010325d:	89 c6                	mov    %eax,%esi
f010325f:	83 c4 10             	add    $0x10,%esp
f0103262:	85 c0                	test   %eax,%eax
f0103264:	0f 84 59 01 00 00    	je     f01033c3 <env_alloc+0x183>
  ++p->pp_ref;
f010326a:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
  memcpy(page2kva(p), kern_pgdir, PGSIZE);
f010326f:	8b 15 a4 3e 53 f0    	mov    0xf0533ea4,%edx
	return (pp - pages) << PGSHIFT;
f0103275:	2b 05 a8 3e 53 f0    	sub    0xf0533ea8,%eax
f010327b:	c1 f8 03             	sar    $0x3,%eax
f010327e:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103281:	89 c1                	mov    %eax,%ecx
f0103283:	c1 e9 0c             	shr    $0xc,%ecx
f0103286:	3b 0d a0 3e 53 f0    	cmp    0xf0533ea0,%ecx
f010328c:	0f 83 f1 00 00 00    	jae    f0103383 <env_alloc+0x143>
f0103292:	83 ec 04             	sub    $0x4,%esp
f0103295:	68 00 10 00 00       	push   $0x1000
f010329a:	52                   	push   %edx
	return (void *)(pa + KERNBASE);
f010329b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01032a0:	50                   	push   %eax
f01032a1:	e8 63 26 00 00       	call   f0105909 <memcpy>
	return (pp - pages) << PGSHIFT;
f01032a6:	2b 35 a8 3e 53 f0    	sub    0xf0533ea8,%esi
f01032ac:	c1 fe 03             	sar    $0x3,%esi
f01032af:	c1 e6 0c             	shl    $0xc,%esi
	if (PGNUM(pa) >= npages)
f01032b2:	89 f0                	mov    %esi,%eax
f01032b4:	c1 e8 0c             	shr    $0xc,%eax
f01032b7:	83 c4 10             	add    $0x10,%esp
f01032ba:	3b 05 a0 3e 53 f0    	cmp    0xf0533ea0,%eax
f01032c0:	0f 83 cf 00 00 00    	jae    f0103395 <env_alloc+0x155>
	return (void *)(pa + KERNBASE);
f01032c6:	8d 86 00 00 00 f0    	lea    -0x10000000(%esi),%eax
  e->env_pgdir = (pte_t*)page2kva(p);
f01032cc:	89 43 60             	mov    %eax,0x60(%ebx)
	if ((uint32_t)kva < KERNBASE)
f01032cf:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01032d4:	0f 86 cd 00 00 00    	jbe    f01033a7 <env_alloc+0x167>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f01032da:	83 ce 05             	or     $0x5,%esi
f01032dd:	89 b0 f4 0e 00 00    	mov    %esi,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f01032e3:	8b 43 48             	mov    0x48(%ebx),%eax
f01032e6:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f01032eb:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f01032f0:	ba 00 10 00 00       	mov    $0x1000,%edx
f01032f5:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f01032f8:	89 da                	mov    %ebx,%edx
f01032fa:	2b 15 48 32 53 f0    	sub    0xf0533248,%edx
f0103300:	c1 fa 02             	sar    $0x2,%edx
f0103303:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f0103309:	09 d0                	or     %edx,%eax
f010330b:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f010330e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103311:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103314:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f010331b:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103322:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103329:	83 ec 04             	sub    $0x4,%esp
f010332c:	6a 44                	push   $0x44
f010332e:	6a 00                	push   $0x0
f0103330:	53                   	push   %ebx
f0103331:	e8 29 25 00 00       	call   f010585f <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f0103336:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f010333c:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103342:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103348:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f010334f:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
  e->env_tf.tf_eflags |= FL_IF;
f0103355:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f010335c:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f0103363:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f0103367:	8b 43 44             	mov    0x44(%ebx),%eax
f010336a:	a3 4c 32 53 f0       	mov    %eax,0xf053324c
	*newenv_store = e;
f010336f:	8b 45 08             	mov    0x8(%ebp),%eax
f0103372:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103374:	83 c4 10             	add    $0x10,%esp
f0103377:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010337c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010337f:	5b                   	pop    %ebx
f0103380:	5e                   	pop    %esi
f0103381:	5d                   	pop    %ebp
f0103382:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103383:	50                   	push   %eax
f0103384:	68 44 6a 10 f0       	push   $0xf0106a44
f0103389:	6a 58                	push   $0x58
f010338b:	68 94 79 10 f0       	push   $0xf0107994
f0103390:	e8 ab cc ff ff       	call   f0100040 <_panic>
f0103395:	56                   	push   %esi
f0103396:	68 44 6a 10 f0       	push   $0xf0106a44
f010339b:	6a 58                	push   $0x58
f010339d:	68 94 79 10 f0       	push   $0xf0107994
f01033a2:	e8 99 cc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01033a7:	50                   	push   %eax
f01033a8:	68 68 6a 10 f0       	push   $0xf0106a68
f01033ad:	68 ca 00 00 00       	push   $0xca
f01033b2:	68 11 7d 10 f0       	push   $0xf0107d11
f01033b7:	e8 84 cc ff ff       	call   f0100040 <_panic>
		return -E_NO_FREE_ENV;
f01033bc:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f01033c1:	eb b9                	jmp    f010337c <env_alloc+0x13c>
		return -E_NO_MEM;
f01033c3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01033c8:	eb b2                	jmp    f010337c <env_alloc+0x13c>

f01033ca <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f01033ca:	55                   	push   %ebp
f01033cb:	89 e5                	mov    %esp,%ebp
f01033cd:	57                   	push   %edi
f01033ce:	56                   	push   %esi
f01033cf:	53                   	push   %ebx
f01033d0:	83 ec 34             	sub    $0x34,%esp
f01033d3:	8b 75 08             	mov    0x8(%ebp),%esi
	// LAB 3: Your code here.
  struct Env *env_ptr;
  int r = env_alloc(&env_ptr, 0);
f01033d6:	6a 00                	push   $0x0
f01033d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01033db:	50                   	push   %eax
f01033dc:	e8 5f fe ff ff       	call   f0103240 <env_alloc>
  if (r) panic("env_create: %e", r);
f01033e1:	83 c4 10             	add    $0x10,%esp
f01033e4:	85 c0                	test   %eax,%eax
f01033e6:	75 49                	jne    f0103431 <env_create+0x67>


	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
  if (type == ENV_TYPE_FS) {
f01033e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
f01033ec:	74 58                	je     f0103446 <env_create+0x7c>
    cprintf("env_create: id = %08x and this is file system env\n", env_ptr->env_id);
    env_ptr->env_tf.tf_eflags |= FL_IOPL_3;
  }

  load_icode(env_ptr, binary);
f01033ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  cprintf("into load_icode: !!!!!!!!!!!!!\n");
f01033f1:	83 ec 0c             	sub    $0xc,%esp
f01033f4:	68 6c 7d 10 f0       	push   $0xf0107d6c
f01033f9:	e8 dc 05 00 00       	call   f01039da <cprintf>
  if (elfhdr->e_magic != ELF_MAGIC) 
f01033fe:	83 c4 10             	add    $0x10,%esp
f0103401:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
f0103407:	75 5f                	jne    f0103468 <env_create+0x9e>
  ph = (struct Proghdr *) (binary + elfhdr->e_phoff);
f0103409:	89 f3                	mov    %esi,%ebx
f010340b:	03 5e 1c             	add    0x1c(%esi),%ebx
  eph = ph + elfhdr->e_phnum;
f010340e:	0f b7 46 2c          	movzwl 0x2c(%esi),%eax
f0103412:	c1 e0 05             	shl    $0x5,%eax
f0103415:	01 d8                	add    %ebx,%eax
f0103417:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  lcr3(PADDR(e->env_pgdir));
f010341a:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f010341d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103422:	76 5b                	jbe    f010347f <env_create+0xb5>
	return (physaddr_t)kva - KERNBASE;
f0103424:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103429:	0f 22 d8             	mov    %eax,%cr3
f010342c:	e9 a1 00 00 00       	jmp    f01034d2 <env_create+0x108>
  if (r) panic("env_create: %e", r);
f0103431:	50                   	push   %eax
f0103432:	68 1c 7d 10 f0       	push   $0xf0107d1c
f0103437:	68 98 01 00 00       	push   $0x198
f010343c:	68 11 7d 10 f0       	push   $0xf0107d11
f0103441:	e8 fa cb ff ff       	call   f0100040 <_panic>
    cprintf("env_create: id = %08x and this is file system env\n", env_ptr->env_id);
f0103446:	83 ec 08             	sub    $0x8,%esp
f0103449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010344c:	ff 70 48             	pushl  0x48(%eax)
f010344f:	68 38 7d 10 f0       	push   $0xf0107d38
f0103454:	e8 81 05 00 00       	call   f01039da <cprintf>
    env_ptr->env_tf.tf_eflags |= FL_IOPL_3;
f0103459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010345c:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
f0103463:	83 c4 10             	add    $0x10,%esp
f0103466:	eb 86                	jmp    f01033ee <env_create+0x24>
    panic("load_icode: not a elf file binary.\n");
f0103468:	83 ec 04             	sub    $0x4,%esp
f010346b:	68 8c 7d 10 f0       	push   $0xf0107d8c
f0103470:	68 6e 01 00 00       	push   $0x16e
f0103475:	68 11 7d 10 f0       	push   $0xf0107d11
f010347a:	e8 c1 cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010347f:	50                   	push   %eax
f0103480:	68 68 6a 10 f0       	push   $0xf0106a68
f0103485:	68 77 01 00 00       	push   $0x177
f010348a:	68 11 7d 10 f0       	push   $0xf0107d11
f010348f:	e8 ac cb ff ff       	call   f0100040 <_panic>
      region_alloc(e, (void*)ph->p_va, ph->p_memsz);  
f0103494:	8b 4b 14             	mov    0x14(%ebx),%ecx
f0103497:	8b 53 08             	mov    0x8(%ebx),%edx
f010349a:	89 f8                	mov    %edi,%eax
f010349c:	e8 25 fc ff ff       	call   f01030c6 <region_alloc>
      memcpy((void*)ph->p_va, (void*)(binary + ph->p_offset), ph->p_memsz);
f01034a1:	83 ec 04             	sub    $0x4,%esp
f01034a4:	ff 73 14             	pushl  0x14(%ebx)
f01034a7:	89 f0                	mov    %esi,%eax
f01034a9:	03 43 04             	add    0x4(%ebx),%eax
f01034ac:	50                   	push   %eax
f01034ad:	ff 73 08             	pushl  0x8(%ebx)
f01034b0:	e8 54 24 00 00       	call   f0105909 <memcpy>
      memset((void*)(ph->p_va + ph->p_filesz), 0, ph->p_memsz - ph->p_filesz);
f01034b5:	8b 43 10             	mov    0x10(%ebx),%eax
f01034b8:	83 c4 0c             	add    $0xc,%esp
f01034bb:	8b 53 14             	mov    0x14(%ebx),%edx
f01034be:	29 c2                	sub    %eax,%edx
f01034c0:	52                   	push   %edx
f01034c1:	6a 00                	push   $0x0
f01034c3:	03 43 08             	add    0x8(%ebx),%eax
f01034c6:	50                   	push   %eax
f01034c7:	e8 93 23 00 00       	call   f010585f <memset>
f01034cc:	83 c4 10             	add    $0x10,%esp
  for (; ph < eph; ph++) {
f01034cf:	83 c3 20             	add    $0x20,%ebx
f01034d2:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f01034d5:	76 07                	jbe    f01034de <env_create+0x114>
    if (ph->p_type == ELF_PROG_LOAD) {
f01034d7:	83 3b 01             	cmpl   $0x1,(%ebx)
f01034da:	75 f3                	jne    f01034cf <env_create+0x105>
f01034dc:	eb b6                	jmp    f0103494 <env_create+0xca>
  lcr3(PADDR(kern_pgdir));
f01034de:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
	if ((uint32_t)kva < KERNBASE)
f01034e3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01034e8:	76 54                	jbe    f010353e <env_create+0x174>
	return (physaddr_t)kva - KERNBASE;
f01034ea:	05 00 00 00 10       	add    $0x10000000,%eax
f01034ef:	0f 22 d8             	mov    %eax,%cr3
  region_alloc(e, (void*)(USTACKTOP - PGSIZE), PGSIZE);
f01034f2:	b9 00 10 00 00       	mov    $0x1000,%ecx
f01034f7:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f01034fc:	89 f8                	mov    %edi,%eax
f01034fe:	e8 c3 fb ff ff       	call   f01030c6 <region_alloc>
  e->env_tf.tf_eip = elfhdr->e_entry;
f0103503:	8b 46 18             	mov    0x18(%esi),%eax
f0103506:	89 47 30             	mov    %eax,0x30(%edi)
  cprintf("load_icode: e_entry = \n!!!!!!!!!!!!!", elfhdr->e_entry);
f0103509:	83 ec 08             	sub    $0x8,%esp
f010350c:	50                   	push   %eax
f010350d:	68 b0 7d 10 f0       	push   $0xf0107db0
f0103512:	e8 c3 04 00 00       	call   f01039da <cprintf>
  env_ptr->env_type = type;
f0103517:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010351a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010351d:	89 48 50             	mov    %ecx,0x50(%eax)
  cprintf("env_create: id = %08x and parent id = %08xfkfkfjkfkfkkfk\n", env_ptr->env_id, env_ptr->env_parent_id);
f0103520:	83 c4 0c             	add    $0xc,%esp
f0103523:	ff 70 4c             	pushl  0x4c(%eax)
f0103526:	ff 70 48             	pushl  0x48(%eax)
f0103529:	68 d8 7d 10 f0       	push   $0xf0107dd8
f010352e:	e8 a7 04 00 00       	call   f01039da <cprintf>
}
f0103533:	83 c4 10             	add    $0x10,%esp
f0103536:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103539:	5b                   	pop    %ebx
f010353a:	5e                   	pop    %esi
f010353b:	5f                   	pop    %edi
f010353c:	5d                   	pop    %ebp
f010353d:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010353e:	50                   	push   %eax
f010353f:	68 68 6a 10 f0       	push   $0xf0106a68
f0103544:	68 81 01 00 00       	push   $0x181
f0103549:	68 11 7d 10 f0       	push   $0xf0107d11
f010354e:	e8 ed ca ff ff       	call   f0100040 <_panic>

f0103553 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103553:	55                   	push   %ebp
f0103554:	89 e5                	mov    %esp,%ebp
f0103556:	57                   	push   %edi
f0103557:	56                   	push   %esi
f0103558:	53                   	push   %ebx
f0103559:	83 ec 1c             	sub    $0x1c,%esp
f010355c:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f010355f:	e8 fa 28 00 00       	call   f0105e5e <cpunum>
f0103564:	6b c0 74             	imul   $0x74,%eax,%eax
f0103567:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f010356e:	39 b8 28 40 53 f0    	cmp    %edi,-0xfacbfd8(%eax)
f0103574:	0f 85 b3 00 00 00    	jne    f010362d <env_free+0xda>
		lcr3(PADDR(kern_pgdir));
f010357a:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
	if ((uint32_t)kva < KERNBASE)
f010357f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103584:	76 14                	jbe    f010359a <env_free+0x47>
	return (physaddr_t)kva - KERNBASE;
f0103586:	05 00 00 00 10       	add    $0x10000000,%eax
f010358b:	0f 22 d8             	mov    %eax,%cr3
f010358e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103595:	e9 93 00 00 00       	jmp    f010362d <env_free+0xda>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010359a:	50                   	push   %eax
f010359b:	68 68 6a 10 f0       	push   $0xf0106a68
f01035a0:	68 b5 01 00 00       	push   $0x1b5
f01035a5:	68 11 7d 10 f0       	push   $0xf0107d11
f01035aa:	e8 91 ca ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01035af:	56                   	push   %esi
f01035b0:	68 44 6a 10 f0       	push   $0xf0106a44
f01035b5:	68 c4 01 00 00       	push   $0x1c4
f01035ba:	68 11 7d 10 f0       	push   $0xf0107d11
f01035bf:	e8 7c ca ff ff       	call   f0100040 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01035c4:	83 ec 08             	sub    $0x8,%esp
f01035c7:	89 d8                	mov    %ebx,%eax
f01035c9:	c1 e0 0c             	shl    $0xc,%eax
f01035cc:	0b 45 e4             	or     -0x1c(%ebp),%eax
f01035cf:	50                   	push   %eax
f01035d0:	ff 77 60             	pushl  0x60(%edi)
f01035d3:	e8 ed dc ff ff       	call   f01012c5 <page_remove>
f01035d8:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01035db:	83 c3 01             	add    $0x1,%ebx
f01035de:	83 c6 04             	add    $0x4,%esi
f01035e1:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f01035e7:	74 07                	je     f01035f0 <env_free+0x9d>
			if (pt[pteno] & PTE_P)
f01035e9:	f6 06 01             	testb  $0x1,(%esi)
f01035ec:	74 ed                	je     f01035db <env_free+0x88>
f01035ee:	eb d4                	jmp    f01035c4 <env_free+0x71>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f01035f0:	8b 47 60             	mov    0x60(%edi),%eax
f01035f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01035f6:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f01035fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103600:	3b 05 a0 3e 53 f0    	cmp    0xf0533ea0,%eax
f0103606:	73 69                	jae    f0103671 <env_free+0x11e>
		page_decref(pa2page(pa));
f0103608:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010360b:	a1 a8 3e 53 f0       	mov    0xf0533ea8,%eax
f0103610:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103613:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103616:	50                   	push   %eax
f0103617:	e8 46 da ff ff       	call   f0101062 <page_decref>
f010361c:	83 c4 10             	add    $0x10,%esp
f010361f:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103623:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103626:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f010362b:	74 58                	je     f0103685 <env_free+0x132>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f010362d:	8b 47 60             	mov    0x60(%edi),%eax
f0103630:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103633:	8b 34 10             	mov    (%eax,%edx,1),%esi
f0103636:	f7 c6 01 00 00 00    	test   $0x1,%esi
f010363c:	74 e1                	je     f010361f <env_free+0xcc>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f010363e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103644:	89 f0                	mov    %esi,%eax
f0103646:	c1 e8 0c             	shr    $0xc,%eax
f0103649:	89 45 dc             	mov    %eax,-0x24(%ebp)
f010364c:	39 05 a0 3e 53 f0    	cmp    %eax,0xf0533ea0
f0103652:	0f 86 57 ff ff ff    	jbe    f01035af <env_free+0x5c>
	return (void *)(pa + KERNBASE);
f0103658:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f010365e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103661:	c1 e0 14             	shl    $0x14,%eax
f0103664:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103667:	bb 00 00 00 00       	mov    $0x0,%ebx
f010366c:	e9 78 ff ff ff       	jmp    f01035e9 <env_free+0x96>
		panic("pa2page called with invalid pa");
f0103671:	83 ec 04             	sub    $0x4,%esp
f0103674:	68 10 71 10 f0       	push   $0xf0107110
f0103679:	6a 51                	push   $0x51
f010367b:	68 94 79 10 f0       	push   $0xf0107994
f0103680:	e8 bb c9 ff ff       	call   f0100040 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103685:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103688:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010368d:	76 49                	jbe    f01036d8 <env_free+0x185>
	e->env_pgdir = 0;
f010368f:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103696:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f010369b:	c1 e8 0c             	shr    $0xc,%eax
f010369e:	3b 05 a0 3e 53 f0    	cmp    0xf0533ea0,%eax
f01036a4:	73 47                	jae    f01036ed <env_free+0x19a>
	page_decref(pa2page(pa));
f01036a6:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01036a9:	8b 15 a8 3e 53 f0    	mov    0xf0533ea8,%edx
f01036af:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f01036b2:	50                   	push   %eax
f01036b3:	e8 aa d9 ff ff       	call   f0101062 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f01036b8:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f01036bf:	a1 4c 32 53 f0       	mov    0xf053324c,%eax
f01036c4:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f01036c7:	89 3d 4c 32 53 f0    	mov    %edi,0xf053324c
}
f01036cd:	83 c4 10             	add    $0x10,%esp
f01036d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01036d3:	5b                   	pop    %ebx
f01036d4:	5e                   	pop    %esi
f01036d5:	5f                   	pop    %edi
f01036d6:	5d                   	pop    %ebp
f01036d7:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01036d8:	50                   	push   %eax
f01036d9:	68 68 6a 10 f0       	push   $0xf0106a68
f01036de:	68 d2 01 00 00       	push   $0x1d2
f01036e3:	68 11 7d 10 f0       	push   $0xf0107d11
f01036e8:	e8 53 c9 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f01036ed:	83 ec 04             	sub    $0x4,%esp
f01036f0:	68 10 71 10 f0       	push   $0xf0107110
f01036f5:	6a 51                	push   $0x51
f01036f7:	68 94 79 10 f0       	push   $0xf0107994
f01036fc:	e8 3f c9 ff ff       	call   f0100040 <_panic>

f0103701 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103701:	55                   	push   %ebp
f0103702:	89 e5                	mov    %esp,%ebp
f0103704:	53                   	push   %ebx
f0103705:	83 ec 04             	sub    $0x4,%esp
f0103708:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f010370b:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f010370f:	74 21                	je     f0103732 <env_destroy+0x31>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103711:	83 ec 0c             	sub    $0xc,%esp
f0103714:	53                   	push   %ebx
f0103715:	e8 39 fe ff ff       	call   f0103553 <env_free>

	if (curenv == e) {
f010371a:	e8 3f 27 00 00       	call   f0105e5e <cpunum>
f010371f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103722:	83 c4 10             	add    $0x10,%esp
f0103725:	39 98 28 40 53 f0    	cmp    %ebx,-0xfacbfd8(%eax)
f010372b:	74 1e                	je     f010374b <env_destroy+0x4a>
		curenv = NULL;
		sched_yield();
	}
}
f010372d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103730:	c9                   	leave  
f0103731:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103732:	e8 27 27 00 00       	call   f0105e5e <cpunum>
f0103737:	6b c0 74             	imul   $0x74,%eax,%eax
f010373a:	39 98 28 40 53 f0    	cmp    %ebx,-0xfacbfd8(%eax)
f0103740:	74 cf                	je     f0103711 <env_destroy+0x10>
		e->env_status = ENV_DYING;
f0103742:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103749:	eb e2                	jmp    f010372d <env_destroy+0x2c>
		curenv = NULL;
f010374b:	e8 0e 27 00 00       	call   f0105e5e <cpunum>
f0103750:	6b c0 74             	imul   $0x74,%eax,%eax
f0103753:	c7 80 28 40 53 f0 00 	movl   $0x0,-0xfacbfd8(%eax)
f010375a:	00 00 00 
		sched_yield();
f010375d:	e8 fd 0e 00 00       	call   f010465f <sched_yield>

f0103762 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103762:	55                   	push   %ebp
f0103763:	89 e5                	mov    %esp,%ebp
f0103765:	53                   	push   %ebx
f0103766:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103769:	e8 f0 26 00 00       	call   f0105e5e <cpunum>
f010376e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103771:	8b 98 28 40 53 f0    	mov    -0xfacbfd8(%eax),%ebx
f0103777:	e8 e2 26 00 00       	call   f0105e5e <cpunum>
f010377c:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f010377f:	8b 65 08             	mov    0x8(%ebp),%esp
f0103782:	61                   	popa   
f0103783:	07                   	pop    %es
f0103784:	1f                   	pop    %ds
f0103785:	83 c4 08             	add    $0x8,%esp
f0103788:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0103789:	83 ec 04             	sub    $0x4,%esp
f010378c:	68 2b 7d 10 f0       	push   $0xf0107d2b
f0103791:	68 09 02 00 00       	push   $0x209
f0103796:	68 11 7d 10 f0       	push   $0xf0107d11
f010379b:	e8 a0 c8 ff ff       	call   f0100040 <_panic>

f01037a0 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f01037a0:	55                   	push   %ebp
f01037a1:	89 e5                	mov    %esp,%ebp
f01037a3:	53                   	push   %ebx
f01037a4:	83 ec 04             	sub    $0x4,%esp
f01037a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
  if (curenv != NULL && curenv->env_status == ENV_RUNNING) {
f01037aa:	e8 af 26 00 00       	call   f0105e5e <cpunum>
f01037af:	6b c0 74             	imul   $0x74,%eax,%eax
f01037b2:	83 b8 28 40 53 f0 00 	cmpl   $0x0,-0xfacbfd8(%eax)
f01037b9:	74 14                	je     f01037cf <env_run+0x2f>
f01037bb:	e8 9e 26 00 00       	call   f0105e5e <cpunum>
f01037c0:	6b c0 74             	imul   $0x74,%eax,%eax
f01037c3:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f01037c9:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01037cd:	74 42                	je     f0103811 <env_run+0x71>
    curenv->env_status = ENV_RUNNABLE; 
  }
  curenv = e;
f01037cf:	e8 8a 26 00 00       	call   f0105e5e <cpunum>
f01037d4:	6b c0 74             	imul   $0x74,%eax,%eax
f01037d7:	89 98 28 40 53 f0    	mov    %ebx,-0xfacbfd8(%eax)
  e->env_status = ENV_RUNNING;
f01037dd:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
  ++e->env_runs;
f01037e4:	83 43 58 01          	addl   $0x1,0x58(%ebx)
  lcr3(PADDR(e->env_pgdir));
f01037e8:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01037eb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01037f0:	76 36                	jbe    f0103828 <env_run+0x88>
	return (physaddr_t)kva - KERNBASE;
f01037f2:	05 00 00 00 10       	add    $0x10000000,%eax
f01037f7:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f01037fa:	83 ec 0c             	sub    $0xc,%esp
f01037fd:	68 c0 53 12 f0       	push   $0xf01253c0
f0103802:	e8 63 29 00 00       	call   f010616a <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103807:	f3 90                	pause  
  unlock_kernel();
  env_pop_tf(&e->env_tf);
f0103809:	89 1c 24             	mov    %ebx,(%esp)
f010380c:	e8 51 ff ff ff       	call   f0103762 <env_pop_tf>
    curenv->env_status = ENV_RUNNABLE; 
f0103811:	e8 48 26 00 00       	call   f0105e5e <cpunum>
f0103816:	6b c0 74             	imul   $0x74,%eax,%eax
f0103819:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f010381f:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103826:	eb a7                	jmp    f01037cf <env_run+0x2f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103828:	50                   	push   %eax
f0103829:	68 68 6a 10 f0       	push   $0xf0106a68
f010382e:	68 2d 02 00 00       	push   $0x22d
f0103833:	68 11 7d 10 f0       	push   $0xf0107d11
f0103838:	e8 03 c8 ff ff       	call   f0100040 <_panic>

f010383d <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010383d:	55                   	push   %ebp
f010383e:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103840:	8b 45 08             	mov    0x8(%ebp),%eax
f0103843:	ba 70 00 00 00       	mov    $0x70,%edx
f0103848:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103849:	ba 71 00 00 00       	mov    $0x71,%edx
f010384e:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f010384f:	0f b6 c0             	movzbl %al,%eax
}
f0103852:	5d                   	pop    %ebp
f0103853:	c3                   	ret    

f0103854 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103854:	55                   	push   %ebp
f0103855:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103857:	8b 45 08             	mov    0x8(%ebp),%eax
f010385a:	ba 70 00 00 00       	mov    $0x70,%edx
f010385f:	ee                   	out    %al,(%dx)
f0103860:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103863:	ba 71 00 00 00       	mov    $0x71,%edx
f0103868:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103869:	5d                   	pop    %ebp
f010386a:	c3                   	ret    

f010386b <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f010386b:	55                   	push   %ebp
f010386c:	89 e5                	mov    %esp,%ebp
f010386e:	56                   	push   %esi
f010386f:	53                   	push   %ebx
f0103870:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0103873:	66 a3 a8 53 12 f0    	mov    %ax,0xf01253a8
	if (!didinit)
f0103879:	80 3d 50 32 53 f0 00 	cmpb   $0x0,0xf0533250
f0103880:	75 07                	jne    f0103889 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f0103882:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103885:	5b                   	pop    %ebx
f0103886:	5e                   	pop    %esi
f0103887:	5d                   	pop    %ebp
f0103888:	c3                   	ret    
f0103889:	89 c6                	mov    %eax,%esi
f010388b:	ba 21 00 00 00       	mov    $0x21,%edx
f0103890:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103891:	66 c1 e8 08          	shr    $0x8,%ax
f0103895:	ba a1 00 00 00       	mov    $0xa1,%edx
f010389a:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f010389b:	83 ec 0c             	sub    $0xc,%esp
f010389e:	68 12 7e 10 f0       	push   $0xf0107e12
f01038a3:	e8 32 01 00 00       	call   f01039da <cprintf>
f01038a8:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01038ab:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f01038b0:	0f b7 f6             	movzwl %si,%esi
f01038b3:	f7 d6                	not    %esi
f01038b5:	eb 19                	jmp    f01038d0 <irq_setmask_8259A+0x65>
			cprintf(" %d", i);
f01038b7:	83 ec 08             	sub    $0x8,%esp
f01038ba:	53                   	push   %ebx
f01038bb:	68 ab 82 10 f0       	push   $0xf01082ab
f01038c0:	e8 15 01 00 00       	call   f01039da <cprintf>
f01038c5:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01038c8:	83 c3 01             	add    $0x1,%ebx
f01038cb:	83 fb 10             	cmp    $0x10,%ebx
f01038ce:	74 07                	je     f01038d7 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f01038d0:	0f a3 de             	bt     %ebx,%esi
f01038d3:	73 f3                	jae    f01038c8 <irq_setmask_8259A+0x5d>
f01038d5:	eb e0                	jmp    f01038b7 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f01038d7:	83 ec 0c             	sub    $0xc,%esp
f01038da:	68 c3 7c 10 f0       	push   $0xf0107cc3
f01038df:	e8 f6 00 00 00       	call   f01039da <cprintf>
f01038e4:	83 c4 10             	add    $0x10,%esp
f01038e7:	eb 99                	jmp    f0103882 <irq_setmask_8259A+0x17>

f01038e9 <pic_init>:
{
f01038e9:	55                   	push   %ebp
f01038ea:	89 e5                	mov    %esp,%ebp
f01038ec:	57                   	push   %edi
f01038ed:	56                   	push   %esi
f01038ee:	53                   	push   %ebx
f01038ef:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f01038f2:	c6 05 50 32 53 f0 01 	movb   $0x1,0xf0533250
f01038f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01038fe:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103903:	89 da                	mov    %ebx,%edx
f0103905:	ee                   	out    %al,(%dx)
f0103906:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f010390b:	89 ca                	mov    %ecx,%edx
f010390d:	ee                   	out    %al,(%dx)
f010390e:	bf 11 00 00 00       	mov    $0x11,%edi
f0103913:	be 20 00 00 00       	mov    $0x20,%esi
f0103918:	89 f8                	mov    %edi,%eax
f010391a:	89 f2                	mov    %esi,%edx
f010391c:	ee                   	out    %al,(%dx)
f010391d:	b8 20 00 00 00       	mov    $0x20,%eax
f0103922:	89 da                	mov    %ebx,%edx
f0103924:	ee                   	out    %al,(%dx)
f0103925:	b8 04 00 00 00       	mov    $0x4,%eax
f010392a:	ee                   	out    %al,(%dx)
f010392b:	b8 03 00 00 00       	mov    $0x3,%eax
f0103930:	ee                   	out    %al,(%dx)
f0103931:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103936:	89 f8                	mov    %edi,%eax
f0103938:	89 da                	mov    %ebx,%edx
f010393a:	ee                   	out    %al,(%dx)
f010393b:	b8 28 00 00 00       	mov    $0x28,%eax
f0103940:	89 ca                	mov    %ecx,%edx
f0103942:	ee                   	out    %al,(%dx)
f0103943:	b8 02 00 00 00       	mov    $0x2,%eax
f0103948:	ee                   	out    %al,(%dx)
f0103949:	b8 01 00 00 00       	mov    $0x1,%eax
f010394e:	ee                   	out    %al,(%dx)
f010394f:	bf 68 00 00 00       	mov    $0x68,%edi
f0103954:	89 f8                	mov    %edi,%eax
f0103956:	89 f2                	mov    %esi,%edx
f0103958:	ee                   	out    %al,(%dx)
f0103959:	b9 0a 00 00 00       	mov    $0xa,%ecx
f010395e:	89 c8                	mov    %ecx,%eax
f0103960:	ee                   	out    %al,(%dx)
f0103961:	89 f8                	mov    %edi,%eax
f0103963:	89 da                	mov    %ebx,%edx
f0103965:	ee                   	out    %al,(%dx)
f0103966:	89 c8                	mov    %ecx,%eax
f0103968:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0103969:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f0103970:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103974:	75 08                	jne    f010397e <pic_init+0x95>
}
f0103976:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103979:	5b                   	pop    %ebx
f010397a:	5e                   	pop    %esi
f010397b:	5f                   	pop    %edi
f010397c:	5d                   	pop    %ebp
f010397d:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f010397e:	83 ec 0c             	sub    $0xc,%esp
f0103981:	0f b7 c0             	movzwl %ax,%eax
f0103984:	50                   	push   %eax
f0103985:	e8 e1 fe ff ff       	call   f010386b <irq_setmask_8259A>
f010398a:	83 c4 10             	add    $0x10,%esp
}
f010398d:	eb e7                	jmp    f0103976 <pic_init+0x8d>

f010398f <irq_eoi>:
f010398f:	b8 20 00 00 00       	mov    $0x20,%eax
f0103994:	ba 20 00 00 00       	mov    $0x20,%edx
f0103999:	ee                   	out    %al,(%dx)
f010399a:	ba a0 00 00 00       	mov    $0xa0,%edx
f010399f:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f01039a0:	c3                   	ret    

f01039a1 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01039a1:	55                   	push   %ebp
f01039a2:	89 e5                	mov    %esp,%ebp
f01039a4:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f01039a7:	ff 75 08             	pushl  0x8(%ebp)
f01039aa:	e8 19 ce ff ff       	call   f01007c8 <cputchar>
	*cnt++;
}
f01039af:	83 c4 10             	add    $0x10,%esp
f01039b2:	c9                   	leave  
f01039b3:	c3                   	ret    

f01039b4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f01039b4:	55                   	push   %ebp
f01039b5:	89 e5                	mov    %esp,%ebp
f01039b7:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f01039ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01039c1:	ff 75 0c             	pushl  0xc(%ebp)
f01039c4:	ff 75 08             	pushl  0x8(%ebp)
f01039c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01039ca:	50                   	push   %eax
f01039cb:	68 a1 39 10 f0       	push   $0xf01039a1
f01039d0:	e8 76 17 00 00       	call   f010514b <vprintfmt>
	return cnt;
}
f01039d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01039d8:	c9                   	leave  
f01039d9:	c3                   	ret    

f01039da <cprintf>:

int
cprintf(const char *fmt, ...)
{
f01039da:	55                   	push   %ebp
f01039db:	89 e5                	mov    %esp,%ebp
f01039dd:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01039e0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f01039e3:	50                   	push   %eax
f01039e4:	ff 75 08             	pushl  0x8(%ebp)
f01039e7:	e8 c8 ff ff ff       	call   f01039b4 <vcprintf>
	va_end(ap);

	return cnt;
}
f01039ec:	c9                   	leave  
f01039ed:	c3                   	ret    

f01039ee <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f01039ee:	55                   	push   %ebp
f01039ef:	89 e5                	mov    %esp,%ebp
f01039f1:	57                   	push   %edi
f01039f2:	56                   	push   %esi
f01039f3:	53                   	push   %ebx
f01039f4:	83 ec 1c             	sub    $0x1c,%esp
	// user space on that CPU.//因为返回时会访问栈地址
	//
	// LAB 4: Your code here:
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
  int i = cpunum();
f01039f7:	e8 62 24 00 00       	call   f0105e5e <cpunum>
f01039fc:	89 c6                	mov    %eax,%esi
  thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
f01039fe:	e8 5b 24 00 00       	call   f0105e5e <cpunum>
f0103a03:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a06:	89 f1                	mov    %esi,%ecx
f0103a08:	c1 e1 10             	shl    $0x10,%ecx
f0103a0b:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103a10:	29 ca                	sub    %ecx,%edx
f0103a12:	89 90 30 40 53 f0    	mov    %edx,-0xfacbfd0(%eax)
  thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0103a18:	e8 41 24 00 00       	call   f0105e5e <cpunum>
f0103a1d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a20:	66 c7 80 34 40 53 f0 	movw   $0x10,-0xfacbfcc(%eax)
f0103a27:	10 00 
  thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);
f0103a29:	e8 30 24 00 00       	call   f0105e5e <cpunum>
f0103a2e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a31:	66 c7 80 92 40 53 f0 	movw   $0x68,-0xfacbf6e(%eax)
f0103a38:	68 00 

	// Initialize the TSS slot of the gdt.
  gdt[(GD_TSS0 >> 3) + i] = SEG16(STS_T32A, (uint32_t) (&thiscpu->cpu_ts),
f0103a3a:	8d 5e 05             	lea    0x5(%esi),%ebx
f0103a3d:	e8 1c 24 00 00       	call   f0105e5e <cpunum>
f0103a42:	89 c7                	mov    %eax,%edi
f0103a44:	e8 15 24 00 00       	call   f0105e5e <cpunum>
f0103a49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103a4c:	e8 0d 24 00 00       	call   f0105e5e <cpunum>
f0103a51:	66 c7 04 dd 40 53 12 	movw   $0x67,-0xfedacc0(,%ebx,8)
f0103a58:	f0 67 00 
f0103a5b:	6b ff 74             	imul   $0x74,%edi,%edi
f0103a5e:	81 c7 2c 40 53 f0    	add    $0xf053402c,%edi
f0103a64:	66 89 3c dd 42 53 12 	mov    %di,-0xfedacbe(,%ebx,8)
f0103a6b:	f0 
f0103a6c:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103a70:	81 c2 2c 40 53 f0    	add    $0xf053402c,%edx
f0103a76:	c1 ea 10             	shr    $0x10,%edx
f0103a79:	88 14 dd 44 53 12 f0 	mov    %dl,-0xfedacbc(,%ebx,8)
f0103a80:	c6 04 dd 46 53 12 f0 	movb   $0x40,-0xfedacba(,%ebx,8)
f0103a87:	40 
f0103a88:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a8b:	05 2c 40 53 f0       	add    $0xf053402c,%eax
f0103a90:	c1 e8 18             	shr    $0x18,%eax
f0103a93:	88 04 dd 47 53 12 f0 	mov    %al,-0xfedacb9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + i].sd_s = 0;
f0103a9a:	c6 04 dd 45 53 12 f0 	movb   $0x89,-0xfedacbb(,%ebx,8)
f0103aa1:	89 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0  + (i << 3));
f0103aa2:	8d 34 f5 28 00 00 00 	lea    0x28(,%esi,8),%esi
	asm volatile("ltr %0" : : "r" (sel));
f0103aa9:	0f 00 de             	ltr    %si
	asm volatile("lidt (%0)" : : "r" (p));
f0103aac:	b8 ac 53 12 f0       	mov    $0xf01253ac,%eax
f0103ab1:	0f 01 18             	lidtl  (%eax)

	// Load the IDT
	lidt(&idt_pd);
}
f0103ab4:	83 c4 1c             	add    $0x1c,%esp
f0103ab7:	5b                   	pop    %ebx
f0103ab8:	5e                   	pop    %esi
f0103ab9:	5f                   	pop    %edi
f0103aba:	5d                   	pop    %ebp
f0103abb:	c3                   	ret    

f0103abc <trap_init>:
{
f0103abc:	55                   	push   %ebp
f0103abd:	89 e5                	mov    %esp,%ebp
f0103abf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_DIVIDE], 0, GD_KT, traphandler0, 0);
f0103ac2:	b8 e6 44 10 f0       	mov    $0xf01044e6,%eax
f0103ac7:	66 a3 60 32 53 f0    	mov    %ax,0xf0533260
f0103acd:	66 c7 05 62 32 53 f0 	movw   $0x8,0xf0533262
f0103ad4:	08 00 
f0103ad6:	c6 05 64 32 53 f0 00 	movb   $0x0,0xf0533264
f0103add:	c6 05 65 32 53 f0 8e 	movb   $0x8e,0xf0533265
f0103ae4:	c1 e8 10             	shr    $0x10,%eax
f0103ae7:	66 a3 66 32 53 f0    	mov    %ax,0xf0533266
  SETGATE(idt[T_DEBUG], 0, GD_KT, traphandler1, 0);
f0103aed:	b8 f0 44 10 f0       	mov    $0xf01044f0,%eax
f0103af2:	66 a3 68 32 53 f0    	mov    %ax,0xf0533268
f0103af8:	66 c7 05 6a 32 53 f0 	movw   $0x8,0xf053326a
f0103aff:	08 00 
f0103b01:	c6 05 6c 32 53 f0 00 	movb   $0x0,0xf053326c
f0103b08:	c6 05 6d 32 53 f0 8e 	movb   $0x8e,0xf053326d
f0103b0f:	c1 e8 10             	shr    $0x10,%eax
f0103b12:	66 a3 6e 32 53 f0    	mov    %ax,0xf053326e
  SETGATE(idt[T_NMI], 0, GD_KT, traphandler2, 0);
f0103b18:	b8 fa 44 10 f0       	mov    $0xf01044fa,%eax
f0103b1d:	66 a3 70 32 53 f0    	mov    %ax,0xf0533270
f0103b23:	66 c7 05 72 32 53 f0 	movw   $0x8,0xf0533272
f0103b2a:	08 00 
f0103b2c:	c6 05 74 32 53 f0 00 	movb   $0x0,0xf0533274
f0103b33:	c6 05 75 32 53 f0 8e 	movb   $0x8e,0xf0533275
f0103b3a:	c1 e8 10             	shr    $0x10,%eax
f0103b3d:	66 a3 76 32 53 f0    	mov    %ax,0xf0533276
  SETGATE(idt[T_BRKPT], 0, GD_KT, traphandler3, 3);
f0103b43:	b8 04 45 10 f0       	mov    $0xf0104504,%eax
f0103b48:	66 a3 78 32 53 f0    	mov    %ax,0xf0533278
f0103b4e:	66 c7 05 7a 32 53 f0 	movw   $0x8,0xf053327a
f0103b55:	08 00 
f0103b57:	c6 05 7c 32 53 f0 00 	movb   $0x0,0xf053327c
f0103b5e:	c6 05 7d 32 53 f0 ee 	movb   $0xee,0xf053327d
f0103b65:	c1 e8 10             	shr    $0x10,%eax
f0103b68:	66 a3 7e 32 53 f0    	mov    %ax,0xf053327e
  SETGATE(idt[T_OFLOW], 0, GD_KT, traphandler4, 0);
f0103b6e:	b8 0a 45 10 f0       	mov    $0xf010450a,%eax
f0103b73:	66 a3 80 32 53 f0    	mov    %ax,0xf0533280
f0103b79:	66 c7 05 82 32 53 f0 	movw   $0x8,0xf0533282
f0103b80:	08 00 
f0103b82:	c6 05 84 32 53 f0 00 	movb   $0x0,0xf0533284
f0103b89:	c6 05 85 32 53 f0 8e 	movb   $0x8e,0xf0533285
f0103b90:	c1 e8 10             	shr    $0x10,%eax
f0103b93:	66 a3 86 32 53 f0    	mov    %ax,0xf0533286
  SETGATE(idt[T_BOUND], 0, GD_KT, traphandler5, 0);
f0103b99:	b8 10 45 10 f0       	mov    $0xf0104510,%eax
f0103b9e:	66 a3 88 32 53 f0    	mov    %ax,0xf0533288
f0103ba4:	66 c7 05 8a 32 53 f0 	movw   $0x8,0xf053328a
f0103bab:	08 00 
f0103bad:	c6 05 8c 32 53 f0 00 	movb   $0x0,0xf053328c
f0103bb4:	c6 05 8d 32 53 f0 8e 	movb   $0x8e,0xf053328d
f0103bbb:	c1 e8 10             	shr    $0x10,%eax
f0103bbe:	66 a3 8e 32 53 f0    	mov    %ax,0xf053328e
  SETGATE(idt[T_ILLOP], 0, GD_KT, traphandler6, 0);
f0103bc4:	b8 16 45 10 f0       	mov    $0xf0104516,%eax
f0103bc9:	66 a3 90 32 53 f0    	mov    %ax,0xf0533290
f0103bcf:	66 c7 05 92 32 53 f0 	movw   $0x8,0xf0533292
f0103bd6:	08 00 
f0103bd8:	c6 05 94 32 53 f0 00 	movb   $0x0,0xf0533294
f0103bdf:	c6 05 95 32 53 f0 8e 	movb   $0x8e,0xf0533295
f0103be6:	c1 e8 10             	shr    $0x10,%eax
f0103be9:	66 a3 96 32 53 f0    	mov    %ax,0xf0533296
  SETGATE(idt[T_DEVICE], 0, GD_KT, traphandler7, 0);
f0103bef:	b8 1c 45 10 f0       	mov    $0xf010451c,%eax
f0103bf4:	66 a3 98 32 53 f0    	mov    %ax,0xf0533298
f0103bfa:	66 c7 05 9a 32 53 f0 	movw   $0x8,0xf053329a
f0103c01:	08 00 
f0103c03:	c6 05 9c 32 53 f0 00 	movb   $0x0,0xf053329c
f0103c0a:	c6 05 9d 32 53 f0 8e 	movb   $0x8e,0xf053329d
f0103c11:	c1 e8 10             	shr    $0x10,%eax
f0103c14:	66 a3 9e 32 53 f0    	mov    %ax,0xf053329e
  SETGATE(idt[T_DBLFLT], 0, GD_KT, traphandler8, 0);
f0103c1a:	b8 22 45 10 f0       	mov    $0xf0104522,%eax
f0103c1f:	66 a3 a0 32 53 f0    	mov    %ax,0xf05332a0
f0103c25:	66 c7 05 a2 32 53 f0 	movw   $0x8,0xf05332a2
f0103c2c:	08 00 
f0103c2e:	c6 05 a4 32 53 f0 00 	movb   $0x0,0xf05332a4
f0103c35:	c6 05 a5 32 53 f0 8e 	movb   $0x8e,0xf05332a5
f0103c3c:	c1 e8 10             	shr    $0x10,%eax
f0103c3f:	66 a3 a6 32 53 f0    	mov    %ax,0xf05332a6
  SETGATE(idt[T_TSS], 0, GD_KT, traphandler10, 0);
f0103c45:	b8 26 45 10 f0       	mov    $0xf0104526,%eax
f0103c4a:	66 a3 b0 32 53 f0    	mov    %ax,0xf05332b0
f0103c50:	66 c7 05 b2 32 53 f0 	movw   $0x8,0xf05332b2
f0103c57:	08 00 
f0103c59:	c6 05 b4 32 53 f0 00 	movb   $0x0,0xf05332b4
f0103c60:	c6 05 b5 32 53 f0 8e 	movb   $0x8e,0xf05332b5
f0103c67:	c1 e8 10             	shr    $0x10,%eax
f0103c6a:	66 a3 b6 32 53 f0    	mov    %ax,0xf05332b6
  SETGATE(idt[T_SEGNP], 0, GD_KT, traphandler11, 0);
f0103c70:	b8 2a 45 10 f0       	mov    $0xf010452a,%eax
f0103c75:	66 a3 b8 32 53 f0    	mov    %ax,0xf05332b8
f0103c7b:	66 c7 05 ba 32 53 f0 	movw   $0x8,0xf05332ba
f0103c82:	08 00 
f0103c84:	c6 05 bc 32 53 f0 00 	movb   $0x0,0xf05332bc
f0103c8b:	c6 05 bd 32 53 f0 8e 	movb   $0x8e,0xf05332bd
f0103c92:	c1 e8 10             	shr    $0x10,%eax
f0103c95:	66 a3 be 32 53 f0    	mov    %ax,0xf05332be
  SETGATE(idt[T_STACK], 0, GD_KT, traphandler12, 0);
f0103c9b:	b8 2e 45 10 f0       	mov    $0xf010452e,%eax
f0103ca0:	66 a3 c0 32 53 f0    	mov    %ax,0xf05332c0
f0103ca6:	66 c7 05 c2 32 53 f0 	movw   $0x8,0xf05332c2
f0103cad:	08 00 
f0103caf:	c6 05 c4 32 53 f0 00 	movb   $0x0,0xf05332c4
f0103cb6:	c6 05 c5 32 53 f0 8e 	movb   $0x8e,0xf05332c5
f0103cbd:	c1 e8 10             	shr    $0x10,%eax
f0103cc0:	66 a3 c6 32 53 f0    	mov    %ax,0xf05332c6
  SETGATE(idt[T_GPFLT], 0, GD_KT, traphandler13, 0);
f0103cc6:	b8 32 45 10 f0       	mov    $0xf0104532,%eax
f0103ccb:	66 a3 c8 32 53 f0    	mov    %ax,0xf05332c8
f0103cd1:	66 c7 05 ca 32 53 f0 	movw   $0x8,0xf05332ca
f0103cd8:	08 00 
f0103cda:	c6 05 cc 32 53 f0 00 	movb   $0x0,0xf05332cc
f0103ce1:	c6 05 cd 32 53 f0 8e 	movb   $0x8e,0xf05332cd
f0103ce8:	c1 e8 10             	shr    $0x10,%eax
f0103ceb:	66 a3 ce 32 53 f0    	mov    %ax,0xf05332ce
  SETGATE(idt[T_PGFLT], 0, GD_KT, traphandler14, 0);
f0103cf1:	b8 36 45 10 f0       	mov    $0xf0104536,%eax
f0103cf6:	66 a3 d0 32 53 f0    	mov    %ax,0xf05332d0
f0103cfc:	66 c7 05 d2 32 53 f0 	movw   $0x8,0xf05332d2
f0103d03:	08 00 
f0103d05:	c6 05 d4 32 53 f0 00 	movb   $0x0,0xf05332d4
f0103d0c:	c6 05 d5 32 53 f0 8e 	movb   $0x8e,0xf05332d5
f0103d13:	c1 e8 10             	shr    $0x10,%eax
f0103d16:	66 a3 d6 32 53 f0    	mov    %ax,0xf05332d6
  SETGATE(idt[T_FPERR], 0, GD_KT, traphandler16, 0);
f0103d1c:	b8 3a 45 10 f0       	mov    $0xf010453a,%eax
f0103d21:	66 a3 e0 32 53 f0    	mov    %ax,0xf05332e0
f0103d27:	66 c7 05 e2 32 53 f0 	movw   $0x8,0xf05332e2
f0103d2e:	08 00 
f0103d30:	c6 05 e4 32 53 f0 00 	movb   $0x0,0xf05332e4
f0103d37:	c6 05 e5 32 53 f0 8e 	movb   $0x8e,0xf05332e5
f0103d3e:	c1 e8 10             	shr    $0x10,%eax
f0103d41:	66 a3 e6 32 53 f0    	mov    %ax,0xf05332e6
  SETGATE(idt[T_ALIGN], 0, GD_KT, traphandler17, 0);
f0103d47:	b8 40 45 10 f0       	mov    $0xf0104540,%eax
f0103d4c:	66 a3 e8 32 53 f0    	mov    %ax,0xf05332e8
f0103d52:	66 c7 05 ea 32 53 f0 	movw   $0x8,0xf05332ea
f0103d59:	08 00 
f0103d5b:	c6 05 ec 32 53 f0 00 	movb   $0x0,0xf05332ec
f0103d62:	c6 05 ed 32 53 f0 8e 	movb   $0x8e,0xf05332ed
f0103d69:	c1 e8 10             	shr    $0x10,%eax
f0103d6c:	66 a3 ee 32 53 f0    	mov    %ax,0xf05332ee
  SETGATE(idt[T_MCHK], 0, GD_KT, traphandler18, 0);
f0103d72:	b8 44 45 10 f0       	mov    $0xf0104544,%eax
f0103d77:	66 a3 f0 32 53 f0    	mov    %ax,0xf05332f0
f0103d7d:	66 c7 05 f2 32 53 f0 	movw   $0x8,0xf05332f2
f0103d84:	08 00 
f0103d86:	c6 05 f4 32 53 f0 00 	movb   $0x0,0xf05332f4
f0103d8d:	c6 05 f5 32 53 f0 8e 	movb   $0x8e,0xf05332f5
f0103d94:	c1 e8 10             	shr    $0x10,%eax
f0103d97:	66 a3 f6 32 53 f0    	mov    %ax,0xf05332f6
  SETGATE(idt[T_SIMDERR], 0, GD_KT, traphandler19, 0);
f0103d9d:	b8 4a 45 10 f0       	mov    $0xf010454a,%eax
f0103da2:	66 a3 f8 32 53 f0    	mov    %ax,0xf05332f8
f0103da8:	66 c7 05 fa 32 53 f0 	movw   $0x8,0xf05332fa
f0103daf:	08 00 
f0103db1:	c6 05 fc 32 53 f0 00 	movb   $0x0,0xf05332fc
f0103db8:	c6 05 fd 32 53 f0 8e 	movb   $0x8e,0xf05332fd
f0103dbf:	c1 e8 10             	shr    $0x10,%eax
f0103dc2:	66 a3 fe 32 53 f0    	mov    %ax,0xf05332fe
  SETGATE(idt[T_SYSCALL], 0, GD_KT, traphandler48, 3);
f0103dc8:	b8 50 45 10 f0       	mov    $0xf0104550,%eax
f0103dcd:	66 a3 e0 33 53 f0    	mov    %ax,0xf05333e0
f0103dd3:	66 c7 05 e2 33 53 f0 	movw   $0x8,0xf05333e2
f0103dda:	08 00 
f0103ddc:	c6 05 e4 33 53 f0 00 	movb   $0x0,0xf05333e4
f0103de3:	c6 05 e5 33 53 f0 ee 	movb   $0xee,0xf05333e5
f0103dea:	c1 e8 10             	shr    $0x10,%eax
f0103ded:	66 a3 e6 33 53 f0    	mov    %ax,0xf05333e6
  SETGATE(idt[T_DEFAULT], 0, GD_KT, traphandler500, 0);
f0103df3:	b8 56 45 10 f0       	mov    $0xf0104556,%eax
f0103df8:	66 a3 00 42 53 f0    	mov    %ax,0xf0534200
f0103dfe:	66 c7 05 02 42 53 f0 	movw   $0x8,0xf0534202
f0103e05:	08 00 
f0103e07:	c6 05 04 42 53 f0 00 	movb   $0x0,0xf0534204
f0103e0e:	c6 05 05 42 53 f0 8e 	movb   $0x8e,0xf0534205
f0103e15:	c1 e8 10             	shr    $0x10,%eax
f0103e18:	66 a3 06 42 53 f0    	mov    %ax,0xf0534206
  SETGATE(idt[IRQ_OFFSET + IRQ_TIMER], 0, GD_KT, traphandler32, 0);
f0103e1e:	b8 60 45 10 f0       	mov    $0xf0104560,%eax
f0103e23:	66 a3 60 33 53 f0    	mov    %ax,0xf0533360
f0103e29:	66 c7 05 62 33 53 f0 	movw   $0x8,0xf0533362
f0103e30:	08 00 
f0103e32:	c6 05 64 33 53 f0 00 	movb   $0x0,0xf0533364
f0103e39:	c6 05 65 33 53 f0 8e 	movb   $0x8e,0xf0533365
f0103e40:	c1 e8 10             	shr    $0x10,%eax
f0103e43:	66 a3 66 33 53 f0    	mov    %ax,0xf0533366
  SETGATE(idt[IRQ_OFFSET + IRQ_KBD], 0, GD_KT, traphandler33, 0);
f0103e49:	b8 66 45 10 f0       	mov    $0xf0104566,%eax
f0103e4e:	66 a3 68 33 53 f0    	mov    %ax,0xf0533368
f0103e54:	66 c7 05 6a 33 53 f0 	movw   $0x8,0xf053336a
f0103e5b:	08 00 
f0103e5d:	c6 05 6c 33 53 f0 00 	movb   $0x0,0xf053336c
f0103e64:	c6 05 6d 33 53 f0 8e 	movb   $0x8e,0xf053336d
f0103e6b:	c1 e8 10             	shr    $0x10,%eax
f0103e6e:	66 a3 6e 33 53 f0    	mov    %ax,0xf053336e
  SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL], 0, GD_KT, traphandler36, 0);
f0103e74:	b8 6c 45 10 f0       	mov    $0xf010456c,%eax
f0103e79:	66 a3 80 33 53 f0    	mov    %ax,0xf0533380
f0103e7f:	66 c7 05 82 33 53 f0 	movw   $0x8,0xf0533382
f0103e86:	08 00 
f0103e88:	c6 05 84 33 53 f0 00 	movb   $0x0,0xf0533384
f0103e8f:	c6 05 85 33 53 f0 8e 	movb   $0x8e,0xf0533385
f0103e96:	c1 e8 10             	shr    $0x10,%eax
f0103e99:	66 a3 86 33 53 f0    	mov    %ax,0xf0533386
  SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS], 0, GD_KT, traphandler39, 0);
f0103e9f:	b8 72 45 10 f0       	mov    $0xf0104572,%eax
f0103ea4:	66 a3 98 33 53 f0    	mov    %ax,0xf0533398
f0103eaa:	66 c7 05 9a 33 53 f0 	movw   $0x8,0xf053339a
f0103eb1:	08 00 
f0103eb3:	c6 05 9c 33 53 f0 00 	movb   $0x0,0xf053339c
f0103eba:	c6 05 9d 33 53 f0 8e 	movb   $0x8e,0xf053339d
f0103ec1:	c1 e8 10             	shr    $0x10,%eax
f0103ec4:	66 a3 9e 33 53 f0    	mov    %ax,0xf053339e
  SETGATE(idt[IRQ_OFFSET + IRQ_IDE], 0, GD_KT, traphandler46, 0);
f0103eca:	b8 78 45 10 f0       	mov    $0xf0104578,%eax
f0103ecf:	66 a3 d0 33 53 f0    	mov    %ax,0xf05333d0
f0103ed5:	66 c7 05 d2 33 53 f0 	movw   $0x8,0xf05333d2
f0103edc:	08 00 
f0103ede:	c6 05 d4 33 53 f0 00 	movb   $0x0,0xf05333d4
f0103ee5:	c6 05 d5 33 53 f0 8e 	movb   $0x8e,0xf05333d5
f0103eec:	c1 e8 10             	shr    $0x10,%eax
f0103eef:	66 a3 d6 33 53 f0    	mov    %ax,0xf05333d6
  SETGATE(idt[IRQ_OFFSET + IRQ_ERROR], 0, GD_KT, traphandler51, 0);
f0103ef5:	b8 7e 45 10 f0       	mov    $0xf010457e,%eax
f0103efa:	66 a3 f8 33 53 f0    	mov    %ax,0xf05333f8
f0103f00:	66 c7 05 fa 33 53 f0 	movw   $0x8,0xf05333fa
f0103f07:	08 00 
f0103f09:	c6 05 fc 33 53 f0 00 	movb   $0x0,0xf05333fc
f0103f10:	c6 05 fd 33 53 f0 8e 	movb   $0x8e,0xf05333fd
f0103f17:	c1 e8 10             	shr    $0x10,%eax
f0103f1a:	66 a3 fe 33 53 f0    	mov    %ax,0xf05333fe
	trap_init_percpu();
f0103f20:	e8 c9 fa ff ff       	call   f01039ee <trap_init_percpu>
}
f0103f25:	c9                   	leave  
f0103f26:	c3                   	ret    

f0103f27 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0103f27:	55                   	push   %ebp
f0103f28:	89 e5                	mov    %esp,%ebp
f0103f2a:	53                   	push   %ebx
f0103f2b:	83 ec 0c             	sub    $0xc,%esp
f0103f2e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103f31:	ff 33                	pushl  (%ebx)
f0103f33:	68 26 7e 10 f0       	push   $0xf0107e26
f0103f38:	e8 9d fa ff ff       	call   f01039da <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103f3d:	83 c4 08             	add    $0x8,%esp
f0103f40:	ff 73 04             	pushl  0x4(%ebx)
f0103f43:	68 35 7e 10 f0       	push   $0xf0107e35
f0103f48:	e8 8d fa ff ff       	call   f01039da <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103f4d:	83 c4 08             	add    $0x8,%esp
f0103f50:	ff 73 08             	pushl  0x8(%ebx)
f0103f53:	68 44 7e 10 f0       	push   $0xf0107e44
f0103f58:	e8 7d fa ff ff       	call   f01039da <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103f5d:	83 c4 08             	add    $0x8,%esp
f0103f60:	ff 73 0c             	pushl  0xc(%ebx)
f0103f63:	68 53 7e 10 f0       	push   $0xf0107e53
f0103f68:	e8 6d fa ff ff       	call   f01039da <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103f6d:	83 c4 08             	add    $0x8,%esp
f0103f70:	ff 73 10             	pushl  0x10(%ebx)
f0103f73:	68 62 7e 10 f0       	push   $0xf0107e62
f0103f78:	e8 5d fa ff ff       	call   f01039da <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103f7d:	83 c4 08             	add    $0x8,%esp
f0103f80:	ff 73 14             	pushl  0x14(%ebx)
f0103f83:	68 71 7e 10 f0       	push   $0xf0107e71
f0103f88:	e8 4d fa ff ff       	call   f01039da <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103f8d:	83 c4 08             	add    $0x8,%esp
f0103f90:	ff 73 18             	pushl  0x18(%ebx)
f0103f93:	68 80 7e 10 f0       	push   $0xf0107e80
f0103f98:	e8 3d fa ff ff       	call   f01039da <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103f9d:	83 c4 08             	add    $0x8,%esp
f0103fa0:	ff 73 1c             	pushl  0x1c(%ebx)
f0103fa3:	68 8f 7e 10 f0       	push   $0xf0107e8f
f0103fa8:	e8 2d fa ff ff       	call   f01039da <cprintf>
}
f0103fad:	83 c4 10             	add    $0x10,%esp
f0103fb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103fb3:	c9                   	leave  
f0103fb4:	c3                   	ret    

f0103fb5 <print_trapframe>:
{
f0103fb5:	55                   	push   %ebp
f0103fb6:	89 e5                	mov    %esp,%ebp
f0103fb8:	56                   	push   %esi
f0103fb9:	53                   	push   %ebx
f0103fba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0103fbd:	e8 9c 1e 00 00       	call   f0105e5e <cpunum>
f0103fc2:	83 ec 04             	sub    $0x4,%esp
f0103fc5:	50                   	push   %eax
f0103fc6:	53                   	push   %ebx
f0103fc7:	68 f3 7e 10 f0       	push   $0xf0107ef3
f0103fcc:	e8 09 fa ff ff       	call   f01039da <cprintf>
	print_regs(&tf->tf_regs);
f0103fd1:	89 1c 24             	mov    %ebx,(%esp)
f0103fd4:	e8 4e ff ff ff       	call   f0103f27 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103fd9:	83 c4 08             	add    $0x8,%esp
f0103fdc:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0103fe0:	50                   	push   %eax
f0103fe1:	68 11 7f 10 f0       	push   $0xf0107f11
f0103fe6:	e8 ef f9 ff ff       	call   f01039da <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103feb:	83 c4 08             	add    $0x8,%esp
f0103fee:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103ff2:	50                   	push   %eax
f0103ff3:	68 24 7f 10 f0       	push   $0xf0107f24
f0103ff8:	e8 dd f9 ff ff       	call   f01039da <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103ffd:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0104000:	83 c4 10             	add    $0x10,%esp
f0104003:	83 f8 13             	cmp    $0x13,%eax
f0104006:	0f 86 e1 00 00 00    	jbe    f01040ed <print_trapframe+0x138>
		return "System call";
f010400c:	ba 9e 7e 10 f0       	mov    $0xf0107e9e,%edx
	if (trapno == T_SYSCALL)
f0104011:	83 f8 30             	cmp    $0x30,%eax
f0104014:	74 13                	je     f0104029 <print_trapframe+0x74>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0104016:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f0104019:	83 fa 0f             	cmp    $0xf,%edx
f010401c:	ba aa 7e 10 f0       	mov    $0xf0107eaa,%edx
f0104021:	b9 b9 7e 10 f0       	mov    $0xf0107eb9,%ecx
f0104026:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104029:	83 ec 04             	sub    $0x4,%esp
f010402c:	52                   	push   %edx
f010402d:	50                   	push   %eax
f010402e:	68 37 7f 10 f0       	push   $0xf0107f37
f0104033:	e8 a2 f9 ff ff       	call   f01039da <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104038:	83 c4 10             	add    $0x10,%esp
f010403b:	39 1d 60 3a 53 f0    	cmp    %ebx,0xf0533a60
f0104041:	0f 84 b2 00 00 00    	je     f01040f9 <print_trapframe+0x144>
	cprintf("  err  0x%08x", tf->tf_err);
f0104047:	83 ec 08             	sub    $0x8,%esp
f010404a:	ff 73 2c             	pushl  0x2c(%ebx)
f010404d:	68 58 7f 10 f0       	push   $0xf0107f58
f0104052:	e8 83 f9 ff ff       	call   f01039da <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0104057:	83 c4 10             	add    $0x10,%esp
f010405a:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f010405e:	0f 85 b8 00 00 00    	jne    f010411c <print_trapframe+0x167>
			tf->tf_err & 1 ? "protection" : "not-present");
f0104064:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0104067:	89 c2                	mov    %eax,%edx
f0104069:	83 e2 01             	and    $0x1,%edx
f010406c:	b9 cc 7e 10 f0       	mov    $0xf0107ecc,%ecx
f0104071:	ba d7 7e 10 f0       	mov    $0xf0107ed7,%edx
f0104076:	0f 44 ca             	cmove  %edx,%ecx
f0104079:	89 c2                	mov    %eax,%edx
f010407b:	83 e2 02             	and    $0x2,%edx
f010407e:	be e3 7e 10 f0       	mov    $0xf0107ee3,%esi
f0104083:	ba e9 7e 10 f0       	mov    $0xf0107ee9,%edx
f0104088:	0f 45 d6             	cmovne %esi,%edx
f010408b:	83 e0 04             	and    $0x4,%eax
f010408e:	b8 ee 7e 10 f0       	mov    $0xf0107eee,%eax
f0104093:	be 3a 80 10 f0       	mov    $0xf010803a,%esi
f0104098:	0f 44 c6             	cmove  %esi,%eax
f010409b:	51                   	push   %ecx
f010409c:	52                   	push   %edx
f010409d:	50                   	push   %eax
f010409e:	68 66 7f 10 f0       	push   $0xf0107f66
f01040a3:	e8 32 f9 ff ff       	call   f01039da <cprintf>
f01040a8:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f01040ab:	83 ec 08             	sub    $0x8,%esp
f01040ae:	ff 73 30             	pushl  0x30(%ebx)
f01040b1:	68 75 7f 10 f0       	push   $0xf0107f75
f01040b6:	e8 1f f9 ff ff       	call   f01039da <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f01040bb:	83 c4 08             	add    $0x8,%esp
f01040be:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f01040c2:	50                   	push   %eax
f01040c3:	68 84 7f 10 f0       	push   $0xf0107f84
f01040c8:	e8 0d f9 ff ff       	call   f01039da <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f01040cd:	83 c4 08             	add    $0x8,%esp
f01040d0:	ff 73 38             	pushl  0x38(%ebx)
f01040d3:	68 97 7f 10 f0       	push   $0xf0107f97
f01040d8:	e8 fd f8 ff ff       	call   f01039da <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f01040dd:	83 c4 10             	add    $0x10,%esp
f01040e0:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f01040e4:	75 4b                	jne    f0104131 <print_trapframe+0x17c>
}
f01040e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01040e9:	5b                   	pop    %ebx
f01040ea:	5e                   	pop    %esi
f01040eb:	5d                   	pop    %ebp
f01040ec:	c3                   	ret    
		return excnames[trapno];
f01040ed:	8b 14 85 c0 81 10 f0 	mov    -0xfef7e40(,%eax,4),%edx
f01040f4:	e9 30 ff ff ff       	jmp    f0104029 <print_trapframe+0x74>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01040f9:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01040fd:	0f 85 44 ff ff ff    	jne    f0104047 <print_trapframe+0x92>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0104103:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0104106:	83 ec 08             	sub    $0x8,%esp
f0104109:	50                   	push   %eax
f010410a:	68 49 7f 10 f0       	push   $0xf0107f49
f010410f:	e8 c6 f8 ff ff       	call   f01039da <cprintf>
f0104114:	83 c4 10             	add    $0x10,%esp
f0104117:	e9 2b ff ff ff       	jmp    f0104047 <print_trapframe+0x92>
		cprintf("\n");
f010411c:	83 ec 0c             	sub    $0xc,%esp
f010411f:	68 c3 7c 10 f0       	push   $0xf0107cc3
f0104124:	e8 b1 f8 ff ff       	call   f01039da <cprintf>
f0104129:	83 c4 10             	add    $0x10,%esp
f010412c:	e9 7a ff ff ff       	jmp    f01040ab <print_trapframe+0xf6>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104131:	83 ec 08             	sub    $0x8,%esp
f0104134:	ff 73 3c             	pushl  0x3c(%ebx)
f0104137:	68 a6 7f 10 f0       	push   $0xf0107fa6
f010413c:	e8 99 f8 ff ff       	call   f01039da <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104141:	83 c4 08             	add    $0x8,%esp
f0104144:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104148:	50                   	push   %eax
f0104149:	68 b5 7f 10 f0       	push   $0xf0107fb5
f010414e:	e8 87 f8 ff ff       	call   f01039da <cprintf>
f0104153:	83 c4 10             	add    $0x10,%esp
}
f0104156:	eb 8e                	jmp    f01040e6 <print_trapframe+0x131>

f0104158 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0104158:	55                   	push   %ebp
f0104159:	89 e5                	mov    %esp,%ebp
f010415b:	57                   	push   %edi
f010415c:	56                   	push   %esi
f010415d:	53                   	push   %ebx
f010415e:	83 ec 0c             	sub    $0xc,%esp
f0104161:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104164:	0f 20 d6             	mov    %cr2,%esi
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
  if ((tf->tf_cs & 0x3) == 0) 
f0104167:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f010416b:	74 5d                	je     f01041ca <page_fault_handler+0x72>
  // 重要：trap时并没有切换页目录表,只是切换了特权级

	// LAB 4: Your code here.
	 //cprintf("[%08x] user fault va %08x ip %08x and upcall = %08x\n",
		//curenv->env_id, fault_va, tf->tf_eip, curenv->env_pgfault_upcall);
	 if (curenv->env_pgfault_upcall) {
f010416d:	e8 ec 1c 00 00       	call   f0105e5e <cpunum>
f0104172:	6b c0 74             	imul   $0x74,%eax,%eax
f0104175:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f010417b:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f010417f:	75 60                	jne    f01041e1 <page_fault_handler+0x89>
     tf->tf_esp = (uintptr_t)utf;
     env_run(curenv);
   }

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104181:	8b 7b 30             	mov    0x30(%ebx),%edi
		curenv->env_id, fault_va, tf->tf_eip);
f0104184:	e8 d5 1c 00 00       	call   f0105e5e <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104189:	57                   	push   %edi
f010418a:	56                   	push   %esi
		curenv->env_id, fault_va, tf->tf_eip);
f010418b:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010418e:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f0104194:	ff 70 48             	pushl  0x48(%eax)
f0104197:	68 84 81 10 f0       	push   $0xf0108184
f010419c:	e8 39 f8 ff ff       	call   f01039da <cprintf>
	print_trapframe(tf);
f01041a1:	89 1c 24             	mov    %ebx,(%esp)
f01041a4:	e8 0c fe ff ff       	call   f0103fb5 <print_trapframe>
	env_destroy(curenv);
f01041a9:	e8 b0 1c 00 00       	call   f0105e5e <cpunum>
f01041ae:	83 c4 04             	add    $0x4,%esp
f01041b1:	6b c0 74             	imul   $0x74,%eax,%eax
f01041b4:	ff b0 28 40 53 f0    	pushl  -0xfacbfd8(%eax)
f01041ba:	e8 42 f5 ff ff       	call   f0103701 <env_destroy>
}
f01041bf:	83 c4 10             	add    $0x10,%esp
f01041c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01041c5:	5b                   	pop    %ebx
f01041c6:	5e                   	pop    %esi
f01041c7:	5f                   	pop    %edi
f01041c8:	5d                   	pop    %ebp
f01041c9:	c3                   	ret    
    panic("page fault in kernel.\n");
f01041ca:	83 ec 04             	sub    $0x4,%esp
f01041cd:	68 c8 7f 10 f0       	push   $0xf0107fc8
f01041d2:	68 7c 01 00 00       	push   $0x17c
f01041d7:	68 df 7f 10 f0       	push   $0xf0107fdf
f01041dc:	e8 5f be ff ff       	call   f0100040 <_panic>
     if (tf->tf_esp >= UXSTACKTOP-PGSIZE && tf->tf_esp < UXSTACKTOP) {
f01041e1:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01041e4:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
       utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));
f01041ea:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
     if (tf->tf_esp >= UXSTACKTOP-PGSIZE && tf->tf_esp < UXSTACKTOP) {
f01041ef:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f01041f5:	77 05                	ja     f01041fc <page_fault_handler+0xa4>
       utf = (struct UTrapframe *)(tf->tf_esp - 4 - sizeof(struct UTrapframe));
f01041f7:	83 e8 38             	sub    $0x38,%eax
f01041fa:	89 c7                	mov    %eax,%edi
     user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_U | PTE_W | PTE_P);
f01041fc:	e8 5d 1c 00 00       	call   f0105e5e <cpunum>
f0104201:	6a 07                	push   $0x7
f0104203:	6a 34                	push   $0x34
f0104205:	57                   	push   %edi
f0104206:	6b c0 74             	imul   $0x74,%eax,%eax
f0104209:	ff b0 28 40 53 f0    	pushl  -0xfacbfd8(%eax)
f010420f:	e8 66 ee ff ff       	call   f010307a <user_mem_assert>
     utf->utf_fault_va = fault_va;
f0104214:	89 fa                	mov    %edi,%edx
f0104216:	89 37                	mov    %esi,(%edi)
     utf->utf_err = tf->tf_trapno;
f0104218:	8b 43 28             	mov    0x28(%ebx),%eax
f010421b:	89 47 04             	mov    %eax,0x4(%edi)
     utf->utf_regs = tf->tf_regs;
f010421e:	8d 7f 08             	lea    0x8(%edi),%edi
f0104221:	b9 08 00 00 00       	mov    $0x8,%ecx
f0104226:	89 de                	mov    %ebx,%esi
f0104228:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
     utf->utf_eip = tf->tf_eip;
f010422a:	8b 43 30             	mov    0x30(%ebx),%eax
f010422d:	89 42 28             	mov    %eax,0x28(%edx)
     utf->utf_eflags = tf->tf_eflags;
f0104230:	8b 43 38             	mov    0x38(%ebx),%eax
f0104233:	89 d7                	mov    %edx,%edi
f0104235:	89 42 2c             	mov    %eax,0x2c(%edx)
     utf->utf_esp = tf->tf_esp;
f0104238:	8b 43 3c             	mov    0x3c(%ebx),%eax
f010423b:	89 42 30             	mov    %eax,0x30(%edx)
     tf->tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f010423e:	e8 1b 1c 00 00       	call   f0105e5e <cpunum>
f0104243:	6b c0 74             	imul   $0x74,%eax,%eax
f0104246:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f010424c:	8b 40 64             	mov    0x64(%eax),%eax
f010424f:	89 43 30             	mov    %eax,0x30(%ebx)
     tf->tf_esp = (uintptr_t)utf;
f0104252:	89 7b 3c             	mov    %edi,0x3c(%ebx)
     env_run(curenv);
f0104255:	e8 04 1c 00 00       	call   f0105e5e <cpunum>
f010425a:	83 c4 04             	add    $0x4,%esp
f010425d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104260:	ff b0 28 40 53 f0    	pushl  -0xfacbfd8(%eax)
f0104266:	e8 35 f5 ff ff       	call   f01037a0 <env_run>

f010426b <trap>:
{
f010426b:	55                   	push   %ebp
f010426c:	89 e5                	mov    %esp,%ebp
f010426e:	57                   	push   %edi
f010426f:	56                   	push   %esi
f0104270:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0104273:	fc                   	cld    
	if (panicstr)
f0104274:	83 3d 98 3e 53 f0 00 	cmpl   $0x0,0xf0533e98
f010427b:	74 01                	je     f010427e <trap+0x13>
		asm volatile("hlt");
f010427d:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f010427e:	e8 db 1b 00 00       	call   f0105e5e <cpunum>
f0104283:	6b d0 74             	imul   $0x74,%eax,%edx
f0104286:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104289:	b8 01 00 00 00       	mov    $0x1,%eax
f010428e:	f0 87 82 20 40 53 f0 	lock xchg %eax,-0xfacbfe0(%edx)
f0104295:	83 f8 02             	cmp    $0x2,%eax
f0104298:	0f 84 99 00 00 00    	je     f0104337 <trap+0xcc>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f010429e:	9c                   	pushf  
f010429f:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f01042a0:	f6 c4 02             	test   $0x2,%ah
f01042a3:	0f 85 a3 00 00 00    	jne    f010434c <trap+0xe1>
	if ((tf->tf_cs & 3) == 3) {
f01042a9:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f01042ad:	83 e0 03             	and    $0x3,%eax
f01042b0:	66 83 f8 03          	cmp    $0x3,%ax
f01042b4:	0f 84 ab 00 00 00    	je     f0104365 <trap+0xfa>
	last_tf = tf;
f01042ba:	89 35 60 3a 53 f0    	mov    %esi,0xf0533a60
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f01042c0:	8b 46 28             	mov    0x28(%esi),%eax
f01042c3:	83 f8 27             	cmp    $0x27,%eax
f01042c6:	0f 84 3e 01 00 00    	je     f010440a <trap+0x19f>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f01042cc:	83 f8 20             	cmp    $0x20,%eax
f01042cf:	0f 84 4f 01 00 00    	je     f0104424 <trap+0x1b9>
  if (tf->tf_trapno == IRQ_OFFSET + IRQ_KBD) {
f01042d5:	83 f8 21             	cmp    $0x21,%eax
f01042d8:	0f 84 68 01 00 00    	je     f0104446 <trap+0x1db>
  if (tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL) {
f01042de:	83 f8 24             	cmp    $0x24,%eax
f01042e1:	0f 84 66 01 00 00    	je     f010444d <trap+0x1e2>
  switch (tf->tf_trapno) {
f01042e7:	83 f8 0e             	cmp    $0xe,%eax
f01042ea:	0f 84 64 01 00 00    	je     f0104454 <trap+0x1e9>
f01042f0:	83 f8 30             	cmp    $0x30,%eax
f01042f3:	0f 84 9f 01 00 00    	je     f0104498 <trap+0x22d>
f01042f9:	83 f8 03             	cmp    $0x3,%eax
f01042fc:	0f 84 88 01 00 00    	je     f010448a <trap+0x21f>
	print_trapframe(tf);
f0104302:	83 ec 0c             	sub    $0xc,%esp
f0104305:	56                   	push   %esi
f0104306:	e8 aa fc ff ff       	call   f0103fb5 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f010430b:	83 c4 10             	add    $0x10,%esp
f010430e:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104313:	0f 84 a0 01 00 00    	je     f01044b9 <trap+0x24e>
		env_destroy(curenv);
f0104319:	e8 40 1b 00 00       	call   f0105e5e <cpunum>
f010431e:	83 ec 0c             	sub    $0xc,%esp
f0104321:	6b c0 74             	imul   $0x74,%eax,%eax
f0104324:	ff b0 28 40 53 f0    	pushl  -0xfacbfd8(%eax)
f010432a:	e8 d2 f3 ff ff       	call   f0103701 <env_destroy>
f010432f:	83 c4 10             	add    $0x10,%esp
f0104332:	e9 29 01 00 00       	jmp    f0104460 <trap+0x1f5>
	spin_lock(&kernel_lock);
f0104337:	83 ec 0c             	sub    $0xc,%esp
f010433a:	68 c0 53 12 f0       	push   $0xf01253c0
f010433f:	e8 8a 1d 00 00       	call   f01060ce <spin_lock>
f0104344:	83 c4 10             	add    $0x10,%esp
f0104347:	e9 52 ff ff ff       	jmp    f010429e <trap+0x33>
	assert(!(read_eflags() & FL_IF));
f010434c:	68 eb 7f 10 f0       	push   $0xf0107feb
f0104351:	68 ae 79 10 f0       	push   $0xf01079ae
f0104356:	68 45 01 00 00       	push   $0x145
f010435b:	68 df 7f 10 f0       	push   $0xf0107fdf
f0104360:	e8 db bc ff ff       	call   f0100040 <_panic>
f0104365:	83 ec 0c             	sub    $0xc,%esp
f0104368:	68 c0 53 12 f0       	push   $0xf01253c0
f010436d:	e8 5c 1d 00 00       	call   f01060ce <spin_lock>
		assert(curenv);
f0104372:	e8 e7 1a 00 00       	call   f0105e5e <cpunum>
f0104377:	6b c0 74             	imul   $0x74,%eax,%eax
f010437a:	83 c4 10             	add    $0x10,%esp
f010437d:	83 b8 28 40 53 f0 00 	cmpl   $0x0,-0xfacbfd8(%eax)
f0104384:	74 3e                	je     f01043c4 <trap+0x159>
		if (curenv->env_status == ENV_DYING) {
f0104386:	e8 d3 1a 00 00       	call   f0105e5e <cpunum>
f010438b:	6b c0 74             	imul   $0x74,%eax,%eax
f010438e:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f0104394:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104398:	74 43                	je     f01043dd <trap+0x172>
		curenv->env_tf = *tf;
f010439a:	e8 bf 1a 00 00       	call   f0105e5e <cpunum>
f010439f:	6b c0 74             	imul   $0x74,%eax,%eax
f01043a2:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f01043a8:	b9 11 00 00 00       	mov    $0x11,%ecx
f01043ad:	89 c7                	mov    %eax,%edi
f01043af:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f01043b1:	e8 a8 1a 00 00       	call   f0105e5e <cpunum>
f01043b6:	6b c0 74             	imul   $0x74,%eax,%eax
f01043b9:	8b b0 28 40 53 f0    	mov    -0xfacbfd8(%eax),%esi
f01043bf:	e9 f6 fe ff ff       	jmp    f01042ba <trap+0x4f>
		assert(curenv);
f01043c4:	68 04 80 10 f0       	push   $0xf0108004
f01043c9:	68 ae 79 10 f0       	push   $0xf01079ae
f01043ce:	68 4d 01 00 00       	push   $0x14d
f01043d3:	68 df 7f 10 f0       	push   $0xf0107fdf
f01043d8:	e8 63 bc ff ff       	call   f0100040 <_panic>
			env_free(curenv);
f01043dd:	e8 7c 1a 00 00       	call   f0105e5e <cpunum>
f01043e2:	83 ec 0c             	sub    $0xc,%esp
f01043e5:	6b c0 74             	imul   $0x74,%eax,%eax
f01043e8:	ff b0 28 40 53 f0    	pushl  -0xfacbfd8(%eax)
f01043ee:	e8 60 f1 ff ff       	call   f0103553 <env_free>
			curenv = NULL;
f01043f3:	e8 66 1a 00 00       	call   f0105e5e <cpunum>
f01043f8:	6b c0 74             	imul   $0x74,%eax,%eax
f01043fb:	c7 80 28 40 53 f0 00 	movl   $0x0,-0xfacbfd8(%eax)
f0104402:	00 00 00 
			sched_yield();
f0104405:	e8 55 02 00 00       	call   f010465f <sched_yield>
		cprintf("Spurious interrupt on irq 7\n");
f010440a:	83 ec 0c             	sub    $0xc,%esp
f010440d:	68 0b 80 10 f0       	push   $0xf010800b
f0104412:	e8 c3 f5 ff ff       	call   f01039da <cprintf>
		print_trapframe(tf);
f0104417:	89 34 24             	mov    %esi,(%esp)
f010441a:	e8 96 fb ff ff       	call   f0103fb5 <print_trapframe>
f010441f:	83 c4 10             	add    $0x10,%esp
f0104422:	eb 3c                	jmp    f0104460 <trap+0x1f5>
    lapic_eoi();
f0104424:	e8 7c 1b 00 00       	call   f0105fa5 <lapic_eoi>
    if (thiscpu->cpu_id == 0)
f0104429:	e8 30 1a 00 00       	call   f0105e5e <cpunum>
f010442e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104431:	80 b8 20 40 53 f0 00 	cmpb   $0x0,-0xfacbfe0(%eax)
f0104438:	74 05                	je     f010443f <trap+0x1d4>
    sched_yield();
f010443a:	e8 20 02 00 00       	call   f010465f <sched_yield>
      time_tick();
f010443f:	e8 44 23 00 00       	call   f0106788 <time_tick>
f0104444:	eb f4                	jmp    f010443a <trap+0x1cf>
    kbd_intr();
f0104446:	e8 dc c1 ff ff       	call   f0100627 <kbd_intr>
f010444b:	eb 13                	jmp    f0104460 <trap+0x1f5>
    serial_intr();
f010444d:	e8 b9 c1 ff ff       	call   f010060b <serial_intr>
f0104452:	eb 0c                	jmp    f0104460 <trap+0x1f5>
      page_fault_handler(tf);
f0104454:	83 ec 0c             	sub    $0xc,%esp
f0104457:	56                   	push   %esi
f0104458:	e8 fb fc ff ff       	call   f0104158 <page_fault_handler>
f010445d:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104460:	e8 f9 19 00 00       	call   f0105e5e <cpunum>
f0104465:	6b c0 74             	imul   $0x74,%eax,%eax
f0104468:	83 b8 28 40 53 f0 00 	cmpl   $0x0,-0xfacbfd8(%eax)
f010446f:	74 14                	je     f0104485 <trap+0x21a>
f0104471:	e8 e8 19 00 00       	call   f0105e5e <cpunum>
f0104476:	6b c0 74             	imul   $0x74,%eax,%eax
f0104479:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f010447f:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104483:	74 4b                	je     f01044d0 <trap+0x265>
		sched_yield();
f0104485:	e8 d5 01 00 00       	call   f010465f <sched_yield>
      monitor(tf);
f010448a:	83 ec 0c             	sub    $0xc,%esp
f010448d:	56                   	push   %esi
f010448e:	e8 f8 c4 ff ff       	call   f010098b <monitor>
f0104493:	83 c4 10             	add    $0x10,%esp
f0104496:	eb c8                	jmp    f0104460 <trap+0x1f5>
      tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax,
f0104498:	83 ec 08             	sub    $0x8,%esp
f010449b:	ff 76 04             	pushl  0x4(%esi)
f010449e:	ff 36                	pushl  (%esi)
f01044a0:	ff 76 10             	pushl  0x10(%esi)
f01044a3:	ff 76 18             	pushl  0x18(%esi)
f01044a6:	ff 76 14             	pushl  0x14(%esi)
f01044a9:	ff 76 1c             	pushl  0x1c(%esi)
f01044ac:	e8 1a 02 00 00       	call   f01046cb <syscall>
f01044b1:	89 46 1c             	mov    %eax,0x1c(%esi)
f01044b4:	83 c4 20             	add    $0x20,%esp
f01044b7:	eb a7                	jmp    f0104460 <trap+0x1f5>
		panic("unhandled trap in kernel");
f01044b9:	83 ec 04             	sub    $0x4,%esp
f01044bc:	68 28 80 10 f0       	push   $0xf0108028
f01044c1:	68 2b 01 00 00       	push   $0x12b
f01044c6:	68 df 7f 10 f0       	push   $0xf0107fdf
f01044cb:	e8 70 bb ff ff       	call   f0100040 <_panic>
		env_run(curenv);
f01044d0:	e8 89 19 00 00       	call   f0105e5e <cpunum>
f01044d5:	83 ec 0c             	sub    $0xc,%esp
f01044d8:	6b c0 74             	imul   $0x74,%eax,%eax
f01044db:	ff b0 28 40 53 f0    	pushl  -0xfacbfd8(%eax)
f01044e1:	e8 ba f2 ff ff       	call   f01037a0 <env_run>

f01044e6 <traphandler0>:
//	TRAPHANDLER_NOEC(fperr_handler, T_FPERR)					
//	TRAPHANDLER(align_handler, T_ALIGN)					
//	TRAPHANDLER_NOEC(mchk_handler, T_MCHK)					
//	TRAPHANDLER_NOEC(simderr_handler, T_SIMDERR)					

TRAPHANDLER_NOEC(traphandler0, T_DIVIDE)
f01044e6:	6a 00                	push   $0x0
f01044e8:	6a 00                	push   $0x0
f01044ea:	e9 95 00 00 00       	jmp    f0104584 <_alltraps>
f01044ef:	90                   	nop

f01044f0 <traphandler1>:
TRAPHANDLER_NOEC(traphandler1, T_DEBUG)
f01044f0:	6a 00                	push   $0x0
f01044f2:	6a 01                	push   $0x1
f01044f4:	e9 8b 00 00 00       	jmp    f0104584 <_alltraps>
f01044f9:	90                   	nop

f01044fa <traphandler2>:
TRAPHANDLER_NOEC(traphandler2, T_NMI)
f01044fa:	6a 00                	push   $0x0
f01044fc:	6a 02                	push   $0x2
f01044fe:	e9 81 00 00 00       	jmp    f0104584 <_alltraps>
f0104503:	90                   	nop

f0104504 <traphandler3>:
TRAPHANDLER_NOEC(traphandler3, T_BRKPT)
f0104504:	6a 00                	push   $0x0
f0104506:	6a 03                	push   $0x3
f0104508:	eb 7a                	jmp    f0104584 <_alltraps>

f010450a <traphandler4>:
TRAPHANDLER_NOEC(traphandler4, T_OFLOW)
f010450a:	6a 00                	push   $0x0
f010450c:	6a 04                	push   $0x4
f010450e:	eb 74                	jmp    f0104584 <_alltraps>

f0104510 <traphandler5>:
TRAPHANDLER_NOEC(traphandler5, T_BOUND)
f0104510:	6a 00                	push   $0x0
f0104512:	6a 05                	push   $0x5
f0104514:	eb 6e                	jmp    f0104584 <_alltraps>

f0104516 <traphandler6>:
TRAPHANDLER_NOEC(traphandler6, T_ILLOP)
f0104516:	6a 00                	push   $0x0
f0104518:	6a 06                	push   $0x6
f010451a:	eb 68                	jmp    f0104584 <_alltraps>

f010451c <traphandler7>:
TRAPHANDLER_NOEC(traphandler7, T_DEVICE)
f010451c:	6a 00                	push   $0x0
f010451e:	6a 07                	push   $0x7
f0104520:	eb 62                	jmp    f0104584 <_alltraps>

f0104522 <traphandler8>:
TRAPHANDLER(traphandler8, T_DBLFLT)
f0104522:	6a 08                	push   $0x8
f0104524:	eb 5e                	jmp    f0104584 <_alltraps>

f0104526 <traphandler10>:
// 9 deprecated since 386
TRAPHANDLER(traphandler10, T_TSS)
f0104526:	6a 0a                	push   $0xa
f0104528:	eb 5a                	jmp    f0104584 <_alltraps>

f010452a <traphandler11>:
TRAPHANDLER(traphandler11, T_SEGNP)
f010452a:	6a 0b                	push   $0xb
f010452c:	eb 56                	jmp    f0104584 <_alltraps>

f010452e <traphandler12>:
TRAPHANDLER(traphandler12, T_STACK)
f010452e:	6a 0c                	push   $0xc
f0104530:	eb 52                	jmp    f0104584 <_alltraps>

f0104532 <traphandler13>:
TRAPHANDLER(traphandler13, T_GPFLT)
f0104532:	6a 0d                	push   $0xd
f0104534:	eb 4e                	jmp    f0104584 <_alltraps>

f0104536 <traphandler14>:
TRAPHANDLER(traphandler14, T_PGFLT)
f0104536:	6a 0e                	push   $0xe
f0104538:	eb 4a                	jmp    f0104584 <_alltraps>

f010453a <traphandler16>:
// 15 reserved by intel
TRAPHANDLER_NOEC(traphandler16, T_FPERR)
f010453a:	6a 00                	push   $0x0
f010453c:	6a 10                	push   $0x10
f010453e:	eb 44                	jmp    f0104584 <_alltraps>

f0104540 <traphandler17>:
TRAPHANDLER(traphandler17, T_ALIGN)
f0104540:	6a 11                	push   $0x11
f0104542:	eb 40                	jmp    f0104584 <_alltraps>

f0104544 <traphandler18>:
TRAPHANDLER_NOEC(traphandler18, T_MCHK)
f0104544:	6a 00                	push   $0x0
f0104546:	6a 12                	push   $0x12
f0104548:	eb 3a                	jmp    f0104584 <_alltraps>

f010454a <traphandler19>:
TRAPHANDLER_NOEC(traphandler19, T_SIMDERR)
f010454a:	6a 00                	push   $0x0
f010454c:	6a 13                	push   $0x13
f010454e:	eb 34                	jmp    f0104584 <_alltraps>

f0104550 <traphandler48>:

// system call (interrupt)
TRAPHANDLER_NOEC(traphandler48, T_SYSCALL)
f0104550:	6a 00                	push   $0x0
f0104552:	6a 30                	push   $0x30
f0104554:	eb 2e                	jmp    f0104584 <_alltraps>

f0104556 <traphandler500>:
TRAPHANDLER_NOEC(traphandler500, T_DEFAULT)
f0104556:	6a 00                	push   $0x0
f0104558:	68 f4 01 00 00       	push   $0x1f4
f010455d:	eb 25                	jmp    f0104584 <_alltraps>
f010455f:	90                   	nop

f0104560 <traphandler32>:

//IRQS
//必须用TRAPHANDLER_NOEC而不是TRAPHANDLER
TRAPHANDLER_NOEC(traphandler32, IRQ_OFFSET + IRQ_TIMER)
f0104560:	6a 00                	push   $0x0
f0104562:	6a 20                	push   $0x20
f0104564:	eb 1e                	jmp    f0104584 <_alltraps>

f0104566 <traphandler33>:
TRAPHANDLER_NOEC(traphandler33, IRQ_OFFSET + IRQ_KBD)
f0104566:	6a 00                	push   $0x0
f0104568:	6a 21                	push   $0x21
f010456a:	eb 18                	jmp    f0104584 <_alltraps>

f010456c <traphandler36>:
TRAPHANDLER_NOEC(traphandler36, IRQ_OFFSET + IRQ_SERIAL)
f010456c:	6a 00                	push   $0x0
f010456e:	6a 24                	push   $0x24
f0104570:	eb 12                	jmp    f0104584 <_alltraps>

f0104572 <traphandler39>:
TRAPHANDLER_NOEC(traphandler39, IRQ_OFFSET + IRQ_SPURIOUS)
f0104572:	6a 00                	push   $0x0
f0104574:	6a 27                	push   $0x27
f0104576:	eb 0c                	jmp    f0104584 <_alltraps>

f0104578 <traphandler46>:
TRAPHANDLER_NOEC(traphandler46, IRQ_OFFSET + IRQ_IDE)
f0104578:	6a 00                	push   $0x0
f010457a:	6a 2e                	push   $0x2e
f010457c:	eb 06                	jmp    f0104584 <_alltraps>

f010457e <traphandler51>:
TRAPHANDLER_NOEC(traphandler51, IRQ_OFFSET + IRQ_ERROR)
f010457e:	6a 00                	push   $0x0
f0104580:	6a 33                	push   $0x33
f0104582:	eb 00                	jmp    f0104584 <_alltraps>

f0104584 <_alltraps>:
/*
 * Lab 3: Your code here for _alltraps
 */
.globl _alltraps
_alltraps:
  pushl %ds
f0104584:	1e                   	push   %ds
  pushl %es
f0104585:	06                   	push   %es
  pushal
f0104586:	60                   	pusha  

  movw $(GD_KD), %ax
f0104587:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
f010458b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
f010458d:	8e c0                	mov    %eax,%es

  pushl %esp
f010458f:	54                   	push   %esp
  call trap
f0104590:	e8 d6 fc ff ff       	call   f010426b <trap>

f0104595 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104595:	55                   	push   %ebp
f0104596:	89 e5                	mov    %esp,%ebp
f0104598:	83 ec 08             	sub    $0x8,%esp
f010459b:	a1 48 32 53 f0       	mov    0xf0533248,%eax
f01045a0:	8d 50 54             	lea    0x54(%eax),%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f01045a3:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f01045a8:	8b 02                	mov    (%edx),%eax
f01045aa:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f01045ad:	83 f8 02             	cmp    $0x2,%eax
f01045b0:	76 2d                	jbe    f01045df <sched_halt+0x4a>
	for (i = 0; i < NENV; i++) {
f01045b2:	83 c1 01             	add    $0x1,%ecx
f01045b5:	83 c2 7c             	add    $0x7c,%edx
f01045b8:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01045be:	75 e8                	jne    f01045a8 <sched_halt+0x13>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f01045c0:	83 ec 0c             	sub    $0xc,%esp
f01045c3:	68 10 82 10 f0       	push   $0xf0108210
f01045c8:	e8 0d f4 ff ff       	call   f01039da <cprintf>
f01045cd:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f01045d0:	83 ec 0c             	sub    $0xc,%esp
f01045d3:	6a 00                	push   $0x0
f01045d5:	e8 b1 c3 ff ff       	call   f010098b <monitor>
f01045da:	83 c4 10             	add    $0x10,%esp
f01045dd:	eb f1                	jmp    f01045d0 <sched_halt+0x3b>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f01045df:	e8 7a 18 00 00       	call   f0105e5e <cpunum>
f01045e4:	6b c0 74             	imul   $0x74,%eax,%eax
f01045e7:	c7 80 28 40 53 f0 00 	movl   $0x0,-0xfacbfd8(%eax)
f01045ee:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f01045f1:	a1 a4 3e 53 f0       	mov    0xf0533ea4,%eax
	if ((uint32_t)kva < KERNBASE)
f01045f6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01045fb:	76 50                	jbe    f010464d <sched_halt+0xb8>
	return (physaddr_t)kva - KERNBASE;
f01045fd:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104602:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104605:	e8 54 18 00 00       	call   f0105e5e <cpunum>
f010460a:	6b d0 74             	imul   $0x74,%eax,%edx
f010460d:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104610:	b8 02 00 00 00       	mov    $0x2,%eax
f0104615:	f0 87 82 20 40 53 f0 	lock xchg %eax,-0xfacbfe0(%edx)
	spin_unlock(&kernel_lock);
f010461c:	83 ec 0c             	sub    $0xc,%esp
f010461f:	68 c0 53 12 f0       	push   $0xf01253c0
f0104624:	e8 41 1b 00 00       	call   f010616a <spin_unlock>
	asm volatile("pause");
f0104629:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f010462b:	e8 2e 18 00 00       	call   f0105e5e <cpunum>
f0104630:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f0104633:	8b 80 30 40 53 f0    	mov    -0xfacbfd0(%eax),%eax
f0104639:	bd 00 00 00 00       	mov    $0x0,%ebp
f010463e:	89 c4                	mov    %eax,%esp
f0104640:	6a 00                	push   $0x0
f0104642:	6a 00                	push   $0x0
f0104644:	fb                   	sti    
f0104645:	f4                   	hlt    
f0104646:	eb fd                	jmp    f0104645 <sched_halt+0xb0>
}
f0104648:	83 c4 10             	add    $0x10,%esp
f010464b:	c9                   	leave  
f010464c:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010464d:	50                   	push   %eax
f010464e:	68 68 6a 10 f0       	push   $0xf0106a68
f0104653:	6a 60                	push   $0x60
f0104655:	68 39 82 10 f0       	push   $0xf0108239
f010465a:	e8 e1 b9 ff ff       	call   f0100040 <_panic>

f010465f <sched_yield>:
{
f010465f:	55                   	push   %ebp
f0104660:	89 e5                	mov    %esp,%ebp
f0104662:	56                   	push   %esi
f0104663:	53                   	push   %ebx
	idle = thiscpu->cpu_env;
f0104664:	e8 f5 17 00 00       	call   f0105e5e <cpunum>
f0104669:	6b c0 74             	imul   $0x74,%eax,%eax
f010466c:	8b b0 28 40 53 f0    	mov    -0xfacbfd8(%eax),%esi
    uint32_t start = (idle != NULL) ? ENVX( idle->env_id) : 0;
f0104672:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104677:	85 f6                	test   %esi,%esi
f0104679:	74 09                	je     f0104684 <sched_yield+0x25>
f010467b:	8b 4e 48             	mov    0x48(%esi),%ecx
f010467e:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
        if(envs[i].env_status == ENV_RUNNABLE)
f0104684:	8b 1d 48 32 53 f0    	mov    0xf0533248,%ebx
    uint32_t i = start;
f010468a:	89 c8                	mov    %ecx,%eax
        if(envs[i].env_status == ENV_RUNNABLE)
f010468c:	6b d0 7c             	imul   $0x7c,%eax,%edx
f010468f:	01 da                	add    %ebx,%edx
f0104691:	83 7a 54 02          	cmpl   $0x2,0x54(%edx)
f0104695:	74 22                	je     f01046b9 <sched_yield+0x5a>
    for (; i != start || first; i = (i+1) % NENV, first = false)
f0104697:	83 c0 01             	add    $0x1,%eax
f010469a:	25 ff 03 00 00       	and    $0x3ff,%eax
f010469f:	39 c1                	cmp    %eax,%ecx
f01046a1:	75 e9                	jne    f010468c <sched_yield+0x2d>
    if (idle && idle->env_status == ENV_RUNNING)
f01046a3:	85 f6                	test   %esi,%esi
f01046a5:	74 06                	je     f01046ad <sched_yield+0x4e>
f01046a7:	83 7e 54 03          	cmpl   $0x3,0x54(%esi)
f01046ab:	74 15                	je     f01046c2 <sched_yield+0x63>
	  sched_halt();
f01046ad:	e8 e3 fe ff ff       	call   f0104595 <sched_halt>
}
f01046b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01046b5:	5b                   	pop    %ebx
f01046b6:	5e                   	pop    %esi
f01046b7:	5d                   	pop    %ebp
f01046b8:	c3                   	ret    
            env_run(&envs[i]);
f01046b9:	83 ec 0c             	sub    $0xc,%esp
f01046bc:	52                   	push   %edx
f01046bd:	e8 de f0 ff ff       	call   f01037a0 <env_run>
        env_run(idle);
f01046c2:	83 ec 0c             	sub    $0xc,%esp
f01046c5:	56                   	push   %esi
f01046c6:	e8 d5 f0 ff ff       	call   f01037a0 <env_run>

f01046cb <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f01046cb:	55                   	push   %ebp
f01046cc:	89 e5                	mov    %esp,%ebp
f01046ce:	57                   	push   %edi
f01046cf:	56                   	push   %esi
f01046d0:	53                   	push   %ebx
f01046d1:	83 ec 1c             	sub    $0x1c,%esp
f01046d4:	8b 45 08             	mov    0x8(%ebp),%eax
f01046d7:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
	//panic("syscall not implemented");

	switch (syscallno) {
f01046da:	83 f8 0e             	cmp    $0xe,%eax
f01046dd:	0f 87 96 05 00 00    	ja     f0104c79 <syscall+0x5ae>
f01046e3:	ff 24 85 48 82 10 f0 	jmp    *-0xfef7db8(,%eax,4)
  user_mem_assert(curenv, (void*)s, len, PTE_U);
f01046ea:	e8 6f 17 00 00       	call   f0105e5e <cpunum>
f01046ef:	6a 04                	push   $0x4
f01046f1:	57                   	push   %edi
f01046f2:	ff 75 0c             	pushl  0xc(%ebp)
f01046f5:	6b c0 74             	imul   $0x74,%eax,%eax
f01046f8:	ff b0 28 40 53 f0    	pushl  -0xfacbfd8(%eax)
f01046fe:	e8 77 e9 ff ff       	call   f010307a <user_mem_assert>
	cprintf("%.*s", len, s);
f0104703:	83 c4 0c             	add    $0xc,%esp
f0104706:	ff 75 0c             	pushl  0xc(%ebp)
f0104709:	57                   	push   %edi
f010470a:	68 b9 6d 10 f0       	push   $0xf0106db9
f010470f:	e8 c6 f2 ff ff       	call   f01039da <cprintf>
f0104714:	83 c4 10             	add    $0x10,%esp
    case SYS_cputs:
      sys_cputs((char*)a1, a2);
      return 0;
f0104717:	bb 00 00 00 00       	mov    $0x0,%ebx
    case SYS_time_msec:
      return sys_time_msec();
	  default:
		  return -E_INVAL;
	}
}
f010471c:	89 d8                	mov    %ebx,%eax
f010471e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104721:	5b                   	pop    %ebx
f0104722:	5e                   	pop    %esi
f0104723:	5f                   	pop    %edi
f0104724:	5d                   	pop    %ebp
f0104725:	c3                   	ret    
	return cons_getc();
f0104726:	e8 0e bf ff ff       	call   f0100639 <cons_getc>
f010472b:	89 c3                	mov    %eax,%ebx
      return sys_cgetc();
f010472d:	eb ed                	jmp    f010471c <syscall+0x51>
	return curenv->env_id;
f010472f:	e8 2a 17 00 00       	call   f0105e5e <cpunum>
f0104734:	6b c0 74             	imul   $0x74,%eax,%eax
f0104737:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f010473d:	8b 58 48             	mov    0x48(%eax),%ebx
      return sys_getenvid();
f0104740:	eb da                	jmp    f010471c <syscall+0x51>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0104742:	83 ec 04             	sub    $0x4,%esp
f0104745:	6a 01                	push   $0x1
f0104747:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010474a:	50                   	push   %eax
f010474b:	ff 75 0c             	pushl  0xc(%ebp)
f010474e:	e8 de e9 ff ff       	call   f0103131 <envid2env>
f0104753:	89 c3                	mov    %eax,%ebx
f0104755:	83 c4 10             	add    $0x10,%esp
f0104758:	85 c0                	test   %eax,%eax
f010475a:	78 c0                	js     f010471c <syscall+0x51>
	env_destroy(e);
f010475c:	83 ec 0c             	sub    $0xc,%esp
f010475f:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104762:	e8 9a ef ff ff       	call   f0103701 <env_destroy>
f0104767:	83 c4 10             	add    $0x10,%esp
	return 0;
f010476a:	bb 00 00 00 00       	mov    $0x0,%ebx
      return sys_env_destroy(a1);
f010476f:	eb ab                	jmp    f010471c <syscall+0x51>
  struct PageInfo *pp = page_alloc(ALLOC_ZERO);
f0104771:	83 ec 0c             	sub    $0xc,%esp
f0104774:	6a 01                	push   $0x1
f0104776:	e8 3a c8 ff ff       	call   f0100fb5 <page_alloc>
f010477b:	89 c6                	mov    %eax,%esi
  if (pp == NULL) return -E_NO_MEM;
f010477d:	83 c4 10             	add    $0x10,%esp
f0104780:	85 c0                	test   %eax,%eax
f0104782:	74 78                	je     f01047fc <syscall+0x131>
  if (envid2env(envid, &e, 1) != 0) return -E_BAD_ENV;
f0104784:	83 ec 04             	sub    $0x4,%esp
f0104787:	6a 01                	push   $0x1
f0104789:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010478c:	50                   	push   %eax
f010478d:	ff 75 0c             	pushl  0xc(%ebp)
f0104790:	e8 9c e9 ff ff       	call   f0103131 <envid2env>
f0104795:	83 c4 10             	add    $0x10,%esp
f0104798:	85 c0                	test   %eax,%eax
f010479a:	75 6a                	jne    f0104806 <syscall+0x13b>
  if (va >= (void*)UTOP || PGOFF(va) != 0) return -E_INVAL;
f010479c:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f01047a2:	77 6c                	ja     f0104810 <syscall+0x145>
f01047a4:	89 fa                	mov    %edi,%edx
f01047a6:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  if ((perm & (~PTE_SYSCALL)) != 0) return -E_INVAL;
f01047ac:	8b 45 14             	mov    0x14(%ebp),%eax
f01047af:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f01047b4:	09 c2                	or     %eax,%edx
f01047b6:	75 62                	jne    f010481a <syscall+0x14f>
  if ((perm & (PTE_U|PTE_P)) != (PTE_U|PTE_P)) return -E_INVAL;
f01047b8:	8b 45 14             	mov    0x14(%ebp),%eax
f01047bb:	83 e0 05             	and    $0x5,%eax
f01047be:	83 f8 05             	cmp    $0x5,%eax
f01047c1:	75 61                	jne    f0104824 <syscall+0x159>
  if (page_insert(e->env_pgdir, pp, va, perm) != 0) {
f01047c3:	ff 75 14             	pushl  0x14(%ebp)
f01047c6:	57                   	push   %edi
f01047c7:	56                   	push   %esi
f01047c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01047cb:	ff 70 60             	pushl  0x60(%eax)
f01047ce:	e8 38 cb ff ff       	call   f010130b <page_insert>
f01047d3:	89 c3                	mov    %eax,%ebx
f01047d5:	83 c4 10             	add    $0x10,%esp
f01047d8:	85 c0                	test   %eax,%eax
f01047da:	0f 84 3c ff ff ff    	je     f010471c <syscall+0x51>
    pp->pp_ref = 0;
f01047e0:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)
    page_free(pp);
f01047e6:	83 ec 0c             	sub    $0xc,%esp
f01047e9:	56                   	push   %esi
f01047ea:	e8 38 c8 ff ff       	call   f0101027 <page_free>
f01047ef:	83 c4 10             	add    $0x10,%esp
    return -E_NO_MEM;
f01047f2:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01047f7:	e9 20 ff ff ff       	jmp    f010471c <syscall+0x51>
  if (pp == NULL) return -E_NO_MEM;
f01047fc:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f0104801:	e9 16 ff ff ff       	jmp    f010471c <syscall+0x51>
  if (envid2env(envid, &e, 1) != 0) return -E_BAD_ENV;
f0104806:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f010480b:	e9 0c ff ff ff       	jmp    f010471c <syscall+0x51>
  if (va >= (void*)UTOP || PGOFF(va) != 0) return -E_INVAL;
f0104810:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104815:	e9 02 ff ff ff       	jmp    f010471c <syscall+0x51>
  if ((perm & (~PTE_SYSCALL)) != 0) return -E_INVAL;
f010481a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010481f:	e9 f8 fe ff ff       	jmp    f010471c <syscall+0x51>
  if ((perm & (PTE_U|PTE_P)) != (PTE_U|PTE_P)) return -E_INVAL;
f0104824:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
      return sys_page_alloc(a1, (void*)a2, a3);
f0104829:	e9 ee fe ff ff       	jmp    f010471c <syscall+0x51>
  if ((perm & (~PTE_SYSCALL)) != 0) return -E_INVAL;
f010482e:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0104831:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
  if ((perm & (PTE_U|PTE_P)) != (PTE_U|PTE_P)) return -E_INVAL;
f0104836:	8b 55 1c             	mov    0x1c(%ebp),%edx
f0104839:	83 e2 05             	and    $0x5,%edx
  if (srcva >= (void*)UTOP || PGOFF(srcva) != 0) return -E_INVAL;
f010483c:	83 fa 05             	cmp    $0x5,%edx
f010483f:	0f 85 b9 00 00 00    	jne    f01048fe <syscall+0x233>
f0104845:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f010484b:	0f 87 ad 00 00 00    	ja     f01048fe <syscall+0x233>
f0104851:	89 fa                	mov    %edi,%edx
f0104853:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  if (dstva >= (void*)UTOP || PGOFF(dstva) != 0) return -E_INVAL;
f0104859:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0104860:	0f 87 a2 00 00 00    	ja     f0104908 <syscall+0x23d>
f0104866:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0104869:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
f010486f:	09 d0                	or     %edx,%eax
f0104871:	09 c1                	or     %eax,%ecx
f0104873:	0f 85 99 00 00 00    	jne    f0104912 <syscall+0x247>
  if (envid2env(srcenvid, &srcenv, 1) != 0 ) return -E_BAD_ENV;
f0104879:	83 ec 04             	sub    $0x4,%esp
f010487c:	6a 01                	push   $0x1
f010487e:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104881:	50                   	push   %eax
f0104882:	ff 75 0c             	pushl  0xc(%ebp)
f0104885:	e8 a7 e8 ff ff       	call   f0103131 <envid2env>
f010488a:	83 c4 10             	add    $0x10,%esp
f010488d:	85 c0                	test   %eax,%eax
f010488f:	0f 85 87 00 00 00    	jne    f010491c <syscall+0x251>
  if (envid2env(dstenvid, &dstenv, 1) != 0 ) return -E_BAD_ENV;
f0104895:	83 ec 04             	sub    $0x4,%esp
f0104898:	6a 01                	push   $0x1
f010489a:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010489d:	50                   	push   %eax
f010489e:	ff 75 14             	pushl  0x14(%ebp)
f01048a1:	e8 8b e8 ff ff       	call   f0103131 <envid2env>
f01048a6:	83 c4 10             	add    $0x10,%esp
f01048a9:	85 c0                	test   %eax,%eax
f01048ab:	75 79                	jne    f0104926 <syscall+0x25b>
  struct PageInfo *pp = page_lookup(srcenv->env_pgdir, srcva, &src_pte);
f01048ad:	83 ec 04             	sub    $0x4,%esp
f01048b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01048b3:	50                   	push   %eax
f01048b4:	57                   	push   %edi
f01048b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01048b8:	ff 70 60             	pushl  0x60(%eax)
f01048bb:	e8 67 c9 ff ff       	call   f0101227 <page_lookup>
  if (pp == NULL) return -E_INVAL;
f01048c0:	83 c4 10             	add    $0x10,%esp
f01048c3:	85 c0                	test   %eax,%eax
f01048c5:	74 69                	je     f0104930 <syscall+0x265>
  if ((perm & PTE_W) && (*src_pte & PTE_W) == 0) return -E_INVAL;
f01048c7:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f01048cb:	74 08                	je     f01048d5 <syscall+0x20a>
f01048cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01048d0:	f6 02 02             	testb  $0x2,(%edx)
f01048d3:	74 65                	je     f010493a <syscall+0x26f>
  if (page_insert(dstenv->env_pgdir, pp, dstva, perm) != 0)
f01048d5:	ff 75 1c             	pushl  0x1c(%ebp)
f01048d8:	ff 75 18             	pushl  0x18(%ebp)
f01048db:	50                   	push   %eax
f01048dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01048df:	ff 70 60             	pushl  0x60(%eax)
f01048e2:	e8 24 ca ff ff       	call   f010130b <page_insert>
f01048e7:	89 c3                	mov    %eax,%ebx
f01048e9:	83 c4 10             	add    $0x10,%esp
f01048ec:	85 c0                	test   %eax,%eax
f01048ee:	0f 84 28 fe ff ff    	je     f010471c <syscall+0x51>
    return -E_NO_MEM;
f01048f4:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01048f9:	e9 1e fe ff ff       	jmp    f010471c <syscall+0x51>
  if (srcva >= (void*)UTOP || PGOFF(srcva) != 0) return -E_INVAL;
f01048fe:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104903:	e9 14 fe ff ff       	jmp    f010471c <syscall+0x51>
  if (dstva >= (void*)UTOP || PGOFF(dstva) != 0) return -E_INVAL;
f0104908:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010490d:	e9 0a fe ff ff       	jmp    f010471c <syscall+0x51>
f0104912:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104917:	e9 00 fe ff ff       	jmp    f010471c <syscall+0x51>
  if (envid2env(srcenvid, &srcenv, 1) != 0 ) return -E_BAD_ENV;
f010491c:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104921:	e9 f6 fd ff ff       	jmp    f010471c <syscall+0x51>
  if (envid2env(dstenvid, &dstenv, 1) != 0 ) return -E_BAD_ENV;
f0104926:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f010492b:	e9 ec fd ff ff       	jmp    f010471c <syscall+0x51>
  if (pp == NULL) return -E_INVAL;
f0104930:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104935:	e9 e2 fd ff ff       	jmp    f010471c <syscall+0x51>
  if ((perm & PTE_W) && (*src_pte & PTE_W) == 0) return -E_INVAL;
f010493a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
      return sys_page_map(a1, (void*)a2, a3, (void*)a4, a5);
f010493f:	e9 d8 fd ff ff       	jmp    f010471c <syscall+0x51>
  if (envid2env(envid, &e, 1) != 0) return -E_BAD_ENV;
f0104944:	83 ec 04             	sub    $0x4,%esp
f0104947:	6a 01                	push   $0x1
f0104949:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010494c:	50                   	push   %eax
f010494d:	ff 75 0c             	pushl  0xc(%ebp)
f0104950:	e8 dc e7 ff ff       	call   f0103131 <envid2env>
f0104955:	89 c3                	mov    %eax,%ebx
f0104957:	83 c4 10             	add    $0x10,%esp
f010495a:	85 c0                	test   %eax,%eax
f010495c:	75 27                	jne    f0104985 <syscall+0x2ba>
  if (va >= (void*)UTOP || PGOFF(va) != 0) return -E_INVAL;
f010495e:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f0104964:	77 29                	ja     f010498f <syscall+0x2c4>
f0104966:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f010496c:	75 2b                	jne    f0104999 <syscall+0x2ce>
  page_remove(e->env_pgdir, va);
f010496e:	83 ec 08             	sub    $0x8,%esp
f0104971:	57                   	push   %edi
f0104972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104975:	ff 70 60             	pushl  0x60(%eax)
f0104978:	e8 48 c9 ff ff       	call   f01012c5 <page_remove>
f010497d:	83 c4 10             	add    $0x10,%esp
f0104980:	e9 97 fd ff ff       	jmp    f010471c <syscall+0x51>
  if (envid2env(envid, &e, 1) != 0) return -E_BAD_ENV;
f0104985:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f010498a:	e9 8d fd ff ff       	jmp    f010471c <syscall+0x51>
  if (va >= (void*)UTOP || PGOFF(va) != 0) return -E_INVAL;
f010498f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104994:	e9 83 fd ff ff       	jmp    f010471c <syscall+0x51>
f0104999:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
      return sys_page_unmap(a1, (void*)a2);
f010499e:	e9 79 fd ff ff       	jmp    f010471c <syscall+0x51>
  int r = env_alloc(&e, curenv->env_id);
f01049a3:	e8 b6 14 00 00       	call   f0105e5e <cpunum>
f01049a8:	83 ec 08             	sub    $0x8,%esp
f01049ab:	6b c0 74             	imul   $0x74,%eax,%eax
f01049ae:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f01049b4:	ff 70 48             	pushl  0x48(%eax)
f01049b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01049ba:	50                   	push   %eax
f01049bb:	e8 80 e8 ff ff       	call   f0103240 <env_alloc>
f01049c0:	89 c3                	mov    %eax,%ebx
  if (r < 0) return r;
f01049c2:	83 c4 10             	add    $0x10,%esp
f01049c5:	85 c0                	test   %eax,%eax
f01049c7:	0f 88 4f fd ff ff    	js     f010471c <syscall+0x51>
  e->env_status = ENV_NOT_RUNNABLE;
f01049cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01049d0:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
  e->env_tf = curenv->env_tf;
f01049d7:	e8 82 14 00 00       	call   f0105e5e <cpunum>
f01049dc:	6b c0 74             	imul   $0x74,%eax,%eax
f01049df:	8b b0 28 40 53 f0    	mov    -0xfacbfd8(%eax),%esi
f01049e5:	b9 11 00 00 00       	mov    $0x11,%ecx
f01049ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01049ed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  e->env_tf.tf_regs.reg_eax = 0;  
f01049ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01049f2:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return e->env_id;
f01049f9:	8b 58 48             	mov    0x48(%eax),%ebx
      return sys_exofork();
f01049fc:	e9 1b fd ff ff       	jmp    f010471c <syscall+0x51>
  if (status != ENV_NOT_RUNNABLE && status != ENV_RUNNABLE)
f0104a01:	8d 47 fe             	lea    -0x2(%edi),%eax
f0104a04:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f0104a09:	75 25                	jne    f0104a30 <syscall+0x365>
  if (envid2env(envid, &e, 1) != 0) return -E_BAD_ENV;
f0104a0b:	83 ec 04             	sub    $0x4,%esp
f0104a0e:	6a 01                	push   $0x1
f0104a10:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104a13:	50                   	push   %eax
f0104a14:	ff 75 0c             	pushl  0xc(%ebp)
f0104a17:	e8 15 e7 ff ff       	call   f0103131 <envid2env>
f0104a1c:	89 c3                	mov    %eax,%ebx
f0104a1e:	83 c4 10             	add    $0x10,%esp
f0104a21:	85 c0                	test   %eax,%eax
f0104a23:	75 15                	jne    f0104a3a <syscall+0x36f>
  e->env_status = status;
f0104a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a28:	89 78 54             	mov    %edi,0x54(%eax)
f0104a2b:	e9 ec fc ff ff       	jmp    f010471c <syscall+0x51>
    return -E_INVAL;
f0104a30:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a35:	e9 e2 fc ff ff       	jmp    f010471c <syscall+0x51>
  if (envid2env(envid, &e, 1) != 0) return -E_BAD_ENV;
f0104a3a:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
      return sys_env_set_status(a1, a2);
f0104a3f:	e9 d8 fc ff ff       	jmp    f010471c <syscall+0x51>
  if (envid2env(envid, &e, 1) != 0) return -E_BAD_ENV;
f0104a44:	83 ec 04             	sub    $0x4,%esp
f0104a47:	6a 01                	push   $0x1
f0104a49:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104a4c:	50                   	push   %eax
f0104a4d:	ff 75 0c             	pushl  0xc(%ebp)
f0104a50:	e8 dc e6 ff ff       	call   f0103131 <envid2env>
f0104a55:	89 c3                	mov    %eax,%ebx
f0104a57:	83 c4 10             	add    $0x10,%esp
f0104a5a:	85 c0                	test   %eax,%eax
f0104a5c:	75 0b                	jne    f0104a69 <syscall+0x39e>
  e->env_pgfault_upcall = func;
f0104a5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a61:	89 78 64             	mov    %edi,0x64(%eax)
f0104a64:	e9 b3 fc ff ff       	jmp    f010471c <syscall+0x51>
  if (envid2env(envid, &e, 1) != 0) return -E_BAD_ENV;
f0104a69:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
      return sys_env_set_pgfault_upcall(a1, (void*)a2);
f0104a6e:	e9 a9 fc ff ff       	jmp    f010471c <syscall+0x51>
	sched_yield();
f0104a73:	e8 e7 fb ff ff       	call   f010465f <sched_yield>
	struct Env* recv = NULL;
f0104a78:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	if((error_code = envid2env(envid, &recv, 0)) < 0)
f0104a7f:	83 ec 04             	sub    $0x4,%esp
f0104a82:	6a 00                	push   $0x0
f0104a84:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104a87:	50                   	push   %eax
f0104a88:	ff 75 0c             	pushl  0xc(%ebp)
f0104a8b:	e8 a1 e6 ff ff       	call   f0103131 <envid2env>
f0104a90:	89 c3                	mov    %eax,%ebx
f0104a92:	83 c4 10             	add    $0x10,%esp
f0104a95:	85 c0                	test   %eax,%eax
f0104a97:	0f 88 7f fc ff ff    	js     f010471c <syscall+0x51>
	if(!recv->env_ipc_recving)
f0104a9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104aa0:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0104aa4:	0f 84 00 01 00 00    	je     f0104baa <syscall+0x4df>
	recv->env_ipc_perm = 0;
f0104aaa:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
	recv->env_ipc_from = curenv->env_id;
f0104ab1:	e8 a8 13 00 00       	call   f0105e5e <cpunum>
f0104ab6:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104ab9:	6b c0 74             	imul   $0x74,%eax,%eax
f0104abc:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f0104ac2:	8b 40 48             	mov    0x48(%eax),%eax
f0104ac5:	89 42 74             	mov    %eax,0x74(%edx)
	recv->env_ipc_value = value;
f0104ac8:	89 7a 70             	mov    %edi,0x70(%edx)
	if((uintptr_t)srcva < UTOP && (uintptr_t)(recv->env_ipc_dstva) < UTOP)
f0104acb:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0104ad2:	0f 87 9f 00 00 00    	ja     f0104b77 <syscall+0x4ac>
f0104ad8:	81 7a 6c ff ff bf ee 	cmpl   $0xeebfffff,0x6c(%edx)
f0104adf:	0f 87 92 00 00 00    	ja     f0104b77 <syscall+0x4ac>
			return -E_INVAL;
f0104ae5:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		if((uintptr_t)srcva != ROUNDDOWN((uintptr_t)srcva, PGSIZE))
f0104aea:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f0104af1:	0f 85 25 fc ff ff    	jne    f010471c <syscall+0x51>
		if(((perm & PTE_U) == 0) || ((perm & PTE_P) == 0) )
f0104af7:	8b 45 18             	mov    0x18(%ebp),%eax
f0104afa:	83 e0 05             	and    $0x5,%eax
f0104afd:	83 f8 05             	cmp    $0x5,%eax
f0104b00:	0f 85 16 fc ff ff    	jne    f010471c <syscall+0x51>
		if((perm & ~PTE_SYSCALL) != 0)
f0104b06:	f7 45 18 f8 f1 ff ff 	testl  $0xfffff1f8,0x18(%ebp)
f0104b0d:	0f 85 09 fc ff ff    	jne    f010471c <syscall+0x51>
		pte_t* pte_addr = NULL;
f0104b13:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		page = page_lookup(curenv->env_pgdir, srcva, &pte_addr);
f0104b1a:	e8 3f 13 00 00       	call   f0105e5e <cpunum>
f0104b1f:	83 ec 04             	sub    $0x4,%esp
f0104b22:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104b25:	52                   	push   %edx
f0104b26:	ff 75 14             	pushl  0x14(%ebp)
f0104b29:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b2c:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f0104b32:	ff 70 60             	pushl  0x60(%eax)
f0104b35:	e8 ed c6 ff ff       	call   f0101227 <page_lookup>
		if(page == NULL)
f0104b3a:	83 c4 10             	add    $0x10,%esp
f0104b3d:	85 c0                	test   %eax,%eax
f0104b3f:	74 55                	je     f0104b96 <syscall+0x4cb>
		if((perm & PTE_W) && !((*pte_addr) & PTE_W))
f0104b41:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0104b45:	74 08                	je     f0104b4f <syscall+0x484>
f0104b47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104b4a:	f6 02 02             	testb  $0x2,(%edx)
f0104b4d:	74 51                	je     f0104ba0 <syscall+0x4d5>
		if((error_code = page_insert(recv->env_pgdir, page, recv->env_ipc_dstva, perm)) < 0)
f0104b4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104b52:	ff 75 18             	pushl  0x18(%ebp)
f0104b55:	ff 72 6c             	pushl  0x6c(%edx)
f0104b58:	50                   	push   %eax
f0104b59:	ff 72 60             	pushl  0x60(%edx)
f0104b5c:	e8 aa c7 ff ff       	call   f010130b <page_insert>
f0104b61:	89 c3                	mov    %eax,%ebx
f0104b63:	83 c4 10             	add    $0x10,%esp
f0104b66:	85 c0                	test   %eax,%eax
f0104b68:	0f 88 ae fb ff ff    	js     f010471c <syscall+0x51>
		recv->env_ipc_perm = perm;
f0104b6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104b71:	8b 75 18             	mov    0x18(%ebp),%esi
f0104b74:	89 70 78             	mov    %esi,0x78(%eax)
	recv->env_ipc_recving = 0;
f0104b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104b7a:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	recv->env_tf.tf_regs.reg_eax = 0;
f0104b7e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	recv->env_status = ENV_RUNNABLE;
f0104b85:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	return 0;
f0104b8c:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104b91:	e9 86 fb ff ff       	jmp    f010471c <syscall+0x51>
			return -E_INVAL;
f0104b96:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b9b:	e9 7c fb ff ff       	jmp    f010471c <syscall+0x51>
			return -E_INVAL;
f0104ba0:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ba5:	e9 72 fb ff ff       	jmp    f010471c <syscall+0x51>
		return -E_IPC_NOT_RECV;
f0104baa:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
      return sys_ipc_try_send(a1, a2, (void*)a3, a4);
f0104baf:	e9 68 fb ff ff       	jmp    f010471c <syscall+0x51>
	if ((uintptr_t)dstva < UTOP ) {
f0104bb4:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0104bbb:	77 27                	ja     f0104be4 <syscall+0x519>
	  if (PGOFF(dstva) != 0)
f0104bbd:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0104bc4:	74 0a                	je     f0104bd0 <syscall+0x505>
      return sys_ipc_recv((void*)a1);
f0104bc6:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104bcb:	e9 4c fb ff ff       	jmp    f010471c <syscall+0x51>
		 curenv->env_ipc_dstva =dstva;
f0104bd0:	e8 89 12 00 00       	call   f0105e5e <cpunum>
f0104bd5:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bd8:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f0104bde:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104be1:	89 70 6c             	mov    %esi,0x6c(%eax)
	curenv->env_ipc_recving = 1;
f0104be4:	e8 75 12 00 00       	call   f0105e5e <cpunum>
f0104be9:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bec:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f0104bf2:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0104bf6:	e8 63 12 00 00       	call   f0105e5e <cpunum>
f0104bfb:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bfe:	8b 80 28 40 53 f0    	mov    -0xfacbfd8(%eax),%eax
f0104c04:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0104c0b:	e8 4f fa ff ff       	call   f010465f <sched_yield>
      return sys_env_set_trapframe(a1, (struct Trapframe*)a2);
f0104c10:	89 fe                	mov    %edi,%esi
  tf->tf_eflags &= (~FL_IOPL_MASK);
f0104c12:	81 67 38 ff cf ff ff 	andl   $0xffffcfff,0x38(%edi)
  tf->tf_cs = GD_UT | 3;
f0104c19:	66 c7 47 34 1b 00    	movw   $0x1b,0x34(%edi)
  user_mem_assert(curenv, tf, sizeof(struct Trapframe), PTE_U|PTE_P);
f0104c1f:	e8 3a 12 00 00       	call   f0105e5e <cpunum>
f0104c24:	6a 05                	push   $0x5
f0104c26:	6a 44                	push   $0x44
f0104c28:	57                   	push   %edi
f0104c29:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c2c:	ff b0 28 40 53 f0    	pushl  -0xfacbfd8(%eax)
f0104c32:	e8 43 e4 ff ff       	call   f010307a <user_mem_assert>
  r = envid2env(envid, &e, 1);
f0104c37:	83 c4 0c             	add    $0xc,%esp
f0104c3a:	6a 01                	push   $0x1
f0104c3c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104c3f:	50                   	push   %eax
f0104c40:	ff 75 0c             	pushl  0xc(%ebp)
f0104c43:	e8 e9 e4 ff ff       	call   f0103131 <envid2env>
  if (r < 0) return -E_BAD_ENV;
f0104c48:	83 c4 10             	add    $0x10,%esp
f0104c4b:	85 c0                	test   %eax,%eax
f0104c4d:	78 14                	js     f0104c63 <syscall+0x598>
  e->env_tf = *tf;
f0104c4f:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104c54:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104c57:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  return 0;
f0104c59:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104c5e:	e9 b9 fa ff ff       	jmp    f010471c <syscall+0x51>
  if (r < 0) return -E_BAD_ENV;
f0104c63:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
      return sys_env_set_trapframe(a1, (struct Trapframe*)a2);
f0104c68:	e9 af fa ff ff       	jmp    f010471c <syscall+0x51>
  return time_msec();
f0104c6d:	e8 44 1b 00 00       	call   f01067b6 <time_msec>
f0104c72:	89 c3                	mov    %eax,%ebx
      return sys_time_msec();
f0104c74:	e9 a3 fa ff ff       	jmp    f010471c <syscall+0x51>
		  return -E_INVAL;
f0104c79:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104c7e:	e9 99 fa ff ff       	jmp    f010471c <syscall+0x51>

f0104c83 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0104c83:	55                   	push   %ebp
f0104c84:	89 e5                	mov    %esp,%ebp
f0104c86:	57                   	push   %edi
f0104c87:	56                   	push   %esi
f0104c88:	53                   	push   %ebx
f0104c89:	83 ec 14             	sub    $0x14,%esp
f0104c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104c8f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104c92:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104c95:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104c98:	8b 1a                	mov    (%edx),%ebx
f0104c9a:	8b 01                	mov    (%ecx),%eax
f0104c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104c9f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0104ca6:	eb 23                	jmp    f0104ccb <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0104ca8:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0104cab:	eb 1e                	jmp    f0104ccb <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0104cad:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104cb0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104cb3:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104cb7:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104cba:	73 41                	jae    f0104cfd <stab_binsearch+0x7a>
			*region_left = m;
f0104cbc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104cbf:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0104cc1:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0104cc4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0104ccb:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0104cce:	7f 5a                	jg     f0104d2a <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f0104cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104cd3:	01 d8                	add    %ebx,%eax
f0104cd5:	89 c7                	mov    %eax,%edi
f0104cd7:	c1 ef 1f             	shr    $0x1f,%edi
f0104cda:	01 c7                	add    %eax,%edi
f0104cdc:	d1 ff                	sar    %edi
f0104cde:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0104ce1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104ce4:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104ce8:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0104cea:	39 c3                	cmp    %eax,%ebx
f0104cec:	7f ba                	jg     f0104ca8 <stab_binsearch+0x25>
f0104cee:	0f b6 0a             	movzbl (%edx),%ecx
f0104cf1:	83 ea 0c             	sub    $0xc,%edx
f0104cf4:	39 f1                	cmp    %esi,%ecx
f0104cf6:	74 b5                	je     f0104cad <stab_binsearch+0x2a>
			m--;
f0104cf8:	83 e8 01             	sub    $0x1,%eax
f0104cfb:	eb ed                	jmp    f0104cea <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f0104cfd:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104d00:	76 14                	jbe    f0104d16 <stab_binsearch+0x93>
			*region_right = m - 1;
f0104d02:	83 e8 01             	sub    $0x1,%eax
f0104d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104d08:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104d0b:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0104d0d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104d14:	eb b5                	jmp    f0104ccb <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104d16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104d19:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0104d1b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104d1f:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0104d21:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104d28:	eb a1                	jmp    f0104ccb <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0104d2a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104d2e:	75 15                	jne    f0104d45 <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f0104d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104d33:	8b 00                	mov    (%eax),%eax
f0104d35:	83 e8 01             	sub    $0x1,%eax
f0104d38:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0104d3b:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0104d3d:	83 c4 14             	add    $0x14,%esp
f0104d40:	5b                   	pop    %ebx
f0104d41:	5e                   	pop    %esi
f0104d42:	5f                   	pop    %edi
f0104d43:	5d                   	pop    %ebp
f0104d44:	c3                   	ret    
		for (l = *region_right;
f0104d45:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104d48:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0104d4a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104d4d:	8b 0f                	mov    (%edi),%ecx
f0104d4f:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104d52:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0104d55:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0104d59:	eb 03                	jmp    f0104d5e <stab_binsearch+0xdb>
		     l--)
f0104d5b:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0104d5e:	39 c1                	cmp    %eax,%ecx
f0104d60:	7d 0a                	jge    f0104d6c <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f0104d62:	0f b6 1a             	movzbl (%edx),%ebx
f0104d65:	83 ea 0c             	sub    $0xc,%edx
f0104d68:	39 f3                	cmp    %esi,%ebx
f0104d6a:	75 ef                	jne    f0104d5b <stab_binsearch+0xd8>
		*region_left = l;
f0104d6c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104d6f:	89 06                	mov    %eax,(%esi)
}
f0104d71:	eb ca                	jmp    f0104d3d <stab_binsearch+0xba>

f0104d73 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0104d73:	55                   	push   %ebp
f0104d74:	89 e5                	mov    %esp,%ebp
f0104d76:	57                   	push   %edi
f0104d77:	56                   	push   %esi
f0104d78:	53                   	push   %ebx
f0104d79:	83 ec 4c             	sub    $0x4c,%esp
f0104d7c:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104d7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0104d82:	c7 03 84 82 10 f0    	movl   $0xf0108284,(%ebx)
	info->eip_line = 0;
f0104d88:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0104d8f:	c7 43 08 84 82 10 f0 	movl   $0xf0108284,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0104d96:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0104d9d:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0104da0:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0104da7:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0104dad:	0f 86 22 01 00 00    	jbe    f0104ed5 <debuginfo_eip+0x162>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0104db3:	c7 45 b8 74 a8 11 f0 	movl   $0xf011a874,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0104dba:	c7 45 b4 81 67 11 f0 	movl   $0xf0116781,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0104dc1:	be 80 67 11 f0       	mov    $0xf0116780,%esi
		stabs = __STAB_BEGIN__;
f0104dc6:	c7 45 bc 88 8a 10 f0 	movl   $0xf0108a88,-0x44(%ebp)
    err = user_mem_check(curenv, (void*)stabstr, stabstr_end-stabstr, 0);
    if (err) return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104dcd:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0104dd0:	39 4d b4             	cmp    %ecx,-0x4c(%ebp)
f0104dd3:	0f 83 61 02 00 00    	jae    f010503a <debuginfo_eip+0x2c7>
f0104dd9:	80 79 ff 00          	cmpb   $0x0,-0x1(%ecx)
f0104ddd:	0f 85 5e 02 00 00    	jne    f0105041 <debuginfo_eip+0x2ce>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0104de3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104dea:	2b 75 bc             	sub    -0x44(%ebp),%esi
f0104ded:	c1 fe 02             	sar    $0x2,%esi
f0104df0:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f0104df6:	83 e8 01             	sub    $0x1,%eax
f0104df9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104dfc:	83 ec 08             	sub    $0x8,%esp
f0104dff:	57                   	push   %edi
f0104e00:	6a 64                	push   $0x64
f0104e02:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0104e05:	89 d1                	mov    %edx,%ecx
f0104e07:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104e0a:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104e0d:	89 f0                	mov    %esi,%eax
f0104e0f:	e8 6f fe ff ff       	call   f0104c83 <stab_binsearch>
	if (lfile == 0)
f0104e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104e17:	83 c4 10             	add    $0x10,%esp
f0104e1a:	85 c0                	test   %eax,%eax
f0104e1c:	0f 84 26 02 00 00    	je     f0105048 <debuginfo_eip+0x2d5>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0104e22:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0104e25:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104e28:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104e2b:	83 ec 08             	sub    $0x8,%esp
f0104e2e:	57                   	push   %edi
f0104e2f:	6a 24                	push   $0x24
f0104e31:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0104e34:	89 d1                	mov    %edx,%ecx
f0104e36:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104e39:	89 f0                	mov    %esi,%eax
f0104e3b:	e8 43 fe ff ff       	call   f0104c83 <stab_binsearch>

	if (lfun <= rfun) {
f0104e40:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104e43:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0104e46:	83 c4 10             	add    $0x10,%esp
f0104e49:	39 d0                	cmp    %edx,%eax
f0104e4b:	0f 8f 31 01 00 00    	jg     f0104f82 <debuginfo_eip+0x20f>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104e51:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0104e54:	8d 34 8e             	lea    (%esi,%ecx,4),%esi
f0104e57:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f0104e5a:	8b 36                	mov    (%esi),%esi
f0104e5c:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0104e5f:	2b 4d b4             	sub    -0x4c(%ebp),%ecx
f0104e62:	39 ce                	cmp    %ecx,%esi
f0104e64:	73 06                	jae    f0104e6c <debuginfo_eip+0xf9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104e66:	03 75 b4             	add    -0x4c(%ebp),%esi
f0104e69:	89 73 08             	mov    %esi,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0104e6c:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0104e6f:	8b 4e 08             	mov    0x8(%esi),%ecx
f0104e72:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0104e75:	29 cf                	sub    %ecx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0104e77:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0104e7a:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104e7d:	83 ec 08             	sub    $0x8,%esp
f0104e80:	6a 3a                	push   $0x3a
f0104e82:	ff 73 08             	pushl  0x8(%ebx)
f0104e85:	e8 b9 09 00 00       	call   f0105843 <strfind>
f0104e8a:	2b 43 08             	sub    0x8(%ebx),%eax
f0104e8d:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0104e90:	83 c4 08             	add    $0x8,%esp
f0104e93:	57                   	push   %edi
f0104e94:	6a 44                	push   $0x44
f0104e96:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0104e99:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0104e9c:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104e9f:	89 f0                	mov    %esi,%eax
f0104ea1:	e8 dd fd ff ff       	call   f0104c83 <stab_binsearch>
  if (lline <= rline)
f0104ea6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104ea9:	83 c4 10             	add    $0x10,%esp
f0104eac:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f0104eaf:	0f 8f 9a 01 00 00    	jg     f010504f <debuginfo_eip+0x2dc>
    info->eip_line = stabs[lline].n_desc;
f0104eb5:	89 d0                	mov    %edx,%eax
f0104eb7:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104eba:	c1 e2 02             	shl    $0x2,%edx
f0104ebd:	0f b7 4c 16 06       	movzwl 0x6(%esi,%edx,1),%ecx
f0104ec2:	89 4b 04             	mov    %ecx,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0104ec5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104ec8:	8d 54 16 04          	lea    0x4(%esi,%edx,1),%edx
f0104ecc:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0104ed0:	e9 cb 00 00 00       	jmp    f0104fa0 <debuginfo_eip+0x22d>
    int err = user_mem_check(curenv, (void*)usd, sizeof(struct UserStabData), 0);
f0104ed5:	e8 84 0f 00 00       	call   f0105e5e <cpunum>
f0104eda:	6a 00                	push   $0x0
f0104edc:	6a 10                	push   $0x10
f0104ede:	68 00 00 20 00       	push   $0x200000
f0104ee3:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ee6:	ff b0 28 40 53 f0    	pushl  -0xfacbfd8(%eax)
f0104eec:	e8 f6 e0 ff ff       	call   f0102fe7 <user_mem_check>
    if (err) return -1;
f0104ef1:	83 c4 10             	add    $0x10,%esp
f0104ef4:	85 c0                	test   %eax,%eax
f0104ef6:	0f 85 30 01 00 00    	jne    f010502c <debuginfo_eip+0x2b9>
		stabs = usd->stabs;
f0104efc:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0104f02:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f0104f05:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0104f0b:	a1 08 00 20 00       	mov    0x200008,%eax
f0104f10:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0104f13:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0104f19:	89 55 b8             	mov    %edx,-0x48(%ebp)
    err = user_mem_check(curenv, (void*)stabs, stab_end-stabs, 0);
f0104f1c:	e8 3d 0f 00 00       	call   f0105e5e <cpunum>
f0104f21:	6a 00                	push   $0x0
f0104f23:	89 f2                	mov    %esi,%edx
f0104f25:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0104f28:	29 ca                	sub    %ecx,%edx
f0104f2a:	c1 fa 02             	sar    $0x2,%edx
f0104f2d:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0104f33:	52                   	push   %edx
f0104f34:	51                   	push   %ecx
f0104f35:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f38:	ff b0 28 40 53 f0    	pushl  -0xfacbfd8(%eax)
f0104f3e:	e8 a4 e0 ff ff       	call   f0102fe7 <user_mem_check>
    if (err) return -1;
f0104f43:	83 c4 10             	add    $0x10,%esp
f0104f46:	85 c0                	test   %eax,%eax
f0104f48:	0f 85 e5 00 00 00    	jne    f0105033 <debuginfo_eip+0x2c0>
    err = user_mem_check(curenv, (void*)stabstr, stabstr_end-stabstr, 0);
f0104f4e:	e8 0b 0f 00 00       	call   f0105e5e <cpunum>
f0104f53:	6a 00                	push   $0x0
f0104f55:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0104f58:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0104f5b:	29 ca                	sub    %ecx,%edx
f0104f5d:	52                   	push   %edx
f0104f5e:	51                   	push   %ecx
f0104f5f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f62:	ff b0 28 40 53 f0    	pushl  -0xfacbfd8(%eax)
f0104f68:	e8 7a e0 ff ff       	call   f0102fe7 <user_mem_check>
    if (err) return -1;
f0104f6d:	83 c4 10             	add    $0x10,%esp
f0104f70:	85 c0                	test   %eax,%eax
f0104f72:	0f 84 55 fe ff ff    	je     f0104dcd <debuginfo_eip+0x5a>
f0104f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104f7d:	e9 d9 00 00 00       	jmp    f010505b <debuginfo_eip+0x2e8>
		info->eip_fn_addr = addr;
f0104f82:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0104f85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104f88:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0104f8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104f8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104f91:	e9 e7 fe ff ff       	jmp    f0104e7d <debuginfo_eip+0x10a>
f0104f96:	83 e8 01             	sub    $0x1,%eax
f0104f99:	83 ea 0c             	sub    $0xc,%edx
f0104f9c:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0104fa0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile
f0104fa3:	39 c7                	cmp    %eax,%edi
f0104fa5:	7f 45                	jg     f0104fec <debuginfo_eip+0x279>
	       && stabs[lline].n_type != N_SOL
f0104fa7:	0f b6 0a             	movzbl (%edx),%ecx
f0104faa:	80 f9 84             	cmp    $0x84,%cl
f0104fad:	74 19                	je     f0104fc8 <debuginfo_eip+0x255>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104faf:	80 f9 64             	cmp    $0x64,%cl
f0104fb2:	75 e2                	jne    f0104f96 <debuginfo_eip+0x223>
f0104fb4:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0104fb8:	74 dc                	je     f0104f96 <debuginfo_eip+0x223>
f0104fba:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104fbe:	74 11                	je     f0104fd1 <debuginfo_eip+0x25e>
f0104fc0:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0104fc3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0104fc6:	eb 09                	jmp    f0104fd1 <debuginfo_eip+0x25e>
f0104fc8:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104fcc:	74 03                	je     f0104fd1 <debuginfo_eip+0x25e>
f0104fce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0104fd1:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104fd4:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0104fd7:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0104fda:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0104fdd:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0104fe0:	29 f8                	sub    %edi,%eax
f0104fe2:	39 c2                	cmp    %eax,%edx
f0104fe4:	73 06                	jae    f0104fec <debuginfo_eip+0x279>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0104fe6:	89 f8                	mov    %edi,%eax
f0104fe8:	01 d0                	add    %edx,%eax
f0104fea:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0104fec:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0104fef:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0104ff2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0104ff7:	39 f2                	cmp    %esi,%edx
f0104ff9:	7d 60                	jge    f010505b <debuginfo_eip+0x2e8>
		for (lline = lfun + 1;
f0104ffb:	83 c2 01             	add    $0x1,%edx
f0104ffe:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105001:	89 d0                	mov    %edx,%eax
f0105003:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105006:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105009:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f010500d:	eb 04                	jmp    f0105013 <debuginfo_eip+0x2a0>
			info->eip_fn_narg++;
f010500f:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0105013:	39 c6                	cmp    %eax,%esi
f0105015:	7e 3f                	jle    f0105056 <debuginfo_eip+0x2e3>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105017:	0f b6 0a             	movzbl (%edx),%ecx
f010501a:	83 c0 01             	add    $0x1,%eax
f010501d:	83 c2 0c             	add    $0xc,%edx
f0105020:	80 f9 a0             	cmp    $0xa0,%cl
f0105023:	74 ea                	je     f010500f <debuginfo_eip+0x29c>
	return 0;
f0105025:	b8 00 00 00 00       	mov    $0x0,%eax
f010502a:	eb 2f                	jmp    f010505b <debuginfo_eip+0x2e8>
    if (err) return -1;
f010502c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105031:	eb 28                	jmp    f010505b <debuginfo_eip+0x2e8>
    if (err) return -1;
f0105033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105038:	eb 21                	jmp    f010505b <debuginfo_eip+0x2e8>
		return -1;
f010503a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010503f:	eb 1a                	jmp    f010505b <debuginfo_eip+0x2e8>
f0105041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105046:	eb 13                	jmp    f010505b <debuginfo_eip+0x2e8>
		return -1;
f0105048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010504d:	eb 0c                	jmp    f010505b <debuginfo_eip+0x2e8>
    return -1;
f010504f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105054:	eb 05                	jmp    f010505b <debuginfo_eip+0x2e8>
	return 0;
f0105056:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010505b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010505e:	5b                   	pop    %ebx
f010505f:	5e                   	pop    %esi
f0105060:	5f                   	pop    %edi
f0105061:	5d                   	pop    %ebp
f0105062:	c3                   	ret    

f0105063 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105063:	55                   	push   %ebp
f0105064:	89 e5                	mov    %esp,%ebp
f0105066:	57                   	push   %edi
f0105067:	56                   	push   %esi
f0105068:	53                   	push   %ebx
f0105069:	83 ec 1c             	sub    $0x1c,%esp
f010506c:	89 c7                	mov    %eax,%edi
f010506e:	89 d6                	mov    %edx,%esi
f0105070:	8b 45 08             	mov    0x8(%ebp),%eax
f0105073:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105076:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105079:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f010507c:	8b 4d 10             	mov    0x10(%ebp),%ecx
f010507f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105084:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105087:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f010508a:	3b 45 10             	cmp    0x10(%ebp),%eax
f010508d:	89 d0                	mov    %edx,%eax
f010508f:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
f0105092:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105095:	73 15                	jae    f01050ac <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0105097:	83 eb 01             	sub    $0x1,%ebx
f010509a:	85 db                	test   %ebx,%ebx
f010509c:	7e 43                	jle    f01050e1 <printnum+0x7e>
			putch(padc, putdat);
f010509e:	83 ec 08             	sub    $0x8,%esp
f01050a1:	56                   	push   %esi
f01050a2:	ff 75 18             	pushl  0x18(%ebp)
f01050a5:	ff d7                	call   *%edi
f01050a7:	83 c4 10             	add    $0x10,%esp
f01050aa:	eb eb                	jmp    f0105097 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f01050ac:	83 ec 0c             	sub    $0xc,%esp
f01050af:	ff 75 18             	pushl  0x18(%ebp)
f01050b2:	8b 45 14             	mov    0x14(%ebp),%eax
f01050b5:	8d 58 ff             	lea    -0x1(%eax),%ebx
f01050b8:	53                   	push   %ebx
f01050b9:	ff 75 10             	pushl  0x10(%ebp)
f01050bc:	83 ec 08             	sub    $0x8,%esp
f01050bf:	ff 75 e4             	pushl  -0x1c(%ebp)
f01050c2:	ff 75 e0             	pushl  -0x20(%ebp)
f01050c5:	ff 75 dc             	pushl  -0x24(%ebp)
f01050c8:	ff 75 d8             	pushl  -0x28(%ebp)
f01050cb:	e8 00 17 00 00       	call   f01067d0 <__udivdi3>
f01050d0:	83 c4 18             	add    $0x18,%esp
f01050d3:	52                   	push   %edx
f01050d4:	50                   	push   %eax
f01050d5:	89 f2                	mov    %esi,%edx
f01050d7:	89 f8                	mov    %edi,%eax
f01050d9:	e8 85 ff ff ff       	call   f0105063 <printnum>
f01050de:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01050e1:	83 ec 08             	sub    $0x8,%esp
f01050e4:	56                   	push   %esi
f01050e5:	83 ec 04             	sub    $0x4,%esp
f01050e8:	ff 75 e4             	pushl  -0x1c(%ebp)
f01050eb:	ff 75 e0             	pushl  -0x20(%ebp)
f01050ee:	ff 75 dc             	pushl  -0x24(%ebp)
f01050f1:	ff 75 d8             	pushl  -0x28(%ebp)
f01050f4:	e8 e7 17 00 00       	call   f01068e0 <__umoddi3>
f01050f9:	83 c4 14             	add    $0x14,%esp
f01050fc:	0f be 80 8e 82 10 f0 	movsbl -0xfef7d72(%eax),%eax
f0105103:	50                   	push   %eax
f0105104:	ff d7                	call   *%edi
}
f0105106:	83 c4 10             	add    $0x10,%esp
f0105109:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010510c:	5b                   	pop    %ebx
f010510d:	5e                   	pop    %esi
f010510e:	5f                   	pop    %edi
f010510f:	5d                   	pop    %ebp
f0105110:	c3                   	ret    

f0105111 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105111:	55                   	push   %ebp
f0105112:	89 e5                	mov    %esp,%ebp
f0105114:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105117:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f010511b:	8b 10                	mov    (%eax),%edx
f010511d:	3b 50 04             	cmp    0x4(%eax),%edx
f0105120:	73 0a                	jae    f010512c <sprintputch+0x1b>
		*b->buf++ = ch;
f0105122:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105125:	89 08                	mov    %ecx,(%eax)
f0105127:	8b 45 08             	mov    0x8(%ebp),%eax
f010512a:	88 02                	mov    %al,(%edx)
}
f010512c:	5d                   	pop    %ebp
f010512d:	c3                   	ret    

f010512e <printfmt>:
{
f010512e:	55                   	push   %ebp
f010512f:	89 e5                	mov    %esp,%ebp
f0105131:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0105134:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105137:	50                   	push   %eax
f0105138:	ff 75 10             	pushl  0x10(%ebp)
f010513b:	ff 75 0c             	pushl  0xc(%ebp)
f010513e:	ff 75 08             	pushl  0x8(%ebp)
f0105141:	e8 05 00 00 00       	call   f010514b <vprintfmt>
}
f0105146:	83 c4 10             	add    $0x10,%esp
f0105149:	c9                   	leave  
f010514a:	c3                   	ret    

f010514b <vprintfmt>:
{
f010514b:	55                   	push   %ebp
f010514c:	89 e5                	mov    %esp,%ebp
f010514e:	57                   	push   %edi
f010514f:	56                   	push   %esi
f0105150:	53                   	push   %ebx
f0105151:	83 ec 3c             	sub    $0x3c,%esp
f0105154:	8b 75 08             	mov    0x8(%ebp),%esi
f0105157:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010515a:	8b 7d 10             	mov    0x10(%ebp),%edi
f010515d:	eb 0a                	jmp    f0105169 <vprintfmt+0x1e>
			putch(ch, putdat);
f010515f:	83 ec 08             	sub    $0x8,%esp
f0105162:	53                   	push   %ebx
f0105163:	50                   	push   %eax
f0105164:	ff d6                	call   *%esi
f0105166:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0105169:	83 c7 01             	add    $0x1,%edi
f010516c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105170:	83 f8 25             	cmp    $0x25,%eax
f0105173:	74 0c                	je     f0105181 <vprintfmt+0x36>
			if (ch == '\0')
f0105175:	85 c0                	test   %eax,%eax
f0105177:	75 e6                	jne    f010515f <vprintfmt+0x14>
}
f0105179:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010517c:	5b                   	pop    %ebx
f010517d:	5e                   	pop    %esi
f010517e:	5f                   	pop    %edi
f010517f:	5d                   	pop    %ebp
f0105180:	c3                   	ret    
		padc = ' ';
f0105181:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
f0105185:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
f010518c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0105193:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f010519a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f010519f:	8d 47 01             	lea    0x1(%edi),%eax
f01051a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01051a5:	0f b6 17             	movzbl (%edi),%edx
f01051a8:	8d 42 dd             	lea    -0x23(%edx),%eax
f01051ab:	3c 55                	cmp    $0x55,%al
f01051ad:	0f 87 ba 03 00 00    	ja     f010556d <vprintfmt+0x422>
f01051b3:	0f b6 c0             	movzbl %al,%eax
f01051b6:	ff 24 85 e0 83 10 f0 	jmp    *-0xfef7c20(,%eax,4)
f01051bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f01051c0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f01051c4:	eb d9                	jmp    f010519f <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
f01051c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f01051c9:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
f01051cd:	eb d0                	jmp    f010519f <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
f01051cf:	0f b6 d2             	movzbl %dl,%edx
f01051d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f01051d5:	b8 00 00 00 00       	mov    $0x0,%eax
f01051da:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f01051dd:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01051e0:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f01051e4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f01051e7:	8d 4a d0             	lea    -0x30(%edx),%ecx
f01051ea:	83 f9 09             	cmp    $0x9,%ecx
f01051ed:	77 55                	ja     f0105244 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
f01051ef:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f01051f2:	eb e9                	jmp    f01051dd <vprintfmt+0x92>
			precision = va_arg(ap, int);
f01051f4:	8b 45 14             	mov    0x14(%ebp),%eax
f01051f7:	8b 00                	mov    (%eax),%eax
f01051f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01051fc:	8b 45 14             	mov    0x14(%ebp),%eax
f01051ff:	8d 40 04             	lea    0x4(%eax),%eax
f0105202:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105205:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0105208:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f010520c:	79 91                	jns    f010519f <vprintfmt+0x54>
				width = precision, precision = -1;
f010520e:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105211:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105214:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f010521b:	eb 82                	jmp    f010519f <vprintfmt+0x54>
f010521d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105220:	85 c0                	test   %eax,%eax
f0105222:	ba 00 00 00 00       	mov    $0x0,%edx
f0105227:	0f 49 d0             	cmovns %eax,%edx
f010522a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010522d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105230:	e9 6a ff ff ff       	jmp    f010519f <vprintfmt+0x54>
f0105235:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0105238:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
f010523f:	e9 5b ff ff ff       	jmp    f010519f <vprintfmt+0x54>
f0105244:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105247:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010524a:	eb bc                	jmp    f0105208 <vprintfmt+0xbd>
			lflag++;
f010524c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f010524f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105252:	e9 48 ff ff ff       	jmp    f010519f <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
f0105257:	8b 45 14             	mov    0x14(%ebp),%eax
f010525a:	8d 78 04             	lea    0x4(%eax),%edi
f010525d:	83 ec 08             	sub    $0x8,%esp
f0105260:	53                   	push   %ebx
f0105261:	ff 30                	pushl  (%eax)
f0105263:	ff d6                	call   *%esi
			break;
f0105265:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0105268:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f010526b:	e9 9c 02 00 00       	jmp    f010550c <vprintfmt+0x3c1>
			err = va_arg(ap, int);
f0105270:	8b 45 14             	mov    0x14(%ebp),%eax
f0105273:	8d 78 04             	lea    0x4(%eax),%edi
f0105276:	8b 00                	mov    (%eax),%eax
f0105278:	99                   	cltd   
f0105279:	31 d0                	xor    %edx,%eax
f010527b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010527d:	83 f8 0f             	cmp    $0xf,%eax
f0105280:	7f 23                	jg     f01052a5 <vprintfmt+0x15a>
f0105282:	8b 14 85 40 85 10 f0 	mov    -0xfef7ac0(,%eax,4),%edx
f0105289:	85 d2                	test   %edx,%edx
f010528b:	74 18                	je     f01052a5 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
f010528d:	52                   	push   %edx
f010528e:	68 c0 79 10 f0       	push   $0xf01079c0
f0105293:	53                   	push   %ebx
f0105294:	56                   	push   %esi
f0105295:	e8 94 fe ff ff       	call   f010512e <printfmt>
f010529a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f010529d:	89 7d 14             	mov    %edi,0x14(%ebp)
f01052a0:	e9 67 02 00 00       	jmp    f010550c <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
f01052a5:	50                   	push   %eax
f01052a6:	68 a6 82 10 f0       	push   $0xf01082a6
f01052ab:	53                   	push   %ebx
f01052ac:	56                   	push   %esi
f01052ad:	e8 7c fe ff ff       	call   f010512e <printfmt>
f01052b2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01052b5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f01052b8:	e9 4f 02 00 00       	jmp    f010550c <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
f01052bd:	8b 45 14             	mov    0x14(%ebp),%eax
f01052c0:	83 c0 04             	add    $0x4,%eax
f01052c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01052c6:	8b 45 14             	mov    0x14(%ebp),%eax
f01052c9:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f01052cb:	85 d2                	test   %edx,%edx
f01052cd:	b8 9f 82 10 f0       	mov    $0xf010829f,%eax
f01052d2:	0f 45 c2             	cmovne %edx,%eax
f01052d5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
f01052d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01052dc:	7e 06                	jle    f01052e4 <vprintfmt+0x199>
f01052de:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f01052e2:	75 0d                	jne    f01052f1 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
f01052e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01052e7:	89 c7                	mov    %eax,%edi
f01052e9:	03 45 e0             	add    -0x20(%ebp),%eax
f01052ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01052ef:	eb 3f                	jmp    f0105330 <vprintfmt+0x1e5>
f01052f1:	83 ec 08             	sub    $0x8,%esp
f01052f4:	ff 75 d8             	pushl  -0x28(%ebp)
f01052f7:	50                   	push   %eax
f01052f8:	e8 fb 03 00 00       	call   f01056f8 <strnlen>
f01052fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105300:	29 c2                	sub    %eax,%edx
f0105302:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f0105305:	83 c4 10             	add    $0x10,%esp
f0105308:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
f010530a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f010530e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0105311:	85 ff                	test   %edi,%edi
f0105313:	7e 58                	jle    f010536d <vprintfmt+0x222>
					putch(padc, putdat);
f0105315:	83 ec 08             	sub    $0x8,%esp
f0105318:	53                   	push   %ebx
f0105319:	ff 75 e0             	pushl  -0x20(%ebp)
f010531c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f010531e:	83 ef 01             	sub    $0x1,%edi
f0105321:	83 c4 10             	add    $0x10,%esp
f0105324:	eb eb                	jmp    f0105311 <vprintfmt+0x1c6>
					putch(ch, putdat);
f0105326:	83 ec 08             	sub    $0x8,%esp
f0105329:	53                   	push   %ebx
f010532a:	52                   	push   %edx
f010532b:	ff d6                	call   *%esi
f010532d:	83 c4 10             	add    $0x10,%esp
f0105330:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105333:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105335:	83 c7 01             	add    $0x1,%edi
f0105338:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f010533c:	0f be d0             	movsbl %al,%edx
f010533f:	85 d2                	test   %edx,%edx
f0105341:	74 45                	je     f0105388 <vprintfmt+0x23d>
f0105343:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105347:	78 06                	js     f010534f <vprintfmt+0x204>
f0105349:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f010534d:	78 35                	js     f0105384 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
f010534f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0105353:	74 d1                	je     f0105326 <vprintfmt+0x1db>
f0105355:	0f be c0             	movsbl %al,%eax
f0105358:	83 e8 20             	sub    $0x20,%eax
f010535b:	83 f8 5e             	cmp    $0x5e,%eax
f010535e:	76 c6                	jbe    f0105326 <vprintfmt+0x1db>
					putch('?', putdat);
f0105360:	83 ec 08             	sub    $0x8,%esp
f0105363:	53                   	push   %ebx
f0105364:	6a 3f                	push   $0x3f
f0105366:	ff d6                	call   *%esi
f0105368:	83 c4 10             	add    $0x10,%esp
f010536b:	eb c3                	jmp    f0105330 <vprintfmt+0x1e5>
f010536d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0105370:	85 d2                	test   %edx,%edx
f0105372:	b8 00 00 00 00       	mov    $0x0,%eax
f0105377:	0f 49 c2             	cmovns %edx,%eax
f010537a:	29 c2                	sub    %eax,%edx
f010537c:	89 55 e0             	mov    %edx,-0x20(%ebp)
f010537f:	e9 60 ff ff ff       	jmp    f01052e4 <vprintfmt+0x199>
f0105384:	89 cf                	mov    %ecx,%edi
f0105386:	eb 02                	jmp    f010538a <vprintfmt+0x23f>
f0105388:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
f010538a:	85 ff                	test   %edi,%edi
f010538c:	7e 10                	jle    f010539e <vprintfmt+0x253>
				putch(' ', putdat);
f010538e:	83 ec 08             	sub    $0x8,%esp
f0105391:	53                   	push   %ebx
f0105392:	6a 20                	push   $0x20
f0105394:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0105396:	83 ef 01             	sub    $0x1,%edi
f0105399:	83 c4 10             	add    $0x10,%esp
f010539c:	eb ec                	jmp    f010538a <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
f010539e:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01053a1:	89 45 14             	mov    %eax,0x14(%ebp)
f01053a4:	e9 63 01 00 00       	jmp    f010550c <vprintfmt+0x3c1>
	if (lflag >= 2)
f01053a9:	83 f9 01             	cmp    $0x1,%ecx
f01053ac:	7f 1b                	jg     f01053c9 <vprintfmt+0x27e>
	else if (lflag)
f01053ae:	85 c9                	test   %ecx,%ecx
f01053b0:	74 63                	je     f0105415 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
f01053b2:	8b 45 14             	mov    0x14(%ebp),%eax
f01053b5:	8b 00                	mov    (%eax),%eax
f01053b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01053ba:	99                   	cltd   
f01053bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01053be:	8b 45 14             	mov    0x14(%ebp),%eax
f01053c1:	8d 40 04             	lea    0x4(%eax),%eax
f01053c4:	89 45 14             	mov    %eax,0x14(%ebp)
f01053c7:	eb 17                	jmp    f01053e0 <vprintfmt+0x295>
		return va_arg(*ap, long long);
f01053c9:	8b 45 14             	mov    0x14(%ebp),%eax
f01053cc:	8b 50 04             	mov    0x4(%eax),%edx
f01053cf:	8b 00                	mov    (%eax),%eax
f01053d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01053d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01053d7:	8b 45 14             	mov    0x14(%ebp),%eax
f01053da:	8d 40 08             	lea    0x8(%eax),%eax
f01053dd:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01053e0:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01053e3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f01053e6:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f01053eb:	85 c9                	test   %ecx,%ecx
f01053ed:	0f 89 ff 00 00 00    	jns    f01054f2 <vprintfmt+0x3a7>
				putch('-', putdat);
f01053f3:	83 ec 08             	sub    $0x8,%esp
f01053f6:	53                   	push   %ebx
f01053f7:	6a 2d                	push   $0x2d
f01053f9:	ff d6                	call   *%esi
				num = -(long long) num;
f01053fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01053fe:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0105401:	f7 da                	neg    %edx
f0105403:	83 d1 00             	adc    $0x0,%ecx
f0105406:	f7 d9                	neg    %ecx
f0105408:	83 c4 10             	add    $0x10,%esp
			base = 10;
f010540b:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105410:	e9 dd 00 00 00       	jmp    f01054f2 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
f0105415:	8b 45 14             	mov    0x14(%ebp),%eax
f0105418:	8b 00                	mov    (%eax),%eax
f010541a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010541d:	99                   	cltd   
f010541e:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105421:	8b 45 14             	mov    0x14(%ebp),%eax
f0105424:	8d 40 04             	lea    0x4(%eax),%eax
f0105427:	89 45 14             	mov    %eax,0x14(%ebp)
f010542a:	eb b4                	jmp    f01053e0 <vprintfmt+0x295>
	if (lflag >= 2)
f010542c:	83 f9 01             	cmp    $0x1,%ecx
f010542f:	7f 1e                	jg     f010544f <vprintfmt+0x304>
	else if (lflag)
f0105431:	85 c9                	test   %ecx,%ecx
f0105433:	74 32                	je     f0105467 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
f0105435:	8b 45 14             	mov    0x14(%ebp),%eax
f0105438:	8b 10                	mov    (%eax),%edx
f010543a:	b9 00 00 00 00       	mov    $0x0,%ecx
f010543f:	8d 40 04             	lea    0x4(%eax),%eax
f0105442:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105445:	b8 0a 00 00 00       	mov    $0xa,%eax
f010544a:	e9 a3 00 00 00       	jmp    f01054f2 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
f010544f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105452:	8b 10                	mov    (%eax),%edx
f0105454:	8b 48 04             	mov    0x4(%eax),%ecx
f0105457:	8d 40 08             	lea    0x8(%eax),%eax
f010545a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010545d:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105462:	e9 8b 00 00 00       	jmp    f01054f2 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
f0105467:	8b 45 14             	mov    0x14(%ebp),%eax
f010546a:	8b 10                	mov    (%eax),%edx
f010546c:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105471:	8d 40 04             	lea    0x4(%eax),%eax
f0105474:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105477:	b8 0a 00 00 00       	mov    $0xa,%eax
f010547c:	eb 74                	jmp    f01054f2 <vprintfmt+0x3a7>
	if (lflag >= 2)
f010547e:	83 f9 01             	cmp    $0x1,%ecx
f0105481:	7f 1b                	jg     f010549e <vprintfmt+0x353>
	else if (lflag)
f0105483:	85 c9                	test   %ecx,%ecx
f0105485:	74 2c                	je     f01054b3 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
f0105487:	8b 45 14             	mov    0x14(%ebp),%eax
f010548a:	8b 10                	mov    (%eax),%edx
f010548c:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105491:	8d 40 04             	lea    0x4(%eax),%eax
f0105494:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105497:	b8 08 00 00 00       	mov    $0x8,%eax
f010549c:	eb 54                	jmp    f01054f2 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
f010549e:	8b 45 14             	mov    0x14(%ebp),%eax
f01054a1:	8b 10                	mov    (%eax),%edx
f01054a3:	8b 48 04             	mov    0x4(%eax),%ecx
f01054a6:	8d 40 08             	lea    0x8(%eax),%eax
f01054a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01054ac:	b8 08 00 00 00       	mov    $0x8,%eax
f01054b1:	eb 3f                	jmp    f01054f2 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
f01054b3:	8b 45 14             	mov    0x14(%ebp),%eax
f01054b6:	8b 10                	mov    (%eax),%edx
f01054b8:	b9 00 00 00 00       	mov    $0x0,%ecx
f01054bd:	8d 40 04             	lea    0x4(%eax),%eax
f01054c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01054c3:	b8 08 00 00 00       	mov    $0x8,%eax
f01054c8:	eb 28                	jmp    f01054f2 <vprintfmt+0x3a7>
			putch('0', putdat);
f01054ca:	83 ec 08             	sub    $0x8,%esp
f01054cd:	53                   	push   %ebx
f01054ce:	6a 30                	push   $0x30
f01054d0:	ff d6                	call   *%esi
			putch('x', putdat);
f01054d2:	83 c4 08             	add    $0x8,%esp
f01054d5:	53                   	push   %ebx
f01054d6:	6a 78                	push   $0x78
f01054d8:	ff d6                	call   *%esi
			num = (unsigned long long)
f01054da:	8b 45 14             	mov    0x14(%ebp),%eax
f01054dd:	8b 10                	mov    (%eax),%edx
f01054df:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f01054e4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01054e7:	8d 40 04             	lea    0x4(%eax),%eax
f01054ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01054ed:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f01054f2:	83 ec 0c             	sub    $0xc,%esp
f01054f5:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
f01054f9:	57                   	push   %edi
f01054fa:	ff 75 e0             	pushl  -0x20(%ebp)
f01054fd:	50                   	push   %eax
f01054fe:	51                   	push   %ecx
f01054ff:	52                   	push   %edx
f0105500:	89 da                	mov    %ebx,%edx
f0105502:	89 f0                	mov    %esi,%eax
f0105504:	e8 5a fb ff ff       	call   f0105063 <printnum>
			break;
f0105509:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f010550c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f010550f:	e9 55 fc ff ff       	jmp    f0105169 <vprintfmt+0x1e>
	if (lflag >= 2)
f0105514:	83 f9 01             	cmp    $0x1,%ecx
f0105517:	7f 1b                	jg     f0105534 <vprintfmt+0x3e9>
	else if (lflag)
f0105519:	85 c9                	test   %ecx,%ecx
f010551b:	74 2c                	je     f0105549 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
f010551d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105520:	8b 10                	mov    (%eax),%edx
f0105522:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105527:	8d 40 04             	lea    0x4(%eax),%eax
f010552a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010552d:	b8 10 00 00 00       	mov    $0x10,%eax
f0105532:	eb be                	jmp    f01054f2 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
f0105534:	8b 45 14             	mov    0x14(%ebp),%eax
f0105537:	8b 10                	mov    (%eax),%edx
f0105539:	8b 48 04             	mov    0x4(%eax),%ecx
f010553c:	8d 40 08             	lea    0x8(%eax),%eax
f010553f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105542:	b8 10 00 00 00       	mov    $0x10,%eax
f0105547:	eb a9                	jmp    f01054f2 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
f0105549:	8b 45 14             	mov    0x14(%ebp),%eax
f010554c:	8b 10                	mov    (%eax),%edx
f010554e:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105553:	8d 40 04             	lea    0x4(%eax),%eax
f0105556:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105559:	b8 10 00 00 00       	mov    $0x10,%eax
f010555e:	eb 92                	jmp    f01054f2 <vprintfmt+0x3a7>
			putch(ch, putdat);
f0105560:	83 ec 08             	sub    $0x8,%esp
f0105563:	53                   	push   %ebx
f0105564:	6a 25                	push   $0x25
f0105566:	ff d6                	call   *%esi
			break;
f0105568:	83 c4 10             	add    $0x10,%esp
f010556b:	eb 9f                	jmp    f010550c <vprintfmt+0x3c1>
			putch('%', putdat);
f010556d:	83 ec 08             	sub    $0x8,%esp
f0105570:	53                   	push   %ebx
f0105571:	6a 25                	push   $0x25
f0105573:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0105575:	83 c4 10             	add    $0x10,%esp
f0105578:	89 f8                	mov    %edi,%eax
f010557a:	eb 03                	jmp    f010557f <vprintfmt+0x434>
f010557c:	83 e8 01             	sub    $0x1,%eax
f010557f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f0105583:	75 f7                	jne    f010557c <vprintfmt+0x431>
f0105585:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105588:	eb 82                	jmp    f010550c <vprintfmt+0x3c1>

f010558a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f010558a:	55                   	push   %ebp
f010558b:	89 e5                	mov    %esp,%ebp
f010558d:	83 ec 18             	sub    $0x18,%esp
f0105590:	8b 45 08             	mov    0x8(%ebp),%eax
f0105593:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0105596:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105599:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f010559d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01055a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01055a7:	85 c0                	test   %eax,%eax
f01055a9:	74 26                	je     f01055d1 <vsnprintf+0x47>
f01055ab:	85 d2                	test   %edx,%edx
f01055ad:	7e 22                	jle    f01055d1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01055af:	ff 75 14             	pushl  0x14(%ebp)
f01055b2:	ff 75 10             	pushl  0x10(%ebp)
f01055b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01055b8:	50                   	push   %eax
f01055b9:	68 11 51 10 f0       	push   $0xf0105111
f01055be:	e8 88 fb ff ff       	call   f010514b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01055c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01055c6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01055c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01055cc:	83 c4 10             	add    $0x10,%esp
}
f01055cf:	c9                   	leave  
f01055d0:	c3                   	ret    
		return -E_INVAL;
f01055d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01055d6:	eb f7                	jmp    f01055cf <vsnprintf+0x45>

f01055d8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01055d8:	55                   	push   %ebp
f01055d9:	89 e5                	mov    %esp,%ebp
f01055db:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f01055de:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f01055e1:	50                   	push   %eax
f01055e2:	ff 75 10             	pushl  0x10(%ebp)
f01055e5:	ff 75 0c             	pushl  0xc(%ebp)
f01055e8:	ff 75 08             	pushl  0x8(%ebp)
f01055eb:	e8 9a ff ff ff       	call   f010558a <vsnprintf>
	va_end(ap);

	return rc;
}
f01055f0:	c9                   	leave  
f01055f1:	c3                   	ret    

f01055f2 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f01055f2:	55                   	push   %ebp
f01055f3:	89 e5                	mov    %esp,%ebp
f01055f5:	57                   	push   %edi
f01055f6:	56                   	push   %esi
f01055f7:	53                   	push   %ebx
f01055f8:	83 ec 0c             	sub    $0xc,%esp
f01055fb:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f01055fe:	85 c0                	test   %eax,%eax
f0105600:	74 11                	je     f0105613 <readline+0x21>
		cprintf("%s", prompt);
f0105602:	83 ec 08             	sub    $0x8,%esp
f0105605:	50                   	push   %eax
f0105606:	68 c0 79 10 f0       	push   $0xf01079c0
f010560b:	e8 ca e3 ff ff       	call   f01039da <cprintf>
f0105610:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0105613:	83 ec 0c             	sub    $0xc,%esp
f0105616:	6a 00                	push   $0x0
f0105618:	e8 cc b1 ff ff       	call   f01007e9 <iscons>
f010561d:	89 c7                	mov    %eax,%edi
f010561f:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0105622:	be 00 00 00 00       	mov    $0x0,%esi
f0105627:	eb 57                	jmp    f0105680 <readline+0x8e>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0105629:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f010562e:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0105631:	75 08                	jne    f010563b <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0105633:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105636:	5b                   	pop    %ebx
f0105637:	5e                   	pop    %esi
f0105638:	5f                   	pop    %edi
f0105639:	5d                   	pop    %ebp
f010563a:	c3                   	ret    
				cprintf("read error: %e\n", c);
f010563b:	83 ec 08             	sub    $0x8,%esp
f010563e:	53                   	push   %ebx
f010563f:	68 9f 85 10 f0       	push   $0xf010859f
f0105644:	e8 91 e3 ff ff       	call   f01039da <cprintf>
f0105649:	83 c4 10             	add    $0x10,%esp
			return NULL;
f010564c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105651:	eb e0                	jmp    f0105633 <readline+0x41>
			if (echoing)
f0105653:	85 ff                	test   %edi,%edi
f0105655:	75 05                	jne    f010565c <readline+0x6a>
			i--;
f0105657:	83 ee 01             	sub    $0x1,%esi
f010565a:	eb 24                	jmp    f0105680 <readline+0x8e>
				cputchar('\b');
f010565c:	83 ec 0c             	sub    $0xc,%esp
f010565f:	6a 08                	push   $0x8
f0105661:	e8 62 b1 ff ff       	call   f01007c8 <cputchar>
f0105666:	83 c4 10             	add    $0x10,%esp
f0105669:	eb ec                	jmp    f0105657 <readline+0x65>
				cputchar(c);
f010566b:	83 ec 0c             	sub    $0xc,%esp
f010566e:	53                   	push   %ebx
f010566f:	e8 54 b1 ff ff       	call   f01007c8 <cputchar>
f0105674:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f0105677:	88 9e 80 3a 53 f0    	mov    %bl,-0xfacc580(%esi)
f010567d:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f0105680:	e8 53 b1 ff ff       	call   f01007d8 <getchar>
f0105685:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f0105687:	85 c0                	test   %eax,%eax
f0105689:	78 9e                	js     f0105629 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f010568b:	83 f8 08             	cmp    $0x8,%eax
f010568e:	0f 94 c2             	sete   %dl
f0105691:	83 f8 7f             	cmp    $0x7f,%eax
f0105694:	0f 94 c0             	sete   %al
f0105697:	08 c2                	or     %al,%dl
f0105699:	74 04                	je     f010569f <readline+0xad>
f010569b:	85 f6                	test   %esi,%esi
f010569d:	7f b4                	jg     f0105653 <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f010569f:	83 fb 1f             	cmp    $0x1f,%ebx
f01056a2:	7e 0e                	jle    f01056b2 <readline+0xc0>
f01056a4:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01056aa:	7f 06                	jg     f01056b2 <readline+0xc0>
			if (echoing)
f01056ac:	85 ff                	test   %edi,%edi
f01056ae:	74 c7                	je     f0105677 <readline+0x85>
f01056b0:	eb b9                	jmp    f010566b <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f01056b2:	83 fb 0a             	cmp    $0xa,%ebx
f01056b5:	74 05                	je     f01056bc <readline+0xca>
f01056b7:	83 fb 0d             	cmp    $0xd,%ebx
f01056ba:	75 c4                	jne    f0105680 <readline+0x8e>
			if (echoing)
f01056bc:	85 ff                	test   %edi,%edi
f01056be:	75 11                	jne    f01056d1 <readline+0xdf>
			buf[i] = 0;
f01056c0:	c6 86 80 3a 53 f0 00 	movb   $0x0,-0xfacc580(%esi)
			return buf;
f01056c7:	b8 80 3a 53 f0       	mov    $0xf0533a80,%eax
f01056cc:	e9 62 ff ff ff       	jmp    f0105633 <readline+0x41>
				cputchar('\n');
f01056d1:	83 ec 0c             	sub    $0xc,%esp
f01056d4:	6a 0a                	push   $0xa
f01056d6:	e8 ed b0 ff ff       	call   f01007c8 <cputchar>
f01056db:	83 c4 10             	add    $0x10,%esp
f01056de:	eb e0                	jmp    f01056c0 <readline+0xce>

f01056e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f01056e0:	55                   	push   %ebp
f01056e1:	89 e5                	mov    %esp,%ebp
f01056e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f01056e6:	b8 00 00 00 00       	mov    $0x0,%eax
f01056eb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f01056ef:	74 05                	je     f01056f6 <strlen+0x16>
		n++;
f01056f1:	83 c0 01             	add    $0x1,%eax
f01056f4:	eb f5                	jmp    f01056eb <strlen+0xb>
	return n;
}
f01056f6:	5d                   	pop    %ebp
f01056f7:	c3                   	ret    

f01056f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f01056f8:	55                   	push   %ebp
f01056f9:	89 e5                	mov    %esp,%ebp
f01056fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01056fe:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105701:	ba 00 00 00 00       	mov    $0x0,%edx
f0105706:	39 c2                	cmp    %eax,%edx
f0105708:	74 0d                	je     f0105717 <strnlen+0x1f>
f010570a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f010570e:	74 05                	je     f0105715 <strnlen+0x1d>
		n++;
f0105710:	83 c2 01             	add    $0x1,%edx
f0105713:	eb f1                	jmp    f0105706 <strnlen+0xe>
f0105715:	89 d0                	mov    %edx,%eax
	return n;
}
f0105717:	5d                   	pop    %ebp
f0105718:	c3                   	ret    

f0105719 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105719:	55                   	push   %ebp
f010571a:	89 e5                	mov    %esp,%ebp
f010571c:	53                   	push   %ebx
f010571d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105720:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0105723:	ba 00 00 00 00       	mov    $0x0,%edx
f0105728:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f010572c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f010572f:	83 c2 01             	add    $0x1,%edx
f0105732:	84 c9                	test   %cl,%cl
f0105734:	75 f2                	jne    f0105728 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0105736:	5b                   	pop    %ebx
f0105737:	5d                   	pop    %ebp
f0105738:	c3                   	ret    

f0105739 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105739:	55                   	push   %ebp
f010573a:	89 e5                	mov    %esp,%ebp
f010573c:	53                   	push   %ebx
f010573d:	83 ec 10             	sub    $0x10,%esp
f0105740:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105743:	53                   	push   %ebx
f0105744:	e8 97 ff ff ff       	call   f01056e0 <strlen>
f0105749:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f010574c:	ff 75 0c             	pushl  0xc(%ebp)
f010574f:	01 d8                	add    %ebx,%eax
f0105751:	50                   	push   %eax
f0105752:	e8 c2 ff ff ff       	call   f0105719 <strcpy>
	return dst;
}
f0105757:	89 d8                	mov    %ebx,%eax
f0105759:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010575c:	c9                   	leave  
f010575d:	c3                   	ret    

f010575e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f010575e:	55                   	push   %ebp
f010575f:	89 e5                	mov    %esp,%ebp
f0105761:	56                   	push   %esi
f0105762:	53                   	push   %ebx
f0105763:	8b 45 08             	mov    0x8(%ebp),%eax
f0105766:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105769:	89 c6                	mov    %eax,%esi
f010576b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f010576e:	89 c2                	mov    %eax,%edx
f0105770:	39 f2                	cmp    %esi,%edx
f0105772:	74 11                	je     f0105785 <strncpy+0x27>
		*dst++ = *src;
f0105774:	83 c2 01             	add    $0x1,%edx
f0105777:	0f b6 19             	movzbl (%ecx),%ebx
f010577a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f010577d:	80 fb 01             	cmp    $0x1,%bl
f0105780:	83 d9 ff             	sbb    $0xffffffff,%ecx
f0105783:	eb eb                	jmp    f0105770 <strncpy+0x12>
	}
	return ret;
}
f0105785:	5b                   	pop    %ebx
f0105786:	5e                   	pop    %esi
f0105787:	5d                   	pop    %ebp
f0105788:	c3                   	ret    

f0105789 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0105789:	55                   	push   %ebp
f010578a:	89 e5                	mov    %esp,%ebp
f010578c:	56                   	push   %esi
f010578d:	53                   	push   %ebx
f010578e:	8b 75 08             	mov    0x8(%ebp),%esi
f0105791:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105794:	8b 55 10             	mov    0x10(%ebp),%edx
f0105797:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0105799:	85 d2                	test   %edx,%edx
f010579b:	74 21                	je     f01057be <strlcpy+0x35>
f010579d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f01057a1:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f01057a3:	39 c2                	cmp    %eax,%edx
f01057a5:	74 14                	je     f01057bb <strlcpy+0x32>
f01057a7:	0f b6 19             	movzbl (%ecx),%ebx
f01057aa:	84 db                	test   %bl,%bl
f01057ac:	74 0b                	je     f01057b9 <strlcpy+0x30>
			*dst++ = *src++;
f01057ae:	83 c1 01             	add    $0x1,%ecx
f01057b1:	83 c2 01             	add    $0x1,%edx
f01057b4:	88 5a ff             	mov    %bl,-0x1(%edx)
f01057b7:	eb ea                	jmp    f01057a3 <strlcpy+0x1a>
f01057b9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f01057bb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01057be:	29 f0                	sub    %esi,%eax
}
f01057c0:	5b                   	pop    %ebx
f01057c1:	5e                   	pop    %esi
f01057c2:	5d                   	pop    %ebp
f01057c3:	c3                   	ret    

f01057c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01057c4:	55                   	push   %ebp
f01057c5:	89 e5                	mov    %esp,%ebp
f01057c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01057ca:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01057cd:	0f b6 01             	movzbl (%ecx),%eax
f01057d0:	84 c0                	test   %al,%al
f01057d2:	74 0c                	je     f01057e0 <strcmp+0x1c>
f01057d4:	3a 02                	cmp    (%edx),%al
f01057d6:	75 08                	jne    f01057e0 <strcmp+0x1c>
		p++, q++;
f01057d8:	83 c1 01             	add    $0x1,%ecx
f01057db:	83 c2 01             	add    $0x1,%edx
f01057de:	eb ed                	jmp    f01057cd <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f01057e0:	0f b6 c0             	movzbl %al,%eax
f01057e3:	0f b6 12             	movzbl (%edx),%edx
f01057e6:	29 d0                	sub    %edx,%eax
}
f01057e8:	5d                   	pop    %ebp
f01057e9:	c3                   	ret    

f01057ea <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f01057ea:	55                   	push   %ebp
f01057eb:	89 e5                	mov    %esp,%ebp
f01057ed:	53                   	push   %ebx
f01057ee:	8b 45 08             	mov    0x8(%ebp),%eax
f01057f1:	8b 55 0c             	mov    0xc(%ebp),%edx
f01057f4:	89 c3                	mov    %eax,%ebx
f01057f6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f01057f9:	eb 06                	jmp    f0105801 <strncmp+0x17>
		n--, p++, q++;
f01057fb:	83 c0 01             	add    $0x1,%eax
f01057fe:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105801:	39 d8                	cmp    %ebx,%eax
f0105803:	74 16                	je     f010581b <strncmp+0x31>
f0105805:	0f b6 08             	movzbl (%eax),%ecx
f0105808:	84 c9                	test   %cl,%cl
f010580a:	74 04                	je     f0105810 <strncmp+0x26>
f010580c:	3a 0a                	cmp    (%edx),%cl
f010580e:	74 eb                	je     f01057fb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105810:	0f b6 00             	movzbl (%eax),%eax
f0105813:	0f b6 12             	movzbl (%edx),%edx
f0105816:	29 d0                	sub    %edx,%eax
}
f0105818:	5b                   	pop    %ebx
f0105819:	5d                   	pop    %ebp
f010581a:	c3                   	ret    
		return 0;
f010581b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105820:	eb f6                	jmp    f0105818 <strncmp+0x2e>

f0105822 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105822:	55                   	push   %ebp
f0105823:	89 e5                	mov    %esp,%ebp
f0105825:	8b 45 08             	mov    0x8(%ebp),%eax
f0105828:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010582c:	0f b6 10             	movzbl (%eax),%edx
f010582f:	84 d2                	test   %dl,%dl
f0105831:	74 09                	je     f010583c <strchr+0x1a>
		if (*s == c)
f0105833:	38 ca                	cmp    %cl,%dl
f0105835:	74 0a                	je     f0105841 <strchr+0x1f>
	for (; *s; s++)
f0105837:	83 c0 01             	add    $0x1,%eax
f010583a:	eb f0                	jmp    f010582c <strchr+0xa>
			return (char *) s;
	return 0;
f010583c:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105841:	5d                   	pop    %ebp
f0105842:	c3                   	ret    

f0105843 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0105843:	55                   	push   %ebp
f0105844:	89 e5                	mov    %esp,%ebp
f0105846:	8b 45 08             	mov    0x8(%ebp),%eax
f0105849:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010584d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0105850:	38 ca                	cmp    %cl,%dl
f0105852:	74 09                	je     f010585d <strfind+0x1a>
f0105854:	84 d2                	test   %dl,%dl
f0105856:	74 05                	je     f010585d <strfind+0x1a>
	for (; *s; s++)
f0105858:	83 c0 01             	add    $0x1,%eax
f010585b:	eb f0                	jmp    f010584d <strfind+0xa>
			break;
	return (char *) s;
}
f010585d:	5d                   	pop    %ebp
f010585e:	c3                   	ret    

f010585f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f010585f:	55                   	push   %ebp
f0105860:	89 e5                	mov    %esp,%ebp
f0105862:	57                   	push   %edi
f0105863:	56                   	push   %esi
f0105864:	53                   	push   %ebx
f0105865:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105868:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f010586b:	85 c9                	test   %ecx,%ecx
f010586d:	74 31                	je     f01058a0 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f010586f:	89 f8                	mov    %edi,%eax
f0105871:	09 c8                	or     %ecx,%eax
f0105873:	a8 03                	test   $0x3,%al
f0105875:	75 23                	jne    f010589a <memset+0x3b>
		c &= 0xFF;
f0105877:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f010587b:	89 d3                	mov    %edx,%ebx
f010587d:	c1 e3 08             	shl    $0x8,%ebx
f0105880:	89 d0                	mov    %edx,%eax
f0105882:	c1 e0 18             	shl    $0x18,%eax
f0105885:	89 d6                	mov    %edx,%esi
f0105887:	c1 e6 10             	shl    $0x10,%esi
f010588a:	09 f0                	or     %esi,%eax
f010588c:	09 c2                	or     %eax,%edx
f010588e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0105890:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0105893:	89 d0                	mov    %edx,%eax
f0105895:	fc                   	cld    
f0105896:	f3 ab                	rep stos %eax,%es:(%edi)
f0105898:	eb 06                	jmp    f01058a0 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f010589a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010589d:	fc                   	cld    
f010589e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01058a0:	89 f8                	mov    %edi,%eax
f01058a2:	5b                   	pop    %ebx
f01058a3:	5e                   	pop    %esi
f01058a4:	5f                   	pop    %edi
f01058a5:	5d                   	pop    %ebp
f01058a6:	c3                   	ret    

f01058a7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01058a7:	55                   	push   %ebp
f01058a8:	89 e5                	mov    %esp,%ebp
f01058aa:	57                   	push   %edi
f01058ab:	56                   	push   %esi
f01058ac:	8b 45 08             	mov    0x8(%ebp),%eax
f01058af:	8b 75 0c             	mov    0xc(%ebp),%esi
f01058b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f01058b5:	39 c6                	cmp    %eax,%esi
f01058b7:	73 32                	jae    f01058eb <memmove+0x44>
f01058b9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01058bc:	39 c2                	cmp    %eax,%edx
f01058be:	76 2b                	jbe    f01058eb <memmove+0x44>
		s += n;
		d += n;
f01058c0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01058c3:	89 fe                	mov    %edi,%esi
f01058c5:	09 ce                	or     %ecx,%esi
f01058c7:	09 d6                	or     %edx,%esi
f01058c9:	f7 c6 03 00 00 00    	test   $0x3,%esi
f01058cf:	75 0e                	jne    f01058df <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f01058d1:	83 ef 04             	sub    $0x4,%edi
f01058d4:	8d 72 fc             	lea    -0x4(%edx),%esi
f01058d7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f01058da:	fd                   	std    
f01058db:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01058dd:	eb 09                	jmp    f01058e8 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f01058df:	83 ef 01             	sub    $0x1,%edi
f01058e2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f01058e5:	fd                   	std    
f01058e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f01058e8:	fc                   	cld    
f01058e9:	eb 1a                	jmp    f0105905 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01058eb:	89 c2                	mov    %eax,%edx
f01058ed:	09 ca                	or     %ecx,%edx
f01058ef:	09 f2                	or     %esi,%edx
f01058f1:	f6 c2 03             	test   $0x3,%dl
f01058f4:	75 0a                	jne    f0105900 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f01058f6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f01058f9:	89 c7                	mov    %eax,%edi
f01058fb:	fc                   	cld    
f01058fc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01058fe:	eb 05                	jmp    f0105905 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f0105900:	89 c7                	mov    %eax,%edi
f0105902:	fc                   	cld    
f0105903:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105905:	5e                   	pop    %esi
f0105906:	5f                   	pop    %edi
f0105907:	5d                   	pop    %ebp
f0105908:	c3                   	ret    

f0105909 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0105909:	55                   	push   %ebp
f010590a:	89 e5                	mov    %esp,%ebp
f010590c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f010590f:	ff 75 10             	pushl  0x10(%ebp)
f0105912:	ff 75 0c             	pushl  0xc(%ebp)
f0105915:	ff 75 08             	pushl  0x8(%ebp)
f0105918:	e8 8a ff ff ff       	call   f01058a7 <memmove>
}
f010591d:	c9                   	leave  
f010591e:	c3                   	ret    

f010591f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f010591f:	55                   	push   %ebp
f0105920:	89 e5                	mov    %esp,%ebp
f0105922:	56                   	push   %esi
f0105923:	53                   	push   %ebx
f0105924:	8b 45 08             	mov    0x8(%ebp),%eax
f0105927:	8b 55 0c             	mov    0xc(%ebp),%edx
f010592a:	89 c6                	mov    %eax,%esi
f010592c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010592f:	39 f0                	cmp    %esi,%eax
f0105931:	74 1c                	je     f010594f <memcmp+0x30>
		if (*s1 != *s2)
f0105933:	0f b6 08             	movzbl (%eax),%ecx
f0105936:	0f b6 1a             	movzbl (%edx),%ebx
f0105939:	38 d9                	cmp    %bl,%cl
f010593b:	75 08                	jne    f0105945 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f010593d:	83 c0 01             	add    $0x1,%eax
f0105940:	83 c2 01             	add    $0x1,%edx
f0105943:	eb ea                	jmp    f010592f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f0105945:	0f b6 c1             	movzbl %cl,%eax
f0105948:	0f b6 db             	movzbl %bl,%ebx
f010594b:	29 d8                	sub    %ebx,%eax
f010594d:	eb 05                	jmp    f0105954 <memcmp+0x35>
	}

	return 0;
f010594f:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105954:	5b                   	pop    %ebx
f0105955:	5e                   	pop    %esi
f0105956:	5d                   	pop    %ebp
f0105957:	c3                   	ret    

f0105958 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0105958:	55                   	push   %ebp
f0105959:	89 e5                	mov    %esp,%ebp
f010595b:	8b 45 08             	mov    0x8(%ebp),%eax
f010595e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0105961:	89 c2                	mov    %eax,%edx
f0105963:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0105966:	39 d0                	cmp    %edx,%eax
f0105968:	73 09                	jae    f0105973 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f010596a:	38 08                	cmp    %cl,(%eax)
f010596c:	74 05                	je     f0105973 <memfind+0x1b>
	for (; s < ends; s++)
f010596e:	83 c0 01             	add    $0x1,%eax
f0105971:	eb f3                	jmp    f0105966 <memfind+0xe>
			break;
	return (void *) s;
}
f0105973:	5d                   	pop    %ebp
f0105974:	c3                   	ret    

f0105975 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0105975:	55                   	push   %ebp
f0105976:	89 e5                	mov    %esp,%ebp
f0105978:	57                   	push   %edi
f0105979:	56                   	push   %esi
f010597a:	53                   	push   %ebx
f010597b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010597e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0105981:	eb 03                	jmp    f0105986 <strtol+0x11>
		s++;
f0105983:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0105986:	0f b6 01             	movzbl (%ecx),%eax
f0105989:	3c 20                	cmp    $0x20,%al
f010598b:	74 f6                	je     f0105983 <strtol+0xe>
f010598d:	3c 09                	cmp    $0x9,%al
f010598f:	74 f2                	je     f0105983 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f0105991:	3c 2b                	cmp    $0x2b,%al
f0105993:	74 2a                	je     f01059bf <strtol+0x4a>
	int neg = 0;
f0105995:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f010599a:	3c 2d                	cmp    $0x2d,%al
f010599c:	74 2b                	je     f01059c9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f010599e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01059a4:	75 0f                	jne    f01059b5 <strtol+0x40>
f01059a6:	80 39 30             	cmpb   $0x30,(%ecx)
f01059a9:	74 28                	je     f01059d3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01059ab:	85 db                	test   %ebx,%ebx
f01059ad:	b8 0a 00 00 00       	mov    $0xa,%eax
f01059b2:	0f 44 d8             	cmove  %eax,%ebx
f01059b5:	b8 00 00 00 00       	mov    $0x0,%eax
f01059ba:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01059bd:	eb 50                	jmp    f0105a0f <strtol+0x9a>
		s++;
f01059bf:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f01059c2:	bf 00 00 00 00       	mov    $0x0,%edi
f01059c7:	eb d5                	jmp    f010599e <strtol+0x29>
		s++, neg = 1;
f01059c9:	83 c1 01             	add    $0x1,%ecx
f01059cc:	bf 01 00 00 00       	mov    $0x1,%edi
f01059d1:	eb cb                	jmp    f010599e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01059d3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f01059d7:	74 0e                	je     f01059e7 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f01059d9:	85 db                	test   %ebx,%ebx
f01059db:	75 d8                	jne    f01059b5 <strtol+0x40>
		s++, base = 8;
f01059dd:	83 c1 01             	add    $0x1,%ecx
f01059e0:	bb 08 00 00 00       	mov    $0x8,%ebx
f01059e5:	eb ce                	jmp    f01059b5 <strtol+0x40>
		s += 2, base = 16;
f01059e7:	83 c1 02             	add    $0x2,%ecx
f01059ea:	bb 10 00 00 00       	mov    $0x10,%ebx
f01059ef:	eb c4                	jmp    f01059b5 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f01059f1:	8d 72 9f             	lea    -0x61(%edx),%esi
f01059f4:	89 f3                	mov    %esi,%ebx
f01059f6:	80 fb 19             	cmp    $0x19,%bl
f01059f9:	77 29                	ja     f0105a24 <strtol+0xaf>
			dig = *s - 'a' + 10;
f01059fb:	0f be d2             	movsbl %dl,%edx
f01059fe:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105a01:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105a04:	7d 30                	jge    f0105a36 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f0105a06:	83 c1 01             	add    $0x1,%ecx
f0105a09:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105a0d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0105a0f:	0f b6 11             	movzbl (%ecx),%edx
f0105a12:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105a15:	89 f3                	mov    %esi,%ebx
f0105a17:	80 fb 09             	cmp    $0x9,%bl
f0105a1a:	77 d5                	ja     f01059f1 <strtol+0x7c>
			dig = *s - '0';
f0105a1c:	0f be d2             	movsbl %dl,%edx
f0105a1f:	83 ea 30             	sub    $0x30,%edx
f0105a22:	eb dd                	jmp    f0105a01 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f0105a24:	8d 72 bf             	lea    -0x41(%edx),%esi
f0105a27:	89 f3                	mov    %esi,%ebx
f0105a29:	80 fb 19             	cmp    $0x19,%bl
f0105a2c:	77 08                	ja     f0105a36 <strtol+0xc1>
			dig = *s - 'A' + 10;
f0105a2e:	0f be d2             	movsbl %dl,%edx
f0105a31:	83 ea 37             	sub    $0x37,%edx
f0105a34:	eb cb                	jmp    f0105a01 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f0105a36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0105a3a:	74 05                	je     f0105a41 <strtol+0xcc>
		*endptr = (char *) s;
f0105a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105a3f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0105a41:	89 c2                	mov    %eax,%edx
f0105a43:	f7 da                	neg    %edx
f0105a45:	85 ff                	test   %edi,%edi
f0105a47:	0f 45 c2             	cmovne %edx,%eax
}
f0105a4a:	5b                   	pop    %ebx
f0105a4b:	5e                   	pop    %esi
f0105a4c:	5f                   	pop    %edi
f0105a4d:	5d                   	pop    %ebp
f0105a4e:	c3                   	ret    
f0105a4f:	90                   	nop

f0105a50 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0105a50:	fa                   	cli    

	xorw    %ax, %ax
f0105a51:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0105a53:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105a55:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105a57:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0105a59:	0f 01 16             	lgdtl  (%esi)
f0105a5c:	74 70                	je     f0105ace <mpsearch1+0x3>
	movl    %cr0, %eax
f0105a5e:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0105a61:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0105a65:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0105a68:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0105a6e:	08 00                	or     %al,(%eax)

f0105a70 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0105a70:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0105a74:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105a76:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105a78:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0105a7a:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0105a7e:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0105a80:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0105a82:	b8 00 30 12 00       	mov    $0x123000,%eax
	movl    %eax, %cr3
f0105a87:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0105a8a:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0105a8d:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0105a92:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0105a95:	8b 25 9c 3e 53 f0    	mov    0xf0533e9c,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0105a9b:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105aa0:	b8 fa 01 10 f0       	mov    $0xf01001fa,%eax
	call    *%eax
f0105aa5:	ff d0                	call   *%eax

f0105aa7 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0105aa7:	eb fe                	jmp    f0105aa7 <spin>
f0105aa9:	8d 76 00             	lea    0x0(%esi),%esi

f0105aac <gdt>:
	...
f0105ab4:	ff                   	(bad)  
f0105ab5:	ff 00                	incl   (%eax)
f0105ab7:	00 00                	add    %al,(%eax)
f0105ab9:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105ac0:	00                   	.byte 0x0
f0105ac1:	92                   	xchg   %eax,%edx
f0105ac2:	cf                   	iret   
	...

f0105ac4 <gdtdesc>:
f0105ac4:	17                   	pop    %ss
f0105ac5:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0105aca <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0105aca:	90                   	nop

f0105acb <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0105acb:	55                   	push   %ebp
f0105acc:	89 e5                	mov    %esp,%ebp
f0105ace:	57                   	push   %edi
f0105acf:	56                   	push   %esi
f0105ad0:	53                   	push   %ebx
f0105ad1:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0105ad4:	8b 0d a0 3e 53 f0    	mov    0xf0533ea0,%ecx
f0105ada:	89 c3                	mov    %eax,%ebx
f0105adc:	c1 eb 0c             	shr    $0xc,%ebx
f0105adf:	39 cb                	cmp    %ecx,%ebx
f0105ae1:	73 1a                	jae    f0105afd <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0105ae3:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105ae9:	8d 3c 02             	lea    (%edx,%eax,1),%edi
	if (PGNUM(pa) >= npages)
f0105aec:	89 f8                	mov    %edi,%eax
f0105aee:	c1 e8 0c             	shr    $0xc,%eax
f0105af1:	39 c8                	cmp    %ecx,%eax
f0105af3:	73 1a                	jae    f0105b0f <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0105af5:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0105afb:	eb 27                	jmp    f0105b24 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105afd:	50                   	push   %eax
f0105afe:	68 44 6a 10 f0       	push   $0xf0106a44
f0105b03:	6a 57                	push   $0x57
f0105b05:	68 3d 87 10 f0       	push   $0xf010873d
f0105b0a:	e8 31 a5 ff ff       	call   f0100040 <_panic>
f0105b0f:	57                   	push   %edi
f0105b10:	68 44 6a 10 f0       	push   $0xf0106a44
f0105b15:	6a 57                	push   $0x57
f0105b17:	68 3d 87 10 f0       	push   $0xf010873d
f0105b1c:	e8 1f a5 ff ff       	call   f0100040 <_panic>
f0105b21:	83 c3 10             	add    $0x10,%ebx
f0105b24:	39 fb                	cmp    %edi,%ebx
f0105b26:	73 30                	jae    f0105b58 <mpsearch1+0x8d>
f0105b28:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105b2a:	83 ec 04             	sub    $0x4,%esp
f0105b2d:	6a 04                	push   $0x4
f0105b2f:	68 4d 87 10 f0       	push   $0xf010874d
f0105b34:	53                   	push   %ebx
f0105b35:	e8 e5 fd ff ff       	call   f010591f <memcmp>
f0105b3a:	83 c4 10             	add    $0x10,%esp
f0105b3d:	85 c0                	test   %eax,%eax
f0105b3f:	75 e0                	jne    f0105b21 <mpsearch1+0x56>
f0105b41:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f0105b43:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f0105b46:	0f b6 0a             	movzbl (%edx),%ecx
f0105b49:	01 c8                	add    %ecx,%eax
f0105b4b:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0105b4e:	39 f2                	cmp    %esi,%edx
f0105b50:	75 f4                	jne    f0105b46 <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105b52:	84 c0                	test   %al,%al
f0105b54:	75 cb                	jne    f0105b21 <mpsearch1+0x56>
f0105b56:	eb 05                	jmp    f0105b5d <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0105b58:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0105b5d:	89 d8                	mov    %ebx,%eax
f0105b5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105b62:	5b                   	pop    %ebx
f0105b63:	5e                   	pop    %esi
f0105b64:	5f                   	pop    %edi
f0105b65:	5d                   	pop    %ebp
f0105b66:	c3                   	ret    

f0105b67 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0105b67:	55                   	push   %ebp
f0105b68:	89 e5                	mov    %esp,%ebp
f0105b6a:	57                   	push   %edi
f0105b6b:	56                   	push   %esi
f0105b6c:	53                   	push   %ebx
f0105b6d:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0105b70:	c7 05 c0 43 53 f0 20 	movl   $0xf0534020,0xf05343c0
f0105b77:	40 53 f0 
	if (PGNUM(pa) >= npages)
f0105b7a:	83 3d a0 3e 53 f0 00 	cmpl   $0x0,0xf0533ea0
f0105b81:	0f 84 a3 00 00 00    	je     f0105c2a <mp_init+0xc3>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0105b87:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0105b8e:	85 c0                	test   %eax,%eax
f0105b90:	0f 84 aa 00 00 00    	je     f0105c40 <mp_init+0xd9>
		p <<= 4;	// Translate from segment to PA
f0105b96:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0105b99:	ba 00 04 00 00       	mov    $0x400,%edx
f0105b9e:	e8 28 ff ff ff       	call   f0105acb <mpsearch1>
f0105ba3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105ba6:	85 c0                	test   %eax,%eax
f0105ba8:	75 1a                	jne    f0105bc4 <mp_init+0x5d>
	return mpsearch1(0xF0000, 0x10000);
f0105baa:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105baf:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0105bb4:	e8 12 ff ff ff       	call   f0105acb <mpsearch1>
f0105bb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0105bbc:	85 c0                	test   %eax,%eax
f0105bbe:	0f 84 31 02 00 00    	je     f0105df5 <mp_init+0x28e>
	if (mp->physaddr == 0 || mp->type != 0) {
f0105bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105bc7:	8b 58 04             	mov    0x4(%eax),%ebx
f0105bca:	85 db                	test   %ebx,%ebx
f0105bcc:	0f 84 97 00 00 00    	je     f0105c69 <mp_init+0x102>
f0105bd2:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0105bd6:	0f 85 8d 00 00 00    	jne    f0105c69 <mp_init+0x102>
f0105bdc:	89 d8                	mov    %ebx,%eax
f0105bde:	c1 e8 0c             	shr    $0xc,%eax
f0105be1:	3b 05 a0 3e 53 f0    	cmp    0xf0533ea0,%eax
f0105be7:	0f 83 91 00 00 00    	jae    f0105c7e <mp_init+0x117>
	return (void *)(pa + KERNBASE);
f0105bed:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0105bf3:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105bf5:	83 ec 04             	sub    $0x4,%esp
f0105bf8:	6a 04                	push   $0x4
f0105bfa:	68 52 87 10 f0       	push   $0xf0108752
f0105bff:	53                   	push   %ebx
f0105c00:	e8 1a fd ff ff       	call   f010591f <memcmp>
f0105c05:	83 c4 10             	add    $0x10,%esp
f0105c08:	85 c0                	test   %eax,%eax
f0105c0a:	0f 85 83 00 00 00    	jne    f0105c93 <mp_init+0x12c>
f0105c10:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0105c14:	01 df                	add    %ebx,%edi
	sum = 0;
f0105c16:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0105c18:	39 fb                	cmp    %edi,%ebx
f0105c1a:	0f 84 88 00 00 00    	je     f0105ca8 <mp_init+0x141>
		sum += ((uint8_t *)addr)[i];
f0105c20:	0f b6 0b             	movzbl (%ebx),%ecx
f0105c23:	01 ca                	add    %ecx,%edx
f0105c25:	83 c3 01             	add    $0x1,%ebx
f0105c28:	eb ee                	jmp    f0105c18 <mp_init+0xb1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105c2a:	68 00 04 00 00       	push   $0x400
f0105c2f:	68 44 6a 10 f0       	push   $0xf0106a44
f0105c34:	6a 6f                	push   $0x6f
f0105c36:	68 3d 87 10 f0       	push   $0xf010873d
f0105c3b:	e8 00 a4 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0105c40:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105c47:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105c4a:	2d 00 04 00 00       	sub    $0x400,%eax
f0105c4f:	ba 00 04 00 00       	mov    $0x400,%edx
f0105c54:	e8 72 fe ff ff       	call   f0105acb <mpsearch1>
f0105c59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105c5c:	85 c0                	test   %eax,%eax
f0105c5e:	0f 85 60 ff ff ff    	jne    f0105bc4 <mp_init+0x5d>
f0105c64:	e9 41 ff ff ff       	jmp    f0105baa <mp_init+0x43>
		cprintf("SMP: Default configurations not implemented\n");
f0105c69:	83 ec 0c             	sub    $0xc,%esp
f0105c6c:	68 b0 85 10 f0       	push   $0xf01085b0
f0105c71:	e8 64 dd ff ff       	call   f01039da <cprintf>
f0105c76:	83 c4 10             	add    $0x10,%esp
f0105c79:	e9 77 01 00 00       	jmp    f0105df5 <mp_init+0x28e>
f0105c7e:	53                   	push   %ebx
f0105c7f:	68 44 6a 10 f0       	push   $0xf0106a44
f0105c84:	68 90 00 00 00       	push   $0x90
f0105c89:	68 3d 87 10 f0       	push   $0xf010873d
f0105c8e:	e8 ad a3 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0105c93:	83 ec 0c             	sub    $0xc,%esp
f0105c96:	68 e0 85 10 f0       	push   $0xf01085e0
f0105c9b:	e8 3a dd ff ff       	call   f01039da <cprintf>
f0105ca0:	83 c4 10             	add    $0x10,%esp
f0105ca3:	e9 4d 01 00 00       	jmp    f0105df5 <mp_init+0x28e>
	if (sum(conf, conf->length) != 0) {
f0105ca8:	84 d2                	test   %dl,%dl
f0105caa:	75 16                	jne    f0105cc2 <mp_init+0x15b>
	if (conf->version != 1 && conf->version != 4) {
f0105cac:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0105cb0:	80 fa 01             	cmp    $0x1,%dl
f0105cb3:	74 05                	je     f0105cba <mp_init+0x153>
f0105cb5:	80 fa 04             	cmp    $0x4,%dl
f0105cb8:	75 1d                	jne    f0105cd7 <mp_init+0x170>
f0105cba:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0105cbe:	01 d9                	add    %ebx,%ecx
f0105cc0:	eb 36                	jmp    f0105cf8 <mp_init+0x191>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105cc2:	83 ec 0c             	sub    $0xc,%esp
f0105cc5:	68 14 86 10 f0       	push   $0xf0108614
f0105cca:	e8 0b dd ff ff       	call   f01039da <cprintf>
f0105ccf:	83 c4 10             	add    $0x10,%esp
f0105cd2:	e9 1e 01 00 00       	jmp    f0105df5 <mp_init+0x28e>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105cd7:	83 ec 08             	sub    $0x8,%esp
f0105cda:	0f b6 d2             	movzbl %dl,%edx
f0105cdd:	52                   	push   %edx
f0105cde:	68 38 86 10 f0       	push   $0xf0108638
f0105ce3:	e8 f2 dc ff ff       	call   f01039da <cprintf>
f0105ce8:	83 c4 10             	add    $0x10,%esp
f0105ceb:	e9 05 01 00 00       	jmp    f0105df5 <mp_init+0x28e>
		sum += ((uint8_t *)addr)[i];
f0105cf0:	0f b6 13             	movzbl (%ebx),%edx
f0105cf3:	01 d0                	add    %edx,%eax
f0105cf5:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0105cf8:	39 d9                	cmp    %ebx,%ecx
f0105cfa:	75 f4                	jne    f0105cf0 <mp_init+0x189>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105cfc:	02 46 2a             	add    0x2a(%esi),%al
f0105cff:	75 1c                	jne    f0105d1d <mp_init+0x1b6>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0105d01:	c7 05 00 40 53 f0 01 	movl   $0x1,0xf0534000
f0105d08:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105d0b:	8b 46 24             	mov    0x24(%esi),%eax
f0105d0e:	a3 00 50 57 f0       	mov    %eax,0xf0575000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105d13:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0105d16:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105d1b:	eb 4d                	jmp    f0105d6a <mp_init+0x203>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0105d1d:	83 ec 0c             	sub    $0xc,%esp
f0105d20:	68 58 86 10 f0       	push   $0xf0108658
f0105d25:	e8 b0 dc ff ff       	call   f01039da <cprintf>
f0105d2a:	83 c4 10             	add    $0x10,%esp
f0105d2d:	e9 c3 00 00 00       	jmp    f0105df5 <mp_init+0x28e>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105d32:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0105d36:	74 11                	je     f0105d49 <mp_init+0x1e2>
				bootcpu = &cpus[ncpu];
f0105d38:	6b 05 c4 43 53 f0 74 	imul   $0x74,0xf05343c4,%eax
f0105d3f:	05 20 40 53 f0       	add    $0xf0534020,%eax
f0105d44:	a3 c0 43 53 f0       	mov    %eax,0xf05343c0
			if (ncpu < NCPU) {
f0105d49:	a1 c4 43 53 f0       	mov    0xf05343c4,%eax
f0105d4e:	83 f8 07             	cmp    $0x7,%eax
f0105d51:	7f 2f                	jg     f0105d82 <mp_init+0x21b>
				cpus[ncpu].cpu_id = ncpu;
f0105d53:	6b d0 74             	imul   $0x74,%eax,%edx
f0105d56:	88 82 20 40 53 f0    	mov    %al,-0xfacbfe0(%edx)
				ncpu++;
f0105d5c:	83 c0 01             	add    $0x1,%eax
f0105d5f:	a3 c4 43 53 f0       	mov    %eax,0xf05343c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0105d64:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105d67:	83 c3 01             	add    $0x1,%ebx
f0105d6a:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0105d6e:	39 d8                	cmp    %ebx,%eax
f0105d70:	76 4b                	jbe    f0105dbd <mp_init+0x256>
		switch (*p) {
f0105d72:	0f b6 07             	movzbl (%edi),%eax
f0105d75:	84 c0                	test   %al,%al
f0105d77:	74 b9                	je     f0105d32 <mp_init+0x1cb>
f0105d79:	3c 04                	cmp    $0x4,%al
f0105d7b:	77 1c                	ja     f0105d99 <mp_init+0x232>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105d7d:	83 c7 08             	add    $0x8,%edi
			continue;
f0105d80:	eb e5                	jmp    f0105d67 <mp_init+0x200>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0105d82:	83 ec 08             	sub    $0x8,%esp
f0105d85:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0105d89:	50                   	push   %eax
f0105d8a:	68 88 86 10 f0       	push   $0xf0108688
f0105d8f:	e8 46 dc ff ff       	call   f01039da <cprintf>
f0105d94:	83 c4 10             	add    $0x10,%esp
f0105d97:	eb cb                	jmp    f0105d64 <mp_init+0x1fd>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0105d99:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0105d9c:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0105d9f:	50                   	push   %eax
f0105da0:	68 b0 86 10 f0       	push   $0xf01086b0
f0105da5:	e8 30 dc ff ff       	call   f01039da <cprintf>
			ismp = 0;
f0105daa:	c7 05 00 40 53 f0 00 	movl   $0x0,0xf0534000
f0105db1:	00 00 00 
			i = conf->entry;
f0105db4:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0105db8:	83 c4 10             	add    $0x10,%esp
f0105dbb:	eb aa                	jmp    f0105d67 <mp_init+0x200>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0105dbd:	a1 c0 43 53 f0       	mov    0xf05343c0,%eax
f0105dc2:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105dc9:	83 3d 00 40 53 f0 00 	cmpl   $0x0,0xf0534000
f0105dd0:	74 2b                	je     f0105dfd <mp_init+0x296>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0105dd2:	83 ec 04             	sub    $0x4,%esp
f0105dd5:	ff 35 c4 43 53 f0    	pushl  0xf05343c4
f0105ddb:	0f b6 00             	movzbl (%eax),%eax
f0105dde:	50                   	push   %eax
f0105ddf:	68 57 87 10 f0       	push   $0xf0108757
f0105de4:	e8 f1 db ff ff       	call   f01039da <cprintf>

	if (mp->imcrp) {
f0105de9:	83 c4 10             	add    $0x10,%esp
f0105dec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105def:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0105df3:	75 2e                	jne    f0105e23 <mp_init+0x2bc>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0105df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105df8:	5b                   	pop    %ebx
f0105df9:	5e                   	pop    %esi
f0105dfa:	5f                   	pop    %edi
f0105dfb:	5d                   	pop    %ebp
f0105dfc:	c3                   	ret    
		ncpu = 1;
f0105dfd:	c7 05 c4 43 53 f0 01 	movl   $0x1,0xf05343c4
f0105e04:	00 00 00 
		lapicaddr = 0;
f0105e07:	c7 05 00 50 57 f0 00 	movl   $0x0,0xf0575000
f0105e0e:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0105e11:	83 ec 0c             	sub    $0xc,%esp
f0105e14:	68 d0 86 10 f0       	push   $0xf01086d0
f0105e19:	e8 bc db ff ff       	call   f01039da <cprintf>
		return;
f0105e1e:	83 c4 10             	add    $0x10,%esp
f0105e21:	eb d2                	jmp    f0105df5 <mp_init+0x28e>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0105e23:	83 ec 0c             	sub    $0xc,%esp
f0105e26:	68 fc 86 10 f0       	push   $0xf01086fc
f0105e2b:	e8 aa db ff ff       	call   f01039da <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105e30:	b8 70 00 00 00       	mov    $0x70,%eax
f0105e35:	ba 22 00 00 00       	mov    $0x22,%edx
f0105e3a:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105e3b:	ba 23 00 00 00       	mov    $0x23,%edx
f0105e40:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0105e41:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105e44:	ee                   	out    %al,(%dx)
f0105e45:	83 c4 10             	add    $0x10,%esp
f0105e48:	eb ab                	jmp    f0105df5 <mp_init+0x28e>

f0105e4a <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0105e4a:	8b 0d 04 50 57 f0    	mov    0xf0575004,%ecx
f0105e50:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0105e53:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0105e55:	a1 04 50 57 f0       	mov    0xf0575004,%eax
f0105e5a:	8b 40 20             	mov    0x20(%eax),%eax
}
f0105e5d:	c3                   	ret    

f0105e5e <cpunum>:
}

int
cpunum(void)
{
	if (lapic)
f0105e5e:	8b 15 04 50 57 f0    	mov    0xf0575004,%edx
		return lapic[ID] >> 24;
	return 0;
f0105e64:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f0105e69:	85 d2                	test   %edx,%edx
f0105e6b:	74 06                	je     f0105e73 <cpunum+0x15>
		return lapic[ID] >> 24;
f0105e6d:	8b 42 20             	mov    0x20(%edx),%eax
f0105e70:	c1 e8 18             	shr    $0x18,%eax
}
f0105e73:	c3                   	ret    

f0105e74 <lapic_init>:
	if (!lapicaddr)
f0105e74:	a1 00 50 57 f0       	mov    0xf0575000,%eax
f0105e79:	85 c0                	test   %eax,%eax
f0105e7b:	75 01                	jne    f0105e7e <lapic_init+0xa>
f0105e7d:	c3                   	ret    
{
f0105e7e:	55                   	push   %ebp
f0105e7f:	89 e5                	mov    %esp,%ebp
f0105e81:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0105e84:	68 00 10 00 00       	push   $0x1000
f0105e89:	50                   	push   %eax
f0105e8a:	e8 e5 b4 ff ff       	call   f0101374 <mmio_map_region>
f0105e8f:	a3 04 50 57 f0       	mov    %eax,0xf0575004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0105e94:	ba 27 01 00 00       	mov    $0x127,%edx
f0105e99:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0105e9e:	e8 a7 ff ff ff       	call   f0105e4a <lapicw>
	lapicw(TDCR, X1);
f0105ea3:	ba 0b 00 00 00       	mov    $0xb,%edx
f0105ea8:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0105ead:	e8 98 ff ff ff       	call   f0105e4a <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0105eb2:	ba 20 00 02 00       	mov    $0x20020,%edx
f0105eb7:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0105ebc:	e8 89 ff ff ff       	call   f0105e4a <lapicw>
	lapicw(TICR, 10000000); 
f0105ec1:	ba 80 96 98 00       	mov    $0x989680,%edx
f0105ec6:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0105ecb:	e8 7a ff ff ff       	call   f0105e4a <lapicw>
	if (thiscpu != bootcpu)
f0105ed0:	e8 89 ff ff ff       	call   f0105e5e <cpunum>
f0105ed5:	6b c0 74             	imul   $0x74,%eax,%eax
f0105ed8:	05 20 40 53 f0       	add    $0xf0534020,%eax
f0105edd:	83 c4 10             	add    $0x10,%esp
f0105ee0:	39 05 c0 43 53 f0    	cmp    %eax,0xf05343c0
f0105ee6:	74 0f                	je     f0105ef7 <lapic_init+0x83>
		lapicw(LINT0, MASKED);
f0105ee8:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105eed:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0105ef2:	e8 53 ff ff ff       	call   f0105e4a <lapicw>
	lapicw(LINT1, MASKED);
f0105ef7:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105efc:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0105f01:	e8 44 ff ff ff       	call   f0105e4a <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0105f06:	a1 04 50 57 f0       	mov    0xf0575004,%eax
f0105f0b:	8b 40 30             	mov    0x30(%eax),%eax
f0105f0e:	c1 e8 10             	shr    $0x10,%eax
f0105f11:	a8 fc                	test   $0xfc,%al
f0105f13:	75 7c                	jne    f0105f91 <lapic_init+0x11d>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0105f15:	ba 33 00 00 00       	mov    $0x33,%edx
f0105f1a:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0105f1f:	e8 26 ff ff ff       	call   f0105e4a <lapicw>
	lapicw(ESR, 0);
f0105f24:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f29:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105f2e:	e8 17 ff ff ff       	call   f0105e4a <lapicw>
	lapicw(ESR, 0);
f0105f33:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f38:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105f3d:	e8 08 ff ff ff       	call   f0105e4a <lapicw>
	lapicw(EOI, 0);
f0105f42:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f47:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105f4c:	e8 f9 fe ff ff       	call   f0105e4a <lapicw>
	lapicw(ICRHI, 0);
f0105f51:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f56:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105f5b:	e8 ea fe ff ff       	call   f0105e4a <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0105f60:	ba 00 85 08 00       	mov    $0x88500,%edx
f0105f65:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105f6a:	e8 db fe ff ff       	call   f0105e4a <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0105f6f:	8b 15 04 50 57 f0    	mov    0xf0575004,%edx
f0105f75:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105f7b:	f6 c4 10             	test   $0x10,%ah
f0105f7e:	75 f5                	jne    f0105f75 <lapic_init+0x101>
	lapicw(TPR, 0);
f0105f80:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f85:	b8 20 00 00 00       	mov    $0x20,%eax
f0105f8a:	e8 bb fe ff ff       	call   f0105e4a <lapicw>
}
f0105f8f:	c9                   	leave  
f0105f90:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0105f91:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105f96:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0105f9b:	e8 aa fe ff ff       	call   f0105e4a <lapicw>
f0105fa0:	e9 70 ff ff ff       	jmp    f0105f15 <lapic_init+0xa1>

f0105fa5 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0105fa5:	83 3d 04 50 57 f0 00 	cmpl   $0x0,0xf0575004
f0105fac:	74 17                	je     f0105fc5 <lapic_eoi+0x20>
{
f0105fae:	55                   	push   %ebp
f0105faf:	89 e5                	mov    %esp,%ebp
f0105fb1:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0105fb4:	ba 00 00 00 00       	mov    $0x0,%edx
f0105fb9:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105fbe:	e8 87 fe ff ff       	call   f0105e4a <lapicw>
}
f0105fc3:	c9                   	leave  
f0105fc4:	c3                   	ret    
f0105fc5:	c3                   	ret    

f0105fc6 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0105fc6:	55                   	push   %ebp
f0105fc7:	89 e5                	mov    %esp,%ebp
f0105fc9:	56                   	push   %esi
f0105fca:	53                   	push   %ebx
f0105fcb:	8b 75 08             	mov    0x8(%ebp),%esi
f0105fce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105fd1:	b8 0f 00 00 00       	mov    $0xf,%eax
f0105fd6:	ba 70 00 00 00       	mov    $0x70,%edx
f0105fdb:	ee                   	out    %al,(%dx)
f0105fdc:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105fe1:	ba 71 00 00 00       	mov    $0x71,%edx
f0105fe6:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0105fe7:	83 3d a0 3e 53 f0 00 	cmpl   $0x0,0xf0533ea0
f0105fee:	74 7e                	je     f010606e <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0105ff0:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0105ff7:	00 00 
	wrv[1] = addr >> 4;
f0105ff9:	89 d8                	mov    %ebx,%eax
f0105ffb:	c1 e8 04             	shr    $0x4,%eax
f0105ffe:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106004:	c1 e6 18             	shl    $0x18,%esi
f0106007:	89 f2                	mov    %esi,%edx
f0106009:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010600e:	e8 37 fe ff ff       	call   f0105e4a <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106013:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106018:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010601d:	e8 28 fe ff ff       	call   f0105e4a <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106022:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106027:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010602c:	e8 19 fe ff ff       	call   f0105e4a <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106031:	c1 eb 0c             	shr    $0xc,%ebx
f0106034:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0106037:	89 f2                	mov    %esi,%edx
f0106039:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010603e:	e8 07 fe ff ff       	call   f0105e4a <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106043:	89 da                	mov    %ebx,%edx
f0106045:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010604a:	e8 fb fd ff ff       	call   f0105e4a <lapicw>
		lapicw(ICRHI, apicid << 24);
f010604f:	89 f2                	mov    %esi,%edx
f0106051:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106056:	e8 ef fd ff ff       	call   f0105e4a <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f010605b:	89 da                	mov    %ebx,%edx
f010605d:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106062:	e8 e3 fd ff ff       	call   f0105e4a <lapicw>
		microdelay(200);
	}
}
f0106067:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010606a:	5b                   	pop    %ebx
f010606b:	5e                   	pop    %esi
f010606c:	5d                   	pop    %ebp
f010606d:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010606e:	68 67 04 00 00       	push   $0x467
f0106073:	68 44 6a 10 f0       	push   $0xf0106a44
f0106078:	68 98 00 00 00       	push   $0x98
f010607d:	68 74 87 10 f0       	push   $0xf0108774
f0106082:	e8 b9 9f ff ff       	call   f0100040 <_panic>

f0106087 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106087:	55                   	push   %ebp
f0106088:	89 e5                	mov    %esp,%ebp
f010608a:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f010608d:	8b 55 08             	mov    0x8(%ebp),%edx
f0106090:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106096:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010609b:	e8 aa fd ff ff       	call   f0105e4a <lapicw>
	while (lapic[ICRLO] & DELIVS)
f01060a0:	8b 15 04 50 57 f0    	mov    0xf0575004,%edx
f01060a6:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f01060ac:	f6 c4 10             	test   $0x10,%ah
f01060af:	75 f5                	jne    f01060a6 <lapic_ipi+0x1f>
		;
}
f01060b1:	c9                   	leave  
f01060b2:	c3                   	ret    

f01060b3 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f01060b3:	55                   	push   %ebp
f01060b4:	89 e5                	mov    %esp,%ebp
f01060b6:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f01060b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f01060bf:	8b 55 0c             	mov    0xc(%ebp),%edx
f01060c2:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f01060c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f01060cc:	5d                   	pop    %ebp
f01060cd:	c3                   	ret    

f01060ce <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f01060ce:	55                   	push   %ebp
f01060cf:	89 e5                	mov    %esp,%ebp
f01060d1:	56                   	push   %esi
f01060d2:	53                   	push   %ebx
f01060d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f01060d6:	83 3b 00             	cmpl   $0x0,(%ebx)
f01060d9:	75 12                	jne    f01060ed <spin_lock+0x1f>
	asm volatile("lock; xchgl %0, %1"
f01060db:	ba 01 00 00 00       	mov    $0x1,%edx
f01060e0:	89 d0                	mov    %edx,%eax
f01060e2:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f01060e5:	85 c0                	test   %eax,%eax
f01060e7:	74 36                	je     f010611f <spin_lock+0x51>
		asm volatile ("pause");
f01060e9:	f3 90                	pause  
f01060eb:	eb f3                	jmp    f01060e0 <spin_lock+0x12>
	return lock->locked && lock->cpu == thiscpu;
f01060ed:	8b 73 08             	mov    0x8(%ebx),%esi
f01060f0:	e8 69 fd ff ff       	call   f0105e5e <cpunum>
f01060f5:	6b c0 74             	imul   $0x74,%eax,%eax
f01060f8:	05 20 40 53 f0       	add    $0xf0534020,%eax
	if (holding(lk))
f01060fd:	39 c6                	cmp    %eax,%esi
f01060ff:	75 da                	jne    f01060db <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106101:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106104:	e8 55 fd ff ff       	call   f0105e5e <cpunum>
f0106109:	83 ec 0c             	sub    $0xc,%esp
f010610c:	53                   	push   %ebx
f010610d:	50                   	push   %eax
f010610e:	68 84 87 10 f0       	push   $0xf0108784
f0106113:	6a 41                	push   $0x41
f0106115:	68 e6 87 10 f0       	push   $0xf01087e6
f010611a:	e8 21 9f ff ff       	call   f0100040 <_panic>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f010611f:	e8 3a fd ff ff       	call   f0105e5e <cpunum>
f0106124:	6b c0 74             	imul   $0x74,%eax,%eax
f0106127:	05 20 40 53 f0       	add    $0xf0534020,%eax
f010612c:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f010612f:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0106131:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106136:	83 f8 09             	cmp    $0x9,%eax
f0106139:	7f 16                	jg     f0106151 <spin_lock+0x83>
f010613b:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0106141:	76 0e                	jbe    f0106151 <spin_lock+0x83>
		pcs[i] = ebp[1];          // saved %eip
f0106143:	8b 4a 04             	mov    0x4(%edx),%ecx
f0106146:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f010614a:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f010614c:	83 c0 01             	add    $0x1,%eax
f010614f:	eb e5                	jmp    f0106136 <spin_lock+0x68>
	for (; i < 10; i++)
f0106151:	83 f8 09             	cmp    $0x9,%eax
f0106154:	7f 0d                	jg     f0106163 <spin_lock+0x95>
		pcs[i] = 0;
f0106156:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f010615d:	00 
	for (; i < 10; i++)
f010615e:	83 c0 01             	add    $0x1,%eax
f0106161:	eb ee                	jmp    f0106151 <spin_lock+0x83>
	get_caller_pcs(lk->pcs);
#endif
}
f0106163:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106166:	5b                   	pop    %ebx
f0106167:	5e                   	pop    %esi
f0106168:	5d                   	pop    %ebp
f0106169:	c3                   	ret    

f010616a <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f010616a:	55                   	push   %ebp
f010616b:	89 e5                	mov    %esp,%ebp
f010616d:	57                   	push   %edi
f010616e:	56                   	push   %esi
f010616f:	53                   	push   %ebx
f0106170:	83 ec 4c             	sub    $0x4c,%esp
f0106173:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106176:	83 3e 00             	cmpl   $0x0,(%esi)
f0106179:	75 35                	jne    f01061b0 <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f010617b:	83 ec 04             	sub    $0x4,%esp
f010617e:	6a 28                	push   $0x28
f0106180:	8d 46 0c             	lea    0xc(%esi),%eax
f0106183:	50                   	push   %eax
f0106184:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106187:	53                   	push   %ebx
f0106188:	e8 1a f7 ff ff       	call   f01058a7 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f010618d:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106190:	0f b6 38             	movzbl (%eax),%edi
f0106193:	8b 76 04             	mov    0x4(%esi),%esi
f0106196:	e8 c3 fc ff ff       	call   f0105e5e <cpunum>
f010619b:	57                   	push   %edi
f010619c:	56                   	push   %esi
f010619d:	50                   	push   %eax
f010619e:	68 b0 87 10 f0       	push   $0xf01087b0
f01061a3:	e8 32 d8 ff ff       	call   f01039da <cprintf>
f01061a8:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01061ab:	8d 7d a8             	lea    -0x58(%ebp),%edi
f01061ae:	eb 4e                	jmp    f01061fe <spin_unlock+0x94>
	return lock->locked && lock->cpu == thiscpu;
f01061b0:	8b 5e 08             	mov    0x8(%esi),%ebx
f01061b3:	e8 a6 fc ff ff       	call   f0105e5e <cpunum>
f01061b8:	6b c0 74             	imul   $0x74,%eax,%eax
f01061bb:	05 20 40 53 f0       	add    $0xf0534020,%eax
	if (!holding(lk)) {
f01061c0:	39 c3                	cmp    %eax,%ebx
f01061c2:	75 b7                	jne    f010617b <spin_unlock+0x11>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f01061c4:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f01061cb:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f01061d2:	b8 00 00 00 00       	mov    $0x0,%eax
f01061d7:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f01061da:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01061dd:	5b                   	pop    %ebx
f01061de:	5e                   	pop    %esi
f01061df:	5f                   	pop    %edi
f01061e0:	5d                   	pop    %ebp
f01061e1:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f01061e2:	83 ec 08             	sub    $0x8,%esp
f01061e5:	ff 36                	pushl  (%esi)
f01061e7:	68 0d 88 10 f0       	push   $0xf010880d
f01061ec:	e8 e9 d7 ff ff       	call   f01039da <cprintf>
f01061f1:	83 c4 10             	add    $0x10,%esp
f01061f4:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f01061f7:	8d 45 e8             	lea    -0x18(%ebp),%eax
f01061fa:	39 c3                	cmp    %eax,%ebx
f01061fc:	74 40                	je     f010623e <spin_unlock+0xd4>
f01061fe:	89 de                	mov    %ebx,%esi
f0106200:	8b 03                	mov    (%ebx),%eax
f0106202:	85 c0                	test   %eax,%eax
f0106204:	74 38                	je     f010623e <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106206:	83 ec 08             	sub    $0x8,%esp
f0106209:	57                   	push   %edi
f010620a:	50                   	push   %eax
f010620b:	e8 63 eb ff ff       	call   f0104d73 <debuginfo_eip>
f0106210:	83 c4 10             	add    $0x10,%esp
f0106213:	85 c0                	test   %eax,%eax
f0106215:	78 cb                	js     f01061e2 <spin_unlock+0x78>
					pcs[i] - info.eip_fn_addr);
f0106217:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106219:	83 ec 04             	sub    $0x4,%esp
f010621c:	89 c2                	mov    %eax,%edx
f010621e:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106221:	52                   	push   %edx
f0106222:	ff 75 b0             	pushl  -0x50(%ebp)
f0106225:	ff 75 b4             	pushl  -0x4c(%ebp)
f0106228:	ff 75 ac             	pushl  -0x54(%ebp)
f010622b:	ff 75 a8             	pushl  -0x58(%ebp)
f010622e:	50                   	push   %eax
f010622f:	68 f6 87 10 f0       	push   $0xf01087f6
f0106234:	e8 a1 d7 ff ff       	call   f01039da <cprintf>
f0106239:	83 c4 20             	add    $0x20,%esp
f010623c:	eb b6                	jmp    f01061f4 <spin_unlock+0x8a>
		panic("spin_unlock");
f010623e:	83 ec 04             	sub    $0x4,%esp
f0106241:	68 15 88 10 f0       	push   $0xf0108815
f0106246:	6a 67                	push   $0x67
f0106248:	68 e6 87 10 f0       	push   $0xf01087e6
f010624d:	e8 ee 9d ff ff       	call   f0100040 <_panic>

f0106252 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0106252:	55                   	push   %ebp
f0106253:	89 e5                	mov    %esp,%ebp
f0106255:	57                   	push   %edi
f0106256:	56                   	push   %esi
f0106257:	53                   	push   %ebx
f0106258:	83 ec 0c             	sub    $0xc,%esp
f010625b:	8b 7d 08             	mov    0x8(%ebp),%edi
f010625e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0106261:	eb 03                	jmp    f0106266 <pci_attach_match+0x14>
f0106263:	83 c3 0c             	add    $0xc,%ebx
f0106266:	89 de                	mov    %ebx,%esi
f0106268:	8b 43 08             	mov    0x8(%ebx),%eax
f010626b:	85 c0                	test   %eax,%eax
f010626d:	74 37                	je     f01062a6 <pci_attach_match+0x54>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f010626f:	39 3b                	cmp    %edi,(%ebx)
f0106271:	75 f0                	jne    f0106263 <pci_attach_match+0x11>
f0106273:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106276:	39 56 04             	cmp    %edx,0x4(%esi)
f0106279:	75 e8                	jne    f0106263 <pci_attach_match+0x11>
			int r = list[i].attachfn(pcif);
f010627b:	83 ec 0c             	sub    $0xc,%esp
f010627e:	ff 75 14             	pushl  0x14(%ebp)
f0106281:	ff d0                	call   *%eax
			if (r > 0)
f0106283:	83 c4 10             	add    $0x10,%esp
f0106286:	85 c0                	test   %eax,%eax
f0106288:	7f 1c                	jg     f01062a6 <pci_attach_match+0x54>
				return r;
			if (r < 0)
f010628a:	79 d7                	jns    f0106263 <pci_attach_match+0x11>
				cprintf("pci_attach_match: attaching "
f010628c:	83 ec 0c             	sub    $0xc,%esp
f010628f:	50                   	push   %eax
f0106290:	ff 76 08             	pushl  0x8(%esi)
f0106293:	ff 75 0c             	pushl  0xc(%ebp)
f0106296:	57                   	push   %edi
f0106297:	68 30 88 10 f0       	push   $0xf0108830
f010629c:	e8 39 d7 ff ff       	call   f01039da <cprintf>
f01062a1:	83 c4 20             	add    $0x20,%esp
f01062a4:	eb bd                	jmp    f0106263 <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f01062a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01062a9:	5b                   	pop    %ebx
f01062aa:	5e                   	pop    %esi
f01062ab:	5f                   	pop    %edi
f01062ac:	5d                   	pop    %ebp
f01062ad:	c3                   	ret    

f01062ae <pci_conf1_set_addr>:
{
f01062ae:	55                   	push   %ebp
f01062af:	89 e5                	mov    %esp,%ebp
f01062b1:	53                   	push   %ebx
f01062b2:	83 ec 04             	sub    $0x4,%esp
f01062b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f01062b8:	3d ff 00 00 00       	cmp    $0xff,%eax
f01062bd:	77 36                	ja     f01062f5 <pci_conf1_set_addr+0x47>
	assert(dev < 32);
f01062bf:	83 fa 1f             	cmp    $0x1f,%edx
f01062c2:	77 47                	ja     f010630b <pci_conf1_set_addr+0x5d>
	assert(func < 8);
f01062c4:	83 f9 07             	cmp    $0x7,%ecx
f01062c7:	77 58                	ja     f0106321 <pci_conf1_set_addr+0x73>
	assert(offset < 256);
f01062c9:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f01062cf:	77 66                	ja     f0106337 <pci_conf1_set_addr+0x89>
	assert((offset & 0x3) == 0);
f01062d1:	f6 c3 03             	test   $0x3,%bl
f01062d4:	75 77                	jne    f010634d <pci_conf1_set_addr+0x9f>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f01062d6:	c1 e0 10             	shl    $0x10,%eax
f01062d9:	09 d8                	or     %ebx,%eax
f01062db:	c1 e1 08             	shl    $0x8,%ecx
f01062de:	09 c8                	or     %ecx,%eax
f01062e0:	c1 e2 0b             	shl    $0xb,%edx
f01062e3:	09 d0                	or     %edx,%eax
	uint32_t v = (1 << 31) |		// config-space
f01062e5:	0d 00 00 00 80       	or     $0x80000000,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f01062ea:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f01062ef:	ef                   	out    %eax,(%dx)
}
f01062f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01062f3:	c9                   	leave  
f01062f4:	c3                   	ret    
	assert(bus < 256);
f01062f5:	68 88 89 10 f0       	push   $0xf0108988
f01062fa:	68 ae 79 10 f0       	push   $0xf01079ae
f01062ff:	6a 2b                	push   $0x2b
f0106301:	68 92 89 10 f0       	push   $0xf0108992
f0106306:	e8 35 9d ff ff       	call   f0100040 <_panic>
	assert(dev < 32);
f010630b:	68 9d 89 10 f0       	push   $0xf010899d
f0106310:	68 ae 79 10 f0       	push   $0xf01079ae
f0106315:	6a 2c                	push   $0x2c
f0106317:	68 92 89 10 f0       	push   $0xf0108992
f010631c:	e8 1f 9d ff ff       	call   f0100040 <_panic>
	assert(func < 8);
f0106321:	68 a6 89 10 f0       	push   $0xf01089a6
f0106326:	68 ae 79 10 f0       	push   $0xf01079ae
f010632b:	6a 2d                	push   $0x2d
f010632d:	68 92 89 10 f0       	push   $0xf0108992
f0106332:	e8 09 9d ff ff       	call   f0100040 <_panic>
	assert(offset < 256);
f0106337:	68 af 89 10 f0       	push   $0xf01089af
f010633c:	68 ae 79 10 f0       	push   $0xf01079ae
f0106341:	6a 2e                	push   $0x2e
f0106343:	68 92 89 10 f0       	push   $0xf0108992
f0106348:	e8 f3 9c ff ff       	call   f0100040 <_panic>
	assert((offset & 0x3) == 0);
f010634d:	68 bc 89 10 f0       	push   $0xf01089bc
f0106352:	68 ae 79 10 f0       	push   $0xf01079ae
f0106357:	6a 2f                	push   $0x2f
f0106359:	68 92 89 10 f0       	push   $0xf0108992
f010635e:	e8 dd 9c ff ff       	call   f0100040 <_panic>

f0106363 <pci_conf_read>:
{
f0106363:	55                   	push   %ebp
f0106364:	89 e5                	mov    %esp,%ebp
f0106366:	53                   	push   %ebx
f0106367:	83 ec 10             	sub    $0x10,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f010636a:	8b 48 08             	mov    0x8(%eax),%ecx
f010636d:	8b 58 04             	mov    0x4(%eax),%ebx
f0106370:	8b 00                	mov    (%eax),%eax
f0106372:	8b 40 04             	mov    0x4(%eax),%eax
f0106375:	52                   	push   %edx
f0106376:	89 da                	mov    %ebx,%edx
f0106378:	e8 31 ff ff ff       	call   f01062ae <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f010637d:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0106382:	ed                   	in     (%dx),%eax
}
f0106383:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106386:	c9                   	leave  
f0106387:	c3                   	ret    

f0106388 <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f0106388:	55                   	push   %ebp
f0106389:	89 e5                	mov    %esp,%ebp
f010638b:	57                   	push   %edi
f010638c:	56                   	push   %esi
f010638d:	53                   	push   %ebx
f010638e:	81 ec 00 01 00 00    	sub    $0x100,%esp
f0106394:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0106396:	6a 48                	push   $0x48
f0106398:	6a 00                	push   $0x0
f010639a:	8d 45 a0             	lea    -0x60(%ebp),%eax
f010639d:	50                   	push   %eax
f010639e:	e8 bc f4 ff ff       	call   f010585f <memset>
	df.bus = bus;
f01063a3:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f01063a6:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f01063ad:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
f01063b0:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f01063b7:	00 00 00 
f01063ba:	e9 25 01 00 00       	jmp    f01064e4 <pci_scan_bus+0x15c>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f01063bf:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f01063c5:	83 ec 08             	sub    $0x8,%esp
f01063c8:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f01063cc:	57                   	push   %edi
f01063cd:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f01063ce:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f01063d1:	0f b6 c0             	movzbl %al,%eax
f01063d4:	50                   	push   %eax
f01063d5:	51                   	push   %ecx
f01063d6:	89 d0                	mov    %edx,%eax
f01063d8:	c1 e8 10             	shr    $0x10,%eax
f01063db:	50                   	push   %eax
f01063dc:	0f b7 d2             	movzwl %dx,%edx
f01063df:	52                   	push   %edx
f01063e0:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f01063e6:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f01063ec:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f01063f2:	ff 70 04             	pushl  0x4(%eax)
f01063f5:	68 5c 88 10 f0       	push   $0xf010885c
f01063fa:	e8 db d5 ff ff       	call   f01039da <cprintf>
				 PCI_SUBCLASS(f->dev_class),
f01063ff:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
f0106405:	83 c4 30             	add    $0x30,%esp
f0106408:	53                   	push   %ebx
f0106409:	68 f4 53 12 f0       	push   $0xf01253f4
				 PCI_SUBCLASS(f->dev_class),
f010640e:	89 c2                	mov    %eax,%edx
f0106410:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
f0106413:	0f b6 d2             	movzbl %dl,%edx
f0106416:	52                   	push   %edx
f0106417:	c1 e8 18             	shr    $0x18,%eax
f010641a:	50                   	push   %eax
f010641b:	e8 32 fe ff ff       	call   f0106252 <pci_attach_match>
				 &pci_attach_class[0], f) ||
f0106420:	83 c4 10             	add    $0x10,%esp
f0106423:	85 c0                	test   %eax,%eax
f0106425:	0f 84 88 00 00 00    	je     f01064b3 <pci_scan_bus+0x12b>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f010642b:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0106432:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f0106438:	39 85 18 ff ff ff    	cmp    %eax,-0xe8(%ebp)
f010643e:	0f 83 92 00 00 00    	jae    f01064d6 <pci_scan_bus+0x14e>
			struct pci_func af = f;
f0106444:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f010644a:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f0106450:	b9 12 00 00 00       	mov    $0x12,%ecx
f0106455:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f0106457:	ba 00 00 00 00       	mov    $0x0,%edx
f010645c:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0106462:	e8 fc fe ff ff       	call   f0106363 <pci_conf_read>
f0106467:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f010646d:	66 83 f8 ff          	cmp    $0xffff,%ax
f0106471:	74 b8                	je     f010642b <pci_scan_bus+0xa3>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0106473:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0106478:	89 d8                	mov    %ebx,%eax
f010647a:	e8 e4 fe ff ff       	call   f0106363 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f010647f:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0106482:	ba 08 00 00 00       	mov    $0x8,%edx
f0106487:	89 d8                	mov    %ebx,%eax
f0106489:	e8 d5 fe ff ff       	call   f0106363 <pci_conf_read>
f010648e:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0106494:	89 c1                	mov    %eax,%ecx
f0106496:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
f0106499:	be d0 89 10 f0       	mov    $0xf01089d0,%esi
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f010649e:	83 f9 06             	cmp    $0x6,%ecx
f01064a1:	0f 87 18 ff ff ff    	ja     f01063bf <pci_scan_bus+0x37>
		class = pci_class[PCI_CLASS(f->dev_class)];
f01064a7:	8b 34 8d 44 8a 10 f0 	mov    -0xfef75bc(,%ecx,4),%esi
f01064ae:	e9 0c ff ff ff       	jmp    f01063bf <pci_scan_bus+0x37>
				 PCI_PRODUCT(f->dev_id),
f01064b3:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f01064b9:	53                   	push   %ebx
f01064ba:	68 80 3e 53 f0       	push   $0xf0533e80
f01064bf:	89 c2                	mov    %eax,%edx
f01064c1:	c1 ea 10             	shr    $0x10,%edx
f01064c4:	52                   	push   %edx
f01064c5:	0f b7 c0             	movzwl %ax,%eax
f01064c8:	50                   	push   %eax
f01064c9:	e8 84 fd ff ff       	call   f0106252 <pci_attach_match>
f01064ce:	83 c4 10             	add    $0x10,%esp
f01064d1:	e9 55 ff ff ff       	jmp    f010642b <pci_scan_bus+0xa3>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f01064d6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f01064d9:	83 c0 01             	add    $0x1,%eax
f01064dc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f01064df:	83 f8 1f             	cmp    $0x1f,%eax
f01064e2:	77 59                	ja     f010653d <pci_scan_bus+0x1b5>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f01064e4:	ba 0c 00 00 00       	mov    $0xc,%edx
f01064e9:	8d 45 a0             	lea    -0x60(%ebp),%eax
f01064ec:	e8 72 fe ff ff       	call   f0106363 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f01064f1:	89 c2                	mov    %eax,%edx
f01064f3:	c1 ea 10             	shr    $0x10,%edx
f01064f6:	f6 c2 7e             	test   $0x7e,%dl
f01064f9:	75 db                	jne    f01064d6 <pci_scan_bus+0x14e>
		totaldev++;
f01064fb:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)
		struct pci_func f = df;
f0106502:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f0106508:	8d 75 a0             	lea    -0x60(%ebp),%esi
f010650b:	b9 12 00 00 00       	mov    $0x12,%ecx
f0106510:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0106512:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f0106519:	00 00 00 
f010651c:	25 00 00 80 00       	and    $0x800000,%eax
f0106521:	83 f8 01             	cmp    $0x1,%eax
f0106524:	19 c0                	sbb    %eax,%eax
f0106526:	83 e0 f9             	and    $0xfffffff9,%eax
f0106529:	83 c0 08             	add    $0x8,%eax
f010652c:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0106532:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0106538:	e9 f5 fe ff ff       	jmp    f0106432 <pci_scan_bus+0xaa>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f010653d:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0106543:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106546:	5b                   	pop    %ebx
f0106547:	5e                   	pop    %esi
f0106548:	5f                   	pop    %edi
f0106549:	5d                   	pop    %ebp
f010654a:	c3                   	ret    

f010654b <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f010654b:	55                   	push   %ebp
f010654c:	89 e5                	mov    %esp,%ebp
f010654e:	57                   	push   %edi
f010654f:	56                   	push   %esi
f0106550:	53                   	push   %ebx
f0106551:	83 ec 1c             	sub    $0x1c,%esp
f0106554:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f0106557:	ba 1c 00 00 00       	mov    $0x1c,%edx
f010655c:	89 d8                	mov    %ebx,%eax
f010655e:	e8 00 fe ff ff       	call   f0106363 <pci_conf_read>
f0106563:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0106565:	ba 18 00 00 00       	mov    $0x18,%edx
f010656a:	89 d8                	mov    %ebx,%eax
f010656c:	e8 f2 fd ff ff       	call   f0106363 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0106571:	83 e7 0f             	and    $0xf,%edi
f0106574:	83 ff 01             	cmp    $0x1,%edi
f0106577:	74 56                	je     f01065cf <pci_bridge_attach+0x84>
f0106579:	89 c6                	mov    %eax,%esi
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f010657b:	83 ec 04             	sub    $0x4,%esp
f010657e:	6a 08                	push   $0x8
f0106580:	6a 00                	push   $0x0
f0106582:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0106585:	57                   	push   %edi
f0106586:	e8 d4 f2 ff ff       	call   f010585f <memset>
	nbus.parent_bridge = pcif;
f010658b:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f010658e:	89 f0                	mov    %esi,%eax
f0106590:	0f b6 c4             	movzbl %ah,%eax
f0106593:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0106596:	83 c4 08             	add    $0x8,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f0106599:	c1 ee 10             	shr    $0x10,%esi
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f010659c:	89 f1                	mov    %esi,%ecx
f010659e:	0f b6 f1             	movzbl %cl,%esi
f01065a1:	56                   	push   %esi
f01065a2:	50                   	push   %eax
f01065a3:	ff 73 08             	pushl  0x8(%ebx)
f01065a6:	ff 73 04             	pushl  0x4(%ebx)
f01065a9:	8b 03                	mov    (%ebx),%eax
f01065ab:	ff 70 04             	pushl  0x4(%eax)
f01065ae:	68 cc 88 10 f0       	push   $0xf01088cc
f01065b3:	e8 22 d4 ff ff       	call   f01039da <cprintf>

	pci_scan_bus(&nbus);
f01065b8:	83 c4 20             	add    $0x20,%esp
f01065bb:	89 f8                	mov    %edi,%eax
f01065bd:	e8 c6 fd ff ff       	call   f0106388 <pci_scan_bus>
	return 1;
f01065c2:	b8 01 00 00 00       	mov    $0x1,%eax
}
f01065c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01065ca:	5b                   	pop    %ebx
f01065cb:	5e                   	pop    %esi
f01065cc:	5f                   	pop    %edi
f01065cd:	5d                   	pop    %ebp
f01065ce:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f01065cf:	ff 73 08             	pushl  0x8(%ebx)
f01065d2:	ff 73 04             	pushl  0x4(%ebx)
f01065d5:	8b 03                	mov    (%ebx),%eax
f01065d7:	ff 70 04             	pushl  0x4(%eax)
f01065da:	68 98 88 10 f0       	push   $0xf0108898
f01065df:	e8 f6 d3 ff ff       	call   f01039da <cprintf>
		return 0;
f01065e4:	83 c4 10             	add    $0x10,%esp
f01065e7:	b8 00 00 00 00       	mov    $0x0,%eax
f01065ec:	eb d9                	jmp    f01065c7 <pci_bridge_attach+0x7c>

f01065ee <pci_conf_write>:
{
f01065ee:	55                   	push   %ebp
f01065ef:	89 e5                	mov    %esp,%ebp
f01065f1:	56                   	push   %esi
f01065f2:	53                   	push   %ebx
f01065f3:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f01065f5:	8b 48 08             	mov    0x8(%eax),%ecx
f01065f8:	8b 70 04             	mov    0x4(%eax),%esi
f01065fb:	8b 00                	mov    (%eax),%eax
f01065fd:	8b 40 04             	mov    0x4(%eax),%eax
f0106600:	83 ec 0c             	sub    $0xc,%esp
f0106603:	52                   	push   %edx
f0106604:	89 f2                	mov    %esi,%edx
f0106606:	e8 a3 fc ff ff       	call   f01062ae <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f010660b:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0106610:	89 d8                	mov    %ebx,%eax
f0106612:	ef                   	out    %eax,(%dx)
}
f0106613:	83 c4 10             	add    $0x10,%esp
f0106616:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106619:	5b                   	pop    %ebx
f010661a:	5e                   	pop    %esi
f010661b:	5d                   	pop    %ebp
f010661c:	c3                   	ret    

f010661d <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f010661d:	55                   	push   %ebp
f010661e:	89 e5                	mov    %esp,%ebp
f0106620:	57                   	push   %edi
f0106621:	56                   	push   %esi
f0106622:	53                   	push   %ebx
f0106623:	83 ec 2c             	sub    $0x2c,%esp
f0106626:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f0106629:	b9 07 00 00 00       	mov    $0x7,%ecx
f010662e:	ba 04 00 00 00       	mov    $0x4,%edx
f0106633:	89 f8                	mov    %edi,%eax
f0106635:	e8 b4 ff ff ff       	call   f01065ee <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f010663a:	be 10 00 00 00       	mov    $0x10,%esi
f010663f:	eb 27                	jmp    f0106668 <pci_func_enable+0x4b>
			base = PCI_MAPREG_MEM_ADDR(oldv);
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0106641:	89 c3                	mov    %eax,%ebx
f0106643:	83 e3 fc             	and    $0xfffffffc,%ebx
f0106646:	f7 db                	neg    %ebx
f0106648:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f010664a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010664d:	83 e0 fc             	and    $0xfffffffc,%eax
f0106650:	89 45 d8             	mov    %eax,-0x28(%ebp)
		bar_width = 4;
f0106653:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f010665a:	eb 74                	jmp    f01066d0 <pci_func_enable+0xb3>
	     bar += bar_width)
f010665c:	03 75 e4             	add    -0x1c(%ebp),%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f010665f:	83 fe 27             	cmp    $0x27,%esi
f0106662:	0f 87 c5 00 00 00    	ja     f010672d <pci_func_enable+0x110>
		uint32_t oldv = pci_conf_read(f, bar);
f0106668:	89 f2                	mov    %esi,%edx
f010666a:	89 f8                	mov    %edi,%eax
f010666c:	e8 f2 fc ff ff       	call   f0106363 <pci_conf_read>
f0106671:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f0106674:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0106679:	89 f2                	mov    %esi,%edx
f010667b:	89 f8                	mov    %edi,%eax
f010667d:	e8 6c ff ff ff       	call   f01065ee <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0106682:	89 f2                	mov    %esi,%edx
f0106684:	89 f8                	mov    %edi,%eax
f0106686:	e8 d8 fc ff ff       	call   f0106363 <pci_conf_read>
		bar_width = 4;
f010668b:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		if (rv == 0)
f0106692:	85 c0                	test   %eax,%eax
f0106694:	74 c6                	je     f010665c <pci_func_enable+0x3f>
		int regnum = PCI_MAPREG_NUM(bar);
f0106696:	8d 4e f0             	lea    -0x10(%esi),%ecx
f0106699:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010669c:	c1 e9 02             	shr    $0x2,%ecx
f010669f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f01066a2:	a8 01                	test   $0x1,%al
f01066a4:	75 9b                	jne    f0106641 <pci_func_enable+0x24>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f01066a6:	89 c2                	mov    %eax,%edx
f01066a8:	83 e2 06             	and    $0x6,%edx
				bar_width = 8;
f01066ab:	83 fa 04             	cmp    $0x4,%edx
f01066ae:	0f 94 c1             	sete   %cl
f01066b1:	0f b6 c9             	movzbl %cl,%ecx
f01066b4:	8d 1c 8d 04 00 00 00 	lea    0x4(,%ecx,4),%ebx
f01066bb:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f01066be:	89 c3                	mov    %eax,%ebx
f01066c0:	83 e3 f0             	and    $0xfffffff0,%ebx
f01066c3:	f7 db                	neg    %ebx
f01066c5:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f01066c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01066ca:	83 e0 f0             	and    $0xfffffff0,%eax
f01066cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f01066d0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01066d3:	89 f2                	mov    %esi,%edx
f01066d5:	89 f8                	mov    %edi,%eax
f01066d7:	e8 12 ff ff ff       	call   f01065ee <pci_conf_write>
f01066dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01066df:	01 f8                	add    %edi,%eax
		f->reg_base[regnum] = base;
f01066e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01066e4:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
f01066e7:	89 58 2c             	mov    %ebx,0x2c(%eax)

		if (size && !base)
f01066ea:	85 db                	test   %ebx,%ebx
f01066ec:	0f 84 6a ff ff ff    	je     f010665c <pci_func_enable+0x3f>
f01066f2:	85 d2                	test   %edx,%edx
f01066f4:	0f 85 62 ff ff ff    	jne    f010665c <pci_func_enable+0x3f>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f01066fa:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f01066fd:	83 ec 0c             	sub    $0xc,%esp
f0106700:	53                   	push   %ebx
f0106701:	6a 00                	push   $0x0
f0106703:	ff 75 d4             	pushl  -0x2c(%ebp)
f0106706:	89 c2                	mov    %eax,%edx
f0106708:	c1 ea 10             	shr    $0x10,%edx
f010670b:	52                   	push   %edx
f010670c:	0f b7 c0             	movzwl %ax,%eax
f010670f:	50                   	push   %eax
f0106710:	ff 77 08             	pushl  0x8(%edi)
f0106713:	ff 77 04             	pushl  0x4(%edi)
f0106716:	8b 07                	mov    (%edi),%eax
f0106718:	ff 70 04             	pushl  0x4(%eax)
f010671b:	68 fc 88 10 f0       	push   $0xf01088fc
f0106720:	e8 b5 d2 ff ff       	call   f01039da <cprintf>
f0106725:	83 c4 30             	add    $0x30,%esp
f0106728:	e9 2f ff ff ff       	jmp    f010665c <pci_func_enable+0x3f>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f010672d:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f0106730:	83 ec 08             	sub    $0x8,%esp
f0106733:	89 c2                	mov    %eax,%edx
f0106735:	c1 ea 10             	shr    $0x10,%edx
f0106738:	52                   	push   %edx
f0106739:	0f b7 c0             	movzwl %ax,%eax
f010673c:	50                   	push   %eax
f010673d:	ff 77 08             	pushl  0x8(%edi)
f0106740:	ff 77 04             	pushl  0x4(%edi)
f0106743:	8b 07                	mov    (%edi),%eax
f0106745:	ff 70 04             	pushl  0x4(%eax)
f0106748:	68 58 89 10 f0       	push   $0xf0108958
f010674d:	e8 88 d2 ff ff       	call   f01039da <cprintf>
}
f0106752:	83 c4 20             	add    $0x20,%esp
f0106755:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106758:	5b                   	pop    %ebx
f0106759:	5e                   	pop    %esi
f010675a:	5f                   	pop    %edi
f010675b:	5d                   	pop    %ebp
f010675c:	c3                   	ret    

f010675d <pci_init>:

int
pci_init(void)
{
f010675d:	55                   	push   %ebp
f010675e:	89 e5                	mov    %esp,%ebp
f0106760:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0106763:	6a 08                	push   $0x8
f0106765:	6a 00                	push   $0x0
f0106767:	68 8c 3e 53 f0       	push   $0xf0533e8c
f010676c:	e8 ee f0 ff ff       	call   f010585f <memset>

	return pci_scan_bus(&root_bus);
f0106771:	b8 8c 3e 53 f0       	mov    $0xf0533e8c,%eax
f0106776:	e8 0d fc ff ff       	call   f0106388 <pci_scan_bus>
}
f010677b:	c9                   	leave  
f010677c:	c3                   	ret    

f010677d <time_init>:
static unsigned int ticks;

void
time_init(void)
{
	ticks = 0;
f010677d:	c7 05 94 3e 53 f0 00 	movl   $0x0,0xf0533e94
f0106784:	00 00 00 
}
f0106787:	c3                   	ret    

f0106788 <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f0106788:	a1 94 3e 53 f0       	mov    0xf0533e94,%eax
f010678d:	83 c0 01             	add    $0x1,%eax
f0106790:	a3 94 3e 53 f0       	mov    %eax,0xf0533e94
	if (ticks * 10 < ticks)
f0106795:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0106798:	01 d2                	add    %edx,%edx
f010679a:	39 d0                	cmp    %edx,%eax
f010679c:	77 01                	ja     f010679f <time_tick+0x17>
f010679e:	c3                   	ret    
{
f010679f:	55                   	push   %ebp
f01067a0:	89 e5                	mov    %esp,%ebp
f01067a2:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f01067a5:	68 60 8a 10 f0       	push   $0xf0108a60
f01067aa:	6a 13                	push   $0x13
f01067ac:	68 7b 8a 10 f0       	push   $0xf0108a7b
f01067b1:	e8 8a 98 ff ff       	call   f0100040 <_panic>

f01067b6 <time_msec>:
}

unsigned int
time_msec(void)
{
	return ticks * 10;
f01067b6:	a1 94 3e 53 f0       	mov    0xf0533e94,%eax
f01067bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01067be:	01 c0                	add    %eax,%eax
}
f01067c0:	c3                   	ret    
f01067c1:	66 90                	xchg   %ax,%ax
f01067c3:	66 90                	xchg   %ax,%ax
f01067c5:	66 90                	xchg   %ax,%ax
f01067c7:	66 90                	xchg   %ax,%ax
f01067c9:	66 90                	xchg   %ax,%ax
f01067cb:	66 90                	xchg   %ax,%ax
f01067cd:	66 90                	xchg   %ax,%ax
f01067cf:	90                   	nop

f01067d0 <__udivdi3>:
f01067d0:	f3 0f 1e fb          	endbr32 
f01067d4:	55                   	push   %ebp
f01067d5:	57                   	push   %edi
f01067d6:	56                   	push   %esi
f01067d7:	53                   	push   %ebx
f01067d8:	83 ec 1c             	sub    $0x1c,%esp
f01067db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f01067df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f01067e3:	8b 74 24 34          	mov    0x34(%esp),%esi
f01067e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f01067eb:	85 d2                	test   %edx,%edx
f01067ed:	75 49                	jne    f0106838 <__udivdi3+0x68>
f01067ef:	39 f3                	cmp    %esi,%ebx
f01067f1:	76 15                	jbe    f0106808 <__udivdi3+0x38>
f01067f3:	31 ff                	xor    %edi,%edi
f01067f5:	89 e8                	mov    %ebp,%eax
f01067f7:	89 f2                	mov    %esi,%edx
f01067f9:	f7 f3                	div    %ebx
f01067fb:	89 fa                	mov    %edi,%edx
f01067fd:	83 c4 1c             	add    $0x1c,%esp
f0106800:	5b                   	pop    %ebx
f0106801:	5e                   	pop    %esi
f0106802:	5f                   	pop    %edi
f0106803:	5d                   	pop    %ebp
f0106804:	c3                   	ret    
f0106805:	8d 76 00             	lea    0x0(%esi),%esi
f0106808:	89 d9                	mov    %ebx,%ecx
f010680a:	85 db                	test   %ebx,%ebx
f010680c:	75 0b                	jne    f0106819 <__udivdi3+0x49>
f010680e:	b8 01 00 00 00       	mov    $0x1,%eax
f0106813:	31 d2                	xor    %edx,%edx
f0106815:	f7 f3                	div    %ebx
f0106817:	89 c1                	mov    %eax,%ecx
f0106819:	31 d2                	xor    %edx,%edx
f010681b:	89 f0                	mov    %esi,%eax
f010681d:	f7 f1                	div    %ecx
f010681f:	89 c6                	mov    %eax,%esi
f0106821:	89 e8                	mov    %ebp,%eax
f0106823:	89 f7                	mov    %esi,%edi
f0106825:	f7 f1                	div    %ecx
f0106827:	89 fa                	mov    %edi,%edx
f0106829:	83 c4 1c             	add    $0x1c,%esp
f010682c:	5b                   	pop    %ebx
f010682d:	5e                   	pop    %esi
f010682e:	5f                   	pop    %edi
f010682f:	5d                   	pop    %ebp
f0106830:	c3                   	ret    
f0106831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106838:	39 f2                	cmp    %esi,%edx
f010683a:	77 1c                	ja     f0106858 <__udivdi3+0x88>
f010683c:	0f bd fa             	bsr    %edx,%edi
f010683f:	83 f7 1f             	xor    $0x1f,%edi
f0106842:	75 2c                	jne    f0106870 <__udivdi3+0xa0>
f0106844:	39 f2                	cmp    %esi,%edx
f0106846:	72 06                	jb     f010684e <__udivdi3+0x7e>
f0106848:	31 c0                	xor    %eax,%eax
f010684a:	39 eb                	cmp    %ebp,%ebx
f010684c:	77 ad                	ja     f01067fb <__udivdi3+0x2b>
f010684e:	b8 01 00 00 00       	mov    $0x1,%eax
f0106853:	eb a6                	jmp    f01067fb <__udivdi3+0x2b>
f0106855:	8d 76 00             	lea    0x0(%esi),%esi
f0106858:	31 ff                	xor    %edi,%edi
f010685a:	31 c0                	xor    %eax,%eax
f010685c:	89 fa                	mov    %edi,%edx
f010685e:	83 c4 1c             	add    $0x1c,%esp
f0106861:	5b                   	pop    %ebx
f0106862:	5e                   	pop    %esi
f0106863:	5f                   	pop    %edi
f0106864:	5d                   	pop    %ebp
f0106865:	c3                   	ret    
f0106866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010686d:	8d 76 00             	lea    0x0(%esi),%esi
f0106870:	89 f9                	mov    %edi,%ecx
f0106872:	b8 20 00 00 00       	mov    $0x20,%eax
f0106877:	29 f8                	sub    %edi,%eax
f0106879:	d3 e2                	shl    %cl,%edx
f010687b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010687f:	89 c1                	mov    %eax,%ecx
f0106881:	89 da                	mov    %ebx,%edx
f0106883:	d3 ea                	shr    %cl,%edx
f0106885:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106889:	09 d1                	or     %edx,%ecx
f010688b:	89 f2                	mov    %esi,%edx
f010688d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106891:	89 f9                	mov    %edi,%ecx
f0106893:	d3 e3                	shl    %cl,%ebx
f0106895:	89 c1                	mov    %eax,%ecx
f0106897:	d3 ea                	shr    %cl,%edx
f0106899:	89 f9                	mov    %edi,%ecx
f010689b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010689f:	89 eb                	mov    %ebp,%ebx
f01068a1:	d3 e6                	shl    %cl,%esi
f01068a3:	89 c1                	mov    %eax,%ecx
f01068a5:	d3 eb                	shr    %cl,%ebx
f01068a7:	09 de                	or     %ebx,%esi
f01068a9:	89 f0                	mov    %esi,%eax
f01068ab:	f7 74 24 08          	divl   0x8(%esp)
f01068af:	89 d6                	mov    %edx,%esi
f01068b1:	89 c3                	mov    %eax,%ebx
f01068b3:	f7 64 24 0c          	mull   0xc(%esp)
f01068b7:	39 d6                	cmp    %edx,%esi
f01068b9:	72 15                	jb     f01068d0 <__udivdi3+0x100>
f01068bb:	89 f9                	mov    %edi,%ecx
f01068bd:	d3 e5                	shl    %cl,%ebp
f01068bf:	39 c5                	cmp    %eax,%ebp
f01068c1:	73 04                	jae    f01068c7 <__udivdi3+0xf7>
f01068c3:	39 d6                	cmp    %edx,%esi
f01068c5:	74 09                	je     f01068d0 <__udivdi3+0x100>
f01068c7:	89 d8                	mov    %ebx,%eax
f01068c9:	31 ff                	xor    %edi,%edi
f01068cb:	e9 2b ff ff ff       	jmp    f01067fb <__udivdi3+0x2b>
f01068d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01068d3:	31 ff                	xor    %edi,%edi
f01068d5:	e9 21 ff ff ff       	jmp    f01067fb <__udivdi3+0x2b>
f01068da:	66 90                	xchg   %ax,%ax
f01068dc:	66 90                	xchg   %ax,%ax
f01068de:	66 90                	xchg   %ax,%ax

f01068e0 <__umoddi3>:
f01068e0:	f3 0f 1e fb          	endbr32 
f01068e4:	55                   	push   %ebp
f01068e5:	57                   	push   %edi
f01068e6:	56                   	push   %esi
f01068e7:	53                   	push   %ebx
f01068e8:	83 ec 1c             	sub    $0x1c,%esp
f01068eb:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01068ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01068f3:	8b 74 24 30          	mov    0x30(%esp),%esi
f01068f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01068fb:	89 da                	mov    %ebx,%edx
f01068fd:	85 c0                	test   %eax,%eax
f01068ff:	75 3f                	jne    f0106940 <__umoddi3+0x60>
f0106901:	39 df                	cmp    %ebx,%edi
f0106903:	76 13                	jbe    f0106918 <__umoddi3+0x38>
f0106905:	89 f0                	mov    %esi,%eax
f0106907:	f7 f7                	div    %edi
f0106909:	89 d0                	mov    %edx,%eax
f010690b:	31 d2                	xor    %edx,%edx
f010690d:	83 c4 1c             	add    $0x1c,%esp
f0106910:	5b                   	pop    %ebx
f0106911:	5e                   	pop    %esi
f0106912:	5f                   	pop    %edi
f0106913:	5d                   	pop    %ebp
f0106914:	c3                   	ret    
f0106915:	8d 76 00             	lea    0x0(%esi),%esi
f0106918:	89 fd                	mov    %edi,%ebp
f010691a:	85 ff                	test   %edi,%edi
f010691c:	75 0b                	jne    f0106929 <__umoddi3+0x49>
f010691e:	b8 01 00 00 00       	mov    $0x1,%eax
f0106923:	31 d2                	xor    %edx,%edx
f0106925:	f7 f7                	div    %edi
f0106927:	89 c5                	mov    %eax,%ebp
f0106929:	89 d8                	mov    %ebx,%eax
f010692b:	31 d2                	xor    %edx,%edx
f010692d:	f7 f5                	div    %ebp
f010692f:	89 f0                	mov    %esi,%eax
f0106931:	f7 f5                	div    %ebp
f0106933:	89 d0                	mov    %edx,%eax
f0106935:	eb d4                	jmp    f010690b <__umoddi3+0x2b>
f0106937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010693e:	66 90                	xchg   %ax,%ax
f0106940:	89 f1                	mov    %esi,%ecx
f0106942:	39 d8                	cmp    %ebx,%eax
f0106944:	76 0a                	jbe    f0106950 <__umoddi3+0x70>
f0106946:	89 f0                	mov    %esi,%eax
f0106948:	83 c4 1c             	add    $0x1c,%esp
f010694b:	5b                   	pop    %ebx
f010694c:	5e                   	pop    %esi
f010694d:	5f                   	pop    %edi
f010694e:	5d                   	pop    %ebp
f010694f:	c3                   	ret    
f0106950:	0f bd e8             	bsr    %eax,%ebp
f0106953:	83 f5 1f             	xor    $0x1f,%ebp
f0106956:	75 20                	jne    f0106978 <__umoddi3+0x98>
f0106958:	39 d8                	cmp    %ebx,%eax
f010695a:	0f 82 b0 00 00 00    	jb     f0106a10 <__umoddi3+0x130>
f0106960:	39 f7                	cmp    %esi,%edi
f0106962:	0f 86 a8 00 00 00    	jbe    f0106a10 <__umoddi3+0x130>
f0106968:	89 c8                	mov    %ecx,%eax
f010696a:	83 c4 1c             	add    $0x1c,%esp
f010696d:	5b                   	pop    %ebx
f010696e:	5e                   	pop    %esi
f010696f:	5f                   	pop    %edi
f0106970:	5d                   	pop    %ebp
f0106971:	c3                   	ret    
f0106972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106978:	89 e9                	mov    %ebp,%ecx
f010697a:	ba 20 00 00 00       	mov    $0x20,%edx
f010697f:	29 ea                	sub    %ebp,%edx
f0106981:	d3 e0                	shl    %cl,%eax
f0106983:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106987:	89 d1                	mov    %edx,%ecx
f0106989:	89 f8                	mov    %edi,%eax
f010698b:	d3 e8                	shr    %cl,%eax
f010698d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106991:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106995:	8b 54 24 04          	mov    0x4(%esp),%edx
f0106999:	09 c1                	or     %eax,%ecx
f010699b:	89 d8                	mov    %ebx,%eax
f010699d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01069a1:	89 e9                	mov    %ebp,%ecx
f01069a3:	d3 e7                	shl    %cl,%edi
f01069a5:	89 d1                	mov    %edx,%ecx
f01069a7:	d3 e8                	shr    %cl,%eax
f01069a9:	89 e9                	mov    %ebp,%ecx
f01069ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01069af:	d3 e3                	shl    %cl,%ebx
f01069b1:	89 c7                	mov    %eax,%edi
f01069b3:	89 d1                	mov    %edx,%ecx
f01069b5:	89 f0                	mov    %esi,%eax
f01069b7:	d3 e8                	shr    %cl,%eax
f01069b9:	89 e9                	mov    %ebp,%ecx
f01069bb:	89 fa                	mov    %edi,%edx
f01069bd:	d3 e6                	shl    %cl,%esi
f01069bf:	09 d8                	or     %ebx,%eax
f01069c1:	f7 74 24 08          	divl   0x8(%esp)
f01069c5:	89 d1                	mov    %edx,%ecx
f01069c7:	89 f3                	mov    %esi,%ebx
f01069c9:	f7 64 24 0c          	mull   0xc(%esp)
f01069cd:	89 c6                	mov    %eax,%esi
f01069cf:	89 d7                	mov    %edx,%edi
f01069d1:	39 d1                	cmp    %edx,%ecx
f01069d3:	72 06                	jb     f01069db <__umoddi3+0xfb>
f01069d5:	75 10                	jne    f01069e7 <__umoddi3+0x107>
f01069d7:	39 c3                	cmp    %eax,%ebx
f01069d9:	73 0c                	jae    f01069e7 <__umoddi3+0x107>
f01069db:	2b 44 24 0c          	sub    0xc(%esp),%eax
f01069df:	1b 54 24 08          	sbb    0x8(%esp),%edx
f01069e3:	89 d7                	mov    %edx,%edi
f01069e5:	89 c6                	mov    %eax,%esi
f01069e7:	89 ca                	mov    %ecx,%edx
f01069e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01069ee:	29 f3                	sub    %esi,%ebx
f01069f0:	19 fa                	sbb    %edi,%edx
f01069f2:	89 d0                	mov    %edx,%eax
f01069f4:	d3 e0                	shl    %cl,%eax
f01069f6:	89 e9                	mov    %ebp,%ecx
f01069f8:	d3 eb                	shr    %cl,%ebx
f01069fa:	d3 ea                	shr    %cl,%edx
f01069fc:	09 d8                	or     %ebx,%eax
f01069fe:	83 c4 1c             	add    $0x1c,%esp
f0106a01:	5b                   	pop    %ebx
f0106a02:	5e                   	pop    %esi
f0106a03:	5f                   	pop    %edi
f0106a04:	5d                   	pop    %ebp
f0106a05:	c3                   	ret    
f0106a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106a0d:	8d 76 00             	lea    0x0(%esi),%esi
f0106a10:	89 da                	mov    %ebx,%edx
f0106a12:	29 fe                	sub    %edi,%esi
f0106a14:	19 c2                	sbb    %eax,%edx
f0106a16:	89 f1                	mov    %esi,%ecx
f0106a18:	89 c8                	mov    %ecx,%eax
f0106a1a:	e9 4b ff ff ff       	jmp    f010696a <__umoddi3+0x8a>
