
obj/user/init.debug：     文件格式 elf32-i386


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
  80002c:	e8 65 03 00 00       	call   800396 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800043:	ba 00 00 00 00       	mov    $0x0,%edx
  800048:	39 da                	cmp    %ebx,%edx
  80004a:	7d 0e                	jge    80005a <sum+0x27>
		tot ^= i * s[i];
  80004c:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  800050:	0f af ca             	imul   %edx,%ecx
  800053:	31 c8                	xor    %ecx,%eax
	for (i = 0; i < n; i++)
  800055:	83 c2 01             	add    $0x1,%edx
  800058:	eb ee                	jmp    800048 <sum+0x15>
	return tot;
}
  80005a:	5b                   	pop    %ebx
  80005b:	5e                   	pop    %esi
  80005c:	5d                   	pop    %ebp
  80005d:	c3                   	ret    

0080005e <umain>:

void
umain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	57                   	push   %edi
  800062:	56                   	push   %esi
  800063:	53                   	push   %ebx
  800064:	81 ec 18 01 00 00    	sub    $0x118,%esp
  80006a:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80006d:	68 a0 2a 80 00       	push   $0x802aa0
  800072:	e8 5a 04 00 00       	call   8004d1 <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800077:	83 c4 08             	add    $0x8,%esp
  80007a:	68 70 17 00 00       	push   $0x1770
  80007f:	68 00 40 80 00       	push   $0x804000
  800084:	e8 aa ff ff ff       	call   800033 <sum>
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  800091:	0f 84 99 00 00 00    	je     800130 <umain+0xd2>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 9e 98 0f 00       	push   $0xf989e
  80009f:	50                   	push   %eax
  8000a0:	68 68 2b 80 00       	push   $0x802b68
  8000a5:	e8 27 04 00 00       	call   8004d1 <cprintf>
  8000aa:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	68 70 17 00 00       	push   $0x1770
  8000b5:	68 20 60 80 00       	push   $0x806020
  8000ba:	e8 74 ff ff ff       	call   800033 <sum>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	74 7f                	je     800145 <umain+0xe7>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	50                   	push   %eax
  8000ca:	68 a4 2b 80 00       	push   $0x802ba4
  8000cf:	e8 fd 03 00 00       	call   8004d1 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	68 dc 2a 80 00       	push   $0x802adc
  8000df:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 e2 09 00 00       	call   800acd <strcat>
	for (i = 0; i < argc; i++) {
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  8000f3:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	for (i = 0; i < argc; i++) {
  8000f9:	39 fb                	cmp    %edi,%ebx
  8000fb:	7d 5a                	jge    800157 <umain+0xf9>
		strcat(args, " '");
  8000fd:	83 ec 08             	sub    $0x8,%esp
  800100:	68 e8 2a 80 00       	push   $0x802ae8
  800105:	56                   	push   %esi
  800106:	e8 c2 09 00 00       	call   800acd <strcat>
		strcat(args, argv[i]);
  80010b:	83 c4 08             	add    $0x8,%esp
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	ff 34 98             	pushl  (%eax,%ebx,4)
  800114:	56                   	push   %esi
  800115:	e8 b3 09 00 00       	call   800acd <strcat>
		strcat(args, "'");
  80011a:	83 c4 08             	add    $0x8,%esp
  80011d:	68 e9 2a 80 00       	push   $0x802ae9
  800122:	56                   	push   %esi
  800123:	e8 a5 09 00 00       	call   800acd <strcat>
	for (i = 0; i < argc; i++) {
  800128:	83 c3 01             	add    $0x1,%ebx
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb c9                	jmp    8000f9 <umain+0x9b>
		cprintf("init: data seems okay\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 af 2a 80 00       	push   $0x802aaf
  800138:	e8 94 03 00 00       	call   8004d1 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	e9 68 ff ff ff       	jmp    8000ad <umain+0x4f>
		cprintf("init: bss seems okay\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 c6 2a 80 00       	push   $0x802ac6
  80014d:	e8 7f 03 00 00       	call   8004d1 <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb 80                	jmp    8000d7 <umain+0x79>
	}
	cprintf("%s\n", args);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800160:	50                   	push   %eax
  800161:	68 eb 2a 80 00       	push   $0x802aeb
  800166:	e8 66 03 00 00       	call   8004d1 <cprintf>

	cprintf("init: running sh\n");
  80016b:	c7 04 24 ef 2a 80 00 	movl   $0x802aef,(%esp)
  800172:	e8 5a 03 00 00       	call   8004d1 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 d7 10 00 00       	call   80125a <close>
	if ((r = opencons()) < 0)
  800183:	e8 bc 01 00 00       	call   800344 <opencons>
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	85 c0                	test   %eax,%eax
  80018d:	78 14                	js     8001a3 <umain+0x145>
		panic("opencons: %e", r);
	if (r != 0)
  80018f:	74 24                	je     8001b5 <umain+0x157>
		panic("first opencons used fd %d", r);
  800191:	50                   	push   %eax
  800192:	68 1a 2b 80 00       	push   $0x802b1a
  800197:	6a 39                	push   $0x39
  800199:	68 0e 2b 80 00       	push   $0x802b0e
  80019e:	e8 53 02 00 00       	call   8003f6 <_panic>
		panic("opencons: %e", r);
  8001a3:	50                   	push   %eax
  8001a4:	68 01 2b 80 00       	push   $0x802b01
  8001a9:	6a 37                	push   $0x37
  8001ab:	68 0e 2b 80 00       	push   $0x802b0e
  8001b0:	e8 41 02 00 00       	call   8003f6 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	6a 01                	push   $0x1
  8001ba:	6a 00                	push   $0x0
  8001bc:	e8 eb 10 00 00       	call   8012ac <dup>
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	85 c0                	test   %eax,%eax
  8001c6:	79 23                	jns    8001eb <umain+0x18d>
		panic("dup: %e", r);
  8001c8:	50                   	push   %eax
  8001c9:	68 34 2b 80 00       	push   $0x802b34
  8001ce:	6a 3b                	push   $0x3b
  8001d0:	68 0e 2b 80 00       	push   $0x802b0e
  8001d5:	e8 1c 02 00 00       	call   8003f6 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	50                   	push   %eax
  8001de:	68 53 2b 80 00       	push   $0x802b53
  8001e3:	e8 e9 02 00 00       	call   8004d1 <cprintf>
			continue;
  8001e8:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	68 3c 2b 80 00       	push   $0x802b3c
  8001f3:	e8 d9 02 00 00       	call   8004d1 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001f8:	83 c4 0c             	add    $0xc,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	68 50 2b 80 00       	push   $0x802b50
  800202:	68 4f 2b 80 00       	push   $0x802b4f
  800207:	e8 5e 1c 00 00       	call   801e6a <spawnl>
		if (r < 0) {
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	85 c0                	test   %eax,%eax
  800211:	78 c7                	js     8001da <umain+0x17c>
		}
		wait(r);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	50                   	push   %eax
  800217:	e8 19 20 00 00       	call   802235 <wait>
  80021c:	83 c4 10             	add    $0x10,%esp
  80021f:	eb ca                	jmp    8001eb <umain+0x18d>

00800221 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800221:	b8 00 00 00 00       	mov    $0x0,%eax
  800226:	c3                   	ret    

00800227 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80022d:	68 d3 2b 80 00       	push   $0x802bd3
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	e8 73 08 00 00       	call   800aad <strcpy>
	return 0;
}
  80023a:	b8 00 00 00 00       	mov    $0x0,%eax
  80023f:	c9                   	leave  
  800240:	c3                   	ret    

00800241 <devcons_write>:
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	57                   	push   %edi
  800245:	56                   	push   %esi
  800246:	53                   	push   %ebx
  800247:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80024d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800252:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800258:	3b 75 10             	cmp    0x10(%ebp),%esi
  80025b:	73 31                	jae    80028e <devcons_write+0x4d>
		m = n - tot;
  80025d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800260:	29 f3                	sub    %esi,%ebx
  800262:	83 fb 7f             	cmp    $0x7f,%ebx
  800265:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80026a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80026d:	83 ec 04             	sub    $0x4,%esp
  800270:	53                   	push   %ebx
  800271:	89 f0                	mov    %esi,%eax
  800273:	03 45 0c             	add    0xc(%ebp),%eax
  800276:	50                   	push   %eax
  800277:	57                   	push   %edi
  800278:	e8 be 09 00 00       	call   800c3b <memmove>
		sys_cputs(buf, m);
  80027d:	83 c4 08             	add    $0x8,%esp
  800280:	53                   	push   %ebx
  800281:	57                   	push   %edi
  800282:	e8 5c 0b 00 00       	call   800de3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800287:	01 de                	add    %ebx,%esi
  800289:	83 c4 10             	add    $0x10,%esp
  80028c:	eb ca                	jmp    800258 <devcons_write+0x17>
}
  80028e:	89 f0                	mov    %esi,%eax
  800290:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800293:	5b                   	pop    %ebx
  800294:	5e                   	pop    %esi
  800295:	5f                   	pop    %edi
  800296:	5d                   	pop    %ebp
  800297:	c3                   	ret    

00800298 <devcons_read>:
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	83 ec 08             	sub    $0x8,%esp
  80029e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8002a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002a7:	74 21                	je     8002ca <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8002a9:	e8 53 0b 00 00       	call   800e01 <sys_cgetc>
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	75 07                	jne    8002b9 <devcons_read+0x21>
		sys_yield();
  8002b2:	e8 c9 0b 00 00       	call   800e80 <sys_yield>
  8002b7:	eb f0                	jmp    8002a9 <devcons_read+0x11>
	if (c < 0)
  8002b9:	78 0f                	js     8002ca <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8002bb:	83 f8 04             	cmp    $0x4,%eax
  8002be:	74 0c                	je     8002cc <devcons_read+0x34>
	*(char*)vbuf = c;
  8002c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c3:	88 02                	mov    %al,(%edx)
	return 1;
  8002c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8002ca:	c9                   	leave  
  8002cb:	c3                   	ret    
		return 0;
  8002cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d1:	eb f7                	jmp    8002ca <devcons_read+0x32>

008002d3 <cputchar>:
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002dc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8002df:	6a 01                	push   $0x1
  8002e1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002e4:	50                   	push   %eax
  8002e5:	e8 f9 0a 00 00       	call   800de3 <sys_cputs>
}
  8002ea:	83 c4 10             	add    $0x10,%esp
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <getchar>:
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8002f5:	6a 01                	push   $0x1
  8002f7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002fa:	50                   	push   %eax
  8002fb:	6a 00                	push   $0x0
  8002fd:	e8 96 10 00 00       	call   801398 <read>
	if (r < 0)
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	85 c0                	test   %eax,%eax
  800307:	78 06                	js     80030f <getchar+0x20>
	if (r < 1)
  800309:	74 06                	je     800311 <getchar+0x22>
	return c;
  80030b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80030f:	c9                   	leave  
  800310:	c3                   	ret    
		return -E_EOF;
  800311:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800316:	eb f7                	jmp    80030f <getchar+0x20>

00800318 <iscons>:
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80031e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800321:	50                   	push   %eax
  800322:	ff 75 08             	pushl  0x8(%ebp)
  800325:	e8 fe 0d 00 00       	call   801128 <fd_lookup>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	85 c0                	test   %eax,%eax
  80032f:	78 11                	js     800342 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8b 15 70 57 80 00    	mov    0x805770,%edx
  80033a:	39 10                	cmp    %edx,(%eax)
  80033c:	0f 94 c0             	sete   %al
  80033f:	0f b6 c0             	movzbl %al,%eax
}
  800342:	c9                   	leave  
  800343:	c3                   	ret    

00800344 <opencons>:
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80034a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80034d:	50                   	push   %eax
  80034e:	e8 83 0d 00 00       	call   8010d6 <fd_alloc>
  800353:	83 c4 10             	add    $0x10,%esp
  800356:	85 c0                	test   %eax,%eax
  800358:	78 3a                	js     800394 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80035a:	83 ec 04             	sub    $0x4,%esp
  80035d:	68 07 04 00 00       	push   $0x407
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	6a 00                	push   $0x0
  800367:	e8 33 0b 00 00       	call   800e9f <sys_page_alloc>
  80036c:	83 c4 10             	add    $0x10,%esp
  80036f:	85 c0                	test   %eax,%eax
  800371:	78 21                	js     800394 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	8b 15 70 57 80 00    	mov    0x805770,%edx
  80037c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80037e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800381:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 1e 0d 00 00       	call   8010af <fd2num>
  800391:	83 c4 10             	add    $0x10,%esp
}
  800394:	c9                   	leave  
  800395:	c3                   	ret    

00800396 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	56                   	push   %esi
  80039a:	53                   	push   %ebx
  80039b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80039e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8003a1:	e8 bb 0a 00 00       	call   800e61 <sys_getenvid>
  8003a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003ab:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003ae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003b3:	a3 90 77 80 00       	mov    %eax,0x807790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003b8:	85 db                	test   %ebx,%ebx
  8003ba:	7e 07                	jle    8003c3 <libmain+0x2d>
		binaryname = argv[0];
  8003bc:	8b 06                	mov    (%esi),%eax
  8003be:	a3 8c 57 80 00       	mov    %eax,0x80578c

	// call user main routine
	umain(argc, argv);
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	56                   	push   %esi
  8003c7:	53                   	push   %ebx
  8003c8:	e8 91 fc ff ff       	call   80005e <umain>

	// exit gracefully
	exit();
  8003cd:	e8 0a 00 00 00       	call   8003dc <exit>
}
  8003d2:	83 c4 10             	add    $0x10,%esp
  8003d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003d8:	5b                   	pop    %ebx
  8003d9:	5e                   	pop    %esi
  8003da:	5d                   	pop    %ebp
  8003db:	c3                   	ret    

008003dc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8003e2:	e8 a0 0e 00 00       	call   801287 <close_all>
	sys_env_destroy(0);
  8003e7:	83 ec 0c             	sub    $0xc,%esp
  8003ea:	6a 00                	push   $0x0
  8003ec:	e8 2f 0a 00 00       	call   800e20 <sys_env_destroy>
}
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	c9                   	leave  
  8003f5:	c3                   	ret    

008003f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003f6:	55                   	push   %ebp
  8003f7:	89 e5                	mov    %esp,%ebp
  8003f9:	56                   	push   %esi
  8003fa:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003fb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003fe:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  800404:	e8 58 0a 00 00       	call   800e61 <sys_getenvid>
  800409:	83 ec 0c             	sub    $0xc,%esp
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 08             	pushl  0x8(%ebp)
  800412:	56                   	push   %esi
  800413:	50                   	push   %eax
  800414:	68 ec 2b 80 00       	push   $0x802bec
  800419:	e8 b3 00 00 00       	call   8004d1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80041e:	83 c4 18             	add    $0x18,%esp
  800421:	53                   	push   %ebx
  800422:	ff 75 10             	pushl  0x10(%ebp)
  800425:	e8 56 00 00 00       	call   800480 <vcprintf>
	cprintf("\n");
  80042a:	c7 04 24 16 31 80 00 	movl   $0x803116,(%esp)
  800431:	e8 9b 00 00 00       	call   8004d1 <cprintf>
  800436:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800439:	cc                   	int3   
  80043a:	eb fd                	jmp    800439 <_panic+0x43>

0080043c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80043c:	55                   	push   %ebp
  80043d:	89 e5                	mov    %esp,%ebp
  80043f:	53                   	push   %ebx
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800446:	8b 13                	mov    (%ebx),%edx
  800448:	8d 42 01             	lea    0x1(%edx),%eax
  80044b:	89 03                	mov    %eax,(%ebx)
  80044d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800450:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800454:	3d ff 00 00 00       	cmp    $0xff,%eax
  800459:	74 09                	je     800464 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80045b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80045f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800462:	c9                   	leave  
  800463:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	68 ff 00 00 00       	push   $0xff
  80046c:	8d 43 08             	lea    0x8(%ebx),%eax
  80046f:	50                   	push   %eax
  800470:	e8 6e 09 00 00       	call   800de3 <sys_cputs>
		b->idx = 0;
  800475:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80047b:	83 c4 10             	add    $0x10,%esp
  80047e:	eb db                	jmp    80045b <putch+0x1f>

00800480 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800489:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800490:	00 00 00 
	b.cnt = 0;
  800493:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80049a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80049d:	ff 75 0c             	pushl  0xc(%ebp)
  8004a0:	ff 75 08             	pushl  0x8(%ebp)
  8004a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a9:	50                   	push   %eax
  8004aa:	68 3c 04 80 00       	push   $0x80043c
  8004af:	e8 19 01 00 00       	call   8005cd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004b4:	83 c4 08             	add    $0x8,%esp
  8004b7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004bd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004c3:	50                   	push   %eax
  8004c4:	e8 1a 09 00 00       	call   800de3 <sys_cputs>

	return b.cnt;
}
  8004c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004cf:	c9                   	leave  
  8004d0:	c3                   	ret    

008004d1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004d1:	55                   	push   %ebp
  8004d2:	89 e5                	mov    %esp,%ebp
  8004d4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004d7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004da:	50                   	push   %eax
  8004db:	ff 75 08             	pushl  0x8(%ebp)
  8004de:	e8 9d ff ff ff       	call   800480 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004e3:	c9                   	leave  
  8004e4:	c3                   	ret    

008004e5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e5:	55                   	push   %ebp
  8004e6:	89 e5                	mov    %esp,%ebp
  8004e8:	57                   	push   %edi
  8004e9:	56                   	push   %esi
  8004ea:	53                   	push   %ebx
  8004eb:	83 ec 1c             	sub    $0x1c,%esp
  8004ee:	89 c7                	mov    %eax,%edi
  8004f0:	89 d6                	mov    %edx,%esi
  8004f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800501:	bb 00 00 00 00       	mov    $0x0,%ebx
  800506:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800509:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80050c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80050f:	89 d0                	mov    %edx,%eax
  800511:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800514:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800517:	73 15                	jae    80052e <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800519:	83 eb 01             	sub    $0x1,%ebx
  80051c:	85 db                	test   %ebx,%ebx
  80051e:	7e 43                	jle    800563 <printnum+0x7e>
			putch(padc, putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	56                   	push   %esi
  800524:	ff 75 18             	pushl  0x18(%ebp)
  800527:	ff d7                	call   *%edi
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	eb eb                	jmp    800519 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80052e:	83 ec 0c             	sub    $0xc,%esp
  800531:	ff 75 18             	pushl  0x18(%ebp)
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80053a:	53                   	push   %ebx
  80053b:	ff 75 10             	pushl  0x10(%ebp)
  80053e:	83 ec 08             	sub    $0x8,%esp
  800541:	ff 75 e4             	pushl  -0x1c(%ebp)
  800544:	ff 75 e0             	pushl  -0x20(%ebp)
  800547:	ff 75 dc             	pushl  -0x24(%ebp)
  80054a:	ff 75 d8             	pushl  -0x28(%ebp)
  80054d:	e8 ee 22 00 00       	call   802840 <__udivdi3>
  800552:	83 c4 18             	add    $0x18,%esp
  800555:	52                   	push   %edx
  800556:	50                   	push   %eax
  800557:	89 f2                	mov    %esi,%edx
  800559:	89 f8                	mov    %edi,%eax
  80055b:	e8 85 ff ff ff       	call   8004e5 <printnum>
  800560:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	56                   	push   %esi
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056d:	ff 75 e0             	pushl  -0x20(%ebp)
  800570:	ff 75 dc             	pushl  -0x24(%ebp)
  800573:	ff 75 d8             	pushl  -0x28(%ebp)
  800576:	e8 d5 23 00 00       	call   802950 <__umoddi3>
  80057b:	83 c4 14             	add    $0x14,%esp
  80057e:	0f be 80 0f 2c 80 00 	movsbl 0x802c0f(%eax),%eax
  800585:	50                   	push   %eax
  800586:	ff d7                	call   *%edi
}
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80058e:	5b                   	pop    %ebx
  80058f:	5e                   	pop    %esi
  800590:	5f                   	pop    %edi
  800591:	5d                   	pop    %ebp
  800592:	c3                   	ret    

00800593 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800599:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80059d:	8b 10                	mov    (%eax),%edx
  80059f:	3b 50 04             	cmp    0x4(%eax),%edx
  8005a2:	73 0a                	jae    8005ae <sprintputch+0x1b>
		*b->buf++ = ch;
  8005a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005a7:	89 08                	mov    %ecx,(%eax)
  8005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ac:	88 02                	mov    %al,(%edx)
}
  8005ae:	5d                   	pop    %ebp
  8005af:	c3                   	ret    

008005b0 <printfmt>:
{
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
  8005b3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005b6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005b9:	50                   	push   %eax
  8005ba:	ff 75 10             	pushl  0x10(%ebp)
  8005bd:	ff 75 0c             	pushl  0xc(%ebp)
  8005c0:	ff 75 08             	pushl  0x8(%ebp)
  8005c3:	e8 05 00 00 00       	call   8005cd <vprintfmt>
}
  8005c8:	83 c4 10             	add    $0x10,%esp
  8005cb:	c9                   	leave  
  8005cc:	c3                   	ret    

008005cd <vprintfmt>:
{
  8005cd:	55                   	push   %ebp
  8005ce:	89 e5                	mov    %esp,%ebp
  8005d0:	57                   	push   %edi
  8005d1:	56                   	push   %esi
  8005d2:	53                   	push   %ebx
  8005d3:	83 ec 3c             	sub    $0x3c,%esp
  8005d6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005dc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005df:	eb 0a                	jmp    8005eb <vprintfmt+0x1e>
			putch(ch, putdat);
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	53                   	push   %ebx
  8005e5:	50                   	push   %eax
  8005e6:	ff d6                	call   *%esi
  8005e8:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005eb:	83 c7 01             	add    $0x1,%edi
  8005ee:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005f2:	83 f8 25             	cmp    $0x25,%eax
  8005f5:	74 0c                	je     800603 <vprintfmt+0x36>
			if (ch == '\0')
  8005f7:	85 c0                	test   %eax,%eax
  8005f9:	75 e6                	jne    8005e1 <vprintfmt+0x14>
}
  8005fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005fe:	5b                   	pop    %ebx
  8005ff:	5e                   	pop    %esi
  800600:	5f                   	pop    %edi
  800601:	5d                   	pop    %ebp
  800602:	c3                   	ret    
		padc = ' ';
  800603:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800607:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80060e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800615:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80061c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800621:	8d 47 01             	lea    0x1(%edi),%eax
  800624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800627:	0f b6 17             	movzbl (%edi),%edx
  80062a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80062d:	3c 55                	cmp    $0x55,%al
  80062f:	0f 87 ba 03 00 00    	ja     8009ef <vprintfmt+0x422>
  800635:	0f b6 c0             	movzbl %al,%eax
  800638:	ff 24 85 60 2d 80 00 	jmp    *0x802d60(,%eax,4)
  80063f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800642:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800646:	eb d9                	jmp    800621 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800648:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80064b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80064f:	eb d0                	jmp    800621 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800651:	0f b6 d2             	movzbl %dl,%edx
  800654:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800657:	b8 00 00 00 00       	mov    $0x0,%eax
  80065c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80065f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800662:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800666:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800669:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80066c:	83 f9 09             	cmp    $0x9,%ecx
  80066f:	77 55                	ja     8006c6 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800671:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800674:	eb e9                	jmp    80065f <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 40 04             	lea    0x4(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800687:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80068a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80068e:	79 91                	jns    800621 <vprintfmt+0x54>
				width = precision, precision = -1;
  800690:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800693:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800696:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80069d:	eb 82                	jmp    800621 <vprintfmt+0x54>
  80069f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a2:	85 c0                	test   %eax,%eax
  8006a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a9:	0f 49 d0             	cmovns %eax,%edx
  8006ac:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006b2:	e9 6a ff ff ff       	jmp    800621 <vprintfmt+0x54>
  8006b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006ba:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006c1:	e9 5b ff ff ff       	jmp    800621 <vprintfmt+0x54>
  8006c6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cc:	eb bc                	jmp    80068a <vprintfmt+0xbd>
			lflag++;
  8006ce:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006d4:	e9 48 ff ff ff       	jmp    800621 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8d 78 04             	lea    0x4(%eax),%edi
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	53                   	push   %ebx
  8006e3:	ff 30                	pushl  (%eax)
  8006e5:	ff d6                	call   *%esi
			break;
  8006e7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006ea:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006ed:	e9 9c 02 00 00       	jmp    80098e <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8d 78 04             	lea    0x4(%eax),%edi
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	99                   	cltd   
  8006fb:	31 d0                	xor    %edx,%eax
  8006fd:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006ff:	83 f8 0f             	cmp    $0xf,%eax
  800702:	7f 23                	jg     800727 <vprintfmt+0x15a>
  800704:	8b 14 85 c0 2e 80 00 	mov    0x802ec0(,%eax,4),%edx
  80070b:	85 d2                	test   %edx,%edx
  80070d:	74 18                	je     800727 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  80070f:	52                   	push   %edx
  800710:	68 fa 2f 80 00       	push   $0x802ffa
  800715:	53                   	push   %ebx
  800716:	56                   	push   %esi
  800717:	e8 94 fe ff ff       	call   8005b0 <printfmt>
  80071c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80071f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800722:	e9 67 02 00 00       	jmp    80098e <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800727:	50                   	push   %eax
  800728:	68 27 2c 80 00       	push   $0x802c27
  80072d:	53                   	push   %ebx
  80072e:	56                   	push   %esi
  80072f:	e8 7c fe ff ff       	call   8005b0 <printfmt>
  800734:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800737:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80073a:	e9 4f 02 00 00       	jmp    80098e <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	83 c0 04             	add    $0x4,%eax
  800745:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80074d:	85 d2                	test   %edx,%edx
  80074f:	b8 20 2c 80 00       	mov    $0x802c20,%eax
  800754:	0f 45 c2             	cmovne %edx,%eax
  800757:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80075a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80075e:	7e 06                	jle    800766 <vprintfmt+0x199>
  800760:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800764:	75 0d                	jne    800773 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800766:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800769:	89 c7                	mov    %eax,%edi
  80076b:	03 45 e0             	add    -0x20(%ebp),%eax
  80076e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800771:	eb 3f                	jmp    8007b2 <vprintfmt+0x1e5>
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	ff 75 d8             	pushl  -0x28(%ebp)
  800779:	50                   	push   %eax
  80077a:	e8 0d 03 00 00       	call   800a8c <strnlen>
  80077f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800782:	29 c2                	sub    %eax,%edx
  800784:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80078c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800790:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800793:	85 ff                	test   %edi,%edi
  800795:	7e 58                	jle    8007ef <vprintfmt+0x222>
					putch(padc, putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	53                   	push   %ebx
  80079b:	ff 75 e0             	pushl  -0x20(%ebp)
  80079e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a0:	83 ef 01             	sub    $0x1,%edi
  8007a3:	83 c4 10             	add    $0x10,%esp
  8007a6:	eb eb                	jmp    800793 <vprintfmt+0x1c6>
					putch(ch, putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	53                   	push   %ebx
  8007ac:	52                   	push   %edx
  8007ad:	ff d6                	call   *%esi
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007b5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007b7:	83 c7 01             	add    $0x1,%edi
  8007ba:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007be:	0f be d0             	movsbl %al,%edx
  8007c1:	85 d2                	test   %edx,%edx
  8007c3:	74 45                	je     80080a <vprintfmt+0x23d>
  8007c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007c9:	78 06                	js     8007d1 <vprintfmt+0x204>
  8007cb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007cf:	78 35                	js     800806 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8007d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007d5:	74 d1                	je     8007a8 <vprintfmt+0x1db>
  8007d7:	0f be c0             	movsbl %al,%eax
  8007da:	83 e8 20             	sub    $0x20,%eax
  8007dd:	83 f8 5e             	cmp    $0x5e,%eax
  8007e0:	76 c6                	jbe    8007a8 <vprintfmt+0x1db>
					putch('?', putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	53                   	push   %ebx
  8007e6:	6a 3f                	push   $0x3f
  8007e8:	ff d6                	call   *%esi
  8007ea:	83 c4 10             	add    $0x10,%esp
  8007ed:	eb c3                	jmp    8007b2 <vprintfmt+0x1e5>
  8007ef:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007f2:	85 d2                	test   %edx,%edx
  8007f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f9:	0f 49 c2             	cmovns %edx,%eax
  8007fc:	29 c2                	sub    %eax,%edx
  8007fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800801:	e9 60 ff ff ff       	jmp    800766 <vprintfmt+0x199>
  800806:	89 cf                	mov    %ecx,%edi
  800808:	eb 02                	jmp    80080c <vprintfmt+0x23f>
  80080a:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  80080c:	85 ff                	test   %edi,%edi
  80080e:	7e 10                	jle    800820 <vprintfmt+0x253>
				putch(' ', putdat);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	53                   	push   %ebx
  800814:	6a 20                	push   $0x20
  800816:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800818:	83 ef 01             	sub    $0x1,%edi
  80081b:	83 c4 10             	add    $0x10,%esp
  80081e:	eb ec                	jmp    80080c <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800820:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
  800826:	e9 63 01 00 00       	jmp    80098e <vprintfmt+0x3c1>
	if (lflag >= 2)
  80082b:	83 f9 01             	cmp    $0x1,%ecx
  80082e:	7f 1b                	jg     80084b <vprintfmt+0x27e>
	else if (lflag)
  800830:	85 c9                	test   %ecx,%ecx
  800832:	74 63                	je     800897 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083c:	99                   	cltd   
  80083d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	8d 40 04             	lea    0x4(%eax),%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
  800849:	eb 17                	jmp    800862 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	8b 50 04             	mov    0x4(%eax),%edx
  800851:	8b 00                	mov    (%eax),%eax
  800853:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800856:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8d 40 08             	lea    0x8(%eax),%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800862:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800865:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800868:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80086d:	85 c9                	test   %ecx,%ecx
  80086f:	0f 89 ff 00 00 00    	jns    800974 <vprintfmt+0x3a7>
				putch('-', putdat);
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	53                   	push   %ebx
  800879:	6a 2d                	push   $0x2d
  80087b:	ff d6                	call   *%esi
				num = -(long long) num;
  80087d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800880:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800883:	f7 da                	neg    %edx
  800885:	83 d1 00             	adc    $0x0,%ecx
  800888:	f7 d9                	neg    %ecx
  80088a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80088d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800892:	e9 dd 00 00 00       	jmp    800974 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089f:	99                   	cltd   
  8008a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a6:	8d 40 04             	lea    0x4(%eax),%eax
  8008a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ac:	eb b4                	jmp    800862 <vprintfmt+0x295>
	if (lflag >= 2)
  8008ae:	83 f9 01             	cmp    $0x1,%ecx
  8008b1:	7f 1e                	jg     8008d1 <vprintfmt+0x304>
	else if (lflag)
  8008b3:	85 c9                	test   %ecx,%ecx
  8008b5:	74 32                	je     8008e9 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8008b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ba:	8b 10                	mov    (%eax),%edx
  8008bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008c1:	8d 40 04             	lea    0x4(%eax),%eax
  8008c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008cc:	e9 a3 00 00 00       	jmp    800974 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	8b 10                	mov    (%eax),%edx
  8008d6:	8b 48 04             	mov    0x4(%eax),%ecx
  8008d9:	8d 40 08             	lea    0x8(%eax),%eax
  8008dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008df:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e4:	e9 8b 00 00 00       	jmp    800974 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	8b 10                	mov    (%eax),%edx
  8008ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008f3:	8d 40 04             	lea    0x4(%eax),%eax
  8008f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008f9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008fe:	eb 74                	jmp    800974 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800900:	83 f9 01             	cmp    $0x1,%ecx
  800903:	7f 1b                	jg     800920 <vprintfmt+0x353>
	else if (lflag)
  800905:	85 c9                	test   %ecx,%ecx
  800907:	74 2c                	je     800935 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	8b 10                	mov    (%eax),%edx
  80090e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800913:	8d 40 04             	lea    0x4(%eax),%eax
  800916:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800919:	b8 08 00 00 00       	mov    $0x8,%eax
  80091e:	eb 54                	jmp    800974 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	8b 10                	mov    (%eax),%edx
  800925:	8b 48 04             	mov    0x4(%eax),%ecx
  800928:	8d 40 08             	lea    0x8(%eax),%eax
  80092b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80092e:	b8 08 00 00 00       	mov    $0x8,%eax
  800933:	eb 3f                	jmp    800974 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	8b 10                	mov    (%eax),%edx
  80093a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093f:	8d 40 04             	lea    0x4(%eax),%eax
  800942:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800945:	b8 08 00 00 00       	mov    $0x8,%eax
  80094a:	eb 28                	jmp    800974 <vprintfmt+0x3a7>
			putch('0', putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	53                   	push   %ebx
  800950:	6a 30                	push   $0x30
  800952:	ff d6                	call   *%esi
			putch('x', putdat);
  800954:	83 c4 08             	add    $0x8,%esp
  800957:	53                   	push   %ebx
  800958:	6a 78                	push   $0x78
  80095a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80095c:	8b 45 14             	mov    0x14(%ebp),%eax
  80095f:	8b 10                	mov    (%eax),%edx
  800961:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800966:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800969:	8d 40 04             	lea    0x4(%eax),%eax
  80096c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80096f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800974:	83 ec 0c             	sub    $0xc,%esp
  800977:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80097b:	57                   	push   %edi
  80097c:	ff 75 e0             	pushl  -0x20(%ebp)
  80097f:	50                   	push   %eax
  800980:	51                   	push   %ecx
  800981:	52                   	push   %edx
  800982:	89 da                	mov    %ebx,%edx
  800984:	89 f0                	mov    %esi,%eax
  800986:	e8 5a fb ff ff       	call   8004e5 <printnum>
			break;
  80098b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80098e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800991:	e9 55 fc ff ff       	jmp    8005eb <vprintfmt+0x1e>
	if (lflag >= 2)
  800996:	83 f9 01             	cmp    $0x1,%ecx
  800999:	7f 1b                	jg     8009b6 <vprintfmt+0x3e9>
	else if (lflag)
  80099b:	85 c9                	test   %ecx,%ecx
  80099d:	74 2c                	je     8009cb <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	8b 10                	mov    (%eax),%edx
  8009a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009a9:	8d 40 04             	lea    0x4(%eax),%eax
  8009ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009af:	b8 10 00 00 00       	mov    $0x10,%eax
  8009b4:	eb be                	jmp    800974 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8009b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b9:	8b 10                	mov    (%eax),%edx
  8009bb:	8b 48 04             	mov    0x4(%eax),%ecx
  8009be:	8d 40 08             	lea    0x8(%eax),%eax
  8009c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009c4:	b8 10 00 00 00       	mov    $0x10,%eax
  8009c9:	eb a9                	jmp    800974 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	8b 10                	mov    (%eax),%edx
  8009d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009d5:	8d 40 04             	lea    0x4(%eax),%eax
  8009d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009db:	b8 10 00 00 00       	mov    $0x10,%eax
  8009e0:	eb 92                	jmp    800974 <vprintfmt+0x3a7>
			putch(ch, putdat);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	53                   	push   %ebx
  8009e6:	6a 25                	push   $0x25
  8009e8:	ff d6                	call   *%esi
			break;
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	eb 9f                	jmp    80098e <vprintfmt+0x3c1>
			putch('%', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	53                   	push   %ebx
  8009f3:	6a 25                	push   $0x25
  8009f5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f7:	83 c4 10             	add    $0x10,%esp
  8009fa:	89 f8                	mov    %edi,%eax
  8009fc:	eb 03                	jmp    800a01 <vprintfmt+0x434>
  8009fe:	83 e8 01             	sub    $0x1,%eax
  800a01:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a05:	75 f7                	jne    8009fe <vprintfmt+0x431>
  800a07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a0a:	eb 82                	jmp    80098e <vprintfmt+0x3c1>

00800a0c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 18             	sub    $0x18,%esp
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a1b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a1f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a29:	85 c0                	test   %eax,%eax
  800a2b:	74 26                	je     800a53 <vsnprintf+0x47>
  800a2d:	85 d2                	test   %edx,%edx
  800a2f:	7e 22                	jle    800a53 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a31:	ff 75 14             	pushl  0x14(%ebp)
  800a34:	ff 75 10             	pushl  0x10(%ebp)
  800a37:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a3a:	50                   	push   %eax
  800a3b:	68 93 05 80 00       	push   $0x800593
  800a40:	e8 88 fb ff ff       	call   8005cd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a48:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a4e:	83 c4 10             	add    $0x10,%esp
}
  800a51:	c9                   	leave  
  800a52:	c3                   	ret    
		return -E_INVAL;
  800a53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a58:	eb f7                	jmp    800a51 <vsnprintf+0x45>

00800a5a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a60:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a63:	50                   	push   %eax
  800a64:	ff 75 10             	pushl  0x10(%ebp)
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	ff 75 08             	pushl  0x8(%ebp)
  800a6d:	e8 9a ff ff ff       	call   800a0c <vsnprintf>
	va_end(ap);

	return rc;
}
  800a72:	c9                   	leave  
  800a73:	c3                   	ret    

00800a74 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a83:	74 05                	je     800a8a <strlen+0x16>
		n++;
  800a85:	83 c0 01             	add    $0x1,%eax
  800a88:	eb f5                	jmp    800a7f <strlen+0xb>
	return n;
}
  800a8a:	5d                   	pop    %ebp
  800a8b:	c3                   	ret    

00800a8c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a92:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a95:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9a:	39 c2                	cmp    %eax,%edx
  800a9c:	74 0d                	je     800aab <strnlen+0x1f>
  800a9e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800aa2:	74 05                	je     800aa9 <strnlen+0x1d>
		n++;
  800aa4:	83 c2 01             	add    $0x1,%edx
  800aa7:	eb f1                	jmp    800a9a <strnlen+0xe>
  800aa9:	89 d0                	mov    %edx,%eax
	return n;
}
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	53                   	push   %ebx
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ab7:	ba 00 00 00 00       	mov    $0x0,%edx
  800abc:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ac0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ac3:	83 c2 01             	add    $0x1,%edx
  800ac6:	84 c9                	test   %cl,%cl
  800ac8:	75 f2                	jne    800abc <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800aca:	5b                   	pop    %ebx
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    

00800acd <strcat>:

char *
strcat(char *dst, const char *src)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	53                   	push   %ebx
  800ad1:	83 ec 10             	sub    $0x10,%esp
  800ad4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ad7:	53                   	push   %ebx
  800ad8:	e8 97 ff ff ff       	call   800a74 <strlen>
  800add:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	01 d8                	add    %ebx,%eax
  800ae5:	50                   	push   %eax
  800ae6:	e8 c2 ff ff ff       	call   800aad <strcpy>
	return dst;
}
  800aeb:	89 d8                	mov    %ebx,%eax
  800aed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800af0:	c9                   	leave  
  800af1:	c3                   	ret    

00800af2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	56                   	push   %esi
  800af6:	53                   	push   %ebx
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800afd:	89 c6                	mov    %eax,%esi
  800aff:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	39 f2                	cmp    %esi,%edx
  800b06:	74 11                	je     800b19 <strncpy+0x27>
		*dst++ = *src;
  800b08:	83 c2 01             	add    $0x1,%edx
  800b0b:	0f b6 19             	movzbl (%ecx),%ebx
  800b0e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b11:	80 fb 01             	cmp    $0x1,%bl
  800b14:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b17:	eb eb                	jmp    800b04 <strncpy+0x12>
	}
	return ret;
}
  800b19:	5b                   	pop    %ebx
  800b1a:	5e                   	pop    %esi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	56                   	push   %esi
  800b21:	53                   	push   %ebx
  800b22:	8b 75 08             	mov    0x8(%ebp),%esi
  800b25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b28:	8b 55 10             	mov    0x10(%ebp),%edx
  800b2b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b2d:	85 d2                	test   %edx,%edx
  800b2f:	74 21                	je     800b52 <strlcpy+0x35>
  800b31:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b35:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b37:	39 c2                	cmp    %eax,%edx
  800b39:	74 14                	je     800b4f <strlcpy+0x32>
  800b3b:	0f b6 19             	movzbl (%ecx),%ebx
  800b3e:	84 db                	test   %bl,%bl
  800b40:	74 0b                	je     800b4d <strlcpy+0x30>
			*dst++ = *src++;
  800b42:	83 c1 01             	add    $0x1,%ecx
  800b45:	83 c2 01             	add    $0x1,%edx
  800b48:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b4b:	eb ea                	jmp    800b37 <strlcpy+0x1a>
  800b4d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b4f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b52:	29 f0                	sub    %esi,%eax
}
  800b54:	5b                   	pop    %ebx
  800b55:	5e                   	pop    %esi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b61:	0f b6 01             	movzbl (%ecx),%eax
  800b64:	84 c0                	test   %al,%al
  800b66:	74 0c                	je     800b74 <strcmp+0x1c>
  800b68:	3a 02                	cmp    (%edx),%al
  800b6a:	75 08                	jne    800b74 <strcmp+0x1c>
		p++, q++;
  800b6c:	83 c1 01             	add    $0x1,%ecx
  800b6f:	83 c2 01             	add    $0x1,%edx
  800b72:	eb ed                	jmp    800b61 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b74:	0f b6 c0             	movzbl %al,%eax
  800b77:	0f b6 12             	movzbl (%edx),%edx
  800b7a:	29 d0                	sub    %edx,%eax
}
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	53                   	push   %ebx
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b88:	89 c3                	mov    %eax,%ebx
  800b8a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b8d:	eb 06                	jmp    800b95 <strncmp+0x17>
		n--, p++, q++;
  800b8f:	83 c0 01             	add    $0x1,%eax
  800b92:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b95:	39 d8                	cmp    %ebx,%eax
  800b97:	74 16                	je     800baf <strncmp+0x31>
  800b99:	0f b6 08             	movzbl (%eax),%ecx
  800b9c:	84 c9                	test   %cl,%cl
  800b9e:	74 04                	je     800ba4 <strncmp+0x26>
  800ba0:	3a 0a                	cmp    (%edx),%cl
  800ba2:	74 eb                	je     800b8f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba4:	0f b6 00             	movzbl (%eax),%eax
  800ba7:	0f b6 12             	movzbl (%edx),%edx
  800baa:	29 d0                	sub    %edx,%eax
}
  800bac:	5b                   	pop    %ebx
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    
		return 0;
  800baf:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb4:	eb f6                	jmp    800bac <strncmp+0x2e>

00800bb6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bc0:	0f b6 10             	movzbl (%eax),%edx
  800bc3:	84 d2                	test   %dl,%dl
  800bc5:	74 09                	je     800bd0 <strchr+0x1a>
		if (*s == c)
  800bc7:	38 ca                	cmp    %cl,%dl
  800bc9:	74 0a                	je     800bd5 <strchr+0x1f>
	for (; *s; s++)
  800bcb:	83 c0 01             	add    $0x1,%eax
  800bce:	eb f0                	jmp    800bc0 <strchr+0xa>
			return (char *) s;
	return 0;
  800bd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    

00800bd7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800be1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800be4:	38 ca                	cmp    %cl,%dl
  800be6:	74 09                	je     800bf1 <strfind+0x1a>
  800be8:	84 d2                	test   %dl,%dl
  800bea:	74 05                	je     800bf1 <strfind+0x1a>
	for (; *s; s++)
  800bec:	83 c0 01             	add    $0x1,%eax
  800bef:	eb f0                	jmp    800be1 <strfind+0xa>
			break;
	return (char *) s;
}
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bfc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bff:	85 c9                	test   %ecx,%ecx
  800c01:	74 31                	je     800c34 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c03:	89 f8                	mov    %edi,%eax
  800c05:	09 c8                	or     %ecx,%eax
  800c07:	a8 03                	test   $0x3,%al
  800c09:	75 23                	jne    800c2e <memset+0x3b>
		c &= 0xFF;
  800c0b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c0f:	89 d3                	mov    %edx,%ebx
  800c11:	c1 e3 08             	shl    $0x8,%ebx
  800c14:	89 d0                	mov    %edx,%eax
  800c16:	c1 e0 18             	shl    $0x18,%eax
  800c19:	89 d6                	mov    %edx,%esi
  800c1b:	c1 e6 10             	shl    $0x10,%esi
  800c1e:	09 f0                	or     %esi,%eax
  800c20:	09 c2                	or     %eax,%edx
  800c22:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c24:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c27:	89 d0                	mov    %edx,%eax
  800c29:	fc                   	cld    
  800c2a:	f3 ab                	rep stos %eax,%es:(%edi)
  800c2c:	eb 06                	jmp    800c34 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	fc                   	cld    
  800c32:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c34:	89 f8                	mov    %edi,%eax
  800c36:	5b                   	pop    %ebx
  800c37:	5e                   	pop    %esi
  800c38:	5f                   	pop    %edi
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	57                   	push   %edi
  800c3f:	56                   	push   %esi
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c46:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c49:	39 c6                	cmp    %eax,%esi
  800c4b:	73 32                	jae    800c7f <memmove+0x44>
  800c4d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c50:	39 c2                	cmp    %eax,%edx
  800c52:	76 2b                	jbe    800c7f <memmove+0x44>
		s += n;
		d += n;
  800c54:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c57:	89 fe                	mov    %edi,%esi
  800c59:	09 ce                	or     %ecx,%esi
  800c5b:	09 d6                	or     %edx,%esi
  800c5d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c63:	75 0e                	jne    800c73 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c65:	83 ef 04             	sub    $0x4,%edi
  800c68:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c6b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c6e:	fd                   	std    
  800c6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c71:	eb 09                	jmp    800c7c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c73:	83 ef 01             	sub    $0x1,%edi
  800c76:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c79:	fd                   	std    
  800c7a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c7c:	fc                   	cld    
  800c7d:	eb 1a                	jmp    800c99 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c7f:	89 c2                	mov    %eax,%edx
  800c81:	09 ca                	or     %ecx,%edx
  800c83:	09 f2                	or     %esi,%edx
  800c85:	f6 c2 03             	test   $0x3,%dl
  800c88:	75 0a                	jne    800c94 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c8a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c8d:	89 c7                	mov    %eax,%edi
  800c8f:	fc                   	cld    
  800c90:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c92:	eb 05                	jmp    800c99 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c94:	89 c7                	mov    %eax,%edi
  800c96:	fc                   	cld    
  800c97:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c99:	5e                   	pop    %esi
  800c9a:	5f                   	pop    %edi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ca3:	ff 75 10             	pushl  0x10(%ebp)
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	ff 75 08             	pushl  0x8(%ebp)
  800cac:	e8 8a ff ff ff       	call   800c3b <memmove>
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	56                   	push   %esi
  800cb7:	53                   	push   %ebx
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbe:	89 c6                	mov    %eax,%esi
  800cc0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cc3:	39 f0                	cmp    %esi,%eax
  800cc5:	74 1c                	je     800ce3 <memcmp+0x30>
		if (*s1 != *s2)
  800cc7:	0f b6 08             	movzbl (%eax),%ecx
  800cca:	0f b6 1a             	movzbl (%edx),%ebx
  800ccd:	38 d9                	cmp    %bl,%cl
  800ccf:	75 08                	jne    800cd9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cd1:	83 c0 01             	add    $0x1,%eax
  800cd4:	83 c2 01             	add    $0x1,%edx
  800cd7:	eb ea                	jmp    800cc3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cd9:	0f b6 c1             	movzbl %cl,%eax
  800cdc:	0f b6 db             	movzbl %bl,%ebx
  800cdf:	29 d8                	sub    %ebx,%eax
  800ce1:	eb 05                	jmp    800ce8 <memcmp+0x35>
	}

	return 0;
  800ce3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce8:	5b                   	pop    %ebx
  800ce9:	5e                   	pop    %esi
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cf5:	89 c2                	mov    %eax,%edx
  800cf7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cfa:	39 d0                	cmp    %edx,%eax
  800cfc:	73 09                	jae    800d07 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cfe:	38 08                	cmp    %cl,(%eax)
  800d00:	74 05                	je     800d07 <memfind+0x1b>
	for (; s < ends; s++)
  800d02:	83 c0 01             	add    $0x1,%eax
  800d05:	eb f3                	jmp    800cfa <memfind+0xe>
			break;
	return (void *) s;
}
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	57                   	push   %edi
  800d0d:	56                   	push   %esi
  800d0e:	53                   	push   %ebx
  800d0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d12:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d15:	eb 03                	jmp    800d1a <strtol+0x11>
		s++;
  800d17:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d1a:	0f b6 01             	movzbl (%ecx),%eax
  800d1d:	3c 20                	cmp    $0x20,%al
  800d1f:	74 f6                	je     800d17 <strtol+0xe>
  800d21:	3c 09                	cmp    $0x9,%al
  800d23:	74 f2                	je     800d17 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d25:	3c 2b                	cmp    $0x2b,%al
  800d27:	74 2a                	je     800d53 <strtol+0x4a>
	int neg = 0;
  800d29:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d2e:	3c 2d                	cmp    $0x2d,%al
  800d30:	74 2b                	je     800d5d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d32:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d38:	75 0f                	jne    800d49 <strtol+0x40>
  800d3a:	80 39 30             	cmpb   $0x30,(%ecx)
  800d3d:	74 28                	je     800d67 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d3f:	85 db                	test   %ebx,%ebx
  800d41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d46:	0f 44 d8             	cmove  %eax,%ebx
  800d49:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d51:	eb 50                	jmp    800da3 <strtol+0x9a>
		s++;
  800d53:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d56:	bf 00 00 00 00       	mov    $0x0,%edi
  800d5b:	eb d5                	jmp    800d32 <strtol+0x29>
		s++, neg = 1;
  800d5d:	83 c1 01             	add    $0x1,%ecx
  800d60:	bf 01 00 00 00       	mov    $0x1,%edi
  800d65:	eb cb                	jmp    800d32 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d67:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d6b:	74 0e                	je     800d7b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d6d:	85 db                	test   %ebx,%ebx
  800d6f:	75 d8                	jne    800d49 <strtol+0x40>
		s++, base = 8;
  800d71:	83 c1 01             	add    $0x1,%ecx
  800d74:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d79:	eb ce                	jmp    800d49 <strtol+0x40>
		s += 2, base = 16;
  800d7b:	83 c1 02             	add    $0x2,%ecx
  800d7e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d83:	eb c4                	jmp    800d49 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d85:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d88:	89 f3                	mov    %esi,%ebx
  800d8a:	80 fb 19             	cmp    $0x19,%bl
  800d8d:	77 29                	ja     800db8 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d8f:	0f be d2             	movsbl %dl,%edx
  800d92:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d95:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d98:	7d 30                	jge    800dca <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d9a:	83 c1 01             	add    $0x1,%ecx
  800d9d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800da1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800da3:	0f b6 11             	movzbl (%ecx),%edx
  800da6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800da9:	89 f3                	mov    %esi,%ebx
  800dab:	80 fb 09             	cmp    $0x9,%bl
  800dae:	77 d5                	ja     800d85 <strtol+0x7c>
			dig = *s - '0';
  800db0:	0f be d2             	movsbl %dl,%edx
  800db3:	83 ea 30             	sub    $0x30,%edx
  800db6:	eb dd                	jmp    800d95 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800db8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800dbb:	89 f3                	mov    %esi,%ebx
  800dbd:	80 fb 19             	cmp    $0x19,%bl
  800dc0:	77 08                	ja     800dca <strtol+0xc1>
			dig = *s - 'A' + 10;
  800dc2:	0f be d2             	movsbl %dl,%edx
  800dc5:	83 ea 37             	sub    $0x37,%edx
  800dc8:	eb cb                	jmp    800d95 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dce:	74 05                	je     800dd5 <strtol+0xcc>
		*endptr = (char *) s;
  800dd0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dd3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dd5:	89 c2                	mov    %eax,%edx
  800dd7:	f7 da                	neg    %edx
  800dd9:	85 ff                	test   %edi,%edi
  800ddb:	0f 45 c2             	cmovne %edx,%eax
}
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5f                   	pop    %edi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dee:	8b 55 08             	mov    0x8(%ebp),%edx
  800df1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df4:	89 c3                	mov    %eax,%ebx
  800df6:	89 c7                	mov    %eax,%edi
  800df8:	89 c6                	mov    %eax,%esi
  800dfa:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dfc:	5b                   	pop    %ebx
  800dfd:	5e                   	pop    %esi
  800dfe:	5f                   	pop    %edi
  800dff:	5d                   	pop    %ebp
  800e00:	c3                   	ret    

00800e01 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	57                   	push   %edi
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e07:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0c:	b8 01 00 00 00       	mov    $0x1,%eax
  800e11:	89 d1                	mov    %edx,%ecx
  800e13:	89 d3                	mov    %edx,%ebx
  800e15:	89 d7                	mov    %edx,%edi
  800e17:	89 d6                	mov    %edx,%esi
  800e19:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	57                   	push   %edi
  800e24:	56                   	push   %esi
  800e25:	53                   	push   %ebx
  800e26:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e29:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e31:	b8 03 00 00 00       	mov    $0x3,%eax
  800e36:	89 cb                	mov    %ecx,%ebx
  800e38:	89 cf                	mov    %ecx,%edi
  800e3a:	89 ce                	mov    %ecx,%esi
  800e3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	7f 08                	jg     800e4a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800e4e:	6a 03                	push   $0x3
  800e50:	68 1f 2f 80 00       	push   $0x802f1f
  800e55:	6a 23                	push   $0x23
  800e57:	68 3c 2f 80 00       	push   $0x802f3c
  800e5c:	e8 95 f5 ff ff       	call   8003f6 <_panic>

00800e61 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	57                   	push   %edi
  800e65:	56                   	push   %esi
  800e66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e67:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6c:	b8 02 00 00 00       	mov    $0x2,%eax
  800e71:	89 d1                	mov    %edx,%ecx
  800e73:	89 d3                	mov    %edx,%ebx
  800e75:	89 d7                	mov    %edx,%edi
  800e77:	89 d6                	mov    %edx,%esi
  800e79:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e7b:	5b                   	pop    %ebx
  800e7c:	5e                   	pop    %esi
  800e7d:	5f                   	pop    %edi
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <sys_yield>:

void
sys_yield(void)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	57                   	push   %edi
  800e84:	56                   	push   %esi
  800e85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e86:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e90:	89 d1                	mov    %edx,%ecx
  800e92:	89 d3                	mov    %edx,%ebx
  800e94:	89 d7                	mov    %edx,%edi
  800e96:	89 d6                	mov    %edx,%esi
  800e98:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea8:	be 00 00 00 00       	mov    $0x0,%esi
  800ead:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb3:	b8 04 00 00 00       	mov    $0x4,%eax
  800eb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebb:	89 f7                	mov    %esi,%edi
  800ebd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7f 08                	jg     800ecb <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	83 ec 0c             	sub    $0xc,%esp
  800ece:	50                   	push   %eax
  800ecf:	6a 04                	push   $0x4
  800ed1:	68 1f 2f 80 00       	push   $0x802f1f
  800ed6:	6a 23                	push   $0x23
  800ed8:	68 3c 2f 80 00       	push   $0x802f3c
  800edd:	e8 14 f5 ff ff       	call   8003f6 <_panic>

00800ee2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	57                   	push   %edi
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
  800ee8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eeb:	8b 55 08             	mov    0x8(%ebp),%edx
  800eee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef1:	b8 05 00 00 00       	mov    $0x5,%eax
  800ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efc:	8b 75 18             	mov    0x18(%ebp),%esi
  800eff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f01:	85 c0                	test   %eax,%eax
  800f03:	7f 08                	jg     800f0d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0d:	83 ec 0c             	sub    $0xc,%esp
  800f10:	50                   	push   %eax
  800f11:	6a 05                	push   $0x5
  800f13:	68 1f 2f 80 00       	push   $0x802f1f
  800f18:	6a 23                	push   $0x23
  800f1a:	68 3c 2f 80 00       	push   $0x802f3c
  800f1f:	e8 d2 f4 ff ff       	call   8003f6 <_panic>

00800f24 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	57                   	push   %edi
  800f28:	56                   	push   %esi
  800f29:	53                   	push   %ebx
  800f2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f38:	b8 06 00 00 00       	mov    $0x6,%eax
  800f3d:	89 df                	mov    %ebx,%edi
  800f3f:	89 de                	mov    %ebx,%esi
  800f41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f43:	85 c0                	test   %eax,%eax
  800f45:	7f 08                	jg     800f4f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4f:	83 ec 0c             	sub    $0xc,%esp
  800f52:	50                   	push   %eax
  800f53:	6a 06                	push   $0x6
  800f55:	68 1f 2f 80 00       	push   $0x802f1f
  800f5a:	6a 23                	push   $0x23
  800f5c:	68 3c 2f 80 00       	push   $0x802f3c
  800f61:	e8 90 f4 ff ff       	call   8003f6 <_panic>

00800f66 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	57                   	push   %edi
  800f6a:	56                   	push   %esi
  800f6b:	53                   	push   %ebx
  800f6c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f74:	8b 55 08             	mov    0x8(%ebp),%edx
  800f77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7a:	b8 08 00 00 00       	mov    $0x8,%eax
  800f7f:	89 df                	mov    %ebx,%edi
  800f81:	89 de                	mov    %ebx,%esi
  800f83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f85:	85 c0                	test   %eax,%eax
  800f87:	7f 08                	jg     800f91 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f91:	83 ec 0c             	sub    $0xc,%esp
  800f94:	50                   	push   %eax
  800f95:	6a 08                	push   $0x8
  800f97:	68 1f 2f 80 00       	push   $0x802f1f
  800f9c:	6a 23                	push   $0x23
  800f9e:	68 3c 2f 80 00       	push   $0x802f3c
  800fa3:	e8 4e f4 ff ff       	call   8003f6 <_panic>

00800fa8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
  800fae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbc:	b8 09 00 00 00       	mov    $0x9,%eax
  800fc1:	89 df                	mov    %ebx,%edi
  800fc3:	89 de                	mov    %ebx,%esi
  800fc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc7:	85 c0                	test   %eax,%eax
  800fc9:	7f 08                	jg     800fd3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fce:	5b                   	pop    %ebx
  800fcf:	5e                   	pop    %esi
  800fd0:	5f                   	pop    %edi
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd3:	83 ec 0c             	sub    $0xc,%esp
  800fd6:	50                   	push   %eax
  800fd7:	6a 09                	push   $0x9
  800fd9:	68 1f 2f 80 00       	push   $0x802f1f
  800fde:	6a 23                	push   $0x23
  800fe0:	68 3c 2f 80 00       	push   $0x802f3c
  800fe5:	e8 0c f4 ff ff       	call   8003f6 <_panic>

00800fea <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	57                   	push   %edi
  800fee:	56                   	push   %esi
  800fef:	53                   	push   %ebx
  800ff0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffe:	b8 0a 00 00 00       	mov    $0xa,%eax
  801003:	89 df                	mov    %ebx,%edi
  801005:	89 de                	mov    %ebx,%esi
  801007:	cd 30                	int    $0x30
	if(check && ret > 0)
  801009:	85 c0                	test   %eax,%eax
  80100b:	7f 08                	jg     801015 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80100d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801010:	5b                   	pop    %ebx
  801011:	5e                   	pop    %esi
  801012:	5f                   	pop    %edi
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801015:	83 ec 0c             	sub    $0xc,%esp
  801018:	50                   	push   %eax
  801019:	6a 0a                	push   $0xa
  80101b:	68 1f 2f 80 00       	push   $0x802f1f
  801020:	6a 23                	push   $0x23
  801022:	68 3c 2f 80 00       	push   $0x802f3c
  801027:	e8 ca f3 ff ff       	call   8003f6 <_panic>

0080102c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	57                   	push   %edi
  801030:	56                   	push   %esi
  801031:	53                   	push   %ebx
	asm volatile("int %1\n"
  801032:	8b 55 08             	mov    0x8(%ebp),%edx
  801035:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801038:	b8 0c 00 00 00       	mov    $0xc,%eax
  80103d:	be 00 00 00 00       	mov    $0x0,%esi
  801042:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801045:	8b 7d 14             	mov    0x14(%ebp),%edi
  801048:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80104a:	5b                   	pop    %ebx
  80104b:	5e                   	pop    %esi
  80104c:	5f                   	pop    %edi
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	57                   	push   %edi
  801053:	56                   	push   %esi
  801054:	53                   	push   %ebx
  801055:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801058:	b9 00 00 00 00       	mov    $0x0,%ecx
  80105d:	8b 55 08             	mov    0x8(%ebp),%edx
  801060:	b8 0d 00 00 00       	mov    $0xd,%eax
  801065:	89 cb                	mov    %ecx,%ebx
  801067:	89 cf                	mov    %ecx,%edi
  801069:	89 ce                	mov    %ecx,%esi
  80106b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80106d:	85 c0                	test   %eax,%eax
  80106f:	7f 08                	jg     801079 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801071:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5f                   	pop    %edi
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	50                   	push   %eax
  80107d:	6a 0d                	push   $0xd
  80107f:	68 1f 2f 80 00       	push   $0x802f1f
  801084:	6a 23                	push   $0x23
  801086:	68 3c 2f 80 00       	push   $0x802f3c
  80108b:	e8 66 f3 ff ff       	call   8003f6 <_panic>

00801090 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	57                   	push   %edi
  801094:	56                   	push   %esi
  801095:	53                   	push   %ebx
	asm volatile("int %1\n"
  801096:	ba 00 00 00 00       	mov    $0x0,%edx
  80109b:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010a0:	89 d1                	mov    %edx,%ecx
  8010a2:	89 d3                	mov    %edx,%ebx
  8010a4:	89 d7                	mov    %edx,%edi
  8010a6:	89 d6                	mov    %edx,%esi
  8010a8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010aa:	5b                   	pop    %ebx
  8010ab:	5e                   	pop    %esi
  8010ac:	5f                   	pop    %edi
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    

008010af <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	05 00 00 00 30       	add    $0x30000000,%eax
  8010ba:	c1 e8 0c             	shr    $0xc,%eax
}
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    

008010bf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010cf:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    

008010d6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010de:	89 c2                	mov    %eax,%edx
  8010e0:	c1 ea 16             	shr    $0x16,%edx
  8010e3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ea:	f6 c2 01             	test   $0x1,%dl
  8010ed:	74 2d                	je     80111c <fd_alloc+0x46>
  8010ef:	89 c2                	mov    %eax,%edx
  8010f1:	c1 ea 0c             	shr    $0xc,%edx
  8010f4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010fb:	f6 c2 01             	test   $0x1,%dl
  8010fe:	74 1c                	je     80111c <fd_alloc+0x46>
  801100:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801105:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80110a:	75 d2                	jne    8010de <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801115:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80111a:	eb 0a                	jmp    801126 <fd_alloc+0x50>
			*fd_store = fd;
  80111c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801121:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80112e:	83 f8 1f             	cmp    $0x1f,%eax
  801131:	77 30                	ja     801163 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801133:	c1 e0 0c             	shl    $0xc,%eax
  801136:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80113b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801141:	f6 c2 01             	test   $0x1,%dl
  801144:	74 24                	je     80116a <fd_lookup+0x42>
  801146:	89 c2                	mov    %eax,%edx
  801148:	c1 ea 0c             	shr    $0xc,%edx
  80114b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801152:	f6 c2 01             	test   $0x1,%dl
  801155:	74 1a                	je     801171 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115a:	89 02                	mov    %eax,(%edx)
	return 0;
  80115c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801161:	5d                   	pop    %ebp
  801162:	c3                   	ret    
		return -E_INVAL;
  801163:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801168:	eb f7                	jmp    801161 <fd_lookup+0x39>
		return -E_INVAL;
  80116a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116f:	eb f0                	jmp    801161 <fd_lookup+0x39>
  801171:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801176:	eb e9                	jmp    801161 <fd_lookup+0x39>

00801178 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801181:	ba 00 00 00 00       	mov    $0x0,%edx
  801186:	b8 90 57 80 00       	mov    $0x805790,%eax
		if (devtab[i]->dev_id == dev_id) {
  80118b:	39 08                	cmp    %ecx,(%eax)
  80118d:	74 38                	je     8011c7 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80118f:	83 c2 01             	add    $0x1,%edx
  801192:	8b 04 95 c8 2f 80 00 	mov    0x802fc8(,%edx,4),%eax
  801199:	85 c0                	test   %eax,%eax
  80119b:	75 ee                	jne    80118b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80119d:	a1 90 77 80 00       	mov    0x807790,%eax
  8011a2:	8b 40 48             	mov    0x48(%eax),%eax
  8011a5:	83 ec 04             	sub    $0x4,%esp
  8011a8:	51                   	push   %ecx
  8011a9:	50                   	push   %eax
  8011aa:	68 4c 2f 80 00       	push   $0x802f4c
  8011af:	e8 1d f3 ff ff       	call   8004d1 <cprintf>
	*dev = 0;
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    
			*dev = devtab[i];
  8011c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ca:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d1:	eb f2                	jmp    8011c5 <dev_lookup+0x4d>

008011d3 <fd_close>:
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	57                   	push   %edi
  8011d7:	56                   	push   %esi
  8011d8:	53                   	push   %ebx
  8011d9:	83 ec 24             	sub    $0x24,%esp
  8011dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8011df:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011e5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011e6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011ec:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011ef:	50                   	push   %eax
  8011f0:	e8 33 ff ff ff       	call   801128 <fd_lookup>
  8011f5:	89 c3                	mov    %eax,%ebx
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	85 c0                	test   %eax,%eax
  8011fc:	78 05                	js     801203 <fd_close+0x30>
	    || fd != fd2)
  8011fe:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801201:	74 16                	je     801219 <fd_close+0x46>
		return (must_exist ? r : 0);
  801203:	89 f8                	mov    %edi,%eax
  801205:	84 c0                	test   %al,%al
  801207:	b8 00 00 00 00       	mov    $0x0,%eax
  80120c:	0f 44 d8             	cmove  %eax,%ebx
}
  80120f:	89 d8                	mov    %ebx,%eax
  801211:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801214:	5b                   	pop    %ebx
  801215:	5e                   	pop    %esi
  801216:	5f                   	pop    %edi
  801217:	5d                   	pop    %ebp
  801218:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801219:	83 ec 08             	sub    $0x8,%esp
  80121c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80121f:	50                   	push   %eax
  801220:	ff 36                	pushl  (%esi)
  801222:	e8 51 ff ff ff       	call   801178 <dev_lookup>
  801227:	89 c3                	mov    %eax,%ebx
  801229:	83 c4 10             	add    $0x10,%esp
  80122c:	85 c0                	test   %eax,%eax
  80122e:	78 1a                	js     80124a <fd_close+0x77>
		if (dev->dev_close)
  801230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801233:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801236:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80123b:	85 c0                	test   %eax,%eax
  80123d:	74 0b                	je     80124a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80123f:	83 ec 0c             	sub    $0xc,%esp
  801242:	56                   	push   %esi
  801243:	ff d0                	call   *%eax
  801245:	89 c3                	mov    %eax,%ebx
  801247:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80124a:	83 ec 08             	sub    $0x8,%esp
  80124d:	56                   	push   %esi
  80124e:	6a 00                	push   $0x0
  801250:	e8 cf fc ff ff       	call   800f24 <sys_page_unmap>
	return r;
  801255:	83 c4 10             	add    $0x10,%esp
  801258:	eb b5                	jmp    80120f <fd_close+0x3c>

0080125a <close>:

int
close(int fdnum)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801260:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801263:	50                   	push   %eax
  801264:	ff 75 08             	pushl  0x8(%ebp)
  801267:	e8 bc fe ff ff       	call   801128 <fd_lookup>
  80126c:	83 c4 10             	add    $0x10,%esp
  80126f:	85 c0                	test   %eax,%eax
  801271:	79 02                	jns    801275 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    
		return fd_close(fd, 1);
  801275:	83 ec 08             	sub    $0x8,%esp
  801278:	6a 01                	push   $0x1
  80127a:	ff 75 f4             	pushl  -0xc(%ebp)
  80127d:	e8 51 ff ff ff       	call   8011d3 <fd_close>
  801282:	83 c4 10             	add    $0x10,%esp
  801285:	eb ec                	jmp    801273 <close+0x19>

00801287 <close_all>:

void
close_all(void)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
  80128a:	53                   	push   %ebx
  80128b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80128e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801293:	83 ec 0c             	sub    $0xc,%esp
  801296:	53                   	push   %ebx
  801297:	e8 be ff ff ff       	call   80125a <close>
	for (i = 0; i < MAXFD; i++)
  80129c:	83 c3 01             	add    $0x1,%ebx
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	83 fb 20             	cmp    $0x20,%ebx
  8012a5:	75 ec                	jne    801293 <close_all+0xc>
}
  8012a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	57                   	push   %edi
  8012b0:	56                   	push   %esi
  8012b1:	53                   	push   %ebx
  8012b2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b8:	50                   	push   %eax
  8012b9:	ff 75 08             	pushl  0x8(%ebp)
  8012bc:	e8 67 fe ff ff       	call   801128 <fd_lookup>
  8012c1:	89 c3                	mov    %eax,%ebx
  8012c3:	83 c4 10             	add    $0x10,%esp
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	0f 88 81 00 00 00    	js     80134f <dup+0xa3>
		return r;
	close(newfdnum);
  8012ce:	83 ec 0c             	sub    $0xc,%esp
  8012d1:	ff 75 0c             	pushl  0xc(%ebp)
  8012d4:	e8 81 ff ff ff       	call   80125a <close>

	newfd = INDEX2FD(newfdnum);
  8012d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012dc:	c1 e6 0c             	shl    $0xc,%esi
  8012df:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012e5:	83 c4 04             	add    $0x4,%esp
  8012e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012eb:	e8 cf fd ff ff       	call   8010bf <fd2data>
  8012f0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012f2:	89 34 24             	mov    %esi,(%esp)
  8012f5:	e8 c5 fd ff ff       	call   8010bf <fd2data>
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012ff:	89 d8                	mov    %ebx,%eax
  801301:	c1 e8 16             	shr    $0x16,%eax
  801304:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80130b:	a8 01                	test   $0x1,%al
  80130d:	74 11                	je     801320 <dup+0x74>
  80130f:	89 d8                	mov    %ebx,%eax
  801311:	c1 e8 0c             	shr    $0xc,%eax
  801314:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80131b:	f6 c2 01             	test   $0x1,%dl
  80131e:	75 39                	jne    801359 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801320:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801323:	89 d0                	mov    %edx,%eax
  801325:	c1 e8 0c             	shr    $0xc,%eax
  801328:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80132f:	83 ec 0c             	sub    $0xc,%esp
  801332:	25 07 0e 00 00       	and    $0xe07,%eax
  801337:	50                   	push   %eax
  801338:	56                   	push   %esi
  801339:	6a 00                	push   $0x0
  80133b:	52                   	push   %edx
  80133c:	6a 00                	push   $0x0
  80133e:	e8 9f fb ff ff       	call   800ee2 <sys_page_map>
  801343:	89 c3                	mov    %eax,%ebx
  801345:	83 c4 20             	add    $0x20,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	78 31                	js     80137d <dup+0xd1>
		goto err;

	return newfdnum;
  80134c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80134f:	89 d8                	mov    %ebx,%eax
  801351:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801354:	5b                   	pop    %ebx
  801355:	5e                   	pop    %esi
  801356:	5f                   	pop    %edi
  801357:	5d                   	pop    %ebp
  801358:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801359:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	25 07 0e 00 00       	and    $0xe07,%eax
  801368:	50                   	push   %eax
  801369:	57                   	push   %edi
  80136a:	6a 00                	push   $0x0
  80136c:	53                   	push   %ebx
  80136d:	6a 00                	push   $0x0
  80136f:	e8 6e fb ff ff       	call   800ee2 <sys_page_map>
  801374:	89 c3                	mov    %eax,%ebx
  801376:	83 c4 20             	add    $0x20,%esp
  801379:	85 c0                	test   %eax,%eax
  80137b:	79 a3                	jns    801320 <dup+0x74>
	sys_page_unmap(0, newfd);
  80137d:	83 ec 08             	sub    $0x8,%esp
  801380:	56                   	push   %esi
  801381:	6a 00                	push   $0x0
  801383:	e8 9c fb ff ff       	call   800f24 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801388:	83 c4 08             	add    $0x8,%esp
  80138b:	57                   	push   %edi
  80138c:	6a 00                	push   $0x0
  80138e:	e8 91 fb ff ff       	call   800f24 <sys_page_unmap>
	return r;
  801393:	83 c4 10             	add    $0x10,%esp
  801396:	eb b7                	jmp    80134f <dup+0xa3>

00801398 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	53                   	push   %ebx
  80139c:	83 ec 1c             	sub    $0x1c,%esp
  80139f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a5:	50                   	push   %eax
  8013a6:	53                   	push   %ebx
  8013a7:	e8 7c fd ff ff       	call   801128 <fd_lookup>
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	78 3f                	js     8013f2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b9:	50                   	push   %eax
  8013ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bd:	ff 30                	pushl  (%eax)
  8013bf:	e8 b4 fd ff ff       	call   801178 <dev_lookup>
  8013c4:	83 c4 10             	add    $0x10,%esp
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	78 27                	js     8013f2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ce:	8b 42 08             	mov    0x8(%edx),%eax
  8013d1:	83 e0 03             	and    $0x3,%eax
  8013d4:	83 f8 01             	cmp    $0x1,%eax
  8013d7:	74 1e                	je     8013f7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013dc:	8b 40 08             	mov    0x8(%eax),%eax
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	74 35                	je     801418 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013e3:	83 ec 04             	sub    $0x4,%esp
  8013e6:	ff 75 10             	pushl  0x10(%ebp)
  8013e9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ec:	52                   	push   %edx
  8013ed:	ff d0                	call   *%eax
  8013ef:	83 c4 10             	add    $0x10,%esp
}
  8013f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013f7:	a1 90 77 80 00       	mov    0x807790,%eax
  8013fc:	8b 40 48             	mov    0x48(%eax),%eax
  8013ff:	83 ec 04             	sub    $0x4,%esp
  801402:	53                   	push   %ebx
  801403:	50                   	push   %eax
  801404:	68 8d 2f 80 00       	push   $0x802f8d
  801409:	e8 c3 f0 ff ff       	call   8004d1 <cprintf>
		return -E_INVAL;
  80140e:	83 c4 10             	add    $0x10,%esp
  801411:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801416:	eb da                	jmp    8013f2 <read+0x5a>
		return -E_NOT_SUPP;
  801418:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80141d:	eb d3                	jmp    8013f2 <read+0x5a>

0080141f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	57                   	push   %edi
  801423:	56                   	push   %esi
  801424:	53                   	push   %ebx
  801425:	83 ec 0c             	sub    $0xc,%esp
  801428:	8b 7d 08             	mov    0x8(%ebp),%edi
  80142b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80142e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801433:	39 f3                	cmp    %esi,%ebx
  801435:	73 23                	jae    80145a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801437:	83 ec 04             	sub    $0x4,%esp
  80143a:	89 f0                	mov    %esi,%eax
  80143c:	29 d8                	sub    %ebx,%eax
  80143e:	50                   	push   %eax
  80143f:	89 d8                	mov    %ebx,%eax
  801441:	03 45 0c             	add    0xc(%ebp),%eax
  801444:	50                   	push   %eax
  801445:	57                   	push   %edi
  801446:	e8 4d ff ff ff       	call   801398 <read>
		if (m < 0)
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	85 c0                	test   %eax,%eax
  801450:	78 06                	js     801458 <readn+0x39>
			return m;
		if (m == 0)
  801452:	74 06                	je     80145a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801454:	01 c3                	add    %eax,%ebx
  801456:	eb db                	jmp    801433 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801458:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80145a:	89 d8                	mov    %ebx,%eax
  80145c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80145f:	5b                   	pop    %ebx
  801460:	5e                   	pop    %esi
  801461:	5f                   	pop    %edi
  801462:	5d                   	pop    %ebp
  801463:	c3                   	ret    

00801464 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	53                   	push   %ebx
  801468:	83 ec 1c             	sub    $0x1c,%esp
  80146b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801471:	50                   	push   %eax
  801472:	53                   	push   %ebx
  801473:	e8 b0 fc ff ff       	call   801128 <fd_lookup>
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 3a                	js     8014b9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147f:	83 ec 08             	sub    $0x8,%esp
  801482:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801489:	ff 30                	pushl  (%eax)
  80148b:	e8 e8 fc ff ff       	call   801178 <dev_lookup>
  801490:	83 c4 10             	add    $0x10,%esp
  801493:	85 c0                	test   %eax,%eax
  801495:	78 22                	js     8014b9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80149e:	74 1e                	je     8014be <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a3:	8b 52 0c             	mov    0xc(%edx),%edx
  8014a6:	85 d2                	test   %edx,%edx
  8014a8:	74 35                	je     8014df <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014aa:	83 ec 04             	sub    $0x4,%esp
  8014ad:	ff 75 10             	pushl  0x10(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	50                   	push   %eax
  8014b4:	ff d2                	call   *%edx
  8014b6:	83 c4 10             	add    $0x10,%esp
}
  8014b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014be:	a1 90 77 80 00       	mov    0x807790,%eax
  8014c3:	8b 40 48             	mov    0x48(%eax),%eax
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	53                   	push   %ebx
  8014ca:	50                   	push   %eax
  8014cb:	68 a9 2f 80 00       	push   $0x802fa9
  8014d0:	e8 fc ef ff ff       	call   8004d1 <cprintf>
		return -E_INVAL;
  8014d5:	83 c4 10             	add    $0x10,%esp
  8014d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014dd:	eb da                	jmp    8014b9 <write+0x55>
		return -E_NOT_SUPP;
  8014df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e4:	eb d3                	jmp    8014b9 <write+0x55>

008014e6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ef:	50                   	push   %eax
  8014f0:	ff 75 08             	pushl  0x8(%ebp)
  8014f3:	e8 30 fc ff ff       	call   801128 <fd_lookup>
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	78 0e                	js     80150d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801505:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801508:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	53                   	push   %ebx
  801513:	83 ec 1c             	sub    $0x1c,%esp
  801516:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801519:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	53                   	push   %ebx
  80151e:	e8 05 fc ff ff       	call   801128 <fd_lookup>
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	85 c0                	test   %eax,%eax
  801528:	78 37                	js     801561 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152a:	83 ec 08             	sub    $0x8,%esp
  80152d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801530:	50                   	push   %eax
  801531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801534:	ff 30                	pushl  (%eax)
  801536:	e8 3d fc ff ff       	call   801178 <dev_lookup>
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	85 c0                	test   %eax,%eax
  801540:	78 1f                	js     801561 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801545:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801549:	74 1b                	je     801566 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80154b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154e:	8b 52 18             	mov    0x18(%edx),%edx
  801551:	85 d2                	test   %edx,%edx
  801553:	74 32                	je     801587 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	ff 75 0c             	pushl  0xc(%ebp)
  80155b:	50                   	push   %eax
  80155c:	ff d2                	call   *%edx
  80155e:	83 c4 10             	add    $0x10,%esp
}
  801561:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801564:	c9                   	leave  
  801565:	c3                   	ret    
			thisenv->env_id, fdnum);
  801566:	a1 90 77 80 00       	mov    0x807790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80156b:	8b 40 48             	mov    0x48(%eax),%eax
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	53                   	push   %ebx
  801572:	50                   	push   %eax
  801573:	68 6c 2f 80 00       	push   $0x802f6c
  801578:	e8 54 ef ff ff       	call   8004d1 <cprintf>
		return -E_INVAL;
  80157d:	83 c4 10             	add    $0x10,%esp
  801580:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801585:	eb da                	jmp    801561 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801587:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80158c:	eb d3                	jmp    801561 <ftruncate+0x52>

0080158e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	53                   	push   %ebx
  801592:	83 ec 1c             	sub    $0x1c,%esp
  801595:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801598:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	ff 75 08             	pushl  0x8(%ebp)
  80159f:	e8 84 fb ff ff       	call   801128 <fd_lookup>
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	78 4b                	js     8015f6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b1:	50                   	push   %eax
  8015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b5:	ff 30                	pushl  (%eax)
  8015b7:	e8 bc fb ff ff       	call   801178 <dev_lookup>
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	78 33                	js     8015f6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015ca:	74 2f                	je     8015fb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015cc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015cf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015d6:	00 00 00 
	stat->st_isdir = 0;
  8015d9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015e0:	00 00 00 
	stat->st_dev = dev;
  8015e3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015e9:	83 ec 08             	sub    $0x8,%esp
  8015ec:	53                   	push   %ebx
  8015ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f0:	ff 50 14             	call   *0x14(%eax)
  8015f3:	83 c4 10             	add    $0x10,%esp
}
  8015f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    
		return -E_NOT_SUPP;
  8015fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801600:	eb f4                	jmp    8015f6 <fstat+0x68>

00801602 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	56                   	push   %esi
  801606:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801607:	83 ec 08             	sub    $0x8,%esp
  80160a:	6a 00                	push   $0x0
  80160c:	ff 75 08             	pushl  0x8(%ebp)
  80160f:	e8 2f 02 00 00       	call   801843 <open>
  801614:	89 c3                	mov    %eax,%ebx
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	85 c0                	test   %eax,%eax
  80161b:	78 1b                	js     801638 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80161d:	83 ec 08             	sub    $0x8,%esp
  801620:	ff 75 0c             	pushl  0xc(%ebp)
  801623:	50                   	push   %eax
  801624:	e8 65 ff ff ff       	call   80158e <fstat>
  801629:	89 c6                	mov    %eax,%esi
	close(fd);
  80162b:	89 1c 24             	mov    %ebx,(%esp)
  80162e:	e8 27 fc ff ff       	call   80125a <close>
	return r;
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	89 f3                	mov    %esi,%ebx
}
  801638:	89 d8                	mov    %ebx,%eax
  80163a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5e                   	pop    %esi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    

00801641 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	56                   	push   %esi
  801645:	53                   	push   %ebx
  801646:	89 c6                	mov    %eax,%esi
  801648:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80164a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801651:	74 27                	je     80167a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801653:	6a 07                	push   $0x7
  801655:	68 00 80 80 00       	push   $0x808000
  80165a:	56                   	push   %esi
  80165b:	ff 35 00 60 80 00    	pushl  0x806000
  801661:	e8 f8 10 00 00       	call   80275e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801666:	83 c4 0c             	add    $0xc,%esp
  801669:	6a 00                	push   $0x0
  80166b:	53                   	push   %ebx
  80166c:	6a 00                	push   $0x0
  80166e:	e8 78 10 00 00       	call   8026eb <ipc_recv>
}
  801673:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801676:	5b                   	pop    %ebx
  801677:	5e                   	pop    %esi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80167a:	83 ec 0c             	sub    $0xc,%esp
  80167d:	6a 01                	push   $0x1
  80167f:	e8 46 11 00 00       	call   8027ca <ipc_find_env>
  801684:	a3 00 60 80 00       	mov    %eax,0x806000
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	eb c5                	jmp    801653 <fsipc+0x12>

0080168e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	8b 40 0c             	mov    0xc(%eax),%eax
  80169a:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ac:	b8 02 00 00 00       	mov    $0x2,%eax
  8016b1:	e8 8b ff ff ff       	call   801641 <fsipc>
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <devfile_flush>:
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c4:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  8016c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ce:	b8 06 00 00 00       	mov    $0x6,%eax
  8016d3:	e8 69 ff ff ff       	call   801641 <fsipc>
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <devfile_stat>:
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 04             	sub    $0x4,%esp
  8016e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ea:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f4:	b8 05 00 00 00       	mov    $0x5,%eax
  8016f9:	e8 43 ff ff ff       	call   801641 <fsipc>
  8016fe:	85 c0                	test   %eax,%eax
  801700:	78 2c                	js     80172e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801702:	83 ec 08             	sub    $0x8,%esp
  801705:	68 00 80 80 00       	push   $0x808000
  80170a:	53                   	push   %ebx
  80170b:	e8 9d f3 ff ff       	call   800aad <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801710:	a1 80 80 80 00       	mov    0x808080,%eax
  801715:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80171b:	a1 84 80 80 00       	mov    0x808084,%eax
  801720:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <devfile_write>:
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	53                   	push   %ebx
  801737:	83 ec 04             	sub    $0x4,%esp
  80173a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  80173d:	85 db                	test   %ebx,%ebx
  80173f:	75 07                	jne    801748 <devfile_write+0x15>
	return n_all;
  801741:	89 d8                	mov    %ebx,%eax
}
  801743:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801746:	c9                   	leave  
  801747:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	8b 40 0c             	mov    0xc(%eax),%eax
  80174e:	a3 00 80 80 00       	mov    %eax,0x808000
	  fsipcbuf.write.req_n = n_left;
  801753:	89 1d 04 80 80 00    	mov    %ebx,0x808004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	53                   	push   %ebx
  80175d:	ff 75 0c             	pushl  0xc(%ebp)
  801760:	68 08 80 80 00       	push   $0x808008
  801765:	e8 d1 f4 ff ff       	call   800c3b <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80176a:	ba 00 00 00 00       	mov    $0x0,%edx
  80176f:	b8 04 00 00 00       	mov    $0x4,%eax
  801774:	e8 c8 fe ff ff       	call   801641 <fsipc>
  801779:	83 c4 10             	add    $0x10,%esp
  80177c:	85 c0                	test   %eax,%eax
  80177e:	78 c3                	js     801743 <devfile_write+0x10>
	  assert(r <= n_left);
  801780:	39 d8                	cmp    %ebx,%eax
  801782:	77 0b                	ja     80178f <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801784:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801789:	7f 1d                	jg     8017a8 <devfile_write+0x75>
    n_all += r;
  80178b:	89 c3                	mov    %eax,%ebx
  80178d:	eb b2                	jmp    801741 <devfile_write+0xe>
	  assert(r <= n_left);
  80178f:	68 dc 2f 80 00       	push   $0x802fdc
  801794:	68 e8 2f 80 00       	push   $0x802fe8
  801799:	68 9f 00 00 00       	push   $0x9f
  80179e:	68 fd 2f 80 00       	push   $0x802ffd
  8017a3:	e8 4e ec ff ff       	call   8003f6 <_panic>
	  assert(r <= PGSIZE);
  8017a8:	68 08 30 80 00       	push   $0x803008
  8017ad:	68 e8 2f 80 00       	push   $0x802fe8
  8017b2:	68 a0 00 00 00       	push   $0xa0
  8017b7:	68 fd 2f 80 00       	push   $0x802ffd
  8017bc:	e8 35 ec ff ff       	call   8003f6 <_panic>

008017c1 <devfile_read>:
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	56                   	push   %esi
  8017c5:	53                   	push   %ebx
  8017c6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017cf:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  8017d4:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017da:	ba 00 00 00 00       	mov    $0x0,%edx
  8017df:	b8 03 00 00 00       	mov    $0x3,%eax
  8017e4:	e8 58 fe ff ff       	call   801641 <fsipc>
  8017e9:	89 c3                	mov    %eax,%ebx
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	78 1f                	js     80180e <devfile_read+0x4d>
	assert(r <= n);
  8017ef:	39 f0                	cmp    %esi,%eax
  8017f1:	77 24                	ja     801817 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017f3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017f8:	7f 33                	jg     80182d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017fa:	83 ec 04             	sub    $0x4,%esp
  8017fd:	50                   	push   %eax
  8017fe:	68 00 80 80 00       	push   $0x808000
  801803:	ff 75 0c             	pushl  0xc(%ebp)
  801806:	e8 30 f4 ff ff       	call   800c3b <memmove>
	return r;
  80180b:	83 c4 10             	add    $0x10,%esp
}
  80180e:	89 d8                	mov    %ebx,%eax
  801810:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801813:	5b                   	pop    %ebx
  801814:	5e                   	pop    %esi
  801815:	5d                   	pop    %ebp
  801816:	c3                   	ret    
	assert(r <= n);
  801817:	68 14 30 80 00       	push   $0x803014
  80181c:	68 e8 2f 80 00       	push   $0x802fe8
  801821:	6a 7c                	push   $0x7c
  801823:	68 fd 2f 80 00       	push   $0x802ffd
  801828:	e8 c9 eb ff ff       	call   8003f6 <_panic>
	assert(r <= PGSIZE);
  80182d:	68 08 30 80 00       	push   $0x803008
  801832:	68 e8 2f 80 00       	push   $0x802fe8
  801837:	6a 7d                	push   $0x7d
  801839:	68 fd 2f 80 00       	push   $0x802ffd
  80183e:	e8 b3 eb ff ff       	call   8003f6 <_panic>

00801843 <open>:
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	56                   	push   %esi
  801847:	53                   	push   %ebx
  801848:	83 ec 1c             	sub    $0x1c,%esp
  80184b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80184e:	56                   	push   %esi
  80184f:	e8 20 f2 ff ff       	call   800a74 <strlen>
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80185c:	7f 6c                	jg     8018ca <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80185e:	83 ec 0c             	sub    $0xc,%esp
  801861:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801864:	50                   	push   %eax
  801865:	e8 6c f8 ff ff       	call   8010d6 <fd_alloc>
  80186a:	89 c3                	mov    %eax,%ebx
  80186c:	83 c4 10             	add    $0x10,%esp
  80186f:	85 c0                	test   %eax,%eax
  801871:	78 3c                	js     8018af <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801873:	83 ec 08             	sub    $0x8,%esp
  801876:	56                   	push   %esi
  801877:	68 00 80 80 00       	push   $0x808000
  80187c:	e8 2c f2 ff ff       	call   800aad <strcpy>
	fsipcbuf.open.req_omode = mode;
  801881:	8b 45 0c             	mov    0xc(%ebp),%eax
  801884:	a3 00 84 80 00       	mov    %eax,0x808400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801889:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80188c:	b8 01 00 00 00       	mov    $0x1,%eax
  801891:	e8 ab fd ff ff       	call   801641 <fsipc>
  801896:	89 c3                	mov    %eax,%ebx
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	85 c0                	test   %eax,%eax
  80189d:	78 19                	js     8018b8 <open+0x75>
	return fd2num(fd);
  80189f:	83 ec 0c             	sub    $0xc,%esp
  8018a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a5:	e8 05 f8 ff ff       	call   8010af <fd2num>
  8018aa:	89 c3                	mov    %eax,%ebx
  8018ac:	83 c4 10             	add    $0x10,%esp
}
  8018af:	89 d8                	mov    %ebx,%eax
  8018b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b4:	5b                   	pop    %ebx
  8018b5:	5e                   	pop    %esi
  8018b6:	5d                   	pop    %ebp
  8018b7:	c3                   	ret    
		fd_close(fd, 0);
  8018b8:	83 ec 08             	sub    $0x8,%esp
  8018bb:	6a 00                	push   $0x0
  8018bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c0:	e8 0e f9 ff ff       	call   8011d3 <fd_close>
		return r;
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	eb e5                	jmp    8018af <open+0x6c>
		return -E_BAD_PATH;
  8018ca:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018cf:	eb de                	jmp    8018af <open+0x6c>

008018d1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018dc:	b8 08 00 00 00       	mov    $0x8,%eax
  8018e1:	e8 5b fd ff ff       	call   801641 <fsipc>
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	57                   	push   %edi
  8018ec:	56                   	push   %esi
  8018ed:	53                   	push   %ebx
  8018ee:	81 ec 8c 02 00 00    	sub    $0x28c,%esp
  cprintf("spawn: parent eid = %08x\n", sys_getenvid());
  8018f4:	e8 68 f5 ff ff       	call   800e61 <sys_getenvid>
  8018f9:	83 ec 08             	sub    $0x8,%esp
  8018fc:	50                   	push   %eax
  8018fd:	68 1b 30 80 00       	push   $0x80301b
  801902:	e8 ca eb ff ff       	call   8004d1 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801907:	83 c4 08             	add    $0x8,%esp
  80190a:	6a 00                	push   $0x0
  80190c:	ff 75 08             	pushl  0x8(%ebp)
  80190f:	e8 2f ff ff ff       	call   801843 <open>
  801914:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	85 c0                	test   %eax,%eax
  80191f:	0f 88 fb 04 00 00    	js     801e20 <spawn+0x538>
  801925:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	68 00 02 00 00       	push   $0x200
  80192f:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801935:	50                   	push   %eax
  801936:	52                   	push   %edx
  801937:	e8 e3 fa ff ff       	call   80141f <readn>
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	3d 00 02 00 00       	cmp    $0x200,%eax
  801944:	75 71                	jne    8019b7 <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  801946:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80194d:	45 4c 46 
  801950:	75 65                	jne    8019b7 <spawn+0xcf>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801952:	b8 07 00 00 00       	mov    $0x7,%eax
  801957:	cd 30                	int    $0x30
  801959:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80195f:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801965:	89 c6                	mov    %eax,%esi
  801967:	85 c0                	test   %eax,%eax
  801969:	0f 88 a5 04 00 00    	js     801e14 <spawn+0x52c>
		return r;
	child = r;
  cprintf("spawn: child eid = %08x\n", child);
  80196f:	83 ec 08             	sub    $0x8,%esp
  801972:	50                   	push   %eax
  801973:	68 4f 30 80 00       	push   $0x80304f
  801978:	e8 54 eb ff ff       	call   8004d1 <cprintf>

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80197d:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801983:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801986:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80198c:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801992:	b9 11 00 00 00       	mov    $0x11,%ecx
  801997:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801999:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80199f:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  8019a5:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019a8:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8019ad:	be 00 00 00 00       	mov    $0x0,%esi
  8019b2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8019b5:	eb 4b                	jmp    801a02 <spawn+0x11a>
		close(fd);
  8019b7:	83 ec 0c             	sub    $0xc,%esp
  8019ba:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8019c0:	e8 95 f8 ff ff       	call   80125a <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8019c5:	83 c4 0c             	add    $0xc,%esp
  8019c8:	68 7f 45 4c 46       	push   $0x464c457f
  8019cd:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8019d3:	68 35 30 80 00       	push   $0x803035
  8019d8:	e8 f4 ea ff ff       	call   8004d1 <cprintf>
		return -E_NOT_EXEC;
  8019dd:	83 c4 10             	add    $0x10,%esp
  8019e0:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8019e7:	ff ff ff 
  8019ea:	e9 31 04 00 00       	jmp    801e20 <spawn+0x538>
		string_size += strlen(argv[argc]) + 1;
  8019ef:	83 ec 0c             	sub    $0xc,%esp
  8019f2:	50                   	push   %eax
  8019f3:	e8 7c f0 ff ff       	call   800a74 <strlen>
  8019f8:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8019fc:	83 c3 01             	add    $0x1,%ebx
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801a09:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801a0c:	85 c0                	test   %eax,%eax
  801a0e:	75 df                	jne    8019ef <spawn+0x107>
  801a10:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801a16:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801a1c:	bf 00 10 40 00       	mov    $0x401000,%edi
  801a21:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801a23:	89 fa                	mov    %edi,%edx
  801a25:	83 e2 fc             	and    $0xfffffffc,%edx
  801a28:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801a2f:	29 c2                	sub    %eax,%edx
  801a31:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801a37:	8d 42 f8             	lea    -0x8(%edx),%eax
  801a3a:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801a3f:	0f 86 fe 03 00 00    	jbe    801e43 <spawn+0x55b>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a45:	83 ec 04             	sub    $0x4,%esp
  801a48:	6a 07                	push   $0x7
  801a4a:	68 00 00 40 00       	push   $0x400000
  801a4f:	6a 00                	push   $0x0
  801a51:	e8 49 f4 ff ff       	call   800e9f <sys_page_alloc>
  801a56:	83 c4 10             	add    $0x10,%esp
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	0f 88 e7 03 00 00    	js     801e48 <spawn+0x560>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a61:	be 00 00 00 00       	mov    $0x0,%esi
  801a66:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801a6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a6f:	eb 30                	jmp    801aa1 <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  801a71:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a77:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801a7d:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801a80:	83 ec 08             	sub    $0x8,%esp
  801a83:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a86:	57                   	push   %edi
  801a87:	e8 21 f0 ff ff       	call   800aad <strcpy>
		string_store += strlen(argv[i]) + 1;
  801a8c:	83 c4 04             	add    $0x4,%esp
  801a8f:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a92:	e8 dd ef ff ff       	call   800a74 <strlen>
  801a97:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801a9b:	83 c6 01             	add    $0x1,%esi
  801a9e:	83 c4 10             	add    $0x10,%esp
  801aa1:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801aa7:	7f c8                	jg     801a71 <spawn+0x189>
	}
	argv_store[argc] = 0;
  801aa9:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801aaf:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801ab5:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801abc:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801ac2:	0f 85 86 00 00 00    	jne    801b4e <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801ac8:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801ace:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801ad4:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801ad7:	89 c8                	mov    %ecx,%eax
  801ad9:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801adf:	89 79 f8             	mov    %edi,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801ae2:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801ae7:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801aed:	83 ec 0c             	sub    $0xc,%esp
  801af0:	6a 07                	push   $0x7
  801af2:	68 00 d0 bf ee       	push   $0xeebfd000
  801af7:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801afd:	68 00 00 40 00       	push   $0x400000
  801b02:	6a 00                	push   $0x0
  801b04:	e8 d9 f3 ff ff       	call   800ee2 <sys_page_map>
  801b09:	89 c3                	mov    %eax,%ebx
  801b0b:	83 c4 20             	add    $0x20,%esp
  801b0e:	85 c0                	test   %eax,%eax
  801b10:	0f 88 3a 03 00 00    	js     801e50 <spawn+0x568>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801b16:	83 ec 08             	sub    $0x8,%esp
  801b19:	68 00 00 40 00       	push   $0x400000
  801b1e:	6a 00                	push   $0x0
  801b20:	e8 ff f3 ff ff       	call   800f24 <sys_page_unmap>
  801b25:	89 c3                	mov    %eax,%ebx
  801b27:	83 c4 10             	add    $0x10,%esp
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	0f 88 1e 03 00 00    	js     801e50 <spawn+0x568>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801b32:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801b38:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b3f:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801b46:	00 00 00 
  801b49:	e9 4f 01 00 00       	jmp    801c9d <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b4e:	68 d8 30 80 00       	push   $0x8030d8
  801b53:	68 e8 2f 80 00       	push   $0x802fe8
  801b58:	68 f4 00 00 00       	push   $0xf4
  801b5d:	68 68 30 80 00       	push   $0x803068
  801b62:	e8 8f e8 ff ff       	call   8003f6 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	6a 07                	push   $0x7
  801b6c:	68 00 00 40 00       	push   $0x400000
  801b71:	6a 00                	push   $0x0
  801b73:	e8 27 f3 ff ff       	call   800e9f <sys_page_alloc>
  801b78:	83 c4 10             	add    $0x10,%esp
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	0f 88 ab 02 00 00    	js     801e2e <spawn+0x546>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801b83:	83 ec 08             	sub    $0x8,%esp
  801b86:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b8c:	01 f0                	add    %esi,%eax
  801b8e:	50                   	push   %eax
  801b8f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b95:	e8 4c f9 ff ff       	call   8014e6 <seek>
  801b9a:	83 c4 10             	add    $0x10,%esp
  801b9d:	85 c0                	test   %eax,%eax
  801b9f:	0f 88 90 02 00 00    	js     801e35 <spawn+0x54d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801ba5:	83 ec 04             	sub    $0x4,%esp
  801ba8:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801bae:	29 f0                	sub    %esi,%eax
  801bb0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bb5:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801bba:	0f 47 c1             	cmova  %ecx,%eax
  801bbd:	50                   	push   %eax
  801bbe:	68 00 00 40 00       	push   $0x400000
  801bc3:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801bc9:	e8 51 f8 ff ff       	call   80141f <readn>
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	0f 88 63 02 00 00    	js     801e3c <spawn+0x554>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801bd9:	83 ec 0c             	sub    $0xc,%esp
  801bdc:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801be2:	53                   	push   %ebx
  801be3:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801be9:	68 00 00 40 00       	push   $0x400000
  801bee:	6a 00                	push   $0x0
  801bf0:	e8 ed f2 ff ff       	call   800ee2 <sys_page_map>
  801bf5:	83 c4 20             	add    $0x20,%esp
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	78 7c                	js     801c78 <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801bfc:	83 ec 08             	sub    $0x8,%esp
  801bff:	68 00 00 40 00       	push   $0x400000
  801c04:	6a 00                	push   $0x0
  801c06:	e8 19 f3 ff ff       	call   800f24 <sys_page_unmap>
  801c0b:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801c0e:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801c14:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c1a:	89 fe                	mov    %edi,%esi
  801c1c:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801c22:	76 69                	jbe    801c8d <spawn+0x3a5>
		if (i >= filesz) {
  801c24:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801c2a:	0f 87 37 ff ff ff    	ja     801b67 <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801c30:	83 ec 04             	sub    $0x4,%esp
  801c33:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c39:	53                   	push   %ebx
  801c3a:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801c40:	e8 5a f2 ff ff       	call   800e9f <sys_page_alloc>
  801c45:	83 c4 10             	add    $0x10,%esp
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	79 c2                	jns    801c0e <spawn+0x326>
  801c4c:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c57:	e8 c4 f1 ff ff       	call   800e20 <sys_env_destroy>
	close(fd);
  801c5c:	83 c4 04             	add    $0x4,%esp
  801c5f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c65:	e8 f0 f5 ff ff       	call   80125a <close>
	return r;
  801c6a:	83 c4 10             	add    $0x10,%esp
  801c6d:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801c73:	e9 a8 01 00 00       	jmp    801e20 <spawn+0x538>
				panic("spawn: sys_page_map data: %e", r);
  801c78:	50                   	push   %eax
  801c79:	68 74 30 80 00       	push   $0x803074
  801c7e:	68 27 01 00 00       	push   $0x127
  801c83:	68 68 30 80 00       	push   $0x803068
  801c88:	e8 69 e7 ff ff       	call   8003f6 <_panic>
  801c8d:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c93:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801c9a:	83 c6 20             	add    $0x20,%esi
  801c9d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801ca4:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801caa:	7e 6d                	jle    801d19 <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  801cac:	83 3e 01             	cmpl   $0x1,(%esi)
  801caf:	75 e2                	jne    801c93 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801cb1:	8b 46 18             	mov    0x18(%esi),%eax
  801cb4:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801cb7:	83 f8 01             	cmp    $0x1,%eax
  801cba:	19 c0                	sbb    %eax,%eax
  801cbc:	83 e0 fe             	and    $0xfffffffe,%eax
  801cbf:	83 c0 07             	add    $0x7,%eax
  801cc2:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801cc8:	8b 4e 04             	mov    0x4(%esi),%ecx
  801ccb:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801cd1:	8b 56 10             	mov    0x10(%esi),%edx
  801cd4:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801cda:	8b 7e 14             	mov    0x14(%esi),%edi
  801cdd:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801ce3:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801ce6:	89 d8                	mov    %ebx,%eax
  801ce8:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ced:	74 1a                	je     801d09 <spawn+0x421>
		va -= i;
  801cef:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801cf1:	01 c7                	add    %eax,%edi
  801cf3:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801cf9:	01 c2                	add    %eax,%edx
  801cfb:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801d01:	29 c1                	sub    %eax,%ecx
  801d03:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801d09:	bf 00 00 00 00       	mov    $0x0,%edi
  801d0e:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801d14:	e9 01 ff ff ff       	jmp    801c1a <spawn+0x332>
	close(fd);
  801d19:	83 ec 0c             	sub    $0xc,%esp
  801d1c:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d22:	e8 33 f5 ff ff       	call   80125a <close>
  801d27:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for(unsigned int i = 0; i < PGNUM(UTOP); i++)
  801d2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d2f:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801d35:	eb 0d                	jmp    801d44 <spawn+0x45c>
  801d37:	83 c3 01             	add    $0x1,%ebx
  801d3a:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801d40:	77 5d                	ja     801d9f <spawn+0x4b7>
	{
		// Remember to ignore exception stack
		if(i == PGNUM(UXSTACKTOP - PGSIZE))
  801d42:	74 f3                	je     801d37 <spawn+0x44f>
			continue;
		// check whether this page table entry is valid(whether there exists a mapping)
		void* addr = (void*)(i * PGSIZE);
  801d44:	89 da                	mov    %ebx,%edx
  801d46:	c1 e2 0c             	shl    $0xc,%edx
    //BUG
    //if (uvpd[PDX(addr)] & PTE_P)  continue;
    if (!(uvpd[PDX(addr)] & PTE_P))  continue;
  801d49:	89 d0                	mov    %edx,%eax
  801d4b:	c1 e8 16             	shr    $0x16,%eax
  801d4e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d55:	a8 01                	test   $0x1,%al
  801d57:	74 de                	je     801d37 <spawn+0x44f>
		pte_t pte = uvpt[i];
  801d59:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		if((pte & PTE_P) && (pte & PTE_SHARE))
  801d60:	89 c1                	mov    %eax,%ecx
  801d62:	81 e1 01 04 00 00    	and    $0x401,%ecx
  801d68:	81 f9 01 04 00 00    	cmp    $0x401,%ecx
  801d6e:	75 c7                	jne    801d37 <spawn+0x44f>
		{
			int error_code = 0;
			if((error_code = sys_page_map(0, addr, child, addr, pte & PTE_SYSCALL)) < 0)
  801d70:	83 ec 0c             	sub    $0xc,%esp
  801d73:	25 07 0e 00 00       	and    $0xe07,%eax
  801d78:	50                   	push   %eax
  801d79:	52                   	push   %edx
  801d7a:	56                   	push   %esi
  801d7b:	52                   	push   %edx
  801d7c:	6a 00                	push   $0x0
  801d7e:	e8 5f f1 ff ff       	call   800ee2 <sys_page_map>
  801d83:	83 c4 20             	add    $0x20,%esp
  801d86:	85 c0                	test   %eax,%eax
  801d88:	79 ad                	jns    801d37 <spawn+0x44f>
				panic("Page Map Failed: %e", error_code);
  801d8a:	50                   	push   %eax
  801d8b:	68 91 30 80 00       	push   $0x803091
  801d90:	68 42 01 00 00       	push   $0x142
  801d95:	68 68 30 80 00       	push   $0x803068
  801d9a:	e8 57 e6 ff ff       	call   8003f6 <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801d9f:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801da6:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801da9:	83 ec 08             	sub    $0x8,%esp
  801dac:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801db2:	50                   	push   %eax
  801db3:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801db9:	e8 ea f1 ff ff       	call   800fa8 <sys_env_set_trapframe>
  801dbe:	83 c4 10             	add    $0x10,%esp
  801dc1:	85 c0                	test   %eax,%eax
  801dc3:	78 25                	js     801dea <spawn+0x502>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801dc5:	83 ec 08             	sub    $0x8,%esp
  801dc8:	6a 02                	push   $0x2
  801dca:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801dd0:	e8 91 f1 ff ff       	call   800f66 <sys_env_set_status>
  801dd5:	83 c4 10             	add    $0x10,%esp
  801dd8:	85 c0                	test   %eax,%eax
  801dda:	78 23                	js     801dff <spawn+0x517>
	return child;
  801ddc:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801de2:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801de8:	eb 36                	jmp    801e20 <spawn+0x538>
		panic("sys_env_set_trapframe: %e", r);
  801dea:	50                   	push   %eax
  801deb:	68 a5 30 80 00       	push   $0x8030a5
  801df0:	68 88 00 00 00       	push   $0x88
  801df5:	68 68 30 80 00       	push   $0x803068
  801dfa:	e8 f7 e5 ff ff       	call   8003f6 <_panic>
		panic("sys_env_set_status: %e", r);
  801dff:	50                   	push   %eax
  801e00:	68 bf 30 80 00       	push   $0x8030bf
  801e05:	68 8b 00 00 00       	push   $0x8b
  801e0a:	68 68 30 80 00       	push   $0x803068
  801e0f:	e8 e2 e5 ff ff       	call   8003f6 <_panic>
		return r;
  801e14:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e1a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801e20:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e29:	5b                   	pop    %ebx
  801e2a:	5e                   	pop    %esi
  801e2b:	5f                   	pop    %edi
  801e2c:	5d                   	pop    %ebp
  801e2d:	c3                   	ret    
  801e2e:	89 c7                	mov    %eax,%edi
  801e30:	e9 19 fe ff ff       	jmp    801c4e <spawn+0x366>
  801e35:	89 c7                	mov    %eax,%edi
  801e37:	e9 12 fe ff ff       	jmp    801c4e <spawn+0x366>
  801e3c:	89 c7                	mov    %eax,%edi
  801e3e:	e9 0b fe ff ff       	jmp    801c4e <spawn+0x366>
		return -E_NO_MEM;
  801e43:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(unsigned int i = 0; i < PGNUM(UTOP); i++)
  801e48:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e4e:	eb d0                	jmp    801e20 <spawn+0x538>
	sys_page_unmap(0, UTEMP);
  801e50:	83 ec 08             	sub    $0x8,%esp
  801e53:	68 00 00 40 00       	push   $0x400000
  801e58:	6a 00                	push   $0x0
  801e5a:	e8 c5 f0 ff ff       	call   800f24 <sys_page_unmap>
  801e5f:	83 c4 10             	add    $0x10,%esp
  801e62:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801e68:	eb b6                	jmp    801e20 <spawn+0x538>

00801e6a <spawnl>:
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	57                   	push   %edi
  801e6e:	56                   	push   %esi
  801e6f:	53                   	push   %ebx
  801e70:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801e73:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801e7b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801e7e:	83 3a 00             	cmpl   $0x0,(%edx)
  801e81:	74 07                	je     801e8a <spawnl+0x20>
		argc++;
  801e83:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801e86:	89 ca                	mov    %ecx,%edx
  801e88:	eb f1                	jmp    801e7b <spawnl+0x11>
	const char *argv[argc+2];
  801e8a:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801e91:	83 e2 f0             	and    $0xfffffff0,%edx
  801e94:	29 d4                	sub    %edx,%esp
  801e96:	8d 54 24 03          	lea    0x3(%esp),%edx
  801e9a:	c1 ea 02             	shr    $0x2,%edx
  801e9d:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801ea4:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801ea6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ea9:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801eb0:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801eb7:	00 
	va_start(vl, arg0);
  801eb8:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801ebb:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801ebd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec2:	eb 0b                	jmp    801ecf <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801ec4:	83 c0 01             	add    $0x1,%eax
  801ec7:	8b 39                	mov    (%ecx),%edi
  801ec9:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801ecc:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801ecf:	39 d0                	cmp    %edx,%eax
  801ed1:	75 f1                	jne    801ec4 <spawnl+0x5a>
	return spawn(prog, argv);
  801ed3:	83 ec 08             	sub    $0x8,%esp
  801ed6:	56                   	push   %esi
  801ed7:	ff 75 08             	pushl  0x8(%ebp)
  801eda:	e8 09 fa ff ff       	call   8018e8 <spawn>
}
  801edf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee2:	5b                   	pop    %ebx
  801ee3:	5e                   	pop    %esi
  801ee4:	5f                   	pop    %edi
  801ee5:	5d                   	pop    %ebp
  801ee6:	c3                   	ret    

00801ee7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	56                   	push   %esi
  801eeb:	53                   	push   %ebx
  801eec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801eef:	83 ec 0c             	sub    $0xc,%esp
  801ef2:	ff 75 08             	pushl  0x8(%ebp)
  801ef5:	e8 c5 f1 ff ff       	call   8010bf <fd2data>
  801efa:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801efc:	83 c4 08             	add    $0x8,%esp
  801eff:	68 fe 30 80 00       	push   $0x8030fe
  801f04:	53                   	push   %ebx
  801f05:	e8 a3 eb ff ff       	call   800aad <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f0a:	8b 46 04             	mov    0x4(%esi),%eax
  801f0d:	2b 06                	sub    (%esi),%eax
  801f0f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f15:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f1c:	00 00 00 
	stat->st_dev = &devpipe;
  801f1f:	c7 83 88 00 00 00 ac 	movl   $0x8057ac,0x88(%ebx)
  801f26:	57 80 00 
	return 0;
}
  801f29:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f31:	5b                   	pop    %ebx
  801f32:	5e                   	pop    %esi
  801f33:	5d                   	pop    %ebp
  801f34:	c3                   	ret    

00801f35 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	53                   	push   %ebx
  801f39:	83 ec 0c             	sub    $0xc,%esp
  801f3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f3f:	53                   	push   %ebx
  801f40:	6a 00                	push   $0x0
  801f42:	e8 dd ef ff ff       	call   800f24 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f47:	89 1c 24             	mov    %ebx,(%esp)
  801f4a:	e8 70 f1 ff ff       	call   8010bf <fd2data>
  801f4f:	83 c4 08             	add    $0x8,%esp
  801f52:	50                   	push   %eax
  801f53:	6a 00                	push   $0x0
  801f55:	e8 ca ef ff ff       	call   800f24 <sys_page_unmap>
}
  801f5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <_pipeisclosed>:
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	57                   	push   %edi
  801f63:	56                   	push   %esi
  801f64:	53                   	push   %ebx
  801f65:	83 ec 1c             	sub    $0x1c,%esp
  801f68:	89 c7                	mov    %eax,%edi
  801f6a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f6c:	a1 90 77 80 00       	mov    0x807790,%eax
  801f71:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f74:	83 ec 0c             	sub    $0xc,%esp
  801f77:	57                   	push   %edi
  801f78:	e8 86 08 00 00       	call   802803 <pageref>
  801f7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f80:	89 34 24             	mov    %esi,(%esp)
  801f83:	e8 7b 08 00 00       	call   802803 <pageref>
		nn = thisenv->env_runs;
  801f88:	8b 15 90 77 80 00    	mov    0x807790,%edx
  801f8e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f91:	83 c4 10             	add    $0x10,%esp
  801f94:	39 cb                	cmp    %ecx,%ebx
  801f96:	74 1b                	je     801fb3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f98:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f9b:	75 cf                	jne    801f6c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f9d:	8b 42 58             	mov    0x58(%edx),%eax
  801fa0:	6a 01                	push   $0x1
  801fa2:	50                   	push   %eax
  801fa3:	53                   	push   %ebx
  801fa4:	68 05 31 80 00       	push   $0x803105
  801fa9:	e8 23 e5 ff ff       	call   8004d1 <cprintf>
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	eb b9                	jmp    801f6c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801fb3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fb6:	0f 94 c0             	sete   %al
  801fb9:	0f b6 c0             	movzbl %al,%eax
}
  801fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fbf:	5b                   	pop    %ebx
  801fc0:	5e                   	pop    %esi
  801fc1:	5f                   	pop    %edi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    

00801fc4 <devpipe_write>:
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	57                   	push   %edi
  801fc8:	56                   	push   %esi
  801fc9:	53                   	push   %ebx
  801fca:	83 ec 28             	sub    $0x28,%esp
  801fcd:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801fd0:	56                   	push   %esi
  801fd1:	e8 e9 f0 ff ff       	call   8010bf <fd2data>
  801fd6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fe3:	74 4f                	je     802034 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fe5:	8b 43 04             	mov    0x4(%ebx),%eax
  801fe8:	8b 0b                	mov    (%ebx),%ecx
  801fea:	8d 51 20             	lea    0x20(%ecx),%edx
  801fed:	39 d0                	cmp    %edx,%eax
  801fef:	72 14                	jb     802005 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ff1:	89 da                	mov    %ebx,%edx
  801ff3:	89 f0                	mov    %esi,%eax
  801ff5:	e8 65 ff ff ff       	call   801f5f <_pipeisclosed>
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	75 3b                	jne    802039 <devpipe_write+0x75>
			sys_yield();
  801ffe:	e8 7d ee ff ff       	call   800e80 <sys_yield>
  802003:	eb e0                	jmp    801fe5 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802008:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80200c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80200f:	89 c2                	mov    %eax,%edx
  802011:	c1 fa 1f             	sar    $0x1f,%edx
  802014:	89 d1                	mov    %edx,%ecx
  802016:	c1 e9 1b             	shr    $0x1b,%ecx
  802019:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80201c:	83 e2 1f             	and    $0x1f,%edx
  80201f:	29 ca                	sub    %ecx,%edx
  802021:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802025:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802029:	83 c0 01             	add    $0x1,%eax
  80202c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80202f:	83 c7 01             	add    $0x1,%edi
  802032:	eb ac                	jmp    801fe0 <devpipe_write+0x1c>
	return i;
  802034:	8b 45 10             	mov    0x10(%ebp),%eax
  802037:	eb 05                	jmp    80203e <devpipe_write+0x7a>
				return 0;
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802041:	5b                   	pop    %ebx
  802042:	5e                   	pop    %esi
  802043:	5f                   	pop    %edi
  802044:	5d                   	pop    %ebp
  802045:	c3                   	ret    

00802046 <devpipe_read>:
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	57                   	push   %edi
  80204a:	56                   	push   %esi
  80204b:	53                   	push   %ebx
  80204c:	83 ec 18             	sub    $0x18,%esp
  80204f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802052:	57                   	push   %edi
  802053:	e8 67 f0 ff ff       	call   8010bf <fd2data>
  802058:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80205a:	83 c4 10             	add    $0x10,%esp
  80205d:	be 00 00 00 00       	mov    $0x0,%esi
  802062:	3b 75 10             	cmp    0x10(%ebp),%esi
  802065:	75 14                	jne    80207b <devpipe_read+0x35>
	return i;
  802067:	8b 45 10             	mov    0x10(%ebp),%eax
  80206a:	eb 02                	jmp    80206e <devpipe_read+0x28>
				return i;
  80206c:	89 f0                	mov    %esi,%eax
}
  80206e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802071:	5b                   	pop    %ebx
  802072:	5e                   	pop    %esi
  802073:	5f                   	pop    %edi
  802074:	5d                   	pop    %ebp
  802075:	c3                   	ret    
			sys_yield();
  802076:	e8 05 ee ff ff       	call   800e80 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80207b:	8b 03                	mov    (%ebx),%eax
  80207d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802080:	75 18                	jne    80209a <devpipe_read+0x54>
			if (i > 0)
  802082:	85 f6                	test   %esi,%esi
  802084:	75 e6                	jne    80206c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802086:	89 da                	mov    %ebx,%edx
  802088:	89 f8                	mov    %edi,%eax
  80208a:	e8 d0 fe ff ff       	call   801f5f <_pipeisclosed>
  80208f:	85 c0                	test   %eax,%eax
  802091:	74 e3                	je     802076 <devpipe_read+0x30>
				return 0;
  802093:	b8 00 00 00 00       	mov    $0x0,%eax
  802098:	eb d4                	jmp    80206e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80209a:	99                   	cltd   
  80209b:	c1 ea 1b             	shr    $0x1b,%edx
  80209e:	01 d0                	add    %edx,%eax
  8020a0:	83 e0 1f             	and    $0x1f,%eax
  8020a3:	29 d0                	sub    %edx,%eax
  8020a5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020ad:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020b0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8020b3:	83 c6 01             	add    $0x1,%esi
  8020b6:	eb aa                	jmp    802062 <devpipe_read+0x1c>

008020b8 <pipe>:
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	56                   	push   %esi
  8020bc:	53                   	push   %ebx
  8020bd:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c3:	50                   	push   %eax
  8020c4:	e8 0d f0 ff ff       	call   8010d6 <fd_alloc>
  8020c9:	89 c3                	mov    %eax,%ebx
  8020cb:	83 c4 10             	add    $0x10,%esp
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	0f 88 23 01 00 00    	js     8021f9 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020d6:	83 ec 04             	sub    $0x4,%esp
  8020d9:	68 07 04 00 00       	push   $0x407
  8020de:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e1:	6a 00                	push   $0x0
  8020e3:	e8 b7 ed ff ff       	call   800e9f <sys_page_alloc>
  8020e8:	89 c3                	mov    %eax,%ebx
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	0f 88 04 01 00 00    	js     8021f9 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8020f5:	83 ec 0c             	sub    $0xc,%esp
  8020f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020fb:	50                   	push   %eax
  8020fc:	e8 d5 ef ff ff       	call   8010d6 <fd_alloc>
  802101:	89 c3                	mov    %eax,%ebx
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	85 c0                	test   %eax,%eax
  802108:	0f 88 db 00 00 00    	js     8021e9 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80210e:	83 ec 04             	sub    $0x4,%esp
  802111:	68 07 04 00 00       	push   $0x407
  802116:	ff 75 f0             	pushl  -0x10(%ebp)
  802119:	6a 00                	push   $0x0
  80211b:	e8 7f ed ff ff       	call   800e9f <sys_page_alloc>
  802120:	89 c3                	mov    %eax,%ebx
  802122:	83 c4 10             	add    $0x10,%esp
  802125:	85 c0                	test   %eax,%eax
  802127:	0f 88 bc 00 00 00    	js     8021e9 <pipe+0x131>
	va = fd2data(fd0);
  80212d:	83 ec 0c             	sub    $0xc,%esp
  802130:	ff 75 f4             	pushl  -0xc(%ebp)
  802133:	e8 87 ef ff ff       	call   8010bf <fd2data>
  802138:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80213a:	83 c4 0c             	add    $0xc,%esp
  80213d:	68 07 04 00 00       	push   $0x407
  802142:	50                   	push   %eax
  802143:	6a 00                	push   $0x0
  802145:	e8 55 ed ff ff       	call   800e9f <sys_page_alloc>
  80214a:	89 c3                	mov    %eax,%ebx
  80214c:	83 c4 10             	add    $0x10,%esp
  80214f:	85 c0                	test   %eax,%eax
  802151:	0f 88 82 00 00 00    	js     8021d9 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802157:	83 ec 0c             	sub    $0xc,%esp
  80215a:	ff 75 f0             	pushl  -0x10(%ebp)
  80215d:	e8 5d ef ff ff       	call   8010bf <fd2data>
  802162:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802169:	50                   	push   %eax
  80216a:	6a 00                	push   $0x0
  80216c:	56                   	push   %esi
  80216d:	6a 00                	push   $0x0
  80216f:	e8 6e ed ff ff       	call   800ee2 <sys_page_map>
  802174:	89 c3                	mov    %eax,%ebx
  802176:	83 c4 20             	add    $0x20,%esp
  802179:	85 c0                	test   %eax,%eax
  80217b:	78 4e                	js     8021cb <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80217d:	a1 ac 57 80 00       	mov    0x8057ac,%eax
  802182:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802185:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802187:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802191:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802194:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802199:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8021a0:	83 ec 0c             	sub    $0xc,%esp
  8021a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a6:	e8 04 ef ff ff       	call   8010af <fd2num>
  8021ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021ae:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021b0:	83 c4 04             	add    $0x4,%esp
  8021b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8021b6:	e8 f4 ee ff ff       	call   8010af <fd2num>
  8021bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021be:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021c1:	83 c4 10             	add    $0x10,%esp
  8021c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021c9:	eb 2e                	jmp    8021f9 <pipe+0x141>
	sys_page_unmap(0, va);
  8021cb:	83 ec 08             	sub    $0x8,%esp
  8021ce:	56                   	push   %esi
  8021cf:	6a 00                	push   $0x0
  8021d1:	e8 4e ed ff ff       	call   800f24 <sys_page_unmap>
  8021d6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021d9:	83 ec 08             	sub    $0x8,%esp
  8021dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8021df:	6a 00                	push   $0x0
  8021e1:	e8 3e ed ff ff       	call   800f24 <sys_page_unmap>
  8021e6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8021e9:	83 ec 08             	sub    $0x8,%esp
  8021ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ef:	6a 00                	push   $0x0
  8021f1:	e8 2e ed ff ff       	call   800f24 <sys_page_unmap>
  8021f6:	83 c4 10             	add    $0x10,%esp
}
  8021f9:	89 d8                	mov    %ebx,%eax
  8021fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021fe:	5b                   	pop    %ebx
  8021ff:	5e                   	pop    %esi
  802200:	5d                   	pop    %ebp
  802201:	c3                   	ret    

00802202 <pipeisclosed>:
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802208:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80220b:	50                   	push   %eax
  80220c:	ff 75 08             	pushl  0x8(%ebp)
  80220f:	e8 14 ef ff ff       	call   801128 <fd_lookup>
  802214:	83 c4 10             	add    $0x10,%esp
  802217:	85 c0                	test   %eax,%eax
  802219:	78 18                	js     802233 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80221b:	83 ec 0c             	sub    $0xc,%esp
  80221e:	ff 75 f4             	pushl  -0xc(%ebp)
  802221:	e8 99 ee ff ff       	call   8010bf <fd2data>
	return _pipeisclosed(fd, p);
  802226:	89 c2                	mov    %eax,%edx
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	e8 2f fd ff ff       	call   801f5f <_pipeisclosed>
  802230:	83 c4 10             	add    $0x10,%esp
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	56                   	push   %esi
  802239:	53                   	push   %ebx
  80223a:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80223d:	85 f6                	test   %esi,%esi
  80223f:	74 13                	je     802254 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802241:	89 f3                	mov    %esi,%ebx
  802243:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802249:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80224c:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802252:	eb 1b                	jmp    80226f <wait+0x3a>
	assert(envid != 0);
  802254:	68 1d 31 80 00       	push   $0x80311d
  802259:	68 e8 2f 80 00       	push   $0x802fe8
  80225e:	6a 09                	push   $0x9
  802260:	68 28 31 80 00       	push   $0x803128
  802265:	e8 8c e1 ff ff       	call   8003f6 <_panic>
		sys_yield();
  80226a:	e8 11 ec ff ff       	call   800e80 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80226f:	8b 43 48             	mov    0x48(%ebx),%eax
  802272:	39 f0                	cmp    %esi,%eax
  802274:	75 07                	jne    80227d <wait+0x48>
  802276:	8b 43 54             	mov    0x54(%ebx),%eax
  802279:	85 c0                	test   %eax,%eax
  80227b:	75 ed                	jne    80226a <wait+0x35>
}
  80227d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802280:	5b                   	pop    %ebx
  802281:	5e                   	pop    %esi
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    

00802284 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
  802287:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80228a:	68 33 31 80 00       	push   $0x803133
  80228f:	ff 75 0c             	pushl  0xc(%ebp)
  802292:	e8 16 e8 ff ff       	call   800aad <strcpy>
	return 0;
}
  802297:	b8 00 00 00 00       	mov    $0x0,%eax
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <devsock_close>:
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	53                   	push   %ebx
  8022a2:	83 ec 10             	sub    $0x10,%esp
  8022a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8022a8:	53                   	push   %ebx
  8022a9:	e8 55 05 00 00       	call   802803 <pageref>
  8022ae:	83 c4 10             	add    $0x10,%esp
		return 0;
  8022b1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8022b6:	83 f8 01             	cmp    $0x1,%eax
  8022b9:	74 07                	je     8022c2 <devsock_close+0x24>
}
  8022bb:	89 d0                	mov    %edx,%eax
  8022bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8022c2:	83 ec 0c             	sub    $0xc,%esp
  8022c5:	ff 73 0c             	pushl  0xc(%ebx)
  8022c8:	e8 b9 02 00 00       	call   802586 <nsipc_close>
  8022cd:	89 c2                	mov    %eax,%edx
  8022cf:	83 c4 10             	add    $0x10,%esp
  8022d2:	eb e7                	jmp    8022bb <devsock_close+0x1d>

008022d4 <devsock_write>:
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8022da:	6a 00                	push   $0x0
  8022dc:	ff 75 10             	pushl  0x10(%ebp)
  8022df:	ff 75 0c             	pushl  0xc(%ebp)
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	ff 70 0c             	pushl  0xc(%eax)
  8022e8:	e8 76 03 00 00       	call   802663 <nsipc_send>
}
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    

008022ef <devsock_read>:
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
  8022f2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8022f5:	6a 00                	push   $0x0
  8022f7:	ff 75 10             	pushl  0x10(%ebp)
  8022fa:	ff 75 0c             	pushl  0xc(%ebp)
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	ff 70 0c             	pushl  0xc(%eax)
  802303:	e8 ef 02 00 00       	call   8025f7 <nsipc_recv>
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <fd2sockid>:
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
  80230d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802310:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802313:	52                   	push   %edx
  802314:	50                   	push   %eax
  802315:	e8 0e ee ff ff       	call   801128 <fd_lookup>
  80231a:	83 c4 10             	add    $0x10,%esp
  80231d:	85 c0                	test   %eax,%eax
  80231f:	78 10                	js     802331 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 0d c8 57 80 00    	mov    0x8057c8,%ecx
  80232a:	39 08                	cmp    %ecx,(%eax)
  80232c:	75 05                	jne    802333 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80232e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    
		return -E_NOT_SUPP;
  802333:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802338:	eb f7                	jmp    802331 <fd2sockid+0x27>

0080233a <alloc_sockfd>:
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
  80233d:	56                   	push   %esi
  80233e:	53                   	push   %ebx
  80233f:	83 ec 1c             	sub    $0x1c,%esp
  802342:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802344:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802347:	50                   	push   %eax
  802348:	e8 89 ed ff ff       	call   8010d6 <fd_alloc>
  80234d:	89 c3                	mov    %eax,%ebx
  80234f:	83 c4 10             	add    $0x10,%esp
  802352:	85 c0                	test   %eax,%eax
  802354:	78 43                	js     802399 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802356:	83 ec 04             	sub    $0x4,%esp
  802359:	68 07 04 00 00       	push   $0x407
  80235e:	ff 75 f4             	pushl  -0xc(%ebp)
  802361:	6a 00                	push   $0x0
  802363:	e8 37 eb ff ff       	call   800e9f <sys_page_alloc>
  802368:	89 c3                	mov    %eax,%ebx
  80236a:	83 c4 10             	add    $0x10,%esp
  80236d:	85 c0                	test   %eax,%eax
  80236f:	78 28                	js     802399 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 15 c8 57 80 00    	mov    0x8057c8,%edx
  80237a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802386:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802389:	83 ec 0c             	sub    $0xc,%esp
  80238c:	50                   	push   %eax
  80238d:	e8 1d ed ff ff       	call   8010af <fd2num>
  802392:	89 c3                	mov    %eax,%ebx
  802394:	83 c4 10             	add    $0x10,%esp
  802397:	eb 0c                	jmp    8023a5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802399:	83 ec 0c             	sub    $0xc,%esp
  80239c:	56                   	push   %esi
  80239d:	e8 e4 01 00 00       	call   802586 <nsipc_close>
		return r;
  8023a2:	83 c4 10             	add    $0x10,%esp
}
  8023a5:	89 d8                	mov    %ebx,%eax
  8023a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023aa:	5b                   	pop    %ebx
  8023ab:	5e                   	pop    %esi
  8023ac:	5d                   	pop    %ebp
  8023ad:	c3                   	ret    

008023ae <accept>:
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
  8023b1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	e8 4e ff ff ff       	call   80230a <fd2sockid>
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	78 1b                	js     8023db <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8023c0:	83 ec 04             	sub    $0x4,%esp
  8023c3:	ff 75 10             	pushl  0x10(%ebp)
  8023c6:	ff 75 0c             	pushl  0xc(%ebp)
  8023c9:	50                   	push   %eax
  8023ca:	e8 0e 01 00 00       	call   8024dd <nsipc_accept>
  8023cf:	83 c4 10             	add    $0x10,%esp
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	78 05                	js     8023db <accept+0x2d>
	return alloc_sockfd(r);
  8023d6:	e8 5f ff ff ff       	call   80233a <alloc_sockfd>
}
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    

008023dd <bind>:
{
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
  8023e0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	e8 1f ff ff ff       	call   80230a <fd2sockid>
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	78 12                	js     802401 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8023ef:	83 ec 04             	sub    $0x4,%esp
  8023f2:	ff 75 10             	pushl  0x10(%ebp)
  8023f5:	ff 75 0c             	pushl  0xc(%ebp)
  8023f8:	50                   	push   %eax
  8023f9:	e8 31 01 00 00       	call   80252f <nsipc_bind>
  8023fe:	83 c4 10             	add    $0x10,%esp
}
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <shutdown>:
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	e8 f9 fe ff ff       	call   80230a <fd2sockid>
  802411:	85 c0                	test   %eax,%eax
  802413:	78 0f                	js     802424 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802415:	83 ec 08             	sub    $0x8,%esp
  802418:	ff 75 0c             	pushl  0xc(%ebp)
  80241b:	50                   	push   %eax
  80241c:	e8 43 01 00 00       	call   802564 <nsipc_shutdown>
  802421:	83 c4 10             	add    $0x10,%esp
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <connect>:
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
  802429:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80242c:	8b 45 08             	mov    0x8(%ebp),%eax
  80242f:	e8 d6 fe ff ff       	call   80230a <fd2sockid>
  802434:	85 c0                	test   %eax,%eax
  802436:	78 12                	js     80244a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802438:	83 ec 04             	sub    $0x4,%esp
  80243b:	ff 75 10             	pushl  0x10(%ebp)
  80243e:	ff 75 0c             	pushl  0xc(%ebp)
  802441:	50                   	push   %eax
  802442:	e8 59 01 00 00       	call   8025a0 <nsipc_connect>
  802447:	83 c4 10             	add    $0x10,%esp
}
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <listen>:
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
  80244f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	e8 b0 fe ff ff       	call   80230a <fd2sockid>
  80245a:	85 c0                	test   %eax,%eax
  80245c:	78 0f                	js     80246d <listen+0x21>
	return nsipc_listen(r, backlog);
  80245e:	83 ec 08             	sub    $0x8,%esp
  802461:	ff 75 0c             	pushl  0xc(%ebp)
  802464:	50                   	push   %eax
  802465:	e8 6b 01 00 00       	call   8025d5 <nsipc_listen>
  80246a:	83 c4 10             	add    $0x10,%esp
}
  80246d:	c9                   	leave  
  80246e:	c3                   	ret    

0080246f <socket>:

int
socket(int domain, int type, int protocol)
{
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
  802472:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802475:	ff 75 10             	pushl  0x10(%ebp)
  802478:	ff 75 0c             	pushl  0xc(%ebp)
  80247b:	ff 75 08             	pushl  0x8(%ebp)
  80247e:	e8 3e 02 00 00       	call   8026c1 <nsipc_socket>
  802483:	83 c4 10             	add    $0x10,%esp
  802486:	85 c0                	test   %eax,%eax
  802488:	78 05                	js     80248f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80248a:	e8 ab fe ff ff       	call   80233a <alloc_sockfd>
}
  80248f:	c9                   	leave  
  802490:	c3                   	ret    

00802491 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	53                   	push   %ebx
  802495:	83 ec 04             	sub    $0x4,%esp
  802498:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80249a:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  8024a1:	74 26                	je     8024c9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8024a3:	6a 07                	push   $0x7
  8024a5:	68 00 90 80 00       	push   $0x809000
  8024aa:	53                   	push   %ebx
  8024ab:	ff 35 04 60 80 00    	pushl  0x806004
  8024b1:	e8 a8 02 00 00       	call   80275e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8024b6:	83 c4 0c             	add    $0xc,%esp
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	e8 27 02 00 00       	call   8026eb <ipc_recv>
}
  8024c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8024c9:	83 ec 0c             	sub    $0xc,%esp
  8024cc:	6a 02                	push   $0x2
  8024ce:	e8 f7 02 00 00       	call   8027ca <ipc_find_env>
  8024d3:	a3 04 60 80 00       	mov    %eax,0x806004
  8024d8:	83 c4 10             	add    $0x10,%esp
  8024db:	eb c6                	jmp    8024a3 <nsipc+0x12>

008024dd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	56                   	push   %esi
  8024e1:	53                   	push   %ebx
  8024e2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8024ed:	8b 06                	mov    (%esi),%eax
  8024ef:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8024f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f9:	e8 93 ff ff ff       	call   802491 <nsipc>
  8024fe:	89 c3                	mov    %eax,%ebx
  802500:	85 c0                	test   %eax,%eax
  802502:	79 09                	jns    80250d <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802504:	89 d8                	mov    %ebx,%eax
  802506:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802509:	5b                   	pop    %ebx
  80250a:	5e                   	pop    %esi
  80250b:	5d                   	pop    %ebp
  80250c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80250d:	83 ec 04             	sub    $0x4,%esp
  802510:	ff 35 10 90 80 00    	pushl  0x809010
  802516:	68 00 90 80 00       	push   $0x809000
  80251b:	ff 75 0c             	pushl  0xc(%ebp)
  80251e:	e8 18 e7 ff ff       	call   800c3b <memmove>
		*addrlen = ret->ret_addrlen;
  802523:	a1 10 90 80 00       	mov    0x809010,%eax
  802528:	89 06                	mov    %eax,(%esi)
  80252a:	83 c4 10             	add    $0x10,%esp
	return r;
  80252d:	eb d5                	jmp    802504 <nsipc_accept+0x27>

0080252f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
  802532:	53                   	push   %ebx
  802533:	83 ec 08             	sub    $0x8,%esp
  802536:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802539:	8b 45 08             	mov    0x8(%ebp),%eax
  80253c:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802541:	53                   	push   %ebx
  802542:	ff 75 0c             	pushl  0xc(%ebp)
  802545:	68 04 90 80 00       	push   $0x809004
  80254a:	e8 ec e6 ff ff       	call   800c3b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80254f:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  802555:	b8 02 00 00 00       	mov    $0x2,%eax
  80255a:	e8 32 ff ff ff       	call   802491 <nsipc>
}
  80255f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80256a:	8b 45 08             	mov    0x8(%ebp),%eax
  80256d:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  802572:	8b 45 0c             	mov    0xc(%ebp),%eax
  802575:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  80257a:	b8 03 00 00 00       	mov    $0x3,%eax
  80257f:	e8 0d ff ff ff       	call   802491 <nsipc>
}
  802584:	c9                   	leave  
  802585:	c3                   	ret    

00802586 <nsipc_close>:

int
nsipc_close(int s)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
  802589:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  802594:	b8 04 00 00 00       	mov    $0x4,%eax
  802599:	e8 f3 fe ff ff       	call   802491 <nsipc>
}
  80259e:	c9                   	leave  
  80259f:	c3                   	ret    

008025a0 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
  8025a3:	53                   	push   %ebx
  8025a4:	83 ec 08             	sub    $0x8,%esp
  8025a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ad:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8025b2:	53                   	push   %ebx
  8025b3:	ff 75 0c             	pushl  0xc(%ebp)
  8025b6:	68 04 90 80 00       	push   $0x809004
  8025bb:	e8 7b e6 ff ff       	call   800c3b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8025c0:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  8025c6:	b8 05 00 00 00       	mov    $0x5,%eax
  8025cb:	e8 c1 fe ff ff       	call   802491 <nsipc>
}
  8025d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025d3:	c9                   	leave  
  8025d4:	c3                   	ret    

008025d5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8025d5:	55                   	push   %ebp
  8025d6:	89 e5                	mov    %esp,%ebp
  8025d8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8025db:	8b 45 08             	mov    0x8(%ebp),%eax
  8025de:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  8025e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e6:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  8025eb:	b8 06 00 00 00       	mov    $0x6,%eax
  8025f0:	e8 9c fe ff ff       	call   802491 <nsipc>
}
  8025f5:	c9                   	leave  
  8025f6:	c3                   	ret    

008025f7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
  8025fa:	56                   	push   %esi
  8025fb:	53                   	push   %ebx
  8025fc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8025ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802602:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  802607:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  80260d:	8b 45 14             	mov    0x14(%ebp),%eax
  802610:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802615:	b8 07 00 00 00       	mov    $0x7,%eax
  80261a:	e8 72 fe ff ff       	call   802491 <nsipc>
  80261f:	89 c3                	mov    %eax,%ebx
  802621:	85 c0                	test   %eax,%eax
  802623:	78 1f                	js     802644 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802625:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80262a:	7f 21                	jg     80264d <nsipc_recv+0x56>
  80262c:	39 c6                	cmp    %eax,%esi
  80262e:	7c 1d                	jl     80264d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802630:	83 ec 04             	sub    $0x4,%esp
  802633:	50                   	push   %eax
  802634:	68 00 90 80 00       	push   $0x809000
  802639:	ff 75 0c             	pushl  0xc(%ebp)
  80263c:	e8 fa e5 ff ff       	call   800c3b <memmove>
  802641:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802644:	89 d8                	mov    %ebx,%eax
  802646:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802649:	5b                   	pop    %ebx
  80264a:	5e                   	pop    %esi
  80264b:	5d                   	pop    %ebp
  80264c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80264d:	68 3f 31 80 00       	push   $0x80313f
  802652:	68 e8 2f 80 00       	push   $0x802fe8
  802657:	6a 62                	push   $0x62
  802659:	68 54 31 80 00       	push   $0x803154
  80265e:	e8 93 dd ff ff       	call   8003f6 <_panic>

00802663 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	53                   	push   %ebx
  802667:	83 ec 04             	sub    $0x4,%esp
  80266a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80266d:	8b 45 08             	mov    0x8(%ebp),%eax
  802670:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  802675:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80267b:	7f 2e                	jg     8026ab <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80267d:	83 ec 04             	sub    $0x4,%esp
  802680:	53                   	push   %ebx
  802681:	ff 75 0c             	pushl  0xc(%ebp)
  802684:	68 0c 90 80 00       	push   $0x80900c
  802689:	e8 ad e5 ff ff       	call   800c3b <memmove>
	nsipcbuf.send.req_size = size;
  80268e:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  802694:	8b 45 14             	mov    0x14(%ebp),%eax
  802697:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  80269c:	b8 08 00 00 00       	mov    $0x8,%eax
  8026a1:	e8 eb fd ff ff       	call   802491 <nsipc>
}
  8026a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026a9:	c9                   	leave  
  8026aa:	c3                   	ret    
	assert(size < 1600);
  8026ab:	68 60 31 80 00       	push   $0x803160
  8026b0:	68 e8 2f 80 00       	push   $0x802fe8
  8026b5:	6a 6d                	push   $0x6d
  8026b7:	68 54 31 80 00       	push   $0x803154
  8026bc:	e8 35 dd ff ff       	call   8003f6 <_panic>

008026c1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8026c1:	55                   	push   %ebp
  8026c2:	89 e5                	mov    %esp,%ebp
  8026c4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  8026cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026d2:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  8026d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8026da:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  8026df:	b8 09 00 00 00       	mov    $0x9,%eax
  8026e4:	e8 a8 fd ff ff       	call   802491 <nsipc>
}
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    

008026eb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
  8026ee:	56                   	push   %esi
  8026ef:	53                   	push   %ebx
  8026f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8026f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8026f9:	85 c0                	test   %eax,%eax
  8026fb:	74 4f                	je     80274c <ipc_recv+0x61>
  8026fd:	83 ec 0c             	sub    $0xc,%esp
  802700:	50                   	push   %eax
  802701:	e8 49 e9 ff ff       	call   80104f <sys_ipc_recv>
  802706:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  802709:	85 f6                	test   %esi,%esi
  80270b:	74 14                	je     802721 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  80270d:	ba 00 00 00 00       	mov    $0x0,%edx
  802712:	85 c0                	test   %eax,%eax
  802714:	75 09                	jne    80271f <ipc_recv+0x34>
  802716:	8b 15 90 77 80 00    	mov    0x807790,%edx
  80271c:	8b 52 74             	mov    0x74(%edx),%edx
  80271f:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  802721:	85 db                	test   %ebx,%ebx
  802723:	74 14                	je     802739 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  802725:	ba 00 00 00 00       	mov    $0x0,%edx
  80272a:	85 c0                	test   %eax,%eax
  80272c:	75 09                	jne    802737 <ipc_recv+0x4c>
  80272e:	8b 15 90 77 80 00    	mov    0x807790,%edx
  802734:	8b 52 78             	mov    0x78(%edx),%edx
  802737:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  802739:	85 c0                	test   %eax,%eax
  80273b:	75 08                	jne    802745 <ipc_recv+0x5a>
  80273d:	a1 90 77 80 00       	mov    0x807790,%eax
  802742:	8b 40 70             	mov    0x70(%eax),%eax
}
  802745:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802748:	5b                   	pop    %ebx
  802749:	5e                   	pop    %esi
  80274a:	5d                   	pop    %ebp
  80274b:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  80274c:	83 ec 0c             	sub    $0xc,%esp
  80274f:	68 00 00 c0 ee       	push   $0xeec00000
  802754:	e8 f6 e8 ff ff       	call   80104f <sys_ipc_recv>
  802759:	83 c4 10             	add    $0x10,%esp
  80275c:	eb ab                	jmp    802709 <ipc_recv+0x1e>

0080275e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
  802761:	57                   	push   %edi
  802762:	56                   	push   %esi
  802763:	53                   	push   %ebx
  802764:	83 ec 0c             	sub    $0xc,%esp
  802767:	8b 7d 08             	mov    0x8(%ebp),%edi
  80276a:	8b 75 10             	mov    0x10(%ebp),%esi
  80276d:	eb 20                	jmp    80278f <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80276f:	6a 00                	push   $0x0
  802771:	68 00 00 c0 ee       	push   $0xeec00000
  802776:	ff 75 0c             	pushl  0xc(%ebp)
  802779:	57                   	push   %edi
  80277a:	e8 ad e8 ff ff       	call   80102c <sys_ipc_try_send>
  80277f:	89 c3                	mov    %eax,%ebx
  802781:	83 c4 10             	add    $0x10,%esp
  802784:	eb 1f                	jmp    8027a5 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802786:	e8 f5 e6 ff ff       	call   800e80 <sys_yield>
	while(retval != 0) {
  80278b:	85 db                	test   %ebx,%ebx
  80278d:	74 33                	je     8027c2 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80278f:	85 f6                	test   %esi,%esi
  802791:	74 dc                	je     80276f <ipc_send+0x11>
  802793:	ff 75 14             	pushl  0x14(%ebp)
  802796:	56                   	push   %esi
  802797:	ff 75 0c             	pushl  0xc(%ebp)
  80279a:	57                   	push   %edi
  80279b:	e8 8c e8 ff ff       	call   80102c <sys_ipc_try_send>
  8027a0:	89 c3                	mov    %eax,%ebx
  8027a2:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  8027a5:	83 fb f9             	cmp    $0xfffffff9,%ebx
  8027a8:	74 dc                	je     802786 <ipc_send+0x28>
  8027aa:	85 db                	test   %ebx,%ebx
  8027ac:	74 d8                	je     802786 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  8027ae:	83 ec 04             	sub    $0x4,%esp
  8027b1:	68 6c 31 80 00       	push   $0x80316c
  8027b6:	6a 35                	push   $0x35
  8027b8:	68 9c 31 80 00       	push   $0x80319c
  8027bd:	e8 34 dc ff ff       	call   8003f6 <_panic>
	}
}
  8027c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027c5:	5b                   	pop    %ebx
  8027c6:	5e                   	pop    %esi
  8027c7:	5f                   	pop    %edi
  8027c8:	5d                   	pop    %ebp
  8027c9:	c3                   	ret    

008027ca <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8027ca:	55                   	push   %ebp
  8027cb:	89 e5                	mov    %esp,%ebp
  8027cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8027d0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8027d5:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8027d8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8027de:	8b 52 50             	mov    0x50(%edx),%edx
  8027e1:	39 ca                	cmp    %ecx,%edx
  8027e3:	74 11                	je     8027f6 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8027e5:	83 c0 01             	add    $0x1,%eax
  8027e8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027ed:	75 e6                	jne    8027d5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8027ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f4:	eb 0b                	jmp    802801 <ipc_find_env+0x37>
			return envs[i].env_id;
  8027f6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8027f9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8027fe:	8b 40 48             	mov    0x48(%eax),%eax
}
  802801:	5d                   	pop    %ebp
  802802:	c3                   	ret    

00802803 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802803:	55                   	push   %ebp
  802804:	89 e5                	mov    %esp,%ebp
  802806:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802809:	89 d0                	mov    %edx,%eax
  80280b:	c1 e8 16             	shr    $0x16,%eax
  80280e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802815:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80281a:	f6 c1 01             	test   $0x1,%cl
  80281d:	74 1d                	je     80283c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80281f:	c1 ea 0c             	shr    $0xc,%edx
  802822:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802829:	f6 c2 01             	test   $0x1,%dl
  80282c:	74 0e                	je     80283c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80282e:	c1 ea 0c             	shr    $0xc,%edx
  802831:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802838:	ef 
  802839:	0f b7 c0             	movzwl %ax,%eax
}
  80283c:	5d                   	pop    %ebp
  80283d:	c3                   	ret    
  80283e:	66 90                	xchg   %ax,%ax

00802840 <__udivdi3>:
  802840:	f3 0f 1e fb          	endbr32 
  802844:	55                   	push   %ebp
  802845:	57                   	push   %edi
  802846:	56                   	push   %esi
  802847:	53                   	push   %ebx
  802848:	83 ec 1c             	sub    $0x1c,%esp
  80284b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80284f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802853:	8b 74 24 34          	mov    0x34(%esp),%esi
  802857:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80285b:	85 d2                	test   %edx,%edx
  80285d:	75 49                	jne    8028a8 <__udivdi3+0x68>
  80285f:	39 f3                	cmp    %esi,%ebx
  802861:	76 15                	jbe    802878 <__udivdi3+0x38>
  802863:	31 ff                	xor    %edi,%edi
  802865:	89 e8                	mov    %ebp,%eax
  802867:	89 f2                	mov    %esi,%edx
  802869:	f7 f3                	div    %ebx
  80286b:	89 fa                	mov    %edi,%edx
  80286d:	83 c4 1c             	add    $0x1c,%esp
  802870:	5b                   	pop    %ebx
  802871:	5e                   	pop    %esi
  802872:	5f                   	pop    %edi
  802873:	5d                   	pop    %ebp
  802874:	c3                   	ret    
  802875:	8d 76 00             	lea    0x0(%esi),%esi
  802878:	89 d9                	mov    %ebx,%ecx
  80287a:	85 db                	test   %ebx,%ebx
  80287c:	75 0b                	jne    802889 <__udivdi3+0x49>
  80287e:	b8 01 00 00 00       	mov    $0x1,%eax
  802883:	31 d2                	xor    %edx,%edx
  802885:	f7 f3                	div    %ebx
  802887:	89 c1                	mov    %eax,%ecx
  802889:	31 d2                	xor    %edx,%edx
  80288b:	89 f0                	mov    %esi,%eax
  80288d:	f7 f1                	div    %ecx
  80288f:	89 c6                	mov    %eax,%esi
  802891:	89 e8                	mov    %ebp,%eax
  802893:	89 f7                	mov    %esi,%edi
  802895:	f7 f1                	div    %ecx
  802897:	89 fa                	mov    %edi,%edx
  802899:	83 c4 1c             	add    $0x1c,%esp
  80289c:	5b                   	pop    %ebx
  80289d:	5e                   	pop    %esi
  80289e:	5f                   	pop    %edi
  80289f:	5d                   	pop    %ebp
  8028a0:	c3                   	ret    
  8028a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028a8:	39 f2                	cmp    %esi,%edx
  8028aa:	77 1c                	ja     8028c8 <__udivdi3+0x88>
  8028ac:	0f bd fa             	bsr    %edx,%edi
  8028af:	83 f7 1f             	xor    $0x1f,%edi
  8028b2:	75 2c                	jne    8028e0 <__udivdi3+0xa0>
  8028b4:	39 f2                	cmp    %esi,%edx
  8028b6:	72 06                	jb     8028be <__udivdi3+0x7e>
  8028b8:	31 c0                	xor    %eax,%eax
  8028ba:	39 eb                	cmp    %ebp,%ebx
  8028bc:	77 ad                	ja     80286b <__udivdi3+0x2b>
  8028be:	b8 01 00 00 00       	mov    $0x1,%eax
  8028c3:	eb a6                	jmp    80286b <__udivdi3+0x2b>
  8028c5:	8d 76 00             	lea    0x0(%esi),%esi
  8028c8:	31 ff                	xor    %edi,%edi
  8028ca:	31 c0                	xor    %eax,%eax
  8028cc:	89 fa                	mov    %edi,%edx
  8028ce:	83 c4 1c             	add    $0x1c,%esp
  8028d1:	5b                   	pop    %ebx
  8028d2:	5e                   	pop    %esi
  8028d3:	5f                   	pop    %edi
  8028d4:	5d                   	pop    %ebp
  8028d5:	c3                   	ret    
  8028d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028dd:	8d 76 00             	lea    0x0(%esi),%esi
  8028e0:	89 f9                	mov    %edi,%ecx
  8028e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8028e7:	29 f8                	sub    %edi,%eax
  8028e9:	d3 e2                	shl    %cl,%edx
  8028eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028ef:	89 c1                	mov    %eax,%ecx
  8028f1:	89 da                	mov    %ebx,%edx
  8028f3:	d3 ea                	shr    %cl,%edx
  8028f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028f9:	09 d1                	or     %edx,%ecx
  8028fb:	89 f2                	mov    %esi,%edx
  8028fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802901:	89 f9                	mov    %edi,%ecx
  802903:	d3 e3                	shl    %cl,%ebx
  802905:	89 c1                	mov    %eax,%ecx
  802907:	d3 ea                	shr    %cl,%edx
  802909:	89 f9                	mov    %edi,%ecx
  80290b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80290f:	89 eb                	mov    %ebp,%ebx
  802911:	d3 e6                	shl    %cl,%esi
  802913:	89 c1                	mov    %eax,%ecx
  802915:	d3 eb                	shr    %cl,%ebx
  802917:	09 de                	or     %ebx,%esi
  802919:	89 f0                	mov    %esi,%eax
  80291b:	f7 74 24 08          	divl   0x8(%esp)
  80291f:	89 d6                	mov    %edx,%esi
  802921:	89 c3                	mov    %eax,%ebx
  802923:	f7 64 24 0c          	mull   0xc(%esp)
  802927:	39 d6                	cmp    %edx,%esi
  802929:	72 15                	jb     802940 <__udivdi3+0x100>
  80292b:	89 f9                	mov    %edi,%ecx
  80292d:	d3 e5                	shl    %cl,%ebp
  80292f:	39 c5                	cmp    %eax,%ebp
  802931:	73 04                	jae    802937 <__udivdi3+0xf7>
  802933:	39 d6                	cmp    %edx,%esi
  802935:	74 09                	je     802940 <__udivdi3+0x100>
  802937:	89 d8                	mov    %ebx,%eax
  802939:	31 ff                	xor    %edi,%edi
  80293b:	e9 2b ff ff ff       	jmp    80286b <__udivdi3+0x2b>
  802940:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802943:	31 ff                	xor    %edi,%edi
  802945:	e9 21 ff ff ff       	jmp    80286b <__udivdi3+0x2b>
  80294a:	66 90                	xchg   %ax,%ax
  80294c:	66 90                	xchg   %ax,%ax
  80294e:	66 90                	xchg   %ax,%ax

00802950 <__umoddi3>:
  802950:	f3 0f 1e fb          	endbr32 
  802954:	55                   	push   %ebp
  802955:	57                   	push   %edi
  802956:	56                   	push   %esi
  802957:	53                   	push   %ebx
  802958:	83 ec 1c             	sub    $0x1c,%esp
  80295b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80295f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802963:	8b 74 24 30          	mov    0x30(%esp),%esi
  802967:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80296b:	89 da                	mov    %ebx,%edx
  80296d:	85 c0                	test   %eax,%eax
  80296f:	75 3f                	jne    8029b0 <__umoddi3+0x60>
  802971:	39 df                	cmp    %ebx,%edi
  802973:	76 13                	jbe    802988 <__umoddi3+0x38>
  802975:	89 f0                	mov    %esi,%eax
  802977:	f7 f7                	div    %edi
  802979:	89 d0                	mov    %edx,%eax
  80297b:	31 d2                	xor    %edx,%edx
  80297d:	83 c4 1c             	add    $0x1c,%esp
  802980:	5b                   	pop    %ebx
  802981:	5e                   	pop    %esi
  802982:	5f                   	pop    %edi
  802983:	5d                   	pop    %ebp
  802984:	c3                   	ret    
  802985:	8d 76 00             	lea    0x0(%esi),%esi
  802988:	89 fd                	mov    %edi,%ebp
  80298a:	85 ff                	test   %edi,%edi
  80298c:	75 0b                	jne    802999 <__umoddi3+0x49>
  80298e:	b8 01 00 00 00       	mov    $0x1,%eax
  802993:	31 d2                	xor    %edx,%edx
  802995:	f7 f7                	div    %edi
  802997:	89 c5                	mov    %eax,%ebp
  802999:	89 d8                	mov    %ebx,%eax
  80299b:	31 d2                	xor    %edx,%edx
  80299d:	f7 f5                	div    %ebp
  80299f:	89 f0                	mov    %esi,%eax
  8029a1:	f7 f5                	div    %ebp
  8029a3:	89 d0                	mov    %edx,%eax
  8029a5:	eb d4                	jmp    80297b <__umoddi3+0x2b>
  8029a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029ae:	66 90                	xchg   %ax,%ax
  8029b0:	89 f1                	mov    %esi,%ecx
  8029b2:	39 d8                	cmp    %ebx,%eax
  8029b4:	76 0a                	jbe    8029c0 <__umoddi3+0x70>
  8029b6:	89 f0                	mov    %esi,%eax
  8029b8:	83 c4 1c             	add    $0x1c,%esp
  8029bb:	5b                   	pop    %ebx
  8029bc:	5e                   	pop    %esi
  8029bd:	5f                   	pop    %edi
  8029be:	5d                   	pop    %ebp
  8029bf:	c3                   	ret    
  8029c0:	0f bd e8             	bsr    %eax,%ebp
  8029c3:	83 f5 1f             	xor    $0x1f,%ebp
  8029c6:	75 20                	jne    8029e8 <__umoddi3+0x98>
  8029c8:	39 d8                	cmp    %ebx,%eax
  8029ca:	0f 82 b0 00 00 00    	jb     802a80 <__umoddi3+0x130>
  8029d0:	39 f7                	cmp    %esi,%edi
  8029d2:	0f 86 a8 00 00 00    	jbe    802a80 <__umoddi3+0x130>
  8029d8:	89 c8                	mov    %ecx,%eax
  8029da:	83 c4 1c             	add    $0x1c,%esp
  8029dd:	5b                   	pop    %ebx
  8029de:	5e                   	pop    %esi
  8029df:	5f                   	pop    %edi
  8029e0:	5d                   	pop    %ebp
  8029e1:	c3                   	ret    
  8029e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029e8:	89 e9                	mov    %ebp,%ecx
  8029ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8029ef:	29 ea                	sub    %ebp,%edx
  8029f1:	d3 e0                	shl    %cl,%eax
  8029f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029f7:	89 d1                	mov    %edx,%ecx
  8029f9:	89 f8                	mov    %edi,%eax
  8029fb:	d3 e8                	shr    %cl,%eax
  8029fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a01:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a05:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a09:	09 c1                	or     %eax,%ecx
  802a0b:	89 d8                	mov    %ebx,%eax
  802a0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a11:	89 e9                	mov    %ebp,%ecx
  802a13:	d3 e7                	shl    %cl,%edi
  802a15:	89 d1                	mov    %edx,%ecx
  802a17:	d3 e8                	shr    %cl,%eax
  802a19:	89 e9                	mov    %ebp,%ecx
  802a1b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a1f:	d3 e3                	shl    %cl,%ebx
  802a21:	89 c7                	mov    %eax,%edi
  802a23:	89 d1                	mov    %edx,%ecx
  802a25:	89 f0                	mov    %esi,%eax
  802a27:	d3 e8                	shr    %cl,%eax
  802a29:	89 e9                	mov    %ebp,%ecx
  802a2b:	89 fa                	mov    %edi,%edx
  802a2d:	d3 e6                	shl    %cl,%esi
  802a2f:	09 d8                	or     %ebx,%eax
  802a31:	f7 74 24 08          	divl   0x8(%esp)
  802a35:	89 d1                	mov    %edx,%ecx
  802a37:	89 f3                	mov    %esi,%ebx
  802a39:	f7 64 24 0c          	mull   0xc(%esp)
  802a3d:	89 c6                	mov    %eax,%esi
  802a3f:	89 d7                	mov    %edx,%edi
  802a41:	39 d1                	cmp    %edx,%ecx
  802a43:	72 06                	jb     802a4b <__umoddi3+0xfb>
  802a45:	75 10                	jne    802a57 <__umoddi3+0x107>
  802a47:	39 c3                	cmp    %eax,%ebx
  802a49:	73 0c                	jae    802a57 <__umoddi3+0x107>
  802a4b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a4f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a53:	89 d7                	mov    %edx,%edi
  802a55:	89 c6                	mov    %eax,%esi
  802a57:	89 ca                	mov    %ecx,%edx
  802a59:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a5e:	29 f3                	sub    %esi,%ebx
  802a60:	19 fa                	sbb    %edi,%edx
  802a62:	89 d0                	mov    %edx,%eax
  802a64:	d3 e0                	shl    %cl,%eax
  802a66:	89 e9                	mov    %ebp,%ecx
  802a68:	d3 eb                	shr    %cl,%ebx
  802a6a:	d3 ea                	shr    %cl,%edx
  802a6c:	09 d8                	or     %ebx,%eax
  802a6e:	83 c4 1c             	add    $0x1c,%esp
  802a71:	5b                   	pop    %ebx
  802a72:	5e                   	pop    %esi
  802a73:	5f                   	pop    %edi
  802a74:	5d                   	pop    %ebp
  802a75:	c3                   	ret    
  802a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a7d:	8d 76 00             	lea    0x0(%esi),%esi
  802a80:	89 da                	mov    %ebx,%edx
  802a82:	29 fe                	sub    %edi,%esi
  802a84:	19 c2                	sbb    %eax,%edx
  802a86:	89 f1                	mov    %esi,%ecx
  802a88:	89 c8                	mov    %ecx,%eax
  802a8a:	e9 4b ff ff ff       	jmp    8029da <__umoddi3+0x8a>
