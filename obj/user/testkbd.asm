
obj/user/testkbd.debug：     文件格式 elf32-i386


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
  80002c:	e8 29 02 00 00       	call   80025a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 f0 0d 00 00       	call   800e34 <sys_yield>
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>

	close(0);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	e8 bb 11 00 00       	call   80120e <close>
	if ((r = opencons()) < 0)
  800053:	e8 b0 01 00 00       	call   800208 <opencons>
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	85 c0                	test   %eax,%eax
  80005d:	78 14                	js     800073 <umain+0x40>
		panic("opencons: %e", r);
	if (r != 0)
  80005f:	74 24                	je     800085 <umain+0x52>
		panic("first opencons used fd %d", r);
  800061:	50                   	push   %eax
  800062:	68 3c 25 80 00       	push   $0x80253c
  800067:	6a 11                	push   $0x11
  800069:	68 2d 25 80 00       	push   $0x80252d
  80006e:	e8 47 02 00 00       	call   8002ba <_panic>
		panic("opencons: %e", r);
  800073:	50                   	push   %eax
  800074:	68 20 25 80 00       	push   $0x802520
  800079:	6a 0f                	push   $0xf
  80007b:	68 2d 25 80 00       	push   $0x80252d
  800080:	e8 35 02 00 00       	call   8002ba <_panic>
	if ((r = dup(0, 1)) < 0)
  800085:	83 ec 08             	sub    $0x8,%esp
  800088:	6a 01                	push   $0x1
  80008a:	6a 00                	push   $0x0
  80008c:	e8 cf 11 00 00       	call   801260 <dup>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	79 24                	jns    8000bc <umain+0x89>
		panic("dup: %e", r);
  800098:	50                   	push   %eax
  800099:	68 56 25 80 00       	push   $0x802556
  80009e:	6a 13                	push   $0x13
  8000a0:	68 2d 25 80 00       	push   $0x80252d
  8000a5:	e8 10 02 00 00       	call   8002ba <_panic>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  8000aa:	83 ec 08             	sub    $0x8,%esp
  8000ad:	68 70 25 80 00       	push   $0x802570
  8000b2:	6a 01                	push   $0x1
  8000b4:	e8 ca 18 00 00       	call   801983 <fprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 5e 25 80 00       	push   $0x80255e
  8000c4:	e8 6f 08 00 00       	call   800938 <readline>
		if (buf != NULL)
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 da                	je     8000aa <umain+0x77>
			fprintf(1, "%s\n", buf);
  8000d0:	83 ec 04             	sub    $0x4,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 6c 25 80 00       	push   $0x80256c
  8000d9:	6a 01                	push   $0x1
  8000db:	e8 a3 18 00 00       	call   801983 <fprintf>
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	eb d7                	jmp    8000bc <umain+0x89>

008000e5 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8000e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ea:	c3                   	ret    

008000eb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8000f1:	68 88 25 80 00       	push   $0x802588
  8000f6:	ff 75 0c             	pushl  0xc(%ebp)
  8000f9:	e8 63 09 00 00       	call   800a61 <strcpy>
	return 0;
}
  8000fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800103:	c9                   	leave  
  800104:	c3                   	ret    

00800105 <devcons_write>:
{
  800105:	55                   	push   %ebp
  800106:	89 e5                	mov    %esp,%ebp
  800108:	57                   	push   %edi
  800109:	56                   	push   %esi
  80010a:	53                   	push   %ebx
  80010b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800111:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800116:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80011c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80011f:	73 31                	jae    800152 <devcons_write+0x4d>
		m = n - tot;
  800121:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800124:	29 f3                	sub    %esi,%ebx
  800126:	83 fb 7f             	cmp    $0x7f,%ebx
  800129:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80012e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	53                   	push   %ebx
  800135:	89 f0                	mov    %esi,%eax
  800137:	03 45 0c             	add    0xc(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	57                   	push   %edi
  80013c:	e8 ae 0a 00 00       	call   800bef <memmove>
		sys_cputs(buf, m);
  800141:	83 c4 08             	add    $0x8,%esp
  800144:	53                   	push   %ebx
  800145:	57                   	push   %edi
  800146:	e8 4c 0c 00 00       	call   800d97 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80014b:	01 de                	add    %ebx,%esi
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	eb ca                	jmp    80011c <devcons_write+0x17>
}
  800152:	89 f0                	mov    %esi,%eax
  800154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800157:	5b                   	pop    %ebx
  800158:	5e                   	pop    %esi
  800159:	5f                   	pop    %edi
  80015a:	5d                   	pop    %ebp
  80015b:	c3                   	ret    

0080015c <devcons_read>:
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 08             	sub    $0x8,%esp
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800167:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80016b:	74 21                	je     80018e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80016d:	e8 43 0c 00 00       	call   800db5 <sys_cgetc>
  800172:	85 c0                	test   %eax,%eax
  800174:	75 07                	jne    80017d <devcons_read+0x21>
		sys_yield();
  800176:	e8 b9 0c 00 00       	call   800e34 <sys_yield>
  80017b:	eb f0                	jmp    80016d <devcons_read+0x11>
	if (c < 0)
  80017d:	78 0f                	js     80018e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80017f:	83 f8 04             	cmp    $0x4,%eax
  800182:	74 0c                	je     800190 <devcons_read+0x34>
	*(char*)vbuf = c;
  800184:	8b 55 0c             	mov    0xc(%ebp),%edx
  800187:	88 02                	mov    %al,(%edx)
	return 1;
  800189:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    
		return 0;
  800190:	b8 00 00 00 00       	mov    $0x0,%eax
  800195:	eb f7                	jmp    80018e <devcons_read+0x32>

00800197 <cputchar>:
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80019d:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8001a3:	6a 01                	push   $0x1
  8001a5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001a8:	50                   	push   %eax
  8001a9:	e8 e9 0b 00 00       	call   800d97 <sys_cputs>
}
  8001ae:	83 c4 10             	add    $0x10,%esp
  8001b1:	c9                   	leave  
  8001b2:	c3                   	ret    

008001b3 <getchar>:
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8001b9:	6a 01                	push   $0x1
  8001bb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001be:	50                   	push   %eax
  8001bf:	6a 00                	push   $0x0
  8001c1:	e8 86 11 00 00       	call   80134c <read>
	if (r < 0)
  8001c6:	83 c4 10             	add    $0x10,%esp
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	78 06                	js     8001d3 <getchar+0x20>
	if (r < 1)
  8001cd:	74 06                	je     8001d5 <getchar+0x22>
	return c;
  8001cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8001d3:	c9                   	leave  
  8001d4:	c3                   	ret    
		return -E_EOF;
  8001d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8001da:	eb f7                	jmp    8001d3 <getchar+0x20>

008001dc <iscons>:
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8001e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001e5:	50                   	push   %eax
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	e8 ee 0e 00 00       	call   8010dc <fd_lookup>
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	78 11                	js     800206 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f8:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8001fe:	39 10                	cmp    %edx,(%eax)
  800200:	0f 94 c0             	sete   %al
  800203:	0f b6 c0             	movzbl %al,%eax
}
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <opencons>:
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80020e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800211:	50                   	push   %eax
  800212:	e8 73 0e 00 00       	call   80108a <fd_alloc>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	85 c0                	test   %eax,%eax
  80021c:	78 3a                	js     800258 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 07 04 00 00       	push   $0x407
  800226:	ff 75 f4             	pushl  -0xc(%ebp)
  800229:	6a 00                	push   $0x0
  80022b:	e8 23 0c 00 00       	call   800e53 <sys_page_alloc>
  800230:	83 c4 10             	add    $0x10,%esp
  800233:	85 c0                	test   %eax,%eax
  800235:	78 21                	js     800258 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023a:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800240:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800245:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	e8 0e 0e 00 00       	call   801063 <fd2num>
  800255:	83 c4 10             	add    $0x10,%esp
}
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	56                   	push   %esi
  80025e:	53                   	push   %ebx
  80025f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800262:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800265:	e8 ab 0b 00 00       	call   800e15 <sys_getenvid>
  80026a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80026f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800272:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800277:	a3 08 44 80 00       	mov    %eax,0x804408

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027c:	85 db                	test   %ebx,%ebx
  80027e:	7e 07                	jle    800287 <libmain+0x2d>
		binaryname = argv[0];
  800280:	8b 06                	mov    (%esi),%eax
  800282:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  800287:	83 ec 08             	sub    $0x8,%esp
  80028a:	56                   	push   %esi
  80028b:	53                   	push   %ebx
  80028c:	e8 a2 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800291:	e8 0a 00 00 00       	call   8002a0 <exit>
}
  800296:	83 c4 10             	add    $0x10,%esp
  800299:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80029c:	5b                   	pop    %ebx
  80029d:	5e                   	pop    %esi
  80029e:	5d                   	pop    %ebp
  80029f:	c3                   	ret    

008002a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8002a6:	e8 90 0f 00 00       	call   80123b <close_all>
	sys_env_destroy(0);
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	6a 00                	push   $0x0
  8002b0:	e8 1f 0b 00 00       	call   800dd4 <sys_env_destroy>
}
  8002b5:	83 c4 10             	add    $0x10,%esp
  8002b8:	c9                   	leave  
  8002b9:	c3                   	ret    

008002ba <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	56                   	push   %esi
  8002be:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002bf:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002c2:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  8002c8:	e8 48 0b 00 00       	call   800e15 <sys_getenvid>
  8002cd:	83 ec 0c             	sub    $0xc,%esp
  8002d0:	ff 75 0c             	pushl  0xc(%ebp)
  8002d3:	ff 75 08             	pushl  0x8(%ebp)
  8002d6:	56                   	push   %esi
  8002d7:	50                   	push   %eax
  8002d8:	68 a0 25 80 00       	push   $0x8025a0
  8002dd:	e8 b3 00 00 00       	call   800395 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002e2:	83 c4 18             	add    $0x18,%esp
  8002e5:	53                   	push   %ebx
  8002e6:	ff 75 10             	pushl  0x10(%ebp)
  8002e9:	e8 56 00 00 00       	call   800344 <vcprintf>
	cprintf("\n");
  8002ee:	c7 04 24 86 25 80 00 	movl   $0x802586,(%esp)
  8002f5:	e8 9b 00 00 00       	call   800395 <cprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002fd:	cc                   	int3   
  8002fe:	eb fd                	jmp    8002fd <_panic+0x43>

00800300 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	53                   	push   %ebx
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80030a:	8b 13                	mov    (%ebx),%edx
  80030c:	8d 42 01             	lea    0x1(%edx),%eax
  80030f:	89 03                	mov    %eax,(%ebx)
  800311:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800314:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800318:	3d ff 00 00 00       	cmp    $0xff,%eax
  80031d:	74 09                	je     800328 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80031f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800323:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800326:	c9                   	leave  
  800327:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800328:	83 ec 08             	sub    $0x8,%esp
  80032b:	68 ff 00 00 00       	push   $0xff
  800330:	8d 43 08             	lea    0x8(%ebx),%eax
  800333:	50                   	push   %eax
  800334:	e8 5e 0a 00 00       	call   800d97 <sys_cputs>
		b->idx = 0;
  800339:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80033f:	83 c4 10             	add    $0x10,%esp
  800342:	eb db                	jmp    80031f <putch+0x1f>

00800344 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80034d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800354:	00 00 00 
	b.cnt = 0;
  800357:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80035e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800361:	ff 75 0c             	pushl  0xc(%ebp)
  800364:	ff 75 08             	pushl  0x8(%ebp)
  800367:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80036d:	50                   	push   %eax
  80036e:	68 00 03 80 00       	push   $0x800300
  800373:	e8 19 01 00 00       	call   800491 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800378:	83 c4 08             	add    $0x8,%esp
  80037b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800381:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800387:	50                   	push   %eax
  800388:	e8 0a 0a 00 00       	call   800d97 <sys_cputs>

	return b.cnt;
}
  80038d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800393:	c9                   	leave  
  800394:	c3                   	ret    

00800395 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80039b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80039e:	50                   	push   %eax
  80039f:	ff 75 08             	pushl  0x8(%ebp)
  8003a2:	e8 9d ff ff ff       	call   800344 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	57                   	push   %edi
  8003ad:	56                   	push   %esi
  8003ae:	53                   	push   %ebx
  8003af:	83 ec 1c             	sub    $0x1c,%esp
  8003b2:	89 c7                	mov    %eax,%edi
  8003b4:	89 d6                	mov    %edx,%esi
  8003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003ca:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003cd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003d0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8003d3:	89 d0                	mov    %edx,%eax
  8003d5:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8003d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003db:	73 15                	jae    8003f2 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003dd:	83 eb 01             	sub    $0x1,%ebx
  8003e0:	85 db                	test   %ebx,%ebx
  8003e2:	7e 43                	jle    800427 <printnum+0x7e>
			putch(padc, putdat);
  8003e4:	83 ec 08             	sub    $0x8,%esp
  8003e7:	56                   	push   %esi
  8003e8:	ff 75 18             	pushl  0x18(%ebp)
  8003eb:	ff d7                	call   *%edi
  8003ed:	83 c4 10             	add    $0x10,%esp
  8003f0:	eb eb                	jmp    8003dd <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003f2:	83 ec 0c             	sub    $0xc,%esp
  8003f5:	ff 75 18             	pushl  0x18(%ebp)
  8003f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003fe:	53                   	push   %ebx
  8003ff:	ff 75 10             	pushl  0x10(%ebp)
  800402:	83 ec 08             	sub    $0x8,%esp
  800405:	ff 75 e4             	pushl  -0x1c(%ebp)
  800408:	ff 75 e0             	pushl  -0x20(%ebp)
  80040b:	ff 75 dc             	pushl  -0x24(%ebp)
  80040e:	ff 75 d8             	pushl  -0x28(%ebp)
  800411:	e8 aa 1e 00 00       	call   8022c0 <__udivdi3>
  800416:	83 c4 18             	add    $0x18,%esp
  800419:	52                   	push   %edx
  80041a:	50                   	push   %eax
  80041b:	89 f2                	mov    %esi,%edx
  80041d:	89 f8                	mov    %edi,%eax
  80041f:	e8 85 ff ff ff       	call   8003a9 <printnum>
  800424:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	56                   	push   %esi
  80042b:	83 ec 04             	sub    $0x4,%esp
  80042e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800431:	ff 75 e0             	pushl  -0x20(%ebp)
  800434:	ff 75 dc             	pushl  -0x24(%ebp)
  800437:	ff 75 d8             	pushl  -0x28(%ebp)
  80043a:	e8 91 1f 00 00       	call   8023d0 <__umoddi3>
  80043f:	83 c4 14             	add    $0x14,%esp
  800442:	0f be 80 c3 25 80 00 	movsbl 0x8025c3(%eax),%eax
  800449:	50                   	push   %eax
  80044a:	ff d7                	call   *%edi
}
  80044c:	83 c4 10             	add    $0x10,%esp
  80044f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800452:	5b                   	pop    %ebx
  800453:	5e                   	pop    %esi
  800454:	5f                   	pop    %edi
  800455:	5d                   	pop    %ebp
  800456:	c3                   	ret    

00800457 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80045d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800461:	8b 10                	mov    (%eax),%edx
  800463:	3b 50 04             	cmp    0x4(%eax),%edx
  800466:	73 0a                	jae    800472 <sprintputch+0x1b>
		*b->buf++ = ch;
  800468:	8d 4a 01             	lea    0x1(%edx),%ecx
  80046b:	89 08                	mov    %ecx,(%eax)
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	88 02                	mov    %al,(%edx)
}
  800472:	5d                   	pop    %ebp
  800473:	c3                   	ret    

00800474 <printfmt>:
{
  800474:	55                   	push   %ebp
  800475:	89 e5                	mov    %esp,%ebp
  800477:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80047a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80047d:	50                   	push   %eax
  80047e:	ff 75 10             	pushl  0x10(%ebp)
  800481:	ff 75 0c             	pushl  0xc(%ebp)
  800484:	ff 75 08             	pushl  0x8(%ebp)
  800487:	e8 05 00 00 00       	call   800491 <vprintfmt>
}
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	c9                   	leave  
  800490:	c3                   	ret    

00800491 <vprintfmt>:
{
  800491:	55                   	push   %ebp
  800492:	89 e5                	mov    %esp,%ebp
  800494:	57                   	push   %edi
  800495:	56                   	push   %esi
  800496:	53                   	push   %ebx
  800497:	83 ec 3c             	sub    $0x3c,%esp
  80049a:	8b 75 08             	mov    0x8(%ebp),%esi
  80049d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004a3:	eb 0a                	jmp    8004af <vprintfmt+0x1e>
			putch(ch, putdat);
  8004a5:	83 ec 08             	sub    $0x8,%esp
  8004a8:	53                   	push   %ebx
  8004a9:	50                   	push   %eax
  8004aa:	ff d6                	call   *%esi
  8004ac:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004af:	83 c7 01             	add    $0x1,%edi
  8004b2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004b6:	83 f8 25             	cmp    $0x25,%eax
  8004b9:	74 0c                	je     8004c7 <vprintfmt+0x36>
			if (ch == '\0')
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	75 e6                	jne    8004a5 <vprintfmt+0x14>
}
  8004bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004c2:	5b                   	pop    %ebx
  8004c3:	5e                   	pop    %esi
  8004c4:	5f                   	pop    %edi
  8004c5:	5d                   	pop    %ebp
  8004c6:	c3                   	ret    
		padc = ' ';
  8004c7:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8004cb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004d2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004d9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004e0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004e5:	8d 47 01             	lea    0x1(%edi),%eax
  8004e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004eb:	0f b6 17             	movzbl (%edi),%edx
  8004ee:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004f1:	3c 55                	cmp    $0x55,%al
  8004f3:	0f 87 ba 03 00 00    	ja     8008b3 <vprintfmt+0x422>
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  800503:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800506:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80050a:	eb d9                	jmp    8004e5 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80050c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80050f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800513:	eb d0                	jmp    8004e5 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800515:	0f b6 d2             	movzbl %dl,%edx
  800518:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80051b:	b8 00 00 00 00       	mov    $0x0,%eax
  800520:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800523:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800526:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80052a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80052d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800530:	83 f9 09             	cmp    $0x9,%ecx
  800533:	77 55                	ja     80058a <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800535:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800538:	eb e9                	jmp    800523 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	8d 40 04             	lea    0x4(%eax),%eax
  800548:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80054b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80054e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800552:	79 91                	jns    8004e5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800554:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800557:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80055a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800561:	eb 82                	jmp    8004e5 <vprintfmt+0x54>
  800563:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800566:	85 c0                	test   %eax,%eax
  800568:	ba 00 00 00 00       	mov    $0x0,%edx
  80056d:	0f 49 d0             	cmovns %eax,%edx
  800570:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800573:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800576:	e9 6a ff ff ff       	jmp    8004e5 <vprintfmt+0x54>
  80057b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80057e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800585:	e9 5b ff ff ff       	jmp    8004e5 <vprintfmt+0x54>
  80058a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80058d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800590:	eb bc                	jmp    80054e <vprintfmt+0xbd>
			lflag++;
  800592:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800595:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800598:	e9 48 ff ff ff       	jmp    8004e5 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	8d 78 04             	lea    0x4(%eax),%edi
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	53                   	push   %ebx
  8005a7:	ff 30                	pushl  (%eax)
  8005a9:	ff d6                	call   *%esi
			break;
  8005ab:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005ae:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005b1:	e9 9c 02 00 00       	jmp    800852 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8d 78 04             	lea    0x4(%eax),%edi
  8005bc:	8b 00                	mov    (%eax),%eax
  8005be:	99                   	cltd   
  8005bf:	31 d0                	xor    %edx,%eax
  8005c1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005c3:	83 f8 0f             	cmp    $0xf,%eax
  8005c6:	7f 23                	jg     8005eb <vprintfmt+0x15a>
  8005c8:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8005cf:	85 d2                	test   %edx,%edx
  8005d1:	74 18                	je     8005eb <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8005d3:	52                   	push   %edx
  8005d4:	68 aa 29 80 00       	push   $0x8029aa
  8005d9:	53                   	push   %ebx
  8005da:	56                   	push   %esi
  8005db:	e8 94 fe ff ff       	call   800474 <printfmt>
  8005e0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005e3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005e6:	e9 67 02 00 00       	jmp    800852 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8005eb:	50                   	push   %eax
  8005ec:	68 db 25 80 00       	push   $0x8025db
  8005f1:	53                   	push   %ebx
  8005f2:	56                   	push   %esi
  8005f3:	e8 7c fe ff ff       	call   800474 <printfmt>
  8005f8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005fb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005fe:	e9 4f 02 00 00       	jmp    800852 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	83 c0 04             	add    $0x4,%eax
  800609:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800611:	85 d2                	test   %edx,%edx
  800613:	b8 d4 25 80 00       	mov    $0x8025d4,%eax
  800618:	0f 45 c2             	cmovne %edx,%eax
  80061b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80061e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800622:	7e 06                	jle    80062a <vprintfmt+0x199>
  800624:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800628:	75 0d                	jne    800637 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80062a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80062d:	89 c7                	mov    %eax,%edi
  80062f:	03 45 e0             	add    -0x20(%ebp),%eax
  800632:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800635:	eb 3f                	jmp    800676 <vprintfmt+0x1e5>
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	ff 75 d8             	pushl  -0x28(%ebp)
  80063d:	50                   	push   %eax
  80063e:	e8 fd 03 00 00       	call   800a40 <strnlen>
  800643:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800646:	29 c2                	sub    %eax,%edx
  800648:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80064b:	83 c4 10             	add    $0x10,%esp
  80064e:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800650:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800654:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800657:	85 ff                	test   %edi,%edi
  800659:	7e 58                	jle    8006b3 <vprintfmt+0x222>
					putch(padc, putdat);
  80065b:	83 ec 08             	sub    $0x8,%esp
  80065e:	53                   	push   %ebx
  80065f:	ff 75 e0             	pushl  -0x20(%ebp)
  800662:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800664:	83 ef 01             	sub    $0x1,%edi
  800667:	83 c4 10             	add    $0x10,%esp
  80066a:	eb eb                	jmp    800657 <vprintfmt+0x1c6>
					putch(ch, putdat);
  80066c:	83 ec 08             	sub    $0x8,%esp
  80066f:	53                   	push   %ebx
  800670:	52                   	push   %edx
  800671:	ff d6                	call   *%esi
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800679:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80067b:	83 c7 01             	add    $0x1,%edi
  80067e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800682:	0f be d0             	movsbl %al,%edx
  800685:	85 d2                	test   %edx,%edx
  800687:	74 45                	je     8006ce <vprintfmt+0x23d>
  800689:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80068d:	78 06                	js     800695 <vprintfmt+0x204>
  80068f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800693:	78 35                	js     8006ca <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800695:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800699:	74 d1                	je     80066c <vprintfmt+0x1db>
  80069b:	0f be c0             	movsbl %al,%eax
  80069e:	83 e8 20             	sub    $0x20,%eax
  8006a1:	83 f8 5e             	cmp    $0x5e,%eax
  8006a4:	76 c6                	jbe    80066c <vprintfmt+0x1db>
					putch('?', putdat);
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	53                   	push   %ebx
  8006aa:	6a 3f                	push   $0x3f
  8006ac:	ff d6                	call   *%esi
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	eb c3                	jmp    800676 <vprintfmt+0x1e5>
  8006b3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006b6:	85 d2                	test   %edx,%edx
  8006b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8006bd:	0f 49 c2             	cmovns %edx,%eax
  8006c0:	29 c2                	sub    %eax,%edx
  8006c2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006c5:	e9 60 ff ff ff       	jmp    80062a <vprintfmt+0x199>
  8006ca:	89 cf                	mov    %ecx,%edi
  8006cc:	eb 02                	jmp    8006d0 <vprintfmt+0x23f>
  8006ce:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8006d0:	85 ff                	test   %edi,%edi
  8006d2:	7e 10                	jle    8006e4 <vprintfmt+0x253>
				putch(' ', putdat);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	53                   	push   %ebx
  8006d8:	6a 20                	push   $0x20
  8006da:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006dc:	83 ef 01             	sub    $0x1,%edi
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	eb ec                	jmp    8006d0 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8006e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	e9 63 01 00 00       	jmp    800852 <vprintfmt+0x3c1>
	if (lflag >= 2)
  8006ef:	83 f9 01             	cmp    $0x1,%ecx
  8006f2:	7f 1b                	jg     80070f <vprintfmt+0x27e>
	else if (lflag)
  8006f4:	85 c9                	test   %ecx,%ecx
  8006f6:	74 63                	je     80075b <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800700:	99                   	cltd   
  800701:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8d 40 04             	lea    0x4(%eax),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
  80070d:	eb 17                	jmp    800726 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 50 04             	mov    0x4(%eax),%edx
  800715:	8b 00                	mov    (%eax),%eax
  800717:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8d 40 08             	lea    0x8(%eax),%eax
  800723:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800726:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800729:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80072c:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800731:	85 c9                	test   %ecx,%ecx
  800733:	0f 89 ff 00 00 00    	jns    800838 <vprintfmt+0x3a7>
				putch('-', putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	53                   	push   %ebx
  80073d:	6a 2d                	push   $0x2d
  80073f:	ff d6                	call   *%esi
				num = -(long long) num;
  800741:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800744:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800747:	f7 da                	neg    %edx
  800749:	83 d1 00             	adc    $0x0,%ecx
  80074c:	f7 d9                	neg    %ecx
  80074e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800751:	b8 0a 00 00 00       	mov    $0xa,%eax
  800756:	e9 dd 00 00 00       	jmp    800838 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800763:	99                   	cltd   
  800764:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8d 40 04             	lea    0x4(%eax),%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
  800770:	eb b4                	jmp    800726 <vprintfmt+0x295>
	if (lflag >= 2)
  800772:	83 f9 01             	cmp    $0x1,%ecx
  800775:	7f 1e                	jg     800795 <vprintfmt+0x304>
	else if (lflag)
  800777:	85 c9                	test   %ecx,%ecx
  800779:	74 32                	je     8007ad <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8b 10                	mov    (%eax),%edx
  800780:	b9 00 00 00 00       	mov    $0x0,%ecx
  800785:	8d 40 04             	lea    0x4(%eax),%eax
  800788:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80078b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800790:	e9 a3 00 00 00       	jmp    800838 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8b 10                	mov    (%eax),%edx
  80079a:	8b 48 04             	mov    0x4(%eax),%ecx
  80079d:	8d 40 08             	lea    0x8(%eax),%eax
  8007a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a8:	e9 8b 00 00 00       	jmp    800838 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8b 10                	mov    (%eax),%edx
  8007b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c2:	eb 74                	jmp    800838 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8007c4:	83 f9 01             	cmp    $0x1,%ecx
  8007c7:	7f 1b                	jg     8007e4 <vprintfmt+0x353>
	else if (lflag)
  8007c9:	85 c9                	test   %ecx,%ecx
  8007cb:	74 2c                	je     8007f9 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8b 10                	mov    (%eax),%edx
  8007d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d7:	8d 40 04             	lea    0x4(%eax),%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007dd:	b8 08 00 00 00       	mov    $0x8,%eax
  8007e2:	eb 54                	jmp    800838 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	8b 10                	mov    (%eax),%edx
  8007e9:	8b 48 04             	mov    0x4(%eax),%ecx
  8007ec:	8d 40 08             	lea    0x8(%eax),%eax
  8007ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8007f7:	eb 3f                	jmp    800838 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8b 10                	mov    (%eax),%edx
  8007fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800803:	8d 40 04             	lea    0x4(%eax),%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800809:	b8 08 00 00 00       	mov    $0x8,%eax
  80080e:	eb 28                	jmp    800838 <vprintfmt+0x3a7>
			putch('0', putdat);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	53                   	push   %ebx
  800814:	6a 30                	push   $0x30
  800816:	ff d6                	call   *%esi
			putch('x', putdat);
  800818:	83 c4 08             	add    $0x8,%esp
  80081b:	53                   	push   %ebx
  80081c:	6a 78                	push   $0x78
  80081e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	8b 10                	mov    (%eax),%edx
  800825:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80082a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80082d:	8d 40 04             	lea    0x4(%eax),%eax
  800830:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800833:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800838:	83 ec 0c             	sub    $0xc,%esp
  80083b:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80083f:	57                   	push   %edi
  800840:	ff 75 e0             	pushl  -0x20(%ebp)
  800843:	50                   	push   %eax
  800844:	51                   	push   %ecx
  800845:	52                   	push   %edx
  800846:	89 da                	mov    %ebx,%edx
  800848:	89 f0                	mov    %esi,%eax
  80084a:	e8 5a fb ff ff       	call   8003a9 <printnum>
			break;
  80084f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800852:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800855:	e9 55 fc ff ff       	jmp    8004af <vprintfmt+0x1e>
	if (lflag >= 2)
  80085a:	83 f9 01             	cmp    $0x1,%ecx
  80085d:	7f 1b                	jg     80087a <vprintfmt+0x3e9>
	else if (lflag)
  80085f:	85 c9                	test   %ecx,%ecx
  800861:	74 2c                	je     80088f <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	8b 10                	mov    (%eax),%edx
  800868:	b9 00 00 00 00       	mov    $0x0,%ecx
  80086d:	8d 40 04             	lea    0x4(%eax),%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800873:	b8 10 00 00 00       	mov    $0x10,%eax
  800878:	eb be                	jmp    800838 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8b 10                	mov    (%eax),%edx
  80087f:	8b 48 04             	mov    0x4(%eax),%ecx
  800882:	8d 40 08             	lea    0x8(%eax),%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800888:	b8 10 00 00 00       	mov    $0x10,%eax
  80088d:	eb a9                	jmp    800838 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8b 10                	mov    (%eax),%edx
  800894:	b9 00 00 00 00       	mov    $0x0,%ecx
  800899:	8d 40 04             	lea    0x4(%eax),%eax
  80089c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80089f:	b8 10 00 00 00       	mov    $0x10,%eax
  8008a4:	eb 92                	jmp    800838 <vprintfmt+0x3a7>
			putch(ch, putdat);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	53                   	push   %ebx
  8008aa:	6a 25                	push   $0x25
  8008ac:	ff d6                	call   *%esi
			break;
  8008ae:	83 c4 10             	add    $0x10,%esp
  8008b1:	eb 9f                	jmp    800852 <vprintfmt+0x3c1>
			putch('%', putdat);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	53                   	push   %ebx
  8008b7:	6a 25                	push   $0x25
  8008b9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008bb:	83 c4 10             	add    $0x10,%esp
  8008be:	89 f8                	mov    %edi,%eax
  8008c0:	eb 03                	jmp    8008c5 <vprintfmt+0x434>
  8008c2:	83 e8 01             	sub    $0x1,%eax
  8008c5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008c9:	75 f7                	jne    8008c2 <vprintfmt+0x431>
  8008cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ce:	eb 82                	jmp    800852 <vprintfmt+0x3c1>

008008d0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 18             	sub    $0x18,%esp
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008df:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008e3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ed:	85 c0                	test   %eax,%eax
  8008ef:	74 26                	je     800917 <vsnprintf+0x47>
  8008f1:	85 d2                	test   %edx,%edx
  8008f3:	7e 22                	jle    800917 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008f5:	ff 75 14             	pushl  0x14(%ebp)
  8008f8:	ff 75 10             	pushl  0x10(%ebp)
  8008fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008fe:	50                   	push   %eax
  8008ff:	68 57 04 80 00       	push   $0x800457
  800904:	e8 88 fb ff ff       	call   800491 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800909:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80090c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80090f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800912:	83 c4 10             	add    $0x10,%esp
}
  800915:	c9                   	leave  
  800916:	c3                   	ret    
		return -E_INVAL;
  800917:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80091c:	eb f7                	jmp    800915 <vsnprintf+0x45>

0080091e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800924:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800927:	50                   	push   %eax
  800928:	ff 75 10             	pushl  0x10(%ebp)
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	ff 75 08             	pushl  0x8(%ebp)
  800931:	e8 9a ff ff ff       	call   8008d0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800936:	c9                   	leave  
  800937:	c3                   	ret    

00800938 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	57                   	push   %edi
  80093c:	56                   	push   %esi
  80093d:	53                   	push   %ebx
  80093e:	83 ec 0c             	sub    $0xc,%esp
  800941:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800944:	85 c0                	test   %eax,%eax
  800946:	74 13                	je     80095b <readline+0x23>
		fprintf(1, "%s", prompt);
  800948:	83 ec 04             	sub    $0x4,%esp
  80094b:	50                   	push   %eax
  80094c:	68 aa 29 80 00       	push   $0x8029aa
  800951:	6a 01                	push   $0x1
  800953:	e8 2b 10 00 00       	call   801983 <fprintf>
  800958:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  80095b:	83 ec 0c             	sub    $0xc,%esp
  80095e:	6a 00                	push   $0x0
  800960:	e8 77 f8 ff ff       	call   8001dc <iscons>
  800965:	89 c7                	mov    %eax,%edi
  800967:	83 c4 10             	add    $0x10,%esp
	i = 0;
  80096a:	be 00 00 00 00       	mov    $0x0,%esi
  80096f:	eb 57                	jmp    8009c8 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800971:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  800976:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800979:	75 08                	jne    800983 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  80097b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80097e:	5b                   	pop    %ebx
  80097f:	5e                   	pop    %esi
  800980:	5f                   	pop    %edi
  800981:	5d                   	pop    %ebp
  800982:	c3                   	ret    
				cprintf("read error: %e\n", c);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	53                   	push   %ebx
  800987:	68 bf 28 80 00       	push   $0x8028bf
  80098c:	e8 04 fa ff ff       	call   800395 <cprintf>
  800991:	83 c4 10             	add    $0x10,%esp
			return NULL;
  800994:	b8 00 00 00 00       	mov    $0x0,%eax
  800999:	eb e0                	jmp    80097b <readline+0x43>
			if (echoing)
  80099b:	85 ff                	test   %edi,%edi
  80099d:	75 05                	jne    8009a4 <readline+0x6c>
			i--;
  80099f:	83 ee 01             	sub    $0x1,%esi
  8009a2:	eb 24                	jmp    8009c8 <readline+0x90>
				cputchar('\b');
  8009a4:	83 ec 0c             	sub    $0xc,%esp
  8009a7:	6a 08                	push   $0x8
  8009a9:	e8 e9 f7 ff ff       	call   800197 <cputchar>
  8009ae:	83 c4 10             	add    $0x10,%esp
  8009b1:	eb ec                	jmp    80099f <readline+0x67>
				cputchar(c);
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	53                   	push   %ebx
  8009b7:	e8 db f7 ff ff       	call   800197 <cputchar>
  8009bc:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8009bf:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  8009c5:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  8009c8:	e8 e6 f7 ff ff       	call   8001b3 <getchar>
  8009cd:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8009cf:	85 c0                	test   %eax,%eax
  8009d1:	78 9e                	js     800971 <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8009d3:	83 f8 08             	cmp    $0x8,%eax
  8009d6:	0f 94 c2             	sete   %dl
  8009d9:	83 f8 7f             	cmp    $0x7f,%eax
  8009dc:	0f 94 c0             	sete   %al
  8009df:	08 c2                	or     %al,%dl
  8009e1:	74 04                	je     8009e7 <readline+0xaf>
  8009e3:	85 f6                	test   %esi,%esi
  8009e5:	7f b4                	jg     80099b <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009e7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ea:	7e 0e                	jle    8009fa <readline+0xc2>
  8009ec:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8009f2:	7f 06                	jg     8009fa <readline+0xc2>
			if (echoing)
  8009f4:	85 ff                	test   %edi,%edi
  8009f6:	74 c7                	je     8009bf <readline+0x87>
  8009f8:	eb b9                	jmp    8009b3 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  8009fa:	83 fb 0a             	cmp    $0xa,%ebx
  8009fd:	74 05                	je     800a04 <readline+0xcc>
  8009ff:	83 fb 0d             	cmp    $0xd,%ebx
  800a02:	75 c4                	jne    8009c8 <readline+0x90>
			if (echoing)
  800a04:	85 ff                	test   %edi,%edi
  800a06:	75 11                	jne    800a19 <readline+0xe1>
			buf[i] = 0;
  800a08:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800a0f:	b8 00 40 80 00       	mov    $0x804000,%eax
  800a14:	e9 62 ff ff ff       	jmp    80097b <readline+0x43>
				cputchar('\n');
  800a19:	83 ec 0c             	sub    $0xc,%esp
  800a1c:	6a 0a                	push   $0xa
  800a1e:	e8 74 f7 ff ff       	call   800197 <cputchar>
  800a23:	83 c4 10             	add    $0x10,%esp
  800a26:	eb e0                	jmp    800a08 <readline+0xd0>

00800a28 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a37:	74 05                	je     800a3e <strlen+0x16>
		n++;
  800a39:	83 c0 01             	add    $0x1,%eax
  800a3c:	eb f5                	jmp    800a33 <strlen+0xb>
	return n;
}
  800a3e:	5d                   	pop    %ebp
  800a3f:	c3                   	ret    

00800a40 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a46:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a49:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4e:	39 c2                	cmp    %eax,%edx
  800a50:	74 0d                	je     800a5f <strnlen+0x1f>
  800a52:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a56:	74 05                	je     800a5d <strnlen+0x1d>
		n++;
  800a58:	83 c2 01             	add    $0x1,%edx
  800a5b:	eb f1                	jmp    800a4e <strnlen+0xe>
  800a5d:	89 d0                	mov    %edx,%eax
	return n;
}
  800a5f:	5d                   	pop    %ebp
  800a60:	c3                   	ret    

00800a61 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	53                   	push   %ebx
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a70:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a77:	83 c2 01             	add    $0x1,%edx
  800a7a:	84 c9                	test   %cl,%cl
  800a7c:	75 f2                	jne    800a70 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a7e:	5b                   	pop    %ebx
  800a7f:	5d                   	pop    %ebp
  800a80:	c3                   	ret    

00800a81 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	53                   	push   %ebx
  800a85:	83 ec 10             	sub    $0x10,%esp
  800a88:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a8b:	53                   	push   %ebx
  800a8c:	e8 97 ff ff ff       	call   800a28 <strlen>
  800a91:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	01 d8                	add    %ebx,%eax
  800a99:	50                   	push   %eax
  800a9a:	e8 c2 ff ff ff       	call   800a61 <strcpy>
	return dst;
}
  800a9f:	89 d8                	mov    %ebx,%eax
  800aa1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa4:	c9                   	leave  
  800aa5:	c3                   	ret    

00800aa6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	56                   	push   %esi
  800aaa:	53                   	push   %ebx
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab1:	89 c6                	mov    %eax,%esi
  800ab3:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab6:	89 c2                	mov    %eax,%edx
  800ab8:	39 f2                	cmp    %esi,%edx
  800aba:	74 11                	je     800acd <strncpy+0x27>
		*dst++ = *src;
  800abc:	83 c2 01             	add    $0x1,%edx
  800abf:	0f b6 19             	movzbl (%ecx),%ebx
  800ac2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ac5:	80 fb 01             	cmp    $0x1,%bl
  800ac8:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800acb:	eb eb                	jmp    800ab8 <strncpy+0x12>
	}
	return ret;
}
  800acd:	5b                   	pop    %ebx
  800ace:	5e                   	pop    %esi
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	56                   	push   %esi
  800ad5:	53                   	push   %ebx
  800ad6:	8b 75 08             	mov    0x8(%ebp),%esi
  800ad9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800adc:	8b 55 10             	mov    0x10(%ebp),%edx
  800adf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ae1:	85 d2                	test   %edx,%edx
  800ae3:	74 21                	je     800b06 <strlcpy+0x35>
  800ae5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ae9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800aeb:	39 c2                	cmp    %eax,%edx
  800aed:	74 14                	je     800b03 <strlcpy+0x32>
  800aef:	0f b6 19             	movzbl (%ecx),%ebx
  800af2:	84 db                	test   %bl,%bl
  800af4:	74 0b                	je     800b01 <strlcpy+0x30>
			*dst++ = *src++;
  800af6:	83 c1 01             	add    $0x1,%ecx
  800af9:	83 c2 01             	add    $0x1,%edx
  800afc:	88 5a ff             	mov    %bl,-0x1(%edx)
  800aff:	eb ea                	jmp    800aeb <strlcpy+0x1a>
  800b01:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b03:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b06:	29 f0                	sub    %esi,%eax
}
  800b08:	5b                   	pop    %ebx
  800b09:	5e                   	pop    %esi
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    

00800b0c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b12:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b15:	0f b6 01             	movzbl (%ecx),%eax
  800b18:	84 c0                	test   %al,%al
  800b1a:	74 0c                	je     800b28 <strcmp+0x1c>
  800b1c:	3a 02                	cmp    (%edx),%al
  800b1e:	75 08                	jne    800b28 <strcmp+0x1c>
		p++, q++;
  800b20:	83 c1 01             	add    $0x1,%ecx
  800b23:	83 c2 01             	add    $0x1,%edx
  800b26:	eb ed                	jmp    800b15 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b28:	0f b6 c0             	movzbl %al,%eax
  800b2b:	0f b6 12             	movzbl (%edx),%edx
  800b2e:	29 d0                	sub    %edx,%eax
}
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	53                   	push   %ebx
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3c:	89 c3                	mov    %eax,%ebx
  800b3e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b41:	eb 06                	jmp    800b49 <strncmp+0x17>
		n--, p++, q++;
  800b43:	83 c0 01             	add    $0x1,%eax
  800b46:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b49:	39 d8                	cmp    %ebx,%eax
  800b4b:	74 16                	je     800b63 <strncmp+0x31>
  800b4d:	0f b6 08             	movzbl (%eax),%ecx
  800b50:	84 c9                	test   %cl,%cl
  800b52:	74 04                	je     800b58 <strncmp+0x26>
  800b54:	3a 0a                	cmp    (%edx),%cl
  800b56:	74 eb                	je     800b43 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b58:	0f b6 00             	movzbl (%eax),%eax
  800b5b:	0f b6 12             	movzbl (%edx),%edx
  800b5e:	29 d0                	sub    %edx,%eax
}
  800b60:	5b                   	pop    %ebx
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    
		return 0;
  800b63:	b8 00 00 00 00       	mov    $0x0,%eax
  800b68:	eb f6                	jmp    800b60 <strncmp+0x2e>

00800b6a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b74:	0f b6 10             	movzbl (%eax),%edx
  800b77:	84 d2                	test   %dl,%dl
  800b79:	74 09                	je     800b84 <strchr+0x1a>
		if (*s == c)
  800b7b:	38 ca                	cmp    %cl,%dl
  800b7d:	74 0a                	je     800b89 <strchr+0x1f>
	for (; *s; s++)
  800b7f:	83 c0 01             	add    $0x1,%eax
  800b82:	eb f0                	jmp    800b74 <strchr+0xa>
			return (char *) s;
	return 0;
  800b84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b89:	5d                   	pop    %ebp
  800b8a:	c3                   	ret    

00800b8b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b95:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b98:	38 ca                	cmp    %cl,%dl
  800b9a:	74 09                	je     800ba5 <strfind+0x1a>
  800b9c:	84 d2                	test   %dl,%dl
  800b9e:	74 05                	je     800ba5 <strfind+0x1a>
	for (; *s; s++)
  800ba0:	83 c0 01             	add    $0x1,%eax
  800ba3:	eb f0                	jmp    800b95 <strfind+0xa>
			break;
	return (char *) s;
}
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
  800bad:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bb3:	85 c9                	test   %ecx,%ecx
  800bb5:	74 31                	je     800be8 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bb7:	89 f8                	mov    %edi,%eax
  800bb9:	09 c8                	or     %ecx,%eax
  800bbb:	a8 03                	test   $0x3,%al
  800bbd:	75 23                	jne    800be2 <memset+0x3b>
		c &= 0xFF;
  800bbf:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bc3:	89 d3                	mov    %edx,%ebx
  800bc5:	c1 e3 08             	shl    $0x8,%ebx
  800bc8:	89 d0                	mov    %edx,%eax
  800bca:	c1 e0 18             	shl    $0x18,%eax
  800bcd:	89 d6                	mov    %edx,%esi
  800bcf:	c1 e6 10             	shl    $0x10,%esi
  800bd2:	09 f0                	or     %esi,%eax
  800bd4:	09 c2                	or     %eax,%edx
  800bd6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bd8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bdb:	89 d0                	mov    %edx,%eax
  800bdd:	fc                   	cld    
  800bde:	f3 ab                	rep stos %eax,%es:(%edi)
  800be0:	eb 06                	jmp    800be8 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	fc                   	cld    
  800be6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800be8:	89 f8                	mov    %edi,%eax
  800bea:	5b                   	pop    %ebx
  800beb:	5e                   	pop    %esi
  800bec:	5f                   	pop    %edi
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	57                   	push   %edi
  800bf3:	56                   	push   %esi
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bfa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bfd:	39 c6                	cmp    %eax,%esi
  800bff:	73 32                	jae    800c33 <memmove+0x44>
  800c01:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c04:	39 c2                	cmp    %eax,%edx
  800c06:	76 2b                	jbe    800c33 <memmove+0x44>
		s += n;
		d += n;
  800c08:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0b:	89 fe                	mov    %edi,%esi
  800c0d:	09 ce                	or     %ecx,%esi
  800c0f:	09 d6                	or     %edx,%esi
  800c11:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c17:	75 0e                	jne    800c27 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c19:	83 ef 04             	sub    $0x4,%edi
  800c1c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c1f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c22:	fd                   	std    
  800c23:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c25:	eb 09                	jmp    800c30 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c27:	83 ef 01             	sub    $0x1,%edi
  800c2a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c2d:	fd                   	std    
  800c2e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c30:	fc                   	cld    
  800c31:	eb 1a                	jmp    800c4d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c33:	89 c2                	mov    %eax,%edx
  800c35:	09 ca                	or     %ecx,%edx
  800c37:	09 f2                	or     %esi,%edx
  800c39:	f6 c2 03             	test   $0x3,%dl
  800c3c:	75 0a                	jne    800c48 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c3e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c41:	89 c7                	mov    %eax,%edi
  800c43:	fc                   	cld    
  800c44:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c46:	eb 05                	jmp    800c4d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c48:	89 c7                	mov    %eax,%edi
  800c4a:	fc                   	cld    
  800c4b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c4d:	5e                   	pop    %esi
  800c4e:	5f                   	pop    %edi
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c57:	ff 75 10             	pushl  0x10(%ebp)
  800c5a:	ff 75 0c             	pushl  0xc(%ebp)
  800c5d:	ff 75 08             	pushl  0x8(%ebp)
  800c60:	e8 8a ff ff ff       	call   800bef <memmove>
}
  800c65:	c9                   	leave  
  800c66:	c3                   	ret    

00800c67 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	56                   	push   %esi
  800c6b:	53                   	push   %ebx
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c72:	89 c6                	mov    %eax,%esi
  800c74:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c77:	39 f0                	cmp    %esi,%eax
  800c79:	74 1c                	je     800c97 <memcmp+0x30>
		if (*s1 != *s2)
  800c7b:	0f b6 08             	movzbl (%eax),%ecx
  800c7e:	0f b6 1a             	movzbl (%edx),%ebx
  800c81:	38 d9                	cmp    %bl,%cl
  800c83:	75 08                	jne    800c8d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c85:	83 c0 01             	add    $0x1,%eax
  800c88:	83 c2 01             	add    $0x1,%edx
  800c8b:	eb ea                	jmp    800c77 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c8d:	0f b6 c1             	movzbl %cl,%eax
  800c90:	0f b6 db             	movzbl %bl,%ebx
  800c93:	29 d8                	sub    %ebx,%eax
  800c95:	eb 05                	jmp    800c9c <memcmp+0x35>
	}

	return 0;
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9c:	5b                   	pop    %ebx
  800c9d:	5e                   	pop    %esi
  800c9e:	5d                   	pop    %ebp
  800c9f:	c3                   	ret    

00800ca0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ca9:	89 c2                	mov    %eax,%edx
  800cab:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cae:	39 d0                	cmp    %edx,%eax
  800cb0:	73 09                	jae    800cbb <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb2:	38 08                	cmp    %cl,(%eax)
  800cb4:	74 05                	je     800cbb <memfind+0x1b>
	for (; s < ends; s++)
  800cb6:	83 c0 01             	add    $0x1,%eax
  800cb9:	eb f3                	jmp    800cae <memfind+0xe>
			break;
	return (void *) s;
}
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    

00800cbd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	57                   	push   %edi
  800cc1:	56                   	push   %esi
  800cc2:	53                   	push   %ebx
  800cc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc9:	eb 03                	jmp    800cce <strtol+0x11>
		s++;
  800ccb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cce:	0f b6 01             	movzbl (%ecx),%eax
  800cd1:	3c 20                	cmp    $0x20,%al
  800cd3:	74 f6                	je     800ccb <strtol+0xe>
  800cd5:	3c 09                	cmp    $0x9,%al
  800cd7:	74 f2                	je     800ccb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cd9:	3c 2b                	cmp    $0x2b,%al
  800cdb:	74 2a                	je     800d07 <strtol+0x4a>
	int neg = 0;
  800cdd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ce2:	3c 2d                	cmp    $0x2d,%al
  800ce4:	74 2b                	je     800d11 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cec:	75 0f                	jne    800cfd <strtol+0x40>
  800cee:	80 39 30             	cmpb   $0x30,(%ecx)
  800cf1:	74 28                	je     800d1b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cf3:	85 db                	test   %ebx,%ebx
  800cf5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cfa:	0f 44 d8             	cmove  %eax,%ebx
  800cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800d02:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d05:	eb 50                	jmp    800d57 <strtol+0x9a>
		s++;
  800d07:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d0a:	bf 00 00 00 00       	mov    $0x0,%edi
  800d0f:	eb d5                	jmp    800ce6 <strtol+0x29>
		s++, neg = 1;
  800d11:	83 c1 01             	add    $0x1,%ecx
  800d14:	bf 01 00 00 00       	mov    $0x1,%edi
  800d19:	eb cb                	jmp    800ce6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d1b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d1f:	74 0e                	je     800d2f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d21:	85 db                	test   %ebx,%ebx
  800d23:	75 d8                	jne    800cfd <strtol+0x40>
		s++, base = 8;
  800d25:	83 c1 01             	add    $0x1,%ecx
  800d28:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d2d:	eb ce                	jmp    800cfd <strtol+0x40>
		s += 2, base = 16;
  800d2f:	83 c1 02             	add    $0x2,%ecx
  800d32:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d37:	eb c4                	jmp    800cfd <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d39:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d3c:	89 f3                	mov    %esi,%ebx
  800d3e:	80 fb 19             	cmp    $0x19,%bl
  800d41:	77 29                	ja     800d6c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d43:	0f be d2             	movsbl %dl,%edx
  800d46:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d49:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d4c:	7d 30                	jge    800d7e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d4e:	83 c1 01             	add    $0x1,%ecx
  800d51:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d55:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d57:	0f b6 11             	movzbl (%ecx),%edx
  800d5a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d5d:	89 f3                	mov    %esi,%ebx
  800d5f:	80 fb 09             	cmp    $0x9,%bl
  800d62:	77 d5                	ja     800d39 <strtol+0x7c>
			dig = *s - '0';
  800d64:	0f be d2             	movsbl %dl,%edx
  800d67:	83 ea 30             	sub    $0x30,%edx
  800d6a:	eb dd                	jmp    800d49 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d6c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d6f:	89 f3                	mov    %esi,%ebx
  800d71:	80 fb 19             	cmp    $0x19,%bl
  800d74:	77 08                	ja     800d7e <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d76:	0f be d2             	movsbl %dl,%edx
  800d79:	83 ea 37             	sub    $0x37,%edx
  800d7c:	eb cb                	jmp    800d49 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d82:	74 05                	je     800d89 <strtol+0xcc>
		*endptr = (char *) s;
  800d84:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d87:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d89:	89 c2                	mov    %eax,%edx
  800d8b:	f7 da                	neg    %edx
  800d8d:	85 ff                	test   %edi,%edi
  800d8f:	0f 45 c2             	cmovne %edx,%eax
}
  800d92:	5b                   	pop    %ebx
  800d93:	5e                   	pop    %esi
  800d94:	5f                   	pop    %edi
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    

00800d97 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800da2:	8b 55 08             	mov    0x8(%ebp),%edx
  800da5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da8:	89 c3                	mov    %eax,%ebx
  800daa:	89 c7                	mov    %eax,%edi
  800dac:	89 c6                	mov    %eax,%esi
  800dae:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	57                   	push   %edi
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc0:	b8 01 00 00 00       	mov    $0x1,%eax
  800dc5:	89 d1                	mov    %edx,%ecx
  800dc7:	89 d3                	mov    %edx,%ebx
  800dc9:	89 d7                	mov    %edx,%edi
  800dcb:	89 d6                	mov    %edx,%esi
  800dcd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	57                   	push   %edi
  800dd8:	56                   	push   %esi
  800dd9:	53                   	push   %ebx
  800dda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ddd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de2:	8b 55 08             	mov    0x8(%ebp),%edx
  800de5:	b8 03 00 00 00       	mov    $0x3,%eax
  800dea:	89 cb                	mov    %ecx,%ebx
  800dec:	89 cf                	mov    %ecx,%edi
  800dee:	89 ce                	mov    %ecx,%esi
  800df0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df2:	85 c0                	test   %eax,%eax
  800df4:	7f 08                	jg     800dfe <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df9:	5b                   	pop    %ebx
  800dfa:	5e                   	pop    %esi
  800dfb:	5f                   	pop    %edi
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfe:	83 ec 0c             	sub    $0xc,%esp
  800e01:	50                   	push   %eax
  800e02:	6a 03                	push   $0x3
  800e04:	68 cf 28 80 00       	push   $0x8028cf
  800e09:	6a 23                	push   $0x23
  800e0b:	68 ec 28 80 00       	push   $0x8028ec
  800e10:	e8 a5 f4 ff ff       	call   8002ba <_panic>

00800e15 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	57                   	push   %edi
  800e19:	56                   	push   %esi
  800e1a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e20:	b8 02 00 00 00       	mov    $0x2,%eax
  800e25:	89 d1                	mov    %edx,%ecx
  800e27:	89 d3                	mov    %edx,%ebx
  800e29:	89 d7                	mov    %edx,%edi
  800e2b:	89 d6                	mov    %edx,%esi
  800e2d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e2f:	5b                   	pop    %ebx
  800e30:	5e                   	pop    %esi
  800e31:	5f                   	pop    %edi
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    

00800e34 <sys_yield>:

void
sys_yield(void)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	57                   	push   %edi
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e44:	89 d1                	mov    %edx,%ecx
  800e46:	89 d3                	mov    %edx,%ebx
  800e48:	89 d7                	mov    %edx,%edi
  800e4a:	89 d6                	mov    %edx,%esi
  800e4c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	57                   	push   %edi
  800e57:	56                   	push   %esi
  800e58:	53                   	push   %ebx
  800e59:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5c:	be 00 00 00 00       	mov    $0x0,%esi
  800e61:	8b 55 08             	mov    0x8(%ebp),%edx
  800e64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e67:	b8 04 00 00 00       	mov    $0x4,%eax
  800e6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e6f:	89 f7                	mov    %esi,%edi
  800e71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	7f 08                	jg     800e7f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7a:	5b                   	pop    %ebx
  800e7b:	5e                   	pop    %esi
  800e7c:	5f                   	pop    %edi
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7f:	83 ec 0c             	sub    $0xc,%esp
  800e82:	50                   	push   %eax
  800e83:	6a 04                	push   $0x4
  800e85:	68 cf 28 80 00       	push   $0x8028cf
  800e8a:	6a 23                	push   $0x23
  800e8c:	68 ec 28 80 00       	push   $0x8028ec
  800e91:	e8 24 f4 ff ff       	call   8002ba <_panic>

00800e96 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea5:	b8 05 00 00 00       	mov    $0x5,%eax
  800eaa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ead:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb0:	8b 75 18             	mov    0x18(%ebp),%esi
  800eb3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	7f 08                	jg     800ec1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebc:	5b                   	pop    %ebx
  800ebd:	5e                   	pop    %esi
  800ebe:	5f                   	pop    %edi
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec1:	83 ec 0c             	sub    $0xc,%esp
  800ec4:	50                   	push   %eax
  800ec5:	6a 05                	push   $0x5
  800ec7:	68 cf 28 80 00       	push   $0x8028cf
  800ecc:	6a 23                	push   $0x23
  800ece:	68 ec 28 80 00       	push   $0x8028ec
  800ed3:	e8 e2 f3 ff ff       	call   8002ba <_panic>

00800ed8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	57                   	push   %edi
  800edc:	56                   	push   %esi
  800edd:	53                   	push   %ebx
  800ede:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eec:	b8 06 00 00 00       	mov    $0x6,%eax
  800ef1:	89 df                	mov    %ebx,%edi
  800ef3:	89 de                	mov    %ebx,%esi
  800ef5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	7f 08                	jg     800f03 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f03:	83 ec 0c             	sub    $0xc,%esp
  800f06:	50                   	push   %eax
  800f07:	6a 06                	push   $0x6
  800f09:	68 cf 28 80 00       	push   $0x8028cf
  800f0e:	6a 23                	push   $0x23
  800f10:	68 ec 28 80 00       	push   $0x8028ec
  800f15:	e8 a0 f3 ff ff       	call   8002ba <_panic>

00800f1a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
  800f20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2e:	b8 08 00 00 00       	mov    $0x8,%eax
  800f33:	89 df                	mov    %ebx,%edi
  800f35:	89 de                	mov    %ebx,%esi
  800f37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	7f 08                	jg     800f45 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f40:	5b                   	pop    %ebx
  800f41:	5e                   	pop    %esi
  800f42:	5f                   	pop    %edi
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f45:	83 ec 0c             	sub    $0xc,%esp
  800f48:	50                   	push   %eax
  800f49:	6a 08                	push   $0x8
  800f4b:	68 cf 28 80 00       	push   $0x8028cf
  800f50:	6a 23                	push   $0x23
  800f52:	68 ec 28 80 00       	push   $0x8028ec
  800f57:	e8 5e f3 ff ff       	call   8002ba <_panic>

00800f5c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
  800f62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f70:	b8 09 00 00 00       	mov    $0x9,%eax
  800f75:	89 df                	mov    %ebx,%edi
  800f77:	89 de                	mov    %ebx,%esi
  800f79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	7f 08                	jg     800f87 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f87:	83 ec 0c             	sub    $0xc,%esp
  800f8a:	50                   	push   %eax
  800f8b:	6a 09                	push   $0x9
  800f8d:	68 cf 28 80 00       	push   $0x8028cf
  800f92:	6a 23                	push   $0x23
  800f94:	68 ec 28 80 00       	push   $0x8028ec
  800f99:	e8 1c f3 ff ff       	call   8002ba <_panic>

00800f9e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	57                   	push   %edi
  800fa2:	56                   	push   %esi
  800fa3:	53                   	push   %ebx
  800fa4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fac:	8b 55 08             	mov    0x8(%ebp),%edx
  800faf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fb7:	89 df                	mov    %ebx,%edi
  800fb9:	89 de                	mov    %ebx,%esi
  800fbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	7f 08                	jg     800fc9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc9:	83 ec 0c             	sub    $0xc,%esp
  800fcc:	50                   	push   %eax
  800fcd:	6a 0a                	push   $0xa
  800fcf:	68 cf 28 80 00       	push   $0x8028cf
  800fd4:	6a 23                	push   $0x23
  800fd6:	68 ec 28 80 00       	push   $0x8028ec
  800fdb:	e8 da f2 ff ff       	call   8002ba <_panic>

00800fe0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	57                   	push   %edi
  800fe4:	56                   	push   %esi
  800fe5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fec:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ff1:	be 00 00 00 00       	mov    $0x0,%esi
  800ff6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ffc:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	57                   	push   %edi
  801007:	56                   	push   %esi
  801008:	53                   	push   %ebx
  801009:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80100c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	b8 0d 00 00 00       	mov    $0xd,%eax
  801019:	89 cb                	mov    %ecx,%ebx
  80101b:	89 cf                	mov    %ecx,%edi
  80101d:	89 ce                	mov    %ecx,%esi
  80101f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801021:	85 c0                	test   %eax,%eax
  801023:	7f 08                	jg     80102d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801025:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801028:	5b                   	pop    %ebx
  801029:	5e                   	pop    %esi
  80102a:	5f                   	pop    %edi
  80102b:	5d                   	pop    %ebp
  80102c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80102d:	83 ec 0c             	sub    $0xc,%esp
  801030:	50                   	push   %eax
  801031:	6a 0d                	push   $0xd
  801033:	68 cf 28 80 00       	push   $0x8028cf
  801038:	6a 23                	push   $0x23
  80103a:	68 ec 28 80 00       	push   $0x8028ec
  80103f:	e8 76 f2 ff ff       	call   8002ba <_panic>

00801044 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	57                   	push   %edi
  801048:	56                   	push   %esi
  801049:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104a:	ba 00 00 00 00       	mov    $0x0,%edx
  80104f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801054:	89 d1                	mov    %edx,%ecx
  801056:	89 d3                	mov    %edx,%ebx
  801058:	89 d7                	mov    %edx,%edi
  80105a:	89 d6                	mov    %edx,%esi
  80105c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80105e:	5b                   	pop    %ebx
  80105f:	5e                   	pop    %esi
  801060:	5f                   	pop    %edi
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    

00801063 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	05 00 00 00 30       	add    $0x30000000,%eax
  80106e:	c1 e8 0c             	shr    $0xc,%eax
}
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80107e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801083:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    

0080108a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801092:	89 c2                	mov    %eax,%edx
  801094:	c1 ea 16             	shr    $0x16,%edx
  801097:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80109e:	f6 c2 01             	test   $0x1,%dl
  8010a1:	74 2d                	je     8010d0 <fd_alloc+0x46>
  8010a3:	89 c2                	mov    %eax,%edx
  8010a5:	c1 ea 0c             	shr    $0xc,%edx
  8010a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010af:	f6 c2 01             	test   $0x1,%dl
  8010b2:	74 1c                	je     8010d0 <fd_alloc+0x46>
  8010b4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010b9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010be:	75 d2                	jne    801092 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010c9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010ce:	eb 0a                	jmp    8010da <fd_alloc+0x50>
			*fd_store = fd;
  8010d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    

008010dc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010e2:	83 f8 1f             	cmp    $0x1f,%eax
  8010e5:	77 30                	ja     801117 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010e7:	c1 e0 0c             	shl    $0xc,%eax
  8010ea:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010ef:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010f5:	f6 c2 01             	test   $0x1,%dl
  8010f8:	74 24                	je     80111e <fd_lookup+0x42>
  8010fa:	89 c2                	mov    %eax,%edx
  8010fc:	c1 ea 0c             	shr    $0xc,%edx
  8010ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801106:	f6 c2 01             	test   $0x1,%dl
  801109:	74 1a                	je     801125 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80110b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110e:	89 02                	mov    %eax,(%edx)
	return 0;
  801110:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    
		return -E_INVAL;
  801117:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111c:	eb f7                	jmp    801115 <fd_lookup+0x39>
		return -E_INVAL;
  80111e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801123:	eb f0                	jmp    801115 <fd_lookup+0x39>
  801125:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112a:	eb e9                	jmp    801115 <fd_lookup+0x39>

0080112c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	83 ec 08             	sub    $0x8,%esp
  801132:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801135:	ba 00 00 00 00       	mov    $0x0,%edx
  80113a:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  80113f:	39 08                	cmp    %ecx,(%eax)
  801141:	74 38                	je     80117b <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801143:	83 c2 01             	add    $0x1,%edx
  801146:	8b 04 95 78 29 80 00 	mov    0x802978(,%edx,4),%eax
  80114d:	85 c0                	test   %eax,%eax
  80114f:	75 ee                	jne    80113f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801151:	a1 08 44 80 00       	mov    0x804408,%eax
  801156:	8b 40 48             	mov    0x48(%eax),%eax
  801159:	83 ec 04             	sub    $0x4,%esp
  80115c:	51                   	push   %ecx
  80115d:	50                   	push   %eax
  80115e:	68 fc 28 80 00       	push   $0x8028fc
  801163:	e8 2d f2 ff ff       	call   800395 <cprintf>
	*dev = 0;
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801171:	83 c4 10             	add    $0x10,%esp
  801174:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801179:	c9                   	leave  
  80117a:	c3                   	ret    
			*dev = devtab[i];
  80117b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
  801185:	eb f2                	jmp    801179 <dev_lookup+0x4d>

00801187 <fd_close>:
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	57                   	push   %edi
  80118b:	56                   	push   %esi
  80118c:	53                   	push   %ebx
  80118d:	83 ec 24             	sub    $0x24,%esp
  801190:	8b 75 08             	mov    0x8(%ebp),%esi
  801193:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801196:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801199:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80119a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011a0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011a3:	50                   	push   %eax
  8011a4:	e8 33 ff ff ff       	call   8010dc <fd_lookup>
  8011a9:	89 c3                	mov    %eax,%ebx
  8011ab:	83 c4 10             	add    $0x10,%esp
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	78 05                	js     8011b7 <fd_close+0x30>
	    || fd != fd2)
  8011b2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011b5:	74 16                	je     8011cd <fd_close+0x46>
		return (must_exist ? r : 0);
  8011b7:	89 f8                	mov    %edi,%eax
  8011b9:	84 c0                	test   %al,%al
  8011bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c0:	0f 44 d8             	cmove  %eax,%ebx
}
  8011c3:	89 d8                	mov    %ebx,%eax
  8011c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c8:	5b                   	pop    %ebx
  8011c9:	5e                   	pop    %esi
  8011ca:	5f                   	pop    %edi
  8011cb:	5d                   	pop    %ebp
  8011cc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011cd:	83 ec 08             	sub    $0x8,%esp
  8011d0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011d3:	50                   	push   %eax
  8011d4:	ff 36                	pushl  (%esi)
  8011d6:	e8 51 ff ff ff       	call   80112c <dev_lookup>
  8011db:	89 c3                	mov    %eax,%ebx
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	78 1a                	js     8011fe <fd_close+0x77>
		if (dev->dev_close)
  8011e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011e7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011ea:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	74 0b                	je     8011fe <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011f3:	83 ec 0c             	sub    $0xc,%esp
  8011f6:	56                   	push   %esi
  8011f7:	ff d0                	call   *%eax
  8011f9:	89 c3                	mov    %eax,%ebx
  8011fb:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011fe:	83 ec 08             	sub    $0x8,%esp
  801201:	56                   	push   %esi
  801202:	6a 00                	push   $0x0
  801204:	e8 cf fc ff ff       	call   800ed8 <sys_page_unmap>
	return r;
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	eb b5                	jmp    8011c3 <fd_close+0x3c>

0080120e <close>:

int
close(int fdnum)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801214:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801217:	50                   	push   %eax
  801218:	ff 75 08             	pushl  0x8(%ebp)
  80121b:	e8 bc fe ff ff       	call   8010dc <fd_lookup>
  801220:	83 c4 10             	add    $0x10,%esp
  801223:	85 c0                	test   %eax,%eax
  801225:	79 02                	jns    801229 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    
		return fd_close(fd, 1);
  801229:	83 ec 08             	sub    $0x8,%esp
  80122c:	6a 01                	push   $0x1
  80122e:	ff 75 f4             	pushl  -0xc(%ebp)
  801231:	e8 51 ff ff ff       	call   801187 <fd_close>
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	eb ec                	jmp    801227 <close+0x19>

0080123b <close_all>:

void
close_all(void)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	53                   	push   %ebx
  80123f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801242:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801247:	83 ec 0c             	sub    $0xc,%esp
  80124a:	53                   	push   %ebx
  80124b:	e8 be ff ff ff       	call   80120e <close>
	for (i = 0; i < MAXFD; i++)
  801250:	83 c3 01             	add    $0x1,%ebx
  801253:	83 c4 10             	add    $0x10,%esp
  801256:	83 fb 20             	cmp    $0x20,%ebx
  801259:	75 ec                	jne    801247 <close_all+0xc>
}
  80125b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80125e:	c9                   	leave  
  80125f:	c3                   	ret    

00801260 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
  801263:	57                   	push   %edi
  801264:	56                   	push   %esi
  801265:	53                   	push   %ebx
  801266:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801269:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80126c:	50                   	push   %eax
  80126d:	ff 75 08             	pushl  0x8(%ebp)
  801270:	e8 67 fe ff ff       	call   8010dc <fd_lookup>
  801275:	89 c3                	mov    %eax,%ebx
  801277:	83 c4 10             	add    $0x10,%esp
  80127a:	85 c0                	test   %eax,%eax
  80127c:	0f 88 81 00 00 00    	js     801303 <dup+0xa3>
		return r;
	close(newfdnum);
  801282:	83 ec 0c             	sub    $0xc,%esp
  801285:	ff 75 0c             	pushl  0xc(%ebp)
  801288:	e8 81 ff ff ff       	call   80120e <close>

	newfd = INDEX2FD(newfdnum);
  80128d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801290:	c1 e6 0c             	shl    $0xc,%esi
  801293:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801299:	83 c4 04             	add    $0x4,%esp
  80129c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80129f:	e8 cf fd ff ff       	call   801073 <fd2data>
  8012a4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012a6:	89 34 24             	mov    %esi,(%esp)
  8012a9:	e8 c5 fd ff ff       	call   801073 <fd2data>
  8012ae:	83 c4 10             	add    $0x10,%esp
  8012b1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012b3:	89 d8                	mov    %ebx,%eax
  8012b5:	c1 e8 16             	shr    $0x16,%eax
  8012b8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012bf:	a8 01                	test   $0x1,%al
  8012c1:	74 11                	je     8012d4 <dup+0x74>
  8012c3:	89 d8                	mov    %ebx,%eax
  8012c5:	c1 e8 0c             	shr    $0xc,%eax
  8012c8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012cf:	f6 c2 01             	test   $0x1,%dl
  8012d2:	75 39                	jne    80130d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012d7:	89 d0                	mov    %edx,%eax
  8012d9:	c1 e8 0c             	shr    $0xc,%eax
  8012dc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012e3:	83 ec 0c             	sub    $0xc,%esp
  8012e6:	25 07 0e 00 00       	and    $0xe07,%eax
  8012eb:	50                   	push   %eax
  8012ec:	56                   	push   %esi
  8012ed:	6a 00                	push   $0x0
  8012ef:	52                   	push   %edx
  8012f0:	6a 00                	push   $0x0
  8012f2:	e8 9f fb ff ff       	call   800e96 <sys_page_map>
  8012f7:	89 c3                	mov    %eax,%ebx
  8012f9:	83 c4 20             	add    $0x20,%esp
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	78 31                	js     801331 <dup+0xd1>
		goto err;

	return newfdnum;
  801300:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801303:	89 d8                	mov    %ebx,%eax
  801305:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801308:	5b                   	pop    %ebx
  801309:	5e                   	pop    %esi
  80130a:	5f                   	pop    %edi
  80130b:	5d                   	pop    %ebp
  80130c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80130d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801314:	83 ec 0c             	sub    $0xc,%esp
  801317:	25 07 0e 00 00       	and    $0xe07,%eax
  80131c:	50                   	push   %eax
  80131d:	57                   	push   %edi
  80131e:	6a 00                	push   $0x0
  801320:	53                   	push   %ebx
  801321:	6a 00                	push   $0x0
  801323:	e8 6e fb ff ff       	call   800e96 <sys_page_map>
  801328:	89 c3                	mov    %eax,%ebx
  80132a:	83 c4 20             	add    $0x20,%esp
  80132d:	85 c0                	test   %eax,%eax
  80132f:	79 a3                	jns    8012d4 <dup+0x74>
	sys_page_unmap(0, newfd);
  801331:	83 ec 08             	sub    $0x8,%esp
  801334:	56                   	push   %esi
  801335:	6a 00                	push   $0x0
  801337:	e8 9c fb ff ff       	call   800ed8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80133c:	83 c4 08             	add    $0x8,%esp
  80133f:	57                   	push   %edi
  801340:	6a 00                	push   $0x0
  801342:	e8 91 fb ff ff       	call   800ed8 <sys_page_unmap>
	return r;
  801347:	83 c4 10             	add    $0x10,%esp
  80134a:	eb b7                	jmp    801303 <dup+0xa3>

0080134c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	53                   	push   %ebx
  801350:	83 ec 1c             	sub    $0x1c,%esp
  801353:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801356:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801359:	50                   	push   %eax
  80135a:	53                   	push   %ebx
  80135b:	e8 7c fd ff ff       	call   8010dc <fd_lookup>
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	85 c0                	test   %eax,%eax
  801365:	78 3f                	js     8013a6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136d:	50                   	push   %eax
  80136e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801371:	ff 30                	pushl  (%eax)
  801373:	e8 b4 fd ff ff       	call   80112c <dev_lookup>
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	85 c0                	test   %eax,%eax
  80137d:	78 27                	js     8013a6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80137f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801382:	8b 42 08             	mov    0x8(%edx),%eax
  801385:	83 e0 03             	and    $0x3,%eax
  801388:	83 f8 01             	cmp    $0x1,%eax
  80138b:	74 1e                	je     8013ab <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80138d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801390:	8b 40 08             	mov    0x8(%eax),%eax
  801393:	85 c0                	test   %eax,%eax
  801395:	74 35                	je     8013cc <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801397:	83 ec 04             	sub    $0x4,%esp
  80139a:	ff 75 10             	pushl  0x10(%ebp)
  80139d:	ff 75 0c             	pushl  0xc(%ebp)
  8013a0:	52                   	push   %edx
  8013a1:	ff d0                	call   *%eax
  8013a3:	83 c4 10             	add    $0x10,%esp
}
  8013a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ab:	a1 08 44 80 00       	mov    0x804408,%eax
  8013b0:	8b 40 48             	mov    0x48(%eax),%eax
  8013b3:	83 ec 04             	sub    $0x4,%esp
  8013b6:	53                   	push   %ebx
  8013b7:	50                   	push   %eax
  8013b8:	68 3d 29 80 00       	push   $0x80293d
  8013bd:	e8 d3 ef ff ff       	call   800395 <cprintf>
		return -E_INVAL;
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ca:	eb da                	jmp    8013a6 <read+0x5a>
		return -E_NOT_SUPP;
  8013cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013d1:	eb d3                	jmp    8013a6 <read+0x5a>

008013d3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	57                   	push   %edi
  8013d7:	56                   	push   %esi
  8013d8:	53                   	push   %ebx
  8013d9:	83 ec 0c             	sub    $0xc,%esp
  8013dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013df:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e7:	39 f3                	cmp    %esi,%ebx
  8013e9:	73 23                	jae    80140e <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013eb:	83 ec 04             	sub    $0x4,%esp
  8013ee:	89 f0                	mov    %esi,%eax
  8013f0:	29 d8                	sub    %ebx,%eax
  8013f2:	50                   	push   %eax
  8013f3:	89 d8                	mov    %ebx,%eax
  8013f5:	03 45 0c             	add    0xc(%ebp),%eax
  8013f8:	50                   	push   %eax
  8013f9:	57                   	push   %edi
  8013fa:	e8 4d ff ff ff       	call   80134c <read>
		if (m < 0)
  8013ff:	83 c4 10             	add    $0x10,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	78 06                	js     80140c <readn+0x39>
			return m;
		if (m == 0)
  801406:	74 06                	je     80140e <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801408:	01 c3                	add    %eax,%ebx
  80140a:	eb db                	jmp    8013e7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80140c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80140e:	89 d8                	mov    %ebx,%eax
  801410:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801413:	5b                   	pop    %ebx
  801414:	5e                   	pop    %esi
  801415:	5f                   	pop    %edi
  801416:	5d                   	pop    %ebp
  801417:	c3                   	ret    

00801418 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	53                   	push   %ebx
  80141c:	83 ec 1c             	sub    $0x1c,%esp
  80141f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801422:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801425:	50                   	push   %eax
  801426:	53                   	push   %ebx
  801427:	e8 b0 fc ff ff       	call   8010dc <fd_lookup>
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	85 c0                	test   %eax,%eax
  801431:	78 3a                	js     80146d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801433:	83 ec 08             	sub    $0x8,%esp
  801436:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801439:	50                   	push   %eax
  80143a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143d:	ff 30                	pushl  (%eax)
  80143f:	e8 e8 fc ff ff       	call   80112c <dev_lookup>
  801444:	83 c4 10             	add    $0x10,%esp
  801447:	85 c0                	test   %eax,%eax
  801449:	78 22                	js     80146d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80144b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801452:	74 1e                	je     801472 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801454:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801457:	8b 52 0c             	mov    0xc(%edx),%edx
  80145a:	85 d2                	test   %edx,%edx
  80145c:	74 35                	je     801493 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80145e:	83 ec 04             	sub    $0x4,%esp
  801461:	ff 75 10             	pushl  0x10(%ebp)
  801464:	ff 75 0c             	pushl  0xc(%ebp)
  801467:	50                   	push   %eax
  801468:	ff d2                	call   *%edx
  80146a:	83 c4 10             	add    $0x10,%esp
}
  80146d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801470:	c9                   	leave  
  801471:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801472:	a1 08 44 80 00       	mov    0x804408,%eax
  801477:	8b 40 48             	mov    0x48(%eax),%eax
  80147a:	83 ec 04             	sub    $0x4,%esp
  80147d:	53                   	push   %ebx
  80147e:	50                   	push   %eax
  80147f:	68 59 29 80 00       	push   $0x802959
  801484:	e8 0c ef ff ff       	call   800395 <cprintf>
		return -E_INVAL;
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801491:	eb da                	jmp    80146d <write+0x55>
		return -E_NOT_SUPP;
  801493:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801498:	eb d3                	jmp    80146d <write+0x55>

0080149a <seek>:

int
seek(int fdnum, off_t offset)
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a3:	50                   	push   %eax
  8014a4:	ff 75 08             	pushl  0x8(%ebp)
  8014a7:	e8 30 fc ff ff       	call   8010dc <fd_lookup>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	78 0e                	js     8014c1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	53                   	push   %ebx
  8014c7:	83 ec 1c             	sub    $0x1c,%esp
  8014ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d0:	50                   	push   %eax
  8014d1:	53                   	push   %ebx
  8014d2:	e8 05 fc ff ff       	call   8010dc <fd_lookup>
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	78 37                	js     801515 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014de:	83 ec 08             	sub    $0x8,%esp
  8014e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e4:	50                   	push   %eax
  8014e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e8:	ff 30                	pushl  (%eax)
  8014ea:	e8 3d fc ff ff       	call   80112c <dev_lookup>
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	78 1f                	js     801515 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014fd:	74 1b                	je     80151a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801502:	8b 52 18             	mov    0x18(%edx),%edx
  801505:	85 d2                	test   %edx,%edx
  801507:	74 32                	je     80153b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801509:	83 ec 08             	sub    $0x8,%esp
  80150c:	ff 75 0c             	pushl  0xc(%ebp)
  80150f:	50                   	push   %eax
  801510:	ff d2                	call   *%edx
  801512:	83 c4 10             	add    $0x10,%esp
}
  801515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801518:	c9                   	leave  
  801519:	c3                   	ret    
			thisenv->env_id, fdnum);
  80151a:	a1 08 44 80 00       	mov    0x804408,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80151f:	8b 40 48             	mov    0x48(%eax),%eax
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	53                   	push   %ebx
  801526:	50                   	push   %eax
  801527:	68 1c 29 80 00       	push   $0x80291c
  80152c:	e8 64 ee ff ff       	call   800395 <cprintf>
		return -E_INVAL;
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801539:	eb da                	jmp    801515 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80153b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801540:	eb d3                	jmp    801515 <ftruncate+0x52>

00801542 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	53                   	push   %ebx
  801546:	83 ec 1c             	sub    $0x1c,%esp
  801549:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80154f:	50                   	push   %eax
  801550:	ff 75 08             	pushl  0x8(%ebp)
  801553:	e8 84 fb ff ff       	call   8010dc <fd_lookup>
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	85 c0                	test   %eax,%eax
  80155d:	78 4b                	js     8015aa <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80155f:	83 ec 08             	sub    $0x8,%esp
  801562:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801565:	50                   	push   %eax
  801566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801569:	ff 30                	pushl  (%eax)
  80156b:	e8 bc fb ff ff       	call   80112c <dev_lookup>
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	85 c0                	test   %eax,%eax
  801575:	78 33                	js     8015aa <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80157e:	74 2f                	je     8015af <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801580:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801583:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80158a:	00 00 00 
	stat->st_isdir = 0;
  80158d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801594:	00 00 00 
	stat->st_dev = dev;
  801597:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80159d:	83 ec 08             	sub    $0x8,%esp
  8015a0:	53                   	push   %ebx
  8015a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8015a4:	ff 50 14             	call   *0x14(%eax)
  8015a7:	83 c4 10             	add    $0x10,%esp
}
  8015aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    
		return -E_NOT_SUPP;
  8015af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b4:	eb f4                	jmp    8015aa <fstat+0x68>

008015b6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	56                   	push   %esi
  8015ba:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015bb:	83 ec 08             	sub    $0x8,%esp
  8015be:	6a 00                	push   $0x0
  8015c0:	ff 75 08             	pushl  0x8(%ebp)
  8015c3:	e8 2f 02 00 00       	call   8017f7 <open>
  8015c8:	89 c3                	mov    %eax,%ebx
  8015ca:	83 c4 10             	add    $0x10,%esp
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	78 1b                	js     8015ec <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015d1:	83 ec 08             	sub    $0x8,%esp
  8015d4:	ff 75 0c             	pushl  0xc(%ebp)
  8015d7:	50                   	push   %eax
  8015d8:	e8 65 ff ff ff       	call   801542 <fstat>
  8015dd:	89 c6                	mov    %eax,%esi
	close(fd);
  8015df:	89 1c 24             	mov    %ebx,(%esp)
  8015e2:	e8 27 fc ff ff       	call   80120e <close>
	return r;
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	89 f3                	mov    %esi,%ebx
}
  8015ec:	89 d8                	mov    %ebx,%eax
  8015ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f1:	5b                   	pop    %ebx
  8015f2:	5e                   	pop    %esi
  8015f3:	5d                   	pop    %ebp
  8015f4:	c3                   	ret    

008015f5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	56                   	push   %esi
  8015f9:	53                   	push   %ebx
  8015fa:	89 c6                	mov    %eax,%esi
  8015fc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015fe:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801605:	74 27                	je     80162e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801607:	6a 07                	push   $0x7
  801609:	68 00 50 80 00       	push   $0x805000
  80160e:	56                   	push   %esi
  80160f:	ff 35 00 44 80 00    	pushl  0x804400
  801615:	e8 be 0b 00 00       	call   8021d8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80161a:	83 c4 0c             	add    $0xc,%esp
  80161d:	6a 00                	push   $0x0
  80161f:	53                   	push   %ebx
  801620:	6a 00                	push   $0x0
  801622:	e8 3e 0b 00 00       	call   802165 <ipc_recv>
}
  801627:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80162a:	5b                   	pop    %ebx
  80162b:	5e                   	pop    %esi
  80162c:	5d                   	pop    %ebp
  80162d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	6a 01                	push   $0x1
  801633:	e8 0c 0c 00 00       	call   802244 <ipc_find_env>
  801638:	a3 00 44 80 00       	mov    %eax,0x804400
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	eb c5                	jmp    801607 <fsipc+0x12>

00801642 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8b 40 0c             	mov    0xc(%eax),%eax
  80164e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801653:	8b 45 0c             	mov    0xc(%ebp),%eax
  801656:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80165b:	ba 00 00 00 00       	mov    $0x0,%edx
  801660:	b8 02 00 00 00       	mov    $0x2,%eax
  801665:	e8 8b ff ff ff       	call   8015f5 <fsipc>
}
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <devfile_flush>:
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	8b 40 0c             	mov    0xc(%eax),%eax
  801678:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80167d:	ba 00 00 00 00       	mov    $0x0,%edx
  801682:	b8 06 00 00 00       	mov    $0x6,%eax
  801687:	e8 69 ff ff ff       	call   8015f5 <fsipc>
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <devfile_stat>:
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	53                   	push   %ebx
  801692:	83 ec 04             	sub    $0x4,%esp
  801695:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8b 40 0c             	mov    0xc(%eax),%eax
  80169e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a8:	b8 05 00 00 00       	mov    $0x5,%eax
  8016ad:	e8 43 ff ff ff       	call   8015f5 <fsipc>
  8016b2:	85 c0                	test   %eax,%eax
  8016b4:	78 2c                	js     8016e2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016b6:	83 ec 08             	sub    $0x8,%esp
  8016b9:	68 00 50 80 00       	push   $0x805000
  8016be:	53                   	push   %ebx
  8016bf:	e8 9d f3 ff ff       	call   800a61 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016c4:	a1 80 50 80 00       	mov    0x805080,%eax
  8016c9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016cf:	a1 84 50 80 00       	mov    0x805084,%eax
  8016d4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <devfile_write>:
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	53                   	push   %ebx
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8016f1:	85 db                	test   %ebx,%ebx
  8016f3:	75 07                	jne    8016fc <devfile_write+0x15>
	return n_all;
  8016f5:	89 d8                	mov    %ebx,%eax
}
  8016f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	8b 40 0c             	mov    0xc(%eax),%eax
  801702:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801707:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  80170d:	83 ec 04             	sub    $0x4,%esp
  801710:	53                   	push   %ebx
  801711:	ff 75 0c             	pushl  0xc(%ebp)
  801714:	68 08 50 80 00       	push   $0x805008
  801719:	e8 d1 f4 ff ff       	call   800bef <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80171e:	ba 00 00 00 00       	mov    $0x0,%edx
  801723:	b8 04 00 00 00       	mov    $0x4,%eax
  801728:	e8 c8 fe ff ff       	call   8015f5 <fsipc>
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	85 c0                	test   %eax,%eax
  801732:	78 c3                	js     8016f7 <devfile_write+0x10>
	  assert(r <= n_left);
  801734:	39 d8                	cmp    %ebx,%eax
  801736:	77 0b                	ja     801743 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801738:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80173d:	7f 1d                	jg     80175c <devfile_write+0x75>
    n_all += r;
  80173f:	89 c3                	mov    %eax,%ebx
  801741:	eb b2                	jmp    8016f5 <devfile_write+0xe>
	  assert(r <= n_left);
  801743:	68 8c 29 80 00       	push   $0x80298c
  801748:	68 98 29 80 00       	push   $0x802998
  80174d:	68 9f 00 00 00       	push   $0x9f
  801752:	68 ad 29 80 00       	push   $0x8029ad
  801757:	e8 5e eb ff ff       	call   8002ba <_panic>
	  assert(r <= PGSIZE);
  80175c:	68 b8 29 80 00       	push   $0x8029b8
  801761:	68 98 29 80 00       	push   $0x802998
  801766:	68 a0 00 00 00       	push   $0xa0
  80176b:	68 ad 29 80 00       	push   $0x8029ad
  801770:	e8 45 eb ff ff       	call   8002ba <_panic>

00801775 <devfile_read>:
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	56                   	push   %esi
  801779:	53                   	push   %ebx
  80177a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	8b 40 0c             	mov    0xc(%eax),%eax
  801783:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801788:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80178e:	ba 00 00 00 00       	mov    $0x0,%edx
  801793:	b8 03 00 00 00       	mov    $0x3,%eax
  801798:	e8 58 fe ff ff       	call   8015f5 <fsipc>
  80179d:	89 c3                	mov    %eax,%ebx
  80179f:	85 c0                	test   %eax,%eax
  8017a1:	78 1f                	js     8017c2 <devfile_read+0x4d>
	assert(r <= n);
  8017a3:	39 f0                	cmp    %esi,%eax
  8017a5:	77 24                	ja     8017cb <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017a7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017ac:	7f 33                	jg     8017e1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	50                   	push   %eax
  8017b2:	68 00 50 80 00       	push   $0x805000
  8017b7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ba:	e8 30 f4 ff ff       	call   800bef <memmove>
	return r;
  8017bf:	83 c4 10             	add    $0x10,%esp
}
  8017c2:	89 d8                	mov    %ebx,%eax
  8017c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c7:	5b                   	pop    %ebx
  8017c8:	5e                   	pop    %esi
  8017c9:	5d                   	pop    %ebp
  8017ca:	c3                   	ret    
	assert(r <= n);
  8017cb:	68 c4 29 80 00       	push   $0x8029c4
  8017d0:	68 98 29 80 00       	push   $0x802998
  8017d5:	6a 7c                	push   $0x7c
  8017d7:	68 ad 29 80 00       	push   $0x8029ad
  8017dc:	e8 d9 ea ff ff       	call   8002ba <_panic>
	assert(r <= PGSIZE);
  8017e1:	68 b8 29 80 00       	push   $0x8029b8
  8017e6:	68 98 29 80 00       	push   $0x802998
  8017eb:	6a 7d                	push   $0x7d
  8017ed:	68 ad 29 80 00       	push   $0x8029ad
  8017f2:	e8 c3 ea ff ff       	call   8002ba <_panic>

008017f7 <open>:
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	56                   	push   %esi
  8017fb:	53                   	push   %ebx
  8017fc:	83 ec 1c             	sub    $0x1c,%esp
  8017ff:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801802:	56                   	push   %esi
  801803:	e8 20 f2 ff ff       	call   800a28 <strlen>
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801810:	7f 6c                	jg     80187e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801812:	83 ec 0c             	sub    $0xc,%esp
  801815:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801818:	50                   	push   %eax
  801819:	e8 6c f8 ff ff       	call   80108a <fd_alloc>
  80181e:	89 c3                	mov    %eax,%ebx
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	85 c0                	test   %eax,%eax
  801825:	78 3c                	js     801863 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801827:	83 ec 08             	sub    $0x8,%esp
  80182a:	56                   	push   %esi
  80182b:	68 00 50 80 00       	push   $0x805000
  801830:	e8 2c f2 ff ff       	call   800a61 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801835:	8b 45 0c             	mov    0xc(%ebp),%eax
  801838:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80183d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801840:	b8 01 00 00 00       	mov    $0x1,%eax
  801845:	e8 ab fd ff ff       	call   8015f5 <fsipc>
  80184a:	89 c3                	mov    %eax,%ebx
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	85 c0                	test   %eax,%eax
  801851:	78 19                	js     80186c <open+0x75>
	return fd2num(fd);
  801853:	83 ec 0c             	sub    $0xc,%esp
  801856:	ff 75 f4             	pushl  -0xc(%ebp)
  801859:	e8 05 f8 ff ff       	call   801063 <fd2num>
  80185e:	89 c3                	mov    %eax,%ebx
  801860:	83 c4 10             	add    $0x10,%esp
}
  801863:	89 d8                	mov    %ebx,%eax
  801865:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801868:	5b                   	pop    %ebx
  801869:	5e                   	pop    %esi
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    
		fd_close(fd, 0);
  80186c:	83 ec 08             	sub    $0x8,%esp
  80186f:	6a 00                	push   $0x0
  801871:	ff 75 f4             	pushl  -0xc(%ebp)
  801874:	e8 0e f9 ff ff       	call   801187 <fd_close>
		return r;
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	eb e5                	jmp    801863 <open+0x6c>
		return -E_BAD_PATH;
  80187e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801883:	eb de                	jmp    801863 <open+0x6c>

00801885 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80188b:	ba 00 00 00 00       	mov    $0x0,%edx
  801890:	b8 08 00 00 00       	mov    $0x8,%eax
  801895:	e8 5b fd ff ff       	call   8015f5 <fsipc>
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80189c:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8018a0:	7f 01                	jg     8018a3 <writebuf+0x7>
  8018a2:	c3                   	ret    
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	53                   	push   %ebx
  8018a7:	83 ec 08             	sub    $0x8,%esp
  8018aa:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8018ac:	ff 70 04             	pushl  0x4(%eax)
  8018af:	8d 40 10             	lea    0x10(%eax),%eax
  8018b2:	50                   	push   %eax
  8018b3:	ff 33                	pushl  (%ebx)
  8018b5:	e8 5e fb ff ff       	call   801418 <write>
		if (result > 0)
  8018ba:	83 c4 10             	add    $0x10,%esp
  8018bd:	85 c0                	test   %eax,%eax
  8018bf:	7e 03                	jle    8018c4 <writebuf+0x28>
			b->result += result;
  8018c1:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8018c4:	39 43 04             	cmp    %eax,0x4(%ebx)
  8018c7:	74 0d                	je     8018d6 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d0:	0f 4f c2             	cmovg  %edx,%eax
  8018d3:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8018d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <putch>:

static void
putch(int ch, void *thunk)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	53                   	push   %ebx
  8018df:	83 ec 04             	sub    $0x4,%esp
  8018e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8018e5:	8b 53 04             	mov    0x4(%ebx),%edx
  8018e8:	8d 42 01             	lea    0x1(%edx),%eax
  8018eb:	89 43 04             	mov    %eax,0x4(%ebx)
  8018ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f1:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8018f5:	3d 00 01 00 00       	cmp    $0x100,%eax
  8018fa:	74 06                	je     801902 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8018fc:	83 c4 04             	add    $0x4,%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    
		writebuf(b);
  801902:	89 d8                	mov    %ebx,%eax
  801904:	e8 93 ff ff ff       	call   80189c <writebuf>
		b->idx = 0;
  801909:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801910:	eb ea                	jmp    8018fc <putch+0x21>

00801912 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801924:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80192b:	00 00 00 
	b.result = 0;
  80192e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801935:	00 00 00 
	b.error = 1;
  801938:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  80193f:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801942:	ff 75 10             	pushl  0x10(%ebp)
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80194e:	50                   	push   %eax
  80194f:	68 db 18 80 00       	push   $0x8018db
  801954:	e8 38 eb ff ff       	call   800491 <vprintfmt>
	if (b.idx > 0)
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801963:	7f 11                	jg     801976 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801965:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80196b:	85 c0                	test   %eax,%eax
  80196d:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    
		writebuf(&b);
  801976:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80197c:	e8 1b ff ff ff       	call   80189c <writebuf>
  801981:	eb e2                	jmp    801965 <vfprintf+0x53>

00801983 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801989:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80198c:	50                   	push   %eax
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	ff 75 08             	pushl  0x8(%ebp)
  801993:	e8 7a ff ff ff       	call   801912 <vfprintf>
	va_end(ap);

	return cnt;
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <printf>:

int
printf(const char *fmt, ...)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019a0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8019a3:	50                   	push   %eax
  8019a4:	ff 75 08             	pushl  0x8(%ebp)
  8019a7:	6a 01                	push   $0x1
  8019a9:	e8 64 ff ff ff       	call   801912 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	56                   	push   %esi
  8019b4:	53                   	push   %ebx
  8019b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019b8:	83 ec 0c             	sub    $0xc,%esp
  8019bb:	ff 75 08             	pushl  0x8(%ebp)
  8019be:	e8 b0 f6 ff ff       	call   801073 <fd2data>
  8019c3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019c5:	83 c4 08             	add    $0x8,%esp
  8019c8:	68 cb 29 80 00       	push   $0x8029cb
  8019cd:	53                   	push   %ebx
  8019ce:	e8 8e f0 ff ff       	call   800a61 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019d3:	8b 46 04             	mov    0x4(%esi),%eax
  8019d6:	2b 06                	sub    (%esi),%eax
  8019d8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019de:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019e5:	00 00 00 
	stat->st_dev = &devpipe;
  8019e8:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8019ef:	30 80 00 
	return 0;
}
  8019f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019fa:	5b                   	pop    %ebx
  8019fb:	5e                   	pop    %esi
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    

008019fe <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	53                   	push   %ebx
  801a02:	83 ec 0c             	sub    $0xc,%esp
  801a05:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a08:	53                   	push   %ebx
  801a09:	6a 00                	push   $0x0
  801a0b:	e8 c8 f4 ff ff       	call   800ed8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a10:	89 1c 24             	mov    %ebx,(%esp)
  801a13:	e8 5b f6 ff ff       	call   801073 <fd2data>
  801a18:	83 c4 08             	add    $0x8,%esp
  801a1b:	50                   	push   %eax
  801a1c:	6a 00                	push   $0x0
  801a1e:	e8 b5 f4 ff ff       	call   800ed8 <sys_page_unmap>
}
  801a23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <_pipeisclosed>:
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	57                   	push   %edi
  801a2c:	56                   	push   %esi
  801a2d:	53                   	push   %ebx
  801a2e:	83 ec 1c             	sub    $0x1c,%esp
  801a31:	89 c7                	mov    %eax,%edi
  801a33:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a35:	a1 08 44 80 00       	mov    0x804408,%eax
  801a3a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a3d:	83 ec 0c             	sub    $0xc,%esp
  801a40:	57                   	push   %edi
  801a41:	e8 37 08 00 00       	call   80227d <pageref>
  801a46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a49:	89 34 24             	mov    %esi,(%esp)
  801a4c:	e8 2c 08 00 00       	call   80227d <pageref>
		nn = thisenv->env_runs;
  801a51:	8b 15 08 44 80 00    	mov    0x804408,%edx
  801a57:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	39 cb                	cmp    %ecx,%ebx
  801a5f:	74 1b                	je     801a7c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a61:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a64:	75 cf                	jne    801a35 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a66:	8b 42 58             	mov    0x58(%edx),%eax
  801a69:	6a 01                	push   $0x1
  801a6b:	50                   	push   %eax
  801a6c:	53                   	push   %ebx
  801a6d:	68 d2 29 80 00       	push   $0x8029d2
  801a72:	e8 1e e9 ff ff       	call   800395 <cprintf>
  801a77:	83 c4 10             	add    $0x10,%esp
  801a7a:	eb b9                	jmp    801a35 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a7c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a7f:	0f 94 c0             	sete   %al
  801a82:	0f b6 c0             	movzbl %al,%eax
}
  801a85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a88:	5b                   	pop    %ebx
  801a89:	5e                   	pop    %esi
  801a8a:	5f                   	pop    %edi
  801a8b:	5d                   	pop    %ebp
  801a8c:	c3                   	ret    

00801a8d <devpipe_write>:
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	57                   	push   %edi
  801a91:	56                   	push   %esi
  801a92:	53                   	push   %ebx
  801a93:	83 ec 28             	sub    $0x28,%esp
  801a96:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a99:	56                   	push   %esi
  801a9a:	e8 d4 f5 ff ff       	call   801073 <fd2data>
  801a9f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801aa1:	83 c4 10             	add    $0x10,%esp
  801aa4:	bf 00 00 00 00       	mov    $0x0,%edi
  801aa9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801aac:	74 4f                	je     801afd <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801aae:	8b 43 04             	mov    0x4(%ebx),%eax
  801ab1:	8b 0b                	mov    (%ebx),%ecx
  801ab3:	8d 51 20             	lea    0x20(%ecx),%edx
  801ab6:	39 d0                	cmp    %edx,%eax
  801ab8:	72 14                	jb     801ace <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801aba:	89 da                	mov    %ebx,%edx
  801abc:	89 f0                	mov    %esi,%eax
  801abe:	e8 65 ff ff ff       	call   801a28 <_pipeisclosed>
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	75 3b                	jne    801b02 <devpipe_write+0x75>
			sys_yield();
  801ac7:	e8 68 f3 ff ff       	call   800e34 <sys_yield>
  801acc:	eb e0                	jmp    801aae <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ace:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ad1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ad5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ad8:	89 c2                	mov    %eax,%edx
  801ada:	c1 fa 1f             	sar    $0x1f,%edx
  801add:	89 d1                	mov    %edx,%ecx
  801adf:	c1 e9 1b             	shr    $0x1b,%ecx
  801ae2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ae5:	83 e2 1f             	and    $0x1f,%edx
  801ae8:	29 ca                	sub    %ecx,%edx
  801aea:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801aee:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801af2:	83 c0 01             	add    $0x1,%eax
  801af5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801af8:	83 c7 01             	add    $0x1,%edi
  801afb:	eb ac                	jmp    801aa9 <devpipe_write+0x1c>
	return i;
  801afd:	8b 45 10             	mov    0x10(%ebp),%eax
  801b00:	eb 05                	jmp    801b07 <devpipe_write+0x7a>
				return 0;
  801b02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b0a:	5b                   	pop    %ebx
  801b0b:	5e                   	pop    %esi
  801b0c:	5f                   	pop    %edi
  801b0d:	5d                   	pop    %ebp
  801b0e:	c3                   	ret    

00801b0f <devpipe_read>:
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	57                   	push   %edi
  801b13:	56                   	push   %esi
  801b14:	53                   	push   %ebx
  801b15:	83 ec 18             	sub    $0x18,%esp
  801b18:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b1b:	57                   	push   %edi
  801b1c:	e8 52 f5 ff ff       	call   801073 <fd2data>
  801b21:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b23:	83 c4 10             	add    $0x10,%esp
  801b26:	be 00 00 00 00       	mov    $0x0,%esi
  801b2b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b2e:	75 14                	jne    801b44 <devpipe_read+0x35>
	return i;
  801b30:	8b 45 10             	mov    0x10(%ebp),%eax
  801b33:	eb 02                	jmp    801b37 <devpipe_read+0x28>
				return i;
  801b35:	89 f0                	mov    %esi,%eax
}
  801b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b3a:	5b                   	pop    %ebx
  801b3b:	5e                   	pop    %esi
  801b3c:	5f                   	pop    %edi
  801b3d:	5d                   	pop    %ebp
  801b3e:	c3                   	ret    
			sys_yield();
  801b3f:	e8 f0 f2 ff ff       	call   800e34 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b44:	8b 03                	mov    (%ebx),%eax
  801b46:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b49:	75 18                	jne    801b63 <devpipe_read+0x54>
			if (i > 0)
  801b4b:	85 f6                	test   %esi,%esi
  801b4d:	75 e6                	jne    801b35 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801b4f:	89 da                	mov    %ebx,%edx
  801b51:	89 f8                	mov    %edi,%eax
  801b53:	e8 d0 fe ff ff       	call   801a28 <_pipeisclosed>
  801b58:	85 c0                	test   %eax,%eax
  801b5a:	74 e3                	je     801b3f <devpipe_read+0x30>
				return 0;
  801b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b61:	eb d4                	jmp    801b37 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b63:	99                   	cltd   
  801b64:	c1 ea 1b             	shr    $0x1b,%edx
  801b67:	01 d0                	add    %edx,%eax
  801b69:	83 e0 1f             	and    $0x1f,%eax
  801b6c:	29 d0                	sub    %edx,%eax
  801b6e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b76:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b79:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b7c:	83 c6 01             	add    $0x1,%esi
  801b7f:	eb aa                	jmp    801b2b <devpipe_read+0x1c>

00801b81 <pipe>:
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	56                   	push   %esi
  801b85:	53                   	push   %ebx
  801b86:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b8c:	50                   	push   %eax
  801b8d:	e8 f8 f4 ff ff       	call   80108a <fd_alloc>
  801b92:	89 c3                	mov    %eax,%ebx
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	85 c0                	test   %eax,%eax
  801b99:	0f 88 23 01 00 00    	js     801cc2 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b9f:	83 ec 04             	sub    $0x4,%esp
  801ba2:	68 07 04 00 00       	push   $0x407
  801ba7:	ff 75 f4             	pushl  -0xc(%ebp)
  801baa:	6a 00                	push   $0x0
  801bac:	e8 a2 f2 ff ff       	call   800e53 <sys_page_alloc>
  801bb1:	89 c3                	mov    %eax,%ebx
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	0f 88 04 01 00 00    	js     801cc2 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801bbe:	83 ec 0c             	sub    $0xc,%esp
  801bc1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bc4:	50                   	push   %eax
  801bc5:	e8 c0 f4 ff ff       	call   80108a <fd_alloc>
  801bca:	89 c3                	mov    %eax,%ebx
  801bcc:	83 c4 10             	add    $0x10,%esp
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	0f 88 db 00 00 00    	js     801cb2 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bd7:	83 ec 04             	sub    $0x4,%esp
  801bda:	68 07 04 00 00       	push   $0x407
  801bdf:	ff 75 f0             	pushl  -0x10(%ebp)
  801be2:	6a 00                	push   $0x0
  801be4:	e8 6a f2 ff ff       	call   800e53 <sys_page_alloc>
  801be9:	89 c3                	mov    %eax,%ebx
  801beb:	83 c4 10             	add    $0x10,%esp
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	0f 88 bc 00 00 00    	js     801cb2 <pipe+0x131>
	va = fd2data(fd0);
  801bf6:	83 ec 0c             	sub    $0xc,%esp
  801bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfc:	e8 72 f4 ff ff       	call   801073 <fd2data>
  801c01:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c03:	83 c4 0c             	add    $0xc,%esp
  801c06:	68 07 04 00 00       	push   $0x407
  801c0b:	50                   	push   %eax
  801c0c:	6a 00                	push   $0x0
  801c0e:	e8 40 f2 ff ff       	call   800e53 <sys_page_alloc>
  801c13:	89 c3                	mov    %eax,%ebx
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	0f 88 82 00 00 00    	js     801ca2 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c20:	83 ec 0c             	sub    $0xc,%esp
  801c23:	ff 75 f0             	pushl  -0x10(%ebp)
  801c26:	e8 48 f4 ff ff       	call   801073 <fd2data>
  801c2b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c32:	50                   	push   %eax
  801c33:	6a 00                	push   $0x0
  801c35:	56                   	push   %esi
  801c36:	6a 00                	push   $0x0
  801c38:	e8 59 f2 ff ff       	call   800e96 <sys_page_map>
  801c3d:	89 c3                	mov    %eax,%ebx
  801c3f:	83 c4 20             	add    $0x20,%esp
  801c42:	85 c0                	test   %eax,%eax
  801c44:	78 4e                	js     801c94 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801c46:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801c4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c4e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c53:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c5d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c62:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c69:	83 ec 0c             	sub    $0xc,%esp
  801c6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c6f:	e8 ef f3 ff ff       	call   801063 <fd2num>
  801c74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c77:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c79:	83 c4 04             	add    $0x4,%esp
  801c7c:	ff 75 f0             	pushl  -0x10(%ebp)
  801c7f:	e8 df f3 ff ff       	call   801063 <fd2num>
  801c84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c87:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c8a:	83 c4 10             	add    $0x10,%esp
  801c8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c92:	eb 2e                	jmp    801cc2 <pipe+0x141>
	sys_page_unmap(0, va);
  801c94:	83 ec 08             	sub    $0x8,%esp
  801c97:	56                   	push   %esi
  801c98:	6a 00                	push   $0x0
  801c9a:	e8 39 f2 ff ff       	call   800ed8 <sys_page_unmap>
  801c9f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ca2:	83 ec 08             	sub    $0x8,%esp
  801ca5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ca8:	6a 00                	push   $0x0
  801caa:	e8 29 f2 ff ff       	call   800ed8 <sys_page_unmap>
  801caf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801cb2:	83 ec 08             	sub    $0x8,%esp
  801cb5:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb8:	6a 00                	push   $0x0
  801cba:	e8 19 f2 ff ff       	call   800ed8 <sys_page_unmap>
  801cbf:	83 c4 10             	add    $0x10,%esp
}
  801cc2:	89 d8                	mov    %ebx,%eax
  801cc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc7:	5b                   	pop    %ebx
  801cc8:	5e                   	pop    %esi
  801cc9:	5d                   	pop    %ebp
  801cca:	c3                   	ret    

00801ccb <pipeisclosed>:
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cd1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd4:	50                   	push   %eax
  801cd5:	ff 75 08             	pushl  0x8(%ebp)
  801cd8:	e8 ff f3 ff ff       	call   8010dc <fd_lookup>
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	78 18                	js     801cfc <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ce4:	83 ec 0c             	sub    $0xc,%esp
  801ce7:	ff 75 f4             	pushl  -0xc(%ebp)
  801cea:	e8 84 f3 ff ff       	call   801073 <fd2data>
	return _pipeisclosed(fd, p);
  801cef:	89 c2                	mov    %eax,%edx
  801cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf4:	e8 2f fd ff ff       	call   801a28 <_pipeisclosed>
  801cf9:	83 c4 10             	add    $0x10,%esp
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d04:	68 ea 29 80 00       	push   $0x8029ea
  801d09:	ff 75 0c             	pushl  0xc(%ebp)
  801d0c:	e8 50 ed ff ff       	call   800a61 <strcpy>
	return 0;
}
  801d11:	b8 00 00 00 00       	mov    $0x0,%eax
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <devsock_close>:
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	53                   	push   %ebx
  801d1c:	83 ec 10             	sub    $0x10,%esp
  801d1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d22:	53                   	push   %ebx
  801d23:	e8 55 05 00 00       	call   80227d <pageref>
  801d28:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d2b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d30:	83 f8 01             	cmp    $0x1,%eax
  801d33:	74 07                	je     801d3c <devsock_close+0x24>
}
  801d35:	89 d0                	mov    %edx,%eax
  801d37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d3c:	83 ec 0c             	sub    $0xc,%esp
  801d3f:	ff 73 0c             	pushl  0xc(%ebx)
  801d42:	e8 b9 02 00 00       	call   802000 <nsipc_close>
  801d47:	89 c2                	mov    %eax,%edx
  801d49:	83 c4 10             	add    $0x10,%esp
  801d4c:	eb e7                	jmp    801d35 <devsock_close+0x1d>

00801d4e <devsock_write>:
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	ff 75 10             	pushl  0x10(%ebp)
  801d59:	ff 75 0c             	pushl  0xc(%ebp)
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	ff 70 0c             	pushl  0xc(%eax)
  801d62:	e8 76 03 00 00       	call   8020dd <nsipc_send>
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <devsock_read>:
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	ff 75 10             	pushl  0x10(%ebp)
  801d74:	ff 75 0c             	pushl  0xc(%ebp)
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	ff 70 0c             	pushl  0xc(%eax)
  801d7d:	e8 ef 02 00 00       	call   802071 <nsipc_recv>
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <fd2sockid>:
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d8a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d8d:	52                   	push   %edx
  801d8e:	50                   	push   %eax
  801d8f:	e8 48 f3 ff ff       	call   8010dc <fd_lookup>
  801d94:	83 c4 10             	add    $0x10,%esp
  801d97:	85 c0                	test   %eax,%eax
  801d99:	78 10                	js     801dab <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9e:	8b 0d 58 30 80 00    	mov    0x803058,%ecx
  801da4:	39 08                	cmp    %ecx,(%eax)
  801da6:	75 05                	jne    801dad <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801da8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    
		return -E_NOT_SUPP;
  801dad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801db2:	eb f7                	jmp    801dab <fd2sockid+0x27>

00801db4 <alloc_sockfd>:
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	56                   	push   %esi
  801db8:	53                   	push   %ebx
  801db9:	83 ec 1c             	sub    $0x1c,%esp
  801dbc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801dbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc1:	50                   	push   %eax
  801dc2:	e8 c3 f2 ff ff       	call   80108a <fd_alloc>
  801dc7:	89 c3                	mov    %eax,%ebx
  801dc9:	83 c4 10             	add    $0x10,%esp
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	78 43                	js     801e13 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801dd0:	83 ec 04             	sub    $0x4,%esp
  801dd3:	68 07 04 00 00       	push   $0x407
  801dd8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ddb:	6a 00                	push   $0x0
  801ddd:	e8 71 f0 ff ff       	call   800e53 <sys_page_alloc>
  801de2:	89 c3                	mov    %eax,%ebx
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	85 c0                	test   %eax,%eax
  801de9:	78 28                	js     801e13 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dee:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801df4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e00:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e03:	83 ec 0c             	sub    $0xc,%esp
  801e06:	50                   	push   %eax
  801e07:	e8 57 f2 ff ff       	call   801063 <fd2num>
  801e0c:	89 c3                	mov    %eax,%ebx
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	eb 0c                	jmp    801e1f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e13:	83 ec 0c             	sub    $0xc,%esp
  801e16:	56                   	push   %esi
  801e17:	e8 e4 01 00 00       	call   802000 <nsipc_close>
		return r;
  801e1c:	83 c4 10             	add    $0x10,%esp
}
  801e1f:	89 d8                	mov    %ebx,%eax
  801e21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e24:	5b                   	pop    %ebx
  801e25:	5e                   	pop    %esi
  801e26:	5d                   	pop    %ebp
  801e27:	c3                   	ret    

00801e28 <accept>:
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	e8 4e ff ff ff       	call   801d84 <fd2sockid>
  801e36:	85 c0                	test   %eax,%eax
  801e38:	78 1b                	js     801e55 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	ff 75 10             	pushl  0x10(%ebp)
  801e40:	ff 75 0c             	pushl  0xc(%ebp)
  801e43:	50                   	push   %eax
  801e44:	e8 0e 01 00 00       	call   801f57 <nsipc_accept>
  801e49:	83 c4 10             	add    $0x10,%esp
  801e4c:	85 c0                	test   %eax,%eax
  801e4e:	78 05                	js     801e55 <accept+0x2d>
	return alloc_sockfd(r);
  801e50:	e8 5f ff ff ff       	call   801db4 <alloc_sockfd>
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <bind>:
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	e8 1f ff ff ff       	call   801d84 <fd2sockid>
  801e65:	85 c0                	test   %eax,%eax
  801e67:	78 12                	js     801e7b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	ff 75 10             	pushl  0x10(%ebp)
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	50                   	push   %eax
  801e73:	e8 31 01 00 00       	call   801fa9 <nsipc_bind>
  801e78:	83 c4 10             	add    $0x10,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <shutdown>:
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	e8 f9 fe ff ff       	call   801d84 <fd2sockid>
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	78 0f                	js     801e9e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e8f:	83 ec 08             	sub    $0x8,%esp
  801e92:	ff 75 0c             	pushl  0xc(%ebp)
  801e95:	50                   	push   %eax
  801e96:	e8 43 01 00 00       	call   801fde <nsipc_shutdown>
  801e9b:	83 c4 10             	add    $0x10,%esp
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <connect>:
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	e8 d6 fe ff ff       	call   801d84 <fd2sockid>
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	78 12                	js     801ec4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801eb2:	83 ec 04             	sub    $0x4,%esp
  801eb5:	ff 75 10             	pushl  0x10(%ebp)
  801eb8:	ff 75 0c             	pushl  0xc(%ebp)
  801ebb:	50                   	push   %eax
  801ebc:	e8 59 01 00 00       	call   80201a <nsipc_connect>
  801ec1:	83 c4 10             	add    $0x10,%esp
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <listen>:
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	e8 b0 fe ff ff       	call   801d84 <fd2sockid>
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	78 0f                	js     801ee7 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ed8:	83 ec 08             	sub    $0x8,%esp
  801edb:	ff 75 0c             	pushl  0xc(%ebp)
  801ede:	50                   	push   %eax
  801edf:	e8 6b 01 00 00       	call   80204f <nsipc_listen>
  801ee4:	83 c4 10             	add    $0x10,%esp
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801eef:	ff 75 10             	pushl  0x10(%ebp)
  801ef2:	ff 75 0c             	pushl  0xc(%ebp)
  801ef5:	ff 75 08             	pushl  0x8(%ebp)
  801ef8:	e8 3e 02 00 00       	call   80213b <nsipc_socket>
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	85 c0                	test   %eax,%eax
  801f02:	78 05                	js     801f09 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f04:	e8 ab fe ff ff       	call   801db4 <alloc_sockfd>
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	53                   	push   %ebx
  801f0f:	83 ec 04             	sub    $0x4,%esp
  801f12:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f14:	83 3d 04 44 80 00 00 	cmpl   $0x0,0x804404
  801f1b:	74 26                	je     801f43 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f1d:	6a 07                	push   $0x7
  801f1f:	68 00 60 80 00       	push   $0x806000
  801f24:	53                   	push   %ebx
  801f25:	ff 35 04 44 80 00    	pushl  0x804404
  801f2b:	e8 a8 02 00 00       	call   8021d8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f30:	83 c4 0c             	add    $0xc,%esp
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	e8 27 02 00 00       	call   802165 <ipc_recv>
}
  801f3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f43:	83 ec 0c             	sub    $0xc,%esp
  801f46:	6a 02                	push   $0x2
  801f48:	e8 f7 02 00 00       	call   802244 <ipc_find_env>
  801f4d:	a3 04 44 80 00       	mov    %eax,0x804404
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	eb c6                	jmp    801f1d <nsipc+0x12>

00801f57 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	56                   	push   %esi
  801f5b:	53                   	push   %ebx
  801f5c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f67:	8b 06                	mov    (%esi),%eax
  801f69:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f73:	e8 93 ff ff ff       	call   801f0b <nsipc>
  801f78:	89 c3                	mov    %eax,%ebx
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	79 09                	jns    801f87 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f7e:	89 d8                	mov    %ebx,%eax
  801f80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f83:	5b                   	pop    %ebx
  801f84:	5e                   	pop    %esi
  801f85:	5d                   	pop    %ebp
  801f86:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f87:	83 ec 04             	sub    $0x4,%esp
  801f8a:	ff 35 10 60 80 00    	pushl  0x806010
  801f90:	68 00 60 80 00       	push   $0x806000
  801f95:	ff 75 0c             	pushl  0xc(%ebp)
  801f98:	e8 52 ec ff ff       	call   800bef <memmove>
		*addrlen = ret->ret_addrlen;
  801f9d:	a1 10 60 80 00       	mov    0x806010,%eax
  801fa2:	89 06                	mov    %eax,(%esi)
  801fa4:	83 c4 10             	add    $0x10,%esp
	return r;
  801fa7:	eb d5                	jmp    801f7e <nsipc_accept+0x27>

00801fa9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	53                   	push   %ebx
  801fad:	83 ec 08             	sub    $0x8,%esp
  801fb0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fbb:	53                   	push   %ebx
  801fbc:	ff 75 0c             	pushl  0xc(%ebp)
  801fbf:	68 04 60 80 00       	push   $0x806004
  801fc4:	e8 26 ec ff ff       	call   800bef <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fc9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801fcf:	b8 02 00 00 00       	mov    $0x2,%eax
  801fd4:	e8 32 ff ff ff       	call   801f0b <nsipc>
}
  801fd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fef:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ff4:	b8 03 00 00 00       	mov    $0x3,%eax
  801ff9:	e8 0d ff ff ff       	call   801f0b <nsipc>
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <nsipc_close>:

int
nsipc_close(int s)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80200e:	b8 04 00 00 00       	mov    $0x4,%eax
  802013:	e8 f3 fe ff ff       	call   801f0b <nsipc>
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	53                   	push   %ebx
  80201e:	83 ec 08             	sub    $0x8,%esp
  802021:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80202c:	53                   	push   %ebx
  80202d:	ff 75 0c             	pushl  0xc(%ebp)
  802030:	68 04 60 80 00       	push   $0x806004
  802035:	e8 b5 eb ff ff       	call   800bef <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80203a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802040:	b8 05 00 00 00       	mov    $0x5,%eax
  802045:	e8 c1 fe ff ff       	call   801f0b <nsipc>
}
  80204a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80205d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802060:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802065:	b8 06 00 00 00       	mov    $0x6,%eax
  80206a:	e8 9c fe ff ff       	call   801f0b <nsipc>
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	56                   	push   %esi
  802075:	53                   	push   %ebx
  802076:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802081:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802087:	8b 45 14             	mov    0x14(%ebp),%eax
  80208a:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80208f:	b8 07 00 00 00       	mov    $0x7,%eax
  802094:	e8 72 fe ff ff       	call   801f0b <nsipc>
  802099:	89 c3                	mov    %eax,%ebx
  80209b:	85 c0                	test   %eax,%eax
  80209d:	78 1f                	js     8020be <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80209f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020a4:	7f 21                	jg     8020c7 <nsipc_recv+0x56>
  8020a6:	39 c6                	cmp    %eax,%esi
  8020a8:	7c 1d                	jl     8020c7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020aa:	83 ec 04             	sub    $0x4,%esp
  8020ad:	50                   	push   %eax
  8020ae:	68 00 60 80 00       	push   $0x806000
  8020b3:	ff 75 0c             	pushl  0xc(%ebp)
  8020b6:	e8 34 eb ff ff       	call   800bef <memmove>
  8020bb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020be:	89 d8                	mov    %ebx,%eax
  8020c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c3:	5b                   	pop    %ebx
  8020c4:	5e                   	pop    %esi
  8020c5:	5d                   	pop    %ebp
  8020c6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020c7:	68 f6 29 80 00       	push   $0x8029f6
  8020cc:	68 98 29 80 00       	push   $0x802998
  8020d1:	6a 62                	push   $0x62
  8020d3:	68 0b 2a 80 00       	push   $0x802a0b
  8020d8:	e8 dd e1 ff ff       	call   8002ba <_panic>

008020dd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
  8020e0:	53                   	push   %ebx
  8020e1:	83 ec 04             	sub    $0x4,%esp
  8020e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8020ef:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020f5:	7f 2e                	jg     802125 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020f7:	83 ec 04             	sub    $0x4,%esp
  8020fa:	53                   	push   %ebx
  8020fb:	ff 75 0c             	pushl  0xc(%ebp)
  8020fe:	68 0c 60 80 00       	push   $0x80600c
  802103:	e8 e7 ea ff ff       	call   800bef <memmove>
	nsipcbuf.send.req_size = size;
  802108:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80210e:	8b 45 14             	mov    0x14(%ebp),%eax
  802111:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802116:	b8 08 00 00 00       	mov    $0x8,%eax
  80211b:	e8 eb fd ff ff       	call   801f0b <nsipc>
}
  802120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802123:	c9                   	leave  
  802124:	c3                   	ret    
	assert(size < 1600);
  802125:	68 17 2a 80 00       	push   $0x802a17
  80212a:	68 98 29 80 00       	push   $0x802998
  80212f:	6a 6d                	push   $0x6d
  802131:	68 0b 2a 80 00       	push   $0x802a0b
  802136:	e8 7f e1 ff ff       	call   8002ba <_panic>

0080213b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214c:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802151:	8b 45 10             	mov    0x10(%ebp),%eax
  802154:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802159:	b8 09 00 00 00       	mov    $0x9,%eax
  80215e:	e8 a8 fd ff ff       	call   801f0b <nsipc>
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	56                   	push   %esi
  802169:	53                   	push   %ebx
  80216a:	8b 75 08             	mov    0x8(%ebp),%esi
  80216d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802170:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802173:	85 c0                	test   %eax,%eax
  802175:	74 4f                	je     8021c6 <ipc_recv+0x61>
  802177:	83 ec 0c             	sub    $0xc,%esp
  80217a:	50                   	push   %eax
  80217b:	e8 83 ee ff ff       	call   801003 <sys_ipc_recv>
  802180:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  802183:	85 f6                	test   %esi,%esi
  802185:	74 14                	je     80219b <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802187:	ba 00 00 00 00       	mov    $0x0,%edx
  80218c:	85 c0                	test   %eax,%eax
  80218e:	75 09                	jne    802199 <ipc_recv+0x34>
  802190:	8b 15 08 44 80 00    	mov    0x804408,%edx
  802196:	8b 52 74             	mov    0x74(%edx),%edx
  802199:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  80219b:	85 db                	test   %ebx,%ebx
  80219d:	74 14                	je     8021b3 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  80219f:	ba 00 00 00 00       	mov    $0x0,%edx
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	75 09                	jne    8021b1 <ipc_recv+0x4c>
  8021a8:	8b 15 08 44 80 00    	mov    0x804408,%edx
  8021ae:	8b 52 78             	mov    0x78(%edx),%edx
  8021b1:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	75 08                	jne    8021bf <ipc_recv+0x5a>
  8021b7:	a1 08 44 80 00       	mov    0x804408,%eax
  8021bc:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c2:	5b                   	pop    %ebx
  8021c3:	5e                   	pop    %esi
  8021c4:	5d                   	pop    %ebp
  8021c5:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8021c6:	83 ec 0c             	sub    $0xc,%esp
  8021c9:	68 00 00 c0 ee       	push   $0xeec00000
  8021ce:	e8 30 ee ff ff       	call   801003 <sys_ipc_recv>
  8021d3:	83 c4 10             	add    $0x10,%esp
  8021d6:	eb ab                	jmp    802183 <ipc_recv+0x1e>

008021d8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	57                   	push   %edi
  8021dc:	56                   	push   %esi
  8021dd:	53                   	push   %ebx
  8021de:	83 ec 0c             	sub    $0xc,%esp
  8021e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021e4:	8b 75 10             	mov    0x10(%ebp),%esi
  8021e7:	eb 20                	jmp    802209 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8021e9:	6a 00                	push   $0x0
  8021eb:	68 00 00 c0 ee       	push   $0xeec00000
  8021f0:	ff 75 0c             	pushl  0xc(%ebp)
  8021f3:	57                   	push   %edi
  8021f4:	e8 e7 ed ff ff       	call   800fe0 <sys_ipc_try_send>
  8021f9:	89 c3                	mov    %eax,%ebx
  8021fb:	83 c4 10             	add    $0x10,%esp
  8021fe:	eb 1f                	jmp    80221f <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802200:	e8 2f ec ff ff       	call   800e34 <sys_yield>
	while(retval != 0) {
  802205:	85 db                	test   %ebx,%ebx
  802207:	74 33                	je     80223c <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802209:	85 f6                	test   %esi,%esi
  80220b:	74 dc                	je     8021e9 <ipc_send+0x11>
  80220d:	ff 75 14             	pushl  0x14(%ebp)
  802210:	56                   	push   %esi
  802211:	ff 75 0c             	pushl  0xc(%ebp)
  802214:	57                   	push   %edi
  802215:	e8 c6 ed ff ff       	call   800fe0 <sys_ipc_try_send>
  80221a:	89 c3                	mov    %eax,%ebx
  80221c:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  80221f:	83 fb f9             	cmp    $0xfffffff9,%ebx
  802222:	74 dc                	je     802200 <ipc_send+0x28>
  802224:	85 db                	test   %ebx,%ebx
  802226:	74 d8                	je     802200 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802228:	83 ec 04             	sub    $0x4,%esp
  80222b:	68 24 2a 80 00       	push   $0x802a24
  802230:	6a 35                	push   $0x35
  802232:	68 54 2a 80 00       	push   $0x802a54
  802237:	e8 7e e0 ff ff       	call   8002ba <_panic>
	}
}
  80223c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80223f:	5b                   	pop    %ebx
  802240:	5e                   	pop    %esi
  802241:	5f                   	pop    %edi
  802242:	5d                   	pop    %ebp
  802243:	c3                   	ret    

00802244 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80224a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80224f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802252:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802258:	8b 52 50             	mov    0x50(%edx),%edx
  80225b:	39 ca                	cmp    %ecx,%edx
  80225d:	74 11                	je     802270 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80225f:	83 c0 01             	add    $0x1,%eax
  802262:	3d 00 04 00 00       	cmp    $0x400,%eax
  802267:	75 e6                	jne    80224f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802269:	b8 00 00 00 00       	mov    $0x0,%eax
  80226e:	eb 0b                	jmp    80227b <ipc_find_env+0x37>
			return envs[i].env_id;
  802270:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802273:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802278:	8b 40 48             	mov    0x48(%eax),%eax
}
  80227b:	5d                   	pop    %ebp
  80227c:	c3                   	ret    

0080227d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802283:	89 d0                	mov    %edx,%eax
  802285:	c1 e8 16             	shr    $0x16,%eax
  802288:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802294:	f6 c1 01             	test   $0x1,%cl
  802297:	74 1d                	je     8022b6 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802299:	c1 ea 0c             	shr    $0xc,%edx
  80229c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022a3:	f6 c2 01             	test   $0x1,%dl
  8022a6:	74 0e                	je     8022b6 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022a8:	c1 ea 0c             	shr    $0xc,%edx
  8022ab:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022b2:	ef 
  8022b3:	0f b7 c0             	movzwl %ax,%eax
}
  8022b6:	5d                   	pop    %ebp
  8022b7:	c3                   	ret    
  8022b8:	66 90                	xchg   %ax,%ax
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	66 90                	xchg   %ax,%ax
  8022be:	66 90                	xchg   %ax,%ax

008022c0 <__udivdi3>:
  8022c0:	f3 0f 1e fb          	endbr32 
  8022c4:	55                   	push   %ebp
  8022c5:	57                   	push   %edi
  8022c6:	56                   	push   %esi
  8022c7:	53                   	push   %ebx
  8022c8:	83 ec 1c             	sub    $0x1c,%esp
  8022cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022db:	85 d2                	test   %edx,%edx
  8022dd:	75 49                	jne    802328 <__udivdi3+0x68>
  8022df:	39 f3                	cmp    %esi,%ebx
  8022e1:	76 15                	jbe    8022f8 <__udivdi3+0x38>
  8022e3:	31 ff                	xor    %edi,%edi
  8022e5:	89 e8                	mov    %ebp,%eax
  8022e7:	89 f2                	mov    %esi,%edx
  8022e9:	f7 f3                	div    %ebx
  8022eb:	89 fa                	mov    %edi,%edx
  8022ed:	83 c4 1c             	add    $0x1c,%esp
  8022f0:	5b                   	pop    %ebx
  8022f1:	5e                   	pop    %esi
  8022f2:	5f                   	pop    %edi
  8022f3:	5d                   	pop    %ebp
  8022f4:	c3                   	ret    
  8022f5:	8d 76 00             	lea    0x0(%esi),%esi
  8022f8:	89 d9                	mov    %ebx,%ecx
  8022fa:	85 db                	test   %ebx,%ebx
  8022fc:	75 0b                	jne    802309 <__udivdi3+0x49>
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	f7 f3                	div    %ebx
  802307:	89 c1                	mov    %eax,%ecx
  802309:	31 d2                	xor    %edx,%edx
  80230b:	89 f0                	mov    %esi,%eax
  80230d:	f7 f1                	div    %ecx
  80230f:	89 c6                	mov    %eax,%esi
  802311:	89 e8                	mov    %ebp,%eax
  802313:	89 f7                	mov    %esi,%edi
  802315:	f7 f1                	div    %ecx
  802317:	89 fa                	mov    %edi,%edx
  802319:	83 c4 1c             	add    $0x1c,%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
  802321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802328:	39 f2                	cmp    %esi,%edx
  80232a:	77 1c                	ja     802348 <__udivdi3+0x88>
  80232c:	0f bd fa             	bsr    %edx,%edi
  80232f:	83 f7 1f             	xor    $0x1f,%edi
  802332:	75 2c                	jne    802360 <__udivdi3+0xa0>
  802334:	39 f2                	cmp    %esi,%edx
  802336:	72 06                	jb     80233e <__udivdi3+0x7e>
  802338:	31 c0                	xor    %eax,%eax
  80233a:	39 eb                	cmp    %ebp,%ebx
  80233c:	77 ad                	ja     8022eb <__udivdi3+0x2b>
  80233e:	b8 01 00 00 00       	mov    $0x1,%eax
  802343:	eb a6                	jmp    8022eb <__udivdi3+0x2b>
  802345:	8d 76 00             	lea    0x0(%esi),%esi
  802348:	31 ff                	xor    %edi,%edi
  80234a:	31 c0                	xor    %eax,%eax
  80234c:	89 fa                	mov    %edi,%edx
  80234e:	83 c4 1c             	add    $0x1c,%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5f                   	pop    %edi
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    
  802356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80235d:	8d 76 00             	lea    0x0(%esi),%esi
  802360:	89 f9                	mov    %edi,%ecx
  802362:	b8 20 00 00 00       	mov    $0x20,%eax
  802367:	29 f8                	sub    %edi,%eax
  802369:	d3 e2                	shl    %cl,%edx
  80236b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80236f:	89 c1                	mov    %eax,%ecx
  802371:	89 da                	mov    %ebx,%edx
  802373:	d3 ea                	shr    %cl,%edx
  802375:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802379:	09 d1                	or     %edx,%ecx
  80237b:	89 f2                	mov    %esi,%edx
  80237d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802381:	89 f9                	mov    %edi,%ecx
  802383:	d3 e3                	shl    %cl,%ebx
  802385:	89 c1                	mov    %eax,%ecx
  802387:	d3 ea                	shr    %cl,%edx
  802389:	89 f9                	mov    %edi,%ecx
  80238b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80238f:	89 eb                	mov    %ebp,%ebx
  802391:	d3 e6                	shl    %cl,%esi
  802393:	89 c1                	mov    %eax,%ecx
  802395:	d3 eb                	shr    %cl,%ebx
  802397:	09 de                	or     %ebx,%esi
  802399:	89 f0                	mov    %esi,%eax
  80239b:	f7 74 24 08          	divl   0x8(%esp)
  80239f:	89 d6                	mov    %edx,%esi
  8023a1:	89 c3                	mov    %eax,%ebx
  8023a3:	f7 64 24 0c          	mull   0xc(%esp)
  8023a7:	39 d6                	cmp    %edx,%esi
  8023a9:	72 15                	jb     8023c0 <__udivdi3+0x100>
  8023ab:	89 f9                	mov    %edi,%ecx
  8023ad:	d3 e5                	shl    %cl,%ebp
  8023af:	39 c5                	cmp    %eax,%ebp
  8023b1:	73 04                	jae    8023b7 <__udivdi3+0xf7>
  8023b3:	39 d6                	cmp    %edx,%esi
  8023b5:	74 09                	je     8023c0 <__udivdi3+0x100>
  8023b7:	89 d8                	mov    %ebx,%eax
  8023b9:	31 ff                	xor    %edi,%edi
  8023bb:	e9 2b ff ff ff       	jmp    8022eb <__udivdi3+0x2b>
  8023c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023c3:	31 ff                	xor    %edi,%edi
  8023c5:	e9 21 ff ff ff       	jmp    8022eb <__udivdi3+0x2b>
  8023ca:	66 90                	xchg   %ax,%ax
  8023cc:	66 90                	xchg   %ax,%ax
  8023ce:	66 90                	xchg   %ax,%ax

008023d0 <__umoddi3>:
  8023d0:	f3 0f 1e fb          	endbr32 
  8023d4:	55                   	push   %ebp
  8023d5:	57                   	push   %edi
  8023d6:	56                   	push   %esi
  8023d7:	53                   	push   %ebx
  8023d8:	83 ec 1c             	sub    $0x1c,%esp
  8023db:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023e3:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023eb:	89 da                	mov    %ebx,%edx
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	75 3f                	jne    802430 <__umoddi3+0x60>
  8023f1:	39 df                	cmp    %ebx,%edi
  8023f3:	76 13                	jbe    802408 <__umoddi3+0x38>
  8023f5:	89 f0                	mov    %esi,%eax
  8023f7:	f7 f7                	div    %edi
  8023f9:	89 d0                	mov    %edx,%eax
  8023fb:	31 d2                	xor    %edx,%edx
  8023fd:	83 c4 1c             	add    $0x1c,%esp
  802400:	5b                   	pop    %ebx
  802401:	5e                   	pop    %esi
  802402:	5f                   	pop    %edi
  802403:	5d                   	pop    %ebp
  802404:	c3                   	ret    
  802405:	8d 76 00             	lea    0x0(%esi),%esi
  802408:	89 fd                	mov    %edi,%ebp
  80240a:	85 ff                	test   %edi,%edi
  80240c:	75 0b                	jne    802419 <__umoddi3+0x49>
  80240e:	b8 01 00 00 00       	mov    $0x1,%eax
  802413:	31 d2                	xor    %edx,%edx
  802415:	f7 f7                	div    %edi
  802417:	89 c5                	mov    %eax,%ebp
  802419:	89 d8                	mov    %ebx,%eax
  80241b:	31 d2                	xor    %edx,%edx
  80241d:	f7 f5                	div    %ebp
  80241f:	89 f0                	mov    %esi,%eax
  802421:	f7 f5                	div    %ebp
  802423:	89 d0                	mov    %edx,%eax
  802425:	eb d4                	jmp    8023fb <__umoddi3+0x2b>
  802427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80242e:	66 90                	xchg   %ax,%ax
  802430:	89 f1                	mov    %esi,%ecx
  802432:	39 d8                	cmp    %ebx,%eax
  802434:	76 0a                	jbe    802440 <__umoddi3+0x70>
  802436:	89 f0                	mov    %esi,%eax
  802438:	83 c4 1c             	add    $0x1c,%esp
  80243b:	5b                   	pop    %ebx
  80243c:	5e                   	pop    %esi
  80243d:	5f                   	pop    %edi
  80243e:	5d                   	pop    %ebp
  80243f:	c3                   	ret    
  802440:	0f bd e8             	bsr    %eax,%ebp
  802443:	83 f5 1f             	xor    $0x1f,%ebp
  802446:	75 20                	jne    802468 <__umoddi3+0x98>
  802448:	39 d8                	cmp    %ebx,%eax
  80244a:	0f 82 b0 00 00 00    	jb     802500 <__umoddi3+0x130>
  802450:	39 f7                	cmp    %esi,%edi
  802452:	0f 86 a8 00 00 00    	jbe    802500 <__umoddi3+0x130>
  802458:	89 c8                	mov    %ecx,%eax
  80245a:	83 c4 1c             	add    $0x1c,%esp
  80245d:	5b                   	pop    %ebx
  80245e:	5e                   	pop    %esi
  80245f:	5f                   	pop    %edi
  802460:	5d                   	pop    %ebp
  802461:	c3                   	ret    
  802462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802468:	89 e9                	mov    %ebp,%ecx
  80246a:	ba 20 00 00 00       	mov    $0x20,%edx
  80246f:	29 ea                	sub    %ebp,%edx
  802471:	d3 e0                	shl    %cl,%eax
  802473:	89 44 24 08          	mov    %eax,0x8(%esp)
  802477:	89 d1                	mov    %edx,%ecx
  802479:	89 f8                	mov    %edi,%eax
  80247b:	d3 e8                	shr    %cl,%eax
  80247d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802481:	89 54 24 04          	mov    %edx,0x4(%esp)
  802485:	8b 54 24 04          	mov    0x4(%esp),%edx
  802489:	09 c1                	or     %eax,%ecx
  80248b:	89 d8                	mov    %ebx,%eax
  80248d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802491:	89 e9                	mov    %ebp,%ecx
  802493:	d3 e7                	shl    %cl,%edi
  802495:	89 d1                	mov    %edx,%ecx
  802497:	d3 e8                	shr    %cl,%eax
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80249f:	d3 e3                	shl    %cl,%ebx
  8024a1:	89 c7                	mov    %eax,%edi
  8024a3:	89 d1                	mov    %edx,%ecx
  8024a5:	89 f0                	mov    %esi,%eax
  8024a7:	d3 e8                	shr    %cl,%eax
  8024a9:	89 e9                	mov    %ebp,%ecx
  8024ab:	89 fa                	mov    %edi,%edx
  8024ad:	d3 e6                	shl    %cl,%esi
  8024af:	09 d8                	or     %ebx,%eax
  8024b1:	f7 74 24 08          	divl   0x8(%esp)
  8024b5:	89 d1                	mov    %edx,%ecx
  8024b7:	89 f3                	mov    %esi,%ebx
  8024b9:	f7 64 24 0c          	mull   0xc(%esp)
  8024bd:	89 c6                	mov    %eax,%esi
  8024bf:	89 d7                	mov    %edx,%edi
  8024c1:	39 d1                	cmp    %edx,%ecx
  8024c3:	72 06                	jb     8024cb <__umoddi3+0xfb>
  8024c5:	75 10                	jne    8024d7 <__umoddi3+0x107>
  8024c7:	39 c3                	cmp    %eax,%ebx
  8024c9:	73 0c                	jae    8024d7 <__umoddi3+0x107>
  8024cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024d3:	89 d7                	mov    %edx,%edi
  8024d5:	89 c6                	mov    %eax,%esi
  8024d7:	89 ca                	mov    %ecx,%edx
  8024d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024de:	29 f3                	sub    %esi,%ebx
  8024e0:	19 fa                	sbb    %edi,%edx
  8024e2:	89 d0                	mov    %edx,%eax
  8024e4:	d3 e0                	shl    %cl,%eax
  8024e6:	89 e9                	mov    %ebp,%ecx
  8024e8:	d3 eb                	shr    %cl,%ebx
  8024ea:	d3 ea                	shr    %cl,%edx
  8024ec:	09 d8                	or     %ebx,%eax
  8024ee:	83 c4 1c             	add    $0x1c,%esp
  8024f1:	5b                   	pop    %ebx
  8024f2:	5e                   	pop    %esi
  8024f3:	5f                   	pop    %edi
  8024f4:	5d                   	pop    %ebp
  8024f5:	c3                   	ret    
  8024f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024fd:	8d 76 00             	lea    0x0(%esi),%esi
  802500:	89 da                	mov    %ebx,%edx
  802502:	29 fe                	sub    %edi,%esi
  802504:	19 c2                	sbb    %eax,%edx
  802506:	89 f1                	mov    %esi,%ecx
  802508:	89 c8                	mov    %ecx,%eax
  80250a:	e9 4b ff ff ff       	jmp    80245a <__umoddi3+0x8a>
