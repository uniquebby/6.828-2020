
obj/net/testoutput：     文件格式 elf32-i386


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
  80002c:	e8 9a 01 00 00       	call   8001cb <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	envid_t ns_envid = sys_getenvid();
  800038:	e8 59 0c 00 00       	call   800c96 <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  80003f:	c7 05 00 30 80 00 40 	movl   $0x802840,0x803000
  800046:	28 80 00 

	output_envid = fork();
  800049:	e8 0d 10 00 00       	call   80105b <fork>
  80004e:	a3 00 40 80 00       	mov    %eax,0x804000
	if (output_envid < 0)
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 93 00 00 00    	js     8000ee <umain+0xbb>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  80005b:	bb 00 00 00 00       	mov    $0x0,%ebx
	else if (output_envid == 0) {
  800060:	0f 84 9c 00 00 00    	je     800102 <umain+0xcf>
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 07                	push   $0x7
  80006b:	68 00 b0 fe 0f       	push   $0xffeb000
  800070:	6a 00                	push   $0x0
  800072:	e8 5d 0c 00 00       	call   800cd4 <sys_page_alloc>
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	85 c0                	test   %eax,%eax
  80007c:	0f 88 8e 00 00 00    	js     800110 <umain+0xdd>
			panic("sys_page_alloc: %e", r);
		pkt->jp_len = snprintf(pkt->jp_data,
  800082:	53                   	push   %ebx
  800083:	68 7d 28 80 00       	push   $0x80287d
  800088:	68 fc 0f 00 00       	push   $0xffc
  80008d:	68 04 b0 fe 0f       	push   $0xffeb004
  800092:	e8 f8 07 00 00       	call   80088f <snprintf>
  800097:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  80009c:	83 c4 08             	add    $0x8,%esp
  80009f:	53                   	push   %ebx
  8000a0:	68 89 28 80 00       	push   $0x802889
  8000a5:	e8 5c 02 00 00       	call   800306 <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8000aa:	6a 07                	push   $0x7
  8000ac:	68 00 b0 fe 0f       	push   $0xffeb000
  8000b1:	6a 0b                	push   $0xb
  8000b3:	ff 35 00 40 80 00    	pushl  0x804000
  8000b9:	e8 3e 12 00 00       	call   8012fc <ipc_send>
		sys_page_unmap(0, pkt);
  8000be:	83 c4 18             	add    $0x18,%esp
  8000c1:	68 00 b0 fe 0f       	push   $0xffeb000
  8000c6:	6a 00                	push   $0x0
  8000c8:	e8 8c 0c 00 00       	call   800d59 <sys_page_unmap>
	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  8000cd:	83 c3 01             	add    $0x1,%ebx
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	83 fb 0a             	cmp    $0xa,%ebx
  8000d6:	75 8e                	jne    800066 <umain+0x33>
  8000d8:	bb 14 00 00 00       	mov    $0x14,%ebx
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  8000dd:	e8 d3 0b 00 00       	call   800cb5 <sys_yield>
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  8000e2:	83 eb 01             	sub    $0x1,%ebx
  8000e5:	75 f6                	jne    8000dd <umain+0xaa>
}
  8000e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ea:	5b                   	pop    %ebx
  8000eb:	5e                   	pop    %esi
  8000ec:	5d                   	pop    %ebp
  8000ed:	c3                   	ret    
		panic("error forking");
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 4b 28 80 00       	push   $0x80284b
  8000f6:	6a 16                	push   $0x16
  8000f8:	68 59 28 80 00       	push   $0x802859
  8000fd:	e8 29 01 00 00       	call   80022b <_panic>
		output(ns_envid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	56                   	push   %esi
  800106:	e8 b5 00 00 00       	call   8001c0 <output>
		return;
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	eb d7                	jmp    8000e7 <umain+0xb4>
			panic("sys_page_alloc: %e", r);
  800110:	50                   	push   %eax
  800111:	68 6a 28 80 00       	push   $0x80286a
  800116:	6a 1e                	push   $0x1e
  800118:	68 59 28 80 00       	push   $0x802859
  80011d:	e8 09 01 00 00       	call   80022b <_panic>

00800122 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	57                   	push   %edi
  800126:	56                   	push   %esi
  800127:	53                   	push   %ebx
  800128:	83 ec 1c             	sub    $0x1c,%esp
  80012b:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80012e:	e8 92 0d 00 00       	call   800ec5 <sys_time_msec>
  800133:	03 45 0c             	add    0xc(%ebp),%eax
  800136:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  800138:	c7 05 00 30 80 00 a1 	movl   $0x8028a1,0x803000
  80013f:	28 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800142:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800145:	eb 33                	jmp    80017a <timer+0x58>
		if (r < 0)
  800147:	85 c0                	test   %eax,%eax
  800149:	78 45                	js     800190 <timer+0x6e>
		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  80014b:	6a 00                	push   $0x0
  80014d:	6a 00                	push   $0x0
  80014f:	6a 0c                	push   $0xc
  800151:	56                   	push   %esi
  800152:	e8 a5 11 00 00       	call   8012fc <ipc_send>
  800157:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	6a 00                	push   $0x0
  80015f:	6a 00                	push   $0x0
  800161:	57                   	push   %edi
  800162:	e8 22 11 00 00       	call   801289 <ipc_recv>
  800167:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  800169:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	39 f0                	cmp    %esi,%eax
  800171:	75 2f                	jne    8001a2 <timer+0x80>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  800173:	e8 4d 0d 00 00       	call   800ec5 <sys_time_msec>
  800178:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  80017a:	e8 46 0d 00 00       	call   800ec5 <sys_time_msec>
  80017f:	89 c2                	mov    %eax,%edx
  800181:	85 c0                	test   %eax,%eax
  800183:	78 c2                	js     800147 <timer+0x25>
  800185:	39 d8                	cmp    %ebx,%eax
  800187:	73 be                	jae    800147 <timer+0x25>
			sys_yield();
  800189:	e8 27 0b 00 00       	call   800cb5 <sys_yield>
  80018e:	eb ea                	jmp    80017a <timer+0x58>
			panic("sys_time_msec: %e", r);
  800190:	52                   	push   %edx
  800191:	68 aa 28 80 00       	push   $0x8028aa
  800196:	6a 0f                	push   $0xf
  800198:	68 bc 28 80 00       	push   $0x8028bc
  80019d:	e8 89 00 00 00       	call   80022b <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	68 c8 28 80 00       	push   $0x8028c8
  8001ab:	e8 56 01 00 00       	call   800306 <cprintf>
				continue;
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	eb a5                	jmp    80015a <timer+0x38>

008001b5 <input>:
extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
	binaryname = "ns_input";
  8001b5:	c7 05 00 30 80 00 03 	movl   $0x802903,0x803000
  8001bc:	29 80 00 
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
}
  8001bf:	c3                   	ret    

008001c0 <output>:
extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
	binaryname = "ns_output";
  8001c0:	c7 05 00 30 80 00 0c 	movl   $0x80290c,0x803000
  8001c7:	29 80 00 

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
}
  8001ca:	c3                   	ret    

008001cb <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001cb:	55                   	push   %ebp
  8001cc:	89 e5                	mov    %esp,%ebp
  8001ce:	56                   	push   %esi
  8001cf:	53                   	push   %ebx
  8001d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001d6:	e8 bb 0a 00 00       	call   800c96 <sys_getenvid>
  8001db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001e3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e8:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ed:	85 db                	test   %ebx,%ebx
  8001ef:	7e 07                	jle    8001f8 <libmain+0x2d>
		binaryname = argv[0];
  8001f1:	8b 06                	mov    (%esi),%eax
  8001f3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001f8:	83 ec 08             	sub    $0x8,%esp
  8001fb:	56                   	push   %esi
  8001fc:	53                   	push   %ebx
  8001fd:	e8 31 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800202:	e8 0a 00 00 00       	call   800211 <exit>
}
  800207:	83 c4 10             	add    $0x10,%esp
  80020a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80020d:	5b                   	pop    %ebx
  80020e:	5e                   	pop    %esi
  80020f:	5d                   	pop    %ebp
  800210:	c3                   	ret    

00800211 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800217:	e8 5d 13 00 00       	call   801579 <close_all>
	sys_env_destroy(0);
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	6a 00                	push   $0x0
  800221:	e8 2f 0a 00 00       	call   800c55 <sys_env_destroy>
}
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	56                   	push   %esi
  80022f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800230:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800233:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800239:	e8 58 0a 00 00       	call   800c96 <sys_getenvid>
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 0c             	pushl  0xc(%ebp)
  800244:	ff 75 08             	pushl  0x8(%ebp)
  800247:	56                   	push   %esi
  800248:	50                   	push   %eax
  800249:	68 20 29 80 00       	push   $0x802920
  80024e:	e8 b3 00 00 00       	call   800306 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800253:	83 c4 18             	add    $0x18,%esp
  800256:	53                   	push   %ebx
  800257:	ff 75 10             	pushl  0x10(%ebp)
  80025a:	e8 56 00 00 00       	call   8002b5 <vcprintf>
	cprintf("\n");
  80025f:	c7 04 24 9f 28 80 00 	movl   $0x80289f,(%esp)
  800266:	e8 9b 00 00 00       	call   800306 <cprintf>
  80026b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80026e:	cc                   	int3   
  80026f:	eb fd                	jmp    80026e <_panic+0x43>

00800271 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	53                   	push   %ebx
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80027b:	8b 13                	mov    (%ebx),%edx
  80027d:	8d 42 01             	lea    0x1(%edx),%eax
  800280:	89 03                	mov    %eax,(%ebx)
  800282:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800285:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800289:	3d ff 00 00 00       	cmp    $0xff,%eax
  80028e:	74 09                	je     800299 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800290:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800294:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800297:	c9                   	leave  
  800298:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800299:	83 ec 08             	sub    $0x8,%esp
  80029c:	68 ff 00 00 00       	push   $0xff
  8002a1:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a4:	50                   	push   %eax
  8002a5:	e8 6e 09 00 00       	call   800c18 <sys_cputs>
		b->idx = 0;
  8002aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	eb db                	jmp    800290 <putch+0x1f>

008002b5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c5:	00 00 00 
	b.cnt = 0;
  8002c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002cf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d2:	ff 75 0c             	pushl  0xc(%ebp)
  8002d5:	ff 75 08             	pushl  0x8(%ebp)
  8002d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002de:	50                   	push   %eax
  8002df:	68 71 02 80 00       	push   $0x800271
  8002e4:	e8 19 01 00 00       	call   800402 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e9:	83 c4 08             	add    $0x8,%esp
  8002ec:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f8:	50                   	push   %eax
  8002f9:	e8 1a 09 00 00       	call   800c18 <sys_cputs>

	return b.cnt;
}
  8002fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800304:	c9                   	leave  
  800305:	c3                   	ret    

00800306 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80030f:	50                   	push   %eax
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	e8 9d ff ff ff       	call   8002b5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800318:	c9                   	leave  
  800319:	c3                   	ret    

0080031a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	57                   	push   %edi
  80031e:	56                   	push   %esi
  80031f:	53                   	push   %ebx
  800320:	83 ec 1c             	sub    $0x1c,%esp
  800323:	89 c7                	mov    %eax,%edi
  800325:	89 d6                	mov    %edx,%esi
  800327:	8b 45 08             	mov    0x8(%ebp),%eax
  80032a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80032d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800330:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800333:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800336:	bb 00 00 00 00       	mov    $0x0,%ebx
  80033b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80033e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800341:	3b 45 10             	cmp    0x10(%ebp),%eax
  800344:	89 d0                	mov    %edx,%eax
  800346:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800349:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80034c:	73 15                	jae    800363 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80034e:	83 eb 01             	sub    $0x1,%ebx
  800351:	85 db                	test   %ebx,%ebx
  800353:	7e 43                	jle    800398 <printnum+0x7e>
			putch(padc, putdat);
  800355:	83 ec 08             	sub    $0x8,%esp
  800358:	56                   	push   %esi
  800359:	ff 75 18             	pushl  0x18(%ebp)
  80035c:	ff d7                	call   *%edi
  80035e:	83 c4 10             	add    $0x10,%esp
  800361:	eb eb                	jmp    80034e <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	ff 75 18             	pushl  0x18(%ebp)
  800369:	8b 45 14             	mov    0x14(%ebp),%eax
  80036c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80036f:	53                   	push   %ebx
  800370:	ff 75 10             	pushl  0x10(%ebp)
  800373:	83 ec 08             	sub    $0x8,%esp
  800376:	ff 75 e4             	pushl  -0x1c(%ebp)
  800379:	ff 75 e0             	pushl  -0x20(%ebp)
  80037c:	ff 75 dc             	pushl  -0x24(%ebp)
  80037f:	ff 75 d8             	pushl  -0x28(%ebp)
  800382:	e8 59 22 00 00       	call   8025e0 <__udivdi3>
  800387:	83 c4 18             	add    $0x18,%esp
  80038a:	52                   	push   %edx
  80038b:	50                   	push   %eax
  80038c:	89 f2                	mov    %esi,%edx
  80038e:	89 f8                	mov    %edi,%eax
  800390:	e8 85 ff ff ff       	call   80031a <printnum>
  800395:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800398:	83 ec 08             	sub    $0x8,%esp
  80039b:	56                   	push   %esi
  80039c:	83 ec 04             	sub    $0x4,%esp
  80039f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a5:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a8:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ab:	e8 40 23 00 00       	call   8026f0 <__umoddi3>
  8003b0:	83 c4 14             	add    $0x14,%esp
  8003b3:	0f be 80 43 29 80 00 	movsbl 0x802943(%eax),%eax
  8003ba:	50                   	push   %eax
  8003bb:	ff d7                	call   *%edi
}
  8003bd:	83 c4 10             	add    $0x10,%esp
  8003c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c3:	5b                   	pop    %ebx
  8003c4:	5e                   	pop    %esi
  8003c5:	5f                   	pop    %edi
  8003c6:	5d                   	pop    %ebp
  8003c7:	c3                   	ret    

008003c8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ce:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003d2:	8b 10                	mov    (%eax),%edx
  8003d4:	3b 50 04             	cmp    0x4(%eax),%edx
  8003d7:	73 0a                	jae    8003e3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003dc:	89 08                	mov    %ecx,(%eax)
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	88 02                	mov    %al,(%edx)
}
  8003e3:	5d                   	pop    %ebp
  8003e4:	c3                   	ret    

008003e5 <printfmt>:
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003eb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ee:	50                   	push   %eax
  8003ef:	ff 75 10             	pushl  0x10(%ebp)
  8003f2:	ff 75 0c             	pushl  0xc(%ebp)
  8003f5:	ff 75 08             	pushl  0x8(%ebp)
  8003f8:	e8 05 00 00 00       	call   800402 <vprintfmt>
}
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	c9                   	leave  
  800401:	c3                   	ret    

00800402 <vprintfmt>:
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	57                   	push   %edi
  800406:	56                   	push   %esi
  800407:	53                   	push   %ebx
  800408:	83 ec 3c             	sub    $0x3c,%esp
  80040b:	8b 75 08             	mov    0x8(%ebp),%esi
  80040e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800411:	8b 7d 10             	mov    0x10(%ebp),%edi
  800414:	eb 0a                	jmp    800420 <vprintfmt+0x1e>
			putch(ch, putdat);
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	53                   	push   %ebx
  80041a:	50                   	push   %eax
  80041b:	ff d6                	call   *%esi
  80041d:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800420:	83 c7 01             	add    $0x1,%edi
  800423:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800427:	83 f8 25             	cmp    $0x25,%eax
  80042a:	74 0c                	je     800438 <vprintfmt+0x36>
			if (ch == '\0')
  80042c:	85 c0                	test   %eax,%eax
  80042e:	75 e6                	jne    800416 <vprintfmt+0x14>
}
  800430:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800433:	5b                   	pop    %ebx
  800434:	5e                   	pop    %esi
  800435:	5f                   	pop    %edi
  800436:	5d                   	pop    %ebp
  800437:	c3                   	ret    
		padc = ' ';
  800438:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80043c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800443:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80044a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800451:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800456:	8d 47 01             	lea    0x1(%edi),%eax
  800459:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80045c:	0f b6 17             	movzbl (%edi),%edx
  80045f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800462:	3c 55                	cmp    $0x55,%al
  800464:	0f 87 ba 03 00 00    	ja     800824 <vprintfmt+0x422>
  80046a:	0f b6 c0             	movzbl %al,%eax
  80046d:	ff 24 85 80 2a 80 00 	jmp    *0x802a80(,%eax,4)
  800474:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800477:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80047b:	eb d9                	jmp    800456 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80047d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800480:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800484:	eb d0                	jmp    800456 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800486:	0f b6 d2             	movzbl %dl,%edx
  800489:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80048c:	b8 00 00 00 00       	mov    $0x0,%eax
  800491:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800494:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800497:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80049b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80049e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a1:	83 f9 09             	cmp    $0x9,%ecx
  8004a4:	77 55                	ja     8004fb <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8004a6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004a9:	eb e9                	jmp    800494 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8004ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b6:	8d 40 04             	lea    0x4(%eax),%eax
  8004b9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004bf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c3:	79 91                	jns    800456 <vprintfmt+0x54>
				width = precision, precision = -1;
  8004c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004d2:	eb 82                	jmp    800456 <vprintfmt+0x54>
  8004d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d7:	85 c0                	test   %eax,%eax
  8004d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004de:	0f 49 d0             	cmovns %eax,%edx
  8004e1:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004e7:	e9 6a ff ff ff       	jmp    800456 <vprintfmt+0x54>
  8004ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004ef:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004f6:	e9 5b ff ff ff       	jmp    800456 <vprintfmt+0x54>
  8004fb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800501:	eb bc                	jmp    8004bf <vprintfmt+0xbd>
			lflag++;
  800503:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800506:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800509:	e9 48 ff ff ff       	jmp    800456 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80050e:	8b 45 14             	mov    0x14(%ebp),%eax
  800511:	8d 78 04             	lea    0x4(%eax),%edi
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	53                   	push   %ebx
  800518:	ff 30                	pushl  (%eax)
  80051a:	ff d6                	call   *%esi
			break;
  80051c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80051f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800522:	e9 9c 02 00 00       	jmp    8007c3 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800527:	8b 45 14             	mov    0x14(%ebp),%eax
  80052a:	8d 78 04             	lea    0x4(%eax),%edi
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	99                   	cltd   
  800530:	31 d0                	xor    %edx,%eax
  800532:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800534:	83 f8 0f             	cmp    $0xf,%eax
  800537:	7f 23                	jg     80055c <vprintfmt+0x15a>
  800539:	8b 14 85 e0 2b 80 00 	mov    0x802be0(,%eax,4),%edx
  800540:	85 d2                	test   %edx,%edx
  800542:	74 18                	je     80055c <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800544:	52                   	push   %edx
  800545:	68 c6 2e 80 00       	push   $0x802ec6
  80054a:	53                   	push   %ebx
  80054b:	56                   	push   %esi
  80054c:	e8 94 fe ff ff       	call   8003e5 <printfmt>
  800551:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800554:	89 7d 14             	mov    %edi,0x14(%ebp)
  800557:	e9 67 02 00 00       	jmp    8007c3 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  80055c:	50                   	push   %eax
  80055d:	68 5b 29 80 00       	push   $0x80295b
  800562:	53                   	push   %ebx
  800563:	56                   	push   %esi
  800564:	e8 7c fe ff ff       	call   8003e5 <printfmt>
  800569:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80056c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80056f:	e9 4f 02 00 00       	jmp    8007c3 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	83 c0 04             	add    $0x4,%eax
  80057a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800582:	85 d2                	test   %edx,%edx
  800584:	b8 54 29 80 00       	mov    $0x802954,%eax
  800589:	0f 45 c2             	cmovne %edx,%eax
  80058c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80058f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800593:	7e 06                	jle    80059b <vprintfmt+0x199>
  800595:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800599:	75 0d                	jne    8005a8 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80059b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80059e:	89 c7                	mov    %eax,%edi
  8005a0:	03 45 e0             	add    -0x20(%ebp),%eax
  8005a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a6:	eb 3f                	jmp    8005e7 <vprintfmt+0x1e5>
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8005ae:	50                   	push   %eax
  8005af:	e8 0d 03 00 00       	call   8008c1 <strnlen>
  8005b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b7:	29 c2                	sub    %eax,%edx
  8005b9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005c1:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c8:	85 ff                	test   %edi,%edi
  8005ca:	7e 58                	jle    800624 <vprintfmt+0x222>
					putch(padc, putdat);
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	53                   	push   %ebx
  8005d0:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d5:	83 ef 01             	sub    $0x1,%edi
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	eb eb                	jmp    8005c8 <vprintfmt+0x1c6>
					putch(ch, putdat);
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	53                   	push   %ebx
  8005e1:	52                   	push   %edx
  8005e2:	ff d6                	call   *%esi
  8005e4:	83 c4 10             	add    $0x10,%esp
  8005e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005ea:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ec:	83 c7 01             	add    $0x1,%edi
  8005ef:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005f3:	0f be d0             	movsbl %al,%edx
  8005f6:	85 d2                	test   %edx,%edx
  8005f8:	74 45                	je     80063f <vprintfmt+0x23d>
  8005fa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005fe:	78 06                	js     800606 <vprintfmt+0x204>
  800600:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800604:	78 35                	js     80063b <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800606:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80060a:	74 d1                	je     8005dd <vprintfmt+0x1db>
  80060c:	0f be c0             	movsbl %al,%eax
  80060f:	83 e8 20             	sub    $0x20,%eax
  800612:	83 f8 5e             	cmp    $0x5e,%eax
  800615:	76 c6                	jbe    8005dd <vprintfmt+0x1db>
					putch('?', putdat);
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	53                   	push   %ebx
  80061b:	6a 3f                	push   $0x3f
  80061d:	ff d6                	call   *%esi
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	eb c3                	jmp    8005e7 <vprintfmt+0x1e5>
  800624:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800627:	85 d2                	test   %edx,%edx
  800629:	b8 00 00 00 00       	mov    $0x0,%eax
  80062e:	0f 49 c2             	cmovns %edx,%eax
  800631:	29 c2                	sub    %eax,%edx
  800633:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800636:	e9 60 ff ff ff       	jmp    80059b <vprintfmt+0x199>
  80063b:	89 cf                	mov    %ecx,%edi
  80063d:	eb 02                	jmp    800641 <vprintfmt+0x23f>
  80063f:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800641:	85 ff                	test   %edi,%edi
  800643:	7e 10                	jle    800655 <vprintfmt+0x253>
				putch(' ', putdat);
  800645:	83 ec 08             	sub    $0x8,%esp
  800648:	53                   	push   %ebx
  800649:	6a 20                	push   $0x20
  80064b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80064d:	83 ef 01             	sub    $0x1,%edi
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	eb ec                	jmp    800641 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800655:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800658:	89 45 14             	mov    %eax,0x14(%ebp)
  80065b:	e9 63 01 00 00       	jmp    8007c3 <vprintfmt+0x3c1>
	if (lflag >= 2)
  800660:	83 f9 01             	cmp    $0x1,%ecx
  800663:	7f 1b                	jg     800680 <vprintfmt+0x27e>
	else if (lflag)
  800665:	85 c9                	test   %ecx,%ecx
  800667:	74 63                	je     8006cc <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800671:	99                   	cltd   
  800672:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8d 40 04             	lea    0x4(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
  80067e:	eb 17                	jmp    800697 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8b 50 04             	mov    0x4(%eax),%edx
  800686:	8b 00                	mov    (%eax),%eax
  800688:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8d 40 08             	lea    0x8(%eax),%eax
  800694:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800697:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80069a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80069d:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006a2:	85 c9                	test   %ecx,%ecx
  8006a4:	0f 89 ff 00 00 00    	jns    8007a9 <vprintfmt+0x3a7>
				putch('-', putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	53                   	push   %ebx
  8006ae:	6a 2d                	push   $0x2d
  8006b0:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006b8:	f7 da                	neg    %edx
  8006ba:	83 d1 00             	adc    $0x0,%ecx
  8006bd:	f7 d9                	neg    %ecx
  8006bf:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c7:	e9 dd 00 00 00       	jmp    8007a9 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d4:	99                   	cltd   
  8006d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e1:	eb b4                	jmp    800697 <vprintfmt+0x295>
	if (lflag >= 2)
  8006e3:	83 f9 01             	cmp    $0x1,%ecx
  8006e6:	7f 1e                	jg     800706 <vprintfmt+0x304>
	else if (lflag)
  8006e8:	85 c9                	test   %ecx,%ecx
  8006ea:	74 32                	je     80071e <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8b 10                	mov    (%eax),%edx
  8006f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f6:	8d 40 04             	lea    0x4(%eax),%eax
  8006f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800701:	e9 a3 00 00 00       	jmp    8007a9 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8b 10                	mov    (%eax),%edx
  80070b:	8b 48 04             	mov    0x4(%eax),%ecx
  80070e:	8d 40 08             	lea    0x8(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800714:	b8 0a 00 00 00       	mov    $0xa,%eax
  800719:	e9 8b 00 00 00       	jmp    8007a9 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8b 10                	mov    (%eax),%edx
  800723:	b9 00 00 00 00       	mov    $0x0,%ecx
  800728:	8d 40 04             	lea    0x4(%eax),%eax
  80072b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800733:	eb 74                	jmp    8007a9 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800735:	83 f9 01             	cmp    $0x1,%ecx
  800738:	7f 1b                	jg     800755 <vprintfmt+0x353>
	else if (lflag)
  80073a:	85 c9                	test   %ecx,%ecx
  80073c:	74 2c                	je     80076a <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8b 10                	mov    (%eax),%edx
  800743:	b9 00 00 00 00       	mov    $0x0,%ecx
  800748:	8d 40 04             	lea    0x4(%eax),%eax
  80074b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074e:	b8 08 00 00 00       	mov    $0x8,%eax
  800753:	eb 54                	jmp    8007a9 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8b 10                	mov    (%eax),%edx
  80075a:	8b 48 04             	mov    0x4(%eax),%ecx
  80075d:	8d 40 08             	lea    0x8(%eax),%eax
  800760:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800763:	b8 08 00 00 00       	mov    $0x8,%eax
  800768:	eb 3f                	jmp    8007a9 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	8b 10                	mov    (%eax),%edx
  80076f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800774:	8d 40 04             	lea    0x4(%eax),%eax
  800777:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077a:	b8 08 00 00 00       	mov    $0x8,%eax
  80077f:	eb 28                	jmp    8007a9 <vprintfmt+0x3a7>
			putch('0', putdat);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	53                   	push   %ebx
  800785:	6a 30                	push   $0x30
  800787:	ff d6                	call   *%esi
			putch('x', putdat);
  800789:	83 c4 08             	add    $0x8,%esp
  80078c:	53                   	push   %ebx
  80078d:	6a 78                	push   $0x78
  80078f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8b 10                	mov    (%eax),%edx
  800796:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80079b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80079e:	8d 40 04             	lea    0x4(%eax),%eax
  8007a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007a9:	83 ec 0c             	sub    $0xc,%esp
  8007ac:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007b0:	57                   	push   %edi
  8007b1:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b4:	50                   	push   %eax
  8007b5:	51                   	push   %ecx
  8007b6:	52                   	push   %edx
  8007b7:	89 da                	mov    %ebx,%edx
  8007b9:	89 f0                	mov    %esi,%eax
  8007bb:	e8 5a fb ff ff       	call   80031a <printnum>
			break;
  8007c0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c6:	e9 55 fc ff ff       	jmp    800420 <vprintfmt+0x1e>
	if (lflag >= 2)
  8007cb:	83 f9 01             	cmp    $0x1,%ecx
  8007ce:	7f 1b                	jg     8007eb <vprintfmt+0x3e9>
	else if (lflag)
  8007d0:	85 c9                	test   %ecx,%ecx
  8007d2:	74 2c                	je     800800 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	8b 10                	mov    (%eax),%edx
  8007d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007de:	8d 40 04             	lea    0x4(%eax),%eax
  8007e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e4:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e9:	eb be                	jmp    8007a9 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8b 10                	mov    (%eax),%edx
  8007f0:	8b 48 04             	mov    0x4(%eax),%ecx
  8007f3:	8d 40 08             	lea    0x8(%eax),%eax
  8007f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fe:	eb a9                	jmp    8007a9 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8b 10                	mov    (%eax),%edx
  800805:	b9 00 00 00 00       	mov    $0x0,%ecx
  80080a:	8d 40 04             	lea    0x4(%eax),%eax
  80080d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800810:	b8 10 00 00 00       	mov    $0x10,%eax
  800815:	eb 92                	jmp    8007a9 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	53                   	push   %ebx
  80081b:	6a 25                	push   $0x25
  80081d:	ff d6                	call   *%esi
			break;
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	eb 9f                	jmp    8007c3 <vprintfmt+0x3c1>
			putch('%', putdat);
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	53                   	push   %ebx
  800828:	6a 25                	push   $0x25
  80082a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	89 f8                	mov    %edi,%eax
  800831:	eb 03                	jmp    800836 <vprintfmt+0x434>
  800833:	83 e8 01             	sub    $0x1,%eax
  800836:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80083a:	75 f7                	jne    800833 <vprintfmt+0x431>
  80083c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083f:	eb 82                	jmp    8007c3 <vprintfmt+0x3c1>

00800841 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800841:	55                   	push   %ebp
  800842:	89 e5                	mov    %esp,%ebp
  800844:	83 ec 18             	sub    $0x18,%esp
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80084d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800850:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800854:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800857:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80085e:	85 c0                	test   %eax,%eax
  800860:	74 26                	je     800888 <vsnprintf+0x47>
  800862:	85 d2                	test   %edx,%edx
  800864:	7e 22                	jle    800888 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800866:	ff 75 14             	pushl  0x14(%ebp)
  800869:	ff 75 10             	pushl  0x10(%ebp)
  80086c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80086f:	50                   	push   %eax
  800870:	68 c8 03 80 00       	push   $0x8003c8
  800875:	e8 88 fb ff ff       	call   800402 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80087a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80087d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800883:	83 c4 10             	add    $0x10,%esp
}
  800886:	c9                   	leave  
  800887:	c3                   	ret    
		return -E_INVAL;
  800888:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80088d:	eb f7                	jmp    800886 <vsnprintf+0x45>

0080088f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800895:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800898:	50                   	push   %eax
  800899:	ff 75 10             	pushl  0x10(%ebp)
  80089c:	ff 75 0c             	pushl  0xc(%ebp)
  80089f:	ff 75 08             	pushl  0x8(%ebp)
  8008a2:	e8 9a ff ff ff       	call   800841 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008a7:	c9                   	leave  
  8008a8:	c3                   	ret    

008008a9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008af:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b8:	74 05                	je     8008bf <strlen+0x16>
		n++;
  8008ba:	83 c0 01             	add    $0x1,%eax
  8008bd:	eb f5                	jmp    8008b4 <strlen+0xb>
	return n;
}
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	74 0d                	je     8008e0 <strnlen+0x1f>
  8008d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008d7:	74 05                	je     8008de <strnlen+0x1d>
		n++;
  8008d9:	83 c2 01             	add    $0x1,%edx
  8008dc:	eb f1                	jmp    8008cf <strnlen+0xe>
  8008de:	89 d0                	mov    %edx,%eax
	return n;
}
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	53                   	push   %ebx
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f1:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008f5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008f8:	83 c2 01             	add    $0x1,%edx
  8008fb:	84 c9                	test   %cl,%cl
  8008fd:	75 f2                	jne    8008f1 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008ff:	5b                   	pop    %ebx
  800900:	5d                   	pop    %ebp
  800901:	c3                   	ret    

00800902 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	53                   	push   %ebx
  800906:	83 ec 10             	sub    $0x10,%esp
  800909:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80090c:	53                   	push   %ebx
  80090d:	e8 97 ff ff ff       	call   8008a9 <strlen>
  800912:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	01 d8                	add    %ebx,%eax
  80091a:	50                   	push   %eax
  80091b:	e8 c2 ff ff ff       	call   8008e2 <strcpy>
	return dst;
}
  800920:	89 d8                	mov    %ebx,%eax
  800922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800925:	c9                   	leave  
  800926:	c3                   	ret    

00800927 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	56                   	push   %esi
  80092b:	53                   	push   %ebx
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800932:	89 c6                	mov    %eax,%esi
  800934:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800937:	89 c2                	mov    %eax,%edx
  800939:	39 f2                	cmp    %esi,%edx
  80093b:	74 11                	je     80094e <strncpy+0x27>
		*dst++ = *src;
  80093d:	83 c2 01             	add    $0x1,%edx
  800940:	0f b6 19             	movzbl (%ecx),%ebx
  800943:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800946:	80 fb 01             	cmp    $0x1,%bl
  800949:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80094c:	eb eb                	jmp    800939 <strncpy+0x12>
	}
	return ret;
}
  80094e:	5b                   	pop    %ebx
  80094f:	5e                   	pop    %esi
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	56                   	push   %esi
  800956:	53                   	push   %ebx
  800957:	8b 75 08             	mov    0x8(%ebp),%esi
  80095a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095d:	8b 55 10             	mov    0x10(%ebp),%edx
  800960:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800962:	85 d2                	test   %edx,%edx
  800964:	74 21                	je     800987 <strlcpy+0x35>
  800966:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80096a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80096c:	39 c2                	cmp    %eax,%edx
  80096e:	74 14                	je     800984 <strlcpy+0x32>
  800970:	0f b6 19             	movzbl (%ecx),%ebx
  800973:	84 db                	test   %bl,%bl
  800975:	74 0b                	je     800982 <strlcpy+0x30>
			*dst++ = *src++;
  800977:	83 c1 01             	add    $0x1,%ecx
  80097a:	83 c2 01             	add    $0x1,%edx
  80097d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800980:	eb ea                	jmp    80096c <strlcpy+0x1a>
  800982:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800984:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800987:	29 f0                	sub    %esi,%eax
}
  800989:	5b                   	pop    %ebx
  80098a:	5e                   	pop    %esi
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800996:	0f b6 01             	movzbl (%ecx),%eax
  800999:	84 c0                	test   %al,%al
  80099b:	74 0c                	je     8009a9 <strcmp+0x1c>
  80099d:	3a 02                	cmp    (%edx),%al
  80099f:	75 08                	jne    8009a9 <strcmp+0x1c>
		p++, q++;
  8009a1:	83 c1 01             	add    $0x1,%ecx
  8009a4:	83 c2 01             	add    $0x1,%edx
  8009a7:	eb ed                	jmp    800996 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a9:	0f b6 c0             	movzbl %al,%eax
  8009ac:	0f b6 12             	movzbl (%edx),%edx
  8009af:	29 d0                	sub    %edx,%eax
}
  8009b1:	5d                   	pop    %ebp
  8009b2:	c3                   	ret    

008009b3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	53                   	push   %ebx
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bd:	89 c3                	mov    %eax,%ebx
  8009bf:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c2:	eb 06                	jmp    8009ca <strncmp+0x17>
		n--, p++, q++;
  8009c4:	83 c0 01             	add    $0x1,%eax
  8009c7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009ca:	39 d8                	cmp    %ebx,%eax
  8009cc:	74 16                	je     8009e4 <strncmp+0x31>
  8009ce:	0f b6 08             	movzbl (%eax),%ecx
  8009d1:	84 c9                	test   %cl,%cl
  8009d3:	74 04                	je     8009d9 <strncmp+0x26>
  8009d5:	3a 0a                	cmp    (%edx),%cl
  8009d7:	74 eb                	je     8009c4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d9:	0f b6 00             	movzbl (%eax),%eax
  8009dc:	0f b6 12             	movzbl (%edx),%edx
  8009df:	29 d0                	sub    %edx,%eax
}
  8009e1:	5b                   	pop    %ebx
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    
		return 0;
  8009e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e9:	eb f6                	jmp    8009e1 <strncmp+0x2e>

008009eb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f5:	0f b6 10             	movzbl (%eax),%edx
  8009f8:	84 d2                	test   %dl,%dl
  8009fa:	74 09                	je     800a05 <strchr+0x1a>
		if (*s == c)
  8009fc:	38 ca                	cmp    %cl,%dl
  8009fe:	74 0a                	je     800a0a <strchr+0x1f>
	for (; *s; s++)
  800a00:	83 c0 01             	add    $0x1,%eax
  800a03:	eb f0                	jmp    8009f5 <strchr+0xa>
			return (char *) s;
	return 0;
  800a05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a16:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a19:	38 ca                	cmp    %cl,%dl
  800a1b:	74 09                	je     800a26 <strfind+0x1a>
  800a1d:	84 d2                	test   %dl,%dl
  800a1f:	74 05                	je     800a26 <strfind+0x1a>
	for (; *s; s++)
  800a21:	83 c0 01             	add    $0x1,%eax
  800a24:	eb f0                	jmp    800a16 <strfind+0xa>
			break;
	return (char *) s;
}
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	57                   	push   %edi
  800a2c:	56                   	push   %esi
  800a2d:	53                   	push   %ebx
  800a2e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a31:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a34:	85 c9                	test   %ecx,%ecx
  800a36:	74 31                	je     800a69 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a38:	89 f8                	mov    %edi,%eax
  800a3a:	09 c8                	or     %ecx,%eax
  800a3c:	a8 03                	test   $0x3,%al
  800a3e:	75 23                	jne    800a63 <memset+0x3b>
		c &= 0xFF;
  800a40:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a44:	89 d3                	mov    %edx,%ebx
  800a46:	c1 e3 08             	shl    $0x8,%ebx
  800a49:	89 d0                	mov    %edx,%eax
  800a4b:	c1 e0 18             	shl    $0x18,%eax
  800a4e:	89 d6                	mov    %edx,%esi
  800a50:	c1 e6 10             	shl    $0x10,%esi
  800a53:	09 f0                	or     %esi,%eax
  800a55:	09 c2                	or     %eax,%edx
  800a57:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a59:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a5c:	89 d0                	mov    %edx,%eax
  800a5e:	fc                   	cld    
  800a5f:	f3 ab                	rep stos %eax,%es:(%edi)
  800a61:	eb 06                	jmp    800a69 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a66:	fc                   	cld    
  800a67:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a69:	89 f8                	mov    %edi,%eax
  800a6b:	5b                   	pop    %ebx
  800a6c:	5e                   	pop    %esi
  800a6d:	5f                   	pop    %edi
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    

00800a70 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	57                   	push   %edi
  800a74:	56                   	push   %esi
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a7e:	39 c6                	cmp    %eax,%esi
  800a80:	73 32                	jae    800ab4 <memmove+0x44>
  800a82:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a85:	39 c2                	cmp    %eax,%edx
  800a87:	76 2b                	jbe    800ab4 <memmove+0x44>
		s += n;
		d += n;
  800a89:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8c:	89 fe                	mov    %edi,%esi
  800a8e:	09 ce                	or     %ecx,%esi
  800a90:	09 d6                	or     %edx,%esi
  800a92:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a98:	75 0e                	jne    800aa8 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a9a:	83 ef 04             	sub    $0x4,%edi
  800a9d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa3:	fd                   	std    
  800aa4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa6:	eb 09                	jmp    800ab1 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aa8:	83 ef 01             	sub    $0x1,%edi
  800aab:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aae:	fd                   	std    
  800aaf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab1:	fc                   	cld    
  800ab2:	eb 1a                	jmp    800ace <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab4:	89 c2                	mov    %eax,%edx
  800ab6:	09 ca                	or     %ecx,%edx
  800ab8:	09 f2                	or     %esi,%edx
  800aba:	f6 c2 03             	test   $0x3,%dl
  800abd:	75 0a                	jne    800ac9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800abf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac2:	89 c7                	mov    %eax,%edi
  800ac4:	fc                   	cld    
  800ac5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac7:	eb 05                	jmp    800ace <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ac9:	89 c7                	mov    %eax,%edi
  800acb:	fc                   	cld    
  800acc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ace:	5e                   	pop    %esi
  800acf:	5f                   	pop    %edi
  800ad0:	5d                   	pop    %ebp
  800ad1:	c3                   	ret    

00800ad2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
  800ad5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ad8:	ff 75 10             	pushl  0x10(%ebp)
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	ff 75 08             	pushl  0x8(%ebp)
  800ae1:	e8 8a ff ff ff       	call   800a70 <memmove>
}
  800ae6:	c9                   	leave  
  800ae7:	c3                   	ret    

00800ae8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	56                   	push   %esi
  800aec:	53                   	push   %ebx
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af3:	89 c6                	mov    %eax,%esi
  800af5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800af8:	39 f0                	cmp    %esi,%eax
  800afa:	74 1c                	je     800b18 <memcmp+0x30>
		if (*s1 != *s2)
  800afc:	0f b6 08             	movzbl (%eax),%ecx
  800aff:	0f b6 1a             	movzbl (%edx),%ebx
  800b02:	38 d9                	cmp    %bl,%cl
  800b04:	75 08                	jne    800b0e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b06:	83 c0 01             	add    $0x1,%eax
  800b09:	83 c2 01             	add    $0x1,%edx
  800b0c:	eb ea                	jmp    800af8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b0e:	0f b6 c1             	movzbl %cl,%eax
  800b11:	0f b6 db             	movzbl %bl,%ebx
  800b14:	29 d8                	sub    %ebx,%eax
  800b16:	eb 05                	jmp    800b1d <memcmp+0x35>
	}

	return 0;
  800b18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1d:	5b                   	pop    %ebx
  800b1e:	5e                   	pop    %esi
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b2a:	89 c2                	mov    %eax,%edx
  800b2c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b2f:	39 d0                	cmp    %edx,%eax
  800b31:	73 09                	jae    800b3c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b33:	38 08                	cmp    %cl,(%eax)
  800b35:	74 05                	je     800b3c <memfind+0x1b>
	for (; s < ends; s++)
  800b37:	83 c0 01             	add    $0x1,%eax
  800b3a:	eb f3                	jmp    800b2f <memfind+0xe>
			break;
	return (void *) s;
}
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	57                   	push   %edi
  800b42:	56                   	push   %esi
  800b43:	53                   	push   %ebx
  800b44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b4a:	eb 03                	jmp    800b4f <strtol+0x11>
		s++;
  800b4c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b4f:	0f b6 01             	movzbl (%ecx),%eax
  800b52:	3c 20                	cmp    $0x20,%al
  800b54:	74 f6                	je     800b4c <strtol+0xe>
  800b56:	3c 09                	cmp    $0x9,%al
  800b58:	74 f2                	je     800b4c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b5a:	3c 2b                	cmp    $0x2b,%al
  800b5c:	74 2a                	je     800b88 <strtol+0x4a>
	int neg = 0;
  800b5e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b63:	3c 2d                	cmp    $0x2d,%al
  800b65:	74 2b                	je     800b92 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b67:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b6d:	75 0f                	jne    800b7e <strtol+0x40>
  800b6f:	80 39 30             	cmpb   $0x30,(%ecx)
  800b72:	74 28                	je     800b9c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b74:	85 db                	test   %ebx,%ebx
  800b76:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b7b:	0f 44 d8             	cmove  %eax,%ebx
  800b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b83:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b86:	eb 50                	jmp    800bd8 <strtol+0x9a>
		s++;
  800b88:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b8b:	bf 00 00 00 00       	mov    $0x0,%edi
  800b90:	eb d5                	jmp    800b67 <strtol+0x29>
		s++, neg = 1;
  800b92:	83 c1 01             	add    $0x1,%ecx
  800b95:	bf 01 00 00 00       	mov    $0x1,%edi
  800b9a:	eb cb                	jmp    800b67 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ba0:	74 0e                	je     800bb0 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ba2:	85 db                	test   %ebx,%ebx
  800ba4:	75 d8                	jne    800b7e <strtol+0x40>
		s++, base = 8;
  800ba6:	83 c1 01             	add    $0x1,%ecx
  800ba9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bae:	eb ce                	jmp    800b7e <strtol+0x40>
		s += 2, base = 16;
  800bb0:	83 c1 02             	add    $0x2,%ecx
  800bb3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bb8:	eb c4                	jmp    800b7e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bba:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bbd:	89 f3                	mov    %esi,%ebx
  800bbf:	80 fb 19             	cmp    $0x19,%bl
  800bc2:	77 29                	ja     800bed <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bc4:	0f be d2             	movsbl %dl,%edx
  800bc7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bca:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bcd:	7d 30                	jge    800bff <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bcf:	83 c1 01             	add    $0x1,%ecx
  800bd2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bd6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bd8:	0f b6 11             	movzbl (%ecx),%edx
  800bdb:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bde:	89 f3                	mov    %esi,%ebx
  800be0:	80 fb 09             	cmp    $0x9,%bl
  800be3:	77 d5                	ja     800bba <strtol+0x7c>
			dig = *s - '0';
  800be5:	0f be d2             	movsbl %dl,%edx
  800be8:	83 ea 30             	sub    $0x30,%edx
  800beb:	eb dd                	jmp    800bca <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bed:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bf0:	89 f3                	mov    %esi,%ebx
  800bf2:	80 fb 19             	cmp    $0x19,%bl
  800bf5:	77 08                	ja     800bff <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bf7:	0f be d2             	movsbl %dl,%edx
  800bfa:	83 ea 37             	sub    $0x37,%edx
  800bfd:	eb cb                	jmp    800bca <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c03:	74 05                	je     800c0a <strtol+0xcc>
		*endptr = (char *) s;
  800c05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c08:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c0a:	89 c2                	mov    %eax,%edx
  800c0c:	f7 da                	neg    %edx
  800c0e:	85 ff                	test   %edi,%edi
  800c10:	0f 45 c2             	cmovne %edx,%eax
}
  800c13:	5b                   	pop    %ebx
  800c14:	5e                   	pop    %esi
  800c15:	5f                   	pop    %edi
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	57                   	push   %edi
  800c1c:	56                   	push   %esi
  800c1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c23:	8b 55 08             	mov    0x8(%ebp),%edx
  800c26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c29:	89 c3                	mov    %eax,%ebx
  800c2b:	89 c7                	mov    %eax,%edi
  800c2d:	89 c6                	mov    %eax,%esi
  800c2f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c31:	5b                   	pop    %ebx
  800c32:	5e                   	pop    %esi
  800c33:	5f                   	pop    %edi
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	57                   	push   %edi
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c41:	b8 01 00 00 00       	mov    $0x1,%eax
  800c46:	89 d1                	mov    %edx,%ecx
  800c48:	89 d3                	mov    %edx,%ebx
  800c4a:	89 d7                	mov    %edx,%edi
  800c4c:	89 d6                	mov    %edx,%esi
  800c4e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
  800c5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c63:	8b 55 08             	mov    0x8(%ebp),%edx
  800c66:	b8 03 00 00 00       	mov    $0x3,%eax
  800c6b:	89 cb                	mov    %ecx,%ebx
  800c6d:	89 cf                	mov    %ecx,%edi
  800c6f:	89 ce                	mov    %ecx,%esi
  800c71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c73:	85 c0                	test   %eax,%eax
  800c75:	7f 08                	jg     800c7f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7a:	5b                   	pop    %ebx
  800c7b:	5e                   	pop    %esi
  800c7c:	5f                   	pop    %edi
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7f:	83 ec 0c             	sub    $0xc,%esp
  800c82:	50                   	push   %eax
  800c83:	6a 03                	push   $0x3
  800c85:	68 3f 2c 80 00       	push   $0x802c3f
  800c8a:	6a 23                	push   $0x23
  800c8c:	68 5c 2c 80 00       	push   $0x802c5c
  800c91:	e8 95 f5 ff ff       	call   80022b <_panic>

00800c96 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	57                   	push   %edi
  800c9a:	56                   	push   %esi
  800c9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca1:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca6:	89 d1                	mov    %edx,%ecx
  800ca8:	89 d3                	mov    %edx,%ebx
  800caa:	89 d7                	mov    %edx,%edi
  800cac:	89 d6                	mov    %edx,%esi
  800cae:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <sys_yield>:

void
sys_yield(void)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc5:	89 d1                	mov    %edx,%ecx
  800cc7:	89 d3                	mov    %edx,%ebx
  800cc9:	89 d7                	mov    %edx,%edi
  800ccb:	89 d6                	mov    %edx,%esi
  800ccd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
  800cda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdd:	be 00 00 00 00       	mov    $0x0,%esi
  800ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce8:	b8 04 00 00 00       	mov    $0x4,%eax
  800ced:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf0:	89 f7                	mov    %esi,%edi
  800cf2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	7f 08                	jg     800d00 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d00:	83 ec 0c             	sub    $0xc,%esp
  800d03:	50                   	push   %eax
  800d04:	6a 04                	push   $0x4
  800d06:	68 3f 2c 80 00       	push   $0x802c3f
  800d0b:	6a 23                	push   $0x23
  800d0d:	68 5c 2c 80 00       	push   $0x802c5c
  800d12:	e8 14 f5 ff ff       	call   80022b <_panic>

00800d17 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
  800d1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d20:	8b 55 08             	mov    0x8(%ebp),%edx
  800d23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d26:	b8 05 00 00 00       	mov    $0x5,%eax
  800d2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d2e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d31:	8b 75 18             	mov    0x18(%ebp),%esi
  800d34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d36:	85 c0                	test   %eax,%eax
  800d38:	7f 08                	jg     800d42 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5f                   	pop    %edi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d42:	83 ec 0c             	sub    $0xc,%esp
  800d45:	50                   	push   %eax
  800d46:	6a 05                	push   $0x5
  800d48:	68 3f 2c 80 00       	push   $0x802c3f
  800d4d:	6a 23                	push   $0x23
  800d4f:	68 5c 2c 80 00       	push   $0x802c5c
  800d54:	e8 d2 f4 ff ff       	call   80022b <_panic>

00800d59 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6d:	b8 06 00 00 00       	mov    $0x6,%eax
  800d72:	89 df                	mov    %ebx,%edi
  800d74:	89 de                	mov    %ebx,%esi
  800d76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	7f 08                	jg     800d84 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d84:	83 ec 0c             	sub    $0xc,%esp
  800d87:	50                   	push   %eax
  800d88:	6a 06                	push   $0x6
  800d8a:	68 3f 2c 80 00       	push   $0x802c3f
  800d8f:	6a 23                	push   $0x23
  800d91:	68 5c 2c 80 00       	push   $0x802c5c
  800d96:	e8 90 f4 ff ff       	call   80022b <_panic>

00800d9b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	57                   	push   %edi
  800d9f:	56                   	push   %esi
  800da0:	53                   	push   %ebx
  800da1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daf:	b8 08 00 00 00       	mov    $0x8,%eax
  800db4:	89 df                	mov    %ebx,%edi
  800db6:	89 de                	mov    %ebx,%esi
  800db8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	7f 08                	jg     800dc6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc6:	83 ec 0c             	sub    $0xc,%esp
  800dc9:	50                   	push   %eax
  800dca:	6a 08                	push   $0x8
  800dcc:	68 3f 2c 80 00       	push   $0x802c3f
  800dd1:	6a 23                	push   $0x23
  800dd3:	68 5c 2c 80 00       	push   $0x802c5c
  800dd8:	e8 4e f4 ff ff       	call   80022b <_panic>

00800ddd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
  800de3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800deb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df1:	b8 09 00 00 00       	mov    $0x9,%eax
  800df6:	89 df                	mov    %ebx,%edi
  800df8:	89 de                	mov    %ebx,%esi
  800dfa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfc:	85 c0                	test   %eax,%eax
  800dfe:	7f 08                	jg     800e08 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e03:	5b                   	pop    %ebx
  800e04:	5e                   	pop    %esi
  800e05:	5f                   	pop    %edi
  800e06:	5d                   	pop    %ebp
  800e07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e08:	83 ec 0c             	sub    $0xc,%esp
  800e0b:	50                   	push   %eax
  800e0c:	6a 09                	push   $0x9
  800e0e:	68 3f 2c 80 00       	push   $0x802c3f
  800e13:	6a 23                	push   $0x23
  800e15:	68 5c 2c 80 00       	push   $0x802c5c
  800e1a:	e8 0c f4 ff ff       	call   80022b <_panic>

00800e1f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	57                   	push   %edi
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
  800e25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e33:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e38:	89 df                	mov    %ebx,%edi
  800e3a:	89 de                	mov    %ebx,%esi
  800e3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	7f 08                	jg     800e4a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e45:	5b                   	pop    %ebx
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4a:	83 ec 0c             	sub    $0xc,%esp
  800e4d:	50                   	push   %eax
  800e4e:	6a 0a                	push   $0xa
  800e50:	68 3f 2c 80 00       	push   $0x802c3f
  800e55:	6a 23                	push   $0x23
  800e57:	68 5c 2c 80 00       	push   $0x802c5c
  800e5c:	e8 ca f3 ff ff       	call   80022b <_panic>

00800e61 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	57                   	push   %edi
  800e65:	56                   	push   %esi
  800e66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e67:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e72:	be 00 00 00 00       	mov    $0x0,%esi
  800e77:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e7d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e7f:	5b                   	pop    %ebx
  800e80:	5e                   	pop    %esi
  800e81:	5f                   	pop    %edi
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    

00800e84 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	57                   	push   %edi
  800e88:	56                   	push   %esi
  800e89:	53                   	push   %ebx
  800e8a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e92:	8b 55 08             	mov    0x8(%ebp),%edx
  800e95:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e9a:	89 cb                	mov    %ecx,%ebx
  800e9c:	89 cf                	mov    %ecx,%edi
  800e9e:	89 ce                	mov    %ecx,%esi
  800ea0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	7f 08                	jg     800eae <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ea6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea9:	5b                   	pop    %ebx
  800eaa:	5e                   	pop    %esi
  800eab:	5f                   	pop    %edi
  800eac:	5d                   	pop    %ebp
  800ead:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eae:	83 ec 0c             	sub    $0xc,%esp
  800eb1:	50                   	push   %eax
  800eb2:	6a 0d                	push   $0xd
  800eb4:	68 3f 2c 80 00       	push   $0x802c3f
  800eb9:	6a 23                	push   $0x23
  800ebb:	68 5c 2c 80 00       	push   $0x802c5c
  800ec0:	e8 66 f3 ff ff       	call   80022b <_panic>

00800ec5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	57                   	push   %edi
  800ec9:	56                   	push   %esi
  800eca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ecb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed0:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ed5:	89 d1                	mov    %edx,%ecx
  800ed7:	89 d3                	mov    %edx,%ebx
  800ed9:	89 d7                	mov    %edx,%edi
  800edb:	89 d6                	mov    %edx,%esi
  800edd:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800edf:	5b                   	pop    %ebx
  800ee0:	5e                   	pop    %esi
  800ee1:	5f                   	pop    %edi
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	57                   	push   %edi
  800ee8:	56                   	push   %esi
  800ee9:	53                   	push   %ebx
  800eea:	83 ec 0c             	sub    $0xc,%esp
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ef0:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800ef2:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800ef5:	89 d9                	mov    %ebx,%ecx
  800ef7:	c1 e9 16             	shr    $0x16,%ecx
  800efa:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  800f01:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  800f06:	f6 c1 01             	test   $0x1,%cl
  800f09:	74 0c                	je     800f17 <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  800f0b:	89 d9                	mov    %ebx,%ecx
  800f0d:	c1 e9 0c             	shr    $0xc,%ecx
  800f10:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  800f17:	f6 c2 02             	test   $0x2,%dl
  800f1a:	0f 84 a3 00 00 00    	je     800fc3 <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  800f20:	89 da                	mov    %ebx,%edx
  800f22:	c1 ea 0c             	shr    $0xc,%edx
  800f25:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f2c:	f6 c6 08             	test   $0x8,%dh
  800f2f:	0f 84 b7 00 00 00    	je     800fec <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  800f35:	e8 5c fd ff ff       	call   800c96 <sys_getenvid>
  800f3a:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800f3c:	83 ec 04             	sub    $0x4,%esp
  800f3f:	6a 07                	push   $0x7
  800f41:	68 00 f0 7f 00       	push   $0x7ff000
  800f46:	50                   	push   %eax
  800f47:	e8 88 fd ff ff       	call   800cd4 <sys_page_alloc>
  800f4c:	83 c4 10             	add    $0x10,%esp
  800f4f:	85 c0                	test   %eax,%eax
  800f51:	0f 88 bc 00 00 00    	js     801013 <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  800f57:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  800f5d:	83 ec 04             	sub    $0x4,%esp
  800f60:	68 00 10 00 00       	push   $0x1000
  800f65:	53                   	push   %ebx
  800f66:	68 00 f0 7f 00       	push   $0x7ff000
  800f6b:	e8 00 fb ff ff       	call   800a70 <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  800f70:	83 c4 08             	add    $0x8,%esp
  800f73:	53                   	push   %ebx
  800f74:	56                   	push   %esi
  800f75:	e8 df fd ff ff       	call   800d59 <sys_page_unmap>
  800f7a:	83 c4 10             	add    $0x10,%esp
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	0f 88 a0 00 00 00    	js     801025 <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800f85:	83 ec 0c             	sub    $0xc,%esp
  800f88:	6a 07                	push   $0x7
  800f8a:	53                   	push   %ebx
  800f8b:	56                   	push   %esi
  800f8c:	68 00 f0 7f 00       	push   $0x7ff000
  800f91:	56                   	push   %esi
  800f92:	e8 80 fd ff ff       	call   800d17 <sys_page_map>
  800f97:	83 c4 20             	add    $0x20,%esp
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	0f 88 95 00 00 00    	js     801037 <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800fa2:	83 ec 08             	sub    $0x8,%esp
  800fa5:	68 00 f0 7f 00       	push   $0x7ff000
  800faa:	56                   	push   %esi
  800fab:	e8 a9 fd ff ff       	call   800d59 <sys_page_unmap>
  800fb0:	83 c4 10             	add    $0x10,%esp
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	0f 88 8e 00 00 00    	js     801049 <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  800fbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbe:	5b                   	pop    %ebx
  800fbf:	5e                   	pop    %esi
  800fc0:	5f                   	pop    %edi
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800fc3:	8b 70 28             	mov    0x28(%eax),%esi
  800fc6:	e8 cb fc ff ff       	call   800c96 <sys_getenvid>
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
  800fcd:	50                   	push   %eax
  800fce:	68 6c 2c 80 00       	push   $0x802c6c
  800fd3:	e8 2e f3 ff ff       	call   800306 <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  800fd8:	83 c4 0c             	add    $0xc,%esp
  800fdb:	68 90 2c 80 00       	push   $0x802c90
  800fe0:	6a 27                	push   $0x27
  800fe2:	68 64 2d 80 00       	push   $0x802d64
  800fe7:	e8 3f f2 ff ff       	call   80022b <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  800fec:	8b 78 28             	mov    0x28(%eax),%edi
  800fef:	e8 a2 fc ff ff       	call   800c96 <sys_getenvid>
  800ff4:	57                   	push   %edi
  800ff5:	53                   	push   %ebx
  800ff6:	50                   	push   %eax
  800ff7:	68 6c 2c 80 00       	push   $0x802c6c
  800ffc:	e8 05 f3 ff ff       	call   800306 <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  801001:	56                   	push   %esi
  801002:	68 c4 2c 80 00       	push   $0x802cc4
  801007:	6a 2b                	push   $0x2b
  801009:	68 64 2d 80 00       	push   $0x802d64
  80100e:	e8 18 f2 ff ff       	call   80022b <_panic>
      panic("pgfault: page allocation failed %e", r);
  801013:	50                   	push   %eax
  801014:	68 fc 2c 80 00       	push   $0x802cfc
  801019:	6a 39                	push   $0x39
  80101b:	68 64 2d 80 00       	push   $0x802d64
  801020:	e8 06 f2 ff ff       	call   80022b <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  801025:	50                   	push   %eax
  801026:	68 20 2d 80 00       	push   $0x802d20
  80102b:	6a 3e                	push   $0x3e
  80102d:	68 64 2d 80 00       	push   $0x802d64
  801032:	e8 f4 f1 ff ff       	call   80022b <_panic>
      panic("pgfault: page map failed (%e)", r);
  801037:	50                   	push   %eax
  801038:	68 6f 2d 80 00       	push   $0x802d6f
  80103d:	6a 40                	push   $0x40
  80103f:	68 64 2d 80 00       	push   $0x802d64
  801044:	e8 e2 f1 ff ff       	call   80022b <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  801049:	50                   	push   %eax
  80104a:	68 20 2d 80 00       	push   $0x802d20
  80104f:	6a 42                	push   $0x42
  801051:	68 64 2d 80 00       	push   $0x802d64
  801056:	e8 d0 f1 ff ff       	call   80022b <_panic>

0080105b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	57                   	push   %edi
  80105f:	56                   	push   %esi
  801060:	53                   	push   %ebx
  801061:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  801064:	68 e4 0e 80 00       	push   $0x800ee4
  801069:	e8 96 14 00 00       	call   802504 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80106e:	b8 07 00 00 00       	mov    $0x7,%eax
  801073:	cd 30                	int    $0x30
  801075:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  801078:	83 c4 10             	add    $0x10,%esp
  80107b:	85 c0                	test   %eax,%eax
  80107d:	78 2d                	js     8010ac <fork+0x51>
  80107f:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801081:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  801086:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80108a:	0f 85 a6 00 00 00    	jne    801136 <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  801090:	e8 01 fc ff ff       	call   800c96 <sys_getenvid>
  801095:	25 ff 03 00 00       	and    $0x3ff,%eax
  80109a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80109d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010a2:	a3 0c 40 80 00       	mov    %eax,0x80400c
      return 0;
  8010a7:	e9 79 01 00 00       	jmp    801225 <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  8010ac:	50                   	push   %eax
  8010ad:	68 8d 2d 80 00       	push   $0x802d8d
  8010b2:	68 aa 00 00 00       	push   $0xaa
  8010b7:	68 64 2d 80 00       	push   $0x802d64
  8010bc:	e8 6a f1 ff ff       	call   80022b <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  8010c1:	83 ec 0c             	sub    $0xc,%esp
  8010c4:	6a 05                	push   $0x5
  8010c6:	53                   	push   %ebx
  8010c7:	57                   	push   %edi
  8010c8:	53                   	push   %ebx
  8010c9:	6a 00                	push   $0x0
  8010cb:	e8 47 fc ff ff       	call   800d17 <sys_page_map>
  8010d0:	83 c4 20             	add    $0x20,%esp
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	79 4d                	jns    801124 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  8010d7:	50                   	push   %eax
  8010d8:	68 96 2d 80 00       	push   $0x802d96
  8010dd:	6a 61                	push   $0x61
  8010df:	68 64 2d 80 00       	push   $0x802d64
  8010e4:	e8 42 f1 ff ff       	call   80022b <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  8010e9:	83 ec 0c             	sub    $0xc,%esp
  8010ec:	68 05 08 00 00       	push   $0x805
  8010f1:	53                   	push   %ebx
  8010f2:	57                   	push   %edi
  8010f3:	53                   	push   %ebx
  8010f4:	6a 00                	push   $0x0
  8010f6:	e8 1c fc ff ff       	call   800d17 <sys_page_map>
  8010fb:	83 c4 20             	add    $0x20,%esp
  8010fe:	85 c0                	test   %eax,%eax
  801100:	0f 88 b7 00 00 00    	js     8011bd <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  801106:	83 ec 0c             	sub    $0xc,%esp
  801109:	68 05 08 00 00       	push   $0x805
  80110e:	53                   	push   %ebx
  80110f:	6a 00                	push   $0x0
  801111:	53                   	push   %ebx
  801112:	6a 00                	push   $0x0
  801114:	e8 fe fb ff ff       	call   800d17 <sys_page_map>
  801119:	83 c4 20             	add    $0x20,%esp
  80111c:	85 c0                	test   %eax,%eax
  80111e:	0f 88 ab 00 00 00    	js     8011cf <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801124:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80112a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801130:	0f 84 ab 00 00 00    	je     8011e1 <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  801136:	89 d8                	mov    %ebx,%eax
  801138:	c1 e8 16             	shr    $0x16,%eax
  80113b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801142:	a8 01                	test   $0x1,%al
  801144:	74 de                	je     801124 <fork+0xc9>
  801146:	89 d8                	mov    %ebx,%eax
  801148:	c1 e8 0c             	shr    $0xc,%eax
  80114b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801152:	f6 c2 01             	test   $0x1,%dl
  801155:	74 cd                	je     801124 <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  801157:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  80115a:	89 c2                	mov    %eax,%edx
  80115c:	c1 ea 16             	shr    $0x16,%edx
  80115f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801166:	f6 c2 01             	test   $0x1,%dl
  801169:	74 b9                	je     801124 <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  80116b:	c1 e8 0c             	shr    $0xc,%eax
  80116e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  801175:	a8 01                	test   $0x1,%al
  801177:	74 ab                	je     801124 <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  801179:	a9 02 08 00 00       	test   $0x802,%eax
  80117e:	0f 84 3d ff ff ff    	je     8010c1 <fork+0x66>
	else if(pte & PTE_SHARE)
  801184:	f6 c4 04             	test   $0x4,%ah
  801187:	0f 84 5c ff ff ff    	je     8010e9 <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  80118d:	83 ec 0c             	sub    $0xc,%esp
  801190:	25 07 0e 00 00       	and    $0xe07,%eax
  801195:	50                   	push   %eax
  801196:	53                   	push   %ebx
  801197:	57                   	push   %edi
  801198:	53                   	push   %ebx
  801199:	6a 00                	push   $0x0
  80119b:	e8 77 fb ff ff       	call   800d17 <sys_page_map>
  8011a0:	83 c4 20             	add    $0x20,%esp
  8011a3:	85 c0                	test   %eax,%eax
  8011a5:	0f 89 79 ff ff ff    	jns    801124 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  8011ab:	50                   	push   %eax
  8011ac:	68 96 2d 80 00       	push   $0x802d96
  8011b1:	6a 67                	push   $0x67
  8011b3:	68 64 2d 80 00       	push   $0x802d64
  8011b8:	e8 6e f0 ff ff       	call   80022b <_panic>
			panic("Page Map Failed: %e", error_code);
  8011bd:	50                   	push   %eax
  8011be:	68 96 2d 80 00       	push   $0x802d96
  8011c3:	6a 6d                	push   $0x6d
  8011c5:	68 64 2d 80 00       	push   $0x802d64
  8011ca:	e8 5c f0 ff ff       	call   80022b <_panic>
			panic("Page Map Failed: %e", error_code);
  8011cf:	50                   	push   %eax
  8011d0:	68 96 2d 80 00       	push   $0x802d96
  8011d5:	6a 70                	push   $0x70
  8011d7:	68 64 2d 80 00       	push   $0x802d64
  8011dc:	e8 4a f0 ff ff       	call   80022b <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  8011e1:	83 ec 04             	sub    $0x4,%esp
  8011e4:	6a 07                	push   $0x7
  8011e6:	68 00 f0 bf ee       	push   $0xeebff000
  8011eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011ee:	e8 e1 fa ff ff       	call   800cd4 <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	78 36                	js     801230 <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  8011fa:	83 ec 08             	sub    $0x8,%esp
  8011fd:	68 7a 25 80 00       	push   $0x80257a
  801202:	ff 75 e4             	pushl  -0x1c(%ebp)
  801205:	e8 15 fc ff ff       	call   800e1f <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  80120a:	83 c4 10             	add    $0x10,%esp
  80120d:	85 c0                	test   %eax,%eax
  80120f:	78 34                	js     801245 <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	6a 02                	push   $0x2
  801216:	ff 75 e4             	pushl  -0x1c(%ebp)
  801219:	e8 7d fb ff ff       	call   800d9b <sys_env_set_status>
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	85 c0                	test   %eax,%eax
  801223:	78 35                	js     80125a <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  801225:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801228:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122b:	5b                   	pop    %ebx
  80122c:	5e                   	pop    %esi
  80122d:	5f                   	pop    %edi
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  801230:	50                   	push   %eax
  801231:	68 8d 2d 80 00       	push   $0x802d8d
  801236:	68 ba 00 00 00       	push   $0xba
  80123b:	68 64 2d 80 00       	push   $0x802d64
  801240:	e8 e6 ef ff ff       	call   80022b <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801245:	50                   	push   %eax
  801246:	68 40 2d 80 00       	push   $0x802d40
  80124b:	68 bf 00 00 00       	push   $0xbf
  801250:	68 64 2d 80 00       	push   $0x802d64
  801255:	e8 d1 ef ff ff       	call   80022b <_panic>
      panic("sys_env_set_status: %e", r);
  80125a:	50                   	push   %eax
  80125b:	68 aa 2d 80 00       	push   $0x802daa
  801260:	68 c3 00 00 00       	push   $0xc3
  801265:	68 64 2d 80 00       	push   $0x802d64
  80126a:	e8 bc ef ff ff       	call   80022b <_panic>

0080126f <sfork>:

// Challenge!
int
sfork(void)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801275:	68 c1 2d 80 00       	push   $0x802dc1
  80127a:	68 cc 00 00 00       	push   $0xcc
  80127f:	68 64 2d 80 00       	push   $0x802d64
  801284:	e8 a2 ef ff ff       	call   80022b <_panic>

00801289 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	56                   	push   %esi
  80128d:	53                   	push   %ebx
  80128e:	8b 75 08             	mov    0x8(%ebp),%esi
  801291:	8b 45 0c             	mov    0xc(%ebp),%eax
  801294:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801297:	85 c0                	test   %eax,%eax
  801299:	74 4f                	je     8012ea <ipc_recv+0x61>
  80129b:	83 ec 0c             	sub    $0xc,%esp
  80129e:	50                   	push   %eax
  80129f:	e8 e0 fb ff ff       	call   800e84 <sys_ipc_recv>
  8012a4:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  8012a7:	85 f6                	test   %esi,%esi
  8012a9:	74 14                	je     8012bf <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  8012ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	75 09                	jne    8012bd <ipc_recv+0x34>
  8012b4:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  8012ba:	8b 52 74             	mov    0x74(%edx),%edx
  8012bd:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8012bf:	85 db                	test   %ebx,%ebx
  8012c1:	74 14                	je     8012d7 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8012c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	75 09                	jne    8012d5 <ipc_recv+0x4c>
  8012cc:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  8012d2:	8b 52 78             	mov    0x78(%edx),%edx
  8012d5:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	75 08                	jne    8012e3 <ipc_recv+0x5a>
  8012db:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8012e0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8012e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e6:	5b                   	pop    %ebx
  8012e7:	5e                   	pop    %esi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8012ea:	83 ec 0c             	sub    $0xc,%esp
  8012ed:	68 00 00 c0 ee       	push   $0xeec00000
  8012f2:	e8 8d fb ff ff       	call   800e84 <sys_ipc_recv>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	eb ab                	jmp    8012a7 <ipc_recv+0x1e>

008012fc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	57                   	push   %edi
  801300:	56                   	push   %esi
  801301:	53                   	push   %ebx
  801302:	83 ec 0c             	sub    $0xc,%esp
  801305:	8b 7d 08             	mov    0x8(%ebp),%edi
  801308:	8b 75 10             	mov    0x10(%ebp),%esi
  80130b:	eb 20                	jmp    80132d <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80130d:	6a 00                	push   $0x0
  80130f:	68 00 00 c0 ee       	push   $0xeec00000
  801314:	ff 75 0c             	pushl  0xc(%ebp)
  801317:	57                   	push   %edi
  801318:	e8 44 fb ff ff       	call   800e61 <sys_ipc_try_send>
  80131d:	89 c3                	mov    %eax,%ebx
  80131f:	83 c4 10             	add    $0x10,%esp
  801322:	eb 1f                	jmp    801343 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801324:	e8 8c f9 ff ff       	call   800cb5 <sys_yield>
	while(retval != 0) {
  801329:	85 db                	test   %ebx,%ebx
  80132b:	74 33                	je     801360 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80132d:	85 f6                	test   %esi,%esi
  80132f:	74 dc                	je     80130d <ipc_send+0x11>
  801331:	ff 75 14             	pushl  0x14(%ebp)
  801334:	56                   	push   %esi
  801335:	ff 75 0c             	pushl  0xc(%ebp)
  801338:	57                   	push   %edi
  801339:	e8 23 fb ff ff       	call   800e61 <sys_ipc_try_send>
  80133e:	89 c3                	mov    %eax,%ebx
  801340:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801343:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801346:	74 dc                	je     801324 <ipc_send+0x28>
  801348:	85 db                	test   %ebx,%ebx
  80134a:	74 d8                	je     801324 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  80134c:	83 ec 04             	sub    $0x4,%esp
  80134f:	68 d8 2d 80 00       	push   $0x802dd8
  801354:	6a 35                	push   $0x35
  801356:	68 08 2e 80 00       	push   $0x802e08
  80135b:	e8 cb ee ff ff       	call   80022b <_panic>
	}
}
  801360:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801363:	5b                   	pop    %ebx
  801364:	5e                   	pop    %esi
  801365:	5f                   	pop    %edi
  801366:	5d                   	pop    %ebp
  801367:	c3                   	ret    

00801368 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80136e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801373:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801376:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80137c:	8b 52 50             	mov    0x50(%edx),%edx
  80137f:	39 ca                	cmp    %ecx,%edx
  801381:	74 11                	je     801394 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801383:	83 c0 01             	add    $0x1,%eax
  801386:	3d 00 04 00 00       	cmp    $0x400,%eax
  80138b:	75 e6                	jne    801373 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80138d:	b8 00 00 00 00       	mov    $0x0,%eax
  801392:	eb 0b                	jmp    80139f <ipc_find_env+0x37>
			return envs[i].env_id;
  801394:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801397:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80139c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80139f:	5d                   	pop    %ebp
  8013a0:	c3                   	ret    

008013a1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	05 00 00 00 30       	add    $0x30000000,%eax
  8013ac:	c1 e8 0c             	shr    $0xc,%eax
}
  8013af:	5d                   	pop    %ebp
  8013b0:	c3                   	ret    

008013b1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013c1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013c6:	5d                   	pop    %ebp
  8013c7:	c3                   	ret    

008013c8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013d0:	89 c2                	mov    %eax,%edx
  8013d2:	c1 ea 16             	shr    $0x16,%edx
  8013d5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013dc:	f6 c2 01             	test   $0x1,%dl
  8013df:	74 2d                	je     80140e <fd_alloc+0x46>
  8013e1:	89 c2                	mov    %eax,%edx
  8013e3:	c1 ea 0c             	shr    $0xc,%edx
  8013e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013ed:	f6 c2 01             	test   $0x1,%dl
  8013f0:	74 1c                	je     80140e <fd_alloc+0x46>
  8013f2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013f7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013fc:	75 d2                	jne    8013d0 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801407:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80140c:	eb 0a                	jmp    801418 <fd_alloc+0x50>
			*fd_store = fd;
  80140e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801411:	89 01                	mov    %eax,(%ecx)
			return 0;
  801413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801418:	5d                   	pop    %ebp
  801419:	c3                   	ret    

0080141a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801420:	83 f8 1f             	cmp    $0x1f,%eax
  801423:	77 30                	ja     801455 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801425:	c1 e0 0c             	shl    $0xc,%eax
  801428:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80142d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801433:	f6 c2 01             	test   $0x1,%dl
  801436:	74 24                	je     80145c <fd_lookup+0x42>
  801438:	89 c2                	mov    %eax,%edx
  80143a:	c1 ea 0c             	shr    $0xc,%edx
  80143d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801444:	f6 c2 01             	test   $0x1,%dl
  801447:	74 1a                	je     801463 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144c:	89 02                	mov    %eax,(%edx)
	return 0;
  80144e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801453:	5d                   	pop    %ebp
  801454:	c3                   	ret    
		return -E_INVAL;
  801455:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145a:	eb f7                	jmp    801453 <fd_lookup+0x39>
		return -E_INVAL;
  80145c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801461:	eb f0                	jmp    801453 <fd_lookup+0x39>
  801463:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801468:	eb e9                	jmp    801453 <fd_lookup+0x39>

0080146a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801473:	ba 00 00 00 00       	mov    $0x0,%edx
  801478:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80147d:	39 08                	cmp    %ecx,(%eax)
  80147f:	74 38                	je     8014b9 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801481:	83 c2 01             	add    $0x1,%edx
  801484:	8b 04 95 94 2e 80 00 	mov    0x802e94(,%edx,4),%eax
  80148b:	85 c0                	test   %eax,%eax
  80148d:	75 ee                	jne    80147d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80148f:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801494:	8b 40 48             	mov    0x48(%eax),%eax
  801497:	83 ec 04             	sub    $0x4,%esp
  80149a:	51                   	push   %ecx
  80149b:	50                   	push   %eax
  80149c:	68 14 2e 80 00       	push   $0x802e14
  8014a1:	e8 60 ee ff ff       	call   800306 <cprintf>
	*dev = 0;
  8014a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    
			*dev = devtab[i];
  8014b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014bc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014be:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c3:	eb f2                	jmp    8014b7 <dev_lookup+0x4d>

008014c5 <fd_close>:
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	57                   	push   %edi
  8014c9:	56                   	push   %esi
  8014ca:	53                   	push   %ebx
  8014cb:	83 ec 24             	sub    $0x24,%esp
  8014ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8014d1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014d7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014d8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014de:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014e1:	50                   	push   %eax
  8014e2:	e8 33 ff ff ff       	call   80141a <fd_lookup>
  8014e7:	89 c3                	mov    %eax,%ebx
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 05                	js     8014f5 <fd_close+0x30>
	    || fd != fd2)
  8014f0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014f3:	74 16                	je     80150b <fd_close+0x46>
		return (must_exist ? r : 0);
  8014f5:	89 f8                	mov    %edi,%eax
  8014f7:	84 c0                	test   %al,%al
  8014f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fe:	0f 44 d8             	cmove  %eax,%ebx
}
  801501:	89 d8                	mov    %ebx,%eax
  801503:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801506:	5b                   	pop    %ebx
  801507:	5e                   	pop    %esi
  801508:	5f                   	pop    %edi
  801509:	5d                   	pop    %ebp
  80150a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80150b:	83 ec 08             	sub    $0x8,%esp
  80150e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801511:	50                   	push   %eax
  801512:	ff 36                	pushl  (%esi)
  801514:	e8 51 ff ff ff       	call   80146a <dev_lookup>
  801519:	89 c3                	mov    %eax,%ebx
  80151b:	83 c4 10             	add    $0x10,%esp
  80151e:	85 c0                	test   %eax,%eax
  801520:	78 1a                	js     80153c <fd_close+0x77>
		if (dev->dev_close)
  801522:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801525:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801528:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80152d:	85 c0                	test   %eax,%eax
  80152f:	74 0b                	je     80153c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801531:	83 ec 0c             	sub    $0xc,%esp
  801534:	56                   	push   %esi
  801535:	ff d0                	call   *%eax
  801537:	89 c3                	mov    %eax,%ebx
  801539:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80153c:	83 ec 08             	sub    $0x8,%esp
  80153f:	56                   	push   %esi
  801540:	6a 00                	push   $0x0
  801542:	e8 12 f8 ff ff       	call   800d59 <sys_page_unmap>
	return r;
  801547:	83 c4 10             	add    $0x10,%esp
  80154a:	eb b5                	jmp    801501 <fd_close+0x3c>

0080154c <close>:

int
close(int fdnum)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801552:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801555:	50                   	push   %eax
  801556:	ff 75 08             	pushl  0x8(%ebp)
  801559:	e8 bc fe ff ff       	call   80141a <fd_lookup>
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	85 c0                	test   %eax,%eax
  801563:	79 02                	jns    801567 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801565:	c9                   	leave  
  801566:	c3                   	ret    
		return fd_close(fd, 1);
  801567:	83 ec 08             	sub    $0x8,%esp
  80156a:	6a 01                	push   $0x1
  80156c:	ff 75 f4             	pushl  -0xc(%ebp)
  80156f:	e8 51 ff ff ff       	call   8014c5 <fd_close>
  801574:	83 c4 10             	add    $0x10,%esp
  801577:	eb ec                	jmp    801565 <close+0x19>

00801579 <close_all>:

void
close_all(void)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	53                   	push   %ebx
  80157d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801580:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801585:	83 ec 0c             	sub    $0xc,%esp
  801588:	53                   	push   %ebx
  801589:	e8 be ff ff ff       	call   80154c <close>
	for (i = 0; i < MAXFD; i++)
  80158e:	83 c3 01             	add    $0x1,%ebx
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	83 fb 20             	cmp    $0x20,%ebx
  801597:	75 ec                	jne    801585 <close_all+0xc>
}
  801599:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	57                   	push   %edi
  8015a2:	56                   	push   %esi
  8015a3:	53                   	push   %ebx
  8015a4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015aa:	50                   	push   %eax
  8015ab:	ff 75 08             	pushl  0x8(%ebp)
  8015ae:	e8 67 fe ff ff       	call   80141a <fd_lookup>
  8015b3:	89 c3                	mov    %eax,%ebx
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	0f 88 81 00 00 00    	js     801641 <dup+0xa3>
		return r;
	close(newfdnum);
  8015c0:	83 ec 0c             	sub    $0xc,%esp
  8015c3:	ff 75 0c             	pushl  0xc(%ebp)
  8015c6:	e8 81 ff ff ff       	call   80154c <close>

	newfd = INDEX2FD(newfdnum);
  8015cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015ce:	c1 e6 0c             	shl    $0xc,%esi
  8015d1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015d7:	83 c4 04             	add    $0x4,%esp
  8015da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015dd:	e8 cf fd ff ff       	call   8013b1 <fd2data>
  8015e2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015e4:	89 34 24             	mov    %esi,(%esp)
  8015e7:	e8 c5 fd ff ff       	call   8013b1 <fd2data>
  8015ec:	83 c4 10             	add    $0x10,%esp
  8015ef:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015f1:	89 d8                	mov    %ebx,%eax
  8015f3:	c1 e8 16             	shr    $0x16,%eax
  8015f6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015fd:	a8 01                	test   $0x1,%al
  8015ff:	74 11                	je     801612 <dup+0x74>
  801601:	89 d8                	mov    %ebx,%eax
  801603:	c1 e8 0c             	shr    $0xc,%eax
  801606:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80160d:	f6 c2 01             	test   $0x1,%dl
  801610:	75 39                	jne    80164b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801612:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801615:	89 d0                	mov    %edx,%eax
  801617:	c1 e8 0c             	shr    $0xc,%eax
  80161a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801621:	83 ec 0c             	sub    $0xc,%esp
  801624:	25 07 0e 00 00       	and    $0xe07,%eax
  801629:	50                   	push   %eax
  80162a:	56                   	push   %esi
  80162b:	6a 00                	push   $0x0
  80162d:	52                   	push   %edx
  80162e:	6a 00                	push   $0x0
  801630:	e8 e2 f6 ff ff       	call   800d17 <sys_page_map>
  801635:	89 c3                	mov    %eax,%ebx
  801637:	83 c4 20             	add    $0x20,%esp
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 31                	js     80166f <dup+0xd1>
		goto err;

	return newfdnum;
  80163e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801641:	89 d8                	mov    %ebx,%eax
  801643:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801646:	5b                   	pop    %ebx
  801647:	5e                   	pop    %esi
  801648:	5f                   	pop    %edi
  801649:	5d                   	pop    %ebp
  80164a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80164b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801652:	83 ec 0c             	sub    $0xc,%esp
  801655:	25 07 0e 00 00       	and    $0xe07,%eax
  80165a:	50                   	push   %eax
  80165b:	57                   	push   %edi
  80165c:	6a 00                	push   $0x0
  80165e:	53                   	push   %ebx
  80165f:	6a 00                	push   $0x0
  801661:	e8 b1 f6 ff ff       	call   800d17 <sys_page_map>
  801666:	89 c3                	mov    %eax,%ebx
  801668:	83 c4 20             	add    $0x20,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	79 a3                	jns    801612 <dup+0x74>
	sys_page_unmap(0, newfd);
  80166f:	83 ec 08             	sub    $0x8,%esp
  801672:	56                   	push   %esi
  801673:	6a 00                	push   $0x0
  801675:	e8 df f6 ff ff       	call   800d59 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80167a:	83 c4 08             	add    $0x8,%esp
  80167d:	57                   	push   %edi
  80167e:	6a 00                	push   $0x0
  801680:	e8 d4 f6 ff ff       	call   800d59 <sys_page_unmap>
	return r;
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	eb b7                	jmp    801641 <dup+0xa3>

0080168a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	53                   	push   %ebx
  80168e:	83 ec 1c             	sub    $0x1c,%esp
  801691:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801694:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801697:	50                   	push   %eax
  801698:	53                   	push   %ebx
  801699:	e8 7c fd ff ff       	call   80141a <fd_lookup>
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	78 3f                	js     8016e4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a5:	83 ec 08             	sub    $0x8,%esp
  8016a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ab:	50                   	push   %eax
  8016ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016af:	ff 30                	pushl  (%eax)
  8016b1:	e8 b4 fd ff ff       	call   80146a <dev_lookup>
  8016b6:	83 c4 10             	add    $0x10,%esp
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	78 27                	js     8016e4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016c0:	8b 42 08             	mov    0x8(%edx),%eax
  8016c3:	83 e0 03             	and    $0x3,%eax
  8016c6:	83 f8 01             	cmp    $0x1,%eax
  8016c9:	74 1e                	je     8016e9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ce:	8b 40 08             	mov    0x8(%eax),%eax
  8016d1:	85 c0                	test   %eax,%eax
  8016d3:	74 35                	je     80170a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016d5:	83 ec 04             	sub    $0x4,%esp
  8016d8:	ff 75 10             	pushl  0x10(%ebp)
  8016db:	ff 75 0c             	pushl  0xc(%ebp)
  8016de:	52                   	push   %edx
  8016df:	ff d0                	call   *%eax
  8016e1:	83 c4 10             	add    $0x10,%esp
}
  8016e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016e9:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8016ee:	8b 40 48             	mov    0x48(%eax),%eax
  8016f1:	83 ec 04             	sub    $0x4,%esp
  8016f4:	53                   	push   %ebx
  8016f5:	50                   	push   %eax
  8016f6:	68 58 2e 80 00       	push   $0x802e58
  8016fb:	e8 06 ec ff ff       	call   800306 <cprintf>
		return -E_INVAL;
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801708:	eb da                	jmp    8016e4 <read+0x5a>
		return -E_NOT_SUPP;
  80170a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80170f:	eb d3                	jmp    8016e4 <read+0x5a>

00801711 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	57                   	push   %edi
  801715:	56                   	push   %esi
  801716:	53                   	push   %ebx
  801717:	83 ec 0c             	sub    $0xc,%esp
  80171a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80171d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801720:	bb 00 00 00 00       	mov    $0x0,%ebx
  801725:	39 f3                	cmp    %esi,%ebx
  801727:	73 23                	jae    80174c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	89 f0                	mov    %esi,%eax
  80172e:	29 d8                	sub    %ebx,%eax
  801730:	50                   	push   %eax
  801731:	89 d8                	mov    %ebx,%eax
  801733:	03 45 0c             	add    0xc(%ebp),%eax
  801736:	50                   	push   %eax
  801737:	57                   	push   %edi
  801738:	e8 4d ff ff ff       	call   80168a <read>
		if (m < 0)
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	85 c0                	test   %eax,%eax
  801742:	78 06                	js     80174a <readn+0x39>
			return m;
		if (m == 0)
  801744:	74 06                	je     80174c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801746:	01 c3                	add    %eax,%ebx
  801748:	eb db                	jmp    801725 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80174a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80174c:	89 d8                	mov    %ebx,%eax
  80174e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801751:	5b                   	pop    %ebx
  801752:	5e                   	pop    %esi
  801753:	5f                   	pop    %edi
  801754:	5d                   	pop    %ebp
  801755:	c3                   	ret    

00801756 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	53                   	push   %ebx
  80175a:	83 ec 1c             	sub    $0x1c,%esp
  80175d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801760:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801763:	50                   	push   %eax
  801764:	53                   	push   %ebx
  801765:	e8 b0 fc ff ff       	call   80141a <fd_lookup>
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	85 c0                	test   %eax,%eax
  80176f:	78 3a                	js     8017ab <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801771:	83 ec 08             	sub    $0x8,%esp
  801774:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801777:	50                   	push   %eax
  801778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177b:	ff 30                	pushl  (%eax)
  80177d:	e8 e8 fc ff ff       	call   80146a <dev_lookup>
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	85 c0                	test   %eax,%eax
  801787:	78 22                	js     8017ab <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801790:	74 1e                	je     8017b0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801792:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801795:	8b 52 0c             	mov    0xc(%edx),%edx
  801798:	85 d2                	test   %edx,%edx
  80179a:	74 35                	je     8017d1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80179c:	83 ec 04             	sub    $0x4,%esp
  80179f:	ff 75 10             	pushl  0x10(%ebp)
  8017a2:	ff 75 0c             	pushl  0xc(%ebp)
  8017a5:	50                   	push   %eax
  8017a6:	ff d2                	call   *%edx
  8017a8:	83 c4 10             	add    $0x10,%esp
}
  8017ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017b0:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8017b5:	8b 40 48             	mov    0x48(%eax),%eax
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	53                   	push   %ebx
  8017bc:	50                   	push   %eax
  8017bd:	68 74 2e 80 00       	push   $0x802e74
  8017c2:	e8 3f eb ff ff       	call   800306 <cprintf>
		return -E_INVAL;
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017cf:	eb da                	jmp    8017ab <write+0x55>
		return -E_NOT_SUPP;
  8017d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017d6:	eb d3                	jmp    8017ab <write+0x55>

008017d8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e1:	50                   	push   %eax
  8017e2:	ff 75 08             	pushl  0x8(%ebp)
  8017e5:	e8 30 fc ff ff       	call   80141a <fd_lookup>
  8017ea:	83 c4 10             	add    $0x10,%esp
  8017ed:	85 c0                	test   %eax,%eax
  8017ef:	78 0e                	js     8017ff <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	53                   	push   %ebx
  801805:	83 ec 1c             	sub    $0x1c,%esp
  801808:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80180b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80180e:	50                   	push   %eax
  80180f:	53                   	push   %ebx
  801810:	e8 05 fc ff ff       	call   80141a <fd_lookup>
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	85 c0                	test   %eax,%eax
  80181a:	78 37                	js     801853 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80181c:	83 ec 08             	sub    $0x8,%esp
  80181f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801822:	50                   	push   %eax
  801823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801826:	ff 30                	pushl  (%eax)
  801828:	e8 3d fc ff ff       	call   80146a <dev_lookup>
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	85 c0                	test   %eax,%eax
  801832:	78 1f                	js     801853 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801837:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80183b:	74 1b                	je     801858 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80183d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801840:	8b 52 18             	mov    0x18(%edx),%edx
  801843:	85 d2                	test   %edx,%edx
  801845:	74 32                	je     801879 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801847:	83 ec 08             	sub    $0x8,%esp
  80184a:	ff 75 0c             	pushl  0xc(%ebp)
  80184d:	50                   	push   %eax
  80184e:	ff d2                	call   *%edx
  801850:	83 c4 10             	add    $0x10,%esp
}
  801853:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801856:	c9                   	leave  
  801857:	c3                   	ret    
			thisenv->env_id, fdnum);
  801858:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80185d:	8b 40 48             	mov    0x48(%eax),%eax
  801860:	83 ec 04             	sub    $0x4,%esp
  801863:	53                   	push   %ebx
  801864:	50                   	push   %eax
  801865:	68 34 2e 80 00       	push   $0x802e34
  80186a:	e8 97 ea ff ff       	call   800306 <cprintf>
		return -E_INVAL;
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801877:	eb da                	jmp    801853 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801879:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80187e:	eb d3                	jmp    801853 <ftruncate+0x52>

00801880 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	53                   	push   %ebx
  801884:	83 ec 1c             	sub    $0x1c,%esp
  801887:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80188a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80188d:	50                   	push   %eax
  80188e:	ff 75 08             	pushl  0x8(%ebp)
  801891:	e8 84 fb ff ff       	call   80141a <fd_lookup>
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	85 c0                	test   %eax,%eax
  80189b:	78 4b                	js     8018e8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80189d:	83 ec 08             	sub    $0x8,%esp
  8018a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a3:	50                   	push   %eax
  8018a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a7:	ff 30                	pushl  (%eax)
  8018a9:	e8 bc fb ff ff       	call   80146a <dev_lookup>
  8018ae:	83 c4 10             	add    $0x10,%esp
  8018b1:	85 c0                	test   %eax,%eax
  8018b3:	78 33                	js     8018e8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018bc:	74 2f                	je     8018ed <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018be:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018c1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018c8:	00 00 00 
	stat->st_isdir = 0;
  8018cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018d2:	00 00 00 
	stat->st_dev = dev;
  8018d5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018db:	83 ec 08             	sub    $0x8,%esp
  8018de:	53                   	push   %ebx
  8018df:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e2:	ff 50 14             	call   *0x14(%eax)
  8018e5:	83 c4 10             	add    $0x10,%esp
}
  8018e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    
		return -E_NOT_SUPP;
  8018ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f2:	eb f4                	jmp    8018e8 <fstat+0x68>

008018f4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	56                   	push   %esi
  8018f8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018f9:	83 ec 08             	sub    $0x8,%esp
  8018fc:	6a 00                	push   $0x0
  8018fe:	ff 75 08             	pushl  0x8(%ebp)
  801901:	e8 2f 02 00 00       	call   801b35 <open>
  801906:	89 c3                	mov    %eax,%ebx
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	85 c0                	test   %eax,%eax
  80190d:	78 1b                	js     80192a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80190f:	83 ec 08             	sub    $0x8,%esp
  801912:	ff 75 0c             	pushl  0xc(%ebp)
  801915:	50                   	push   %eax
  801916:	e8 65 ff ff ff       	call   801880 <fstat>
  80191b:	89 c6                	mov    %eax,%esi
	close(fd);
  80191d:	89 1c 24             	mov    %ebx,(%esp)
  801920:	e8 27 fc ff ff       	call   80154c <close>
	return r;
  801925:	83 c4 10             	add    $0x10,%esp
  801928:	89 f3                	mov    %esi,%ebx
}
  80192a:	89 d8                	mov    %ebx,%eax
  80192c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    

00801933 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	56                   	push   %esi
  801937:	53                   	push   %ebx
  801938:	89 c6                	mov    %eax,%esi
  80193a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80193c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801943:	74 27                	je     80196c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801945:	6a 07                	push   $0x7
  801947:	68 00 50 80 00       	push   $0x805000
  80194c:	56                   	push   %esi
  80194d:	ff 35 04 40 80 00    	pushl  0x804004
  801953:	e8 a4 f9 ff ff       	call   8012fc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801958:	83 c4 0c             	add    $0xc,%esp
  80195b:	6a 00                	push   $0x0
  80195d:	53                   	push   %ebx
  80195e:	6a 00                	push   $0x0
  801960:	e8 24 f9 ff ff       	call   801289 <ipc_recv>
}
  801965:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801968:	5b                   	pop    %ebx
  801969:	5e                   	pop    %esi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80196c:	83 ec 0c             	sub    $0xc,%esp
  80196f:	6a 01                	push   $0x1
  801971:	e8 f2 f9 ff ff       	call   801368 <ipc_find_env>
  801976:	a3 04 40 80 00       	mov    %eax,0x804004
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	eb c5                	jmp    801945 <fsipc+0x12>

00801980 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	8b 40 0c             	mov    0xc(%eax),%eax
  80198c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801991:	8b 45 0c             	mov    0xc(%ebp),%eax
  801994:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801999:	ba 00 00 00 00       	mov    $0x0,%edx
  80199e:	b8 02 00 00 00       	mov    $0x2,%eax
  8019a3:	e8 8b ff ff ff       	call   801933 <fsipc>
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <devfile_flush>:
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c0:	b8 06 00 00 00       	mov    $0x6,%eax
  8019c5:	e8 69 ff ff ff       	call   801933 <fsipc>
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <devfile_stat>:
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	53                   	push   %ebx
  8019d0:	83 ec 04             	sub    $0x4,%esp
  8019d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019dc:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e6:	b8 05 00 00 00       	mov    $0x5,%eax
  8019eb:	e8 43 ff ff ff       	call   801933 <fsipc>
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	78 2c                	js     801a20 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019f4:	83 ec 08             	sub    $0x8,%esp
  8019f7:	68 00 50 80 00       	push   $0x805000
  8019fc:	53                   	push   %ebx
  8019fd:	e8 e0 ee ff ff       	call   8008e2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a02:	a1 80 50 80 00       	mov    0x805080,%eax
  801a07:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a0d:	a1 84 50 80 00       	mov    0x805084,%eax
  801a12:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a18:	83 c4 10             	add    $0x10,%esp
  801a1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <devfile_write>:
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	53                   	push   %ebx
  801a29:	83 ec 04             	sub    $0x4,%esp
  801a2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801a2f:	85 db                	test   %ebx,%ebx
  801a31:	75 07                	jne    801a3a <devfile_write+0x15>
	return n_all;
  801a33:	89 d8                	mov    %ebx,%eax
}
  801a35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a40:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801a45:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801a4b:	83 ec 04             	sub    $0x4,%esp
  801a4e:	53                   	push   %ebx
  801a4f:	ff 75 0c             	pushl  0xc(%ebp)
  801a52:	68 08 50 80 00       	push   $0x805008
  801a57:	e8 14 f0 ff ff       	call   800a70 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a61:	b8 04 00 00 00       	mov    $0x4,%eax
  801a66:	e8 c8 fe ff ff       	call   801933 <fsipc>
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	78 c3                	js     801a35 <devfile_write+0x10>
	  assert(r <= n_left);
  801a72:	39 d8                	cmp    %ebx,%eax
  801a74:	77 0b                	ja     801a81 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801a76:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a7b:	7f 1d                	jg     801a9a <devfile_write+0x75>
    n_all += r;
  801a7d:	89 c3                	mov    %eax,%ebx
  801a7f:	eb b2                	jmp    801a33 <devfile_write+0xe>
	  assert(r <= n_left);
  801a81:	68 a8 2e 80 00       	push   $0x802ea8
  801a86:	68 b4 2e 80 00       	push   $0x802eb4
  801a8b:	68 9f 00 00 00       	push   $0x9f
  801a90:	68 c9 2e 80 00       	push   $0x802ec9
  801a95:	e8 91 e7 ff ff       	call   80022b <_panic>
	  assert(r <= PGSIZE);
  801a9a:	68 d4 2e 80 00       	push   $0x802ed4
  801a9f:	68 b4 2e 80 00       	push   $0x802eb4
  801aa4:	68 a0 00 00 00       	push   $0xa0
  801aa9:	68 c9 2e 80 00       	push   $0x802ec9
  801aae:	e8 78 e7 ff ff       	call   80022b <_panic>

00801ab3 <devfile_read>:
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	56                   	push   %esi
  801ab7:	53                   	push   %ebx
  801ab8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801ac6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801acc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad1:	b8 03 00 00 00       	mov    $0x3,%eax
  801ad6:	e8 58 fe ff ff       	call   801933 <fsipc>
  801adb:	89 c3                	mov    %eax,%ebx
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 1f                	js     801b00 <devfile_read+0x4d>
	assert(r <= n);
  801ae1:	39 f0                	cmp    %esi,%eax
  801ae3:	77 24                	ja     801b09 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ae5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aea:	7f 33                	jg     801b1f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801aec:	83 ec 04             	sub    $0x4,%esp
  801aef:	50                   	push   %eax
  801af0:	68 00 50 80 00       	push   $0x805000
  801af5:	ff 75 0c             	pushl  0xc(%ebp)
  801af8:	e8 73 ef ff ff       	call   800a70 <memmove>
	return r;
  801afd:	83 c4 10             	add    $0x10,%esp
}
  801b00:	89 d8                	mov    %ebx,%eax
  801b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b05:	5b                   	pop    %ebx
  801b06:	5e                   	pop    %esi
  801b07:	5d                   	pop    %ebp
  801b08:	c3                   	ret    
	assert(r <= n);
  801b09:	68 e0 2e 80 00       	push   $0x802ee0
  801b0e:	68 b4 2e 80 00       	push   $0x802eb4
  801b13:	6a 7c                	push   $0x7c
  801b15:	68 c9 2e 80 00       	push   $0x802ec9
  801b1a:	e8 0c e7 ff ff       	call   80022b <_panic>
	assert(r <= PGSIZE);
  801b1f:	68 d4 2e 80 00       	push   $0x802ed4
  801b24:	68 b4 2e 80 00       	push   $0x802eb4
  801b29:	6a 7d                	push   $0x7d
  801b2b:	68 c9 2e 80 00       	push   $0x802ec9
  801b30:	e8 f6 e6 ff ff       	call   80022b <_panic>

00801b35 <open>:
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	56                   	push   %esi
  801b39:	53                   	push   %ebx
  801b3a:	83 ec 1c             	sub    $0x1c,%esp
  801b3d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b40:	56                   	push   %esi
  801b41:	e8 63 ed ff ff       	call   8008a9 <strlen>
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b4e:	7f 6c                	jg     801bbc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b50:	83 ec 0c             	sub    $0xc,%esp
  801b53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b56:	50                   	push   %eax
  801b57:	e8 6c f8 ff ff       	call   8013c8 <fd_alloc>
  801b5c:	89 c3                	mov    %eax,%ebx
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	85 c0                	test   %eax,%eax
  801b63:	78 3c                	js     801ba1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b65:	83 ec 08             	sub    $0x8,%esp
  801b68:	56                   	push   %esi
  801b69:	68 00 50 80 00       	push   $0x805000
  801b6e:	e8 6f ed ff ff       	call   8008e2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b76:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b83:	e8 ab fd ff ff       	call   801933 <fsipc>
  801b88:	89 c3                	mov    %eax,%ebx
  801b8a:	83 c4 10             	add    $0x10,%esp
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	78 19                	js     801baa <open+0x75>
	return fd2num(fd);
  801b91:	83 ec 0c             	sub    $0xc,%esp
  801b94:	ff 75 f4             	pushl  -0xc(%ebp)
  801b97:	e8 05 f8 ff ff       	call   8013a1 <fd2num>
  801b9c:	89 c3                	mov    %eax,%ebx
  801b9e:	83 c4 10             	add    $0x10,%esp
}
  801ba1:	89 d8                	mov    %ebx,%eax
  801ba3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba6:	5b                   	pop    %ebx
  801ba7:	5e                   	pop    %esi
  801ba8:	5d                   	pop    %ebp
  801ba9:	c3                   	ret    
		fd_close(fd, 0);
  801baa:	83 ec 08             	sub    $0x8,%esp
  801bad:	6a 00                	push   $0x0
  801baf:	ff 75 f4             	pushl  -0xc(%ebp)
  801bb2:	e8 0e f9 ff ff       	call   8014c5 <fd_close>
		return r;
  801bb7:	83 c4 10             	add    $0x10,%esp
  801bba:	eb e5                	jmp    801ba1 <open+0x6c>
		return -E_BAD_PATH;
  801bbc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bc1:	eb de                	jmp    801ba1 <open+0x6c>

00801bc3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bc9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bce:	b8 08 00 00 00       	mov    $0x8,%eax
  801bd3:	e8 5b fd ff ff       	call   801933 <fsipc>
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	56                   	push   %esi
  801bde:	53                   	push   %ebx
  801bdf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	ff 75 08             	pushl  0x8(%ebp)
  801be8:	e8 c4 f7 ff ff       	call   8013b1 <fd2data>
  801bed:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bef:	83 c4 08             	add    $0x8,%esp
  801bf2:	68 e7 2e 80 00       	push   $0x802ee7
  801bf7:	53                   	push   %ebx
  801bf8:	e8 e5 ec ff ff       	call   8008e2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bfd:	8b 46 04             	mov    0x4(%esi),%eax
  801c00:	2b 06                	sub    (%esi),%eax
  801c02:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c08:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c0f:	00 00 00 
	stat->st_dev = &devpipe;
  801c12:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c19:	30 80 00 
	return 0;
}
  801c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c24:	5b                   	pop    %ebx
  801c25:	5e                   	pop    %esi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    

00801c28 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	53                   	push   %ebx
  801c2c:	83 ec 0c             	sub    $0xc,%esp
  801c2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c32:	53                   	push   %ebx
  801c33:	6a 00                	push   $0x0
  801c35:	e8 1f f1 ff ff       	call   800d59 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c3a:	89 1c 24             	mov    %ebx,(%esp)
  801c3d:	e8 6f f7 ff ff       	call   8013b1 <fd2data>
  801c42:	83 c4 08             	add    $0x8,%esp
  801c45:	50                   	push   %eax
  801c46:	6a 00                	push   $0x0
  801c48:	e8 0c f1 ff ff       	call   800d59 <sys_page_unmap>
}
  801c4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <_pipeisclosed>:
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	57                   	push   %edi
  801c56:	56                   	push   %esi
  801c57:	53                   	push   %ebx
  801c58:	83 ec 1c             	sub    $0x1c,%esp
  801c5b:	89 c7                	mov    %eax,%edi
  801c5d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c5f:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801c64:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c67:	83 ec 0c             	sub    $0xc,%esp
  801c6a:	57                   	push   %edi
  801c6b:	e8 31 09 00 00       	call   8025a1 <pageref>
  801c70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c73:	89 34 24             	mov    %esi,(%esp)
  801c76:	e8 26 09 00 00       	call   8025a1 <pageref>
		nn = thisenv->env_runs;
  801c7b:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801c81:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c84:	83 c4 10             	add    $0x10,%esp
  801c87:	39 cb                	cmp    %ecx,%ebx
  801c89:	74 1b                	je     801ca6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c8b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c8e:	75 cf                	jne    801c5f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c90:	8b 42 58             	mov    0x58(%edx),%eax
  801c93:	6a 01                	push   $0x1
  801c95:	50                   	push   %eax
  801c96:	53                   	push   %ebx
  801c97:	68 ee 2e 80 00       	push   $0x802eee
  801c9c:	e8 65 e6 ff ff       	call   800306 <cprintf>
  801ca1:	83 c4 10             	add    $0x10,%esp
  801ca4:	eb b9                	jmp    801c5f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ca6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ca9:	0f 94 c0             	sete   %al
  801cac:	0f b6 c0             	movzbl %al,%eax
}
  801caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb2:	5b                   	pop    %ebx
  801cb3:	5e                   	pop    %esi
  801cb4:	5f                   	pop    %edi
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    

00801cb7 <devpipe_write>:
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	57                   	push   %edi
  801cbb:	56                   	push   %esi
  801cbc:	53                   	push   %ebx
  801cbd:	83 ec 28             	sub    $0x28,%esp
  801cc0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cc3:	56                   	push   %esi
  801cc4:	e8 e8 f6 ff ff       	call   8013b1 <fd2data>
  801cc9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ccb:	83 c4 10             	add    $0x10,%esp
  801cce:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cd6:	74 4f                	je     801d27 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cd8:	8b 43 04             	mov    0x4(%ebx),%eax
  801cdb:	8b 0b                	mov    (%ebx),%ecx
  801cdd:	8d 51 20             	lea    0x20(%ecx),%edx
  801ce0:	39 d0                	cmp    %edx,%eax
  801ce2:	72 14                	jb     801cf8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ce4:	89 da                	mov    %ebx,%edx
  801ce6:	89 f0                	mov    %esi,%eax
  801ce8:	e8 65 ff ff ff       	call   801c52 <_pipeisclosed>
  801ced:	85 c0                	test   %eax,%eax
  801cef:	75 3b                	jne    801d2c <devpipe_write+0x75>
			sys_yield();
  801cf1:	e8 bf ef ff ff       	call   800cb5 <sys_yield>
  801cf6:	eb e0                	jmp    801cd8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cfb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cff:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d02:	89 c2                	mov    %eax,%edx
  801d04:	c1 fa 1f             	sar    $0x1f,%edx
  801d07:	89 d1                	mov    %edx,%ecx
  801d09:	c1 e9 1b             	shr    $0x1b,%ecx
  801d0c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d0f:	83 e2 1f             	and    $0x1f,%edx
  801d12:	29 ca                	sub    %ecx,%edx
  801d14:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d18:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d1c:	83 c0 01             	add    $0x1,%eax
  801d1f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d22:	83 c7 01             	add    $0x1,%edi
  801d25:	eb ac                	jmp    801cd3 <devpipe_write+0x1c>
	return i;
  801d27:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2a:	eb 05                	jmp    801d31 <devpipe_write+0x7a>
				return 0;
  801d2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    

00801d39 <devpipe_read>:
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	57                   	push   %edi
  801d3d:	56                   	push   %esi
  801d3e:	53                   	push   %ebx
  801d3f:	83 ec 18             	sub    $0x18,%esp
  801d42:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d45:	57                   	push   %edi
  801d46:	e8 66 f6 ff ff       	call   8013b1 <fd2data>
  801d4b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d4d:	83 c4 10             	add    $0x10,%esp
  801d50:	be 00 00 00 00       	mov    $0x0,%esi
  801d55:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d58:	75 14                	jne    801d6e <devpipe_read+0x35>
	return i;
  801d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5d:	eb 02                	jmp    801d61 <devpipe_read+0x28>
				return i;
  801d5f:	89 f0                	mov    %esi,%eax
}
  801d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d64:	5b                   	pop    %ebx
  801d65:	5e                   	pop    %esi
  801d66:	5f                   	pop    %edi
  801d67:	5d                   	pop    %ebp
  801d68:	c3                   	ret    
			sys_yield();
  801d69:	e8 47 ef ff ff       	call   800cb5 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d6e:	8b 03                	mov    (%ebx),%eax
  801d70:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d73:	75 18                	jne    801d8d <devpipe_read+0x54>
			if (i > 0)
  801d75:	85 f6                	test   %esi,%esi
  801d77:	75 e6                	jne    801d5f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801d79:	89 da                	mov    %ebx,%edx
  801d7b:	89 f8                	mov    %edi,%eax
  801d7d:	e8 d0 fe ff ff       	call   801c52 <_pipeisclosed>
  801d82:	85 c0                	test   %eax,%eax
  801d84:	74 e3                	je     801d69 <devpipe_read+0x30>
				return 0;
  801d86:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8b:	eb d4                	jmp    801d61 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d8d:	99                   	cltd   
  801d8e:	c1 ea 1b             	shr    $0x1b,%edx
  801d91:	01 d0                	add    %edx,%eax
  801d93:	83 e0 1f             	and    $0x1f,%eax
  801d96:	29 d0                	sub    %edx,%eax
  801d98:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801da0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801da3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801da6:	83 c6 01             	add    $0x1,%esi
  801da9:	eb aa                	jmp    801d55 <devpipe_read+0x1c>

00801dab <pipe>:
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	56                   	push   %esi
  801daf:	53                   	push   %ebx
  801db0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801db3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801db6:	50                   	push   %eax
  801db7:	e8 0c f6 ff ff       	call   8013c8 <fd_alloc>
  801dbc:	89 c3                	mov    %eax,%ebx
  801dbe:	83 c4 10             	add    $0x10,%esp
  801dc1:	85 c0                	test   %eax,%eax
  801dc3:	0f 88 23 01 00 00    	js     801eec <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dc9:	83 ec 04             	sub    $0x4,%esp
  801dcc:	68 07 04 00 00       	push   $0x407
  801dd1:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd4:	6a 00                	push   $0x0
  801dd6:	e8 f9 ee ff ff       	call   800cd4 <sys_page_alloc>
  801ddb:	89 c3                	mov    %eax,%ebx
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	85 c0                	test   %eax,%eax
  801de2:	0f 88 04 01 00 00    	js     801eec <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801de8:	83 ec 0c             	sub    $0xc,%esp
  801deb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dee:	50                   	push   %eax
  801def:	e8 d4 f5 ff ff       	call   8013c8 <fd_alloc>
  801df4:	89 c3                	mov    %eax,%ebx
  801df6:	83 c4 10             	add    $0x10,%esp
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	0f 88 db 00 00 00    	js     801edc <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e01:	83 ec 04             	sub    $0x4,%esp
  801e04:	68 07 04 00 00       	push   $0x407
  801e09:	ff 75 f0             	pushl  -0x10(%ebp)
  801e0c:	6a 00                	push   $0x0
  801e0e:	e8 c1 ee ff ff       	call   800cd4 <sys_page_alloc>
  801e13:	89 c3                	mov    %eax,%ebx
  801e15:	83 c4 10             	add    $0x10,%esp
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	0f 88 bc 00 00 00    	js     801edc <pipe+0x131>
	va = fd2data(fd0);
  801e20:	83 ec 0c             	sub    $0xc,%esp
  801e23:	ff 75 f4             	pushl  -0xc(%ebp)
  801e26:	e8 86 f5 ff ff       	call   8013b1 <fd2data>
  801e2b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e2d:	83 c4 0c             	add    $0xc,%esp
  801e30:	68 07 04 00 00       	push   $0x407
  801e35:	50                   	push   %eax
  801e36:	6a 00                	push   $0x0
  801e38:	e8 97 ee ff ff       	call   800cd4 <sys_page_alloc>
  801e3d:	89 c3                	mov    %eax,%ebx
  801e3f:	83 c4 10             	add    $0x10,%esp
  801e42:	85 c0                	test   %eax,%eax
  801e44:	0f 88 82 00 00 00    	js     801ecc <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e4a:	83 ec 0c             	sub    $0xc,%esp
  801e4d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e50:	e8 5c f5 ff ff       	call   8013b1 <fd2data>
  801e55:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e5c:	50                   	push   %eax
  801e5d:	6a 00                	push   $0x0
  801e5f:	56                   	push   %esi
  801e60:	6a 00                	push   $0x0
  801e62:	e8 b0 ee ff ff       	call   800d17 <sys_page_map>
  801e67:	89 c3                	mov    %eax,%ebx
  801e69:	83 c4 20             	add    $0x20,%esp
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	78 4e                	js     801ebe <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801e70:	a1 20 30 80 00       	mov    0x803020,%eax
  801e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e78:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e87:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e93:	83 ec 0c             	sub    $0xc,%esp
  801e96:	ff 75 f4             	pushl  -0xc(%ebp)
  801e99:	e8 03 f5 ff ff       	call   8013a1 <fd2num>
  801e9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ea3:	83 c4 04             	add    $0x4,%esp
  801ea6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ea9:	e8 f3 f4 ff ff       	call   8013a1 <fd2num>
  801eae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eb1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801eb4:	83 c4 10             	add    $0x10,%esp
  801eb7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ebc:	eb 2e                	jmp    801eec <pipe+0x141>
	sys_page_unmap(0, va);
  801ebe:	83 ec 08             	sub    $0x8,%esp
  801ec1:	56                   	push   %esi
  801ec2:	6a 00                	push   $0x0
  801ec4:	e8 90 ee ff ff       	call   800d59 <sys_page_unmap>
  801ec9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ecc:	83 ec 08             	sub    $0x8,%esp
  801ecf:	ff 75 f0             	pushl  -0x10(%ebp)
  801ed2:	6a 00                	push   $0x0
  801ed4:	e8 80 ee ff ff       	call   800d59 <sys_page_unmap>
  801ed9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801edc:	83 ec 08             	sub    $0x8,%esp
  801edf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee2:	6a 00                	push   $0x0
  801ee4:	e8 70 ee ff ff       	call   800d59 <sys_page_unmap>
  801ee9:	83 c4 10             	add    $0x10,%esp
}
  801eec:	89 d8                	mov    %ebx,%eax
  801eee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ef1:	5b                   	pop    %ebx
  801ef2:	5e                   	pop    %esi
  801ef3:	5d                   	pop    %ebp
  801ef4:	c3                   	ret    

00801ef5 <pipeisclosed>:
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801efb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801efe:	50                   	push   %eax
  801eff:	ff 75 08             	pushl  0x8(%ebp)
  801f02:	e8 13 f5 ff ff       	call   80141a <fd_lookup>
  801f07:	83 c4 10             	add    $0x10,%esp
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	78 18                	js     801f26 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	ff 75 f4             	pushl  -0xc(%ebp)
  801f14:	e8 98 f4 ff ff       	call   8013b1 <fd2data>
	return _pipeisclosed(fd, p);
  801f19:	89 c2                	mov    %eax,%edx
  801f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1e:	e8 2f fd ff ff       	call   801c52 <_pipeisclosed>
  801f23:	83 c4 10             	add    $0x10,%esp
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f2e:	68 06 2f 80 00       	push   $0x802f06
  801f33:	ff 75 0c             	pushl  0xc(%ebp)
  801f36:	e8 a7 e9 ff ff       	call   8008e2 <strcpy>
	return 0;
}
  801f3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <devsock_close>:
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	53                   	push   %ebx
  801f46:	83 ec 10             	sub    $0x10,%esp
  801f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f4c:	53                   	push   %ebx
  801f4d:	e8 4f 06 00 00       	call   8025a1 <pageref>
  801f52:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f55:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f5a:	83 f8 01             	cmp    $0x1,%eax
  801f5d:	74 07                	je     801f66 <devsock_close+0x24>
}
  801f5f:	89 d0                	mov    %edx,%eax
  801f61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f64:	c9                   	leave  
  801f65:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f66:	83 ec 0c             	sub    $0xc,%esp
  801f69:	ff 73 0c             	pushl  0xc(%ebx)
  801f6c:	e8 b9 02 00 00       	call   80222a <nsipc_close>
  801f71:	89 c2                	mov    %eax,%edx
  801f73:	83 c4 10             	add    $0x10,%esp
  801f76:	eb e7                	jmp    801f5f <devsock_close+0x1d>

00801f78 <devsock_write>:
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f7e:	6a 00                	push   $0x0
  801f80:	ff 75 10             	pushl  0x10(%ebp)
  801f83:	ff 75 0c             	pushl  0xc(%ebp)
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	ff 70 0c             	pushl  0xc(%eax)
  801f8c:	e8 76 03 00 00       	call   802307 <nsipc_send>
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <devsock_read>:
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f99:	6a 00                	push   $0x0
  801f9b:	ff 75 10             	pushl  0x10(%ebp)
  801f9e:	ff 75 0c             	pushl  0xc(%ebp)
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	ff 70 0c             	pushl  0xc(%eax)
  801fa7:	e8 ef 02 00 00       	call   80229b <nsipc_recv>
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <fd2sockid>:
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fb4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fb7:	52                   	push   %edx
  801fb8:	50                   	push   %eax
  801fb9:	e8 5c f4 ff ff       	call   80141a <fd_lookup>
  801fbe:	83 c4 10             	add    $0x10,%esp
  801fc1:	85 c0                	test   %eax,%eax
  801fc3:	78 10                	js     801fd5 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc8:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801fce:	39 08                	cmp    %ecx,(%eax)
  801fd0:	75 05                	jne    801fd7 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fd2:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    
		return -E_NOT_SUPP;
  801fd7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fdc:	eb f7                	jmp    801fd5 <fd2sockid+0x27>

00801fde <alloc_sockfd>:
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	56                   	push   %esi
  801fe2:	53                   	push   %ebx
  801fe3:	83 ec 1c             	sub    $0x1c,%esp
  801fe6:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fe8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801feb:	50                   	push   %eax
  801fec:	e8 d7 f3 ff ff       	call   8013c8 <fd_alloc>
  801ff1:	89 c3                	mov    %eax,%ebx
  801ff3:	83 c4 10             	add    $0x10,%esp
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	78 43                	js     80203d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ffa:	83 ec 04             	sub    $0x4,%esp
  801ffd:	68 07 04 00 00       	push   $0x407
  802002:	ff 75 f4             	pushl  -0xc(%ebp)
  802005:	6a 00                	push   $0x0
  802007:	e8 c8 ec ff ff       	call   800cd4 <sys_page_alloc>
  80200c:	89 c3                	mov    %eax,%ebx
  80200e:	83 c4 10             	add    $0x10,%esp
  802011:	85 c0                	test   %eax,%eax
  802013:	78 28                	js     80203d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802018:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80201e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802023:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80202a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80202d:	83 ec 0c             	sub    $0xc,%esp
  802030:	50                   	push   %eax
  802031:	e8 6b f3 ff ff       	call   8013a1 <fd2num>
  802036:	89 c3                	mov    %eax,%ebx
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	eb 0c                	jmp    802049 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80203d:	83 ec 0c             	sub    $0xc,%esp
  802040:	56                   	push   %esi
  802041:	e8 e4 01 00 00       	call   80222a <nsipc_close>
		return r;
  802046:	83 c4 10             	add    $0x10,%esp
}
  802049:	89 d8                	mov    %ebx,%eax
  80204b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80204e:	5b                   	pop    %ebx
  80204f:	5e                   	pop    %esi
  802050:	5d                   	pop    %ebp
  802051:	c3                   	ret    

00802052 <accept>:
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
  802055:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802058:	8b 45 08             	mov    0x8(%ebp),%eax
  80205b:	e8 4e ff ff ff       	call   801fae <fd2sockid>
  802060:	85 c0                	test   %eax,%eax
  802062:	78 1b                	js     80207f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802064:	83 ec 04             	sub    $0x4,%esp
  802067:	ff 75 10             	pushl  0x10(%ebp)
  80206a:	ff 75 0c             	pushl  0xc(%ebp)
  80206d:	50                   	push   %eax
  80206e:	e8 0e 01 00 00       	call   802181 <nsipc_accept>
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	85 c0                	test   %eax,%eax
  802078:	78 05                	js     80207f <accept+0x2d>
	return alloc_sockfd(r);
  80207a:	e8 5f ff ff ff       	call   801fde <alloc_sockfd>
}
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <bind>:
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	e8 1f ff ff ff       	call   801fae <fd2sockid>
  80208f:	85 c0                	test   %eax,%eax
  802091:	78 12                	js     8020a5 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802093:	83 ec 04             	sub    $0x4,%esp
  802096:	ff 75 10             	pushl  0x10(%ebp)
  802099:	ff 75 0c             	pushl  0xc(%ebp)
  80209c:	50                   	push   %eax
  80209d:	e8 31 01 00 00       	call   8021d3 <nsipc_bind>
  8020a2:	83 c4 10             	add    $0x10,%esp
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <shutdown>:
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	e8 f9 fe ff ff       	call   801fae <fd2sockid>
  8020b5:	85 c0                	test   %eax,%eax
  8020b7:	78 0f                	js     8020c8 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020b9:	83 ec 08             	sub    $0x8,%esp
  8020bc:	ff 75 0c             	pushl  0xc(%ebp)
  8020bf:	50                   	push   %eax
  8020c0:	e8 43 01 00 00       	call   802208 <nsipc_shutdown>
  8020c5:	83 c4 10             	add    $0x10,%esp
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <connect>:
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	e8 d6 fe ff ff       	call   801fae <fd2sockid>
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	78 12                	js     8020ee <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	ff 75 10             	pushl  0x10(%ebp)
  8020e2:	ff 75 0c             	pushl  0xc(%ebp)
  8020e5:	50                   	push   %eax
  8020e6:	e8 59 01 00 00       	call   802244 <nsipc_connect>
  8020eb:	83 c4 10             	add    $0x10,%esp
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <listen>:
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	e8 b0 fe ff ff       	call   801fae <fd2sockid>
  8020fe:	85 c0                	test   %eax,%eax
  802100:	78 0f                	js     802111 <listen+0x21>
	return nsipc_listen(r, backlog);
  802102:	83 ec 08             	sub    $0x8,%esp
  802105:	ff 75 0c             	pushl  0xc(%ebp)
  802108:	50                   	push   %eax
  802109:	e8 6b 01 00 00       	call   802279 <nsipc_listen>
  80210e:	83 c4 10             	add    $0x10,%esp
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <socket>:

int
socket(int domain, int type, int protocol)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802119:	ff 75 10             	pushl  0x10(%ebp)
  80211c:	ff 75 0c             	pushl  0xc(%ebp)
  80211f:	ff 75 08             	pushl  0x8(%ebp)
  802122:	e8 3e 02 00 00       	call   802365 <nsipc_socket>
  802127:	83 c4 10             	add    $0x10,%esp
  80212a:	85 c0                	test   %eax,%eax
  80212c:	78 05                	js     802133 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80212e:	e8 ab fe ff ff       	call   801fde <alloc_sockfd>
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	53                   	push   %ebx
  802139:	83 ec 04             	sub    $0x4,%esp
  80213c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80213e:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  802145:	74 26                	je     80216d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802147:	6a 07                	push   $0x7
  802149:	68 00 60 80 00       	push   $0x806000
  80214e:	53                   	push   %ebx
  80214f:	ff 35 08 40 80 00    	pushl  0x804008
  802155:	e8 a2 f1 ff ff       	call   8012fc <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80215a:	83 c4 0c             	add    $0xc,%esp
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	e8 21 f1 ff ff       	call   801289 <ipc_recv>
}
  802168:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80216d:	83 ec 0c             	sub    $0xc,%esp
  802170:	6a 02                	push   $0x2
  802172:	e8 f1 f1 ff ff       	call   801368 <ipc_find_env>
  802177:	a3 08 40 80 00       	mov    %eax,0x804008
  80217c:	83 c4 10             	add    $0x10,%esp
  80217f:	eb c6                	jmp    802147 <nsipc+0x12>

00802181 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	56                   	push   %esi
  802185:	53                   	push   %ebx
  802186:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802191:	8b 06                	mov    (%esi),%eax
  802193:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802198:	b8 01 00 00 00       	mov    $0x1,%eax
  80219d:	e8 93 ff ff ff       	call   802135 <nsipc>
  8021a2:	89 c3                	mov    %eax,%ebx
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	79 09                	jns    8021b1 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021a8:	89 d8                	mov    %ebx,%eax
  8021aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ad:	5b                   	pop    %ebx
  8021ae:	5e                   	pop    %esi
  8021af:	5d                   	pop    %ebp
  8021b0:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021b1:	83 ec 04             	sub    $0x4,%esp
  8021b4:	ff 35 10 60 80 00    	pushl  0x806010
  8021ba:	68 00 60 80 00       	push   $0x806000
  8021bf:	ff 75 0c             	pushl  0xc(%ebp)
  8021c2:	e8 a9 e8 ff ff       	call   800a70 <memmove>
		*addrlen = ret->ret_addrlen;
  8021c7:	a1 10 60 80 00       	mov    0x806010,%eax
  8021cc:	89 06                	mov    %eax,(%esi)
  8021ce:	83 c4 10             	add    $0x10,%esp
	return r;
  8021d1:	eb d5                	jmp    8021a8 <nsipc_accept+0x27>

008021d3 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	53                   	push   %ebx
  8021d7:	83 ec 08             	sub    $0x8,%esp
  8021da:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021e5:	53                   	push   %ebx
  8021e6:	ff 75 0c             	pushl  0xc(%ebp)
  8021e9:	68 04 60 80 00       	push   $0x806004
  8021ee:	e8 7d e8 ff ff       	call   800a70 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021f3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8021f9:	b8 02 00 00 00       	mov    $0x2,%eax
  8021fe:	e8 32 ff ff ff       	call   802135 <nsipc>
}
  802203:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802216:	8b 45 0c             	mov    0xc(%ebp),%eax
  802219:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80221e:	b8 03 00 00 00       	mov    $0x3,%eax
  802223:	e8 0d ff ff ff       	call   802135 <nsipc>
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <nsipc_close>:

int
nsipc_close(int s)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
  80222d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802238:	b8 04 00 00 00       	mov    $0x4,%eax
  80223d:	e8 f3 fe ff ff       	call   802135 <nsipc>
}
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	53                   	push   %ebx
  802248:	83 ec 08             	sub    $0x8,%esp
  80224b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802256:	53                   	push   %ebx
  802257:	ff 75 0c             	pushl  0xc(%ebp)
  80225a:	68 04 60 80 00       	push   $0x806004
  80225f:	e8 0c e8 ff ff       	call   800a70 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802264:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80226a:	b8 05 00 00 00       	mov    $0x5,%eax
  80226f:	e8 c1 fe ff ff       	call   802135 <nsipc>
}
  802274:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80228f:	b8 06 00 00 00       	mov    $0x6,%eax
  802294:	e8 9c fe ff ff       	call   802135 <nsipc>
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	56                   	push   %esi
  80229f:	53                   	push   %ebx
  8022a0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8022ab:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8022b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8022b4:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022b9:	b8 07 00 00 00       	mov    $0x7,%eax
  8022be:	e8 72 fe ff ff       	call   802135 <nsipc>
  8022c3:	89 c3                	mov    %eax,%ebx
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	78 1f                	js     8022e8 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022c9:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022ce:	7f 21                	jg     8022f1 <nsipc_recv+0x56>
  8022d0:	39 c6                	cmp    %eax,%esi
  8022d2:	7c 1d                	jl     8022f1 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022d4:	83 ec 04             	sub    $0x4,%esp
  8022d7:	50                   	push   %eax
  8022d8:	68 00 60 80 00       	push   $0x806000
  8022dd:	ff 75 0c             	pushl  0xc(%ebp)
  8022e0:	e8 8b e7 ff ff       	call   800a70 <memmove>
  8022e5:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022e8:	89 d8                	mov    %ebx,%eax
  8022ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ed:	5b                   	pop    %ebx
  8022ee:	5e                   	pop    %esi
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022f1:	68 12 2f 80 00       	push   $0x802f12
  8022f6:	68 b4 2e 80 00       	push   $0x802eb4
  8022fb:	6a 62                	push   $0x62
  8022fd:	68 27 2f 80 00       	push   $0x802f27
  802302:	e8 24 df ff ff       	call   80022b <_panic>

00802307 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	53                   	push   %ebx
  80230b:	83 ec 04             	sub    $0x4,%esp
  80230e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802319:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80231f:	7f 2e                	jg     80234f <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802321:	83 ec 04             	sub    $0x4,%esp
  802324:	53                   	push   %ebx
  802325:	ff 75 0c             	pushl  0xc(%ebp)
  802328:	68 0c 60 80 00       	push   $0x80600c
  80232d:	e8 3e e7 ff ff       	call   800a70 <memmove>
	nsipcbuf.send.req_size = size;
  802332:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802338:	8b 45 14             	mov    0x14(%ebp),%eax
  80233b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802340:	b8 08 00 00 00       	mov    $0x8,%eax
  802345:	e8 eb fd ff ff       	call   802135 <nsipc>
}
  80234a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    
	assert(size < 1600);
  80234f:	68 33 2f 80 00       	push   $0x802f33
  802354:	68 b4 2e 80 00       	push   $0x802eb4
  802359:	6a 6d                	push   $0x6d
  80235b:	68 27 2f 80 00       	push   $0x802f27
  802360:	e8 c6 de ff ff       	call   80022b <_panic>

00802365 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802373:	8b 45 0c             	mov    0xc(%ebp),%eax
  802376:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80237b:	8b 45 10             	mov    0x10(%ebp),%eax
  80237e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802383:	b8 09 00 00 00       	mov    $0x9,%eax
  802388:	e8 a8 fd ff ff       	call   802135 <nsipc>
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80238f:	b8 00 00 00 00       	mov    $0x0,%eax
  802394:	c3                   	ret    

00802395 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80239b:	68 3f 2f 80 00       	push   $0x802f3f
  8023a0:	ff 75 0c             	pushl  0xc(%ebp)
  8023a3:	e8 3a e5 ff ff       	call   8008e2 <strcpy>
	return 0;
}
  8023a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <devcons_write>:
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
  8023b2:	57                   	push   %edi
  8023b3:	56                   	push   %esi
  8023b4:	53                   	push   %ebx
  8023b5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023bb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023c0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023c6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023c9:	73 31                	jae    8023fc <devcons_write+0x4d>
		m = n - tot;
  8023cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023ce:	29 f3                	sub    %esi,%ebx
  8023d0:	83 fb 7f             	cmp    $0x7f,%ebx
  8023d3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023d8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023db:	83 ec 04             	sub    $0x4,%esp
  8023de:	53                   	push   %ebx
  8023df:	89 f0                	mov    %esi,%eax
  8023e1:	03 45 0c             	add    0xc(%ebp),%eax
  8023e4:	50                   	push   %eax
  8023e5:	57                   	push   %edi
  8023e6:	e8 85 e6 ff ff       	call   800a70 <memmove>
		sys_cputs(buf, m);
  8023eb:	83 c4 08             	add    $0x8,%esp
  8023ee:	53                   	push   %ebx
  8023ef:	57                   	push   %edi
  8023f0:	e8 23 e8 ff ff       	call   800c18 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023f5:	01 de                	add    %ebx,%esi
  8023f7:	83 c4 10             	add    $0x10,%esp
  8023fa:	eb ca                	jmp    8023c6 <devcons_write+0x17>
}
  8023fc:	89 f0                	mov    %esi,%eax
  8023fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802401:	5b                   	pop    %ebx
  802402:	5e                   	pop    %esi
  802403:	5f                   	pop    %edi
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    

00802406 <devcons_read>:
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	83 ec 08             	sub    $0x8,%esp
  80240c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802411:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802415:	74 21                	je     802438 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802417:	e8 1a e8 ff ff       	call   800c36 <sys_cgetc>
  80241c:	85 c0                	test   %eax,%eax
  80241e:	75 07                	jne    802427 <devcons_read+0x21>
		sys_yield();
  802420:	e8 90 e8 ff ff       	call   800cb5 <sys_yield>
  802425:	eb f0                	jmp    802417 <devcons_read+0x11>
	if (c < 0)
  802427:	78 0f                	js     802438 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802429:	83 f8 04             	cmp    $0x4,%eax
  80242c:	74 0c                	je     80243a <devcons_read+0x34>
	*(char*)vbuf = c;
  80242e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802431:	88 02                	mov    %al,(%edx)
	return 1;
  802433:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    
		return 0;
  80243a:	b8 00 00 00 00       	mov    $0x0,%eax
  80243f:	eb f7                	jmp    802438 <devcons_read+0x32>

00802441 <cputchar>:
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80244d:	6a 01                	push   $0x1
  80244f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802452:	50                   	push   %eax
  802453:	e8 c0 e7 ff ff       	call   800c18 <sys_cputs>
}
  802458:	83 c4 10             	add    $0x10,%esp
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <getchar>:
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
  802460:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802463:	6a 01                	push   $0x1
  802465:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802468:	50                   	push   %eax
  802469:	6a 00                	push   $0x0
  80246b:	e8 1a f2 ff ff       	call   80168a <read>
	if (r < 0)
  802470:	83 c4 10             	add    $0x10,%esp
  802473:	85 c0                	test   %eax,%eax
  802475:	78 06                	js     80247d <getchar+0x20>
	if (r < 1)
  802477:	74 06                	je     80247f <getchar+0x22>
	return c;
  802479:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80247d:	c9                   	leave  
  80247e:	c3                   	ret    
		return -E_EOF;
  80247f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802484:	eb f7                	jmp    80247d <getchar+0x20>

00802486 <iscons>:
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80248c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80248f:	50                   	push   %eax
  802490:	ff 75 08             	pushl  0x8(%ebp)
  802493:	e8 82 ef ff ff       	call   80141a <fd_lookup>
  802498:	83 c4 10             	add    $0x10,%esp
  80249b:	85 c0                	test   %eax,%eax
  80249d:	78 11                	js     8024b0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024a8:	39 10                	cmp    %edx,(%eax)
  8024aa:	0f 94 c0             	sete   %al
  8024ad:	0f b6 c0             	movzbl %al,%eax
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <opencons>:
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024bb:	50                   	push   %eax
  8024bc:	e8 07 ef ff ff       	call   8013c8 <fd_alloc>
  8024c1:	83 c4 10             	add    $0x10,%esp
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	78 3a                	js     802502 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024c8:	83 ec 04             	sub    $0x4,%esp
  8024cb:	68 07 04 00 00       	push   $0x407
  8024d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8024d3:	6a 00                	push   $0x0
  8024d5:	e8 fa e7 ff ff       	call   800cd4 <sys_page_alloc>
  8024da:	83 c4 10             	add    $0x10,%esp
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	78 21                	js     802502 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024ea:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024f6:	83 ec 0c             	sub    $0xc,%esp
  8024f9:	50                   	push   %eax
  8024fa:	e8 a2 ee ff ff       	call   8013a1 <fd2num>
  8024ff:	83 c4 10             	add    $0x10,%esp
}
  802502:	c9                   	leave  
  802503:	c3                   	ret    

00802504 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80250a:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802511:	74 0a                	je     80251d <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80251b:	c9                   	leave  
  80251c:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80251d:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802522:	8b 40 48             	mov    0x48(%eax),%eax
  802525:	83 ec 04             	sub    $0x4,%esp
  802528:	6a 07                	push   $0x7
  80252a:	68 00 f0 bf ee       	push   $0xeebff000
  80252f:	50                   	push   %eax
  802530:	e8 9f e7 ff ff       	call   800cd4 <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802535:	83 c4 10             	add    $0x10,%esp
  802538:	85 c0                	test   %eax,%eax
  80253a:	78 2c                	js     802568 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80253c:	e8 55 e7 ff ff       	call   800c96 <sys_getenvid>
  802541:	83 ec 08             	sub    $0x8,%esp
  802544:	68 7a 25 80 00       	push   $0x80257a
  802549:	50                   	push   %eax
  80254a:	e8 d0 e8 ff ff       	call   800e1f <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80254f:	83 c4 10             	add    $0x10,%esp
  802552:	85 c0                	test   %eax,%eax
  802554:	79 bd                	jns    802513 <set_pgfault_handler+0xf>
  802556:	50                   	push   %eax
  802557:	68 4b 2f 80 00       	push   $0x802f4b
  80255c:	6a 23                	push   $0x23
  80255e:	68 63 2f 80 00       	push   $0x802f63
  802563:	e8 c3 dc ff ff       	call   80022b <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802568:	50                   	push   %eax
  802569:	68 4b 2f 80 00       	push   $0x802f4b
  80256e:	6a 21                	push   $0x21
  802570:	68 63 2f 80 00       	push   $0x802f63
  802575:	e8 b1 dc ff ff       	call   80022b <_panic>

0080257a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80257a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80257b:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802580:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802582:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  802585:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  802589:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  80258c:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  802590:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  802594:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802597:	83 c4 08             	add    $0x8,%esp
	popal
  80259a:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  80259b:	83 c4 04             	add    $0x4,%esp
	popfl
  80259e:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80259f:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8025a0:	c3                   	ret    

008025a1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025a1:	55                   	push   %ebp
  8025a2:	89 e5                	mov    %esp,%ebp
  8025a4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025a7:	89 d0                	mov    %edx,%eax
  8025a9:	c1 e8 16             	shr    $0x16,%eax
  8025ac:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8025b8:	f6 c1 01             	test   $0x1,%cl
  8025bb:	74 1d                	je     8025da <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8025bd:	c1 ea 0c             	shr    $0xc,%edx
  8025c0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025c7:	f6 c2 01             	test   $0x1,%dl
  8025ca:	74 0e                	je     8025da <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025cc:	c1 ea 0c             	shr    $0xc,%edx
  8025cf:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025d6:	ef 
  8025d7:	0f b7 c0             	movzwl %ax,%eax
}
  8025da:	5d                   	pop    %ebp
  8025db:	c3                   	ret    
  8025dc:	66 90                	xchg   %ax,%ax
  8025de:	66 90                	xchg   %ax,%ax

008025e0 <__udivdi3>:
  8025e0:	f3 0f 1e fb          	endbr32 
  8025e4:	55                   	push   %ebp
  8025e5:	57                   	push   %edi
  8025e6:	56                   	push   %esi
  8025e7:	53                   	push   %ebx
  8025e8:	83 ec 1c             	sub    $0x1c,%esp
  8025eb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8025ef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8025f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025f7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8025fb:	85 d2                	test   %edx,%edx
  8025fd:	75 49                	jne    802648 <__udivdi3+0x68>
  8025ff:	39 f3                	cmp    %esi,%ebx
  802601:	76 15                	jbe    802618 <__udivdi3+0x38>
  802603:	31 ff                	xor    %edi,%edi
  802605:	89 e8                	mov    %ebp,%eax
  802607:	89 f2                	mov    %esi,%edx
  802609:	f7 f3                	div    %ebx
  80260b:	89 fa                	mov    %edi,%edx
  80260d:	83 c4 1c             	add    $0x1c,%esp
  802610:	5b                   	pop    %ebx
  802611:	5e                   	pop    %esi
  802612:	5f                   	pop    %edi
  802613:	5d                   	pop    %ebp
  802614:	c3                   	ret    
  802615:	8d 76 00             	lea    0x0(%esi),%esi
  802618:	89 d9                	mov    %ebx,%ecx
  80261a:	85 db                	test   %ebx,%ebx
  80261c:	75 0b                	jne    802629 <__udivdi3+0x49>
  80261e:	b8 01 00 00 00       	mov    $0x1,%eax
  802623:	31 d2                	xor    %edx,%edx
  802625:	f7 f3                	div    %ebx
  802627:	89 c1                	mov    %eax,%ecx
  802629:	31 d2                	xor    %edx,%edx
  80262b:	89 f0                	mov    %esi,%eax
  80262d:	f7 f1                	div    %ecx
  80262f:	89 c6                	mov    %eax,%esi
  802631:	89 e8                	mov    %ebp,%eax
  802633:	89 f7                	mov    %esi,%edi
  802635:	f7 f1                	div    %ecx
  802637:	89 fa                	mov    %edi,%edx
  802639:	83 c4 1c             	add    $0x1c,%esp
  80263c:	5b                   	pop    %ebx
  80263d:	5e                   	pop    %esi
  80263e:	5f                   	pop    %edi
  80263f:	5d                   	pop    %ebp
  802640:	c3                   	ret    
  802641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802648:	39 f2                	cmp    %esi,%edx
  80264a:	77 1c                	ja     802668 <__udivdi3+0x88>
  80264c:	0f bd fa             	bsr    %edx,%edi
  80264f:	83 f7 1f             	xor    $0x1f,%edi
  802652:	75 2c                	jne    802680 <__udivdi3+0xa0>
  802654:	39 f2                	cmp    %esi,%edx
  802656:	72 06                	jb     80265e <__udivdi3+0x7e>
  802658:	31 c0                	xor    %eax,%eax
  80265a:	39 eb                	cmp    %ebp,%ebx
  80265c:	77 ad                	ja     80260b <__udivdi3+0x2b>
  80265e:	b8 01 00 00 00       	mov    $0x1,%eax
  802663:	eb a6                	jmp    80260b <__udivdi3+0x2b>
  802665:	8d 76 00             	lea    0x0(%esi),%esi
  802668:	31 ff                	xor    %edi,%edi
  80266a:	31 c0                	xor    %eax,%eax
  80266c:	89 fa                	mov    %edi,%edx
  80266e:	83 c4 1c             	add    $0x1c,%esp
  802671:	5b                   	pop    %ebx
  802672:	5e                   	pop    %esi
  802673:	5f                   	pop    %edi
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    
  802676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80267d:	8d 76 00             	lea    0x0(%esi),%esi
  802680:	89 f9                	mov    %edi,%ecx
  802682:	b8 20 00 00 00       	mov    $0x20,%eax
  802687:	29 f8                	sub    %edi,%eax
  802689:	d3 e2                	shl    %cl,%edx
  80268b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80268f:	89 c1                	mov    %eax,%ecx
  802691:	89 da                	mov    %ebx,%edx
  802693:	d3 ea                	shr    %cl,%edx
  802695:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802699:	09 d1                	or     %edx,%ecx
  80269b:	89 f2                	mov    %esi,%edx
  80269d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026a1:	89 f9                	mov    %edi,%ecx
  8026a3:	d3 e3                	shl    %cl,%ebx
  8026a5:	89 c1                	mov    %eax,%ecx
  8026a7:	d3 ea                	shr    %cl,%edx
  8026a9:	89 f9                	mov    %edi,%ecx
  8026ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026af:	89 eb                	mov    %ebp,%ebx
  8026b1:	d3 e6                	shl    %cl,%esi
  8026b3:	89 c1                	mov    %eax,%ecx
  8026b5:	d3 eb                	shr    %cl,%ebx
  8026b7:	09 de                	or     %ebx,%esi
  8026b9:	89 f0                	mov    %esi,%eax
  8026bb:	f7 74 24 08          	divl   0x8(%esp)
  8026bf:	89 d6                	mov    %edx,%esi
  8026c1:	89 c3                	mov    %eax,%ebx
  8026c3:	f7 64 24 0c          	mull   0xc(%esp)
  8026c7:	39 d6                	cmp    %edx,%esi
  8026c9:	72 15                	jb     8026e0 <__udivdi3+0x100>
  8026cb:	89 f9                	mov    %edi,%ecx
  8026cd:	d3 e5                	shl    %cl,%ebp
  8026cf:	39 c5                	cmp    %eax,%ebp
  8026d1:	73 04                	jae    8026d7 <__udivdi3+0xf7>
  8026d3:	39 d6                	cmp    %edx,%esi
  8026d5:	74 09                	je     8026e0 <__udivdi3+0x100>
  8026d7:	89 d8                	mov    %ebx,%eax
  8026d9:	31 ff                	xor    %edi,%edi
  8026db:	e9 2b ff ff ff       	jmp    80260b <__udivdi3+0x2b>
  8026e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026e3:	31 ff                	xor    %edi,%edi
  8026e5:	e9 21 ff ff ff       	jmp    80260b <__udivdi3+0x2b>
  8026ea:	66 90                	xchg   %ax,%ax
  8026ec:	66 90                	xchg   %ax,%ax
  8026ee:	66 90                	xchg   %ax,%ax

008026f0 <__umoddi3>:
  8026f0:	f3 0f 1e fb          	endbr32 
  8026f4:	55                   	push   %ebp
  8026f5:	57                   	push   %edi
  8026f6:	56                   	push   %esi
  8026f7:	53                   	push   %ebx
  8026f8:	83 ec 1c             	sub    $0x1c,%esp
  8026fb:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8026ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802703:	8b 74 24 30          	mov    0x30(%esp),%esi
  802707:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80270b:	89 da                	mov    %ebx,%edx
  80270d:	85 c0                	test   %eax,%eax
  80270f:	75 3f                	jne    802750 <__umoddi3+0x60>
  802711:	39 df                	cmp    %ebx,%edi
  802713:	76 13                	jbe    802728 <__umoddi3+0x38>
  802715:	89 f0                	mov    %esi,%eax
  802717:	f7 f7                	div    %edi
  802719:	89 d0                	mov    %edx,%eax
  80271b:	31 d2                	xor    %edx,%edx
  80271d:	83 c4 1c             	add    $0x1c,%esp
  802720:	5b                   	pop    %ebx
  802721:	5e                   	pop    %esi
  802722:	5f                   	pop    %edi
  802723:	5d                   	pop    %ebp
  802724:	c3                   	ret    
  802725:	8d 76 00             	lea    0x0(%esi),%esi
  802728:	89 fd                	mov    %edi,%ebp
  80272a:	85 ff                	test   %edi,%edi
  80272c:	75 0b                	jne    802739 <__umoddi3+0x49>
  80272e:	b8 01 00 00 00       	mov    $0x1,%eax
  802733:	31 d2                	xor    %edx,%edx
  802735:	f7 f7                	div    %edi
  802737:	89 c5                	mov    %eax,%ebp
  802739:	89 d8                	mov    %ebx,%eax
  80273b:	31 d2                	xor    %edx,%edx
  80273d:	f7 f5                	div    %ebp
  80273f:	89 f0                	mov    %esi,%eax
  802741:	f7 f5                	div    %ebp
  802743:	89 d0                	mov    %edx,%eax
  802745:	eb d4                	jmp    80271b <__umoddi3+0x2b>
  802747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80274e:	66 90                	xchg   %ax,%ax
  802750:	89 f1                	mov    %esi,%ecx
  802752:	39 d8                	cmp    %ebx,%eax
  802754:	76 0a                	jbe    802760 <__umoddi3+0x70>
  802756:	89 f0                	mov    %esi,%eax
  802758:	83 c4 1c             	add    $0x1c,%esp
  80275b:	5b                   	pop    %ebx
  80275c:	5e                   	pop    %esi
  80275d:	5f                   	pop    %edi
  80275e:	5d                   	pop    %ebp
  80275f:	c3                   	ret    
  802760:	0f bd e8             	bsr    %eax,%ebp
  802763:	83 f5 1f             	xor    $0x1f,%ebp
  802766:	75 20                	jne    802788 <__umoddi3+0x98>
  802768:	39 d8                	cmp    %ebx,%eax
  80276a:	0f 82 b0 00 00 00    	jb     802820 <__umoddi3+0x130>
  802770:	39 f7                	cmp    %esi,%edi
  802772:	0f 86 a8 00 00 00    	jbe    802820 <__umoddi3+0x130>
  802778:	89 c8                	mov    %ecx,%eax
  80277a:	83 c4 1c             	add    $0x1c,%esp
  80277d:	5b                   	pop    %ebx
  80277e:	5e                   	pop    %esi
  80277f:	5f                   	pop    %edi
  802780:	5d                   	pop    %ebp
  802781:	c3                   	ret    
  802782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802788:	89 e9                	mov    %ebp,%ecx
  80278a:	ba 20 00 00 00       	mov    $0x20,%edx
  80278f:	29 ea                	sub    %ebp,%edx
  802791:	d3 e0                	shl    %cl,%eax
  802793:	89 44 24 08          	mov    %eax,0x8(%esp)
  802797:	89 d1                	mov    %edx,%ecx
  802799:	89 f8                	mov    %edi,%eax
  80279b:	d3 e8                	shr    %cl,%eax
  80279d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027a9:	09 c1                	or     %eax,%ecx
  8027ab:	89 d8                	mov    %ebx,%eax
  8027ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027b1:	89 e9                	mov    %ebp,%ecx
  8027b3:	d3 e7                	shl    %cl,%edi
  8027b5:	89 d1                	mov    %edx,%ecx
  8027b7:	d3 e8                	shr    %cl,%eax
  8027b9:	89 e9                	mov    %ebp,%ecx
  8027bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027bf:	d3 e3                	shl    %cl,%ebx
  8027c1:	89 c7                	mov    %eax,%edi
  8027c3:	89 d1                	mov    %edx,%ecx
  8027c5:	89 f0                	mov    %esi,%eax
  8027c7:	d3 e8                	shr    %cl,%eax
  8027c9:	89 e9                	mov    %ebp,%ecx
  8027cb:	89 fa                	mov    %edi,%edx
  8027cd:	d3 e6                	shl    %cl,%esi
  8027cf:	09 d8                	or     %ebx,%eax
  8027d1:	f7 74 24 08          	divl   0x8(%esp)
  8027d5:	89 d1                	mov    %edx,%ecx
  8027d7:	89 f3                	mov    %esi,%ebx
  8027d9:	f7 64 24 0c          	mull   0xc(%esp)
  8027dd:	89 c6                	mov    %eax,%esi
  8027df:	89 d7                	mov    %edx,%edi
  8027e1:	39 d1                	cmp    %edx,%ecx
  8027e3:	72 06                	jb     8027eb <__umoddi3+0xfb>
  8027e5:	75 10                	jne    8027f7 <__umoddi3+0x107>
  8027e7:	39 c3                	cmp    %eax,%ebx
  8027e9:	73 0c                	jae    8027f7 <__umoddi3+0x107>
  8027eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8027ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8027f3:	89 d7                	mov    %edx,%edi
  8027f5:	89 c6                	mov    %eax,%esi
  8027f7:	89 ca                	mov    %ecx,%edx
  8027f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027fe:	29 f3                	sub    %esi,%ebx
  802800:	19 fa                	sbb    %edi,%edx
  802802:	89 d0                	mov    %edx,%eax
  802804:	d3 e0                	shl    %cl,%eax
  802806:	89 e9                	mov    %ebp,%ecx
  802808:	d3 eb                	shr    %cl,%ebx
  80280a:	d3 ea                	shr    %cl,%edx
  80280c:	09 d8                	or     %ebx,%eax
  80280e:	83 c4 1c             	add    $0x1c,%esp
  802811:	5b                   	pop    %ebx
  802812:	5e                   	pop    %esi
  802813:	5f                   	pop    %edi
  802814:	5d                   	pop    %ebp
  802815:	c3                   	ret    
  802816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80281d:	8d 76 00             	lea    0x0(%esi),%esi
  802820:	89 da                	mov    %ebx,%edx
  802822:	29 fe                	sub    %edi,%esi
  802824:	19 c2                	sbb    %eax,%edx
  802826:	89 f1                	mov    %esi,%ecx
  802828:	89 c8                	mov    %ecx,%eax
  80282a:	e9 4b ff ff ff       	jmp    80277a <__umoddi3+0x8a>
