
obj/user/sh.debug：     文件格式 elf32-i386


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
  80002c:	e8 d9 09 00 00       	call   800a0a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int t;

	if (s == 0) {
  800042:	85 db                	test   %ebx,%ebx
  800044:	74 39                	je     80007f <_gettoken+0x4c>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  800046:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80004d:	7f 50                	jg     80009f <_gettoken+0x6c>
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
  80004f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	*p2 = 0;
  800055:	8b 45 10             	mov    0x10(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  80005e:	83 ec 08             	sub    $0x8,%esp
  800061:	0f be 03             	movsbl (%ebx),%eax
  800064:	50                   	push   %eax
  800065:	68 bd 38 80 00       	push   $0x8038bd
  80006a:	e8 ab 12 00 00       	call   80131a <strchr>
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	74 3c                	je     8000b2 <_gettoken+0x7f>
		*s++ = 0;
  800076:	83 c3 01             	add    $0x1,%ebx
  800079:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  80007d:	eb df                	jmp    80005e <_gettoken+0x2b>
		return 0;
  80007f:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  800084:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80008b:	7e 3a                	jle    8000c7 <_gettoken+0x94>
			cprintf("GETTOKEN NULL\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 a0 38 80 00       	push   $0x8038a0
  800095:	e8 ab 0a 00 00       	call   800b45 <cprintf>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	eb 28                	jmp    8000c7 <_gettoken+0x94>
		cprintf("GETTOKEN: %s\n", s);
  80009f:	83 ec 08             	sub    $0x8,%esp
  8000a2:	53                   	push   %ebx
  8000a3:	68 af 38 80 00       	push   $0x8038af
  8000a8:	e8 98 0a 00 00       	call   800b45 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	eb 9d                	jmp    80004f <_gettoken+0x1c>
	if (*s == 0) {
  8000b2:	0f b6 03             	movzbl (%ebx),%eax
  8000b5:	84 c0                	test   %al,%al
  8000b7:	75 2a                	jne    8000e3 <_gettoken+0xb0>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000b9:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  8000be:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  8000c5:	7f 0a                	jg     8000d1 <_gettoken+0x9e>
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000c7:	89 f0                	mov    %esi,%eax
  8000c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5e                   	pop    %esi
  8000ce:	5f                   	pop    %edi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
			cprintf("EOL\n");
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	68 c2 38 80 00       	push   $0x8038c2
  8000d9:	e8 67 0a 00 00       	call   800b45 <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	eb e4                	jmp    8000c7 <_gettoken+0x94>
	if (strchr(SYMBOLS, *s)) {
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	0f be c0             	movsbl %al,%eax
  8000e9:	50                   	push   %eax
  8000ea:	68 d3 38 80 00       	push   $0x8038d3
  8000ef:	e8 26 12 00 00       	call   80131a <strchr>
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	85 c0                	test   %eax,%eax
  8000f9:	74 2c                	je     800127 <_gettoken+0xf4>
		t = *s;
  8000fb:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  8000fe:	89 1f                	mov    %ebx,(%edi)
		*s++ = 0;
  800100:	c6 03 00             	movb   $0x0,(%ebx)
  800103:	83 c3 01             	add    $0x1,%ebx
  800106:	8b 45 10             	mov    0x10(%ebp),%eax
  800109:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  80010b:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800112:	7e b3                	jle    8000c7 <_gettoken+0x94>
			cprintf("TOK %c\n", t);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	56                   	push   %esi
  800118:	68 c7 38 80 00       	push   $0x8038c7
  80011d:	e8 23 0a 00 00       	call   800b45 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	eb a0                	jmp    8000c7 <_gettoken+0x94>
	*p1 = s;
  800127:	89 1f                	mov    %ebx,(%edi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800129:	eb 03                	jmp    80012e <_gettoken+0xfb>
		s++;
  80012b:	83 c3 01             	add    $0x1,%ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012e:	0f b6 03             	movzbl (%ebx),%eax
  800131:	84 c0                	test   %al,%al
  800133:	74 18                	je     80014d <_gettoken+0x11a>
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	0f be c0             	movsbl %al,%eax
  80013b:	50                   	push   %eax
  80013c:	68 cf 38 80 00       	push   $0x8038cf
  800141:	e8 d4 11 00 00       	call   80131a <strchr>
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	85 c0                	test   %eax,%eax
  80014b:	74 de                	je     80012b <_gettoken+0xf8>
	*p2 = s;
  80014d:	8b 45 10             	mov    0x10(%ebp),%eax
  800150:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800152:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1) {
  800157:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80015e:	0f 8e 63 ff ff ff    	jle    8000c7 <_gettoken+0x94>
		t = **p2;
  800164:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800167:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016a:	83 ec 08             	sub    $0x8,%esp
  80016d:	ff 37                	pushl  (%edi)
  80016f:	68 db 38 80 00       	push   $0x8038db
  800174:	e8 cc 09 00 00       	call   800b45 <cprintf>
		**p2 = t;
  800179:	8b 45 10             	mov    0x10(%ebp),%eax
  80017c:	8b 00                	mov    (%eax),%eax
  80017e:	89 f2                	mov    %esi,%edx
  800180:	88 10                	mov    %dl,(%eax)
  800182:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800185:	be 77 00 00 00       	mov    $0x77,%esi
  80018a:	e9 38 ff ff ff       	jmp    8000c7 <_gettoken+0x94>

0080018f <gettoken>:

int
gettoken(char *s, char **p1)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 08             	sub    $0x8,%esp
  800195:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800198:	85 c0                	test   %eax,%eax
  80019a:	74 22                	je     8001be <gettoken+0x2f>
		nc = _gettoken(s, &np1, &np2);
  80019c:	83 ec 04             	sub    $0x4,%esp
  80019f:	68 0c 60 80 00       	push   $0x80600c
  8001a4:	68 10 60 80 00       	push   $0x806010
  8001a9:	50                   	push   %eax
  8001aa:	e8 84 fe ff ff       	call   800033 <_gettoken>
  8001af:	a3 08 60 80 00       	mov    %eax,0x806008
		return 0;
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    
	c = nc;
  8001be:	a1 08 60 80 00       	mov    0x806008,%eax
  8001c3:	a3 04 60 80 00       	mov    %eax,0x806004
	*p1 = np1;
  8001c8:	8b 15 10 60 80 00    	mov    0x806010,%edx
  8001ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d1:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	68 0c 60 80 00       	push   $0x80600c
  8001db:	68 10 60 80 00       	push   $0x806010
  8001e0:	ff 35 0c 60 80 00    	pushl  0x80600c
  8001e6:	e8 48 fe ff ff       	call   800033 <_gettoken>
  8001eb:	a3 08 60 80 00       	mov    %eax,0x806008
	return c;
  8001f0:	a1 04 60 80 00       	mov    0x806004,%eax
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	eb c2                	jmp    8001bc <gettoken+0x2d>

008001fa <runcmd>:
{
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	57                   	push   %edi
  8001fe:	56                   	push   %esi
  8001ff:	53                   	push   %ebx
  800200:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  800206:	6a 00                	push   $0x0
  800208:	ff 75 08             	pushl  0x8(%ebp)
  80020b:	e8 7f ff ff ff       	call   80018f <gettoken>
  800210:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t))) {
  800213:	8d 75 a4             	lea    -0x5c(%ebp),%esi
	argc = 0;
  800216:	bf 00 00 00 00       	mov    $0x0,%edi
		switch ((c = gettoken(0, &t))) {
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	56                   	push   %esi
  80021f:	6a 00                	push   $0x0
  800221:	e8 69 ff ff ff       	call   80018f <gettoken>
  800226:	89 c3                	mov    %eax,%ebx
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	83 f8 3e             	cmp    $0x3e,%eax
  80022e:	0f 84 32 01 00 00    	je     800366 <runcmd+0x16c>
  800234:	7f 49                	jg     80027f <runcmd+0x85>
  800236:	85 c0                	test   %eax,%eax
  800238:	0f 84 1c 02 00 00    	je     80045a <runcmd+0x260>
  80023e:	83 f8 3c             	cmp    $0x3c,%eax
  800241:	0f 85 ef 02 00 00    	jne    800536 <runcmd+0x33c>
			if (gettoken(0, &t) != 'w') {
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	56                   	push   %esi
  80024b:	6a 00                	push   $0x0
  80024d:	e8 3d ff ff ff       	call   80018f <gettoken>
  800252:	83 c4 10             	add    $0x10,%esp
  800255:	83 f8 77             	cmp    $0x77,%eax
  800258:	0f 85 ba 00 00 00    	jne    800318 <runcmd+0x11e>
			if ((fd = open(t, O_RDONLY)) < 0) {
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	6a 00                	push   $0x0
  800263:	ff 75 a4             	pushl  -0x5c(%ebp)
  800266:	e8 35 22 00 00       	call   8024a0 <open>
  80026b:	89 c3                	mov    %eax,%ebx
  80026d:	83 c4 10             	add    $0x10,%esp
  800270:	85 c0                	test   %eax,%eax
  800272:	0f 88 ba 00 00 00    	js     800332 <runcmd+0x138>
      if (fd != 0) {
  800278:	74 a1                	je     80021b <runcmd+0x21>
  80027a:	e9 cc 00 00 00       	jmp    80034b <runcmd+0x151>
		switch ((c = gettoken(0, &t))) {
  80027f:	83 f8 77             	cmp    $0x77,%eax
  800282:	74 69                	je     8002ed <runcmd+0xf3>
  800284:	83 f8 7c             	cmp    $0x7c,%eax
  800287:	0f 85 a9 02 00 00    	jne    800536 <runcmd+0x33c>
			if ((r = pipe(p)) < 0) {
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  800296:	50                   	push   %eax
  800297:	e8 8d 2b 00 00       	call   802e29 <pipe>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	0f 88 41 01 00 00    	js     8003e8 <runcmd+0x1ee>
			if (debug)
  8002a7:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8002ae:	0f 85 4f 01 00 00    	jne    800403 <runcmd+0x209>
			if ((r = fork()) < 0) {
  8002b4:	e8 d1 16 00 00       	call   80198a <fork>
  8002b9:	89 c3                	mov    %eax,%ebx
  8002bb:	85 c0                	test   %eax,%eax
  8002bd:	0f 88 61 01 00 00    	js     800424 <runcmd+0x22a>
			if (r == 0) {
  8002c3:	0f 85 71 01 00 00    	jne    80043a <runcmd+0x240>
				if (p[0] != 0) {
  8002c9:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8002cf:	85 c0                	test   %eax,%eax
  8002d1:	0f 85 1d 02 00 00    	jne    8004f4 <runcmd+0x2fa>
				close(p[1]);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8002e0:	e8 d2 1b 00 00       	call   801eb7 <close>
				goto again;
  8002e5:	83 c4 10             	add    $0x10,%esp
  8002e8:	e9 29 ff ff ff       	jmp    800216 <runcmd+0x1c>
			if (argc == MAXARGS) {
  8002ed:	83 ff 10             	cmp    $0x10,%edi
  8002f0:	74 0f                	je     800301 <runcmd+0x107>
			argv[argc++] = t;
  8002f2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002f5:	89 44 bd a8          	mov    %eax,-0x58(%ebp,%edi,4)
  8002f9:	8d 7f 01             	lea    0x1(%edi),%edi
			break;
  8002fc:	e9 1a ff ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("too many arguments\n");
  800301:	83 ec 0c             	sub    $0xc,%esp
  800304:	68 e5 38 80 00       	push   $0x8038e5
  800309:	e8 37 08 00 00       	call   800b45 <cprintf>
				exit();
  80030e:	e8 3d 07 00 00       	call   800a50 <exit>
  800313:	83 c4 10             	add    $0x10,%esp
  800316:	eb da                	jmp    8002f2 <runcmd+0xf8>
				cprintf("syntax error: < not followed by word\n");
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	68 38 3a 80 00       	push   $0x803a38
  800320:	e8 20 08 00 00       	call   800b45 <cprintf>
				exit();
  800325:	e8 26 07 00 00       	call   800a50 <exit>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	e9 2c ff ff ff       	jmp    80025e <runcmd+0x64>
				cprintf("open %s for read: %e", t, fd);
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	50                   	push   %eax
  800336:	ff 75 a4             	pushl  -0x5c(%ebp)
  800339:	68 f9 38 80 00       	push   $0x8038f9
  80033e:	e8 02 08 00 00       	call   800b45 <cprintf>
				exit();
  800343:	e8 08 07 00 00       	call   800a50 <exit>
  800348:	83 c4 10             	add    $0x10,%esp
        dup(fd, 0);
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	6a 00                	push   $0x0
  800350:	53                   	push   %ebx
  800351:	e8 b3 1b 00 00       	call   801f09 <dup>
        close(fd);
  800356:	89 1c 24             	mov    %ebx,(%esp)
  800359:	e8 59 1b 00 00       	call   801eb7 <close>
  80035e:	83 c4 10             	add    $0x10,%esp
  800361:	e9 b5 fe ff ff       	jmp    80021b <runcmd+0x21>
			if (gettoken(0, &t) != 'w') {
  800366:	83 ec 08             	sub    $0x8,%esp
  800369:	56                   	push   %esi
  80036a:	6a 00                	push   $0x0
  80036c:	e8 1e fe ff ff       	call   80018f <gettoken>
  800371:	83 c4 10             	add    $0x10,%esp
  800374:	83 f8 77             	cmp    $0x77,%eax
  800377:	75 24                	jne    80039d <runcmd+0x1a3>
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800379:	83 ec 08             	sub    $0x8,%esp
  80037c:	68 01 03 00 00       	push   $0x301
  800381:	ff 75 a4             	pushl  -0x5c(%ebp)
  800384:	e8 17 21 00 00       	call   8024a0 <open>
  800389:	89 c3                	mov    %eax,%ebx
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	85 c0                	test   %eax,%eax
  800390:	78 22                	js     8003b4 <runcmd+0x1ba>
			if (fd != 1) {
  800392:	83 f8 01             	cmp    $0x1,%eax
  800395:	0f 84 80 fe ff ff    	je     80021b <runcmd+0x21>
  80039b:	eb 30                	jmp    8003cd <runcmd+0x1d3>
				cprintf("syntax error: > not followed by word\n");
  80039d:	83 ec 0c             	sub    $0xc,%esp
  8003a0:	68 60 3a 80 00       	push   $0x803a60
  8003a5:	e8 9b 07 00 00       	call   800b45 <cprintf>
				exit();
  8003aa:	e8 a1 06 00 00       	call   800a50 <exit>
  8003af:	83 c4 10             	add    $0x10,%esp
  8003b2:	eb c5                	jmp    800379 <runcmd+0x17f>
				cprintf("open %s for write: %e", t, fd);
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	50                   	push   %eax
  8003b8:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003bb:	68 0e 39 80 00       	push   $0x80390e
  8003c0:	e8 80 07 00 00       	call   800b45 <cprintf>
				exit();
  8003c5:	e8 86 06 00 00       	call   800a50 <exit>
  8003ca:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	6a 01                	push   $0x1
  8003d2:	53                   	push   %ebx
  8003d3:	e8 31 1b 00 00       	call   801f09 <dup>
				close(fd);
  8003d8:	89 1c 24             	mov    %ebx,(%esp)
  8003db:	e8 d7 1a 00 00       	call   801eb7 <close>
  8003e0:	83 c4 10             	add    $0x10,%esp
  8003e3:	e9 33 fe ff ff       	jmp    80021b <runcmd+0x21>
				cprintf("pipe: %e", r);
  8003e8:	83 ec 08             	sub    $0x8,%esp
  8003eb:	50                   	push   %eax
  8003ec:	68 24 39 80 00       	push   $0x803924
  8003f1:	e8 4f 07 00 00       	call   800b45 <cprintf>
				exit();
  8003f6:	e8 55 06 00 00       	call   800a50 <exit>
  8003fb:	83 c4 10             	add    $0x10,%esp
  8003fe:	e9 a4 fe ff ff       	jmp    8002a7 <runcmd+0xad>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800403:	83 ec 04             	sub    $0x4,%esp
  800406:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80040c:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800412:	68 2d 39 80 00       	push   $0x80392d
  800417:	e8 29 07 00 00       	call   800b45 <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
  80041f:	e9 90 fe ff ff       	jmp    8002b4 <runcmd+0xba>
				cprintf("fork: %e", r);
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	50                   	push   %eax
  800428:	68 3a 39 80 00       	push   $0x80393a
  80042d:	e8 13 07 00 00       	call   800b45 <cprintf>
				exit();
  800432:	e8 19 06 00 00       	call   800a50 <exit>
  800437:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  80043a:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800440:	83 f8 01             	cmp    $0x1,%eax
  800443:	0f 85 cc 00 00 00    	jne    800515 <runcmd+0x31b>
				close(p[0]);
  800449:	83 ec 0c             	sub    $0xc,%esp
  80044c:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800452:	e8 60 1a 00 00       	call   801eb7 <close>
				goto runit;
  800457:	83 c4 10             	add    $0x10,%esp
	if(argc == 0) {
  80045a:	85 ff                	test   %edi,%edi
  80045c:	0f 84 e6 00 00 00    	je     800548 <runcmd+0x34e>
	if (argv[0][0] != '/') {
  800462:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800465:	80 38 2f             	cmpb   $0x2f,(%eax)
  800468:	0f 85 f5 00 00 00    	jne    800563 <runcmd+0x369>
	argv[argc] = 0;
  80046e:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
  800475:	00 
	if (debug) {
  800476:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80047d:	0f 85 08 01 00 00    	jne    80058b <runcmd+0x391>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800489:	50                   	push   %eax
  80048a:	ff 75 a8             	pushl  -0x58(%ebp)
  80048d:	e8 c7 21 00 00       	call   802659 <spawn>
  800492:	89 c6                	mov    %eax,%esi
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	85 c0                	test   %eax,%eax
  800499:	0f 88 3a 01 00 00    	js     8005d9 <runcmd+0x3df>
	close_all();
  80049f:	e8 40 1a 00 00       	call   801ee4 <close_all>
		if (debug)
  8004a4:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004ab:	0f 85 75 01 00 00    	jne    800626 <runcmd+0x42c>
		wait(r);
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	56                   	push   %esi
  8004b5:	e8 ec 2a 00 00       	call   802fa6 <wait>
		if (debug)
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004c4:	0f 85 7b 01 00 00    	jne    800645 <runcmd+0x44b>
	if (pipe_child) {
  8004ca:	85 db                	test   %ebx,%ebx
  8004cc:	74 19                	je     8004e7 <runcmd+0x2ed>
		wait(pipe_child);
  8004ce:	83 ec 0c             	sub    $0xc,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	e8 cf 2a 00 00       	call   802fa6 <wait>
		if (debug)
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004e1:	0f 85 79 01 00 00    	jne    800660 <runcmd+0x466>
	exit();
  8004e7:	e8 64 05 00 00       	call   800a50 <exit>
}
  8004ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ef:	5b                   	pop    %ebx
  8004f0:	5e                   	pop    %esi
  8004f1:	5f                   	pop    %edi
  8004f2:	5d                   	pop    %ebp
  8004f3:	c3                   	ret    
					dup(p[0], 0);
  8004f4:	83 ec 08             	sub    $0x8,%esp
  8004f7:	6a 00                	push   $0x0
  8004f9:	50                   	push   %eax
  8004fa:	e8 0a 1a 00 00       	call   801f09 <dup>
					close(p[0]);
  8004ff:	83 c4 04             	add    $0x4,%esp
  800502:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800508:	e8 aa 19 00 00       	call   801eb7 <close>
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	e9 c2 fd ff ff       	jmp    8002d7 <runcmd+0xdd>
					dup(p[1], 1);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	6a 01                	push   $0x1
  80051a:	50                   	push   %eax
  80051b:	e8 e9 19 00 00       	call   801f09 <dup>
					close(p[1]);
  800520:	83 c4 04             	add    $0x4,%esp
  800523:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800529:	e8 89 19 00 00       	call   801eb7 <close>
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	e9 13 ff ff ff       	jmp    800449 <runcmd+0x24f>
			panic("bad return %d from gettoken", c);
  800536:	53                   	push   %ebx
  800537:	68 43 39 80 00       	push   $0x803943
  80053c:	6a 78                	push   $0x78
  80053e:	68 5f 39 80 00       	push   $0x80395f
  800543:	e8 22 05 00 00       	call   800a6a <_panic>
		if (debug)
  800548:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80054f:	74 9b                	je     8004ec <runcmd+0x2f2>
			cprintf("EMPTY COMMAND\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 69 39 80 00       	push   $0x803969
  800559:	e8 e7 05 00 00       	call   800b45 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp
  800561:	eb 89                	jmp    8004ec <runcmd+0x2f2>
		argv0buf[0] = '/';
  800563:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	50                   	push   %eax
  80056e:	8d b5 a4 fb ff ff    	lea    -0x45c(%ebp),%esi
  800574:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	e8 91 0c 00 00       	call   801211 <strcpy>
		argv[0] = argv0buf;
  800580:	89 75 a8             	mov    %esi,-0x58(%ebp)
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	e9 e3 fe ff ff       	jmp    80046e <runcmd+0x274>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  80058b:	a1 28 64 80 00       	mov    0x806428,%eax
  800590:	8b 40 48             	mov    0x48(%eax),%eax
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	50                   	push   %eax
  800597:	68 78 39 80 00       	push   $0x803978
  80059c:	e8 a4 05 00 00       	call   800b45 <cprintf>
  8005a1:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	eb 11                	jmp    8005ba <runcmd+0x3c0>
			cprintf(" %s", argv[i]);
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	50                   	push   %eax
  8005ad:	68 00 3a 80 00       	push   $0x803a00
  8005b2:	e8 8e 05 00 00       	call   800b45 <cprintf>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  8005bd:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005c0:	85 c0                	test   %eax,%eax
  8005c2:	75 e5                	jne    8005a9 <runcmd+0x3af>
		cprintf("\n");
  8005c4:	83 ec 0c             	sub    $0xc,%esp
  8005c7:	68 c0 38 80 00       	push   $0x8038c0
  8005cc:	e8 74 05 00 00       	call   800b45 <cprintf>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	e9 aa fe ff ff       	jmp    800483 <runcmd+0x289>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	50                   	push   %eax
  8005dd:	ff 75 a8             	pushl  -0x58(%ebp)
  8005e0:	68 86 39 80 00       	push   $0x803986
  8005e5:	e8 5b 05 00 00       	call   800b45 <cprintf>
	close_all();
  8005ea:	e8 f5 18 00 00       	call   801ee4 <close_all>
  8005ef:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005f2:	85 db                	test   %ebx,%ebx
  8005f4:	0f 84 ed fe ff ff    	je     8004e7 <runcmd+0x2ed>
		if (debug)
  8005fa:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800601:	0f 84 c7 fe ff ff    	je     8004ce <runcmd+0x2d4>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800607:	a1 28 64 80 00       	mov    0x806428,%eax
  80060c:	8b 40 48             	mov    0x48(%eax),%eax
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	53                   	push   %ebx
  800613:	50                   	push   %eax
  800614:	68 bf 39 80 00       	push   $0x8039bf
  800619:	e8 27 05 00 00       	call   800b45 <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	e9 a8 fe ff ff       	jmp    8004ce <runcmd+0x2d4>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  800626:	a1 28 64 80 00       	mov    0x806428,%eax
  80062b:	8b 40 48             	mov    0x48(%eax),%eax
  80062e:	56                   	push   %esi
  80062f:	ff 75 a8             	pushl  -0x58(%ebp)
  800632:	50                   	push   %eax
  800633:	68 94 39 80 00       	push   $0x803994
  800638:	e8 08 05 00 00       	call   800b45 <cprintf>
  80063d:	83 c4 10             	add    $0x10,%esp
  800640:	e9 6c fe ff ff       	jmp    8004b1 <runcmd+0x2b7>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800645:	a1 28 64 80 00       	mov    0x806428,%eax
  80064a:	8b 40 48             	mov    0x48(%eax),%eax
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	50                   	push   %eax
  800651:	68 a9 39 80 00       	push   $0x8039a9
  800656:	e8 ea 04 00 00       	call   800b45 <cprintf>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	eb 92                	jmp    8005f2 <runcmd+0x3f8>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800660:	a1 28 64 80 00       	mov    0x806428,%eax
  800665:	8b 40 48             	mov    0x48(%eax),%eax
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	50                   	push   %eax
  80066c:	68 a9 39 80 00       	push   $0x8039a9
  800671:	e8 cf 04 00 00       	call   800b45 <cprintf>
  800676:	83 c4 10             	add    $0x10,%esp
  800679:	e9 69 fe ff ff       	jmp    8004e7 <runcmd+0x2ed>

0080067e <usage>:


void
usage(void)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800684:	68 88 3a 80 00       	push   $0x803a88
  800689:	e8 b7 04 00 00       	call   800b45 <cprintf>
	exit();
  80068e:	e8 bd 03 00 00       	call   800a50 <exit>
}
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	c9                   	leave  
  800697:	c3                   	ret    

00800698 <umain>:

void
umain(int argc, char **argv)
{
  800698:	55                   	push   %ebp
  800699:	89 e5                	mov    %esp,%ebp
  80069b:	57                   	push   %edi
  80069c:	56                   	push   %esi
  80069d:	53                   	push   %ebx
  80069e:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  8006a1:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8006a4:	50                   	push   %eax
  8006a5:	ff 75 0c             	pushl  0xc(%ebp)
  8006a8:	8d 45 08             	lea    0x8(%ebp),%eax
  8006ab:	50                   	push   %eax
  8006ac:	e8 07 15 00 00       	call   801bb8 <argstart>
	while ((r = argnext(&args)) >= 0)
  8006b1:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  8006b4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  8006bb:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  8006c0:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006c3:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  8006c8:	eb 10                	jmp    8006da <umain+0x42>
			debug++;
  8006ca:	83 05 00 60 80 00 01 	addl   $0x1,0x806000
			break;
  8006d1:	eb 07                	jmp    8006da <umain+0x42>
			interactive = 1;
  8006d3:	89 f7                	mov    %esi,%edi
  8006d5:	eb 03                	jmp    8006da <umain+0x42>
			break;
		case 'x':
			echocmds = 1;
  8006d7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	53                   	push   %ebx
  8006de:	e8 05 15 00 00       	call   801be8 <argnext>
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	78 16                	js     800700 <umain+0x68>
		switch (r) {
  8006ea:	83 f8 69             	cmp    $0x69,%eax
  8006ed:	74 e4                	je     8006d3 <umain+0x3b>
  8006ef:	83 f8 78             	cmp    $0x78,%eax
  8006f2:	74 e3                	je     8006d7 <umain+0x3f>
  8006f4:	83 f8 64             	cmp    $0x64,%eax
  8006f7:	74 d1                	je     8006ca <umain+0x32>
			break;
		default:
			usage();
  8006f9:	e8 80 ff ff ff       	call   80067e <usage>
  8006fe:	eb da                	jmp    8006da <umain+0x42>
		}

	if (argc > 2)
  800700:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800704:	7f 1f                	jg     800725 <umain+0x8d>
		usage();
	if (argc == 2) {
  800706:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  80070a:	74 20                	je     80072c <umain+0x94>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  80070c:	83 ff 3f             	cmp    $0x3f,%edi
  80070f:	74 75                	je     800786 <umain+0xee>
  800711:	85 ff                	test   %edi,%edi
  800713:	bf 04 3a 80 00       	mov    $0x803a04,%edi
  800718:	b8 00 00 00 00       	mov    $0x0,%eax
  80071d:	0f 44 f8             	cmove  %eax,%edi
  800720:	e9 06 01 00 00       	jmp    80082b <umain+0x193>
		usage();
  800725:	e8 54 ff ff ff       	call   80067e <usage>
  80072a:	eb da                	jmp    800706 <umain+0x6e>
		close(0);
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	6a 00                	push   $0x0
  800731:	e8 81 17 00 00       	call   801eb7 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800736:	83 c4 08             	add    $0x8,%esp
  800739:	6a 00                	push   $0x0
  80073b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073e:	ff 70 04             	pushl  0x4(%eax)
  800741:	e8 5a 1d 00 00       	call   8024a0 <open>
  800746:	83 c4 10             	add    $0x10,%esp
  800749:	85 c0                	test   %eax,%eax
  80074b:	78 1b                	js     800768 <umain+0xd0>
		assert(r == 0);
  80074d:	74 bd                	je     80070c <umain+0x74>
  80074f:	68 e8 39 80 00       	push   $0x8039e8
  800754:	68 ef 39 80 00       	push   $0x8039ef
  800759:	68 29 01 00 00       	push   $0x129
  80075e:	68 5f 39 80 00       	push   $0x80395f
  800763:	e8 02 03 00 00       	call   800a6a <_panic>
			panic("open %s: %e", argv[1], r);
  800768:	83 ec 0c             	sub    $0xc,%esp
  80076b:	50                   	push   %eax
  80076c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076f:	ff 70 04             	pushl  0x4(%eax)
  800772:	68 dc 39 80 00       	push   $0x8039dc
  800777:	68 28 01 00 00       	push   $0x128
  80077c:	68 5f 39 80 00       	push   $0x80395f
  800781:	e8 e4 02 00 00       	call   800a6a <_panic>
		interactive = iscons(0);
  800786:	83 ec 0c             	sub    $0xc,%esp
  800789:	6a 00                	push   $0x0
  80078b:	e8 fc 01 00 00       	call   80098c <iscons>
  800790:	89 c7                	mov    %eax,%edi
  800792:	83 c4 10             	add    $0x10,%esp
  800795:	e9 77 ff ff ff       	jmp    800711 <umain+0x79>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  80079a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007a1:	75 0a                	jne    8007ad <umain+0x115>
				cprintf("EXITING\n");
			exit();	// end of file
  8007a3:	e8 a8 02 00 00       	call   800a50 <exit>
  8007a8:	e9 94 00 00 00       	jmp    800841 <umain+0x1a9>
				cprintf("EXITING\n");
  8007ad:	83 ec 0c             	sub    $0xc,%esp
  8007b0:	68 07 3a 80 00       	push   $0x803a07
  8007b5:	e8 8b 03 00 00       	call   800b45 <cprintf>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	eb e4                	jmp    8007a3 <umain+0x10b>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	53                   	push   %ebx
  8007c3:	68 10 3a 80 00       	push   $0x803a10
  8007c8:	e8 78 03 00 00       	call   800b45 <cprintf>
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	eb 7c                	jmp    80084e <umain+0x1b6>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	53                   	push   %ebx
  8007d6:	68 1a 3a 80 00       	push   $0x803a1a
  8007db:	e8 63 1e 00 00       	call   802643 <printf>
  8007e0:	83 c4 10             	add    $0x10,%esp
  8007e3:	eb 78                	jmp    80085d <umain+0x1c5>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007e5:	83 ec 0c             	sub    $0xc,%esp
  8007e8:	68 20 3a 80 00       	push   $0x803a20
  8007ed:	e8 53 03 00 00       	call   800b45 <cprintf>
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	eb 73                	jmp    80086a <umain+0x1d2>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  8007f7:	50                   	push   %eax
  8007f8:	68 3a 39 80 00       	push   $0x80393a
  8007fd:	68 40 01 00 00       	push   $0x140
  800802:	68 5f 39 80 00       	push   $0x80395f
  800807:	e8 5e 02 00 00       	call   800a6a <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	50                   	push   %eax
  800810:	68 2d 3a 80 00       	push   $0x803a2d
  800815:	e8 2b 03 00 00       	call   800b45 <cprintf>
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	eb 5f                	jmp    80087e <umain+0x1e6>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  80081f:	83 ec 0c             	sub    $0xc,%esp
  800822:	56                   	push   %esi
  800823:	e8 7e 27 00 00       	call   802fa6 <wait>
  800828:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  80082b:	83 ec 0c             	sub    $0xc,%esp
  80082e:	57                   	push   %edi
  80082f:	e8 b4 08 00 00       	call   8010e8 <readline>
  800834:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	85 c0                	test   %eax,%eax
  80083b:	0f 84 59 ff ff ff    	je     80079a <umain+0x102>
		if (debug)
  800841:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800848:	0f 85 71 ff ff ff    	jne    8007bf <umain+0x127>
		if (buf[0] == '#')
  80084e:	80 3b 23             	cmpb   $0x23,(%ebx)
  800851:	74 d8                	je     80082b <umain+0x193>
		if (echocmds)
  800853:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800857:	0f 85 75 ff ff ff    	jne    8007d2 <umain+0x13a>
		if (debug)
  80085d:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800864:	0f 85 7b ff ff ff    	jne    8007e5 <umain+0x14d>
		if ((r = fork()) < 0)
  80086a:	e8 1b 11 00 00       	call   80198a <fork>
  80086f:	89 c6                	mov    %eax,%esi
  800871:	85 c0                	test   %eax,%eax
  800873:	78 82                	js     8007f7 <umain+0x15f>
		if (debug)
  800875:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80087c:	75 8e                	jne    80080c <umain+0x174>
		if (r == 0) {
  80087e:	85 f6                	test   %esi,%esi
  800880:	75 9d                	jne    80081f <umain+0x187>
			runcmd(buf);
  800882:	83 ec 0c             	sub    $0xc,%esp
  800885:	53                   	push   %ebx
  800886:	e8 6f f9 ff ff       	call   8001fa <runcmd>
			exit();
  80088b:	e8 c0 01 00 00       	call   800a50 <exit>
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	eb 96                	jmp    80082b <umain+0x193>

00800895 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  800895:	b8 00 00 00 00       	mov    $0x0,%eax
  80089a:	c3                   	ret    

0080089b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8008a1:	68 a9 3a 80 00       	push   $0x803aa9
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	e8 63 09 00 00       	call   801211 <strcpy>
	return 0;
}
  8008ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b3:	c9                   	leave  
  8008b4:	c3                   	ret    

008008b5 <devcons_write>:
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	57                   	push   %edi
  8008b9:	56                   	push   %esi
  8008ba:	53                   	push   %ebx
  8008bb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8008c1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8008c6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8008cc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8008cf:	73 31                	jae    800902 <devcons_write+0x4d>
		m = n - tot;
  8008d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008d4:	29 f3                	sub    %esi,%ebx
  8008d6:	83 fb 7f             	cmp    $0x7f,%ebx
  8008d9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008de:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8008e1:	83 ec 04             	sub    $0x4,%esp
  8008e4:	53                   	push   %ebx
  8008e5:	89 f0                	mov    %esi,%eax
  8008e7:	03 45 0c             	add    0xc(%ebp),%eax
  8008ea:	50                   	push   %eax
  8008eb:	57                   	push   %edi
  8008ec:	e8 ae 0a 00 00       	call   80139f <memmove>
		sys_cputs(buf, m);
  8008f1:	83 c4 08             	add    $0x8,%esp
  8008f4:	53                   	push   %ebx
  8008f5:	57                   	push   %edi
  8008f6:	e8 4c 0c 00 00       	call   801547 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8008fb:	01 de                	add    %ebx,%esi
  8008fd:	83 c4 10             	add    $0x10,%esp
  800900:	eb ca                	jmp    8008cc <devcons_write+0x17>
}
  800902:	89 f0                	mov    %esi,%eax
  800904:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800907:	5b                   	pop    %ebx
  800908:	5e                   	pop    %esi
  800909:	5f                   	pop    %edi
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <devcons_read>:
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800917:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80091b:	74 21                	je     80093e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80091d:	e8 43 0c 00 00       	call   801565 <sys_cgetc>
  800922:	85 c0                	test   %eax,%eax
  800924:	75 07                	jne    80092d <devcons_read+0x21>
		sys_yield();
  800926:	e8 b9 0c 00 00       	call   8015e4 <sys_yield>
  80092b:	eb f0                	jmp    80091d <devcons_read+0x11>
	if (c < 0)
  80092d:	78 0f                	js     80093e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80092f:	83 f8 04             	cmp    $0x4,%eax
  800932:	74 0c                	je     800940 <devcons_read+0x34>
	*(char*)vbuf = c;
  800934:	8b 55 0c             	mov    0xc(%ebp),%edx
  800937:	88 02                	mov    %al,(%edx)
	return 1;
  800939:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80093e:	c9                   	leave  
  80093f:	c3                   	ret    
		return 0;
  800940:	b8 00 00 00 00       	mov    $0x0,%eax
  800945:	eb f7                	jmp    80093e <devcons_read+0x32>

00800947 <cputchar>:
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800953:	6a 01                	push   $0x1
  800955:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800958:	50                   	push   %eax
  800959:	e8 e9 0b 00 00       	call   801547 <sys_cputs>
}
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	c9                   	leave  
  800962:	c3                   	ret    

00800963 <getchar>:
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800969:	6a 01                	push   $0x1
  80096b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80096e:	50                   	push   %eax
  80096f:	6a 00                	push   $0x0
  800971:	e8 7f 16 00 00       	call   801ff5 <read>
	if (r < 0)
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	85 c0                	test   %eax,%eax
  80097b:	78 06                	js     800983 <getchar+0x20>
	if (r < 1)
  80097d:	74 06                	je     800985 <getchar+0x22>
	return c;
  80097f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800983:	c9                   	leave  
  800984:	c3                   	ret    
		return -E_EOF;
  800985:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80098a:	eb f7                	jmp    800983 <getchar+0x20>

0080098c <iscons>:
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800992:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800995:	50                   	push   %eax
  800996:	ff 75 08             	pushl  0x8(%ebp)
  800999:	e8 e7 13 00 00       	call   801d85 <fd_lookup>
  80099e:	83 c4 10             	add    $0x10,%esp
  8009a1:	85 c0                	test   %eax,%eax
  8009a3:	78 11                	js     8009b6 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8009a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a8:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009ae:	39 10                	cmp    %edx,(%eax)
  8009b0:	0f 94 c0             	sete   %al
  8009b3:	0f b6 c0             	movzbl %al,%eax
}
  8009b6:	c9                   	leave  
  8009b7:	c3                   	ret    

008009b8 <opencons>:
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8009be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009c1:	50                   	push   %eax
  8009c2:	e8 6c 13 00 00       	call   801d33 <fd_alloc>
  8009c7:	83 c4 10             	add    $0x10,%esp
  8009ca:	85 c0                	test   %eax,%eax
  8009cc:	78 3a                	js     800a08 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009ce:	83 ec 04             	sub    $0x4,%esp
  8009d1:	68 07 04 00 00       	push   $0x407
  8009d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d9:	6a 00                	push   $0x0
  8009db:	e8 23 0c 00 00       	call   801603 <sys_page_alloc>
  8009e0:	83 c4 10             	add    $0x10,%esp
  8009e3:	85 c0                	test   %eax,%eax
  8009e5:	78 21                	js     800a08 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8009e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ea:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009f0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8009f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8009fc:	83 ec 0c             	sub    $0xc,%esp
  8009ff:	50                   	push   %eax
  800a00:	e8 07 13 00 00       	call   801d0c <fd2num>
  800a05:	83 c4 10             	add    $0x10,%esp
}
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	56                   	push   %esi
  800a0e:	53                   	push   %ebx
  800a0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a12:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800a15:	e8 ab 0b 00 00       	call   8015c5 <sys_getenvid>
  800a1a:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a1f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a22:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a27:	a3 28 64 80 00       	mov    %eax,0x806428

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a2c:	85 db                	test   %ebx,%ebx
  800a2e:	7e 07                	jle    800a37 <libmain+0x2d>
		binaryname = argv[0];
  800a30:	8b 06                	mov    (%esi),%eax
  800a32:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	umain(argc, argv);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	56                   	push   %esi
  800a3b:	53                   	push   %ebx
  800a3c:	e8 57 fc ff ff       	call   800698 <umain>

	// exit gracefully
	exit();
  800a41:	e8 0a 00 00 00       	call   800a50 <exit>
}
  800a46:	83 c4 10             	add    $0x10,%esp
  800a49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a4c:	5b                   	pop    %ebx
  800a4d:	5e                   	pop    %esi
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800a56:	e8 89 14 00 00       	call   801ee4 <close_all>
	sys_env_destroy(0);
  800a5b:	83 ec 0c             	sub    $0xc,%esp
  800a5e:	6a 00                	push   $0x0
  800a60:	e8 1f 0b 00 00       	call   801584 <sys_env_destroy>
}
  800a65:	83 c4 10             	add    $0x10,%esp
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	56                   	push   %esi
  800a6e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800a6f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a72:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  800a78:	e8 48 0b 00 00       	call   8015c5 <sys_getenvid>
  800a7d:	83 ec 0c             	sub    $0xc,%esp
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	ff 75 08             	pushl  0x8(%ebp)
  800a86:	56                   	push   %esi
  800a87:	50                   	push   %eax
  800a88:	68 c0 3a 80 00       	push   $0x803ac0
  800a8d:	e8 b3 00 00 00       	call   800b45 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a92:	83 c4 18             	add    $0x18,%esp
  800a95:	53                   	push   %ebx
  800a96:	ff 75 10             	pushl  0x10(%ebp)
  800a99:	e8 56 00 00 00       	call   800af4 <vcprintf>
	cprintf("\n");
  800a9e:	c7 04 24 c0 38 80 00 	movl   $0x8038c0,(%esp)
  800aa5:	e8 9b 00 00 00       	call   800b45 <cprintf>
  800aaa:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800aad:	cc                   	int3   
  800aae:	eb fd                	jmp    800aad <_panic+0x43>

00800ab0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	53                   	push   %ebx
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800aba:	8b 13                	mov    (%ebx),%edx
  800abc:	8d 42 01             	lea    0x1(%edx),%eax
  800abf:	89 03                	mov    %eax,(%ebx)
  800ac1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800ac8:	3d ff 00 00 00       	cmp    $0xff,%eax
  800acd:	74 09                	je     800ad8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800acf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800ad3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad6:	c9                   	leave  
  800ad7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	68 ff 00 00 00       	push   $0xff
  800ae0:	8d 43 08             	lea    0x8(%ebx),%eax
  800ae3:	50                   	push   %eax
  800ae4:	e8 5e 0a 00 00       	call   801547 <sys_cputs>
		b->idx = 0;
  800ae9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	eb db                	jmp    800acf <putch+0x1f>

00800af4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800afd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b04:	00 00 00 
	b.cnt = 0;
  800b07:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b0e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b11:	ff 75 0c             	pushl  0xc(%ebp)
  800b14:	ff 75 08             	pushl  0x8(%ebp)
  800b17:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b1d:	50                   	push   %eax
  800b1e:	68 b0 0a 80 00       	push   $0x800ab0
  800b23:	e8 19 01 00 00       	call   800c41 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b28:	83 c4 08             	add    $0x8,%esp
  800b2b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800b31:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b37:	50                   	push   %eax
  800b38:	e8 0a 0a 00 00       	call   801547 <sys_cputs>

	return b.cnt;
}
  800b3d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b4b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b4e:	50                   	push   %eax
  800b4f:	ff 75 08             	pushl  0x8(%ebp)
  800b52:	e8 9d ff ff ff       	call   800af4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	57                   	push   %edi
  800b5d:	56                   	push   %esi
  800b5e:	53                   	push   %ebx
  800b5f:	83 ec 1c             	sub    $0x1c,%esp
  800b62:	89 c7                	mov    %eax,%edi
  800b64:	89 d6                	mov    %edx,%esi
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b6f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b72:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b7a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800b7d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800b80:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b83:	89 d0                	mov    %edx,%eax
  800b85:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800b88:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800b8b:	73 15                	jae    800ba2 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b8d:	83 eb 01             	sub    $0x1,%ebx
  800b90:	85 db                	test   %ebx,%ebx
  800b92:	7e 43                	jle    800bd7 <printnum+0x7e>
			putch(padc, putdat);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	56                   	push   %esi
  800b98:	ff 75 18             	pushl  0x18(%ebp)
  800b9b:	ff d7                	call   *%edi
  800b9d:	83 c4 10             	add    $0x10,%esp
  800ba0:	eb eb                	jmp    800b8d <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ba2:	83 ec 0c             	sub    $0xc,%esp
  800ba5:	ff 75 18             	pushl  0x18(%ebp)
  800ba8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bab:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bae:	53                   	push   %ebx
  800baf:	ff 75 10             	pushl  0x10(%ebp)
  800bb2:	83 ec 08             	sub    $0x8,%esp
  800bb5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bb8:	ff 75 e0             	pushl  -0x20(%ebp)
  800bbb:	ff 75 dc             	pushl  -0x24(%ebp)
  800bbe:	ff 75 d8             	pushl  -0x28(%ebp)
  800bc1:	e8 8a 2a 00 00       	call   803650 <__udivdi3>
  800bc6:	83 c4 18             	add    $0x18,%esp
  800bc9:	52                   	push   %edx
  800bca:	50                   	push   %eax
  800bcb:	89 f2                	mov    %esi,%edx
  800bcd:	89 f8                	mov    %edi,%eax
  800bcf:	e8 85 ff ff ff       	call   800b59 <printnum>
  800bd4:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bd7:	83 ec 08             	sub    $0x8,%esp
  800bda:	56                   	push   %esi
  800bdb:	83 ec 04             	sub    $0x4,%esp
  800bde:	ff 75 e4             	pushl  -0x1c(%ebp)
  800be1:	ff 75 e0             	pushl  -0x20(%ebp)
  800be4:	ff 75 dc             	pushl  -0x24(%ebp)
  800be7:	ff 75 d8             	pushl  -0x28(%ebp)
  800bea:	e8 71 2b 00 00       	call   803760 <__umoddi3>
  800bef:	83 c4 14             	add    $0x14,%esp
  800bf2:	0f be 80 e3 3a 80 00 	movsbl 0x803ae3(%eax),%eax
  800bf9:	50                   	push   %eax
  800bfa:	ff d7                	call   *%edi
}
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5f                   	pop    %edi
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c0d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c11:	8b 10                	mov    (%eax),%edx
  800c13:	3b 50 04             	cmp    0x4(%eax),%edx
  800c16:	73 0a                	jae    800c22 <sprintputch+0x1b>
		*b->buf++ = ch;
  800c18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c1b:	89 08                	mov    %ecx,(%eax)
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	88 02                	mov    %al,(%edx)
}
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <printfmt>:
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c2a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c2d:	50                   	push   %eax
  800c2e:	ff 75 10             	pushl  0x10(%ebp)
  800c31:	ff 75 0c             	pushl  0xc(%ebp)
  800c34:	ff 75 08             	pushl  0x8(%ebp)
  800c37:	e8 05 00 00 00       	call   800c41 <vprintfmt>
}
  800c3c:	83 c4 10             	add    $0x10,%esp
  800c3f:	c9                   	leave  
  800c40:	c3                   	ret    

00800c41 <vprintfmt>:
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	57                   	push   %edi
  800c45:	56                   	push   %esi
  800c46:	53                   	push   %ebx
  800c47:	83 ec 3c             	sub    $0x3c,%esp
  800c4a:	8b 75 08             	mov    0x8(%ebp),%esi
  800c4d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c50:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c53:	eb 0a                	jmp    800c5f <vprintfmt+0x1e>
			putch(ch, putdat);
  800c55:	83 ec 08             	sub    $0x8,%esp
  800c58:	53                   	push   %ebx
  800c59:	50                   	push   %eax
  800c5a:	ff d6                	call   *%esi
  800c5c:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c5f:	83 c7 01             	add    $0x1,%edi
  800c62:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c66:	83 f8 25             	cmp    $0x25,%eax
  800c69:	74 0c                	je     800c77 <vprintfmt+0x36>
			if (ch == '\0')
  800c6b:	85 c0                	test   %eax,%eax
  800c6d:	75 e6                	jne    800c55 <vprintfmt+0x14>
}
  800c6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5f                   	pop    %edi
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    
		padc = ' ';
  800c77:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800c7b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800c82:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800c89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c90:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800c95:	8d 47 01             	lea    0x1(%edi),%eax
  800c98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c9b:	0f b6 17             	movzbl (%edi),%edx
  800c9e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800ca1:	3c 55                	cmp    $0x55,%al
  800ca3:	0f 87 ba 03 00 00    	ja     801063 <vprintfmt+0x422>
  800ca9:	0f b6 c0             	movzbl %al,%eax
  800cac:	ff 24 85 20 3c 80 00 	jmp    *0x803c20(,%eax,4)
  800cb3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800cb6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800cba:	eb d9                	jmp    800c95 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800cbc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800cbf:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800cc3:	eb d0                	jmp    800c95 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800cc5:	0f b6 d2             	movzbl %dl,%edx
  800cc8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800cd3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800cd6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800cda:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800cdd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800ce0:	83 f9 09             	cmp    $0x9,%ecx
  800ce3:	77 55                	ja     800d3a <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800ce5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800ce8:	eb e9                	jmp    800cd3 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800cea:	8b 45 14             	mov    0x14(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf5:	8d 40 04             	lea    0x4(%eax),%eax
  800cf8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800cfb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800cfe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d02:	79 91                	jns    800c95 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d04:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d07:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d0a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800d11:	eb 82                	jmp    800c95 <vprintfmt+0x54>
  800d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d16:	85 c0                	test   %eax,%eax
  800d18:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1d:	0f 49 d0             	cmovns %eax,%edx
  800d20:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d23:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d26:	e9 6a ff ff ff       	jmp    800c95 <vprintfmt+0x54>
  800d2b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d2e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800d35:	e9 5b ff ff ff       	jmp    800c95 <vprintfmt+0x54>
  800d3a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800d3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d40:	eb bc                	jmp    800cfe <vprintfmt+0xbd>
			lflag++;
  800d42:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d45:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d48:	e9 48 ff ff ff       	jmp    800c95 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800d4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d50:	8d 78 04             	lea    0x4(%eax),%edi
  800d53:	83 ec 08             	sub    $0x8,%esp
  800d56:	53                   	push   %ebx
  800d57:	ff 30                	pushl  (%eax)
  800d59:	ff d6                	call   *%esi
			break;
  800d5b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d5e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d61:	e9 9c 02 00 00       	jmp    801002 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	8d 78 04             	lea    0x4(%eax),%edi
  800d6c:	8b 00                	mov    (%eax),%eax
  800d6e:	99                   	cltd   
  800d6f:	31 d0                	xor    %edx,%eax
  800d71:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d73:	83 f8 0f             	cmp    $0xf,%eax
  800d76:	7f 23                	jg     800d9b <vprintfmt+0x15a>
  800d78:	8b 14 85 80 3d 80 00 	mov    0x803d80(,%eax,4),%edx
  800d7f:	85 d2                	test   %edx,%edx
  800d81:	74 18                	je     800d9b <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800d83:	52                   	push   %edx
  800d84:	68 01 3a 80 00       	push   $0x803a01
  800d89:	53                   	push   %ebx
  800d8a:	56                   	push   %esi
  800d8b:	e8 94 fe ff ff       	call   800c24 <printfmt>
  800d90:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d93:	89 7d 14             	mov    %edi,0x14(%ebp)
  800d96:	e9 67 02 00 00       	jmp    801002 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800d9b:	50                   	push   %eax
  800d9c:	68 fb 3a 80 00       	push   $0x803afb
  800da1:	53                   	push   %ebx
  800da2:	56                   	push   %esi
  800da3:	e8 7c fe ff ff       	call   800c24 <printfmt>
  800da8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800dab:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800dae:	e9 4f 02 00 00       	jmp    801002 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800db3:	8b 45 14             	mov    0x14(%ebp),%eax
  800db6:	83 c0 04             	add    $0x4,%eax
  800db9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800dbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbf:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800dc1:	85 d2                	test   %edx,%edx
  800dc3:	b8 f4 3a 80 00       	mov    $0x803af4,%eax
  800dc8:	0f 45 c2             	cmovne %edx,%eax
  800dcb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800dce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd2:	7e 06                	jle    800dda <vprintfmt+0x199>
  800dd4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800dd8:	75 0d                	jne    800de7 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dda:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800ddd:	89 c7                	mov    %eax,%edi
  800ddf:	03 45 e0             	add    -0x20(%ebp),%eax
  800de2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800de5:	eb 3f                	jmp    800e26 <vprintfmt+0x1e5>
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 d8             	pushl  -0x28(%ebp)
  800ded:	50                   	push   %eax
  800dee:	e8 fd 03 00 00       	call   8011f0 <strnlen>
  800df3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800df6:	29 c2                	sub    %eax,%edx
  800df8:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800dfb:	83 c4 10             	add    $0x10,%esp
  800dfe:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800e00:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800e04:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800e07:	85 ff                	test   %edi,%edi
  800e09:	7e 58                	jle    800e63 <vprintfmt+0x222>
					putch(padc, putdat);
  800e0b:	83 ec 08             	sub    $0x8,%esp
  800e0e:	53                   	push   %ebx
  800e0f:	ff 75 e0             	pushl  -0x20(%ebp)
  800e12:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e14:	83 ef 01             	sub    $0x1,%edi
  800e17:	83 c4 10             	add    $0x10,%esp
  800e1a:	eb eb                	jmp    800e07 <vprintfmt+0x1c6>
					putch(ch, putdat);
  800e1c:	83 ec 08             	sub    $0x8,%esp
  800e1f:	53                   	push   %ebx
  800e20:	52                   	push   %edx
  800e21:	ff d6                	call   *%esi
  800e23:	83 c4 10             	add    $0x10,%esp
  800e26:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e29:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2b:	83 c7 01             	add    $0x1,%edi
  800e2e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e32:	0f be d0             	movsbl %al,%edx
  800e35:	85 d2                	test   %edx,%edx
  800e37:	74 45                	je     800e7e <vprintfmt+0x23d>
  800e39:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e3d:	78 06                	js     800e45 <vprintfmt+0x204>
  800e3f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800e43:	78 35                	js     800e7a <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800e45:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800e49:	74 d1                	je     800e1c <vprintfmt+0x1db>
  800e4b:	0f be c0             	movsbl %al,%eax
  800e4e:	83 e8 20             	sub    $0x20,%eax
  800e51:	83 f8 5e             	cmp    $0x5e,%eax
  800e54:	76 c6                	jbe    800e1c <vprintfmt+0x1db>
					putch('?', putdat);
  800e56:	83 ec 08             	sub    $0x8,%esp
  800e59:	53                   	push   %ebx
  800e5a:	6a 3f                	push   $0x3f
  800e5c:	ff d6                	call   *%esi
  800e5e:	83 c4 10             	add    $0x10,%esp
  800e61:	eb c3                	jmp    800e26 <vprintfmt+0x1e5>
  800e63:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800e66:	85 d2                	test   %edx,%edx
  800e68:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6d:	0f 49 c2             	cmovns %edx,%eax
  800e70:	29 c2                	sub    %eax,%edx
  800e72:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800e75:	e9 60 ff ff ff       	jmp    800dda <vprintfmt+0x199>
  800e7a:	89 cf                	mov    %ecx,%edi
  800e7c:	eb 02                	jmp    800e80 <vprintfmt+0x23f>
  800e7e:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800e80:	85 ff                	test   %edi,%edi
  800e82:	7e 10                	jle    800e94 <vprintfmt+0x253>
				putch(' ', putdat);
  800e84:	83 ec 08             	sub    $0x8,%esp
  800e87:	53                   	push   %ebx
  800e88:	6a 20                	push   $0x20
  800e8a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800e8c:	83 ef 01             	sub    $0x1,%edi
  800e8f:	83 c4 10             	add    $0x10,%esp
  800e92:	eb ec                	jmp    800e80 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800e94:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800e97:	89 45 14             	mov    %eax,0x14(%ebp)
  800e9a:	e9 63 01 00 00       	jmp    801002 <vprintfmt+0x3c1>
	if (lflag >= 2)
  800e9f:	83 f9 01             	cmp    $0x1,%ecx
  800ea2:	7f 1b                	jg     800ebf <vprintfmt+0x27e>
	else if (lflag)
  800ea4:	85 c9                	test   %ecx,%ecx
  800ea6:	74 63                	je     800f0b <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800ea8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eb0:	99                   	cltd   
  800eb1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800eb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb7:	8d 40 04             	lea    0x4(%eax),%eax
  800eba:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebd:	eb 17                	jmp    800ed6 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800ebf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec2:	8b 50 04             	mov    0x4(%eax),%edx
  800ec5:	8b 00                	mov    (%eax),%eax
  800ec7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ecd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed0:	8d 40 08             	lea    0x8(%eax),%eax
  800ed3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800ed6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ed9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800edc:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800ee1:	85 c9                	test   %ecx,%ecx
  800ee3:	0f 89 ff 00 00 00    	jns    800fe8 <vprintfmt+0x3a7>
				putch('-', putdat);
  800ee9:	83 ec 08             	sub    $0x8,%esp
  800eec:	53                   	push   %ebx
  800eed:	6a 2d                	push   $0x2d
  800eef:	ff d6                	call   *%esi
				num = -(long long) num;
  800ef1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ef4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800ef7:	f7 da                	neg    %edx
  800ef9:	83 d1 00             	adc    $0x0,%ecx
  800efc:	f7 d9                	neg    %ecx
  800efe:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800f01:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f06:	e9 dd 00 00 00       	jmp    800fe8 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800f0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0e:	8b 00                	mov    (%eax),%eax
  800f10:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f13:	99                   	cltd   
  800f14:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f17:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1a:	8d 40 04             	lea    0x4(%eax),%eax
  800f1d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f20:	eb b4                	jmp    800ed6 <vprintfmt+0x295>
	if (lflag >= 2)
  800f22:	83 f9 01             	cmp    $0x1,%ecx
  800f25:	7f 1e                	jg     800f45 <vprintfmt+0x304>
	else if (lflag)
  800f27:	85 c9                	test   %ecx,%ecx
  800f29:	74 32                	je     800f5d <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800f2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2e:	8b 10                	mov    (%eax),%edx
  800f30:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f35:	8d 40 04             	lea    0x4(%eax),%eax
  800f38:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f3b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f40:	e9 a3 00 00 00       	jmp    800fe8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800f45:	8b 45 14             	mov    0x14(%ebp),%eax
  800f48:	8b 10                	mov    (%eax),%edx
  800f4a:	8b 48 04             	mov    0x4(%eax),%ecx
  800f4d:	8d 40 08             	lea    0x8(%eax),%eax
  800f50:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f53:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f58:	e9 8b 00 00 00       	jmp    800fe8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800f5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f60:	8b 10                	mov    (%eax),%edx
  800f62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f67:	8d 40 04             	lea    0x4(%eax),%eax
  800f6a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f6d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f72:	eb 74                	jmp    800fe8 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800f74:	83 f9 01             	cmp    $0x1,%ecx
  800f77:	7f 1b                	jg     800f94 <vprintfmt+0x353>
	else if (lflag)
  800f79:	85 c9                	test   %ecx,%ecx
  800f7b:	74 2c                	je     800fa9 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800f7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f80:	8b 10                	mov    (%eax),%edx
  800f82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f87:	8d 40 04             	lea    0x4(%eax),%eax
  800f8a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f8d:	b8 08 00 00 00       	mov    $0x8,%eax
  800f92:	eb 54                	jmp    800fe8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800f94:	8b 45 14             	mov    0x14(%ebp),%eax
  800f97:	8b 10                	mov    (%eax),%edx
  800f99:	8b 48 04             	mov    0x4(%eax),%ecx
  800f9c:	8d 40 08             	lea    0x8(%eax),%eax
  800f9f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fa2:	b8 08 00 00 00       	mov    $0x8,%eax
  800fa7:	eb 3f                	jmp    800fe8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800fa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fac:	8b 10                	mov    (%eax),%edx
  800fae:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb3:	8d 40 04             	lea    0x4(%eax),%eax
  800fb6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fb9:	b8 08 00 00 00       	mov    $0x8,%eax
  800fbe:	eb 28                	jmp    800fe8 <vprintfmt+0x3a7>
			putch('0', putdat);
  800fc0:	83 ec 08             	sub    $0x8,%esp
  800fc3:	53                   	push   %ebx
  800fc4:	6a 30                	push   $0x30
  800fc6:	ff d6                	call   *%esi
			putch('x', putdat);
  800fc8:	83 c4 08             	add    $0x8,%esp
  800fcb:	53                   	push   %ebx
  800fcc:	6a 78                	push   $0x78
  800fce:	ff d6                	call   *%esi
			num = (unsigned long long)
  800fd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd3:	8b 10                	mov    (%eax),%edx
  800fd5:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800fda:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800fdd:	8d 40 04             	lea    0x4(%eax),%eax
  800fe0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800fe3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800fe8:	83 ec 0c             	sub    $0xc,%esp
  800feb:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800fef:	57                   	push   %edi
  800ff0:	ff 75 e0             	pushl  -0x20(%ebp)
  800ff3:	50                   	push   %eax
  800ff4:	51                   	push   %ecx
  800ff5:	52                   	push   %edx
  800ff6:	89 da                	mov    %ebx,%edx
  800ff8:	89 f0                	mov    %esi,%eax
  800ffa:	e8 5a fb ff ff       	call   800b59 <printnum>
			break;
  800fff:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801002:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801005:	e9 55 fc ff ff       	jmp    800c5f <vprintfmt+0x1e>
	if (lflag >= 2)
  80100a:	83 f9 01             	cmp    $0x1,%ecx
  80100d:	7f 1b                	jg     80102a <vprintfmt+0x3e9>
	else if (lflag)
  80100f:	85 c9                	test   %ecx,%ecx
  801011:	74 2c                	je     80103f <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  801013:	8b 45 14             	mov    0x14(%ebp),%eax
  801016:	8b 10                	mov    (%eax),%edx
  801018:	b9 00 00 00 00       	mov    $0x0,%ecx
  80101d:	8d 40 04             	lea    0x4(%eax),%eax
  801020:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801023:	b8 10 00 00 00       	mov    $0x10,%eax
  801028:	eb be                	jmp    800fe8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80102a:	8b 45 14             	mov    0x14(%ebp),%eax
  80102d:	8b 10                	mov    (%eax),%edx
  80102f:	8b 48 04             	mov    0x4(%eax),%ecx
  801032:	8d 40 08             	lea    0x8(%eax),%eax
  801035:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801038:	b8 10 00 00 00       	mov    $0x10,%eax
  80103d:	eb a9                	jmp    800fe8 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  80103f:	8b 45 14             	mov    0x14(%ebp),%eax
  801042:	8b 10                	mov    (%eax),%edx
  801044:	b9 00 00 00 00       	mov    $0x0,%ecx
  801049:	8d 40 04             	lea    0x4(%eax),%eax
  80104c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80104f:	b8 10 00 00 00       	mov    $0x10,%eax
  801054:	eb 92                	jmp    800fe8 <vprintfmt+0x3a7>
			putch(ch, putdat);
  801056:	83 ec 08             	sub    $0x8,%esp
  801059:	53                   	push   %ebx
  80105a:	6a 25                	push   $0x25
  80105c:	ff d6                	call   *%esi
			break;
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	eb 9f                	jmp    801002 <vprintfmt+0x3c1>
			putch('%', putdat);
  801063:	83 ec 08             	sub    $0x8,%esp
  801066:	53                   	push   %ebx
  801067:	6a 25                	push   $0x25
  801069:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80106b:	83 c4 10             	add    $0x10,%esp
  80106e:	89 f8                	mov    %edi,%eax
  801070:	eb 03                	jmp    801075 <vprintfmt+0x434>
  801072:	83 e8 01             	sub    $0x1,%eax
  801075:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801079:	75 f7                	jne    801072 <vprintfmt+0x431>
  80107b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80107e:	eb 82                	jmp    801002 <vprintfmt+0x3c1>

00801080 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
  801083:	83 ec 18             	sub    $0x18,%esp
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80108c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80108f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801093:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801096:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80109d:	85 c0                	test   %eax,%eax
  80109f:	74 26                	je     8010c7 <vsnprintf+0x47>
  8010a1:	85 d2                	test   %edx,%edx
  8010a3:	7e 22                	jle    8010c7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010a5:	ff 75 14             	pushl  0x14(%ebp)
  8010a8:	ff 75 10             	pushl  0x10(%ebp)
  8010ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ae:	50                   	push   %eax
  8010af:	68 07 0c 80 00       	push   $0x800c07
  8010b4:	e8 88 fb ff ff       	call   800c41 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8010b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010bc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c2:	83 c4 10             	add    $0x10,%esp
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    
		return -E_INVAL;
  8010c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010cc:	eb f7                	jmp    8010c5 <vsnprintf+0x45>

008010ce <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010d4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8010d7:	50                   	push   %eax
  8010d8:	ff 75 10             	pushl  0x10(%ebp)
  8010db:	ff 75 0c             	pushl  0xc(%ebp)
  8010de:	ff 75 08             	pushl  0x8(%ebp)
  8010e1:	e8 9a ff ff ff       	call   801080 <vsnprintf>
	va_end(ap);

	return rc;
}
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    

008010e8 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	57                   	push   %edi
  8010ec:	56                   	push   %esi
  8010ed:	53                   	push   %ebx
  8010ee:	83 ec 0c             	sub    $0xc,%esp
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	74 13                	je     80110b <readline+0x23>
		fprintf(1, "%s", prompt);
  8010f8:	83 ec 04             	sub    $0x4,%esp
  8010fb:	50                   	push   %eax
  8010fc:	68 01 3a 80 00       	push   $0x803a01
  801101:	6a 01                	push   $0x1
  801103:	e8 24 15 00 00       	call   80262c <fprintf>
  801108:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  80110b:	83 ec 0c             	sub    $0xc,%esp
  80110e:	6a 00                	push   $0x0
  801110:	e8 77 f8 ff ff       	call   80098c <iscons>
  801115:	89 c7                	mov    %eax,%edi
  801117:	83 c4 10             	add    $0x10,%esp
	i = 0;
  80111a:	be 00 00 00 00       	mov    $0x0,%esi
  80111f:	eb 57                	jmp    801178 <readline+0x90>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  801121:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  801126:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801129:	75 08                	jne    801133 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  80112b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80112e:	5b                   	pop    %ebx
  80112f:	5e                   	pop    %esi
  801130:	5f                   	pop    %edi
  801131:	5d                   	pop    %ebp
  801132:	c3                   	ret    
				cprintf("read error: %e\n", c);
  801133:	83 ec 08             	sub    $0x8,%esp
  801136:	53                   	push   %ebx
  801137:	68 df 3d 80 00       	push   $0x803ddf
  80113c:	e8 04 fa ff ff       	call   800b45 <cprintf>
  801141:	83 c4 10             	add    $0x10,%esp
			return NULL;
  801144:	b8 00 00 00 00       	mov    $0x0,%eax
  801149:	eb e0                	jmp    80112b <readline+0x43>
			if (echoing)
  80114b:	85 ff                	test   %edi,%edi
  80114d:	75 05                	jne    801154 <readline+0x6c>
			i--;
  80114f:	83 ee 01             	sub    $0x1,%esi
  801152:	eb 24                	jmp    801178 <readline+0x90>
				cputchar('\b');
  801154:	83 ec 0c             	sub    $0xc,%esp
  801157:	6a 08                	push   $0x8
  801159:	e8 e9 f7 ff ff       	call   800947 <cputchar>
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	eb ec                	jmp    80114f <readline+0x67>
				cputchar(c);
  801163:	83 ec 0c             	sub    $0xc,%esp
  801166:	53                   	push   %ebx
  801167:	e8 db f7 ff ff       	call   800947 <cputchar>
  80116c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80116f:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  801175:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  801178:	e8 e6 f7 ff ff       	call   800963 <getchar>
  80117d:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  80117f:	85 c0                	test   %eax,%eax
  801181:	78 9e                	js     801121 <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  801183:	83 f8 08             	cmp    $0x8,%eax
  801186:	0f 94 c2             	sete   %dl
  801189:	83 f8 7f             	cmp    $0x7f,%eax
  80118c:	0f 94 c0             	sete   %al
  80118f:	08 c2                	or     %al,%dl
  801191:	74 04                	je     801197 <readline+0xaf>
  801193:	85 f6                	test   %esi,%esi
  801195:	7f b4                	jg     80114b <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801197:	83 fb 1f             	cmp    $0x1f,%ebx
  80119a:	7e 0e                	jle    8011aa <readline+0xc2>
  80119c:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8011a2:	7f 06                	jg     8011aa <readline+0xc2>
			if (echoing)
  8011a4:	85 ff                	test   %edi,%edi
  8011a6:	74 c7                	je     80116f <readline+0x87>
  8011a8:	eb b9                	jmp    801163 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  8011aa:	83 fb 0a             	cmp    $0xa,%ebx
  8011ad:	74 05                	je     8011b4 <readline+0xcc>
  8011af:	83 fb 0d             	cmp    $0xd,%ebx
  8011b2:	75 c4                	jne    801178 <readline+0x90>
			if (echoing)
  8011b4:	85 ff                	test   %edi,%edi
  8011b6:	75 11                	jne    8011c9 <readline+0xe1>
			buf[i] = 0;
  8011b8:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  8011bf:	b8 20 60 80 00       	mov    $0x806020,%eax
  8011c4:	e9 62 ff ff ff       	jmp    80112b <readline+0x43>
				cputchar('\n');
  8011c9:	83 ec 0c             	sub    $0xc,%esp
  8011cc:	6a 0a                	push   $0xa
  8011ce:	e8 74 f7 ff ff       	call   800947 <cputchar>
  8011d3:	83 c4 10             	add    $0x10,%esp
  8011d6:	eb e0                	jmp    8011b8 <readline+0xd0>

008011d8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8011de:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8011e7:	74 05                	je     8011ee <strlen+0x16>
		n++;
  8011e9:	83 c0 01             	add    $0x1,%eax
  8011ec:	eb f5                	jmp    8011e3 <strlen+0xb>
	return n;
}
  8011ee:	5d                   	pop    %ebp
  8011ef:	c3                   	ret    

008011f0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011fe:	39 c2                	cmp    %eax,%edx
  801200:	74 0d                	je     80120f <strnlen+0x1f>
  801202:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801206:	74 05                	je     80120d <strnlen+0x1d>
		n++;
  801208:	83 c2 01             	add    $0x1,%edx
  80120b:	eb f1                	jmp    8011fe <strnlen+0xe>
  80120d:	89 d0                	mov    %edx,%eax
	return n;
}
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	53                   	push   %ebx
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80121b:	ba 00 00 00 00       	mov    $0x0,%edx
  801220:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801224:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801227:	83 c2 01             	add    $0x1,%edx
  80122a:	84 c9                	test   %cl,%cl
  80122c:	75 f2                	jne    801220 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80122e:	5b                   	pop    %ebx
  80122f:	5d                   	pop    %ebp
  801230:	c3                   	ret    

00801231 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	53                   	push   %ebx
  801235:	83 ec 10             	sub    $0x10,%esp
  801238:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80123b:	53                   	push   %ebx
  80123c:	e8 97 ff ff ff       	call   8011d8 <strlen>
  801241:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801244:	ff 75 0c             	pushl  0xc(%ebp)
  801247:	01 d8                	add    %ebx,%eax
  801249:	50                   	push   %eax
  80124a:	e8 c2 ff ff ff       	call   801211 <strcpy>
	return dst;
}
  80124f:	89 d8                	mov    %ebx,%eax
  801251:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801254:	c9                   	leave  
  801255:	c3                   	ret    

00801256 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	56                   	push   %esi
  80125a:	53                   	push   %ebx
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801261:	89 c6                	mov    %eax,%esi
  801263:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801266:	89 c2                	mov    %eax,%edx
  801268:	39 f2                	cmp    %esi,%edx
  80126a:	74 11                	je     80127d <strncpy+0x27>
		*dst++ = *src;
  80126c:	83 c2 01             	add    $0x1,%edx
  80126f:	0f b6 19             	movzbl (%ecx),%ebx
  801272:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801275:	80 fb 01             	cmp    $0x1,%bl
  801278:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80127b:	eb eb                	jmp    801268 <strncpy+0x12>
	}
	return ret;
}
  80127d:	5b                   	pop    %ebx
  80127e:	5e                   	pop    %esi
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	8b 75 08             	mov    0x8(%ebp),%esi
  801289:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80128c:	8b 55 10             	mov    0x10(%ebp),%edx
  80128f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801291:	85 d2                	test   %edx,%edx
  801293:	74 21                	je     8012b6 <strlcpy+0x35>
  801295:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801299:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80129b:	39 c2                	cmp    %eax,%edx
  80129d:	74 14                	je     8012b3 <strlcpy+0x32>
  80129f:	0f b6 19             	movzbl (%ecx),%ebx
  8012a2:	84 db                	test   %bl,%bl
  8012a4:	74 0b                	je     8012b1 <strlcpy+0x30>
			*dst++ = *src++;
  8012a6:	83 c1 01             	add    $0x1,%ecx
  8012a9:	83 c2 01             	add    $0x1,%edx
  8012ac:	88 5a ff             	mov    %bl,-0x1(%edx)
  8012af:	eb ea                	jmp    80129b <strlcpy+0x1a>
  8012b1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8012b3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8012b6:	29 f0                	sub    %esi,%eax
}
  8012b8:	5b                   	pop    %ebx
  8012b9:	5e                   	pop    %esi
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    

008012bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8012c5:	0f b6 01             	movzbl (%ecx),%eax
  8012c8:	84 c0                	test   %al,%al
  8012ca:	74 0c                	je     8012d8 <strcmp+0x1c>
  8012cc:	3a 02                	cmp    (%edx),%al
  8012ce:	75 08                	jne    8012d8 <strcmp+0x1c>
		p++, q++;
  8012d0:	83 c1 01             	add    $0x1,%ecx
  8012d3:	83 c2 01             	add    $0x1,%edx
  8012d6:	eb ed                	jmp    8012c5 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d8:	0f b6 c0             	movzbl %al,%eax
  8012db:	0f b6 12             	movzbl (%edx),%edx
  8012de:	29 d0                	sub    %edx,%eax
}
  8012e0:	5d                   	pop    %ebp
  8012e1:	c3                   	ret    

008012e2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	53                   	push   %ebx
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ec:	89 c3                	mov    %eax,%ebx
  8012ee:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8012f1:	eb 06                	jmp    8012f9 <strncmp+0x17>
		n--, p++, q++;
  8012f3:	83 c0 01             	add    $0x1,%eax
  8012f6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8012f9:	39 d8                	cmp    %ebx,%eax
  8012fb:	74 16                	je     801313 <strncmp+0x31>
  8012fd:	0f b6 08             	movzbl (%eax),%ecx
  801300:	84 c9                	test   %cl,%cl
  801302:	74 04                	je     801308 <strncmp+0x26>
  801304:	3a 0a                	cmp    (%edx),%cl
  801306:	74 eb                	je     8012f3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801308:	0f b6 00             	movzbl (%eax),%eax
  80130b:	0f b6 12             	movzbl (%edx),%edx
  80130e:	29 d0                	sub    %edx,%eax
}
  801310:	5b                   	pop    %ebx
  801311:	5d                   	pop    %ebp
  801312:	c3                   	ret    
		return 0;
  801313:	b8 00 00 00 00       	mov    $0x0,%eax
  801318:	eb f6                	jmp    801310 <strncmp+0x2e>

0080131a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801324:	0f b6 10             	movzbl (%eax),%edx
  801327:	84 d2                	test   %dl,%dl
  801329:	74 09                	je     801334 <strchr+0x1a>
		if (*s == c)
  80132b:	38 ca                	cmp    %cl,%dl
  80132d:	74 0a                	je     801339 <strchr+0x1f>
	for (; *s; s++)
  80132f:	83 c0 01             	add    $0x1,%eax
  801332:	eb f0                	jmp    801324 <strchr+0xa>
			return (char *) s;
	return 0;
  801334:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801339:	5d                   	pop    %ebp
  80133a:	c3                   	ret    

0080133b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801345:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801348:	38 ca                	cmp    %cl,%dl
  80134a:	74 09                	je     801355 <strfind+0x1a>
  80134c:	84 d2                	test   %dl,%dl
  80134e:	74 05                	je     801355 <strfind+0x1a>
	for (; *s; s++)
  801350:	83 c0 01             	add    $0x1,%eax
  801353:	eb f0                	jmp    801345 <strfind+0xa>
			break;
	return (char *) s;
}
  801355:	5d                   	pop    %ebp
  801356:	c3                   	ret    

00801357 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	57                   	push   %edi
  80135b:	56                   	push   %esi
  80135c:	53                   	push   %ebx
  80135d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801360:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801363:	85 c9                	test   %ecx,%ecx
  801365:	74 31                	je     801398 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801367:	89 f8                	mov    %edi,%eax
  801369:	09 c8                	or     %ecx,%eax
  80136b:	a8 03                	test   $0x3,%al
  80136d:	75 23                	jne    801392 <memset+0x3b>
		c &= 0xFF;
  80136f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801373:	89 d3                	mov    %edx,%ebx
  801375:	c1 e3 08             	shl    $0x8,%ebx
  801378:	89 d0                	mov    %edx,%eax
  80137a:	c1 e0 18             	shl    $0x18,%eax
  80137d:	89 d6                	mov    %edx,%esi
  80137f:	c1 e6 10             	shl    $0x10,%esi
  801382:	09 f0                	or     %esi,%eax
  801384:	09 c2                	or     %eax,%edx
  801386:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801388:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80138b:	89 d0                	mov    %edx,%eax
  80138d:	fc                   	cld    
  80138e:	f3 ab                	rep stos %eax,%es:(%edi)
  801390:	eb 06                	jmp    801398 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801392:	8b 45 0c             	mov    0xc(%ebp),%eax
  801395:	fc                   	cld    
  801396:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801398:	89 f8                	mov    %edi,%eax
  80139a:	5b                   	pop    %ebx
  80139b:	5e                   	pop    %esi
  80139c:	5f                   	pop    %edi
  80139d:	5d                   	pop    %ebp
  80139e:	c3                   	ret    

0080139f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	57                   	push   %edi
  8013a3:	56                   	push   %esi
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013ad:	39 c6                	cmp    %eax,%esi
  8013af:	73 32                	jae    8013e3 <memmove+0x44>
  8013b1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8013b4:	39 c2                	cmp    %eax,%edx
  8013b6:	76 2b                	jbe    8013e3 <memmove+0x44>
		s += n;
		d += n;
  8013b8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8013bb:	89 fe                	mov    %edi,%esi
  8013bd:	09 ce                	or     %ecx,%esi
  8013bf:	09 d6                	or     %edx,%esi
  8013c1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8013c7:	75 0e                	jne    8013d7 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013c9:	83 ef 04             	sub    $0x4,%edi
  8013cc:	8d 72 fc             	lea    -0x4(%edx),%esi
  8013cf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8013d2:	fd                   	std    
  8013d3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8013d5:	eb 09                	jmp    8013e0 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013d7:	83 ef 01             	sub    $0x1,%edi
  8013da:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8013dd:	fd                   	std    
  8013de:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013e0:	fc                   	cld    
  8013e1:	eb 1a                	jmp    8013fd <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8013e3:	89 c2                	mov    %eax,%edx
  8013e5:	09 ca                	or     %ecx,%edx
  8013e7:	09 f2                	or     %esi,%edx
  8013e9:	f6 c2 03             	test   $0x3,%dl
  8013ec:	75 0a                	jne    8013f8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8013ee:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8013f1:	89 c7                	mov    %eax,%edi
  8013f3:	fc                   	cld    
  8013f4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8013f6:	eb 05                	jmp    8013fd <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8013f8:	89 c7                	mov    %eax,%edi
  8013fa:	fc                   	cld    
  8013fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8013fd:	5e                   	pop    %esi
  8013fe:	5f                   	pop    %edi
  8013ff:	5d                   	pop    %ebp
  801400:	c3                   	ret    

00801401 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801407:	ff 75 10             	pushl  0x10(%ebp)
  80140a:	ff 75 0c             	pushl  0xc(%ebp)
  80140d:	ff 75 08             	pushl  0x8(%ebp)
  801410:	e8 8a ff ff ff       	call   80139f <memmove>
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	56                   	push   %esi
  80141b:	53                   	push   %ebx
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801422:	89 c6                	mov    %eax,%esi
  801424:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801427:	39 f0                	cmp    %esi,%eax
  801429:	74 1c                	je     801447 <memcmp+0x30>
		if (*s1 != *s2)
  80142b:	0f b6 08             	movzbl (%eax),%ecx
  80142e:	0f b6 1a             	movzbl (%edx),%ebx
  801431:	38 d9                	cmp    %bl,%cl
  801433:	75 08                	jne    80143d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801435:	83 c0 01             	add    $0x1,%eax
  801438:	83 c2 01             	add    $0x1,%edx
  80143b:	eb ea                	jmp    801427 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80143d:	0f b6 c1             	movzbl %cl,%eax
  801440:	0f b6 db             	movzbl %bl,%ebx
  801443:	29 d8                	sub    %ebx,%eax
  801445:	eb 05                	jmp    80144c <memcmp+0x35>
	}

	return 0;
  801447:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144c:	5b                   	pop    %ebx
  80144d:	5e                   	pop    %esi
  80144e:	5d                   	pop    %ebp
  80144f:	c3                   	ret    

00801450 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801459:	89 c2                	mov    %eax,%edx
  80145b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80145e:	39 d0                	cmp    %edx,%eax
  801460:	73 09                	jae    80146b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801462:	38 08                	cmp    %cl,(%eax)
  801464:	74 05                	je     80146b <memfind+0x1b>
	for (; s < ends; s++)
  801466:	83 c0 01             	add    $0x1,%eax
  801469:	eb f3                	jmp    80145e <memfind+0xe>
			break;
	return (void *) s;
}
  80146b:	5d                   	pop    %ebp
  80146c:	c3                   	ret    

0080146d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	57                   	push   %edi
  801471:	56                   	push   %esi
  801472:	53                   	push   %ebx
  801473:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801476:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801479:	eb 03                	jmp    80147e <strtol+0x11>
		s++;
  80147b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80147e:	0f b6 01             	movzbl (%ecx),%eax
  801481:	3c 20                	cmp    $0x20,%al
  801483:	74 f6                	je     80147b <strtol+0xe>
  801485:	3c 09                	cmp    $0x9,%al
  801487:	74 f2                	je     80147b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801489:	3c 2b                	cmp    $0x2b,%al
  80148b:	74 2a                	je     8014b7 <strtol+0x4a>
	int neg = 0;
  80148d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801492:	3c 2d                	cmp    $0x2d,%al
  801494:	74 2b                	je     8014c1 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801496:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80149c:	75 0f                	jne    8014ad <strtol+0x40>
  80149e:	80 39 30             	cmpb   $0x30,(%ecx)
  8014a1:	74 28                	je     8014cb <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8014a3:	85 db                	test   %ebx,%ebx
  8014a5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014aa:	0f 44 d8             	cmove  %eax,%ebx
  8014ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8014b5:	eb 50                	jmp    801507 <strtol+0x9a>
		s++;
  8014b7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8014ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8014bf:	eb d5                	jmp    801496 <strtol+0x29>
		s++, neg = 1;
  8014c1:	83 c1 01             	add    $0x1,%ecx
  8014c4:	bf 01 00 00 00       	mov    $0x1,%edi
  8014c9:	eb cb                	jmp    801496 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014cb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8014cf:	74 0e                	je     8014df <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8014d1:	85 db                	test   %ebx,%ebx
  8014d3:	75 d8                	jne    8014ad <strtol+0x40>
		s++, base = 8;
  8014d5:	83 c1 01             	add    $0x1,%ecx
  8014d8:	bb 08 00 00 00       	mov    $0x8,%ebx
  8014dd:	eb ce                	jmp    8014ad <strtol+0x40>
		s += 2, base = 16;
  8014df:	83 c1 02             	add    $0x2,%ecx
  8014e2:	bb 10 00 00 00       	mov    $0x10,%ebx
  8014e7:	eb c4                	jmp    8014ad <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8014e9:	8d 72 9f             	lea    -0x61(%edx),%esi
  8014ec:	89 f3                	mov    %esi,%ebx
  8014ee:	80 fb 19             	cmp    $0x19,%bl
  8014f1:	77 29                	ja     80151c <strtol+0xaf>
			dig = *s - 'a' + 10;
  8014f3:	0f be d2             	movsbl %dl,%edx
  8014f6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8014f9:	3b 55 10             	cmp    0x10(%ebp),%edx
  8014fc:	7d 30                	jge    80152e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8014fe:	83 c1 01             	add    $0x1,%ecx
  801501:	0f af 45 10          	imul   0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801507:	0f b6 11             	movzbl (%ecx),%edx
  80150a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80150d:	89 f3                	mov    %esi,%ebx
  80150f:	80 fb 09             	cmp    $0x9,%bl
  801512:	77 d5                	ja     8014e9 <strtol+0x7c>
			dig = *s - '0';
  801514:	0f be d2             	movsbl %dl,%edx
  801517:	83 ea 30             	sub    $0x30,%edx
  80151a:	eb dd                	jmp    8014f9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80151c:	8d 72 bf             	lea    -0x41(%edx),%esi
  80151f:	89 f3                	mov    %esi,%ebx
  801521:	80 fb 19             	cmp    $0x19,%bl
  801524:	77 08                	ja     80152e <strtol+0xc1>
			dig = *s - 'A' + 10;
  801526:	0f be d2             	movsbl %dl,%edx
  801529:	83 ea 37             	sub    $0x37,%edx
  80152c:	eb cb                	jmp    8014f9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80152e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801532:	74 05                	je     801539 <strtol+0xcc>
		*endptr = (char *) s;
  801534:	8b 75 0c             	mov    0xc(%ebp),%esi
  801537:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801539:	89 c2                	mov    %eax,%edx
  80153b:	f7 da                	neg    %edx
  80153d:	85 ff                	test   %edi,%edi
  80153f:	0f 45 c2             	cmovne %edx,%eax
}
  801542:	5b                   	pop    %ebx
  801543:	5e                   	pop    %esi
  801544:	5f                   	pop    %edi
  801545:	5d                   	pop    %ebp
  801546:	c3                   	ret    

00801547 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	57                   	push   %edi
  80154b:	56                   	push   %esi
  80154c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
  801552:	8b 55 08             	mov    0x8(%ebp),%edx
  801555:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801558:	89 c3                	mov    %eax,%ebx
  80155a:	89 c7                	mov    %eax,%edi
  80155c:	89 c6                	mov    %eax,%esi
  80155e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801560:	5b                   	pop    %ebx
  801561:	5e                   	pop    %esi
  801562:	5f                   	pop    %edi
  801563:	5d                   	pop    %ebp
  801564:	c3                   	ret    

00801565 <sys_cgetc>:

int
sys_cgetc(void)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	57                   	push   %edi
  801569:	56                   	push   %esi
  80156a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80156b:	ba 00 00 00 00       	mov    $0x0,%edx
  801570:	b8 01 00 00 00       	mov    $0x1,%eax
  801575:	89 d1                	mov    %edx,%ecx
  801577:	89 d3                	mov    %edx,%ebx
  801579:	89 d7                	mov    %edx,%edi
  80157b:	89 d6                	mov    %edx,%esi
  80157d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80157f:	5b                   	pop    %ebx
  801580:	5e                   	pop    %esi
  801581:	5f                   	pop    %edi
  801582:	5d                   	pop    %ebp
  801583:	c3                   	ret    

00801584 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	57                   	push   %edi
  801588:	56                   	push   %esi
  801589:	53                   	push   %ebx
  80158a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80158d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801592:	8b 55 08             	mov    0x8(%ebp),%edx
  801595:	b8 03 00 00 00       	mov    $0x3,%eax
  80159a:	89 cb                	mov    %ecx,%ebx
  80159c:	89 cf                	mov    %ecx,%edi
  80159e:	89 ce                	mov    %ecx,%esi
  8015a0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015a2:	85 c0                	test   %eax,%eax
  8015a4:	7f 08                	jg     8015ae <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8015a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a9:	5b                   	pop    %ebx
  8015aa:	5e                   	pop    %esi
  8015ab:	5f                   	pop    %edi
  8015ac:	5d                   	pop    %ebp
  8015ad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015ae:	83 ec 0c             	sub    $0xc,%esp
  8015b1:	50                   	push   %eax
  8015b2:	6a 03                	push   $0x3
  8015b4:	68 ef 3d 80 00       	push   $0x803def
  8015b9:	6a 23                	push   $0x23
  8015bb:	68 0c 3e 80 00       	push   $0x803e0c
  8015c0:	e8 a5 f4 ff ff       	call   800a6a <_panic>

008015c5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	57                   	push   %edi
  8015c9:	56                   	push   %esi
  8015ca:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d0:	b8 02 00 00 00       	mov    $0x2,%eax
  8015d5:	89 d1                	mov    %edx,%ecx
  8015d7:	89 d3                	mov    %edx,%ebx
  8015d9:	89 d7                	mov    %edx,%edi
  8015db:	89 d6                	mov    %edx,%esi
  8015dd:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8015df:	5b                   	pop    %ebx
  8015e0:	5e                   	pop    %esi
  8015e1:	5f                   	pop    %edi
  8015e2:	5d                   	pop    %ebp
  8015e3:	c3                   	ret    

008015e4 <sys_yield>:

void
sys_yield(void)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	57                   	push   %edi
  8015e8:	56                   	push   %esi
  8015e9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ef:	b8 0b 00 00 00       	mov    $0xb,%eax
  8015f4:	89 d1                	mov    %edx,%ecx
  8015f6:	89 d3                	mov    %edx,%ebx
  8015f8:	89 d7                	mov    %edx,%edi
  8015fa:	89 d6                	mov    %edx,%esi
  8015fc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8015fe:	5b                   	pop    %ebx
  8015ff:	5e                   	pop    %esi
  801600:	5f                   	pop    %edi
  801601:	5d                   	pop    %ebp
  801602:	c3                   	ret    

00801603 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	57                   	push   %edi
  801607:	56                   	push   %esi
  801608:	53                   	push   %ebx
  801609:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80160c:	be 00 00 00 00       	mov    $0x0,%esi
  801611:	8b 55 08             	mov    0x8(%ebp),%edx
  801614:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801617:	b8 04 00 00 00       	mov    $0x4,%eax
  80161c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80161f:	89 f7                	mov    %esi,%edi
  801621:	cd 30                	int    $0x30
	if(check && ret > 0)
  801623:	85 c0                	test   %eax,%eax
  801625:	7f 08                	jg     80162f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801627:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80162a:	5b                   	pop    %ebx
  80162b:	5e                   	pop    %esi
  80162c:	5f                   	pop    %edi
  80162d:	5d                   	pop    %ebp
  80162e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80162f:	83 ec 0c             	sub    $0xc,%esp
  801632:	50                   	push   %eax
  801633:	6a 04                	push   $0x4
  801635:	68 ef 3d 80 00       	push   $0x803def
  80163a:	6a 23                	push   $0x23
  80163c:	68 0c 3e 80 00       	push   $0x803e0c
  801641:	e8 24 f4 ff ff       	call   800a6a <_panic>

00801646 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	57                   	push   %edi
  80164a:	56                   	push   %esi
  80164b:	53                   	push   %ebx
  80164c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80164f:	8b 55 08             	mov    0x8(%ebp),%edx
  801652:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801655:	b8 05 00 00 00       	mov    $0x5,%eax
  80165a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80165d:	8b 7d 14             	mov    0x14(%ebp),%edi
  801660:	8b 75 18             	mov    0x18(%ebp),%esi
  801663:	cd 30                	int    $0x30
	if(check && ret > 0)
  801665:	85 c0                	test   %eax,%eax
  801667:	7f 08                	jg     801671 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801669:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80166c:	5b                   	pop    %ebx
  80166d:	5e                   	pop    %esi
  80166e:	5f                   	pop    %edi
  80166f:	5d                   	pop    %ebp
  801670:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801671:	83 ec 0c             	sub    $0xc,%esp
  801674:	50                   	push   %eax
  801675:	6a 05                	push   $0x5
  801677:	68 ef 3d 80 00       	push   $0x803def
  80167c:	6a 23                	push   $0x23
  80167e:	68 0c 3e 80 00       	push   $0x803e0c
  801683:	e8 e2 f3 ff ff       	call   800a6a <_panic>

00801688 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	57                   	push   %edi
  80168c:	56                   	push   %esi
  80168d:	53                   	push   %ebx
  80168e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801691:	bb 00 00 00 00       	mov    $0x0,%ebx
  801696:	8b 55 08             	mov    0x8(%ebp),%edx
  801699:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80169c:	b8 06 00 00 00       	mov    $0x6,%eax
  8016a1:	89 df                	mov    %ebx,%edi
  8016a3:	89 de                	mov    %ebx,%esi
  8016a5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	7f 08                	jg     8016b3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8016ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ae:	5b                   	pop    %ebx
  8016af:	5e                   	pop    %esi
  8016b0:	5f                   	pop    %edi
  8016b1:	5d                   	pop    %ebp
  8016b2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016b3:	83 ec 0c             	sub    $0xc,%esp
  8016b6:	50                   	push   %eax
  8016b7:	6a 06                	push   $0x6
  8016b9:	68 ef 3d 80 00       	push   $0x803def
  8016be:	6a 23                	push   $0x23
  8016c0:	68 0c 3e 80 00       	push   $0x803e0c
  8016c5:	e8 a0 f3 ff ff       	call   800a6a <_panic>

008016ca <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	57                   	push   %edi
  8016ce:	56                   	push   %esi
  8016cf:	53                   	push   %ebx
  8016d0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016de:	b8 08 00 00 00       	mov    $0x8,%eax
  8016e3:	89 df                	mov    %ebx,%edi
  8016e5:	89 de                	mov    %ebx,%esi
  8016e7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	7f 08                	jg     8016f5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8016ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f0:	5b                   	pop    %ebx
  8016f1:	5e                   	pop    %esi
  8016f2:	5f                   	pop    %edi
  8016f3:	5d                   	pop    %ebp
  8016f4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016f5:	83 ec 0c             	sub    $0xc,%esp
  8016f8:	50                   	push   %eax
  8016f9:	6a 08                	push   $0x8
  8016fb:	68 ef 3d 80 00       	push   $0x803def
  801700:	6a 23                	push   $0x23
  801702:	68 0c 3e 80 00       	push   $0x803e0c
  801707:	e8 5e f3 ff ff       	call   800a6a <_panic>

0080170c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	57                   	push   %edi
  801710:	56                   	push   %esi
  801711:	53                   	push   %ebx
  801712:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801715:	bb 00 00 00 00       	mov    $0x0,%ebx
  80171a:	8b 55 08             	mov    0x8(%ebp),%edx
  80171d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801720:	b8 09 00 00 00       	mov    $0x9,%eax
  801725:	89 df                	mov    %ebx,%edi
  801727:	89 de                	mov    %ebx,%esi
  801729:	cd 30                	int    $0x30
	if(check && ret > 0)
  80172b:	85 c0                	test   %eax,%eax
  80172d:	7f 08                	jg     801737 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80172f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801732:	5b                   	pop    %ebx
  801733:	5e                   	pop    %esi
  801734:	5f                   	pop    %edi
  801735:	5d                   	pop    %ebp
  801736:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801737:	83 ec 0c             	sub    $0xc,%esp
  80173a:	50                   	push   %eax
  80173b:	6a 09                	push   $0x9
  80173d:	68 ef 3d 80 00       	push   $0x803def
  801742:	6a 23                	push   $0x23
  801744:	68 0c 3e 80 00       	push   $0x803e0c
  801749:	e8 1c f3 ff ff       	call   800a6a <_panic>

0080174e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	57                   	push   %edi
  801752:	56                   	push   %esi
  801753:	53                   	push   %ebx
  801754:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801757:	bb 00 00 00 00       	mov    $0x0,%ebx
  80175c:	8b 55 08             	mov    0x8(%ebp),%edx
  80175f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801762:	b8 0a 00 00 00       	mov    $0xa,%eax
  801767:	89 df                	mov    %ebx,%edi
  801769:	89 de                	mov    %ebx,%esi
  80176b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80176d:	85 c0                	test   %eax,%eax
  80176f:	7f 08                	jg     801779 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801771:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801774:	5b                   	pop    %ebx
  801775:	5e                   	pop    %esi
  801776:	5f                   	pop    %edi
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	50                   	push   %eax
  80177d:	6a 0a                	push   $0xa
  80177f:	68 ef 3d 80 00       	push   $0x803def
  801784:	6a 23                	push   $0x23
  801786:	68 0c 3e 80 00       	push   $0x803e0c
  80178b:	e8 da f2 ff ff       	call   800a6a <_panic>

00801790 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	57                   	push   %edi
  801794:	56                   	push   %esi
  801795:	53                   	push   %ebx
	asm volatile("int %1\n"
  801796:	8b 55 08             	mov    0x8(%ebp),%edx
  801799:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80179c:	b8 0c 00 00 00       	mov    $0xc,%eax
  8017a1:	be 00 00 00 00       	mov    $0x0,%esi
  8017a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017a9:	8b 7d 14             	mov    0x14(%ebp),%edi
  8017ac:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8017ae:	5b                   	pop    %ebx
  8017af:	5e                   	pop    %esi
  8017b0:	5f                   	pop    %edi
  8017b1:	5d                   	pop    %ebp
  8017b2:	c3                   	ret    

008017b3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	57                   	push   %edi
  8017b7:	56                   	push   %esi
  8017b8:	53                   	push   %ebx
  8017b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c4:	b8 0d 00 00 00       	mov    $0xd,%eax
  8017c9:	89 cb                	mov    %ecx,%ebx
  8017cb:	89 cf                	mov    %ecx,%edi
  8017cd:	89 ce                	mov    %ecx,%esi
  8017cf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	7f 08                	jg     8017dd <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8017d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017d8:	5b                   	pop    %ebx
  8017d9:	5e                   	pop    %esi
  8017da:	5f                   	pop    %edi
  8017db:	5d                   	pop    %ebp
  8017dc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017dd:	83 ec 0c             	sub    $0xc,%esp
  8017e0:	50                   	push   %eax
  8017e1:	6a 0d                	push   $0xd
  8017e3:	68 ef 3d 80 00       	push   $0x803def
  8017e8:	6a 23                	push   $0x23
  8017ea:	68 0c 3e 80 00       	push   $0x803e0c
  8017ef:	e8 76 f2 ff ff       	call   800a6a <_panic>

008017f4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	57                   	push   %edi
  8017f8:	56                   	push   %esi
  8017f9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ff:	b8 0e 00 00 00       	mov    $0xe,%eax
  801804:	89 d1                	mov    %edx,%ecx
  801806:	89 d3                	mov    %edx,%ebx
  801808:	89 d7                	mov    %edx,%edi
  80180a:	89 d6                	mov    %edx,%esi
  80180c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80180e:	5b                   	pop    %ebx
  80180f:	5e                   	pop    %esi
  801810:	5f                   	pop    %edi
  801811:	5d                   	pop    %ebp
  801812:	c3                   	ret    

00801813 <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	57                   	push   %edi
  801817:	56                   	push   %esi
  801818:	53                   	push   %ebx
  801819:	83 ec 0c             	sub    $0xc,%esp
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80181f:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  801821:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  801824:	89 d9                	mov    %ebx,%ecx
  801826:	c1 e9 16             	shr    $0x16,%ecx
  801829:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  801830:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  801835:	f6 c1 01             	test   $0x1,%cl
  801838:	74 0c                	je     801846 <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  80183a:	89 d9                	mov    %ebx,%ecx
  80183c:	c1 e9 0c             	shr    $0xc,%ecx
  80183f:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  801846:	f6 c2 02             	test   $0x2,%dl
  801849:	0f 84 a3 00 00 00    	je     8018f2 <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  80184f:	89 da                	mov    %ebx,%edx
  801851:	c1 ea 0c             	shr    $0xc,%edx
  801854:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80185b:	f6 c6 08             	test   $0x8,%dh
  80185e:	0f 84 b7 00 00 00    	je     80191b <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  801864:	e8 5c fd ff ff       	call   8015c5 <sys_getenvid>
  801869:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  80186b:	83 ec 04             	sub    $0x4,%esp
  80186e:	6a 07                	push   $0x7
  801870:	68 00 f0 7f 00       	push   $0x7ff000
  801875:	50                   	push   %eax
  801876:	e8 88 fd ff ff       	call   801603 <sys_page_alloc>
  80187b:	83 c4 10             	add    $0x10,%esp
  80187e:	85 c0                	test   %eax,%eax
  801880:	0f 88 bc 00 00 00    	js     801942 <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  801886:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	68 00 10 00 00       	push   $0x1000
  801894:	53                   	push   %ebx
  801895:	68 00 f0 7f 00       	push   $0x7ff000
  80189a:	e8 00 fb ff ff       	call   80139f <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  80189f:	83 c4 08             	add    $0x8,%esp
  8018a2:	53                   	push   %ebx
  8018a3:	56                   	push   %esi
  8018a4:	e8 df fd ff ff       	call   801688 <sys_page_unmap>
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	0f 88 a0 00 00 00    	js     801954 <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  8018b4:	83 ec 0c             	sub    $0xc,%esp
  8018b7:	6a 07                	push   $0x7
  8018b9:	53                   	push   %ebx
  8018ba:	56                   	push   %esi
  8018bb:	68 00 f0 7f 00       	push   $0x7ff000
  8018c0:	56                   	push   %esi
  8018c1:	e8 80 fd ff ff       	call   801646 <sys_page_map>
  8018c6:	83 c4 20             	add    $0x20,%esp
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	0f 88 95 00 00 00    	js     801966 <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  8018d1:	83 ec 08             	sub    $0x8,%esp
  8018d4:	68 00 f0 7f 00       	push   $0x7ff000
  8018d9:	56                   	push   %esi
  8018da:	e8 a9 fd ff ff       	call   801688 <sys_page_unmap>
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	0f 88 8e 00 00 00    	js     801978 <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  8018ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5f                   	pop    %edi
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  8018f2:	8b 70 28             	mov    0x28(%eax),%esi
  8018f5:	e8 cb fc ff ff       	call   8015c5 <sys_getenvid>
  8018fa:	56                   	push   %esi
  8018fb:	53                   	push   %ebx
  8018fc:	50                   	push   %eax
  8018fd:	68 1c 3e 80 00       	push   $0x803e1c
  801902:	e8 3e f2 ff ff       	call   800b45 <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  801907:	83 c4 0c             	add    $0xc,%esp
  80190a:	68 40 3e 80 00       	push   $0x803e40
  80190f:	6a 27                	push   $0x27
  801911:	68 14 3f 80 00       	push   $0x803f14
  801916:	e8 4f f1 ff ff       	call   800a6a <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  80191b:	8b 78 28             	mov    0x28(%eax),%edi
  80191e:	e8 a2 fc ff ff       	call   8015c5 <sys_getenvid>
  801923:	57                   	push   %edi
  801924:	53                   	push   %ebx
  801925:	50                   	push   %eax
  801926:	68 1c 3e 80 00       	push   $0x803e1c
  80192b:	e8 15 f2 ff ff       	call   800b45 <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  801930:	56                   	push   %esi
  801931:	68 74 3e 80 00       	push   $0x803e74
  801936:	6a 2b                	push   $0x2b
  801938:	68 14 3f 80 00       	push   $0x803f14
  80193d:	e8 28 f1 ff ff       	call   800a6a <_panic>
      panic("pgfault: page allocation failed %e", r);
  801942:	50                   	push   %eax
  801943:	68 ac 3e 80 00       	push   $0x803eac
  801948:	6a 39                	push   $0x39
  80194a:	68 14 3f 80 00       	push   $0x803f14
  80194f:	e8 16 f1 ff ff       	call   800a6a <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  801954:	50                   	push   %eax
  801955:	68 d0 3e 80 00       	push   $0x803ed0
  80195a:	6a 3e                	push   $0x3e
  80195c:	68 14 3f 80 00       	push   $0x803f14
  801961:	e8 04 f1 ff ff       	call   800a6a <_panic>
      panic("pgfault: page map failed (%e)", r);
  801966:	50                   	push   %eax
  801967:	68 1f 3f 80 00       	push   $0x803f1f
  80196c:	6a 40                	push   $0x40
  80196e:	68 14 3f 80 00       	push   $0x803f14
  801973:	e8 f2 f0 ff ff       	call   800a6a <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  801978:	50                   	push   %eax
  801979:	68 d0 3e 80 00       	push   $0x803ed0
  80197e:	6a 42                	push   $0x42
  801980:	68 14 3f 80 00       	push   $0x803f14
  801985:	e8 e0 f0 ff ff       	call   800a6a <_panic>

0080198a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	57                   	push   %edi
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
  801990:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  801993:	68 13 18 80 00       	push   $0x801813
  801998:	e8 bf 1a 00 00       	call   80345c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80199d:	b8 07 00 00 00       	mov    $0x7,%eax
  8019a2:	cd 30                	int    $0x30
  8019a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  8019a7:	83 c4 10             	add    $0x10,%esp
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	78 2d                	js     8019db <fork+0x51>
  8019ae:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8019b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  8019b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019b9:	0f 85 a6 00 00 00    	jne    801a65 <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  8019bf:	e8 01 fc ff ff       	call   8015c5 <sys_getenvid>
  8019c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8019c9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8019cc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8019d1:	a3 28 64 80 00       	mov    %eax,0x806428
      return 0;
  8019d6:	e9 79 01 00 00       	jmp    801b54 <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  8019db:	50                   	push   %eax
  8019dc:	68 3a 39 80 00       	push   $0x80393a
  8019e1:	68 aa 00 00 00       	push   $0xaa
  8019e6:	68 14 3f 80 00       	push   $0x803f14
  8019eb:	e8 7a f0 ff ff       	call   800a6a <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  8019f0:	83 ec 0c             	sub    $0xc,%esp
  8019f3:	6a 05                	push   $0x5
  8019f5:	53                   	push   %ebx
  8019f6:	57                   	push   %edi
  8019f7:	53                   	push   %ebx
  8019f8:	6a 00                	push   $0x0
  8019fa:	e8 47 fc ff ff       	call   801646 <sys_page_map>
  8019ff:	83 c4 20             	add    $0x20,%esp
  801a02:	85 c0                	test   %eax,%eax
  801a04:	79 4d                	jns    801a53 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  801a06:	50                   	push   %eax
  801a07:	68 3d 3f 80 00       	push   $0x803f3d
  801a0c:	6a 61                	push   $0x61
  801a0e:	68 14 3f 80 00       	push   $0x803f14
  801a13:	e8 52 f0 ff ff       	call   800a6a <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  801a18:	83 ec 0c             	sub    $0xc,%esp
  801a1b:	68 05 08 00 00       	push   $0x805
  801a20:	53                   	push   %ebx
  801a21:	57                   	push   %edi
  801a22:	53                   	push   %ebx
  801a23:	6a 00                	push   $0x0
  801a25:	e8 1c fc ff ff       	call   801646 <sys_page_map>
  801a2a:	83 c4 20             	add    $0x20,%esp
  801a2d:	85 c0                	test   %eax,%eax
  801a2f:	0f 88 b7 00 00 00    	js     801aec <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  801a35:	83 ec 0c             	sub    $0xc,%esp
  801a38:	68 05 08 00 00       	push   $0x805
  801a3d:	53                   	push   %ebx
  801a3e:	6a 00                	push   $0x0
  801a40:	53                   	push   %ebx
  801a41:	6a 00                	push   $0x0
  801a43:	e8 fe fb ff ff       	call   801646 <sys_page_map>
  801a48:	83 c4 20             	add    $0x20,%esp
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	0f 88 ab 00 00 00    	js     801afe <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801a53:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a59:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801a5f:	0f 84 ab 00 00 00    	je     801b10 <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  801a65:	89 d8                	mov    %ebx,%eax
  801a67:	c1 e8 16             	shr    $0x16,%eax
  801a6a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a71:	a8 01                	test   $0x1,%al
  801a73:	74 de                	je     801a53 <fork+0xc9>
  801a75:	89 d8                	mov    %ebx,%eax
  801a77:	c1 e8 0c             	shr    $0xc,%eax
  801a7a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a81:	f6 c2 01             	test   $0x1,%dl
  801a84:	74 cd                	je     801a53 <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  801a86:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  801a89:	89 c2                	mov    %eax,%edx
  801a8b:	c1 ea 16             	shr    $0x16,%edx
  801a8e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801a95:	f6 c2 01             	test   $0x1,%dl
  801a98:	74 b9                	je     801a53 <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  801a9a:	c1 e8 0c             	shr    $0xc,%eax
  801a9d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  801aa4:	a8 01                	test   $0x1,%al
  801aa6:	74 ab                	je     801a53 <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  801aa8:	a9 02 08 00 00       	test   $0x802,%eax
  801aad:	0f 84 3d ff ff ff    	je     8019f0 <fork+0x66>
	else if(pte & PTE_SHARE)
  801ab3:	f6 c4 04             	test   $0x4,%ah
  801ab6:	0f 84 5c ff ff ff    	je     801a18 <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801abc:	83 ec 0c             	sub    $0xc,%esp
  801abf:	25 07 0e 00 00       	and    $0xe07,%eax
  801ac4:	50                   	push   %eax
  801ac5:	53                   	push   %ebx
  801ac6:	57                   	push   %edi
  801ac7:	53                   	push   %ebx
  801ac8:	6a 00                	push   $0x0
  801aca:	e8 77 fb ff ff       	call   801646 <sys_page_map>
  801acf:	83 c4 20             	add    $0x20,%esp
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	0f 89 79 ff ff ff    	jns    801a53 <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  801ada:	50                   	push   %eax
  801adb:	68 3d 3f 80 00       	push   $0x803f3d
  801ae0:	6a 67                	push   $0x67
  801ae2:	68 14 3f 80 00       	push   $0x803f14
  801ae7:	e8 7e ef ff ff       	call   800a6a <_panic>
			panic("Page Map Failed: %e", error_code);
  801aec:	50                   	push   %eax
  801aed:	68 3d 3f 80 00       	push   $0x803f3d
  801af2:	6a 6d                	push   $0x6d
  801af4:	68 14 3f 80 00       	push   $0x803f14
  801af9:	e8 6c ef ff ff       	call   800a6a <_panic>
			panic("Page Map Failed: %e", error_code);
  801afe:	50                   	push   %eax
  801aff:	68 3d 3f 80 00       	push   $0x803f3d
  801b04:	6a 70                	push   $0x70
  801b06:	68 14 3f 80 00       	push   $0x803f14
  801b0b:	e8 5a ef ff ff       	call   800a6a <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801b10:	83 ec 04             	sub    $0x4,%esp
  801b13:	6a 07                	push   $0x7
  801b15:	68 00 f0 bf ee       	push   $0xeebff000
  801b1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b1d:	e8 e1 fa ff ff       	call   801603 <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  801b22:	83 c4 10             	add    $0x10,%esp
  801b25:	85 c0                	test   %eax,%eax
  801b27:	78 36                	js     801b5f <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801b29:	83 ec 08             	sub    $0x8,%esp
  801b2c:	68 d2 34 80 00       	push   $0x8034d2
  801b31:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b34:	e8 15 fc ff ff       	call   80174e <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801b39:	83 c4 10             	add    $0x10,%esp
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	78 34                	js     801b74 <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801b40:	83 ec 08             	sub    $0x8,%esp
  801b43:	6a 02                	push   $0x2
  801b45:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b48:	e8 7d fb ff ff       	call   8016ca <sys_env_set_status>
  801b4d:	83 c4 10             	add    $0x10,%esp
  801b50:	85 c0                	test   %eax,%eax
  801b52:	78 35                	js     801b89 <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  801b54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b5a:	5b                   	pop    %ebx
  801b5b:	5e                   	pop    %esi
  801b5c:	5f                   	pop    %edi
  801b5d:	5d                   	pop    %ebp
  801b5e:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  801b5f:	50                   	push   %eax
  801b60:	68 3a 39 80 00       	push   $0x80393a
  801b65:	68 ba 00 00 00       	push   $0xba
  801b6a:	68 14 3f 80 00       	push   $0x803f14
  801b6f:	e8 f6 ee ff ff       	call   800a6a <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801b74:	50                   	push   %eax
  801b75:	68 f0 3e 80 00       	push   $0x803ef0
  801b7a:	68 bf 00 00 00       	push   $0xbf
  801b7f:	68 14 3f 80 00       	push   $0x803f14
  801b84:	e8 e1 ee ff ff       	call   800a6a <_panic>
      panic("sys_env_set_status: %e", r);
  801b89:	50                   	push   %eax
  801b8a:	68 51 3f 80 00       	push   $0x803f51
  801b8f:	68 c3 00 00 00       	push   $0xc3
  801b94:	68 14 3f 80 00       	push   $0x803f14
  801b99:	e8 cc ee ff ff       	call   800a6a <_panic>

00801b9e <sfork>:

// Challenge!
int
sfork(void)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801ba4:	68 68 3f 80 00       	push   $0x803f68
  801ba9:	68 cc 00 00 00       	push   $0xcc
  801bae:	68 14 3f 80 00       	push   $0x803f14
  801bb3:	e8 b2 ee ff ff       	call   800a6a <_panic>

00801bb8 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bc1:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801bc4:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801bc6:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801bc9:	83 3a 01             	cmpl   $0x1,(%edx)
  801bcc:	7e 09                	jle    801bd7 <argstart+0x1f>
  801bce:	ba c1 38 80 00       	mov    $0x8038c1,%edx
  801bd3:	85 c9                	test   %ecx,%ecx
  801bd5:	75 05                	jne    801bdc <argstart+0x24>
  801bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bdc:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801bdf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801be6:	5d                   	pop    %ebp
  801be7:	c3                   	ret    

00801be8 <argnext>:

int
argnext(struct Argstate *args)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	53                   	push   %ebx
  801bec:	83 ec 04             	sub    $0x4,%esp
  801bef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801bf2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801bf9:	8b 43 08             	mov    0x8(%ebx),%eax
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	74 72                	je     801c72 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801c00:	80 38 00             	cmpb   $0x0,(%eax)
  801c03:	75 48                	jne    801c4d <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801c05:	8b 0b                	mov    (%ebx),%ecx
  801c07:	83 39 01             	cmpl   $0x1,(%ecx)
  801c0a:	74 58                	je     801c64 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801c0c:	8b 53 04             	mov    0x4(%ebx),%edx
  801c0f:	8b 42 04             	mov    0x4(%edx),%eax
  801c12:	80 38 2d             	cmpb   $0x2d,(%eax)
  801c15:	75 4d                	jne    801c64 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801c17:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801c1b:	74 47                	je     801c64 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801c1d:	83 c0 01             	add    $0x1,%eax
  801c20:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	8b 01                	mov    (%ecx),%eax
  801c28:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801c2f:	50                   	push   %eax
  801c30:	8d 42 08             	lea    0x8(%edx),%eax
  801c33:	50                   	push   %eax
  801c34:	83 c2 04             	add    $0x4,%edx
  801c37:	52                   	push   %edx
  801c38:	e8 62 f7 ff ff       	call   80139f <memmove>
		(*args->argc)--;
  801c3d:	8b 03                	mov    (%ebx),%eax
  801c3f:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801c42:	8b 43 08             	mov    0x8(%ebx),%eax
  801c45:	83 c4 10             	add    $0x10,%esp
  801c48:	80 38 2d             	cmpb   $0x2d,(%eax)
  801c4b:	74 11                	je     801c5e <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801c4d:	8b 53 08             	mov    0x8(%ebx),%edx
  801c50:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801c53:	83 c2 01             	add    $0x1,%edx
  801c56:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801c59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801c5e:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801c62:	75 e9                	jne    801c4d <argnext+0x65>
	args->curarg = 0;
  801c64:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801c6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c70:	eb e7                	jmp    801c59 <argnext+0x71>
		return -1;
  801c72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c77:	eb e0                	jmp    801c59 <argnext+0x71>

00801c79 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	53                   	push   %ebx
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801c83:	8b 43 08             	mov    0x8(%ebx),%eax
  801c86:	85 c0                	test   %eax,%eax
  801c88:	74 5b                	je     801ce5 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  801c8a:	80 38 00             	cmpb   $0x0,(%eax)
  801c8d:	74 12                	je     801ca1 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801c8f:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801c92:	c7 43 08 c1 38 80 00 	movl   $0x8038c1,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801c99:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801c9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    
	} else if (*args->argc > 1) {
  801ca1:	8b 13                	mov    (%ebx),%edx
  801ca3:	83 3a 01             	cmpl   $0x1,(%edx)
  801ca6:	7f 10                	jg     801cb8 <argnextvalue+0x3f>
		args->argvalue = 0;
  801ca8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801caf:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801cb6:	eb e1                	jmp    801c99 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801cb8:	8b 43 04             	mov    0x4(%ebx),%eax
  801cbb:	8b 48 04             	mov    0x4(%eax),%ecx
  801cbe:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801cc1:	83 ec 04             	sub    $0x4,%esp
  801cc4:	8b 12                	mov    (%edx),%edx
  801cc6:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801ccd:	52                   	push   %edx
  801cce:	8d 50 08             	lea    0x8(%eax),%edx
  801cd1:	52                   	push   %edx
  801cd2:	83 c0 04             	add    $0x4,%eax
  801cd5:	50                   	push   %eax
  801cd6:	e8 c4 f6 ff ff       	call   80139f <memmove>
		(*args->argc)--;
  801cdb:	8b 03                	mov    (%ebx),%eax
  801cdd:	83 28 01             	subl   $0x1,(%eax)
  801ce0:	83 c4 10             	add    $0x10,%esp
  801ce3:	eb b4                	jmp    801c99 <argnextvalue+0x20>
		return 0;
  801ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cea:	eb b0                	jmp    801c9c <argnextvalue+0x23>

00801cec <argvalue>:
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	83 ec 08             	sub    $0x8,%esp
  801cf2:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801cf5:	8b 42 0c             	mov    0xc(%edx),%eax
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	74 02                	je     801cfe <argvalue+0x12>
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801cfe:	83 ec 0c             	sub    $0xc,%esp
  801d01:	52                   	push   %edx
  801d02:	e8 72 ff ff ff       	call   801c79 <argnextvalue>
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	eb f0                	jmp    801cfc <argvalue+0x10>

00801d0c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	05 00 00 00 30       	add    $0x30000000,%eax
  801d17:	c1 e8 0c             	shr    $0xc,%eax
}
  801d1a:	5d                   	pop    %ebp
  801d1b:	c3                   	ret    

00801d1c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801d27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d2c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801d31:	5d                   	pop    %ebp
  801d32:	c3                   	ret    

00801d33 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d3b:	89 c2                	mov    %eax,%edx
  801d3d:	c1 ea 16             	shr    $0x16,%edx
  801d40:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801d47:	f6 c2 01             	test   $0x1,%dl
  801d4a:	74 2d                	je     801d79 <fd_alloc+0x46>
  801d4c:	89 c2                	mov    %eax,%edx
  801d4e:	c1 ea 0c             	shr    $0xc,%edx
  801d51:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d58:	f6 c2 01             	test   $0x1,%dl
  801d5b:	74 1c                	je     801d79 <fd_alloc+0x46>
  801d5d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801d62:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801d67:	75 d2                	jne    801d3b <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801d72:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801d77:	eb 0a                	jmp    801d83 <fd_alloc+0x50>
			*fd_store = fd;
  801d79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d7c:	89 01                	mov    %eax,(%ecx)
			return 0;
  801d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d83:	5d                   	pop    %ebp
  801d84:	c3                   	ret    

00801d85 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d8b:	83 f8 1f             	cmp    $0x1f,%eax
  801d8e:	77 30                	ja     801dc0 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801d90:	c1 e0 0c             	shl    $0xc,%eax
  801d93:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d98:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801d9e:	f6 c2 01             	test   $0x1,%dl
  801da1:	74 24                	je     801dc7 <fd_lookup+0x42>
  801da3:	89 c2                	mov    %eax,%edx
  801da5:	c1 ea 0c             	shr    $0xc,%edx
  801da8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801daf:	f6 c2 01             	test   $0x1,%dl
  801db2:	74 1a                	je     801dce <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801db4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db7:	89 02                	mov    %eax,(%edx)
	return 0;
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    
		return -E_INVAL;
  801dc0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dc5:	eb f7                	jmp    801dbe <fd_lookup+0x39>
		return -E_INVAL;
  801dc7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dcc:	eb f0                	jmp    801dbe <fd_lookup+0x39>
  801dce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dd3:	eb e9                	jmp    801dbe <fd_lookup+0x39>

00801dd5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 08             	sub    $0x8,%esp
  801ddb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801dde:	ba 00 00 00 00       	mov    $0x0,%edx
  801de3:	b8 20 50 80 00       	mov    $0x805020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801de8:	39 08                	cmp    %ecx,(%eax)
  801dea:	74 38                	je     801e24 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801dec:	83 c2 01             	add    $0x1,%edx
  801def:	8b 04 95 fc 3f 80 00 	mov    0x803ffc(,%edx,4),%eax
  801df6:	85 c0                	test   %eax,%eax
  801df8:	75 ee                	jne    801de8 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801dfa:	a1 28 64 80 00       	mov    0x806428,%eax
  801dff:	8b 40 48             	mov    0x48(%eax),%eax
  801e02:	83 ec 04             	sub    $0x4,%esp
  801e05:	51                   	push   %ecx
  801e06:	50                   	push   %eax
  801e07:	68 80 3f 80 00       	push   $0x803f80
  801e0c:	e8 34 ed ff ff       	call   800b45 <cprintf>
	*dev = 0;
  801e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801e1a:	83 c4 10             	add    $0x10,%esp
  801e1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    
			*dev = devtab[i];
  801e24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e27:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e29:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2e:	eb f2                	jmp    801e22 <dev_lookup+0x4d>

00801e30 <fd_close>:
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	57                   	push   %edi
  801e34:	56                   	push   %esi
  801e35:	53                   	push   %ebx
  801e36:	83 ec 24             	sub    $0x24,%esp
  801e39:	8b 75 08             	mov    0x8(%ebp),%esi
  801e3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e3f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801e42:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e43:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801e49:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e4c:	50                   	push   %eax
  801e4d:	e8 33 ff ff ff       	call   801d85 <fd_lookup>
  801e52:	89 c3                	mov    %eax,%ebx
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	85 c0                	test   %eax,%eax
  801e59:	78 05                	js     801e60 <fd_close+0x30>
	    || fd != fd2)
  801e5b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801e5e:	74 16                	je     801e76 <fd_close+0x46>
		return (must_exist ? r : 0);
  801e60:	89 f8                	mov    %edi,%eax
  801e62:	84 c0                	test   %al,%al
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
  801e69:	0f 44 d8             	cmove  %eax,%ebx
}
  801e6c:	89 d8                	mov    %ebx,%eax
  801e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e71:	5b                   	pop    %ebx
  801e72:	5e                   	pop    %esi
  801e73:	5f                   	pop    %edi
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e76:	83 ec 08             	sub    $0x8,%esp
  801e79:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801e7c:	50                   	push   %eax
  801e7d:	ff 36                	pushl  (%esi)
  801e7f:	e8 51 ff ff ff       	call   801dd5 <dev_lookup>
  801e84:	89 c3                	mov    %eax,%ebx
  801e86:	83 c4 10             	add    $0x10,%esp
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	78 1a                	js     801ea7 <fd_close+0x77>
		if (dev->dev_close)
  801e8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e90:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801e93:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	74 0b                	je     801ea7 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801e9c:	83 ec 0c             	sub    $0xc,%esp
  801e9f:	56                   	push   %esi
  801ea0:	ff d0                	call   *%eax
  801ea2:	89 c3                	mov    %eax,%ebx
  801ea4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801ea7:	83 ec 08             	sub    $0x8,%esp
  801eaa:	56                   	push   %esi
  801eab:	6a 00                	push   $0x0
  801ead:	e8 d6 f7 ff ff       	call   801688 <sys_page_unmap>
	return r;
  801eb2:	83 c4 10             	add    $0x10,%esp
  801eb5:	eb b5                	jmp    801e6c <fd_close+0x3c>

00801eb7 <close>:

int
close(int fdnum)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ebd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec0:	50                   	push   %eax
  801ec1:	ff 75 08             	pushl  0x8(%ebp)
  801ec4:	e8 bc fe ff ff       	call   801d85 <fd_lookup>
  801ec9:	83 c4 10             	add    $0x10,%esp
  801ecc:	85 c0                	test   %eax,%eax
  801ece:	79 02                	jns    801ed2 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    
		return fd_close(fd, 1);
  801ed2:	83 ec 08             	sub    $0x8,%esp
  801ed5:	6a 01                	push   $0x1
  801ed7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eda:	e8 51 ff ff ff       	call   801e30 <fd_close>
  801edf:	83 c4 10             	add    $0x10,%esp
  801ee2:	eb ec                	jmp    801ed0 <close+0x19>

00801ee4 <close_all>:

void
close_all(void)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	53                   	push   %ebx
  801ee8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801eeb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801ef0:	83 ec 0c             	sub    $0xc,%esp
  801ef3:	53                   	push   %ebx
  801ef4:	e8 be ff ff ff       	call   801eb7 <close>
	for (i = 0; i < MAXFD; i++)
  801ef9:	83 c3 01             	add    $0x1,%ebx
  801efc:	83 c4 10             	add    $0x10,%esp
  801eff:	83 fb 20             	cmp    $0x20,%ebx
  801f02:	75 ec                	jne    801ef0 <close_all+0xc>
}
  801f04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	57                   	push   %edi
  801f0d:	56                   	push   %esi
  801f0e:	53                   	push   %ebx
  801f0f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f12:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f15:	50                   	push   %eax
  801f16:	ff 75 08             	pushl  0x8(%ebp)
  801f19:	e8 67 fe ff ff       	call   801d85 <fd_lookup>
  801f1e:	89 c3                	mov    %eax,%ebx
  801f20:	83 c4 10             	add    $0x10,%esp
  801f23:	85 c0                	test   %eax,%eax
  801f25:	0f 88 81 00 00 00    	js     801fac <dup+0xa3>
		return r;
	close(newfdnum);
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	ff 75 0c             	pushl  0xc(%ebp)
  801f31:	e8 81 ff ff ff       	call   801eb7 <close>

	newfd = INDEX2FD(newfdnum);
  801f36:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f39:	c1 e6 0c             	shl    $0xc,%esi
  801f3c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801f42:	83 c4 04             	add    $0x4,%esp
  801f45:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f48:	e8 cf fd ff ff       	call   801d1c <fd2data>
  801f4d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801f4f:	89 34 24             	mov    %esi,(%esp)
  801f52:	e8 c5 fd ff ff       	call   801d1c <fd2data>
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f5c:	89 d8                	mov    %ebx,%eax
  801f5e:	c1 e8 16             	shr    $0x16,%eax
  801f61:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f68:	a8 01                	test   $0x1,%al
  801f6a:	74 11                	je     801f7d <dup+0x74>
  801f6c:	89 d8                	mov    %ebx,%eax
  801f6e:	c1 e8 0c             	shr    $0xc,%eax
  801f71:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f78:	f6 c2 01             	test   $0x1,%dl
  801f7b:	75 39                	jne    801fb6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f80:	89 d0                	mov    %edx,%eax
  801f82:	c1 e8 0c             	shr    $0xc,%eax
  801f85:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f8c:	83 ec 0c             	sub    $0xc,%esp
  801f8f:	25 07 0e 00 00       	and    $0xe07,%eax
  801f94:	50                   	push   %eax
  801f95:	56                   	push   %esi
  801f96:	6a 00                	push   $0x0
  801f98:	52                   	push   %edx
  801f99:	6a 00                	push   $0x0
  801f9b:	e8 a6 f6 ff ff       	call   801646 <sys_page_map>
  801fa0:	89 c3                	mov    %eax,%ebx
  801fa2:	83 c4 20             	add    $0x20,%esp
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	78 31                	js     801fda <dup+0xd1>
		goto err;

	return newfdnum;
  801fa9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801fac:	89 d8                	mov    %ebx,%eax
  801fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fb1:	5b                   	pop    %ebx
  801fb2:	5e                   	pop    %esi
  801fb3:	5f                   	pop    %edi
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801fb6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	25 07 0e 00 00       	and    $0xe07,%eax
  801fc5:	50                   	push   %eax
  801fc6:	57                   	push   %edi
  801fc7:	6a 00                	push   $0x0
  801fc9:	53                   	push   %ebx
  801fca:	6a 00                	push   $0x0
  801fcc:	e8 75 f6 ff ff       	call   801646 <sys_page_map>
  801fd1:	89 c3                	mov    %eax,%ebx
  801fd3:	83 c4 20             	add    $0x20,%esp
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	79 a3                	jns    801f7d <dup+0x74>
	sys_page_unmap(0, newfd);
  801fda:	83 ec 08             	sub    $0x8,%esp
  801fdd:	56                   	push   %esi
  801fde:	6a 00                	push   $0x0
  801fe0:	e8 a3 f6 ff ff       	call   801688 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801fe5:	83 c4 08             	add    $0x8,%esp
  801fe8:	57                   	push   %edi
  801fe9:	6a 00                	push   $0x0
  801feb:	e8 98 f6 ff ff       	call   801688 <sys_page_unmap>
	return r;
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	eb b7                	jmp    801fac <dup+0xa3>

00801ff5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	53                   	push   %ebx
  801ff9:	83 ec 1c             	sub    $0x1c,%esp
  801ffc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801fff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802002:	50                   	push   %eax
  802003:	53                   	push   %ebx
  802004:	e8 7c fd ff ff       	call   801d85 <fd_lookup>
  802009:	83 c4 10             	add    $0x10,%esp
  80200c:	85 c0                	test   %eax,%eax
  80200e:	78 3f                	js     80204f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802010:	83 ec 08             	sub    $0x8,%esp
  802013:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802016:	50                   	push   %eax
  802017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201a:	ff 30                	pushl  (%eax)
  80201c:	e8 b4 fd ff ff       	call   801dd5 <dev_lookup>
  802021:	83 c4 10             	add    $0x10,%esp
  802024:	85 c0                	test   %eax,%eax
  802026:	78 27                	js     80204f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802028:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80202b:	8b 42 08             	mov    0x8(%edx),%eax
  80202e:	83 e0 03             	and    $0x3,%eax
  802031:	83 f8 01             	cmp    $0x1,%eax
  802034:	74 1e                	je     802054 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	8b 40 08             	mov    0x8(%eax),%eax
  80203c:	85 c0                	test   %eax,%eax
  80203e:	74 35                	je     802075 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802040:	83 ec 04             	sub    $0x4,%esp
  802043:	ff 75 10             	pushl  0x10(%ebp)
  802046:	ff 75 0c             	pushl  0xc(%ebp)
  802049:	52                   	push   %edx
  80204a:	ff d0                	call   *%eax
  80204c:	83 c4 10             	add    $0x10,%esp
}
  80204f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802052:	c9                   	leave  
  802053:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802054:	a1 28 64 80 00       	mov    0x806428,%eax
  802059:	8b 40 48             	mov    0x48(%eax),%eax
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	53                   	push   %ebx
  802060:	50                   	push   %eax
  802061:	68 c1 3f 80 00       	push   $0x803fc1
  802066:	e8 da ea ff ff       	call   800b45 <cprintf>
		return -E_INVAL;
  80206b:	83 c4 10             	add    $0x10,%esp
  80206e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802073:	eb da                	jmp    80204f <read+0x5a>
		return -E_NOT_SUPP;
  802075:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80207a:	eb d3                	jmp    80204f <read+0x5a>

0080207c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	57                   	push   %edi
  802080:	56                   	push   %esi
  802081:	53                   	push   %ebx
  802082:	83 ec 0c             	sub    $0xc,%esp
  802085:	8b 7d 08             	mov    0x8(%ebp),%edi
  802088:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80208b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802090:	39 f3                	cmp    %esi,%ebx
  802092:	73 23                	jae    8020b7 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802094:	83 ec 04             	sub    $0x4,%esp
  802097:	89 f0                	mov    %esi,%eax
  802099:	29 d8                	sub    %ebx,%eax
  80209b:	50                   	push   %eax
  80209c:	89 d8                	mov    %ebx,%eax
  80209e:	03 45 0c             	add    0xc(%ebp),%eax
  8020a1:	50                   	push   %eax
  8020a2:	57                   	push   %edi
  8020a3:	e8 4d ff ff ff       	call   801ff5 <read>
		if (m < 0)
  8020a8:	83 c4 10             	add    $0x10,%esp
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	78 06                	js     8020b5 <readn+0x39>
			return m;
		if (m == 0)
  8020af:	74 06                	je     8020b7 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8020b1:	01 c3                	add    %eax,%ebx
  8020b3:	eb db                	jmp    802090 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8020b5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8020b7:	89 d8                	mov    %ebx,%eax
  8020b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020bc:	5b                   	pop    %ebx
  8020bd:	5e                   	pop    %esi
  8020be:	5f                   	pop    %edi
  8020bf:	5d                   	pop    %ebp
  8020c0:	c3                   	ret    

008020c1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	53                   	push   %ebx
  8020c5:	83 ec 1c             	sub    $0x1c,%esp
  8020c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020ce:	50                   	push   %eax
  8020cf:	53                   	push   %ebx
  8020d0:	e8 b0 fc ff ff       	call   801d85 <fd_lookup>
  8020d5:	83 c4 10             	add    $0x10,%esp
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	78 3a                	js     802116 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020dc:	83 ec 08             	sub    $0x8,%esp
  8020df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e2:	50                   	push   %eax
  8020e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e6:	ff 30                	pushl  (%eax)
  8020e8:	e8 e8 fc ff ff       	call   801dd5 <dev_lookup>
  8020ed:	83 c4 10             	add    $0x10,%esp
  8020f0:	85 c0                	test   %eax,%eax
  8020f2:	78 22                	js     802116 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8020fb:	74 1e                	je     80211b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8020fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802100:	8b 52 0c             	mov    0xc(%edx),%edx
  802103:	85 d2                	test   %edx,%edx
  802105:	74 35                	je     80213c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802107:	83 ec 04             	sub    $0x4,%esp
  80210a:	ff 75 10             	pushl  0x10(%ebp)
  80210d:	ff 75 0c             	pushl  0xc(%ebp)
  802110:	50                   	push   %eax
  802111:	ff d2                	call   *%edx
  802113:	83 c4 10             	add    $0x10,%esp
}
  802116:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802119:	c9                   	leave  
  80211a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80211b:	a1 28 64 80 00       	mov    0x806428,%eax
  802120:	8b 40 48             	mov    0x48(%eax),%eax
  802123:	83 ec 04             	sub    $0x4,%esp
  802126:	53                   	push   %ebx
  802127:	50                   	push   %eax
  802128:	68 dd 3f 80 00       	push   $0x803fdd
  80212d:	e8 13 ea ff ff       	call   800b45 <cprintf>
		return -E_INVAL;
  802132:	83 c4 10             	add    $0x10,%esp
  802135:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80213a:	eb da                	jmp    802116 <write+0x55>
		return -E_NOT_SUPP;
  80213c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802141:	eb d3                	jmp    802116 <write+0x55>

00802143 <seek>:

int
seek(int fdnum, off_t offset)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802149:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214c:	50                   	push   %eax
  80214d:	ff 75 08             	pushl  0x8(%ebp)
  802150:	e8 30 fc ff ff       	call   801d85 <fd_lookup>
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	85 c0                	test   %eax,%eax
  80215a:	78 0e                	js     80216a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80215c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802165:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	53                   	push   %ebx
  802170:	83 ec 1c             	sub    $0x1c,%esp
  802173:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802176:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802179:	50                   	push   %eax
  80217a:	53                   	push   %ebx
  80217b:	e8 05 fc ff ff       	call   801d85 <fd_lookup>
  802180:	83 c4 10             	add    $0x10,%esp
  802183:	85 c0                	test   %eax,%eax
  802185:	78 37                	js     8021be <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802187:	83 ec 08             	sub    $0x8,%esp
  80218a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80218d:	50                   	push   %eax
  80218e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802191:	ff 30                	pushl  (%eax)
  802193:	e8 3d fc ff ff       	call   801dd5 <dev_lookup>
  802198:	83 c4 10             	add    $0x10,%esp
  80219b:	85 c0                	test   %eax,%eax
  80219d:	78 1f                	js     8021be <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80219f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8021a6:	74 1b                	je     8021c3 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8021a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ab:	8b 52 18             	mov    0x18(%edx),%edx
  8021ae:	85 d2                	test   %edx,%edx
  8021b0:	74 32                	je     8021e4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8021b2:	83 ec 08             	sub    $0x8,%esp
  8021b5:	ff 75 0c             	pushl  0xc(%ebp)
  8021b8:	50                   	push   %eax
  8021b9:	ff d2                	call   *%edx
  8021bb:	83 c4 10             	add    $0x10,%esp
}
  8021be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    
			thisenv->env_id, fdnum);
  8021c3:	a1 28 64 80 00       	mov    0x806428,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8021c8:	8b 40 48             	mov    0x48(%eax),%eax
  8021cb:	83 ec 04             	sub    $0x4,%esp
  8021ce:	53                   	push   %ebx
  8021cf:	50                   	push   %eax
  8021d0:	68 a0 3f 80 00       	push   $0x803fa0
  8021d5:	e8 6b e9 ff ff       	call   800b45 <cprintf>
		return -E_INVAL;
  8021da:	83 c4 10             	add    $0x10,%esp
  8021dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021e2:	eb da                	jmp    8021be <ftruncate+0x52>
		return -E_NOT_SUPP;
  8021e4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021e9:	eb d3                	jmp    8021be <ftruncate+0x52>

008021eb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	53                   	push   %ebx
  8021ef:	83 ec 1c             	sub    $0x1c,%esp
  8021f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021f8:	50                   	push   %eax
  8021f9:	ff 75 08             	pushl  0x8(%ebp)
  8021fc:	e8 84 fb ff ff       	call   801d85 <fd_lookup>
  802201:	83 c4 10             	add    $0x10,%esp
  802204:	85 c0                	test   %eax,%eax
  802206:	78 4b                	js     802253 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802208:	83 ec 08             	sub    $0x8,%esp
  80220b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80220e:	50                   	push   %eax
  80220f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802212:	ff 30                	pushl  (%eax)
  802214:	e8 bc fb ff ff       	call   801dd5 <dev_lookup>
  802219:	83 c4 10             	add    $0x10,%esp
  80221c:	85 c0                	test   %eax,%eax
  80221e:	78 33                	js     802253 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802223:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802227:	74 2f                	je     802258 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802229:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80222c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802233:	00 00 00 
	stat->st_isdir = 0;
  802236:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80223d:	00 00 00 
	stat->st_dev = dev;
  802240:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802246:	83 ec 08             	sub    $0x8,%esp
  802249:	53                   	push   %ebx
  80224a:	ff 75 f0             	pushl  -0x10(%ebp)
  80224d:	ff 50 14             	call   *0x14(%eax)
  802250:	83 c4 10             	add    $0x10,%esp
}
  802253:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802256:	c9                   	leave  
  802257:	c3                   	ret    
		return -E_NOT_SUPP;
  802258:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80225d:	eb f4                	jmp    802253 <fstat+0x68>

0080225f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	56                   	push   %esi
  802263:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802264:	83 ec 08             	sub    $0x8,%esp
  802267:	6a 00                	push   $0x0
  802269:	ff 75 08             	pushl  0x8(%ebp)
  80226c:	e8 2f 02 00 00       	call   8024a0 <open>
  802271:	89 c3                	mov    %eax,%ebx
  802273:	83 c4 10             	add    $0x10,%esp
  802276:	85 c0                	test   %eax,%eax
  802278:	78 1b                	js     802295 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80227a:	83 ec 08             	sub    $0x8,%esp
  80227d:	ff 75 0c             	pushl  0xc(%ebp)
  802280:	50                   	push   %eax
  802281:	e8 65 ff ff ff       	call   8021eb <fstat>
  802286:	89 c6                	mov    %eax,%esi
	close(fd);
  802288:	89 1c 24             	mov    %ebx,(%esp)
  80228b:	e8 27 fc ff ff       	call   801eb7 <close>
	return r;
  802290:	83 c4 10             	add    $0x10,%esp
  802293:	89 f3                	mov    %esi,%ebx
}
  802295:	89 d8                	mov    %ebx,%eax
  802297:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80229a:	5b                   	pop    %ebx
  80229b:	5e                   	pop    %esi
  80229c:	5d                   	pop    %ebp
  80229d:	c3                   	ret    

0080229e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	56                   	push   %esi
  8022a2:	53                   	push   %ebx
  8022a3:	89 c6                	mov    %eax,%esi
  8022a5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8022a7:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  8022ae:	74 27                	je     8022d7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8022b0:	6a 07                	push   $0x7
  8022b2:	68 00 70 80 00       	push   $0x807000
  8022b7:	56                   	push   %esi
  8022b8:	ff 35 20 64 80 00    	pushl  0x806420
  8022be:	e8 a9 12 00 00       	call   80356c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8022c3:	83 c4 0c             	add    $0xc,%esp
  8022c6:	6a 00                	push   $0x0
  8022c8:	53                   	push   %ebx
  8022c9:	6a 00                	push   $0x0
  8022cb:	e8 29 12 00 00       	call   8034f9 <ipc_recv>
}
  8022d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022d3:	5b                   	pop    %ebx
  8022d4:	5e                   	pop    %esi
  8022d5:	5d                   	pop    %ebp
  8022d6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8022d7:	83 ec 0c             	sub    $0xc,%esp
  8022da:	6a 01                	push   $0x1
  8022dc:	e8 f7 12 00 00       	call   8035d8 <ipc_find_env>
  8022e1:	a3 20 64 80 00       	mov    %eax,0x806420
  8022e6:	83 c4 10             	add    $0x10,%esp
  8022e9:	eb c5                	jmp    8022b0 <fsipc+0x12>

008022eb <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f7:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8022fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ff:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802304:	ba 00 00 00 00       	mov    $0x0,%edx
  802309:	b8 02 00 00 00       	mov    $0x2,%eax
  80230e:	e8 8b ff ff ff       	call   80229e <fsipc>
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <devfile_flush>:
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8b 40 0c             	mov    0xc(%eax),%eax
  802321:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  802326:	ba 00 00 00 00       	mov    $0x0,%edx
  80232b:	b8 06 00 00 00       	mov    $0x6,%eax
  802330:	e8 69 ff ff ff       	call   80229e <fsipc>
}
  802335:	c9                   	leave  
  802336:	c3                   	ret    

00802337 <devfile_stat>:
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	53                   	push   %ebx
  80233b:	83 ec 04             	sub    $0x4,%esp
  80233e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	8b 40 0c             	mov    0xc(%eax),%eax
  802347:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80234c:	ba 00 00 00 00       	mov    $0x0,%edx
  802351:	b8 05 00 00 00       	mov    $0x5,%eax
  802356:	e8 43 ff ff ff       	call   80229e <fsipc>
  80235b:	85 c0                	test   %eax,%eax
  80235d:	78 2c                	js     80238b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80235f:	83 ec 08             	sub    $0x8,%esp
  802362:	68 00 70 80 00       	push   $0x807000
  802367:	53                   	push   %ebx
  802368:	e8 a4 ee ff ff       	call   801211 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80236d:	a1 80 70 80 00       	mov    0x807080,%eax
  802372:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802378:	a1 84 70 80 00       	mov    0x807084,%eax
  80237d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802383:	83 c4 10             	add    $0x10,%esp
  802386:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80238b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <devfile_write>:
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	53                   	push   %ebx
  802394:	83 ec 04             	sub    $0x4,%esp
  802397:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  80239a:	85 db                	test   %ebx,%ebx
  80239c:	75 07                	jne    8023a5 <devfile_write+0x15>
	return n_all;
  80239e:	89 d8                	mov    %ebx,%eax
}
  8023a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ab:	a3 00 70 80 00       	mov    %eax,0x807000
	  fsipcbuf.write.req_n = n_left;
  8023b0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8023b6:	83 ec 04             	sub    $0x4,%esp
  8023b9:	53                   	push   %ebx
  8023ba:	ff 75 0c             	pushl  0xc(%ebp)
  8023bd:	68 08 70 80 00       	push   $0x807008
  8023c2:	e8 d8 ef ff ff       	call   80139f <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8023c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8023cc:	b8 04 00 00 00       	mov    $0x4,%eax
  8023d1:	e8 c8 fe ff ff       	call   80229e <fsipc>
  8023d6:	83 c4 10             	add    $0x10,%esp
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	78 c3                	js     8023a0 <devfile_write+0x10>
	  assert(r <= n_left);
  8023dd:	39 d8                	cmp    %ebx,%eax
  8023df:	77 0b                	ja     8023ec <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  8023e1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8023e6:	7f 1d                	jg     802405 <devfile_write+0x75>
    n_all += r;
  8023e8:	89 c3                	mov    %eax,%ebx
  8023ea:	eb b2                	jmp    80239e <devfile_write+0xe>
	  assert(r <= n_left);
  8023ec:	68 10 40 80 00       	push   $0x804010
  8023f1:	68 ef 39 80 00       	push   $0x8039ef
  8023f6:	68 9f 00 00 00       	push   $0x9f
  8023fb:	68 1c 40 80 00       	push   $0x80401c
  802400:	e8 65 e6 ff ff       	call   800a6a <_panic>
	  assert(r <= PGSIZE);
  802405:	68 27 40 80 00       	push   $0x804027
  80240a:	68 ef 39 80 00       	push   $0x8039ef
  80240f:	68 a0 00 00 00       	push   $0xa0
  802414:	68 1c 40 80 00       	push   $0x80401c
  802419:	e8 4c e6 ff ff       	call   800a6a <_panic>

0080241e <devfile_read>:
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	56                   	push   %esi
  802422:	53                   	push   %ebx
  802423:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	8b 40 0c             	mov    0xc(%eax),%eax
  80242c:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  802431:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802437:	ba 00 00 00 00       	mov    $0x0,%edx
  80243c:	b8 03 00 00 00       	mov    $0x3,%eax
  802441:	e8 58 fe ff ff       	call   80229e <fsipc>
  802446:	89 c3                	mov    %eax,%ebx
  802448:	85 c0                	test   %eax,%eax
  80244a:	78 1f                	js     80246b <devfile_read+0x4d>
	assert(r <= n);
  80244c:	39 f0                	cmp    %esi,%eax
  80244e:	77 24                	ja     802474 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802450:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802455:	7f 33                	jg     80248a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802457:	83 ec 04             	sub    $0x4,%esp
  80245a:	50                   	push   %eax
  80245b:	68 00 70 80 00       	push   $0x807000
  802460:	ff 75 0c             	pushl  0xc(%ebp)
  802463:	e8 37 ef ff ff       	call   80139f <memmove>
	return r;
  802468:	83 c4 10             	add    $0x10,%esp
}
  80246b:	89 d8                	mov    %ebx,%eax
  80246d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802470:	5b                   	pop    %ebx
  802471:	5e                   	pop    %esi
  802472:	5d                   	pop    %ebp
  802473:	c3                   	ret    
	assert(r <= n);
  802474:	68 33 40 80 00       	push   $0x804033
  802479:	68 ef 39 80 00       	push   $0x8039ef
  80247e:	6a 7c                	push   $0x7c
  802480:	68 1c 40 80 00       	push   $0x80401c
  802485:	e8 e0 e5 ff ff       	call   800a6a <_panic>
	assert(r <= PGSIZE);
  80248a:	68 27 40 80 00       	push   $0x804027
  80248f:	68 ef 39 80 00       	push   $0x8039ef
  802494:	6a 7d                	push   $0x7d
  802496:	68 1c 40 80 00       	push   $0x80401c
  80249b:	e8 ca e5 ff ff       	call   800a6a <_panic>

008024a0 <open>:
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
  8024a3:	56                   	push   %esi
  8024a4:	53                   	push   %ebx
  8024a5:	83 ec 1c             	sub    $0x1c,%esp
  8024a8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8024ab:	56                   	push   %esi
  8024ac:	e8 27 ed ff ff       	call   8011d8 <strlen>
  8024b1:	83 c4 10             	add    $0x10,%esp
  8024b4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8024b9:	7f 6c                	jg     802527 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8024bb:	83 ec 0c             	sub    $0xc,%esp
  8024be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024c1:	50                   	push   %eax
  8024c2:	e8 6c f8 ff ff       	call   801d33 <fd_alloc>
  8024c7:	89 c3                	mov    %eax,%ebx
  8024c9:	83 c4 10             	add    $0x10,%esp
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	78 3c                	js     80250c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8024d0:	83 ec 08             	sub    $0x8,%esp
  8024d3:	56                   	push   %esi
  8024d4:	68 00 70 80 00       	push   $0x807000
  8024d9:	e8 33 ed ff ff       	call   801211 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8024de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e1:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8024e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ee:	e8 ab fd ff ff       	call   80229e <fsipc>
  8024f3:	89 c3                	mov    %eax,%ebx
  8024f5:	83 c4 10             	add    $0x10,%esp
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	78 19                	js     802515 <open+0x75>
	return fd2num(fd);
  8024fc:	83 ec 0c             	sub    $0xc,%esp
  8024ff:	ff 75 f4             	pushl  -0xc(%ebp)
  802502:	e8 05 f8 ff ff       	call   801d0c <fd2num>
  802507:	89 c3                	mov    %eax,%ebx
  802509:	83 c4 10             	add    $0x10,%esp
}
  80250c:	89 d8                	mov    %ebx,%eax
  80250e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802511:	5b                   	pop    %ebx
  802512:	5e                   	pop    %esi
  802513:	5d                   	pop    %ebp
  802514:	c3                   	ret    
		fd_close(fd, 0);
  802515:	83 ec 08             	sub    $0x8,%esp
  802518:	6a 00                	push   $0x0
  80251a:	ff 75 f4             	pushl  -0xc(%ebp)
  80251d:	e8 0e f9 ff ff       	call   801e30 <fd_close>
		return r;
  802522:	83 c4 10             	add    $0x10,%esp
  802525:	eb e5                	jmp    80250c <open+0x6c>
		return -E_BAD_PATH;
  802527:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80252c:	eb de                	jmp    80250c <open+0x6c>

0080252e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
  802531:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802534:	ba 00 00 00 00       	mov    $0x0,%edx
  802539:	b8 08 00 00 00       	mov    $0x8,%eax
  80253e:	e8 5b fd ff ff       	call   80229e <fsipc>
}
  802543:	c9                   	leave  
  802544:	c3                   	ret    

00802545 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  802545:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802549:	7f 01                	jg     80254c <writebuf+0x7>
  80254b:	c3                   	ret    
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
  80254f:	53                   	push   %ebx
  802550:	83 ec 08             	sub    $0x8,%esp
  802553:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  802555:	ff 70 04             	pushl  0x4(%eax)
  802558:	8d 40 10             	lea    0x10(%eax),%eax
  80255b:	50                   	push   %eax
  80255c:	ff 33                	pushl  (%ebx)
  80255e:	e8 5e fb ff ff       	call   8020c1 <write>
		if (result > 0)
  802563:	83 c4 10             	add    $0x10,%esp
  802566:	85 c0                	test   %eax,%eax
  802568:	7e 03                	jle    80256d <writebuf+0x28>
			b->result += result;
  80256a:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80256d:	39 43 04             	cmp    %eax,0x4(%ebx)
  802570:	74 0d                	je     80257f <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  802572:	85 c0                	test   %eax,%eax
  802574:	ba 00 00 00 00       	mov    $0x0,%edx
  802579:	0f 4f c2             	cmovg  %edx,%eax
  80257c:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80257f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802582:	c9                   	leave  
  802583:	c3                   	ret    

00802584 <putch>:

static void
putch(int ch, void *thunk)
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	53                   	push   %ebx
  802588:	83 ec 04             	sub    $0x4,%esp
  80258b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80258e:	8b 53 04             	mov    0x4(%ebx),%edx
  802591:	8d 42 01             	lea    0x1(%edx),%eax
  802594:	89 43 04             	mov    %eax,0x4(%ebx)
  802597:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80259a:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80259e:	3d 00 01 00 00       	cmp    $0x100,%eax
  8025a3:	74 06                	je     8025ab <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8025a5:	83 c4 04             	add    $0x4,%esp
  8025a8:	5b                   	pop    %ebx
  8025a9:	5d                   	pop    %ebp
  8025aa:	c3                   	ret    
		writebuf(b);
  8025ab:	89 d8                	mov    %ebx,%eax
  8025ad:	e8 93 ff ff ff       	call   802545 <writebuf>
		b->idx = 0;
  8025b2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8025b9:	eb ea                	jmp    8025a5 <putch+0x21>

008025bb <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
  8025be:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8025cd:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8025d4:	00 00 00 
	b.result = 0;
  8025d7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8025de:	00 00 00 
	b.error = 1;
  8025e1:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8025e8:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8025eb:	ff 75 10             	pushl  0x10(%ebp)
  8025ee:	ff 75 0c             	pushl  0xc(%ebp)
  8025f1:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8025f7:	50                   	push   %eax
  8025f8:	68 84 25 80 00       	push   $0x802584
  8025fd:	e8 3f e6 ff ff       	call   800c41 <vprintfmt>
	if (b.idx > 0)
  802602:	83 c4 10             	add    $0x10,%esp
  802605:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80260c:	7f 11                	jg     80261f <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80260e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802614:	85 c0                	test   %eax,%eax
  802616:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80261d:	c9                   	leave  
  80261e:	c3                   	ret    
		writebuf(&b);
  80261f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802625:	e8 1b ff ff ff       	call   802545 <writebuf>
  80262a:	eb e2                	jmp    80260e <vfprintf+0x53>

0080262c <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802632:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802635:	50                   	push   %eax
  802636:	ff 75 0c             	pushl  0xc(%ebp)
  802639:	ff 75 08             	pushl  0x8(%ebp)
  80263c:	e8 7a ff ff ff       	call   8025bb <vfprintf>
	va_end(ap);

	return cnt;
}
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <printf>:

int
printf(const char *fmt, ...)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
  802646:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802649:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80264c:	50                   	push   %eax
  80264d:	ff 75 08             	pushl  0x8(%ebp)
  802650:	6a 01                	push   $0x1
  802652:	e8 64 ff ff ff       	call   8025bb <vfprintf>
	va_end(ap);

	return cnt;
}
  802657:	c9                   	leave  
  802658:	c3                   	ret    

00802659 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
  80265c:	57                   	push   %edi
  80265d:	56                   	push   %esi
  80265e:	53                   	push   %ebx
  80265f:	81 ec 8c 02 00 00    	sub    $0x28c,%esp
  cprintf("spawn: parent eid = %08x\n", sys_getenvid());
  802665:	e8 5b ef ff ff       	call   8015c5 <sys_getenvid>
  80266a:	83 ec 08             	sub    $0x8,%esp
  80266d:	50                   	push   %eax
  80266e:	68 3a 40 80 00       	push   $0x80403a
  802673:	e8 cd e4 ff ff       	call   800b45 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802678:	83 c4 08             	add    $0x8,%esp
  80267b:	6a 00                	push   $0x0
  80267d:	ff 75 08             	pushl  0x8(%ebp)
  802680:	e8 1b fe ff ff       	call   8024a0 <open>
  802685:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80268b:	83 c4 10             	add    $0x10,%esp
  80268e:	85 c0                	test   %eax,%eax
  802690:	0f 88 fb 04 00 00    	js     802b91 <spawn+0x538>
  802696:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802698:	83 ec 04             	sub    $0x4,%esp
  80269b:	68 00 02 00 00       	push   $0x200
  8026a0:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8026a6:	50                   	push   %eax
  8026a7:	52                   	push   %edx
  8026a8:	e8 cf f9 ff ff       	call   80207c <readn>
  8026ad:	83 c4 10             	add    $0x10,%esp
  8026b0:	3d 00 02 00 00       	cmp    $0x200,%eax
  8026b5:	75 71                	jne    802728 <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  8026b7:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8026be:	45 4c 46 
  8026c1:	75 65                	jne    802728 <spawn+0xcf>
  8026c3:	b8 07 00 00 00       	mov    $0x7,%eax
  8026c8:	cd 30                	int    $0x30
  8026ca:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8026d0:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8026d6:	89 c6                	mov    %eax,%esi
  8026d8:	85 c0                	test   %eax,%eax
  8026da:	0f 88 a5 04 00 00    	js     802b85 <spawn+0x52c>
		return r;
	child = r;
  cprintf("spawn: child eid = %08x\n", child);
  8026e0:	83 ec 08             	sub    $0x8,%esp
  8026e3:	50                   	push   %eax
  8026e4:	68 6e 40 80 00       	push   $0x80406e
  8026e9:	e8 57 e4 ff ff       	call   800b45 <cprintf>

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8026ee:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8026f4:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8026f7:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8026fd:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802703:	b9 11 00 00 00       	mov    $0x11,%ecx
  802708:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80270a:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802710:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  802716:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802719:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  80271e:	be 00 00 00 00       	mov    $0x0,%esi
  802723:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802726:	eb 4b                	jmp    802773 <spawn+0x11a>
		close(fd);
  802728:	83 ec 0c             	sub    $0xc,%esp
  80272b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802731:	e8 81 f7 ff ff       	call   801eb7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802736:	83 c4 0c             	add    $0xc,%esp
  802739:	68 7f 45 4c 46       	push   $0x464c457f
  80273e:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802744:	68 54 40 80 00       	push   $0x804054
  802749:	e8 f7 e3 ff ff       	call   800b45 <cprintf>
		return -E_NOT_EXEC;
  80274e:	83 c4 10             	add    $0x10,%esp
  802751:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  802758:	ff ff ff 
  80275b:	e9 31 04 00 00       	jmp    802b91 <spawn+0x538>
		string_size += strlen(argv[argc]) + 1;
  802760:	83 ec 0c             	sub    $0xc,%esp
  802763:	50                   	push   %eax
  802764:	e8 6f ea ff ff       	call   8011d8 <strlen>
  802769:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80276d:	83 c3 01             	add    $0x1,%ebx
  802770:	83 c4 10             	add    $0x10,%esp
  802773:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80277a:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80277d:	85 c0                	test   %eax,%eax
  80277f:	75 df                	jne    802760 <spawn+0x107>
  802781:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802787:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80278d:	bf 00 10 40 00       	mov    $0x401000,%edi
  802792:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802794:	89 fa                	mov    %edi,%edx
  802796:	83 e2 fc             	and    $0xfffffffc,%edx
  802799:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8027a0:	29 c2                	sub    %eax,%edx
  8027a2:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8027a8:	8d 42 f8             	lea    -0x8(%edx),%eax
  8027ab:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8027b0:	0f 86 fe 03 00 00    	jbe    802bb4 <spawn+0x55b>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8027b6:	83 ec 04             	sub    $0x4,%esp
  8027b9:	6a 07                	push   $0x7
  8027bb:	68 00 00 40 00       	push   $0x400000
  8027c0:	6a 00                	push   $0x0
  8027c2:	e8 3c ee ff ff       	call   801603 <sys_page_alloc>
  8027c7:	83 c4 10             	add    $0x10,%esp
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	0f 88 e7 03 00 00    	js     802bb9 <spawn+0x560>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8027d2:	be 00 00 00 00       	mov    $0x0,%esi
  8027d7:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8027dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8027e0:	eb 30                	jmp    802812 <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  8027e2:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8027e8:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8027ee:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8027f1:	83 ec 08             	sub    $0x8,%esp
  8027f4:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8027f7:	57                   	push   %edi
  8027f8:	e8 14 ea ff ff       	call   801211 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8027fd:	83 c4 04             	add    $0x4,%esp
  802800:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802803:	e8 d0 e9 ff ff       	call   8011d8 <strlen>
  802808:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  80280c:	83 c6 01             	add    $0x1,%esi
  80280f:	83 c4 10             	add    $0x10,%esp
  802812:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802818:	7f c8                	jg     8027e2 <spawn+0x189>
	}
	argv_store[argc] = 0;
  80281a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802820:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802826:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80282d:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802833:	0f 85 86 00 00 00    	jne    8028bf <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802839:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80283f:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  802845:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802848:	89 c8                	mov    %ecx,%eax
  80284a:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  802850:	89 79 f8             	mov    %edi,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802853:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802858:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80285e:	83 ec 0c             	sub    $0xc,%esp
  802861:	6a 07                	push   $0x7
  802863:	68 00 d0 bf ee       	push   $0xeebfd000
  802868:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80286e:	68 00 00 40 00       	push   $0x400000
  802873:	6a 00                	push   $0x0
  802875:	e8 cc ed ff ff       	call   801646 <sys_page_map>
  80287a:	89 c3                	mov    %eax,%ebx
  80287c:	83 c4 20             	add    $0x20,%esp
  80287f:	85 c0                	test   %eax,%eax
  802881:	0f 88 3a 03 00 00    	js     802bc1 <spawn+0x568>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802887:	83 ec 08             	sub    $0x8,%esp
  80288a:	68 00 00 40 00       	push   $0x400000
  80288f:	6a 00                	push   $0x0
  802891:	e8 f2 ed ff ff       	call   801688 <sys_page_unmap>
  802896:	89 c3                	mov    %eax,%ebx
  802898:	83 c4 10             	add    $0x10,%esp
  80289b:	85 c0                	test   %eax,%eax
  80289d:	0f 88 1e 03 00 00    	js     802bc1 <spawn+0x568>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8028a3:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8028a9:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8028b0:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8028b7:	00 00 00 
  8028ba:	e9 4f 01 00 00       	jmp    802a0e <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8028bf:	68 cc 40 80 00       	push   $0x8040cc
  8028c4:	68 ef 39 80 00       	push   $0x8039ef
  8028c9:	68 f4 00 00 00       	push   $0xf4
  8028ce:	68 87 40 80 00       	push   $0x804087
  8028d3:	e8 92 e1 ff ff       	call   800a6a <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8028d8:	83 ec 04             	sub    $0x4,%esp
  8028db:	6a 07                	push   $0x7
  8028dd:	68 00 00 40 00       	push   $0x400000
  8028e2:	6a 00                	push   $0x0
  8028e4:	e8 1a ed ff ff       	call   801603 <sys_page_alloc>
  8028e9:	83 c4 10             	add    $0x10,%esp
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	0f 88 ab 02 00 00    	js     802b9f <spawn+0x546>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8028f4:	83 ec 08             	sub    $0x8,%esp
  8028f7:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8028fd:	01 f0                	add    %esi,%eax
  8028ff:	50                   	push   %eax
  802900:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802906:	e8 38 f8 ff ff       	call   802143 <seek>
  80290b:	83 c4 10             	add    $0x10,%esp
  80290e:	85 c0                	test   %eax,%eax
  802910:	0f 88 90 02 00 00    	js     802ba6 <spawn+0x54d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802916:	83 ec 04             	sub    $0x4,%esp
  802919:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80291f:	29 f0                	sub    %esi,%eax
  802921:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802926:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80292b:	0f 47 c1             	cmova  %ecx,%eax
  80292e:	50                   	push   %eax
  80292f:	68 00 00 40 00       	push   $0x400000
  802934:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80293a:	e8 3d f7 ff ff       	call   80207c <readn>
  80293f:	83 c4 10             	add    $0x10,%esp
  802942:	85 c0                	test   %eax,%eax
  802944:	0f 88 63 02 00 00    	js     802bad <spawn+0x554>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80294a:	83 ec 0c             	sub    $0xc,%esp
  80294d:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802953:	53                   	push   %ebx
  802954:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80295a:	68 00 00 40 00       	push   $0x400000
  80295f:	6a 00                	push   $0x0
  802961:	e8 e0 ec ff ff       	call   801646 <sys_page_map>
  802966:	83 c4 20             	add    $0x20,%esp
  802969:	85 c0                	test   %eax,%eax
  80296b:	78 7c                	js     8029e9 <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80296d:	83 ec 08             	sub    $0x8,%esp
  802970:	68 00 00 40 00       	push   $0x400000
  802975:	6a 00                	push   $0x0
  802977:	e8 0c ed ff ff       	call   801688 <sys_page_unmap>
  80297c:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80297f:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802985:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80298b:	89 fe                	mov    %edi,%esi
  80298d:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802993:	76 69                	jbe    8029fe <spawn+0x3a5>
		if (i >= filesz) {
  802995:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  80299b:	0f 87 37 ff ff ff    	ja     8028d8 <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8029a1:	83 ec 04             	sub    $0x4,%esp
  8029a4:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8029aa:	53                   	push   %ebx
  8029ab:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8029b1:	e8 4d ec ff ff       	call   801603 <sys_page_alloc>
  8029b6:	83 c4 10             	add    $0x10,%esp
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	79 c2                	jns    80297f <spawn+0x326>
  8029bd:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8029bf:	83 ec 0c             	sub    $0xc,%esp
  8029c2:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8029c8:	e8 b7 eb ff ff       	call   801584 <sys_env_destroy>
	close(fd);
  8029cd:	83 c4 04             	add    $0x4,%esp
  8029d0:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8029d6:	e8 dc f4 ff ff       	call   801eb7 <close>
	return r;
  8029db:	83 c4 10             	add    $0x10,%esp
  8029de:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  8029e4:	e9 a8 01 00 00       	jmp    802b91 <spawn+0x538>
				panic("spawn: sys_page_map data: %e", r);
  8029e9:	50                   	push   %eax
  8029ea:	68 93 40 80 00       	push   $0x804093
  8029ef:	68 27 01 00 00       	push   $0x127
  8029f4:	68 87 40 80 00       	push   $0x804087
  8029f9:	e8 6c e0 ff ff       	call   800a6a <_panic>
  8029fe:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802a04:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802a0b:	83 c6 20             	add    $0x20,%esi
  802a0e:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802a15:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802a1b:	7e 6d                	jle    802a8a <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  802a1d:	83 3e 01             	cmpl   $0x1,(%esi)
  802a20:	75 e2                	jne    802a04 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802a22:	8b 46 18             	mov    0x18(%esi),%eax
  802a25:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802a28:	83 f8 01             	cmp    $0x1,%eax
  802a2b:	19 c0                	sbb    %eax,%eax
  802a2d:	83 e0 fe             	and    $0xfffffffe,%eax
  802a30:	83 c0 07             	add    $0x7,%eax
  802a33:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802a39:	8b 4e 04             	mov    0x4(%esi),%ecx
  802a3c:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802a42:	8b 56 10             	mov    0x10(%esi),%edx
  802a45:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802a4b:	8b 7e 14             	mov    0x14(%esi),%edi
  802a4e:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802a54:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802a57:	89 d8                	mov    %ebx,%eax
  802a59:	25 ff 0f 00 00       	and    $0xfff,%eax
  802a5e:	74 1a                	je     802a7a <spawn+0x421>
		va -= i;
  802a60:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802a62:	01 c7                	add    %eax,%edi
  802a64:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802a6a:	01 c2                	add    %eax,%edx
  802a6c:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802a72:	29 c1                	sub    %eax,%ecx
  802a74:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802a7a:	bf 00 00 00 00       	mov    $0x0,%edi
  802a7f:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802a85:	e9 01 ff ff ff       	jmp    80298b <spawn+0x332>
	close(fd);
  802a8a:	83 ec 0c             	sub    $0xc,%esp
  802a8d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802a93:	e8 1f f4 ff ff       	call   801eb7 <close>
  802a98:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for(unsigned int i = 0; i < PGNUM(UTOP); i++)
  802a9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802aa0:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802aa6:	eb 0d                	jmp    802ab5 <spawn+0x45c>
  802aa8:	83 c3 01             	add    $0x1,%ebx
  802aab:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  802ab1:	77 5d                	ja     802b10 <spawn+0x4b7>
	{
		// Remember to ignore exception stack
		if(i == PGNUM(UXSTACKTOP - PGSIZE))
  802ab3:	74 f3                	je     802aa8 <spawn+0x44f>
			continue;
		// check whether this page table entry is valid(whether there exists a mapping)
		void* addr = (void*)(i * PGSIZE);
  802ab5:	89 da                	mov    %ebx,%edx
  802ab7:	c1 e2 0c             	shl    $0xc,%edx
    //BUG
    //if (uvpd[PDX(addr)] & PTE_P)  continue;
    if (!(uvpd[PDX(addr)] & PTE_P))  continue;
  802aba:	89 d0                	mov    %edx,%eax
  802abc:	c1 e8 16             	shr    $0x16,%eax
  802abf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802ac6:	a8 01                	test   $0x1,%al
  802ac8:	74 de                	je     802aa8 <spawn+0x44f>
		pte_t pte = uvpt[i];
  802aca:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		if((pte & PTE_P) && (pte & PTE_SHARE))
  802ad1:	89 c1                	mov    %eax,%ecx
  802ad3:	81 e1 01 04 00 00    	and    $0x401,%ecx
  802ad9:	81 f9 01 04 00 00    	cmp    $0x401,%ecx
  802adf:	75 c7                	jne    802aa8 <spawn+0x44f>
		{
			int error_code = 0;
			if((error_code = sys_page_map(0, addr, child, addr, pte & PTE_SYSCALL)) < 0)
  802ae1:	83 ec 0c             	sub    $0xc,%esp
  802ae4:	25 07 0e 00 00       	and    $0xe07,%eax
  802ae9:	50                   	push   %eax
  802aea:	52                   	push   %edx
  802aeb:	56                   	push   %esi
  802aec:	52                   	push   %edx
  802aed:	6a 00                	push   $0x0
  802aef:	e8 52 eb ff ff       	call   801646 <sys_page_map>
  802af4:	83 c4 20             	add    $0x20,%esp
  802af7:	85 c0                	test   %eax,%eax
  802af9:	79 ad                	jns    802aa8 <spawn+0x44f>
				panic("Page Map Failed: %e", error_code);
  802afb:	50                   	push   %eax
  802afc:	68 3d 3f 80 00       	push   $0x803f3d
  802b01:	68 42 01 00 00       	push   $0x142
  802b06:	68 87 40 80 00       	push   $0x804087
  802b0b:	e8 5a df ff ff       	call   800a6a <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802b10:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802b17:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802b1a:	83 ec 08             	sub    $0x8,%esp
  802b1d:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802b23:	50                   	push   %eax
  802b24:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802b2a:	e8 dd eb ff ff       	call   80170c <sys_env_set_trapframe>
  802b2f:	83 c4 10             	add    $0x10,%esp
  802b32:	85 c0                	test   %eax,%eax
  802b34:	78 25                	js     802b5b <spawn+0x502>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802b36:	83 ec 08             	sub    $0x8,%esp
  802b39:	6a 02                	push   $0x2
  802b3b:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802b41:	e8 84 eb ff ff       	call   8016ca <sys_env_set_status>
  802b46:	83 c4 10             	add    $0x10,%esp
  802b49:	85 c0                	test   %eax,%eax
  802b4b:	78 23                	js     802b70 <spawn+0x517>
	return child;
  802b4d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802b53:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802b59:	eb 36                	jmp    802b91 <spawn+0x538>
		panic("sys_env_set_trapframe: %e", r);
  802b5b:	50                   	push   %eax
  802b5c:	68 b0 40 80 00       	push   $0x8040b0
  802b61:	68 88 00 00 00       	push   $0x88
  802b66:	68 87 40 80 00       	push   $0x804087
  802b6b:	e8 fa de ff ff       	call   800a6a <_panic>
		panic("sys_env_set_status: %e", r);
  802b70:	50                   	push   %eax
  802b71:	68 51 3f 80 00       	push   $0x803f51
  802b76:	68 8b 00 00 00       	push   $0x8b
  802b7b:	68 87 40 80 00       	push   $0x804087
  802b80:	e8 e5 de ff ff       	call   800a6a <_panic>
		return r;
  802b85:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802b8b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802b91:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802b97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b9a:	5b                   	pop    %ebx
  802b9b:	5e                   	pop    %esi
  802b9c:	5f                   	pop    %edi
  802b9d:	5d                   	pop    %ebp
  802b9e:	c3                   	ret    
  802b9f:	89 c7                	mov    %eax,%edi
  802ba1:	e9 19 fe ff ff       	jmp    8029bf <spawn+0x366>
  802ba6:	89 c7                	mov    %eax,%edi
  802ba8:	e9 12 fe ff ff       	jmp    8029bf <spawn+0x366>
  802bad:	89 c7                	mov    %eax,%edi
  802baf:	e9 0b fe ff ff       	jmp    8029bf <spawn+0x366>
		return -E_NO_MEM;
  802bb4:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(unsigned int i = 0; i < PGNUM(UTOP); i++)
  802bb9:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802bbf:	eb d0                	jmp    802b91 <spawn+0x538>
	sys_page_unmap(0, UTEMP);
  802bc1:	83 ec 08             	sub    $0x8,%esp
  802bc4:	68 00 00 40 00       	push   $0x400000
  802bc9:	6a 00                	push   $0x0
  802bcb:	e8 b8 ea ff ff       	call   801688 <sys_page_unmap>
  802bd0:	83 c4 10             	add    $0x10,%esp
  802bd3:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802bd9:	eb b6                	jmp    802b91 <spawn+0x538>

00802bdb <spawnl>:
{
  802bdb:	55                   	push   %ebp
  802bdc:	89 e5                	mov    %esp,%ebp
  802bde:	57                   	push   %edi
  802bdf:	56                   	push   %esi
  802be0:	53                   	push   %ebx
  802be1:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802be4:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802be7:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802bec:	8d 4a 04             	lea    0x4(%edx),%ecx
  802bef:	83 3a 00             	cmpl   $0x0,(%edx)
  802bf2:	74 07                	je     802bfb <spawnl+0x20>
		argc++;
  802bf4:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802bf7:	89 ca                	mov    %ecx,%edx
  802bf9:	eb f1                	jmp    802bec <spawnl+0x11>
	const char *argv[argc+2];
  802bfb:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802c02:	83 e2 f0             	and    $0xfffffff0,%edx
  802c05:	29 d4                	sub    %edx,%esp
  802c07:	8d 54 24 03          	lea    0x3(%esp),%edx
  802c0b:	c1 ea 02             	shr    $0x2,%edx
  802c0e:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802c15:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802c17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c1a:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802c21:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802c28:	00 
	va_start(vl, arg0);
  802c29:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802c2c:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c33:	eb 0b                	jmp    802c40 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  802c35:	83 c0 01             	add    $0x1,%eax
  802c38:	8b 39                	mov    (%ecx),%edi
  802c3a:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802c3d:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802c40:	39 d0                	cmp    %edx,%eax
  802c42:	75 f1                	jne    802c35 <spawnl+0x5a>
	return spawn(prog, argv);
  802c44:	83 ec 08             	sub    $0x8,%esp
  802c47:	56                   	push   %esi
  802c48:	ff 75 08             	pushl  0x8(%ebp)
  802c4b:	e8 09 fa ff ff       	call   802659 <spawn>
}
  802c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c53:	5b                   	pop    %ebx
  802c54:	5e                   	pop    %esi
  802c55:	5f                   	pop    %edi
  802c56:	5d                   	pop    %ebp
  802c57:	c3                   	ret    

00802c58 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802c58:	55                   	push   %ebp
  802c59:	89 e5                	mov    %esp,%ebp
  802c5b:	56                   	push   %esi
  802c5c:	53                   	push   %ebx
  802c5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802c60:	83 ec 0c             	sub    $0xc,%esp
  802c63:	ff 75 08             	pushl  0x8(%ebp)
  802c66:	e8 b1 f0 ff ff       	call   801d1c <fd2data>
  802c6b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802c6d:	83 c4 08             	add    $0x8,%esp
  802c70:	68 f2 40 80 00       	push   $0x8040f2
  802c75:	53                   	push   %ebx
  802c76:	e8 96 e5 ff ff       	call   801211 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802c7b:	8b 46 04             	mov    0x4(%esi),%eax
  802c7e:	2b 06                	sub    (%esi),%eax
  802c80:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802c86:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802c8d:	00 00 00 
	stat->st_dev = &devpipe;
  802c90:	c7 83 88 00 00 00 3c 	movl   $0x80503c,0x88(%ebx)
  802c97:	50 80 00 
	return 0;
}
  802c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ca2:	5b                   	pop    %ebx
  802ca3:	5e                   	pop    %esi
  802ca4:	5d                   	pop    %ebp
  802ca5:	c3                   	ret    

00802ca6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802ca6:	55                   	push   %ebp
  802ca7:	89 e5                	mov    %esp,%ebp
  802ca9:	53                   	push   %ebx
  802caa:	83 ec 0c             	sub    $0xc,%esp
  802cad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802cb0:	53                   	push   %ebx
  802cb1:	6a 00                	push   $0x0
  802cb3:	e8 d0 e9 ff ff       	call   801688 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802cb8:	89 1c 24             	mov    %ebx,(%esp)
  802cbb:	e8 5c f0 ff ff       	call   801d1c <fd2data>
  802cc0:	83 c4 08             	add    $0x8,%esp
  802cc3:	50                   	push   %eax
  802cc4:	6a 00                	push   $0x0
  802cc6:	e8 bd e9 ff ff       	call   801688 <sys_page_unmap>
}
  802ccb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802cce:	c9                   	leave  
  802ccf:	c3                   	ret    

00802cd0 <_pipeisclosed>:
{
  802cd0:	55                   	push   %ebp
  802cd1:	89 e5                	mov    %esp,%ebp
  802cd3:	57                   	push   %edi
  802cd4:	56                   	push   %esi
  802cd5:	53                   	push   %ebx
  802cd6:	83 ec 1c             	sub    $0x1c,%esp
  802cd9:	89 c7                	mov    %eax,%edi
  802cdb:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802cdd:	a1 28 64 80 00       	mov    0x806428,%eax
  802ce2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802ce5:	83 ec 0c             	sub    $0xc,%esp
  802ce8:	57                   	push   %edi
  802ce9:	e8 23 09 00 00       	call   803611 <pageref>
  802cee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802cf1:	89 34 24             	mov    %esi,(%esp)
  802cf4:	e8 18 09 00 00       	call   803611 <pageref>
		nn = thisenv->env_runs;
  802cf9:	8b 15 28 64 80 00    	mov    0x806428,%edx
  802cff:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802d02:	83 c4 10             	add    $0x10,%esp
  802d05:	39 cb                	cmp    %ecx,%ebx
  802d07:	74 1b                	je     802d24 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802d09:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802d0c:	75 cf                	jne    802cdd <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802d0e:	8b 42 58             	mov    0x58(%edx),%eax
  802d11:	6a 01                	push   $0x1
  802d13:	50                   	push   %eax
  802d14:	53                   	push   %ebx
  802d15:	68 f9 40 80 00       	push   $0x8040f9
  802d1a:	e8 26 de ff ff       	call   800b45 <cprintf>
  802d1f:	83 c4 10             	add    $0x10,%esp
  802d22:	eb b9                	jmp    802cdd <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802d24:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802d27:	0f 94 c0             	sete   %al
  802d2a:	0f b6 c0             	movzbl %al,%eax
}
  802d2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d30:	5b                   	pop    %ebx
  802d31:	5e                   	pop    %esi
  802d32:	5f                   	pop    %edi
  802d33:	5d                   	pop    %ebp
  802d34:	c3                   	ret    

00802d35 <devpipe_write>:
{
  802d35:	55                   	push   %ebp
  802d36:	89 e5                	mov    %esp,%ebp
  802d38:	57                   	push   %edi
  802d39:	56                   	push   %esi
  802d3a:	53                   	push   %ebx
  802d3b:	83 ec 28             	sub    $0x28,%esp
  802d3e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802d41:	56                   	push   %esi
  802d42:	e8 d5 ef ff ff       	call   801d1c <fd2data>
  802d47:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802d49:	83 c4 10             	add    $0x10,%esp
  802d4c:	bf 00 00 00 00       	mov    $0x0,%edi
  802d51:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802d54:	74 4f                	je     802da5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802d56:	8b 43 04             	mov    0x4(%ebx),%eax
  802d59:	8b 0b                	mov    (%ebx),%ecx
  802d5b:	8d 51 20             	lea    0x20(%ecx),%edx
  802d5e:	39 d0                	cmp    %edx,%eax
  802d60:	72 14                	jb     802d76 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802d62:	89 da                	mov    %ebx,%edx
  802d64:	89 f0                	mov    %esi,%eax
  802d66:	e8 65 ff ff ff       	call   802cd0 <_pipeisclosed>
  802d6b:	85 c0                	test   %eax,%eax
  802d6d:	75 3b                	jne    802daa <devpipe_write+0x75>
			sys_yield();
  802d6f:	e8 70 e8 ff ff       	call   8015e4 <sys_yield>
  802d74:	eb e0                	jmp    802d56 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d79:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802d7d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802d80:	89 c2                	mov    %eax,%edx
  802d82:	c1 fa 1f             	sar    $0x1f,%edx
  802d85:	89 d1                	mov    %edx,%ecx
  802d87:	c1 e9 1b             	shr    $0x1b,%ecx
  802d8a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802d8d:	83 e2 1f             	and    $0x1f,%edx
  802d90:	29 ca                	sub    %ecx,%edx
  802d92:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802d96:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802d9a:	83 c0 01             	add    $0x1,%eax
  802d9d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802da0:	83 c7 01             	add    $0x1,%edi
  802da3:	eb ac                	jmp    802d51 <devpipe_write+0x1c>
	return i;
  802da5:	8b 45 10             	mov    0x10(%ebp),%eax
  802da8:	eb 05                	jmp    802daf <devpipe_write+0x7a>
				return 0;
  802daa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802db2:	5b                   	pop    %ebx
  802db3:	5e                   	pop    %esi
  802db4:	5f                   	pop    %edi
  802db5:	5d                   	pop    %ebp
  802db6:	c3                   	ret    

00802db7 <devpipe_read>:
{
  802db7:	55                   	push   %ebp
  802db8:	89 e5                	mov    %esp,%ebp
  802dba:	57                   	push   %edi
  802dbb:	56                   	push   %esi
  802dbc:	53                   	push   %ebx
  802dbd:	83 ec 18             	sub    $0x18,%esp
  802dc0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802dc3:	57                   	push   %edi
  802dc4:	e8 53 ef ff ff       	call   801d1c <fd2data>
  802dc9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802dcb:	83 c4 10             	add    $0x10,%esp
  802dce:	be 00 00 00 00       	mov    $0x0,%esi
  802dd3:	3b 75 10             	cmp    0x10(%ebp),%esi
  802dd6:	75 14                	jne    802dec <devpipe_read+0x35>
	return i;
  802dd8:	8b 45 10             	mov    0x10(%ebp),%eax
  802ddb:	eb 02                	jmp    802ddf <devpipe_read+0x28>
				return i;
  802ddd:	89 f0                	mov    %esi,%eax
}
  802ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802de2:	5b                   	pop    %ebx
  802de3:	5e                   	pop    %esi
  802de4:	5f                   	pop    %edi
  802de5:	5d                   	pop    %ebp
  802de6:	c3                   	ret    
			sys_yield();
  802de7:	e8 f8 e7 ff ff       	call   8015e4 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802dec:	8b 03                	mov    (%ebx),%eax
  802dee:	3b 43 04             	cmp    0x4(%ebx),%eax
  802df1:	75 18                	jne    802e0b <devpipe_read+0x54>
			if (i > 0)
  802df3:	85 f6                	test   %esi,%esi
  802df5:	75 e6                	jne    802ddd <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802df7:	89 da                	mov    %ebx,%edx
  802df9:	89 f8                	mov    %edi,%eax
  802dfb:	e8 d0 fe ff ff       	call   802cd0 <_pipeisclosed>
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 e3                	je     802de7 <devpipe_read+0x30>
				return 0;
  802e04:	b8 00 00 00 00       	mov    $0x0,%eax
  802e09:	eb d4                	jmp    802ddf <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e0b:	99                   	cltd   
  802e0c:	c1 ea 1b             	shr    $0x1b,%edx
  802e0f:	01 d0                	add    %edx,%eax
  802e11:	83 e0 1f             	and    $0x1f,%eax
  802e14:	29 d0                	sub    %edx,%eax
  802e16:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e1e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802e21:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802e24:	83 c6 01             	add    $0x1,%esi
  802e27:	eb aa                	jmp    802dd3 <devpipe_read+0x1c>

00802e29 <pipe>:
{
  802e29:	55                   	push   %ebp
  802e2a:	89 e5                	mov    %esp,%ebp
  802e2c:	56                   	push   %esi
  802e2d:	53                   	push   %ebx
  802e2e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802e31:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e34:	50                   	push   %eax
  802e35:	e8 f9 ee ff ff       	call   801d33 <fd_alloc>
  802e3a:	89 c3                	mov    %eax,%ebx
  802e3c:	83 c4 10             	add    $0x10,%esp
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	0f 88 23 01 00 00    	js     802f6a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e47:	83 ec 04             	sub    $0x4,%esp
  802e4a:	68 07 04 00 00       	push   $0x407
  802e4f:	ff 75 f4             	pushl  -0xc(%ebp)
  802e52:	6a 00                	push   $0x0
  802e54:	e8 aa e7 ff ff       	call   801603 <sys_page_alloc>
  802e59:	89 c3                	mov    %eax,%ebx
  802e5b:	83 c4 10             	add    $0x10,%esp
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	0f 88 04 01 00 00    	js     802f6a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802e66:	83 ec 0c             	sub    $0xc,%esp
  802e69:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e6c:	50                   	push   %eax
  802e6d:	e8 c1 ee ff ff       	call   801d33 <fd_alloc>
  802e72:	89 c3                	mov    %eax,%ebx
  802e74:	83 c4 10             	add    $0x10,%esp
  802e77:	85 c0                	test   %eax,%eax
  802e79:	0f 88 db 00 00 00    	js     802f5a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e7f:	83 ec 04             	sub    $0x4,%esp
  802e82:	68 07 04 00 00       	push   $0x407
  802e87:	ff 75 f0             	pushl  -0x10(%ebp)
  802e8a:	6a 00                	push   $0x0
  802e8c:	e8 72 e7 ff ff       	call   801603 <sys_page_alloc>
  802e91:	89 c3                	mov    %eax,%ebx
  802e93:	83 c4 10             	add    $0x10,%esp
  802e96:	85 c0                	test   %eax,%eax
  802e98:	0f 88 bc 00 00 00    	js     802f5a <pipe+0x131>
	va = fd2data(fd0);
  802e9e:	83 ec 0c             	sub    $0xc,%esp
  802ea1:	ff 75 f4             	pushl  -0xc(%ebp)
  802ea4:	e8 73 ee ff ff       	call   801d1c <fd2data>
  802ea9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802eab:	83 c4 0c             	add    $0xc,%esp
  802eae:	68 07 04 00 00       	push   $0x407
  802eb3:	50                   	push   %eax
  802eb4:	6a 00                	push   $0x0
  802eb6:	e8 48 e7 ff ff       	call   801603 <sys_page_alloc>
  802ebb:	89 c3                	mov    %eax,%ebx
  802ebd:	83 c4 10             	add    $0x10,%esp
  802ec0:	85 c0                	test   %eax,%eax
  802ec2:	0f 88 82 00 00 00    	js     802f4a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ec8:	83 ec 0c             	sub    $0xc,%esp
  802ecb:	ff 75 f0             	pushl  -0x10(%ebp)
  802ece:	e8 49 ee ff ff       	call   801d1c <fd2data>
  802ed3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802eda:	50                   	push   %eax
  802edb:	6a 00                	push   $0x0
  802edd:	56                   	push   %esi
  802ede:	6a 00                	push   $0x0
  802ee0:	e8 61 e7 ff ff       	call   801646 <sys_page_map>
  802ee5:	89 c3                	mov    %eax,%ebx
  802ee7:	83 c4 20             	add    $0x20,%esp
  802eea:	85 c0                	test   %eax,%eax
  802eec:	78 4e                	js     802f3c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802eee:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ef3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efb:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802f02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f05:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802f11:	83 ec 0c             	sub    $0xc,%esp
  802f14:	ff 75 f4             	pushl  -0xc(%ebp)
  802f17:	e8 f0 ed ff ff       	call   801d0c <fd2num>
  802f1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f1f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802f21:	83 c4 04             	add    $0x4,%esp
  802f24:	ff 75 f0             	pushl  -0x10(%ebp)
  802f27:	e8 e0 ed ff ff       	call   801d0c <fd2num>
  802f2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f2f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802f32:	83 c4 10             	add    $0x10,%esp
  802f35:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f3a:	eb 2e                	jmp    802f6a <pipe+0x141>
	sys_page_unmap(0, va);
  802f3c:	83 ec 08             	sub    $0x8,%esp
  802f3f:	56                   	push   %esi
  802f40:	6a 00                	push   $0x0
  802f42:	e8 41 e7 ff ff       	call   801688 <sys_page_unmap>
  802f47:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802f4a:	83 ec 08             	sub    $0x8,%esp
  802f4d:	ff 75 f0             	pushl  -0x10(%ebp)
  802f50:	6a 00                	push   $0x0
  802f52:	e8 31 e7 ff ff       	call   801688 <sys_page_unmap>
  802f57:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802f5a:	83 ec 08             	sub    $0x8,%esp
  802f5d:	ff 75 f4             	pushl  -0xc(%ebp)
  802f60:	6a 00                	push   $0x0
  802f62:	e8 21 e7 ff ff       	call   801688 <sys_page_unmap>
  802f67:	83 c4 10             	add    $0x10,%esp
}
  802f6a:	89 d8                	mov    %ebx,%eax
  802f6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f6f:	5b                   	pop    %ebx
  802f70:	5e                   	pop    %esi
  802f71:	5d                   	pop    %ebp
  802f72:	c3                   	ret    

00802f73 <pipeisclosed>:
{
  802f73:	55                   	push   %ebp
  802f74:	89 e5                	mov    %esp,%ebp
  802f76:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f7c:	50                   	push   %eax
  802f7d:	ff 75 08             	pushl  0x8(%ebp)
  802f80:	e8 00 ee ff ff       	call   801d85 <fd_lookup>
  802f85:	83 c4 10             	add    $0x10,%esp
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	78 18                	js     802fa4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802f8c:	83 ec 0c             	sub    $0xc,%esp
  802f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  802f92:	e8 85 ed ff ff       	call   801d1c <fd2data>
	return _pipeisclosed(fd, p);
  802f97:	89 c2                	mov    %eax,%edx
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	e8 2f fd ff ff       	call   802cd0 <_pipeisclosed>
  802fa1:	83 c4 10             	add    $0x10,%esp
}
  802fa4:	c9                   	leave  
  802fa5:	c3                   	ret    

00802fa6 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802fa6:	55                   	push   %ebp
  802fa7:	89 e5                	mov    %esp,%ebp
  802fa9:	56                   	push   %esi
  802faa:	53                   	push   %ebx
  802fab:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802fae:	85 f6                	test   %esi,%esi
  802fb0:	74 13                	je     802fc5 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802fb2:	89 f3                	mov    %esi,%ebx
  802fb4:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802fba:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802fbd:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802fc3:	eb 1b                	jmp    802fe0 <wait+0x3a>
	assert(envid != 0);
  802fc5:	68 11 41 80 00       	push   $0x804111
  802fca:	68 ef 39 80 00       	push   $0x8039ef
  802fcf:	6a 09                	push   $0x9
  802fd1:	68 1c 41 80 00       	push   $0x80411c
  802fd6:	e8 8f da ff ff       	call   800a6a <_panic>
		sys_yield();
  802fdb:	e8 04 e6 ff ff       	call   8015e4 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802fe0:	8b 43 48             	mov    0x48(%ebx),%eax
  802fe3:	39 f0                	cmp    %esi,%eax
  802fe5:	75 07                	jne    802fee <wait+0x48>
  802fe7:	8b 43 54             	mov    0x54(%ebx),%eax
  802fea:	85 c0                	test   %eax,%eax
  802fec:	75 ed                	jne    802fdb <wait+0x35>
}
  802fee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ff1:	5b                   	pop    %ebx
  802ff2:	5e                   	pop    %esi
  802ff3:	5d                   	pop    %ebp
  802ff4:	c3                   	ret    

00802ff5 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802ff5:	55                   	push   %ebp
  802ff6:	89 e5                	mov    %esp,%ebp
  802ff8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802ffb:	68 27 41 80 00       	push   $0x804127
  803000:	ff 75 0c             	pushl  0xc(%ebp)
  803003:	e8 09 e2 ff ff       	call   801211 <strcpy>
	return 0;
}
  803008:	b8 00 00 00 00       	mov    $0x0,%eax
  80300d:	c9                   	leave  
  80300e:	c3                   	ret    

0080300f <devsock_close>:
{
  80300f:	55                   	push   %ebp
  803010:	89 e5                	mov    %esp,%ebp
  803012:	53                   	push   %ebx
  803013:	83 ec 10             	sub    $0x10,%esp
  803016:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803019:	53                   	push   %ebx
  80301a:	e8 f2 05 00 00       	call   803611 <pageref>
  80301f:	83 c4 10             	add    $0x10,%esp
		return 0;
  803022:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  803027:	83 f8 01             	cmp    $0x1,%eax
  80302a:	74 07                	je     803033 <devsock_close+0x24>
}
  80302c:	89 d0                	mov    %edx,%eax
  80302e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803031:	c9                   	leave  
  803032:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  803033:	83 ec 0c             	sub    $0xc,%esp
  803036:	ff 73 0c             	pushl  0xc(%ebx)
  803039:	e8 b9 02 00 00       	call   8032f7 <nsipc_close>
  80303e:	89 c2                	mov    %eax,%edx
  803040:	83 c4 10             	add    $0x10,%esp
  803043:	eb e7                	jmp    80302c <devsock_close+0x1d>

00803045 <devsock_write>:
{
  803045:	55                   	push   %ebp
  803046:	89 e5                	mov    %esp,%ebp
  803048:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80304b:	6a 00                	push   $0x0
  80304d:	ff 75 10             	pushl  0x10(%ebp)
  803050:	ff 75 0c             	pushl  0xc(%ebp)
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	ff 70 0c             	pushl  0xc(%eax)
  803059:	e8 76 03 00 00       	call   8033d4 <nsipc_send>
}
  80305e:	c9                   	leave  
  80305f:	c3                   	ret    

00803060 <devsock_read>:
{
  803060:	55                   	push   %ebp
  803061:	89 e5                	mov    %esp,%ebp
  803063:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803066:	6a 00                	push   $0x0
  803068:	ff 75 10             	pushl  0x10(%ebp)
  80306b:	ff 75 0c             	pushl  0xc(%ebp)
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	ff 70 0c             	pushl  0xc(%eax)
  803074:	e8 ef 02 00 00       	call   803368 <nsipc_recv>
}
  803079:	c9                   	leave  
  80307a:	c3                   	ret    

0080307b <fd2sockid>:
{
  80307b:	55                   	push   %ebp
  80307c:	89 e5                	mov    %esp,%ebp
  80307e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  803081:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803084:	52                   	push   %edx
  803085:	50                   	push   %eax
  803086:	e8 fa ec ff ff       	call   801d85 <fd_lookup>
  80308b:	83 c4 10             	add    $0x10,%esp
  80308e:	85 c0                	test   %eax,%eax
  803090:	78 10                	js     8030a2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	8b 0d 58 50 80 00    	mov    0x805058,%ecx
  80309b:	39 08                	cmp    %ecx,(%eax)
  80309d:	75 05                	jne    8030a4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80309f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8030a2:	c9                   	leave  
  8030a3:	c3                   	ret    
		return -E_NOT_SUPP;
  8030a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8030a9:	eb f7                	jmp    8030a2 <fd2sockid+0x27>

008030ab <alloc_sockfd>:
{
  8030ab:	55                   	push   %ebp
  8030ac:	89 e5                	mov    %esp,%ebp
  8030ae:	56                   	push   %esi
  8030af:	53                   	push   %ebx
  8030b0:	83 ec 1c             	sub    $0x1c,%esp
  8030b3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8030b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030b8:	50                   	push   %eax
  8030b9:	e8 75 ec ff ff       	call   801d33 <fd_alloc>
  8030be:	89 c3                	mov    %eax,%ebx
  8030c0:	83 c4 10             	add    $0x10,%esp
  8030c3:	85 c0                	test   %eax,%eax
  8030c5:	78 43                	js     80310a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8030c7:	83 ec 04             	sub    $0x4,%esp
  8030ca:	68 07 04 00 00       	push   $0x407
  8030cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8030d2:	6a 00                	push   $0x0
  8030d4:	e8 2a e5 ff ff       	call   801603 <sys_page_alloc>
  8030d9:	89 c3                	mov    %eax,%ebx
  8030db:	83 c4 10             	add    $0x10,%esp
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	78 28                	js     80310a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8030e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e5:	8b 15 58 50 80 00    	mov    0x805058,%edx
  8030eb:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8030f7:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8030fa:	83 ec 0c             	sub    $0xc,%esp
  8030fd:	50                   	push   %eax
  8030fe:	e8 09 ec ff ff       	call   801d0c <fd2num>
  803103:	89 c3                	mov    %eax,%ebx
  803105:	83 c4 10             	add    $0x10,%esp
  803108:	eb 0c                	jmp    803116 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80310a:	83 ec 0c             	sub    $0xc,%esp
  80310d:	56                   	push   %esi
  80310e:	e8 e4 01 00 00       	call   8032f7 <nsipc_close>
		return r;
  803113:	83 c4 10             	add    $0x10,%esp
}
  803116:	89 d8                	mov    %ebx,%eax
  803118:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80311b:	5b                   	pop    %ebx
  80311c:	5e                   	pop    %esi
  80311d:	5d                   	pop    %ebp
  80311e:	c3                   	ret    

0080311f <accept>:
{
  80311f:	55                   	push   %ebp
  803120:	89 e5                	mov    %esp,%ebp
  803122:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	e8 4e ff ff ff       	call   80307b <fd2sockid>
  80312d:	85 c0                	test   %eax,%eax
  80312f:	78 1b                	js     80314c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803131:	83 ec 04             	sub    $0x4,%esp
  803134:	ff 75 10             	pushl  0x10(%ebp)
  803137:	ff 75 0c             	pushl  0xc(%ebp)
  80313a:	50                   	push   %eax
  80313b:	e8 0e 01 00 00       	call   80324e <nsipc_accept>
  803140:	83 c4 10             	add    $0x10,%esp
  803143:	85 c0                	test   %eax,%eax
  803145:	78 05                	js     80314c <accept+0x2d>
	return alloc_sockfd(r);
  803147:	e8 5f ff ff ff       	call   8030ab <alloc_sockfd>
}
  80314c:	c9                   	leave  
  80314d:	c3                   	ret    

0080314e <bind>:
{
  80314e:	55                   	push   %ebp
  80314f:	89 e5                	mov    %esp,%ebp
  803151:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803154:	8b 45 08             	mov    0x8(%ebp),%eax
  803157:	e8 1f ff ff ff       	call   80307b <fd2sockid>
  80315c:	85 c0                	test   %eax,%eax
  80315e:	78 12                	js     803172 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  803160:	83 ec 04             	sub    $0x4,%esp
  803163:	ff 75 10             	pushl  0x10(%ebp)
  803166:	ff 75 0c             	pushl  0xc(%ebp)
  803169:	50                   	push   %eax
  80316a:	e8 31 01 00 00       	call   8032a0 <nsipc_bind>
  80316f:	83 c4 10             	add    $0x10,%esp
}
  803172:	c9                   	leave  
  803173:	c3                   	ret    

00803174 <shutdown>:
{
  803174:	55                   	push   %ebp
  803175:	89 e5                	mov    %esp,%ebp
  803177:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	e8 f9 fe ff ff       	call   80307b <fd2sockid>
  803182:	85 c0                	test   %eax,%eax
  803184:	78 0f                	js     803195 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  803186:	83 ec 08             	sub    $0x8,%esp
  803189:	ff 75 0c             	pushl  0xc(%ebp)
  80318c:	50                   	push   %eax
  80318d:	e8 43 01 00 00       	call   8032d5 <nsipc_shutdown>
  803192:	83 c4 10             	add    $0x10,%esp
}
  803195:	c9                   	leave  
  803196:	c3                   	ret    

00803197 <connect>:
{
  803197:	55                   	push   %ebp
  803198:	89 e5                	mov    %esp,%ebp
  80319a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80319d:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a0:	e8 d6 fe ff ff       	call   80307b <fd2sockid>
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	78 12                	js     8031bb <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8031a9:	83 ec 04             	sub    $0x4,%esp
  8031ac:	ff 75 10             	pushl  0x10(%ebp)
  8031af:	ff 75 0c             	pushl  0xc(%ebp)
  8031b2:	50                   	push   %eax
  8031b3:	e8 59 01 00 00       	call   803311 <nsipc_connect>
  8031b8:	83 c4 10             	add    $0x10,%esp
}
  8031bb:	c9                   	leave  
  8031bc:	c3                   	ret    

008031bd <listen>:
{
  8031bd:	55                   	push   %ebp
  8031be:	89 e5                	mov    %esp,%ebp
  8031c0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c6:	e8 b0 fe ff ff       	call   80307b <fd2sockid>
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	78 0f                	js     8031de <listen+0x21>
	return nsipc_listen(r, backlog);
  8031cf:	83 ec 08             	sub    $0x8,%esp
  8031d2:	ff 75 0c             	pushl  0xc(%ebp)
  8031d5:	50                   	push   %eax
  8031d6:	e8 6b 01 00 00       	call   803346 <nsipc_listen>
  8031db:	83 c4 10             	add    $0x10,%esp
}
  8031de:	c9                   	leave  
  8031df:	c3                   	ret    

008031e0 <socket>:

int
socket(int domain, int type, int protocol)
{
  8031e0:	55                   	push   %ebp
  8031e1:	89 e5                	mov    %esp,%ebp
  8031e3:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8031e6:	ff 75 10             	pushl  0x10(%ebp)
  8031e9:	ff 75 0c             	pushl  0xc(%ebp)
  8031ec:	ff 75 08             	pushl  0x8(%ebp)
  8031ef:	e8 3e 02 00 00       	call   803432 <nsipc_socket>
  8031f4:	83 c4 10             	add    $0x10,%esp
  8031f7:	85 c0                	test   %eax,%eax
  8031f9:	78 05                	js     803200 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8031fb:	e8 ab fe ff ff       	call   8030ab <alloc_sockfd>
}
  803200:	c9                   	leave  
  803201:	c3                   	ret    

00803202 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803202:	55                   	push   %ebp
  803203:	89 e5                	mov    %esp,%ebp
  803205:	53                   	push   %ebx
  803206:	83 ec 04             	sub    $0x4,%esp
  803209:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80320b:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  803212:	74 26                	je     80323a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803214:	6a 07                	push   $0x7
  803216:	68 00 80 80 00       	push   $0x808000
  80321b:	53                   	push   %ebx
  80321c:	ff 35 24 64 80 00    	pushl  0x806424
  803222:	e8 45 03 00 00       	call   80356c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803227:	83 c4 0c             	add    $0xc,%esp
  80322a:	6a 00                	push   $0x0
  80322c:	6a 00                	push   $0x0
  80322e:	6a 00                	push   $0x0
  803230:	e8 c4 02 00 00       	call   8034f9 <ipc_recv>
}
  803235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803238:	c9                   	leave  
  803239:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80323a:	83 ec 0c             	sub    $0xc,%esp
  80323d:	6a 02                	push   $0x2
  80323f:	e8 94 03 00 00       	call   8035d8 <ipc_find_env>
  803244:	a3 24 64 80 00       	mov    %eax,0x806424
  803249:	83 c4 10             	add    $0x10,%esp
  80324c:	eb c6                	jmp    803214 <nsipc+0x12>

0080324e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80324e:	55                   	push   %ebp
  80324f:	89 e5                	mov    %esp,%ebp
  803251:	56                   	push   %esi
  803252:	53                   	push   %ebx
  803253:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80325e:	8b 06                	mov    (%esi),%eax
  803260:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803265:	b8 01 00 00 00       	mov    $0x1,%eax
  80326a:	e8 93 ff ff ff       	call   803202 <nsipc>
  80326f:	89 c3                	mov    %eax,%ebx
  803271:	85 c0                	test   %eax,%eax
  803273:	79 09                	jns    80327e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  803275:	89 d8                	mov    %ebx,%eax
  803277:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80327a:	5b                   	pop    %ebx
  80327b:	5e                   	pop    %esi
  80327c:	5d                   	pop    %ebp
  80327d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80327e:	83 ec 04             	sub    $0x4,%esp
  803281:	ff 35 10 80 80 00    	pushl  0x808010
  803287:	68 00 80 80 00       	push   $0x808000
  80328c:	ff 75 0c             	pushl  0xc(%ebp)
  80328f:	e8 0b e1 ff ff       	call   80139f <memmove>
		*addrlen = ret->ret_addrlen;
  803294:	a1 10 80 80 00       	mov    0x808010,%eax
  803299:	89 06                	mov    %eax,(%esi)
  80329b:	83 c4 10             	add    $0x10,%esp
	return r;
  80329e:	eb d5                	jmp    803275 <nsipc_accept+0x27>

008032a0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032a0:	55                   	push   %ebp
  8032a1:	89 e5                	mov    %esp,%ebp
  8032a3:	53                   	push   %ebx
  8032a4:	83 ec 08             	sub    $0x8,%esp
  8032a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8032b2:	53                   	push   %ebx
  8032b3:	ff 75 0c             	pushl  0xc(%ebp)
  8032b6:	68 04 80 80 00       	push   $0x808004
  8032bb:	e8 df e0 ff ff       	call   80139f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8032c0:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  8032c6:	b8 02 00 00 00       	mov    $0x2,%eax
  8032cb:	e8 32 ff ff ff       	call   803202 <nsipc>
}
  8032d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032d3:	c9                   	leave  
  8032d4:	c3                   	ret    

008032d5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8032d5:	55                   	push   %ebp
  8032d6:	89 e5                	mov    %esp,%ebp
  8032d8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8032e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e6:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8032eb:	b8 03 00 00 00       	mov    $0x3,%eax
  8032f0:	e8 0d ff ff ff       	call   803202 <nsipc>
}
  8032f5:	c9                   	leave  
  8032f6:	c3                   	ret    

008032f7 <nsipc_close>:

int
nsipc_close(int s)
{
  8032f7:	55                   	push   %ebp
  8032f8:	89 e5                	mov    %esp,%ebp
  8032fa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803300:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  803305:	b8 04 00 00 00       	mov    $0x4,%eax
  80330a:	e8 f3 fe ff ff       	call   803202 <nsipc>
}
  80330f:	c9                   	leave  
  803310:	c3                   	ret    

00803311 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803311:	55                   	push   %ebp
  803312:	89 e5                	mov    %esp,%ebp
  803314:	53                   	push   %ebx
  803315:	83 ec 08             	sub    $0x8,%esp
  803318:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80331b:	8b 45 08             	mov    0x8(%ebp),%eax
  80331e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803323:	53                   	push   %ebx
  803324:	ff 75 0c             	pushl  0xc(%ebp)
  803327:	68 04 80 80 00       	push   $0x808004
  80332c:	e8 6e e0 ff ff       	call   80139f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803331:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803337:	b8 05 00 00 00       	mov    $0x5,%eax
  80333c:	e8 c1 fe ff ff       	call   803202 <nsipc>
}
  803341:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803344:	c9                   	leave  
  803345:	c3                   	ret    

00803346 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803346:	55                   	push   %ebp
  803347:	89 e5                	mov    %esp,%ebp
  803349:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  803354:	8b 45 0c             	mov    0xc(%ebp),%eax
  803357:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80335c:	b8 06 00 00 00       	mov    $0x6,%eax
  803361:	e8 9c fe ff ff       	call   803202 <nsipc>
}
  803366:	c9                   	leave  
  803367:	c3                   	ret    

00803368 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803368:	55                   	push   %ebp
  803369:	89 e5                	mov    %esp,%ebp
  80336b:	56                   	push   %esi
  80336c:	53                   	push   %ebx
  80336d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803370:	8b 45 08             	mov    0x8(%ebp),%eax
  803373:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803378:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  80337e:	8b 45 14             	mov    0x14(%ebp),%eax
  803381:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803386:	b8 07 00 00 00       	mov    $0x7,%eax
  80338b:	e8 72 fe ff ff       	call   803202 <nsipc>
  803390:	89 c3                	mov    %eax,%ebx
  803392:	85 c0                	test   %eax,%eax
  803394:	78 1f                	js     8033b5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  803396:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80339b:	7f 21                	jg     8033be <nsipc_recv+0x56>
  80339d:	39 c6                	cmp    %eax,%esi
  80339f:	7c 1d                	jl     8033be <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8033a1:	83 ec 04             	sub    $0x4,%esp
  8033a4:	50                   	push   %eax
  8033a5:	68 00 80 80 00       	push   $0x808000
  8033aa:	ff 75 0c             	pushl  0xc(%ebp)
  8033ad:	e8 ed df ff ff       	call   80139f <memmove>
  8033b2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8033b5:	89 d8                	mov    %ebx,%eax
  8033b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8033ba:	5b                   	pop    %ebx
  8033bb:	5e                   	pop    %esi
  8033bc:	5d                   	pop    %ebp
  8033bd:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8033be:	68 33 41 80 00       	push   $0x804133
  8033c3:	68 ef 39 80 00       	push   $0x8039ef
  8033c8:	6a 62                	push   $0x62
  8033ca:	68 48 41 80 00       	push   $0x804148
  8033cf:	e8 96 d6 ff ff       	call   800a6a <_panic>

008033d4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8033d4:	55                   	push   %ebp
  8033d5:	89 e5                	mov    %esp,%ebp
  8033d7:	53                   	push   %ebx
  8033d8:	83 ec 04             	sub    $0x4,%esp
  8033db:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8033e6:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8033ec:	7f 2e                	jg     80341c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8033ee:	83 ec 04             	sub    $0x4,%esp
  8033f1:	53                   	push   %ebx
  8033f2:	ff 75 0c             	pushl  0xc(%ebp)
  8033f5:	68 0c 80 80 00       	push   $0x80800c
  8033fa:	e8 a0 df ff ff       	call   80139f <memmove>
	nsipcbuf.send.req_size = size;
  8033ff:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  803405:	8b 45 14             	mov    0x14(%ebp),%eax
  803408:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  80340d:	b8 08 00 00 00       	mov    $0x8,%eax
  803412:	e8 eb fd ff ff       	call   803202 <nsipc>
}
  803417:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80341a:	c9                   	leave  
  80341b:	c3                   	ret    
	assert(size < 1600);
  80341c:	68 54 41 80 00       	push   $0x804154
  803421:	68 ef 39 80 00       	push   $0x8039ef
  803426:	6a 6d                	push   $0x6d
  803428:	68 48 41 80 00       	push   $0x804148
  80342d:	e8 38 d6 ff ff       	call   800a6a <_panic>

00803432 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803432:	55                   	push   %ebp
  803433:	89 e5                	mov    %esp,%ebp
  803435:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  803440:	8b 45 0c             	mov    0xc(%ebp),%eax
  803443:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803448:	8b 45 10             	mov    0x10(%ebp),%eax
  80344b:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  803450:	b8 09 00 00 00       	mov    $0x9,%eax
  803455:	e8 a8 fd ff ff       	call   803202 <nsipc>
}
  80345a:	c9                   	leave  
  80345b:	c3                   	ret    

0080345c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80345c:	55                   	push   %ebp
  80345d:	89 e5                	mov    %esp,%ebp
  80345f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  803462:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  803469:	74 0a                	je     803475 <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	a3 00 90 80 00       	mov    %eax,0x809000
}
  803473:	c9                   	leave  
  803474:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  803475:	a1 28 64 80 00       	mov    0x806428,%eax
  80347a:	8b 40 48             	mov    0x48(%eax),%eax
  80347d:	83 ec 04             	sub    $0x4,%esp
  803480:	6a 07                	push   $0x7
  803482:	68 00 f0 bf ee       	push   $0xeebff000
  803487:	50                   	push   %eax
  803488:	e8 76 e1 ff ff       	call   801603 <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80348d:	83 c4 10             	add    $0x10,%esp
  803490:	85 c0                	test   %eax,%eax
  803492:	78 2c                	js     8034c0 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  803494:	e8 2c e1 ff ff       	call   8015c5 <sys_getenvid>
  803499:	83 ec 08             	sub    $0x8,%esp
  80349c:	68 d2 34 80 00       	push   $0x8034d2
  8034a1:	50                   	push   %eax
  8034a2:	e8 a7 e2 ff ff       	call   80174e <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  8034a7:	83 c4 10             	add    $0x10,%esp
  8034aa:	85 c0                	test   %eax,%eax
  8034ac:	79 bd                	jns    80346b <set_pgfault_handler+0xf>
  8034ae:	50                   	push   %eax
  8034af:	68 60 41 80 00       	push   $0x804160
  8034b4:	6a 23                	push   $0x23
  8034b6:	68 78 41 80 00       	push   $0x804178
  8034bb:	e8 aa d5 ff ff       	call   800a6a <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  8034c0:	50                   	push   %eax
  8034c1:	68 60 41 80 00       	push   $0x804160
  8034c6:	6a 21                	push   $0x21
  8034c8:	68 78 41 80 00       	push   $0x804178
  8034cd:	e8 98 d5 ff ff       	call   800a6a <_panic>

008034d2 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8034d2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8034d3:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  8034d8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8034da:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  8034dd:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  8034e1:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  8034e4:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  8034e8:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  8034ec:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  8034ef:	83 c4 08             	add    $0x8,%esp
	popal
  8034f2:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8034f3:	83 c4 04             	add    $0x4,%esp
	popfl
  8034f6:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8034f7:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8034f8:	c3                   	ret    

008034f9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8034f9:	55                   	push   %ebp
  8034fa:	89 e5                	mov    %esp,%ebp
  8034fc:	56                   	push   %esi
  8034fd:	53                   	push   %ebx
  8034fe:	8b 75 08             	mov    0x8(%ebp),%esi
  803501:	8b 45 0c             	mov    0xc(%ebp),%eax
  803504:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  803507:	85 c0                	test   %eax,%eax
  803509:	74 4f                	je     80355a <ipc_recv+0x61>
  80350b:	83 ec 0c             	sub    $0xc,%esp
  80350e:	50                   	push   %eax
  80350f:	e8 9f e2 ff ff       	call   8017b3 <sys_ipc_recv>
  803514:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  803517:	85 f6                	test   %esi,%esi
  803519:	74 14                	je     80352f <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  80351b:	ba 00 00 00 00       	mov    $0x0,%edx
  803520:	85 c0                	test   %eax,%eax
  803522:	75 09                	jne    80352d <ipc_recv+0x34>
  803524:	8b 15 28 64 80 00    	mov    0x806428,%edx
  80352a:	8b 52 74             	mov    0x74(%edx),%edx
  80352d:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  80352f:	85 db                	test   %ebx,%ebx
  803531:	74 14                	je     803547 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  803533:	ba 00 00 00 00       	mov    $0x0,%edx
  803538:	85 c0                	test   %eax,%eax
  80353a:	75 09                	jne    803545 <ipc_recv+0x4c>
  80353c:	8b 15 28 64 80 00    	mov    0x806428,%edx
  803542:	8b 52 78             	mov    0x78(%edx),%edx
  803545:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  803547:	85 c0                	test   %eax,%eax
  803549:	75 08                	jne    803553 <ipc_recv+0x5a>
  80354b:	a1 28 64 80 00       	mov    0x806428,%eax
  803550:	8b 40 70             	mov    0x70(%eax),%eax
}
  803553:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803556:	5b                   	pop    %ebx
  803557:	5e                   	pop    %esi
  803558:	5d                   	pop    %ebp
  803559:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  80355a:	83 ec 0c             	sub    $0xc,%esp
  80355d:	68 00 00 c0 ee       	push   $0xeec00000
  803562:	e8 4c e2 ff ff       	call   8017b3 <sys_ipc_recv>
  803567:	83 c4 10             	add    $0x10,%esp
  80356a:	eb ab                	jmp    803517 <ipc_recv+0x1e>

0080356c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80356c:	55                   	push   %ebp
  80356d:	89 e5                	mov    %esp,%ebp
  80356f:	57                   	push   %edi
  803570:	56                   	push   %esi
  803571:	53                   	push   %ebx
  803572:	83 ec 0c             	sub    $0xc,%esp
  803575:	8b 7d 08             	mov    0x8(%ebp),%edi
  803578:	8b 75 10             	mov    0x10(%ebp),%esi
  80357b:	eb 20                	jmp    80359d <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80357d:	6a 00                	push   $0x0
  80357f:	68 00 00 c0 ee       	push   $0xeec00000
  803584:	ff 75 0c             	pushl  0xc(%ebp)
  803587:	57                   	push   %edi
  803588:	e8 03 e2 ff ff       	call   801790 <sys_ipc_try_send>
  80358d:	89 c3                	mov    %eax,%ebx
  80358f:	83 c4 10             	add    $0x10,%esp
  803592:	eb 1f                	jmp    8035b3 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  803594:	e8 4b e0 ff ff       	call   8015e4 <sys_yield>
	while(retval != 0) {
  803599:	85 db                	test   %ebx,%ebx
  80359b:	74 33                	je     8035d0 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80359d:	85 f6                	test   %esi,%esi
  80359f:	74 dc                	je     80357d <ipc_send+0x11>
  8035a1:	ff 75 14             	pushl  0x14(%ebp)
  8035a4:	56                   	push   %esi
  8035a5:	ff 75 0c             	pushl  0xc(%ebp)
  8035a8:	57                   	push   %edi
  8035a9:	e8 e2 e1 ff ff       	call   801790 <sys_ipc_try_send>
  8035ae:	89 c3                	mov    %eax,%ebx
  8035b0:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  8035b3:	83 fb f9             	cmp    $0xfffffff9,%ebx
  8035b6:	74 dc                	je     803594 <ipc_send+0x28>
  8035b8:	85 db                	test   %ebx,%ebx
  8035ba:	74 d8                	je     803594 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  8035bc:	83 ec 04             	sub    $0x4,%esp
  8035bf:	68 88 41 80 00       	push   $0x804188
  8035c4:	6a 35                	push   $0x35
  8035c6:	68 b8 41 80 00       	push   $0x8041b8
  8035cb:	e8 9a d4 ff ff       	call   800a6a <_panic>
	}
}
  8035d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8035d3:	5b                   	pop    %ebx
  8035d4:	5e                   	pop    %esi
  8035d5:	5f                   	pop    %edi
  8035d6:	5d                   	pop    %ebp
  8035d7:	c3                   	ret    

008035d8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8035d8:	55                   	push   %ebp
  8035d9:	89 e5                	mov    %esp,%ebp
  8035db:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8035de:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8035e3:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8035e6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8035ec:	8b 52 50             	mov    0x50(%edx),%edx
  8035ef:	39 ca                	cmp    %ecx,%edx
  8035f1:	74 11                	je     803604 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8035f3:	83 c0 01             	add    $0x1,%eax
  8035f6:	3d 00 04 00 00       	cmp    $0x400,%eax
  8035fb:	75 e6                	jne    8035e3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8035fd:	b8 00 00 00 00       	mov    $0x0,%eax
  803602:	eb 0b                	jmp    80360f <ipc_find_env+0x37>
			return envs[i].env_id;
  803604:	6b c0 7c             	imul   $0x7c,%eax,%eax
  803607:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80360c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80360f:	5d                   	pop    %ebp
  803610:	c3                   	ret    

00803611 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803611:	55                   	push   %ebp
  803612:	89 e5                	mov    %esp,%ebp
  803614:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803617:	89 d0                	mov    %edx,%eax
  803619:	c1 e8 16             	shr    $0x16,%eax
  80361c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803623:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  803628:	f6 c1 01             	test   $0x1,%cl
  80362b:	74 1d                	je     80364a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80362d:	c1 ea 0c             	shr    $0xc,%edx
  803630:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803637:	f6 c2 01             	test   $0x1,%dl
  80363a:	74 0e                	je     80364a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80363c:	c1 ea 0c             	shr    $0xc,%edx
  80363f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803646:	ef 
  803647:	0f b7 c0             	movzwl %ax,%eax
}
  80364a:	5d                   	pop    %ebp
  80364b:	c3                   	ret    
  80364c:	66 90                	xchg   %ax,%ax
  80364e:	66 90                	xchg   %ax,%ax

00803650 <__udivdi3>:
  803650:	f3 0f 1e fb          	endbr32 
  803654:	55                   	push   %ebp
  803655:	57                   	push   %edi
  803656:	56                   	push   %esi
  803657:	53                   	push   %ebx
  803658:	83 ec 1c             	sub    $0x1c,%esp
  80365b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80365f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803663:	8b 74 24 34          	mov    0x34(%esp),%esi
  803667:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80366b:	85 d2                	test   %edx,%edx
  80366d:	75 49                	jne    8036b8 <__udivdi3+0x68>
  80366f:	39 f3                	cmp    %esi,%ebx
  803671:	76 15                	jbe    803688 <__udivdi3+0x38>
  803673:	31 ff                	xor    %edi,%edi
  803675:	89 e8                	mov    %ebp,%eax
  803677:	89 f2                	mov    %esi,%edx
  803679:	f7 f3                	div    %ebx
  80367b:	89 fa                	mov    %edi,%edx
  80367d:	83 c4 1c             	add    $0x1c,%esp
  803680:	5b                   	pop    %ebx
  803681:	5e                   	pop    %esi
  803682:	5f                   	pop    %edi
  803683:	5d                   	pop    %ebp
  803684:	c3                   	ret    
  803685:	8d 76 00             	lea    0x0(%esi),%esi
  803688:	89 d9                	mov    %ebx,%ecx
  80368a:	85 db                	test   %ebx,%ebx
  80368c:	75 0b                	jne    803699 <__udivdi3+0x49>
  80368e:	b8 01 00 00 00       	mov    $0x1,%eax
  803693:	31 d2                	xor    %edx,%edx
  803695:	f7 f3                	div    %ebx
  803697:	89 c1                	mov    %eax,%ecx
  803699:	31 d2                	xor    %edx,%edx
  80369b:	89 f0                	mov    %esi,%eax
  80369d:	f7 f1                	div    %ecx
  80369f:	89 c6                	mov    %eax,%esi
  8036a1:	89 e8                	mov    %ebp,%eax
  8036a3:	89 f7                	mov    %esi,%edi
  8036a5:	f7 f1                	div    %ecx
  8036a7:	89 fa                	mov    %edi,%edx
  8036a9:	83 c4 1c             	add    $0x1c,%esp
  8036ac:	5b                   	pop    %ebx
  8036ad:	5e                   	pop    %esi
  8036ae:	5f                   	pop    %edi
  8036af:	5d                   	pop    %ebp
  8036b0:	c3                   	ret    
  8036b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8036b8:	39 f2                	cmp    %esi,%edx
  8036ba:	77 1c                	ja     8036d8 <__udivdi3+0x88>
  8036bc:	0f bd fa             	bsr    %edx,%edi
  8036bf:	83 f7 1f             	xor    $0x1f,%edi
  8036c2:	75 2c                	jne    8036f0 <__udivdi3+0xa0>
  8036c4:	39 f2                	cmp    %esi,%edx
  8036c6:	72 06                	jb     8036ce <__udivdi3+0x7e>
  8036c8:	31 c0                	xor    %eax,%eax
  8036ca:	39 eb                	cmp    %ebp,%ebx
  8036cc:	77 ad                	ja     80367b <__udivdi3+0x2b>
  8036ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8036d3:	eb a6                	jmp    80367b <__udivdi3+0x2b>
  8036d5:	8d 76 00             	lea    0x0(%esi),%esi
  8036d8:	31 ff                	xor    %edi,%edi
  8036da:	31 c0                	xor    %eax,%eax
  8036dc:	89 fa                	mov    %edi,%edx
  8036de:	83 c4 1c             	add    $0x1c,%esp
  8036e1:	5b                   	pop    %ebx
  8036e2:	5e                   	pop    %esi
  8036e3:	5f                   	pop    %edi
  8036e4:	5d                   	pop    %ebp
  8036e5:	c3                   	ret    
  8036e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8036ed:	8d 76 00             	lea    0x0(%esi),%esi
  8036f0:	89 f9                	mov    %edi,%ecx
  8036f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8036f7:	29 f8                	sub    %edi,%eax
  8036f9:	d3 e2                	shl    %cl,%edx
  8036fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8036ff:	89 c1                	mov    %eax,%ecx
  803701:	89 da                	mov    %ebx,%edx
  803703:	d3 ea                	shr    %cl,%edx
  803705:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803709:	09 d1                	or     %edx,%ecx
  80370b:	89 f2                	mov    %esi,%edx
  80370d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803711:	89 f9                	mov    %edi,%ecx
  803713:	d3 e3                	shl    %cl,%ebx
  803715:	89 c1                	mov    %eax,%ecx
  803717:	d3 ea                	shr    %cl,%edx
  803719:	89 f9                	mov    %edi,%ecx
  80371b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80371f:	89 eb                	mov    %ebp,%ebx
  803721:	d3 e6                	shl    %cl,%esi
  803723:	89 c1                	mov    %eax,%ecx
  803725:	d3 eb                	shr    %cl,%ebx
  803727:	09 de                	or     %ebx,%esi
  803729:	89 f0                	mov    %esi,%eax
  80372b:	f7 74 24 08          	divl   0x8(%esp)
  80372f:	89 d6                	mov    %edx,%esi
  803731:	89 c3                	mov    %eax,%ebx
  803733:	f7 64 24 0c          	mull   0xc(%esp)
  803737:	39 d6                	cmp    %edx,%esi
  803739:	72 15                	jb     803750 <__udivdi3+0x100>
  80373b:	89 f9                	mov    %edi,%ecx
  80373d:	d3 e5                	shl    %cl,%ebp
  80373f:	39 c5                	cmp    %eax,%ebp
  803741:	73 04                	jae    803747 <__udivdi3+0xf7>
  803743:	39 d6                	cmp    %edx,%esi
  803745:	74 09                	je     803750 <__udivdi3+0x100>
  803747:	89 d8                	mov    %ebx,%eax
  803749:	31 ff                	xor    %edi,%edi
  80374b:	e9 2b ff ff ff       	jmp    80367b <__udivdi3+0x2b>
  803750:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803753:	31 ff                	xor    %edi,%edi
  803755:	e9 21 ff ff ff       	jmp    80367b <__udivdi3+0x2b>
  80375a:	66 90                	xchg   %ax,%ax
  80375c:	66 90                	xchg   %ax,%ax
  80375e:	66 90                	xchg   %ax,%ax

00803760 <__umoddi3>:
  803760:	f3 0f 1e fb          	endbr32 
  803764:	55                   	push   %ebp
  803765:	57                   	push   %edi
  803766:	56                   	push   %esi
  803767:	53                   	push   %ebx
  803768:	83 ec 1c             	sub    $0x1c,%esp
  80376b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80376f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803773:	8b 74 24 30          	mov    0x30(%esp),%esi
  803777:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80377b:	89 da                	mov    %ebx,%edx
  80377d:	85 c0                	test   %eax,%eax
  80377f:	75 3f                	jne    8037c0 <__umoddi3+0x60>
  803781:	39 df                	cmp    %ebx,%edi
  803783:	76 13                	jbe    803798 <__umoddi3+0x38>
  803785:	89 f0                	mov    %esi,%eax
  803787:	f7 f7                	div    %edi
  803789:	89 d0                	mov    %edx,%eax
  80378b:	31 d2                	xor    %edx,%edx
  80378d:	83 c4 1c             	add    $0x1c,%esp
  803790:	5b                   	pop    %ebx
  803791:	5e                   	pop    %esi
  803792:	5f                   	pop    %edi
  803793:	5d                   	pop    %ebp
  803794:	c3                   	ret    
  803795:	8d 76 00             	lea    0x0(%esi),%esi
  803798:	89 fd                	mov    %edi,%ebp
  80379a:	85 ff                	test   %edi,%edi
  80379c:	75 0b                	jne    8037a9 <__umoddi3+0x49>
  80379e:	b8 01 00 00 00       	mov    $0x1,%eax
  8037a3:	31 d2                	xor    %edx,%edx
  8037a5:	f7 f7                	div    %edi
  8037a7:	89 c5                	mov    %eax,%ebp
  8037a9:	89 d8                	mov    %ebx,%eax
  8037ab:	31 d2                	xor    %edx,%edx
  8037ad:	f7 f5                	div    %ebp
  8037af:	89 f0                	mov    %esi,%eax
  8037b1:	f7 f5                	div    %ebp
  8037b3:	89 d0                	mov    %edx,%eax
  8037b5:	eb d4                	jmp    80378b <__umoddi3+0x2b>
  8037b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8037be:	66 90                	xchg   %ax,%ax
  8037c0:	89 f1                	mov    %esi,%ecx
  8037c2:	39 d8                	cmp    %ebx,%eax
  8037c4:	76 0a                	jbe    8037d0 <__umoddi3+0x70>
  8037c6:	89 f0                	mov    %esi,%eax
  8037c8:	83 c4 1c             	add    $0x1c,%esp
  8037cb:	5b                   	pop    %ebx
  8037cc:	5e                   	pop    %esi
  8037cd:	5f                   	pop    %edi
  8037ce:	5d                   	pop    %ebp
  8037cf:	c3                   	ret    
  8037d0:	0f bd e8             	bsr    %eax,%ebp
  8037d3:	83 f5 1f             	xor    $0x1f,%ebp
  8037d6:	75 20                	jne    8037f8 <__umoddi3+0x98>
  8037d8:	39 d8                	cmp    %ebx,%eax
  8037da:	0f 82 b0 00 00 00    	jb     803890 <__umoddi3+0x130>
  8037e0:	39 f7                	cmp    %esi,%edi
  8037e2:	0f 86 a8 00 00 00    	jbe    803890 <__umoddi3+0x130>
  8037e8:	89 c8                	mov    %ecx,%eax
  8037ea:	83 c4 1c             	add    $0x1c,%esp
  8037ed:	5b                   	pop    %ebx
  8037ee:	5e                   	pop    %esi
  8037ef:	5f                   	pop    %edi
  8037f0:	5d                   	pop    %ebp
  8037f1:	c3                   	ret    
  8037f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8037f8:	89 e9                	mov    %ebp,%ecx
  8037fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8037ff:	29 ea                	sub    %ebp,%edx
  803801:	d3 e0                	shl    %cl,%eax
  803803:	89 44 24 08          	mov    %eax,0x8(%esp)
  803807:	89 d1                	mov    %edx,%ecx
  803809:	89 f8                	mov    %edi,%eax
  80380b:	d3 e8                	shr    %cl,%eax
  80380d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803811:	89 54 24 04          	mov    %edx,0x4(%esp)
  803815:	8b 54 24 04          	mov    0x4(%esp),%edx
  803819:	09 c1                	or     %eax,%ecx
  80381b:	89 d8                	mov    %ebx,%eax
  80381d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803821:	89 e9                	mov    %ebp,%ecx
  803823:	d3 e7                	shl    %cl,%edi
  803825:	89 d1                	mov    %edx,%ecx
  803827:	d3 e8                	shr    %cl,%eax
  803829:	89 e9                	mov    %ebp,%ecx
  80382b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80382f:	d3 e3                	shl    %cl,%ebx
  803831:	89 c7                	mov    %eax,%edi
  803833:	89 d1                	mov    %edx,%ecx
  803835:	89 f0                	mov    %esi,%eax
  803837:	d3 e8                	shr    %cl,%eax
  803839:	89 e9                	mov    %ebp,%ecx
  80383b:	89 fa                	mov    %edi,%edx
  80383d:	d3 e6                	shl    %cl,%esi
  80383f:	09 d8                	or     %ebx,%eax
  803841:	f7 74 24 08          	divl   0x8(%esp)
  803845:	89 d1                	mov    %edx,%ecx
  803847:	89 f3                	mov    %esi,%ebx
  803849:	f7 64 24 0c          	mull   0xc(%esp)
  80384d:	89 c6                	mov    %eax,%esi
  80384f:	89 d7                	mov    %edx,%edi
  803851:	39 d1                	cmp    %edx,%ecx
  803853:	72 06                	jb     80385b <__umoddi3+0xfb>
  803855:	75 10                	jne    803867 <__umoddi3+0x107>
  803857:	39 c3                	cmp    %eax,%ebx
  803859:	73 0c                	jae    803867 <__umoddi3+0x107>
  80385b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80385f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803863:	89 d7                	mov    %edx,%edi
  803865:	89 c6                	mov    %eax,%esi
  803867:	89 ca                	mov    %ecx,%edx
  803869:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80386e:	29 f3                	sub    %esi,%ebx
  803870:	19 fa                	sbb    %edi,%edx
  803872:	89 d0                	mov    %edx,%eax
  803874:	d3 e0                	shl    %cl,%eax
  803876:	89 e9                	mov    %ebp,%ecx
  803878:	d3 eb                	shr    %cl,%ebx
  80387a:	d3 ea                	shr    %cl,%edx
  80387c:	09 d8                	or     %ebx,%eax
  80387e:	83 c4 1c             	add    $0x1c,%esp
  803881:	5b                   	pop    %ebx
  803882:	5e                   	pop    %esi
  803883:	5f                   	pop    %edi
  803884:	5d                   	pop    %ebp
  803885:	c3                   	ret    
  803886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80388d:	8d 76 00             	lea    0x0(%esi),%esi
  803890:	89 da                	mov    %ebx,%edx
  803892:	29 fe                	sub    %edi,%esi
  803894:	19 c2                	sbb    %eax,%edx
  803896:	89 f1                	mov    %esi,%ecx
  803898:	89 c8                	mov    %ecx,%eax
  80389a:	e9 4b ff ff ff       	jmp    8037ea <__umoddi3+0x8a>
