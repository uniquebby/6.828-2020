
obj/user/dumbfork.debug：     文件格式 elf32-i386


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
  80002c:	e8 a1 01 00 00       	call   8001d2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 07                	push   $0x7
  800043:	53                   	push   %ebx
  800044:	56                   	push   %esi
  800045:	e8 91 0c 00 00       	call   800cdb <sys_page_alloc>
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	78 4a                	js     80009b <duppage+0x68>
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 40 00       	push   $0x400000
  80005b:	6a 00                	push   $0x0
  80005d:	53                   	push   %ebx
  80005e:	56                   	push   %esi
  80005f:	e8 ba 0c 00 00       	call   800d1e <sys_page_map>
  800064:	83 c4 20             	add    $0x20,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 42                	js     8000ad <duppage+0x7a>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 00 10 00 00       	push   $0x1000
  800073:	53                   	push   %ebx
  800074:	68 00 00 40 00       	push   $0x400000
  800079:	e8 f9 09 00 00       	call   800a77 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80007e:	83 c4 08             	add    $0x8,%esp
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	6a 00                	push   $0x0
  800088:	e8 d3 0c 00 00       	call   800d60 <sys_page_unmap>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	78 2b                	js     8000bf <duppage+0x8c>
		panic("sys_page_unmap: %e", r);
}
  800094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800097:	5b                   	pop    %ebx
  800098:	5e                   	pop    %esi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80009b:	50                   	push   %eax
  80009c:	68 00 24 80 00       	push   $0x802400
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 13 24 80 00       	push   $0x802413
  8000a8:	e8 85 01 00 00       	call   800232 <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 23 24 80 00       	push   $0x802423
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 13 24 80 00       	push   $0x802413
  8000ba:	e8 73 01 00 00       	call   800232 <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 34 24 80 00       	push   $0x802434
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 13 24 80 00       	push   $0x802413
  8000cc:	e8 61 01 00 00       	call   800232 <_panic>

008000d1 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8000de:	cd 30                	int    $0x30
  8000e0:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	78 2c                	js     800112 <dumbfork+0x41>
  8000e6:	89 c6                	mov    %eax,%esi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8000e8:	74 3a                	je     800124 <dumbfork+0x53>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8000ea:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8000f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000f4:	81 fa 00 70 80 00    	cmp    $0x807000,%edx
  8000fa:	73 41                	jae    80013d <dumbfork+0x6c>
		duppage(envid, addr);
  8000fc:	83 ec 08             	sub    $0x8,%esp
  8000ff:	52                   	push   %edx
  800100:	56                   	push   %esi
  800101:	e8 2d ff ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800106:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	eb df                	jmp    8000f1 <dumbfork+0x20>
		panic("sys_exofork: %e", envid);
  800112:	50                   	push   %eax
  800113:	68 47 24 80 00       	push   $0x802447
  800118:	6a 37                	push   $0x37
  80011a:	68 13 24 80 00       	push   $0x802413
  80011f:	e8 0e 01 00 00       	call   800232 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  800124:	e8 74 0b 00 00       	call   800c9d <sys_getenvid>
  800129:	25 ff 03 00 00       	and    $0x3ff,%eax
  80012e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800131:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800136:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  80013b:	eb 24                	jmp    800161 <dumbfork+0x90>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  80013d:	83 ec 08             	sub    $0x8,%esp
  800140:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800143:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800148:	50                   	push   %eax
  800149:	53                   	push   %ebx
  80014a:	e8 e4 fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80014f:	83 c4 08             	add    $0x8,%esp
  800152:	6a 02                	push   $0x2
  800154:	53                   	push   %ebx
  800155:	e8 48 0c 00 00       	call   800da2 <sys_env_set_status>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	85 c0                	test   %eax,%eax
  80015f:	78 09                	js     80016a <dumbfork+0x99>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  800161:	89 d8                	mov    %ebx,%eax
  800163:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800166:	5b                   	pop    %ebx
  800167:	5e                   	pop    %esi
  800168:	5d                   	pop    %ebp
  800169:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  80016a:	50                   	push   %eax
  80016b:	68 57 24 80 00       	push   $0x802457
  800170:	6a 4c                	push   $0x4c
  800172:	68 13 24 80 00       	push   $0x802413
  800177:	e8 b6 00 00 00       	call   800232 <_panic>

0080017c <umain>:
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	57                   	push   %edi
  800180:	56                   	push   %esi
  800181:	53                   	push   %ebx
  800182:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  800185:	e8 47 ff ff ff       	call   8000d1 <dumbfork>
  80018a:	89 c7                	mov    %eax,%edi
  80018c:	85 c0                	test   %eax,%eax
  80018e:	be 6e 24 80 00       	mov    $0x80246e,%esi
  800193:	b8 75 24 80 00       	mov    $0x802475,%eax
  800198:	0f 44 f0             	cmove  %eax,%esi
	for (i = 0; i < (who ? 10 : 20); i++) {
  80019b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a0:	eb 1f                	jmp    8001c1 <umain+0x45>
  8001a2:	83 fb 13             	cmp    $0x13,%ebx
  8001a5:	7f 23                	jg     8001ca <umain+0x4e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001a7:	83 ec 04             	sub    $0x4,%esp
  8001aa:	56                   	push   %esi
  8001ab:	53                   	push   %ebx
  8001ac:	68 7b 24 80 00       	push   $0x80247b
  8001b1:	e8 57 01 00 00       	call   80030d <cprintf>
		sys_yield();
  8001b6:	e8 01 0b 00 00       	call   800cbc <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001bb:	83 c3 01             	add    $0x1,%ebx
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	85 ff                	test   %edi,%edi
  8001c3:	74 dd                	je     8001a2 <umain+0x26>
  8001c5:	83 fb 09             	cmp    $0x9,%ebx
  8001c8:	7e dd                	jle    8001a7 <umain+0x2b>
}
  8001ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cd:	5b                   	pop    %ebx
  8001ce:	5e                   	pop    %esi
  8001cf:	5f                   	pop    %edi
  8001d0:	5d                   	pop    %ebp
  8001d1:	c3                   	ret    

008001d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	56                   	push   %esi
  8001d6:	53                   	push   %ebx
  8001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001dd:	e8 bb 0a 00 00       	call   800c9d <sys_getenvid>
  8001e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ef:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f4:	85 db                	test   %ebx,%ebx
  8001f6:	7e 07                	jle    8001ff <libmain+0x2d>
		binaryname = argv[0];
  8001f8:	8b 06                	mov    (%esi),%eax
  8001fa:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001ff:	83 ec 08             	sub    $0x8,%esp
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	e8 73 ff ff ff       	call   80017c <umain>

	// exit gracefully
	exit();
  800209:	e8 0a 00 00 00       	call   800218 <exit>
}
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80021e:	e8 a0 0e 00 00       	call   8010c3 <close_all>
	sys_env_destroy(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 2f 0a 00 00       	call   800c5c <sys_env_destroy>
}
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	c9                   	leave  
  800231:	c3                   	ret    

00800232 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	56                   	push   %esi
  800236:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800237:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80023a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800240:	e8 58 0a 00 00       	call   800c9d <sys_getenvid>
  800245:	83 ec 0c             	sub    $0xc,%esp
  800248:	ff 75 0c             	pushl  0xc(%ebp)
  80024b:	ff 75 08             	pushl  0x8(%ebp)
  80024e:	56                   	push   %esi
  80024f:	50                   	push   %eax
  800250:	68 98 24 80 00       	push   $0x802498
  800255:	e8 b3 00 00 00       	call   80030d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025a:	83 c4 18             	add    $0x18,%esp
  80025d:	53                   	push   %ebx
  80025e:	ff 75 10             	pushl  0x10(%ebp)
  800261:	e8 56 00 00 00       	call   8002bc <vcprintf>
	cprintf("\n");
  800266:	c7 04 24 8b 24 80 00 	movl   $0x80248b,(%esp)
  80026d:	e8 9b 00 00 00       	call   80030d <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800275:	cc                   	int3   
  800276:	eb fd                	jmp    800275 <_panic+0x43>

00800278 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	53                   	push   %ebx
  80027c:	83 ec 04             	sub    $0x4,%esp
  80027f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800282:	8b 13                	mov    (%ebx),%edx
  800284:	8d 42 01             	lea    0x1(%edx),%eax
  800287:	89 03                	mov    %eax,(%ebx)
  800289:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800290:	3d ff 00 00 00       	cmp    $0xff,%eax
  800295:	74 09                	je     8002a0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800297:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80029b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	68 ff 00 00 00       	push   $0xff
  8002a8:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ab:	50                   	push   %eax
  8002ac:	e8 6e 09 00 00       	call   800c1f <sys_cputs>
		b->idx = 0;
  8002b1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	eb db                	jmp    800297 <putch+0x1f>

008002bc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002cc:	00 00 00 
	b.cnt = 0;
  8002cf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d9:	ff 75 0c             	pushl  0xc(%ebp)
  8002dc:	ff 75 08             	pushl  0x8(%ebp)
  8002df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e5:	50                   	push   %eax
  8002e6:	68 78 02 80 00       	push   $0x800278
  8002eb:	e8 19 01 00 00       	call   800409 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f0:	83 c4 08             	add    $0x8,%esp
  8002f3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ff:	50                   	push   %eax
  800300:	e8 1a 09 00 00       	call   800c1f <sys_cputs>

	return b.cnt;
}
  800305:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800313:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800316:	50                   	push   %eax
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	e8 9d ff ff ff       	call   8002bc <vcprintf>
	va_end(ap);

	return cnt;
}
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	57                   	push   %edi
  800325:	56                   	push   %esi
  800326:	53                   	push   %ebx
  800327:	83 ec 1c             	sub    $0x1c,%esp
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	89 d6                	mov    %edx,%esi
  80032e:	8b 45 08             	mov    0x8(%ebp),%eax
  800331:	8b 55 0c             	mov    0xc(%ebp),%edx
  800334:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800337:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80033d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800342:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800345:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800348:	3b 45 10             	cmp    0x10(%ebp),%eax
  80034b:	89 d0                	mov    %edx,%eax
  80034d:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800350:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800353:	73 15                	jae    80036a <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800355:	83 eb 01             	sub    $0x1,%ebx
  800358:	85 db                	test   %ebx,%ebx
  80035a:	7e 43                	jle    80039f <printnum+0x7e>
			putch(padc, putdat);
  80035c:	83 ec 08             	sub    $0x8,%esp
  80035f:	56                   	push   %esi
  800360:	ff 75 18             	pushl  0x18(%ebp)
  800363:	ff d7                	call   *%edi
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	eb eb                	jmp    800355 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036a:	83 ec 0c             	sub    $0xc,%esp
  80036d:	ff 75 18             	pushl  0x18(%ebp)
  800370:	8b 45 14             	mov    0x14(%ebp),%eax
  800373:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800376:	53                   	push   %ebx
  800377:	ff 75 10             	pushl  0x10(%ebp)
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800380:	ff 75 e0             	pushl  -0x20(%ebp)
  800383:	ff 75 dc             	pushl  -0x24(%ebp)
  800386:	ff 75 d8             	pushl  -0x28(%ebp)
  800389:	e8 22 1e 00 00       	call   8021b0 <__udivdi3>
  80038e:	83 c4 18             	add    $0x18,%esp
  800391:	52                   	push   %edx
  800392:	50                   	push   %eax
  800393:	89 f2                	mov    %esi,%edx
  800395:	89 f8                	mov    %edi,%eax
  800397:	e8 85 ff ff ff       	call   800321 <printnum>
  80039c:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	56                   	push   %esi
  8003a3:	83 ec 04             	sub    $0x4,%esp
  8003a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8003af:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b2:	e8 09 1f 00 00       	call   8022c0 <__umoddi3>
  8003b7:	83 c4 14             	add    $0x14,%esp
  8003ba:	0f be 80 bb 24 80 00 	movsbl 0x8024bb(%eax),%eax
  8003c1:	50                   	push   %eax
  8003c2:	ff d7                	call   *%edi
}
  8003c4:	83 c4 10             	add    $0x10,%esp
  8003c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ca:	5b                   	pop    %ebx
  8003cb:	5e                   	pop    %esi
  8003cc:	5f                   	pop    %edi
  8003cd:	5d                   	pop    %ebp
  8003ce:	c3                   	ret    

008003cf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
  8003d2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003d9:	8b 10                	mov    (%eax),%edx
  8003db:	3b 50 04             	cmp    0x4(%eax),%edx
  8003de:	73 0a                	jae    8003ea <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e3:	89 08                	mov    %ecx,(%eax)
  8003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e8:	88 02                	mov    %al,(%edx)
}
  8003ea:	5d                   	pop    %ebp
  8003eb:	c3                   	ret    

008003ec <printfmt>:
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003f2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f5:	50                   	push   %eax
  8003f6:	ff 75 10             	pushl  0x10(%ebp)
  8003f9:	ff 75 0c             	pushl  0xc(%ebp)
  8003fc:	ff 75 08             	pushl  0x8(%ebp)
  8003ff:	e8 05 00 00 00       	call   800409 <vprintfmt>
}
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <vprintfmt>:
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	57                   	push   %edi
  80040d:	56                   	push   %esi
  80040e:	53                   	push   %ebx
  80040f:	83 ec 3c             	sub    $0x3c,%esp
  800412:	8b 75 08             	mov    0x8(%ebp),%esi
  800415:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800418:	8b 7d 10             	mov    0x10(%ebp),%edi
  80041b:	eb 0a                	jmp    800427 <vprintfmt+0x1e>
			putch(ch, putdat);
  80041d:	83 ec 08             	sub    $0x8,%esp
  800420:	53                   	push   %ebx
  800421:	50                   	push   %eax
  800422:	ff d6                	call   *%esi
  800424:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800427:	83 c7 01             	add    $0x1,%edi
  80042a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80042e:	83 f8 25             	cmp    $0x25,%eax
  800431:	74 0c                	je     80043f <vprintfmt+0x36>
			if (ch == '\0')
  800433:	85 c0                	test   %eax,%eax
  800435:	75 e6                	jne    80041d <vprintfmt+0x14>
}
  800437:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80043a:	5b                   	pop    %ebx
  80043b:	5e                   	pop    %esi
  80043c:	5f                   	pop    %edi
  80043d:	5d                   	pop    %ebp
  80043e:	c3                   	ret    
		padc = ' ';
  80043f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800443:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80044a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800451:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800458:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045d:	8d 47 01             	lea    0x1(%edi),%eax
  800460:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800463:	0f b6 17             	movzbl (%edi),%edx
  800466:	8d 42 dd             	lea    -0x23(%edx),%eax
  800469:	3c 55                	cmp    $0x55,%al
  80046b:	0f 87 ba 03 00 00    	ja     80082b <vprintfmt+0x422>
  800471:	0f b6 c0             	movzbl %al,%eax
  800474:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  80047b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80047e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800482:	eb d9                	jmp    80045d <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800484:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800487:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80048b:	eb d0                	jmp    80045d <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80048d:	0f b6 d2             	movzbl %dl,%edx
  800490:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80049b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80049e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004a2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a8:	83 f9 09             	cmp    $0x9,%ecx
  8004ab:	77 55                	ja     800502 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8004ad:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004b0:	eb e9                	jmp    80049b <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	8d 40 04             	lea    0x4(%eax),%eax
  8004c0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ca:	79 91                	jns    80045d <vprintfmt+0x54>
				width = precision, precision = -1;
  8004cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004d9:	eb 82                	jmp    80045d <vprintfmt+0x54>
  8004db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004de:	85 c0                	test   %eax,%eax
  8004e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e5:	0f 49 d0             	cmovns %eax,%edx
  8004e8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ee:	e9 6a ff ff ff       	jmp    80045d <vprintfmt+0x54>
  8004f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004fd:	e9 5b ff ff ff       	jmp    80045d <vprintfmt+0x54>
  800502:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800505:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800508:	eb bc                	jmp    8004c6 <vprintfmt+0xbd>
			lflag++;
  80050a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80050d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800510:	e9 48 ff ff ff       	jmp    80045d <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	8d 78 04             	lea    0x4(%eax),%edi
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	53                   	push   %ebx
  80051f:	ff 30                	pushl  (%eax)
  800521:	ff d6                	call   *%esi
			break;
  800523:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800526:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800529:	e9 9c 02 00 00       	jmp    8007ca <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	8d 78 04             	lea    0x4(%eax),%edi
  800534:	8b 00                	mov    (%eax),%eax
  800536:	99                   	cltd   
  800537:	31 d0                	xor    %edx,%eax
  800539:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80053b:	83 f8 0f             	cmp    $0xf,%eax
  80053e:	7f 23                	jg     800563 <vprintfmt+0x15a>
  800540:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  800547:	85 d2                	test   %edx,%edx
  800549:	74 18                	je     800563 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  80054b:	52                   	push   %edx
  80054c:	68 9a 28 80 00       	push   $0x80289a
  800551:	53                   	push   %ebx
  800552:	56                   	push   %esi
  800553:	e8 94 fe ff ff       	call   8003ec <printfmt>
  800558:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80055e:	e9 67 02 00 00       	jmp    8007ca <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800563:	50                   	push   %eax
  800564:	68 d3 24 80 00       	push   $0x8024d3
  800569:	53                   	push   %ebx
  80056a:	56                   	push   %esi
  80056b:	e8 7c fe ff ff       	call   8003ec <printfmt>
  800570:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800573:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800576:	e9 4f 02 00 00       	jmp    8007ca <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	83 c0 04             	add    $0x4,%eax
  800581:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800589:	85 d2                	test   %edx,%edx
  80058b:	b8 cc 24 80 00       	mov    $0x8024cc,%eax
  800590:	0f 45 c2             	cmovne %edx,%eax
  800593:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800596:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80059a:	7e 06                	jle    8005a2 <vprintfmt+0x199>
  80059c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005a0:	75 0d                	jne    8005af <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005a5:	89 c7                	mov    %eax,%edi
  8005a7:	03 45 e0             	add    -0x20(%ebp),%eax
  8005aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ad:	eb 3f                	jmp    8005ee <vprintfmt+0x1e5>
  8005af:	83 ec 08             	sub    $0x8,%esp
  8005b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b5:	50                   	push   %eax
  8005b6:	e8 0d 03 00 00       	call   8008c8 <strnlen>
  8005bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005be:	29 c2                	sub    %eax,%edx
  8005c0:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005c8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cf:	85 ff                	test   %edi,%edi
  8005d1:	7e 58                	jle    80062b <vprintfmt+0x222>
					putch(padc, putdat);
  8005d3:	83 ec 08             	sub    $0x8,%esp
  8005d6:	53                   	push   %ebx
  8005d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8005da:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005dc:	83 ef 01             	sub    $0x1,%edi
  8005df:	83 c4 10             	add    $0x10,%esp
  8005e2:	eb eb                	jmp    8005cf <vprintfmt+0x1c6>
					putch(ch, putdat);
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	53                   	push   %ebx
  8005e8:	52                   	push   %edx
  8005e9:	ff d6                	call   *%esi
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005f1:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f3:	83 c7 01             	add    $0x1,%edi
  8005f6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005fa:	0f be d0             	movsbl %al,%edx
  8005fd:	85 d2                	test   %edx,%edx
  8005ff:	74 45                	je     800646 <vprintfmt+0x23d>
  800601:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800605:	78 06                	js     80060d <vprintfmt+0x204>
  800607:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80060b:	78 35                	js     800642 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  80060d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800611:	74 d1                	je     8005e4 <vprintfmt+0x1db>
  800613:	0f be c0             	movsbl %al,%eax
  800616:	83 e8 20             	sub    $0x20,%eax
  800619:	83 f8 5e             	cmp    $0x5e,%eax
  80061c:	76 c6                	jbe    8005e4 <vprintfmt+0x1db>
					putch('?', putdat);
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	53                   	push   %ebx
  800622:	6a 3f                	push   $0x3f
  800624:	ff d6                	call   *%esi
  800626:	83 c4 10             	add    $0x10,%esp
  800629:	eb c3                	jmp    8005ee <vprintfmt+0x1e5>
  80062b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80062e:	85 d2                	test   %edx,%edx
  800630:	b8 00 00 00 00       	mov    $0x0,%eax
  800635:	0f 49 c2             	cmovns %edx,%eax
  800638:	29 c2                	sub    %eax,%edx
  80063a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80063d:	e9 60 ff ff ff       	jmp    8005a2 <vprintfmt+0x199>
  800642:	89 cf                	mov    %ecx,%edi
  800644:	eb 02                	jmp    800648 <vprintfmt+0x23f>
  800646:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800648:	85 ff                	test   %edi,%edi
  80064a:	7e 10                	jle    80065c <vprintfmt+0x253>
				putch(' ', putdat);
  80064c:	83 ec 08             	sub    $0x8,%esp
  80064f:	53                   	push   %ebx
  800650:	6a 20                	push   $0x20
  800652:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800654:	83 ef 01             	sub    $0x1,%edi
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	eb ec                	jmp    800648 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  80065c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
  800662:	e9 63 01 00 00       	jmp    8007ca <vprintfmt+0x3c1>
	if (lflag >= 2)
  800667:	83 f9 01             	cmp    $0x1,%ecx
  80066a:	7f 1b                	jg     800687 <vprintfmt+0x27e>
	else if (lflag)
  80066c:	85 c9                	test   %ecx,%ecx
  80066e:	74 63                	je     8006d3 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800678:	99                   	cltd   
  800679:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8d 40 04             	lea    0x4(%eax),%eax
  800682:	89 45 14             	mov    %eax,0x14(%ebp)
  800685:	eb 17                	jmp    80069e <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8b 50 04             	mov    0x4(%eax),%edx
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800692:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 40 08             	lea    0x8(%eax),%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80069e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006a4:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006a9:	85 c9                	test   %ecx,%ecx
  8006ab:	0f 89 ff 00 00 00    	jns    8007b0 <vprintfmt+0x3a7>
				putch('-', putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	6a 2d                	push   $0x2d
  8006b7:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006bc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006bf:	f7 da                	neg    %edx
  8006c1:	83 d1 00             	adc    $0x0,%ecx
  8006c4:	f7 d9                	neg    %ecx
  8006c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ce:	e9 dd 00 00 00       	jmp    8007b0 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006db:	99                   	cltd   
  8006dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8d 40 04             	lea    0x4(%eax),%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e8:	eb b4                	jmp    80069e <vprintfmt+0x295>
	if (lflag >= 2)
  8006ea:	83 f9 01             	cmp    $0x1,%ecx
  8006ed:	7f 1e                	jg     80070d <vprintfmt+0x304>
	else if (lflag)
  8006ef:	85 c9                	test   %ecx,%ecx
  8006f1:	74 32                	je     800725 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 10                	mov    (%eax),%edx
  8006f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fd:	8d 40 04             	lea    0x4(%eax),%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800703:	b8 0a 00 00 00       	mov    $0xa,%eax
  800708:	e9 a3 00 00 00       	jmp    8007b0 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8b 10                	mov    (%eax),%edx
  800712:	8b 48 04             	mov    0x4(%eax),%ecx
  800715:	8d 40 08             	lea    0x8(%eax),%eax
  800718:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800720:	e9 8b 00 00 00       	jmp    8007b0 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8b 10                	mov    (%eax),%edx
  80072a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072f:	8d 40 04             	lea    0x4(%eax),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800735:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073a:	eb 74                	jmp    8007b0 <vprintfmt+0x3a7>
	if (lflag >= 2)
  80073c:	83 f9 01             	cmp    $0x1,%ecx
  80073f:	7f 1b                	jg     80075c <vprintfmt+0x353>
	else if (lflag)
  800741:	85 c9                	test   %ecx,%ecx
  800743:	74 2c                	je     800771 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8b 10                	mov    (%eax),%edx
  80074a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074f:	8d 40 04             	lea    0x4(%eax),%eax
  800752:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800755:	b8 08 00 00 00       	mov    $0x8,%eax
  80075a:	eb 54                	jmp    8007b0 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8b 10                	mov    (%eax),%edx
  800761:	8b 48 04             	mov    0x4(%eax),%ecx
  800764:	8d 40 08             	lea    0x8(%eax),%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80076a:	b8 08 00 00 00       	mov    $0x8,%eax
  80076f:	eb 3f                	jmp    8007b0 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8b 10                	mov    (%eax),%edx
  800776:	b9 00 00 00 00       	mov    $0x0,%ecx
  80077b:	8d 40 04             	lea    0x4(%eax),%eax
  80077e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800781:	b8 08 00 00 00       	mov    $0x8,%eax
  800786:	eb 28                	jmp    8007b0 <vprintfmt+0x3a7>
			putch('0', putdat);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	53                   	push   %ebx
  80078c:	6a 30                	push   $0x30
  80078e:	ff d6                	call   *%esi
			putch('x', putdat);
  800790:	83 c4 08             	add    $0x8,%esp
  800793:	53                   	push   %ebx
  800794:	6a 78                	push   $0x78
  800796:	ff d6                	call   *%esi
			num = (unsigned long long)
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 10                	mov    (%eax),%edx
  80079d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007a2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a5:	8d 40 04             	lea    0x4(%eax),%eax
  8007a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ab:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007b7:	57                   	push   %edi
  8007b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8007bb:	50                   	push   %eax
  8007bc:	51                   	push   %ecx
  8007bd:	52                   	push   %edx
  8007be:	89 da                	mov    %ebx,%edx
  8007c0:	89 f0                	mov    %esi,%eax
  8007c2:	e8 5a fb ff ff       	call   800321 <printnum>
			break;
  8007c7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cd:	e9 55 fc ff ff       	jmp    800427 <vprintfmt+0x1e>
	if (lflag >= 2)
  8007d2:	83 f9 01             	cmp    $0x1,%ecx
  8007d5:	7f 1b                	jg     8007f2 <vprintfmt+0x3e9>
	else if (lflag)
  8007d7:	85 c9                	test   %ecx,%ecx
  8007d9:	74 2c                	je     800807 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8b 10                	mov    (%eax),%edx
  8007e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e5:	8d 40 04             	lea    0x4(%eax),%eax
  8007e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007eb:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f0:	eb be                	jmp    8007b0 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8b 10                	mov    (%eax),%edx
  8007f7:	8b 48 04             	mov    0x4(%eax),%ecx
  8007fa:	8d 40 08             	lea    0x8(%eax),%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800800:	b8 10 00 00 00       	mov    $0x10,%eax
  800805:	eb a9                	jmp    8007b0 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	8b 10                	mov    (%eax),%edx
  80080c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800811:	8d 40 04             	lea    0x4(%eax),%eax
  800814:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800817:	b8 10 00 00 00       	mov    $0x10,%eax
  80081c:	eb 92                	jmp    8007b0 <vprintfmt+0x3a7>
			putch(ch, putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	53                   	push   %ebx
  800822:	6a 25                	push   $0x25
  800824:	ff d6                	call   *%esi
			break;
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	eb 9f                	jmp    8007ca <vprintfmt+0x3c1>
			putch('%', putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	53                   	push   %ebx
  80082f:	6a 25                	push   $0x25
  800831:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	89 f8                	mov    %edi,%eax
  800838:	eb 03                	jmp    80083d <vprintfmt+0x434>
  80083a:	83 e8 01             	sub    $0x1,%eax
  80083d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800841:	75 f7                	jne    80083a <vprintfmt+0x431>
  800843:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800846:	eb 82                	jmp    8007ca <vprintfmt+0x3c1>

00800848 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	83 ec 18             	sub    $0x18,%esp
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800854:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800857:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80085b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800865:	85 c0                	test   %eax,%eax
  800867:	74 26                	je     80088f <vsnprintf+0x47>
  800869:	85 d2                	test   %edx,%edx
  80086b:	7e 22                	jle    80088f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80086d:	ff 75 14             	pushl  0x14(%ebp)
  800870:	ff 75 10             	pushl  0x10(%ebp)
  800873:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800876:	50                   	push   %eax
  800877:	68 cf 03 80 00       	push   $0x8003cf
  80087c:	e8 88 fb ff ff       	call   800409 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800881:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800884:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088a:	83 c4 10             	add    $0x10,%esp
}
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    
		return -E_INVAL;
  80088f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800894:	eb f7                	jmp    80088d <vsnprintf+0x45>

00800896 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80089f:	50                   	push   %eax
  8008a0:	ff 75 10             	pushl  0x10(%ebp)
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	ff 75 08             	pushl  0x8(%ebp)
  8008a9:	e8 9a ff ff ff       	call   800848 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    

008008b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008bf:	74 05                	je     8008c6 <strlen+0x16>
		n++;
  8008c1:	83 c0 01             	add    $0x1,%eax
  8008c4:	eb f5                	jmp    8008bb <strlen+0xb>
	return n;
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d6:	39 c2                	cmp    %eax,%edx
  8008d8:	74 0d                	je     8008e7 <strnlen+0x1f>
  8008da:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008de:	74 05                	je     8008e5 <strnlen+0x1d>
		n++;
  8008e0:	83 c2 01             	add    $0x1,%edx
  8008e3:	eb f1                	jmp    8008d6 <strnlen+0xe>
  8008e5:	89 d0                	mov    %edx,%eax
	return n;
}
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	53                   	push   %ebx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008ff:	83 c2 01             	add    $0x1,%edx
  800902:	84 c9                	test   %cl,%cl
  800904:	75 f2                	jne    8008f8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800906:	5b                   	pop    %ebx
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    

00800909 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	53                   	push   %ebx
  80090d:	83 ec 10             	sub    $0x10,%esp
  800910:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800913:	53                   	push   %ebx
  800914:	e8 97 ff ff ff       	call   8008b0 <strlen>
  800919:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	01 d8                	add    %ebx,%eax
  800921:	50                   	push   %eax
  800922:	e8 c2 ff ff ff       	call   8008e9 <strcpy>
	return dst;
}
  800927:	89 d8                	mov    %ebx,%eax
  800929:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80092c:	c9                   	leave  
  80092d:	c3                   	ret    

0080092e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	56                   	push   %esi
  800932:	53                   	push   %ebx
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800939:	89 c6                	mov    %eax,%esi
  80093b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80093e:	89 c2                	mov    %eax,%edx
  800940:	39 f2                	cmp    %esi,%edx
  800942:	74 11                	je     800955 <strncpy+0x27>
		*dst++ = *src;
  800944:	83 c2 01             	add    $0x1,%edx
  800947:	0f b6 19             	movzbl (%ecx),%ebx
  80094a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094d:	80 fb 01             	cmp    $0x1,%bl
  800950:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800953:	eb eb                	jmp    800940 <strncpy+0x12>
	}
	return ret;
}
  800955:	5b                   	pop    %ebx
  800956:	5e                   	pop    %esi
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    

00800959 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	56                   	push   %esi
  80095d:	53                   	push   %ebx
  80095e:	8b 75 08             	mov    0x8(%ebp),%esi
  800961:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800964:	8b 55 10             	mov    0x10(%ebp),%edx
  800967:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800969:	85 d2                	test   %edx,%edx
  80096b:	74 21                	je     80098e <strlcpy+0x35>
  80096d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800971:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800973:	39 c2                	cmp    %eax,%edx
  800975:	74 14                	je     80098b <strlcpy+0x32>
  800977:	0f b6 19             	movzbl (%ecx),%ebx
  80097a:	84 db                	test   %bl,%bl
  80097c:	74 0b                	je     800989 <strlcpy+0x30>
			*dst++ = *src++;
  80097e:	83 c1 01             	add    $0x1,%ecx
  800981:	83 c2 01             	add    $0x1,%edx
  800984:	88 5a ff             	mov    %bl,-0x1(%edx)
  800987:	eb ea                	jmp    800973 <strlcpy+0x1a>
  800989:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80098b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80098e:	29 f0                	sub    %esi,%eax
}
  800990:	5b                   	pop    %ebx
  800991:	5e                   	pop    %esi
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80099d:	0f b6 01             	movzbl (%ecx),%eax
  8009a0:	84 c0                	test   %al,%al
  8009a2:	74 0c                	je     8009b0 <strcmp+0x1c>
  8009a4:	3a 02                	cmp    (%edx),%al
  8009a6:	75 08                	jne    8009b0 <strcmp+0x1c>
		p++, q++;
  8009a8:	83 c1 01             	add    $0x1,%ecx
  8009ab:	83 c2 01             	add    $0x1,%edx
  8009ae:	eb ed                	jmp    80099d <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b0:	0f b6 c0             	movzbl %al,%eax
  8009b3:	0f b6 12             	movzbl (%edx),%edx
  8009b6:	29 d0                	sub    %edx,%eax
}
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	53                   	push   %ebx
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c4:	89 c3                	mov    %eax,%ebx
  8009c6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c9:	eb 06                	jmp    8009d1 <strncmp+0x17>
		n--, p++, q++;
  8009cb:	83 c0 01             	add    $0x1,%eax
  8009ce:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009d1:	39 d8                	cmp    %ebx,%eax
  8009d3:	74 16                	je     8009eb <strncmp+0x31>
  8009d5:	0f b6 08             	movzbl (%eax),%ecx
  8009d8:	84 c9                	test   %cl,%cl
  8009da:	74 04                	je     8009e0 <strncmp+0x26>
  8009dc:	3a 0a                	cmp    (%edx),%cl
  8009de:	74 eb                	je     8009cb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e0:	0f b6 00             	movzbl (%eax),%eax
  8009e3:	0f b6 12             	movzbl (%edx),%edx
  8009e6:	29 d0                	sub    %edx,%eax
}
  8009e8:	5b                   	pop    %ebx
  8009e9:	5d                   	pop    %ebp
  8009ea:	c3                   	ret    
		return 0;
  8009eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f0:	eb f6                	jmp    8009e8 <strncmp+0x2e>

008009f2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009fc:	0f b6 10             	movzbl (%eax),%edx
  8009ff:	84 d2                	test   %dl,%dl
  800a01:	74 09                	je     800a0c <strchr+0x1a>
		if (*s == c)
  800a03:	38 ca                	cmp    %cl,%dl
  800a05:	74 0a                	je     800a11 <strchr+0x1f>
	for (; *s; s++)
  800a07:	83 c0 01             	add    $0x1,%eax
  800a0a:	eb f0                	jmp    8009fc <strchr+0xa>
			return (char *) s;
	return 0;
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a20:	38 ca                	cmp    %cl,%dl
  800a22:	74 09                	je     800a2d <strfind+0x1a>
  800a24:	84 d2                	test   %dl,%dl
  800a26:	74 05                	je     800a2d <strfind+0x1a>
	for (; *s; s++)
  800a28:	83 c0 01             	add    $0x1,%eax
  800a2b:	eb f0                	jmp    800a1d <strfind+0xa>
			break;
	return (char *) s;
}
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	57                   	push   %edi
  800a33:	56                   	push   %esi
  800a34:	53                   	push   %ebx
  800a35:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a38:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a3b:	85 c9                	test   %ecx,%ecx
  800a3d:	74 31                	je     800a70 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a3f:	89 f8                	mov    %edi,%eax
  800a41:	09 c8                	or     %ecx,%eax
  800a43:	a8 03                	test   $0x3,%al
  800a45:	75 23                	jne    800a6a <memset+0x3b>
		c &= 0xFF;
  800a47:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a4b:	89 d3                	mov    %edx,%ebx
  800a4d:	c1 e3 08             	shl    $0x8,%ebx
  800a50:	89 d0                	mov    %edx,%eax
  800a52:	c1 e0 18             	shl    $0x18,%eax
  800a55:	89 d6                	mov    %edx,%esi
  800a57:	c1 e6 10             	shl    $0x10,%esi
  800a5a:	09 f0                	or     %esi,%eax
  800a5c:	09 c2                	or     %eax,%edx
  800a5e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a60:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a63:	89 d0                	mov    %edx,%eax
  800a65:	fc                   	cld    
  800a66:	f3 ab                	rep stos %eax,%es:(%edi)
  800a68:	eb 06                	jmp    800a70 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6d:	fc                   	cld    
  800a6e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a70:	89 f8                	mov    %edi,%eax
  800a72:	5b                   	pop    %ebx
  800a73:	5e                   	pop    %esi
  800a74:	5f                   	pop    %edi
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	57                   	push   %edi
  800a7b:	56                   	push   %esi
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a82:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a85:	39 c6                	cmp    %eax,%esi
  800a87:	73 32                	jae    800abb <memmove+0x44>
  800a89:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a8c:	39 c2                	cmp    %eax,%edx
  800a8e:	76 2b                	jbe    800abb <memmove+0x44>
		s += n;
		d += n;
  800a90:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a93:	89 fe                	mov    %edi,%esi
  800a95:	09 ce                	or     %ecx,%esi
  800a97:	09 d6                	or     %edx,%esi
  800a99:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9f:	75 0e                	jne    800aaf <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa1:	83 ef 04             	sub    $0x4,%edi
  800aa4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aaa:	fd                   	std    
  800aab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aad:	eb 09                	jmp    800ab8 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aaf:	83 ef 01             	sub    $0x1,%edi
  800ab2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ab5:	fd                   	std    
  800ab6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab8:	fc                   	cld    
  800ab9:	eb 1a                	jmp    800ad5 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abb:	89 c2                	mov    %eax,%edx
  800abd:	09 ca                	or     %ecx,%edx
  800abf:	09 f2                	or     %esi,%edx
  800ac1:	f6 c2 03             	test   $0x3,%dl
  800ac4:	75 0a                	jne    800ad0 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac9:	89 c7                	mov    %eax,%edi
  800acb:	fc                   	cld    
  800acc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ace:	eb 05                	jmp    800ad5 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ad0:	89 c7                	mov    %eax,%edi
  800ad2:	fc                   	cld    
  800ad3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad5:	5e                   	pop    %esi
  800ad6:	5f                   	pop    %edi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800adf:	ff 75 10             	pushl  0x10(%ebp)
  800ae2:	ff 75 0c             	pushl  0xc(%ebp)
  800ae5:	ff 75 08             	pushl  0x8(%ebp)
  800ae8:	e8 8a ff ff ff       	call   800a77 <memmove>
}
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	56                   	push   %esi
  800af3:	53                   	push   %ebx
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afa:	89 c6                	mov    %eax,%esi
  800afc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aff:	39 f0                	cmp    %esi,%eax
  800b01:	74 1c                	je     800b1f <memcmp+0x30>
		if (*s1 != *s2)
  800b03:	0f b6 08             	movzbl (%eax),%ecx
  800b06:	0f b6 1a             	movzbl (%edx),%ebx
  800b09:	38 d9                	cmp    %bl,%cl
  800b0b:	75 08                	jne    800b15 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b0d:	83 c0 01             	add    $0x1,%eax
  800b10:	83 c2 01             	add    $0x1,%edx
  800b13:	eb ea                	jmp    800aff <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b15:	0f b6 c1             	movzbl %cl,%eax
  800b18:	0f b6 db             	movzbl %bl,%ebx
  800b1b:	29 d8                	sub    %ebx,%eax
  800b1d:	eb 05                	jmp    800b24 <memcmp+0x35>
	}

	return 0;
  800b1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b31:	89 c2                	mov    %eax,%edx
  800b33:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b36:	39 d0                	cmp    %edx,%eax
  800b38:	73 09                	jae    800b43 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b3a:	38 08                	cmp    %cl,(%eax)
  800b3c:	74 05                	je     800b43 <memfind+0x1b>
	for (; s < ends; s++)
  800b3e:	83 c0 01             	add    $0x1,%eax
  800b41:	eb f3                	jmp    800b36 <memfind+0xe>
			break;
	return (void *) s;
}
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	57                   	push   %edi
  800b49:	56                   	push   %esi
  800b4a:	53                   	push   %ebx
  800b4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b51:	eb 03                	jmp    800b56 <strtol+0x11>
		s++;
  800b53:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b56:	0f b6 01             	movzbl (%ecx),%eax
  800b59:	3c 20                	cmp    $0x20,%al
  800b5b:	74 f6                	je     800b53 <strtol+0xe>
  800b5d:	3c 09                	cmp    $0x9,%al
  800b5f:	74 f2                	je     800b53 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b61:	3c 2b                	cmp    $0x2b,%al
  800b63:	74 2a                	je     800b8f <strtol+0x4a>
	int neg = 0;
  800b65:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b6a:	3c 2d                	cmp    $0x2d,%al
  800b6c:	74 2b                	je     800b99 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b74:	75 0f                	jne    800b85 <strtol+0x40>
  800b76:	80 39 30             	cmpb   $0x30,(%ecx)
  800b79:	74 28                	je     800ba3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b7b:	85 db                	test   %ebx,%ebx
  800b7d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b82:	0f 44 d8             	cmove  %eax,%ebx
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b8d:	eb 50                	jmp    800bdf <strtol+0x9a>
		s++;
  800b8f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b92:	bf 00 00 00 00       	mov    $0x0,%edi
  800b97:	eb d5                	jmp    800b6e <strtol+0x29>
		s++, neg = 1;
  800b99:	83 c1 01             	add    $0x1,%ecx
  800b9c:	bf 01 00 00 00       	mov    $0x1,%edi
  800ba1:	eb cb                	jmp    800b6e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ba7:	74 0e                	je     800bb7 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ba9:	85 db                	test   %ebx,%ebx
  800bab:	75 d8                	jne    800b85 <strtol+0x40>
		s++, base = 8;
  800bad:	83 c1 01             	add    $0x1,%ecx
  800bb0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bb5:	eb ce                	jmp    800b85 <strtol+0x40>
		s += 2, base = 16;
  800bb7:	83 c1 02             	add    $0x2,%ecx
  800bba:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bbf:	eb c4                	jmp    800b85 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bc1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bc4:	89 f3                	mov    %esi,%ebx
  800bc6:	80 fb 19             	cmp    $0x19,%bl
  800bc9:	77 29                	ja     800bf4 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bcb:	0f be d2             	movsbl %dl,%edx
  800bce:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bd1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bd4:	7d 30                	jge    800c06 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bd6:	83 c1 01             	add    $0x1,%ecx
  800bd9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bdd:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bdf:	0f b6 11             	movzbl (%ecx),%edx
  800be2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800be5:	89 f3                	mov    %esi,%ebx
  800be7:	80 fb 09             	cmp    $0x9,%bl
  800bea:	77 d5                	ja     800bc1 <strtol+0x7c>
			dig = *s - '0';
  800bec:	0f be d2             	movsbl %dl,%edx
  800bef:	83 ea 30             	sub    $0x30,%edx
  800bf2:	eb dd                	jmp    800bd1 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bf4:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bf7:	89 f3                	mov    %esi,%ebx
  800bf9:	80 fb 19             	cmp    $0x19,%bl
  800bfc:	77 08                	ja     800c06 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bfe:	0f be d2             	movsbl %dl,%edx
  800c01:	83 ea 37             	sub    $0x37,%edx
  800c04:	eb cb                	jmp    800bd1 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0a:	74 05                	je     800c11 <strtol+0xcc>
		*endptr = (char *) s;
  800c0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c0f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c11:	89 c2                	mov    %eax,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	85 ff                	test   %edi,%edi
  800c17:	0f 45 c2             	cmovne %edx,%eax
}
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5f                   	pop    %edi
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	57                   	push   %edi
  800c23:	56                   	push   %esi
  800c24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c25:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c30:	89 c3                	mov    %eax,%ebx
  800c32:	89 c7                	mov    %eax,%edi
  800c34:	89 c6                	mov    %eax,%esi
  800c36:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5f                   	pop    %edi
  800c3b:	5d                   	pop    %ebp
  800c3c:	c3                   	ret    

00800c3d <sys_cgetc>:

int
sys_cgetc(void)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	57                   	push   %edi
  800c41:	56                   	push   %esi
  800c42:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c43:	ba 00 00 00 00       	mov    $0x0,%edx
  800c48:	b8 01 00 00 00       	mov    $0x1,%eax
  800c4d:	89 d1                	mov    %edx,%ecx
  800c4f:	89 d3                	mov    %edx,%ebx
  800c51:	89 d7                	mov    %edx,%edi
  800c53:	89 d6                	mov    %edx,%esi
  800c55:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c57:	5b                   	pop    %ebx
  800c58:	5e                   	pop    %esi
  800c59:	5f                   	pop    %edi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
  800c62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c65:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6d:	b8 03 00 00 00       	mov    $0x3,%eax
  800c72:	89 cb                	mov    %ecx,%ebx
  800c74:	89 cf                	mov    %ecx,%edi
  800c76:	89 ce                	mov    %ecx,%esi
  800c78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7a:	85 c0                	test   %eax,%eax
  800c7c:	7f 08                	jg     800c86 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c86:	83 ec 0c             	sub    $0xc,%esp
  800c89:	50                   	push   %eax
  800c8a:	6a 03                	push   $0x3
  800c8c:	68 bf 27 80 00       	push   $0x8027bf
  800c91:	6a 23                	push   $0x23
  800c93:	68 dc 27 80 00       	push   $0x8027dc
  800c98:	e8 95 f5 ff ff       	call   800232 <_panic>

00800c9d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca8:	b8 02 00 00 00       	mov    $0x2,%eax
  800cad:	89 d1                	mov    %edx,%ecx
  800caf:	89 d3                	mov    %edx,%ebx
  800cb1:	89 d7                	mov    %edx,%edi
  800cb3:	89 d6                	mov    %edx,%esi
  800cb5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <sys_yield>:

void
sys_yield(void)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	57                   	push   %edi
  800cc0:	56                   	push   %esi
  800cc1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ccc:	89 d1                	mov    %edx,%ecx
  800cce:	89 d3                	mov    %edx,%ebx
  800cd0:	89 d7                	mov    %edx,%edi
  800cd2:	89 d6                	mov    %edx,%esi
  800cd4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cd6:	5b                   	pop    %ebx
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	57                   	push   %edi
  800cdf:	56                   	push   %esi
  800ce0:	53                   	push   %ebx
  800ce1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce4:	be 00 00 00 00       	mov    $0x0,%esi
  800ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cef:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf7:	89 f7                	mov    %esi,%edi
  800cf9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfb:	85 c0                	test   %eax,%eax
  800cfd:	7f 08                	jg     800d07 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d07:	83 ec 0c             	sub    $0xc,%esp
  800d0a:	50                   	push   %eax
  800d0b:	6a 04                	push   $0x4
  800d0d:	68 bf 27 80 00       	push   $0x8027bf
  800d12:	6a 23                	push   $0x23
  800d14:	68 dc 27 80 00       	push   $0x8027dc
  800d19:	e8 14 f5 ff ff       	call   800232 <_panic>

00800d1e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
  800d24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d27:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d35:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d38:	8b 75 18             	mov    0x18(%ebp),%esi
  800d3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	7f 08                	jg     800d49 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	50                   	push   %eax
  800d4d:	6a 05                	push   $0x5
  800d4f:	68 bf 27 80 00       	push   $0x8027bf
  800d54:	6a 23                	push   $0x23
  800d56:	68 dc 27 80 00       	push   $0x8027dc
  800d5b:	e8 d2 f4 ff ff       	call   800232 <_panic>

00800d60 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	57                   	push   %edi
  800d64:	56                   	push   %esi
  800d65:	53                   	push   %ebx
  800d66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d74:	b8 06 00 00 00       	mov    $0x6,%eax
  800d79:	89 df                	mov    %ebx,%edi
  800d7b:	89 de                	mov    %ebx,%esi
  800d7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	7f 08                	jg     800d8b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d86:	5b                   	pop    %ebx
  800d87:	5e                   	pop    %esi
  800d88:	5f                   	pop    %edi
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8b:	83 ec 0c             	sub    $0xc,%esp
  800d8e:	50                   	push   %eax
  800d8f:	6a 06                	push   $0x6
  800d91:	68 bf 27 80 00       	push   $0x8027bf
  800d96:	6a 23                	push   $0x23
  800d98:	68 dc 27 80 00       	push   $0x8027dc
  800d9d:	e8 90 f4 ff ff       	call   800232 <_panic>

00800da2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	57                   	push   %edi
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
  800da8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db6:	b8 08 00 00 00       	mov    $0x8,%eax
  800dbb:	89 df                	mov    %ebx,%edi
  800dbd:	89 de                	mov    %ebx,%esi
  800dbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc1:	85 c0                	test   %eax,%eax
  800dc3:	7f 08                	jg     800dcd <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5f                   	pop    %edi
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcd:	83 ec 0c             	sub    $0xc,%esp
  800dd0:	50                   	push   %eax
  800dd1:	6a 08                	push   $0x8
  800dd3:	68 bf 27 80 00       	push   $0x8027bf
  800dd8:	6a 23                	push   $0x23
  800dda:	68 dc 27 80 00       	push   $0x8027dc
  800ddf:	e8 4e f4 ff ff       	call   800232 <_panic>

00800de4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	57                   	push   %edi
  800de8:	56                   	push   %esi
  800de9:	53                   	push   %ebx
  800dea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ded:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df2:	8b 55 08             	mov    0x8(%ebp),%edx
  800df5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df8:	b8 09 00 00 00       	mov    $0x9,%eax
  800dfd:	89 df                	mov    %ebx,%edi
  800dff:	89 de                	mov    %ebx,%esi
  800e01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e03:	85 c0                	test   %eax,%eax
  800e05:	7f 08                	jg     800e0f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0a:	5b                   	pop    %ebx
  800e0b:	5e                   	pop    %esi
  800e0c:	5f                   	pop    %edi
  800e0d:	5d                   	pop    %ebp
  800e0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0f:	83 ec 0c             	sub    $0xc,%esp
  800e12:	50                   	push   %eax
  800e13:	6a 09                	push   $0x9
  800e15:	68 bf 27 80 00       	push   $0x8027bf
  800e1a:	6a 23                	push   $0x23
  800e1c:	68 dc 27 80 00       	push   $0x8027dc
  800e21:	e8 0c f4 ff ff       	call   800232 <_panic>

00800e26 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	57                   	push   %edi
  800e2a:	56                   	push   %esi
  800e2b:	53                   	push   %ebx
  800e2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e34:	8b 55 08             	mov    0x8(%ebp),%edx
  800e37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e3f:	89 df                	mov    %ebx,%edi
  800e41:	89 de                	mov    %ebx,%esi
  800e43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e45:	85 c0                	test   %eax,%eax
  800e47:	7f 08                	jg     800e51 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4c:	5b                   	pop    %ebx
  800e4d:	5e                   	pop    %esi
  800e4e:	5f                   	pop    %edi
  800e4f:	5d                   	pop    %ebp
  800e50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e51:	83 ec 0c             	sub    $0xc,%esp
  800e54:	50                   	push   %eax
  800e55:	6a 0a                	push   $0xa
  800e57:	68 bf 27 80 00       	push   $0x8027bf
  800e5c:	6a 23                	push   $0x23
  800e5e:	68 dc 27 80 00       	push   $0x8027dc
  800e63:	e8 ca f3 ff ff       	call   800232 <_panic>

00800e68 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	57                   	push   %edi
  800e6c:	56                   	push   %esi
  800e6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e74:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e79:	be 00 00 00 00       	mov    $0x0,%esi
  800e7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e81:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e84:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5f                   	pop    %edi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    

00800e8b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	57                   	push   %edi
  800e8f:	56                   	push   %esi
  800e90:	53                   	push   %ebx
  800e91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e94:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ea1:	89 cb                	mov    %ecx,%ebx
  800ea3:	89 cf                	mov    %ecx,%edi
  800ea5:	89 ce                	mov    %ecx,%esi
  800ea7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	7f 08                	jg     800eb5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb5:	83 ec 0c             	sub    $0xc,%esp
  800eb8:	50                   	push   %eax
  800eb9:	6a 0d                	push   $0xd
  800ebb:	68 bf 27 80 00       	push   $0x8027bf
  800ec0:	6a 23                	push   $0x23
  800ec2:	68 dc 27 80 00       	push   $0x8027dc
  800ec7:	e8 66 f3 ff ff       	call   800232 <_panic>

00800ecc <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed7:	b8 0e 00 00 00       	mov    $0xe,%eax
  800edc:	89 d1                	mov    %edx,%ecx
  800ede:	89 d3                	mov    %edx,%ebx
  800ee0:	89 d7                	mov    %edx,%edi
  800ee2:	89 d6                	mov    %edx,%esi
  800ee4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    

00800eeb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	05 00 00 00 30       	add    $0x30000000,%eax
  800ef6:	c1 e8 0c             	shr    $0xc,%eax
}
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f0b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    

00800f12 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f1a:	89 c2                	mov    %eax,%edx
  800f1c:	c1 ea 16             	shr    $0x16,%edx
  800f1f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f26:	f6 c2 01             	test   $0x1,%dl
  800f29:	74 2d                	je     800f58 <fd_alloc+0x46>
  800f2b:	89 c2                	mov    %eax,%edx
  800f2d:	c1 ea 0c             	shr    $0xc,%edx
  800f30:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f37:	f6 c2 01             	test   $0x1,%dl
  800f3a:	74 1c                	je     800f58 <fd_alloc+0x46>
  800f3c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f41:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f46:	75 d2                	jne    800f1a <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f51:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f56:	eb 0a                	jmp    800f62 <fd_alloc+0x50>
			*fd_store = fd;
  800f58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f5b:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    

00800f64 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f6a:	83 f8 1f             	cmp    $0x1f,%eax
  800f6d:	77 30                	ja     800f9f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f6f:	c1 e0 0c             	shl    $0xc,%eax
  800f72:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f77:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f7d:	f6 c2 01             	test   $0x1,%dl
  800f80:	74 24                	je     800fa6 <fd_lookup+0x42>
  800f82:	89 c2                	mov    %eax,%edx
  800f84:	c1 ea 0c             	shr    $0xc,%edx
  800f87:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f8e:	f6 c2 01             	test   $0x1,%dl
  800f91:	74 1a                	je     800fad <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f96:	89 02                	mov    %eax,(%edx)
	return 0;
  800f98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9d:	5d                   	pop    %ebp
  800f9e:	c3                   	ret    
		return -E_INVAL;
  800f9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fa4:	eb f7                	jmp    800f9d <fd_lookup+0x39>
		return -E_INVAL;
  800fa6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fab:	eb f0                	jmp    800f9d <fd_lookup+0x39>
  800fad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fb2:	eb e9                	jmp    800f9d <fd_lookup+0x39>

00800fb4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	83 ec 08             	sub    $0x8,%esp
  800fba:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800fbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc2:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fc7:	39 08                	cmp    %ecx,(%eax)
  800fc9:	74 38                	je     801003 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800fcb:	83 c2 01             	add    $0x1,%edx
  800fce:	8b 04 95 68 28 80 00 	mov    0x802868(,%edx,4),%eax
  800fd5:	85 c0                	test   %eax,%eax
  800fd7:	75 ee                	jne    800fc7 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fd9:	a1 08 40 80 00       	mov    0x804008,%eax
  800fde:	8b 40 48             	mov    0x48(%eax),%eax
  800fe1:	83 ec 04             	sub    $0x4,%esp
  800fe4:	51                   	push   %ecx
  800fe5:	50                   	push   %eax
  800fe6:	68 ec 27 80 00       	push   $0x8027ec
  800feb:	e8 1d f3 ff ff       	call   80030d <cprintf>
	*dev = 0;
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ff9:	83 c4 10             	add    $0x10,%esp
  800ffc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801001:	c9                   	leave  
  801002:	c3                   	ret    
			*dev = devtab[i];
  801003:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801006:	89 01                	mov    %eax,(%ecx)
			return 0;
  801008:	b8 00 00 00 00       	mov    $0x0,%eax
  80100d:	eb f2                	jmp    801001 <dev_lookup+0x4d>

0080100f <fd_close>:
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	57                   	push   %edi
  801013:	56                   	push   %esi
  801014:	53                   	push   %ebx
  801015:	83 ec 24             	sub    $0x24,%esp
  801018:	8b 75 08             	mov    0x8(%ebp),%esi
  80101b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80101e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801021:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801022:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801028:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80102b:	50                   	push   %eax
  80102c:	e8 33 ff ff ff       	call   800f64 <fd_lookup>
  801031:	89 c3                	mov    %eax,%ebx
  801033:	83 c4 10             	add    $0x10,%esp
  801036:	85 c0                	test   %eax,%eax
  801038:	78 05                	js     80103f <fd_close+0x30>
	    || fd != fd2)
  80103a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80103d:	74 16                	je     801055 <fd_close+0x46>
		return (must_exist ? r : 0);
  80103f:	89 f8                	mov    %edi,%eax
  801041:	84 c0                	test   %al,%al
  801043:	b8 00 00 00 00       	mov    $0x0,%eax
  801048:	0f 44 d8             	cmove  %eax,%ebx
}
  80104b:	89 d8                	mov    %ebx,%eax
  80104d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801050:	5b                   	pop    %ebx
  801051:	5e                   	pop    %esi
  801052:	5f                   	pop    %edi
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801055:	83 ec 08             	sub    $0x8,%esp
  801058:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80105b:	50                   	push   %eax
  80105c:	ff 36                	pushl  (%esi)
  80105e:	e8 51 ff ff ff       	call   800fb4 <dev_lookup>
  801063:	89 c3                	mov    %eax,%ebx
  801065:	83 c4 10             	add    $0x10,%esp
  801068:	85 c0                	test   %eax,%eax
  80106a:	78 1a                	js     801086 <fd_close+0x77>
		if (dev->dev_close)
  80106c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80106f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801072:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801077:	85 c0                	test   %eax,%eax
  801079:	74 0b                	je     801086 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80107b:	83 ec 0c             	sub    $0xc,%esp
  80107e:	56                   	push   %esi
  80107f:	ff d0                	call   *%eax
  801081:	89 c3                	mov    %eax,%ebx
  801083:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	56                   	push   %esi
  80108a:	6a 00                	push   $0x0
  80108c:	e8 cf fc ff ff       	call   800d60 <sys_page_unmap>
	return r;
  801091:	83 c4 10             	add    $0x10,%esp
  801094:	eb b5                	jmp    80104b <fd_close+0x3c>

00801096 <close>:

int
close(int fdnum)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80109c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80109f:	50                   	push   %eax
  8010a0:	ff 75 08             	pushl  0x8(%ebp)
  8010a3:	e8 bc fe ff ff       	call   800f64 <fd_lookup>
  8010a8:	83 c4 10             	add    $0x10,%esp
  8010ab:	85 c0                	test   %eax,%eax
  8010ad:	79 02                	jns    8010b1 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8010af:	c9                   	leave  
  8010b0:	c3                   	ret    
		return fd_close(fd, 1);
  8010b1:	83 ec 08             	sub    $0x8,%esp
  8010b4:	6a 01                	push   $0x1
  8010b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b9:	e8 51 ff ff ff       	call   80100f <fd_close>
  8010be:	83 c4 10             	add    $0x10,%esp
  8010c1:	eb ec                	jmp    8010af <close+0x19>

008010c3 <close_all>:

void
close_all(void)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	53                   	push   %ebx
  8010c7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010ca:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010cf:	83 ec 0c             	sub    $0xc,%esp
  8010d2:	53                   	push   %ebx
  8010d3:	e8 be ff ff ff       	call   801096 <close>
	for (i = 0; i < MAXFD; i++)
  8010d8:	83 c3 01             	add    $0x1,%ebx
  8010db:	83 c4 10             	add    $0x10,%esp
  8010de:	83 fb 20             	cmp    $0x20,%ebx
  8010e1:	75 ec                	jne    8010cf <close_all+0xc>
}
  8010e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    

008010e8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	57                   	push   %edi
  8010ec:	56                   	push   %esi
  8010ed:	53                   	push   %ebx
  8010ee:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010f4:	50                   	push   %eax
  8010f5:	ff 75 08             	pushl  0x8(%ebp)
  8010f8:	e8 67 fe ff ff       	call   800f64 <fd_lookup>
  8010fd:	89 c3                	mov    %eax,%ebx
  8010ff:	83 c4 10             	add    $0x10,%esp
  801102:	85 c0                	test   %eax,%eax
  801104:	0f 88 81 00 00 00    	js     80118b <dup+0xa3>
		return r;
	close(newfdnum);
  80110a:	83 ec 0c             	sub    $0xc,%esp
  80110d:	ff 75 0c             	pushl  0xc(%ebp)
  801110:	e8 81 ff ff ff       	call   801096 <close>

	newfd = INDEX2FD(newfdnum);
  801115:	8b 75 0c             	mov    0xc(%ebp),%esi
  801118:	c1 e6 0c             	shl    $0xc,%esi
  80111b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801121:	83 c4 04             	add    $0x4,%esp
  801124:	ff 75 e4             	pushl  -0x1c(%ebp)
  801127:	e8 cf fd ff ff       	call   800efb <fd2data>
  80112c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80112e:	89 34 24             	mov    %esi,(%esp)
  801131:	e8 c5 fd ff ff       	call   800efb <fd2data>
  801136:	83 c4 10             	add    $0x10,%esp
  801139:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80113b:	89 d8                	mov    %ebx,%eax
  80113d:	c1 e8 16             	shr    $0x16,%eax
  801140:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801147:	a8 01                	test   $0x1,%al
  801149:	74 11                	je     80115c <dup+0x74>
  80114b:	89 d8                	mov    %ebx,%eax
  80114d:	c1 e8 0c             	shr    $0xc,%eax
  801150:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801157:	f6 c2 01             	test   $0x1,%dl
  80115a:	75 39                	jne    801195 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80115c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80115f:	89 d0                	mov    %edx,%eax
  801161:	c1 e8 0c             	shr    $0xc,%eax
  801164:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80116b:	83 ec 0c             	sub    $0xc,%esp
  80116e:	25 07 0e 00 00       	and    $0xe07,%eax
  801173:	50                   	push   %eax
  801174:	56                   	push   %esi
  801175:	6a 00                	push   $0x0
  801177:	52                   	push   %edx
  801178:	6a 00                	push   $0x0
  80117a:	e8 9f fb ff ff       	call   800d1e <sys_page_map>
  80117f:	89 c3                	mov    %eax,%ebx
  801181:	83 c4 20             	add    $0x20,%esp
  801184:	85 c0                	test   %eax,%eax
  801186:	78 31                	js     8011b9 <dup+0xd1>
		goto err;

	return newfdnum;
  801188:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80118b:	89 d8                	mov    %ebx,%eax
  80118d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801190:	5b                   	pop    %ebx
  801191:	5e                   	pop    %esi
  801192:	5f                   	pop    %edi
  801193:	5d                   	pop    %ebp
  801194:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801195:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80119c:	83 ec 0c             	sub    $0xc,%esp
  80119f:	25 07 0e 00 00       	and    $0xe07,%eax
  8011a4:	50                   	push   %eax
  8011a5:	57                   	push   %edi
  8011a6:	6a 00                	push   $0x0
  8011a8:	53                   	push   %ebx
  8011a9:	6a 00                	push   $0x0
  8011ab:	e8 6e fb ff ff       	call   800d1e <sys_page_map>
  8011b0:	89 c3                	mov    %eax,%ebx
  8011b2:	83 c4 20             	add    $0x20,%esp
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	79 a3                	jns    80115c <dup+0x74>
	sys_page_unmap(0, newfd);
  8011b9:	83 ec 08             	sub    $0x8,%esp
  8011bc:	56                   	push   %esi
  8011bd:	6a 00                	push   $0x0
  8011bf:	e8 9c fb ff ff       	call   800d60 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011c4:	83 c4 08             	add    $0x8,%esp
  8011c7:	57                   	push   %edi
  8011c8:	6a 00                	push   $0x0
  8011ca:	e8 91 fb ff ff       	call   800d60 <sys_page_unmap>
	return r;
  8011cf:	83 c4 10             	add    $0x10,%esp
  8011d2:	eb b7                	jmp    80118b <dup+0xa3>

008011d4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
  8011d7:	53                   	push   %ebx
  8011d8:	83 ec 1c             	sub    $0x1c,%esp
  8011db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011e1:	50                   	push   %eax
  8011e2:	53                   	push   %ebx
  8011e3:	e8 7c fd ff ff       	call   800f64 <fd_lookup>
  8011e8:	83 c4 10             	add    $0x10,%esp
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	78 3f                	js     80122e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011ef:	83 ec 08             	sub    $0x8,%esp
  8011f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011f5:	50                   	push   %eax
  8011f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f9:	ff 30                	pushl  (%eax)
  8011fb:	e8 b4 fd ff ff       	call   800fb4 <dev_lookup>
  801200:	83 c4 10             	add    $0x10,%esp
  801203:	85 c0                	test   %eax,%eax
  801205:	78 27                	js     80122e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801207:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80120a:	8b 42 08             	mov    0x8(%edx),%eax
  80120d:	83 e0 03             	and    $0x3,%eax
  801210:	83 f8 01             	cmp    $0x1,%eax
  801213:	74 1e                	je     801233 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801218:	8b 40 08             	mov    0x8(%eax),%eax
  80121b:	85 c0                	test   %eax,%eax
  80121d:	74 35                	je     801254 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	ff 75 10             	pushl  0x10(%ebp)
  801225:	ff 75 0c             	pushl  0xc(%ebp)
  801228:	52                   	push   %edx
  801229:	ff d0                	call   *%eax
  80122b:	83 c4 10             	add    $0x10,%esp
}
  80122e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801231:	c9                   	leave  
  801232:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801233:	a1 08 40 80 00       	mov    0x804008,%eax
  801238:	8b 40 48             	mov    0x48(%eax),%eax
  80123b:	83 ec 04             	sub    $0x4,%esp
  80123e:	53                   	push   %ebx
  80123f:	50                   	push   %eax
  801240:	68 2d 28 80 00       	push   $0x80282d
  801245:	e8 c3 f0 ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  80124a:	83 c4 10             	add    $0x10,%esp
  80124d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801252:	eb da                	jmp    80122e <read+0x5a>
		return -E_NOT_SUPP;
  801254:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801259:	eb d3                	jmp    80122e <read+0x5a>

0080125b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	57                   	push   %edi
  80125f:	56                   	push   %esi
  801260:	53                   	push   %ebx
  801261:	83 ec 0c             	sub    $0xc,%esp
  801264:	8b 7d 08             	mov    0x8(%ebp),%edi
  801267:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80126a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80126f:	39 f3                	cmp    %esi,%ebx
  801271:	73 23                	jae    801296 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801273:	83 ec 04             	sub    $0x4,%esp
  801276:	89 f0                	mov    %esi,%eax
  801278:	29 d8                	sub    %ebx,%eax
  80127a:	50                   	push   %eax
  80127b:	89 d8                	mov    %ebx,%eax
  80127d:	03 45 0c             	add    0xc(%ebp),%eax
  801280:	50                   	push   %eax
  801281:	57                   	push   %edi
  801282:	e8 4d ff ff ff       	call   8011d4 <read>
		if (m < 0)
  801287:	83 c4 10             	add    $0x10,%esp
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 06                	js     801294 <readn+0x39>
			return m;
		if (m == 0)
  80128e:	74 06                	je     801296 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801290:	01 c3                	add    %eax,%ebx
  801292:	eb db                	jmp    80126f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801294:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801296:	89 d8                	mov    %ebx,%eax
  801298:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129b:	5b                   	pop    %ebx
  80129c:	5e                   	pop    %esi
  80129d:	5f                   	pop    %edi
  80129e:	5d                   	pop    %ebp
  80129f:	c3                   	ret    

008012a0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	53                   	push   %ebx
  8012a4:	83 ec 1c             	sub    $0x1c,%esp
  8012a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ad:	50                   	push   %eax
  8012ae:	53                   	push   %ebx
  8012af:	e8 b0 fc ff ff       	call   800f64 <fd_lookup>
  8012b4:	83 c4 10             	add    $0x10,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	78 3a                	js     8012f5 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012bb:	83 ec 08             	sub    $0x8,%esp
  8012be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c1:	50                   	push   %eax
  8012c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c5:	ff 30                	pushl  (%eax)
  8012c7:	e8 e8 fc ff ff       	call   800fb4 <dev_lookup>
  8012cc:	83 c4 10             	add    $0x10,%esp
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	78 22                	js     8012f5 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012da:	74 1e                	je     8012fa <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012df:	8b 52 0c             	mov    0xc(%edx),%edx
  8012e2:	85 d2                	test   %edx,%edx
  8012e4:	74 35                	je     80131b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012e6:	83 ec 04             	sub    $0x4,%esp
  8012e9:	ff 75 10             	pushl  0x10(%ebp)
  8012ec:	ff 75 0c             	pushl  0xc(%ebp)
  8012ef:	50                   	push   %eax
  8012f0:	ff d2                	call   *%edx
  8012f2:	83 c4 10             	add    $0x10,%esp
}
  8012f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012fa:	a1 08 40 80 00       	mov    0x804008,%eax
  8012ff:	8b 40 48             	mov    0x48(%eax),%eax
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	53                   	push   %ebx
  801306:	50                   	push   %eax
  801307:	68 49 28 80 00       	push   $0x802849
  80130c:	e8 fc ef ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801319:	eb da                	jmp    8012f5 <write+0x55>
		return -E_NOT_SUPP;
  80131b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801320:	eb d3                	jmp    8012f5 <write+0x55>

00801322 <seek>:

int
seek(int fdnum, off_t offset)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801328:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80132b:	50                   	push   %eax
  80132c:	ff 75 08             	pushl  0x8(%ebp)
  80132f:	e8 30 fc ff ff       	call   800f64 <fd_lookup>
  801334:	83 c4 10             	add    $0x10,%esp
  801337:	85 c0                	test   %eax,%eax
  801339:	78 0e                	js     801349 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80133b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801341:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801344:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	53                   	push   %ebx
  80134f:	83 ec 1c             	sub    $0x1c,%esp
  801352:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801355:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801358:	50                   	push   %eax
  801359:	53                   	push   %ebx
  80135a:	e8 05 fc ff ff       	call   800f64 <fd_lookup>
  80135f:	83 c4 10             	add    $0x10,%esp
  801362:	85 c0                	test   %eax,%eax
  801364:	78 37                	js     80139d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801366:	83 ec 08             	sub    $0x8,%esp
  801369:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136c:	50                   	push   %eax
  80136d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801370:	ff 30                	pushl  (%eax)
  801372:	e8 3d fc ff ff       	call   800fb4 <dev_lookup>
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	85 c0                	test   %eax,%eax
  80137c:	78 1f                	js     80139d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80137e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801381:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801385:	74 1b                	je     8013a2 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801387:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138a:	8b 52 18             	mov    0x18(%edx),%edx
  80138d:	85 d2                	test   %edx,%edx
  80138f:	74 32                	je     8013c3 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801391:	83 ec 08             	sub    $0x8,%esp
  801394:	ff 75 0c             	pushl  0xc(%ebp)
  801397:	50                   	push   %eax
  801398:	ff d2                	call   *%edx
  80139a:	83 c4 10             	add    $0x10,%esp
}
  80139d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013a2:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013a7:	8b 40 48             	mov    0x48(%eax),%eax
  8013aa:	83 ec 04             	sub    $0x4,%esp
  8013ad:	53                   	push   %ebx
  8013ae:	50                   	push   %eax
  8013af:	68 0c 28 80 00       	push   $0x80280c
  8013b4:	e8 54 ef ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c1:	eb da                	jmp    80139d <ftruncate+0x52>
		return -E_NOT_SUPP;
  8013c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c8:	eb d3                	jmp    80139d <ftruncate+0x52>

008013ca <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	53                   	push   %ebx
  8013ce:	83 ec 1c             	sub    $0x1c,%esp
  8013d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d7:	50                   	push   %eax
  8013d8:	ff 75 08             	pushl  0x8(%ebp)
  8013db:	e8 84 fb ff ff       	call   800f64 <fd_lookup>
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	78 4b                	js     801432 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ed:	50                   	push   %eax
  8013ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f1:	ff 30                	pushl  (%eax)
  8013f3:	e8 bc fb ff ff       	call   800fb4 <dev_lookup>
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	78 33                	js     801432 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801402:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801406:	74 2f                	je     801437 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801408:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80140b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801412:	00 00 00 
	stat->st_isdir = 0;
  801415:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80141c:	00 00 00 
	stat->st_dev = dev;
  80141f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	53                   	push   %ebx
  801429:	ff 75 f0             	pushl  -0x10(%ebp)
  80142c:	ff 50 14             	call   *0x14(%eax)
  80142f:	83 c4 10             	add    $0x10,%esp
}
  801432:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801435:	c9                   	leave  
  801436:	c3                   	ret    
		return -E_NOT_SUPP;
  801437:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80143c:	eb f4                	jmp    801432 <fstat+0x68>

0080143e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	56                   	push   %esi
  801442:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801443:	83 ec 08             	sub    $0x8,%esp
  801446:	6a 00                	push   $0x0
  801448:	ff 75 08             	pushl  0x8(%ebp)
  80144b:	e8 2f 02 00 00       	call   80167f <open>
  801450:	89 c3                	mov    %eax,%ebx
  801452:	83 c4 10             	add    $0x10,%esp
  801455:	85 c0                	test   %eax,%eax
  801457:	78 1b                	js     801474 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	50                   	push   %eax
  801460:	e8 65 ff ff ff       	call   8013ca <fstat>
  801465:	89 c6                	mov    %eax,%esi
	close(fd);
  801467:	89 1c 24             	mov    %ebx,(%esp)
  80146a:	e8 27 fc ff ff       	call   801096 <close>
	return r;
  80146f:	83 c4 10             	add    $0x10,%esp
  801472:	89 f3                	mov    %esi,%ebx
}
  801474:	89 d8                	mov    %ebx,%eax
  801476:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801479:	5b                   	pop    %ebx
  80147a:	5e                   	pop    %esi
  80147b:	5d                   	pop    %ebp
  80147c:	c3                   	ret    

0080147d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	56                   	push   %esi
  801481:	53                   	push   %ebx
  801482:	89 c6                	mov    %eax,%esi
  801484:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801486:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80148d:	74 27                	je     8014b6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80148f:	6a 07                	push   $0x7
  801491:	68 00 50 80 00       	push   $0x805000
  801496:	56                   	push   %esi
  801497:	ff 35 00 40 80 00    	pushl  0x804000
  80149d:	e8 1f 0c 00 00       	call   8020c1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014a2:	83 c4 0c             	add    $0xc,%esp
  8014a5:	6a 00                	push   $0x0
  8014a7:	53                   	push   %ebx
  8014a8:	6a 00                	push   $0x0
  8014aa:	e8 9f 0b 00 00       	call   80204e <ipc_recv>
}
  8014af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b2:	5b                   	pop    %ebx
  8014b3:	5e                   	pop    %esi
  8014b4:	5d                   	pop    %ebp
  8014b5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014b6:	83 ec 0c             	sub    $0xc,%esp
  8014b9:	6a 01                	push   $0x1
  8014bb:	e8 6d 0c 00 00       	call   80212d <ipc_find_env>
  8014c0:	a3 00 40 80 00       	mov    %eax,0x804000
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	eb c5                	jmp    80148f <fsipc+0x12>

008014ca <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8014d6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014de:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e8:	b8 02 00 00 00       	mov    $0x2,%eax
  8014ed:	e8 8b ff ff ff       	call   80147d <fsipc>
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <devfile_flush>:
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801500:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801505:	ba 00 00 00 00       	mov    $0x0,%edx
  80150a:	b8 06 00 00 00       	mov    $0x6,%eax
  80150f:	e8 69 ff ff ff       	call   80147d <fsipc>
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <devfile_stat>:
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	53                   	push   %ebx
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	8b 40 0c             	mov    0xc(%eax),%eax
  801526:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80152b:	ba 00 00 00 00       	mov    $0x0,%edx
  801530:	b8 05 00 00 00       	mov    $0x5,%eax
  801535:	e8 43 ff ff ff       	call   80147d <fsipc>
  80153a:	85 c0                	test   %eax,%eax
  80153c:	78 2c                	js     80156a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	68 00 50 80 00       	push   $0x805000
  801546:	53                   	push   %ebx
  801547:	e8 9d f3 ff ff       	call   8008e9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80154c:	a1 80 50 80 00       	mov    0x805080,%eax
  801551:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801557:	a1 84 50 80 00       	mov    0x805084,%eax
  80155c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <devfile_write>:
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	53                   	push   %ebx
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801579:	85 db                	test   %ebx,%ebx
  80157b:	75 07                	jne    801584 <devfile_write+0x15>
	return n_all;
  80157d:	89 d8                	mov    %ebx,%eax
}
  80157f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801582:	c9                   	leave  
  801583:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	8b 40 0c             	mov    0xc(%eax),%eax
  80158a:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  80158f:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801595:	83 ec 04             	sub    $0x4,%esp
  801598:	53                   	push   %ebx
  801599:	ff 75 0c             	pushl  0xc(%ebp)
  80159c:	68 08 50 80 00       	push   $0x805008
  8015a1:	e8 d1 f4 ff ff       	call   800a77 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8015a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ab:	b8 04 00 00 00       	mov    $0x4,%eax
  8015b0:	e8 c8 fe ff ff       	call   80147d <fsipc>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	78 c3                	js     80157f <devfile_write+0x10>
	  assert(r <= n_left);
  8015bc:	39 d8                	cmp    %ebx,%eax
  8015be:	77 0b                	ja     8015cb <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  8015c0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015c5:	7f 1d                	jg     8015e4 <devfile_write+0x75>
    n_all += r;
  8015c7:	89 c3                	mov    %eax,%ebx
  8015c9:	eb b2                	jmp    80157d <devfile_write+0xe>
	  assert(r <= n_left);
  8015cb:	68 7c 28 80 00       	push   $0x80287c
  8015d0:	68 88 28 80 00       	push   $0x802888
  8015d5:	68 9f 00 00 00       	push   $0x9f
  8015da:	68 9d 28 80 00       	push   $0x80289d
  8015df:	e8 4e ec ff ff       	call   800232 <_panic>
	  assert(r <= PGSIZE);
  8015e4:	68 a8 28 80 00       	push   $0x8028a8
  8015e9:	68 88 28 80 00       	push   $0x802888
  8015ee:	68 a0 00 00 00       	push   $0xa0
  8015f3:	68 9d 28 80 00       	push   $0x80289d
  8015f8:	e8 35 ec ff ff       	call   800232 <_panic>

008015fd <devfile_read>:
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	56                   	push   %esi
  801601:	53                   	push   %ebx
  801602:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	8b 40 0c             	mov    0xc(%eax),%eax
  80160b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801610:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801616:	ba 00 00 00 00       	mov    $0x0,%edx
  80161b:	b8 03 00 00 00       	mov    $0x3,%eax
  801620:	e8 58 fe ff ff       	call   80147d <fsipc>
  801625:	89 c3                	mov    %eax,%ebx
  801627:	85 c0                	test   %eax,%eax
  801629:	78 1f                	js     80164a <devfile_read+0x4d>
	assert(r <= n);
  80162b:	39 f0                	cmp    %esi,%eax
  80162d:	77 24                	ja     801653 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80162f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801634:	7f 33                	jg     801669 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	50                   	push   %eax
  80163a:	68 00 50 80 00       	push   $0x805000
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	e8 30 f4 ff ff       	call   800a77 <memmove>
	return r;
  801647:	83 c4 10             	add    $0x10,%esp
}
  80164a:	89 d8                	mov    %ebx,%eax
  80164c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164f:	5b                   	pop    %ebx
  801650:	5e                   	pop    %esi
  801651:	5d                   	pop    %ebp
  801652:	c3                   	ret    
	assert(r <= n);
  801653:	68 b4 28 80 00       	push   $0x8028b4
  801658:	68 88 28 80 00       	push   $0x802888
  80165d:	6a 7c                	push   $0x7c
  80165f:	68 9d 28 80 00       	push   $0x80289d
  801664:	e8 c9 eb ff ff       	call   800232 <_panic>
	assert(r <= PGSIZE);
  801669:	68 a8 28 80 00       	push   $0x8028a8
  80166e:	68 88 28 80 00       	push   $0x802888
  801673:	6a 7d                	push   $0x7d
  801675:	68 9d 28 80 00       	push   $0x80289d
  80167a:	e8 b3 eb ff ff       	call   800232 <_panic>

0080167f <open>:
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	56                   	push   %esi
  801683:	53                   	push   %ebx
  801684:	83 ec 1c             	sub    $0x1c,%esp
  801687:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80168a:	56                   	push   %esi
  80168b:	e8 20 f2 ff ff       	call   8008b0 <strlen>
  801690:	83 c4 10             	add    $0x10,%esp
  801693:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801698:	7f 6c                	jg     801706 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80169a:	83 ec 0c             	sub    $0xc,%esp
  80169d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a0:	50                   	push   %eax
  8016a1:	e8 6c f8 ff ff       	call   800f12 <fd_alloc>
  8016a6:	89 c3                	mov    %eax,%ebx
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	78 3c                	js     8016eb <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016af:	83 ec 08             	sub    $0x8,%esp
  8016b2:	56                   	push   %esi
  8016b3:	68 00 50 80 00       	push   $0x805000
  8016b8:	e8 2c f2 ff ff       	call   8008e9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8016cd:	e8 ab fd ff ff       	call   80147d <fsipc>
  8016d2:	89 c3                	mov    %eax,%ebx
  8016d4:	83 c4 10             	add    $0x10,%esp
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	78 19                	js     8016f4 <open+0x75>
	return fd2num(fd);
  8016db:	83 ec 0c             	sub    $0xc,%esp
  8016de:	ff 75 f4             	pushl  -0xc(%ebp)
  8016e1:	e8 05 f8 ff ff       	call   800eeb <fd2num>
  8016e6:	89 c3                	mov    %eax,%ebx
  8016e8:	83 c4 10             	add    $0x10,%esp
}
  8016eb:	89 d8                	mov    %ebx,%eax
  8016ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f0:	5b                   	pop    %ebx
  8016f1:	5e                   	pop    %esi
  8016f2:	5d                   	pop    %ebp
  8016f3:	c3                   	ret    
		fd_close(fd, 0);
  8016f4:	83 ec 08             	sub    $0x8,%esp
  8016f7:	6a 00                	push   $0x0
  8016f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8016fc:	e8 0e f9 ff ff       	call   80100f <fd_close>
		return r;
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	eb e5                	jmp    8016eb <open+0x6c>
		return -E_BAD_PATH;
  801706:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80170b:	eb de                	jmp    8016eb <open+0x6c>

0080170d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801713:	ba 00 00 00 00       	mov    $0x0,%edx
  801718:	b8 08 00 00 00       	mov    $0x8,%eax
  80171d:	e8 5b fd ff ff       	call   80147d <fsipc>
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	56                   	push   %esi
  801728:	53                   	push   %ebx
  801729:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80172c:	83 ec 0c             	sub    $0xc,%esp
  80172f:	ff 75 08             	pushl  0x8(%ebp)
  801732:	e8 c4 f7 ff ff       	call   800efb <fd2data>
  801737:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801739:	83 c4 08             	add    $0x8,%esp
  80173c:	68 bb 28 80 00       	push   $0x8028bb
  801741:	53                   	push   %ebx
  801742:	e8 a2 f1 ff ff       	call   8008e9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801747:	8b 46 04             	mov    0x4(%esi),%eax
  80174a:	2b 06                	sub    (%esi),%eax
  80174c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801752:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801759:	00 00 00 
	stat->st_dev = &devpipe;
  80175c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801763:	30 80 00 
	return 0;
}
  801766:	b8 00 00 00 00       	mov    $0x0,%eax
  80176b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176e:	5b                   	pop    %ebx
  80176f:	5e                   	pop    %esi
  801770:	5d                   	pop    %ebp
  801771:	c3                   	ret    

00801772 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	53                   	push   %ebx
  801776:	83 ec 0c             	sub    $0xc,%esp
  801779:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80177c:	53                   	push   %ebx
  80177d:	6a 00                	push   $0x0
  80177f:	e8 dc f5 ff ff       	call   800d60 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801784:	89 1c 24             	mov    %ebx,(%esp)
  801787:	e8 6f f7 ff ff       	call   800efb <fd2data>
  80178c:	83 c4 08             	add    $0x8,%esp
  80178f:	50                   	push   %eax
  801790:	6a 00                	push   $0x0
  801792:	e8 c9 f5 ff ff       	call   800d60 <sys_page_unmap>
}
  801797:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <_pipeisclosed>:
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	57                   	push   %edi
  8017a0:	56                   	push   %esi
  8017a1:	53                   	push   %ebx
  8017a2:	83 ec 1c             	sub    $0x1c,%esp
  8017a5:	89 c7                	mov    %eax,%edi
  8017a7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8017a9:	a1 08 40 80 00       	mov    0x804008,%eax
  8017ae:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017b1:	83 ec 0c             	sub    $0xc,%esp
  8017b4:	57                   	push   %edi
  8017b5:	e8 ac 09 00 00       	call   802166 <pageref>
  8017ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017bd:	89 34 24             	mov    %esi,(%esp)
  8017c0:	e8 a1 09 00 00       	call   802166 <pageref>
		nn = thisenv->env_runs;
  8017c5:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8017cb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	39 cb                	cmp    %ecx,%ebx
  8017d3:	74 1b                	je     8017f0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8017d5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017d8:	75 cf                	jne    8017a9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8017da:	8b 42 58             	mov    0x58(%edx),%eax
  8017dd:	6a 01                	push   $0x1
  8017df:	50                   	push   %eax
  8017e0:	53                   	push   %ebx
  8017e1:	68 c2 28 80 00       	push   $0x8028c2
  8017e6:	e8 22 eb ff ff       	call   80030d <cprintf>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	eb b9                	jmp    8017a9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8017f0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017f3:	0f 94 c0             	sete   %al
  8017f6:	0f b6 c0             	movzbl %al,%eax
}
  8017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017fc:	5b                   	pop    %ebx
  8017fd:	5e                   	pop    %esi
  8017fe:	5f                   	pop    %edi
  8017ff:	5d                   	pop    %ebp
  801800:	c3                   	ret    

00801801 <devpipe_write>:
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	57                   	push   %edi
  801805:	56                   	push   %esi
  801806:	53                   	push   %ebx
  801807:	83 ec 28             	sub    $0x28,%esp
  80180a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80180d:	56                   	push   %esi
  80180e:	e8 e8 f6 ff ff       	call   800efb <fd2data>
  801813:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	bf 00 00 00 00       	mov    $0x0,%edi
  80181d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801820:	74 4f                	je     801871 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801822:	8b 43 04             	mov    0x4(%ebx),%eax
  801825:	8b 0b                	mov    (%ebx),%ecx
  801827:	8d 51 20             	lea    0x20(%ecx),%edx
  80182a:	39 d0                	cmp    %edx,%eax
  80182c:	72 14                	jb     801842 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80182e:	89 da                	mov    %ebx,%edx
  801830:	89 f0                	mov    %esi,%eax
  801832:	e8 65 ff ff ff       	call   80179c <_pipeisclosed>
  801837:	85 c0                	test   %eax,%eax
  801839:	75 3b                	jne    801876 <devpipe_write+0x75>
			sys_yield();
  80183b:	e8 7c f4 ff ff       	call   800cbc <sys_yield>
  801840:	eb e0                	jmp    801822 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801842:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801845:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801849:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80184c:	89 c2                	mov    %eax,%edx
  80184e:	c1 fa 1f             	sar    $0x1f,%edx
  801851:	89 d1                	mov    %edx,%ecx
  801853:	c1 e9 1b             	shr    $0x1b,%ecx
  801856:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801859:	83 e2 1f             	and    $0x1f,%edx
  80185c:	29 ca                	sub    %ecx,%edx
  80185e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801862:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801866:	83 c0 01             	add    $0x1,%eax
  801869:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80186c:	83 c7 01             	add    $0x1,%edi
  80186f:	eb ac                	jmp    80181d <devpipe_write+0x1c>
	return i;
  801871:	8b 45 10             	mov    0x10(%ebp),%eax
  801874:	eb 05                	jmp    80187b <devpipe_write+0x7a>
				return 0;
  801876:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80187e:	5b                   	pop    %ebx
  80187f:	5e                   	pop    %esi
  801880:	5f                   	pop    %edi
  801881:	5d                   	pop    %ebp
  801882:	c3                   	ret    

00801883 <devpipe_read>:
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	57                   	push   %edi
  801887:	56                   	push   %esi
  801888:	53                   	push   %ebx
  801889:	83 ec 18             	sub    $0x18,%esp
  80188c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80188f:	57                   	push   %edi
  801890:	e8 66 f6 ff ff       	call   800efb <fd2data>
  801895:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	be 00 00 00 00       	mov    $0x0,%esi
  80189f:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018a2:	75 14                	jne    8018b8 <devpipe_read+0x35>
	return i;
  8018a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a7:	eb 02                	jmp    8018ab <devpipe_read+0x28>
				return i;
  8018a9:	89 f0                	mov    %esi,%eax
}
  8018ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ae:	5b                   	pop    %ebx
  8018af:	5e                   	pop    %esi
  8018b0:	5f                   	pop    %edi
  8018b1:	5d                   	pop    %ebp
  8018b2:	c3                   	ret    
			sys_yield();
  8018b3:	e8 04 f4 ff ff       	call   800cbc <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8018b8:	8b 03                	mov    (%ebx),%eax
  8018ba:	3b 43 04             	cmp    0x4(%ebx),%eax
  8018bd:	75 18                	jne    8018d7 <devpipe_read+0x54>
			if (i > 0)
  8018bf:	85 f6                	test   %esi,%esi
  8018c1:	75 e6                	jne    8018a9 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8018c3:	89 da                	mov    %ebx,%edx
  8018c5:	89 f8                	mov    %edi,%eax
  8018c7:	e8 d0 fe ff ff       	call   80179c <_pipeisclosed>
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	74 e3                	je     8018b3 <devpipe_read+0x30>
				return 0;
  8018d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d5:	eb d4                	jmp    8018ab <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8018d7:	99                   	cltd   
  8018d8:	c1 ea 1b             	shr    $0x1b,%edx
  8018db:	01 d0                	add    %edx,%eax
  8018dd:	83 e0 1f             	and    $0x1f,%eax
  8018e0:	29 d0                	sub    %edx,%eax
  8018e2:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8018e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ea:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8018ed:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8018f0:	83 c6 01             	add    $0x1,%esi
  8018f3:	eb aa                	jmp    80189f <devpipe_read+0x1c>

008018f5 <pipe>:
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	56                   	push   %esi
  8018f9:	53                   	push   %ebx
  8018fa:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8018fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801900:	50                   	push   %eax
  801901:	e8 0c f6 ff ff       	call   800f12 <fd_alloc>
  801906:	89 c3                	mov    %eax,%ebx
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	85 c0                	test   %eax,%eax
  80190d:	0f 88 23 01 00 00    	js     801a36 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801913:	83 ec 04             	sub    $0x4,%esp
  801916:	68 07 04 00 00       	push   $0x407
  80191b:	ff 75 f4             	pushl  -0xc(%ebp)
  80191e:	6a 00                	push   $0x0
  801920:	e8 b6 f3 ff ff       	call   800cdb <sys_page_alloc>
  801925:	89 c3                	mov    %eax,%ebx
  801927:	83 c4 10             	add    $0x10,%esp
  80192a:	85 c0                	test   %eax,%eax
  80192c:	0f 88 04 01 00 00    	js     801a36 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801932:	83 ec 0c             	sub    $0xc,%esp
  801935:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801938:	50                   	push   %eax
  801939:	e8 d4 f5 ff ff       	call   800f12 <fd_alloc>
  80193e:	89 c3                	mov    %eax,%ebx
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	85 c0                	test   %eax,%eax
  801945:	0f 88 db 00 00 00    	js     801a26 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80194b:	83 ec 04             	sub    $0x4,%esp
  80194e:	68 07 04 00 00       	push   $0x407
  801953:	ff 75 f0             	pushl  -0x10(%ebp)
  801956:	6a 00                	push   $0x0
  801958:	e8 7e f3 ff ff       	call   800cdb <sys_page_alloc>
  80195d:	89 c3                	mov    %eax,%ebx
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	85 c0                	test   %eax,%eax
  801964:	0f 88 bc 00 00 00    	js     801a26 <pipe+0x131>
	va = fd2data(fd0);
  80196a:	83 ec 0c             	sub    $0xc,%esp
  80196d:	ff 75 f4             	pushl  -0xc(%ebp)
  801970:	e8 86 f5 ff ff       	call   800efb <fd2data>
  801975:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801977:	83 c4 0c             	add    $0xc,%esp
  80197a:	68 07 04 00 00       	push   $0x407
  80197f:	50                   	push   %eax
  801980:	6a 00                	push   $0x0
  801982:	e8 54 f3 ff ff       	call   800cdb <sys_page_alloc>
  801987:	89 c3                	mov    %eax,%ebx
  801989:	83 c4 10             	add    $0x10,%esp
  80198c:	85 c0                	test   %eax,%eax
  80198e:	0f 88 82 00 00 00    	js     801a16 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801994:	83 ec 0c             	sub    $0xc,%esp
  801997:	ff 75 f0             	pushl  -0x10(%ebp)
  80199a:	e8 5c f5 ff ff       	call   800efb <fd2data>
  80199f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8019a6:	50                   	push   %eax
  8019a7:	6a 00                	push   $0x0
  8019a9:	56                   	push   %esi
  8019aa:	6a 00                	push   $0x0
  8019ac:	e8 6d f3 ff ff       	call   800d1e <sys_page_map>
  8019b1:	89 c3                	mov    %eax,%ebx
  8019b3:	83 c4 20             	add    $0x20,%esp
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	78 4e                	js     801a08 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8019ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8019bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8019c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8019ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019d1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8019d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8019dd:	83 ec 0c             	sub    $0xc,%esp
  8019e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e3:	e8 03 f5 ff ff       	call   800eeb <fd2num>
  8019e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019eb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8019ed:	83 c4 04             	add    $0x4,%esp
  8019f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f3:	e8 f3 f4 ff ff       	call   800eeb <fd2num>
  8019f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019fb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8019fe:	83 c4 10             	add    $0x10,%esp
  801a01:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a06:	eb 2e                	jmp    801a36 <pipe+0x141>
	sys_page_unmap(0, va);
  801a08:	83 ec 08             	sub    $0x8,%esp
  801a0b:	56                   	push   %esi
  801a0c:	6a 00                	push   $0x0
  801a0e:	e8 4d f3 ff ff       	call   800d60 <sys_page_unmap>
  801a13:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a16:	83 ec 08             	sub    $0x8,%esp
  801a19:	ff 75 f0             	pushl  -0x10(%ebp)
  801a1c:	6a 00                	push   $0x0
  801a1e:	e8 3d f3 ff ff       	call   800d60 <sys_page_unmap>
  801a23:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801a26:	83 ec 08             	sub    $0x8,%esp
  801a29:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2c:	6a 00                	push   $0x0
  801a2e:	e8 2d f3 ff ff       	call   800d60 <sys_page_unmap>
  801a33:	83 c4 10             	add    $0x10,%esp
}
  801a36:	89 d8                	mov    %ebx,%eax
  801a38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5d                   	pop    %ebp
  801a3e:	c3                   	ret    

00801a3f <pipeisclosed>:
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a48:	50                   	push   %eax
  801a49:	ff 75 08             	pushl  0x8(%ebp)
  801a4c:	e8 13 f5 ff ff       	call   800f64 <fd_lookup>
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	85 c0                	test   %eax,%eax
  801a56:	78 18                	js     801a70 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801a58:	83 ec 0c             	sub    $0xc,%esp
  801a5b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a5e:	e8 98 f4 ff ff       	call   800efb <fd2data>
	return _pipeisclosed(fd, p);
  801a63:	89 c2                	mov    %eax,%edx
  801a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a68:	e8 2f fd ff ff       	call   80179c <_pipeisclosed>
  801a6d:	83 c4 10             	add    $0x10,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a78:	68 da 28 80 00       	push   $0x8028da
  801a7d:	ff 75 0c             	pushl  0xc(%ebp)
  801a80:	e8 64 ee ff ff       	call   8008e9 <strcpy>
	return 0;
}
  801a85:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <devsock_close>:
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	53                   	push   %ebx
  801a90:	83 ec 10             	sub    $0x10,%esp
  801a93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a96:	53                   	push   %ebx
  801a97:	e8 ca 06 00 00       	call   802166 <pageref>
  801a9c:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a9f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801aa4:	83 f8 01             	cmp    $0x1,%eax
  801aa7:	74 07                	je     801ab0 <devsock_close+0x24>
}
  801aa9:	89 d0                	mov    %edx,%eax
  801aab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ab0:	83 ec 0c             	sub    $0xc,%esp
  801ab3:	ff 73 0c             	pushl  0xc(%ebx)
  801ab6:	e8 b9 02 00 00       	call   801d74 <nsipc_close>
  801abb:	89 c2                	mov    %eax,%edx
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	eb e7                	jmp    801aa9 <devsock_close+0x1d>

00801ac2 <devsock_write>:
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ac8:	6a 00                	push   $0x0
  801aca:	ff 75 10             	pushl  0x10(%ebp)
  801acd:	ff 75 0c             	pushl  0xc(%ebp)
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	ff 70 0c             	pushl  0xc(%eax)
  801ad6:	e8 76 03 00 00       	call   801e51 <nsipc_send>
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <devsock_read>:
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	ff 75 10             	pushl  0x10(%ebp)
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	ff 70 0c             	pushl  0xc(%eax)
  801af1:	e8 ef 02 00 00       	call   801de5 <nsipc_recv>
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <fd2sockid>:
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801afe:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b01:	52                   	push   %edx
  801b02:	50                   	push   %eax
  801b03:	e8 5c f4 ff ff       	call   800f64 <fd_lookup>
  801b08:	83 c4 10             	add    $0x10,%esp
  801b0b:	85 c0                	test   %eax,%eax
  801b0d:	78 10                	js     801b1f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b12:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801b18:	39 08                	cmp    %ecx,(%eax)
  801b1a:	75 05                	jne    801b21 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b1c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    
		return -E_NOT_SUPP;
  801b21:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b26:	eb f7                	jmp    801b1f <fd2sockid+0x27>

00801b28 <alloc_sockfd>:
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	56                   	push   %esi
  801b2c:	53                   	push   %ebx
  801b2d:	83 ec 1c             	sub    $0x1c,%esp
  801b30:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b35:	50                   	push   %eax
  801b36:	e8 d7 f3 ff ff       	call   800f12 <fd_alloc>
  801b3b:	89 c3                	mov    %eax,%ebx
  801b3d:	83 c4 10             	add    $0x10,%esp
  801b40:	85 c0                	test   %eax,%eax
  801b42:	78 43                	js     801b87 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b44:	83 ec 04             	sub    $0x4,%esp
  801b47:	68 07 04 00 00       	push   $0x407
  801b4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4f:	6a 00                	push   $0x0
  801b51:	e8 85 f1 ff ff       	call   800cdb <sys_page_alloc>
  801b56:	89 c3                	mov    %eax,%ebx
  801b58:	83 c4 10             	add    $0x10,%esp
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	78 28                	js     801b87 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b62:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b68:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b74:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b77:	83 ec 0c             	sub    $0xc,%esp
  801b7a:	50                   	push   %eax
  801b7b:	e8 6b f3 ff ff       	call   800eeb <fd2num>
  801b80:	89 c3                	mov    %eax,%ebx
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	eb 0c                	jmp    801b93 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b87:	83 ec 0c             	sub    $0xc,%esp
  801b8a:	56                   	push   %esi
  801b8b:	e8 e4 01 00 00       	call   801d74 <nsipc_close>
		return r;
  801b90:	83 c4 10             	add    $0x10,%esp
}
  801b93:	89 d8                	mov    %ebx,%eax
  801b95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b98:	5b                   	pop    %ebx
  801b99:	5e                   	pop    %esi
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    

00801b9c <accept>:
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	e8 4e ff ff ff       	call   801af8 <fd2sockid>
  801baa:	85 c0                	test   %eax,%eax
  801bac:	78 1b                	js     801bc9 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bae:	83 ec 04             	sub    $0x4,%esp
  801bb1:	ff 75 10             	pushl  0x10(%ebp)
  801bb4:	ff 75 0c             	pushl  0xc(%ebp)
  801bb7:	50                   	push   %eax
  801bb8:	e8 0e 01 00 00       	call   801ccb <nsipc_accept>
  801bbd:	83 c4 10             	add    $0x10,%esp
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	78 05                	js     801bc9 <accept+0x2d>
	return alloc_sockfd(r);
  801bc4:	e8 5f ff ff ff       	call   801b28 <alloc_sockfd>
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <bind>:
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	e8 1f ff ff ff       	call   801af8 <fd2sockid>
  801bd9:	85 c0                	test   %eax,%eax
  801bdb:	78 12                	js     801bef <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801bdd:	83 ec 04             	sub    $0x4,%esp
  801be0:	ff 75 10             	pushl  0x10(%ebp)
  801be3:	ff 75 0c             	pushl  0xc(%ebp)
  801be6:	50                   	push   %eax
  801be7:	e8 31 01 00 00       	call   801d1d <nsipc_bind>
  801bec:	83 c4 10             	add    $0x10,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <shutdown>:
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfa:	e8 f9 fe ff ff       	call   801af8 <fd2sockid>
  801bff:	85 c0                	test   %eax,%eax
  801c01:	78 0f                	js     801c12 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c03:	83 ec 08             	sub    $0x8,%esp
  801c06:	ff 75 0c             	pushl  0xc(%ebp)
  801c09:	50                   	push   %eax
  801c0a:	e8 43 01 00 00       	call   801d52 <nsipc_shutdown>
  801c0f:	83 c4 10             	add    $0x10,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <connect>:
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	e8 d6 fe ff ff       	call   801af8 <fd2sockid>
  801c22:	85 c0                	test   %eax,%eax
  801c24:	78 12                	js     801c38 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c26:	83 ec 04             	sub    $0x4,%esp
  801c29:	ff 75 10             	pushl  0x10(%ebp)
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	50                   	push   %eax
  801c30:	e8 59 01 00 00       	call   801d8e <nsipc_connect>
  801c35:	83 c4 10             	add    $0x10,%esp
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <listen>:
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	e8 b0 fe ff ff       	call   801af8 <fd2sockid>
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	78 0f                	js     801c5b <listen+0x21>
	return nsipc_listen(r, backlog);
  801c4c:	83 ec 08             	sub    $0x8,%esp
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	50                   	push   %eax
  801c53:	e8 6b 01 00 00       	call   801dc3 <nsipc_listen>
  801c58:	83 c4 10             	add    $0x10,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <socket>:

int
socket(int domain, int type, int protocol)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c63:	ff 75 10             	pushl  0x10(%ebp)
  801c66:	ff 75 0c             	pushl  0xc(%ebp)
  801c69:	ff 75 08             	pushl  0x8(%ebp)
  801c6c:	e8 3e 02 00 00       	call   801eaf <nsipc_socket>
  801c71:	83 c4 10             	add    $0x10,%esp
  801c74:	85 c0                	test   %eax,%eax
  801c76:	78 05                	js     801c7d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c78:	e8 ab fe ff ff       	call   801b28 <alloc_sockfd>
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	53                   	push   %ebx
  801c83:	83 ec 04             	sub    $0x4,%esp
  801c86:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c88:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c8f:	74 26                	je     801cb7 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c91:	6a 07                	push   $0x7
  801c93:	68 00 60 80 00       	push   $0x806000
  801c98:	53                   	push   %ebx
  801c99:	ff 35 04 40 80 00    	pushl  0x804004
  801c9f:	e8 1d 04 00 00       	call   8020c1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ca4:	83 c4 0c             	add    $0xc,%esp
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	e8 9c 03 00 00       	call   80204e <ipc_recv>
}
  801cb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cb7:	83 ec 0c             	sub    $0xc,%esp
  801cba:	6a 02                	push   $0x2
  801cbc:	e8 6c 04 00 00       	call   80212d <ipc_find_env>
  801cc1:	a3 04 40 80 00       	mov    %eax,0x804004
  801cc6:	83 c4 10             	add    $0x10,%esp
  801cc9:	eb c6                	jmp    801c91 <nsipc+0x12>

00801ccb <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	56                   	push   %esi
  801ccf:	53                   	push   %ebx
  801cd0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cdb:	8b 06                	mov    (%esi),%eax
  801cdd:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce7:	e8 93 ff ff ff       	call   801c7f <nsipc>
  801cec:	89 c3                	mov    %eax,%ebx
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	79 09                	jns    801cfb <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801cf2:	89 d8                	mov    %ebx,%eax
  801cf4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cfb:	83 ec 04             	sub    $0x4,%esp
  801cfe:	ff 35 10 60 80 00    	pushl  0x806010
  801d04:	68 00 60 80 00       	push   $0x806000
  801d09:	ff 75 0c             	pushl  0xc(%ebp)
  801d0c:	e8 66 ed ff ff       	call   800a77 <memmove>
		*addrlen = ret->ret_addrlen;
  801d11:	a1 10 60 80 00       	mov    0x806010,%eax
  801d16:	89 06                	mov    %eax,(%esi)
  801d18:	83 c4 10             	add    $0x10,%esp
	return r;
  801d1b:	eb d5                	jmp    801cf2 <nsipc_accept+0x27>

00801d1d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	53                   	push   %ebx
  801d21:	83 ec 08             	sub    $0x8,%esp
  801d24:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d2f:	53                   	push   %ebx
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	68 04 60 80 00       	push   $0x806004
  801d38:	e8 3a ed ff ff       	call   800a77 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d3d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d43:	b8 02 00 00 00       	mov    $0x2,%eax
  801d48:	e8 32 ff ff ff       	call   801c7f <nsipc>
}
  801d4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d63:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d68:	b8 03 00 00 00       	mov    $0x3,%eax
  801d6d:	e8 0d ff ff ff       	call   801c7f <nsipc>
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <nsipc_close>:

int
nsipc_close(int s)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d82:	b8 04 00 00 00       	mov    $0x4,%eax
  801d87:	e8 f3 fe ff ff       	call   801c7f <nsipc>
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	53                   	push   %ebx
  801d92:	83 ec 08             	sub    $0x8,%esp
  801d95:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801da0:	53                   	push   %ebx
  801da1:	ff 75 0c             	pushl  0xc(%ebp)
  801da4:	68 04 60 80 00       	push   $0x806004
  801da9:	e8 c9 ec ff ff       	call   800a77 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801dae:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801db4:	b8 05 00 00 00       	mov    $0x5,%eax
  801db9:	e8 c1 fe ff ff       	call   801c7f <nsipc>
}
  801dbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801dd9:	b8 06 00 00 00       	mov    $0x6,%eax
  801dde:	e8 9c fe ff ff       	call   801c7f <nsipc>
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	56                   	push   %esi
  801de9:	53                   	push   %ebx
  801dea:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801df5:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801dfb:	8b 45 14             	mov    0x14(%ebp),%eax
  801dfe:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e03:	b8 07 00 00 00       	mov    $0x7,%eax
  801e08:	e8 72 fe ff ff       	call   801c7f <nsipc>
  801e0d:	89 c3                	mov    %eax,%ebx
  801e0f:	85 c0                	test   %eax,%eax
  801e11:	78 1f                	js     801e32 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e13:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e18:	7f 21                	jg     801e3b <nsipc_recv+0x56>
  801e1a:	39 c6                	cmp    %eax,%esi
  801e1c:	7c 1d                	jl     801e3b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	50                   	push   %eax
  801e22:	68 00 60 80 00       	push   $0x806000
  801e27:	ff 75 0c             	pushl  0xc(%ebp)
  801e2a:	e8 48 ec ff ff       	call   800a77 <memmove>
  801e2f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e32:	89 d8                	mov    %ebx,%eax
  801e34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5d                   	pop    %ebp
  801e3a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e3b:	68 e6 28 80 00       	push   $0x8028e6
  801e40:	68 88 28 80 00       	push   $0x802888
  801e45:	6a 62                	push   $0x62
  801e47:	68 fb 28 80 00       	push   $0x8028fb
  801e4c:	e8 e1 e3 ff ff       	call   800232 <_panic>

00801e51 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	53                   	push   %ebx
  801e55:	83 ec 04             	sub    $0x4,%esp
  801e58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e63:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e69:	7f 2e                	jg     801e99 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e6b:	83 ec 04             	sub    $0x4,%esp
  801e6e:	53                   	push   %ebx
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	68 0c 60 80 00       	push   $0x80600c
  801e77:	e8 fb eb ff ff       	call   800a77 <memmove>
	nsipcbuf.send.req_size = size;
  801e7c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e82:	8b 45 14             	mov    0x14(%ebp),%eax
  801e85:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e8a:	b8 08 00 00 00       	mov    $0x8,%eax
  801e8f:	e8 eb fd ff ff       	call   801c7f <nsipc>
}
  801e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    
	assert(size < 1600);
  801e99:	68 07 29 80 00       	push   $0x802907
  801e9e:	68 88 28 80 00       	push   $0x802888
  801ea3:	6a 6d                	push   $0x6d
  801ea5:	68 fb 28 80 00       	push   $0x8028fb
  801eaa:	e8 83 e3 ff ff       	call   800232 <_panic>

00801eaf <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec0:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ec5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ecd:	b8 09 00 00 00       	mov    $0x9,%eax
  801ed2:	e8 a8 fd ff ff       	call   801c7f <nsipc>
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	c3                   	ret    

00801edf <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ee5:	68 13 29 80 00       	push   $0x802913
  801eea:	ff 75 0c             	pushl  0xc(%ebp)
  801eed:	e8 f7 e9 ff ff       	call   8008e9 <strcpy>
	return 0;
}
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <devcons_write>:
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	57                   	push   %edi
  801efd:	56                   	push   %esi
  801efe:	53                   	push   %ebx
  801eff:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f05:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f0a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f10:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f13:	73 31                	jae    801f46 <devcons_write+0x4d>
		m = n - tot;
  801f15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f18:	29 f3                	sub    %esi,%ebx
  801f1a:	83 fb 7f             	cmp    $0x7f,%ebx
  801f1d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f22:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	53                   	push   %ebx
  801f29:	89 f0                	mov    %esi,%eax
  801f2b:	03 45 0c             	add    0xc(%ebp),%eax
  801f2e:	50                   	push   %eax
  801f2f:	57                   	push   %edi
  801f30:	e8 42 eb ff ff       	call   800a77 <memmove>
		sys_cputs(buf, m);
  801f35:	83 c4 08             	add    $0x8,%esp
  801f38:	53                   	push   %ebx
  801f39:	57                   	push   %edi
  801f3a:	e8 e0 ec ff ff       	call   800c1f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f3f:	01 de                	add    %ebx,%esi
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	eb ca                	jmp    801f10 <devcons_write+0x17>
}
  801f46:	89 f0                	mov    %esi,%eax
  801f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f4b:	5b                   	pop    %ebx
  801f4c:	5e                   	pop    %esi
  801f4d:	5f                   	pop    %edi
  801f4e:	5d                   	pop    %ebp
  801f4f:	c3                   	ret    

00801f50 <devcons_read>:
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	83 ec 08             	sub    $0x8,%esp
  801f56:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f5f:	74 21                	je     801f82 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801f61:	e8 d7 ec ff ff       	call   800c3d <sys_cgetc>
  801f66:	85 c0                	test   %eax,%eax
  801f68:	75 07                	jne    801f71 <devcons_read+0x21>
		sys_yield();
  801f6a:	e8 4d ed ff ff       	call   800cbc <sys_yield>
  801f6f:	eb f0                	jmp    801f61 <devcons_read+0x11>
	if (c < 0)
  801f71:	78 0f                	js     801f82 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801f73:	83 f8 04             	cmp    $0x4,%eax
  801f76:	74 0c                	je     801f84 <devcons_read+0x34>
	*(char*)vbuf = c;
  801f78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7b:	88 02                	mov    %al,(%edx)
	return 1;
  801f7d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    
		return 0;
  801f84:	b8 00 00 00 00       	mov    $0x0,%eax
  801f89:	eb f7                	jmp    801f82 <devcons_read+0x32>

00801f8b <cputchar>:
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f97:	6a 01                	push   $0x1
  801f99:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f9c:	50                   	push   %eax
  801f9d:	e8 7d ec ff ff       	call   800c1f <sys_cputs>
}
  801fa2:	83 c4 10             	add    $0x10,%esp
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <getchar>:
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fad:	6a 01                	push   $0x1
  801faf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fb2:	50                   	push   %eax
  801fb3:	6a 00                	push   $0x0
  801fb5:	e8 1a f2 ff ff       	call   8011d4 <read>
	if (r < 0)
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	85 c0                	test   %eax,%eax
  801fbf:	78 06                	js     801fc7 <getchar+0x20>
	if (r < 1)
  801fc1:	74 06                	je     801fc9 <getchar+0x22>
	return c;
  801fc3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    
		return -E_EOF;
  801fc9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fce:	eb f7                	jmp    801fc7 <getchar+0x20>

00801fd0 <iscons>:
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd9:	50                   	push   %eax
  801fda:	ff 75 08             	pushl  0x8(%ebp)
  801fdd:	e8 82 ef ff ff       	call   800f64 <fd_lookup>
  801fe2:	83 c4 10             	add    $0x10,%esp
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	78 11                	js     801ffa <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801ff2:	39 10                	cmp    %edx,(%eax)
  801ff4:	0f 94 c0             	sete   %al
  801ff7:	0f b6 c0             	movzbl %al,%eax
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <opencons>:
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802002:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802005:	50                   	push   %eax
  802006:	e8 07 ef ff ff       	call   800f12 <fd_alloc>
  80200b:	83 c4 10             	add    $0x10,%esp
  80200e:	85 c0                	test   %eax,%eax
  802010:	78 3a                	js     80204c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802012:	83 ec 04             	sub    $0x4,%esp
  802015:	68 07 04 00 00       	push   $0x407
  80201a:	ff 75 f4             	pushl  -0xc(%ebp)
  80201d:	6a 00                	push   $0x0
  80201f:	e8 b7 ec ff ff       	call   800cdb <sys_page_alloc>
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	85 c0                	test   %eax,%eax
  802029:	78 21                	js     80204c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802034:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802040:	83 ec 0c             	sub    $0xc,%esp
  802043:	50                   	push   %eax
  802044:	e8 a2 ee ff ff       	call   800eeb <fd2num>
  802049:	83 c4 10             	add    $0x10,%esp
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	56                   	push   %esi
  802052:	53                   	push   %ebx
  802053:	8b 75 08             	mov    0x8(%ebp),%esi
  802056:	8b 45 0c             	mov    0xc(%ebp),%eax
  802059:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  80205c:	85 c0                	test   %eax,%eax
  80205e:	74 4f                	je     8020af <ipc_recv+0x61>
  802060:	83 ec 0c             	sub    $0xc,%esp
  802063:	50                   	push   %eax
  802064:	e8 22 ee ff ff       	call   800e8b <sys_ipc_recv>
  802069:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  80206c:	85 f6                	test   %esi,%esi
  80206e:	74 14                	je     802084 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802070:	ba 00 00 00 00       	mov    $0x0,%edx
  802075:	85 c0                	test   %eax,%eax
  802077:	75 09                	jne    802082 <ipc_recv+0x34>
  802079:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80207f:	8b 52 74             	mov    0x74(%edx),%edx
  802082:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  802084:	85 db                	test   %ebx,%ebx
  802086:	74 14                	je     80209c <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  802088:	ba 00 00 00 00       	mov    $0x0,%edx
  80208d:	85 c0                	test   %eax,%eax
  80208f:	75 09                	jne    80209a <ipc_recv+0x4c>
  802091:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802097:	8b 52 78             	mov    0x78(%edx),%edx
  80209a:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  80209c:	85 c0                	test   %eax,%eax
  80209e:	75 08                	jne    8020a8 <ipc_recv+0x5a>
  8020a0:	a1 08 40 80 00       	mov    0x804008,%eax
  8020a5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ab:	5b                   	pop    %ebx
  8020ac:	5e                   	pop    %esi
  8020ad:	5d                   	pop    %ebp
  8020ae:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8020af:	83 ec 0c             	sub    $0xc,%esp
  8020b2:	68 00 00 c0 ee       	push   $0xeec00000
  8020b7:	e8 cf ed ff ff       	call   800e8b <sys_ipc_recv>
  8020bc:	83 c4 10             	add    $0x10,%esp
  8020bf:	eb ab                	jmp    80206c <ipc_recv+0x1e>

008020c1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	57                   	push   %edi
  8020c5:	56                   	push   %esi
  8020c6:	53                   	push   %ebx
  8020c7:	83 ec 0c             	sub    $0xc,%esp
  8020ca:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020cd:	8b 75 10             	mov    0x10(%ebp),%esi
  8020d0:	eb 20                	jmp    8020f2 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8020d2:	6a 00                	push   $0x0
  8020d4:	68 00 00 c0 ee       	push   $0xeec00000
  8020d9:	ff 75 0c             	pushl  0xc(%ebp)
  8020dc:	57                   	push   %edi
  8020dd:	e8 86 ed ff ff       	call   800e68 <sys_ipc_try_send>
  8020e2:	89 c3                	mov    %eax,%ebx
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	eb 1f                	jmp    802108 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  8020e9:	e8 ce eb ff ff       	call   800cbc <sys_yield>
	while(retval != 0) {
  8020ee:	85 db                	test   %ebx,%ebx
  8020f0:	74 33                	je     802125 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8020f2:	85 f6                	test   %esi,%esi
  8020f4:	74 dc                	je     8020d2 <ipc_send+0x11>
  8020f6:	ff 75 14             	pushl  0x14(%ebp)
  8020f9:	56                   	push   %esi
  8020fa:	ff 75 0c             	pushl  0xc(%ebp)
  8020fd:	57                   	push   %edi
  8020fe:	e8 65 ed ff ff       	call   800e68 <sys_ipc_try_send>
  802103:	89 c3                	mov    %eax,%ebx
  802105:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802108:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80210b:	74 dc                	je     8020e9 <ipc_send+0x28>
  80210d:	85 db                	test   %ebx,%ebx
  80210f:	74 d8                	je     8020e9 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802111:	83 ec 04             	sub    $0x4,%esp
  802114:	68 20 29 80 00       	push   $0x802920
  802119:	6a 35                	push   $0x35
  80211b:	68 50 29 80 00       	push   $0x802950
  802120:	e8 0d e1 ff ff       	call   800232 <_panic>
	}
}
  802125:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802128:	5b                   	pop    %ebx
  802129:	5e                   	pop    %esi
  80212a:	5f                   	pop    %edi
  80212b:	5d                   	pop    %ebp
  80212c:	c3                   	ret    

0080212d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802138:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80213b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802141:	8b 52 50             	mov    0x50(%edx),%edx
  802144:	39 ca                	cmp    %ecx,%edx
  802146:	74 11                	je     802159 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802148:	83 c0 01             	add    $0x1,%eax
  80214b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802150:	75 e6                	jne    802138 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802152:	b8 00 00 00 00       	mov    $0x0,%eax
  802157:	eb 0b                	jmp    802164 <ipc_find_env+0x37>
			return envs[i].env_id;
  802159:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80215c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802161:	8b 40 48             	mov    0x48(%eax),%eax
}
  802164:	5d                   	pop    %ebp
  802165:	c3                   	ret    

00802166 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80216c:	89 d0                	mov    %edx,%eax
  80216e:	c1 e8 16             	shr    $0x16,%eax
  802171:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802178:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80217d:	f6 c1 01             	test   $0x1,%cl
  802180:	74 1d                	je     80219f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802182:	c1 ea 0c             	shr    $0xc,%edx
  802185:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80218c:	f6 c2 01             	test   $0x1,%dl
  80218f:	74 0e                	je     80219f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802191:	c1 ea 0c             	shr    $0xc,%edx
  802194:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80219b:	ef 
  80219c:	0f b7 c0             	movzwl %ax,%eax
}
  80219f:	5d                   	pop    %ebp
  8021a0:	c3                   	ret    
  8021a1:	66 90                	xchg   %ax,%ax
  8021a3:	66 90                	xchg   %ax,%ax
  8021a5:	66 90                	xchg   %ax,%ax
  8021a7:	66 90                	xchg   %ax,%ax
  8021a9:	66 90                	xchg   %ax,%ax
  8021ab:	66 90                	xchg   %ax,%ax
  8021ad:	66 90                	xchg   %ax,%ax
  8021af:	90                   	nop

008021b0 <__udivdi3>:
  8021b0:	f3 0f 1e fb          	endbr32 
  8021b4:	55                   	push   %ebp
  8021b5:	57                   	push   %edi
  8021b6:	56                   	push   %esi
  8021b7:	53                   	push   %ebx
  8021b8:	83 ec 1c             	sub    $0x1c,%esp
  8021bb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021cb:	85 d2                	test   %edx,%edx
  8021cd:	75 49                	jne    802218 <__udivdi3+0x68>
  8021cf:	39 f3                	cmp    %esi,%ebx
  8021d1:	76 15                	jbe    8021e8 <__udivdi3+0x38>
  8021d3:	31 ff                	xor    %edi,%edi
  8021d5:	89 e8                	mov    %ebp,%eax
  8021d7:	89 f2                	mov    %esi,%edx
  8021d9:	f7 f3                	div    %ebx
  8021db:	89 fa                	mov    %edi,%edx
  8021dd:	83 c4 1c             	add    $0x1c,%esp
  8021e0:	5b                   	pop    %ebx
  8021e1:	5e                   	pop    %esi
  8021e2:	5f                   	pop    %edi
  8021e3:	5d                   	pop    %ebp
  8021e4:	c3                   	ret    
  8021e5:	8d 76 00             	lea    0x0(%esi),%esi
  8021e8:	89 d9                	mov    %ebx,%ecx
  8021ea:	85 db                	test   %ebx,%ebx
  8021ec:	75 0b                	jne    8021f9 <__udivdi3+0x49>
  8021ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f3:	31 d2                	xor    %edx,%edx
  8021f5:	f7 f3                	div    %ebx
  8021f7:	89 c1                	mov    %eax,%ecx
  8021f9:	31 d2                	xor    %edx,%edx
  8021fb:	89 f0                	mov    %esi,%eax
  8021fd:	f7 f1                	div    %ecx
  8021ff:	89 c6                	mov    %eax,%esi
  802201:	89 e8                	mov    %ebp,%eax
  802203:	89 f7                	mov    %esi,%edi
  802205:	f7 f1                	div    %ecx
  802207:	89 fa                	mov    %edi,%edx
  802209:	83 c4 1c             	add    $0x1c,%esp
  80220c:	5b                   	pop    %ebx
  80220d:	5e                   	pop    %esi
  80220e:	5f                   	pop    %edi
  80220f:	5d                   	pop    %ebp
  802210:	c3                   	ret    
  802211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802218:	39 f2                	cmp    %esi,%edx
  80221a:	77 1c                	ja     802238 <__udivdi3+0x88>
  80221c:	0f bd fa             	bsr    %edx,%edi
  80221f:	83 f7 1f             	xor    $0x1f,%edi
  802222:	75 2c                	jne    802250 <__udivdi3+0xa0>
  802224:	39 f2                	cmp    %esi,%edx
  802226:	72 06                	jb     80222e <__udivdi3+0x7e>
  802228:	31 c0                	xor    %eax,%eax
  80222a:	39 eb                	cmp    %ebp,%ebx
  80222c:	77 ad                	ja     8021db <__udivdi3+0x2b>
  80222e:	b8 01 00 00 00       	mov    $0x1,%eax
  802233:	eb a6                	jmp    8021db <__udivdi3+0x2b>
  802235:	8d 76 00             	lea    0x0(%esi),%esi
  802238:	31 ff                	xor    %edi,%edi
  80223a:	31 c0                	xor    %eax,%eax
  80223c:	89 fa                	mov    %edi,%edx
  80223e:	83 c4 1c             	add    $0x1c,%esp
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	5f                   	pop    %edi
  802244:	5d                   	pop    %ebp
  802245:	c3                   	ret    
  802246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80224d:	8d 76 00             	lea    0x0(%esi),%esi
  802250:	89 f9                	mov    %edi,%ecx
  802252:	b8 20 00 00 00       	mov    $0x20,%eax
  802257:	29 f8                	sub    %edi,%eax
  802259:	d3 e2                	shl    %cl,%edx
  80225b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80225f:	89 c1                	mov    %eax,%ecx
  802261:	89 da                	mov    %ebx,%edx
  802263:	d3 ea                	shr    %cl,%edx
  802265:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802269:	09 d1                	or     %edx,%ecx
  80226b:	89 f2                	mov    %esi,%edx
  80226d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802271:	89 f9                	mov    %edi,%ecx
  802273:	d3 e3                	shl    %cl,%ebx
  802275:	89 c1                	mov    %eax,%ecx
  802277:	d3 ea                	shr    %cl,%edx
  802279:	89 f9                	mov    %edi,%ecx
  80227b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80227f:	89 eb                	mov    %ebp,%ebx
  802281:	d3 e6                	shl    %cl,%esi
  802283:	89 c1                	mov    %eax,%ecx
  802285:	d3 eb                	shr    %cl,%ebx
  802287:	09 de                	or     %ebx,%esi
  802289:	89 f0                	mov    %esi,%eax
  80228b:	f7 74 24 08          	divl   0x8(%esp)
  80228f:	89 d6                	mov    %edx,%esi
  802291:	89 c3                	mov    %eax,%ebx
  802293:	f7 64 24 0c          	mull   0xc(%esp)
  802297:	39 d6                	cmp    %edx,%esi
  802299:	72 15                	jb     8022b0 <__udivdi3+0x100>
  80229b:	89 f9                	mov    %edi,%ecx
  80229d:	d3 e5                	shl    %cl,%ebp
  80229f:	39 c5                	cmp    %eax,%ebp
  8022a1:	73 04                	jae    8022a7 <__udivdi3+0xf7>
  8022a3:	39 d6                	cmp    %edx,%esi
  8022a5:	74 09                	je     8022b0 <__udivdi3+0x100>
  8022a7:	89 d8                	mov    %ebx,%eax
  8022a9:	31 ff                	xor    %edi,%edi
  8022ab:	e9 2b ff ff ff       	jmp    8021db <__udivdi3+0x2b>
  8022b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022b3:	31 ff                	xor    %edi,%edi
  8022b5:	e9 21 ff ff ff       	jmp    8021db <__udivdi3+0x2b>
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	66 90                	xchg   %ax,%ax
  8022be:	66 90                	xchg   %ax,%ax

008022c0 <__umoddi3>:
  8022c0:	f3 0f 1e fb          	endbr32 
  8022c4:	55                   	push   %ebp
  8022c5:	57                   	push   %edi
  8022c6:	56                   	push   %esi
  8022c7:	53                   	push   %ebx
  8022c8:	83 ec 1c             	sub    $0x1c,%esp
  8022cb:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022d3:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022db:	89 da                	mov    %ebx,%edx
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	75 3f                	jne    802320 <__umoddi3+0x60>
  8022e1:	39 df                	cmp    %ebx,%edi
  8022e3:	76 13                	jbe    8022f8 <__umoddi3+0x38>
  8022e5:	89 f0                	mov    %esi,%eax
  8022e7:	f7 f7                	div    %edi
  8022e9:	89 d0                	mov    %edx,%eax
  8022eb:	31 d2                	xor    %edx,%edx
  8022ed:	83 c4 1c             	add    $0x1c,%esp
  8022f0:	5b                   	pop    %ebx
  8022f1:	5e                   	pop    %esi
  8022f2:	5f                   	pop    %edi
  8022f3:	5d                   	pop    %ebp
  8022f4:	c3                   	ret    
  8022f5:	8d 76 00             	lea    0x0(%esi),%esi
  8022f8:	89 fd                	mov    %edi,%ebp
  8022fa:	85 ff                	test   %edi,%edi
  8022fc:	75 0b                	jne    802309 <__umoddi3+0x49>
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	f7 f7                	div    %edi
  802307:	89 c5                	mov    %eax,%ebp
  802309:	89 d8                	mov    %ebx,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	f7 f5                	div    %ebp
  80230f:	89 f0                	mov    %esi,%eax
  802311:	f7 f5                	div    %ebp
  802313:	89 d0                	mov    %edx,%eax
  802315:	eb d4                	jmp    8022eb <__umoddi3+0x2b>
  802317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80231e:	66 90                	xchg   %ax,%ax
  802320:	89 f1                	mov    %esi,%ecx
  802322:	39 d8                	cmp    %ebx,%eax
  802324:	76 0a                	jbe    802330 <__umoddi3+0x70>
  802326:	89 f0                	mov    %esi,%eax
  802328:	83 c4 1c             	add    $0x1c,%esp
  80232b:	5b                   	pop    %ebx
  80232c:	5e                   	pop    %esi
  80232d:	5f                   	pop    %edi
  80232e:	5d                   	pop    %ebp
  80232f:	c3                   	ret    
  802330:	0f bd e8             	bsr    %eax,%ebp
  802333:	83 f5 1f             	xor    $0x1f,%ebp
  802336:	75 20                	jne    802358 <__umoddi3+0x98>
  802338:	39 d8                	cmp    %ebx,%eax
  80233a:	0f 82 b0 00 00 00    	jb     8023f0 <__umoddi3+0x130>
  802340:	39 f7                	cmp    %esi,%edi
  802342:	0f 86 a8 00 00 00    	jbe    8023f0 <__umoddi3+0x130>
  802348:	89 c8                	mov    %ecx,%eax
  80234a:	83 c4 1c             	add    $0x1c,%esp
  80234d:	5b                   	pop    %ebx
  80234e:	5e                   	pop    %esi
  80234f:	5f                   	pop    %edi
  802350:	5d                   	pop    %ebp
  802351:	c3                   	ret    
  802352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802358:	89 e9                	mov    %ebp,%ecx
  80235a:	ba 20 00 00 00       	mov    $0x20,%edx
  80235f:	29 ea                	sub    %ebp,%edx
  802361:	d3 e0                	shl    %cl,%eax
  802363:	89 44 24 08          	mov    %eax,0x8(%esp)
  802367:	89 d1                	mov    %edx,%ecx
  802369:	89 f8                	mov    %edi,%eax
  80236b:	d3 e8                	shr    %cl,%eax
  80236d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802371:	89 54 24 04          	mov    %edx,0x4(%esp)
  802375:	8b 54 24 04          	mov    0x4(%esp),%edx
  802379:	09 c1                	or     %eax,%ecx
  80237b:	89 d8                	mov    %ebx,%eax
  80237d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802381:	89 e9                	mov    %ebp,%ecx
  802383:	d3 e7                	shl    %cl,%edi
  802385:	89 d1                	mov    %edx,%ecx
  802387:	d3 e8                	shr    %cl,%eax
  802389:	89 e9                	mov    %ebp,%ecx
  80238b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80238f:	d3 e3                	shl    %cl,%ebx
  802391:	89 c7                	mov    %eax,%edi
  802393:	89 d1                	mov    %edx,%ecx
  802395:	89 f0                	mov    %esi,%eax
  802397:	d3 e8                	shr    %cl,%eax
  802399:	89 e9                	mov    %ebp,%ecx
  80239b:	89 fa                	mov    %edi,%edx
  80239d:	d3 e6                	shl    %cl,%esi
  80239f:	09 d8                	or     %ebx,%eax
  8023a1:	f7 74 24 08          	divl   0x8(%esp)
  8023a5:	89 d1                	mov    %edx,%ecx
  8023a7:	89 f3                	mov    %esi,%ebx
  8023a9:	f7 64 24 0c          	mull   0xc(%esp)
  8023ad:	89 c6                	mov    %eax,%esi
  8023af:	89 d7                	mov    %edx,%edi
  8023b1:	39 d1                	cmp    %edx,%ecx
  8023b3:	72 06                	jb     8023bb <__umoddi3+0xfb>
  8023b5:	75 10                	jne    8023c7 <__umoddi3+0x107>
  8023b7:	39 c3                	cmp    %eax,%ebx
  8023b9:	73 0c                	jae    8023c7 <__umoddi3+0x107>
  8023bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023c3:	89 d7                	mov    %edx,%edi
  8023c5:	89 c6                	mov    %eax,%esi
  8023c7:	89 ca                	mov    %ecx,%edx
  8023c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023ce:	29 f3                	sub    %esi,%ebx
  8023d0:	19 fa                	sbb    %edi,%edx
  8023d2:	89 d0                	mov    %edx,%eax
  8023d4:	d3 e0                	shl    %cl,%eax
  8023d6:	89 e9                	mov    %ebp,%ecx
  8023d8:	d3 eb                	shr    %cl,%ebx
  8023da:	d3 ea                	shr    %cl,%edx
  8023dc:	09 d8                	or     %ebx,%eax
  8023de:	83 c4 1c             	add    $0x1c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    
  8023e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	89 da                	mov    %ebx,%edx
  8023f2:	29 fe                	sub    %edi,%esi
  8023f4:	19 c2                	sbb    %eax,%edx
  8023f6:	89 f1                	mov    %esi,%ecx
  8023f8:	89 c8                	mov    %ecx,%eax
  8023fa:	e9 4b ff ff ff       	jmp    80234a <__umoddi3+0x8a>
