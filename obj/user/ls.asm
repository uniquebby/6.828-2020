
obj/user/ls.debug：     文件格式 elf32-i386


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
  80002c:	e8 95 02 00 00       	call   8002c6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80003e:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800045:	74 20                	je     800067 <ls1+0x34>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800047:	89 f0                	mov    %esi,%eax
  800049:	3c 01                	cmp    $0x1,%al
  80004b:	19 c0                	sbb    %eax,%eax
  80004d:	83 e0 c9             	and    $0xffffffc9,%eax
  800050:	83 c0 64             	add    $0x64,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	ff 75 10             	pushl  0x10(%ebp)
  80005a:	68 62 27 80 00       	push   $0x802762
  80005f:	e8 06 1a 00 00       	call   801a6a <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 1c                	je     800087 <ls1+0x54>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 c8 27 80 00       	mov    $0x8027c8,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	75 4b                	jne    8000c0 <ls1+0x8d>
		printf("%s%s", prefix, sep);
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	50                   	push   %eax
  800079:	53                   	push   %ebx
  80007a:	68 6b 27 80 00       	push   $0x80276b
  80007f:	e8 e6 19 00 00       	call   801a6a <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	pushl  0x14(%ebp)
  80008d:	68 fa 2b 80 00       	push   $0x802bfa
  800092:	e8 d3 19 00 00       	call   801a6a <printf>
	if(flag['F'] && isdir)
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000a1:	74 06                	je     8000a9 <ls1+0x76>
  8000a3:	89 f0                	mov    %esi,%eax
  8000a5:	84 c0                	test   %al,%al
  8000a7:	75 37                	jne    8000e0 <ls1+0xad>
		printf("/");
	printf("\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 c7 27 80 00       	push   $0x8027c7
  8000b1:	e8 b4 19 00 00       	call   801a6a <printf>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5e                   	pop    %esi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	53                   	push   %ebx
  8000c4:	e8 db 08 00 00       	call   8009a4 <strlen>
  8000c9:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000cc:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d1:	b8 60 27 80 00       	mov    $0x802760,%eax
  8000d6:	ba c8 27 80 00       	mov    $0x8027c8,%edx
  8000db:	0f 44 c2             	cmove  %edx,%eax
  8000de:	eb 95                	jmp    800075 <ls1+0x42>
		printf("/");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 60 27 80 00       	push   $0x802760
  8000e8:	e8 7d 19 00 00       	call   801a6a <printf>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	eb b7                	jmp    8000a9 <ls1+0x76>

008000f2 <lsdir>:
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000fe:	8b 7d 08             	mov    0x8(%ebp),%edi
	if ((fd = open(path, O_RDONLY)) < 0)
  800101:	6a 00                	push   $0x0
  800103:	57                   	push   %edi
  800104:	e8 be 17 00 00       	call   8018c7 <open>
  800109:	89 c3                	mov    %eax,%ebx
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	85 c0                	test   %eax,%eax
  800110:	78 4a                	js     80015c <lsdir+0x6a>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  800112:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	68 00 01 00 00       	push   $0x100
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	e8 7c 13 00 00       	call   8014a3 <readn>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80012f:	75 41                	jne    800172 <lsdir+0x80>
		if (f.f_name[0])
  800131:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  800138:	74 de                	je     800118 <lsdir+0x26>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  80013a:	56                   	push   %esi
  80013b:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800141:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800148:	0f 94 c0             	sete   %al
  80014b:	0f b6 c0             	movzbl %al,%eax
  80014e:	50                   	push   %eax
  80014f:	ff 75 0c             	pushl  0xc(%ebp)
  800152:	e8 dc fe ff ff       	call   800033 <ls1>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	eb bc                	jmp    800118 <lsdir+0x26>
		panic("open %s: %e", path, fd);
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	50                   	push   %eax
  800160:	57                   	push   %edi
  800161:	68 70 27 80 00       	push   $0x802770
  800166:	6a 1d                	push   $0x1d
  800168:	68 7c 27 80 00       	push   $0x80277c
  80016d:	e8 b4 01 00 00       	call   800326 <_panic>
	if (n > 0)
  800172:	85 c0                	test   %eax,%eax
  800174:	7f 0a                	jg     800180 <lsdir+0x8e>
	if (n < 0)
  800176:	78 1a                	js     800192 <lsdir+0xa0>
}
  800178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017b:	5b                   	pop    %ebx
  80017c:	5e                   	pop    %esi
  80017d:	5f                   	pop    %edi
  80017e:	5d                   	pop    %ebp
  80017f:	c3                   	ret    
		panic("short read in directory %s", path);
  800180:	57                   	push   %edi
  800181:	68 86 27 80 00       	push   $0x802786
  800186:	6a 22                	push   $0x22
  800188:	68 7c 27 80 00       	push   $0x80277c
  80018d:	e8 94 01 00 00       	call   800326 <_panic>
		panic("error reading directory %s: %e", path, n);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	57                   	push   %edi
  800197:	68 cc 27 80 00       	push   $0x8027cc
  80019c:	6a 24                	push   $0x24
  80019e:	68 7c 27 80 00       	push   $0x80277c
  8001a3:	e8 7e 01 00 00       	call   800326 <_panic>

008001a8 <ls>:
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	53                   	push   %ebx
  8001ac:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((r = stat(path, &st)) < 0)
  8001b5:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001bb:	50                   	push   %eax
  8001bc:	53                   	push   %ebx
  8001bd:	e8 c4 14 00 00       	call   801686 <stat>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	78 2c                	js     8001f5 <ls+0x4d>
	if (st.st_isdir && !flag['d'])
  8001c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001cc:	85 c0                	test   %eax,%eax
  8001ce:	74 09                	je     8001d9 <ls+0x31>
  8001d0:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  8001d7:	74 32                	je     80020b <ls+0x63>
		ls1(0, st.st_isdir, st.st_size, path);
  8001d9:	53                   	push   %ebx
  8001da:	ff 75 ec             	pushl  -0x14(%ebp)
  8001dd:	85 c0                	test   %eax,%eax
  8001df:	0f 95 c0             	setne  %al
  8001e2:	0f b6 c0             	movzbl %al,%eax
  8001e5:	50                   	push   %eax
  8001e6:	6a 00                	push   $0x0
  8001e8:	e8 46 fe ff ff       	call   800033 <ls1>
  8001ed:	83 c4 10             	add    $0x10,%esp
}
  8001f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    
		panic("stat %s: %e", path, r);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	53                   	push   %ebx
  8001fa:	68 a1 27 80 00       	push   $0x8027a1
  8001ff:	6a 0f                	push   $0xf
  800201:	68 7c 27 80 00       	push   $0x80277c
  800206:	e8 1b 01 00 00       	call   800326 <_panic>
		lsdir(path, prefix);
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	ff 75 0c             	pushl  0xc(%ebp)
  800211:	53                   	push   %ebx
  800212:	e8 db fe ff ff       	call   8000f2 <lsdir>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	eb d4                	jmp    8001f0 <ls+0x48>

0080021c <usage>:

void
usage(void)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800222:	68 ad 27 80 00       	push   $0x8027ad
  800227:	e8 3e 18 00 00       	call   801a6a <printf>
	exit();
  80022c:	e8 db 00 00 00       	call   80030c <exit>
}
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <umain>:

void
umain(int argc, char **argv)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	56                   	push   %esi
  80023a:	53                   	push   %ebx
  80023b:	83 ec 14             	sub    $0x14,%esp
  80023e:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800241:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800244:	50                   	push   %eax
  800245:	56                   	push   %esi
  800246:	8d 45 08             	lea    0x8(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	e8 90 0d 00 00       	call   800fdf <argstart>
	while ((i = argnext(&args)) >= 0)
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800255:	eb 08                	jmp    80025f <umain+0x29>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800257:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  80025e:	01 
	while ((i = argnext(&args)) >= 0)
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	53                   	push   %ebx
  800263:	e8 a7 0d 00 00       	call   80100f <argnext>
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	85 c0                	test   %eax,%eax
  80026d:	78 16                	js     800285 <umain+0x4f>
		switch (i) {
  80026f:	83 f8 64             	cmp    $0x64,%eax
  800272:	74 e3                	je     800257 <umain+0x21>
  800274:	83 f8 6c             	cmp    $0x6c,%eax
  800277:	74 de                	je     800257 <umain+0x21>
  800279:	83 f8 46             	cmp    $0x46,%eax
  80027c:	74 d9                	je     800257 <umain+0x21>
			break;
		default:
			usage();
  80027e:	e8 99 ff ff ff       	call   80021c <usage>
  800283:	eb da                	jmp    80025f <umain+0x29>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800285:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  80028a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80028e:	75 2a                	jne    8002ba <umain+0x84>
		ls("/", "");
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	68 c8 27 80 00       	push   $0x8027c8
  800298:	68 60 27 80 00       	push   $0x802760
  80029d:	e8 06 ff ff ff       	call   8001a8 <ls>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	eb 18                	jmp    8002bf <umain+0x89>
			ls(argv[i], argv[i]);
  8002a7:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	50                   	push   %eax
  8002ae:	50                   	push   %eax
  8002af:	e8 f4 fe ff ff       	call   8001a8 <ls>
		for (i = 1; i < argc; i++)
  8002b4:	83 c3 01             	add    $0x1,%ebx
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  8002bd:	7f e8                	jg     8002a7 <umain+0x71>
	}
}
  8002bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c2:	5b                   	pop    %ebx
  8002c3:	5e                   	pop    %esi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002ce:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002d1:	e8 bb 0a 00 00       	call   800d91 <sys_getenvid>
  8002d6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002db:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e3:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e8:	85 db                	test   %ebx,%ebx
  8002ea:	7e 07                	jle    8002f3 <libmain+0x2d>
		binaryname = argv[0];
  8002ec:	8b 06                	mov    (%esi),%eax
  8002ee:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002f3:	83 ec 08             	sub    $0x8,%esp
  8002f6:	56                   	push   %esi
  8002f7:	53                   	push   %ebx
  8002f8:	e8 39 ff ff ff       	call   800236 <umain>

	// exit gracefully
	exit();
  8002fd:	e8 0a 00 00 00       	call   80030c <exit>
}
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800308:	5b                   	pop    %ebx
  800309:	5e                   	pop    %esi
  80030a:	5d                   	pop    %ebp
  80030b:	c3                   	ret    

0080030c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800312:	e8 f4 0f 00 00       	call   80130b <close_all>
	sys_env_destroy(0);
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	6a 00                	push   $0x0
  80031c:	e8 2f 0a 00 00       	call   800d50 <sys_env_destroy>
}
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	c9                   	leave  
  800325:	c3                   	ret    

00800326 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	56                   	push   %esi
  80032a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80032b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80032e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800334:	e8 58 0a 00 00       	call   800d91 <sys_getenvid>
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 0c             	pushl  0xc(%ebp)
  80033f:	ff 75 08             	pushl  0x8(%ebp)
  800342:	56                   	push   %esi
  800343:	50                   	push   %eax
  800344:	68 f8 27 80 00       	push   $0x8027f8
  800349:	e8 b3 00 00 00       	call   800401 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80034e:	83 c4 18             	add    $0x18,%esp
  800351:	53                   	push   %ebx
  800352:	ff 75 10             	pushl  0x10(%ebp)
  800355:	e8 56 00 00 00       	call   8003b0 <vcprintf>
	cprintf("\n");
  80035a:	c7 04 24 c7 27 80 00 	movl   $0x8027c7,(%esp)
  800361:	e8 9b 00 00 00       	call   800401 <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800369:	cc                   	int3   
  80036a:	eb fd                	jmp    800369 <_panic+0x43>

0080036c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	53                   	push   %ebx
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800376:	8b 13                	mov    (%ebx),%edx
  800378:	8d 42 01             	lea    0x1(%edx),%eax
  80037b:	89 03                	mov    %eax,(%ebx)
  80037d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800380:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800384:	3d ff 00 00 00       	cmp    $0xff,%eax
  800389:	74 09                	je     800394 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80038b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80038f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800392:	c9                   	leave  
  800393:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800394:	83 ec 08             	sub    $0x8,%esp
  800397:	68 ff 00 00 00       	push   $0xff
  80039c:	8d 43 08             	lea    0x8(%ebx),%eax
  80039f:	50                   	push   %eax
  8003a0:	e8 6e 09 00 00       	call   800d13 <sys_cputs>
		b->idx = 0;
  8003a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	eb db                	jmp    80038b <putch+0x1f>

008003b0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c0:	00 00 00 
	b.cnt = 0;
  8003c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ca:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003cd:	ff 75 0c             	pushl  0xc(%ebp)
  8003d0:	ff 75 08             	pushl  0x8(%ebp)
  8003d3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003d9:	50                   	push   %eax
  8003da:	68 6c 03 80 00       	push   $0x80036c
  8003df:	e8 19 01 00 00       	call   8004fd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003e4:	83 c4 08             	add    $0x8,%esp
  8003e7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003ed:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003f3:	50                   	push   %eax
  8003f4:	e8 1a 09 00 00       	call   800d13 <sys_cputs>

	return b.cnt;
}
  8003f9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    

00800401 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800407:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80040a:	50                   	push   %eax
  80040b:	ff 75 08             	pushl  0x8(%ebp)
  80040e:	e8 9d ff ff ff       	call   8003b0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800413:	c9                   	leave  
  800414:	c3                   	ret    

00800415 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800415:	55                   	push   %ebp
  800416:	89 e5                	mov    %esp,%ebp
  800418:	57                   	push   %edi
  800419:	56                   	push   %esi
  80041a:	53                   	push   %ebx
  80041b:	83 ec 1c             	sub    $0x1c,%esp
  80041e:	89 c7                	mov    %eax,%edi
  800420:	89 d6                	mov    %edx,%esi
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	8b 55 0c             	mov    0xc(%ebp),%edx
  800428:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80042e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800431:	bb 00 00 00 00       	mov    $0x0,%ebx
  800436:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800439:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80043c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80043f:	89 d0                	mov    %edx,%eax
  800441:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800444:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800447:	73 15                	jae    80045e <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800449:	83 eb 01             	sub    $0x1,%ebx
  80044c:	85 db                	test   %ebx,%ebx
  80044e:	7e 43                	jle    800493 <printnum+0x7e>
			putch(padc, putdat);
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	56                   	push   %esi
  800454:	ff 75 18             	pushl  0x18(%ebp)
  800457:	ff d7                	call   *%edi
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	eb eb                	jmp    800449 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80045e:	83 ec 0c             	sub    $0xc,%esp
  800461:	ff 75 18             	pushl  0x18(%ebp)
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80046a:	53                   	push   %ebx
  80046b:	ff 75 10             	pushl  0x10(%ebp)
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	ff 75 e4             	pushl  -0x1c(%ebp)
  800474:	ff 75 e0             	pushl  -0x20(%ebp)
  800477:	ff 75 dc             	pushl  -0x24(%ebp)
  80047a:	ff 75 d8             	pushl  -0x28(%ebp)
  80047d:	e8 7e 20 00 00       	call   802500 <__udivdi3>
  800482:	83 c4 18             	add    $0x18,%esp
  800485:	52                   	push   %edx
  800486:	50                   	push   %eax
  800487:	89 f2                	mov    %esi,%edx
  800489:	89 f8                	mov    %edi,%eax
  80048b:	e8 85 ff ff ff       	call   800415 <printnum>
  800490:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	56                   	push   %esi
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049d:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8004a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a6:	e8 65 21 00 00       	call   802610 <__umoddi3>
  8004ab:	83 c4 14             	add    $0x14,%esp
  8004ae:	0f be 80 1b 28 80 00 	movsbl 0x80281b(%eax),%eax
  8004b5:	50                   	push   %eax
  8004b6:	ff d7                	call   *%edi
}
  8004b8:	83 c4 10             	add    $0x10,%esp
  8004bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004be:	5b                   	pop    %ebx
  8004bf:	5e                   	pop    %esi
  8004c0:	5f                   	pop    %edi
  8004c1:	5d                   	pop    %ebp
  8004c2:	c3                   	ret    

008004c3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
  8004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004c9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004cd:	8b 10                	mov    (%eax),%edx
  8004cf:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d2:	73 0a                	jae    8004de <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004d7:	89 08                	mov    %ecx,(%eax)
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	88 02                	mov    %al,(%edx)
}
  8004de:	5d                   	pop    %ebp
  8004df:	c3                   	ret    

008004e0 <printfmt>:
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004e6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004e9:	50                   	push   %eax
  8004ea:	ff 75 10             	pushl  0x10(%ebp)
  8004ed:	ff 75 0c             	pushl  0xc(%ebp)
  8004f0:	ff 75 08             	pushl  0x8(%ebp)
  8004f3:	e8 05 00 00 00       	call   8004fd <vprintfmt>
}
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	c9                   	leave  
  8004fc:	c3                   	ret    

008004fd <vprintfmt>:
{
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	57                   	push   %edi
  800501:	56                   	push   %esi
  800502:	53                   	push   %ebx
  800503:	83 ec 3c             	sub    $0x3c,%esp
  800506:	8b 75 08             	mov    0x8(%ebp),%esi
  800509:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80050f:	eb 0a                	jmp    80051b <vprintfmt+0x1e>
			putch(ch, putdat);
  800511:	83 ec 08             	sub    $0x8,%esp
  800514:	53                   	push   %ebx
  800515:	50                   	push   %eax
  800516:	ff d6                	call   *%esi
  800518:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80051b:	83 c7 01             	add    $0x1,%edi
  80051e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800522:	83 f8 25             	cmp    $0x25,%eax
  800525:	74 0c                	je     800533 <vprintfmt+0x36>
			if (ch == '\0')
  800527:	85 c0                	test   %eax,%eax
  800529:	75 e6                	jne    800511 <vprintfmt+0x14>
}
  80052b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80052e:	5b                   	pop    %ebx
  80052f:	5e                   	pop    %esi
  800530:	5f                   	pop    %edi
  800531:	5d                   	pop    %ebp
  800532:	c3                   	ret    
		padc = ' ';
  800533:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800537:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80053e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800545:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80054c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800551:	8d 47 01             	lea    0x1(%edi),%eax
  800554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800557:	0f b6 17             	movzbl (%edi),%edx
  80055a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80055d:	3c 55                	cmp    $0x55,%al
  80055f:	0f 87 ba 03 00 00    	ja     80091f <vprintfmt+0x422>
  800565:	0f b6 c0             	movzbl %al,%eax
  800568:	ff 24 85 60 29 80 00 	jmp    *0x802960(,%eax,4)
  80056f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800572:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800576:	eb d9                	jmp    800551 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800578:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80057b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80057f:	eb d0                	jmp    800551 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800581:	0f b6 d2             	movzbl %dl,%edx
  800584:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800587:	b8 00 00 00 00       	mov    $0x0,%eax
  80058c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80058f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800592:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800596:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800599:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80059c:	83 f9 09             	cmp    $0x9,%ecx
  80059f:	77 55                	ja     8005f6 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8005a1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005a4:	eb e9                	jmp    80058f <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8d 40 04             	lea    0x4(%eax),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005be:	79 91                	jns    800551 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005cd:	eb 82                	jmp    800551 <vprintfmt+0x54>
  8005cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d2:	85 c0                	test   %eax,%eax
  8005d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d9:	0f 49 d0             	cmovns %eax,%edx
  8005dc:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005e2:	e9 6a ff ff ff       	jmp    800551 <vprintfmt+0x54>
  8005e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005ea:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005f1:	e9 5b ff ff ff       	jmp    800551 <vprintfmt+0x54>
  8005f6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fc:	eb bc                	jmp    8005ba <vprintfmt+0xbd>
			lflag++;
  8005fe:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800601:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800604:	e9 48 ff ff ff       	jmp    800551 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8d 78 04             	lea    0x4(%eax),%edi
  80060f:	83 ec 08             	sub    $0x8,%esp
  800612:	53                   	push   %ebx
  800613:	ff 30                	pushl  (%eax)
  800615:	ff d6                	call   *%esi
			break;
  800617:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80061a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80061d:	e9 9c 02 00 00       	jmp    8008be <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8d 78 04             	lea    0x4(%eax),%edi
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	99                   	cltd   
  80062b:	31 d0                	xor    %edx,%eax
  80062d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80062f:	83 f8 0f             	cmp    $0xf,%eax
  800632:	7f 23                	jg     800657 <vprintfmt+0x15a>
  800634:	8b 14 85 c0 2a 80 00 	mov    0x802ac0(,%eax,4),%edx
  80063b:	85 d2                	test   %edx,%edx
  80063d:	74 18                	je     800657 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  80063f:	52                   	push   %edx
  800640:	68 fa 2b 80 00       	push   $0x802bfa
  800645:	53                   	push   %ebx
  800646:	56                   	push   %esi
  800647:	e8 94 fe ff ff       	call   8004e0 <printfmt>
  80064c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80064f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800652:	e9 67 02 00 00       	jmp    8008be <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800657:	50                   	push   %eax
  800658:	68 33 28 80 00       	push   $0x802833
  80065d:	53                   	push   %ebx
  80065e:	56                   	push   %esi
  80065f:	e8 7c fe ff ff       	call   8004e0 <printfmt>
  800664:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800667:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80066a:	e9 4f 02 00 00       	jmp    8008be <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	83 c0 04             	add    $0x4,%eax
  800675:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80067d:	85 d2                	test   %edx,%edx
  80067f:	b8 2c 28 80 00       	mov    $0x80282c,%eax
  800684:	0f 45 c2             	cmovne %edx,%eax
  800687:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80068a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80068e:	7e 06                	jle    800696 <vprintfmt+0x199>
  800690:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800694:	75 0d                	jne    8006a3 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800696:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800699:	89 c7                	mov    %eax,%edi
  80069b:	03 45 e0             	add    -0x20(%ebp),%eax
  80069e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a1:	eb 3f                	jmp    8006e2 <vprintfmt+0x1e5>
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	ff 75 d8             	pushl  -0x28(%ebp)
  8006a9:	50                   	push   %eax
  8006aa:	e8 0d 03 00 00       	call   8009bc <strnlen>
  8006af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006b2:	29 c2                	sub    %eax,%edx
  8006b4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006bc:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c3:	85 ff                	test   %edi,%edi
  8006c5:	7e 58                	jle    80071f <vprintfmt+0x222>
					putch(padc, putdat);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	53                   	push   %ebx
  8006cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ce:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d0:	83 ef 01             	sub    $0x1,%edi
  8006d3:	83 c4 10             	add    $0x10,%esp
  8006d6:	eb eb                	jmp    8006c3 <vprintfmt+0x1c6>
					putch(ch, putdat);
  8006d8:	83 ec 08             	sub    $0x8,%esp
  8006db:	53                   	push   %ebx
  8006dc:	52                   	push   %edx
  8006dd:	ff d6                	call   *%esi
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006e5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e7:	83 c7 01             	add    $0x1,%edi
  8006ea:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ee:	0f be d0             	movsbl %al,%edx
  8006f1:	85 d2                	test   %edx,%edx
  8006f3:	74 45                	je     80073a <vprintfmt+0x23d>
  8006f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006f9:	78 06                	js     800701 <vprintfmt+0x204>
  8006fb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006ff:	78 35                	js     800736 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800701:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800705:	74 d1                	je     8006d8 <vprintfmt+0x1db>
  800707:	0f be c0             	movsbl %al,%eax
  80070a:	83 e8 20             	sub    $0x20,%eax
  80070d:	83 f8 5e             	cmp    $0x5e,%eax
  800710:	76 c6                	jbe    8006d8 <vprintfmt+0x1db>
					putch('?', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	53                   	push   %ebx
  800716:	6a 3f                	push   $0x3f
  800718:	ff d6                	call   *%esi
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	eb c3                	jmp    8006e2 <vprintfmt+0x1e5>
  80071f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800722:	85 d2                	test   %edx,%edx
  800724:	b8 00 00 00 00       	mov    $0x0,%eax
  800729:	0f 49 c2             	cmovns %edx,%eax
  80072c:	29 c2                	sub    %eax,%edx
  80072e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800731:	e9 60 ff ff ff       	jmp    800696 <vprintfmt+0x199>
  800736:	89 cf                	mov    %ecx,%edi
  800738:	eb 02                	jmp    80073c <vprintfmt+0x23f>
  80073a:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  80073c:	85 ff                	test   %edi,%edi
  80073e:	7e 10                	jle    800750 <vprintfmt+0x253>
				putch(' ', putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	6a 20                	push   $0x20
  800746:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800748:	83 ef 01             	sub    $0x1,%edi
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	eb ec                	jmp    80073c <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800750:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
  800756:	e9 63 01 00 00       	jmp    8008be <vprintfmt+0x3c1>
	if (lflag >= 2)
  80075b:	83 f9 01             	cmp    $0x1,%ecx
  80075e:	7f 1b                	jg     80077b <vprintfmt+0x27e>
	else if (lflag)
  800760:	85 c9                	test   %ecx,%ecx
  800762:	74 63                	je     8007c7 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8b 00                	mov    (%eax),%eax
  800769:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076c:	99                   	cltd   
  80076d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8d 40 04             	lea    0x4(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
  800779:	eb 17                	jmp    800792 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8b 50 04             	mov    0x4(%eax),%edx
  800781:	8b 00                	mov    (%eax),%eax
  800783:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800786:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8d 40 08             	lea    0x8(%eax),%eax
  80078f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800792:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800795:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800798:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80079d:	85 c9                	test   %ecx,%ecx
  80079f:	0f 89 ff 00 00 00    	jns    8008a4 <vprintfmt+0x3a7>
				putch('-', putdat);
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	53                   	push   %ebx
  8007a9:	6a 2d                	push   $0x2d
  8007ab:	ff d6                	call   *%esi
				num = -(long long) num;
  8007ad:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007b0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007b3:	f7 da                	neg    %edx
  8007b5:	83 d1 00             	adc    $0x0,%ecx
  8007b8:	f7 d9                	neg    %ecx
  8007ba:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c2:	e9 dd 00 00 00       	jmp    8008a4 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8b 00                	mov    (%eax),%eax
  8007cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cf:	99                   	cltd   
  8007d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8d 40 04             	lea    0x4(%eax),%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dc:	eb b4                	jmp    800792 <vprintfmt+0x295>
	if (lflag >= 2)
  8007de:	83 f9 01             	cmp    $0x1,%ecx
  8007e1:	7f 1e                	jg     800801 <vprintfmt+0x304>
	else if (lflag)
  8007e3:	85 c9                	test   %ecx,%ecx
  8007e5:	74 32                	je     800819 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8b 10                	mov    (%eax),%edx
  8007ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f1:	8d 40 04             	lea    0x4(%eax),%eax
  8007f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fc:	e9 a3 00 00 00       	jmp    8008a4 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8b 10                	mov    (%eax),%edx
  800806:	8b 48 04             	mov    0x4(%eax),%ecx
  800809:	8d 40 08             	lea    0x8(%eax),%eax
  80080c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80080f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800814:	e9 8b 00 00 00       	jmp    8008a4 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	8b 10                	mov    (%eax),%edx
  80081e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800823:	8d 40 04             	lea    0x4(%eax),%eax
  800826:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800829:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082e:	eb 74                	jmp    8008a4 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800830:	83 f9 01             	cmp    $0x1,%ecx
  800833:	7f 1b                	jg     800850 <vprintfmt+0x353>
	else if (lflag)
  800835:	85 c9                	test   %ecx,%ecx
  800837:	74 2c                	je     800865 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	8b 10                	mov    (%eax),%edx
  80083e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800843:	8d 40 04             	lea    0x4(%eax),%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800849:	b8 08 00 00 00       	mov    $0x8,%eax
  80084e:	eb 54                	jmp    8008a4 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8b 10                	mov    (%eax),%edx
  800855:	8b 48 04             	mov    0x4(%eax),%ecx
  800858:	8d 40 08             	lea    0x8(%eax),%eax
  80085b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80085e:	b8 08 00 00 00       	mov    $0x8,%eax
  800863:	eb 3f                	jmp    8008a4 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8b 10                	mov    (%eax),%edx
  80086a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80086f:	8d 40 04             	lea    0x4(%eax),%eax
  800872:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800875:	b8 08 00 00 00       	mov    $0x8,%eax
  80087a:	eb 28                	jmp    8008a4 <vprintfmt+0x3a7>
			putch('0', putdat);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	53                   	push   %ebx
  800880:	6a 30                	push   $0x30
  800882:	ff d6                	call   *%esi
			putch('x', putdat);
  800884:	83 c4 08             	add    $0x8,%esp
  800887:	53                   	push   %ebx
  800888:	6a 78                	push   $0x78
  80088a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8b 10                	mov    (%eax),%edx
  800891:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800896:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800899:	8d 40 04             	lea    0x4(%eax),%eax
  80089c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80089f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008a4:	83 ec 0c             	sub    $0xc,%esp
  8008a7:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008ab:	57                   	push   %edi
  8008ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8008af:	50                   	push   %eax
  8008b0:	51                   	push   %ecx
  8008b1:	52                   	push   %edx
  8008b2:	89 da                	mov    %ebx,%edx
  8008b4:	89 f0                	mov    %esi,%eax
  8008b6:	e8 5a fb ff ff       	call   800415 <printnum>
			break;
  8008bb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c1:	e9 55 fc ff ff       	jmp    80051b <vprintfmt+0x1e>
	if (lflag >= 2)
  8008c6:	83 f9 01             	cmp    $0x1,%ecx
  8008c9:	7f 1b                	jg     8008e6 <vprintfmt+0x3e9>
	else if (lflag)
  8008cb:	85 c9                	test   %ecx,%ecx
  8008cd:	74 2c                	je     8008fb <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8b 10                	mov    (%eax),%edx
  8008d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008d9:	8d 40 04             	lea    0x4(%eax),%eax
  8008dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008df:	b8 10 00 00 00       	mov    $0x10,%eax
  8008e4:	eb be                	jmp    8008a4 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	8b 10                	mov    (%eax),%edx
  8008eb:	8b 48 04             	mov    0x4(%eax),%ecx
  8008ee:	8d 40 08             	lea    0x8(%eax),%eax
  8008f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f4:	b8 10 00 00 00       	mov    $0x10,%eax
  8008f9:	eb a9                	jmp    8008a4 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	8b 10                	mov    (%eax),%edx
  800900:	b9 00 00 00 00       	mov    $0x0,%ecx
  800905:	8d 40 04             	lea    0x4(%eax),%eax
  800908:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80090b:	b8 10 00 00 00       	mov    $0x10,%eax
  800910:	eb 92                	jmp    8008a4 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	53                   	push   %ebx
  800916:	6a 25                	push   $0x25
  800918:	ff d6                	call   *%esi
			break;
  80091a:	83 c4 10             	add    $0x10,%esp
  80091d:	eb 9f                	jmp    8008be <vprintfmt+0x3c1>
			putch('%', putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	53                   	push   %ebx
  800923:	6a 25                	push   $0x25
  800925:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800927:	83 c4 10             	add    $0x10,%esp
  80092a:	89 f8                	mov    %edi,%eax
  80092c:	eb 03                	jmp    800931 <vprintfmt+0x434>
  80092e:	83 e8 01             	sub    $0x1,%eax
  800931:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800935:	75 f7                	jne    80092e <vprintfmt+0x431>
  800937:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80093a:	eb 82                	jmp    8008be <vprintfmt+0x3c1>

0080093c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	83 ec 18             	sub    $0x18,%esp
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800948:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80094b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80094f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800952:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800959:	85 c0                	test   %eax,%eax
  80095b:	74 26                	je     800983 <vsnprintf+0x47>
  80095d:	85 d2                	test   %edx,%edx
  80095f:	7e 22                	jle    800983 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800961:	ff 75 14             	pushl  0x14(%ebp)
  800964:	ff 75 10             	pushl  0x10(%ebp)
  800967:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80096a:	50                   	push   %eax
  80096b:	68 c3 04 80 00       	push   $0x8004c3
  800970:	e8 88 fb ff ff       	call   8004fd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800978:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80097b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80097e:	83 c4 10             	add    $0x10,%esp
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    
		return -E_INVAL;
  800983:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800988:	eb f7                	jmp    800981 <vsnprintf+0x45>

0080098a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800990:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800993:	50                   	push   %eax
  800994:	ff 75 10             	pushl  0x10(%ebp)
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	ff 75 08             	pushl  0x8(%ebp)
  80099d:	e8 9a ff ff ff       	call   80093c <vsnprintf>
	va_end(ap);

	return rc;
}
  8009a2:	c9                   	leave  
  8009a3:	c3                   	ret    

008009a4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8009af:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009b3:	74 05                	je     8009ba <strlen+0x16>
		n++;
  8009b5:	83 c0 01             	add    $0x1,%eax
  8009b8:	eb f5                	jmp    8009af <strlen+0xb>
	return n;
}
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c2:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ca:	39 c2                	cmp    %eax,%edx
  8009cc:	74 0d                	je     8009db <strnlen+0x1f>
  8009ce:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009d2:	74 05                	je     8009d9 <strnlen+0x1d>
		n++;
  8009d4:	83 c2 01             	add    $0x1,%edx
  8009d7:	eb f1                	jmp    8009ca <strnlen+0xe>
  8009d9:	89 d0                	mov    %edx,%eax
	return n;
}
  8009db:	5d                   	pop    %ebp
  8009dc:	c3                   	ret    

008009dd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	53                   	push   %ebx
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ec:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009f0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009f3:	83 c2 01             	add    $0x1,%edx
  8009f6:	84 c9                	test   %cl,%cl
  8009f8:	75 f2                	jne    8009ec <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009fa:	5b                   	pop    %ebx
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	53                   	push   %ebx
  800a01:	83 ec 10             	sub    $0x10,%esp
  800a04:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a07:	53                   	push   %ebx
  800a08:	e8 97 ff ff ff       	call   8009a4 <strlen>
  800a0d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	01 d8                	add    %ebx,%eax
  800a15:	50                   	push   %eax
  800a16:	e8 c2 ff ff ff       	call   8009dd <strcpy>
	return dst;
}
  800a1b:	89 d8                	mov    %ebx,%eax
  800a1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a20:	c9                   	leave  
  800a21:	c3                   	ret    

00800a22 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	56                   	push   %esi
  800a26:	53                   	push   %ebx
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a2d:	89 c6                	mov    %eax,%esi
  800a2f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a32:	89 c2                	mov    %eax,%edx
  800a34:	39 f2                	cmp    %esi,%edx
  800a36:	74 11                	je     800a49 <strncpy+0x27>
		*dst++ = *src;
  800a38:	83 c2 01             	add    $0x1,%edx
  800a3b:	0f b6 19             	movzbl (%ecx),%ebx
  800a3e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a41:	80 fb 01             	cmp    $0x1,%bl
  800a44:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a47:	eb eb                	jmp    800a34 <strncpy+0x12>
	}
	return ret;
}
  800a49:	5b                   	pop    %ebx
  800a4a:	5e                   	pop    %esi
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	56                   	push   %esi
  800a51:	53                   	push   %ebx
  800a52:	8b 75 08             	mov    0x8(%ebp),%esi
  800a55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a58:	8b 55 10             	mov    0x10(%ebp),%edx
  800a5b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a5d:	85 d2                	test   %edx,%edx
  800a5f:	74 21                	je     800a82 <strlcpy+0x35>
  800a61:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a65:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a67:	39 c2                	cmp    %eax,%edx
  800a69:	74 14                	je     800a7f <strlcpy+0x32>
  800a6b:	0f b6 19             	movzbl (%ecx),%ebx
  800a6e:	84 db                	test   %bl,%bl
  800a70:	74 0b                	je     800a7d <strlcpy+0x30>
			*dst++ = *src++;
  800a72:	83 c1 01             	add    $0x1,%ecx
  800a75:	83 c2 01             	add    $0x1,%edx
  800a78:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a7b:	eb ea                	jmp    800a67 <strlcpy+0x1a>
  800a7d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a7f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a82:	29 f0                	sub    %esi,%eax
}
  800a84:	5b                   	pop    %ebx
  800a85:	5e                   	pop    %esi
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a91:	0f b6 01             	movzbl (%ecx),%eax
  800a94:	84 c0                	test   %al,%al
  800a96:	74 0c                	je     800aa4 <strcmp+0x1c>
  800a98:	3a 02                	cmp    (%edx),%al
  800a9a:	75 08                	jne    800aa4 <strcmp+0x1c>
		p++, q++;
  800a9c:	83 c1 01             	add    $0x1,%ecx
  800a9f:	83 c2 01             	add    $0x1,%edx
  800aa2:	eb ed                	jmp    800a91 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa4:	0f b6 c0             	movzbl %al,%eax
  800aa7:	0f b6 12             	movzbl (%edx),%edx
  800aaa:	29 d0                	sub    %edx,%eax
}
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	53                   	push   %ebx
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab8:	89 c3                	mov    %eax,%ebx
  800aba:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800abd:	eb 06                	jmp    800ac5 <strncmp+0x17>
		n--, p++, q++;
  800abf:	83 c0 01             	add    $0x1,%eax
  800ac2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ac5:	39 d8                	cmp    %ebx,%eax
  800ac7:	74 16                	je     800adf <strncmp+0x31>
  800ac9:	0f b6 08             	movzbl (%eax),%ecx
  800acc:	84 c9                	test   %cl,%cl
  800ace:	74 04                	je     800ad4 <strncmp+0x26>
  800ad0:	3a 0a                	cmp    (%edx),%cl
  800ad2:	74 eb                	je     800abf <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad4:	0f b6 00             	movzbl (%eax),%eax
  800ad7:	0f b6 12             	movzbl (%edx),%edx
  800ada:	29 d0                	sub    %edx,%eax
}
  800adc:	5b                   	pop    %ebx
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    
		return 0;
  800adf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae4:	eb f6                	jmp    800adc <strncmp+0x2e>

00800ae6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af0:	0f b6 10             	movzbl (%eax),%edx
  800af3:	84 d2                	test   %dl,%dl
  800af5:	74 09                	je     800b00 <strchr+0x1a>
		if (*s == c)
  800af7:	38 ca                	cmp    %cl,%dl
  800af9:	74 0a                	je     800b05 <strchr+0x1f>
	for (; *s; s++)
  800afb:	83 c0 01             	add    $0x1,%eax
  800afe:	eb f0                	jmp    800af0 <strchr+0xa>
			return (char *) s;
	return 0;
  800b00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b11:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b14:	38 ca                	cmp    %cl,%dl
  800b16:	74 09                	je     800b21 <strfind+0x1a>
  800b18:	84 d2                	test   %dl,%dl
  800b1a:	74 05                	je     800b21 <strfind+0x1a>
	for (; *s; s++)
  800b1c:	83 c0 01             	add    $0x1,%eax
  800b1f:	eb f0                	jmp    800b11 <strfind+0xa>
			break;
	return (char *) s;
}
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	57                   	push   %edi
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
  800b29:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b2f:	85 c9                	test   %ecx,%ecx
  800b31:	74 31                	je     800b64 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b33:	89 f8                	mov    %edi,%eax
  800b35:	09 c8                	or     %ecx,%eax
  800b37:	a8 03                	test   $0x3,%al
  800b39:	75 23                	jne    800b5e <memset+0x3b>
		c &= 0xFF;
  800b3b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b3f:	89 d3                	mov    %edx,%ebx
  800b41:	c1 e3 08             	shl    $0x8,%ebx
  800b44:	89 d0                	mov    %edx,%eax
  800b46:	c1 e0 18             	shl    $0x18,%eax
  800b49:	89 d6                	mov    %edx,%esi
  800b4b:	c1 e6 10             	shl    $0x10,%esi
  800b4e:	09 f0                	or     %esi,%eax
  800b50:	09 c2                	or     %eax,%edx
  800b52:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b54:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b57:	89 d0                	mov    %edx,%eax
  800b59:	fc                   	cld    
  800b5a:	f3 ab                	rep stos %eax,%es:(%edi)
  800b5c:	eb 06                	jmp    800b64 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	fc                   	cld    
  800b62:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b64:	89 f8                	mov    %edi,%eax
  800b66:	5b                   	pop    %ebx
  800b67:	5e                   	pop    %esi
  800b68:	5f                   	pop    %edi
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	57                   	push   %edi
  800b6f:	56                   	push   %esi
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b76:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b79:	39 c6                	cmp    %eax,%esi
  800b7b:	73 32                	jae    800baf <memmove+0x44>
  800b7d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b80:	39 c2                	cmp    %eax,%edx
  800b82:	76 2b                	jbe    800baf <memmove+0x44>
		s += n;
		d += n;
  800b84:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b87:	89 fe                	mov    %edi,%esi
  800b89:	09 ce                	or     %ecx,%esi
  800b8b:	09 d6                	or     %edx,%esi
  800b8d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b93:	75 0e                	jne    800ba3 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b95:	83 ef 04             	sub    $0x4,%edi
  800b98:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b9b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b9e:	fd                   	std    
  800b9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba1:	eb 09                	jmp    800bac <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ba3:	83 ef 01             	sub    $0x1,%edi
  800ba6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ba9:	fd                   	std    
  800baa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bac:	fc                   	cld    
  800bad:	eb 1a                	jmp    800bc9 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800baf:	89 c2                	mov    %eax,%edx
  800bb1:	09 ca                	or     %ecx,%edx
  800bb3:	09 f2                	or     %esi,%edx
  800bb5:	f6 c2 03             	test   $0x3,%dl
  800bb8:	75 0a                	jne    800bc4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bba:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bbd:	89 c7                	mov    %eax,%edi
  800bbf:	fc                   	cld    
  800bc0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bc2:	eb 05                	jmp    800bc9 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bc4:	89 c7                	mov    %eax,%edi
  800bc6:	fc                   	cld    
  800bc7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bd3:	ff 75 10             	pushl  0x10(%ebp)
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 8a ff ff ff       	call   800b6b <memmove>
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	56                   	push   %esi
  800be7:	53                   	push   %ebx
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bee:	89 c6                	mov    %eax,%esi
  800bf0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf3:	39 f0                	cmp    %esi,%eax
  800bf5:	74 1c                	je     800c13 <memcmp+0x30>
		if (*s1 != *s2)
  800bf7:	0f b6 08             	movzbl (%eax),%ecx
  800bfa:	0f b6 1a             	movzbl (%edx),%ebx
  800bfd:	38 d9                	cmp    %bl,%cl
  800bff:	75 08                	jne    800c09 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c01:	83 c0 01             	add    $0x1,%eax
  800c04:	83 c2 01             	add    $0x1,%edx
  800c07:	eb ea                	jmp    800bf3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c09:	0f b6 c1             	movzbl %cl,%eax
  800c0c:	0f b6 db             	movzbl %bl,%ebx
  800c0f:	29 d8                	sub    %ebx,%eax
  800c11:	eb 05                	jmp    800c18 <memcmp+0x35>
	}

	return 0;
  800c13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c25:	89 c2                	mov    %eax,%edx
  800c27:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c2a:	39 d0                	cmp    %edx,%eax
  800c2c:	73 09                	jae    800c37 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c2e:	38 08                	cmp    %cl,(%eax)
  800c30:	74 05                	je     800c37 <memfind+0x1b>
	for (; s < ends; s++)
  800c32:	83 c0 01             	add    $0x1,%eax
  800c35:	eb f3                	jmp    800c2a <memfind+0xe>
			break;
	return (void *) s;
}
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
  800c3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c45:	eb 03                	jmp    800c4a <strtol+0x11>
		s++;
  800c47:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c4a:	0f b6 01             	movzbl (%ecx),%eax
  800c4d:	3c 20                	cmp    $0x20,%al
  800c4f:	74 f6                	je     800c47 <strtol+0xe>
  800c51:	3c 09                	cmp    $0x9,%al
  800c53:	74 f2                	je     800c47 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c55:	3c 2b                	cmp    $0x2b,%al
  800c57:	74 2a                	je     800c83 <strtol+0x4a>
	int neg = 0;
  800c59:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c5e:	3c 2d                	cmp    $0x2d,%al
  800c60:	74 2b                	je     800c8d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c62:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c68:	75 0f                	jne    800c79 <strtol+0x40>
  800c6a:	80 39 30             	cmpb   $0x30,(%ecx)
  800c6d:	74 28                	je     800c97 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c6f:	85 db                	test   %ebx,%ebx
  800c71:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c76:	0f 44 d8             	cmove  %eax,%ebx
  800c79:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c81:	eb 50                	jmp    800cd3 <strtol+0x9a>
		s++;
  800c83:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c86:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8b:	eb d5                	jmp    800c62 <strtol+0x29>
		s++, neg = 1;
  800c8d:	83 c1 01             	add    $0x1,%ecx
  800c90:	bf 01 00 00 00       	mov    $0x1,%edi
  800c95:	eb cb                	jmp    800c62 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c97:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c9b:	74 0e                	je     800cab <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c9d:	85 db                	test   %ebx,%ebx
  800c9f:	75 d8                	jne    800c79 <strtol+0x40>
		s++, base = 8;
  800ca1:	83 c1 01             	add    $0x1,%ecx
  800ca4:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ca9:	eb ce                	jmp    800c79 <strtol+0x40>
		s += 2, base = 16;
  800cab:	83 c1 02             	add    $0x2,%ecx
  800cae:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cb3:	eb c4                	jmp    800c79 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cb5:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cb8:	89 f3                	mov    %esi,%ebx
  800cba:	80 fb 19             	cmp    $0x19,%bl
  800cbd:	77 29                	ja     800ce8 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cbf:	0f be d2             	movsbl %dl,%edx
  800cc2:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cc5:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cc8:	7d 30                	jge    800cfa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cca:	83 c1 01             	add    $0x1,%ecx
  800ccd:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cd1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cd3:	0f b6 11             	movzbl (%ecx),%edx
  800cd6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cd9:	89 f3                	mov    %esi,%ebx
  800cdb:	80 fb 09             	cmp    $0x9,%bl
  800cde:	77 d5                	ja     800cb5 <strtol+0x7c>
			dig = *s - '0';
  800ce0:	0f be d2             	movsbl %dl,%edx
  800ce3:	83 ea 30             	sub    $0x30,%edx
  800ce6:	eb dd                	jmp    800cc5 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ce8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ceb:	89 f3                	mov    %esi,%ebx
  800ced:	80 fb 19             	cmp    $0x19,%bl
  800cf0:	77 08                	ja     800cfa <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cf2:	0f be d2             	movsbl %dl,%edx
  800cf5:	83 ea 37             	sub    $0x37,%edx
  800cf8:	eb cb                	jmp    800cc5 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfe:	74 05                	je     800d05 <strtol+0xcc>
		*endptr = (char *) s;
  800d00:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d03:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d05:	89 c2                	mov    %eax,%edx
  800d07:	f7 da                	neg    %edx
  800d09:	85 ff                	test   %edi,%edi
  800d0b:	0f 45 c2             	cmovne %edx,%eax
}
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5f                   	pop    %edi
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d19:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d24:	89 c3                	mov    %eax,%ebx
  800d26:	89 c7                	mov    %eax,%edi
  800d28:	89 c6                	mov    %eax,%esi
  800d2a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    

00800d31 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	57                   	push   %edi
  800d35:	56                   	push   %esi
  800d36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d37:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3c:	b8 01 00 00 00       	mov    $0x1,%eax
  800d41:	89 d1                	mov    %edx,%ecx
  800d43:	89 d3                	mov    %edx,%ebx
  800d45:	89 d7                	mov    %edx,%edi
  800d47:	89 d6                	mov    %edx,%esi
  800d49:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5f                   	pop    %edi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
  800d56:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d59:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	b8 03 00 00 00       	mov    $0x3,%eax
  800d66:	89 cb                	mov    %ecx,%ebx
  800d68:	89 cf                	mov    %ecx,%edi
  800d6a:	89 ce                	mov    %ecx,%esi
  800d6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6e:	85 c0                	test   %eax,%eax
  800d70:	7f 08                	jg     800d7a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d75:	5b                   	pop    %ebx
  800d76:	5e                   	pop    %esi
  800d77:	5f                   	pop    %edi
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7a:	83 ec 0c             	sub    $0xc,%esp
  800d7d:	50                   	push   %eax
  800d7e:	6a 03                	push   $0x3
  800d80:	68 1f 2b 80 00       	push   $0x802b1f
  800d85:	6a 23                	push   $0x23
  800d87:	68 3c 2b 80 00       	push   $0x802b3c
  800d8c:	e8 95 f5 ff ff       	call   800326 <_panic>

00800d91 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	57                   	push   %edi
  800d95:	56                   	push   %esi
  800d96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d97:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9c:	b8 02 00 00 00       	mov    $0x2,%eax
  800da1:	89 d1                	mov    %edx,%ecx
  800da3:	89 d3                	mov    %edx,%ebx
  800da5:	89 d7                	mov    %edx,%edi
  800da7:	89 d6                	mov    %edx,%esi
  800da9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dab:	5b                   	pop    %ebx
  800dac:	5e                   	pop    %esi
  800dad:	5f                   	pop    %edi
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    

00800db0 <sys_yield>:

void
sys_yield(void)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	57                   	push   %edi
  800db4:	56                   	push   %esi
  800db5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db6:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc0:	89 d1                	mov    %edx,%ecx
  800dc2:	89 d3                	mov    %edx,%ebx
  800dc4:	89 d7                	mov    %edx,%edi
  800dc6:	89 d6                	mov    %edx,%esi
  800dc8:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dca:	5b                   	pop    %ebx
  800dcb:	5e                   	pop    %esi
  800dcc:	5f                   	pop    %edi
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    

00800dcf <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	57                   	push   %edi
  800dd3:	56                   	push   %esi
  800dd4:	53                   	push   %ebx
  800dd5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd8:	be 00 00 00 00       	mov    $0x0,%esi
  800ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  800de0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de3:	b8 04 00 00 00       	mov    $0x4,%eax
  800de8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800deb:	89 f7                	mov    %esi,%edi
  800ded:	cd 30                	int    $0x30
	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7f 08                	jg     800dfb <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfb:	83 ec 0c             	sub    $0xc,%esp
  800dfe:	50                   	push   %eax
  800dff:	6a 04                	push   $0x4
  800e01:	68 1f 2b 80 00       	push   $0x802b1f
  800e06:	6a 23                	push   $0x23
  800e08:	68 3c 2b 80 00       	push   $0x802b3c
  800e0d:	e8 14 f5 ff ff       	call   800326 <_panic>

00800e12 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	57                   	push   %edi
  800e16:	56                   	push   %esi
  800e17:	53                   	push   %ebx
  800e18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e21:	b8 05 00 00 00       	mov    $0x5,%eax
  800e26:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e29:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e2c:	8b 75 18             	mov    0x18(%ebp),%esi
  800e2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e31:	85 c0                	test   %eax,%eax
  800e33:	7f 08                	jg     800e3d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e38:	5b                   	pop    %ebx
  800e39:	5e                   	pop    %esi
  800e3a:	5f                   	pop    %edi
  800e3b:	5d                   	pop    %ebp
  800e3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3d:	83 ec 0c             	sub    $0xc,%esp
  800e40:	50                   	push   %eax
  800e41:	6a 05                	push   $0x5
  800e43:	68 1f 2b 80 00       	push   $0x802b1f
  800e48:	6a 23                	push   $0x23
  800e4a:	68 3c 2b 80 00       	push   $0x802b3c
  800e4f:	e8 d2 f4 ff ff       	call   800326 <_panic>

00800e54 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	57                   	push   %edi
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
  800e5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e68:	b8 06 00 00 00       	mov    $0x6,%eax
  800e6d:	89 df                	mov    %ebx,%edi
  800e6f:	89 de                	mov    %ebx,%esi
  800e71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	7f 08                	jg     800e7f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800e83:	6a 06                	push   $0x6
  800e85:	68 1f 2b 80 00       	push   $0x802b1f
  800e8a:	6a 23                	push   $0x23
  800e8c:	68 3c 2b 80 00       	push   $0x802b3c
  800e91:	e8 90 f4 ff ff       	call   800326 <_panic>

00800e96 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaa:	b8 08 00 00 00       	mov    $0x8,%eax
  800eaf:	89 df                	mov    %ebx,%edi
  800eb1:	89 de                	mov    %ebx,%esi
  800eb3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	7f 08                	jg     800ec1 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800ec5:	6a 08                	push   $0x8
  800ec7:	68 1f 2b 80 00       	push   $0x802b1f
  800ecc:	6a 23                	push   $0x23
  800ece:	68 3c 2b 80 00       	push   $0x802b3c
  800ed3:	e8 4e f4 ff ff       	call   800326 <_panic>

00800ed8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800eec:	b8 09 00 00 00       	mov    $0x9,%eax
  800ef1:	89 df                	mov    %ebx,%edi
  800ef3:	89 de                	mov    %ebx,%esi
  800ef5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	7f 08                	jg     800f03 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800f07:	6a 09                	push   $0x9
  800f09:	68 1f 2b 80 00       	push   $0x802b1f
  800f0e:	6a 23                	push   $0x23
  800f10:	68 3c 2b 80 00       	push   $0x802b3c
  800f15:	e8 0c f4 ff ff       	call   800326 <_panic>

00800f1a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800f2e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f33:	89 df                	mov    %ebx,%edi
  800f35:	89 de                	mov    %ebx,%esi
  800f37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	7f 08                	jg     800f45 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800f49:	6a 0a                	push   $0xa
  800f4b:	68 1f 2b 80 00       	push   $0x802b1f
  800f50:	6a 23                	push   $0x23
  800f52:	68 3c 2b 80 00       	push   $0x802b3c
  800f57:	e8 ca f3 ff ff       	call   800326 <_panic>

00800f5c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f62:	8b 55 08             	mov    0x8(%ebp),%edx
  800f65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f68:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f6d:	be 00 00 00 00       	mov    $0x0,%esi
  800f72:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f75:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f78:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f7a:	5b                   	pop    %ebx
  800f7b:	5e                   	pop    %esi
  800f7c:	5f                   	pop    %edi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    

00800f7f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	57                   	push   %edi
  800f83:	56                   	push   %esi
  800f84:	53                   	push   %ebx
  800f85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f88:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f95:	89 cb                	mov    %ecx,%ebx
  800f97:	89 cf                	mov    %ecx,%edi
  800f99:	89 ce                	mov    %ecx,%esi
  800f9b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	7f 08                	jg     800fa9 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa9:	83 ec 0c             	sub    $0xc,%esp
  800fac:	50                   	push   %eax
  800fad:	6a 0d                	push   $0xd
  800faf:	68 1f 2b 80 00       	push   $0x802b1f
  800fb4:	6a 23                	push   $0x23
  800fb6:	68 3c 2b 80 00       	push   $0x802b3c
  800fbb:	e8 66 f3 ff ff       	call   800326 <_panic>

00800fc0 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	57                   	push   %edi
  800fc4:	56                   	push   %esi
  800fc5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800fcb:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fd0:	89 d1                	mov    %edx,%ecx
  800fd2:	89 d3                	mov    %edx,%ebx
  800fd4:	89 d7                	mov    %edx,%edi
  800fd6:	89 d6                	mov    %edx,%esi
  800fd8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fda:	5b                   	pop    %ebx
  800fdb:	5e                   	pop    %esi
  800fdc:	5f                   	pop    %edi
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    

00800fdf <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800feb:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800fed:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800ff0:	83 3a 01             	cmpl   $0x1,(%edx)
  800ff3:	7e 09                	jle    800ffe <argstart+0x1f>
  800ff5:	ba c8 27 80 00       	mov    $0x8027c8,%edx
  800ffa:	85 c9                	test   %ecx,%ecx
  800ffc:	75 05                	jne    801003 <argstart+0x24>
  800ffe:	ba 00 00 00 00       	mov    $0x0,%edx
  801003:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801006:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    

0080100f <argnext>:

int
argnext(struct Argstate *args)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	53                   	push   %ebx
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801019:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801020:	8b 43 08             	mov    0x8(%ebx),%eax
  801023:	85 c0                	test   %eax,%eax
  801025:	74 72                	je     801099 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801027:	80 38 00             	cmpb   $0x0,(%eax)
  80102a:	75 48                	jne    801074 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80102c:	8b 0b                	mov    (%ebx),%ecx
  80102e:	83 39 01             	cmpl   $0x1,(%ecx)
  801031:	74 58                	je     80108b <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801033:	8b 53 04             	mov    0x4(%ebx),%edx
  801036:	8b 42 04             	mov    0x4(%edx),%eax
  801039:	80 38 2d             	cmpb   $0x2d,(%eax)
  80103c:	75 4d                	jne    80108b <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  80103e:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801042:	74 47                	je     80108b <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801044:	83 c0 01             	add    $0x1,%eax
  801047:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80104a:	83 ec 04             	sub    $0x4,%esp
  80104d:	8b 01                	mov    (%ecx),%eax
  80104f:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801056:	50                   	push   %eax
  801057:	8d 42 08             	lea    0x8(%edx),%eax
  80105a:	50                   	push   %eax
  80105b:	83 c2 04             	add    $0x4,%edx
  80105e:	52                   	push   %edx
  80105f:	e8 07 fb ff ff       	call   800b6b <memmove>
		(*args->argc)--;
  801064:	8b 03                	mov    (%ebx),%eax
  801066:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801069:	8b 43 08             	mov    0x8(%ebx),%eax
  80106c:	83 c4 10             	add    $0x10,%esp
  80106f:	80 38 2d             	cmpb   $0x2d,(%eax)
  801072:	74 11                	je     801085 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801074:	8b 53 08             	mov    0x8(%ebx),%edx
  801077:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  80107a:	83 c2 01             	add    $0x1,%edx
  80107d:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801080:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801083:	c9                   	leave  
  801084:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801085:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801089:	75 e9                	jne    801074 <argnext+0x65>
	args->curarg = 0;
  80108b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801092:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801097:	eb e7                	jmp    801080 <argnext+0x71>
		return -1;
  801099:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80109e:	eb e0                	jmp    801080 <argnext+0x71>

008010a0 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	53                   	push   %ebx
  8010a4:	83 ec 04             	sub    $0x4,%esp
  8010a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8010aa:	8b 43 08             	mov    0x8(%ebx),%eax
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	74 5b                	je     80110c <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  8010b1:	80 38 00             	cmpb   $0x0,(%eax)
  8010b4:	74 12                	je     8010c8 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  8010b6:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8010b9:	c7 43 08 c8 27 80 00 	movl   $0x8027c8,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  8010c0:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8010c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010c6:	c9                   	leave  
  8010c7:	c3                   	ret    
	} else if (*args->argc > 1) {
  8010c8:	8b 13                	mov    (%ebx),%edx
  8010ca:	83 3a 01             	cmpl   $0x1,(%edx)
  8010cd:	7f 10                	jg     8010df <argnextvalue+0x3f>
		args->argvalue = 0;
  8010cf:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8010d6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  8010dd:	eb e1                	jmp    8010c0 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  8010df:	8b 43 04             	mov    0x4(%ebx),%eax
  8010e2:	8b 48 04             	mov    0x4(%eax),%ecx
  8010e5:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8010e8:	83 ec 04             	sub    $0x4,%esp
  8010eb:	8b 12                	mov    (%edx),%edx
  8010ed:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  8010f4:	52                   	push   %edx
  8010f5:	8d 50 08             	lea    0x8(%eax),%edx
  8010f8:	52                   	push   %edx
  8010f9:	83 c0 04             	add    $0x4,%eax
  8010fc:	50                   	push   %eax
  8010fd:	e8 69 fa ff ff       	call   800b6b <memmove>
		(*args->argc)--;
  801102:	8b 03                	mov    (%ebx),%eax
  801104:	83 28 01             	subl   $0x1,(%eax)
  801107:	83 c4 10             	add    $0x10,%esp
  80110a:	eb b4                	jmp    8010c0 <argnextvalue+0x20>
		return 0;
  80110c:	b8 00 00 00 00       	mov    $0x0,%eax
  801111:	eb b0                	jmp    8010c3 <argnextvalue+0x23>

00801113 <argvalue>:
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	83 ec 08             	sub    $0x8,%esp
  801119:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80111c:	8b 42 0c             	mov    0xc(%edx),%eax
  80111f:	85 c0                	test   %eax,%eax
  801121:	74 02                	je     801125 <argvalue+0x12>
}
  801123:	c9                   	leave  
  801124:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801125:	83 ec 0c             	sub    $0xc,%esp
  801128:	52                   	push   %edx
  801129:	e8 72 ff ff ff       	call   8010a0 <argnextvalue>
  80112e:	83 c4 10             	add    $0x10,%esp
  801131:	eb f0                	jmp    801123 <argvalue+0x10>

00801133 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	05 00 00 00 30       	add    $0x30000000,%eax
  80113e:	c1 e8 0c             	shr    $0xc,%eax
}
  801141:	5d                   	pop    %ebp
  801142:	c3                   	ret    

00801143 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80114e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801153:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    

0080115a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801162:	89 c2                	mov    %eax,%edx
  801164:	c1 ea 16             	shr    $0x16,%edx
  801167:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80116e:	f6 c2 01             	test   $0x1,%dl
  801171:	74 2d                	je     8011a0 <fd_alloc+0x46>
  801173:	89 c2                	mov    %eax,%edx
  801175:	c1 ea 0c             	shr    $0xc,%edx
  801178:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80117f:	f6 c2 01             	test   $0x1,%dl
  801182:	74 1c                	je     8011a0 <fd_alloc+0x46>
  801184:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801189:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80118e:	75 d2                	jne    801162 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801199:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80119e:	eb 0a                	jmp    8011aa <fd_alloc+0x50>
			*fd_store = fd;
  8011a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    

008011ac <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011b2:	83 f8 1f             	cmp    $0x1f,%eax
  8011b5:	77 30                	ja     8011e7 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011b7:	c1 e0 0c             	shl    $0xc,%eax
  8011ba:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011bf:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011c5:	f6 c2 01             	test   $0x1,%dl
  8011c8:	74 24                	je     8011ee <fd_lookup+0x42>
  8011ca:	89 c2                	mov    %eax,%edx
  8011cc:	c1 ea 0c             	shr    $0xc,%edx
  8011cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d6:	f6 c2 01             	test   $0x1,%dl
  8011d9:	74 1a                	je     8011f5 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011de:	89 02                	mov    %eax,(%edx)
	return 0;
  8011e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e5:	5d                   	pop    %ebp
  8011e6:	c3                   	ret    
		return -E_INVAL;
  8011e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ec:	eb f7                	jmp    8011e5 <fd_lookup+0x39>
		return -E_INVAL;
  8011ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f3:	eb f0                	jmp    8011e5 <fd_lookup+0x39>
  8011f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011fa:	eb e9                	jmp    8011e5 <fd_lookup+0x39>

008011fc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	83 ec 08             	sub    $0x8,%esp
  801202:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801205:	ba 00 00 00 00       	mov    $0x0,%edx
  80120a:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80120f:	39 08                	cmp    %ecx,(%eax)
  801211:	74 38                	je     80124b <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801213:	83 c2 01             	add    $0x1,%edx
  801216:	8b 04 95 c8 2b 80 00 	mov    0x802bc8(,%edx,4),%eax
  80121d:	85 c0                	test   %eax,%eax
  80121f:	75 ee                	jne    80120f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801221:	a1 20 44 80 00       	mov    0x804420,%eax
  801226:	8b 40 48             	mov    0x48(%eax),%eax
  801229:	83 ec 04             	sub    $0x4,%esp
  80122c:	51                   	push   %ecx
  80122d:	50                   	push   %eax
  80122e:	68 4c 2b 80 00       	push   $0x802b4c
  801233:	e8 c9 f1 ff ff       	call   800401 <cprintf>
	*dev = 0;
  801238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801249:	c9                   	leave  
  80124a:	c3                   	ret    
			*dev = devtab[i];
  80124b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80124e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801250:	b8 00 00 00 00       	mov    $0x0,%eax
  801255:	eb f2                	jmp    801249 <dev_lookup+0x4d>

00801257 <fd_close>:
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	57                   	push   %edi
  80125b:	56                   	push   %esi
  80125c:	53                   	push   %ebx
  80125d:	83 ec 24             	sub    $0x24,%esp
  801260:	8b 75 08             	mov    0x8(%ebp),%esi
  801263:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801266:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801269:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80126a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801270:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801273:	50                   	push   %eax
  801274:	e8 33 ff ff ff       	call   8011ac <fd_lookup>
  801279:	89 c3                	mov    %eax,%ebx
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 05                	js     801287 <fd_close+0x30>
	    || fd != fd2)
  801282:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801285:	74 16                	je     80129d <fd_close+0x46>
		return (must_exist ? r : 0);
  801287:	89 f8                	mov    %edi,%eax
  801289:	84 c0                	test   %al,%al
  80128b:	b8 00 00 00 00       	mov    $0x0,%eax
  801290:	0f 44 d8             	cmove  %eax,%ebx
}
  801293:	89 d8                	mov    %ebx,%eax
  801295:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801298:	5b                   	pop    %ebx
  801299:	5e                   	pop    %esi
  80129a:	5f                   	pop    %edi
  80129b:	5d                   	pop    %ebp
  80129c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012a3:	50                   	push   %eax
  8012a4:	ff 36                	pushl  (%esi)
  8012a6:	e8 51 ff ff ff       	call   8011fc <dev_lookup>
  8012ab:	89 c3                	mov    %eax,%ebx
  8012ad:	83 c4 10             	add    $0x10,%esp
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	78 1a                	js     8012ce <fd_close+0x77>
		if (dev->dev_close)
  8012b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012b7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012ba:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	74 0b                	je     8012ce <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	56                   	push   %esi
  8012c7:	ff d0                	call   *%eax
  8012c9:	89 c3                	mov    %eax,%ebx
  8012cb:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012ce:	83 ec 08             	sub    $0x8,%esp
  8012d1:	56                   	push   %esi
  8012d2:	6a 00                	push   $0x0
  8012d4:	e8 7b fb ff ff       	call   800e54 <sys_page_unmap>
	return r;
  8012d9:	83 c4 10             	add    $0x10,%esp
  8012dc:	eb b5                	jmp    801293 <fd_close+0x3c>

008012de <close>:

int
close(int fdnum)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e7:	50                   	push   %eax
  8012e8:	ff 75 08             	pushl  0x8(%ebp)
  8012eb:	e8 bc fe ff ff       	call   8011ac <fd_lookup>
  8012f0:	83 c4 10             	add    $0x10,%esp
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	79 02                	jns    8012f9 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    
		return fd_close(fd, 1);
  8012f9:	83 ec 08             	sub    $0x8,%esp
  8012fc:	6a 01                	push   $0x1
  8012fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801301:	e8 51 ff ff ff       	call   801257 <fd_close>
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	eb ec                	jmp    8012f7 <close+0x19>

0080130b <close_all>:

void
close_all(void)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	53                   	push   %ebx
  80130f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801312:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801317:	83 ec 0c             	sub    $0xc,%esp
  80131a:	53                   	push   %ebx
  80131b:	e8 be ff ff ff       	call   8012de <close>
	for (i = 0; i < MAXFD; i++)
  801320:	83 c3 01             	add    $0x1,%ebx
  801323:	83 c4 10             	add    $0x10,%esp
  801326:	83 fb 20             	cmp    $0x20,%ebx
  801329:	75 ec                	jne    801317 <close_all+0xc>
}
  80132b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	57                   	push   %edi
  801334:	56                   	push   %esi
  801335:	53                   	push   %ebx
  801336:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801339:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80133c:	50                   	push   %eax
  80133d:	ff 75 08             	pushl  0x8(%ebp)
  801340:	e8 67 fe ff ff       	call   8011ac <fd_lookup>
  801345:	89 c3                	mov    %eax,%ebx
  801347:	83 c4 10             	add    $0x10,%esp
  80134a:	85 c0                	test   %eax,%eax
  80134c:	0f 88 81 00 00 00    	js     8013d3 <dup+0xa3>
		return r;
	close(newfdnum);
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	ff 75 0c             	pushl  0xc(%ebp)
  801358:	e8 81 ff ff ff       	call   8012de <close>

	newfd = INDEX2FD(newfdnum);
  80135d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801360:	c1 e6 0c             	shl    $0xc,%esi
  801363:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801369:	83 c4 04             	add    $0x4,%esp
  80136c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80136f:	e8 cf fd ff ff       	call   801143 <fd2data>
  801374:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801376:	89 34 24             	mov    %esi,(%esp)
  801379:	e8 c5 fd ff ff       	call   801143 <fd2data>
  80137e:	83 c4 10             	add    $0x10,%esp
  801381:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801383:	89 d8                	mov    %ebx,%eax
  801385:	c1 e8 16             	shr    $0x16,%eax
  801388:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80138f:	a8 01                	test   $0x1,%al
  801391:	74 11                	je     8013a4 <dup+0x74>
  801393:	89 d8                	mov    %ebx,%eax
  801395:	c1 e8 0c             	shr    $0xc,%eax
  801398:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80139f:	f6 c2 01             	test   $0x1,%dl
  8013a2:	75 39                	jne    8013dd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013a7:	89 d0                	mov    %edx,%eax
  8013a9:	c1 e8 0c             	shr    $0xc,%eax
  8013ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	25 07 0e 00 00       	and    $0xe07,%eax
  8013bb:	50                   	push   %eax
  8013bc:	56                   	push   %esi
  8013bd:	6a 00                	push   $0x0
  8013bf:	52                   	push   %edx
  8013c0:	6a 00                	push   $0x0
  8013c2:	e8 4b fa ff ff       	call   800e12 <sys_page_map>
  8013c7:	89 c3                	mov    %eax,%ebx
  8013c9:	83 c4 20             	add    $0x20,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 31                	js     801401 <dup+0xd1>
		goto err;

	return newfdnum;
  8013d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013d3:	89 d8                	mov    %ebx,%eax
  8013d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d8:	5b                   	pop    %ebx
  8013d9:	5e                   	pop    %esi
  8013da:	5f                   	pop    %edi
  8013db:	5d                   	pop    %ebp
  8013dc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013dd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8013ec:	50                   	push   %eax
  8013ed:	57                   	push   %edi
  8013ee:	6a 00                	push   $0x0
  8013f0:	53                   	push   %ebx
  8013f1:	6a 00                	push   $0x0
  8013f3:	e8 1a fa ff ff       	call   800e12 <sys_page_map>
  8013f8:	89 c3                	mov    %eax,%ebx
  8013fa:	83 c4 20             	add    $0x20,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	79 a3                	jns    8013a4 <dup+0x74>
	sys_page_unmap(0, newfd);
  801401:	83 ec 08             	sub    $0x8,%esp
  801404:	56                   	push   %esi
  801405:	6a 00                	push   $0x0
  801407:	e8 48 fa ff ff       	call   800e54 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80140c:	83 c4 08             	add    $0x8,%esp
  80140f:	57                   	push   %edi
  801410:	6a 00                	push   $0x0
  801412:	e8 3d fa ff ff       	call   800e54 <sys_page_unmap>
	return r;
  801417:	83 c4 10             	add    $0x10,%esp
  80141a:	eb b7                	jmp    8013d3 <dup+0xa3>

0080141c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	53                   	push   %ebx
  801420:	83 ec 1c             	sub    $0x1c,%esp
  801423:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801426:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801429:	50                   	push   %eax
  80142a:	53                   	push   %ebx
  80142b:	e8 7c fd ff ff       	call   8011ac <fd_lookup>
  801430:	83 c4 10             	add    $0x10,%esp
  801433:	85 c0                	test   %eax,%eax
  801435:	78 3f                	js     801476 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801437:	83 ec 08             	sub    $0x8,%esp
  80143a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143d:	50                   	push   %eax
  80143e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801441:	ff 30                	pushl  (%eax)
  801443:	e8 b4 fd ff ff       	call   8011fc <dev_lookup>
  801448:	83 c4 10             	add    $0x10,%esp
  80144b:	85 c0                	test   %eax,%eax
  80144d:	78 27                	js     801476 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80144f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801452:	8b 42 08             	mov    0x8(%edx),%eax
  801455:	83 e0 03             	and    $0x3,%eax
  801458:	83 f8 01             	cmp    $0x1,%eax
  80145b:	74 1e                	je     80147b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80145d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801460:	8b 40 08             	mov    0x8(%eax),%eax
  801463:	85 c0                	test   %eax,%eax
  801465:	74 35                	je     80149c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	ff 75 10             	pushl  0x10(%ebp)
  80146d:	ff 75 0c             	pushl  0xc(%ebp)
  801470:	52                   	push   %edx
  801471:	ff d0                	call   *%eax
  801473:	83 c4 10             	add    $0x10,%esp
}
  801476:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801479:	c9                   	leave  
  80147a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80147b:	a1 20 44 80 00       	mov    0x804420,%eax
  801480:	8b 40 48             	mov    0x48(%eax),%eax
  801483:	83 ec 04             	sub    $0x4,%esp
  801486:	53                   	push   %ebx
  801487:	50                   	push   %eax
  801488:	68 8d 2b 80 00       	push   $0x802b8d
  80148d:	e8 6f ef ff ff       	call   800401 <cprintf>
		return -E_INVAL;
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149a:	eb da                	jmp    801476 <read+0x5a>
		return -E_NOT_SUPP;
  80149c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a1:	eb d3                	jmp    801476 <read+0x5a>

008014a3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	57                   	push   %edi
  8014a7:	56                   	push   %esi
  8014a8:	53                   	push   %ebx
  8014a9:	83 ec 0c             	sub    $0xc,%esp
  8014ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014af:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014b7:	39 f3                	cmp    %esi,%ebx
  8014b9:	73 23                	jae    8014de <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014bb:	83 ec 04             	sub    $0x4,%esp
  8014be:	89 f0                	mov    %esi,%eax
  8014c0:	29 d8                	sub    %ebx,%eax
  8014c2:	50                   	push   %eax
  8014c3:	89 d8                	mov    %ebx,%eax
  8014c5:	03 45 0c             	add    0xc(%ebp),%eax
  8014c8:	50                   	push   %eax
  8014c9:	57                   	push   %edi
  8014ca:	e8 4d ff ff ff       	call   80141c <read>
		if (m < 0)
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	78 06                	js     8014dc <readn+0x39>
			return m;
		if (m == 0)
  8014d6:	74 06                	je     8014de <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014d8:	01 c3                	add    %eax,%ebx
  8014da:	eb db                	jmp    8014b7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014dc:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014de:	89 d8                	mov    %ebx,%eax
  8014e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e3:	5b                   	pop    %ebx
  8014e4:	5e                   	pop    %esi
  8014e5:	5f                   	pop    %edi
  8014e6:	5d                   	pop    %ebp
  8014e7:	c3                   	ret    

008014e8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	53                   	push   %ebx
  8014ec:	83 ec 1c             	sub    $0x1c,%esp
  8014ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f5:	50                   	push   %eax
  8014f6:	53                   	push   %ebx
  8014f7:	e8 b0 fc ff ff       	call   8011ac <fd_lookup>
  8014fc:	83 c4 10             	add    $0x10,%esp
  8014ff:	85 c0                	test   %eax,%eax
  801501:	78 3a                	js     80153d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801503:	83 ec 08             	sub    $0x8,%esp
  801506:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801509:	50                   	push   %eax
  80150a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150d:	ff 30                	pushl  (%eax)
  80150f:	e8 e8 fc ff ff       	call   8011fc <dev_lookup>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	85 c0                	test   %eax,%eax
  801519:	78 22                	js     80153d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80151b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801522:	74 1e                	je     801542 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801524:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801527:	8b 52 0c             	mov    0xc(%edx),%edx
  80152a:	85 d2                	test   %edx,%edx
  80152c:	74 35                	je     801563 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80152e:	83 ec 04             	sub    $0x4,%esp
  801531:	ff 75 10             	pushl  0x10(%ebp)
  801534:	ff 75 0c             	pushl  0xc(%ebp)
  801537:	50                   	push   %eax
  801538:	ff d2                	call   *%edx
  80153a:	83 c4 10             	add    $0x10,%esp
}
  80153d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801540:	c9                   	leave  
  801541:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801542:	a1 20 44 80 00       	mov    0x804420,%eax
  801547:	8b 40 48             	mov    0x48(%eax),%eax
  80154a:	83 ec 04             	sub    $0x4,%esp
  80154d:	53                   	push   %ebx
  80154e:	50                   	push   %eax
  80154f:	68 a9 2b 80 00       	push   $0x802ba9
  801554:	e8 a8 ee ff ff       	call   800401 <cprintf>
		return -E_INVAL;
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801561:	eb da                	jmp    80153d <write+0x55>
		return -E_NOT_SUPP;
  801563:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801568:	eb d3                	jmp    80153d <write+0x55>

0080156a <seek>:

int
seek(int fdnum, off_t offset)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801570:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801573:	50                   	push   %eax
  801574:	ff 75 08             	pushl  0x8(%ebp)
  801577:	e8 30 fc ff ff       	call   8011ac <fd_lookup>
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	85 c0                	test   %eax,%eax
  801581:	78 0e                	js     801591 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801583:	8b 55 0c             	mov    0xc(%ebp),%edx
  801586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801589:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80158c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801591:	c9                   	leave  
  801592:	c3                   	ret    

00801593 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
  801596:	53                   	push   %ebx
  801597:	83 ec 1c             	sub    $0x1c,%esp
  80159a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80159d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a0:	50                   	push   %eax
  8015a1:	53                   	push   %ebx
  8015a2:	e8 05 fc ff ff       	call   8011ac <fd_lookup>
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	78 37                	js     8015e5 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ae:	83 ec 08             	sub    $0x8,%esp
  8015b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b4:	50                   	push   %eax
  8015b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b8:	ff 30                	pushl  (%eax)
  8015ba:	e8 3d fc ff ff       	call   8011fc <dev_lookup>
  8015bf:	83 c4 10             	add    $0x10,%esp
  8015c2:	85 c0                	test   %eax,%eax
  8015c4:	78 1f                	js     8015e5 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015cd:	74 1b                	je     8015ea <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d2:	8b 52 18             	mov    0x18(%edx),%edx
  8015d5:	85 d2                	test   %edx,%edx
  8015d7:	74 32                	je     80160b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015d9:	83 ec 08             	sub    $0x8,%esp
  8015dc:	ff 75 0c             	pushl  0xc(%ebp)
  8015df:	50                   	push   %eax
  8015e0:	ff d2                	call   *%edx
  8015e2:	83 c4 10             	add    $0x10,%esp
}
  8015e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015ea:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015ef:	8b 40 48             	mov    0x48(%eax),%eax
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	53                   	push   %ebx
  8015f6:	50                   	push   %eax
  8015f7:	68 6c 2b 80 00       	push   $0x802b6c
  8015fc:	e8 00 ee ff ff       	call   800401 <cprintf>
		return -E_INVAL;
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801609:	eb da                	jmp    8015e5 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80160b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801610:	eb d3                	jmp    8015e5 <ftruncate+0x52>

00801612 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	53                   	push   %ebx
  801616:	83 ec 1c             	sub    $0x1c,%esp
  801619:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80161c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80161f:	50                   	push   %eax
  801620:	ff 75 08             	pushl  0x8(%ebp)
  801623:	e8 84 fb ff ff       	call   8011ac <fd_lookup>
  801628:	83 c4 10             	add    $0x10,%esp
  80162b:	85 c0                	test   %eax,%eax
  80162d:	78 4b                	js     80167a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80162f:	83 ec 08             	sub    $0x8,%esp
  801632:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801635:	50                   	push   %eax
  801636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801639:	ff 30                	pushl  (%eax)
  80163b:	e8 bc fb ff ff       	call   8011fc <dev_lookup>
  801640:	83 c4 10             	add    $0x10,%esp
  801643:	85 c0                	test   %eax,%eax
  801645:	78 33                	js     80167a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80164e:	74 2f                	je     80167f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801650:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801653:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80165a:	00 00 00 
	stat->st_isdir = 0;
  80165d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801664:	00 00 00 
	stat->st_dev = dev;
  801667:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80166d:	83 ec 08             	sub    $0x8,%esp
  801670:	53                   	push   %ebx
  801671:	ff 75 f0             	pushl  -0x10(%ebp)
  801674:	ff 50 14             	call   *0x14(%eax)
  801677:	83 c4 10             	add    $0x10,%esp
}
  80167a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    
		return -E_NOT_SUPP;
  80167f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801684:	eb f4                	jmp    80167a <fstat+0x68>

00801686 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	56                   	push   %esi
  80168a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80168b:	83 ec 08             	sub    $0x8,%esp
  80168e:	6a 00                	push   $0x0
  801690:	ff 75 08             	pushl  0x8(%ebp)
  801693:	e8 2f 02 00 00       	call   8018c7 <open>
  801698:	89 c3                	mov    %eax,%ebx
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 1b                	js     8016bc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016a1:	83 ec 08             	sub    $0x8,%esp
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	50                   	push   %eax
  8016a8:	e8 65 ff ff ff       	call   801612 <fstat>
  8016ad:	89 c6                	mov    %eax,%esi
	close(fd);
  8016af:	89 1c 24             	mov    %ebx,(%esp)
  8016b2:	e8 27 fc ff ff       	call   8012de <close>
	return r;
  8016b7:	83 c4 10             	add    $0x10,%esp
  8016ba:	89 f3                	mov    %esi,%ebx
}
  8016bc:	89 d8                	mov    %ebx,%eax
  8016be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c1:	5b                   	pop    %ebx
  8016c2:	5e                   	pop    %esi
  8016c3:	5d                   	pop    %ebp
  8016c4:	c3                   	ret    

008016c5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	56                   	push   %esi
  8016c9:	53                   	push   %ebx
  8016ca:	89 c6                	mov    %eax,%esi
  8016cc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016ce:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016d5:	74 27                	je     8016fe <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016d7:	6a 07                	push   $0x7
  8016d9:	68 00 50 80 00       	push   $0x805000
  8016de:	56                   	push   %esi
  8016df:	ff 35 00 40 80 00    	pushl  0x804000
  8016e5:	e8 33 0d 00 00       	call   80241d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016ea:	83 c4 0c             	add    $0xc,%esp
  8016ed:	6a 00                	push   $0x0
  8016ef:	53                   	push   %ebx
  8016f0:	6a 00                	push   $0x0
  8016f2:	e8 b3 0c 00 00       	call   8023aa <ipc_recv>
}
  8016f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016fa:	5b                   	pop    %ebx
  8016fb:	5e                   	pop    %esi
  8016fc:	5d                   	pop    %ebp
  8016fd:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016fe:	83 ec 0c             	sub    $0xc,%esp
  801701:	6a 01                	push   $0x1
  801703:	e8 81 0d 00 00       	call   802489 <ipc_find_env>
  801708:	a3 00 40 80 00       	mov    %eax,0x804000
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	eb c5                	jmp    8016d7 <fsipc+0x12>

00801712 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	8b 40 0c             	mov    0xc(%eax),%eax
  80171e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80172b:	ba 00 00 00 00       	mov    $0x0,%edx
  801730:	b8 02 00 00 00       	mov    $0x2,%eax
  801735:	e8 8b ff ff ff       	call   8016c5 <fsipc>
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <devfile_flush>:
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	8b 40 0c             	mov    0xc(%eax),%eax
  801748:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80174d:	ba 00 00 00 00       	mov    $0x0,%edx
  801752:	b8 06 00 00 00       	mov    $0x6,%eax
  801757:	e8 69 ff ff ff       	call   8016c5 <fsipc>
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <devfile_stat>:
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	53                   	push   %ebx
  801762:	83 ec 04             	sub    $0x4,%esp
  801765:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	8b 40 0c             	mov    0xc(%eax),%eax
  80176e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801773:	ba 00 00 00 00       	mov    $0x0,%edx
  801778:	b8 05 00 00 00       	mov    $0x5,%eax
  80177d:	e8 43 ff ff ff       	call   8016c5 <fsipc>
  801782:	85 c0                	test   %eax,%eax
  801784:	78 2c                	js     8017b2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801786:	83 ec 08             	sub    $0x8,%esp
  801789:	68 00 50 80 00       	push   $0x805000
  80178e:	53                   	push   %ebx
  80178f:	e8 49 f2 ff ff       	call   8009dd <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801794:	a1 80 50 80 00       	mov    0x805080,%eax
  801799:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80179f:	a1 84 50 80 00       	mov    0x805084,%eax
  8017a4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <devfile_write>:
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	53                   	push   %ebx
  8017bb:	83 ec 04             	sub    $0x4,%esp
  8017be:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8017c1:	85 db                	test   %ebx,%ebx
  8017c3:	75 07                	jne    8017cc <devfile_write+0x15>
	return n_all;
  8017c5:	89 d8                	mov    %ebx,%eax
}
  8017c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d2:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  8017d7:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  8017dd:	83 ec 04             	sub    $0x4,%esp
  8017e0:	53                   	push   %ebx
  8017e1:	ff 75 0c             	pushl  0xc(%ebp)
  8017e4:	68 08 50 80 00       	push   $0x805008
  8017e9:	e8 7d f3 ff ff       	call   800b6b <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f3:	b8 04 00 00 00       	mov    $0x4,%eax
  8017f8:	e8 c8 fe ff ff       	call   8016c5 <fsipc>
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	85 c0                	test   %eax,%eax
  801802:	78 c3                	js     8017c7 <devfile_write+0x10>
	  assert(r <= n_left);
  801804:	39 d8                	cmp    %ebx,%eax
  801806:	77 0b                	ja     801813 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801808:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80180d:	7f 1d                	jg     80182c <devfile_write+0x75>
    n_all += r;
  80180f:	89 c3                	mov    %eax,%ebx
  801811:	eb b2                	jmp    8017c5 <devfile_write+0xe>
	  assert(r <= n_left);
  801813:	68 dc 2b 80 00       	push   $0x802bdc
  801818:	68 e8 2b 80 00       	push   $0x802be8
  80181d:	68 9f 00 00 00       	push   $0x9f
  801822:	68 fd 2b 80 00       	push   $0x802bfd
  801827:	e8 fa ea ff ff       	call   800326 <_panic>
	  assert(r <= PGSIZE);
  80182c:	68 08 2c 80 00       	push   $0x802c08
  801831:	68 e8 2b 80 00       	push   $0x802be8
  801836:	68 a0 00 00 00       	push   $0xa0
  80183b:	68 fd 2b 80 00       	push   $0x802bfd
  801840:	e8 e1 ea ff ff       	call   800326 <_panic>

00801845 <devfile_read>:
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	56                   	push   %esi
  801849:	53                   	push   %ebx
  80184a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	8b 40 0c             	mov    0xc(%eax),%eax
  801853:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801858:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80185e:	ba 00 00 00 00       	mov    $0x0,%edx
  801863:	b8 03 00 00 00       	mov    $0x3,%eax
  801868:	e8 58 fe ff ff       	call   8016c5 <fsipc>
  80186d:	89 c3                	mov    %eax,%ebx
  80186f:	85 c0                	test   %eax,%eax
  801871:	78 1f                	js     801892 <devfile_read+0x4d>
	assert(r <= n);
  801873:	39 f0                	cmp    %esi,%eax
  801875:	77 24                	ja     80189b <devfile_read+0x56>
	assert(r <= PGSIZE);
  801877:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80187c:	7f 33                	jg     8018b1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80187e:	83 ec 04             	sub    $0x4,%esp
  801881:	50                   	push   %eax
  801882:	68 00 50 80 00       	push   $0x805000
  801887:	ff 75 0c             	pushl  0xc(%ebp)
  80188a:	e8 dc f2 ff ff       	call   800b6b <memmove>
	return r;
  80188f:	83 c4 10             	add    $0x10,%esp
}
  801892:	89 d8                	mov    %ebx,%eax
  801894:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801897:	5b                   	pop    %ebx
  801898:	5e                   	pop    %esi
  801899:	5d                   	pop    %ebp
  80189a:	c3                   	ret    
	assert(r <= n);
  80189b:	68 14 2c 80 00       	push   $0x802c14
  8018a0:	68 e8 2b 80 00       	push   $0x802be8
  8018a5:	6a 7c                	push   $0x7c
  8018a7:	68 fd 2b 80 00       	push   $0x802bfd
  8018ac:	e8 75 ea ff ff       	call   800326 <_panic>
	assert(r <= PGSIZE);
  8018b1:	68 08 2c 80 00       	push   $0x802c08
  8018b6:	68 e8 2b 80 00       	push   $0x802be8
  8018bb:	6a 7d                	push   $0x7d
  8018bd:	68 fd 2b 80 00       	push   $0x802bfd
  8018c2:	e8 5f ea ff ff       	call   800326 <_panic>

008018c7 <open>:
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	56                   	push   %esi
  8018cb:	53                   	push   %ebx
  8018cc:	83 ec 1c             	sub    $0x1c,%esp
  8018cf:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018d2:	56                   	push   %esi
  8018d3:	e8 cc f0 ff ff       	call   8009a4 <strlen>
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018e0:	7f 6c                	jg     80194e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018e2:	83 ec 0c             	sub    $0xc,%esp
  8018e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e8:	50                   	push   %eax
  8018e9:	e8 6c f8 ff ff       	call   80115a <fd_alloc>
  8018ee:	89 c3                	mov    %eax,%ebx
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 3c                	js     801933 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	56                   	push   %esi
  8018fb:	68 00 50 80 00       	push   $0x805000
  801900:	e8 d8 f0 ff ff       	call   8009dd <strcpy>
	fsipcbuf.open.req_omode = mode;
  801905:	8b 45 0c             	mov    0xc(%ebp),%eax
  801908:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80190d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801910:	b8 01 00 00 00       	mov    $0x1,%eax
  801915:	e8 ab fd ff ff       	call   8016c5 <fsipc>
  80191a:	89 c3                	mov    %eax,%ebx
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	85 c0                	test   %eax,%eax
  801921:	78 19                	js     80193c <open+0x75>
	return fd2num(fd);
  801923:	83 ec 0c             	sub    $0xc,%esp
  801926:	ff 75 f4             	pushl  -0xc(%ebp)
  801929:	e8 05 f8 ff ff       	call   801133 <fd2num>
  80192e:	89 c3                	mov    %eax,%ebx
  801930:	83 c4 10             	add    $0x10,%esp
}
  801933:	89 d8                	mov    %ebx,%eax
  801935:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801938:	5b                   	pop    %ebx
  801939:	5e                   	pop    %esi
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    
		fd_close(fd, 0);
  80193c:	83 ec 08             	sub    $0x8,%esp
  80193f:	6a 00                	push   $0x0
  801941:	ff 75 f4             	pushl  -0xc(%ebp)
  801944:	e8 0e f9 ff ff       	call   801257 <fd_close>
		return r;
  801949:	83 c4 10             	add    $0x10,%esp
  80194c:	eb e5                	jmp    801933 <open+0x6c>
		return -E_BAD_PATH;
  80194e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801953:	eb de                	jmp    801933 <open+0x6c>

00801955 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80195b:	ba 00 00 00 00       	mov    $0x0,%edx
  801960:	b8 08 00 00 00       	mov    $0x8,%eax
  801965:	e8 5b fd ff ff       	call   8016c5 <fsipc>
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80196c:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801970:	7f 01                	jg     801973 <writebuf+0x7>
  801972:	c3                   	ret    
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	53                   	push   %ebx
  801977:	83 ec 08             	sub    $0x8,%esp
  80197a:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80197c:	ff 70 04             	pushl  0x4(%eax)
  80197f:	8d 40 10             	lea    0x10(%eax),%eax
  801982:	50                   	push   %eax
  801983:	ff 33                	pushl  (%ebx)
  801985:	e8 5e fb ff ff       	call   8014e8 <write>
		if (result > 0)
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	85 c0                	test   %eax,%eax
  80198f:	7e 03                	jle    801994 <writebuf+0x28>
			b->result += result;
  801991:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801994:	39 43 04             	cmp    %eax,0x4(%ebx)
  801997:	74 0d                	je     8019a6 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801999:	85 c0                	test   %eax,%eax
  80199b:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a0:	0f 4f c2             	cmovg  %edx,%eax
  8019a3:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <putch>:

static void
putch(int ch, void *thunk)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	53                   	push   %ebx
  8019af:	83 ec 04             	sub    $0x4,%esp
  8019b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019b5:	8b 53 04             	mov    0x4(%ebx),%edx
  8019b8:	8d 42 01             	lea    0x1(%edx),%eax
  8019bb:	89 43 04             	mov    %eax,0x4(%ebx)
  8019be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c1:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019c5:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019ca:	74 06                	je     8019d2 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8019cc:	83 c4 04             	add    $0x4,%esp
  8019cf:	5b                   	pop    %ebx
  8019d0:	5d                   	pop    %ebp
  8019d1:	c3                   	ret    
		writebuf(b);
  8019d2:	89 d8                	mov    %ebx,%eax
  8019d4:	e8 93 ff ff ff       	call   80196c <writebuf>
		b->idx = 0;
  8019d9:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8019e0:	eb ea                	jmp    8019cc <putch+0x21>

008019e2 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8019f4:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8019fb:	00 00 00 
	b.result = 0;
  8019fe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a05:	00 00 00 
	b.error = 1;
  801a08:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a0f:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a12:	ff 75 10             	pushl  0x10(%ebp)
  801a15:	ff 75 0c             	pushl  0xc(%ebp)
  801a18:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a1e:	50                   	push   %eax
  801a1f:	68 ab 19 80 00       	push   $0x8019ab
  801a24:	e8 d4 ea ff ff       	call   8004fd <vprintfmt>
	if (b.idx > 0)
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a33:	7f 11                	jg     801a46 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a35:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    
		writebuf(&b);
  801a46:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a4c:	e8 1b ff ff ff       	call   80196c <writebuf>
  801a51:	eb e2                	jmp    801a35 <vfprintf+0x53>

00801a53 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a59:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a5c:	50                   	push   %eax
  801a5d:	ff 75 0c             	pushl  0xc(%ebp)
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	e8 7a ff ff ff       	call   8019e2 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <printf>:

int
printf(const char *fmt, ...)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a70:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a73:	50                   	push   %eax
  801a74:	ff 75 08             	pushl  0x8(%ebp)
  801a77:	6a 01                	push   $0x1
  801a79:	e8 64 ff ff ff       	call   8019e2 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	56                   	push   %esi
  801a84:	53                   	push   %ebx
  801a85:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a88:	83 ec 0c             	sub    $0xc,%esp
  801a8b:	ff 75 08             	pushl  0x8(%ebp)
  801a8e:	e8 b0 f6 ff ff       	call   801143 <fd2data>
  801a93:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a95:	83 c4 08             	add    $0x8,%esp
  801a98:	68 1b 2c 80 00       	push   $0x802c1b
  801a9d:	53                   	push   %ebx
  801a9e:	e8 3a ef ff ff       	call   8009dd <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801aa3:	8b 46 04             	mov    0x4(%esi),%eax
  801aa6:	2b 06                	sub    (%esi),%eax
  801aa8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801aae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ab5:	00 00 00 
	stat->st_dev = &devpipe;
  801ab8:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801abf:	30 80 00 
	return 0;
}
  801ac2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aca:	5b                   	pop    %ebx
  801acb:	5e                   	pop    %esi
  801acc:	5d                   	pop    %ebp
  801acd:	c3                   	ret    

00801ace <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	53                   	push   %ebx
  801ad2:	83 ec 0c             	sub    $0xc,%esp
  801ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ad8:	53                   	push   %ebx
  801ad9:	6a 00                	push   $0x0
  801adb:	e8 74 f3 ff ff       	call   800e54 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ae0:	89 1c 24             	mov    %ebx,(%esp)
  801ae3:	e8 5b f6 ff ff       	call   801143 <fd2data>
  801ae8:	83 c4 08             	add    $0x8,%esp
  801aeb:	50                   	push   %eax
  801aec:	6a 00                	push   $0x0
  801aee:	e8 61 f3 ff ff       	call   800e54 <sys_page_unmap>
}
  801af3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <_pipeisclosed>:
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	57                   	push   %edi
  801afc:	56                   	push   %esi
  801afd:	53                   	push   %ebx
  801afe:	83 ec 1c             	sub    $0x1c,%esp
  801b01:	89 c7                	mov    %eax,%edi
  801b03:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b05:	a1 20 44 80 00       	mov    0x804420,%eax
  801b0a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b0d:	83 ec 0c             	sub    $0xc,%esp
  801b10:	57                   	push   %edi
  801b11:	e8 ac 09 00 00       	call   8024c2 <pageref>
  801b16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b19:	89 34 24             	mov    %esi,(%esp)
  801b1c:	e8 a1 09 00 00       	call   8024c2 <pageref>
		nn = thisenv->env_runs;
  801b21:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801b27:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b2a:	83 c4 10             	add    $0x10,%esp
  801b2d:	39 cb                	cmp    %ecx,%ebx
  801b2f:	74 1b                	je     801b4c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b31:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b34:	75 cf                	jne    801b05 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b36:	8b 42 58             	mov    0x58(%edx),%eax
  801b39:	6a 01                	push   $0x1
  801b3b:	50                   	push   %eax
  801b3c:	53                   	push   %ebx
  801b3d:	68 22 2c 80 00       	push   $0x802c22
  801b42:	e8 ba e8 ff ff       	call   800401 <cprintf>
  801b47:	83 c4 10             	add    $0x10,%esp
  801b4a:	eb b9                	jmp    801b05 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b4c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b4f:	0f 94 c0             	sete   %al
  801b52:	0f b6 c0             	movzbl %al,%eax
}
  801b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b58:	5b                   	pop    %ebx
  801b59:	5e                   	pop    %esi
  801b5a:	5f                   	pop    %edi
  801b5b:	5d                   	pop    %ebp
  801b5c:	c3                   	ret    

00801b5d <devpipe_write>:
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	57                   	push   %edi
  801b61:	56                   	push   %esi
  801b62:	53                   	push   %ebx
  801b63:	83 ec 28             	sub    $0x28,%esp
  801b66:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b69:	56                   	push   %esi
  801b6a:	e8 d4 f5 ff ff       	call   801143 <fd2data>
  801b6f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b71:	83 c4 10             	add    $0x10,%esp
  801b74:	bf 00 00 00 00       	mov    $0x0,%edi
  801b79:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b7c:	74 4f                	je     801bcd <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b7e:	8b 43 04             	mov    0x4(%ebx),%eax
  801b81:	8b 0b                	mov    (%ebx),%ecx
  801b83:	8d 51 20             	lea    0x20(%ecx),%edx
  801b86:	39 d0                	cmp    %edx,%eax
  801b88:	72 14                	jb     801b9e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b8a:	89 da                	mov    %ebx,%edx
  801b8c:	89 f0                	mov    %esi,%eax
  801b8e:	e8 65 ff ff ff       	call   801af8 <_pipeisclosed>
  801b93:	85 c0                	test   %eax,%eax
  801b95:	75 3b                	jne    801bd2 <devpipe_write+0x75>
			sys_yield();
  801b97:	e8 14 f2 ff ff       	call   800db0 <sys_yield>
  801b9c:	eb e0                	jmp    801b7e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ba1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ba5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ba8:	89 c2                	mov    %eax,%edx
  801baa:	c1 fa 1f             	sar    $0x1f,%edx
  801bad:	89 d1                	mov    %edx,%ecx
  801baf:	c1 e9 1b             	shr    $0x1b,%ecx
  801bb2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bb5:	83 e2 1f             	and    $0x1f,%edx
  801bb8:	29 ca                	sub    %ecx,%edx
  801bba:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bbe:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bc2:	83 c0 01             	add    $0x1,%eax
  801bc5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bc8:	83 c7 01             	add    $0x1,%edi
  801bcb:	eb ac                	jmp    801b79 <devpipe_write+0x1c>
	return i;
  801bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd0:	eb 05                	jmp    801bd7 <devpipe_write+0x7a>
				return 0;
  801bd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bda:	5b                   	pop    %ebx
  801bdb:	5e                   	pop    %esi
  801bdc:	5f                   	pop    %edi
  801bdd:	5d                   	pop    %ebp
  801bde:	c3                   	ret    

00801bdf <devpipe_read>:
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	57                   	push   %edi
  801be3:	56                   	push   %esi
  801be4:	53                   	push   %ebx
  801be5:	83 ec 18             	sub    $0x18,%esp
  801be8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801beb:	57                   	push   %edi
  801bec:	e8 52 f5 ff ff       	call   801143 <fd2data>
  801bf1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bf3:	83 c4 10             	add    $0x10,%esp
  801bf6:	be 00 00 00 00       	mov    $0x0,%esi
  801bfb:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bfe:	75 14                	jne    801c14 <devpipe_read+0x35>
	return i;
  801c00:	8b 45 10             	mov    0x10(%ebp),%eax
  801c03:	eb 02                	jmp    801c07 <devpipe_read+0x28>
				return i;
  801c05:	89 f0                	mov    %esi,%eax
}
  801c07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c0a:	5b                   	pop    %ebx
  801c0b:	5e                   	pop    %esi
  801c0c:	5f                   	pop    %edi
  801c0d:	5d                   	pop    %ebp
  801c0e:	c3                   	ret    
			sys_yield();
  801c0f:	e8 9c f1 ff ff       	call   800db0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c14:	8b 03                	mov    (%ebx),%eax
  801c16:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c19:	75 18                	jne    801c33 <devpipe_read+0x54>
			if (i > 0)
  801c1b:	85 f6                	test   %esi,%esi
  801c1d:	75 e6                	jne    801c05 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801c1f:	89 da                	mov    %ebx,%edx
  801c21:	89 f8                	mov    %edi,%eax
  801c23:	e8 d0 fe ff ff       	call   801af8 <_pipeisclosed>
  801c28:	85 c0                	test   %eax,%eax
  801c2a:	74 e3                	je     801c0f <devpipe_read+0x30>
				return 0;
  801c2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c31:	eb d4                	jmp    801c07 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c33:	99                   	cltd   
  801c34:	c1 ea 1b             	shr    $0x1b,%edx
  801c37:	01 d0                	add    %edx,%eax
  801c39:	83 e0 1f             	and    $0x1f,%eax
  801c3c:	29 d0                	sub    %edx,%eax
  801c3e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c46:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c49:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c4c:	83 c6 01             	add    $0x1,%esi
  801c4f:	eb aa                	jmp    801bfb <devpipe_read+0x1c>

00801c51 <pipe>:
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	56                   	push   %esi
  801c55:	53                   	push   %ebx
  801c56:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c5c:	50                   	push   %eax
  801c5d:	e8 f8 f4 ff ff       	call   80115a <fd_alloc>
  801c62:	89 c3                	mov    %eax,%ebx
  801c64:	83 c4 10             	add    $0x10,%esp
  801c67:	85 c0                	test   %eax,%eax
  801c69:	0f 88 23 01 00 00    	js     801d92 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c6f:	83 ec 04             	sub    $0x4,%esp
  801c72:	68 07 04 00 00       	push   $0x407
  801c77:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7a:	6a 00                	push   $0x0
  801c7c:	e8 4e f1 ff ff       	call   800dcf <sys_page_alloc>
  801c81:	89 c3                	mov    %eax,%ebx
  801c83:	83 c4 10             	add    $0x10,%esp
  801c86:	85 c0                	test   %eax,%eax
  801c88:	0f 88 04 01 00 00    	js     801d92 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801c8e:	83 ec 0c             	sub    $0xc,%esp
  801c91:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c94:	50                   	push   %eax
  801c95:	e8 c0 f4 ff ff       	call   80115a <fd_alloc>
  801c9a:	89 c3                	mov    %eax,%ebx
  801c9c:	83 c4 10             	add    $0x10,%esp
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	0f 88 db 00 00 00    	js     801d82 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ca7:	83 ec 04             	sub    $0x4,%esp
  801caa:	68 07 04 00 00       	push   $0x407
  801caf:	ff 75 f0             	pushl  -0x10(%ebp)
  801cb2:	6a 00                	push   $0x0
  801cb4:	e8 16 f1 ff ff       	call   800dcf <sys_page_alloc>
  801cb9:	89 c3                	mov    %eax,%ebx
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	0f 88 bc 00 00 00    	js     801d82 <pipe+0x131>
	va = fd2data(fd0);
  801cc6:	83 ec 0c             	sub    $0xc,%esp
  801cc9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ccc:	e8 72 f4 ff ff       	call   801143 <fd2data>
  801cd1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cd3:	83 c4 0c             	add    $0xc,%esp
  801cd6:	68 07 04 00 00       	push   $0x407
  801cdb:	50                   	push   %eax
  801cdc:	6a 00                	push   $0x0
  801cde:	e8 ec f0 ff ff       	call   800dcf <sys_page_alloc>
  801ce3:	89 c3                	mov    %eax,%ebx
  801ce5:	83 c4 10             	add    $0x10,%esp
  801ce8:	85 c0                	test   %eax,%eax
  801cea:	0f 88 82 00 00 00    	js     801d72 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf0:	83 ec 0c             	sub    $0xc,%esp
  801cf3:	ff 75 f0             	pushl  -0x10(%ebp)
  801cf6:	e8 48 f4 ff ff       	call   801143 <fd2data>
  801cfb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d02:	50                   	push   %eax
  801d03:	6a 00                	push   $0x0
  801d05:	56                   	push   %esi
  801d06:	6a 00                	push   $0x0
  801d08:	e8 05 f1 ff ff       	call   800e12 <sys_page_map>
  801d0d:	89 c3                	mov    %eax,%ebx
  801d0f:	83 c4 20             	add    $0x20,%esp
  801d12:	85 c0                	test   %eax,%eax
  801d14:	78 4e                	js     801d64 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801d16:	a1 20 30 80 00       	mov    0x803020,%eax
  801d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d1e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d23:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d2d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d32:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d39:	83 ec 0c             	sub    $0xc,%esp
  801d3c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3f:	e8 ef f3 ff ff       	call   801133 <fd2num>
  801d44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d47:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d49:	83 c4 04             	add    $0x4,%esp
  801d4c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d4f:	e8 df f3 ff ff       	call   801133 <fd2num>
  801d54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d57:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d5a:	83 c4 10             	add    $0x10,%esp
  801d5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d62:	eb 2e                	jmp    801d92 <pipe+0x141>
	sys_page_unmap(0, va);
  801d64:	83 ec 08             	sub    $0x8,%esp
  801d67:	56                   	push   %esi
  801d68:	6a 00                	push   $0x0
  801d6a:	e8 e5 f0 ff ff       	call   800e54 <sys_page_unmap>
  801d6f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d72:	83 ec 08             	sub    $0x8,%esp
  801d75:	ff 75 f0             	pushl  -0x10(%ebp)
  801d78:	6a 00                	push   $0x0
  801d7a:	e8 d5 f0 ff ff       	call   800e54 <sys_page_unmap>
  801d7f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d82:	83 ec 08             	sub    $0x8,%esp
  801d85:	ff 75 f4             	pushl  -0xc(%ebp)
  801d88:	6a 00                	push   $0x0
  801d8a:	e8 c5 f0 ff ff       	call   800e54 <sys_page_unmap>
  801d8f:	83 c4 10             	add    $0x10,%esp
}
  801d92:	89 d8                	mov    %ebx,%eax
  801d94:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d97:	5b                   	pop    %ebx
  801d98:	5e                   	pop    %esi
  801d99:	5d                   	pop    %ebp
  801d9a:	c3                   	ret    

00801d9b <pipeisclosed>:
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801da1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da4:	50                   	push   %eax
  801da5:	ff 75 08             	pushl  0x8(%ebp)
  801da8:	e8 ff f3 ff ff       	call   8011ac <fd_lookup>
  801dad:	83 c4 10             	add    $0x10,%esp
  801db0:	85 c0                	test   %eax,%eax
  801db2:	78 18                	js     801dcc <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801db4:	83 ec 0c             	sub    $0xc,%esp
  801db7:	ff 75 f4             	pushl  -0xc(%ebp)
  801dba:	e8 84 f3 ff ff       	call   801143 <fd2data>
	return _pipeisclosed(fd, p);
  801dbf:	89 c2                	mov    %eax,%edx
  801dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc4:	e8 2f fd ff ff       	call   801af8 <_pipeisclosed>
  801dc9:	83 c4 10             	add    $0x10,%esp
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801dd4:	68 3a 2c 80 00       	push   $0x802c3a
  801dd9:	ff 75 0c             	pushl  0xc(%ebp)
  801ddc:	e8 fc eb ff ff       	call   8009dd <strcpy>
	return 0;
}
  801de1:	b8 00 00 00 00       	mov    $0x0,%eax
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <devsock_close>:
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	53                   	push   %ebx
  801dec:	83 ec 10             	sub    $0x10,%esp
  801def:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801df2:	53                   	push   %ebx
  801df3:	e8 ca 06 00 00       	call   8024c2 <pageref>
  801df8:	83 c4 10             	add    $0x10,%esp
		return 0;
  801dfb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e00:	83 f8 01             	cmp    $0x1,%eax
  801e03:	74 07                	je     801e0c <devsock_close+0x24>
}
  801e05:	89 d0                	mov    %edx,%eax
  801e07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e0c:	83 ec 0c             	sub    $0xc,%esp
  801e0f:	ff 73 0c             	pushl  0xc(%ebx)
  801e12:	e8 b9 02 00 00       	call   8020d0 <nsipc_close>
  801e17:	89 c2                	mov    %eax,%edx
  801e19:	83 c4 10             	add    $0x10,%esp
  801e1c:	eb e7                	jmp    801e05 <devsock_close+0x1d>

00801e1e <devsock_write>:
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e24:	6a 00                	push   $0x0
  801e26:	ff 75 10             	pushl  0x10(%ebp)
  801e29:	ff 75 0c             	pushl  0xc(%ebp)
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	ff 70 0c             	pushl  0xc(%eax)
  801e32:	e8 76 03 00 00       	call   8021ad <nsipc_send>
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <devsock_read>:
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e3f:	6a 00                	push   $0x0
  801e41:	ff 75 10             	pushl  0x10(%ebp)
  801e44:	ff 75 0c             	pushl  0xc(%ebp)
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	ff 70 0c             	pushl  0xc(%eax)
  801e4d:	e8 ef 02 00 00       	call   802141 <nsipc_recv>
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <fd2sockid>:
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e5a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e5d:	52                   	push   %edx
  801e5e:	50                   	push   %eax
  801e5f:	e8 48 f3 ff ff       	call   8011ac <fd_lookup>
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	85 c0                	test   %eax,%eax
  801e69:	78 10                	js     801e7b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6e:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801e74:	39 08                	cmp    %ecx,(%eax)
  801e76:	75 05                	jne    801e7d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e78:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    
		return -E_NOT_SUPP;
  801e7d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e82:	eb f7                	jmp    801e7b <fd2sockid+0x27>

00801e84 <alloc_sockfd>:
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	56                   	push   %esi
  801e88:	53                   	push   %ebx
  801e89:	83 ec 1c             	sub    $0x1c,%esp
  801e8c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e91:	50                   	push   %eax
  801e92:	e8 c3 f2 ff ff       	call   80115a <fd_alloc>
  801e97:	89 c3                	mov    %eax,%ebx
  801e99:	83 c4 10             	add    $0x10,%esp
  801e9c:	85 c0                	test   %eax,%eax
  801e9e:	78 43                	js     801ee3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ea0:	83 ec 04             	sub    $0x4,%esp
  801ea3:	68 07 04 00 00       	push   $0x407
  801ea8:	ff 75 f4             	pushl  -0xc(%ebp)
  801eab:	6a 00                	push   $0x0
  801ead:	e8 1d ef ff ff       	call   800dcf <sys_page_alloc>
  801eb2:	89 c3                	mov    %eax,%ebx
  801eb4:	83 c4 10             	add    $0x10,%esp
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	78 28                	js     801ee3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebe:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ec4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ed0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	50                   	push   %eax
  801ed7:	e8 57 f2 ff ff       	call   801133 <fd2num>
  801edc:	89 c3                	mov    %eax,%ebx
  801ede:	83 c4 10             	add    $0x10,%esp
  801ee1:	eb 0c                	jmp    801eef <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ee3:	83 ec 0c             	sub    $0xc,%esp
  801ee6:	56                   	push   %esi
  801ee7:	e8 e4 01 00 00       	call   8020d0 <nsipc_close>
		return r;
  801eec:	83 c4 10             	add    $0x10,%esp
}
  801eef:	89 d8                	mov    %ebx,%eax
  801ef1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ef4:	5b                   	pop    %ebx
  801ef5:	5e                   	pop    %esi
  801ef6:	5d                   	pop    %ebp
  801ef7:	c3                   	ret    

00801ef8 <accept>:
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	e8 4e ff ff ff       	call   801e54 <fd2sockid>
  801f06:	85 c0                	test   %eax,%eax
  801f08:	78 1b                	js     801f25 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f0a:	83 ec 04             	sub    $0x4,%esp
  801f0d:	ff 75 10             	pushl  0x10(%ebp)
  801f10:	ff 75 0c             	pushl  0xc(%ebp)
  801f13:	50                   	push   %eax
  801f14:	e8 0e 01 00 00       	call   802027 <nsipc_accept>
  801f19:	83 c4 10             	add    $0x10,%esp
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	78 05                	js     801f25 <accept+0x2d>
	return alloc_sockfd(r);
  801f20:	e8 5f ff ff ff       	call   801e84 <alloc_sockfd>
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <bind>:
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	e8 1f ff ff ff       	call   801e54 <fd2sockid>
  801f35:	85 c0                	test   %eax,%eax
  801f37:	78 12                	js     801f4b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f39:	83 ec 04             	sub    $0x4,%esp
  801f3c:	ff 75 10             	pushl  0x10(%ebp)
  801f3f:	ff 75 0c             	pushl  0xc(%ebp)
  801f42:	50                   	push   %eax
  801f43:	e8 31 01 00 00       	call   802079 <nsipc_bind>
  801f48:	83 c4 10             	add    $0x10,%esp
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <shutdown>:
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	e8 f9 fe ff ff       	call   801e54 <fd2sockid>
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	78 0f                	js     801f6e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f5f:	83 ec 08             	sub    $0x8,%esp
  801f62:	ff 75 0c             	pushl  0xc(%ebp)
  801f65:	50                   	push   %eax
  801f66:	e8 43 01 00 00       	call   8020ae <nsipc_shutdown>
  801f6b:	83 c4 10             	add    $0x10,%esp
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <connect>:
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	e8 d6 fe ff ff       	call   801e54 <fd2sockid>
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 12                	js     801f94 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	ff 75 10             	pushl  0x10(%ebp)
  801f88:	ff 75 0c             	pushl  0xc(%ebp)
  801f8b:	50                   	push   %eax
  801f8c:	e8 59 01 00 00       	call   8020ea <nsipc_connect>
  801f91:	83 c4 10             	add    $0x10,%esp
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <listen>:
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	e8 b0 fe ff ff       	call   801e54 <fd2sockid>
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	78 0f                	js     801fb7 <listen+0x21>
	return nsipc_listen(r, backlog);
  801fa8:	83 ec 08             	sub    $0x8,%esp
  801fab:	ff 75 0c             	pushl  0xc(%ebp)
  801fae:	50                   	push   %eax
  801faf:	e8 6b 01 00 00       	call   80211f <nsipc_listen>
  801fb4:	83 c4 10             	add    $0x10,%esp
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <socket>:

int
socket(int domain, int type, int protocol)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fbf:	ff 75 10             	pushl  0x10(%ebp)
  801fc2:	ff 75 0c             	pushl  0xc(%ebp)
  801fc5:	ff 75 08             	pushl  0x8(%ebp)
  801fc8:	e8 3e 02 00 00       	call   80220b <nsipc_socket>
  801fcd:	83 c4 10             	add    $0x10,%esp
  801fd0:	85 c0                	test   %eax,%eax
  801fd2:	78 05                	js     801fd9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fd4:	e8 ab fe ff ff       	call   801e84 <alloc_sockfd>
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
  801fde:	53                   	push   %ebx
  801fdf:	83 ec 04             	sub    $0x4,%esp
  801fe2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fe4:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801feb:	74 26                	je     802013 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fed:	6a 07                	push   $0x7
  801fef:	68 00 60 80 00       	push   $0x806000
  801ff4:	53                   	push   %ebx
  801ff5:	ff 35 04 40 80 00    	pushl  0x804004
  801ffb:	e8 1d 04 00 00       	call   80241d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802000:	83 c4 0c             	add    $0xc,%esp
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	e8 9c 03 00 00       	call   8023aa <ipc_recv>
}
  80200e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802011:	c9                   	leave  
  802012:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802013:	83 ec 0c             	sub    $0xc,%esp
  802016:	6a 02                	push   $0x2
  802018:	e8 6c 04 00 00       	call   802489 <ipc_find_env>
  80201d:	a3 04 40 80 00       	mov    %eax,0x804004
  802022:	83 c4 10             	add    $0x10,%esp
  802025:	eb c6                	jmp    801fed <nsipc+0x12>

00802027 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	56                   	push   %esi
  80202b:	53                   	push   %ebx
  80202c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802037:	8b 06                	mov    (%esi),%eax
  802039:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80203e:	b8 01 00 00 00       	mov    $0x1,%eax
  802043:	e8 93 ff ff ff       	call   801fdb <nsipc>
  802048:	89 c3                	mov    %eax,%ebx
  80204a:	85 c0                	test   %eax,%eax
  80204c:	79 09                	jns    802057 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80204e:	89 d8                	mov    %ebx,%eax
  802050:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802053:	5b                   	pop    %ebx
  802054:	5e                   	pop    %esi
  802055:	5d                   	pop    %ebp
  802056:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	ff 35 10 60 80 00    	pushl  0x806010
  802060:	68 00 60 80 00       	push   $0x806000
  802065:	ff 75 0c             	pushl  0xc(%ebp)
  802068:	e8 fe ea ff ff       	call   800b6b <memmove>
		*addrlen = ret->ret_addrlen;
  80206d:	a1 10 60 80 00       	mov    0x806010,%eax
  802072:	89 06                	mov    %eax,(%esi)
  802074:	83 c4 10             	add    $0x10,%esp
	return r;
  802077:	eb d5                	jmp    80204e <nsipc_accept+0x27>

00802079 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	53                   	push   %ebx
  80207d:	83 ec 08             	sub    $0x8,%esp
  802080:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80208b:	53                   	push   %ebx
  80208c:	ff 75 0c             	pushl  0xc(%ebp)
  80208f:	68 04 60 80 00       	push   $0x806004
  802094:	e8 d2 ea ff ff       	call   800b6b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802099:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80209f:	b8 02 00 00 00       	mov    $0x2,%eax
  8020a4:	e8 32 ff ff ff       	call   801fdb <nsipc>
}
  8020a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
  8020b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8020bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020bf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8020c4:	b8 03 00 00 00       	mov    $0x3,%eax
  8020c9:	e8 0d ff ff ff       	call   801fdb <nsipc>
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <nsipc_close>:

int
nsipc_close(int s)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8020de:	b8 04 00 00 00       	mov    $0x4,%eax
  8020e3:	e8 f3 fe ff ff       	call   801fdb <nsipc>
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	53                   	push   %ebx
  8020ee:	83 ec 08             	sub    $0x8,%esp
  8020f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020fc:	53                   	push   %ebx
  8020fd:	ff 75 0c             	pushl  0xc(%ebp)
  802100:	68 04 60 80 00       	push   $0x806004
  802105:	e8 61 ea ff ff       	call   800b6b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80210a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802110:	b8 05 00 00 00       	mov    $0x5,%eax
  802115:	e8 c1 fe ff ff       	call   801fdb <nsipc>
}
  80211a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80212d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802130:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802135:	b8 06 00 00 00       	mov    $0x6,%eax
  80213a:	e8 9c fe ff ff       	call   801fdb <nsipc>
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	56                   	push   %esi
  802145:	53                   	push   %ebx
  802146:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802151:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802157:	8b 45 14             	mov    0x14(%ebp),%eax
  80215a:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80215f:	b8 07 00 00 00       	mov    $0x7,%eax
  802164:	e8 72 fe ff ff       	call   801fdb <nsipc>
  802169:	89 c3                	mov    %eax,%ebx
  80216b:	85 c0                	test   %eax,%eax
  80216d:	78 1f                	js     80218e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80216f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802174:	7f 21                	jg     802197 <nsipc_recv+0x56>
  802176:	39 c6                	cmp    %eax,%esi
  802178:	7c 1d                	jl     802197 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	50                   	push   %eax
  80217e:	68 00 60 80 00       	push   $0x806000
  802183:	ff 75 0c             	pushl  0xc(%ebp)
  802186:	e8 e0 e9 ff ff       	call   800b6b <memmove>
  80218b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80218e:	89 d8                	mov    %ebx,%eax
  802190:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802193:	5b                   	pop    %ebx
  802194:	5e                   	pop    %esi
  802195:	5d                   	pop    %ebp
  802196:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802197:	68 46 2c 80 00       	push   $0x802c46
  80219c:	68 e8 2b 80 00       	push   $0x802be8
  8021a1:	6a 62                	push   $0x62
  8021a3:	68 5b 2c 80 00       	push   $0x802c5b
  8021a8:	e8 79 e1 ff ff       	call   800326 <_panic>

008021ad <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	53                   	push   %ebx
  8021b1:	83 ec 04             	sub    $0x4,%esp
  8021b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8021bf:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021c5:	7f 2e                	jg     8021f5 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	53                   	push   %ebx
  8021cb:	ff 75 0c             	pushl  0xc(%ebp)
  8021ce:	68 0c 60 80 00       	push   $0x80600c
  8021d3:	e8 93 e9 ff ff       	call   800b6b <memmove>
	nsipcbuf.send.req_size = size;
  8021d8:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8021de:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8021e6:	b8 08 00 00 00       	mov    $0x8,%eax
  8021eb:	e8 eb fd ff ff       	call   801fdb <nsipc>
}
  8021f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    
	assert(size < 1600);
  8021f5:	68 67 2c 80 00       	push   $0x802c67
  8021fa:	68 e8 2b 80 00       	push   $0x802be8
  8021ff:	6a 6d                	push   $0x6d
  802201:	68 5b 2c 80 00       	push   $0x802c5b
  802206:	e8 1b e1 ff ff       	call   800326 <_panic>

0080220b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221c:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802221:	8b 45 10             	mov    0x10(%ebp),%eax
  802224:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802229:	b8 09 00 00 00       	mov    $0x9,%eax
  80222e:	e8 a8 fd ff ff       	call   801fdb <nsipc>
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802235:	b8 00 00 00 00       	mov    $0x0,%eax
  80223a:	c3                   	ret    

0080223b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802241:	68 73 2c 80 00       	push   $0x802c73
  802246:	ff 75 0c             	pushl  0xc(%ebp)
  802249:	e8 8f e7 ff ff       	call   8009dd <strcpy>
	return 0;
}
  80224e:	b8 00 00 00 00       	mov    $0x0,%eax
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <devcons_write>:
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	57                   	push   %edi
  802259:	56                   	push   %esi
  80225a:	53                   	push   %ebx
  80225b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802261:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802266:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80226c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80226f:	73 31                	jae    8022a2 <devcons_write+0x4d>
		m = n - tot;
  802271:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802274:	29 f3                	sub    %esi,%ebx
  802276:	83 fb 7f             	cmp    $0x7f,%ebx
  802279:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80227e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802281:	83 ec 04             	sub    $0x4,%esp
  802284:	53                   	push   %ebx
  802285:	89 f0                	mov    %esi,%eax
  802287:	03 45 0c             	add    0xc(%ebp),%eax
  80228a:	50                   	push   %eax
  80228b:	57                   	push   %edi
  80228c:	e8 da e8 ff ff       	call   800b6b <memmove>
		sys_cputs(buf, m);
  802291:	83 c4 08             	add    $0x8,%esp
  802294:	53                   	push   %ebx
  802295:	57                   	push   %edi
  802296:	e8 78 ea ff ff       	call   800d13 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80229b:	01 de                	add    %ebx,%esi
  80229d:	83 c4 10             	add    $0x10,%esp
  8022a0:	eb ca                	jmp    80226c <devcons_write+0x17>
}
  8022a2:	89 f0                	mov    %esi,%eax
  8022a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a7:	5b                   	pop    %ebx
  8022a8:	5e                   	pop    %esi
  8022a9:	5f                   	pop    %edi
  8022aa:	5d                   	pop    %ebp
  8022ab:	c3                   	ret    

008022ac <devcons_read>:
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
  8022af:	83 ec 08             	sub    $0x8,%esp
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022bb:	74 21                	je     8022de <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8022bd:	e8 6f ea ff ff       	call   800d31 <sys_cgetc>
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	75 07                	jne    8022cd <devcons_read+0x21>
		sys_yield();
  8022c6:	e8 e5 ea ff ff       	call   800db0 <sys_yield>
  8022cb:	eb f0                	jmp    8022bd <devcons_read+0x11>
	if (c < 0)
  8022cd:	78 0f                	js     8022de <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8022cf:	83 f8 04             	cmp    $0x4,%eax
  8022d2:	74 0c                	je     8022e0 <devcons_read+0x34>
	*(char*)vbuf = c;
  8022d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d7:	88 02                	mov    %al,(%edx)
	return 1;
  8022d9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    
		return 0;
  8022e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e5:	eb f7                	jmp    8022de <devcons_read+0x32>

008022e7 <cputchar>:
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
  8022ea:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8022f3:	6a 01                	push   $0x1
  8022f5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022f8:	50                   	push   %eax
  8022f9:	e8 15 ea ff ff       	call   800d13 <sys_cputs>
}
  8022fe:	83 c4 10             	add    $0x10,%esp
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <getchar>:
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802309:	6a 01                	push   $0x1
  80230b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80230e:	50                   	push   %eax
  80230f:	6a 00                	push   $0x0
  802311:	e8 06 f1 ff ff       	call   80141c <read>
	if (r < 0)
  802316:	83 c4 10             	add    $0x10,%esp
  802319:	85 c0                	test   %eax,%eax
  80231b:	78 06                	js     802323 <getchar+0x20>
	if (r < 1)
  80231d:	74 06                	je     802325 <getchar+0x22>
	return c;
  80231f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    
		return -E_EOF;
  802325:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80232a:	eb f7                	jmp    802323 <getchar+0x20>

0080232c <iscons>:
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802332:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802335:	50                   	push   %eax
  802336:	ff 75 08             	pushl  0x8(%ebp)
  802339:	e8 6e ee ff ff       	call   8011ac <fd_lookup>
  80233e:	83 c4 10             	add    $0x10,%esp
  802341:	85 c0                	test   %eax,%eax
  802343:	78 11                	js     802356 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80234e:	39 10                	cmp    %edx,(%eax)
  802350:	0f 94 c0             	sete   %al
  802353:	0f b6 c0             	movzbl %al,%eax
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <opencons>:
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80235e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802361:	50                   	push   %eax
  802362:	e8 f3 ed ff ff       	call   80115a <fd_alloc>
  802367:	83 c4 10             	add    $0x10,%esp
  80236a:	85 c0                	test   %eax,%eax
  80236c:	78 3a                	js     8023a8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80236e:	83 ec 04             	sub    $0x4,%esp
  802371:	68 07 04 00 00       	push   $0x407
  802376:	ff 75 f4             	pushl  -0xc(%ebp)
  802379:	6a 00                	push   $0x0
  80237b:	e8 4f ea ff ff       	call   800dcf <sys_page_alloc>
  802380:	83 c4 10             	add    $0x10,%esp
  802383:	85 c0                	test   %eax,%eax
  802385:	78 21                	js     8023a8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802390:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80239c:	83 ec 0c             	sub    $0xc,%esp
  80239f:	50                   	push   %eax
  8023a0:	e8 8e ed ff ff       	call   801133 <fd2num>
  8023a5:	83 c4 10             	add    $0x10,%esp
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	56                   	push   %esi
  8023ae:	53                   	push   %ebx
  8023af:	8b 75 08             	mov    0x8(%ebp),%esi
  8023b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	74 4f                	je     80240b <ipc_recv+0x61>
  8023bc:	83 ec 0c             	sub    $0xc,%esp
  8023bf:	50                   	push   %eax
  8023c0:	e8 ba eb ff ff       	call   800f7f <sys_ipc_recv>
  8023c5:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  8023c8:	85 f6                	test   %esi,%esi
  8023ca:	74 14                	je     8023e0 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  8023cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8023d1:	85 c0                	test   %eax,%eax
  8023d3:	75 09                	jne    8023de <ipc_recv+0x34>
  8023d5:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8023db:	8b 52 74             	mov    0x74(%edx),%edx
  8023de:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8023e0:	85 db                	test   %ebx,%ebx
  8023e2:	74 14                	je     8023f8 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8023e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	75 09                	jne    8023f6 <ipc_recv+0x4c>
  8023ed:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8023f3:	8b 52 78             	mov    0x78(%edx),%edx
  8023f6:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	75 08                	jne    802404 <ipc_recv+0x5a>
  8023fc:	a1 20 44 80 00       	mov    0x804420,%eax
  802401:	8b 40 70             	mov    0x70(%eax),%eax
}
  802404:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802407:	5b                   	pop    %ebx
  802408:	5e                   	pop    %esi
  802409:	5d                   	pop    %ebp
  80240a:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  80240b:	83 ec 0c             	sub    $0xc,%esp
  80240e:	68 00 00 c0 ee       	push   $0xeec00000
  802413:	e8 67 eb ff ff       	call   800f7f <sys_ipc_recv>
  802418:	83 c4 10             	add    $0x10,%esp
  80241b:	eb ab                	jmp    8023c8 <ipc_recv+0x1e>

0080241d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
  802420:	57                   	push   %edi
  802421:	56                   	push   %esi
  802422:	53                   	push   %ebx
  802423:	83 ec 0c             	sub    $0xc,%esp
  802426:	8b 7d 08             	mov    0x8(%ebp),%edi
  802429:	8b 75 10             	mov    0x10(%ebp),%esi
  80242c:	eb 20                	jmp    80244e <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80242e:	6a 00                	push   $0x0
  802430:	68 00 00 c0 ee       	push   $0xeec00000
  802435:	ff 75 0c             	pushl  0xc(%ebp)
  802438:	57                   	push   %edi
  802439:	e8 1e eb ff ff       	call   800f5c <sys_ipc_try_send>
  80243e:	89 c3                	mov    %eax,%ebx
  802440:	83 c4 10             	add    $0x10,%esp
  802443:	eb 1f                	jmp    802464 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802445:	e8 66 e9 ff ff       	call   800db0 <sys_yield>
	while(retval != 0) {
  80244a:	85 db                	test   %ebx,%ebx
  80244c:	74 33                	je     802481 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80244e:	85 f6                	test   %esi,%esi
  802450:	74 dc                	je     80242e <ipc_send+0x11>
  802452:	ff 75 14             	pushl  0x14(%ebp)
  802455:	56                   	push   %esi
  802456:	ff 75 0c             	pushl  0xc(%ebp)
  802459:	57                   	push   %edi
  80245a:	e8 fd ea ff ff       	call   800f5c <sys_ipc_try_send>
  80245f:	89 c3                	mov    %eax,%ebx
  802461:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802464:	83 fb f9             	cmp    $0xfffffff9,%ebx
  802467:	74 dc                	je     802445 <ipc_send+0x28>
  802469:	85 db                	test   %ebx,%ebx
  80246b:	74 d8                	je     802445 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  80246d:	83 ec 04             	sub    $0x4,%esp
  802470:	68 80 2c 80 00       	push   $0x802c80
  802475:	6a 35                	push   $0x35
  802477:	68 b0 2c 80 00       	push   $0x802cb0
  80247c:	e8 a5 de ff ff       	call   800326 <_panic>
	}
}
  802481:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802484:	5b                   	pop    %ebx
  802485:	5e                   	pop    %esi
  802486:	5f                   	pop    %edi
  802487:	5d                   	pop    %ebp
  802488:	c3                   	ret    

00802489 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
  80248c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80248f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802494:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802497:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80249d:	8b 52 50             	mov    0x50(%edx),%edx
  8024a0:	39 ca                	cmp    %ecx,%edx
  8024a2:	74 11                	je     8024b5 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8024a4:	83 c0 01             	add    $0x1,%eax
  8024a7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024ac:	75 e6                	jne    802494 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b3:	eb 0b                	jmp    8024c0 <ipc_find_env+0x37>
			return envs[i].env_id;
  8024b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024bd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024c0:	5d                   	pop    %ebp
  8024c1:	c3                   	ret    

008024c2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
  8024c5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024c8:	89 d0                	mov    %edx,%eax
  8024ca:	c1 e8 16             	shr    $0x16,%eax
  8024cd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024d4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024d9:	f6 c1 01             	test   $0x1,%cl
  8024dc:	74 1d                	je     8024fb <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024de:	c1 ea 0c             	shr    $0xc,%edx
  8024e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024e8:	f6 c2 01             	test   $0x1,%dl
  8024eb:	74 0e                	je     8024fb <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024ed:	c1 ea 0c             	shr    $0xc,%edx
  8024f0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024f7:	ef 
  8024f8:	0f b7 c0             	movzwl %ax,%eax
}
  8024fb:	5d                   	pop    %ebp
  8024fc:	c3                   	ret    
  8024fd:	66 90                	xchg   %ax,%ax
  8024ff:	90                   	nop

00802500 <__udivdi3>:
  802500:	f3 0f 1e fb          	endbr32 
  802504:	55                   	push   %ebp
  802505:	57                   	push   %edi
  802506:	56                   	push   %esi
  802507:	53                   	push   %ebx
  802508:	83 ec 1c             	sub    $0x1c,%esp
  80250b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80250f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802513:	8b 74 24 34          	mov    0x34(%esp),%esi
  802517:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80251b:	85 d2                	test   %edx,%edx
  80251d:	75 49                	jne    802568 <__udivdi3+0x68>
  80251f:	39 f3                	cmp    %esi,%ebx
  802521:	76 15                	jbe    802538 <__udivdi3+0x38>
  802523:	31 ff                	xor    %edi,%edi
  802525:	89 e8                	mov    %ebp,%eax
  802527:	89 f2                	mov    %esi,%edx
  802529:	f7 f3                	div    %ebx
  80252b:	89 fa                	mov    %edi,%edx
  80252d:	83 c4 1c             	add    $0x1c,%esp
  802530:	5b                   	pop    %ebx
  802531:	5e                   	pop    %esi
  802532:	5f                   	pop    %edi
  802533:	5d                   	pop    %ebp
  802534:	c3                   	ret    
  802535:	8d 76 00             	lea    0x0(%esi),%esi
  802538:	89 d9                	mov    %ebx,%ecx
  80253a:	85 db                	test   %ebx,%ebx
  80253c:	75 0b                	jne    802549 <__udivdi3+0x49>
  80253e:	b8 01 00 00 00       	mov    $0x1,%eax
  802543:	31 d2                	xor    %edx,%edx
  802545:	f7 f3                	div    %ebx
  802547:	89 c1                	mov    %eax,%ecx
  802549:	31 d2                	xor    %edx,%edx
  80254b:	89 f0                	mov    %esi,%eax
  80254d:	f7 f1                	div    %ecx
  80254f:	89 c6                	mov    %eax,%esi
  802551:	89 e8                	mov    %ebp,%eax
  802553:	89 f7                	mov    %esi,%edi
  802555:	f7 f1                	div    %ecx
  802557:	89 fa                	mov    %edi,%edx
  802559:	83 c4 1c             	add    $0x1c,%esp
  80255c:	5b                   	pop    %ebx
  80255d:	5e                   	pop    %esi
  80255e:	5f                   	pop    %edi
  80255f:	5d                   	pop    %ebp
  802560:	c3                   	ret    
  802561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802568:	39 f2                	cmp    %esi,%edx
  80256a:	77 1c                	ja     802588 <__udivdi3+0x88>
  80256c:	0f bd fa             	bsr    %edx,%edi
  80256f:	83 f7 1f             	xor    $0x1f,%edi
  802572:	75 2c                	jne    8025a0 <__udivdi3+0xa0>
  802574:	39 f2                	cmp    %esi,%edx
  802576:	72 06                	jb     80257e <__udivdi3+0x7e>
  802578:	31 c0                	xor    %eax,%eax
  80257a:	39 eb                	cmp    %ebp,%ebx
  80257c:	77 ad                	ja     80252b <__udivdi3+0x2b>
  80257e:	b8 01 00 00 00       	mov    $0x1,%eax
  802583:	eb a6                	jmp    80252b <__udivdi3+0x2b>
  802585:	8d 76 00             	lea    0x0(%esi),%esi
  802588:	31 ff                	xor    %edi,%edi
  80258a:	31 c0                	xor    %eax,%eax
  80258c:	89 fa                	mov    %edi,%edx
  80258e:	83 c4 1c             	add    $0x1c,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80259d:	8d 76 00             	lea    0x0(%esi),%esi
  8025a0:	89 f9                	mov    %edi,%ecx
  8025a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025a7:	29 f8                	sub    %edi,%eax
  8025a9:	d3 e2                	shl    %cl,%edx
  8025ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025af:	89 c1                	mov    %eax,%ecx
  8025b1:	89 da                	mov    %ebx,%edx
  8025b3:	d3 ea                	shr    %cl,%edx
  8025b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025b9:	09 d1                	or     %edx,%ecx
  8025bb:	89 f2                	mov    %esi,%edx
  8025bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025c1:	89 f9                	mov    %edi,%ecx
  8025c3:	d3 e3                	shl    %cl,%ebx
  8025c5:	89 c1                	mov    %eax,%ecx
  8025c7:	d3 ea                	shr    %cl,%edx
  8025c9:	89 f9                	mov    %edi,%ecx
  8025cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025cf:	89 eb                	mov    %ebp,%ebx
  8025d1:	d3 e6                	shl    %cl,%esi
  8025d3:	89 c1                	mov    %eax,%ecx
  8025d5:	d3 eb                	shr    %cl,%ebx
  8025d7:	09 de                	or     %ebx,%esi
  8025d9:	89 f0                	mov    %esi,%eax
  8025db:	f7 74 24 08          	divl   0x8(%esp)
  8025df:	89 d6                	mov    %edx,%esi
  8025e1:	89 c3                	mov    %eax,%ebx
  8025e3:	f7 64 24 0c          	mull   0xc(%esp)
  8025e7:	39 d6                	cmp    %edx,%esi
  8025e9:	72 15                	jb     802600 <__udivdi3+0x100>
  8025eb:	89 f9                	mov    %edi,%ecx
  8025ed:	d3 e5                	shl    %cl,%ebp
  8025ef:	39 c5                	cmp    %eax,%ebp
  8025f1:	73 04                	jae    8025f7 <__udivdi3+0xf7>
  8025f3:	39 d6                	cmp    %edx,%esi
  8025f5:	74 09                	je     802600 <__udivdi3+0x100>
  8025f7:	89 d8                	mov    %ebx,%eax
  8025f9:	31 ff                	xor    %edi,%edi
  8025fb:	e9 2b ff ff ff       	jmp    80252b <__udivdi3+0x2b>
  802600:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802603:	31 ff                	xor    %edi,%edi
  802605:	e9 21 ff ff ff       	jmp    80252b <__udivdi3+0x2b>
  80260a:	66 90                	xchg   %ax,%ax
  80260c:	66 90                	xchg   %ax,%ax
  80260e:	66 90                	xchg   %ax,%ax

00802610 <__umoddi3>:
  802610:	f3 0f 1e fb          	endbr32 
  802614:	55                   	push   %ebp
  802615:	57                   	push   %edi
  802616:	56                   	push   %esi
  802617:	53                   	push   %ebx
  802618:	83 ec 1c             	sub    $0x1c,%esp
  80261b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80261f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802623:	8b 74 24 30          	mov    0x30(%esp),%esi
  802627:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80262b:	89 da                	mov    %ebx,%edx
  80262d:	85 c0                	test   %eax,%eax
  80262f:	75 3f                	jne    802670 <__umoddi3+0x60>
  802631:	39 df                	cmp    %ebx,%edi
  802633:	76 13                	jbe    802648 <__umoddi3+0x38>
  802635:	89 f0                	mov    %esi,%eax
  802637:	f7 f7                	div    %edi
  802639:	89 d0                	mov    %edx,%eax
  80263b:	31 d2                	xor    %edx,%edx
  80263d:	83 c4 1c             	add    $0x1c,%esp
  802640:	5b                   	pop    %ebx
  802641:	5e                   	pop    %esi
  802642:	5f                   	pop    %edi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    
  802645:	8d 76 00             	lea    0x0(%esi),%esi
  802648:	89 fd                	mov    %edi,%ebp
  80264a:	85 ff                	test   %edi,%edi
  80264c:	75 0b                	jne    802659 <__umoddi3+0x49>
  80264e:	b8 01 00 00 00       	mov    $0x1,%eax
  802653:	31 d2                	xor    %edx,%edx
  802655:	f7 f7                	div    %edi
  802657:	89 c5                	mov    %eax,%ebp
  802659:	89 d8                	mov    %ebx,%eax
  80265b:	31 d2                	xor    %edx,%edx
  80265d:	f7 f5                	div    %ebp
  80265f:	89 f0                	mov    %esi,%eax
  802661:	f7 f5                	div    %ebp
  802663:	89 d0                	mov    %edx,%eax
  802665:	eb d4                	jmp    80263b <__umoddi3+0x2b>
  802667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80266e:	66 90                	xchg   %ax,%ax
  802670:	89 f1                	mov    %esi,%ecx
  802672:	39 d8                	cmp    %ebx,%eax
  802674:	76 0a                	jbe    802680 <__umoddi3+0x70>
  802676:	89 f0                	mov    %esi,%eax
  802678:	83 c4 1c             	add    $0x1c,%esp
  80267b:	5b                   	pop    %ebx
  80267c:	5e                   	pop    %esi
  80267d:	5f                   	pop    %edi
  80267e:	5d                   	pop    %ebp
  80267f:	c3                   	ret    
  802680:	0f bd e8             	bsr    %eax,%ebp
  802683:	83 f5 1f             	xor    $0x1f,%ebp
  802686:	75 20                	jne    8026a8 <__umoddi3+0x98>
  802688:	39 d8                	cmp    %ebx,%eax
  80268a:	0f 82 b0 00 00 00    	jb     802740 <__umoddi3+0x130>
  802690:	39 f7                	cmp    %esi,%edi
  802692:	0f 86 a8 00 00 00    	jbe    802740 <__umoddi3+0x130>
  802698:	89 c8                	mov    %ecx,%eax
  80269a:	83 c4 1c             	add    $0x1c,%esp
  80269d:	5b                   	pop    %ebx
  80269e:	5e                   	pop    %esi
  80269f:	5f                   	pop    %edi
  8026a0:	5d                   	pop    %ebp
  8026a1:	c3                   	ret    
  8026a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026a8:	89 e9                	mov    %ebp,%ecx
  8026aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8026af:	29 ea                	sub    %ebp,%edx
  8026b1:	d3 e0                	shl    %cl,%eax
  8026b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026b7:	89 d1                	mov    %edx,%ecx
  8026b9:	89 f8                	mov    %edi,%eax
  8026bb:	d3 e8                	shr    %cl,%eax
  8026bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026c9:	09 c1                	or     %eax,%ecx
  8026cb:	89 d8                	mov    %ebx,%eax
  8026cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026d1:	89 e9                	mov    %ebp,%ecx
  8026d3:	d3 e7                	shl    %cl,%edi
  8026d5:	89 d1                	mov    %edx,%ecx
  8026d7:	d3 e8                	shr    %cl,%eax
  8026d9:	89 e9                	mov    %ebp,%ecx
  8026db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026df:	d3 e3                	shl    %cl,%ebx
  8026e1:	89 c7                	mov    %eax,%edi
  8026e3:	89 d1                	mov    %edx,%ecx
  8026e5:	89 f0                	mov    %esi,%eax
  8026e7:	d3 e8                	shr    %cl,%eax
  8026e9:	89 e9                	mov    %ebp,%ecx
  8026eb:	89 fa                	mov    %edi,%edx
  8026ed:	d3 e6                	shl    %cl,%esi
  8026ef:	09 d8                	or     %ebx,%eax
  8026f1:	f7 74 24 08          	divl   0x8(%esp)
  8026f5:	89 d1                	mov    %edx,%ecx
  8026f7:	89 f3                	mov    %esi,%ebx
  8026f9:	f7 64 24 0c          	mull   0xc(%esp)
  8026fd:	89 c6                	mov    %eax,%esi
  8026ff:	89 d7                	mov    %edx,%edi
  802701:	39 d1                	cmp    %edx,%ecx
  802703:	72 06                	jb     80270b <__umoddi3+0xfb>
  802705:	75 10                	jne    802717 <__umoddi3+0x107>
  802707:	39 c3                	cmp    %eax,%ebx
  802709:	73 0c                	jae    802717 <__umoddi3+0x107>
  80270b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80270f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802713:	89 d7                	mov    %edx,%edi
  802715:	89 c6                	mov    %eax,%esi
  802717:	89 ca                	mov    %ecx,%edx
  802719:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80271e:	29 f3                	sub    %esi,%ebx
  802720:	19 fa                	sbb    %edi,%edx
  802722:	89 d0                	mov    %edx,%eax
  802724:	d3 e0                	shl    %cl,%eax
  802726:	89 e9                	mov    %ebp,%ecx
  802728:	d3 eb                	shr    %cl,%ebx
  80272a:	d3 ea                	shr    %cl,%edx
  80272c:	09 d8                	or     %ebx,%eax
  80272e:	83 c4 1c             	add    $0x1c,%esp
  802731:	5b                   	pop    %ebx
  802732:	5e                   	pop    %esi
  802733:	5f                   	pop    %edi
  802734:	5d                   	pop    %ebp
  802735:	c3                   	ret    
  802736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80273d:	8d 76 00             	lea    0x0(%esi),%esi
  802740:	89 da                	mov    %ebx,%edx
  802742:	29 fe                	sub    %edi,%esi
  802744:	19 c2                	sbb    %eax,%edx
  802746:	89 f1                	mov    %esi,%ecx
  802748:	89 c8                	mov    %ecx,%eax
  80274a:	e9 4b ff ff ff       	jmp    80269a <__umoddi3+0x8a>
