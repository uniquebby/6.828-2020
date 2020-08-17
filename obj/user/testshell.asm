
obj/user/testshell.debug：     文件格式 elf32-i386


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
  80002c:	e8 55 04 00 00       	call   800486 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 84 00 00 00    	sub    $0x84,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	53                   	push   %ebx
  800049:	56                   	push   %esi
  80004a:	e8 2c 19 00 00       	call   80197b <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 22 19 00 00       	call   80197b <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 c0 2f 80 00 	movl   $0x802fc0,(%esp)
  800060:	e8 5c 05 00 00       	call   8005c1 <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 2b 30 80 00 	movl   $0x80302b,(%esp)
  80006c:	e8 50 05 00 00       	call   8005c1 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	6a 63                	push   $0x63
  80007c:	53                   	push   %ebx
  80007d:	57                   	push   %edi
  80007e:	e8 aa 17 00 00       	call   80182d <read>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	85 c0                	test   %eax,%eax
  800088:	7e 0f                	jle    800099 <wrong+0x66>
		sys_cputs(buf, n);
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	50                   	push   %eax
  80008e:	53                   	push   %ebx
  80008f:	e8 3f 0e 00 00       	call   800ed3 <sys_cputs>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	eb de                	jmp    800077 <wrong+0x44>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 3a 30 80 00       	push   $0x80303a
  8000a1:	e8 1b 05 00 00       	call   8005c1 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 1b 0e 00 00       	call   800ed3 <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 66 17 00 00       	call   80182d <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 35 30 80 00       	push   $0x803035
  8000d6:	e8 e6 04 00 00       	call   8005c1 <cprintf>
	exit();
  8000db:	e8 ec 03 00 00       	call   8004cc <exit>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <umain>:
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000f4:	6a 00                	push   $0x0
  8000f6:	e8 f4 15 00 00       	call   8016ef <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 e8 15 00 00       	call   8016ef <close>
	opencons();
  800107:	e8 28 03 00 00       	call   800434 <opencons>
	opencons();
  80010c:	e8 23 03 00 00       	call   800434 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 48 30 80 00       	push   $0x803048
  80011b:	e8 b8 1b 00 00       	call   801cd8 <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e7 00 00 00    	js     800214 <umain+0x129>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 14 24 00 00       	call   80254d <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e2 00 00 00    	js     800226 <umain+0x13b>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 e4 2f 80 00       	push   $0x802fe4
  80014f:	e8 6d 04 00 00       	call   8005c1 <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 bd 11 00 00       	call   801316 <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d4 00 00 00    	js     800238 <umain+0x14d>
	if (r == 0) {
  800164:	75 6f                	jne    8001d5 <umain+0xea>
		dup(rfd, 0);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	6a 00                	push   $0x0
  80016b:	53                   	push   %ebx
  80016c:	e8 d0 15 00 00       	call   801741 <dup>
		dup(wfd, 1);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	6a 01                	push   $0x1
  800176:	56                   	push   %esi
  800177:	e8 c5 15 00 00       	call   801741 <dup>
		close(rfd);
  80017c:	89 1c 24             	mov    %ebx,(%esp)
  80017f:	e8 6b 15 00 00       	call   8016ef <close>
		close(wfd);
  800184:	89 34 24             	mov    %esi,(%esp)
  800187:	e8 63 15 00 00       	call   8016ef <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018c:	6a 00                	push   $0x0
  80018e:	68 8e 30 80 00       	push   $0x80308e
  800193:	68 52 30 80 00       	push   $0x803052
  800198:	68 91 30 80 00       	push   $0x803091
  80019d:	e8 5d 21 00 00       	call   8022ff <spawnl>
  8001a2:	89 c7                	mov    %eax,%edi
  8001a4:	83 c4 20             	add    $0x20,%esp
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	0f 88 9b 00 00 00    	js     80024a <umain+0x15f>
		close(0);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	e8 36 15 00 00       	call   8016ef <close>
		close(1);
  8001b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c0:	e8 2a 15 00 00       	call   8016ef <close>
		wait(r);
  8001c5:	89 3c 24             	mov    %edi,(%esp)
  8001c8:	e8 fd 24 00 00       	call   8026ca <wait>
		exit();
  8001cd:	e8 fa 02 00 00       	call   8004cc <exit>
  8001d2:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	53                   	push   %ebx
  8001d9:	e8 11 15 00 00       	call   8016ef <close>
	close(wfd);
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 09 15 00 00       	call   8016ef <close>
	rfd = pfds[0];
  8001e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ec:	83 c4 08             	add    $0x8,%esp
  8001ef:	6a 00                	push   $0x0
  8001f1:	68 9f 30 80 00       	push   $0x80309f
  8001f6:	e8 dd 1a 00 00       	call   801cd8 <open>
  8001fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	85 c0                	test   %eax,%eax
  800203:	78 57                	js     80025c <umain+0x171>
  800205:	be 01 00 00 00       	mov    $0x1,%esi
	nloff = 0;
  80020a:	bf 00 00 00 00       	mov    $0x0,%edi
  80020f:	e9 9a 00 00 00       	jmp    8002ae <umain+0x1c3>
		panic("open testshell.sh: %e", rfd);
  800214:	50                   	push   %eax
  800215:	68 55 30 80 00       	push   $0x803055
  80021a:	6a 13                	push   $0x13
  80021c:	68 6b 30 80 00       	push   $0x80306b
  800221:	e8 c0 02 00 00       	call   8004e6 <_panic>
		panic("pipe: %e", wfd);
  800226:	50                   	push   %eax
  800227:	68 7c 30 80 00       	push   $0x80307c
  80022c:	6a 15                	push   $0x15
  80022e:	68 6b 30 80 00       	push   $0x80306b
  800233:	e8 ae 02 00 00       	call   8004e6 <_panic>
		panic("fork: %e", r);
  800238:	50                   	push   %eax
  800239:	68 85 30 80 00       	push   $0x803085
  80023e:	6a 1a                	push   $0x1a
  800240:	68 6b 30 80 00       	push   $0x80306b
  800245:	e8 9c 02 00 00       	call   8004e6 <_panic>
			panic("spawn: %e", r);
  80024a:	50                   	push   %eax
  80024b:	68 95 30 80 00       	push   $0x803095
  800250:	6a 21                	push   $0x21
  800252:	68 6b 30 80 00       	push   $0x80306b
  800257:	e8 8a 02 00 00       	call   8004e6 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025c:	50                   	push   %eax
  80025d:	68 08 30 80 00       	push   $0x803008
  800262:	6a 2c                	push   $0x2c
  800264:	68 6b 30 80 00       	push   $0x80306b
  800269:	e8 78 02 00 00       	call   8004e6 <_panic>
			panic("reading testshell.out: %e", n1);
  80026e:	53                   	push   %ebx
  80026f:	68 ad 30 80 00       	push   $0x8030ad
  800274:	6a 33                	push   $0x33
  800276:	68 6b 30 80 00       	push   $0x80306b
  80027b:	e8 66 02 00 00       	call   8004e6 <_panic>
			panic("reading testshell.key: %e", n2);
  800280:	50                   	push   %eax
  800281:	68 c7 30 80 00       	push   $0x8030c7
  800286:	6a 35                	push   $0x35
  800288:	68 6b 30 80 00       	push   $0x80306b
  80028d:	e8 54 02 00 00       	call   8004e6 <_panic>
			wrong(rfd, kfd, nloff);
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	57                   	push   %edi
  800296:	ff 75 d4             	pushl  -0x2c(%ebp)
  800299:	ff 75 d0             	pushl  -0x30(%ebp)
  80029c:	e8 92 fd ff ff       	call   800033 <wrong>
  8002a1:	83 c4 10             	add    $0x10,%esp
			nloff = off+1;
  8002a4:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002a8:	0f 44 fe             	cmove  %esi,%edi
  8002ab:	83 c6 01             	add    $0x1,%esi
		n1 = read(rfd, &c1, 1);
  8002ae:	83 ec 04             	sub    $0x4,%esp
  8002b1:	6a 01                	push   $0x1
  8002b3:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002b6:	50                   	push   %eax
  8002b7:	ff 75 d0             	pushl  -0x30(%ebp)
  8002ba:	e8 6e 15 00 00       	call   80182d <read>
  8002bf:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c1:	83 c4 0c             	add    $0xc,%esp
  8002c4:	6a 01                	push   $0x1
  8002c6:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cd:	e8 5b 15 00 00       	call   80182d <read>
		if (n1 < 0)
  8002d2:	83 c4 10             	add    $0x10,%esp
  8002d5:	85 db                	test   %ebx,%ebx
  8002d7:	78 95                	js     80026e <umain+0x183>
		if (n2 < 0)
  8002d9:	85 c0                	test   %eax,%eax
  8002db:	78 a3                	js     800280 <umain+0x195>
		if (n1 == 0 && n2 == 0)
  8002dd:	89 da                	mov    %ebx,%edx
  8002df:	09 c2                	or     %eax,%edx
  8002e1:	74 15                	je     8002f8 <umain+0x20d>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002e3:	83 fb 01             	cmp    $0x1,%ebx
  8002e6:	75 aa                	jne    800292 <umain+0x1a7>
  8002e8:	83 f8 01             	cmp    $0x1,%eax
  8002eb:	75 a5                	jne    800292 <umain+0x1a7>
  8002ed:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002f1:	38 45 e7             	cmp    %al,-0x19(%ebp)
  8002f4:	75 9c                	jne    800292 <umain+0x1a7>
  8002f6:	eb ac                	jmp    8002a4 <umain+0x1b9>
	cprintf("shell ran correctly\n");
  8002f8:	83 ec 0c             	sub    $0xc,%esp
  8002fb:	68 e1 30 80 00       	push   $0x8030e1
  800300:	e8 bc 02 00 00       	call   8005c1 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800305:	cc                   	int3   
}
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030c:	5b                   	pop    %ebx
  80030d:	5e                   	pop    %esi
  80030e:	5f                   	pop    %edi
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    

00800311 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800311:	b8 00 00 00 00       	mov    $0x0,%eax
  800316:	c3                   	ret    

00800317 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80031d:	68 f6 30 80 00       	push   $0x8030f6
  800322:	ff 75 0c             	pushl  0xc(%ebp)
  800325:	e8 73 08 00 00       	call   800b9d <strcpy>
	return 0;
}
  80032a:	b8 00 00 00 00       	mov    $0x0,%eax
  80032f:	c9                   	leave  
  800330:	c3                   	ret    

00800331 <devcons_write>:
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	57                   	push   %edi
  800335:	56                   	push   %esi
  800336:	53                   	push   %ebx
  800337:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80033d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800342:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800348:	3b 75 10             	cmp    0x10(%ebp),%esi
  80034b:	73 31                	jae    80037e <devcons_write+0x4d>
		m = n - tot;
  80034d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800350:	29 f3                	sub    %esi,%ebx
  800352:	83 fb 7f             	cmp    $0x7f,%ebx
  800355:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80035a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80035d:	83 ec 04             	sub    $0x4,%esp
  800360:	53                   	push   %ebx
  800361:	89 f0                	mov    %esi,%eax
  800363:	03 45 0c             	add    0xc(%ebp),%eax
  800366:	50                   	push   %eax
  800367:	57                   	push   %edi
  800368:	e8 be 09 00 00       	call   800d2b <memmove>
		sys_cputs(buf, m);
  80036d:	83 c4 08             	add    $0x8,%esp
  800370:	53                   	push   %ebx
  800371:	57                   	push   %edi
  800372:	e8 5c 0b 00 00       	call   800ed3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800377:	01 de                	add    %ebx,%esi
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	eb ca                	jmp    800348 <devcons_write+0x17>
}
  80037e:	89 f0                	mov    %esi,%eax
  800380:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800383:	5b                   	pop    %ebx
  800384:	5e                   	pop    %esi
  800385:	5f                   	pop    %edi
  800386:	5d                   	pop    %ebp
  800387:	c3                   	ret    

00800388 <devcons_read>:
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800393:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800397:	74 21                	je     8003ba <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  800399:	e8 53 0b 00 00       	call   800ef1 <sys_cgetc>
  80039e:	85 c0                	test   %eax,%eax
  8003a0:	75 07                	jne    8003a9 <devcons_read+0x21>
		sys_yield();
  8003a2:	e8 c9 0b 00 00       	call   800f70 <sys_yield>
  8003a7:	eb f0                	jmp    800399 <devcons_read+0x11>
	if (c < 0)
  8003a9:	78 0f                	js     8003ba <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8003ab:	83 f8 04             	cmp    $0x4,%eax
  8003ae:	74 0c                	je     8003bc <devcons_read+0x34>
	*(char*)vbuf = c;
  8003b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b3:	88 02                	mov    %al,(%edx)
	return 1;
  8003b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8003ba:	c9                   	leave  
  8003bb:	c3                   	ret    
		return 0;
  8003bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c1:	eb f7                	jmp    8003ba <devcons_read+0x32>

008003c3 <cputchar>:
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003cf:	6a 01                	push   $0x1
  8003d1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003d4:	50                   	push   %eax
  8003d5:	e8 f9 0a 00 00       	call   800ed3 <sys_cputs>
}
  8003da:	83 c4 10             	add    $0x10,%esp
  8003dd:	c9                   	leave  
  8003de:	c3                   	ret    

008003df <getchar>:
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8003e5:	6a 01                	push   $0x1
  8003e7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003ea:	50                   	push   %eax
  8003eb:	6a 00                	push   $0x0
  8003ed:	e8 3b 14 00 00       	call   80182d <read>
	if (r < 0)
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	85 c0                	test   %eax,%eax
  8003f7:	78 06                	js     8003ff <getchar+0x20>
	if (r < 1)
  8003f9:	74 06                	je     800401 <getchar+0x22>
	return c;
  8003fb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    
		return -E_EOF;
  800401:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800406:	eb f7                	jmp    8003ff <getchar+0x20>

00800408 <iscons>:
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80040e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800411:	50                   	push   %eax
  800412:	ff 75 08             	pushl  0x8(%ebp)
  800415:	e8 a3 11 00 00       	call   8015bd <fd_lookup>
  80041a:	83 c4 10             	add    $0x10,%esp
  80041d:	85 c0                	test   %eax,%eax
  80041f:	78 11                	js     800432 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800424:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80042a:	39 10                	cmp    %edx,(%eax)
  80042c:	0f 94 c0             	sete   %al
  80042f:	0f b6 c0             	movzbl %al,%eax
}
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <opencons>:
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80043a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80043d:	50                   	push   %eax
  80043e:	e8 28 11 00 00       	call   80156b <fd_alloc>
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	85 c0                	test   %eax,%eax
  800448:	78 3a                	js     800484 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	68 07 04 00 00       	push   $0x407
  800452:	ff 75 f4             	pushl  -0xc(%ebp)
  800455:	6a 00                	push   $0x0
  800457:	e8 33 0b 00 00       	call   800f8f <sys_page_alloc>
  80045c:	83 c4 10             	add    $0x10,%esp
  80045f:	85 c0                	test   %eax,%eax
  800461:	78 21                	js     800484 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800466:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80046c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800471:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	50                   	push   %eax
  80047c:	e8 c3 10 00 00       	call   801544 <fd2num>
  800481:	83 c4 10             	add    $0x10,%esp
}
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	56                   	push   %esi
  80048a:	53                   	push   %ebx
  80048b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80048e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800491:	e8 bb 0a 00 00       	call   800f51 <sys_getenvid>
  800496:	25 ff 03 00 00       	and    $0x3ff,%eax
  80049b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80049e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a3:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004a8:	85 db                	test   %ebx,%ebx
  8004aa:	7e 07                	jle    8004b3 <libmain+0x2d>
		binaryname = argv[0];
  8004ac:	8b 06                	mov    (%esi),%eax
  8004ae:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004b3:	83 ec 08             	sub    $0x8,%esp
  8004b6:	56                   	push   %esi
  8004b7:	53                   	push   %ebx
  8004b8:	e8 2e fc ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8004bd:	e8 0a 00 00 00       	call   8004cc <exit>
}
  8004c2:	83 c4 10             	add    $0x10,%esp
  8004c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004c8:	5b                   	pop    %ebx
  8004c9:	5e                   	pop    %esi
  8004ca:	5d                   	pop    %ebp
  8004cb:	c3                   	ret    

008004cc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8004d2:	e8 45 12 00 00       	call   80171c <close_all>
	sys_env_destroy(0);
  8004d7:	83 ec 0c             	sub    $0xc,%esp
  8004da:	6a 00                	push   $0x0
  8004dc:	e8 2f 0a 00 00       	call   800f10 <sys_env_destroy>
}
  8004e1:	83 c4 10             	add    $0x10,%esp
  8004e4:	c9                   	leave  
  8004e5:	c3                   	ret    

008004e6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
  8004e9:	56                   	push   %esi
  8004ea:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8004eb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004ee:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8004f4:	e8 58 0a 00 00       	call   800f51 <sys_getenvid>
  8004f9:	83 ec 0c             	sub    $0xc,%esp
  8004fc:	ff 75 0c             	pushl  0xc(%ebp)
  8004ff:	ff 75 08             	pushl  0x8(%ebp)
  800502:	56                   	push   %esi
  800503:	50                   	push   %eax
  800504:	68 0c 31 80 00       	push   $0x80310c
  800509:	e8 b3 00 00 00       	call   8005c1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80050e:	83 c4 18             	add    $0x18,%esp
  800511:	53                   	push   %ebx
  800512:	ff 75 10             	pushl  0x10(%ebp)
  800515:	e8 56 00 00 00       	call   800570 <vcprintf>
	cprintf("\n");
  80051a:	c7 04 24 38 30 80 00 	movl   $0x803038,(%esp)
  800521:	e8 9b 00 00 00       	call   8005c1 <cprintf>
  800526:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800529:	cc                   	int3   
  80052a:	eb fd                	jmp    800529 <_panic+0x43>

0080052c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	53                   	push   %ebx
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800536:	8b 13                	mov    (%ebx),%edx
  800538:	8d 42 01             	lea    0x1(%edx),%eax
  80053b:	89 03                	mov    %eax,(%ebx)
  80053d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800540:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800544:	3d ff 00 00 00       	cmp    $0xff,%eax
  800549:	74 09                	je     800554 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80054b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80054f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800552:	c9                   	leave  
  800553:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	68 ff 00 00 00       	push   $0xff
  80055c:	8d 43 08             	lea    0x8(%ebx),%eax
  80055f:	50                   	push   %eax
  800560:	e8 6e 09 00 00       	call   800ed3 <sys_cputs>
		b->idx = 0;
  800565:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	eb db                	jmp    80054b <putch+0x1f>

00800570 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800579:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800580:	00 00 00 
	b.cnt = 0;
  800583:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80058a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80058d:	ff 75 0c             	pushl  0xc(%ebp)
  800590:	ff 75 08             	pushl  0x8(%ebp)
  800593:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800599:	50                   	push   %eax
  80059a:	68 2c 05 80 00       	push   $0x80052c
  80059f:	e8 19 01 00 00       	call   8006bd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005a4:	83 c4 08             	add    $0x8,%esp
  8005a7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005ad:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005b3:	50                   	push   %eax
  8005b4:	e8 1a 09 00 00       	call   800ed3 <sys_cputs>

	return b.cnt;
}
  8005b9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005bf:	c9                   	leave  
  8005c0:	c3                   	ret    

008005c1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005c1:	55                   	push   %ebp
  8005c2:	89 e5                	mov    %esp,%ebp
  8005c4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005c7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005ca:	50                   	push   %eax
  8005cb:	ff 75 08             	pushl  0x8(%ebp)
  8005ce:	e8 9d ff ff ff       	call   800570 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005d3:	c9                   	leave  
  8005d4:	c3                   	ret    

008005d5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
  8005d8:	57                   	push   %edi
  8005d9:	56                   	push   %esi
  8005da:	53                   	push   %ebx
  8005db:	83 ec 1c             	sub    $0x1c,%esp
  8005de:	89 c7                	mov    %eax,%edi
  8005e0:	89 d6                	mov    %edx,%esi
  8005e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005f9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005fc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8005ff:	89 d0                	mov    %edx,%eax
  800601:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800604:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800607:	73 15                	jae    80061e <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800609:	83 eb 01             	sub    $0x1,%ebx
  80060c:	85 db                	test   %ebx,%ebx
  80060e:	7e 43                	jle    800653 <printnum+0x7e>
			putch(padc, putdat);
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	56                   	push   %esi
  800614:	ff 75 18             	pushl  0x18(%ebp)
  800617:	ff d7                	call   *%edi
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	eb eb                	jmp    800609 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80061e:	83 ec 0c             	sub    $0xc,%esp
  800621:	ff 75 18             	pushl  0x18(%ebp)
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80062a:	53                   	push   %ebx
  80062b:	ff 75 10             	pushl  0x10(%ebp)
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	ff 75 e4             	pushl  -0x1c(%ebp)
  800634:	ff 75 e0             	pushl  -0x20(%ebp)
  800637:	ff 75 dc             	pushl  -0x24(%ebp)
  80063a:	ff 75 d8             	pushl  -0x28(%ebp)
  80063d:	e8 2e 27 00 00       	call   802d70 <__udivdi3>
  800642:	83 c4 18             	add    $0x18,%esp
  800645:	52                   	push   %edx
  800646:	50                   	push   %eax
  800647:	89 f2                	mov    %esi,%edx
  800649:	89 f8                	mov    %edi,%eax
  80064b:	e8 85 ff ff ff       	call   8005d5 <printnum>
  800650:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800653:	83 ec 08             	sub    $0x8,%esp
  800656:	56                   	push   %esi
  800657:	83 ec 04             	sub    $0x4,%esp
  80065a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80065d:	ff 75 e0             	pushl  -0x20(%ebp)
  800660:	ff 75 dc             	pushl  -0x24(%ebp)
  800663:	ff 75 d8             	pushl  -0x28(%ebp)
  800666:	e8 15 28 00 00       	call   802e80 <__umoddi3>
  80066b:	83 c4 14             	add    $0x14,%esp
  80066e:	0f be 80 2f 31 80 00 	movsbl 0x80312f(%eax),%eax
  800675:	50                   	push   %eax
  800676:	ff d7                	call   *%edi
}
  800678:	83 c4 10             	add    $0x10,%esp
  80067b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80067e:	5b                   	pop    %ebx
  80067f:	5e                   	pop    %esi
  800680:	5f                   	pop    %edi
  800681:	5d                   	pop    %ebp
  800682:	c3                   	ret    

00800683 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
  800686:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800689:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80068d:	8b 10                	mov    (%eax),%edx
  80068f:	3b 50 04             	cmp    0x4(%eax),%edx
  800692:	73 0a                	jae    80069e <sprintputch+0x1b>
		*b->buf++ = ch;
  800694:	8d 4a 01             	lea    0x1(%edx),%ecx
  800697:	89 08                	mov    %ecx,(%eax)
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	88 02                	mov    %al,(%edx)
}
  80069e:	5d                   	pop    %ebp
  80069f:	c3                   	ret    

008006a0 <printfmt>:
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
  8006a3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006a6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006a9:	50                   	push   %eax
  8006aa:	ff 75 10             	pushl  0x10(%ebp)
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	ff 75 08             	pushl  0x8(%ebp)
  8006b3:	e8 05 00 00 00       	call   8006bd <vprintfmt>
}
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	c9                   	leave  
  8006bc:	c3                   	ret    

008006bd <vprintfmt>:
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	57                   	push   %edi
  8006c1:	56                   	push   %esi
  8006c2:	53                   	push   %ebx
  8006c3:	83 ec 3c             	sub    $0x3c,%esp
  8006c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8006c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006cc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006cf:	eb 0a                	jmp    8006db <vprintfmt+0x1e>
			putch(ch, putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	53                   	push   %ebx
  8006d5:	50                   	push   %eax
  8006d6:	ff d6                	call   *%esi
  8006d8:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006db:	83 c7 01             	add    $0x1,%edi
  8006de:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e2:	83 f8 25             	cmp    $0x25,%eax
  8006e5:	74 0c                	je     8006f3 <vprintfmt+0x36>
			if (ch == '\0')
  8006e7:	85 c0                	test   %eax,%eax
  8006e9:	75 e6                	jne    8006d1 <vprintfmt+0x14>
}
  8006eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006ee:	5b                   	pop    %ebx
  8006ef:	5e                   	pop    %esi
  8006f0:	5f                   	pop    %edi
  8006f1:	5d                   	pop    %ebp
  8006f2:	c3                   	ret    
		padc = ' ';
  8006f3:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8006f7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8006fe:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800705:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80070c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800711:	8d 47 01             	lea    0x1(%edi),%eax
  800714:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800717:	0f b6 17             	movzbl (%edi),%edx
  80071a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80071d:	3c 55                	cmp    $0x55,%al
  80071f:	0f 87 ba 03 00 00    	ja     800adf <vprintfmt+0x422>
  800725:	0f b6 c0             	movzbl %al,%eax
  800728:	ff 24 85 80 32 80 00 	jmp    *0x803280(,%eax,4)
  80072f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800732:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800736:	eb d9                	jmp    800711 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800738:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80073b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80073f:	eb d0                	jmp    800711 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800741:	0f b6 d2             	movzbl %dl,%edx
  800744:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80074f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800752:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800756:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800759:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80075c:	83 f9 09             	cmp    $0x9,%ecx
  80075f:	77 55                	ja     8007b6 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800761:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800764:	eb e9                	jmp    80074f <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8d 40 04             	lea    0x4(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800777:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80077a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80077e:	79 91                	jns    800711 <vprintfmt+0x54>
				width = precision, precision = -1;
  800780:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800783:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800786:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80078d:	eb 82                	jmp    800711 <vprintfmt+0x54>
  80078f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800792:	85 c0                	test   %eax,%eax
  800794:	ba 00 00 00 00       	mov    $0x0,%edx
  800799:	0f 49 d0             	cmovns %eax,%edx
  80079c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80079f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007a2:	e9 6a ff ff ff       	jmp    800711 <vprintfmt+0x54>
  8007a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007aa:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8007b1:	e9 5b ff ff ff       	jmp    800711 <vprintfmt+0x54>
  8007b6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bc:	eb bc                	jmp    80077a <vprintfmt+0xbd>
			lflag++;
  8007be:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007c4:	e9 48 ff ff ff       	jmp    800711 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8d 78 04             	lea    0x4(%eax),%edi
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	53                   	push   %ebx
  8007d3:	ff 30                	pushl  (%eax)
  8007d5:	ff d6                	call   *%esi
			break;
  8007d7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007da:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007dd:	e9 9c 02 00 00       	jmp    800a7e <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8d 78 04             	lea    0x4(%eax),%edi
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	99                   	cltd   
  8007eb:	31 d0                	xor    %edx,%eax
  8007ed:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007ef:	83 f8 0f             	cmp    $0xf,%eax
  8007f2:	7f 23                	jg     800817 <vprintfmt+0x15a>
  8007f4:	8b 14 85 e0 33 80 00 	mov    0x8033e0(,%eax,4),%edx
  8007fb:	85 d2                	test   %edx,%edx
  8007fd:	74 18                	je     800817 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8007ff:	52                   	push   %edx
  800800:	68 7e 36 80 00       	push   $0x80367e
  800805:	53                   	push   %ebx
  800806:	56                   	push   %esi
  800807:	e8 94 fe ff ff       	call   8006a0 <printfmt>
  80080c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80080f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800812:	e9 67 02 00 00       	jmp    800a7e <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800817:	50                   	push   %eax
  800818:	68 47 31 80 00       	push   $0x803147
  80081d:	53                   	push   %ebx
  80081e:	56                   	push   %esi
  80081f:	e8 7c fe ff ff       	call   8006a0 <printfmt>
  800824:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800827:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80082a:	e9 4f 02 00 00       	jmp    800a7e <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	83 c0 04             	add    $0x4,%eax
  800835:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80083d:	85 d2                	test   %edx,%edx
  80083f:	b8 40 31 80 00       	mov    $0x803140,%eax
  800844:	0f 45 c2             	cmovne %edx,%eax
  800847:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80084a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80084e:	7e 06                	jle    800856 <vprintfmt+0x199>
  800850:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800854:	75 0d                	jne    800863 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800856:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800859:	89 c7                	mov    %eax,%edi
  80085b:	03 45 e0             	add    -0x20(%ebp),%eax
  80085e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800861:	eb 3f                	jmp    8008a2 <vprintfmt+0x1e5>
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 d8             	pushl  -0x28(%ebp)
  800869:	50                   	push   %eax
  80086a:	e8 0d 03 00 00       	call   800b7c <strnlen>
  80086f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800872:	29 c2                	sub    %eax,%edx
  800874:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800877:	83 c4 10             	add    $0x10,%esp
  80087a:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80087c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800880:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800883:	85 ff                	test   %edi,%edi
  800885:	7e 58                	jle    8008df <vprintfmt+0x222>
					putch(padc, putdat);
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	53                   	push   %ebx
  80088b:	ff 75 e0             	pushl  -0x20(%ebp)
  80088e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800890:	83 ef 01             	sub    $0x1,%edi
  800893:	83 c4 10             	add    $0x10,%esp
  800896:	eb eb                	jmp    800883 <vprintfmt+0x1c6>
					putch(ch, putdat);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	53                   	push   %ebx
  80089c:	52                   	push   %edx
  80089d:	ff d6                	call   *%esi
  80089f:	83 c4 10             	add    $0x10,%esp
  8008a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008a5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008a7:	83 c7 01             	add    $0x1,%edi
  8008aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ae:	0f be d0             	movsbl %al,%edx
  8008b1:	85 d2                	test   %edx,%edx
  8008b3:	74 45                	je     8008fa <vprintfmt+0x23d>
  8008b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008b9:	78 06                	js     8008c1 <vprintfmt+0x204>
  8008bb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008bf:	78 35                	js     8008f6 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8008c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008c5:	74 d1                	je     800898 <vprintfmt+0x1db>
  8008c7:	0f be c0             	movsbl %al,%eax
  8008ca:	83 e8 20             	sub    $0x20,%eax
  8008cd:	83 f8 5e             	cmp    $0x5e,%eax
  8008d0:	76 c6                	jbe    800898 <vprintfmt+0x1db>
					putch('?', putdat);
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	53                   	push   %ebx
  8008d6:	6a 3f                	push   $0x3f
  8008d8:	ff d6                	call   *%esi
  8008da:	83 c4 10             	add    $0x10,%esp
  8008dd:	eb c3                	jmp    8008a2 <vprintfmt+0x1e5>
  8008df:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008e2:	85 d2                	test   %edx,%edx
  8008e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e9:	0f 49 c2             	cmovns %edx,%eax
  8008ec:	29 c2                	sub    %eax,%edx
  8008ee:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8008f1:	e9 60 ff ff ff       	jmp    800856 <vprintfmt+0x199>
  8008f6:	89 cf                	mov    %ecx,%edi
  8008f8:	eb 02                	jmp    8008fc <vprintfmt+0x23f>
  8008fa:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8008fc:	85 ff                	test   %edi,%edi
  8008fe:	7e 10                	jle    800910 <vprintfmt+0x253>
				putch(' ', putdat);
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	53                   	push   %ebx
  800904:	6a 20                	push   $0x20
  800906:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800908:	83 ef 01             	sub    $0x1,%edi
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	eb ec                	jmp    8008fc <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800910:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800913:	89 45 14             	mov    %eax,0x14(%ebp)
  800916:	e9 63 01 00 00       	jmp    800a7e <vprintfmt+0x3c1>
	if (lflag >= 2)
  80091b:	83 f9 01             	cmp    $0x1,%ecx
  80091e:	7f 1b                	jg     80093b <vprintfmt+0x27e>
	else if (lflag)
  800920:	85 c9                	test   %ecx,%ecx
  800922:	74 63                	je     800987 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800924:	8b 45 14             	mov    0x14(%ebp),%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092c:	99                   	cltd   
  80092d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8d 40 04             	lea    0x4(%eax),%eax
  800936:	89 45 14             	mov    %eax,0x14(%ebp)
  800939:	eb 17                	jmp    800952 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	8b 50 04             	mov    0x4(%eax),%edx
  800941:	8b 00                	mov    (%eax),%eax
  800943:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800946:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	8d 40 08             	lea    0x8(%eax),%eax
  80094f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800952:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800955:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800958:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80095d:	85 c9                	test   %ecx,%ecx
  80095f:	0f 89 ff 00 00 00    	jns    800a64 <vprintfmt+0x3a7>
				putch('-', putdat);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	53                   	push   %ebx
  800969:	6a 2d                	push   $0x2d
  80096b:	ff d6                	call   *%esi
				num = -(long long) num;
  80096d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800970:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800973:	f7 da                	neg    %edx
  800975:	83 d1 00             	adc    $0x0,%ecx
  800978:	f7 d9                	neg    %ecx
  80097a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80097d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800982:	e9 dd 00 00 00       	jmp    800a64 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800987:	8b 45 14             	mov    0x14(%ebp),%eax
  80098a:	8b 00                	mov    (%eax),%eax
  80098c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80098f:	99                   	cltd   
  800990:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	8d 40 04             	lea    0x4(%eax),%eax
  800999:	89 45 14             	mov    %eax,0x14(%ebp)
  80099c:	eb b4                	jmp    800952 <vprintfmt+0x295>
	if (lflag >= 2)
  80099e:	83 f9 01             	cmp    $0x1,%ecx
  8009a1:	7f 1e                	jg     8009c1 <vprintfmt+0x304>
	else if (lflag)
  8009a3:	85 c9                	test   %ecx,%ecx
  8009a5:	74 32                	je     8009d9 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	8b 10                	mov    (%eax),%edx
  8009ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009b1:	8d 40 04             	lea    0x4(%eax),%eax
  8009b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009bc:	e9 a3 00 00 00       	jmp    800a64 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8009c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c4:	8b 10                	mov    (%eax),%edx
  8009c6:	8b 48 04             	mov    0x4(%eax),%ecx
  8009c9:	8d 40 08             	lea    0x8(%eax),%eax
  8009cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d4:	e9 8b 00 00 00       	jmp    800a64 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8009d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dc:	8b 10                	mov    (%eax),%edx
  8009de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009e3:	8d 40 04             	lea    0x4(%eax),%eax
  8009e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ee:	eb 74                	jmp    800a64 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8009f0:	83 f9 01             	cmp    $0x1,%ecx
  8009f3:	7f 1b                	jg     800a10 <vprintfmt+0x353>
	else if (lflag)
  8009f5:	85 c9                	test   %ecx,%ecx
  8009f7:	74 2c                	je     800a25 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8009f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fc:	8b 10                	mov    (%eax),%edx
  8009fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a03:	8d 40 04             	lea    0x4(%eax),%eax
  800a06:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a09:	b8 08 00 00 00       	mov    $0x8,%eax
  800a0e:	eb 54                	jmp    800a64 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	8b 10                	mov    (%eax),%edx
  800a15:	8b 48 04             	mov    0x4(%eax),%ecx
  800a18:	8d 40 08             	lea    0x8(%eax),%eax
  800a1b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a1e:	b8 08 00 00 00       	mov    $0x8,%eax
  800a23:	eb 3f                	jmp    800a64 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	8b 10                	mov    (%eax),%edx
  800a2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a2f:	8d 40 04             	lea    0x4(%eax),%eax
  800a32:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a35:	b8 08 00 00 00       	mov    $0x8,%eax
  800a3a:	eb 28                	jmp    800a64 <vprintfmt+0x3a7>
			putch('0', putdat);
  800a3c:	83 ec 08             	sub    $0x8,%esp
  800a3f:	53                   	push   %ebx
  800a40:	6a 30                	push   $0x30
  800a42:	ff d6                	call   *%esi
			putch('x', putdat);
  800a44:	83 c4 08             	add    $0x8,%esp
  800a47:	53                   	push   %ebx
  800a48:	6a 78                	push   $0x78
  800a4a:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	8b 10                	mov    (%eax),%edx
  800a51:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a56:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a59:	8d 40 04             	lea    0x4(%eax),%eax
  800a5c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a5f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a64:	83 ec 0c             	sub    $0xc,%esp
  800a67:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800a6b:	57                   	push   %edi
  800a6c:	ff 75 e0             	pushl  -0x20(%ebp)
  800a6f:	50                   	push   %eax
  800a70:	51                   	push   %ecx
  800a71:	52                   	push   %edx
  800a72:	89 da                	mov    %ebx,%edx
  800a74:	89 f0                	mov    %esi,%eax
  800a76:	e8 5a fb ff ff       	call   8005d5 <printnum>
			break;
  800a7b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a7e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a81:	e9 55 fc ff ff       	jmp    8006db <vprintfmt+0x1e>
	if (lflag >= 2)
  800a86:	83 f9 01             	cmp    $0x1,%ecx
  800a89:	7f 1b                	jg     800aa6 <vprintfmt+0x3e9>
	else if (lflag)
  800a8b:	85 c9                	test   %ecx,%ecx
  800a8d:	74 2c                	je     800abb <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	8b 10                	mov    (%eax),%edx
  800a94:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a99:	8d 40 04             	lea    0x4(%eax),%eax
  800a9c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a9f:	b8 10 00 00 00       	mov    $0x10,%eax
  800aa4:	eb be                	jmp    800a64 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	8b 10                	mov    (%eax),%edx
  800aab:	8b 48 04             	mov    0x4(%eax),%ecx
  800aae:	8d 40 08             	lea    0x8(%eax),%eax
  800ab1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ab4:	b8 10 00 00 00       	mov    $0x10,%eax
  800ab9:	eb a9                	jmp    800a64 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800abb:	8b 45 14             	mov    0x14(%ebp),%eax
  800abe:	8b 10                	mov    (%eax),%edx
  800ac0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ac5:	8d 40 04             	lea    0x4(%eax),%eax
  800ac8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800acb:	b8 10 00 00 00       	mov    $0x10,%eax
  800ad0:	eb 92                	jmp    800a64 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	53                   	push   %ebx
  800ad6:	6a 25                	push   $0x25
  800ad8:	ff d6                	call   *%esi
			break;
  800ada:	83 c4 10             	add    $0x10,%esp
  800add:	eb 9f                	jmp    800a7e <vprintfmt+0x3c1>
			putch('%', putdat);
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	53                   	push   %ebx
  800ae3:	6a 25                	push   $0x25
  800ae5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 f8                	mov    %edi,%eax
  800aec:	eb 03                	jmp    800af1 <vprintfmt+0x434>
  800aee:	83 e8 01             	sub    $0x1,%eax
  800af1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800af5:	75 f7                	jne    800aee <vprintfmt+0x431>
  800af7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800afa:	eb 82                	jmp    800a7e <vprintfmt+0x3c1>

00800afc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 18             	sub    $0x18,%esp
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b08:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b0b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b0f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b19:	85 c0                	test   %eax,%eax
  800b1b:	74 26                	je     800b43 <vsnprintf+0x47>
  800b1d:	85 d2                	test   %edx,%edx
  800b1f:	7e 22                	jle    800b43 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b21:	ff 75 14             	pushl  0x14(%ebp)
  800b24:	ff 75 10             	pushl  0x10(%ebp)
  800b27:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b2a:	50                   	push   %eax
  800b2b:	68 83 06 80 00       	push   $0x800683
  800b30:	e8 88 fb ff ff       	call   8006bd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b38:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b3e:	83 c4 10             	add    $0x10,%esp
}
  800b41:	c9                   	leave  
  800b42:	c3                   	ret    
		return -E_INVAL;
  800b43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b48:	eb f7                	jmp    800b41 <vsnprintf+0x45>

00800b4a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b50:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b53:	50                   	push   %eax
  800b54:	ff 75 10             	pushl  0x10(%ebp)
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	ff 75 08             	pushl  0x8(%ebp)
  800b5d:	e8 9a ff ff ff       	call   800afc <vsnprintf>
	va_end(ap);

	return rc;
}
  800b62:	c9                   	leave  
  800b63:	c3                   	ret    

00800b64 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b73:	74 05                	je     800b7a <strlen+0x16>
		n++;
  800b75:	83 c0 01             	add    $0x1,%eax
  800b78:	eb f5                	jmp    800b6f <strlen+0xb>
	return n;
}
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b85:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8a:	39 c2                	cmp    %eax,%edx
  800b8c:	74 0d                	je     800b9b <strnlen+0x1f>
  800b8e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b92:	74 05                	je     800b99 <strnlen+0x1d>
		n++;
  800b94:	83 c2 01             	add    $0x1,%edx
  800b97:	eb f1                	jmp    800b8a <strnlen+0xe>
  800b99:	89 d0                	mov    %edx,%eax
	return n;
}
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	53                   	push   %ebx
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ba7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bac:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bb0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bb3:	83 c2 01             	add    $0x1,%edx
  800bb6:	84 c9                	test   %cl,%cl
  800bb8:	75 f2                	jne    800bac <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bba:	5b                   	pop    %ebx
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    

00800bbd <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	53                   	push   %ebx
  800bc1:	83 ec 10             	sub    $0x10,%esp
  800bc4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bc7:	53                   	push   %ebx
  800bc8:	e8 97 ff ff ff       	call   800b64 <strlen>
  800bcd:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	01 d8                	add    %ebx,%eax
  800bd5:	50                   	push   %eax
  800bd6:	e8 c2 ff ff ff       	call   800b9d <strcpy>
	return dst;
}
  800bdb:	89 d8                	mov    %ebx,%eax
  800bdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	56                   	push   %esi
  800be6:	53                   	push   %ebx
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bed:	89 c6                	mov    %eax,%esi
  800bef:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bf2:	89 c2                	mov    %eax,%edx
  800bf4:	39 f2                	cmp    %esi,%edx
  800bf6:	74 11                	je     800c09 <strncpy+0x27>
		*dst++ = *src;
  800bf8:	83 c2 01             	add    $0x1,%edx
  800bfb:	0f b6 19             	movzbl (%ecx),%ebx
  800bfe:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c01:	80 fb 01             	cmp    $0x1,%bl
  800c04:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c07:	eb eb                	jmp    800bf4 <strncpy+0x12>
	}
	return ret;
}
  800c09:	5b                   	pop    %ebx
  800c0a:	5e                   	pop    %esi
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
  800c12:	8b 75 08             	mov    0x8(%ebp),%esi
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c18:	8b 55 10             	mov    0x10(%ebp),%edx
  800c1b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c1d:	85 d2                	test   %edx,%edx
  800c1f:	74 21                	je     800c42 <strlcpy+0x35>
  800c21:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c25:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c27:	39 c2                	cmp    %eax,%edx
  800c29:	74 14                	je     800c3f <strlcpy+0x32>
  800c2b:	0f b6 19             	movzbl (%ecx),%ebx
  800c2e:	84 db                	test   %bl,%bl
  800c30:	74 0b                	je     800c3d <strlcpy+0x30>
			*dst++ = *src++;
  800c32:	83 c1 01             	add    $0x1,%ecx
  800c35:	83 c2 01             	add    $0x1,%edx
  800c38:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c3b:	eb ea                	jmp    800c27 <strlcpy+0x1a>
  800c3d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c3f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c42:	29 f0                	sub    %esi,%eax
}
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c51:	0f b6 01             	movzbl (%ecx),%eax
  800c54:	84 c0                	test   %al,%al
  800c56:	74 0c                	je     800c64 <strcmp+0x1c>
  800c58:	3a 02                	cmp    (%edx),%al
  800c5a:	75 08                	jne    800c64 <strcmp+0x1c>
		p++, q++;
  800c5c:	83 c1 01             	add    $0x1,%ecx
  800c5f:	83 c2 01             	add    $0x1,%edx
  800c62:	eb ed                	jmp    800c51 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c64:	0f b6 c0             	movzbl %al,%eax
  800c67:	0f b6 12             	movzbl (%edx),%edx
  800c6a:	29 d0                	sub    %edx,%eax
}
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	53                   	push   %ebx
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c78:	89 c3                	mov    %eax,%ebx
  800c7a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c7d:	eb 06                	jmp    800c85 <strncmp+0x17>
		n--, p++, q++;
  800c7f:	83 c0 01             	add    $0x1,%eax
  800c82:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c85:	39 d8                	cmp    %ebx,%eax
  800c87:	74 16                	je     800c9f <strncmp+0x31>
  800c89:	0f b6 08             	movzbl (%eax),%ecx
  800c8c:	84 c9                	test   %cl,%cl
  800c8e:	74 04                	je     800c94 <strncmp+0x26>
  800c90:	3a 0a                	cmp    (%edx),%cl
  800c92:	74 eb                	je     800c7f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c94:	0f b6 00             	movzbl (%eax),%eax
  800c97:	0f b6 12             	movzbl (%edx),%edx
  800c9a:	29 d0                	sub    %edx,%eax
}
  800c9c:	5b                   	pop    %ebx
  800c9d:	5d                   	pop    %ebp
  800c9e:	c3                   	ret    
		return 0;
  800c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca4:	eb f6                	jmp    800c9c <strncmp+0x2e>

00800ca6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cb0:	0f b6 10             	movzbl (%eax),%edx
  800cb3:	84 d2                	test   %dl,%dl
  800cb5:	74 09                	je     800cc0 <strchr+0x1a>
		if (*s == c)
  800cb7:	38 ca                	cmp    %cl,%dl
  800cb9:	74 0a                	je     800cc5 <strchr+0x1f>
	for (; *s; s++)
  800cbb:	83 c0 01             	add    $0x1,%eax
  800cbe:	eb f0                	jmp    800cb0 <strchr+0xa>
			return (char *) s;
	return 0;
  800cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cd1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cd4:	38 ca                	cmp    %cl,%dl
  800cd6:	74 09                	je     800ce1 <strfind+0x1a>
  800cd8:	84 d2                	test   %dl,%dl
  800cda:	74 05                	je     800ce1 <strfind+0x1a>
	for (; *s; s++)
  800cdc:	83 c0 01             	add    $0x1,%eax
  800cdf:	eb f0                	jmp    800cd1 <strfind+0xa>
			break;
	return (char *) s;
}
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
  800ce9:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cec:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cef:	85 c9                	test   %ecx,%ecx
  800cf1:	74 31                	je     800d24 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cf3:	89 f8                	mov    %edi,%eax
  800cf5:	09 c8                	or     %ecx,%eax
  800cf7:	a8 03                	test   $0x3,%al
  800cf9:	75 23                	jne    800d1e <memset+0x3b>
		c &= 0xFF;
  800cfb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cff:	89 d3                	mov    %edx,%ebx
  800d01:	c1 e3 08             	shl    $0x8,%ebx
  800d04:	89 d0                	mov    %edx,%eax
  800d06:	c1 e0 18             	shl    $0x18,%eax
  800d09:	89 d6                	mov    %edx,%esi
  800d0b:	c1 e6 10             	shl    $0x10,%esi
  800d0e:	09 f0                	or     %esi,%eax
  800d10:	09 c2                	or     %eax,%edx
  800d12:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d14:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d17:	89 d0                	mov    %edx,%eax
  800d19:	fc                   	cld    
  800d1a:	f3 ab                	rep stos %eax,%es:(%edi)
  800d1c:	eb 06                	jmp    800d24 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	fc                   	cld    
  800d22:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d24:	89 f8                	mov    %edi,%eax
  800d26:	5b                   	pop    %ebx
  800d27:	5e                   	pop    %esi
  800d28:	5f                   	pop    %edi
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	57                   	push   %edi
  800d2f:	56                   	push   %esi
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d36:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d39:	39 c6                	cmp    %eax,%esi
  800d3b:	73 32                	jae    800d6f <memmove+0x44>
  800d3d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d40:	39 c2                	cmp    %eax,%edx
  800d42:	76 2b                	jbe    800d6f <memmove+0x44>
		s += n;
		d += n;
  800d44:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d47:	89 fe                	mov    %edi,%esi
  800d49:	09 ce                	or     %ecx,%esi
  800d4b:	09 d6                	or     %edx,%esi
  800d4d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d53:	75 0e                	jne    800d63 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d55:	83 ef 04             	sub    $0x4,%edi
  800d58:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d5b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d5e:	fd                   	std    
  800d5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d61:	eb 09                	jmp    800d6c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d63:	83 ef 01             	sub    $0x1,%edi
  800d66:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d69:	fd                   	std    
  800d6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d6c:	fc                   	cld    
  800d6d:	eb 1a                	jmp    800d89 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d6f:	89 c2                	mov    %eax,%edx
  800d71:	09 ca                	or     %ecx,%edx
  800d73:	09 f2                	or     %esi,%edx
  800d75:	f6 c2 03             	test   $0x3,%dl
  800d78:	75 0a                	jne    800d84 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d7a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d7d:	89 c7                	mov    %eax,%edi
  800d7f:	fc                   	cld    
  800d80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d82:	eb 05                	jmp    800d89 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d84:	89 c7                	mov    %eax,%edi
  800d86:	fc                   	cld    
  800d87:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d93:	ff 75 10             	pushl  0x10(%ebp)
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	ff 75 08             	pushl  0x8(%ebp)
  800d9c:	e8 8a ff ff ff       	call   800d2b <memmove>
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dae:	89 c6                	mov    %eax,%esi
  800db0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800db3:	39 f0                	cmp    %esi,%eax
  800db5:	74 1c                	je     800dd3 <memcmp+0x30>
		if (*s1 != *s2)
  800db7:	0f b6 08             	movzbl (%eax),%ecx
  800dba:	0f b6 1a             	movzbl (%edx),%ebx
  800dbd:	38 d9                	cmp    %bl,%cl
  800dbf:	75 08                	jne    800dc9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dc1:	83 c0 01             	add    $0x1,%eax
  800dc4:	83 c2 01             	add    $0x1,%edx
  800dc7:	eb ea                	jmp    800db3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dc9:	0f b6 c1             	movzbl %cl,%eax
  800dcc:	0f b6 db             	movzbl %bl,%ebx
  800dcf:	29 d8                	sub    %ebx,%eax
  800dd1:	eb 05                	jmp    800dd8 <memcmp+0x35>
	}

	return 0;
  800dd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800de5:	89 c2                	mov    %eax,%edx
  800de7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dea:	39 d0                	cmp    %edx,%eax
  800dec:	73 09                	jae    800df7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dee:	38 08                	cmp    %cl,(%eax)
  800df0:	74 05                	je     800df7 <memfind+0x1b>
	for (; s < ends; s++)
  800df2:	83 c0 01             	add    $0x1,%eax
  800df5:	eb f3                	jmp    800dea <memfind+0xe>
			break;
	return (void *) s;
}
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
  800dff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e05:	eb 03                	jmp    800e0a <strtol+0x11>
		s++;
  800e07:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e0a:	0f b6 01             	movzbl (%ecx),%eax
  800e0d:	3c 20                	cmp    $0x20,%al
  800e0f:	74 f6                	je     800e07 <strtol+0xe>
  800e11:	3c 09                	cmp    $0x9,%al
  800e13:	74 f2                	je     800e07 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e15:	3c 2b                	cmp    $0x2b,%al
  800e17:	74 2a                	je     800e43 <strtol+0x4a>
	int neg = 0;
  800e19:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e1e:	3c 2d                	cmp    $0x2d,%al
  800e20:	74 2b                	je     800e4d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e22:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e28:	75 0f                	jne    800e39 <strtol+0x40>
  800e2a:	80 39 30             	cmpb   $0x30,(%ecx)
  800e2d:	74 28                	je     800e57 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e2f:	85 db                	test   %ebx,%ebx
  800e31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e36:	0f 44 d8             	cmove  %eax,%ebx
  800e39:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e41:	eb 50                	jmp    800e93 <strtol+0x9a>
		s++;
  800e43:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e46:	bf 00 00 00 00       	mov    $0x0,%edi
  800e4b:	eb d5                	jmp    800e22 <strtol+0x29>
		s++, neg = 1;
  800e4d:	83 c1 01             	add    $0x1,%ecx
  800e50:	bf 01 00 00 00       	mov    $0x1,%edi
  800e55:	eb cb                	jmp    800e22 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e57:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e5b:	74 0e                	je     800e6b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e5d:	85 db                	test   %ebx,%ebx
  800e5f:	75 d8                	jne    800e39 <strtol+0x40>
		s++, base = 8;
  800e61:	83 c1 01             	add    $0x1,%ecx
  800e64:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e69:	eb ce                	jmp    800e39 <strtol+0x40>
		s += 2, base = 16;
  800e6b:	83 c1 02             	add    $0x2,%ecx
  800e6e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e73:	eb c4                	jmp    800e39 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e75:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e78:	89 f3                	mov    %esi,%ebx
  800e7a:	80 fb 19             	cmp    $0x19,%bl
  800e7d:	77 29                	ja     800ea8 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e7f:	0f be d2             	movsbl %dl,%edx
  800e82:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e85:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e88:	7d 30                	jge    800eba <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e8a:	83 c1 01             	add    $0x1,%ecx
  800e8d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e91:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e93:	0f b6 11             	movzbl (%ecx),%edx
  800e96:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e99:	89 f3                	mov    %esi,%ebx
  800e9b:	80 fb 09             	cmp    $0x9,%bl
  800e9e:	77 d5                	ja     800e75 <strtol+0x7c>
			dig = *s - '0';
  800ea0:	0f be d2             	movsbl %dl,%edx
  800ea3:	83 ea 30             	sub    $0x30,%edx
  800ea6:	eb dd                	jmp    800e85 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ea8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800eab:	89 f3                	mov    %esi,%ebx
  800ead:	80 fb 19             	cmp    $0x19,%bl
  800eb0:	77 08                	ja     800eba <strtol+0xc1>
			dig = *s - 'A' + 10;
  800eb2:	0f be d2             	movsbl %dl,%edx
  800eb5:	83 ea 37             	sub    $0x37,%edx
  800eb8:	eb cb                	jmp    800e85 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebe:	74 05                	je     800ec5 <strtol+0xcc>
		*endptr = (char *) s;
  800ec0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ec3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ec5:	89 c2                	mov    %eax,%edx
  800ec7:	f7 da                	neg    %edx
  800ec9:	85 ff                	test   %edi,%edi
  800ecb:	0f 45 c2             	cmovne %edx,%eax
}
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ede:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee4:	89 c3                	mov    %eax,%ebx
  800ee6:	89 c7                	mov    %eax,%edi
  800ee8:	89 c6                	mov    %eax,%esi
  800eea:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800eec:	5b                   	pop    %ebx
  800eed:	5e                   	pop    %esi
  800eee:	5f                   	pop    %edi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    

00800ef1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	57                   	push   %edi
  800ef5:	56                   	push   %esi
  800ef6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef7:	ba 00 00 00 00       	mov    $0x0,%edx
  800efc:	b8 01 00 00 00       	mov    $0x1,%eax
  800f01:	89 d1                	mov    %edx,%ecx
  800f03:	89 d3                	mov    %edx,%ebx
  800f05:	89 d7                	mov    %edx,%edi
  800f07:	89 d6                	mov    %edx,%esi
  800f09:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	57                   	push   %edi
  800f14:	56                   	push   %esi
  800f15:	53                   	push   %ebx
  800f16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	b8 03 00 00 00       	mov    $0x3,%eax
  800f26:	89 cb                	mov    %ecx,%ebx
  800f28:	89 cf                	mov    %ecx,%edi
  800f2a:	89 ce                	mov    %ecx,%esi
  800f2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	7f 08                	jg     800f3a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3a:	83 ec 0c             	sub    $0xc,%esp
  800f3d:	50                   	push   %eax
  800f3e:	6a 03                	push   $0x3
  800f40:	68 3f 34 80 00       	push   $0x80343f
  800f45:	6a 23                	push   $0x23
  800f47:	68 5c 34 80 00       	push   $0x80345c
  800f4c:	e8 95 f5 ff ff       	call   8004e6 <_panic>

00800f51 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	57                   	push   %edi
  800f55:	56                   	push   %esi
  800f56:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f57:	ba 00 00 00 00       	mov    $0x0,%edx
  800f5c:	b8 02 00 00 00       	mov    $0x2,%eax
  800f61:	89 d1                	mov    %edx,%ecx
  800f63:	89 d3                	mov    %edx,%ebx
  800f65:	89 d7                	mov    %edx,%edi
  800f67:	89 d6                	mov    %edx,%esi
  800f69:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f6b:	5b                   	pop    %ebx
  800f6c:	5e                   	pop    %esi
  800f6d:	5f                   	pop    %edi
  800f6e:	5d                   	pop    %ebp
  800f6f:	c3                   	ret    

00800f70 <sys_yield>:

void
sys_yield(void)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	57                   	push   %edi
  800f74:	56                   	push   %esi
  800f75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f76:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f80:	89 d1                	mov    %edx,%ecx
  800f82:	89 d3                	mov    %edx,%ebx
  800f84:	89 d7                	mov    %edx,%edi
  800f86:	89 d6                	mov    %edx,%esi
  800f88:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f8a:	5b                   	pop    %ebx
  800f8b:	5e                   	pop    %esi
  800f8c:	5f                   	pop    %edi
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    

00800f8f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	57                   	push   %edi
  800f93:	56                   	push   %esi
  800f94:	53                   	push   %ebx
  800f95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f98:	be 00 00 00 00       	mov    $0x0,%esi
  800f9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa3:	b8 04 00 00 00       	mov    $0x4,%eax
  800fa8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fab:	89 f7                	mov    %esi,%edi
  800fad:	cd 30                	int    $0x30
	if(check && ret > 0)
  800faf:	85 c0                	test   %eax,%eax
  800fb1:	7f 08                	jg     800fbb <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb6:	5b                   	pop    %ebx
  800fb7:	5e                   	pop    %esi
  800fb8:	5f                   	pop    %edi
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbb:	83 ec 0c             	sub    $0xc,%esp
  800fbe:	50                   	push   %eax
  800fbf:	6a 04                	push   $0x4
  800fc1:	68 3f 34 80 00       	push   $0x80343f
  800fc6:	6a 23                	push   $0x23
  800fc8:	68 5c 34 80 00       	push   $0x80345c
  800fcd:	e8 14 f5 ff ff       	call   8004e6 <_panic>

00800fd2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	57                   	push   %edi
  800fd6:	56                   	push   %esi
  800fd7:	53                   	push   %ebx
  800fd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe1:	b8 05 00 00 00       	mov    $0x5,%eax
  800fe6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fec:	8b 75 18             	mov    0x18(%ebp),%esi
  800fef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff1:	85 c0                	test   %eax,%eax
  800ff3:	7f 08                	jg     800ffd <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff8:	5b                   	pop    %ebx
  800ff9:	5e                   	pop    %esi
  800ffa:	5f                   	pop    %edi
  800ffb:	5d                   	pop    %ebp
  800ffc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffd:	83 ec 0c             	sub    $0xc,%esp
  801000:	50                   	push   %eax
  801001:	6a 05                	push   $0x5
  801003:	68 3f 34 80 00       	push   $0x80343f
  801008:	6a 23                	push   $0x23
  80100a:	68 5c 34 80 00       	push   $0x80345c
  80100f:	e8 d2 f4 ff ff       	call   8004e6 <_panic>

00801014 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	57                   	push   %edi
  801018:	56                   	push   %esi
  801019:	53                   	push   %ebx
  80101a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80101d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801022:	8b 55 08             	mov    0x8(%ebp),%edx
  801025:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801028:	b8 06 00 00 00       	mov    $0x6,%eax
  80102d:	89 df                	mov    %ebx,%edi
  80102f:	89 de                	mov    %ebx,%esi
  801031:	cd 30                	int    $0x30
	if(check && ret > 0)
  801033:	85 c0                	test   %eax,%eax
  801035:	7f 08                	jg     80103f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801037:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103a:	5b                   	pop    %ebx
  80103b:	5e                   	pop    %esi
  80103c:	5f                   	pop    %edi
  80103d:	5d                   	pop    %ebp
  80103e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80103f:	83 ec 0c             	sub    $0xc,%esp
  801042:	50                   	push   %eax
  801043:	6a 06                	push   $0x6
  801045:	68 3f 34 80 00       	push   $0x80343f
  80104a:	6a 23                	push   $0x23
  80104c:	68 5c 34 80 00       	push   $0x80345c
  801051:	e8 90 f4 ff ff       	call   8004e6 <_panic>

00801056 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	57                   	push   %edi
  80105a:	56                   	push   %esi
  80105b:	53                   	push   %ebx
  80105c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80105f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801064:	8b 55 08             	mov    0x8(%ebp),%edx
  801067:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106a:	b8 08 00 00 00       	mov    $0x8,%eax
  80106f:	89 df                	mov    %ebx,%edi
  801071:	89 de                	mov    %ebx,%esi
  801073:	cd 30                	int    $0x30
	if(check && ret > 0)
  801075:	85 c0                	test   %eax,%eax
  801077:	7f 08                	jg     801081 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801079:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80107c:	5b                   	pop    %ebx
  80107d:	5e                   	pop    %esi
  80107e:	5f                   	pop    %edi
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801081:	83 ec 0c             	sub    $0xc,%esp
  801084:	50                   	push   %eax
  801085:	6a 08                	push   $0x8
  801087:	68 3f 34 80 00       	push   $0x80343f
  80108c:	6a 23                	push   $0x23
  80108e:	68 5c 34 80 00       	push   $0x80345c
  801093:	e8 4e f4 ff ff       	call   8004e6 <_panic>

00801098 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	57                   	push   %edi
  80109c:	56                   	push   %esi
  80109d:	53                   	push   %ebx
  80109e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ac:	b8 09 00 00 00       	mov    $0x9,%eax
  8010b1:	89 df                	mov    %ebx,%edi
  8010b3:	89 de                	mov    %ebx,%esi
  8010b5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b7:	85 c0                	test   %eax,%eax
  8010b9:	7f 08                	jg     8010c3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010be:	5b                   	pop    %ebx
  8010bf:	5e                   	pop    %esi
  8010c0:	5f                   	pop    %edi
  8010c1:	5d                   	pop    %ebp
  8010c2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c3:	83 ec 0c             	sub    $0xc,%esp
  8010c6:	50                   	push   %eax
  8010c7:	6a 09                	push   $0x9
  8010c9:	68 3f 34 80 00       	push   $0x80343f
  8010ce:	6a 23                	push   $0x23
  8010d0:	68 5c 34 80 00       	push   $0x80345c
  8010d5:	e8 0c f4 ff ff       	call   8004e6 <_panic>

008010da <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	57                   	push   %edi
  8010de:	56                   	push   %esi
  8010df:	53                   	push   %ebx
  8010e0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ee:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010f3:	89 df                	mov    %ebx,%edi
  8010f5:	89 de                	mov    %ebx,%esi
  8010f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	7f 08                	jg     801105 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801100:	5b                   	pop    %ebx
  801101:	5e                   	pop    %esi
  801102:	5f                   	pop    %edi
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801105:	83 ec 0c             	sub    $0xc,%esp
  801108:	50                   	push   %eax
  801109:	6a 0a                	push   $0xa
  80110b:	68 3f 34 80 00       	push   $0x80343f
  801110:	6a 23                	push   $0x23
  801112:	68 5c 34 80 00       	push   $0x80345c
  801117:	e8 ca f3 ff ff       	call   8004e6 <_panic>

0080111c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	57                   	push   %edi
  801120:	56                   	push   %esi
  801121:	53                   	push   %ebx
	asm volatile("int %1\n"
  801122:	8b 55 08             	mov    0x8(%ebp),%edx
  801125:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801128:	b8 0c 00 00 00       	mov    $0xc,%eax
  80112d:	be 00 00 00 00       	mov    $0x0,%esi
  801132:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801135:	8b 7d 14             	mov    0x14(%ebp),%edi
  801138:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80113a:	5b                   	pop    %ebx
  80113b:	5e                   	pop    %esi
  80113c:	5f                   	pop    %edi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    

0080113f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	57                   	push   %edi
  801143:	56                   	push   %esi
  801144:	53                   	push   %ebx
  801145:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801148:	b9 00 00 00 00       	mov    $0x0,%ecx
  80114d:	8b 55 08             	mov    0x8(%ebp),%edx
  801150:	b8 0d 00 00 00       	mov    $0xd,%eax
  801155:	89 cb                	mov    %ecx,%ebx
  801157:	89 cf                	mov    %ecx,%edi
  801159:	89 ce                	mov    %ecx,%esi
  80115b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80115d:	85 c0                	test   %eax,%eax
  80115f:	7f 08                	jg     801169 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801161:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801164:	5b                   	pop    %ebx
  801165:	5e                   	pop    %esi
  801166:	5f                   	pop    %edi
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801169:	83 ec 0c             	sub    $0xc,%esp
  80116c:	50                   	push   %eax
  80116d:	6a 0d                	push   $0xd
  80116f:	68 3f 34 80 00       	push   $0x80343f
  801174:	6a 23                	push   $0x23
  801176:	68 5c 34 80 00       	push   $0x80345c
  80117b:	e8 66 f3 ff ff       	call   8004e6 <_panic>

00801180 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	57                   	push   %edi
  801184:	56                   	push   %esi
  801185:	53                   	push   %ebx
	asm volatile("int %1\n"
  801186:	ba 00 00 00 00       	mov    $0x0,%edx
  80118b:	b8 0e 00 00 00       	mov    $0xe,%eax
  801190:	89 d1                	mov    %edx,%ecx
  801192:	89 d3                	mov    %edx,%ebx
  801194:	89 d7                	mov    %edx,%edi
  801196:	89 d6                	mov    %edx,%esi
  801198:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80119a:	5b                   	pop    %ebx
  80119b:	5e                   	pop    %esi
  80119c:	5f                   	pop    %edi
  80119d:	5d                   	pop    %ebp
  80119e:	c3                   	ret    

0080119f <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	57                   	push   %edi
  8011a3:	56                   	push   %esi
  8011a4:	53                   	push   %ebx
  8011a5:	83 ec 0c             	sub    $0xc,%esp
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8011ab:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  8011ad:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  8011b0:	89 d9                	mov    %ebx,%ecx
  8011b2:	c1 e9 16             	shr    $0x16,%ecx
  8011b5:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  8011bc:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  8011c1:	f6 c1 01             	test   $0x1,%cl
  8011c4:	74 0c                	je     8011d2 <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  8011c6:	89 d9                	mov    %ebx,%ecx
  8011c8:	c1 e9 0c             	shr    $0xc,%ecx
  8011cb:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  8011d2:	f6 c2 02             	test   $0x2,%dl
  8011d5:	0f 84 a3 00 00 00    	je     80127e <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  8011db:	89 da                	mov    %ebx,%edx
  8011dd:	c1 ea 0c             	shr    $0xc,%edx
  8011e0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011e7:	f6 c6 08             	test   $0x8,%dh
  8011ea:	0f 84 b7 00 00 00    	je     8012a7 <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  8011f0:	e8 5c fd ff ff       	call   800f51 <sys_getenvid>
  8011f5:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  8011f7:	83 ec 04             	sub    $0x4,%esp
  8011fa:	6a 07                	push   $0x7
  8011fc:	68 00 f0 7f 00       	push   $0x7ff000
  801201:	50                   	push   %eax
  801202:	e8 88 fd ff ff       	call   800f8f <sys_page_alloc>
  801207:	83 c4 10             	add    $0x10,%esp
  80120a:	85 c0                	test   %eax,%eax
  80120c:	0f 88 bc 00 00 00    	js     8012ce <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  801212:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  801218:	83 ec 04             	sub    $0x4,%esp
  80121b:	68 00 10 00 00       	push   $0x1000
  801220:	53                   	push   %ebx
  801221:	68 00 f0 7f 00       	push   $0x7ff000
  801226:	e8 00 fb ff ff       	call   800d2b <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  80122b:	83 c4 08             	add    $0x8,%esp
  80122e:	53                   	push   %ebx
  80122f:	56                   	push   %esi
  801230:	e8 df fd ff ff       	call   801014 <sys_page_unmap>
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	0f 88 a0 00 00 00    	js     8012e0 <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  801240:	83 ec 0c             	sub    $0xc,%esp
  801243:	6a 07                	push   $0x7
  801245:	53                   	push   %ebx
  801246:	56                   	push   %esi
  801247:	68 00 f0 7f 00       	push   $0x7ff000
  80124c:	56                   	push   %esi
  80124d:	e8 80 fd ff ff       	call   800fd2 <sys_page_map>
  801252:	83 c4 20             	add    $0x20,%esp
  801255:	85 c0                	test   %eax,%eax
  801257:	0f 88 95 00 00 00    	js     8012f2 <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  80125d:	83 ec 08             	sub    $0x8,%esp
  801260:	68 00 f0 7f 00       	push   $0x7ff000
  801265:	56                   	push   %esi
  801266:	e8 a9 fd ff ff       	call   801014 <sys_page_unmap>
  80126b:	83 c4 10             	add    $0x10,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	0f 88 8e 00 00 00    	js     801304 <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  801276:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801279:	5b                   	pop    %ebx
  80127a:	5e                   	pop    %esi
  80127b:	5f                   	pop    %edi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  80127e:	8b 70 28             	mov    0x28(%eax),%esi
  801281:	e8 cb fc ff ff       	call   800f51 <sys_getenvid>
  801286:	56                   	push   %esi
  801287:	53                   	push   %ebx
  801288:	50                   	push   %eax
  801289:	68 6c 34 80 00       	push   $0x80346c
  80128e:	e8 2e f3 ff ff       	call   8005c1 <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  801293:	83 c4 0c             	add    $0xc,%esp
  801296:	68 90 34 80 00       	push   $0x803490
  80129b:	6a 27                	push   $0x27
  80129d:	68 64 35 80 00       	push   $0x803564
  8012a2:	e8 3f f2 ff ff       	call   8004e6 <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  8012a7:	8b 78 28             	mov    0x28(%eax),%edi
  8012aa:	e8 a2 fc ff ff       	call   800f51 <sys_getenvid>
  8012af:	57                   	push   %edi
  8012b0:	53                   	push   %ebx
  8012b1:	50                   	push   %eax
  8012b2:	68 6c 34 80 00       	push   $0x80346c
  8012b7:	e8 05 f3 ff ff       	call   8005c1 <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  8012bc:	56                   	push   %esi
  8012bd:	68 c4 34 80 00       	push   $0x8034c4
  8012c2:	6a 2b                	push   $0x2b
  8012c4:	68 64 35 80 00       	push   $0x803564
  8012c9:	e8 18 f2 ff ff       	call   8004e6 <_panic>
      panic("pgfault: page allocation failed %e", r);
  8012ce:	50                   	push   %eax
  8012cf:	68 fc 34 80 00       	push   $0x8034fc
  8012d4:	6a 39                	push   $0x39
  8012d6:	68 64 35 80 00       	push   $0x803564
  8012db:	e8 06 f2 ff ff       	call   8004e6 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  8012e0:	50                   	push   %eax
  8012e1:	68 20 35 80 00       	push   $0x803520
  8012e6:	6a 3e                	push   $0x3e
  8012e8:	68 64 35 80 00       	push   $0x803564
  8012ed:	e8 f4 f1 ff ff       	call   8004e6 <_panic>
      panic("pgfault: page map failed (%e)", r);
  8012f2:	50                   	push   %eax
  8012f3:	68 6f 35 80 00       	push   $0x80356f
  8012f8:	6a 40                	push   $0x40
  8012fa:	68 64 35 80 00       	push   $0x803564
  8012ff:	e8 e2 f1 ff ff       	call   8004e6 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  801304:	50                   	push   %eax
  801305:	68 20 35 80 00       	push   $0x803520
  80130a:	6a 42                	push   $0x42
  80130c:	68 64 35 80 00       	push   $0x803564
  801311:	e8 d0 f1 ff ff       	call   8004e6 <_panic>

00801316 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	57                   	push   %edi
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
  80131c:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  80131f:	68 9f 11 80 00       	push   $0x80119f
  801324:	e8 57 18 00 00       	call   802b80 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801329:	b8 07 00 00 00       	mov    $0x7,%eax
  80132e:	cd 30                	int    $0x30
  801330:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	78 2d                	js     801367 <fork+0x51>
  80133a:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80133c:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  801341:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801345:	0f 85 a6 00 00 00    	jne    8013f1 <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  80134b:	e8 01 fc ff ff       	call   800f51 <sys_getenvid>
  801350:	25 ff 03 00 00       	and    $0x3ff,%eax
  801355:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801358:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80135d:	a3 08 50 80 00       	mov    %eax,0x805008
      return 0;
  801362:	e9 79 01 00 00       	jmp    8014e0 <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  801367:	50                   	push   %eax
  801368:	68 85 30 80 00       	push   $0x803085
  80136d:	68 aa 00 00 00       	push   $0xaa
  801372:	68 64 35 80 00       	push   $0x803564
  801377:	e8 6a f1 ff ff       	call   8004e6 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  80137c:	83 ec 0c             	sub    $0xc,%esp
  80137f:	6a 05                	push   $0x5
  801381:	53                   	push   %ebx
  801382:	57                   	push   %edi
  801383:	53                   	push   %ebx
  801384:	6a 00                	push   $0x0
  801386:	e8 47 fc ff ff       	call   800fd2 <sys_page_map>
  80138b:	83 c4 20             	add    $0x20,%esp
  80138e:	85 c0                	test   %eax,%eax
  801390:	79 4d                	jns    8013df <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  801392:	50                   	push   %eax
  801393:	68 8d 35 80 00       	push   $0x80358d
  801398:	6a 61                	push   $0x61
  80139a:	68 64 35 80 00       	push   $0x803564
  80139f:	e8 42 f1 ff ff       	call   8004e6 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  8013a4:	83 ec 0c             	sub    $0xc,%esp
  8013a7:	68 05 08 00 00       	push   $0x805
  8013ac:	53                   	push   %ebx
  8013ad:	57                   	push   %edi
  8013ae:	53                   	push   %ebx
  8013af:	6a 00                	push   $0x0
  8013b1:	e8 1c fc ff ff       	call   800fd2 <sys_page_map>
  8013b6:	83 c4 20             	add    $0x20,%esp
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	0f 88 b7 00 00 00    	js     801478 <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  8013c1:	83 ec 0c             	sub    $0xc,%esp
  8013c4:	68 05 08 00 00       	push   $0x805
  8013c9:	53                   	push   %ebx
  8013ca:	6a 00                	push   $0x0
  8013cc:	53                   	push   %ebx
  8013cd:	6a 00                	push   $0x0
  8013cf:	e8 fe fb ff ff       	call   800fd2 <sys_page_map>
  8013d4:	83 c4 20             	add    $0x20,%esp
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	0f 88 ab 00 00 00    	js     80148a <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8013df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013e5:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8013eb:	0f 84 ab 00 00 00    	je     80149c <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  8013f1:	89 d8                	mov    %ebx,%eax
  8013f3:	c1 e8 16             	shr    $0x16,%eax
  8013f6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013fd:	a8 01                	test   $0x1,%al
  8013ff:	74 de                	je     8013df <fork+0xc9>
  801401:	89 d8                	mov    %ebx,%eax
  801403:	c1 e8 0c             	shr    $0xc,%eax
  801406:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80140d:	f6 c2 01             	test   $0x1,%dl
  801410:	74 cd                	je     8013df <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  801412:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  801415:	89 c2                	mov    %eax,%edx
  801417:	c1 ea 16             	shr    $0x16,%edx
  80141a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801421:	f6 c2 01             	test   $0x1,%dl
  801424:	74 b9                	je     8013df <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  801426:	c1 e8 0c             	shr    $0xc,%eax
  801429:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  801430:	a8 01                	test   $0x1,%al
  801432:	74 ab                	je     8013df <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  801434:	a9 02 08 00 00       	test   $0x802,%eax
  801439:	0f 84 3d ff ff ff    	je     80137c <fork+0x66>
	else if(pte & PTE_SHARE)
  80143f:	f6 c4 04             	test   $0x4,%ah
  801442:	0f 84 5c ff ff ff    	je     8013a4 <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801448:	83 ec 0c             	sub    $0xc,%esp
  80144b:	25 07 0e 00 00       	and    $0xe07,%eax
  801450:	50                   	push   %eax
  801451:	53                   	push   %ebx
  801452:	57                   	push   %edi
  801453:	53                   	push   %ebx
  801454:	6a 00                	push   $0x0
  801456:	e8 77 fb ff ff       	call   800fd2 <sys_page_map>
  80145b:	83 c4 20             	add    $0x20,%esp
  80145e:	85 c0                	test   %eax,%eax
  801460:	0f 89 79 ff ff ff    	jns    8013df <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  801466:	50                   	push   %eax
  801467:	68 8d 35 80 00       	push   $0x80358d
  80146c:	6a 67                	push   $0x67
  80146e:	68 64 35 80 00       	push   $0x803564
  801473:	e8 6e f0 ff ff       	call   8004e6 <_panic>
			panic("Page Map Failed: %e", error_code);
  801478:	50                   	push   %eax
  801479:	68 8d 35 80 00       	push   $0x80358d
  80147e:	6a 6d                	push   $0x6d
  801480:	68 64 35 80 00       	push   $0x803564
  801485:	e8 5c f0 ff ff       	call   8004e6 <_panic>
			panic("Page Map Failed: %e", error_code);
  80148a:	50                   	push   %eax
  80148b:	68 8d 35 80 00       	push   $0x80358d
  801490:	6a 70                	push   $0x70
  801492:	68 64 35 80 00       	push   $0x803564
  801497:	e8 4a f0 ff ff       	call   8004e6 <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  80149c:	83 ec 04             	sub    $0x4,%esp
  80149f:	6a 07                	push   $0x7
  8014a1:	68 00 f0 bf ee       	push   $0xeebff000
  8014a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a9:	e8 e1 fa ff ff       	call   800f8f <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  8014ae:	83 c4 10             	add    $0x10,%esp
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	78 36                	js     8014eb <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  8014b5:	83 ec 08             	sub    $0x8,%esp
  8014b8:	68 f6 2b 80 00       	push   $0x802bf6
  8014bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014c0:	e8 15 fc ff ff       	call   8010da <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	78 34                	js     801500 <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  8014cc:	83 ec 08             	sub    $0x8,%esp
  8014cf:	6a 02                	push   $0x2
  8014d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014d4:	e8 7d fb ff ff       	call   801056 <sys_env_set_status>
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 35                	js     801515 <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  8014e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e6:	5b                   	pop    %ebx
  8014e7:	5e                   	pop    %esi
  8014e8:	5f                   	pop    %edi
  8014e9:	5d                   	pop    %ebp
  8014ea:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  8014eb:	50                   	push   %eax
  8014ec:	68 85 30 80 00       	push   $0x803085
  8014f1:	68 ba 00 00 00       	push   $0xba
  8014f6:	68 64 35 80 00       	push   $0x803564
  8014fb:	e8 e6 ef ff ff       	call   8004e6 <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801500:	50                   	push   %eax
  801501:	68 40 35 80 00       	push   $0x803540
  801506:	68 bf 00 00 00       	push   $0xbf
  80150b:	68 64 35 80 00       	push   $0x803564
  801510:	e8 d1 ef ff ff       	call   8004e6 <_panic>
      panic("sys_env_set_status: %e", r);
  801515:	50                   	push   %eax
  801516:	68 a1 35 80 00       	push   $0x8035a1
  80151b:	68 c3 00 00 00       	push   $0xc3
  801520:	68 64 35 80 00       	push   $0x803564
  801525:	e8 bc ef ff ff       	call   8004e6 <_panic>

0080152a <sfork>:

// Challenge!
int
sfork(void)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801530:	68 b8 35 80 00       	push   $0x8035b8
  801535:	68 cc 00 00 00       	push   $0xcc
  80153a:	68 64 35 80 00       	push   $0x803564
  80153f:	e8 a2 ef ff ff       	call   8004e6 <_panic>

00801544 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	05 00 00 00 30       	add    $0x30000000,%eax
  80154f:	c1 e8 0c             	shr    $0xc,%eax
}
  801552:	5d                   	pop    %ebp
  801553:	c3                   	ret    

00801554 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80155f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801564:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801569:	5d                   	pop    %ebp
  80156a:	c3                   	ret    

0080156b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801573:	89 c2                	mov    %eax,%edx
  801575:	c1 ea 16             	shr    $0x16,%edx
  801578:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80157f:	f6 c2 01             	test   $0x1,%dl
  801582:	74 2d                	je     8015b1 <fd_alloc+0x46>
  801584:	89 c2                	mov    %eax,%edx
  801586:	c1 ea 0c             	shr    $0xc,%edx
  801589:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801590:	f6 c2 01             	test   $0x1,%dl
  801593:	74 1c                	je     8015b1 <fd_alloc+0x46>
  801595:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80159a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80159f:	75 d2                	jne    801573 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015aa:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015af:	eb 0a                	jmp    8015bb <fd_alloc+0x50>
			*fd_store = fd;
  8015b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015b4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015bb:	5d                   	pop    %ebp
  8015bc:	c3                   	ret    

008015bd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015c3:	83 f8 1f             	cmp    $0x1f,%eax
  8015c6:	77 30                	ja     8015f8 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015c8:	c1 e0 0c             	shl    $0xc,%eax
  8015cb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015d0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8015d6:	f6 c2 01             	test   $0x1,%dl
  8015d9:	74 24                	je     8015ff <fd_lookup+0x42>
  8015db:	89 c2                	mov    %eax,%edx
  8015dd:	c1 ea 0c             	shr    $0xc,%edx
  8015e0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015e7:	f6 c2 01             	test   $0x1,%dl
  8015ea:	74 1a                	je     801606 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ef:	89 02                	mov    %eax,(%edx)
	return 0;
  8015f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f6:	5d                   	pop    %ebp
  8015f7:	c3                   	ret    
		return -E_INVAL;
  8015f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015fd:	eb f7                	jmp    8015f6 <fd_lookup+0x39>
		return -E_INVAL;
  8015ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801604:	eb f0                	jmp    8015f6 <fd_lookup+0x39>
  801606:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80160b:	eb e9                	jmp    8015f6 <fd_lookup+0x39>

0080160d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801616:	ba 00 00 00 00       	mov    $0x0,%edx
  80161b:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801620:	39 08                	cmp    %ecx,(%eax)
  801622:	74 38                	je     80165c <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801624:	83 c2 01             	add    $0x1,%edx
  801627:	8b 04 95 4c 36 80 00 	mov    0x80364c(,%edx,4),%eax
  80162e:	85 c0                	test   %eax,%eax
  801630:	75 ee                	jne    801620 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801632:	a1 08 50 80 00       	mov    0x805008,%eax
  801637:	8b 40 48             	mov    0x48(%eax),%eax
  80163a:	83 ec 04             	sub    $0x4,%esp
  80163d:	51                   	push   %ecx
  80163e:	50                   	push   %eax
  80163f:	68 d0 35 80 00       	push   $0x8035d0
  801644:	e8 78 ef ff ff       	call   8005c1 <cprintf>
	*dev = 0;
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    
			*dev = devtab[i];
  80165c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80165f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801661:	b8 00 00 00 00       	mov    $0x0,%eax
  801666:	eb f2                	jmp    80165a <dev_lookup+0x4d>

00801668 <fd_close>:
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	57                   	push   %edi
  80166c:	56                   	push   %esi
  80166d:	53                   	push   %ebx
  80166e:	83 ec 24             	sub    $0x24,%esp
  801671:	8b 75 08             	mov    0x8(%ebp),%esi
  801674:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801677:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80167a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80167b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801681:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801684:	50                   	push   %eax
  801685:	e8 33 ff ff ff       	call   8015bd <fd_lookup>
  80168a:	89 c3                	mov    %eax,%ebx
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	85 c0                	test   %eax,%eax
  801691:	78 05                	js     801698 <fd_close+0x30>
	    || fd != fd2)
  801693:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801696:	74 16                	je     8016ae <fd_close+0x46>
		return (must_exist ? r : 0);
  801698:	89 f8                	mov    %edi,%eax
  80169a:	84 c0                	test   %al,%al
  80169c:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a1:	0f 44 d8             	cmove  %eax,%ebx
}
  8016a4:	89 d8                	mov    %ebx,%eax
  8016a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016a9:	5b                   	pop    %ebx
  8016aa:	5e                   	pop    %esi
  8016ab:	5f                   	pop    %edi
  8016ac:	5d                   	pop    %ebp
  8016ad:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016b4:	50                   	push   %eax
  8016b5:	ff 36                	pushl  (%esi)
  8016b7:	e8 51 ff ff ff       	call   80160d <dev_lookup>
  8016bc:	89 c3                	mov    %eax,%ebx
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	78 1a                	js     8016df <fd_close+0x77>
		if (dev->dev_close)
  8016c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016c8:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8016cb:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	74 0b                	je     8016df <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8016d4:	83 ec 0c             	sub    $0xc,%esp
  8016d7:	56                   	push   %esi
  8016d8:	ff d0                	call   *%eax
  8016da:	89 c3                	mov    %eax,%ebx
  8016dc:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8016df:	83 ec 08             	sub    $0x8,%esp
  8016e2:	56                   	push   %esi
  8016e3:	6a 00                	push   $0x0
  8016e5:	e8 2a f9 ff ff       	call   801014 <sys_page_unmap>
	return r;
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	eb b5                	jmp    8016a4 <fd_close+0x3c>

008016ef <close>:

int
close(int fdnum)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f8:	50                   	push   %eax
  8016f9:	ff 75 08             	pushl  0x8(%ebp)
  8016fc:	e8 bc fe ff ff       	call   8015bd <fd_lookup>
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	85 c0                	test   %eax,%eax
  801706:	79 02                	jns    80170a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    
		return fd_close(fd, 1);
  80170a:	83 ec 08             	sub    $0x8,%esp
  80170d:	6a 01                	push   $0x1
  80170f:	ff 75 f4             	pushl  -0xc(%ebp)
  801712:	e8 51 ff ff ff       	call   801668 <fd_close>
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	eb ec                	jmp    801708 <close+0x19>

0080171c <close_all>:

void
close_all(void)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	53                   	push   %ebx
  801720:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801723:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801728:	83 ec 0c             	sub    $0xc,%esp
  80172b:	53                   	push   %ebx
  80172c:	e8 be ff ff ff       	call   8016ef <close>
	for (i = 0; i < MAXFD; i++)
  801731:	83 c3 01             	add    $0x1,%ebx
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	83 fb 20             	cmp    $0x20,%ebx
  80173a:	75 ec                	jne    801728 <close_all+0xc>
}
  80173c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	57                   	push   %edi
  801745:	56                   	push   %esi
  801746:	53                   	push   %ebx
  801747:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80174a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80174d:	50                   	push   %eax
  80174e:	ff 75 08             	pushl  0x8(%ebp)
  801751:	e8 67 fe ff ff       	call   8015bd <fd_lookup>
  801756:	89 c3                	mov    %eax,%ebx
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	85 c0                	test   %eax,%eax
  80175d:	0f 88 81 00 00 00    	js     8017e4 <dup+0xa3>
		return r;
	close(newfdnum);
  801763:	83 ec 0c             	sub    $0xc,%esp
  801766:	ff 75 0c             	pushl  0xc(%ebp)
  801769:	e8 81 ff ff ff       	call   8016ef <close>

	newfd = INDEX2FD(newfdnum);
  80176e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801771:	c1 e6 0c             	shl    $0xc,%esi
  801774:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80177a:	83 c4 04             	add    $0x4,%esp
  80177d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801780:	e8 cf fd ff ff       	call   801554 <fd2data>
  801785:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801787:	89 34 24             	mov    %esi,(%esp)
  80178a:	e8 c5 fd ff ff       	call   801554 <fd2data>
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801794:	89 d8                	mov    %ebx,%eax
  801796:	c1 e8 16             	shr    $0x16,%eax
  801799:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017a0:	a8 01                	test   $0x1,%al
  8017a2:	74 11                	je     8017b5 <dup+0x74>
  8017a4:	89 d8                	mov    %ebx,%eax
  8017a6:	c1 e8 0c             	shr    $0xc,%eax
  8017a9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017b0:	f6 c2 01             	test   $0x1,%dl
  8017b3:	75 39                	jne    8017ee <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017b8:	89 d0                	mov    %edx,%eax
  8017ba:	c1 e8 0c             	shr    $0xc,%eax
  8017bd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017c4:	83 ec 0c             	sub    $0xc,%esp
  8017c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8017cc:	50                   	push   %eax
  8017cd:	56                   	push   %esi
  8017ce:	6a 00                	push   $0x0
  8017d0:	52                   	push   %edx
  8017d1:	6a 00                	push   $0x0
  8017d3:	e8 fa f7 ff ff       	call   800fd2 <sys_page_map>
  8017d8:	89 c3                	mov    %eax,%ebx
  8017da:	83 c4 20             	add    $0x20,%esp
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 31                	js     801812 <dup+0xd1>
		goto err;

	return newfdnum;
  8017e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8017e4:	89 d8                	mov    %ebx,%eax
  8017e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017e9:	5b                   	pop    %ebx
  8017ea:	5e                   	pop    %esi
  8017eb:	5f                   	pop    %edi
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017ee:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017f5:	83 ec 0c             	sub    $0xc,%esp
  8017f8:	25 07 0e 00 00       	and    $0xe07,%eax
  8017fd:	50                   	push   %eax
  8017fe:	57                   	push   %edi
  8017ff:	6a 00                	push   $0x0
  801801:	53                   	push   %ebx
  801802:	6a 00                	push   $0x0
  801804:	e8 c9 f7 ff ff       	call   800fd2 <sys_page_map>
  801809:	89 c3                	mov    %eax,%ebx
  80180b:	83 c4 20             	add    $0x20,%esp
  80180e:	85 c0                	test   %eax,%eax
  801810:	79 a3                	jns    8017b5 <dup+0x74>
	sys_page_unmap(0, newfd);
  801812:	83 ec 08             	sub    $0x8,%esp
  801815:	56                   	push   %esi
  801816:	6a 00                	push   $0x0
  801818:	e8 f7 f7 ff ff       	call   801014 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80181d:	83 c4 08             	add    $0x8,%esp
  801820:	57                   	push   %edi
  801821:	6a 00                	push   $0x0
  801823:	e8 ec f7 ff ff       	call   801014 <sys_page_unmap>
	return r;
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	eb b7                	jmp    8017e4 <dup+0xa3>

0080182d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	53                   	push   %ebx
  801831:	83 ec 1c             	sub    $0x1c,%esp
  801834:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801837:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80183a:	50                   	push   %eax
  80183b:	53                   	push   %ebx
  80183c:	e8 7c fd ff ff       	call   8015bd <fd_lookup>
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	85 c0                	test   %eax,%eax
  801846:	78 3f                	js     801887 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801848:	83 ec 08             	sub    $0x8,%esp
  80184b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184e:	50                   	push   %eax
  80184f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801852:	ff 30                	pushl  (%eax)
  801854:	e8 b4 fd ff ff       	call   80160d <dev_lookup>
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 27                	js     801887 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801860:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801863:	8b 42 08             	mov    0x8(%edx),%eax
  801866:	83 e0 03             	and    $0x3,%eax
  801869:	83 f8 01             	cmp    $0x1,%eax
  80186c:	74 1e                	je     80188c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801871:	8b 40 08             	mov    0x8(%eax),%eax
  801874:	85 c0                	test   %eax,%eax
  801876:	74 35                	je     8018ad <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801878:	83 ec 04             	sub    $0x4,%esp
  80187b:	ff 75 10             	pushl  0x10(%ebp)
  80187e:	ff 75 0c             	pushl  0xc(%ebp)
  801881:	52                   	push   %edx
  801882:	ff d0                	call   *%eax
  801884:	83 c4 10             	add    $0x10,%esp
}
  801887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80188c:	a1 08 50 80 00       	mov    0x805008,%eax
  801891:	8b 40 48             	mov    0x48(%eax),%eax
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	53                   	push   %ebx
  801898:	50                   	push   %eax
  801899:	68 11 36 80 00       	push   $0x803611
  80189e:	e8 1e ed ff ff       	call   8005c1 <cprintf>
		return -E_INVAL;
  8018a3:	83 c4 10             	add    $0x10,%esp
  8018a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018ab:	eb da                	jmp    801887 <read+0x5a>
		return -E_NOT_SUPP;
  8018ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018b2:	eb d3                	jmp    801887 <read+0x5a>

008018b4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	57                   	push   %edi
  8018b8:	56                   	push   %esi
  8018b9:	53                   	push   %ebx
  8018ba:	83 ec 0c             	sub    $0xc,%esp
  8018bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018c0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018c8:	39 f3                	cmp    %esi,%ebx
  8018ca:	73 23                	jae    8018ef <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018cc:	83 ec 04             	sub    $0x4,%esp
  8018cf:	89 f0                	mov    %esi,%eax
  8018d1:	29 d8                	sub    %ebx,%eax
  8018d3:	50                   	push   %eax
  8018d4:	89 d8                	mov    %ebx,%eax
  8018d6:	03 45 0c             	add    0xc(%ebp),%eax
  8018d9:	50                   	push   %eax
  8018da:	57                   	push   %edi
  8018db:	e8 4d ff ff ff       	call   80182d <read>
		if (m < 0)
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	78 06                	js     8018ed <readn+0x39>
			return m;
		if (m == 0)
  8018e7:	74 06                	je     8018ef <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8018e9:	01 c3                	add    %eax,%ebx
  8018eb:	eb db                	jmp    8018c8 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018ed:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8018ef:	89 d8                	mov    %ebx,%eax
  8018f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018f4:	5b                   	pop    %ebx
  8018f5:	5e                   	pop    %esi
  8018f6:	5f                   	pop    %edi
  8018f7:	5d                   	pop    %ebp
  8018f8:	c3                   	ret    

008018f9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	53                   	push   %ebx
  8018fd:	83 ec 1c             	sub    $0x1c,%esp
  801900:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801903:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801906:	50                   	push   %eax
  801907:	53                   	push   %ebx
  801908:	e8 b0 fc ff ff       	call   8015bd <fd_lookup>
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	85 c0                	test   %eax,%eax
  801912:	78 3a                	js     80194e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801914:	83 ec 08             	sub    $0x8,%esp
  801917:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191a:	50                   	push   %eax
  80191b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191e:	ff 30                	pushl  (%eax)
  801920:	e8 e8 fc ff ff       	call   80160d <dev_lookup>
  801925:	83 c4 10             	add    $0x10,%esp
  801928:	85 c0                	test   %eax,%eax
  80192a:	78 22                	js     80194e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80192c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801933:	74 1e                	je     801953 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801938:	8b 52 0c             	mov    0xc(%edx),%edx
  80193b:	85 d2                	test   %edx,%edx
  80193d:	74 35                	je     801974 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	ff 75 10             	pushl  0x10(%ebp)
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	50                   	push   %eax
  801949:	ff d2                	call   *%edx
  80194b:	83 c4 10             	add    $0x10,%esp
}
  80194e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801951:	c9                   	leave  
  801952:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801953:	a1 08 50 80 00       	mov    0x805008,%eax
  801958:	8b 40 48             	mov    0x48(%eax),%eax
  80195b:	83 ec 04             	sub    $0x4,%esp
  80195e:	53                   	push   %ebx
  80195f:	50                   	push   %eax
  801960:	68 2d 36 80 00       	push   $0x80362d
  801965:	e8 57 ec ff ff       	call   8005c1 <cprintf>
		return -E_INVAL;
  80196a:	83 c4 10             	add    $0x10,%esp
  80196d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801972:	eb da                	jmp    80194e <write+0x55>
		return -E_NOT_SUPP;
  801974:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801979:	eb d3                	jmp    80194e <write+0x55>

0080197b <seek>:

int
seek(int fdnum, off_t offset)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801981:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801984:	50                   	push   %eax
  801985:	ff 75 08             	pushl  0x8(%ebp)
  801988:	e8 30 fc ff ff       	call   8015bd <fd_lookup>
  80198d:	83 c4 10             	add    $0x10,%esp
  801990:	85 c0                	test   %eax,%eax
  801992:	78 0e                	js     8019a2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801994:	8b 55 0c             	mov    0xc(%ebp),%edx
  801997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80199d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	53                   	push   %ebx
  8019a8:	83 ec 1c             	sub    $0x1c,%esp
  8019ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b1:	50                   	push   %eax
  8019b2:	53                   	push   %ebx
  8019b3:	e8 05 fc ff ff       	call   8015bd <fd_lookup>
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	78 37                	js     8019f6 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019bf:	83 ec 08             	sub    $0x8,%esp
  8019c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c5:	50                   	push   %eax
  8019c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c9:	ff 30                	pushl  (%eax)
  8019cb:	e8 3d fc ff ff       	call   80160d <dev_lookup>
  8019d0:	83 c4 10             	add    $0x10,%esp
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	78 1f                	js     8019f6 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019da:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019de:	74 1b                	je     8019fb <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8019e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e3:	8b 52 18             	mov    0x18(%edx),%edx
  8019e6:	85 d2                	test   %edx,%edx
  8019e8:	74 32                	je     801a1c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019ea:	83 ec 08             	sub    $0x8,%esp
  8019ed:	ff 75 0c             	pushl  0xc(%ebp)
  8019f0:	50                   	push   %eax
  8019f1:	ff d2                	call   *%edx
  8019f3:	83 c4 10             	add    $0x10,%esp
}
  8019f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    
			thisenv->env_id, fdnum);
  8019fb:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a00:	8b 40 48             	mov    0x48(%eax),%eax
  801a03:	83 ec 04             	sub    $0x4,%esp
  801a06:	53                   	push   %ebx
  801a07:	50                   	push   %eax
  801a08:	68 f0 35 80 00       	push   $0x8035f0
  801a0d:	e8 af eb ff ff       	call   8005c1 <cprintf>
		return -E_INVAL;
  801a12:	83 c4 10             	add    $0x10,%esp
  801a15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a1a:	eb da                	jmp    8019f6 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a1c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a21:	eb d3                	jmp    8019f6 <ftruncate+0x52>

00801a23 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	53                   	push   %ebx
  801a27:	83 ec 1c             	sub    $0x1c,%esp
  801a2a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a2d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a30:	50                   	push   %eax
  801a31:	ff 75 08             	pushl  0x8(%ebp)
  801a34:	e8 84 fb ff ff       	call   8015bd <fd_lookup>
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	78 4b                	js     801a8b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a40:	83 ec 08             	sub    $0x8,%esp
  801a43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a46:	50                   	push   %eax
  801a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4a:	ff 30                	pushl  (%eax)
  801a4c:	e8 bc fb ff ff       	call   80160d <dev_lookup>
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	85 c0                	test   %eax,%eax
  801a56:	78 33                	js     801a8b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a5f:	74 2f                	je     801a90 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a61:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a64:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a6b:	00 00 00 
	stat->st_isdir = 0;
  801a6e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a75:	00 00 00 
	stat->st_dev = dev;
  801a78:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a7e:	83 ec 08             	sub    $0x8,%esp
  801a81:	53                   	push   %ebx
  801a82:	ff 75 f0             	pushl  -0x10(%ebp)
  801a85:	ff 50 14             	call   *0x14(%eax)
  801a88:	83 c4 10             	add    $0x10,%esp
}
  801a8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    
		return -E_NOT_SUPP;
  801a90:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a95:	eb f4                	jmp    801a8b <fstat+0x68>

00801a97 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	56                   	push   %esi
  801a9b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a9c:	83 ec 08             	sub    $0x8,%esp
  801a9f:	6a 00                	push   $0x0
  801aa1:	ff 75 08             	pushl  0x8(%ebp)
  801aa4:	e8 2f 02 00 00       	call   801cd8 <open>
  801aa9:	89 c3                	mov    %eax,%ebx
  801aab:	83 c4 10             	add    $0x10,%esp
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	78 1b                	js     801acd <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801ab2:	83 ec 08             	sub    $0x8,%esp
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	50                   	push   %eax
  801ab9:	e8 65 ff ff ff       	call   801a23 <fstat>
  801abe:	89 c6                	mov    %eax,%esi
	close(fd);
  801ac0:	89 1c 24             	mov    %ebx,(%esp)
  801ac3:	e8 27 fc ff ff       	call   8016ef <close>
	return r;
  801ac8:	83 c4 10             	add    $0x10,%esp
  801acb:	89 f3                	mov    %esi,%ebx
}
  801acd:	89 d8                	mov    %ebx,%eax
  801acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad2:	5b                   	pop    %ebx
  801ad3:	5e                   	pop    %esi
  801ad4:	5d                   	pop    %ebp
  801ad5:	c3                   	ret    

00801ad6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	56                   	push   %esi
  801ada:	53                   	push   %ebx
  801adb:	89 c6                	mov    %eax,%esi
  801add:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801adf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ae6:	74 27                	je     801b0f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ae8:	6a 07                	push   $0x7
  801aea:	68 00 60 80 00       	push   $0x806000
  801aef:	56                   	push   %esi
  801af0:	ff 35 00 50 80 00    	pushl  0x805000
  801af6:	e8 95 11 00 00       	call   802c90 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801afb:	83 c4 0c             	add    $0xc,%esp
  801afe:	6a 00                	push   $0x0
  801b00:	53                   	push   %ebx
  801b01:	6a 00                	push   $0x0
  801b03:	e8 15 11 00 00       	call   802c1d <ipc_recv>
}
  801b08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0b:	5b                   	pop    %ebx
  801b0c:	5e                   	pop    %esi
  801b0d:	5d                   	pop    %ebp
  801b0e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b0f:	83 ec 0c             	sub    $0xc,%esp
  801b12:	6a 01                	push   $0x1
  801b14:	e8 e3 11 00 00       	call   802cfc <ipc_find_env>
  801b19:	a3 00 50 80 00       	mov    %eax,0x805000
  801b1e:	83 c4 10             	add    $0x10,%esp
  801b21:	eb c5                	jmp    801ae8 <fsipc+0x12>

00801b23 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b2f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b37:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b41:	b8 02 00 00 00       	mov    $0x2,%eax
  801b46:	e8 8b ff ff ff       	call   801ad6 <fsipc>
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <devfile_flush>:
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	8b 40 0c             	mov    0xc(%eax),%eax
  801b59:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b63:	b8 06 00 00 00       	mov    $0x6,%eax
  801b68:	e8 69 ff ff ff       	call   801ad6 <fsipc>
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <devfile_stat>:
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	53                   	push   %ebx
  801b73:	83 ec 04             	sub    $0x4,%esp
  801b76:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7f:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b84:	ba 00 00 00 00       	mov    $0x0,%edx
  801b89:	b8 05 00 00 00       	mov    $0x5,%eax
  801b8e:	e8 43 ff ff ff       	call   801ad6 <fsipc>
  801b93:	85 c0                	test   %eax,%eax
  801b95:	78 2c                	js     801bc3 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b97:	83 ec 08             	sub    $0x8,%esp
  801b9a:	68 00 60 80 00       	push   $0x806000
  801b9f:	53                   	push   %ebx
  801ba0:	e8 f8 ef ff ff       	call   800b9d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ba5:	a1 80 60 80 00       	mov    0x806080,%eax
  801baa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bb0:	a1 84 60 80 00       	mov    0x806084,%eax
  801bb5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bbb:	83 c4 10             	add    $0x10,%esp
  801bbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <devfile_write>:
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801bd2:	85 db                	test   %ebx,%ebx
  801bd4:	75 07                	jne    801bdd <devfile_write+0x15>
	return n_all;
  801bd6:	89 d8                	mov    %ebx,%eax
}
  801bd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	8b 40 0c             	mov    0xc(%eax),%eax
  801be3:	a3 00 60 80 00       	mov    %eax,0x806000
	  fsipcbuf.write.req_n = n_left;
  801be8:	89 1d 04 60 80 00    	mov    %ebx,0x806004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801bee:	83 ec 04             	sub    $0x4,%esp
  801bf1:	53                   	push   %ebx
  801bf2:	ff 75 0c             	pushl  0xc(%ebp)
  801bf5:	68 08 60 80 00       	push   $0x806008
  801bfa:	e8 2c f1 ff ff       	call   800d2b <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801bff:	ba 00 00 00 00       	mov    $0x0,%edx
  801c04:	b8 04 00 00 00       	mov    $0x4,%eax
  801c09:	e8 c8 fe ff ff       	call   801ad6 <fsipc>
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	85 c0                	test   %eax,%eax
  801c13:	78 c3                	js     801bd8 <devfile_write+0x10>
	  assert(r <= n_left);
  801c15:	39 d8                	cmp    %ebx,%eax
  801c17:	77 0b                	ja     801c24 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801c19:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c1e:	7f 1d                	jg     801c3d <devfile_write+0x75>
    n_all += r;
  801c20:	89 c3                	mov    %eax,%ebx
  801c22:	eb b2                	jmp    801bd6 <devfile_write+0xe>
	  assert(r <= n_left);
  801c24:	68 60 36 80 00       	push   $0x803660
  801c29:	68 6c 36 80 00       	push   $0x80366c
  801c2e:	68 9f 00 00 00       	push   $0x9f
  801c33:	68 81 36 80 00       	push   $0x803681
  801c38:	e8 a9 e8 ff ff       	call   8004e6 <_panic>
	  assert(r <= PGSIZE);
  801c3d:	68 8c 36 80 00       	push   $0x80368c
  801c42:	68 6c 36 80 00       	push   $0x80366c
  801c47:	68 a0 00 00 00       	push   $0xa0
  801c4c:	68 81 36 80 00       	push   $0x803681
  801c51:	e8 90 e8 ff ff       	call   8004e6 <_panic>

00801c56 <devfile_read>:
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	56                   	push   %esi
  801c5a:	53                   	push   %ebx
  801c5b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	8b 40 0c             	mov    0xc(%eax),%eax
  801c64:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c69:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c74:	b8 03 00 00 00       	mov    $0x3,%eax
  801c79:	e8 58 fe ff ff       	call   801ad6 <fsipc>
  801c7e:	89 c3                	mov    %eax,%ebx
  801c80:	85 c0                	test   %eax,%eax
  801c82:	78 1f                	js     801ca3 <devfile_read+0x4d>
	assert(r <= n);
  801c84:	39 f0                	cmp    %esi,%eax
  801c86:	77 24                	ja     801cac <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c88:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c8d:	7f 33                	jg     801cc2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c8f:	83 ec 04             	sub    $0x4,%esp
  801c92:	50                   	push   %eax
  801c93:	68 00 60 80 00       	push   $0x806000
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	e8 8b f0 ff ff       	call   800d2b <memmove>
	return r;
  801ca0:	83 c4 10             	add    $0x10,%esp
}
  801ca3:	89 d8                	mov    %ebx,%eax
  801ca5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ca8:	5b                   	pop    %ebx
  801ca9:	5e                   	pop    %esi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    
	assert(r <= n);
  801cac:	68 98 36 80 00       	push   $0x803698
  801cb1:	68 6c 36 80 00       	push   $0x80366c
  801cb6:	6a 7c                	push   $0x7c
  801cb8:	68 81 36 80 00       	push   $0x803681
  801cbd:	e8 24 e8 ff ff       	call   8004e6 <_panic>
	assert(r <= PGSIZE);
  801cc2:	68 8c 36 80 00       	push   $0x80368c
  801cc7:	68 6c 36 80 00       	push   $0x80366c
  801ccc:	6a 7d                	push   $0x7d
  801cce:	68 81 36 80 00       	push   $0x803681
  801cd3:	e8 0e e8 ff ff       	call   8004e6 <_panic>

00801cd8 <open>:
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	56                   	push   %esi
  801cdc:	53                   	push   %ebx
  801cdd:	83 ec 1c             	sub    $0x1c,%esp
  801ce0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ce3:	56                   	push   %esi
  801ce4:	e8 7b ee ff ff       	call   800b64 <strlen>
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cf1:	7f 6c                	jg     801d5f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801cf3:	83 ec 0c             	sub    $0xc,%esp
  801cf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf9:	50                   	push   %eax
  801cfa:	e8 6c f8 ff ff       	call   80156b <fd_alloc>
  801cff:	89 c3                	mov    %eax,%ebx
  801d01:	83 c4 10             	add    $0x10,%esp
  801d04:	85 c0                	test   %eax,%eax
  801d06:	78 3c                	js     801d44 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d08:	83 ec 08             	sub    $0x8,%esp
  801d0b:	56                   	push   %esi
  801d0c:	68 00 60 80 00       	push   $0x806000
  801d11:	e8 87 ee ff ff       	call   800b9d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d19:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d21:	b8 01 00 00 00       	mov    $0x1,%eax
  801d26:	e8 ab fd ff ff       	call   801ad6 <fsipc>
  801d2b:	89 c3                	mov    %eax,%ebx
  801d2d:	83 c4 10             	add    $0x10,%esp
  801d30:	85 c0                	test   %eax,%eax
  801d32:	78 19                	js     801d4d <open+0x75>
	return fd2num(fd);
  801d34:	83 ec 0c             	sub    $0xc,%esp
  801d37:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3a:	e8 05 f8 ff ff       	call   801544 <fd2num>
  801d3f:	89 c3                	mov    %eax,%ebx
  801d41:	83 c4 10             	add    $0x10,%esp
}
  801d44:	89 d8                	mov    %ebx,%eax
  801d46:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d49:	5b                   	pop    %ebx
  801d4a:	5e                   	pop    %esi
  801d4b:	5d                   	pop    %ebp
  801d4c:	c3                   	ret    
		fd_close(fd, 0);
  801d4d:	83 ec 08             	sub    $0x8,%esp
  801d50:	6a 00                	push   $0x0
  801d52:	ff 75 f4             	pushl  -0xc(%ebp)
  801d55:	e8 0e f9 ff ff       	call   801668 <fd_close>
		return r;
  801d5a:	83 c4 10             	add    $0x10,%esp
  801d5d:	eb e5                	jmp    801d44 <open+0x6c>
		return -E_BAD_PATH;
  801d5f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d64:	eb de                	jmp    801d44 <open+0x6c>

00801d66 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d71:	b8 08 00 00 00       	mov    $0x8,%eax
  801d76:	e8 5b fd ff ff       	call   801ad6 <fsipc>
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	57                   	push   %edi
  801d81:	56                   	push   %esi
  801d82:	53                   	push   %ebx
  801d83:	81 ec 8c 02 00 00    	sub    $0x28c,%esp
  cprintf("spawn: parent eid = %08x\n", sys_getenvid());
  801d89:	e8 c3 f1 ff ff       	call   800f51 <sys_getenvid>
  801d8e:	83 ec 08             	sub    $0x8,%esp
  801d91:	50                   	push   %eax
  801d92:	68 9f 36 80 00       	push   $0x80369f
  801d97:	e8 25 e8 ff ff       	call   8005c1 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801d9c:	83 c4 08             	add    $0x8,%esp
  801d9f:	6a 00                	push   $0x0
  801da1:	ff 75 08             	pushl  0x8(%ebp)
  801da4:	e8 2f ff ff ff       	call   801cd8 <open>
  801da9:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801daf:	83 c4 10             	add    $0x10,%esp
  801db2:	85 c0                	test   %eax,%eax
  801db4:	0f 88 fb 04 00 00    	js     8022b5 <spawn+0x538>
  801dba:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801dbc:	83 ec 04             	sub    $0x4,%esp
  801dbf:	68 00 02 00 00       	push   $0x200
  801dc4:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801dca:	50                   	push   %eax
  801dcb:	52                   	push   %edx
  801dcc:	e8 e3 fa ff ff       	call   8018b4 <readn>
  801dd1:	83 c4 10             	add    $0x10,%esp
  801dd4:	3d 00 02 00 00       	cmp    $0x200,%eax
  801dd9:	75 71                	jne    801e4c <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  801ddb:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801de2:	45 4c 46 
  801de5:	75 65                	jne    801e4c <spawn+0xcf>
  801de7:	b8 07 00 00 00       	mov    $0x7,%eax
  801dec:	cd 30                	int    $0x30
  801dee:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801df4:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801dfa:	89 c6                	mov    %eax,%esi
  801dfc:	85 c0                	test   %eax,%eax
  801dfe:	0f 88 a5 04 00 00    	js     8022a9 <spawn+0x52c>
		return r;
	child = r;
  cprintf("spawn: child eid = %08x\n", child);
  801e04:	83 ec 08             	sub    $0x8,%esp
  801e07:	50                   	push   %eax
  801e08:	68 d3 36 80 00       	push   $0x8036d3
  801e0d:	e8 af e7 ff ff       	call   8005c1 <cprintf>

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801e12:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801e18:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801e1b:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801e21:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801e27:	b9 11 00 00 00       	mov    $0x11,%ecx
  801e2c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801e2e:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801e34:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  801e3a:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e3d:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801e42:	be 00 00 00 00       	mov    $0x0,%esi
  801e47:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801e4a:	eb 4b                	jmp    801e97 <spawn+0x11a>
		close(fd);
  801e4c:	83 ec 0c             	sub    $0xc,%esp
  801e4f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e55:	e8 95 f8 ff ff       	call   8016ef <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801e5a:	83 c4 0c             	add    $0xc,%esp
  801e5d:	68 7f 45 4c 46       	push   $0x464c457f
  801e62:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801e68:	68 b9 36 80 00       	push   $0x8036b9
  801e6d:	e8 4f e7 ff ff       	call   8005c1 <cprintf>
		return -E_NOT_EXEC;
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801e7c:	ff ff ff 
  801e7f:	e9 31 04 00 00       	jmp    8022b5 <spawn+0x538>
		string_size += strlen(argv[argc]) + 1;
  801e84:	83 ec 0c             	sub    $0xc,%esp
  801e87:	50                   	push   %eax
  801e88:	e8 d7 ec ff ff       	call   800b64 <strlen>
  801e8d:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801e91:	83 c3 01             	add    $0x1,%ebx
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801e9e:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	75 df                	jne    801e84 <spawn+0x107>
  801ea5:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801eab:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801eb1:	bf 00 10 40 00       	mov    $0x401000,%edi
  801eb6:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801eb8:	89 fa                	mov    %edi,%edx
  801eba:	83 e2 fc             	and    $0xfffffffc,%edx
  801ebd:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801ec4:	29 c2                	sub    %eax,%edx
  801ec6:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801ecc:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ecf:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ed4:	0f 86 fe 03 00 00    	jbe    8022d8 <spawn+0x55b>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	6a 07                	push   $0x7
  801edf:	68 00 00 40 00       	push   $0x400000
  801ee4:	6a 00                	push   $0x0
  801ee6:	e8 a4 f0 ff ff       	call   800f8f <sys_page_alloc>
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	0f 88 e7 03 00 00    	js     8022dd <spawn+0x560>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801ef6:	be 00 00 00 00       	mov    $0x0,%esi
  801efb:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801f01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f04:	eb 30                	jmp    801f36 <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  801f06:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801f0c:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801f12:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801f15:	83 ec 08             	sub    $0x8,%esp
  801f18:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801f1b:	57                   	push   %edi
  801f1c:	e8 7c ec ff ff       	call   800b9d <strcpy>
		string_store += strlen(argv[i]) + 1;
  801f21:	83 c4 04             	add    $0x4,%esp
  801f24:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801f27:	e8 38 ec ff ff       	call   800b64 <strlen>
  801f2c:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801f30:	83 c6 01             	add    $0x1,%esi
  801f33:	83 c4 10             	add    $0x10,%esp
  801f36:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801f3c:	7f c8                	jg     801f06 <spawn+0x189>
	}
	argv_store[argc] = 0;
  801f3e:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801f44:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801f4a:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801f51:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801f57:	0f 85 86 00 00 00    	jne    801fe3 <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801f5d:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801f63:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801f69:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801f6c:	89 c8                	mov    %ecx,%eax
  801f6e:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801f74:	89 79 f8             	mov    %edi,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801f77:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801f7c:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f82:	83 ec 0c             	sub    $0xc,%esp
  801f85:	6a 07                	push   $0x7
  801f87:	68 00 d0 bf ee       	push   $0xeebfd000
  801f8c:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f92:	68 00 00 40 00       	push   $0x400000
  801f97:	6a 00                	push   $0x0
  801f99:	e8 34 f0 ff ff       	call   800fd2 <sys_page_map>
  801f9e:	89 c3                	mov    %eax,%ebx
  801fa0:	83 c4 20             	add    $0x20,%esp
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	0f 88 3a 03 00 00    	js     8022e5 <spawn+0x568>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801fab:	83 ec 08             	sub    $0x8,%esp
  801fae:	68 00 00 40 00       	push   $0x400000
  801fb3:	6a 00                	push   $0x0
  801fb5:	e8 5a f0 ff ff       	call   801014 <sys_page_unmap>
  801fba:	89 c3                	mov    %eax,%ebx
  801fbc:	83 c4 10             	add    $0x10,%esp
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	0f 88 1e 03 00 00    	js     8022e5 <spawn+0x568>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801fc7:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801fcd:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801fd4:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801fdb:	00 00 00 
  801fde:	e9 4f 01 00 00       	jmp    802132 <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801fe3:	68 30 37 80 00       	push   $0x803730
  801fe8:	68 6c 36 80 00       	push   $0x80366c
  801fed:	68 f4 00 00 00       	push   $0xf4
  801ff2:	68 ec 36 80 00       	push   $0x8036ec
  801ff7:	e8 ea e4 ff ff       	call   8004e6 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ffc:	83 ec 04             	sub    $0x4,%esp
  801fff:	6a 07                	push   $0x7
  802001:	68 00 00 40 00       	push   $0x400000
  802006:	6a 00                	push   $0x0
  802008:	e8 82 ef ff ff       	call   800f8f <sys_page_alloc>
  80200d:	83 c4 10             	add    $0x10,%esp
  802010:	85 c0                	test   %eax,%eax
  802012:	0f 88 ab 02 00 00    	js     8022c3 <spawn+0x546>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802018:	83 ec 08             	sub    $0x8,%esp
  80201b:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802021:	01 f0                	add    %esi,%eax
  802023:	50                   	push   %eax
  802024:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80202a:	e8 4c f9 ff ff       	call   80197b <seek>
  80202f:	83 c4 10             	add    $0x10,%esp
  802032:	85 c0                	test   %eax,%eax
  802034:	0f 88 90 02 00 00    	js     8022ca <spawn+0x54d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80203a:	83 ec 04             	sub    $0x4,%esp
  80203d:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802043:	29 f0                	sub    %esi,%eax
  802045:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80204a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80204f:	0f 47 c1             	cmova  %ecx,%eax
  802052:	50                   	push   %eax
  802053:	68 00 00 40 00       	push   $0x400000
  802058:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80205e:	e8 51 f8 ff ff       	call   8018b4 <readn>
  802063:	83 c4 10             	add    $0x10,%esp
  802066:	85 c0                	test   %eax,%eax
  802068:	0f 88 63 02 00 00    	js     8022d1 <spawn+0x554>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80206e:	83 ec 0c             	sub    $0xc,%esp
  802071:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802077:	53                   	push   %ebx
  802078:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80207e:	68 00 00 40 00       	push   $0x400000
  802083:	6a 00                	push   $0x0
  802085:	e8 48 ef ff ff       	call   800fd2 <sys_page_map>
  80208a:	83 c4 20             	add    $0x20,%esp
  80208d:	85 c0                	test   %eax,%eax
  80208f:	78 7c                	js     80210d <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802091:	83 ec 08             	sub    $0x8,%esp
  802094:	68 00 00 40 00       	push   $0x400000
  802099:	6a 00                	push   $0x0
  80209b:	e8 74 ef ff ff       	call   801014 <sys_page_unmap>
  8020a0:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8020a3:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8020a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8020af:	89 fe                	mov    %edi,%esi
  8020b1:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8020b7:	76 69                	jbe    802122 <spawn+0x3a5>
		if (i >= filesz) {
  8020b9:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8020bf:	0f 87 37 ff ff ff    	ja     801ffc <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8020c5:	83 ec 04             	sub    $0x4,%esp
  8020c8:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8020ce:	53                   	push   %ebx
  8020cf:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8020d5:	e8 b5 ee ff ff       	call   800f8f <sys_page_alloc>
  8020da:	83 c4 10             	add    $0x10,%esp
  8020dd:	85 c0                	test   %eax,%eax
  8020df:	79 c2                	jns    8020a3 <spawn+0x326>
  8020e1:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8020e3:	83 ec 0c             	sub    $0xc,%esp
  8020e6:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8020ec:	e8 1f ee ff ff       	call   800f10 <sys_env_destroy>
	close(fd);
  8020f1:	83 c4 04             	add    $0x4,%esp
  8020f4:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8020fa:	e8 f0 f5 ff ff       	call   8016ef <close>
	return r;
  8020ff:	83 c4 10             	add    $0x10,%esp
  802102:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802108:	e9 a8 01 00 00       	jmp    8022b5 <spawn+0x538>
				panic("spawn: sys_page_map data: %e", r);
  80210d:	50                   	push   %eax
  80210e:	68 f8 36 80 00       	push   $0x8036f8
  802113:	68 27 01 00 00       	push   $0x127
  802118:	68 ec 36 80 00       	push   $0x8036ec
  80211d:	e8 c4 e3 ff ff       	call   8004e6 <_panic>
  802122:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802128:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  80212f:	83 c6 20             	add    $0x20,%esi
  802132:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802139:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  80213f:	7e 6d                	jle    8021ae <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  802141:	83 3e 01             	cmpl   $0x1,(%esi)
  802144:	75 e2                	jne    802128 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802146:	8b 46 18             	mov    0x18(%esi),%eax
  802149:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  80214c:	83 f8 01             	cmp    $0x1,%eax
  80214f:	19 c0                	sbb    %eax,%eax
  802151:	83 e0 fe             	and    $0xfffffffe,%eax
  802154:	83 c0 07             	add    $0x7,%eax
  802157:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80215d:	8b 4e 04             	mov    0x4(%esi),%ecx
  802160:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802166:	8b 56 10             	mov    0x10(%esi),%edx
  802169:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  80216f:	8b 7e 14             	mov    0x14(%esi),%edi
  802172:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802178:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  80217b:	89 d8                	mov    %ebx,%eax
  80217d:	25 ff 0f 00 00       	and    $0xfff,%eax
  802182:	74 1a                	je     80219e <spawn+0x421>
		va -= i;
  802184:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802186:	01 c7                	add    %eax,%edi
  802188:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  80218e:	01 c2                	add    %eax,%edx
  802190:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802196:	29 c1                	sub    %eax,%ecx
  802198:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  80219e:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a3:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  8021a9:	e9 01 ff ff ff       	jmp    8020af <spawn+0x332>
	close(fd);
  8021ae:	83 ec 0c             	sub    $0xc,%esp
  8021b1:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8021b7:	e8 33 f5 ff ff       	call   8016ef <close>
  8021bc:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for(unsigned int i = 0; i < PGNUM(UTOP); i++)
  8021bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021c4:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  8021ca:	eb 0d                	jmp    8021d9 <spawn+0x45c>
  8021cc:	83 c3 01             	add    $0x1,%ebx
  8021cf:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  8021d5:	77 5d                	ja     802234 <spawn+0x4b7>
	{
		// Remember to ignore exception stack
		if(i == PGNUM(UXSTACKTOP - PGSIZE))
  8021d7:	74 f3                	je     8021cc <spawn+0x44f>
			continue;
		// check whether this page table entry is valid(whether there exists a mapping)
		void* addr = (void*)(i * PGSIZE);
  8021d9:	89 da                	mov    %ebx,%edx
  8021db:	c1 e2 0c             	shl    $0xc,%edx
    //BUG
    //if (uvpd[PDX(addr)] & PTE_P)  continue;
    if (!(uvpd[PDX(addr)] & PTE_P))  continue;
  8021de:	89 d0                	mov    %edx,%eax
  8021e0:	c1 e8 16             	shr    $0x16,%eax
  8021e3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8021ea:	a8 01                	test   $0x1,%al
  8021ec:	74 de                	je     8021cc <spawn+0x44f>
		pte_t pte = uvpt[i];
  8021ee:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		if((pte & PTE_P) && (pte & PTE_SHARE))
  8021f5:	89 c1                	mov    %eax,%ecx
  8021f7:	81 e1 01 04 00 00    	and    $0x401,%ecx
  8021fd:	81 f9 01 04 00 00    	cmp    $0x401,%ecx
  802203:	75 c7                	jne    8021cc <spawn+0x44f>
		{
			int error_code = 0;
			if((error_code = sys_page_map(0, addr, child, addr, pte & PTE_SYSCALL)) < 0)
  802205:	83 ec 0c             	sub    $0xc,%esp
  802208:	25 07 0e 00 00       	and    $0xe07,%eax
  80220d:	50                   	push   %eax
  80220e:	52                   	push   %edx
  80220f:	56                   	push   %esi
  802210:	52                   	push   %edx
  802211:	6a 00                	push   $0x0
  802213:	e8 ba ed ff ff       	call   800fd2 <sys_page_map>
  802218:	83 c4 20             	add    $0x20,%esp
  80221b:	85 c0                	test   %eax,%eax
  80221d:	79 ad                	jns    8021cc <spawn+0x44f>
				panic("Page Map Failed: %e", error_code);
  80221f:	50                   	push   %eax
  802220:	68 8d 35 80 00       	push   $0x80358d
  802225:	68 42 01 00 00       	push   $0x142
  80222a:	68 ec 36 80 00       	push   $0x8036ec
  80222f:	e8 b2 e2 ff ff       	call   8004e6 <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802234:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  80223b:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80223e:	83 ec 08             	sub    $0x8,%esp
  802241:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802247:	50                   	push   %eax
  802248:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80224e:	e8 45 ee ff ff       	call   801098 <sys_env_set_trapframe>
  802253:	83 c4 10             	add    $0x10,%esp
  802256:	85 c0                	test   %eax,%eax
  802258:	78 25                	js     80227f <spawn+0x502>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80225a:	83 ec 08             	sub    $0x8,%esp
  80225d:	6a 02                	push   $0x2
  80225f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802265:	e8 ec ed ff ff       	call   801056 <sys_env_set_status>
  80226a:	83 c4 10             	add    $0x10,%esp
  80226d:	85 c0                	test   %eax,%eax
  80226f:	78 23                	js     802294 <spawn+0x517>
	return child;
  802271:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802277:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80227d:	eb 36                	jmp    8022b5 <spawn+0x538>
		panic("sys_env_set_trapframe: %e", r);
  80227f:	50                   	push   %eax
  802280:	68 15 37 80 00       	push   $0x803715
  802285:	68 88 00 00 00       	push   $0x88
  80228a:	68 ec 36 80 00       	push   $0x8036ec
  80228f:	e8 52 e2 ff ff       	call   8004e6 <_panic>
		panic("sys_env_set_status: %e", r);
  802294:	50                   	push   %eax
  802295:	68 a1 35 80 00       	push   $0x8035a1
  80229a:	68 8b 00 00 00       	push   $0x8b
  80229f:	68 ec 36 80 00       	push   $0x8036ec
  8022a4:	e8 3d e2 ff ff       	call   8004e6 <_panic>
		return r;
  8022a9:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8022af:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  8022b5:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8022bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5e                   	pop    %esi
  8022c0:	5f                   	pop    %edi
  8022c1:	5d                   	pop    %ebp
  8022c2:	c3                   	ret    
  8022c3:	89 c7                	mov    %eax,%edi
  8022c5:	e9 19 fe ff ff       	jmp    8020e3 <spawn+0x366>
  8022ca:	89 c7                	mov    %eax,%edi
  8022cc:	e9 12 fe ff ff       	jmp    8020e3 <spawn+0x366>
  8022d1:	89 c7                	mov    %eax,%edi
  8022d3:	e9 0b fe ff ff       	jmp    8020e3 <spawn+0x366>
		return -E_NO_MEM;
  8022d8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(unsigned int i = 0; i < PGNUM(UTOP); i++)
  8022dd:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8022e3:	eb d0                	jmp    8022b5 <spawn+0x538>
	sys_page_unmap(0, UTEMP);
  8022e5:	83 ec 08             	sub    $0x8,%esp
  8022e8:	68 00 00 40 00       	push   $0x400000
  8022ed:	6a 00                	push   $0x0
  8022ef:	e8 20 ed ff ff       	call   801014 <sys_page_unmap>
  8022f4:	83 c4 10             	add    $0x10,%esp
  8022f7:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  8022fd:	eb b6                	jmp    8022b5 <spawn+0x538>

008022ff <spawnl>:
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	57                   	push   %edi
  802303:	56                   	push   %esi
  802304:	53                   	push   %ebx
  802305:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802308:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  80230b:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802310:	8d 4a 04             	lea    0x4(%edx),%ecx
  802313:	83 3a 00             	cmpl   $0x0,(%edx)
  802316:	74 07                	je     80231f <spawnl+0x20>
		argc++;
  802318:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  80231b:	89 ca                	mov    %ecx,%edx
  80231d:	eb f1                	jmp    802310 <spawnl+0x11>
	const char *argv[argc+2];
  80231f:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802326:	83 e2 f0             	and    $0xfffffff0,%edx
  802329:	29 d4                	sub    %edx,%esp
  80232b:	8d 54 24 03          	lea    0x3(%esp),%edx
  80232f:	c1 ea 02             	shr    $0x2,%edx
  802332:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802339:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80233b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80233e:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802345:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  80234c:	00 
	va_start(vl, arg0);
  80234d:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802350:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802352:	b8 00 00 00 00       	mov    $0x0,%eax
  802357:	eb 0b                	jmp    802364 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  802359:	83 c0 01             	add    $0x1,%eax
  80235c:	8b 39                	mov    (%ecx),%edi
  80235e:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802361:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802364:	39 d0                	cmp    %edx,%eax
  802366:	75 f1                	jne    802359 <spawnl+0x5a>
	return spawn(prog, argv);
  802368:	83 ec 08             	sub    $0x8,%esp
  80236b:	56                   	push   %esi
  80236c:	ff 75 08             	pushl  0x8(%ebp)
  80236f:	e8 09 fa ff ff       	call   801d7d <spawn>
}
  802374:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802377:	5b                   	pop    %ebx
  802378:	5e                   	pop    %esi
  802379:	5f                   	pop    %edi
  80237a:	5d                   	pop    %ebp
  80237b:	c3                   	ret    

0080237c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	56                   	push   %esi
  802380:	53                   	push   %ebx
  802381:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802384:	83 ec 0c             	sub    $0xc,%esp
  802387:	ff 75 08             	pushl  0x8(%ebp)
  80238a:	e8 c5 f1 ff ff       	call   801554 <fd2data>
  80238f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802391:	83 c4 08             	add    $0x8,%esp
  802394:	68 56 37 80 00       	push   $0x803756
  802399:	53                   	push   %ebx
  80239a:	e8 fe e7 ff ff       	call   800b9d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80239f:	8b 46 04             	mov    0x4(%esi),%eax
  8023a2:	2b 06                	sub    (%esi),%eax
  8023a4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023aa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023b1:	00 00 00 
	stat->st_dev = &devpipe;
  8023b4:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023bb:	40 80 00 
	return 0;
}
  8023be:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023c6:	5b                   	pop    %ebx
  8023c7:	5e                   	pop    %esi
  8023c8:	5d                   	pop    %ebp
  8023c9:	c3                   	ret    

008023ca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	53                   	push   %ebx
  8023ce:	83 ec 0c             	sub    $0xc,%esp
  8023d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023d4:	53                   	push   %ebx
  8023d5:	6a 00                	push   $0x0
  8023d7:	e8 38 ec ff ff       	call   801014 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023dc:	89 1c 24             	mov    %ebx,(%esp)
  8023df:	e8 70 f1 ff ff       	call   801554 <fd2data>
  8023e4:	83 c4 08             	add    $0x8,%esp
  8023e7:	50                   	push   %eax
  8023e8:	6a 00                	push   $0x0
  8023ea:	e8 25 ec ff ff       	call   801014 <sys_page_unmap>
}
  8023ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <_pipeisclosed>:
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
  8023f7:	57                   	push   %edi
  8023f8:	56                   	push   %esi
  8023f9:	53                   	push   %ebx
  8023fa:	83 ec 1c             	sub    $0x1c,%esp
  8023fd:	89 c7                	mov    %eax,%edi
  8023ff:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802401:	a1 08 50 80 00       	mov    0x805008,%eax
  802406:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802409:	83 ec 0c             	sub    $0xc,%esp
  80240c:	57                   	push   %edi
  80240d:	e8 23 09 00 00       	call   802d35 <pageref>
  802412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802415:	89 34 24             	mov    %esi,(%esp)
  802418:	e8 18 09 00 00       	call   802d35 <pageref>
		nn = thisenv->env_runs;
  80241d:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802423:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802426:	83 c4 10             	add    $0x10,%esp
  802429:	39 cb                	cmp    %ecx,%ebx
  80242b:	74 1b                	je     802448 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80242d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802430:	75 cf                	jne    802401 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802432:	8b 42 58             	mov    0x58(%edx),%eax
  802435:	6a 01                	push   $0x1
  802437:	50                   	push   %eax
  802438:	53                   	push   %ebx
  802439:	68 5d 37 80 00       	push   $0x80375d
  80243e:	e8 7e e1 ff ff       	call   8005c1 <cprintf>
  802443:	83 c4 10             	add    $0x10,%esp
  802446:	eb b9                	jmp    802401 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802448:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80244b:	0f 94 c0             	sete   %al
  80244e:	0f b6 c0             	movzbl %al,%eax
}
  802451:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802454:	5b                   	pop    %ebx
  802455:	5e                   	pop    %esi
  802456:	5f                   	pop    %edi
  802457:	5d                   	pop    %ebp
  802458:	c3                   	ret    

00802459 <devpipe_write>:
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	57                   	push   %edi
  80245d:	56                   	push   %esi
  80245e:	53                   	push   %ebx
  80245f:	83 ec 28             	sub    $0x28,%esp
  802462:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802465:	56                   	push   %esi
  802466:	e8 e9 f0 ff ff       	call   801554 <fd2data>
  80246b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80246d:	83 c4 10             	add    $0x10,%esp
  802470:	bf 00 00 00 00       	mov    $0x0,%edi
  802475:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802478:	74 4f                	je     8024c9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80247a:	8b 43 04             	mov    0x4(%ebx),%eax
  80247d:	8b 0b                	mov    (%ebx),%ecx
  80247f:	8d 51 20             	lea    0x20(%ecx),%edx
  802482:	39 d0                	cmp    %edx,%eax
  802484:	72 14                	jb     80249a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802486:	89 da                	mov    %ebx,%edx
  802488:	89 f0                	mov    %esi,%eax
  80248a:	e8 65 ff ff ff       	call   8023f4 <_pipeisclosed>
  80248f:	85 c0                	test   %eax,%eax
  802491:	75 3b                	jne    8024ce <devpipe_write+0x75>
			sys_yield();
  802493:	e8 d8 ea ff ff       	call   800f70 <sys_yield>
  802498:	eb e0                	jmp    80247a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80249a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80249d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024a1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024a4:	89 c2                	mov    %eax,%edx
  8024a6:	c1 fa 1f             	sar    $0x1f,%edx
  8024a9:	89 d1                	mov    %edx,%ecx
  8024ab:	c1 e9 1b             	shr    $0x1b,%ecx
  8024ae:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024b1:	83 e2 1f             	and    $0x1f,%edx
  8024b4:	29 ca                	sub    %ecx,%edx
  8024b6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024ba:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024be:	83 c0 01             	add    $0x1,%eax
  8024c1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024c4:	83 c7 01             	add    $0x1,%edi
  8024c7:	eb ac                	jmp    802475 <devpipe_write+0x1c>
	return i;
  8024c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8024cc:	eb 05                	jmp    8024d3 <devpipe_write+0x7a>
				return 0;
  8024ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024d6:	5b                   	pop    %ebx
  8024d7:	5e                   	pop    %esi
  8024d8:	5f                   	pop    %edi
  8024d9:	5d                   	pop    %ebp
  8024da:	c3                   	ret    

008024db <devpipe_read>:
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
  8024de:	57                   	push   %edi
  8024df:	56                   	push   %esi
  8024e0:	53                   	push   %ebx
  8024e1:	83 ec 18             	sub    $0x18,%esp
  8024e4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024e7:	57                   	push   %edi
  8024e8:	e8 67 f0 ff ff       	call   801554 <fd2data>
  8024ed:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024ef:	83 c4 10             	add    $0x10,%esp
  8024f2:	be 00 00 00 00       	mov    $0x0,%esi
  8024f7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024fa:	75 14                	jne    802510 <devpipe_read+0x35>
	return i;
  8024fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ff:	eb 02                	jmp    802503 <devpipe_read+0x28>
				return i;
  802501:	89 f0                	mov    %esi,%eax
}
  802503:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802506:	5b                   	pop    %ebx
  802507:	5e                   	pop    %esi
  802508:	5f                   	pop    %edi
  802509:	5d                   	pop    %ebp
  80250a:	c3                   	ret    
			sys_yield();
  80250b:	e8 60 ea ff ff       	call   800f70 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802510:	8b 03                	mov    (%ebx),%eax
  802512:	3b 43 04             	cmp    0x4(%ebx),%eax
  802515:	75 18                	jne    80252f <devpipe_read+0x54>
			if (i > 0)
  802517:	85 f6                	test   %esi,%esi
  802519:	75 e6                	jne    802501 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80251b:	89 da                	mov    %ebx,%edx
  80251d:	89 f8                	mov    %edi,%eax
  80251f:	e8 d0 fe ff ff       	call   8023f4 <_pipeisclosed>
  802524:	85 c0                	test   %eax,%eax
  802526:	74 e3                	je     80250b <devpipe_read+0x30>
				return 0;
  802528:	b8 00 00 00 00       	mov    $0x0,%eax
  80252d:	eb d4                	jmp    802503 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80252f:	99                   	cltd   
  802530:	c1 ea 1b             	shr    $0x1b,%edx
  802533:	01 d0                	add    %edx,%eax
  802535:	83 e0 1f             	and    $0x1f,%eax
  802538:	29 d0                	sub    %edx,%eax
  80253a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80253f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802542:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802545:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802548:	83 c6 01             	add    $0x1,%esi
  80254b:	eb aa                	jmp    8024f7 <devpipe_read+0x1c>

0080254d <pipe>:
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
  802550:	56                   	push   %esi
  802551:	53                   	push   %ebx
  802552:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802555:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802558:	50                   	push   %eax
  802559:	e8 0d f0 ff ff       	call   80156b <fd_alloc>
  80255e:	89 c3                	mov    %eax,%ebx
  802560:	83 c4 10             	add    $0x10,%esp
  802563:	85 c0                	test   %eax,%eax
  802565:	0f 88 23 01 00 00    	js     80268e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80256b:	83 ec 04             	sub    $0x4,%esp
  80256e:	68 07 04 00 00       	push   $0x407
  802573:	ff 75 f4             	pushl  -0xc(%ebp)
  802576:	6a 00                	push   $0x0
  802578:	e8 12 ea ff ff       	call   800f8f <sys_page_alloc>
  80257d:	89 c3                	mov    %eax,%ebx
  80257f:	83 c4 10             	add    $0x10,%esp
  802582:	85 c0                	test   %eax,%eax
  802584:	0f 88 04 01 00 00    	js     80268e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80258a:	83 ec 0c             	sub    $0xc,%esp
  80258d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802590:	50                   	push   %eax
  802591:	e8 d5 ef ff ff       	call   80156b <fd_alloc>
  802596:	89 c3                	mov    %eax,%ebx
  802598:	83 c4 10             	add    $0x10,%esp
  80259b:	85 c0                	test   %eax,%eax
  80259d:	0f 88 db 00 00 00    	js     80267e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025a3:	83 ec 04             	sub    $0x4,%esp
  8025a6:	68 07 04 00 00       	push   $0x407
  8025ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ae:	6a 00                	push   $0x0
  8025b0:	e8 da e9 ff ff       	call   800f8f <sys_page_alloc>
  8025b5:	89 c3                	mov    %eax,%ebx
  8025b7:	83 c4 10             	add    $0x10,%esp
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	0f 88 bc 00 00 00    	js     80267e <pipe+0x131>
	va = fd2data(fd0);
  8025c2:	83 ec 0c             	sub    $0xc,%esp
  8025c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c8:	e8 87 ef ff ff       	call   801554 <fd2data>
  8025cd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025cf:	83 c4 0c             	add    $0xc,%esp
  8025d2:	68 07 04 00 00       	push   $0x407
  8025d7:	50                   	push   %eax
  8025d8:	6a 00                	push   $0x0
  8025da:	e8 b0 e9 ff ff       	call   800f8f <sys_page_alloc>
  8025df:	89 c3                	mov    %eax,%ebx
  8025e1:	83 c4 10             	add    $0x10,%esp
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	0f 88 82 00 00 00    	js     80266e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ec:	83 ec 0c             	sub    $0xc,%esp
  8025ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8025f2:	e8 5d ef ff ff       	call   801554 <fd2data>
  8025f7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025fe:	50                   	push   %eax
  8025ff:	6a 00                	push   $0x0
  802601:	56                   	push   %esi
  802602:	6a 00                	push   $0x0
  802604:	e8 c9 e9 ff ff       	call   800fd2 <sys_page_map>
  802609:	89 c3                	mov    %eax,%ebx
  80260b:	83 c4 20             	add    $0x20,%esp
  80260e:	85 c0                	test   %eax,%eax
  802610:	78 4e                	js     802660 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802612:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802617:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80261c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802626:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802629:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80262b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802635:	83 ec 0c             	sub    $0xc,%esp
  802638:	ff 75 f4             	pushl  -0xc(%ebp)
  80263b:	e8 04 ef ff ff       	call   801544 <fd2num>
  802640:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802643:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802645:	83 c4 04             	add    $0x4,%esp
  802648:	ff 75 f0             	pushl  -0x10(%ebp)
  80264b:	e8 f4 ee ff ff       	call   801544 <fd2num>
  802650:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802653:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802656:	83 c4 10             	add    $0x10,%esp
  802659:	bb 00 00 00 00       	mov    $0x0,%ebx
  80265e:	eb 2e                	jmp    80268e <pipe+0x141>
	sys_page_unmap(0, va);
  802660:	83 ec 08             	sub    $0x8,%esp
  802663:	56                   	push   %esi
  802664:	6a 00                	push   $0x0
  802666:	e8 a9 e9 ff ff       	call   801014 <sys_page_unmap>
  80266b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80266e:	83 ec 08             	sub    $0x8,%esp
  802671:	ff 75 f0             	pushl  -0x10(%ebp)
  802674:	6a 00                	push   $0x0
  802676:	e8 99 e9 ff ff       	call   801014 <sys_page_unmap>
  80267b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80267e:	83 ec 08             	sub    $0x8,%esp
  802681:	ff 75 f4             	pushl  -0xc(%ebp)
  802684:	6a 00                	push   $0x0
  802686:	e8 89 e9 ff ff       	call   801014 <sys_page_unmap>
  80268b:	83 c4 10             	add    $0x10,%esp
}
  80268e:	89 d8                	mov    %ebx,%eax
  802690:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802693:	5b                   	pop    %ebx
  802694:	5e                   	pop    %esi
  802695:	5d                   	pop    %ebp
  802696:	c3                   	ret    

00802697 <pipeisclosed>:
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
  80269a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80269d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026a0:	50                   	push   %eax
  8026a1:	ff 75 08             	pushl  0x8(%ebp)
  8026a4:	e8 14 ef ff ff       	call   8015bd <fd_lookup>
  8026a9:	83 c4 10             	add    $0x10,%esp
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	78 18                	js     8026c8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026b0:	83 ec 0c             	sub    $0xc,%esp
  8026b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8026b6:	e8 99 ee ff ff       	call   801554 <fd2data>
	return _pipeisclosed(fd, p);
  8026bb:	89 c2                	mov    %eax,%edx
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	e8 2f fd ff ff       	call   8023f4 <_pipeisclosed>
  8026c5:	83 c4 10             	add    $0x10,%esp
}
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
  8026cd:	56                   	push   %esi
  8026ce:	53                   	push   %ebx
  8026cf:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8026d2:	85 f6                	test   %esi,%esi
  8026d4:	74 13                	je     8026e9 <wait+0x1f>
	e = &envs[ENVX(envid)];
  8026d6:	89 f3                	mov    %esi,%ebx
  8026d8:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026de:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8026e1:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8026e7:	eb 1b                	jmp    802704 <wait+0x3a>
	assert(envid != 0);
  8026e9:	68 75 37 80 00       	push   $0x803775
  8026ee:	68 6c 36 80 00       	push   $0x80366c
  8026f3:	6a 09                	push   $0x9
  8026f5:	68 80 37 80 00       	push   $0x803780
  8026fa:	e8 e7 dd ff ff       	call   8004e6 <_panic>
		sys_yield();
  8026ff:	e8 6c e8 ff ff       	call   800f70 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802704:	8b 43 48             	mov    0x48(%ebx),%eax
  802707:	39 f0                	cmp    %esi,%eax
  802709:	75 07                	jne    802712 <wait+0x48>
  80270b:	8b 43 54             	mov    0x54(%ebx),%eax
  80270e:	85 c0                	test   %eax,%eax
  802710:	75 ed                	jne    8026ff <wait+0x35>
}
  802712:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802715:	5b                   	pop    %ebx
  802716:	5e                   	pop    %esi
  802717:	5d                   	pop    %ebp
  802718:	c3                   	ret    

00802719 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
  80271c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80271f:	68 8b 37 80 00       	push   $0x80378b
  802724:	ff 75 0c             	pushl  0xc(%ebp)
  802727:	e8 71 e4 ff ff       	call   800b9d <strcpy>
	return 0;
}
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
  802731:	c9                   	leave  
  802732:	c3                   	ret    

00802733 <devsock_close>:
{
  802733:	55                   	push   %ebp
  802734:	89 e5                	mov    %esp,%ebp
  802736:	53                   	push   %ebx
  802737:	83 ec 10             	sub    $0x10,%esp
  80273a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80273d:	53                   	push   %ebx
  80273e:	e8 f2 05 00 00       	call   802d35 <pageref>
  802743:	83 c4 10             	add    $0x10,%esp
		return 0;
  802746:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80274b:	83 f8 01             	cmp    $0x1,%eax
  80274e:	74 07                	je     802757 <devsock_close+0x24>
}
  802750:	89 d0                	mov    %edx,%eax
  802752:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802755:	c9                   	leave  
  802756:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802757:	83 ec 0c             	sub    $0xc,%esp
  80275a:	ff 73 0c             	pushl  0xc(%ebx)
  80275d:	e8 b9 02 00 00       	call   802a1b <nsipc_close>
  802762:	89 c2                	mov    %eax,%edx
  802764:	83 c4 10             	add    $0x10,%esp
  802767:	eb e7                	jmp    802750 <devsock_close+0x1d>

00802769 <devsock_write>:
{
  802769:	55                   	push   %ebp
  80276a:	89 e5                	mov    %esp,%ebp
  80276c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80276f:	6a 00                	push   $0x0
  802771:	ff 75 10             	pushl  0x10(%ebp)
  802774:	ff 75 0c             	pushl  0xc(%ebp)
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	ff 70 0c             	pushl  0xc(%eax)
  80277d:	e8 76 03 00 00       	call   802af8 <nsipc_send>
}
  802782:	c9                   	leave  
  802783:	c3                   	ret    

00802784 <devsock_read>:
{
  802784:	55                   	push   %ebp
  802785:	89 e5                	mov    %esp,%ebp
  802787:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80278a:	6a 00                	push   $0x0
  80278c:	ff 75 10             	pushl  0x10(%ebp)
  80278f:	ff 75 0c             	pushl  0xc(%ebp)
  802792:	8b 45 08             	mov    0x8(%ebp),%eax
  802795:	ff 70 0c             	pushl  0xc(%eax)
  802798:	e8 ef 02 00 00       	call   802a8c <nsipc_recv>
}
  80279d:	c9                   	leave  
  80279e:	c3                   	ret    

0080279f <fd2sockid>:
{
  80279f:	55                   	push   %ebp
  8027a0:	89 e5                	mov    %esp,%ebp
  8027a2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8027a5:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8027a8:	52                   	push   %edx
  8027a9:	50                   	push   %eax
  8027aa:	e8 0e ee ff ff       	call   8015bd <fd_lookup>
  8027af:	83 c4 10             	add    $0x10,%esp
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	78 10                	js     8027c6 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 0d 58 40 80 00    	mov    0x804058,%ecx
  8027bf:	39 08                	cmp    %ecx,(%eax)
  8027c1:	75 05                	jne    8027c8 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8027c3:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8027c6:	c9                   	leave  
  8027c7:	c3                   	ret    
		return -E_NOT_SUPP;
  8027c8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8027cd:	eb f7                	jmp    8027c6 <fd2sockid+0x27>

008027cf <alloc_sockfd>:
{
  8027cf:	55                   	push   %ebp
  8027d0:	89 e5                	mov    %esp,%ebp
  8027d2:	56                   	push   %esi
  8027d3:	53                   	push   %ebx
  8027d4:	83 ec 1c             	sub    $0x1c,%esp
  8027d7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8027d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027dc:	50                   	push   %eax
  8027dd:	e8 89 ed ff ff       	call   80156b <fd_alloc>
  8027e2:	89 c3                	mov    %eax,%ebx
  8027e4:	83 c4 10             	add    $0x10,%esp
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	78 43                	js     80282e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8027eb:	83 ec 04             	sub    $0x4,%esp
  8027ee:	68 07 04 00 00       	push   $0x407
  8027f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8027f6:	6a 00                	push   $0x0
  8027f8:	e8 92 e7 ff ff       	call   800f8f <sys_page_alloc>
  8027fd:	89 c3                	mov    %eax,%ebx
  8027ff:	83 c4 10             	add    $0x10,%esp
  802802:	85 c0                	test   %eax,%eax
  802804:	78 28                	js     80282e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80280f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80281b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80281e:	83 ec 0c             	sub    $0xc,%esp
  802821:	50                   	push   %eax
  802822:	e8 1d ed ff ff       	call   801544 <fd2num>
  802827:	89 c3                	mov    %eax,%ebx
  802829:	83 c4 10             	add    $0x10,%esp
  80282c:	eb 0c                	jmp    80283a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80282e:	83 ec 0c             	sub    $0xc,%esp
  802831:	56                   	push   %esi
  802832:	e8 e4 01 00 00       	call   802a1b <nsipc_close>
		return r;
  802837:	83 c4 10             	add    $0x10,%esp
}
  80283a:	89 d8                	mov    %ebx,%eax
  80283c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80283f:	5b                   	pop    %ebx
  802840:	5e                   	pop    %esi
  802841:	5d                   	pop    %ebp
  802842:	c3                   	ret    

00802843 <accept>:
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	e8 4e ff ff ff       	call   80279f <fd2sockid>
  802851:	85 c0                	test   %eax,%eax
  802853:	78 1b                	js     802870 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802855:	83 ec 04             	sub    $0x4,%esp
  802858:	ff 75 10             	pushl  0x10(%ebp)
  80285b:	ff 75 0c             	pushl  0xc(%ebp)
  80285e:	50                   	push   %eax
  80285f:	e8 0e 01 00 00       	call   802972 <nsipc_accept>
  802864:	83 c4 10             	add    $0x10,%esp
  802867:	85 c0                	test   %eax,%eax
  802869:	78 05                	js     802870 <accept+0x2d>
	return alloc_sockfd(r);
  80286b:	e8 5f ff ff ff       	call   8027cf <alloc_sockfd>
}
  802870:	c9                   	leave  
  802871:	c3                   	ret    

00802872 <bind>:
{
  802872:	55                   	push   %ebp
  802873:	89 e5                	mov    %esp,%ebp
  802875:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802878:	8b 45 08             	mov    0x8(%ebp),%eax
  80287b:	e8 1f ff ff ff       	call   80279f <fd2sockid>
  802880:	85 c0                	test   %eax,%eax
  802882:	78 12                	js     802896 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802884:	83 ec 04             	sub    $0x4,%esp
  802887:	ff 75 10             	pushl  0x10(%ebp)
  80288a:	ff 75 0c             	pushl  0xc(%ebp)
  80288d:	50                   	push   %eax
  80288e:	e8 31 01 00 00       	call   8029c4 <nsipc_bind>
  802893:	83 c4 10             	add    $0x10,%esp
}
  802896:	c9                   	leave  
  802897:	c3                   	ret    

00802898 <shutdown>:
{
  802898:	55                   	push   %ebp
  802899:	89 e5                	mov    %esp,%ebp
  80289b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80289e:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a1:	e8 f9 fe ff ff       	call   80279f <fd2sockid>
  8028a6:	85 c0                	test   %eax,%eax
  8028a8:	78 0f                	js     8028b9 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8028aa:	83 ec 08             	sub    $0x8,%esp
  8028ad:	ff 75 0c             	pushl  0xc(%ebp)
  8028b0:	50                   	push   %eax
  8028b1:	e8 43 01 00 00       	call   8029f9 <nsipc_shutdown>
  8028b6:	83 c4 10             	add    $0x10,%esp
}
  8028b9:	c9                   	leave  
  8028ba:	c3                   	ret    

008028bb <connect>:
{
  8028bb:	55                   	push   %ebp
  8028bc:	89 e5                	mov    %esp,%ebp
  8028be:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	e8 d6 fe ff ff       	call   80279f <fd2sockid>
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	78 12                	js     8028df <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8028cd:	83 ec 04             	sub    $0x4,%esp
  8028d0:	ff 75 10             	pushl  0x10(%ebp)
  8028d3:	ff 75 0c             	pushl  0xc(%ebp)
  8028d6:	50                   	push   %eax
  8028d7:	e8 59 01 00 00       	call   802a35 <nsipc_connect>
  8028dc:	83 c4 10             	add    $0x10,%esp
}
  8028df:	c9                   	leave  
  8028e0:	c3                   	ret    

008028e1 <listen>:
{
  8028e1:	55                   	push   %ebp
  8028e2:	89 e5                	mov    %esp,%ebp
  8028e4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	e8 b0 fe ff ff       	call   80279f <fd2sockid>
  8028ef:	85 c0                	test   %eax,%eax
  8028f1:	78 0f                	js     802902 <listen+0x21>
	return nsipc_listen(r, backlog);
  8028f3:	83 ec 08             	sub    $0x8,%esp
  8028f6:	ff 75 0c             	pushl  0xc(%ebp)
  8028f9:	50                   	push   %eax
  8028fa:	e8 6b 01 00 00       	call   802a6a <nsipc_listen>
  8028ff:	83 c4 10             	add    $0x10,%esp
}
  802902:	c9                   	leave  
  802903:	c3                   	ret    

00802904 <socket>:

int
socket(int domain, int type, int protocol)
{
  802904:	55                   	push   %ebp
  802905:	89 e5                	mov    %esp,%ebp
  802907:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80290a:	ff 75 10             	pushl  0x10(%ebp)
  80290d:	ff 75 0c             	pushl  0xc(%ebp)
  802910:	ff 75 08             	pushl  0x8(%ebp)
  802913:	e8 3e 02 00 00       	call   802b56 <nsipc_socket>
  802918:	83 c4 10             	add    $0x10,%esp
  80291b:	85 c0                	test   %eax,%eax
  80291d:	78 05                	js     802924 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80291f:	e8 ab fe ff ff       	call   8027cf <alloc_sockfd>
}
  802924:	c9                   	leave  
  802925:	c3                   	ret    

00802926 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802926:	55                   	push   %ebp
  802927:	89 e5                	mov    %esp,%ebp
  802929:	53                   	push   %ebx
  80292a:	83 ec 04             	sub    $0x4,%esp
  80292d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80292f:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802936:	74 26                	je     80295e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802938:	6a 07                	push   $0x7
  80293a:	68 00 70 80 00       	push   $0x807000
  80293f:	53                   	push   %ebx
  802940:	ff 35 04 50 80 00    	pushl  0x805004
  802946:	e8 45 03 00 00       	call   802c90 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80294b:	83 c4 0c             	add    $0xc,%esp
  80294e:	6a 00                	push   $0x0
  802950:	6a 00                	push   $0x0
  802952:	6a 00                	push   $0x0
  802954:	e8 c4 02 00 00       	call   802c1d <ipc_recv>
}
  802959:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80295c:	c9                   	leave  
  80295d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80295e:	83 ec 0c             	sub    $0xc,%esp
  802961:	6a 02                	push   $0x2
  802963:	e8 94 03 00 00       	call   802cfc <ipc_find_env>
  802968:	a3 04 50 80 00       	mov    %eax,0x805004
  80296d:	83 c4 10             	add    $0x10,%esp
  802970:	eb c6                	jmp    802938 <nsipc+0x12>

00802972 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802972:	55                   	push   %ebp
  802973:	89 e5                	mov    %esp,%ebp
  802975:	56                   	push   %esi
  802976:	53                   	push   %ebx
  802977:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80297a:	8b 45 08             	mov    0x8(%ebp),%eax
  80297d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802982:	8b 06                	mov    (%esi),%eax
  802984:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802989:	b8 01 00 00 00       	mov    $0x1,%eax
  80298e:	e8 93 ff ff ff       	call   802926 <nsipc>
  802993:	89 c3                	mov    %eax,%ebx
  802995:	85 c0                	test   %eax,%eax
  802997:	79 09                	jns    8029a2 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802999:	89 d8                	mov    %ebx,%eax
  80299b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80299e:	5b                   	pop    %ebx
  80299f:	5e                   	pop    %esi
  8029a0:	5d                   	pop    %ebp
  8029a1:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8029a2:	83 ec 04             	sub    $0x4,%esp
  8029a5:	ff 35 10 70 80 00    	pushl  0x807010
  8029ab:	68 00 70 80 00       	push   $0x807000
  8029b0:	ff 75 0c             	pushl  0xc(%ebp)
  8029b3:	e8 73 e3 ff ff       	call   800d2b <memmove>
		*addrlen = ret->ret_addrlen;
  8029b8:	a1 10 70 80 00       	mov    0x807010,%eax
  8029bd:	89 06                	mov    %eax,(%esi)
  8029bf:	83 c4 10             	add    $0x10,%esp
	return r;
  8029c2:	eb d5                	jmp    802999 <nsipc_accept+0x27>

008029c4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8029c4:	55                   	push   %ebp
  8029c5:	89 e5                	mov    %esp,%ebp
  8029c7:	53                   	push   %ebx
  8029c8:	83 ec 08             	sub    $0x8,%esp
  8029cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8029ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d1:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8029d6:	53                   	push   %ebx
  8029d7:	ff 75 0c             	pushl  0xc(%ebp)
  8029da:	68 04 70 80 00       	push   $0x807004
  8029df:	e8 47 e3 ff ff       	call   800d2b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8029e4:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8029ea:	b8 02 00 00 00       	mov    $0x2,%eax
  8029ef:	e8 32 ff ff ff       	call   802926 <nsipc>
}
  8029f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029f7:	c9                   	leave  
  8029f8:	c3                   	ret    

008029f9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8029f9:	55                   	push   %ebp
  8029fa:	89 e5                	mov    %esp,%ebp
  8029fc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802a02:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a0a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802a0f:	b8 03 00 00 00       	mov    $0x3,%eax
  802a14:	e8 0d ff ff ff       	call   802926 <nsipc>
}
  802a19:	c9                   	leave  
  802a1a:	c3                   	ret    

00802a1b <nsipc_close>:

int
nsipc_close(int s)
{
  802a1b:	55                   	push   %ebp
  802a1c:	89 e5                	mov    %esp,%ebp
  802a1e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802a29:	b8 04 00 00 00       	mov    $0x4,%eax
  802a2e:	e8 f3 fe ff ff       	call   802926 <nsipc>
}
  802a33:	c9                   	leave  
  802a34:	c3                   	ret    

00802a35 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802a35:	55                   	push   %ebp
  802a36:	89 e5                	mov    %esp,%ebp
  802a38:	53                   	push   %ebx
  802a39:	83 ec 08             	sub    $0x8,%esp
  802a3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802a47:	53                   	push   %ebx
  802a48:	ff 75 0c             	pushl  0xc(%ebp)
  802a4b:	68 04 70 80 00       	push   $0x807004
  802a50:	e8 d6 e2 ff ff       	call   800d2b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802a55:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802a5b:	b8 05 00 00 00       	mov    $0x5,%eax
  802a60:	e8 c1 fe ff ff       	call   802926 <nsipc>
}
  802a65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a68:	c9                   	leave  
  802a69:	c3                   	ret    

00802a6a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802a6a:	55                   	push   %ebp
  802a6b:	89 e5                	mov    %esp,%ebp
  802a6d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802a70:	8b 45 08             	mov    0x8(%ebp),%eax
  802a73:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a7b:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802a80:	b8 06 00 00 00       	mov    $0x6,%eax
  802a85:	e8 9c fe ff ff       	call   802926 <nsipc>
}
  802a8a:	c9                   	leave  
  802a8b:	c3                   	ret    

00802a8c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802a8c:	55                   	push   %ebp
  802a8d:	89 e5                	mov    %esp,%ebp
  802a8f:	56                   	push   %esi
  802a90:	53                   	push   %ebx
  802a91:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802a9c:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  802aa5:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802aaa:	b8 07 00 00 00       	mov    $0x7,%eax
  802aaf:	e8 72 fe ff ff       	call   802926 <nsipc>
  802ab4:	89 c3                	mov    %eax,%ebx
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	78 1f                	js     802ad9 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802aba:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802abf:	7f 21                	jg     802ae2 <nsipc_recv+0x56>
  802ac1:	39 c6                	cmp    %eax,%esi
  802ac3:	7c 1d                	jl     802ae2 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802ac5:	83 ec 04             	sub    $0x4,%esp
  802ac8:	50                   	push   %eax
  802ac9:	68 00 70 80 00       	push   $0x807000
  802ace:	ff 75 0c             	pushl  0xc(%ebp)
  802ad1:	e8 55 e2 ff ff       	call   800d2b <memmove>
  802ad6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802ad9:	89 d8                	mov    %ebx,%eax
  802adb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ade:	5b                   	pop    %ebx
  802adf:	5e                   	pop    %esi
  802ae0:	5d                   	pop    %ebp
  802ae1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802ae2:	68 97 37 80 00       	push   $0x803797
  802ae7:	68 6c 36 80 00       	push   $0x80366c
  802aec:	6a 62                	push   $0x62
  802aee:	68 ac 37 80 00       	push   $0x8037ac
  802af3:	e8 ee d9 ff ff       	call   8004e6 <_panic>

00802af8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802af8:	55                   	push   %ebp
  802af9:	89 e5                	mov    %esp,%ebp
  802afb:	53                   	push   %ebx
  802afc:	83 ec 04             	sub    $0x4,%esp
  802aff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802b0a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802b10:	7f 2e                	jg     802b40 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802b12:	83 ec 04             	sub    $0x4,%esp
  802b15:	53                   	push   %ebx
  802b16:	ff 75 0c             	pushl  0xc(%ebp)
  802b19:	68 0c 70 80 00       	push   $0x80700c
  802b1e:	e8 08 e2 ff ff       	call   800d2b <memmove>
	nsipcbuf.send.req_size = size;
  802b23:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802b29:	8b 45 14             	mov    0x14(%ebp),%eax
  802b2c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802b31:	b8 08 00 00 00       	mov    $0x8,%eax
  802b36:	e8 eb fd ff ff       	call   802926 <nsipc>
}
  802b3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b3e:	c9                   	leave  
  802b3f:	c3                   	ret    
	assert(size < 1600);
  802b40:	68 b8 37 80 00       	push   $0x8037b8
  802b45:	68 6c 36 80 00       	push   $0x80366c
  802b4a:	6a 6d                	push   $0x6d
  802b4c:	68 ac 37 80 00       	push   $0x8037ac
  802b51:	e8 90 d9 ff ff       	call   8004e6 <_panic>

00802b56 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802b56:	55                   	push   %ebp
  802b57:	89 e5                	mov    %esp,%ebp
  802b59:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b67:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802b6c:	8b 45 10             	mov    0x10(%ebp),%eax
  802b6f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802b74:	b8 09 00 00 00       	mov    $0x9,%eax
  802b79:	e8 a8 fd ff ff       	call   802926 <nsipc>
}
  802b7e:	c9                   	leave  
  802b7f:	c3                   	ret    

00802b80 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802b80:	55                   	push   %ebp
  802b81:	89 e5                	mov    %esp,%ebp
  802b83:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802b86:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802b8d:	74 0a                	je     802b99 <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802b97:	c9                   	leave  
  802b98:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802b99:	a1 08 50 80 00       	mov    0x805008,%eax
  802b9e:	8b 40 48             	mov    0x48(%eax),%eax
  802ba1:	83 ec 04             	sub    $0x4,%esp
  802ba4:	6a 07                	push   $0x7
  802ba6:	68 00 f0 bf ee       	push   $0xeebff000
  802bab:	50                   	push   %eax
  802bac:	e8 de e3 ff ff       	call   800f8f <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802bb1:	83 c4 10             	add    $0x10,%esp
  802bb4:	85 c0                	test   %eax,%eax
  802bb6:	78 2c                	js     802be4 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802bb8:	e8 94 e3 ff ff       	call   800f51 <sys_getenvid>
  802bbd:	83 ec 08             	sub    $0x8,%esp
  802bc0:	68 f6 2b 80 00       	push   $0x802bf6
  802bc5:	50                   	push   %eax
  802bc6:	e8 0f e5 ff ff       	call   8010da <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802bcb:	83 c4 10             	add    $0x10,%esp
  802bce:	85 c0                	test   %eax,%eax
  802bd0:	79 bd                	jns    802b8f <set_pgfault_handler+0xf>
  802bd2:	50                   	push   %eax
  802bd3:	68 c4 37 80 00       	push   $0x8037c4
  802bd8:	6a 23                	push   $0x23
  802bda:	68 dc 37 80 00       	push   $0x8037dc
  802bdf:	e8 02 d9 ff ff       	call   8004e6 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802be4:	50                   	push   %eax
  802be5:	68 c4 37 80 00       	push   $0x8037c4
  802bea:	6a 21                	push   $0x21
  802bec:	68 dc 37 80 00       	push   $0x8037dc
  802bf1:	e8 f0 d8 ff ff       	call   8004e6 <_panic>

00802bf6 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802bf6:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802bf7:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802bfc:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802bfe:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  802c01:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  802c05:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  802c08:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  802c0c:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  802c10:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802c13:	83 c4 08             	add    $0x8,%esp
	popal
  802c16:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802c17:	83 c4 04             	add    $0x4,%esp
	popfl
  802c1a:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802c1b:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802c1c:	c3                   	ret    

00802c1d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c1d:	55                   	push   %ebp
  802c1e:	89 e5                	mov    %esp,%ebp
  802c20:	56                   	push   %esi
  802c21:	53                   	push   %ebx
  802c22:	8b 75 08             	mov    0x8(%ebp),%esi
  802c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	74 4f                	je     802c7e <ipc_recv+0x61>
  802c2f:	83 ec 0c             	sub    $0xc,%esp
  802c32:	50                   	push   %eax
  802c33:	e8 07 e5 ff ff       	call   80113f <sys_ipc_recv>
  802c38:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  802c3b:	85 f6                	test   %esi,%esi
  802c3d:	74 14                	je     802c53 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  802c44:	85 c0                	test   %eax,%eax
  802c46:	75 09                	jne    802c51 <ipc_recv+0x34>
  802c48:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802c4e:	8b 52 74             	mov    0x74(%edx),%edx
  802c51:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  802c53:	85 db                	test   %ebx,%ebx
  802c55:	74 14                	je     802c6b <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  802c57:	ba 00 00 00 00       	mov    $0x0,%edx
  802c5c:	85 c0                	test   %eax,%eax
  802c5e:	75 09                	jne    802c69 <ipc_recv+0x4c>
  802c60:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802c66:	8b 52 78             	mov    0x78(%edx),%edx
  802c69:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  802c6b:	85 c0                	test   %eax,%eax
  802c6d:	75 08                	jne    802c77 <ipc_recv+0x5a>
  802c6f:	a1 08 50 80 00       	mov    0x805008,%eax
  802c74:	8b 40 70             	mov    0x70(%eax),%eax
}
  802c77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c7a:	5b                   	pop    %ebx
  802c7b:	5e                   	pop    %esi
  802c7c:	5d                   	pop    %ebp
  802c7d:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802c7e:	83 ec 0c             	sub    $0xc,%esp
  802c81:	68 00 00 c0 ee       	push   $0xeec00000
  802c86:	e8 b4 e4 ff ff       	call   80113f <sys_ipc_recv>
  802c8b:	83 c4 10             	add    $0x10,%esp
  802c8e:	eb ab                	jmp    802c3b <ipc_recv+0x1e>

00802c90 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802c90:	55                   	push   %ebp
  802c91:	89 e5                	mov    %esp,%ebp
  802c93:	57                   	push   %edi
  802c94:	56                   	push   %esi
  802c95:	53                   	push   %ebx
  802c96:	83 ec 0c             	sub    $0xc,%esp
  802c99:	8b 7d 08             	mov    0x8(%ebp),%edi
  802c9c:	8b 75 10             	mov    0x10(%ebp),%esi
  802c9f:	eb 20                	jmp    802cc1 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802ca1:	6a 00                	push   $0x0
  802ca3:	68 00 00 c0 ee       	push   $0xeec00000
  802ca8:	ff 75 0c             	pushl  0xc(%ebp)
  802cab:	57                   	push   %edi
  802cac:	e8 6b e4 ff ff       	call   80111c <sys_ipc_try_send>
  802cb1:	89 c3                	mov    %eax,%ebx
  802cb3:	83 c4 10             	add    $0x10,%esp
  802cb6:	eb 1f                	jmp    802cd7 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802cb8:	e8 b3 e2 ff ff       	call   800f70 <sys_yield>
	while(retval != 0) {
  802cbd:	85 db                	test   %ebx,%ebx
  802cbf:	74 33                	je     802cf4 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802cc1:	85 f6                	test   %esi,%esi
  802cc3:	74 dc                	je     802ca1 <ipc_send+0x11>
  802cc5:	ff 75 14             	pushl  0x14(%ebp)
  802cc8:	56                   	push   %esi
  802cc9:	ff 75 0c             	pushl  0xc(%ebp)
  802ccc:	57                   	push   %edi
  802ccd:	e8 4a e4 ff ff       	call   80111c <sys_ipc_try_send>
  802cd2:	89 c3                	mov    %eax,%ebx
  802cd4:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802cd7:	83 fb f9             	cmp    $0xfffffff9,%ebx
  802cda:	74 dc                	je     802cb8 <ipc_send+0x28>
  802cdc:	85 db                	test   %ebx,%ebx
  802cde:	74 d8                	je     802cb8 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802ce0:	83 ec 04             	sub    $0x4,%esp
  802ce3:	68 ec 37 80 00       	push   $0x8037ec
  802ce8:	6a 35                	push   $0x35
  802cea:	68 1c 38 80 00       	push   $0x80381c
  802cef:	e8 f2 d7 ff ff       	call   8004e6 <_panic>
	}
}
  802cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cf7:	5b                   	pop    %ebx
  802cf8:	5e                   	pop    %esi
  802cf9:	5f                   	pop    %edi
  802cfa:	5d                   	pop    %ebp
  802cfb:	c3                   	ret    

00802cfc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802cfc:	55                   	push   %ebp
  802cfd:	89 e5                	mov    %esp,%ebp
  802cff:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802d02:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802d07:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802d0a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802d10:	8b 52 50             	mov    0x50(%edx),%edx
  802d13:	39 ca                	cmp    %ecx,%edx
  802d15:	74 11                	je     802d28 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802d17:	83 c0 01             	add    $0x1,%eax
  802d1a:	3d 00 04 00 00       	cmp    $0x400,%eax
  802d1f:	75 e6                	jne    802d07 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802d21:	b8 00 00 00 00       	mov    $0x0,%eax
  802d26:	eb 0b                	jmp    802d33 <ipc_find_env+0x37>
			return envs[i].env_id;
  802d28:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802d2b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802d30:	8b 40 48             	mov    0x48(%eax),%eax
}
  802d33:	5d                   	pop    %ebp
  802d34:	c3                   	ret    

00802d35 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802d35:	55                   	push   %ebp
  802d36:	89 e5                	mov    %esp,%ebp
  802d38:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d3b:	89 d0                	mov    %edx,%eax
  802d3d:	c1 e8 16             	shr    $0x16,%eax
  802d40:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802d47:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802d4c:	f6 c1 01             	test   $0x1,%cl
  802d4f:	74 1d                	je     802d6e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802d51:	c1 ea 0c             	shr    $0xc,%edx
  802d54:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802d5b:	f6 c2 01             	test   $0x1,%dl
  802d5e:	74 0e                	je     802d6e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802d60:	c1 ea 0c             	shr    $0xc,%edx
  802d63:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802d6a:	ef 
  802d6b:	0f b7 c0             	movzwl %ax,%eax
}
  802d6e:	5d                   	pop    %ebp
  802d6f:	c3                   	ret    

00802d70 <__udivdi3>:
  802d70:	f3 0f 1e fb          	endbr32 
  802d74:	55                   	push   %ebp
  802d75:	57                   	push   %edi
  802d76:	56                   	push   %esi
  802d77:	53                   	push   %ebx
  802d78:	83 ec 1c             	sub    $0x1c,%esp
  802d7b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802d7f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802d83:	8b 74 24 34          	mov    0x34(%esp),%esi
  802d87:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802d8b:	85 d2                	test   %edx,%edx
  802d8d:	75 49                	jne    802dd8 <__udivdi3+0x68>
  802d8f:	39 f3                	cmp    %esi,%ebx
  802d91:	76 15                	jbe    802da8 <__udivdi3+0x38>
  802d93:	31 ff                	xor    %edi,%edi
  802d95:	89 e8                	mov    %ebp,%eax
  802d97:	89 f2                	mov    %esi,%edx
  802d99:	f7 f3                	div    %ebx
  802d9b:	89 fa                	mov    %edi,%edx
  802d9d:	83 c4 1c             	add    $0x1c,%esp
  802da0:	5b                   	pop    %ebx
  802da1:	5e                   	pop    %esi
  802da2:	5f                   	pop    %edi
  802da3:	5d                   	pop    %ebp
  802da4:	c3                   	ret    
  802da5:	8d 76 00             	lea    0x0(%esi),%esi
  802da8:	89 d9                	mov    %ebx,%ecx
  802daa:	85 db                	test   %ebx,%ebx
  802dac:	75 0b                	jne    802db9 <__udivdi3+0x49>
  802dae:	b8 01 00 00 00       	mov    $0x1,%eax
  802db3:	31 d2                	xor    %edx,%edx
  802db5:	f7 f3                	div    %ebx
  802db7:	89 c1                	mov    %eax,%ecx
  802db9:	31 d2                	xor    %edx,%edx
  802dbb:	89 f0                	mov    %esi,%eax
  802dbd:	f7 f1                	div    %ecx
  802dbf:	89 c6                	mov    %eax,%esi
  802dc1:	89 e8                	mov    %ebp,%eax
  802dc3:	89 f7                	mov    %esi,%edi
  802dc5:	f7 f1                	div    %ecx
  802dc7:	89 fa                	mov    %edi,%edx
  802dc9:	83 c4 1c             	add    $0x1c,%esp
  802dcc:	5b                   	pop    %ebx
  802dcd:	5e                   	pop    %esi
  802dce:	5f                   	pop    %edi
  802dcf:	5d                   	pop    %ebp
  802dd0:	c3                   	ret    
  802dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802dd8:	39 f2                	cmp    %esi,%edx
  802dda:	77 1c                	ja     802df8 <__udivdi3+0x88>
  802ddc:	0f bd fa             	bsr    %edx,%edi
  802ddf:	83 f7 1f             	xor    $0x1f,%edi
  802de2:	75 2c                	jne    802e10 <__udivdi3+0xa0>
  802de4:	39 f2                	cmp    %esi,%edx
  802de6:	72 06                	jb     802dee <__udivdi3+0x7e>
  802de8:	31 c0                	xor    %eax,%eax
  802dea:	39 eb                	cmp    %ebp,%ebx
  802dec:	77 ad                	ja     802d9b <__udivdi3+0x2b>
  802dee:	b8 01 00 00 00       	mov    $0x1,%eax
  802df3:	eb a6                	jmp    802d9b <__udivdi3+0x2b>
  802df5:	8d 76 00             	lea    0x0(%esi),%esi
  802df8:	31 ff                	xor    %edi,%edi
  802dfa:	31 c0                	xor    %eax,%eax
  802dfc:	89 fa                	mov    %edi,%edx
  802dfe:	83 c4 1c             	add    $0x1c,%esp
  802e01:	5b                   	pop    %ebx
  802e02:	5e                   	pop    %esi
  802e03:	5f                   	pop    %edi
  802e04:	5d                   	pop    %ebp
  802e05:	c3                   	ret    
  802e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e0d:	8d 76 00             	lea    0x0(%esi),%esi
  802e10:	89 f9                	mov    %edi,%ecx
  802e12:	b8 20 00 00 00       	mov    $0x20,%eax
  802e17:	29 f8                	sub    %edi,%eax
  802e19:	d3 e2                	shl    %cl,%edx
  802e1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e1f:	89 c1                	mov    %eax,%ecx
  802e21:	89 da                	mov    %ebx,%edx
  802e23:	d3 ea                	shr    %cl,%edx
  802e25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802e29:	09 d1                	or     %edx,%ecx
  802e2b:	89 f2                	mov    %esi,%edx
  802e2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e31:	89 f9                	mov    %edi,%ecx
  802e33:	d3 e3                	shl    %cl,%ebx
  802e35:	89 c1                	mov    %eax,%ecx
  802e37:	d3 ea                	shr    %cl,%edx
  802e39:	89 f9                	mov    %edi,%ecx
  802e3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802e3f:	89 eb                	mov    %ebp,%ebx
  802e41:	d3 e6                	shl    %cl,%esi
  802e43:	89 c1                	mov    %eax,%ecx
  802e45:	d3 eb                	shr    %cl,%ebx
  802e47:	09 de                	or     %ebx,%esi
  802e49:	89 f0                	mov    %esi,%eax
  802e4b:	f7 74 24 08          	divl   0x8(%esp)
  802e4f:	89 d6                	mov    %edx,%esi
  802e51:	89 c3                	mov    %eax,%ebx
  802e53:	f7 64 24 0c          	mull   0xc(%esp)
  802e57:	39 d6                	cmp    %edx,%esi
  802e59:	72 15                	jb     802e70 <__udivdi3+0x100>
  802e5b:	89 f9                	mov    %edi,%ecx
  802e5d:	d3 e5                	shl    %cl,%ebp
  802e5f:	39 c5                	cmp    %eax,%ebp
  802e61:	73 04                	jae    802e67 <__udivdi3+0xf7>
  802e63:	39 d6                	cmp    %edx,%esi
  802e65:	74 09                	je     802e70 <__udivdi3+0x100>
  802e67:	89 d8                	mov    %ebx,%eax
  802e69:	31 ff                	xor    %edi,%edi
  802e6b:	e9 2b ff ff ff       	jmp    802d9b <__udivdi3+0x2b>
  802e70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e73:	31 ff                	xor    %edi,%edi
  802e75:	e9 21 ff ff ff       	jmp    802d9b <__udivdi3+0x2b>
  802e7a:	66 90                	xchg   %ax,%ax
  802e7c:	66 90                	xchg   %ax,%ax
  802e7e:	66 90                	xchg   %ax,%ax

00802e80 <__umoddi3>:
  802e80:	f3 0f 1e fb          	endbr32 
  802e84:	55                   	push   %ebp
  802e85:	57                   	push   %edi
  802e86:	56                   	push   %esi
  802e87:	53                   	push   %ebx
  802e88:	83 ec 1c             	sub    $0x1c,%esp
  802e8b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802e8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e93:	8b 74 24 30          	mov    0x30(%esp),%esi
  802e97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e9b:	89 da                	mov    %ebx,%edx
  802e9d:	85 c0                	test   %eax,%eax
  802e9f:	75 3f                	jne    802ee0 <__umoddi3+0x60>
  802ea1:	39 df                	cmp    %ebx,%edi
  802ea3:	76 13                	jbe    802eb8 <__umoddi3+0x38>
  802ea5:	89 f0                	mov    %esi,%eax
  802ea7:	f7 f7                	div    %edi
  802ea9:	89 d0                	mov    %edx,%eax
  802eab:	31 d2                	xor    %edx,%edx
  802ead:	83 c4 1c             	add    $0x1c,%esp
  802eb0:	5b                   	pop    %ebx
  802eb1:	5e                   	pop    %esi
  802eb2:	5f                   	pop    %edi
  802eb3:	5d                   	pop    %ebp
  802eb4:	c3                   	ret    
  802eb5:	8d 76 00             	lea    0x0(%esi),%esi
  802eb8:	89 fd                	mov    %edi,%ebp
  802eba:	85 ff                	test   %edi,%edi
  802ebc:	75 0b                	jne    802ec9 <__umoddi3+0x49>
  802ebe:	b8 01 00 00 00       	mov    $0x1,%eax
  802ec3:	31 d2                	xor    %edx,%edx
  802ec5:	f7 f7                	div    %edi
  802ec7:	89 c5                	mov    %eax,%ebp
  802ec9:	89 d8                	mov    %ebx,%eax
  802ecb:	31 d2                	xor    %edx,%edx
  802ecd:	f7 f5                	div    %ebp
  802ecf:	89 f0                	mov    %esi,%eax
  802ed1:	f7 f5                	div    %ebp
  802ed3:	89 d0                	mov    %edx,%eax
  802ed5:	eb d4                	jmp    802eab <__umoddi3+0x2b>
  802ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ede:	66 90                	xchg   %ax,%ax
  802ee0:	89 f1                	mov    %esi,%ecx
  802ee2:	39 d8                	cmp    %ebx,%eax
  802ee4:	76 0a                	jbe    802ef0 <__umoddi3+0x70>
  802ee6:	89 f0                	mov    %esi,%eax
  802ee8:	83 c4 1c             	add    $0x1c,%esp
  802eeb:	5b                   	pop    %ebx
  802eec:	5e                   	pop    %esi
  802eed:	5f                   	pop    %edi
  802eee:	5d                   	pop    %ebp
  802eef:	c3                   	ret    
  802ef0:	0f bd e8             	bsr    %eax,%ebp
  802ef3:	83 f5 1f             	xor    $0x1f,%ebp
  802ef6:	75 20                	jne    802f18 <__umoddi3+0x98>
  802ef8:	39 d8                	cmp    %ebx,%eax
  802efa:	0f 82 b0 00 00 00    	jb     802fb0 <__umoddi3+0x130>
  802f00:	39 f7                	cmp    %esi,%edi
  802f02:	0f 86 a8 00 00 00    	jbe    802fb0 <__umoddi3+0x130>
  802f08:	89 c8                	mov    %ecx,%eax
  802f0a:	83 c4 1c             	add    $0x1c,%esp
  802f0d:	5b                   	pop    %ebx
  802f0e:	5e                   	pop    %esi
  802f0f:	5f                   	pop    %edi
  802f10:	5d                   	pop    %ebp
  802f11:	c3                   	ret    
  802f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802f18:	89 e9                	mov    %ebp,%ecx
  802f1a:	ba 20 00 00 00       	mov    $0x20,%edx
  802f1f:	29 ea                	sub    %ebp,%edx
  802f21:	d3 e0                	shl    %cl,%eax
  802f23:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f27:	89 d1                	mov    %edx,%ecx
  802f29:	89 f8                	mov    %edi,%eax
  802f2b:	d3 e8                	shr    %cl,%eax
  802f2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802f31:	89 54 24 04          	mov    %edx,0x4(%esp)
  802f35:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f39:	09 c1                	or     %eax,%ecx
  802f3b:	89 d8                	mov    %ebx,%eax
  802f3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f41:	89 e9                	mov    %ebp,%ecx
  802f43:	d3 e7                	shl    %cl,%edi
  802f45:	89 d1                	mov    %edx,%ecx
  802f47:	d3 e8                	shr    %cl,%eax
  802f49:	89 e9                	mov    %ebp,%ecx
  802f4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f4f:	d3 e3                	shl    %cl,%ebx
  802f51:	89 c7                	mov    %eax,%edi
  802f53:	89 d1                	mov    %edx,%ecx
  802f55:	89 f0                	mov    %esi,%eax
  802f57:	d3 e8                	shr    %cl,%eax
  802f59:	89 e9                	mov    %ebp,%ecx
  802f5b:	89 fa                	mov    %edi,%edx
  802f5d:	d3 e6                	shl    %cl,%esi
  802f5f:	09 d8                	or     %ebx,%eax
  802f61:	f7 74 24 08          	divl   0x8(%esp)
  802f65:	89 d1                	mov    %edx,%ecx
  802f67:	89 f3                	mov    %esi,%ebx
  802f69:	f7 64 24 0c          	mull   0xc(%esp)
  802f6d:	89 c6                	mov    %eax,%esi
  802f6f:	89 d7                	mov    %edx,%edi
  802f71:	39 d1                	cmp    %edx,%ecx
  802f73:	72 06                	jb     802f7b <__umoddi3+0xfb>
  802f75:	75 10                	jne    802f87 <__umoddi3+0x107>
  802f77:	39 c3                	cmp    %eax,%ebx
  802f79:	73 0c                	jae    802f87 <__umoddi3+0x107>
  802f7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802f7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802f83:	89 d7                	mov    %edx,%edi
  802f85:	89 c6                	mov    %eax,%esi
  802f87:	89 ca                	mov    %ecx,%edx
  802f89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802f8e:	29 f3                	sub    %esi,%ebx
  802f90:	19 fa                	sbb    %edi,%edx
  802f92:	89 d0                	mov    %edx,%eax
  802f94:	d3 e0                	shl    %cl,%eax
  802f96:	89 e9                	mov    %ebp,%ecx
  802f98:	d3 eb                	shr    %cl,%ebx
  802f9a:	d3 ea                	shr    %cl,%edx
  802f9c:	09 d8                	or     %ebx,%eax
  802f9e:	83 c4 1c             	add    $0x1c,%esp
  802fa1:	5b                   	pop    %ebx
  802fa2:	5e                   	pop    %esi
  802fa3:	5f                   	pop    %edi
  802fa4:	5d                   	pop    %ebp
  802fa5:	c3                   	ret    
  802fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802fad:	8d 76 00             	lea    0x0(%esi),%esi
  802fb0:	89 da                	mov    %ebx,%edx
  802fb2:	29 fe                	sub    %edi,%esi
  802fb4:	19 c2                	sbb    %eax,%edx
  802fb6:	89 f1                	mov    %esi,%ecx
  802fb8:	89 c8                	mov    %ecx,%eax
  802fba:	e9 4b ff ff ff       	jmp    802f0a <__umoddi3+0x8a>
