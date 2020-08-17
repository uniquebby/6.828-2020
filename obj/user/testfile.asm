
obj/user/testfile.debug：     文件格式 elf32-i386


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
  80002c:	e8 54 06 00 00       	call   800685 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	50                   	push   %eax
  80003d:	68 00 60 80 00       	push   $0x806000
  800042:	e8 55 0d 00 00       	call   800d9c <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 24 14 00 00       	call   80147d <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 60 80 00       	push   $0x806000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 a9 13 00 00       	call   801411 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 25 13 00 00       	call   80139e <ipc_recv>
}
  800079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007c:	c9                   	leave  
  80007d:	c3                   	ret    

0080007e <umain>:

void
umain(int argc, char **argv)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	57                   	push   %edi
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80008a:	ba 00 00 00 00       	mov    $0x0,%edx
  80008f:	b8 c0 28 80 00       	mov    $0x8028c0,%eax
  800094:	e8 9a ff ff ff       	call   800033 <xopen>
  800099:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80009c:	74 08                	je     8000a6 <umain+0x28>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	0f 88 e9 03 00 00    	js     80048f <umain+0x411>
		panic("serve_open /not-found: %e", r);
	else if (r >= 0)
  8000a6:	85 c0                	test   %eax,%eax
  8000a8:	0f 89 f3 03 00 00    	jns    8004a1 <umain+0x423>
		panic("serve_open /not-found succeeded!");

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b3:	b8 f5 28 80 00       	mov    $0x8028f5,%eax
  8000b8:	e8 76 ff ff ff       	call   800033 <xopen>
  8000bd:	85 c0                	test   %eax,%eax
  8000bf:	0f 88 f0 03 00 00    	js     8004b5 <umain+0x437>
		panic("serve_open /newmotd: %e", r);
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8000c5:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  8000cc:	0f 85 f5 03 00 00    	jne    8004c7 <umain+0x449>
  8000d2:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  8000d9:	0f 85 e8 03 00 00    	jne    8004c7 <umain+0x449>
  8000df:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  8000e6:	0f 85 db 03 00 00    	jne    8004c7 <umain+0x449>
		panic("serve_open did not fill struct Fd correctly\n");
	cprintf("serve_open is good\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 16 29 80 00       	push   $0x802916
  8000f4:	e8 c7 06 00 00       	call   8007c0 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  8000f9:	83 c4 08             	add    $0x8,%esp
  8000fc:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800102:	50                   	push   %eax
  800103:	68 00 c0 cc cc       	push   $0xccccc000
  800108:	ff 15 1c 40 80 00    	call   *0x80401c
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	0f 88 c2 03 00 00    	js     8004db <umain+0x45d>
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 35 00 40 80 00    	pushl  0x804000
  800122:	e8 3c 0c 00 00       	call   800d63 <strlen>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80012d:	0f 85 ba 03 00 00    	jne    8004ed <umain+0x46f>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 38 29 80 00       	push   $0x802938
  80013b:	e8 80 06 00 00       	call   8007c0 <cprintf>

	memset(buf, 0, sizeof buf);
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	68 00 02 00 00       	push   $0x200
  800148:	6a 00                	push   $0x0
  80014a:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800150:	53                   	push   %ebx
  800151:	e8 8c 0d 00 00       	call   800ee2 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800156:	83 c4 0c             	add    $0xc,%esp
  800159:	68 00 02 00 00       	push   $0x200
  80015e:	53                   	push   %ebx
  80015f:	68 00 c0 cc cc       	push   $0xccccc000
  800164:	ff 15 10 40 80 00    	call   *0x804010
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	85 c0                	test   %eax,%eax
  80016f:	0f 88 9d 03 00 00    	js     800512 <umain+0x494>
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 35 00 40 80 00    	pushl  0x804000
  80017e:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	e8 bd 0c 00 00       	call   800e47 <strcmp>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	85 c0                	test   %eax,%eax
  80018f:	0f 85 8f 03 00 00    	jne    800524 <umain+0x4a6>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 77 29 80 00       	push   $0x802977
  80019d:	e8 1e 06 00 00       	call   8007c0 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a2:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001a9:	ff 15 18 40 80 00    	call   *0x804018
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	0f 88 7e 03 00 00    	js     800538 <umain+0x4ba>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 99 29 80 00       	push   $0x802999
  8001c2:	e8 f9 05 00 00       	call   8007c0 <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8001c7:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cf:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8001d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001d7:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8001dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001df:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8001e7:	83 c4 08             	add    $0x8,%esp
  8001ea:	68 00 c0 cc cc       	push   $0xccccc000
  8001ef:	6a 00                	push   $0x0
  8001f1:	e8 1d 10 00 00       	call   801213 <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	68 00 02 00 00       	push   $0x200
  8001fe:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800208:	50                   	push   %eax
  800209:	ff 15 10 40 80 00    	call   *0x804010
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800215:	0f 85 2f 03 00 00    	jne    80054a <umain+0x4cc>
		panic("serve_read does not handle stale fileids correctly: %e", r);
	cprintf("stale fileid is good\n");
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	68 ad 29 80 00       	push   $0x8029ad
  800223:	e8 98 05 00 00       	call   8007c0 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800228:	ba 02 01 00 00       	mov    $0x102,%edx
  80022d:	b8 c3 29 80 00       	mov    $0x8029c3,%eax
  800232:	e8 fc fd ff ff       	call   800033 <xopen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	85 c0                	test   %eax,%eax
  80023c:	0f 88 1a 03 00 00    	js     80055c <umain+0x4de>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800242:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 35 00 40 80 00    	pushl  0x804000
  800251:	e8 0d 0b 00 00       	call   800d63 <strlen>
  800256:	83 c4 0c             	add    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	ff 35 00 40 80 00    	pushl  0x804000
  800260:	68 00 c0 cc cc       	push   $0xccccc000
  800265:	ff d3                	call   *%ebx
  800267:	89 c3                	mov    %eax,%ebx
  800269:	83 c4 04             	add    $0x4,%esp
  80026c:	ff 35 00 40 80 00    	pushl  0x804000
  800272:	e8 ec 0a 00 00       	call   800d63 <strlen>
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	39 d8                	cmp    %ebx,%eax
  80027c:	0f 85 ec 02 00 00    	jne    80056e <umain+0x4f0>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	68 f5 29 80 00       	push   $0x8029f5
  80028a:	e8 31 05 00 00       	call   8007c0 <cprintf>

	FVA->fd_offset = 0;
  80028f:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800296:	00 00 00 
	memset(buf, 0, sizeof buf);
  800299:	83 c4 0c             	add    $0xc,%esp
  80029c:	68 00 02 00 00       	push   $0x200
  8002a1:	6a 00                	push   $0x0
  8002a3:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002a9:	53                   	push   %ebx
  8002aa:	e8 33 0c 00 00       	call   800ee2 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8002af:	83 c4 0c             	add    $0xc,%esp
  8002b2:	68 00 02 00 00       	push   $0x200
  8002b7:	53                   	push   %ebx
  8002b8:	68 00 c0 cc cc       	push   $0xccccc000
  8002bd:	ff 15 10 40 80 00    	call   *0x804010
  8002c3:	89 c3                	mov    %eax,%ebx
  8002c5:	83 c4 10             	add    $0x10,%esp
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	0f 88 b0 02 00 00    	js     800580 <umain+0x502>
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 35 00 40 80 00    	pushl  0x804000
  8002d9:	e8 85 0a 00 00       	call   800d63 <strlen>
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	39 d8                	cmp    %ebx,%eax
  8002e3:	0f 85 a9 02 00 00    	jne    800592 <umain+0x514>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	ff 35 00 40 80 00    	pushl  0x804000
  8002f2:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8002f8:	50                   	push   %eax
  8002f9:	e8 49 0b 00 00       	call   800e47 <strcmp>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	85 c0                	test   %eax,%eax
  800303:	0f 85 9b 02 00 00    	jne    8005a4 <umain+0x526>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	68 bc 2b 80 00       	push   $0x802bbc
  800311:	e8 aa 04 00 00       	call   8007c0 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800316:	83 c4 08             	add    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 c0 28 80 00       	push   $0x8028c0
  800320:	e8 25 19 00 00       	call   801c4a <open>
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80032b:	74 08                	je     800335 <umain+0x2b7>
  80032d:	85 c0                	test   %eax,%eax
  80032f:	0f 88 83 02 00 00    	js     8005b8 <umain+0x53a>
		panic("open /not-found: %e", r);
	else if (r >= 0)
  800335:	85 c0                	test   %eax,%eax
  800337:	0f 89 8d 02 00 00    	jns    8005ca <umain+0x54c>
		panic("open /not-found succeeded!");

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	6a 00                	push   $0x0
  800342:	68 f5 28 80 00       	push   $0x8028f5
  800347:	e8 fe 18 00 00       	call   801c4a <open>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	85 c0                	test   %eax,%eax
  800351:	0f 88 87 02 00 00    	js     8005de <umain+0x560>
		panic("open /newmotd: %e", r);
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800357:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80035a:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800361:	0f 85 89 02 00 00    	jne    8005f0 <umain+0x572>
  800367:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  80036e:	0f 85 7c 02 00 00    	jne    8005f0 <umain+0x572>
  800374:	8b 98 08 00 00 d0    	mov    -0x2ffffff8(%eax),%ebx
  80037a:	85 db                	test   %ebx,%ebx
  80037c:	0f 85 6e 02 00 00    	jne    8005f0 <umain+0x572>
		panic("open did not fill struct Fd correctly\n");
	cprintf("open is good\n");
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 1c 29 80 00       	push   $0x80291c
  80038a:	e8 31 04 00 00       	call   8007c0 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	68 01 01 00 00       	push   $0x101
  800397:	68 24 2a 80 00       	push   $0x802a24
  80039c:	e8 a9 18 00 00       	call   801c4a <open>
  8003a1:	89 c7                	mov    %eax,%edi
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	85 c0                	test   %eax,%eax
  8003a8:	0f 88 56 02 00 00    	js     800604 <umain+0x586>
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
  8003ae:	83 ec 04             	sub    $0x4,%esp
  8003b1:	68 00 02 00 00       	push   $0x200
  8003b6:	6a 00                	push   $0x0
  8003b8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003be:	50                   	push   %eax
  8003bf:	e8 1e 0b 00 00       	call   800ee2 <memset>
  8003c4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003c7:	89 de                	mov    %ebx,%esi
		*(int*)buf = i;
  8003c9:	89 b5 4c fd ff ff    	mov    %esi,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 00 02 00 00       	push   $0x200
  8003d7:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003dd:	50                   	push   %eax
  8003de:	57                   	push   %edi
  8003df:	e8 87 14 00 00       	call   80186b <write>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	0f 88 27 02 00 00    	js     800616 <umain+0x598>
  8003ef:	81 c6 00 02 00 00    	add    $0x200,%esi
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003f5:	81 fe 00 e0 01 00    	cmp    $0x1e000,%esi
  8003fb:	75 cc                	jne    8003c9 <umain+0x34b>
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	57                   	push   %edi
  800401:	e8 5b 12 00 00       	call   801661 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  800406:	83 c4 08             	add    $0x8,%esp
  800409:	6a 00                	push   $0x0
  80040b:	68 24 2a 80 00       	push   $0x802a24
  800410:	e8 35 18 00 00       	call   801c4a <open>
  800415:	89 c6                	mov    %eax,%esi
  800417:	83 c4 10             	add    $0x10,%esp
  80041a:	85 c0                	test   %eax,%eax
  80041c:	0f 88 0a 02 00 00    	js     80062c <umain+0x5ae>
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800422:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
		*(int*)buf = i;
  800428:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	68 00 02 00 00       	push   $0x200
  800436:	57                   	push   %edi
  800437:	56                   	push   %esi
  800438:	e8 e9 13 00 00       	call   801826 <readn>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	85 c0                	test   %eax,%eax
  800442:	0f 88 f6 01 00 00    	js     80063e <umain+0x5c0>
			panic("read /big@%d: %e", i, r);
		if (r != sizeof(buf))
  800448:	3d 00 02 00 00       	cmp    $0x200,%eax
  80044d:	0f 85 01 02 00 00    	jne    800654 <umain+0x5d6>
			panic("read /big from %d returned %d < %d bytes",
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800453:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  800459:	39 d8                	cmp    %ebx,%eax
  80045b:	0f 85 0e 02 00 00    	jne    80066f <umain+0x5f1>
  800461:	81 c3 00 02 00 00    	add    $0x200,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800467:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
  80046d:	75 b9                	jne    800428 <umain+0x3aa>
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	56                   	push   %esi
  800473:	e8 e9 11 00 00       	call   801661 <close>
	cprintf("large file is good\n");
  800478:	c7 04 24 69 2a 80 00 	movl   $0x802a69,(%esp)
  80047f:	e8 3c 03 00 00       	call   8007c0 <cprintf>
}
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5e                   	pop    %esi
  80048c:	5f                   	pop    %edi
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    
		panic("serve_open /not-found: %e", r);
  80048f:	50                   	push   %eax
  800490:	68 cb 28 80 00       	push   $0x8028cb
  800495:	6a 20                	push   $0x20
  800497:	68 e5 28 80 00       	push   $0x8028e5
  80049c:	e8 44 02 00 00       	call   8006e5 <_panic>
		panic("serve_open /not-found succeeded!");
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	68 80 2a 80 00       	push   $0x802a80
  8004a9:	6a 22                	push   $0x22
  8004ab:	68 e5 28 80 00       	push   $0x8028e5
  8004b0:	e8 30 02 00 00       	call   8006e5 <_panic>
		panic("serve_open /newmotd: %e", r);
  8004b5:	50                   	push   %eax
  8004b6:	68 fe 28 80 00       	push   $0x8028fe
  8004bb:	6a 25                	push   $0x25
  8004bd:	68 e5 28 80 00       	push   $0x8028e5
  8004c2:	e8 1e 02 00 00       	call   8006e5 <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004c7:	83 ec 04             	sub    $0x4,%esp
  8004ca:	68 a4 2a 80 00       	push   $0x802aa4
  8004cf:	6a 27                	push   $0x27
  8004d1:	68 e5 28 80 00       	push   $0x8028e5
  8004d6:	e8 0a 02 00 00       	call   8006e5 <_panic>
		panic("file_stat: %e", r);
  8004db:	50                   	push   %eax
  8004dc:	68 2a 29 80 00       	push   $0x80292a
  8004e1:	6a 2b                	push   $0x2b
  8004e3:	68 e5 28 80 00       	push   $0x8028e5
  8004e8:	e8 f8 01 00 00       	call   8006e5 <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8004ed:	83 ec 0c             	sub    $0xc,%esp
  8004f0:	ff 35 00 40 80 00    	pushl  0x804000
  8004f6:	e8 68 08 00 00       	call   800d63 <strlen>
  8004fb:	89 04 24             	mov    %eax,(%esp)
  8004fe:	ff 75 cc             	pushl  -0x34(%ebp)
  800501:	68 d4 2a 80 00       	push   $0x802ad4
  800506:	6a 2d                	push   $0x2d
  800508:	68 e5 28 80 00       	push   $0x8028e5
  80050d:	e8 d3 01 00 00       	call   8006e5 <_panic>
		panic("file_read: %e", r);
  800512:	50                   	push   %eax
  800513:	68 4b 29 80 00       	push   $0x80294b
  800518:	6a 32                	push   $0x32
  80051a:	68 e5 28 80 00       	push   $0x8028e5
  80051f:	e8 c1 01 00 00       	call   8006e5 <_panic>
		panic("file_read returned wrong data");
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	68 59 29 80 00       	push   $0x802959
  80052c:	6a 34                	push   $0x34
  80052e:	68 e5 28 80 00       	push   $0x8028e5
  800533:	e8 ad 01 00 00       	call   8006e5 <_panic>
		panic("file_close: %e", r);
  800538:	50                   	push   %eax
  800539:	68 8a 29 80 00       	push   $0x80298a
  80053e:	6a 38                	push   $0x38
  800540:	68 e5 28 80 00       	push   $0x8028e5
  800545:	e8 9b 01 00 00       	call   8006e5 <_panic>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  80054a:	50                   	push   %eax
  80054b:	68 fc 2a 80 00       	push   $0x802afc
  800550:	6a 43                	push   $0x43
  800552:	68 e5 28 80 00       	push   $0x8028e5
  800557:	e8 89 01 00 00       	call   8006e5 <_panic>
		panic("serve_open /new-file: %e", r);
  80055c:	50                   	push   %eax
  80055d:	68 cd 29 80 00       	push   $0x8029cd
  800562:	6a 48                	push   $0x48
  800564:	68 e5 28 80 00       	push   $0x8028e5
  800569:	e8 77 01 00 00       	call   8006e5 <_panic>
		panic("file_write: %e", r);
  80056e:	53                   	push   %ebx
  80056f:	68 e6 29 80 00       	push   $0x8029e6
  800574:	6a 4b                	push   $0x4b
  800576:	68 e5 28 80 00       	push   $0x8028e5
  80057b:	e8 65 01 00 00       	call   8006e5 <_panic>
		panic("file_read after file_write: %e", r);
  800580:	50                   	push   %eax
  800581:	68 34 2b 80 00       	push   $0x802b34
  800586:	6a 51                	push   $0x51
  800588:	68 e5 28 80 00       	push   $0x8028e5
  80058d:	e8 53 01 00 00       	call   8006e5 <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  800592:	53                   	push   %ebx
  800593:	68 54 2b 80 00       	push   $0x802b54
  800598:	6a 53                	push   $0x53
  80059a:	68 e5 28 80 00       	push   $0x8028e5
  80059f:	e8 41 01 00 00       	call   8006e5 <_panic>
		panic("file_read after file_write returned wrong data");
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	68 8c 2b 80 00       	push   $0x802b8c
  8005ac:	6a 55                	push   $0x55
  8005ae:	68 e5 28 80 00       	push   $0x8028e5
  8005b3:	e8 2d 01 00 00       	call   8006e5 <_panic>
		panic("open /not-found: %e", r);
  8005b8:	50                   	push   %eax
  8005b9:	68 d1 28 80 00       	push   $0x8028d1
  8005be:	6a 5a                	push   $0x5a
  8005c0:	68 e5 28 80 00       	push   $0x8028e5
  8005c5:	e8 1b 01 00 00       	call   8006e5 <_panic>
		panic("open /not-found succeeded!");
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	68 09 2a 80 00       	push   $0x802a09
  8005d2:	6a 5c                	push   $0x5c
  8005d4:	68 e5 28 80 00       	push   $0x8028e5
  8005d9:	e8 07 01 00 00       	call   8006e5 <_panic>
		panic("open /newmotd: %e", r);
  8005de:	50                   	push   %eax
  8005df:	68 04 29 80 00       	push   $0x802904
  8005e4:	6a 5f                	push   $0x5f
  8005e6:	68 e5 28 80 00       	push   $0x8028e5
  8005eb:	e8 f5 00 00 00       	call   8006e5 <_panic>
		panic("open did not fill struct Fd correctly\n");
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	68 e0 2b 80 00       	push   $0x802be0
  8005f8:	6a 62                	push   $0x62
  8005fa:	68 e5 28 80 00       	push   $0x8028e5
  8005ff:	e8 e1 00 00 00       	call   8006e5 <_panic>
		panic("creat /big: %e", f);
  800604:	50                   	push   %eax
  800605:	68 29 2a 80 00       	push   $0x802a29
  80060a:	6a 67                	push   $0x67
  80060c:	68 e5 28 80 00       	push   $0x8028e5
  800611:	e8 cf 00 00 00       	call   8006e5 <_panic>
			panic("write /big@%d: %e", i, r);
  800616:	83 ec 0c             	sub    $0xc,%esp
  800619:	50                   	push   %eax
  80061a:	56                   	push   %esi
  80061b:	68 38 2a 80 00       	push   $0x802a38
  800620:	6a 6c                	push   $0x6c
  800622:	68 e5 28 80 00       	push   $0x8028e5
  800627:	e8 b9 00 00 00       	call   8006e5 <_panic>
		panic("open /big: %e", f);
  80062c:	50                   	push   %eax
  80062d:	68 4a 2a 80 00       	push   $0x802a4a
  800632:	6a 71                	push   $0x71
  800634:	68 e5 28 80 00       	push   $0x8028e5
  800639:	e8 a7 00 00 00       	call   8006e5 <_panic>
			panic("read /big@%d: %e", i, r);
  80063e:	83 ec 0c             	sub    $0xc,%esp
  800641:	50                   	push   %eax
  800642:	53                   	push   %ebx
  800643:	68 58 2a 80 00       	push   $0x802a58
  800648:	6a 75                	push   $0x75
  80064a:	68 e5 28 80 00       	push   $0x8028e5
  80064f:	e8 91 00 00 00       	call   8006e5 <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	68 00 02 00 00       	push   $0x200
  80065c:	50                   	push   %eax
  80065d:	53                   	push   %ebx
  80065e:	68 08 2c 80 00       	push   $0x802c08
  800663:	6a 78                	push   $0x78
  800665:	68 e5 28 80 00       	push   $0x8028e5
  80066a:	e8 76 00 00 00       	call   8006e5 <_panic>
			panic("read /big from %d returned bad data %d",
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	50                   	push   %eax
  800673:	53                   	push   %ebx
  800674:	68 34 2c 80 00       	push   $0x802c34
  800679:	6a 7b                	push   $0x7b
  80067b:	68 e5 28 80 00       	push   $0x8028e5
  800680:	e8 60 00 00 00       	call   8006e5 <_panic>

00800685 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	56                   	push   %esi
  800689:	53                   	push   %ebx
  80068a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80068d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800690:	e8 bb 0a 00 00       	call   801150 <sys_getenvid>
  800695:	25 ff 03 00 00       	and    $0x3ff,%eax
  80069a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80069d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a2:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a7:	85 db                	test   %ebx,%ebx
  8006a9:	7e 07                	jle    8006b2 <libmain+0x2d>
		binaryname = argv[0];
  8006ab:	8b 06                	mov    (%esi),%eax
  8006ad:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	56                   	push   %esi
  8006b6:	53                   	push   %ebx
  8006b7:	e8 c2 f9 ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  8006bc:	e8 0a 00 00 00       	call   8006cb <exit>
}
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006c7:	5b                   	pop    %ebx
  8006c8:	5e                   	pop    %esi
  8006c9:	5d                   	pop    %ebp
  8006ca:	c3                   	ret    

008006cb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8006d1:	e8 b8 0f 00 00       	call   80168e <close_all>
	sys_env_destroy(0);
  8006d6:	83 ec 0c             	sub    $0xc,%esp
  8006d9:	6a 00                	push   $0x0
  8006db:	e8 2f 0a 00 00       	call   80110f <sys_env_destroy>
}
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	56                   	push   %esi
  8006e9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8006ea:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006ed:	8b 35 04 40 80 00    	mov    0x804004,%esi
  8006f3:	e8 58 0a 00 00       	call   801150 <sys_getenvid>
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	ff 75 0c             	pushl  0xc(%ebp)
  8006fe:	ff 75 08             	pushl  0x8(%ebp)
  800701:	56                   	push   %esi
  800702:	50                   	push   %eax
  800703:	68 8c 2c 80 00       	push   $0x802c8c
  800708:	e8 b3 00 00 00       	call   8007c0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80070d:	83 c4 18             	add    $0x18,%esp
  800710:	53                   	push   %ebx
  800711:	ff 75 10             	pushl  0x10(%ebp)
  800714:	e8 56 00 00 00       	call   80076f <vcprintf>
	cprintf("\n");
  800719:	c7 04 24 13 31 80 00 	movl   $0x803113,(%esp)
  800720:	e8 9b 00 00 00       	call   8007c0 <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800728:	cc                   	int3   
  800729:	eb fd                	jmp    800728 <_panic+0x43>

0080072b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	53                   	push   %ebx
  80072f:	83 ec 04             	sub    $0x4,%esp
  800732:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800735:	8b 13                	mov    (%ebx),%edx
  800737:	8d 42 01             	lea    0x1(%edx),%eax
  80073a:	89 03                	mov    %eax,(%ebx)
  80073c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80073f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800743:	3d ff 00 00 00       	cmp    $0xff,%eax
  800748:	74 09                	je     800753 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80074a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80074e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800751:	c9                   	leave  
  800752:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	68 ff 00 00 00       	push   $0xff
  80075b:	8d 43 08             	lea    0x8(%ebx),%eax
  80075e:	50                   	push   %eax
  80075f:	e8 6e 09 00 00       	call   8010d2 <sys_cputs>
		b->idx = 0;
  800764:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80076a:	83 c4 10             	add    $0x10,%esp
  80076d:	eb db                	jmp    80074a <putch+0x1f>

0080076f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
  800772:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800778:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80077f:	00 00 00 
	b.cnt = 0;
  800782:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800789:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800798:	50                   	push   %eax
  800799:	68 2b 07 80 00       	push   $0x80072b
  80079e:	e8 19 01 00 00       	call   8008bc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8007a3:	83 c4 08             	add    $0x8,%esp
  8007a6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8007ac:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8007b2:	50                   	push   %eax
  8007b3:	e8 1a 09 00 00       	call   8010d2 <sys_cputs>

	return b.cnt;
}
  8007b8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007c9:	50                   	push   %eax
  8007ca:	ff 75 08             	pushl  0x8(%ebp)
  8007cd:	e8 9d ff ff ff       	call   80076f <vcprintf>
	va_end(ap);

	return cnt;
}
  8007d2:	c9                   	leave  
  8007d3:	c3                   	ret    

008007d4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	57                   	push   %edi
  8007d8:	56                   	push   %esi
  8007d9:	53                   	push   %ebx
  8007da:	83 ec 1c             	sub    $0x1c,%esp
  8007dd:	89 c7                	mov    %eax,%edi
  8007df:	89 d6                	mov    %edx,%esi
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007f5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007f8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8007fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8007fe:	89 d0                	mov    %edx,%eax
  800800:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800803:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800806:	73 15                	jae    80081d <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800808:	83 eb 01             	sub    $0x1,%ebx
  80080b:	85 db                	test   %ebx,%ebx
  80080d:	7e 43                	jle    800852 <printnum+0x7e>
			putch(padc, putdat);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	56                   	push   %esi
  800813:	ff 75 18             	pushl  0x18(%ebp)
  800816:	ff d7                	call   *%edi
  800818:	83 c4 10             	add    $0x10,%esp
  80081b:	eb eb                	jmp    800808 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80081d:	83 ec 0c             	sub    $0xc,%esp
  800820:	ff 75 18             	pushl  0x18(%ebp)
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800829:	53                   	push   %ebx
  80082a:	ff 75 10             	pushl  0x10(%ebp)
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 e4             	pushl  -0x1c(%ebp)
  800833:	ff 75 e0             	pushl  -0x20(%ebp)
  800836:	ff 75 dc             	pushl  -0x24(%ebp)
  800839:	ff 75 d8             	pushl  -0x28(%ebp)
  80083c:	e8 1f 1e 00 00       	call   802660 <__udivdi3>
  800841:	83 c4 18             	add    $0x18,%esp
  800844:	52                   	push   %edx
  800845:	50                   	push   %eax
  800846:	89 f2                	mov    %esi,%edx
  800848:	89 f8                	mov    %edi,%eax
  80084a:	e8 85 ff ff ff       	call   8007d4 <printnum>
  80084f:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	56                   	push   %esi
  800856:	83 ec 04             	sub    $0x4,%esp
  800859:	ff 75 e4             	pushl  -0x1c(%ebp)
  80085c:	ff 75 e0             	pushl  -0x20(%ebp)
  80085f:	ff 75 dc             	pushl  -0x24(%ebp)
  800862:	ff 75 d8             	pushl  -0x28(%ebp)
  800865:	e8 06 1f 00 00       	call   802770 <__umoddi3>
  80086a:	83 c4 14             	add    $0x14,%esp
  80086d:	0f be 80 af 2c 80 00 	movsbl 0x802caf(%eax),%eax
  800874:	50                   	push   %eax
  800875:	ff d7                	call   *%edi
}
  800877:	83 c4 10             	add    $0x10,%esp
  80087a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80087d:	5b                   	pop    %ebx
  80087e:	5e                   	pop    %esi
  80087f:	5f                   	pop    %edi
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800888:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80088c:	8b 10                	mov    (%eax),%edx
  80088e:	3b 50 04             	cmp    0x4(%eax),%edx
  800891:	73 0a                	jae    80089d <sprintputch+0x1b>
		*b->buf++ = ch;
  800893:	8d 4a 01             	lea    0x1(%edx),%ecx
  800896:	89 08                	mov    %ecx,(%eax)
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	88 02                	mov    %al,(%edx)
}
  80089d:	5d                   	pop    %ebp
  80089e:	c3                   	ret    

0080089f <printfmt>:
{
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8008a5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008a8:	50                   	push   %eax
  8008a9:	ff 75 10             	pushl  0x10(%ebp)
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	ff 75 08             	pushl  0x8(%ebp)
  8008b2:	e8 05 00 00 00       	call   8008bc <vprintfmt>
}
  8008b7:	83 c4 10             	add    $0x10,%esp
  8008ba:	c9                   	leave  
  8008bb:	c3                   	ret    

008008bc <vprintfmt>:
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	57                   	push   %edi
  8008c0:	56                   	push   %esi
  8008c1:	53                   	push   %ebx
  8008c2:	83 ec 3c             	sub    $0x3c,%esp
  8008c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008cb:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008ce:	eb 0a                	jmp    8008da <vprintfmt+0x1e>
			putch(ch, putdat);
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	53                   	push   %ebx
  8008d4:	50                   	push   %eax
  8008d5:	ff d6                	call   *%esi
  8008d7:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008da:	83 c7 01             	add    $0x1,%edi
  8008dd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008e1:	83 f8 25             	cmp    $0x25,%eax
  8008e4:	74 0c                	je     8008f2 <vprintfmt+0x36>
			if (ch == '\0')
  8008e6:	85 c0                	test   %eax,%eax
  8008e8:	75 e6                	jne    8008d0 <vprintfmt+0x14>
}
  8008ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ed:	5b                   	pop    %ebx
  8008ee:	5e                   	pop    %esi
  8008ef:	5f                   	pop    %edi
  8008f0:	5d                   	pop    %ebp
  8008f1:	c3                   	ret    
		padc = ' ';
  8008f2:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8008f6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8008fd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800904:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80090b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800910:	8d 47 01             	lea    0x1(%edi),%eax
  800913:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800916:	0f b6 17             	movzbl (%edi),%edx
  800919:	8d 42 dd             	lea    -0x23(%edx),%eax
  80091c:	3c 55                	cmp    $0x55,%al
  80091e:	0f 87 ba 03 00 00    	ja     800cde <vprintfmt+0x422>
  800924:	0f b6 c0             	movzbl %al,%eax
  800927:	ff 24 85 00 2e 80 00 	jmp    *0x802e00(,%eax,4)
  80092e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800931:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800935:	eb d9                	jmp    800910 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800937:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80093a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80093e:	eb d0                	jmp    800910 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800940:	0f b6 d2             	movzbl %dl,%edx
  800943:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800946:	b8 00 00 00 00       	mov    $0x0,%eax
  80094b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80094e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800951:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800955:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800958:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80095b:	83 f9 09             	cmp    $0x9,%ecx
  80095e:	77 55                	ja     8009b5 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800960:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800963:	eb e9                	jmp    80094e <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	8b 00                	mov    (%eax),%eax
  80096a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	8d 40 04             	lea    0x4(%eax),%eax
  800973:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800976:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800979:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097d:	79 91                	jns    800910 <vprintfmt+0x54>
				width = precision, precision = -1;
  80097f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800982:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800985:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80098c:	eb 82                	jmp    800910 <vprintfmt+0x54>
  80098e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800991:	85 c0                	test   %eax,%eax
  800993:	ba 00 00 00 00       	mov    $0x0,%edx
  800998:	0f 49 d0             	cmovns %eax,%edx
  80099b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80099e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8009a1:	e9 6a ff ff ff       	jmp    800910 <vprintfmt+0x54>
  8009a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8009a9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8009b0:	e9 5b ff ff ff       	jmp    800910 <vprintfmt+0x54>
  8009b5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8009b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009bb:	eb bc                	jmp    800979 <vprintfmt+0xbd>
			lflag++;
  8009bd:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8009c3:	e9 48 ff ff ff       	jmp    800910 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	8d 78 04             	lea    0x4(%eax),%edi
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	53                   	push   %ebx
  8009d2:	ff 30                	pushl  (%eax)
  8009d4:	ff d6                	call   *%esi
			break;
  8009d6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8009d9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8009dc:	e9 9c 02 00 00       	jmp    800c7d <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8009e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e4:	8d 78 04             	lea    0x4(%eax),%edi
  8009e7:	8b 00                	mov    (%eax),%eax
  8009e9:	99                   	cltd   
  8009ea:	31 d0                	xor    %edx,%eax
  8009ec:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009ee:	83 f8 0f             	cmp    $0xf,%eax
  8009f1:	7f 23                	jg     800a16 <vprintfmt+0x15a>
  8009f3:	8b 14 85 60 2f 80 00 	mov    0x802f60(,%eax,4),%edx
  8009fa:	85 d2                	test   %edx,%edx
  8009fc:	74 18                	je     800a16 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8009fe:	52                   	push   %edx
  8009ff:	68 da 30 80 00       	push   $0x8030da
  800a04:	53                   	push   %ebx
  800a05:	56                   	push   %esi
  800a06:	e8 94 fe ff ff       	call   80089f <printfmt>
  800a0b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a0e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a11:	e9 67 02 00 00       	jmp    800c7d <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800a16:	50                   	push   %eax
  800a17:	68 c7 2c 80 00       	push   $0x802cc7
  800a1c:	53                   	push   %ebx
  800a1d:	56                   	push   %esi
  800a1e:	e8 7c fe ff ff       	call   80089f <printfmt>
  800a23:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a26:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a29:	e9 4f 02 00 00       	jmp    800c7d <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 c0 04             	add    $0x4,%eax
  800a34:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800a3c:	85 d2                	test   %edx,%edx
  800a3e:	b8 c0 2c 80 00       	mov    $0x802cc0,%eax
  800a43:	0f 45 c2             	cmovne %edx,%eax
  800a46:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800a49:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a4d:	7e 06                	jle    800a55 <vprintfmt+0x199>
  800a4f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800a53:	75 0d                	jne    800a62 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a55:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a58:	89 c7                	mov    %eax,%edi
  800a5a:	03 45 e0             	add    -0x20(%ebp),%eax
  800a5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a60:	eb 3f                	jmp    800aa1 <vprintfmt+0x1e5>
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 d8             	pushl  -0x28(%ebp)
  800a68:	50                   	push   %eax
  800a69:	e8 0d 03 00 00       	call   800d7b <strnlen>
  800a6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a71:	29 c2                	sub    %eax,%edx
  800a73:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800a76:	83 c4 10             	add    $0x10,%esp
  800a79:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800a7b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800a7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800a82:	85 ff                	test   %edi,%edi
  800a84:	7e 58                	jle    800ade <vprintfmt+0x222>
					putch(padc, putdat);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	53                   	push   %ebx
  800a8a:	ff 75 e0             	pushl  -0x20(%ebp)
  800a8d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a8f:	83 ef 01             	sub    $0x1,%edi
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	eb eb                	jmp    800a82 <vprintfmt+0x1c6>
					putch(ch, putdat);
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	53                   	push   %ebx
  800a9b:	52                   	push   %edx
  800a9c:	ff d6                	call   *%esi
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800aa4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa6:	83 c7 01             	add    $0x1,%edi
  800aa9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800aad:	0f be d0             	movsbl %al,%edx
  800ab0:	85 d2                	test   %edx,%edx
  800ab2:	74 45                	je     800af9 <vprintfmt+0x23d>
  800ab4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800ab8:	78 06                	js     800ac0 <vprintfmt+0x204>
  800aba:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800abe:	78 35                	js     800af5 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800ac0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800ac4:	74 d1                	je     800a97 <vprintfmt+0x1db>
  800ac6:	0f be c0             	movsbl %al,%eax
  800ac9:	83 e8 20             	sub    $0x20,%eax
  800acc:	83 f8 5e             	cmp    $0x5e,%eax
  800acf:	76 c6                	jbe    800a97 <vprintfmt+0x1db>
					putch('?', putdat);
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	53                   	push   %ebx
  800ad5:	6a 3f                	push   $0x3f
  800ad7:	ff d6                	call   *%esi
  800ad9:	83 c4 10             	add    $0x10,%esp
  800adc:	eb c3                	jmp    800aa1 <vprintfmt+0x1e5>
  800ade:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800ae1:	85 d2                	test   %edx,%edx
  800ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae8:	0f 49 c2             	cmovns %edx,%eax
  800aeb:	29 c2                	sub    %eax,%edx
  800aed:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800af0:	e9 60 ff ff ff       	jmp    800a55 <vprintfmt+0x199>
  800af5:	89 cf                	mov    %ecx,%edi
  800af7:	eb 02                	jmp    800afb <vprintfmt+0x23f>
  800af9:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800afb:	85 ff                	test   %edi,%edi
  800afd:	7e 10                	jle    800b0f <vprintfmt+0x253>
				putch(' ', putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	53                   	push   %ebx
  800b03:	6a 20                	push   $0x20
  800b05:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800b07:	83 ef 01             	sub    $0x1,%edi
  800b0a:	83 c4 10             	add    $0x10,%esp
  800b0d:	eb ec                	jmp    800afb <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800b0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	e9 63 01 00 00       	jmp    800c7d <vprintfmt+0x3c1>
	if (lflag >= 2)
  800b1a:	83 f9 01             	cmp    $0x1,%ecx
  800b1d:	7f 1b                	jg     800b3a <vprintfmt+0x27e>
	else if (lflag)
  800b1f:	85 c9                	test   %ecx,%ecx
  800b21:	74 63                	je     800b86 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800b23:	8b 45 14             	mov    0x14(%ebp),%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b2b:	99                   	cltd   
  800b2c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	8d 40 04             	lea    0x4(%eax),%eax
  800b35:	89 45 14             	mov    %eax,0x14(%ebp)
  800b38:	eb 17                	jmp    800b51 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800b3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3d:	8b 50 04             	mov    0x4(%eax),%edx
  800b40:	8b 00                	mov    (%eax),%eax
  800b42:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b45:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b48:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4b:	8d 40 08             	lea    0x8(%eax),%eax
  800b4e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800b51:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b54:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800b57:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800b5c:	85 c9                	test   %ecx,%ecx
  800b5e:	0f 89 ff 00 00 00    	jns    800c63 <vprintfmt+0x3a7>
				putch('-', putdat);
  800b64:	83 ec 08             	sub    $0x8,%esp
  800b67:	53                   	push   %ebx
  800b68:	6a 2d                	push   $0x2d
  800b6a:	ff d6                	call   *%esi
				num = -(long long) num;
  800b6c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b6f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b72:	f7 da                	neg    %edx
  800b74:	83 d1 00             	adc    $0x0,%ecx
  800b77:	f7 d9                	neg    %ecx
  800b79:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b7c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b81:	e9 dd 00 00 00       	jmp    800c63 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800b86:	8b 45 14             	mov    0x14(%ebp),%eax
  800b89:	8b 00                	mov    (%eax),%eax
  800b8b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b8e:	99                   	cltd   
  800b8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b92:	8b 45 14             	mov    0x14(%ebp),%eax
  800b95:	8d 40 04             	lea    0x4(%eax),%eax
  800b98:	89 45 14             	mov    %eax,0x14(%ebp)
  800b9b:	eb b4                	jmp    800b51 <vprintfmt+0x295>
	if (lflag >= 2)
  800b9d:	83 f9 01             	cmp    $0x1,%ecx
  800ba0:	7f 1e                	jg     800bc0 <vprintfmt+0x304>
	else if (lflag)
  800ba2:	85 c9                	test   %ecx,%ecx
  800ba4:	74 32                	je     800bd8 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800ba6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba9:	8b 10                	mov    (%eax),%edx
  800bab:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bb0:	8d 40 04             	lea    0x4(%eax),%eax
  800bb3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bb6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bbb:	e9 a3 00 00 00       	jmp    800c63 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800bc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc3:	8b 10                	mov    (%eax),%edx
  800bc5:	8b 48 04             	mov    0x4(%eax),%ecx
  800bc8:	8d 40 08             	lea    0x8(%eax),%eax
  800bcb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bce:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd3:	e9 8b 00 00 00       	jmp    800c63 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800bd8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bdb:	8b 10                	mov    (%eax),%edx
  800bdd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800be2:	8d 40 04             	lea    0x4(%eax),%eax
  800be5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800be8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bed:	eb 74                	jmp    800c63 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800bef:	83 f9 01             	cmp    $0x1,%ecx
  800bf2:	7f 1b                	jg     800c0f <vprintfmt+0x353>
	else if (lflag)
  800bf4:	85 c9                	test   %ecx,%ecx
  800bf6:	74 2c                	je     800c24 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800bf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfb:	8b 10                	mov    (%eax),%edx
  800bfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c02:	8d 40 04             	lea    0x4(%eax),%eax
  800c05:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c08:	b8 08 00 00 00       	mov    $0x8,%eax
  800c0d:	eb 54                	jmp    800c63 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800c0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c12:	8b 10                	mov    (%eax),%edx
  800c14:	8b 48 04             	mov    0x4(%eax),%ecx
  800c17:	8d 40 08             	lea    0x8(%eax),%eax
  800c1a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c1d:	b8 08 00 00 00       	mov    $0x8,%eax
  800c22:	eb 3f                	jmp    800c63 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800c24:	8b 45 14             	mov    0x14(%ebp),%eax
  800c27:	8b 10                	mov    (%eax),%edx
  800c29:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c2e:	8d 40 04             	lea    0x4(%eax),%eax
  800c31:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c34:	b8 08 00 00 00       	mov    $0x8,%eax
  800c39:	eb 28                	jmp    800c63 <vprintfmt+0x3a7>
			putch('0', putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	53                   	push   %ebx
  800c3f:	6a 30                	push   $0x30
  800c41:	ff d6                	call   *%esi
			putch('x', putdat);
  800c43:	83 c4 08             	add    $0x8,%esp
  800c46:	53                   	push   %ebx
  800c47:	6a 78                	push   $0x78
  800c49:	ff d6                	call   *%esi
			num = (unsigned long long)
  800c4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4e:	8b 10                	mov    (%eax),%edx
  800c50:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800c55:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800c58:	8d 40 04             	lea    0x4(%eax),%eax
  800c5b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c5e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800c63:	83 ec 0c             	sub    $0xc,%esp
  800c66:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800c6a:	57                   	push   %edi
  800c6b:	ff 75 e0             	pushl  -0x20(%ebp)
  800c6e:	50                   	push   %eax
  800c6f:	51                   	push   %ecx
  800c70:	52                   	push   %edx
  800c71:	89 da                	mov    %ebx,%edx
  800c73:	89 f0                	mov    %esi,%eax
  800c75:	e8 5a fb ff ff       	call   8007d4 <printnum>
			break;
  800c7a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800c7d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c80:	e9 55 fc ff ff       	jmp    8008da <vprintfmt+0x1e>
	if (lflag >= 2)
  800c85:	83 f9 01             	cmp    $0x1,%ecx
  800c88:	7f 1b                	jg     800ca5 <vprintfmt+0x3e9>
	else if (lflag)
  800c8a:	85 c9                	test   %ecx,%ecx
  800c8c:	74 2c                	je     800cba <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800c8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c91:	8b 10                	mov    (%eax),%edx
  800c93:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c98:	8d 40 04             	lea    0x4(%eax),%eax
  800c9b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c9e:	b8 10 00 00 00       	mov    $0x10,%eax
  800ca3:	eb be                	jmp    800c63 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca8:	8b 10                	mov    (%eax),%edx
  800caa:	8b 48 04             	mov    0x4(%eax),%ecx
  800cad:	8d 40 08             	lea    0x8(%eax),%eax
  800cb0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cb3:	b8 10 00 00 00       	mov    $0x10,%eax
  800cb8:	eb a9                	jmp    800c63 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800cba:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbd:	8b 10                	mov    (%eax),%edx
  800cbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc4:	8d 40 04             	lea    0x4(%eax),%eax
  800cc7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cca:	b8 10 00 00 00       	mov    $0x10,%eax
  800ccf:	eb 92                	jmp    800c63 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	53                   	push   %ebx
  800cd5:	6a 25                	push   $0x25
  800cd7:	ff d6                	call   *%esi
			break;
  800cd9:	83 c4 10             	add    $0x10,%esp
  800cdc:	eb 9f                	jmp    800c7d <vprintfmt+0x3c1>
			putch('%', putdat);
  800cde:	83 ec 08             	sub    $0x8,%esp
  800ce1:	53                   	push   %ebx
  800ce2:	6a 25                	push   $0x25
  800ce4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ce6:	83 c4 10             	add    $0x10,%esp
  800ce9:	89 f8                	mov    %edi,%eax
  800ceb:	eb 03                	jmp    800cf0 <vprintfmt+0x434>
  800ced:	83 e8 01             	sub    $0x1,%eax
  800cf0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800cf4:	75 f7                	jne    800ced <vprintfmt+0x431>
  800cf6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cf9:	eb 82                	jmp    800c7d <vprintfmt+0x3c1>

00800cfb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	83 ec 18             	sub    $0x18,%esp
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d0a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d0e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d18:	85 c0                	test   %eax,%eax
  800d1a:	74 26                	je     800d42 <vsnprintf+0x47>
  800d1c:	85 d2                	test   %edx,%edx
  800d1e:	7e 22                	jle    800d42 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d20:	ff 75 14             	pushl  0x14(%ebp)
  800d23:	ff 75 10             	pushl  0x10(%ebp)
  800d26:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d29:	50                   	push   %eax
  800d2a:	68 82 08 80 00       	push   $0x800882
  800d2f:	e8 88 fb ff ff       	call   8008bc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d3d:	83 c4 10             	add    $0x10,%esp
}
  800d40:	c9                   	leave  
  800d41:	c3                   	ret    
		return -E_INVAL;
  800d42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d47:	eb f7                	jmp    800d40 <vsnprintf+0x45>

00800d49 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d4f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d52:	50                   	push   %eax
  800d53:	ff 75 10             	pushl  0x10(%ebp)
  800d56:	ff 75 0c             	pushl  0xc(%ebp)
  800d59:	ff 75 08             	pushl  0x8(%ebp)
  800d5c:	e8 9a ff ff ff       	call   800cfb <vsnprintf>
	va_end(ap);

	return rc;
}
  800d61:	c9                   	leave  
  800d62:	c3                   	ret    

00800d63 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d69:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d72:	74 05                	je     800d79 <strlen+0x16>
		n++;
  800d74:	83 c0 01             	add    $0x1,%eax
  800d77:	eb f5                	jmp    800d6e <strlen+0xb>
	return n;
}
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d84:	ba 00 00 00 00       	mov    $0x0,%edx
  800d89:	39 c2                	cmp    %eax,%edx
  800d8b:	74 0d                	je     800d9a <strnlen+0x1f>
  800d8d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800d91:	74 05                	je     800d98 <strnlen+0x1d>
		n++;
  800d93:	83 c2 01             	add    $0x1,%edx
  800d96:	eb f1                	jmp    800d89 <strnlen+0xe>
  800d98:	89 d0                	mov    %edx,%eax
	return n;
}
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    

00800d9c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	53                   	push   %ebx
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800da6:	ba 00 00 00 00       	mov    $0x0,%edx
  800dab:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800daf:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800db2:	83 c2 01             	add    $0x1,%edx
  800db5:	84 c9                	test   %cl,%cl
  800db7:	75 f2                	jne    800dab <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800db9:	5b                   	pop    %ebx
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <strcat>:

char *
strcat(char *dst, const char *src)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	53                   	push   %ebx
  800dc0:	83 ec 10             	sub    $0x10,%esp
  800dc3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800dc6:	53                   	push   %ebx
  800dc7:	e8 97 ff ff ff       	call   800d63 <strlen>
  800dcc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800dcf:	ff 75 0c             	pushl  0xc(%ebp)
  800dd2:	01 d8                	add    %ebx,%eax
  800dd4:	50                   	push   %eax
  800dd5:	e8 c2 ff ff ff       	call   800d9c <strcpy>
	return dst;
}
  800dda:	89 d8                	mov    %ebx,%eax
  800ddc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dec:	89 c6                	mov    %eax,%esi
  800dee:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800df1:	89 c2                	mov    %eax,%edx
  800df3:	39 f2                	cmp    %esi,%edx
  800df5:	74 11                	je     800e08 <strncpy+0x27>
		*dst++ = *src;
  800df7:	83 c2 01             	add    $0x1,%edx
  800dfa:	0f b6 19             	movzbl (%ecx),%ebx
  800dfd:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e00:	80 fb 01             	cmp    $0x1,%bl
  800e03:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800e06:	eb eb                	jmp    800df3 <strncpy+0x12>
	}
	return ret;
}
  800e08:	5b                   	pop    %ebx
  800e09:	5e                   	pop    %esi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	56                   	push   %esi
  800e10:	53                   	push   %ebx
  800e11:	8b 75 08             	mov    0x8(%ebp),%esi
  800e14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e17:	8b 55 10             	mov    0x10(%ebp),%edx
  800e1a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e1c:	85 d2                	test   %edx,%edx
  800e1e:	74 21                	je     800e41 <strlcpy+0x35>
  800e20:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800e24:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800e26:	39 c2                	cmp    %eax,%edx
  800e28:	74 14                	je     800e3e <strlcpy+0x32>
  800e2a:	0f b6 19             	movzbl (%ecx),%ebx
  800e2d:	84 db                	test   %bl,%bl
  800e2f:	74 0b                	je     800e3c <strlcpy+0x30>
			*dst++ = *src++;
  800e31:	83 c1 01             	add    $0x1,%ecx
  800e34:	83 c2 01             	add    $0x1,%edx
  800e37:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e3a:	eb ea                	jmp    800e26 <strlcpy+0x1a>
  800e3c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e3e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e41:	29 f0                	sub    %esi,%eax
}
  800e43:	5b                   	pop    %ebx
  800e44:	5e                   	pop    %esi
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    

00800e47 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e4d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e50:	0f b6 01             	movzbl (%ecx),%eax
  800e53:	84 c0                	test   %al,%al
  800e55:	74 0c                	je     800e63 <strcmp+0x1c>
  800e57:	3a 02                	cmp    (%edx),%al
  800e59:	75 08                	jne    800e63 <strcmp+0x1c>
		p++, q++;
  800e5b:	83 c1 01             	add    $0x1,%ecx
  800e5e:	83 c2 01             	add    $0x1,%edx
  800e61:	eb ed                	jmp    800e50 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e63:	0f b6 c0             	movzbl %al,%eax
  800e66:	0f b6 12             	movzbl (%edx),%edx
  800e69:	29 d0                	sub    %edx,%eax
}
  800e6b:	5d                   	pop    %ebp
  800e6c:	c3                   	ret    

00800e6d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	53                   	push   %ebx
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e77:	89 c3                	mov    %eax,%ebx
  800e79:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e7c:	eb 06                	jmp    800e84 <strncmp+0x17>
		n--, p++, q++;
  800e7e:	83 c0 01             	add    $0x1,%eax
  800e81:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e84:	39 d8                	cmp    %ebx,%eax
  800e86:	74 16                	je     800e9e <strncmp+0x31>
  800e88:	0f b6 08             	movzbl (%eax),%ecx
  800e8b:	84 c9                	test   %cl,%cl
  800e8d:	74 04                	je     800e93 <strncmp+0x26>
  800e8f:	3a 0a                	cmp    (%edx),%cl
  800e91:	74 eb                	je     800e7e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e93:	0f b6 00             	movzbl (%eax),%eax
  800e96:	0f b6 12             	movzbl (%edx),%edx
  800e99:	29 d0                	sub    %edx,%eax
}
  800e9b:	5b                   	pop    %ebx
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    
		return 0;
  800e9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea3:	eb f6                	jmp    800e9b <strncmp+0x2e>

00800ea5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800eaf:	0f b6 10             	movzbl (%eax),%edx
  800eb2:	84 d2                	test   %dl,%dl
  800eb4:	74 09                	je     800ebf <strchr+0x1a>
		if (*s == c)
  800eb6:	38 ca                	cmp    %cl,%dl
  800eb8:	74 0a                	je     800ec4 <strchr+0x1f>
	for (; *s; s++)
  800eba:	83 c0 01             	add    $0x1,%eax
  800ebd:	eb f0                	jmp    800eaf <strchr+0xa>
			return (char *) s;
	return 0;
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec4:	5d                   	pop    %ebp
  800ec5:	c3                   	ret    

00800ec6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ed0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ed3:	38 ca                	cmp    %cl,%dl
  800ed5:	74 09                	je     800ee0 <strfind+0x1a>
  800ed7:	84 d2                	test   %dl,%dl
  800ed9:	74 05                	je     800ee0 <strfind+0x1a>
	for (; *s; s++)
  800edb:	83 c0 01             	add    $0x1,%eax
  800ede:	eb f0                	jmp    800ed0 <strfind+0xa>
			break;
	return (char *) s;
}
  800ee0:	5d                   	pop    %ebp
  800ee1:	c3                   	ret    

00800ee2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	57                   	push   %edi
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
  800ee8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800eeb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800eee:	85 c9                	test   %ecx,%ecx
  800ef0:	74 31                	je     800f23 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ef2:	89 f8                	mov    %edi,%eax
  800ef4:	09 c8                	or     %ecx,%eax
  800ef6:	a8 03                	test   $0x3,%al
  800ef8:	75 23                	jne    800f1d <memset+0x3b>
		c &= 0xFF;
  800efa:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800efe:	89 d3                	mov    %edx,%ebx
  800f00:	c1 e3 08             	shl    $0x8,%ebx
  800f03:	89 d0                	mov    %edx,%eax
  800f05:	c1 e0 18             	shl    $0x18,%eax
  800f08:	89 d6                	mov    %edx,%esi
  800f0a:	c1 e6 10             	shl    $0x10,%esi
  800f0d:	09 f0                	or     %esi,%eax
  800f0f:	09 c2                	or     %eax,%edx
  800f11:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f13:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f16:	89 d0                	mov    %edx,%eax
  800f18:	fc                   	cld    
  800f19:	f3 ab                	rep stos %eax,%es:(%edi)
  800f1b:	eb 06                	jmp    800f23 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f20:	fc                   	cld    
  800f21:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f23:	89 f8                	mov    %edi,%eax
  800f25:	5b                   	pop    %ebx
  800f26:	5e                   	pop    %esi
  800f27:	5f                   	pop    %edi
  800f28:	5d                   	pop    %ebp
  800f29:	c3                   	ret    

00800f2a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	57                   	push   %edi
  800f2e:	56                   	push   %esi
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f35:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f38:	39 c6                	cmp    %eax,%esi
  800f3a:	73 32                	jae    800f6e <memmove+0x44>
  800f3c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f3f:	39 c2                	cmp    %eax,%edx
  800f41:	76 2b                	jbe    800f6e <memmove+0x44>
		s += n;
		d += n;
  800f43:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f46:	89 fe                	mov    %edi,%esi
  800f48:	09 ce                	or     %ecx,%esi
  800f4a:	09 d6                	or     %edx,%esi
  800f4c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f52:	75 0e                	jne    800f62 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f54:	83 ef 04             	sub    $0x4,%edi
  800f57:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f5a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f5d:	fd                   	std    
  800f5e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f60:	eb 09                	jmp    800f6b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f62:	83 ef 01             	sub    $0x1,%edi
  800f65:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f68:	fd                   	std    
  800f69:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f6b:	fc                   	cld    
  800f6c:	eb 1a                	jmp    800f88 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f6e:	89 c2                	mov    %eax,%edx
  800f70:	09 ca                	or     %ecx,%edx
  800f72:	09 f2                	or     %esi,%edx
  800f74:	f6 c2 03             	test   $0x3,%dl
  800f77:	75 0a                	jne    800f83 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f79:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f7c:	89 c7                	mov    %eax,%edi
  800f7e:	fc                   	cld    
  800f7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f81:	eb 05                	jmp    800f88 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800f83:	89 c7                	mov    %eax,%edi
  800f85:	fc                   	cld    
  800f86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f88:	5e                   	pop    %esi
  800f89:	5f                   	pop    %edi
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f92:	ff 75 10             	pushl  0x10(%ebp)
  800f95:	ff 75 0c             	pushl  0xc(%ebp)
  800f98:	ff 75 08             	pushl  0x8(%ebp)
  800f9b:	e8 8a ff ff ff       	call   800f2a <memmove>
}
  800fa0:	c9                   	leave  
  800fa1:	c3                   	ret    

00800fa2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	56                   	push   %esi
  800fa6:	53                   	push   %ebx
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fad:	89 c6                	mov    %eax,%esi
  800faf:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fb2:	39 f0                	cmp    %esi,%eax
  800fb4:	74 1c                	je     800fd2 <memcmp+0x30>
		if (*s1 != *s2)
  800fb6:	0f b6 08             	movzbl (%eax),%ecx
  800fb9:	0f b6 1a             	movzbl (%edx),%ebx
  800fbc:	38 d9                	cmp    %bl,%cl
  800fbe:	75 08                	jne    800fc8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800fc0:	83 c0 01             	add    $0x1,%eax
  800fc3:	83 c2 01             	add    $0x1,%edx
  800fc6:	eb ea                	jmp    800fb2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800fc8:	0f b6 c1             	movzbl %cl,%eax
  800fcb:	0f b6 db             	movzbl %bl,%ebx
  800fce:	29 d8                	sub    %ebx,%eax
  800fd0:	eb 05                	jmp    800fd7 <memcmp+0x35>
	}

	return 0;
  800fd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    

00800fdb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800fe4:	89 c2                	mov    %eax,%edx
  800fe6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800fe9:	39 d0                	cmp    %edx,%eax
  800feb:	73 09                	jae    800ff6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fed:	38 08                	cmp    %cl,(%eax)
  800fef:	74 05                	je     800ff6 <memfind+0x1b>
	for (; s < ends; s++)
  800ff1:	83 c0 01             	add    $0x1,%eax
  800ff4:	eb f3                	jmp    800fe9 <memfind+0xe>
			break;
	return (void *) s;
}
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    

00800ff8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	57                   	push   %edi
  800ffc:	56                   	push   %esi
  800ffd:	53                   	push   %ebx
  800ffe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801001:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801004:	eb 03                	jmp    801009 <strtol+0x11>
		s++;
  801006:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801009:	0f b6 01             	movzbl (%ecx),%eax
  80100c:	3c 20                	cmp    $0x20,%al
  80100e:	74 f6                	je     801006 <strtol+0xe>
  801010:	3c 09                	cmp    $0x9,%al
  801012:	74 f2                	je     801006 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801014:	3c 2b                	cmp    $0x2b,%al
  801016:	74 2a                	je     801042 <strtol+0x4a>
	int neg = 0;
  801018:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80101d:	3c 2d                	cmp    $0x2d,%al
  80101f:	74 2b                	je     80104c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801021:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801027:	75 0f                	jne    801038 <strtol+0x40>
  801029:	80 39 30             	cmpb   $0x30,(%ecx)
  80102c:	74 28                	je     801056 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80102e:	85 db                	test   %ebx,%ebx
  801030:	b8 0a 00 00 00       	mov    $0xa,%eax
  801035:	0f 44 d8             	cmove  %eax,%ebx
  801038:	b8 00 00 00 00       	mov    $0x0,%eax
  80103d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801040:	eb 50                	jmp    801092 <strtol+0x9a>
		s++;
  801042:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801045:	bf 00 00 00 00       	mov    $0x0,%edi
  80104a:	eb d5                	jmp    801021 <strtol+0x29>
		s++, neg = 1;
  80104c:	83 c1 01             	add    $0x1,%ecx
  80104f:	bf 01 00 00 00       	mov    $0x1,%edi
  801054:	eb cb                	jmp    801021 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801056:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80105a:	74 0e                	je     80106a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  80105c:	85 db                	test   %ebx,%ebx
  80105e:	75 d8                	jne    801038 <strtol+0x40>
		s++, base = 8;
  801060:	83 c1 01             	add    $0x1,%ecx
  801063:	bb 08 00 00 00       	mov    $0x8,%ebx
  801068:	eb ce                	jmp    801038 <strtol+0x40>
		s += 2, base = 16;
  80106a:	83 c1 02             	add    $0x2,%ecx
  80106d:	bb 10 00 00 00       	mov    $0x10,%ebx
  801072:	eb c4                	jmp    801038 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801074:	8d 72 9f             	lea    -0x61(%edx),%esi
  801077:	89 f3                	mov    %esi,%ebx
  801079:	80 fb 19             	cmp    $0x19,%bl
  80107c:	77 29                	ja     8010a7 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80107e:	0f be d2             	movsbl %dl,%edx
  801081:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801084:	3b 55 10             	cmp    0x10(%ebp),%edx
  801087:	7d 30                	jge    8010b9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801089:	83 c1 01             	add    $0x1,%ecx
  80108c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801090:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801092:	0f b6 11             	movzbl (%ecx),%edx
  801095:	8d 72 d0             	lea    -0x30(%edx),%esi
  801098:	89 f3                	mov    %esi,%ebx
  80109a:	80 fb 09             	cmp    $0x9,%bl
  80109d:	77 d5                	ja     801074 <strtol+0x7c>
			dig = *s - '0';
  80109f:	0f be d2             	movsbl %dl,%edx
  8010a2:	83 ea 30             	sub    $0x30,%edx
  8010a5:	eb dd                	jmp    801084 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8010a7:	8d 72 bf             	lea    -0x41(%edx),%esi
  8010aa:	89 f3                	mov    %esi,%ebx
  8010ac:	80 fb 19             	cmp    $0x19,%bl
  8010af:	77 08                	ja     8010b9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8010b1:	0f be d2             	movsbl %dl,%edx
  8010b4:	83 ea 37             	sub    $0x37,%edx
  8010b7:	eb cb                	jmp    801084 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8010b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010bd:	74 05                	je     8010c4 <strtol+0xcc>
		*endptr = (char *) s;
  8010bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010c2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8010c4:	89 c2                	mov    %eax,%edx
  8010c6:	f7 da                	neg    %edx
  8010c8:	85 ff                	test   %edi,%edi
  8010ca:	0f 45 c2             	cmovne %edx,%eax
}
  8010cd:	5b                   	pop    %ebx
  8010ce:	5e                   	pop    %esi
  8010cf:	5f                   	pop    %edi
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	57                   	push   %edi
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e3:	89 c3                	mov    %eax,%ebx
  8010e5:	89 c7                	mov    %eax,%edi
  8010e7:	89 c6                	mov    %eax,%esi
  8010e9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	57                   	push   %edi
  8010f4:	56                   	push   %esi
  8010f5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8010fb:	b8 01 00 00 00       	mov    $0x1,%eax
  801100:	89 d1                	mov    %edx,%ecx
  801102:	89 d3                	mov    %edx,%ebx
  801104:	89 d7                	mov    %edx,%edi
  801106:	89 d6                	mov    %edx,%esi
  801108:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80110a:	5b                   	pop    %ebx
  80110b:	5e                   	pop    %esi
  80110c:	5f                   	pop    %edi
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    

0080110f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	57                   	push   %edi
  801113:	56                   	push   %esi
  801114:	53                   	push   %ebx
  801115:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801118:	b9 00 00 00 00       	mov    $0x0,%ecx
  80111d:	8b 55 08             	mov    0x8(%ebp),%edx
  801120:	b8 03 00 00 00       	mov    $0x3,%eax
  801125:	89 cb                	mov    %ecx,%ebx
  801127:	89 cf                	mov    %ecx,%edi
  801129:	89 ce                	mov    %ecx,%esi
  80112b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80112d:	85 c0                	test   %eax,%eax
  80112f:	7f 08                	jg     801139 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801131:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801134:	5b                   	pop    %ebx
  801135:	5e                   	pop    %esi
  801136:	5f                   	pop    %edi
  801137:	5d                   	pop    %ebp
  801138:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801139:	83 ec 0c             	sub    $0xc,%esp
  80113c:	50                   	push   %eax
  80113d:	6a 03                	push   $0x3
  80113f:	68 bf 2f 80 00       	push   $0x802fbf
  801144:	6a 23                	push   $0x23
  801146:	68 dc 2f 80 00       	push   $0x802fdc
  80114b:	e8 95 f5 ff ff       	call   8006e5 <_panic>

00801150 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	57                   	push   %edi
  801154:	56                   	push   %esi
  801155:	53                   	push   %ebx
	asm volatile("int %1\n"
  801156:	ba 00 00 00 00       	mov    $0x0,%edx
  80115b:	b8 02 00 00 00       	mov    $0x2,%eax
  801160:	89 d1                	mov    %edx,%ecx
  801162:	89 d3                	mov    %edx,%ebx
  801164:	89 d7                	mov    %edx,%edi
  801166:	89 d6                	mov    %edx,%esi
  801168:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80116a:	5b                   	pop    %ebx
  80116b:	5e                   	pop    %esi
  80116c:	5f                   	pop    %edi
  80116d:	5d                   	pop    %ebp
  80116e:	c3                   	ret    

0080116f <sys_yield>:

void
sys_yield(void)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	57                   	push   %edi
  801173:	56                   	push   %esi
  801174:	53                   	push   %ebx
	asm volatile("int %1\n"
  801175:	ba 00 00 00 00       	mov    $0x0,%edx
  80117a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80117f:	89 d1                	mov    %edx,%ecx
  801181:	89 d3                	mov    %edx,%ebx
  801183:	89 d7                	mov    %edx,%edi
  801185:	89 d6                	mov    %edx,%esi
  801187:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801189:	5b                   	pop    %ebx
  80118a:	5e                   	pop    %esi
  80118b:	5f                   	pop    %edi
  80118c:	5d                   	pop    %ebp
  80118d:	c3                   	ret    

0080118e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	57                   	push   %edi
  801192:	56                   	push   %esi
  801193:	53                   	push   %ebx
  801194:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801197:	be 00 00 00 00       	mov    $0x0,%esi
  80119c:	8b 55 08             	mov    0x8(%ebp),%edx
  80119f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a2:	b8 04 00 00 00       	mov    $0x4,%eax
  8011a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011aa:	89 f7                	mov    %esi,%edi
  8011ac:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	7f 08                	jg     8011ba <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b5:	5b                   	pop    %ebx
  8011b6:	5e                   	pop    %esi
  8011b7:	5f                   	pop    %edi
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	50                   	push   %eax
  8011be:	6a 04                	push   $0x4
  8011c0:	68 bf 2f 80 00       	push   $0x802fbf
  8011c5:	6a 23                	push   $0x23
  8011c7:	68 dc 2f 80 00       	push   $0x802fdc
  8011cc:	e8 14 f5 ff ff       	call   8006e5 <_panic>

008011d1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	57                   	push   %edi
  8011d5:	56                   	push   %esi
  8011d6:	53                   	push   %ebx
  8011d7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011da:	8b 55 08             	mov    0x8(%ebp),%edx
  8011dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e0:	b8 05 00 00 00       	mov    $0x5,%eax
  8011e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011e8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011eb:	8b 75 18             	mov    0x18(%ebp),%esi
  8011ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	7f 08                	jg     8011fc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f7:	5b                   	pop    %ebx
  8011f8:	5e                   	pop    %esi
  8011f9:	5f                   	pop    %edi
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fc:	83 ec 0c             	sub    $0xc,%esp
  8011ff:	50                   	push   %eax
  801200:	6a 05                	push   $0x5
  801202:	68 bf 2f 80 00       	push   $0x802fbf
  801207:	6a 23                	push   $0x23
  801209:	68 dc 2f 80 00       	push   $0x802fdc
  80120e:	e8 d2 f4 ff ff       	call   8006e5 <_panic>

00801213 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	57                   	push   %edi
  801217:	56                   	push   %esi
  801218:	53                   	push   %ebx
  801219:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80121c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801221:	8b 55 08             	mov    0x8(%ebp),%edx
  801224:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801227:	b8 06 00 00 00       	mov    $0x6,%eax
  80122c:	89 df                	mov    %ebx,%edi
  80122e:	89 de                	mov    %ebx,%esi
  801230:	cd 30                	int    $0x30
	if(check && ret > 0)
  801232:	85 c0                	test   %eax,%eax
  801234:	7f 08                	jg     80123e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801236:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801239:	5b                   	pop    %ebx
  80123a:	5e                   	pop    %esi
  80123b:	5f                   	pop    %edi
  80123c:	5d                   	pop    %ebp
  80123d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80123e:	83 ec 0c             	sub    $0xc,%esp
  801241:	50                   	push   %eax
  801242:	6a 06                	push   $0x6
  801244:	68 bf 2f 80 00       	push   $0x802fbf
  801249:	6a 23                	push   $0x23
  80124b:	68 dc 2f 80 00       	push   $0x802fdc
  801250:	e8 90 f4 ff ff       	call   8006e5 <_panic>

00801255 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	57                   	push   %edi
  801259:	56                   	push   %esi
  80125a:	53                   	push   %ebx
  80125b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80125e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801263:	8b 55 08             	mov    0x8(%ebp),%edx
  801266:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801269:	b8 08 00 00 00       	mov    $0x8,%eax
  80126e:	89 df                	mov    %ebx,%edi
  801270:	89 de                	mov    %ebx,%esi
  801272:	cd 30                	int    $0x30
	if(check && ret > 0)
  801274:	85 c0                	test   %eax,%eax
  801276:	7f 08                	jg     801280 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801278:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127b:	5b                   	pop    %ebx
  80127c:	5e                   	pop    %esi
  80127d:	5f                   	pop    %edi
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801280:	83 ec 0c             	sub    $0xc,%esp
  801283:	50                   	push   %eax
  801284:	6a 08                	push   $0x8
  801286:	68 bf 2f 80 00       	push   $0x802fbf
  80128b:	6a 23                	push   $0x23
  80128d:	68 dc 2f 80 00       	push   $0x802fdc
  801292:	e8 4e f4 ff ff       	call   8006e5 <_panic>

00801297 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	57                   	push   %edi
  80129b:	56                   	push   %esi
  80129c:	53                   	push   %ebx
  80129d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ab:	b8 09 00 00 00       	mov    $0x9,%eax
  8012b0:	89 df                	mov    %ebx,%edi
  8012b2:	89 de                	mov    %ebx,%esi
  8012b4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	7f 08                	jg     8012c2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012bd:	5b                   	pop    %ebx
  8012be:	5e                   	pop    %esi
  8012bf:	5f                   	pop    %edi
  8012c0:	5d                   	pop    %ebp
  8012c1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c2:	83 ec 0c             	sub    $0xc,%esp
  8012c5:	50                   	push   %eax
  8012c6:	6a 09                	push   $0x9
  8012c8:	68 bf 2f 80 00       	push   $0x802fbf
  8012cd:	6a 23                	push   $0x23
  8012cf:	68 dc 2f 80 00       	push   $0x802fdc
  8012d4:	e8 0c f4 ff ff       	call   8006e5 <_panic>

008012d9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	57                   	push   %edi
  8012dd:	56                   	push   %esi
  8012de:	53                   	push   %ebx
  8012df:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012f2:	89 df                	mov    %ebx,%edi
  8012f4:	89 de                	mov    %ebx,%esi
  8012f6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	7f 08                	jg     801304 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ff:	5b                   	pop    %ebx
  801300:	5e                   	pop    %esi
  801301:	5f                   	pop    %edi
  801302:	5d                   	pop    %ebp
  801303:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801304:	83 ec 0c             	sub    $0xc,%esp
  801307:	50                   	push   %eax
  801308:	6a 0a                	push   $0xa
  80130a:	68 bf 2f 80 00       	push   $0x802fbf
  80130f:	6a 23                	push   $0x23
  801311:	68 dc 2f 80 00       	push   $0x802fdc
  801316:	e8 ca f3 ff ff       	call   8006e5 <_panic>

0080131b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	57                   	push   %edi
  80131f:	56                   	push   %esi
  801320:	53                   	push   %ebx
	asm volatile("int %1\n"
  801321:	8b 55 08             	mov    0x8(%ebp),%edx
  801324:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801327:	b8 0c 00 00 00       	mov    $0xc,%eax
  80132c:	be 00 00 00 00       	mov    $0x0,%esi
  801331:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801334:	8b 7d 14             	mov    0x14(%ebp),%edi
  801337:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801339:	5b                   	pop    %ebx
  80133a:	5e                   	pop    %esi
  80133b:	5f                   	pop    %edi
  80133c:	5d                   	pop    %ebp
  80133d:	c3                   	ret    

0080133e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	57                   	push   %edi
  801342:	56                   	push   %esi
  801343:	53                   	push   %ebx
  801344:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801347:	b9 00 00 00 00       	mov    $0x0,%ecx
  80134c:	8b 55 08             	mov    0x8(%ebp),%edx
  80134f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801354:	89 cb                	mov    %ecx,%ebx
  801356:	89 cf                	mov    %ecx,%edi
  801358:	89 ce                	mov    %ecx,%esi
  80135a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80135c:	85 c0                	test   %eax,%eax
  80135e:	7f 08                	jg     801368 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801360:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801363:	5b                   	pop    %ebx
  801364:	5e                   	pop    %esi
  801365:	5f                   	pop    %edi
  801366:	5d                   	pop    %ebp
  801367:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801368:	83 ec 0c             	sub    $0xc,%esp
  80136b:	50                   	push   %eax
  80136c:	6a 0d                	push   $0xd
  80136e:	68 bf 2f 80 00       	push   $0x802fbf
  801373:	6a 23                	push   $0x23
  801375:	68 dc 2f 80 00       	push   $0x802fdc
  80137a:	e8 66 f3 ff ff       	call   8006e5 <_panic>

0080137f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	57                   	push   %edi
  801383:	56                   	push   %esi
  801384:	53                   	push   %ebx
	asm volatile("int %1\n"
  801385:	ba 00 00 00 00       	mov    $0x0,%edx
  80138a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80138f:	89 d1                	mov    %edx,%ecx
  801391:	89 d3                	mov    %edx,%ebx
  801393:	89 d7                	mov    %edx,%edi
  801395:	89 d6                	mov    %edx,%esi
  801397:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801399:	5b                   	pop    %ebx
  80139a:	5e                   	pop    %esi
  80139b:	5f                   	pop    %edi
  80139c:	5d                   	pop    %ebp
  80139d:	c3                   	ret    

0080139e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	56                   	push   %esi
  8013a2:	53                   	push   %ebx
  8013a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8013a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	74 4f                	je     8013ff <ipc_recv+0x61>
  8013b0:	83 ec 0c             	sub    $0xc,%esp
  8013b3:	50                   	push   %eax
  8013b4:	e8 85 ff ff ff       	call   80133e <sys_ipc_recv>
  8013b9:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  8013bc:	85 f6                	test   %esi,%esi
  8013be:	74 14                	je     8013d4 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  8013c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	75 09                	jne    8013d2 <ipc_recv+0x34>
  8013c9:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8013cf:	8b 52 74             	mov    0x74(%edx),%edx
  8013d2:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8013d4:	85 db                	test   %ebx,%ebx
  8013d6:	74 14                	je     8013ec <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8013d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	75 09                	jne    8013ea <ipc_recv+0x4c>
  8013e1:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8013e7:	8b 52 78             	mov    0x78(%edx),%edx
  8013ea:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	75 08                	jne    8013f8 <ipc_recv+0x5a>
  8013f0:	a1 08 50 80 00       	mov    0x805008,%eax
  8013f5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8013f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013fb:	5b                   	pop    %ebx
  8013fc:	5e                   	pop    %esi
  8013fd:	5d                   	pop    %ebp
  8013fe:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	68 00 00 c0 ee       	push   $0xeec00000
  801407:	e8 32 ff ff ff       	call   80133e <sys_ipc_recv>
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	eb ab                	jmp    8013bc <ipc_recv+0x1e>

00801411 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
  801414:	57                   	push   %edi
  801415:	56                   	push   %esi
  801416:	53                   	push   %ebx
  801417:	83 ec 0c             	sub    $0xc,%esp
  80141a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80141d:	8b 75 10             	mov    0x10(%ebp),%esi
  801420:	eb 20                	jmp    801442 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801422:	6a 00                	push   $0x0
  801424:	68 00 00 c0 ee       	push   $0xeec00000
  801429:	ff 75 0c             	pushl  0xc(%ebp)
  80142c:	57                   	push   %edi
  80142d:	e8 e9 fe ff ff       	call   80131b <sys_ipc_try_send>
  801432:	89 c3                	mov    %eax,%ebx
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	eb 1f                	jmp    801458 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801439:	e8 31 fd ff ff       	call   80116f <sys_yield>
	while(retval != 0) {
  80143e:	85 db                	test   %ebx,%ebx
  801440:	74 33                	je     801475 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801442:	85 f6                	test   %esi,%esi
  801444:	74 dc                	je     801422 <ipc_send+0x11>
  801446:	ff 75 14             	pushl  0x14(%ebp)
  801449:	56                   	push   %esi
  80144a:	ff 75 0c             	pushl  0xc(%ebp)
  80144d:	57                   	push   %edi
  80144e:	e8 c8 fe ff ff       	call   80131b <sys_ipc_try_send>
  801453:	89 c3                	mov    %eax,%ebx
  801455:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801458:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80145b:	74 dc                	je     801439 <ipc_send+0x28>
  80145d:	85 db                	test   %ebx,%ebx
  80145f:	74 d8                	je     801439 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	68 ec 2f 80 00       	push   $0x802fec
  801469:	6a 35                	push   $0x35
  80146b:	68 1c 30 80 00       	push   $0x80301c
  801470:	e8 70 f2 ff ff       	call   8006e5 <_panic>
	}
}
  801475:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801478:	5b                   	pop    %ebx
  801479:	5e                   	pop    %esi
  80147a:	5f                   	pop    %edi
  80147b:	5d                   	pop    %ebp
  80147c:	c3                   	ret    

0080147d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801483:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801488:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80148b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801491:	8b 52 50             	mov    0x50(%edx),%edx
  801494:	39 ca                	cmp    %ecx,%edx
  801496:	74 11                	je     8014a9 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801498:	83 c0 01             	add    $0x1,%eax
  80149b:	3d 00 04 00 00       	cmp    $0x400,%eax
  8014a0:	75 e6                	jne    801488 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8014a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a7:	eb 0b                	jmp    8014b4 <ipc_find_env+0x37>
			return envs[i].env_id;
  8014a9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8014ac:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014b1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8014b4:	5d                   	pop    %ebp
  8014b5:	c3                   	ret    

008014b6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	05 00 00 00 30       	add    $0x30000000,%eax
  8014c1:	c1 e8 0c             	shr    $0xc,%eax
}
  8014c4:	5d                   	pop    %ebp
  8014c5:	c3                   	ret    

008014c6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8014d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014d6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014db:	5d                   	pop    %ebp
  8014dc:	c3                   	ret    

008014dd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014e5:	89 c2                	mov    %eax,%edx
  8014e7:	c1 ea 16             	shr    $0x16,%edx
  8014ea:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014f1:	f6 c2 01             	test   $0x1,%dl
  8014f4:	74 2d                	je     801523 <fd_alloc+0x46>
  8014f6:	89 c2                	mov    %eax,%edx
  8014f8:	c1 ea 0c             	shr    $0xc,%edx
  8014fb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801502:	f6 c2 01             	test   $0x1,%dl
  801505:	74 1c                	je     801523 <fd_alloc+0x46>
  801507:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80150c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801511:	75 d2                	jne    8014e5 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80151c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801521:	eb 0a                	jmp    80152d <fd_alloc+0x50>
			*fd_store = fd;
  801523:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801526:	89 01                	mov    %eax,(%ecx)
			return 0;
  801528:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    

0080152f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801535:	83 f8 1f             	cmp    $0x1f,%eax
  801538:	77 30                	ja     80156a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80153a:	c1 e0 0c             	shl    $0xc,%eax
  80153d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801542:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801548:	f6 c2 01             	test   $0x1,%dl
  80154b:	74 24                	je     801571 <fd_lookup+0x42>
  80154d:	89 c2                	mov    %eax,%edx
  80154f:	c1 ea 0c             	shr    $0xc,%edx
  801552:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801559:	f6 c2 01             	test   $0x1,%dl
  80155c:	74 1a                	je     801578 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80155e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801561:	89 02                	mov    %eax,(%edx)
	return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801568:	5d                   	pop    %ebp
  801569:	c3                   	ret    
		return -E_INVAL;
  80156a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80156f:	eb f7                	jmp    801568 <fd_lookup+0x39>
		return -E_INVAL;
  801571:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801576:	eb f0                	jmp    801568 <fd_lookup+0x39>
  801578:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157d:	eb e9                	jmp    801568 <fd_lookup+0x39>

0080157f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 08             	sub    $0x8,%esp
  801585:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801588:	ba 00 00 00 00       	mov    $0x0,%edx
  80158d:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801592:	39 08                	cmp    %ecx,(%eax)
  801594:	74 38                	je     8015ce <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801596:	83 c2 01             	add    $0x1,%edx
  801599:	8b 04 95 a8 30 80 00 	mov    0x8030a8(,%edx,4),%eax
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	75 ee                	jne    801592 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015a4:	a1 08 50 80 00       	mov    0x805008,%eax
  8015a9:	8b 40 48             	mov    0x48(%eax),%eax
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	51                   	push   %ecx
  8015b0:	50                   	push   %eax
  8015b1:	68 28 30 80 00       	push   $0x803028
  8015b6:	e8 05 f2 ff ff       	call   8007c0 <cprintf>
	*dev = 0;
  8015bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015c4:	83 c4 10             	add    $0x10,%esp
  8015c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    
			*dev = devtab[i];
  8015ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015d1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d8:	eb f2                	jmp    8015cc <dev_lookup+0x4d>

008015da <fd_close>:
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	57                   	push   %edi
  8015de:	56                   	push   %esi
  8015df:	53                   	push   %ebx
  8015e0:	83 ec 24             	sub    $0x24,%esp
  8015e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8015e6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ec:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015ed:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015f3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015f6:	50                   	push   %eax
  8015f7:	e8 33 ff ff ff       	call   80152f <fd_lookup>
  8015fc:	89 c3                	mov    %eax,%ebx
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	85 c0                	test   %eax,%eax
  801603:	78 05                	js     80160a <fd_close+0x30>
	    || fd != fd2)
  801605:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801608:	74 16                	je     801620 <fd_close+0x46>
		return (must_exist ? r : 0);
  80160a:	89 f8                	mov    %edi,%eax
  80160c:	84 c0                	test   %al,%al
  80160e:	b8 00 00 00 00       	mov    $0x0,%eax
  801613:	0f 44 d8             	cmove  %eax,%ebx
}
  801616:	89 d8                	mov    %ebx,%eax
  801618:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161b:	5b                   	pop    %ebx
  80161c:	5e                   	pop    %esi
  80161d:	5f                   	pop    %edi
  80161e:	5d                   	pop    %ebp
  80161f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801620:	83 ec 08             	sub    $0x8,%esp
  801623:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801626:	50                   	push   %eax
  801627:	ff 36                	pushl  (%esi)
  801629:	e8 51 ff ff ff       	call   80157f <dev_lookup>
  80162e:	89 c3                	mov    %eax,%ebx
  801630:	83 c4 10             	add    $0x10,%esp
  801633:	85 c0                	test   %eax,%eax
  801635:	78 1a                	js     801651 <fd_close+0x77>
		if (dev->dev_close)
  801637:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80163d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801642:	85 c0                	test   %eax,%eax
  801644:	74 0b                	je     801651 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801646:	83 ec 0c             	sub    $0xc,%esp
  801649:	56                   	push   %esi
  80164a:	ff d0                	call   *%eax
  80164c:	89 c3                	mov    %eax,%ebx
  80164e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801651:	83 ec 08             	sub    $0x8,%esp
  801654:	56                   	push   %esi
  801655:	6a 00                	push   $0x0
  801657:	e8 b7 fb ff ff       	call   801213 <sys_page_unmap>
	return r;
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	eb b5                	jmp    801616 <fd_close+0x3c>

00801661 <close>:

int
close(int fdnum)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801667:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166a:	50                   	push   %eax
  80166b:	ff 75 08             	pushl  0x8(%ebp)
  80166e:	e8 bc fe ff ff       	call   80152f <fd_lookup>
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	85 c0                	test   %eax,%eax
  801678:	79 02                	jns    80167c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    
		return fd_close(fd, 1);
  80167c:	83 ec 08             	sub    $0x8,%esp
  80167f:	6a 01                	push   $0x1
  801681:	ff 75 f4             	pushl  -0xc(%ebp)
  801684:	e8 51 ff ff ff       	call   8015da <fd_close>
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	eb ec                	jmp    80167a <close+0x19>

0080168e <close_all>:

void
close_all(void)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	53                   	push   %ebx
  801692:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801695:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80169a:	83 ec 0c             	sub    $0xc,%esp
  80169d:	53                   	push   %ebx
  80169e:	e8 be ff ff ff       	call   801661 <close>
	for (i = 0; i < MAXFD; i++)
  8016a3:	83 c3 01             	add    $0x1,%ebx
  8016a6:	83 c4 10             	add    $0x10,%esp
  8016a9:	83 fb 20             	cmp    $0x20,%ebx
  8016ac:	75 ec                	jne    80169a <close_all+0xc>
}
  8016ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	57                   	push   %edi
  8016b7:	56                   	push   %esi
  8016b8:	53                   	push   %ebx
  8016b9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016bc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016bf:	50                   	push   %eax
  8016c0:	ff 75 08             	pushl  0x8(%ebp)
  8016c3:	e8 67 fe ff ff       	call   80152f <fd_lookup>
  8016c8:	89 c3                	mov    %eax,%ebx
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	0f 88 81 00 00 00    	js     801756 <dup+0xa3>
		return r;
	close(newfdnum);
  8016d5:	83 ec 0c             	sub    $0xc,%esp
  8016d8:	ff 75 0c             	pushl  0xc(%ebp)
  8016db:	e8 81 ff ff ff       	call   801661 <close>

	newfd = INDEX2FD(newfdnum);
  8016e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016e3:	c1 e6 0c             	shl    $0xc,%esi
  8016e6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016ec:	83 c4 04             	add    $0x4,%esp
  8016ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016f2:	e8 cf fd ff ff       	call   8014c6 <fd2data>
  8016f7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016f9:	89 34 24             	mov    %esi,(%esp)
  8016fc:	e8 c5 fd ff ff       	call   8014c6 <fd2data>
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801706:	89 d8                	mov    %ebx,%eax
  801708:	c1 e8 16             	shr    $0x16,%eax
  80170b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801712:	a8 01                	test   $0x1,%al
  801714:	74 11                	je     801727 <dup+0x74>
  801716:	89 d8                	mov    %ebx,%eax
  801718:	c1 e8 0c             	shr    $0xc,%eax
  80171b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801722:	f6 c2 01             	test   $0x1,%dl
  801725:	75 39                	jne    801760 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801727:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80172a:	89 d0                	mov    %edx,%eax
  80172c:	c1 e8 0c             	shr    $0xc,%eax
  80172f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801736:	83 ec 0c             	sub    $0xc,%esp
  801739:	25 07 0e 00 00       	and    $0xe07,%eax
  80173e:	50                   	push   %eax
  80173f:	56                   	push   %esi
  801740:	6a 00                	push   $0x0
  801742:	52                   	push   %edx
  801743:	6a 00                	push   $0x0
  801745:	e8 87 fa ff ff       	call   8011d1 <sys_page_map>
  80174a:	89 c3                	mov    %eax,%ebx
  80174c:	83 c4 20             	add    $0x20,%esp
  80174f:	85 c0                	test   %eax,%eax
  801751:	78 31                	js     801784 <dup+0xd1>
		goto err;

	return newfdnum;
  801753:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801756:	89 d8                	mov    %ebx,%eax
  801758:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80175b:	5b                   	pop    %ebx
  80175c:	5e                   	pop    %esi
  80175d:	5f                   	pop    %edi
  80175e:	5d                   	pop    %ebp
  80175f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801760:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801767:	83 ec 0c             	sub    $0xc,%esp
  80176a:	25 07 0e 00 00       	and    $0xe07,%eax
  80176f:	50                   	push   %eax
  801770:	57                   	push   %edi
  801771:	6a 00                	push   $0x0
  801773:	53                   	push   %ebx
  801774:	6a 00                	push   $0x0
  801776:	e8 56 fa ff ff       	call   8011d1 <sys_page_map>
  80177b:	89 c3                	mov    %eax,%ebx
  80177d:	83 c4 20             	add    $0x20,%esp
  801780:	85 c0                	test   %eax,%eax
  801782:	79 a3                	jns    801727 <dup+0x74>
	sys_page_unmap(0, newfd);
  801784:	83 ec 08             	sub    $0x8,%esp
  801787:	56                   	push   %esi
  801788:	6a 00                	push   $0x0
  80178a:	e8 84 fa ff ff       	call   801213 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80178f:	83 c4 08             	add    $0x8,%esp
  801792:	57                   	push   %edi
  801793:	6a 00                	push   $0x0
  801795:	e8 79 fa ff ff       	call   801213 <sys_page_unmap>
	return r;
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	eb b7                	jmp    801756 <dup+0xa3>

0080179f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	53                   	push   %ebx
  8017a3:	83 ec 1c             	sub    $0x1c,%esp
  8017a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ac:	50                   	push   %eax
  8017ad:	53                   	push   %ebx
  8017ae:	e8 7c fd ff ff       	call   80152f <fd_lookup>
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	78 3f                	js     8017f9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ba:	83 ec 08             	sub    $0x8,%esp
  8017bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c0:	50                   	push   %eax
  8017c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c4:	ff 30                	pushl  (%eax)
  8017c6:	e8 b4 fd ff ff       	call   80157f <dev_lookup>
  8017cb:	83 c4 10             	add    $0x10,%esp
  8017ce:	85 c0                	test   %eax,%eax
  8017d0:	78 27                	js     8017f9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d5:	8b 42 08             	mov    0x8(%edx),%eax
  8017d8:	83 e0 03             	and    $0x3,%eax
  8017db:	83 f8 01             	cmp    $0x1,%eax
  8017de:	74 1e                	je     8017fe <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e3:	8b 40 08             	mov    0x8(%eax),%eax
  8017e6:	85 c0                	test   %eax,%eax
  8017e8:	74 35                	je     80181f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017ea:	83 ec 04             	sub    $0x4,%esp
  8017ed:	ff 75 10             	pushl  0x10(%ebp)
  8017f0:	ff 75 0c             	pushl  0xc(%ebp)
  8017f3:	52                   	push   %edx
  8017f4:	ff d0                	call   *%eax
  8017f6:	83 c4 10             	add    $0x10,%esp
}
  8017f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017fe:	a1 08 50 80 00       	mov    0x805008,%eax
  801803:	8b 40 48             	mov    0x48(%eax),%eax
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	53                   	push   %ebx
  80180a:	50                   	push   %eax
  80180b:	68 6c 30 80 00       	push   $0x80306c
  801810:	e8 ab ef ff ff       	call   8007c0 <cprintf>
		return -E_INVAL;
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80181d:	eb da                	jmp    8017f9 <read+0x5a>
		return -E_NOT_SUPP;
  80181f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801824:	eb d3                	jmp    8017f9 <read+0x5a>

00801826 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	57                   	push   %edi
  80182a:	56                   	push   %esi
  80182b:	53                   	push   %ebx
  80182c:	83 ec 0c             	sub    $0xc,%esp
  80182f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801832:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801835:	bb 00 00 00 00       	mov    $0x0,%ebx
  80183a:	39 f3                	cmp    %esi,%ebx
  80183c:	73 23                	jae    801861 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80183e:	83 ec 04             	sub    $0x4,%esp
  801841:	89 f0                	mov    %esi,%eax
  801843:	29 d8                	sub    %ebx,%eax
  801845:	50                   	push   %eax
  801846:	89 d8                	mov    %ebx,%eax
  801848:	03 45 0c             	add    0xc(%ebp),%eax
  80184b:	50                   	push   %eax
  80184c:	57                   	push   %edi
  80184d:	e8 4d ff ff ff       	call   80179f <read>
		if (m < 0)
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	85 c0                	test   %eax,%eax
  801857:	78 06                	js     80185f <readn+0x39>
			return m;
		if (m == 0)
  801859:	74 06                	je     801861 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80185b:	01 c3                	add    %eax,%ebx
  80185d:	eb db                	jmp    80183a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80185f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801861:	89 d8                	mov    %ebx,%eax
  801863:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801866:	5b                   	pop    %ebx
  801867:	5e                   	pop    %esi
  801868:	5f                   	pop    %edi
  801869:	5d                   	pop    %ebp
  80186a:	c3                   	ret    

0080186b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	53                   	push   %ebx
  80186f:	83 ec 1c             	sub    $0x1c,%esp
  801872:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801875:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801878:	50                   	push   %eax
  801879:	53                   	push   %ebx
  80187a:	e8 b0 fc ff ff       	call   80152f <fd_lookup>
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	85 c0                	test   %eax,%eax
  801884:	78 3a                	js     8018c0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801886:	83 ec 08             	sub    $0x8,%esp
  801889:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188c:	50                   	push   %eax
  80188d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801890:	ff 30                	pushl  (%eax)
  801892:	e8 e8 fc ff ff       	call   80157f <dev_lookup>
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	85 c0                	test   %eax,%eax
  80189c:	78 22                	js     8018c0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80189e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018a5:	74 1e                	je     8018c5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018aa:	8b 52 0c             	mov    0xc(%edx),%edx
  8018ad:	85 d2                	test   %edx,%edx
  8018af:	74 35                	je     8018e6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018b1:	83 ec 04             	sub    $0x4,%esp
  8018b4:	ff 75 10             	pushl  0x10(%ebp)
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	50                   	push   %eax
  8018bb:	ff d2                	call   *%edx
  8018bd:	83 c4 10             	add    $0x10,%esp
}
  8018c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018c5:	a1 08 50 80 00       	mov    0x805008,%eax
  8018ca:	8b 40 48             	mov    0x48(%eax),%eax
  8018cd:	83 ec 04             	sub    $0x4,%esp
  8018d0:	53                   	push   %ebx
  8018d1:	50                   	push   %eax
  8018d2:	68 88 30 80 00       	push   $0x803088
  8018d7:	e8 e4 ee ff ff       	call   8007c0 <cprintf>
		return -E_INVAL;
  8018dc:	83 c4 10             	add    $0x10,%esp
  8018df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018e4:	eb da                	jmp    8018c0 <write+0x55>
		return -E_NOT_SUPP;
  8018e6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018eb:	eb d3                	jmp    8018c0 <write+0x55>

008018ed <seek>:

int
seek(int fdnum, off_t offset)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f6:	50                   	push   %eax
  8018f7:	ff 75 08             	pushl  0x8(%ebp)
  8018fa:	e8 30 fc ff ff       	call   80152f <fd_lookup>
  8018ff:	83 c4 10             	add    $0x10,%esp
  801902:	85 c0                	test   %eax,%eax
  801904:	78 0e                	js     801914 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801906:	8b 55 0c             	mov    0xc(%ebp),%edx
  801909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80190f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	53                   	push   %ebx
  80191a:	83 ec 1c             	sub    $0x1c,%esp
  80191d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801920:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801923:	50                   	push   %eax
  801924:	53                   	push   %ebx
  801925:	e8 05 fc ff ff       	call   80152f <fd_lookup>
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	85 c0                	test   %eax,%eax
  80192f:	78 37                	js     801968 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801931:	83 ec 08             	sub    $0x8,%esp
  801934:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801937:	50                   	push   %eax
  801938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193b:	ff 30                	pushl  (%eax)
  80193d:	e8 3d fc ff ff       	call   80157f <dev_lookup>
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	85 c0                	test   %eax,%eax
  801947:	78 1f                	js     801968 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801950:	74 1b                	je     80196d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801952:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801955:	8b 52 18             	mov    0x18(%edx),%edx
  801958:	85 d2                	test   %edx,%edx
  80195a:	74 32                	je     80198e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80195c:	83 ec 08             	sub    $0x8,%esp
  80195f:	ff 75 0c             	pushl  0xc(%ebp)
  801962:	50                   	push   %eax
  801963:	ff d2                	call   *%edx
  801965:	83 c4 10             	add    $0x10,%esp
}
  801968:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80196d:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801972:	8b 40 48             	mov    0x48(%eax),%eax
  801975:	83 ec 04             	sub    $0x4,%esp
  801978:	53                   	push   %ebx
  801979:	50                   	push   %eax
  80197a:	68 48 30 80 00       	push   $0x803048
  80197f:	e8 3c ee ff ff       	call   8007c0 <cprintf>
		return -E_INVAL;
  801984:	83 c4 10             	add    $0x10,%esp
  801987:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80198c:	eb da                	jmp    801968 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80198e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801993:	eb d3                	jmp    801968 <ftruncate+0x52>

00801995 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	53                   	push   %ebx
  801999:	83 ec 1c             	sub    $0x1c,%esp
  80199c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80199f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a2:	50                   	push   %eax
  8019a3:	ff 75 08             	pushl  0x8(%ebp)
  8019a6:	e8 84 fb ff ff       	call   80152f <fd_lookup>
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	78 4b                	js     8019fd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b2:	83 ec 08             	sub    $0x8,%esp
  8019b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b8:	50                   	push   %eax
  8019b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bc:	ff 30                	pushl  (%eax)
  8019be:	e8 bc fb ff ff       	call   80157f <dev_lookup>
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	78 33                	js     8019fd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8019ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019d1:	74 2f                	je     801a02 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019d3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019d6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019dd:	00 00 00 
	stat->st_isdir = 0;
  8019e0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019e7:	00 00 00 
	stat->st_dev = dev;
  8019ea:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019f0:	83 ec 08             	sub    $0x8,%esp
  8019f3:	53                   	push   %ebx
  8019f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f7:	ff 50 14             	call   *0x14(%eax)
  8019fa:	83 c4 10             	add    $0x10,%esp
}
  8019fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    
		return -E_NOT_SUPP;
  801a02:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a07:	eb f4                	jmp    8019fd <fstat+0x68>

00801a09 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	56                   	push   %esi
  801a0d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a0e:	83 ec 08             	sub    $0x8,%esp
  801a11:	6a 00                	push   $0x0
  801a13:	ff 75 08             	pushl  0x8(%ebp)
  801a16:	e8 2f 02 00 00       	call   801c4a <open>
  801a1b:	89 c3                	mov    %eax,%ebx
  801a1d:	83 c4 10             	add    $0x10,%esp
  801a20:	85 c0                	test   %eax,%eax
  801a22:	78 1b                	js     801a3f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a24:	83 ec 08             	sub    $0x8,%esp
  801a27:	ff 75 0c             	pushl  0xc(%ebp)
  801a2a:	50                   	push   %eax
  801a2b:	e8 65 ff ff ff       	call   801995 <fstat>
  801a30:	89 c6                	mov    %eax,%esi
	close(fd);
  801a32:	89 1c 24             	mov    %ebx,(%esp)
  801a35:	e8 27 fc ff ff       	call   801661 <close>
	return r;
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	89 f3                	mov    %esi,%ebx
}
  801a3f:	89 d8                	mov    %ebx,%eax
  801a41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a44:	5b                   	pop    %ebx
  801a45:	5e                   	pop    %esi
  801a46:	5d                   	pop    %ebp
  801a47:	c3                   	ret    

00801a48 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
  801a4d:	89 c6                	mov    %eax,%esi
  801a4f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a51:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a58:	74 27                	je     801a81 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a5a:	6a 07                	push   $0x7
  801a5c:	68 00 60 80 00       	push   $0x806000
  801a61:	56                   	push   %esi
  801a62:	ff 35 00 50 80 00    	pushl  0x805000
  801a68:	e8 a4 f9 ff ff       	call   801411 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a6d:	83 c4 0c             	add    $0xc,%esp
  801a70:	6a 00                	push   $0x0
  801a72:	53                   	push   %ebx
  801a73:	6a 00                	push   $0x0
  801a75:	e8 24 f9 ff ff       	call   80139e <ipc_recv>
}
  801a7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a7d:	5b                   	pop    %ebx
  801a7e:	5e                   	pop    %esi
  801a7f:	5d                   	pop    %ebp
  801a80:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a81:	83 ec 0c             	sub    $0xc,%esp
  801a84:	6a 01                	push   $0x1
  801a86:	e8 f2 f9 ff ff       	call   80147d <ipc_find_env>
  801a8b:	a3 00 50 80 00       	mov    %eax,0x805000
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	eb c5                	jmp    801a5a <fsipc+0x12>

00801a95 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa9:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801aae:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab3:	b8 02 00 00 00       	mov    $0x2,%eax
  801ab8:	e8 8b ff ff ff       	call   801a48 <fsipc>
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <devfile_flush>:
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	8b 40 0c             	mov    0xc(%eax),%eax
  801acb:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ad0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad5:	b8 06 00 00 00       	mov    $0x6,%eax
  801ada:	e8 69 ff ff ff       	call   801a48 <fsipc>
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <devfile_stat>:
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	53                   	push   %ebx
  801ae5:	83 ec 04             	sub    $0x4,%esp
  801ae8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	8b 40 0c             	mov    0xc(%eax),%eax
  801af1:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801af6:	ba 00 00 00 00       	mov    $0x0,%edx
  801afb:	b8 05 00 00 00       	mov    $0x5,%eax
  801b00:	e8 43 ff ff ff       	call   801a48 <fsipc>
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 2c                	js     801b35 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b09:	83 ec 08             	sub    $0x8,%esp
  801b0c:	68 00 60 80 00       	push   $0x806000
  801b11:	53                   	push   %ebx
  801b12:	e8 85 f2 ff ff       	call   800d9c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b17:	a1 80 60 80 00       	mov    0x806080,%eax
  801b1c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b22:	a1 84 60 80 00       	mov    0x806084,%eax
  801b27:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b2d:	83 c4 10             	add    $0x10,%esp
  801b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <devfile_write>:
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	53                   	push   %ebx
  801b3e:	83 ec 04             	sub    $0x4,%esp
  801b41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801b44:	85 db                	test   %ebx,%ebx
  801b46:	75 07                	jne    801b4f <devfile_write+0x15>
	return n_all;
  801b48:	89 d8                	mov    %ebx,%eax
}
  801b4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	8b 40 0c             	mov    0xc(%eax),%eax
  801b55:	a3 00 60 80 00       	mov    %eax,0x806000
	  fsipcbuf.write.req_n = n_left;
  801b5a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	53                   	push   %ebx
  801b64:	ff 75 0c             	pushl  0xc(%ebp)
  801b67:	68 08 60 80 00       	push   $0x806008
  801b6c:	e8 b9 f3 ff ff       	call   800f2a <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b71:	ba 00 00 00 00       	mov    $0x0,%edx
  801b76:	b8 04 00 00 00       	mov    $0x4,%eax
  801b7b:	e8 c8 fe ff ff       	call   801a48 <fsipc>
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	85 c0                	test   %eax,%eax
  801b85:	78 c3                	js     801b4a <devfile_write+0x10>
	  assert(r <= n_left);
  801b87:	39 d8                	cmp    %ebx,%eax
  801b89:	77 0b                	ja     801b96 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801b8b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b90:	7f 1d                	jg     801baf <devfile_write+0x75>
    n_all += r;
  801b92:	89 c3                	mov    %eax,%ebx
  801b94:	eb b2                	jmp    801b48 <devfile_write+0xe>
	  assert(r <= n_left);
  801b96:	68 bc 30 80 00       	push   $0x8030bc
  801b9b:	68 c8 30 80 00       	push   $0x8030c8
  801ba0:	68 9f 00 00 00       	push   $0x9f
  801ba5:	68 dd 30 80 00       	push   $0x8030dd
  801baa:	e8 36 eb ff ff       	call   8006e5 <_panic>
	  assert(r <= PGSIZE);
  801baf:	68 e8 30 80 00       	push   $0x8030e8
  801bb4:	68 c8 30 80 00       	push   $0x8030c8
  801bb9:	68 a0 00 00 00       	push   $0xa0
  801bbe:	68 dd 30 80 00       	push   $0x8030dd
  801bc3:	e8 1d eb ff ff       	call   8006e5 <_panic>

00801bc8 <devfile_read>:
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	56                   	push   %esi
  801bcc:	53                   	push   %ebx
  801bcd:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd6:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801bdb:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801be1:	ba 00 00 00 00       	mov    $0x0,%edx
  801be6:	b8 03 00 00 00       	mov    $0x3,%eax
  801beb:	e8 58 fe ff ff       	call   801a48 <fsipc>
  801bf0:	89 c3                	mov    %eax,%ebx
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	78 1f                	js     801c15 <devfile_read+0x4d>
	assert(r <= n);
  801bf6:	39 f0                	cmp    %esi,%eax
  801bf8:	77 24                	ja     801c1e <devfile_read+0x56>
	assert(r <= PGSIZE);
  801bfa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bff:	7f 33                	jg     801c34 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c01:	83 ec 04             	sub    $0x4,%esp
  801c04:	50                   	push   %eax
  801c05:	68 00 60 80 00       	push   $0x806000
  801c0a:	ff 75 0c             	pushl  0xc(%ebp)
  801c0d:	e8 18 f3 ff ff       	call   800f2a <memmove>
	return r;
  801c12:	83 c4 10             	add    $0x10,%esp
}
  801c15:	89 d8                	mov    %ebx,%eax
  801c17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1a:	5b                   	pop    %ebx
  801c1b:	5e                   	pop    %esi
  801c1c:	5d                   	pop    %ebp
  801c1d:	c3                   	ret    
	assert(r <= n);
  801c1e:	68 f4 30 80 00       	push   $0x8030f4
  801c23:	68 c8 30 80 00       	push   $0x8030c8
  801c28:	6a 7c                	push   $0x7c
  801c2a:	68 dd 30 80 00       	push   $0x8030dd
  801c2f:	e8 b1 ea ff ff       	call   8006e5 <_panic>
	assert(r <= PGSIZE);
  801c34:	68 e8 30 80 00       	push   $0x8030e8
  801c39:	68 c8 30 80 00       	push   $0x8030c8
  801c3e:	6a 7d                	push   $0x7d
  801c40:	68 dd 30 80 00       	push   $0x8030dd
  801c45:	e8 9b ea ff ff       	call   8006e5 <_panic>

00801c4a <open>:
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	56                   	push   %esi
  801c4e:	53                   	push   %ebx
  801c4f:	83 ec 1c             	sub    $0x1c,%esp
  801c52:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c55:	56                   	push   %esi
  801c56:	e8 08 f1 ff ff       	call   800d63 <strlen>
  801c5b:	83 c4 10             	add    $0x10,%esp
  801c5e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c63:	7f 6c                	jg     801cd1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c65:	83 ec 0c             	sub    $0xc,%esp
  801c68:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c6b:	50                   	push   %eax
  801c6c:	e8 6c f8 ff ff       	call   8014dd <fd_alloc>
  801c71:	89 c3                	mov    %eax,%ebx
  801c73:	83 c4 10             	add    $0x10,%esp
  801c76:	85 c0                	test   %eax,%eax
  801c78:	78 3c                	js     801cb6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c7a:	83 ec 08             	sub    $0x8,%esp
  801c7d:	56                   	push   %esi
  801c7e:	68 00 60 80 00       	push   $0x806000
  801c83:	e8 14 f1 ff ff       	call   800d9c <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8b:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c93:	b8 01 00 00 00       	mov    $0x1,%eax
  801c98:	e8 ab fd ff ff       	call   801a48 <fsipc>
  801c9d:	89 c3                	mov    %eax,%ebx
  801c9f:	83 c4 10             	add    $0x10,%esp
  801ca2:	85 c0                	test   %eax,%eax
  801ca4:	78 19                	js     801cbf <open+0x75>
	return fd2num(fd);
  801ca6:	83 ec 0c             	sub    $0xc,%esp
  801ca9:	ff 75 f4             	pushl  -0xc(%ebp)
  801cac:	e8 05 f8 ff ff       	call   8014b6 <fd2num>
  801cb1:	89 c3                	mov    %eax,%ebx
  801cb3:	83 c4 10             	add    $0x10,%esp
}
  801cb6:	89 d8                	mov    %ebx,%eax
  801cb8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cbb:	5b                   	pop    %ebx
  801cbc:	5e                   	pop    %esi
  801cbd:	5d                   	pop    %ebp
  801cbe:	c3                   	ret    
		fd_close(fd, 0);
  801cbf:	83 ec 08             	sub    $0x8,%esp
  801cc2:	6a 00                	push   $0x0
  801cc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc7:	e8 0e f9 ff ff       	call   8015da <fd_close>
		return r;
  801ccc:	83 c4 10             	add    $0x10,%esp
  801ccf:	eb e5                	jmp    801cb6 <open+0x6c>
		return -E_BAD_PATH;
  801cd1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cd6:	eb de                	jmp    801cb6 <open+0x6c>

00801cd8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cde:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce3:	b8 08 00 00 00       	mov    $0x8,%eax
  801ce8:	e8 5b fd ff ff       	call   801a48 <fsipc>
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	56                   	push   %esi
  801cf3:	53                   	push   %ebx
  801cf4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cf7:	83 ec 0c             	sub    $0xc,%esp
  801cfa:	ff 75 08             	pushl  0x8(%ebp)
  801cfd:	e8 c4 f7 ff ff       	call   8014c6 <fd2data>
  801d02:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d04:	83 c4 08             	add    $0x8,%esp
  801d07:	68 fb 30 80 00       	push   $0x8030fb
  801d0c:	53                   	push   %ebx
  801d0d:	e8 8a f0 ff ff       	call   800d9c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d12:	8b 46 04             	mov    0x4(%esi),%eax
  801d15:	2b 06                	sub    (%esi),%eax
  801d17:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d1d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d24:	00 00 00 
	stat->st_dev = &devpipe;
  801d27:	c7 83 88 00 00 00 24 	movl   $0x804024,0x88(%ebx)
  801d2e:	40 80 00 
	return 0;
}
  801d31:	b8 00 00 00 00       	mov    $0x0,%eax
  801d36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d39:	5b                   	pop    %ebx
  801d3a:	5e                   	pop    %esi
  801d3b:	5d                   	pop    %ebp
  801d3c:	c3                   	ret    

00801d3d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	53                   	push   %ebx
  801d41:	83 ec 0c             	sub    $0xc,%esp
  801d44:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d47:	53                   	push   %ebx
  801d48:	6a 00                	push   $0x0
  801d4a:	e8 c4 f4 ff ff       	call   801213 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d4f:	89 1c 24             	mov    %ebx,(%esp)
  801d52:	e8 6f f7 ff ff       	call   8014c6 <fd2data>
  801d57:	83 c4 08             	add    $0x8,%esp
  801d5a:	50                   	push   %eax
  801d5b:	6a 00                	push   $0x0
  801d5d:	e8 b1 f4 ff ff       	call   801213 <sys_page_unmap>
}
  801d62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <_pipeisclosed>:
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	57                   	push   %edi
  801d6b:	56                   	push   %esi
  801d6c:	53                   	push   %ebx
  801d6d:	83 ec 1c             	sub    $0x1c,%esp
  801d70:	89 c7                	mov    %eax,%edi
  801d72:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d74:	a1 08 50 80 00       	mov    0x805008,%eax
  801d79:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d7c:	83 ec 0c             	sub    $0xc,%esp
  801d7f:	57                   	push   %edi
  801d80:	e8 94 08 00 00       	call   802619 <pageref>
  801d85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d88:	89 34 24             	mov    %esi,(%esp)
  801d8b:	e8 89 08 00 00       	call   802619 <pageref>
		nn = thisenv->env_runs;
  801d90:	8b 15 08 50 80 00    	mov    0x805008,%edx
  801d96:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d99:	83 c4 10             	add    $0x10,%esp
  801d9c:	39 cb                	cmp    %ecx,%ebx
  801d9e:	74 1b                	je     801dbb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801da0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801da3:	75 cf                	jne    801d74 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801da5:	8b 42 58             	mov    0x58(%edx),%eax
  801da8:	6a 01                	push   $0x1
  801daa:	50                   	push   %eax
  801dab:	53                   	push   %ebx
  801dac:	68 02 31 80 00       	push   $0x803102
  801db1:	e8 0a ea ff ff       	call   8007c0 <cprintf>
  801db6:	83 c4 10             	add    $0x10,%esp
  801db9:	eb b9                	jmp    801d74 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dbb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dbe:	0f 94 c0             	sete   %al
  801dc1:	0f b6 c0             	movzbl %al,%eax
}
  801dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5f                   	pop    %edi
  801dca:	5d                   	pop    %ebp
  801dcb:	c3                   	ret    

00801dcc <devpipe_write>:
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	57                   	push   %edi
  801dd0:	56                   	push   %esi
  801dd1:	53                   	push   %ebx
  801dd2:	83 ec 28             	sub    $0x28,%esp
  801dd5:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dd8:	56                   	push   %esi
  801dd9:	e8 e8 f6 ff ff       	call   8014c6 <fd2data>
  801dde:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801de0:	83 c4 10             	add    $0x10,%esp
  801de3:	bf 00 00 00 00       	mov    $0x0,%edi
  801de8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801deb:	74 4f                	je     801e3c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ded:	8b 43 04             	mov    0x4(%ebx),%eax
  801df0:	8b 0b                	mov    (%ebx),%ecx
  801df2:	8d 51 20             	lea    0x20(%ecx),%edx
  801df5:	39 d0                	cmp    %edx,%eax
  801df7:	72 14                	jb     801e0d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801df9:	89 da                	mov    %ebx,%edx
  801dfb:	89 f0                	mov    %esi,%eax
  801dfd:	e8 65 ff ff ff       	call   801d67 <_pipeisclosed>
  801e02:	85 c0                	test   %eax,%eax
  801e04:	75 3b                	jne    801e41 <devpipe_write+0x75>
			sys_yield();
  801e06:	e8 64 f3 ff ff       	call   80116f <sys_yield>
  801e0b:	eb e0                	jmp    801ded <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e10:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e14:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e17:	89 c2                	mov    %eax,%edx
  801e19:	c1 fa 1f             	sar    $0x1f,%edx
  801e1c:	89 d1                	mov    %edx,%ecx
  801e1e:	c1 e9 1b             	shr    $0x1b,%ecx
  801e21:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e24:	83 e2 1f             	and    $0x1f,%edx
  801e27:	29 ca                	sub    %ecx,%edx
  801e29:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e2d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e31:	83 c0 01             	add    $0x1,%eax
  801e34:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e37:	83 c7 01             	add    $0x1,%edi
  801e3a:	eb ac                	jmp    801de8 <devpipe_write+0x1c>
	return i;
  801e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3f:	eb 05                	jmp    801e46 <devpipe_write+0x7a>
				return 0;
  801e41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e49:	5b                   	pop    %ebx
  801e4a:	5e                   	pop    %esi
  801e4b:	5f                   	pop    %edi
  801e4c:	5d                   	pop    %ebp
  801e4d:	c3                   	ret    

00801e4e <devpipe_read>:
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	57                   	push   %edi
  801e52:	56                   	push   %esi
  801e53:	53                   	push   %ebx
  801e54:	83 ec 18             	sub    $0x18,%esp
  801e57:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e5a:	57                   	push   %edi
  801e5b:	e8 66 f6 ff ff       	call   8014c6 <fd2data>
  801e60:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e62:	83 c4 10             	add    $0x10,%esp
  801e65:	be 00 00 00 00       	mov    $0x0,%esi
  801e6a:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e6d:	75 14                	jne    801e83 <devpipe_read+0x35>
	return i;
  801e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e72:	eb 02                	jmp    801e76 <devpipe_read+0x28>
				return i;
  801e74:	89 f0                	mov    %esi,%eax
}
  801e76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e79:	5b                   	pop    %ebx
  801e7a:	5e                   	pop    %esi
  801e7b:	5f                   	pop    %edi
  801e7c:	5d                   	pop    %ebp
  801e7d:	c3                   	ret    
			sys_yield();
  801e7e:	e8 ec f2 ff ff       	call   80116f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e83:	8b 03                	mov    (%ebx),%eax
  801e85:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e88:	75 18                	jne    801ea2 <devpipe_read+0x54>
			if (i > 0)
  801e8a:	85 f6                	test   %esi,%esi
  801e8c:	75 e6                	jne    801e74 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e8e:	89 da                	mov    %ebx,%edx
  801e90:	89 f8                	mov    %edi,%eax
  801e92:	e8 d0 fe ff ff       	call   801d67 <_pipeisclosed>
  801e97:	85 c0                	test   %eax,%eax
  801e99:	74 e3                	je     801e7e <devpipe_read+0x30>
				return 0;
  801e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea0:	eb d4                	jmp    801e76 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ea2:	99                   	cltd   
  801ea3:	c1 ea 1b             	shr    $0x1b,%edx
  801ea6:	01 d0                	add    %edx,%eax
  801ea8:	83 e0 1f             	and    $0x1f,%eax
  801eab:	29 d0                	sub    %edx,%eax
  801ead:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801eb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eb5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801eb8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ebb:	83 c6 01             	add    $0x1,%esi
  801ebe:	eb aa                	jmp    801e6a <devpipe_read+0x1c>

00801ec0 <pipe>:
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	56                   	push   %esi
  801ec4:	53                   	push   %ebx
  801ec5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ec8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ecb:	50                   	push   %eax
  801ecc:	e8 0c f6 ff ff       	call   8014dd <fd_alloc>
  801ed1:	89 c3                	mov    %eax,%ebx
  801ed3:	83 c4 10             	add    $0x10,%esp
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	0f 88 23 01 00 00    	js     802001 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ede:	83 ec 04             	sub    $0x4,%esp
  801ee1:	68 07 04 00 00       	push   $0x407
  801ee6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee9:	6a 00                	push   $0x0
  801eeb:	e8 9e f2 ff ff       	call   80118e <sys_page_alloc>
  801ef0:	89 c3                	mov    %eax,%ebx
  801ef2:	83 c4 10             	add    $0x10,%esp
  801ef5:	85 c0                	test   %eax,%eax
  801ef7:	0f 88 04 01 00 00    	js     802001 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801efd:	83 ec 0c             	sub    $0xc,%esp
  801f00:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f03:	50                   	push   %eax
  801f04:	e8 d4 f5 ff ff       	call   8014dd <fd_alloc>
  801f09:	89 c3                	mov    %eax,%ebx
  801f0b:	83 c4 10             	add    $0x10,%esp
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	0f 88 db 00 00 00    	js     801ff1 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f16:	83 ec 04             	sub    $0x4,%esp
  801f19:	68 07 04 00 00       	push   $0x407
  801f1e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f21:	6a 00                	push   $0x0
  801f23:	e8 66 f2 ff ff       	call   80118e <sys_page_alloc>
  801f28:	89 c3                	mov    %eax,%ebx
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	0f 88 bc 00 00 00    	js     801ff1 <pipe+0x131>
	va = fd2data(fd0);
  801f35:	83 ec 0c             	sub    $0xc,%esp
  801f38:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3b:	e8 86 f5 ff ff       	call   8014c6 <fd2data>
  801f40:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f42:	83 c4 0c             	add    $0xc,%esp
  801f45:	68 07 04 00 00       	push   $0x407
  801f4a:	50                   	push   %eax
  801f4b:	6a 00                	push   $0x0
  801f4d:	e8 3c f2 ff ff       	call   80118e <sys_page_alloc>
  801f52:	89 c3                	mov    %eax,%ebx
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	85 c0                	test   %eax,%eax
  801f59:	0f 88 82 00 00 00    	js     801fe1 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	ff 75 f0             	pushl  -0x10(%ebp)
  801f65:	e8 5c f5 ff ff       	call   8014c6 <fd2data>
  801f6a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f71:	50                   	push   %eax
  801f72:	6a 00                	push   $0x0
  801f74:	56                   	push   %esi
  801f75:	6a 00                	push   $0x0
  801f77:	e8 55 f2 ff ff       	call   8011d1 <sys_page_map>
  801f7c:	89 c3                	mov    %eax,%ebx
  801f7e:	83 c4 20             	add    $0x20,%esp
  801f81:	85 c0                	test   %eax,%eax
  801f83:	78 4e                	js     801fd3 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f85:	a1 24 40 80 00       	mov    0x804024,%eax
  801f8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f92:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f9c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fa8:	83 ec 0c             	sub    $0xc,%esp
  801fab:	ff 75 f4             	pushl  -0xc(%ebp)
  801fae:	e8 03 f5 ff ff       	call   8014b6 <fd2num>
  801fb3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fb8:	83 c4 04             	add    $0x4,%esp
  801fbb:	ff 75 f0             	pushl  -0x10(%ebp)
  801fbe:	e8 f3 f4 ff ff       	call   8014b6 <fd2num>
  801fc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fc9:	83 c4 10             	add    $0x10,%esp
  801fcc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fd1:	eb 2e                	jmp    802001 <pipe+0x141>
	sys_page_unmap(0, va);
  801fd3:	83 ec 08             	sub    $0x8,%esp
  801fd6:	56                   	push   %esi
  801fd7:	6a 00                	push   $0x0
  801fd9:	e8 35 f2 ff ff       	call   801213 <sys_page_unmap>
  801fde:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fe1:	83 ec 08             	sub    $0x8,%esp
  801fe4:	ff 75 f0             	pushl  -0x10(%ebp)
  801fe7:	6a 00                	push   $0x0
  801fe9:	e8 25 f2 ff ff       	call   801213 <sys_page_unmap>
  801fee:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ff1:	83 ec 08             	sub    $0x8,%esp
  801ff4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff7:	6a 00                	push   $0x0
  801ff9:	e8 15 f2 ff ff       	call   801213 <sys_page_unmap>
  801ffe:	83 c4 10             	add    $0x10,%esp
}
  802001:	89 d8                	mov    %ebx,%eax
  802003:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802006:	5b                   	pop    %ebx
  802007:	5e                   	pop    %esi
  802008:	5d                   	pop    %ebp
  802009:	c3                   	ret    

0080200a <pipeisclosed>:
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802010:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802013:	50                   	push   %eax
  802014:	ff 75 08             	pushl  0x8(%ebp)
  802017:	e8 13 f5 ff ff       	call   80152f <fd_lookup>
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	85 c0                	test   %eax,%eax
  802021:	78 18                	js     80203b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802023:	83 ec 0c             	sub    $0xc,%esp
  802026:	ff 75 f4             	pushl  -0xc(%ebp)
  802029:	e8 98 f4 ff ff       	call   8014c6 <fd2data>
	return _pipeisclosed(fd, p);
  80202e:	89 c2                	mov    %eax,%edx
  802030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802033:	e8 2f fd ff ff       	call   801d67 <_pipeisclosed>
  802038:	83 c4 10             	add    $0x10,%esp
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802043:	68 1a 31 80 00       	push   $0x80311a
  802048:	ff 75 0c             	pushl  0xc(%ebp)
  80204b:	e8 4c ed ff ff       	call   800d9c <strcpy>
	return 0;
}
  802050:	b8 00 00 00 00       	mov    $0x0,%eax
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <devsock_close>:
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	53                   	push   %ebx
  80205b:	83 ec 10             	sub    $0x10,%esp
  80205e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802061:	53                   	push   %ebx
  802062:	e8 b2 05 00 00       	call   802619 <pageref>
  802067:	83 c4 10             	add    $0x10,%esp
		return 0;
  80206a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80206f:	83 f8 01             	cmp    $0x1,%eax
  802072:	74 07                	je     80207b <devsock_close+0x24>
}
  802074:	89 d0                	mov    %edx,%eax
  802076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802079:	c9                   	leave  
  80207a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80207b:	83 ec 0c             	sub    $0xc,%esp
  80207e:	ff 73 0c             	pushl  0xc(%ebx)
  802081:	e8 b9 02 00 00       	call   80233f <nsipc_close>
  802086:	89 c2                	mov    %eax,%edx
  802088:	83 c4 10             	add    $0x10,%esp
  80208b:	eb e7                	jmp    802074 <devsock_close+0x1d>

0080208d <devsock_write>:
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802093:	6a 00                	push   $0x0
  802095:	ff 75 10             	pushl  0x10(%ebp)
  802098:	ff 75 0c             	pushl  0xc(%ebp)
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	ff 70 0c             	pushl  0xc(%eax)
  8020a1:	e8 76 03 00 00       	call   80241c <nsipc_send>
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <devsock_read>:
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020ae:	6a 00                	push   $0x0
  8020b0:	ff 75 10             	pushl  0x10(%ebp)
  8020b3:	ff 75 0c             	pushl  0xc(%ebp)
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	ff 70 0c             	pushl  0xc(%eax)
  8020bc:	e8 ef 02 00 00       	call   8023b0 <nsipc_recv>
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <fd2sockid>:
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020c9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020cc:	52                   	push   %edx
  8020cd:	50                   	push   %eax
  8020ce:	e8 5c f4 ff ff       	call   80152f <fd_lookup>
  8020d3:	83 c4 10             	add    $0x10,%esp
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	78 10                	js     8020ea <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  8020e3:	39 08                	cmp    %ecx,(%eax)
  8020e5:	75 05                	jne    8020ec <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8020e7:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    
		return -E_NOT_SUPP;
  8020ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020f1:	eb f7                	jmp    8020ea <fd2sockid+0x27>

008020f3 <alloc_sockfd>:
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	56                   	push   %esi
  8020f7:	53                   	push   %ebx
  8020f8:	83 ec 1c             	sub    $0x1c,%esp
  8020fb:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8020fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802100:	50                   	push   %eax
  802101:	e8 d7 f3 ff ff       	call   8014dd <fd_alloc>
  802106:	89 c3                	mov    %eax,%ebx
  802108:	83 c4 10             	add    $0x10,%esp
  80210b:	85 c0                	test   %eax,%eax
  80210d:	78 43                	js     802152 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80210f:	83 ec 04             	sub    $0x4,%esp
  802112:	68 07 04 00 00       	push   $0x407
  802117:	ff 75 f4             	pushl  -0xc(%ebp)
  80211a:	6a 00                	push   $0x0
  80211c:	e8 6d f0 ff ff       	call   80118e <sys_page_alloc>
  802121:	89 c3                	mov    %eax,%ebx
  802123:	83 c4 10             	add    $0x10,%esp
  802126:	85 c0                	test   %eax,%eax
  802128:	78 28                	js     802152 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802133:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802138:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80213f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802142:	83 ec 0c             	sub    $0xc,%esp
  802145:	50                   	push   %eax
  802146:	e8 6b f3 ff ff       	call   8014b6 <fd2num>
  80214b:	89 c3                	mov    %eax,%ebx
  80214d:	83 c4 10             	add    $0x10,%esp
  802150:	eb 0c                	jmp    80215e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802152:	83 ec 0c             	sub    $0xc,%esp
  802155:	56                   	push   %esi
  802156:	e8 e4 01 00 00       	call   80233f <nsipc_close>
		return r;
  80215b:	83 c4 10             	add    $0x10,%esp
}
  80215e:	89 d8                	mov    %ebx,%eax
  802160:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802163:	5b                   	pop    %ebx
  802164:	5e                   	pop    %esi
  802165:	5d                   	pop    %ebp
  802166:	c3                   	ret    

00802167 <accept>:
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	e8 4e ff ff ff       	call   8020c3 <fd2sockid>
  802175:	85 c0                	test   %eax,%eax
  802177:	78 1b                	js     802194 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802179:	83 ec 04             	sub    $0x4,%esp
  80217c:	ff 75 10             	pushl  0x10(%ebp)
  80217f:	ff 75 0c             	pushl  0xc(%ebp)
  802182:	50                   	push   %eax
  802183:	e8 0e 01 00 00       	call   802296 <nsipc_accept>
  802188:	83 c4 10             	add    $0x10,%esp
  80218b:	85 c0                	test   %eax,%eax
  80218d:	78 05                	js     802194 <accept+0x2d>
	return alloc_sockfd(r);
  80218f:	e8 5f ff ff ff       	call   8020f3 <alloc_sockfd>
}
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <bind>:
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
  802199:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	e8 1f ff ff ff       	call   8020c3 <fd2sockid>
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	78 12                	js     8021ba <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8021a8:	83 ec 04             	sub    $0x4,%esp
  8021ab:	ff 75 10             	pushl  0x10(%ebp)
  8021ae:	ff 75 0c             	pushl  0xc(%ebp)
  8021b1:	50                   	push   %eax
  8021b2:	e8 31 01 00 00       	call   8022e8 <nsipc_bind>
  8021b7:	83 c4 10             	add    $0x10,%esp
}
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <shutdown>:
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	e8 f9 fe ff ff       	call   8020c3 <fd2sockid>
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	78 0f                	js     8021dd <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8021ce:	83 ec 08             	sub    $0x8,%esp
  8021d1:	ff 75 0c             	pushl  0xc(%ebp)
  8021d4:	50                   	push   %eax
  8021d5:	e8 43 01 00 00       	call   80231d <nsipc_shutdown>
  8021da:	83 c4 10             	add    $0x10,%esp
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <connect>:
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	e8 d6 fe ff ff       	call   8020c3 <fd2sockid>
  8021ed:	85 c0                	test   %eax,%eax
  8021ef:	78 12                	js     802203 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8021f1:	83 ec 04             	sub    $0x4,%esp
  8021f4:	ff 75 10             	pushl  0x10(%ebp)
  8021f7:	ff 75 0c             	pushl  0xc(%ebp)
  8021fa:	50                   	push   %eax
  8021fb:	e8 59 01 00 00       	call   802359 <nsipc_connect>
  802200:	83 c4 10             	add    $0x10,%esp
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <listen>:
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	e8 b0 fe ff ff       	call   8020c3 <fd2sockid>
  802213:	85 c0                	test   %eax,%eax
  802215:	78 0f                	js     802226 <listen+0x21>
	return nsipc_listen(r, backlog);
  802217:	83 ec 08             	sub    $0x8,%esp
  80221a:	ff 75 0c             	pushl  0xc(%ebp)
  80221d:	50                   	push   %eax
  80221e:	e8 6b 01 00 00       	call   80238e <nsipc_listen>
  802223:	83 c4 10             	add    $0x10,%esp
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <socket>:

int
socket(int domain, int type, int protocol)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80222e:	ff 75 10             	pushl  0x10(%ebp)
  802231:	ff 75 0c             	pushl  0xc(%ebp)
  802234:	ff 75 08             	pushl  0x8(%ebp)
  802237:	e8 3e 02 00 00       	call   80247a <nsipc_socket>
  80223c:	83 c4 10             	add    $0x10,%esp
  80223f:	85 c0                	test   %eax,%eax
  802241:	78 05                	js     802248 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802243:	e8 ab fe ff ff       	call   8020f3 <alloc_sockfd>
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	53                   	push   %ebx
  80224e:	83 ec 04             	sub    $0x4,%esp
  802251:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802253:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80225a:	74 26                	je     802282 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80225c:	6a 07                	push   $0x7
  80225e:	68 00 70 80 00       	push   $0x807000
  802263:	53                   	push   %ebx
  802264:	ff 35 04 50 80 00    	pushl  0x805004
  80226a:	e8 a2 f1 ff ff       	call   801411 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80226f:	83 c4 0c             	add    $0xc,%esp
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	e8 21 f1 ff ff       	call   80139e <ipc_recv>
}
  80227d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802280:	c9                   	leave  
  802281:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802282:	83 ec 0c             	sub    $0xc,%esp
  802285:	6a 02                	push   $0x2
  802287:	e8 f1 f1 ff ff       	call   80147d <ipc_find_env>
  80228c:	a3 04 50 80 00       	mov    %eax,0x805004
  802291:	83 c4 10             	add    $0x10,%esp
  802294:	eb c6                	jmp    80225c <nsipc+0x12>

00802296 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	56                   	push   %esi
  80229a:	53                   	push   %ebx
  80229b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022a6:	8b 06                	mov    (%esi),%eax
  8022a8:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b2:	e8 93 ff ff ff       	call   80224a <nsipc>
  8022b7:	89 c3                	mov    %eax,%ebx
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	79 09                	jns    8022c6 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8022bd:	89 d8                	mov    %ebx,%eax
  8022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022c2:	5b                   	pop    %ebx
  8022c3:	5e                   	pop    %esi
  8022c4:	5d                   	pop    %ebp
  8022c5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022c6:	83 ec 04             	sub    $0x4,%esp
  8022c9:	ff 35 10 70 80 00    	pushl  0x807010
  8022cf:	68 00 70 80 00       	push   $0x807000
  8022d4:	ff 75 0c             	pushl  0xc(%ebp)
  8022d7:	e8 4e ec ff ff       	call   800f2a <memmove>
		*addrlen = ret->ret_addrlen;
  8022dc:	a1 10 70 80 00       	mov    0x807010,%eax
  8022e1:	89 06                	mov    %eax,(%esi)
  8022e3:	83 c4 10             	add    $0x10,%esp
	return r;
  8022e6:	eb d5                	jmp    8022bd <nsipc_accept+0x27>

008022e8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	53                   	push   %ebx
  8022ec:	83 ec 08             	sub    $0x8,%esp
  8022ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022fa:	53                   	push   %ebx
  8022fb:	ff 75 0c             	pushl  0xc(%ebp)
  8022fe:	68 04 70 80 00       	push   $0x807004
  802303:	e8 22 ec ff ff       	call   800f2a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802308:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80230e:	b8 02 00 00 00       	mov    $0x2,%eax
  802313:	e8 32 ff ff ff       	call   80224a <nsipc>
}
  802318:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80232b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802333:	b8 03 00 00 00       	mov    $0x3,%eax
  802338:	e8 0d ff ff ff       	call   80224a <nsipc>
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <nsipc_close>:

int
nsipc_close(int s)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80234d:	b8 04 00 00 00       	mov    $0x4,%eax
  802352:	e8 f3 fe ff ff       	call   80224a <nsipc>
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	53                   	push   %ebx
  80235d:	83 ec 08             	sub    $0x8,%esp
  802360:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80236b:	53                   	push   %ebx
  80236c:	ff 75 0c             	pushl  0xc(%ebp)
  80236f:	68 04 70 80 00       	push   $0x807004
  802374:	e8 b1 eb ff ff       	call   800f2a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802379:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80237f:	b8 05 00 00 00       	mov    $0x5,%eax
  802384:	e8 c1 fe ff ff       	call   80224a <nsipc>
}
  802389:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80239c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023a4:	b8 06 00 00 00       	mov    $0x6,%eax
  8023a9:	e8 9c fe ff ff       	call   80224a <nsipc>
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	56                   	push   %esi
  8023b4:	53                   	push   %ebx
  8023b5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8023c0:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8023c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c9:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023ce:	b8 07 00 00 00       	mov    $0x7,%eax
  8023d3:	e8 72 fe ff ff       	call   80224a <nsipc>
  8023d8:	89 c3                	mov    %eax,%ebx
  8023da:	85 c0                	test   %eax,%eax
  8023dc:	78 1f                	js     8023fd <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8023de:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023e3:	7f 21                	jg     802406 <nsipc_recv+0x56>
  8023e5:	39 c6                	cmp    %eax,%esi
  8023e7:	7c 1d                	jl     802406 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023e9:	83 ec 04             	sub    $0x4,%esp
  8023ec:	50                   	push   %eax
  8023ed:	68 00 70 80 00       	push   $0x807000
  8023f2:	ff 75 0c             	pushl  0xc(%ebp)
  8023f5:	e8 30 eb ff ff       	call   800f2a <memmove>
  8023fa:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8023fd:	89 d8                	mov    %ebx,%eax
  8023ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802402:	5b                   	pop    %ebx
  802403:	5e                   	pop    %esi
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802406:	68 26 31 80 00       	push   $0x803126
  80240b:	68 c8 30 80 00       	push   $0x8030c8
  802410:	6a 62                	push   $0x62
  802412:	68 3b 31 80 00       	push   $0x80313b
  802417:	e8 c9 e2 ff ff       	call   8006e5 <_panic>

0080241c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
  80241f:	53                   	push   %ebx
  802420:	83 ec 04             	sub    $0x4,%esp
  802423:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80242e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802434:	7f 2e                	jg     802464 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802436:	83 ec 04             	sub    $0x4,%esp
  802439:	53                   	push   %ebx
  80243a:	ff 75 0c             	pushl  0xc(%ebp)
  80243d:	68 0c 70 80 00       	push   $0x80700c
  802442:	e8 e3 ea ff ff       	call   800f2a <memmove>
	nsipcbuf.send.req_size = size;
  802447:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80244d:	8b 45 14             	mov    0x14(%ebp),%eax
  802450:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802455:	b8 08 00 00 00       	mov    $0x8,%eax
  80245a:	e8 eb fd ff ff       	call   80224a <nsipc>
}
  80245f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802462:	c9                   	leave  
  802463:	c3                   	ret    
	assert(size < 1600);
  802464:	68 47 31 80 00       	push   $0x803147
  802469:	68 c8 30 80 00       	push   $0x8030c8
  80246e:	6a 6d                	push   $0x6d
  802470:	68 3b 31 80 00       	push   $0x80313b
  802475:	e8 6b e2 ff ff       	call   8006e5 <_panic>

0080247a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248b:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802490:	8b 45 10             	mov    0x10(%ebp),%eax
  802493:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802498:	b8 09 00 00 00       	mov    $0x9,%eax
  80249d:	e8 a8 fd ff ff       	call   80224a <nsipc>
}
  8024a2:	c9                   	leave  
  8024a3:	c3                   	ret    

008024a4 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8024a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a9:	c3                   	ret    

008024aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024b0:	68 53 31 80 00       	push   $0x803153
  8024b5:	ff 75 0c             	pushl  0xc(%ebp)
  8024b8:	e8 df e8 ff ff       	call   800d9c <strcpy>
	return 0;
}
  8024bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <devcons_write>:
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	57                   	push   %edi
  8024c8:	56                   	push   %esi
  8024c9:	53                   	push   %ebx
  8024ca:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8024d0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8024d5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8024db:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024de:	73 31                	jae    802511 <devcons_write+0x4d>
		m = n - tot;
  8024e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024e3:	29 f3                	sub    %esi,%ebx
  8024e5:	83 fb 7f             	cmp    $0x7f,%ebx
  8024e8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8024ed:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8024f0:	83 ec 04             	sub    $0x4,%esp
  8024f3:	53                   	push   %ebx
  8024f4:	89 f0                	mov    %esi,%eax
  8024f6:	03 45 0c             	add    0xc(%ebp),%eax
  8024f9:	50                   	push   %eax
  8024fa:	57                   	push   %edi
  8024fb:	e8 2a ea ff ff       	call   800f2a <memmove>
		sys_cputs(buf, m);
  802500:	83 c4 08             	add    $0x8,%esp
  802503:	53                   	push   %ebx
  802504:	57                   	push   %edi
  802505:	e8 c8 eb ff ff       	call   8010d2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80250a:	01 de                	add    %ebx,%esi
  80250c:	83 c4 10             	add    $0x10,%esp
  80250f:	eb ca                	jmp    8024db <devcons_write+0x17>
}
  802511:	89 f0                	mov    %esi,%eax
  802513:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802516:	5b                   	pop    %ebx
  802517:	5e                   	pop    %esi
  802518:	5f                   	pop    %edi
  802519:	5d                   	pop    %ebp
  80251a:	c3                   	ret    

0080251b <devcons_read>:
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	83 ec 08             	sub    $0x8,%esp
  802521:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802526:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80252a:	74 21                	je     80254d <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80252c:	e8 bf eb ff ff       	call   8010f0 <sys_cgetc>
  802531:	85 c0                	test   %eax,%eax
  802533:	75 07                	jne    80253c <devcons_read+0x21>
		sys_yield();
  802535:	e8 35 ec ff ff       	call   80116f <sys_yield>
  80253a:	eb f0                	jmp    80252c <devcons_read+0x11>
	if (c < 0)
  80253c:	78 0f                	js     80254d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80253e:	83 f8 04             	cmp    $0x4,%eax
  802541:	74 0c                	je     80254f <devcons_read+0x34>
	*(char*)vbuf = c;
  802543:	8b 55 0c             	mov    0xc(%ebp),%edx
  802546:	88 02                	mov    %al,(%edx)
	return 1;
  802548:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80254d:	c9                   	leave  
  80254e:	c3                   	ret    
		return 0;
  80254f:	b8 00 00 00 00       	mov    $0x0,%eax
  802554:	eb f7                	jmp    80254d <devcons_read+0x32>

00802556 <cputchar>:
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802562:	6a 01                	push   $0x1
  802564:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802567:	50                   	push   %eax
  802568:	e8 65 eb ff ff       	call   8010d2 <sys_cputs>
}
  80256d:	83 c4 10             	add    $0x10,%esp
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <getchar>:
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802578:	6a 01                	push   $0x1
  80257a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80257d:	50                   	push   %eax
  80257e:	6a 00                	push   $0x0
  802580:	e8 1a f2 ff ff       	call   80179f <read>
	if (r < 0)
  802585:	83 c4 10             	add    $0x10,%esp
  802588:	85 c0                	test   %eax,%eax
  80258a:	78 06                	js     802592 <getchar+0x20>
	if (r < 1)
  80258c:	74 06                	je     802594 <getchar+0x22>
	return c;
  80258e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802592:	c9                   	leave  
  802593:	c3                   	ret    
		return -E_EOF;
  802594:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802599:	eb f7                	jmp    802592 <getchar+0x20>

0080259b <iscons>:
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025a4:	50                   	push   %eax
  8025a5:	ff 75 08             	pushl  0x8(%ebp)
  8025a8:	e8 82 ef ff ff       	call   80152f <fd_lookup>
  8025ad:	83 c4 10             	add    $0x10,%esp
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	78 11                	js     8025c5 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8025bd:	39 10                	cmp    %edx,(%eax)
  8025bf:	0f 94 c0             	sete   %al
  8025c2:	0f b6 c0             	movzbl %al,%eax
}
  8025c5:	c9                   	leave  
  8025c6:	c3                   	ret    

008025c7 <opencons>:
{
  8025c7:	55                   	push   %ebp
  8025c8:	89 e5                	mov    %esp,%ebp
  8025ca:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8025cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025d0:	50                   	push   %eax
  8025d1:	e8 07 ef ff ff       	call   8014dd <fd_alloc>
  8025d6:	83 c4 10             	add    $0x10,%esp
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	78 3a                	js     802617 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025dd:	83 ec 04             	sub    $0x4,%esp
  8025e0:	68 07 04 00 00       	push   $0x407
  8025e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e8:	6a 00                	push   $0x0
  8025ea:	e8 9f eb ff ff       	call   80118e <sys_page_alloc>
  8025ef:	83 c4 10             	add    $0x10,%esp
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	78 21                	js     802617 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8025ff:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80260b:	83 ec 0c             	sub    $0xc,%esp
  80260e:	50                   	push   %eax
  80260f:	e8 a2 ee ff ff       	call   8014b6 <fd2num>
  802614:	83 c4 10             	add    $0x10,%esp
}
  802617:	c9                   	leave  
  802618:	c3                   	ret    

00802619 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
  80261c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80261f:	89 d0                	mov    %edx,%eax
  802621:	c1 e8 16             	shr    $0x16,%eax
  802624:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80262b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802630:	f6 c1 01             	test   $0x1,%cl
  802633:	74 1d                	je     802652 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802635:	c1 ea 0c             	shr    $0xc,%edx
  802638:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80263f:	f6 c2 01             	test   $0x1,%dl
  802642:	74 0e                	je     802652 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802644:	c1 ea 0c             	shr    $0xc,%edx
  802647:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80264e:	ef 
  80264f:	0f b7 c0             	movzwl %ax,%eax
}
  802652:	5d                   	pop    %ebp
  802653:	c3                   	ret    
  802654:	66 90                	xchg   %ax,%ax
  802656:	66 90                	xchg   %ax,%ax
  802658:	66 90                	xchg   %ax,%ax
  80265a:	66 90                	xchg   %ax,%ax
  80265c:	66 90                	xchg   %ax,%ax
  80265e:	66 90                	xchg   %ax,%ax

00802660 <__udivdi3>:
  802660:	f3 0f 1e fb          	endbr32 
  802664:	55                   	push   %ebp
  802665:	57                   	push   %edi
  802666:	56                   	push   %esi
  802667:	53                   	push   %ebx
  802668:	83 ec 1c             	sub    $0x1c,%esp
  80266b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80266f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802673:	8b 74 24 34          	mov    0x34(%esp),%esi
  802677:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80267b:	85 d2                	test   %edx,%edx
  80267d:	75 49                	jne    8026c8 <__udivdi3+0x68>
  80267f:	39 f3                	cmp    %esi,%ebx
  802681:	76 15                	jbe    802698 <__udivdi3+0x38>
  802683:	31 ff                	xor    %edi,%edi
  802685:	89 e8                	mov    %ebp,%eax
  802687:	89 f2                	mov    %esi,%edx
  802689:	f7 f3                	div    %ebx
  80268b:	89 fa                	mov    %edi,%edx
  80268d:	83 c4 1c             	add    $0x1c,%esp
  802690:	5b                   	pop    %ebx
  802691:	5e                   	pop    %esi
  802692:	5f                   	pop    %edi
  802693:	5d                   	pop    %ebp
  802694:	c3                   	ret    
  802695:	8d 76 00             	lea    0x0(%esi),%esi
  802698:	89 d9                	mov    %ebx,%ecx
  80269a:	85 db                	test   %ebx,%ebx
  80269c:	75 0b                	jne    8026a9 <__udivdi3+0x49>
  80269e:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a3:	31 d2                	xor    %edx,%edx
  8026a5:	f7 f3                	div    %ebx
  8026a7:	89 c1                	mov    %eax,%ecx
  8026a9:	31 d2                	xor    %edx,%edx
  8026ab:	89 f0                	mov    %esi,%eax
  8026ad:	f7 f1                	div    %ecx
  8026af:	89 c6                	mov    %eax,%esi
  8026b1:	89 e8                	mov    %ebp,%eax
  8026b3:	89 f7                	mov    %esi,%edi
  8026b5:	f7 f1                	div    %ecx
  8026b7:	89 fa                	mov    %edi,%edx
  8026b9:	83 c4 1c             	add    $0x1c,%esp
  8026bc:	5b                   	pop    %ebx
  8026bd:	5e                   	pop    %esi
  8026be:	5f                   	pop    %edi
  8026bf:	5d                   	pop    %ebp
  8026c0:	c3                   	ret    
  8026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026c8:	39 f2                	cmp    %esi,%edx
  8026ca:	77 1c                	ja     8026e8 <__udivdi3+0x88>
  8026cc:	0f bd fa             	bsr    %edx,%edi
  8026cf:	83 f7 1f             	xor    $0x1f,%edi
  8026d2:	75 2c                	jne    802700 <__udivdi3+0xa0>
  8026d4:	39 f2                	cmp    %esi,%edx
  8026d6:	72 06                	jb     8026de <__udivdi3+0x7e>
  8026d8:	31 c0                	xor    %eax,%eax
  8026da:	39 eb                	cmp    %ebp,%ebx
  8026dc:	77 ad                	ja     80268b <__udivdi3+0x2b>
  8026de:	b8 01 00 00 00       	mov    $0x1,%eax
  8026e3:	eb a6                	jmp    80268b <__udivdi3+0x2b>
  8026e5:	8d 76 00             	lea    0x0(%esi),%esi
  8026e8:	31 ff                	xor    %edi,%edi
  8026ea:	31 c0                	xor    %eax,%eax
  8026ec:	89 fa                	mov    %edi,%edx
  8026ee:	83 c4 1c             	add    $0x1c,%esp
  8026f1:	5b                   	pop    %ebx
  8026f2:	5e                   	pop    %esi
  8026f3:	5f                   	pop    %edi
  8026f4:	5d                   	pop    %ebp
  8026f5:	c3                   	ret    
  8026f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026fd:	8d 76 00             	lea    0x0(%esi),%esi
  802700:	89 f9                	mov    %edi,%ecx
  802702:	b8 20 00 00 00       	mov    $0x20,%eax
  802707:	29 f8                	sub    %edi,%eax
  802709:	d3 e2                	shl    %cl,%edx
  80270b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80270f:	89 c1                	mov    %eax,%ecx
  802711:	89 da                	mov    %ebx,%edx
  802713:	d3 ea                	shr    %cl,%edx
  802715:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802719:	09 d1                	or     %edx,%ecx
  80271b:	89 f2                	mov    %esi,%edx
  80271d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802721:	89 f9                	mov    %edi,%ecx
  802723:	d3 e3                	shl    %cl,%ebx
  802725:	89 c1                	mov    %eax,%ecx
  802727:	d3 ea                	shr    %cl,%edx
  802729:	89 f9                	mov    %edi,%ecx
  80272b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80272f:	89 eb                	mov    %ebp,%ebx
  802731:	d3 e6                	shl    %cl,%esi
  802733:	89 c1                	mov    %eax,%ecx
  802735:	d3 eb                	shr    %cl,%ebx
  802737:	09 de                	or     %ebx,%esi
  802739:	89 f0                	mov    %esi,%eax
  80273b:	f7 74 24 08          	divl   0x8(%esp)
  80273f:	89 d6                	mov    %edx,%esi
  802741:	89 c3                	mov    %eax,%ebx
  802743:	f7 64 24 0c          	mull   0xc(%esp)
  802747:	39 d6                	cmp    %edx,%esi
  802749:	72 15                	jb     802760 <__udivdi3+0x100>
  80274b:	89 f9                	mov    %edi,%ecx
  80274d:	d3 e5                	shl    %cl,%ebp
  80274f:	39 c5                	cmp    %eax,%ebp
  802751:	73 04                	jae    802757 <__udivdi3+0xf7>
  802753:	39 d6                	cmp    %edx,%esi
  802755:	74 09                	je     802760 <__udivdi3+0x100>
  802757:	89 d8                	mov    %ebx,%eax
  802759:	31 ff                	xor    %edi,%edi
  80275b:	e9 2b ff ff ff       	jmp    80268b <__udivdi3+0x2b>
  802760:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802763:	31 ff                	xor    %edi,%edi
  802765:	e9 21 ff ff ff       	jmp    80268b <__udivdi3+0x2b>
  80276a:	66 90                	xchg   %ax,%ax
  80276c:	66 90                	xchg   %ax,%ax
  80276e:	66 90                	xchg   %ax,%ax

00802770 <__umoddi3>:
  802770:	f3 0f 1e fb          	endbr32 
  802774:	55                   	push   %ebp
  802775:	57                   	push   %edi
  802776:	56                   	push   %esi
  802777:	53                   	push   %ebx
  802778:	83 ec 1c             	sub    $0x1c,%esp
  80277b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80277f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802783:	8b 74 24 30          	mov    0x30(%esp),%esi
  802787:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80278b:	89 da                	mov    %ebx,%edx
  80278d:	85 c0                	test   %eax,%eax
  80278f:	75 3f                	jne    8027d0 <__umoddi3+0x60>
  802791:	39 df                	cmp    %ebx,%edi
  802793:	76 13                	jbe    8027a8 <__umoddi3+0x38>
  802795:	89 f0                	mov    %esi,%eax
  802797:	f7 f7                	div    %edi
  802799:	89 d0                	mov    %edx,%eax
  80279b:	31 d2                	xor    %edx,%edx
  80279d:	83 c4 1c             	add    $0x1c,%esp
  8027a0:	5b                   	pop    %ebx
  8027a1:	5e                   	pop    %esi
  8027a2:	5f                   	pop    %edi
  8027a3:	5d                   	pop    %ebp
  8027a4:	c3                   	ret    
  8027a5:	8d 76 00             	lea    0x0(%esi),%esi
  8027a8:	89 fd                	mov    %edi,%ebp
  8027aa:	85 ff                	test   %edi,%edi
  8027ac:	75 0b                	jne    8027b9 <__umoddi3+0x49>
  8027ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b3:	31 d2                	xor    %edx,%edx
  8027b5:	f7 f7                	div    %edi
  8027b7:	89 c5                	mov    %eax,%ebp
  8027b9:	89 d8                	mov    %ebx,%eax
  8027bb:	31 d2                	xor    %edx,%edx
  8027bd:	f7 f5                	div    %ebp
  8027bf:	89 f0                	mov    %esi,%eax
  8027c1:	f7 f5                	div    %ebp
  8027c3:	89 d0                	mov    %edx,%eax
  8027c5:	eb d4                	jmp    80279b <__umoddi3+0x2b>
  8027c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027ce:	66 90                	xchg   %ax,%ax
  8027d0:	89 f1                	mov    %esi,%ecx
  8027d2:	39 d8                	cmp    %ebx,%eax
  8027d4:	76 0a                	jbe    8027e0 <__umoddi3+0x70>
  8027d6:	89 f0                	mov    %esi,%eax
  8027d8:	83 c4 1c             	add    $0x1c,%esp
  8027db:	5b                   	pop    %ebx
  8027dc:	5e                   	pop    %esi
  8027dd:	5f                   	pop    %edi
  8027de:	5d                   	pop    %ebp
  8027df:	c3                   	ret    
  8027e0:	0f bd e8             	bsr    %eax,%ebp
  8027e3:	83 f5 1f             	xor    $0x1f,%ebp
  8027e6:	75 20                	jne    802808 <__umoddi3+0x98>
  8027e8:	39 d8                	cmp    %ebx,%eax
  8027ea:	0f 82 b0 00 00 00    	jb     8028a0 <__umoddi3+0x130>
  8027f0:	39 f7                	cmp    %esi,%edi
  8027f2:	0f 86 a8 00 00 00    	jbe    8028a0 <__umoddi3+0x130>
  8027f8:	89 c8                	mov    %ecx,%eax
  8027fa:	83 c4 1c             	add    $0x1c,%esp
  8027fd:	5b                   	pop    %ebx
  8027fe:	5e                   	pop    %esi
  8027ff:	5f                   	pop    %edi
  802800:	5d                   	pop    %ebp
  802801:	c3                   	ret    
  802802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802808:	89 e9                	mov    %ebp,%ecx
  80280a:	ba 20 00 00 00       	mov    $0x20,%edx
  80280f:	29 ea                	sub    %ebp,%edx
  802811:	d3 e0                	shl    %cl,%eax
  802813:	89 44 24 08          	mov    %eax,0x8(%esp)
  802817:	89 d1                	mov    %edx,%ecx
  802819:	89 f8                	mov    %edi,%eax
  80281b:	d3 e8                	shr    %cl,%eax
  80281d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802821:	89 54 24 04          	mov    %edx,0x4(%esp)
  802825:	8b 54 24 04          	mov    0x4(%esp),%edx
  802829:	09 c1                	or     %eax,%ecx
  80282b:	89 d8                	mov    %ebx,%eax
  80282d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802831:	89 e9                	mov    %ebp,%ecx
  802833:	d3 e7                	shl    %cl,%edi
  802835:	89 d1                	mov    %edx,%ecx
  802837:	d3 e8                	shr    %cl,%eax
  802839:	89 e9                	mov    %ebp,%ecx
  80283b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80283f:	d3 e3                	shl    %cl,%ebx
  802841:	89 c7                	mov    %eax,%edi
  802843:	89 d1                	mov    %edx,%ecx
  802845:	89 f0                	mov    %esi,%eax
  802847:	d3 e8                	shr    %cl,%eax
  802849:	89 e9                	mov    %ebp,%ecx
  80284b:	89 fa                	mov    %edi,%edx
  80284d:	d3 e6                	shl    %cl,%esi
  80284f:	09 d8                	or     %ebx,%eax
  802851:	f7 74 24 08          	divl   0x8(%esp)
  802855:	89 d1                	mov    %edx,%ecx
  802857:	89 f3                	mov    %esi,%ebx
  802859:	f7 64 24 0c          	mull   0xc(%esp)
  80285d:	89 c6                	mov    %eax,%esi
  80285f:	89 d7                	mov    %edx,%edi
  802861:	39 d1                	cmp    %edx,%ecx
  802863:	72 06                	jb     80286b <__umoddi3+0xfb>
  802865:	75 10                	jne    802877 <__umoddi3+0x107>
  802867:	39 c3                	cmp    %eax,%ebx
  802869:	73 0c                	jae    802877 <__umoddi3+0x107>
  80286b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80286f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802873:	89 d7                	mov    %edx,%edi
  802875:	89 c6                	mov    %eax,%esi
  802877:	89 ca                	mov    %ecx,%edx
  802879:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80287e:	29 f3                	sub    %esi,%ebx
  802880:	19 fa                	sbb    %edi,%edx
  802882:	89 d0                	mov    %edx,%eax
  802884:	d3 e0                	shl    %cl,%eax
  802886:	89 e9                	mov    %ebp,%ecx
  802888:	d3 eb                	shr    %cl,%ebx
  80288a:	d3 ea                	shr    %cl,%edx
  80288c:	09 d8                	or     %ebx,%eax
  80288e:	83 c4 1c             	add    $0x1c,%esp
  802891:	5b                   	pop    %ebx
  802892:	5e                   	pop    %esi
  802893:	5f                   	pop    %edi
  802894:	5d                   	pop    %ebp
  802895:	c3                   	ret    
  802896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80289d:	8d 76 00             	lea    0x0(%esi),%esi
  8028a0:	89 da                	mov    %ebx,%edx
  8028a2:	29 fe                	sub    %edi,%esi
  8028a4:	19 c2                	sbb    %eax,%edx
  8028a6:	89 f1                	mov    %esi,%ecx
  8028a8:	89 c8                	mov    %ecx,%eax
  8028aa:	e9 4b ff ff ff       	jmp    8027fa <__umoddi3+0x8a>
