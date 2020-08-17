
obj/user/httpd.debug：     文件格式 elf32-i386


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
  80002c:	e8 63 05 00 00       	call   800594 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 60 2a 80 00       	push   $0x802a60
  80003f:	e8 8b 06 00 00       	call   8006cf <cprintf>
	exit();
  800044:	e8 91 05 00 00       	call   8005da <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	81 ec 20 04 00 00    	sub    $0x420,%esp
  80005a:	89 c3                	mov    %eax,%ebx
	struct http_request *req = &con_d;

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005c:	68 00 02 00 00       	push   $0x200
  800061:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  800067:	50                   	push   %eax
  800068:	53                   	push   %ebx
  800069:	e8 28 15 00 00       	call   801596 <read>
  80006e:	83 c4 10             	add    $0x10,%esp
  800071:	85 c0                	test   %eax,%eax
  800073:	78 44                	js     8000b9 <handle_client+0x6b>
			panic("failed to read");

		memset(req, 0, sizeof(*req));
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	6a 0c                	push   $0xc
  80007a:	6a 00                	push   $0x0
  80007c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80007f:	50                   	push   %eax
  800080:	e8 6c 0d 00 00       	call   800df1 <memset>

		req->sock = sock;
  800085:	89 5d dc             	mov    %ebx,-0x24(%ebp)
	if (strncmp(request, "GET ", 4) != 0)
  800088:	83 c4 0c             	add    $0xc,%esp
  80008b:	6a 04                	push   $0x4
  80008d:	68 80 2a 80 00       	push   $0x802a80
  800092:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	e8 de 0c 00 00       	call   800d7c <strncmp>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	0f 85 a7 00 00 00    	jne    800150 <handle_client+0x102>
	request += 4;
  8000a9:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx
	while (*request && *request != ' ')
  8000af:	f6 03 df             	testb  $0xdf,(%ebx)
  8000b2:	74 1c                	je     8000d0 <handle_client+0x82>
		request++;
  8000b4:	83 c3 01             	add    $0x1,%ebx
  8000b7:	eb f6                	jmp    8000af <handle_client+0x61>
			panic("failed to read");
  8000b9:	83 ec 04             	sub    $0x4,%esp
  8000bc:	68 64 2a 80 00       	push   $0x802a64
  8000c1:	68 04 01 00 00       	push   $0x104
  8000c6:	68 73 2a 80 00       	push   $0x802a73
  8000cb:	e8 24 05 00 00       	call   8005f4 <_panic>
	url_len = request - url;
  8000d0:	8d bd e0 fd ff ff    	lea    -0x220(%ebp),%edi
  8000d6:	89 de                	mov    %ebx,%esi
  8000d8:	29 fe                	sub    %edi,%esi
	req->url = malloc(url_len + 1);
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	8d 46 01             	lea    0x1(%esi),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 61 22 00 00       	call   802347 <malloc>
  8000e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  8000e9:	83 c4 0c             	add    $0xc,%esp
  8000ec:	56                   	push   %esi
  8000ed:	57                   	push   %edi
  8000ee:	50                   	push   %eax
  8000ef:	e8 45 0d 00 00       	call   800e39 <memmove>
	req->url[url_len] = '\0';
  8000f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000f7:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
	request++;
  8000fb:	8d 73 01             	lea    0x1(%ebx),%esi
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 f0                	mov    %esi,%eax
  800103:	eb 03                	jmp    800108 <handle_client+0xba>
		request++;
  800105:	83 c0 01             	add    $0x1,%eax
	while (*request && *request != '\n')
  800108:	0f b6 10             	movzbl (%eax),%edx
  80010b:	84 d2                	test   %dl,%dl
  80010d:	74 05                	je     800114 <handle_client+0xc6>
  80010f:	80 fa 0a             	cmp    $0xa,%dl
  800112:	75 f1                	jne    800105 <handle_client+0xb7>
	version_len = request - version;
  800114:	29 f0                	sub    %esi,%eax
  800116:	89 c3                	mov    %eax,%ebx
	req->version = malloc(version_len + 1);
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	8d 40 01             	lea    0x1(%eax),%eax
  80011e:	50                   	push   %eax
  80011f:	e8 23 22 00 00       	call   802347 <malloc>
  800124:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  800127:	83 c4 0c             	add    $0xc,%esp
  80012a:	53                   	push   %ebx
  80012b:	56                   	push   %esi
  80012c:	50                   	push   %eax
  80012d:	e8 07 0d 00 00       	call   800e39 <memmove>
	req->version[version_len] = '\0';
  800132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800135:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
	panic("send_file not implemented");
  800139:	83 c4 0c             	add    $0xc,%esp
  80013c:	68 85 2a 80 00       	push   $0x802a85
  800141:	68 e2 00 00 00       	push   $0xe2
  800146:	68 73 2a 80 00       	push   $0x802a73
  80014b:	e8 a4 04 00 00       	call   8005f4 <_panic>
	struct error_messages *e = errors;
  800150:	b8 00 40 80 00       	mov    $0x804000,%eax
	while (e->code != 0 && e->msg != 0) {
  800155:	8b 10                	mov    (%eax),%edx
  800157:	85 d2                	test   %edx,%edx
  800159:	74 43                	je     80019e <handle_client+0x150>
		if (e->code == code)
  80015b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80015f:	74 0d                	je     80016e <handle_client+0x120>
  800161:	81 fa 90 01 00 00    	cmp    $0x190,%edx
  800167:	74 05                	je     80016e <handle_client+0x120>
		e++;
  800169:	83 c0 08             	add    $0x8,%eax
  80016c:	eb e7                	jmp    800155 <handle_client+0x107>
	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  80016e:	8b 40 04             	mov    0x4(%eax),%eax
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	50                   	push   %eax
  800175:	52                   	push   %edx
  800176:	50                   	push   %eax
  800177:	52                   	push   %edx
  800178:	68 d4 2a 80 00       	push   $0x802ad4
  80017d:	68 00 02 00 00       	push   $0x200
  800182:	8d b5 dc fb ff ff    	lea    -0x424(%ebp),%esi
  800188:	56                   	push   %esi
  800189:	e8 ca 0a 00 00       	call   800c58 <snprintf>
	if (write(req->sock, buf, r) != r)
  80018e:	83 c4 1c             	add    $0x1c,%esp
  800191:	50                   	push   %eax
  800192:	56                   	push   %esi
  800193:	ff 75 dc             	pushl  -0x24(%ebp)
  800196:	e8 c7 14 00 00       	call   801662 <write>
  80019b:	83 c4 10             	add    $0x10,%esp
	free(req->url);
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8001a4:	e8 f2 20 00 00       	call   80229b <free>
	free(req->version);
  8001a9:	83 c4 04             	add    $0x4,%esp
  8001ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001af:	e8 e7 20 00 00       	call   80229b <free>

		// no keep alive
		break;
	}

	close(sock);
  8001b4:	89 1c 24             	mov    %ebx,(%esp)
  8001b7:	e8 9c 12 00 00       	call   801458 <close>
}
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c2:	5b                   	pop    %ebx
  8001c3:	5e                   	pop    %esi
  8001c4:	5f                   	pop    %edi
  8001c5:	5d                   	pop    %ebp
  8001c6:	c3                   	ret    

008001c7 <umain>:

void
umain(int argc, char **argv)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	57                   	push   %edi
  8001cb:	56                   	push   %esi
  8001cc:	53                   	push   %ebx
  8001cd:	83 ec 40             	sub    $0x40,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  8001d0:	c7 05 20 40 80 00 9f 	movl   $0x802a9f,0x804020
  8001d7:	2a 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8001da:	6a 06                	push   $0x6
  8001dc:	6a 01                	push   $0x1
  8001de:	6a 02                	push   $0x2
  8001e0:	e8 3a 1e 00 00       	call   80201f <socket>
  8001e5:	89 c6                	mov    %eax,%esi
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	85 c0                	test   %eax,%eax
  8001ec:	78 6d                	js     80025b <umain+0x94>
		die("Failed to create socket");

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 10                	push   $0x10
  8001f3:	6a 00                	push   $0x0
  8001f5:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8001f8:	53                   	push   %ebx
  8001f9:	e8 f3 0b 00 00       	call   800df1 <memset>
	server.sin_family = AF_INET;			// Internet/IP
  8001fe:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  800202:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800209:	e8 5c 01 00 00       	call   80036a <htonl>
  80020e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	server.sin_port = htons(PORT);			// server port
  800211:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  800218:	e8 33 01 00 00       	call   800350 <htons>
  80021d:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  800221:	83 c4 0c             	add    $0xc,%esp
  800224:	6a 10                	push   $0x10
  800226:	53                   	push   %ebx
  800227:	56                   	push   %esi
  800228:	e8 60 1d 00 00       	call   801f8d <bind>
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	85 c0                	test   %eax,%eax
  800232:	78 33                	js     800267 <umain+0xa0>
	{
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	6a 05                	push   $0x5
  800239:	56                   	push   %esi
  80023a:	e8 bd 1d 00 00       	call   801ffc <listen>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	85 c0                	test   %eax,%eax
  800244:	78 2d                	js     800273 <umain+0xac>
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 98 2b 80 00       	push   $0x802b98
  80024e:	e8 7c 04 00 00       	call   8006cf <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800256:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  800259:	eb 35                	jmp    800290 <umain+0xc9>
		die("Failed to create socket");
  80025b:	b8 a6 2a 80 00       	mov    $0x802aa6,%eax
  800260:	e8 ce fd ff ff       	call   800033 <die>
  800265:	eb 87                	jmp    8001ee <umain+0x27>
		die("Failed to bind the server socket");
  800267:	b8 50 2b 80 00       	mov    $0x802b50,%eax
  80026c:	e8 c2 fd ff ff       	call   800033 <die>
  800271:	eb c1                	jmp    800234 <umain+0x6d>
		die("Failed to listen on server socket");
  800273:	b8 74 2b 80 00       	mov    $0x802b74,%eax
  800278:	e8 b6 fd ff ff       	call   800033 <die>
  80027d:	eb c7                	jmp    800246 <umain+0x7f>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  80027f:	b8 bc 2b 80 00       	mov    $0x802bbc,%eax
  800284:	e8 aa fd ff ff       	call   800033 <die>
		}
		handle_client(clientsock);
  800289:	89 d8                	mov    %ebx,%eax
  80028b:	e8 be fd ff ff       	call   80004e <handle_client>
		unsigned int clientlen = sizeof(client);
  800290:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		if ((clientsock = accept(serversock,
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	57                   	push   %edi
  80029b:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80029e:	50                   	push   %eax
  80029f:	56                   	push   %esi
  8002a0:	e8 b9 1c 00 00       	call   801f5e <accept>
  8002a5:	89 c3                	mov    %eax,%ebx
  8002a7:	83 c4 10             	add    $0x10,%esp
  8002aa:	85 c0                	test   %eax,%eax
  8002ac:	78 d1                	js     80027f <umain+0xb8>
  8002ae:	eb d9                	jmp    800289 <umain+0xc2>

008002b0 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	57                   	push   %edi
  8002b4:	56                   	push   %esi
  8002b5:	53                   	push   %ebx
  8002b6:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8002b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8002bf:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  8002c3:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  8002c6:	bf 00 50 80 00       	mov    $0x805000,%edi
  8002cb:	eb 1a                	jmp    8002e7 <inet_ntoa+0x37>
  8002cd:	0f b6 db             	movzbl %bl,%ebx
  8002d0:	01 fb                	add    %edi,%ebx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8002d2:	8d 7b 01             	lea    0x1(%ebx),%edi
  8002d5:	c6 03 2e             	movb   $0x2e,(%ebx)
  8002d8:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  8002db:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  8002df:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  8002e3:	3c 04                	cmp    $0x4,%al
  8002e5:	74 59                	je     800340 <inet_ntoa+0x90>
  rp = str;
  8002e7:	ba 00 00 00 00       	mov    $0x0,%edx
      rem = *ap % (u8_t)10;
  8002ec:	0f b6 0e             	movzbl (%esi),%ecx
      *ap /= (u8_t)10;
  8002ef:	0f b6 d9             	movzbl %cl,%ebx
  8002f2:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  8002f5:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  8002f8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002fb:	66 c1 e8 0b          	shr    $0xb,%ax
  8002ff:	88 06                	mov    %al,(%esi)
      inv[i++] = '0' + rem;
  800301:	8d 5a 01             	lea    0x1(%edx),%ebx
  800304:	0f b6 d2             	movzbl %dl,%edx
  800307:	89 55 e0             	mov    %edx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  80030a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	89 ca                	mov    %ecx,%edx
  800311:	29 c2                	sub    %eax,%edx
  800313:	89 d0                	mov    %edx,%eax
      inv[i++] = '0' + rem;
  800315:	83 c0 30             	add    $0x30,%eax
  800318:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80031b:	88 44 15 ed          	mov    %al,-0x13(%ebp,%edx,1)
  80031f:	89 da                	mov    %ebx,%edx
    } while(*ap);
  800321:	80 f9 09             	cmp    $0x9,%cl
  800324:	77 c6                	ja     8002ec <inet_ntoa+0x3c>
  800326:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  800328:	89 d8                	mov    %ebx,%eax
    while(i--)
  80032a:	83 e8 01             	sub    $0x1,%eax
  80032d:	3c ff                	cmp    $0xff,%al
  80032f:	74 9c                	je     8002cd <inet_ntoa+0x1d>
      *rp++ = inv[i];
  800331:	0f b6 c8             	movzbl %al,%ecx
  800334:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800339:	88 0a                	mov    %cl,(%edx)
  80033b:	83 c2 01             	add    $0x1,%edx
  80033e:	eb ea                	jmp    80032a <inet_ntoa+0x7a>
    ap++;
  }
  *--rp = 0;
  800340:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  800343:	b8 00 50 80 00       	mov    $0x805000,%eax
  800348:	83 c4 18             	add    $0x18,%esp
  80034b:	5b                   	pop    %ebx
  80034c:	5e                   	pop    %esi
  80034d:	5f                   	pop    %edi
  80034e:	5d                   	pop    %ebp
  80034f:	c3                   	ret    

00800350 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800353:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800357:	66 c1 c0 08          	rol    $0x8,%ax
}
  80035b:	5d                   	pop    %ebp
  80035c:	c3                   	ret    

0080035d <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800360:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800364:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  800368:	5d                   	pop    %ebp
  800369:	c3                   	ret    

0080036a <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800370:	89 d0                	mov    %edx,%eax
  800372:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800375:	89 d1                	mov    %edx,%ecx
  800377:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  80037a:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  80037c:	89 d1                	mov    %edx,%ecx
  80037e:	c1 e1 08             	shl    $0x8,%ecx
  800381:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  800387:	09 c8                	or     %ecx,%eax
  800389:	c1 ea 08             	shr    $0x8,%edx
  80038c:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  800392:	09 d0                	or     %edx,%eax
}
  800394:	5d                   	pop    %ebp
  800395:	c3                   	ret    

00800396 <inet_aton>:
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	57                   	push   %edi
  80039a:	56                   	push   %esi
  80039b:	53                   	push   %ebx
  80039c:	83 ec 2c             	sub    $0x2c,%esp
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  8003a2:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  8003a5:	8d 75 d8             	lea    -0x28(%ebp),%esi
  8003a8:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8003ab:	e9 a7 00 00 00       	jmp    800457 <inet_aton+0xc1>
      c = *++cp;
  8003b0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8003b4:	89 d1                	mov    %edx,%ecx
  8003b6:	83 e1 df             	and    $0xffffffdf,%ecx
  8003b9:	80 f9 58             	cmp    $0x58,%cl
  8003bc:	74 10                	je     8003ce <inet_aton+0x38>
      c = *++cp;
  8003be:	83 c0 01             	add    $0x1,%eax
  8003c1:	0f be d2             	movsbl %dl,%edx
        base = 8;
  8003c4:	be 08 00 00 00       	mov    $0x8,%esi
  8003c9:	e9 a3 00 00 00       	jmp    800471 <inet_aton+0xdb>
        c = *++cp;
  8003ce:	0f be 50 02          	movsbl 0x2(%eax),%edx
  8003d2:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  8003d5:	be 10 00 00 00       	mov    $0x10,%esi
  8003da:	e9 92 00 00 00       	jmp    800471 <inet_aton+0xdb>
      } else if (base == 16 && isxdigit(c)) {
  8003df:	83 fe 10             	cmp    $0x10,%esi
  8003e2:	75 4d                	jne    800431 <inet_aton+0x9b>
  8003e4:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  8003e7:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  8003ea:	89 d1                	mov    %edx,%ecx
  8003ec:	83 e1 df             	and    $0xffffffdf,%ecx
  8003ef:	83 e9 41             	sub    $0x41,%ecx
  8003f2:	80 f9 05             	cmp    $0x5,%cl
  8003f5:	77 3a                	ja     800431 <inet_aton+0x9b>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8003f7:	c1 e3 04             	shl    $0x4,%ebx
  8003fa:	83 c2 0a             	add    $0xa,%edx
  8003fd:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  800401:	19 c9                	sbb    %ecx,%ecx
  800403:	83 e1 20             	and    $0x20,%ecx
  800406:	83 c1 41             	add    $0x41,%ecx
  800409:	29 ca                	sub    %ecx,%edx
  80040b:	09 d3                	or     %edx,%ebx
        c = *++cp;
  80040d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800410:	0f be 57 01          	movsbl 0x1(%edi),%edx
  800414:	83 c0 01             	add    $0x1,%eax
  800417:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if (isdigit(c)) {
  80041a:	89 d7                	mov    %edx,%edi
  80041c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80041f:	80 f9 09             	cmp    $0x9,%cl
  800422:	77 bb                	ja     8003df <inet_aton+0x49>
        val = (val * base) + (int)(c - '0');
  800424:	0f af de             	imul   %esi,%ebx
  800427:	8d 5c 1a d0          	lea    -0x30(%edx,%ebx,1),%ebx
        c = *++cp;
  80042b:	0f be 50 01          	movsbl 0x1(%eax),%edx
  80042f:	eb e3                	jmp    800414 <inet_aton+0x7e>
    if (c == '.') {
  800431:	83 fa 2e             	cmp    $0x2e,%edx
  800434:	75 42                	jne    800478 <inet_aton+0xe2>
      if (pp >= parts + 3)
  800436:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800439:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80043c:	39 c6                	cmp    %eax,%esi
  80043e:	0f 84 0e 01 00 00    	je     800552 <inet_aton+0x1bc>
      *pp++ = val;
  800444:	83 c6 04             	add    $0x4,%esi
  800447:	89 75 cc             	mov    %esi,-0x34(%ebp)
  80044a:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  80044d:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  800450:	8d 46 01             	lea    0x1(%esi),%eax
  800453:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  800457:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80045a:	80 f9 09             	cmp    $0x9,%cl
  80045d:	0f 87 e8 00 00 00    	ja     80054b <inet_aton+0x1b5>
    base = 10;
  800463:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  800468:	83 fa 30             	cmp    $0x30,%edx
  80046b:	0f 84 3f ff ff ff    	je     8003b0 <inet_aton+0x1a>
    base = 10;
  800471:	bb 00 00 00 00       	mov    $0x0,%ebx
  800476:	eb 9f                	jmp    800417 <inet_aton+0x81>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800478:	85 d2                	test   %edx,%edx
  80047a:	74 26                	je     8004a2 <inet_aton+0x10c>
    return (0);
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800481:	89 f9                	mov    %edi,%ecx
  800483:	80 f9 1f             	cmp    $0x1f,%cl
  800486:	0f 86 cb 00 00 00    	jbe    800557 <inet_aton+0x1c1>
  80048c:	84 d2                	test   %dl,%dl
  80048e:	0f 88 c3 00 00 00    	js     800557 <inet_aton+0x1c1>
  800494:	83 fa 20             	cmp    $0x20,%edx
  800497:	74 09                	je     8004a2 <inet_aton+0x10c>
  800499:	83 fa 0c             	cmp    $0xc,%edx
  80049c:	0f 85 b5 00 00 00    	jne    800557 <inet_aton+0x1c1>
  n = pp - parts + 1;
  8004a2:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8004a5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004a8:	29 c6                	sub    %eax,%esi
  8004aa:	89 f0                	mov    %esi,%eax
  8004ac:	c1 f8 02             	sar    $0x2,%eax
  8004af:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  8004b2:	83 f8 02             	cmp    $0x2,%eax
  8004b5:	74 5e                	je     800515 <inet_aton+0x17f>
  8004b7:	7e 35                	jle    8004ee <inet_aton+0x158>
  8004b9:	83 f8 03             	cmp    $0x3,%eax
  8004bc:	74 6e                	je     80052c <inet_aton+0x196>
  8004be:	83 f8 04             	cmp    $0x4,%eax
  8004c1:	75 2f                	jne    8004f2 <inet_aton+0x15c>
      return (0);
  8004c3:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  8004c8:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  8004ce:	0f 87 83 00 00 00    	ja     800557 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8004d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d7:	c1 e0 18             	shl    $0x18,%eax
  8004da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004dd:	c1 e2 10             	shl    $0x10,%edx
  8004e0:	09 d0                	or     %edx,%eax
  8004e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e5:	c1 e2 08             	shl    $0x8,%edx
  8004e8:	09 d0                	or     %edx,%eax
  8004ea:	09 c3                	or     %eax,%ebx
    break;
  8004ec:	eb 04                	jmp    8004f2 <inet_aton+0x15c>
  switch (n) {
  8004ee:	85 c0                	test   %eax,%eax
  8004f0:	74 65                	je     800557 <inet_aton+0x1c1>
  return (1);
  8004f2:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  8004f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004fb:	74 5a                	je     800557 <inet_aton+0x1c1>
    addr->s_addr = htonl(val);
  8004fd:	83 ec 0c             	sub    $0xc,%esp
  800500:	53                   	push   %ebx
  800501:	e8 64 fe ff ff       	call   80036a <htonl>
  800506:	83 c4 10             	add    $0x10,%esp
  800509:	8b 75 0c             	mov    0xc(%ebp),%esi
  80050c:	89 06                	mov    %eax,(%esi)
  return (1);
  80050e:	b8 01 00 00 00       	mov    $0x1,%eax
  800513:	eb 42                	jmp    800557 <inet_aton+0x1c1>
      return (0);
  800515:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  80051a:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  800520:	77 35                	ja     800557 <inet_aton+0x1c1>
    val |= parts[0] << 24;
  800522:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800525:	c1 e0 18             	shl    $0x18,%eax
  800528:	09 c3                	or     %eax,%ebx
    break;
  80052a:	eb c6                	jmp    8004f2 <inet_aton+0x15c>
      return (0);
  80052c:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  800531:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  800537:	77 1e                	ja     800557 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16);
  800539:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80053c:	c1 e0 18             	shl    $0x18,%eax
  80053f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800542:	c1 e2 10             	shl    $0x10,%edx
  800545:	09 d0                	or     %edx,%eax
  800547:	09 c3                	or     %eax,%ebx
    break;
  800549:	eb a7                	jmp    8004f2 <inet_aton+0x15c>
      return (0);
  80054b:	b8 00 00 00 00       	mov    $0x0,%eax
  800550:	eb 05                	jmp    800557 <inet_aton+0x1c1>
        return (0);
  800552:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800557:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80055a:	5b                   	pop    %ebx
  80055b:	5e                   	pop    %esi
  80055c:	5f                   	pop    %edi
  80055d:	5d                   	pop    %ebp
  80055e:	c3                   	ret    

0080055f <inet_addr>:
{
  80055f:	55                   	push   %ebp
  800560:	89 e5                	mov    %esp,%ebp
  800562:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  800565:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 08             	pushl  0x8(%ebp)
  80056c:	e8 25 fe ff ff       	call   800396 <inet_aton>
  800571:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  800574:	85 c0                	test   %eax,%eax
  800576:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80057b:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  80057f:	c9                   	leave  
  800580:	c3                   	ret    

00800581 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  800581:	55                   	push   %ebp
  800582:	89 e5                	mov    %esp,%ebp
  800584:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  800587:	ff 75 08             	pushl  0x8(%ebp)
  80058a:	e8 db fd ff ff       	call   80036a <htonl>
  80058f:	83 c4 10             	add    $0x10,%esp
}
  800592:	c9                   	leave  
  800593:	c3                   	ret    

00800594 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	56                   	push   %esi
  800598:	53                   	push   %ebx
  800599:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80059c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80059f:	e8 bb 0a 00 00       	call   80105f <sys_getenvid>
  8005a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005a9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005ac:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005b1:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005b6:	85 db                	test   %ebx,%ebx
  8005b8:	7e 07                	jle    8005c1 <libmain+0x2d>
		binaryname = argv[0];
  8005ba:	8b 06                	mov    (%esi),%eax
  8005bc:	a3 20 40 80 00       	mov    %eax,0x804020

	// call user main routine
	umain(argc, argv);
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	56                   	push   %esi
  8005c5:	53                   	push   %ebx
  8005c6:	e8 fc fb ff ff       	call   8001c7 <umain>

	// exit gracefully
	exit();
  8005cb:	e8 0a 00 00 00       	call   8005da <exit>
}
  8005d0:	83 c4 10             	add    $0x10,%esp
  8005d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005d6:	5b                   	pop    %ebx
  8005d7:	5e                   	pop    %esi
  8005d8:	5d                   	pop    %ebp
  8005d9:	c3                   	ret    

008005da <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8005e0:	e8 a0 0e 00 00       	call   801485 <close_all>
	sys_env_destroy(0);
  8005e5:	83 ec 0c             	sub    $0xc,%esp
  8005e8:	6a 00                	push   $0x0
  8005ea:	e8 2f 0a 00 00       	call   80101e <sys_env_destroy>
}
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	c9                   	leave  
  8005f3:	c3                   	ret    

008005f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
  8005f7:	56                   	push   %esi
  8005f8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8005f9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005fc:	8b 35 20 40 80 00    	mov    0x804020,%esi
  800602:	e8 58 0a 00 00       	call   80105f <sys_getenvid>
  800607:	83 ec 0c             	sub    $0xc,%esp
  80060a:	ff 75 0c             	pushl  0xc(%ebp)
  80060d:	ff 75 08             	pushl  0x8(%ebp)
  800610:	56                   	push   %esi
  800611:	50                   	push   %eax
  800612:	68 10 2c 80 00       	push   $0x802c10
  800617:	e8 b3 00 00 00       	call   8006cf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80061c:	83 c4 18             	add    $0x18,%esp
  80061f:	53                   	push   %ebx
  800620:	ff 75 10             	pushl  0x10(%ebp)
  800623:	e8 56 00 00 00       	call   80067e <vcprintf>
	cprintf("\n");
  800628:	c7 04 24 53 30 80 00 	movl   $0x803053,(%esp)
  80062f:	e8 9b 00 00 00       	call   8006cf <cprintf>
  800634:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800637:	cc                   	int3   
  800638:	eb fd                	jmp    800637 <_panic+0x43>

0080063a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
  80063d:	53                   	push   %ebx
  80063e:	83 ec 04             	sub    $0x4,%esp
  800641:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800644:	8b 13                	mov    (%ebx),%edx
  800646:	8d 42 01             	lea    0x1(%edx),%eax
  800649:	89 03                	mov    %eax,(%ebx)
  80064b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80064e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800652:	3d ff 00 00 00       	cmp    $0xff,%eax
  800657:	74 09                	je     800662 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800659:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80065d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800660:	c9                   	leave  
  800661:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	68 ff 00 00 00       	push   $0xff
  80066a:	8d 43 08             	lea    0x8(%ebx),%eax
  80066d:	50                   	push   %eax
  80066e:	e8 6e 09 00 00       	call   800fe1 <sys_cputs>
		b->idx = 0;
  800673:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	eb db                	jmp    800659 <putch+0x1f>

0080067e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800687:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80068e:	00 00 00 
	b.cnt = 0;
  800691:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800698:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80069b:	ff 75 0c             	pushl  0xc(%ebp)
  80069e:	ff 75 08             	pushl  0x8(%ebp)
  8006a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a7:	50                   	push   %eax
  8006a8:	68 3a 06 80 00       	push   $0x80063a
  8006ad:	e8 19 01 00 00       	call   8007cb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006b2:	83 c4 08             	add    $0x8,%esp
  8006b5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8006bb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006c1:	50                   	push   %eax
  8006c2:	e8 1a 09 00 00       	call   800fe1 <sys_cputs>

	return b.cnt;
}
  8006c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006d5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006d8:	50                   	push   %eax
  8006d9:	ff 75 08             	pushl  0x8(%ebp)
  8006dc:	e8 9d ff ff ff       	call   80067e <vcprintf>
	va_end(ap);

	return cnt;
}
  8006e1:	c9                   	leave  
  8006e2:	c3                   	ret    

008006e3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
  8006e6:	57                   	push   %edi
  8006e7:	56                   	push   %esi
  8006e8:	53                   	push   %ebx
  8006e9:	83 ec 1c             	sub    $0x1c,%esp
  8006ec:	89 c7                	mov    %eax,%edi
  8006ee:	89 d6                	mov    %edx,%esi
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8006ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800704:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800707:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80070a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80070d:	89 d0                	mov    %edx,%eax
  80070f:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  800712:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800715:	73 15                	jae    80072c <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800717:	83 eb 01             	sub    $0x1,%ebx
  80071a:	85 db                	test   %ebx,%ebx
  80071c:	7e 43                	jle    800761 <printnum+0x7e>
			putch(padc, putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	56                   	push   %esi
  800722:	ff 75 18             	pushl  0x18(%ebp)
  800725:	ff d7                	call   *%edi
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	eb eb                	jmp    800717 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	ff 75 18             	pushl  0x18(%ebp)
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800738:	53                   	push   %ebx
  800739:	ff 75 10             	pushl  0x10(%ebp)
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800742:	ff 75 e0             	pushl  -0x20(%ebp)
  800745:	ff 75 dc             	pushl  -0x24(%ebp)
  800748:	ff 75 d8             	pushl  -0x28(%ebp)
  80074b:	e8 b0 20 00 00       	call   802800 <__udivdi3>
  800750:	83 c4 18             	add    $0x18,%esp
  800753:	52                   	push   %edx
  800754:	50                   	push   %eax
  800755:	89 f2                	mov    %esi,%edx
  800757:	89 f8                	mov    %edi,%eax
  800759:	e8 85 ff ff ff       	call   8006e3 <printnum>
  80075e:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	56                   	push   %esi
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	ff 75 e4             	pushl  -0x1c(%ebp)
  80076b:	ff 75 e0             	pushl  -0x20(%ebp)
  80076e:	ff 75 dc             	pushl  -0x24(%ebp)
  800771:	ff 75 d8             	pushl  -0x28(%ebp)
  800774:	e8 97 21 00 00       	call   802910 <__umoddi3>
  800779:	83 c4 14             	add    $0x14,%esp
  80077c:	0f be 80 33 2c 80 00 	movsbl 0x802c33(%eax),%eax
  800783:	50                   	push   %eax
  800784:	ff d7                	call   *%edi
}
  800786:	83 c4 10             	add    $0x10,%esp
  800789:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078c:	5b                   	pop    %ebx
  80078d:	5e                   	pop    %esi
  80078e:	5f                   	pop    %edi
  80078f:	5d                   	pop    %ebp
  800790:	c3                   	ret    

00800791 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800797:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80079b:	8b 10                	mov    (%eax),%edx
  80079d:	3b 50 04             	cmp    0x4(%eax),%edx
  8007a0:	73 0a                	jae    8007ac <sprintputch+0x1b>
		*b->buf++ = ch;
  8007a2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007a5:	89 08                	mov    %ecx,(%eax)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	88 02                	mov    %al,(%edx)
}
  8007ac:	5d                   	pop    %ebp
  8007ad:	c3                   	ret    

008007ae <printfmt>:
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8007b4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8007b7:	50                   	push   %eax
  8007b8:	ff 75 10             	pushl  0x10(%ebp)
  8007bb:	ff 75 0c             	pushl  0xc(%ebp)
  8007be:	ff 75 08             	pushl  0x8(%ebp)
  8007c1:	e8 05 00 00 00       	call   8007cb <vprintfmt>
}
  8007c6:	83 c4 10             	add    $0x10,%esp
  8007c9:	c9                   	leave  
  8007ca:	c3                   	ret    

008007cb <vprintfmt>:
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	57                   	push   %edi
  8007cf:	56                   	push   %esi
  8007d0:	53                   	push   %ebx
  8007d1:	83 ec 3c             	sub    $0x3c,%esp
  8007d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8007d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007da:	8b 7d 10             	mov    0x10(%ebp),%edi
  8007dd:	eb 0a                	jmp    8007e9 <vprintfmt+0x1e>
			putch(ch, putdat);
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	53                   	push   %ebx
  8007e3:	50                   	push   %eax
  8007e4:	ff d6                	call   *%esi
  8007e6:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e9:	83 c7 01             	add    $0x1,%edi
  8007ec:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f0:	83 f8 25             	cmp    $0x25,%eax
  8007f3:	74 0c                	je     800801 <vprintfmt+0x36>
			if (ch == '\0')
  8007f5:	85 c0                	test   %eax,%eax
  8007f7:	75 e6                	jne    8007df <vprintfmt+0x14>
}
  8007f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007fc:	5b                   	pop    %ebx
  8007fd:	5e                   	pop    %esi
  8007fe:	5f                   	pop    %edi
  8007ff:	5d                   	pop    %ebp
  800800:	c3                   	ret    
		padc = ' ';
  800801:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800805:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80080c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800813:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80081a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80081f:	8d 47 01             	lea    0x1(%edi),%eax
  800822:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800825:	0f b6 17             	movzbl (%edi),%edx
  800828:	8d 42 dd             	lea    -0x23(%edx),%eax
  80082b:	3c 55                	cmp    $0x55,%al
  80082d:	0f 87 ba 03 00 00    	ja     800bed <vprintfmt+0x422>
  800833:	0f b6 c0             	movzbl %al,%eax
  800836:	ff 24 85 80 2d 80 00 	jmp    *0x802d80(,%eax,4)
  80083d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800840:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800844:	eb d9                	jmp    80081f <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800846:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800849:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80084d:	eb d0                	jmp    80081f <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80084f:	0f b6 d2             	movzbl %dl,%edx
  800852:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800855:	b8 00 00 00 00       	mov    $0x0,%eax
  80085a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80085d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800860:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800864:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800867:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80086a:	83 f9 09             	cmp    $0x9,%ecx
  80086d:	77 55                	ja     8008c4 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80086f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800872:	eb e9                	jmp    80085d <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8b 00                	mov    (%eax),%eax
  800879:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8d 40 04             	lea    0x4(%eax),%eax
  800882:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800885:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800888:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80088c:	79 91                	jns    80081f <vprintfmt+0x54>
				width = precision, precision = -1;
  80088e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800891:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800894:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80089b:	eb 82                	jmp    80081f <vprintfmt+0x54>
  80089d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a0:	85 c0                	test   %eax,%eax
  8008a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a7:	0f 49 d0             	cmovns %eax,%edx
  8008aa:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8008b0:	e9 6a ff ff ff       	jmp    80081f <vprintfmt+0x54>
  8008b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8008b8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8008bf:	e9 5b ff ff ff       	jmp    80081f <vprintfmt+0x54>
  8008c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ca:	eb bc                	jmp    800888 <vprintfmt+0xbd>
			lflag++;
  8008cc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8008d2:	e9 48 ff ff ff       	jmp    80081f <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	8d 78 04             	lea    0x4(%eax),%edi
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	53                   	push   %ebx
  8008e1:	ff 30                	pushl  (%eax)
  8008e3:	ff d6                	call   *%esi
			break;
  8008e5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8008e8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8008eb:	e9 9c 02 00 00       	jmp    800b8c <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	8d 78 04             	lea    0x4(%eax),%edi
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	99                   	cltd   
  8008f9:	31 d0                	xor    %edx,%eax
  8008fb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008fd:	83 f8 0f             	cmp    $0xf,%eax
  800900:	7f 23                	jg     800925 <vprintfmt+0x15a>
  800902:	8b 14 85 e0 2e 80 00 	mov    0x802ee0(,%eax,4),%edx
  800909:	85 d2                	test   %edx,%edx
  80090b:	74 18                	je     800925 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  80090d:	52                   	push   %edx
  80090e:	68 1a 30 80 00       	push   $0x80301a
  800913:	53                   	push   %ebx
  800914:	56                   	push   %esi
  800915:	e8 94 fe ff ff       	call   8007ae <printfmt>
  80091a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80091d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800920:	e9 67 02 00 00       	jmp    800b8c <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800925:	50                   	push   %eax
  800926:	68 4b 2c 80 00       	push   $0x802c4b
  80092b:	53                   	push   %ebx
  80092c:	56                   	push   %esi
  80092d:	e8 7c fe ff ff       	call   8007ae <printfmt>
  800932:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800935:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800938:	e9 4f 02 00 00       	jmp    800b8c <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	83 c0 04             	add    $0x4,%eax
  800943:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80094b:	85 d2                	test   %edx,%edx
  80094d:	b8 44 2c 80 00       	mov    $0x802c44,%eax
  800952:	0f 45 c2             	cmovne %edx,%eax
  800955:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800958:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80095c:	7e 06                	jle    800964 <vprintfmt+0x199>
  80095e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800962:	75 0d                	jne    800971 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800964:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800967:	89 c7                	mov    %eax,%edi
  800969:	03 45 e0             	add    -0x20(%ebp),%eax
  80096c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80096f:	eb 3f                	jmp    8009b0 <vprintfmt+0x1e5>
  800971:	83 ec 08             	sub    $0x8,%esp
  800974:	ff 75 d8             	pushl  -0x28(%ebp)
  800977:	50                   	push   %eax
  800978:	e8 0d 03 00 00       	call   800c8a <strnlen>
  80097d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800980:	29 c2                	sub    %eax,%edx
  800982:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800985:	83 c4 10             	add    $0x10,%esp
  800988:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80098a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80098e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800991:	85 ff                	test   %edi,%edi
  800993:	7e 58                	jle    8009ed <vprintfmt+0x222>
					putch(padc, putdat);
  800995:	83 ec 08             	sub    $0x8,%esp
  800998:	53                   	push   %ebx
  800999:	ff 75 e0             	pushl  -0x20(%ebp)
  80099c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80099e:	83 ef 01             	sub    $0x1,%edi
  8009a1:	83 c4 10             	add    $0x10,%esp
  8009a4:	eb eb                	jmp    800991 <vprintfmt+0x1c6>
					putch(ch, putdat);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	53                   	push   %ebx
  8009aa:	52                   	push   %edx
  8009ab:	ff d6                	call   *%esi
  8009ad:	83 c4 10             	add    $0x10,%esp
  8009b0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009b3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b5:	83 c7 01             	add    $0x1,%edi
  8009b8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009bc:	0f be d0             	movsbl %al,%edx
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	74 45                	je     800a08 <vprintfmt+0x23d>
  8009c3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009c7:	78 06                	js     8009cf <vprintfmt+0x204>
  8009c9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8009cd:	78 35                	js     800a04 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8009cf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8009d3:	74 d1                	je     8009a6 <vprintfmt+0x1db>
  8009d5:	0f be c0             	movsbl %al,%eax
  8009d8:	83 e8 20             	sub    $0x20,%eax
  8009db:	83 f8 5e             	cmp    $0x5e,%eax
  8009de:	76 c6                	jbe    8009a6 <vprintfmt+0x1db>
					putch('?', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	53                   	push   %ebx
  8009e4:	6a 3f                	push   $0x3f
  8009e6:	ff d6                	call   *%esi
  8009e8:	83 c4 10             	add    $0x10,%esp
  8009eb:	eb c3                	jmp    8009b0 <vprintfmt+0x1e5>
  8009ed:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8009f0:	85 d2                	test   %edx,%edx
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f7:	0f 49 c2             	cmovns %edx,%eax
  8009fa:	29 c2                	sub    %eax,%edx
  8009fc:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8009ff:	e9 60 ff ff ff       	jmp    800964 <vprintfmt+0x199>
  800a04:	89 cf                	mov    %ecx,%edi
  800a06:	eb 02                	jmp    800a0a <vprintfmt+0x23f>
  800a08:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800a0a:	85 ff                	test   %edi,%edi
  800a0c:	7e 10                	jle    800a1e <vprintfmt+0x253>
				putch(' ', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	53                   	push   %ebx
  800a12:	6a 20                	push   $0x20
  800a14:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a16:	83 ef 01             	sub    $0x1,%edi
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	eb ec                	jmp    800a0a <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800a1e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a21:	89 45 14             	mov    %eax,0x14(%ebp)
  800a24:	e9 63 01 00 00       	jmp    800b8c <vprintfmt+0x3c1>
	if (lflag >= 2)
  800a29:	83 f9 01             	cmp    $0x1,%ecx
  800a2c:	7f 1b                	jg     800a49 <vprintfmt+0x27e>
	else if (lflag)
  800a2e:	85 c9                	test   %ecx,%ecx
  800a30:	74 63                	je     800a95 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800a32:	8b 45 14             	mov    0x14(%ebp),%eax
  800a35:	8b 00                	mov    (%eax),%eax
  800a37:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a3a:	99                   	cltd   
  800a3b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	8d 40 04             	lea    0x4(%eax),%eax
  800a44:	89 45 14             	mov    %eax,0x14(%ebp)
  800a47:	eb 17                	jmp    800a60 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800a49:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4c:	8b 50 04             	mov    0x4(%eax),%edx
  800a4f:	8b 00                	mov    (%eax),%eax
  800a51:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a54:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	8d 40 08             	lea    0x8(%eax),%eax
  800a5d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800a60:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800a63:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800a66:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800a6b:	85 c9                	test   %ecx,%ecx
  800a6d:	0f 89 ff 00 00 00    	jns    800b72 <vprintfmt+0x3a7>
				putch('-', putdat);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	53                   	push   %ebx
  800a77:	6a 2d                	push   $0x2d
  800a79:	ff d6                	call   *%esi
				num = -(long long) num;
  800a7b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800a7e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800a81:	f7 da                	neg    %edx
  800a83:	83 d1 00             	adc    $0x0,%ecx
  800a86:	f7 d9                	neg    %ecx
  800a88:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a8b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a90:	e9 dd 00 00 00       	jmp    800b72 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800a95:	8b 45 14             	mov    0x14(%ebp),%eax
  800a98:	8b 00                	mov    (%eax),%eax
  800a9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a9d:	99                   	cltd   
  800a9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa4:	8d 40 04             	lea    0x4(%eax),%eax
  800aa7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aaa:	eb b4                	jmp    800a60 <vprintfmt+0x295>
	if (lflag >= 2)
  800aac:	83 f9 01             	cmp    $0x1,%ecx
  800aaf:	7f 1e                	jg     800acf <vprintfmt+0x304>
	else if (lflag)
  800ab1:	85 c9                	test   %ecx,%ecx
  800ab3:	74 32                	je     800ae7 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800ab5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab8:	8b 10                	mov    (%eax),%edx
  800aba:	b9 00 00 00 00       	mov    $0x0,%ecx
  800abf:	8d 40 04             	lea    0x4(%eax),%eax
  800ac2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ac5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aca:	e9 a3 00 00 00       	jmp    800b72 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	8b 10                	mov    (%eax),%edx
  800ad4:	8b 48 04             	mov    0x4(%eax),%ecx
  800ad7:	8d 40 08             	lea    0x8(%eax),%eax
  800ada:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800add:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ae2:	e9 8b 00 00 00       	jmp    800b72 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aea:	8b 10                	mov    (%eax),%edx
  800aec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800af1:	8d 40 04             	lea    0x4(%eax),%eax
  800af4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800af7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800afc:	eb 74                	jmp    800b72 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800afe:	83 f9 01             	cmp    $0x1,%ecx
  800b01:	7f 1b                	jg     800b1e <vprintfmt+0x353>
	else if (lflag)
  800b03:	85 c9                	test   %ecx,%ecx
  800b05:	74 2c                	je     800b33 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800b07:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0a:	8b 10                	mov    (%eax),%edx
  800b0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b11:	8d 40 04             	lea    0x4(%eax),%eax
  800b14:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b17:	b8 08 00 00 00       	mov    $0x8,%eax
  800b1c:	eb 54                	jmp    800b72 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b21:	8b 10                	mov    (%eax),%edx
  800b23:	8b 48 04             	mov    0x4(%eax),%ecx
  800b26:	8d 40 08             	lea    0x8(%eax),%eax
  800b29:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b2c:	b8 08 00 00 00       	mov    $0x8,%eax
  800b31:	eb 3f                	jmp    800b72 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800b33:	8b 45 14             	mov    0x14(%ebp),%eax
  800b36:	8b 10                	mov    (%eax),%edx
  800b38:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3d:	8d 40 04             	lea    0x4(%eax),%eax
  800b40:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b43:	b8 08 00 00 00       	mov    $0x8,%eax
  800b48:	eb 28                	jmp    800b72 <vprintfmt+0x3a7>
			putch('0', putdat);
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	53                   	push   %ebx
  800b4e:	6a 30                	push   $0x30
  800b50:	ff d6                	call   *%esi
			putch('x', putdat);
  800b52:	83 c4 08             	add    $0x8,%esp
  800b55:	53                   	push   %ebx
  800b56:	6a 78                	push   $0x78
  800b58:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5d:	8b 10                	mov    (%eax),%edx
  800b5f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800b64:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800b67:	8d 40 04             	lea    0x4(%eax),%eax
  800b6a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b6d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800b72:	83 ec 0c             	sub    $0xc,%esp
  800b75:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800b79:	57                   	push   %edi
  800b7a:	ff 75 e0             	pushl  -0x20(%ebp)
  800b7d:	50                   	push   %eax
  800b7e:	51                   	push   %ecx
  800b7f:	52                   	push   %edx
  800b80:	89 da                	mov    %ebx,%edx
  800b82:	89 f0                	mov    %esi,%eax
  800b84:	e8 5a fb ff ff       	call   8006e3 <printnum>
			break;
  800b89:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800b8c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b8f:	e9 55 fc ff ff       	jmp    8007e9 <vprintfmt+0x1e>
	if (lflag >= 2)
  800b94:	83 f9 01             	cmp    $0x1,%ecx
  800b97:	7f 1b                	jg     800bb4 <vprintfmt+0x3e9>
	else if (lflag)
  800b99:	85 c9                	test   %ecx,%ecx
  800b9b:	74 2c                	je     800bc9 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba0:	8b 10                	mov    (%eax),%edx
  800ba2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba7:	8d 40 04             	lea    0x4(%eax),%eax
  800baa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bad:	b8 10 00 00 00       	mov    $0x10,%eax
  800bb2:	eb be                	jmp    800b72 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800bb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb7:	8b 10                	mov    (%eax),%edx
  800bb9:	8b 48 04             	mov    0x4(%eax),%ecx
  800bbc:	8d 40 08             	lea    0x8(%eax),%eax
  800bbf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bc2:	b8 10 00 00 00       	mov    $0x10,%eax
  800bc7:	eb a9                	jmp    800b72 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcc:	8b 10                	mov    (%eax),%edx
  800bce:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd3:	8d 40 04             	lea    0x4(%eax),%eax
  800bd6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bd9:	b8 10 00 00 00       	mov    $0x10,%eax
  800bde:	eb 92                	jmp    800b72 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800be0:	83 ec 08             	sub    $0x8,%esp
  800be3:	53                   	push   %ebx
  800be4:	6a 25                	push   $0x25
  800be6:	ff d6                	call   *%esi
			break;
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	eb 9f                	jmp    800b8c <vprintfmt+0x3c1>
			putch('%', putdat);
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	53                   	push   %ebx
  800bf1:	6a 25                	push   $0x25
  800bf3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bf5:	83 c4 10             	add    $0x10,%esp
  800bf8:	89 f8                	mov    %edi,%eax
  800bfa:	eb 03                	jmp    800bff <vprintfmt+0x434>
  800bfc:	83 e8 01             	sub    $0x1,%eax
  800bff:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c03:	75 f7                	jne    800bfc <vprintfmt+0x431>
  800c05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c08:	eb 82                	jmp    800b8c <vprintfmt+0x3c1>

00800c0a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	83 ec 18             	sub    $0x18,%esp
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c16:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c19:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c1d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c27:	85 c0                	test   %eax,%eax
  800c29:	74 26                	je     800c51 <vsnprintf+0x47>
  800c2b:	85 d2                	test   %edx,%edx
  800c2d:	7e 22                	jle    800c51 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c2f:	ff 75 14             	pushl  0x14(%ebp)
  800c32:	ff 75 10             	pushl  0x10(%ebp)
  800c35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c38:	50                   	push   %eax
  800c39:	68 91 07 80 00       	push   $0x800791
  800c3e:	e8 88 fb ff ff       	call   8007cb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c46:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
}
  800c4f:	c9                   	leave  
  800c50:	c3                   	ret    
		return -E_INVAL;
  800c51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c56:	eb f7                	jmp    800c4f <vsnprintf+0x45>

00800c58 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c5e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c61:	50                   	push   %eax
  800c62:	ff 75 10             	pushl  0x10(%ebp)
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	ff 75 08             	pushl  0x8(%ebp)
  800c6b:	e8 9a ff ff ff       	call   800c0a <vsnprintf>
	va_end(ap);

	return rc;
}
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c78:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c81:	74 05                	je     800c88 <strlen+0x16>
		n++;
  800c83:	83 c0 01             	add    $0x1,%eax
  800c86:	eb f5                	jmp    800c7d <strlen+0xb>
	return n;
}
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c90:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c93:	ba 00 00 00 00       	mov    $0x0,%edx
  800c98:	39 c2                	cmp    %eax,%edx
  800c9a:	74 0d                	je     800ca9 <strnlen+0x1f>
  800c9c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ca0:	74 05                	je     800ca7 <strnlen+0x1d>
		n++;
  800ca2:	83 c2 01             	add    $0x1,%edx
  800ca5:	eb f1                	jmp    800c98 <strnlen+0xe>
  800ca7:	89 d0                	mov    %edx,%eax
	return n;
}
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	53                   	push   %ebx
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cba:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800cbe:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800cc1:	83 c2 01             	add    $0x1,%edx
  800cc4:	84 c9                	test   %cl,%cl
  800cc6:	75 f2                	jne    800cba <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800cc8:	5b                   	pop    %ebx
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    

00800ccb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	53                   	push   %ebx
  800ccf:	83 ec 10             	sub    $0x10,%esp
  800cd2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cd5:	53                   	push   %ebx
  800cd6:	e8 97 ff ff ff       	call   800c72 <strlen>
  800cdb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800cde:	ff 75 0c             	pushl  0xc(%ebp)
  800ce1:	01 d8                	add    %ebx,%eax
  800ce3:	50                   	push   %eax
  800ce4:	e8 c2 ff ff ff       	call   800cab <strcpy>
	return dst;
}
  800ce9:	89 d8                	mov    %ebx,%eax
  800ceb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cee:	c9                   	leave  
  800cef:	c3                   	ret    

00800cf0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	56                   	push   %esi
  800cf4:	53                   	push   %ebx
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfb:	89 c6                	mov    %eax,%esi
  800cfd:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d00:	89 c2                	mov    %eax,%edx
  800d02:	39 f2                	cmp    %esi,%edx
  800d04:	74 11                	je     800d17 <strncpy+0x27>
		*dst++ = *src;
  800d06:	83 c2 01             	add    $0x1,%edx
  800d09:	0f b6 19             	movzbl (%ecx),%ebx
  800d0c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d0f:	80 fb 01             	cmp    $0x1,%bl
  800d12:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800d15:	eb eb                	jmp    800d02 <strncpy+0x12>
	}
	return ret;
}
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	56                   	push   %esi
  800d1f:	53                   	push   %ebx
  800d20:	8b 75 08             	mov    0x8(%ebp),%esi
  800d23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d26:	8b 55 10             	mov    0x10(%ebp),%edx
  800d29:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d2b:	85 d2                	test   %edx,%edx
  800d2d:	74 21                	je     800d50 <strlcpy+0x35>
  800d2f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d33:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800d35:	39 c2                	cmp    %eax,%edx
  800d37:	74 14                	je     800d4d <strlcpy+0x32>
  800d39:	0f b6 19             	movzbl (%ecx),%ebx
  800d3c:	84 db                	test   %bl,%bl
  800d3e:	74 0b                	je     800d4b <strlcpy+0x30>
			*dst++ = *src++;
  800d40:	83 c1 01             	add    $0x1,%ecx
  800d43:	83 c2 01             	add    $0x1,%edx
  800d46:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d49:	eb ea                	jmp    800d35 <strlcpy+0x1a>
  800d4b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d4d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d50:	29 f0                	sub    %esi,%eax
}
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    

00800d56 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d5f:	0f b6 01             	movzbl (%ecx),%eax
  800d62:	84 c0                	test   %al,%al
  800d64:	74 0c                	je     800d72 <strcmp+0x1c>
  800d66:	3a 02                	cmp    (%edx),%al
  800d68:	75 08                	jne    800d72 <strcmp+0x1c>
		p++, q++;
  800d6a:	83 c1 01             	add    $0x1,%ecx
  800d6d:	83 c2 01             	add    $0x1,%edx
  800d70:	eb ed                	jmp    800d5f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d72:	0f b6 c0             	movzbl %al,%eax
  800d75:	0f b6 12             	movzbl (%edx),%edx
  800d78:	29 d0                	sub    %edx,%eax
}
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	53                   	push   %ebx
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d86:	89 c3                	mov    %eax,%ebx
  800d88:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d8b:	eb 06                	jmp    800d93 <strncmp+0x17>
		n--, p++, q++;
  800d8d:	83 c0 01             	add    $0x1,%eax
  800d90:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d93:	39 d8                	cmp    %ebx,%eax
  800d95:	74 16                	je     800dad <strncmp+0x31>
  800d97:	0f b6 08             	movzbl (%eax),%ecx
  800d9a:	84 c9                	test   %cl,%cl
  800d9c:	74 04                	je     800da2 <strncmp+0x26>
  800d9e:	3a 0a                	cmp    (%edx),%cl
  800da0:	74 eb                	je     800d8d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800da2:	0f b6 00             	movzbl (%eax),%eax
  800da5:	0f b6 12             	movzbl (%edx),%edx
  800da8:	29 d0                	sub    %edx,%eax
}
  800daa:	5b                   	pop    %ebx
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    
		return 0;
  800dad:	b8 00 00 00 00       	mov    $0x0,%eax
  800db2:	eb f6                	jmp    800daa <strncmp+0x2e>

00800db4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dbe:	0f b6 10             	movzbl (%eax),%edx
  800dc1:	84 d2                	test   %dl,%dl
  800dc3:	74 09                	je     800dce <strchr+0x1a>
		if (*s == c)
  800dc5:	38 ca                	cmp    %cl,%dl
  800dc7:	74 0a                	je     800dd3 <strchr+0x1f>
	for (; *s; s++)
  800dc9:	83 c0 01             	add    $0x1,%eax
  800dcc:	eb f0                	jmp    800dbe <strchr+0xa>
			return (char *) s;
	return 0;
  800dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    

00800dd5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ddf:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800de2:	38 ca                	cmp    %cl,%dl
  800de4:	74 09                	je     800def <strfind+0x1a>
  800de6:	84 d2                	test   %dl,%dl
  800de8:	74 05                	je     800def <strfind+0x1a>
	for (; *s; s++)
  800dea:	83 c0 01             	add    $0x1,%eax
  800ded:	eb f0                	jmp    800ddf <strfind+0xa>
			break;
	return (char *) s;
}
  800def:	5d                   	pop    %ebp
  800df0:	c3                   	ret    

00800df1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	57                   	push   %edi
  800df5:	56                   	push   %esi
  800df6:	53                   	push   %ebx
  800df7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800dfa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800dfd:	85 c9                	test   %ecx,%ecx
  800dff:	74 31                	je     800e32 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e01:	89 f8                	mov    %edi,%eax
  800e03:	09 c8                	or     %ecx,%eax
  800e05:	a8 03                	test   $0x3,%al
  800e07:	75 23                	jne    800e2c <memset+0x3b>
		c &= 0xFF;
  800e09:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e0d:	89 d3                	mov    %edx,%ebx
  800e0f:	c1 e3 08             	shl    $0x8,%ebx
  800e12:	89 d0                	mov    %edx,%eax
  800e14:	c1 e0 18             	shl    $0x18,%eax
  800e17:	89 d6                	mov    %edx,%esi
  800e19:	c1 e6 10             	shl    $0x10,%esi
  800e1c:	09 f0                	or     %esi,%eax
  800e1e:	09 c2                	or     %eax,%edx
  800e20:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e22:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e25:	89 d0                	mov    %edx,%eax
  800e27:	fc                   	cld    
  800e28:	f3 ab                	rep stos %eax,%es:(%edi)
  800e2a:	eb 06                	jmp    800e32 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	fc                   	cld    
  800e30:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e32:	89 f8                	mov    %edi,%eax
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	57                   	push   %edi
  800e3d:	56                   	push   %esi
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e44:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e47:	39 c6                	cmp    %eax,%esi
  800e49:	73 32                	jae    800e7d <memmove+0x44>
  800e4b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e4e:	39 c2                	cmp    %eax,%edx
  800e50:	76 2b                	jbe    800e7d <memmove+0x44>
		s += n;
		d += n;
  800e52:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e55:	89 fe                	mov    %edi,%esi
  800e57:	09 ce                	or     %ecx,%esi
  800e59:	09 d6                	or     %edx,%esi
  800e5b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e61:	75 0e                	jne    800e71 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e63:	83 ef 04             	sub    $0x4,%edi
  800e66:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e69:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e6c:	fd                   	std    
  800e6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e6f:	eb 09                	jmp    800e7a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e71:	83 ef 01             	sub    $0x1,%edi
  800e74:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e77:	fd                   	std    
  800e78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e7a:	fc                   	cld    
  800e7b:	eb 1a                	jmp    800e97 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e7d:	89 c2                	mov    %eax,%edx
  800e7f:	09 ca                	or     %ecx,%edx
  800e81:	09 f2                	or     %esi,%edx
  800e83:	f6 c2 03             	test   $0x3,%dl
  800e86:	75 0a                	jne    800e92 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e88:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e8b:	89 c7                	mov    %eax,%edi
  800e8d:	fc                   	cld    
  800e8e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e90:	eb 05                	jmp    800e97 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e92:	89 c7                	mov    %eax,%edi
  800e94:	fc                   	cld    
  800e95:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e97:	5e                   	pop    %esi
  800e98:	5f                   	pop    %edi
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ea1:	ff 75 10             	pushl  0x10(%ebp)
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	ff 75 08             	pushl  0x8(%ebp)
  800eaa:	e8 8a ff ff ff       	call   800e39 <memmove>
}
  800eaf:	c9                   	leave  
  800eb0:	c3                   	ret    

00800eb1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	56                   	push   %esi
  800eb5:	53                   	push   %ebx
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebc:	89 c6                	mov    %eax,%esi
  800ebe:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ec1:	39 f0                	cmp    %esi,%eax
  800ec3:	74 1c                	je     800ee1 <memcmp+0x30>
		if (*s1 != *s2)
  800ec5:	0f b6 08             	movzbl (%eax),%ecx
  800ec8:	0f b6 1a             	movzbl (%edx),%ebx
  800ecb:	38 d9                	cmp    %bl,%cl
  800ecd:	75 08                	jne    800ed7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ecf:	83 c0 01             	add    $0x1,%eax
  800ed2:	83 c2 01             	add    $0x1,%edx
  800ed5:	eb ea                	jmp    800ec1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ed7:	0f b6 c1             	movzbl %cl,%eax
  800eda:	0f b6 db             	movzbl %bl,%ebx
  800edd:	29 d8                	sub    %ebx,%eax
  800edf:	eb 05                	jmp    800ee6 <memcmp+0x35>
	}

	return 0;
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ef3:	89 c2                	mov    %eax,%edx
  800ef5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ef8:	39 d0                	cmp    %edx,%eax
  800efa:	73 09                	jae    800f05 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800efc:	38 08                	cmp    %cl,(%eax)
  800efe:	74 05                	je     800f05 <memfind+0x1b>
	for (; s < ends; s++)
  800f00:	83 c0 01             	add    $0x1,%eax
  800f03:	eb f3                	jmp    800ef8 <memfind+0xe>
			break;
	return (void *) s;
}
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	57                   	push   %edi
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f13:	eb 03                	jmp    800f18 <strtol+0x11>
		s++;
  800f15:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f18:	0f b6 01             	movzbl (%ecx),%eax
  800f1b:	3c 20                	cmp    $0x20,%al
  800f1d:	74 f6                	je     800f15 <strtol+0xe>
  800f1f:	3c 09                	cmp    $0x9,%al
  800f21:	74 f2                	je     800f15 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f23:	3c 2b                	cmp    $0x2b,%al
  800f25:	74 2a                	je     800f51 <strtol+0x4a>
	int neg = 0;
  800f27:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f2c:	3c 2d                	cmp    $0x2d,%al
  800f2e:	74 2b                	je     800f5b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f30:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f36:	75 0f                	jne    800f47 <strtol+0x40>
  800f38:	80 39 30             	cmpb   $0x30,(%ecx)
  800f3b:	74 28                	je     800f65 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f3d:	85 db                	test   %ebx,%ebx
  800f3f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f44:	0f 44 d8             	cmove  %eax,%ebx
  800f47:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f4f:	eb 50                	jmp    800fa1 <strtol+0x9a>
		s++;
  800f51:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f54:	bf 00 00 00 00       	mov    $0x0,%edi
  800f59:	eb d5                	jmp    800f30 <strtol+0x29>
		s++, neg = 1;
  800f5b:	83 c1 01             	add    $0x1,%ecx
  800f5e:	bf 01 00 00 00       	mov    $0x1,%edi
  800f63:	eb cb                	jmp    800f30 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f65:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f69:	74 0e                	je     800f79 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800f6b:	85 db                	test   %ebx,%ebx
  800f6d:	75 d8                	jne    800f47 <strtol+0x40>
		s++, base = 8;
  800f6f:	83 c1 01             	add    $0x1,%ecx
  800f72:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f77:	eb ce                	jmp    800f47 <strtol+0x40>
		s += 2, base = 16;
  800f79:	83 c1 02             	add    $0x2,%ecx
  800f7c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f81:	eb c4                	jmp    800f47 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f83:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f86:	89 f3                	mov    %esi,%ebx
  800f88:	80 fb 19             	cmp    $0x19,%bl
  800f8b:	77 29                	ja     800fb6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f8d:	0f be d2             	movsbl %dl,%edx
  800f90:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f93:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f96:	7d 30                	jge    800fc8 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f98:	83 c1 01             	add    $0x1,%ecx
  800f9b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f9f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800fa1:	0f b6 11             	movzbl (%ecx),%edx
  800fa4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800fa7:	89 f3                	mov    %esi,%ebx
  800fa9:	80 fb 09             	cmp    $0x9,%bl
  800fac:	77 d5                	ja     800f83 <strtol+0x7c>
			dig = *s - '0';
  800fae:	0f be d2             	movsbl %dl,%edx
  800fb1:	83 ea 30             	sub    $0x30,%edx
  800fb4:	eb dd                	jmp    800f93 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800fb6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800fb9:	89 f3                	mov    %esi,%ebx
  800fbb:	80 fb 19             	cmp    $0x19,%bl
  800fbe:	77 08                	ja     800fc8 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800fc0:	0f be d2             	movsbl %dl,%edx
  800fc3:	83 ea 37             	sub    $0x37,%edx
  800fc6:	eb cb                	jmp    800f93 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800fc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fcc:	74 05                	je     800fd3 <strtol+0xcc>
		*endptr = (char *) s;
  800fce:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fd1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	f7 da                	neg    %edx
  800fd7:	85 ff                	test   %edi,%edi
  800fd9:	0f 45 c2             	cmovne %edx,%eax
}
  800fdc:	5b                   	pop    %ebx
  800fdd:	5e                   	pop    %esi
  800fde:	5f                   	pop    %edi
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    

00800fe1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	57                   	push   %edi
  800fe5:	56                   	push   %esi
  800fe6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  800fec:	8b 55 08             	mov    0x8(%ebp),%edx
  800fef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff2:	89 c3                	mov    %eax,%ebx
  800ff4:	89 c7                	mov    %eax,%edi
  800ff6:	89 c6                	mov    %eax,%esi
  800ff8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ffa:	5b                   	pop    %ebx
  800ffb:	5e                   	pop    %esi
  800ffc:	5f                   	pop    %edi
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    

00800fff <sys_cgetc>:

int
sys_cgetc(void)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	57                   	push   %edi
  801003:	56                   	push   %esi
  801004:	53                   	push   %ebx
	asm volatile("int %1\n"
  801005:	ba 00 00 00 00       	mov    $0x0,%edx
  80100a:	b8 01 00 00 00       	mov    $0x1,%eax
  80100f:	89 d1                	mov    %edx,%ecx
  801011:	89 d3                	mov    %edx,%ebx
  801013:	89 d7                	mov    %edx,%edi
  801015:	89 d6                	mov    %edx,%esi
  801017:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801019:	5b                   	pop    %ebx
  80101a:	5e                   	pop    %esi
  80101b:	5f                   	pop    %edi
  80101c:	5d                   	pop    %ebp
  80101d:	c3                   	ret    

0080101e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
  801024:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801027:	b9 00 00 00 00       	mov    $0x0,%ecx
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	b8 03 00 00 00       	mov    $0x3,%eax
  801034:	89 cb                	mov    %ecx,%ebx
  801036:	89 cf                	mov    %ecx,%edi
  801038:	89 ce                	mov    %ecx,%esi
  80103a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103c:	85 c0                	test   %eax,%eax
  80103e:	7f 08                	jg     801048 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801040:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801043:	5b                   	pop    %ebx
  801044:	5e                   	pop    %esi
  801045:	5f                   	pop    %edi
  801046:	5d                   	pop    %ebp
  801047:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801048:	83 ec 0c             	sub    $0xc,%esp
  80104b:	50                   	push   %eax
  80104c:	6a 03                	push   $0x3
  80104e:	68 3f 2f 80 00       	push   $0x802f3f
  801053:	6a 23                	push   $0x23
  801055:	68 5c 2f 80 00       	push   $0x802f5c
  80105a:	e8 95 f5 ff ff       	call   8005f4 <_panic>

0080105f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	57                   	push   %edi
  801063:	56                   	push   %esi
  801064:	53                   	push   %ebx
	asm volatile("int %1\n"
  801065:	ba 00 00 00 00       	mov    $0x0,%edx
  80106a:	b8 02 00 00 00       	mov    $0x2,%eax
  80106f:	89 d1                	mov    %edx,%ecx
  801071:	89 d3                	mov    %edx,%ebx
  801073:	89 d7                	mov    %edx,%edi
  801075:	89 d6                	mov    %edx,%esi
  801077:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801079:	5b                   	pop    %ebx
  80107a:	5e                   	pop    %esi
  80107b:	5f                   	pop    %edi
  80107c:	5d                   	pop    %ebp
  80107d:	c3                   	ret    

0080107e <sys_yield>:

void
sys_yield(void)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
	asm volatile("int %1\n"
  801084:	ba 00 00 00 00       	mov    $0x0,%edx
  801089:	b8 0b 00 00 00       	mov    $0xb,%eax
  80108e:	89 d1                	mov    %edx,%ecx
  801090:	89 d3                	mov    %edx,%ebx
  801092:	89 d7                	mov    %edx,%edi
  801094:	89 d6                	mov    %edx,%esi
  801096:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a6:	be 00 00 00 00       	mov    $0x0,%esi
  8010ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b1:	b8 04 00 00 00       	mov    $0x4,%eax
  8010b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010b9:	89 f7                	mov    %esi,%edi
  8010bb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	7f 08                	jg     8010c9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c4:	5b                   	pop    %ebx
  8010c5:	5e                   	pop    %esi
  8010c6:	5f                   	pop    %edi
  8010c7:	5d                   	pop    %ebp
  8010c8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c9:	83 ec 0c             	sub    $0xc,%esp
  8010cc:	50                   	push   %eax
  8010cd:	6a 04                	push   $0x4
  8010cf:	68 3f 2f 80 00       	push   $0x802f3f
  8010d4:	6a 23                	push   $0x23
  8010d6:	68 5c 2f 80 00       	push   $0x802f5c
  8010db:	e8 14 f5 ff ff       	call   8005f4 <_panic>

008010e0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	57                   	push   %edi
  8010e4:	56                   	push   %esi
  8010e5:	53                   	push   %ebx
  8010e6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8010f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010f7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010fa:	8b 75 18             	mov    0x18(%ebp),%esi
  8010fd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010ff:	85 c0                	test   %eax,%eax
  801101:	7f 08                	jg     80110b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801103:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801106:	5b                   	pop    %ebx
  801107:	5e                   	pop    %esi
  801108:	5f                   	pop    %edi
  801109:	5d                   	pop    %ebp
  80110a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110b:	83 ec 0c             	sub    $0xc,%esp
  80110e:	50                   	push   %eax
  80110f:	6a 05                	push   $0x5
  801111:	68 3f 2f 80 00       	push   $0x802f3f
  801116:	6a 23                	push   $0x23
  801118:	68 5c 2f 80 00       	push   $0x802f5c
  80111d:	e8 d2 f4 ff ff       	call   8005f4 <_panic>

00801122 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	57                   	push   %edi
  801126:	56                   	push   %esi
  801127:	53                   	push   %ebx
  801128:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80112b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801130:	8b 55 08             	mov    0x8(%ebp),%edx
  801133:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801136:	b8 06 00 00 00       	mov    $0x6,%eax
  80113b:	89 df                	mov    %ebx,%edi
  80113d:	89 de                	mov    %ebx,%esi
  80113f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801141:	85 c0                	test   %eax,%eax
  801143:	7f 08                	jg     80114d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801145:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801148:	5b                   	pop    %ebx
  801149:	5e                   	pop    %esi
  80114a:	5f                   	pop    %edi
  80114b:	5d                   	pop    %ebp
  80114c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114d:	83 ec 0c             	sub    $0xc,%esp
  801150:	50                   	push   %eax
  801151:	6a 06                	push   $0x6
  801153:	68 3f 2f 80 00       	push   $0x802f3f
  801158:	6a 23                	push   $0x23
  80115a:	68 5c 2f 80 00       	push   $0x802f5c
  80115f:	e8 90 f4 ff ff       	call   8005f4 <_panic>

00801164 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	57                   	push   %edi
  801168:	56                   	push   %esi
  801169:	53                   	push   %ebx
  80116a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80116d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801172:	8b 55 08             	mov    0x8(%ebp),%edx
  801175:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801178:	b8 08 00 00 00       	mov    $0x8,%eax
  80117d:	89 df                	mov    %ebx,%edi
  80117f:	89 de                	mov    %ebx,%esi
  801181:	cd 30                	int    $0x30
	if(check && ret > 0)
  801183:	85 c0                	test   %eax,%eax
  801185:	7f 08                	jg     80118f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801187:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118a:	5b                   	pop    %ebx
  80118b:	5e                   	pop    %esi
  80118c:	5f                   	pop    %edi
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80118f:	83 ec 0c             	sub    $0xc,%esp
  801192:	50                   	push   %eax
  801193:	6a 08                	push   $0x8
  801195:	68 3f 2f 80 00       	push   $0x802f3f
  80119a:	6a 23                	push   $0x23
  80119c:	68 5c 2f 80 00       	push   $0x802f5c
  8011a1:	e8 4e f4 ff ff       	call   8005f4 <_panic>

008011a6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	57                   	push   %edi
  8011aa:	56                   	push   %esi
  8011ab:	53                   	push   %ebx
  8011ac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ba:	b8 09 00 00 00       	mov    $0x9,%eax
  8011bf:	89 df                	mov    %ebx,%edi
  8011c1:	89 de                	mov    %ebx,%esi
  8011c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	7f 08                	jg     8011d1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011cc:	5b                   	pop    %ebx
  8011cd:	5e                   	pop    %esi
  8011ce:	5f                   	pop    %edi
  8011cf:	5d                   	pop    %ebp
  8011d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d1:	83 ec 0c             	sub    $0xc,%esp
  8011d4:	50                   	push   %eax
  8011d5:	6a 09                	push   $0x9
  8011d7:	68 3f 2f 80 00       	push   $0x802f3f
  8011dc:	6a 23                	push   $0x23
  8011de:	68 5c 2f 80 00       	push   $0x802f5c
  8011e3:	e8 0c f4 ff ff       	call   8005f4 <_panic>

008011e8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	57                   	push   %edi
  8011ec:	56                   	push   %esi
  8011ed:	53                   	push   %ebx
  8011ee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  801201:	89 df                	mov    %ebx,%edi
  801203:	89 de                	mov    %ebx,%esi
  801205:	cd 30                	int    $0x30
	if(check && ret > 0)
  801207:	85 c0                	test   %eax,%eax
  801209:	7f 08                	jg     801213 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80120b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120e:	5b                   	pop    %ebx
  80120f:	5e                   	pop    %esi
  801210:	5f                   	pop    %edi
  801211:	5d                   	pop    %ebp
  801212:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801213:	83 ec 0c             	sub    $0xc,%esp
  801216:	50                   	push   %eax
  801217:	6a 0a                	push   $0xa
  801219:	68 3f 2f 80 00       	push   $0x802f3f
  80121e:	6a 23                	push   $0x23
  801220:	68 5c 2f 80 00       	push   $0x802f5c
  801225:	e8 ca f3 ff ff       	call   8005f4 <_panic>

0080122a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	57                   	push   %edi
  80122e:	56                   	push   %esi
  80122f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801230:	8b 55 08             	mov    0x8(%ebp),%edx
  801233:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801236:	b8 0c 00 00 00       	mov    $0xc,%eax
  80123b:	be 00 00 00 00       	mov    $0x0,%esi
  801240:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801243:	8b 7d 14             	mov    0x14(%ebp),%edi
  801246:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801248:	5b                   	pop    %ebx
  801249:	5e                   	pop    %esi
  80124a:	5f                   	pop    %edi
  80124b:	5d                   	pop    %ebp
  80124c:	c3                   	ret    

0080124d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	57                   	push   %edi
  801251:	56                   	push   %esi
  801252:	53                   	push   %ebx
  801253:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801256:	b9 00 00 00 00       	mov    $0x0,%ecx
  80125b:	8b 55 08             	mov    0x8(%ebp),%edx
  80125e:	b8 0d 00 00 00       	mov    $0xd,%eax
  801263:	89 cb                	mov    %ecx,%ebx
  801265:	89 cf                	mov    %ecx,%edi
  801267:	89 ce                	mov    %ecx,%esi
  801269:	cd 30                	int    $0x30
	if(check && ret > 0)
  80126b:	85 c0                	test   %eax,%eax
  80126d:	7f 08                	jg     801277 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80126f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801272:	5b                   	pop    %ebx
  801273:	5e                   	pop    %esi
  801274:	5f                   	pop    %edi
  801275:	5d                   	pop    %ebp
  801276:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801277:	83 ec 0c             	sub    $0xc,%esp
  80127a:	50                   	push   %eax
  80127b:	6a 0d                	push   $0xd
  80127d:	68 3f 2f 80 00       	push   $0x802f3f
  801282:	6a 23                	push   $0x23
  801284:	68 5c 2f 80 00       	push   $0x802f5c
  801289:	e8 66 f3 ff ff       	call   8005f4 <_panic>

0080128e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	57                   	push   %edi
  801292:	56                   	push   %esi
  801293:	53                   	push   %ebx
	asm volatile("int %1\n"
  801294:	ba 00 00 00 00       	mov    $0x0,%edx
  801299:	b8 0e 00 00 00       	mov    $0xe,%eax
  80129e:	89 d1                	mov    %edx,%ecx
  8012a0:	89 d3                	mov    %edx,%ebx
  8012a2:	89 d7                	mov    %edx,%edi
  8012a4:	89 d6                	mov    %edx,%esi
  8012a6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012a8:	5b                   	pop    %ebx
  8012a9:	5e                   	pop    %esi
  8012aa:	5f                   	pop    %edi
  8012ab:	5d                   	pop    %ebp
  8012ac:	c3                   	ret    

008012ad <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	05 00 00 00 30       	add    $0x30000000,%eax
  8012b8:	c1 e8 0c             	shr    $0xc,%eax
}
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    

008012bd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012cd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012d2:	5d                   	pop    %ebp
  8012d3:	c3                   	ret    

008012d4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012dc:	89 c2                	mov    %eax,%edx
  8012de:	c1 ea 16             	shr    $0x16,%edx
  8012e1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012e8:	f6 c2 01             	test   $0x1,%dl
  8012eb:	74 2d                	je     80131a <fd_alloc+0x46>
  8012ed:	89 c2                	mov    %eax,%edx
  8012ef:	c1 ea 0c             	shr    $0xc,%edx
  8012f2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f9:	f6 c2 01             	test   $0x1,%dl
  8012fc:	74 1c                	je     80131a <fd_alloc+0x46>
  8012fe:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801303:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801308:	75 d2                	jne    8012dc <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801313:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801318:	eb 0a                	jmp    801324 <fd_alloc+0x50>
			*fd_store = fd;
  80131a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80131f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801324:	5d                   	pop    %ebp
  801325:	c3                   	ret    

00801326 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80132c:	83 f8 1f             	cmp    $0x1f,%eax
  80132f:	77 30                	ja     801361 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801331:	c1 e0 0c             	shl    $0xc,%eax
  801334:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801339:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80133f:	f6 c2 01             	test   $0x1,%dl
  801342:	74 24                	je     801368 <fd_lookup+0x42>
  801344:	89 c2                	mov    %eax,%edx
  801346:	c1 ea 0c             	shr    $0xc,%edx
  801349:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801350:	f6 c2 01             	test   $0x1,%dl
  801353:	74 1a                	je     80136f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801355:	8b 55 0c             	mov    0xc(%ebp),%edx
  801358:	89 02                	mov    %eax,(%edx)
	return 0;
  80135a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135f:	5d                   	pop    %ebp
  801360:	c3                   	ret    
		return -E_INVAL;
  801361:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801366:	eb f7                	jmp    80135f <fd_lookup+0x39>
		return -E_INVAL;
  801368:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80136d:	eb f0                	jmp    80135f <fd_lookup+0x39>
  80136f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801374:	eb e9                	jmp    80135f <fd_lookup+0x39>

00801376 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	83 ec 08             	sub    $0x8,%esp
  80137c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80137f:	ba 00 00 00 00       	mov    $0x0,%edx
  801384:	b8 24 40 80 00       	mov    $0x804024,%eax
		if (devtab[i]->dev_id == dev_id) {
  801389:	39 08                	cmp    %ecx,(%eax)
  80138b:	74 38                	je     8013c5 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80138d:	83 c2 01             	add    $0x1,%edx
  801390:	8b 04 95 e8 2f 80 00 	mov    0x802fe8(,%edx,4),%eax
  801397:	85 c0                	test   %eax,%eax
  801399:	75 ee                	jne    801389 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80139b:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8013a0:	8b 40 48             	mov    0x48(%eax),%eax
  8013a3:	83 ec 04             	sub    $0x4,%esp
  8013a6:	51                   	push   %ecx
  8013a7:	50                   	push   %eax
  8013a8:	68 6c 2f 80 00       	push   $0x802f6c
  8013ad:	e8 1d f3 ff ff       	call   8006cf <cprintf>
	*dev = 0;
  8013b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013bb:	83 c4 10             	add    $0x10,%esp
  8013be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013c3:	c9                   	leave  
  8013c4:	c3                   	ret    
			*dev = devtab[i];
  8013c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cf:	eb f2                	jmp    8013c3 <dev_lookup+0x4d>

008013d1 <fd_close>:
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	57                   	push   %edi
  8013d5:	56                   	push   %esi
  8013d6:	53                   	push   %ebx
  8013d7:	83 ec 24             	sub    $0x24,%esp
  8013da:	8b 75 08             	mov    0x8(%ebp),%esi
  8013dd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013e3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013ea:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013ed:	50                   	push   %eax
  8013ee:	e8 33 ff ff ff       	call   801326 <fd_lookup>
  8013f3:	89 c3                	mov    %eax,%ebx
  8013f5:	83 c4 10             	add    $0x10,%esp
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	78 05                	js     801401 <fd_close+0x30>
	    || fd != fd2)
  8013fc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013ff:	74 16                	je     801417 <fd_close+0x46>
		return (must_exist ? r : 0);
  801401:	89 f8                	mov    %edi,%eax
  801403:	84 c0                	test   %al,%al
  801405:	b8 00 00 00 00       	mov    $0x0,%eax
  80140a:	0f 44 d8             	cmove  %eax,%ebx
}
  80140d:	89 d8                	mov    %ebx,%eax
  80140f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801412:	5b                   	pop    %ebx
  801413:	5e                   	pop    %esi
  801414:	5f                   	pop    %edi
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801417:	83 ec 08             	sub    $0x8,%esp
  80141a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80141d:	50                   	push   %eax
  80141e:	ff 36                	pushl  (%esi)
  801420:	e8 51 ff ff ff       	call   801376 <dev_lookup>
  801425:	89 c3                	mov    %eax,%ebx
  801427:	83 c4 10             	add    $0x10,%esp
  80142a:	85 c0                	test   %eax,%eax
  80142c:	78 1a                	js     801448 <fd_close+0x77>
		if (dev->dev_close)
  80142e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801431:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801434:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801439:	85 c0                	test   %eax,%eax
  80143b:	74 0b                	je     801448 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80143d:	83 ec 0c             	sub    $0xc,%esp
  801440:	56                   	push   %esi
  801441:	ff d0                	call   *%eax
  801443:	89 c3                	mov    %eax,%ebx
  801445:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	56                   	push   %esi
  80144c:	6a 00                	push   $0x0
  80144e:	e8 cf fc ff ff       	call   801122 <sys_page_unmap>
	return r;
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	eb b5                	jmp    80140d <fd_close+0x3c>

00801458 <close>:

int
close(int fdnum)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80145e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801461:	50                   	push   %eax
  801462:	ff 75 08             	pushl  0x8(%ebp)
  801465:	e8 bc fe ff ff       	call   801326 <fd_lookup>
  80146a:	83 c4 10             	add    $0x10,%esp
  80146d:	85 c0                	test   %eax,%eax
  80146f:	79 02                	jns    801473 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801471:	c9                   	leave  
  801472:	c3                   	ret    
		return fd_close(fd, 1);
  801473:	83 ec 08             	sub    $0x8,%esp
  801476:	6a 01                	push   $0x1
  801478:	ff 75 f4             	pushl  -0xc(%ebp)
  80147b:	e8 51 ff ff ff       	call   8013d1 <fd_close>
  801480:	83 c4 10             	add    $0x10,%esp
  801483:	eb ec                	jmp    801471 <close+0x19>

00801485 <close_all>:

void
close_all(void)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	53                   	push   %ebx
  801489:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80148c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801491:	83 ec 0c             	sub    $0xc,%esp
  801494:	53                   	push   %ebx
  801495:	e8 be ff ff ff       	call   801458 <close>
	for (i = 0; i < MAXFD; i++)
  80149a:	83 c3 01             	add    $0x1,%ebx
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	83 fb 20             	cmp    $0x20,%ebx
  8014a3:	75 ec                	jne    801491 <close_all+0xc>
}
  8014a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	57                   	push   %edi
  8014ae:	56                   	push   %esi
  8014af:	53                   	push   %ebx
  8014b0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014b6:	50                   	push   %eax
  8014b7:	ff 75 08             	pushl  0x8(%ebp)
  8014ba:	e8 67 fe ff ff       	call   801326 <fd_lookup>
  8014bf:	89 c3                	mov    %eax,%ebx
  8014c1:	83 c4 10             	add    $0x10,%esp
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	0f 88 81 00 00 00    	js     80154d <dup+0xa3>
		return r;
	close(newfdnum);
  8014cc:	83 ec 0c             	sub    $0xc,%esp
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	e8 81 ff ff ff       	call   801458 <close>

	newfd = INDEX2FD(newfdnum);
  8014d7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014da:	c1 e6 0c             	shl    $0xc,%esi
  8014dd:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014e3:	83 c4 04             	add    $0x4,%esp
  8014e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014e9:	e8 cf fd ff ff       	call   8012bd <fd2data>
  8014ee:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014f0:	89 34 24             	mov    %esi,(%esp)
  8014f3:	e8 c5 fd ff ff       	call   8012bd <fd2data>
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014fd:	89 d8                	mov    %ebx,%eax
  8014ff:	c1 e8 16             	shr    $0x16,%eax
  801502:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801509:	a8 01                	test   $0x1,%al
  80150b:	74 11                	je     80151e <dup+0x74>
  80150d:	89 d8                	mov    %ebx,%eax
  80150f:	c1 e8 0c             	shr    $0xc,%eax
  801512:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801519:	f6 c2 01             	test   $0x1,%dl
  80151c:	75 39                	jne    801557 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80151e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801521:	89 d0                	mov    %edx,%eax
  801523:	c1 e8 0c             	shr    $0xc,%eax
  801526:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80152d:	83 ec 0c             	sub    $0xc,%esp
  801530:	25 07 0e 00 00       	and    $0xe07,%eax
  801535:	50                   	push   %eax
  801536:	56                   	push   %esi
  801537:	6a 00                	push   $0x0
  801539:	52                   	push   %edx
  80153a:	6a 00                	push   $0x0
  80153c:	e8 9f fb ff ff       	call   8010e0 <sys_page_map>
  801541:	89 c3                	mov    %eax,%ebx
  801543:	83 c4 20             	add    $0x20,%esp
  801546:	85 c0                	test   %eax,%eax
  801548:	78 31                	js     80157b <dup+0xd1>
		goto err;

	return newfdnum;
  80154a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80154d:	89 d8                	mov    %ebx,%eax
  80154f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801552:	5b                   	pop    %ebx
  801553:	5e                   	pop    %esi
  801554:	5f                   	pop    %edi
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801557:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80155e:	83 ec 0c             	sub    $0xc,%esp
  801561:	25 07 0e 00 00       	and    $0xe07,%eax
  801566:	50                   	push   %eax
  801567:	57                   	push   %edi
  801568:	6a 00                	push   $0x0
  80156a:	53                   	push   %ebx
  80156b:	6a 00                	push   $0x0
  80156d:	e8 6e fb ff ff       	call   8010e0 <sys_page_map>
  801572:	89 c3                	mov    %eax,%ebx
  801574:	83 c4 20             	add    $0x20,%esp
  801577:	85 c0                	test   %eax,%eax
  801579:	79 a3                	jns    80151e <dup+0x74>
	sys_page_unmap(0, newfd);
  80157b:	83 ec 08             	sub    $0x8,%esp
  80157e:	56                   	push   %esi
  80157f:	6a 00                	push   $0x0
  801581:	e8 9c fb ff ff       	call   801122 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801586:	83 c4 08             	add    $0x8,%esp
  801589:	57                   	push   %edi
  80158a:	6a 00                	push   $0x0
  80158c:	e8 91 fb ff ff       	call   801122 <sys_page_unmap>
	return r;
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	eb b7                	jmp    80154d <dup+0xa3>

00801596 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	53                   	push   %ebx
  80159a:	83 ec 1c             	sub    $0x1c,%esp
  80159d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a3:	50                   	push   %eax
  8015a4:	53                   	push   %ebx
  8015a5:	e8 7c fd ff ff       	call   801326 <fd_lookup>
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	78 3f                	js     8015f0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b1:	83 ec 08             	sub    $0x8,%esp
  8015b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b7:	50                   	push   %eax
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bb:	ff 30                	pushl  (%eax)
  8015bd:	e8 b4 fd ff ff       	call   801376 <dev_lookup>
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	78 27                	js     8015f0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cc:	8b 42 08             	mov    0x8(%edx),%eax
  8015cf:	83 e0 03             	and    $0x3,%eax
  8015d2:	83 f8 01             	cmp    $0x1,%eax
  8015d5:	74 1e                	je     8015f5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015da:	8b 40 08             	mov    0x8(%eax),%eax
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	74 35                	je     801616 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	ff 75 10             	pushl  0x10(%ebp)
  8015e7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ea:	52                   	push   %edx
  8015eb:	ff d0                	call   *%eax
  8015ed:	83 c4 10             	add    $0x10,%esp
}
  8015f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015f5:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8015fa:	8b 40 48             	mov    0x48(%eax),%eax
  8015fd:	83 ec 04             	sub    $0x4,%esp
  801600:	53                   	push   %ebx
  801601:	50                   	push   %eax
  801602:	68 ad 2f 80 00       	push   $0x802fad
  801607:	e8 c3 f0 ff ff       	call   8006cf <cprintf>
		return -E_INVAL;
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801614:	eb da                	jmp    8015f0 <read+0x5a>
		return -E_NOT_SUPP;
  801616:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80161b:	eb d3                	jmp    8015f0 <read+0x5a>

0080161d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	57                   	push   %edi
  801621:	56                   	push   %esi
  801622:	53                   	push   %ebx
  801623:	83 ec 0c             	sub    $0xc,%esp
  801626:	8b 7d 08             	mov    0x8(%ebp),%edi
  801629:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80162c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801631:	39 f3                	cmp    %esi,%ebx
  801633:	73 23                	jae    801658 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	89 f0                	mov    %esi,%eax
  80163a:	29 d8                	sub    %ebx,%eax
  80163c:	50                   	push   %eax
  80163d:	89 d8                	mov    %ebx,%eax
  80163f:	03 45 0c             	add    0xc(%ebp),%eax
  801642:	50                   	push   %eax
  801643:	57                   	push   %edi
  801644:	e8 4d ff ff ff       	call   801596 <read>
		if (m < 0)
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	85 c0                	test   %eax,%eax
  80164e:	78 06                	js     801656 <readn+0x39>
			return m;
		if (m == 0)
  801650:	74 06                	je     801658 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801652:	01 c3                	add    %eax,%ebx
  801654:	eb db                	jmp    801631 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801656:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801658:	89 d8                	mov    %ebx,%eax
  80165a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165d:	5b                   	pop    %ebx
  80165e:	5e                   	pop    %esi
  80165f:	5f                   	pop    %edi
  801660:	5d                   	pop    %ebp
  801661:	c3                   	ret    

00801662 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	53                   	push   %ebx
  801666:	83 ec 1c             	sub    $0x1c,%esp
  801669:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80166c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80166f:	50                   	push   %eax
  801670:	53                   	push   %ebx
  801671:	e8 b0 fc ff ff       	call   801326 <fd_lookup>
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	85 c0                	test   %eax,%eax
  80167b:	78 3a                	js     8016b7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167d:	83 ec 08             	sub    $0x8,%esp
  801680:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801683:	50                   	push   %eax
  801684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801687:	ff 30                	pushl  (%eax)
  801689:	e8 e8 fc ff ff       	call   801376 <dev_lookup>
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	85 c0                	test   %eax,%eax
  801693:	78 22                	js     8016b7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801698:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80169c:	74 1e                	je     8016bc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80169e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a1:	8b 52 0c             	mov    0xc(%edx),%edx
  8016a4:	85 d2                	test   %edx,%edx
  8016a6:	74 35                	je     8016dd <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016a8:	83 ec 04             	sub    $0x4,%esp
  8016ab:	ff 75 10             	pushl  0x10(%ebp)
  8016ae:	ff 75 0c             	pushl  0xc(%ebp)
  8016b1:	50                   	push   %eax
  8016b2:	ff d2                	call   *%edx
  8016b4:	83 c4 10             	add    $0x10,%esp
}
  8016b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016bc:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8016c1:	8b 40 48             	mov    0x48(%eax),%eax
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	53                   	push   %ebx
  8016c8:	50                   	push   %eax
  8016c9:	68 c9 2f 80 00       	push   $0x802fc9
  8016ce:	e8 fc ef ff ff       	call   8006cf <cprintf>
		return -E_INVAL;
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016db:	eb da                	jmp    8016b7 <write+0x55>
		return -E_NOT_SUPP;
  8016dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016e2:	eb d3                	jmp    8016b7 <write+0x55>

008016e4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ed:	50                   	push   %eax
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	e8 30 fc ff ff       	call   801326 <fd_lookup>
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	78 0e                	js     80170b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801703:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801706:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	53                   	push   %ebx
  801711:	83 ec 1c             	sub    $0x1c,%esp
  801714:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801717:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80171a:	50                   	push   %eax
  80171b:	53                   	push   %ebx
  80171c:	e8 05 fc ff ff       	call   801326 <fd_lookup>
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	85 c0                	test   %eax,%eax
  801726:	78 37                	js     80175f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80172e:	50                   	push   %eax
  80172f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801732:	ff 30                	pushl  (%eax)
  801734:	e8 3d fc ff ff       	call   801376 <dev_lookup>
  801739:	83 c4 10             	add    $0x10,%esp
  80173c:	85 c0                	test   %eax,%eax
  80173e:	78 1f                	js     80175f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801740:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801743:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801747:	74 1b                	je     801764 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801749:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174c:	8b 52 18             	mov    0x18(%edx),%edx
  80174f:	85 d2                	test   %edx,%edx
  801751:	74 32                	je     801785 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801753:	83 ec 08             	sub    $0x8,%esp
  801756:	ff 75 0c             	pushl  0xc(%ebp)
  801759:	50                   	push   %eax
  80175a:	ff d2                	call   *%edx
  80175c:	83 c4 10             	add    $0x10,%esp
}
  80175f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801762:	c9                   	leave  
  801763:	c3                   	ret    
			thisenv->env_id, fdnum);
  801764:	a1 1c 50 80 00       	mov    0x80501c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801769:	8b 40 48             	mov    0x48(%eax),%eax
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	53                   	push   %ebx
  801770:	50                   	push   %eax
  801771:	68 8c 2f 80 00       	push   $0x802f8c
  801776:	e8 54 ef ff ff       	call   8006cf <cprintf>
		return -E_INVAL;
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801783:	eb da                	jmp    80175f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801785:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80178a:	eb d3                	jmp    80175f <ftruncate+0x52>

0080178c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	53                   	push   %ebx
  801790:	83 ec 1c             	sub    $0x1c,%esp
  801793:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801796:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801799:	50                   	push   %eax
  80179a:	ff 75 08             	pushl  0x8(%ebp)
  80179d:	e8 84 fb ff ff       	call   801326 <fd_lookup>
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 4b                	js     8017f4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017af:	50                   	push   %eax
  8017b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b3:	ff 30                	pushl  (%eax)
  8017b5:	e8 bc fb ff ff       	call   801376 <dev_lookup>
  8017ba:	83 c4 10             	add    $0x10,%esp
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	78 33                	js     8017f4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017c8:	74 2f                	je     8017f9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017ca:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017cd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017d4:	00 00 00 
	stat->st_isdir = 0;
  8017d7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017de:	00 00 00 
	stat->st_dev = dev;
  8017e1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017e7:	83 ec 08             	sub    $0x8,%esp
  8017ea:	53                   	push   %ebx
  8017eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ee:	ff 50 14             	call   *0x14(%eax)
  8017f1:	83 c4 10             	add    $0x10,%esp
}
  8017f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    
		return -E_NOT_SUPP;
  8017f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017fe:	eb f4                	jmp    8017f4 <fstat+0x68>

00801800 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	56                   	push   %esi
  801804:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801805:	83 ec 08             	sub    $0x8,%esp
  801808:	6a 00                	push   $0x0
  80180a:	ff 75 08             	pushl  0x8(%ebp)
  80180d:	e8 2f 02 00 00       	call   801a41 <open>
  801812:	89 c3                	mov    %eax,%ebx
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	85 c0                	test   %eax,%eax
  801819:	78 1b                	js     801836 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80181b:	83 ec 08             	sub    $0x8,%esp
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	50                   	push   %eax
  801822:	e8 65 ff ff ff       	call   80178c <fstat>
  801827:	89 c6                	mov    %eax,%esi
	close(fd);
  801829:	89 1c 24             	mov    %ebx,(%esp)
  80182c:	e8 27 fc ff ff       	call   801458 <close>
	return r;
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	89 f3                	mov    %esi,%ebx
}
  801836:	89 d8                	mov    %ebx,%eax
  801838:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80183b:	5b                   	pop    %ebx
  80183c:	5e                   	pop    %esi
  80183d:	5d                   	pop    %ebp
  80183e:	c3                   	ret    

0080183f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	56                   	push   %esi
  801843:	53                   	push   %ebx
  801844:	89 c6                	mov    %eax,%esi
  801846:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801848:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  80184f:	74 27                	je     801878 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801851:	6a 07                	push   $0x7
  801853:	68 00 60 80 00       	push   $0x806000
  801858:	56                   	push   %esi
  801859:	ff 35 10 50 80 00    	pushl  0x805010
  80185f:	e8 bc 0e 00 00       	call   802720 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801864:	83 c4 0c             	add    $0xc,%esp
  801867:	6a 00                	push   $0x0
  801869:	53                   	push   %ebx
  80186a:	6a 00                	push   $0x0
  80186c:	e8 3c 0e 00 00       	call   8026ad <ipc_recv>
}
  801871:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801874:	5b                   	pop    %ebx
  801875:	5e                   	pop    %esi
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801878:	83 ec 0c             	sub    $0xc,%esp
  80187b:	6a 01                	push   $0x1
  80187d:	e8 0a 0f 00 00       	call   80278c <ipc_find_env>
  801882:	a3 10 50 80 00       	mov    %eax,0x805010
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	eb c5                	jmp    801851 <fsipc+0x12>

0080188c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	8b 40 0c             	mov    0xc(%eax),%eax
  801898:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80189d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a0:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018aa:	b8 02 00 00 00       	mov    $0x2,%eax
  8018af:	e8 8b ff ff ff       	call   80183f <fsipc>
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <devfile_flush>:
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c2:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8018c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cc:	b8 06 00 00 00       	mov    $0x6,%eax
  8018d1:	e8 69 ff ff ff       	call   80183f <fsipc>
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <devfile_stat>:
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	53                   	push   %ebx
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e8:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f2:	b8 05 00 00 00       	mov    $0x5,%eax
  8018f7:	e8 43 ff ff ff       	call   80183f <fsipc>
  8018fc:	85 c0                	test   %eax,%eax
  8018fe:	78 2c                	js     80192c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801900:	83 ec 08             	sub    $0x8,%esp
  801903:	68 00 60 80 00       	push   $0x806000
  801908:	53                   	push   %ebx
  801909:	e8 9d f3 ff ff       	call   800cab <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80190e:	a1 80 60 80 00       	mov    0x806080,%eax
  801913:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801919:	a1 84 60 80 00       	mov    0x806084,%eax
  80191e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <devfile_write>:
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	53                   	push   %ebx
  801935:	83 ec 04             	sub    $0x4,%esp
  801938:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  80193b:	85 db                	test   %ebx,%ebx
  80193d:	75 07                	jne    801946 <devfile_write+0x15>
	return n_all;
  80193f:	89 d8                	mov    %ebx,%eax
}
  801941:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801944:	c9                   	leave  
  801945:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	8b 40 0c             	mov    0xc(%eax),%eax
  80194c:	a3 00 60 80 00       	mov    %eax,0x806000
	  fsipcbuf.write.req_n = n_left;
  801951:	89 1d 04 60 80 00    	mov    %ebx,0x806004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801957:	83 ec 04             	sub    $0x4,%esp
  80195a:	53                   	push   %ebx
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	68 08 60 80 00       	push   $0x806008
  801963:	e8 d1 f4 ff ff       	call   800e39 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801968:	ba 00 00 00 00       	mov    $0x0,%edx
  80196d:	b8 04 00 00 00       	mov    $0x4,%eax
  801972:	e8 c8 fe ff ff       	call   80183f <fsipc>
  801977:	83 c4 10             	add    $0x10,%esp
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 c3                	js     801941 <devfile_write+0x10>
	  assert(r <= n_left);
  80197e:	39 d8                	cmp    %ebx,%eax
  801980:	77 0b                	ja     80198d <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801982:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801987:	7f 1d                	jg     8019a6 <devfile_write+0x75>
    n_all += r;
  801989:	89 c3                	mov    %eax,%ebx
  80198b:	eb b2                	jmp    80193f <devfile_write+0xe>
	  assert(r <= n_left);
  80198d:	68 fc 2f 80 00       	push   $0x802ffc
  801992:	68 08 30 80 00       	push   $0x803008
  801997:	68 9f 00 00 00       	push   $0x9f
  80199c:	68 1d 30 80 00       	push   $0x80301d
  8019a1:	e8 4e ec ff ff       	call   8005f4 <_panic>
	  assert(r <= PGSIZE);
  8019a6:	68 28 30 80 00       	push   $0x803028
  8019ab:	68 08 30 80 00       	push   $0x803008
  8019b0:	68 a0 00 00 00       	push   $0xa0
  8019b5:	68 1d 30 80 00       	push   $0x80301d
  8019ba:	e8 35 ec ff ff       	call   8005f4 <_panic>

008019bf <devfile_read>:
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	56                   	push   %esi
  8019c3:	53                   	push   %ebx
  8019c4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8019cd:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8019d2:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8019dd:	b8 03 00 00 00       	mov    $0x3,%eax
  8019e2:	e8 58 fe ff ff       	call   80183f <fsipc>
  8019e7:	89 c3                	mov    %eax,%ebx
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	78 1f                	js     801a0c <devfile_read+0x4d>
	assert(r <= n);
  8019ed:	39 f0                	cmp    %esi,%eax
  8019ef:	77 24                	ja     801a15 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019f1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019f6:	7f 33                	jg     801a2b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019f8:	83 ec 04             	sub    $0x4,%esp
  8019fb:	50                   	push   %eax
  8019fc:	68 00 60 80 00       	push   $0x806000
  801a01:	ff 75 0c             	pushl  0xc(%ebp)
  801a04:	e8 30 f4 ff ff       	call   800e39 <memmove>
	return r;
  801a09:	83 c4 10             	add    $0x10,%esp
}
  801a0c:	89 d8                	mov    %ebx,%eax
  801a0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a11:	5b                   	pop    %ebx
  801a12:	5e                   	pop    %esi
  801a13:	5d                   	pop    %ebp
  801a14:	c3                   	ret    
	assert(r <= n);
  801a15:	68 34 30 80 00       	push   $0x803034
  801a1a:	68 08 30 80 00       	push   $0x803008
  801a1f:	6a 7c                	push   $0x7c
  801a21:	68 1d 30 80 00       	push   $0x80301d
  801a26:	e8 c9 eb ff ff       	call   8005f4 <_panic>
	assert(r <= PGSIZE);
  801a2b:	68 28 30 80 00       	push   $0x803028
  801a30:	68 08 30 80 00       	push   $0x803008
  801a35:	6a 7d                	push   $0x7d
  801a37:	68 1d 30 80 00       	push   $0x80301d
  801a3c:	e8 b3 eb ff ff       	call   8005f4 <_panic>

00801a41 <open>:
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	56                   	push   %esi
  801a45:	53                   	push   %ebx
  801a46:	83 ec 1c             	sub    $0x1c,%esp
  801a49:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a4c:	56                   	push   %esi
  801a4d:	e8 20 f2 ff ff       	call   800c72 <strlen>
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a5a:	7f 6c                	jg     801ac8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a5c:	83 ec 0c             	sub    $0xc,%esp
  801a5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a62:	50                   	push   %eax
  801a63:	e8 6c f8 ff ff       	call   8012d4 <fd_alloc>
  801a68:	89 c3                	mov    %eax,%ebx
  801a6a:	83 c4 10             	add    $0x10,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	78 3c                	js     801aad <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a71:	83 ec 08             	sub    $0x8,%esp
  801a74:	56                   	push   %esi
  801a75:	68 00 60 80 00       	push   $0x806000
  801a7a:	e8 2c f2 ff ff       	call   800cab <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a82:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8f:	e8 ab fd ff ff       	call   80183f <fsipc>
  801a94:	89 c3                	mov    %eax,%ebx
  801a96:	83 c4 10             	add    $0x10,%esp
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	78 19                	js     801ab6 <open+0x75>
	return fd2num(fd);
  801a9d:	83 ec 0c             	sub    $0xc,%esp
  801aa0:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa3:	e8 05 f8 ff ff       	call   8012ad <fd2num>
  801aa8:	89 c3                	mov    %eax,%ebx
  801aaa:	83 c4 10             	add    $0x10,%esp
}
  801aad:	89 d8                	mov    %ebx,%eax
  801aaf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab2:	5b                   	pop    %ebx
  801ab3:	5e                   	pop    %esi
  801ab4:	5d                   	pop    %ebp
  801ab5:	c3                   	ret    
		fd_close(fd, 0);
  801ab6:	83 ec 08             	sub    $0x8,%esp
  801ab9:	6a 00                	push   $0x0
  801abb:	ff 75 f4             	pushl  -0xc(%ebp)
  801abe:	e8 0e f9 ff ff       	call   8013d1 <fd_close>
		return r;
  801ac3:	83 c4 10             	add    $0x10,%esp
  801ac6:	eb e5                	jmp    801aad <open+0x6c>
		return -E_BAD_PATH;
  801ac8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801acd:	eb de                	jmp    801aad <open+0x6c>

00801acf <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  801ada:	b8 08 00 00 00       	mov    $0x8,%eax
  801adf:	e8 5b fd ff ff       	call   80183f <fsipc>
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	56                   	push   %esi
  801aea:	53                   	push   %ebx
  801aeb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801aee:	83 ec 0c             	sub    $0xc,%esp
  801af1:	ff 75 08             	pushl  0x8(%ebp)
  801af4:	e8 c4 f7 ff ff       	call   8012bd <fd2data>
  801af9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801afb:	83 c4 08             	add    $0x8,%esp
  801afe:	68 3b 30 80 00       	push   $0x80303b
  801b03:	53                   	push   %ebx
  801b04:	e8 a2 f1 ff ff       	call   800cab <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b09:	8b 46 04             	mov    0x4(%esi),%eax
  801b0c:	2b 06                	sub    (%esi),%eax
  801b0e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b14:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b1b:	00 00 00 
	stat->st_dev = &devpipe;
  801b1e:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  801b25:	40 80 00 
	return 0;
}
  801b28:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b30:	5b                   	pop    %ebx
  801b31:	5e                   	pop    %esi
  801b32:	5d                   	pop    %ebp
  801b33:	c3                   	ret    

00801b34 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	53                   	push   %ebx
  801b38:	83 ec 0c             	sub    $0xc,%esp
  801b3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b3e:	53                   	push   %ebx
  801b3f:	6a 00                	push   $0x0
  801b41:	e8 dc f5 ff ff       	call   801122 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b46:	89 1c 24             	mov    %ebx,(%esp)
  801b49:	e8 6f f7 ff ff       	call   8012bd <fd2data>
  801b4e:	83 c4 08             	add    $0x8,%esp
  801b51:	50                   	push   %eax
  801b52:	6a 00                	push   $0x0
  801b54:	e8 c9 f5 ff ff       	call   801122 <sys_page_unmap>
}
  801b59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <_pipeisclosed>:
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	57                   	push   %edi
  801b62:	56                   	push   %esi
  801b63:	53                   	push   %ebx
  801b64:	83 ec 1c             	sub    $0x1c,%esp
  801b67:	89 c7                	mov    %eax,%edi
  801b69:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b6b:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801b70:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b73:	83 ec 0c             	sub    $0xc,%esp
  801b76:	57                   	push   %edi
  801b77:	e8 49 0c 00 00       	call   8027c5 <pageref>
  801b7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b7f:	89 34 24             	mov    %esi,(%esp)
  801b82:	e8 3e 0c 00 00       	call   8027c5 <pageref>
		nn = thisenv->env_runs;
  801b87:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  801b8d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b90:	83 c4 10             	add    $0x10,%esp
  801b93:	39 cb                	cmp    %ecx,%ebx
  801b95:	74 1b                	je     801bb2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b97:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b9a:	75 cf                	jne    801b6b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b9c:	8b 42 58             	mov    0x58(%edx),%eax
  801b9f:	6a 01                	push   $0x1
  801ba1:	50                   	push   %eax
  801ba2:	53                   	push   %ebx
  801ba3:	68 42 30 80 00       	push   $0x803042
  801ba8:	e8 22 eb ff ff       	call   8006cf <cprintf>
  801bad:	83 c4 10             	add    $0x10,%esp
  801bb0:	eb b9                	jmp    801b6b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bb2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bb5:	0f 94 c0             	sete   %al
  801bb8:	0f b6 c0             	movzbl %al,%eax
}
  801bbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bbe:	5b                   	pop    %ebx
  801bbf:	5e                   	pop    %esi
  801bc0:	5f                   	pop    %edi
  801bc1:	5d                   	pop    %ebp
  801bc2:	c3                   	ret    

00801bc3 <devpipe_write>:
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	57                   	push   %edi
  801bc7:	56                   	push   %esi
  801bc8:	53                   	push   %ebx
  801bc9:	83 ec 28             	sub    $0x28,%esp
  801bcc:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bcf:	56                   	push   %esi
  801bd0:	e8 e8 f6 ff ff       	call   8012bd <fd2data>
  801bd5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	bf 00 00 00 00       	mov    $0x0,%edi
  801bdf:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801be2:	74 4f                	je     801c33 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801be4:	8b 43 04             	mov    0x4(%ebx),%eax
  801be7:	8b 0b                	mov    (%ebx),%ecx
  801be9:	8d 51 20             	lea    0x20(%ecx),%edx
  801bec:	39 d0                	cmp    %edx,%eax
  801bee:	72 14                	jb     801c04 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801bf0:	89 da                	mov    %ebx,%edx
  801bf2:	89 f0                	mov    %esi,%eax
  801bf4:	e8 65 ff ff ff       	call   801b5e <_pipeisclosed>
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	75 3b                	jne    801c38 <devpipe_write+0x75>
			sys_yield();
  801bfd:	e8 7c f4 ff ff       	call   80107e <sys_yield>
  801c02:	eb e0                	jmp    801be4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c07:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c0b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c0e:	89 c2                	mov    %eax,%edx
  801c10:	c1 fa 1f             	sar    $0x1f,%edx
  801c13:	89 d1                	mov    %edx,%ecx
  801c15:	c1 e9 1b             	shr    $0x1b,%ecx
  801c18:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c1b:	83 e2 1f             	and    $0x1f,%edx
  801c1e:	29 ca                	sub    %ecx,%edx
  801c20:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c24:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c28:	83 c0 01             	add    $0x1,%eax
  801c2b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c2e:	83 c7 01             	add    $0x1,%edi
  801c31:	eb ac                	jmp    801bdf <devpipe_write+0x1c>
	return i;
  801c33:	8b 45 10             	mov    0x10(%ebp),%eax
  801c36:	eb 05                	jmp    801c3d <devpipe_write+0x7a>
				return 0;
  801c38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c40:	5b                   	pop    %ebx
  801c41:	5e                   	pop    %esi
  801c42:	5f                   	pop    %edi
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    

00801c45 <devpipe_read>:
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	57                   	push   %edi
  801c49:	56                   	push   %esi
  801c4a:	53                   	push   %ebx
  801c4b:	83 ec 18             	sub    $0x18,%esp
  801c4e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c51:	57                   	push   %edi
  801c52:	e8 66 f6 ff ff       	call   8012bd <fd2data>
  801c57:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c59:	83 c4 10             	add    $0x10,%esp
  801c5c:	be 00 00 00 00       	mov    $0x0,%esi
  801c61:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c64:	75 14                	jne    801c7a <devpipe_read+0x35>
	return i;
  801c66:	8b 45 10             	mov    0x10(%ebp),%eax
  801c69:	eb 02                	jmp    801c6d <devpipe_read+0x28>
				return i;
  801c6b:	89 f0                	mov    %esi,%eax
}
  801c6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5f                   	pop    %edi
  801c73:	5d                   	pop    %ebp
  801c74:	c3                   	ret    
			sys_yield();
  801c75:	e8 04 f4 ff ff       	call   80107e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c7a:	8b 03                	mov    (%ebx),%eax
  801c7c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c7f:	75 18                	jne    801c99 <devpipe_read+0x54>
			if (i > 0)
  801c81:	85 f6                	test   %esi,%esi
  801c83:	75 e6                	jne    801c6b <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801c85:	89 da                	mov    %ebx,%edx
  801c87:	89 f8                	mov    %edi,%eax
  801c89:	e8 d0 fe ff ff       	call   801b5e <_pipeisclosed>
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	74 e3                	je     801c75 <devpipe_read+0x30>
				return 0;
  801c92:	b8 00 00 00 00       	mov    $0x0,%eax
  801c97:	eb d4                	jmp    801c6d <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c99:	99                   	cltd   
  801c9a:	c1 ea 1b             	shr    $0x1b,%edx
  801c9d:	01 d0                	add    %edx,%eax
  801c9f:	83 e0 1f             	and    $0x1f,%eax
  801ca2:	29 d0                	sub    %edx,%eax
  801ca4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ca9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cac:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801caf:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cb2:	83 c6 01             	add    $0x1,%esi
  801cb5:	eb aa                	jmp    801c61 <devpipe_read+0x1c>

00801cb7 <pipe>:
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	56                   	push   %esi
  801cbb:	53                   	push   %ebx
  801cbc:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc2:	50                   	push   %eax
  801cc3:	e8 0c f6 ff ff       	call   8012d4 <fd_alloc>
  801cc8:	89 c3                	mov    %eax,%ebx
  801cca:	83 c4 10             	add    $0x10,%esp
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	0f 88 23 01 00 00    	js     801df8 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cd5:	83 ec 04             	sub    $0x4,%esp
  801cd8:	68 07 04 00 00       	push   $0x407
  801cdd:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce0:	6a 00                	push   $0x0
  801ce2:	e8 b6 f3 ff ff       	call   80109d <sys_page_alloc>
  801ce7:	89 c3                	mov    %eax,%ebx
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	85 c0                	test   %eax,%eax
  801cee:	0f 88 04 01 00 00    	js     801df8 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801cf4:	83 ec 0c             	sub    $0xc,%esp
  801cf7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cfa:	50                   	push   %eax
  801cfb:	e8 d4 f5 ff ff       	call   8012d4 <fd_alloc>
  801d00:	89 c3                	mov    %eax,%ebx
  801d02:	83 c4 10             	add    $0x10,%esp
  801d05:	85 c0                	test   %eax,%eax
  801d07:	0f 88 db 00 00 00    	js     801de8 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	68 07 04 00 00       	push   $0x407
  801d15:	ff 75 f0             	pushl  -0x10(%ebp)
  801d18:	6a 00                	push   $0x0
  801d1a:	e8 7e f3 ff ff       	call   80109d <sys_page_alloc>
  801d1f:	89 c3                	mov    %eax,%ebx
  801d21:	83 c4 10             	add    $0x10,%esp
  801d24:	85 c0                	test   %eax,%eax
  801d26:	0f 88 bc 00 00 00    	js     801de8 <pipe+0x131>
	va = fd2data(fd0);
  801d2c:	83 ec 0c             	sub    $0xc,%esp
  801d2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d32:	e8 86 f5 ff ff       	call   8012bd <fd2data>
  801d37:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d39:	83 c4 0c             	add    $0xc,%esp
  801d3c:	68 07 04 00 00       	push   $0x407
  801d41:	50                   	push   %eax
  801d42:	6a 00                	push   $0x0
  801d44:	e8 54 f3 ff ff       	call   80109d <sys_page_alloc>
  801d49:	89 c3                	mov    %eax,%ebx
  801d4b:	83 c4 10             	add    $0x10,%esp
  801d4e:	85 c0                	test   %eax,%eax
  801d50:	0f 88 82 00 00 00    	js     801dd8 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d56:	83 ec 0c             	sub    $0xc,%esp
  801d59:	ff 75 f0             	pushl  -0x10(%ebp)
  801d5c:	e8 5c f5 ff ff       	call   8012bd <fd2data>
  801d61:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d68:	50                   	push   %eax
  801d69:	6a 00                	push   $0x0
  801d6b:	56                   	push   %esi
  801d6c:	6a 00                	push   $0x0
  801d6e:	e8 6d f3 ff ff       	call   8010e0 <sys_page_map>
  801d73:	89 c3                	mov    %eax,%ebx
  801d75:	83 c4 20             	add    $0x20,%esp
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	78 4e                	js     801dca <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801d7c:	a1 40 40 80 00       	mov    0x804040,%eax
  801d81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d84:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d89:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d93:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d98:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d9f:	83 ec 0c             	sub    $0xc,%esp
  801da2:	ff 75 f4             	pushl  -0xc(%ebp)
  801da5:	e8 03 f5 ff ff       	call   8012ad <fd2num>
  801daa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dad:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801daf:	83 c4 04             	add    $0x4,%esp
  801db2:	ff 75 f0             	pushl  -0x10(%ebp)
  801db5:	e8 f3 f4 ff ff       	call   8012ad <fd2num>
  801dba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dbd:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dc8:	eb 2e                	jmp    801df8 <pipe+0x141>
	sys_page_unmap(0, va);
  801dca:	83 ec 08             	sub    $0x8,%esp
  801dcd:	56                   	push   %esi
  801dce:	6a 00                	push   $0x0
  801dd0:	e8 4d f3 ff ff       	call   801122 <sys_page_unmap>
  801dd5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dd8:	83 ec 08             	sub    $0x8,%esp
  801ddb:	ff 75 f0             	pushl  -0x10(%ebp)
  801dde:	6a 00                	push   $0x0
  801de0:	e8 3d f3 ff ff       	call   801122 <sys_page_unmap>
  801de5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801de8:	83 ec 08             	sub    $0x8,%esp
  801deb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dee:	6a 00                	push   $0x0
  801df0:	e8 2d f3 ff ff       	call   801122 <sys_page_unmap>
  801df5:	83 c4 10             	add    $0x10,%esp
}
  801df8:	89 d8                	mov    %ebx,%eax
  801dfa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dfd:	5b                   	pop    %ebx
  801dfe:	5e                   	pop    %esi
  801dff:	5d                   	pop    %ebp
  801e00:	c3                   	ret    

00801e01 <pipeisclosed>:
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e0a:	50                   	push   %eax
  801e0b:	ff 75 08             	pushl  0x8(%ebp)
  801e0e:	e8 13 f5 ff ff       	call   801326 <fd_lookup>
  801e13:	83 c4 10             	add    $0x10,%esp
  801e16:	85 c0                	test   %eax,%eax
  801e18:	78 18                	js     801e32 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e1a:	83 ec 0c             	sub    $0xc,%esp
  801e1d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e20:	e8 98 f4 ff ff       	call   8012bd <fd2data>
	return _pipeisclosed(fd, p);
  801e25:	89 c2                	mov    %eax,%edx
  801e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2a:	e8 2f fd ff ff       	call   801b5e <_pipeisclosed>
  801e2f:	83 c4 10             	add    $0x10,%esp
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e3a:	68 5a 30 80 00       	push   $0x80305a
  801e3f:	ff 75 0c             	pushl  0xc(%ebp)
  801e42:	e8 64 ee ff ff       	call   800cab <strcpy>
	return 0;
}
  801e47:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <devsock_close>:
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	53                   	push   %ebx
  801e52:	83 ec 10             	sub    $0x10,%esp
  801e55:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e58:	53                   	push   %ebx
  801e59:	e8 67 09 00 00       	call   8027c5 <pageref>
  801e5e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e61:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e66:	83 f8 01             	cmp    $0x1,%eax
  801e69:	74 07                	je     801e72 <devsock_close+0x24>
}
  801e6b:	89 d0                	mov    %edx,%eax
  801e6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e72:	83 ec 0c             	sub    $0xc,%esp
  801e75:	ff 73 0c             	pushl  0xc(%ebx)
  801e78:	e8 b9 02 00 00       	call   802136 <nsipc_close>
  801e7d:	89 c2                	mov    %eax,%edx
  801e7f:	83 c4 10             	add    $0x10,%esp
  801e82:	eb e7                	jmp    801e6b <devsock_close+0x1d>

00801e84 <devsock_write>:
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	ff 75 10             	pushl  0x10(%ebp)
  801e8f:	ff 75 0c             	pushl  0xc(%ebp)
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	ff 70 0c             	pushl  0xc(%eax)
  801e98:	e8 76 03 00 00       	call   802213 <nsipc_send>
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <devsock_read>:
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ea5:	6a 00                	push   $0x0
  801ea7:	ff 75 10             	pushl  0x10(%ebp)
  801eaa:	ff 75 0c             	pushl  0xc(%ebp)
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	ff 70 0c             	pushl  0xc(%eax)
  801eb3:	e8 ef 02 00 00       	call   8021a7 <nsipc_recv>
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <fd2sockid>:
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ec0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ec3:	52                   	push   %edx
  801ec4:	50                   	push   %eax
  801ec5:	e8 5c f4 ff ff       	call   801326 <fd_lookup>
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	78 10                	js     801ee1 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	8b 0d 5c 40 80 00    	mov    0x80405c,%ecx
  801eda:	39 08                	cmp    %ecx,(%eax)
  801edc:	75 05                	jne    801ee3 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ede:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    
		return -E_NOT_SUPP;
  801ee3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ee8:	eb f7                	jmp    801ee1 <fd2sockid+0x27>

00801eea <alloc_sockfd>:
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	56                   	push   %esi
  801eee:	53                   	push   %ebx
  801eef:	83 ec 1c             	sub    $0x1c,%esp
  801ef2:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ef4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef7:	50                   	push   %eax
  801ef8:	e8 d7 f3 ff ff       	call   8012d4 <fd_alloc>
  801efd:	89 c3                	mov    %eax,%ebx
  801eff:	83 c4 10             	add    $0x10,%esp
  801f02:	85 c0                	test   %eax,%eax
  801f04:	78 43                	js     801f49 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f06:	83 ec 04             	sub    $0x4,%esp
  801f09:	68 07 04 00 00       	push   $0x407
  801f0e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f11:	6a 00                	push   $0x0
  801f13:	e8 85 f1 ff ff       	call   80109d <sys_page_alloc>
  801f18:	89 c3                	mov    %eax,%ebx
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	78 28                	js     801f49 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f24:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  801f2a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f36:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f39:	83 ec 0c             	sub    $0xc,%esp
  801f3c:	50                   	push   %eax
  801f3d:	e8 6b f3 ff ff       	call   8012ad <fd2num>
  801f42:	89 c3                	mov    %eax,%ebx
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	eb 0c                	jmp    801f55 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f49:	83 ec 0c             	sub    $0xc,%esp
  801f4c:	56                   	push   %esi
  801f4d:	e8 e4 01 00 00       	call   802136 <nsipc_close>
		return r;
  801f52:	83 c4 10             	add    $0x10,%esp
}
  801f55:	89 d8                	mov    %ebx,%eax
  801f57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f5a:	5b                   	pop    %ebx
  801f5b:	5e                   	pop    %esi
  801f5c:	5d                   	pop    %ebp
  801f5d:	c3                   	ret    

00801f5e <accept>:
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	e8 4e ff ff ff       	call   801eba <fd2sockid>
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	78 1b                	js     801f8b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f70:	83 ec 04             	sub    $0x4,%esp
  801f73:	ff 75 10             	pushl  0x10(%ebp)
  801f76:	ff 75 0c             	pushl  0xc(%ebp)
  801f79:	50                   	push   %eax
  801f7a:	e8 0e 01 00 00       	call   80208d <nsipc_accept>
  801f7f:	83 c4 10             	add    $0x10,%esp
  801f82:	85 c0                	test   %eax,%eax
  801f84:	78 05                	js     801f8b <accept+0x2d>
	return alloc_sockfd(r);
  801f86:	e8 5f ff ff ff       	call   801eea <alloc_sockfd>
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <bind>:
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f93:	8b 45 08             	mov    0x8(%ebp),%eax
  801f96:	e8 1f ff ff ff       	call   801eba <fd2sockid>
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	78 12                	js     801fb1 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f9f:	83 ec 04             	sub    $0x4,%esp
  801fa2:	ff 75 10             	pushl  0x10(%ebp)
  801fa5:	ff 75 0c             	pushl  0xc(%ebp)
  801fa8:	50                   	push   %eax
  801fa9:	e8 31 01 00 00       	call   8020df <nsipc_bind>
  801fae:	83 c4 10             	add    $0x10,%esp
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <shutdown>:
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	e8 f9 fe ff ff       	call   801eba <fd2sockid>
  801fc1:	85 c0                	test   %eax,%eax
  801fc3:	78 0f                	js     801fd4 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fc5:	83 ec 08             	sub    $0x8,%esp
  801fc8:	ff 75 0c             	pushl  0xc(%ebp)
  801fcb:	50                   	push   %eax
  801fcc:	e8 43 01 00 00       	call   802114 <nsipc_shutdown>
  801fd1:	83 c4 10             	add    $0x10,%esp
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <connect>:
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	e8 d6 fe ff ff       	call   801eba <fd2sockid>
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	78 12                	js     801ffa <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	ff 75 10             	pushl  0x10(%ebp)
  801fee:	ff 75 0c             	pushl  0xc(%ebp)
  801ff1:	50                   	push   %eax
  801ff2:	e8 59 01 00 00       	call   802150 <nsipc_connect>
  801ff7:	83 c4 10             	add    $0x10,%esp
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <listen>:
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	e8 b0 fe ff ff       	call   801eba <fd2sockid>
  80200a:	85 c0                	test   %eax,%eax
  80200c:	78 0f                	js     80201d <listen+0x21>
	return nsipc_listen(r, backlog);
  80200e:	83 ec 08             	sub    $0x8,%esp
  802011:	ff 75 0c             	pushl  0xc(%ebp)
  802014:	50                   	push   %eax
  802015:	e8 6b 01 00 00       	call   802185 <nsipc_listen>
  80201a:	83 c4 10             	add    $0x10,%esp
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <socket>:

int
socket(int domain, int type, int protocol)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802025:	ff 75 10             	pushl  0x10(%ebp)
  802028:	ff 75 0c             	pushl  0xc(%ebp)
  80202b:	ff 75 08             	pushl  0x8(%ebp)
  80202e:	e8 3e 02 00 00       	call   802271 <nsipc_socket>
  802033:	83 c4 10             	add    $0x10,%esp
  802036:	85 c0                	test   %eax,%eax
  802038:	78 05                	js     80203f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80203a:	e8 ab fe ff ff       	call   801eea <alloc_sockfd>
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	53                   	push   %ebx
  802045:	83 ec 04             	sub    $0x4,%esp
  802048:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80204a:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  802051:	74 26                	je     802079 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802053:	6a 07                	push   $0x7
  802055:	68 00 70 80 00       	push   $0x807000
  80205a:	53                   	push   %ebx
  80205b:	ff 35 14 50 80 00    	pushl  0x805014
  802061:	e8 ba 06 00 00       	call   802720 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802066:	83 c4 0c             	add    $0xc,%esp
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	e8 39 06 00 00       	call   8026ad <ipc_recv>
}
  802074:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802077:	c9                   	leave  
  802078:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802079:	83 ec 0c             	sub    $0xc,%esp
  80207c:	6a 02                	push   $0x2
  80207e:	e8 09 07 00 00       	call   80278c <ipc_find_env>
  802083:	a3 14 50 80 00       	mov    %eax,0x805014
  802088:	83 c4 10             	add    $0x10,%esp
  80208b:	eb c6                	jmp    802053 <nsipc+0x12>

0080208d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	56                   	push   %esi
  802091:	53                   	push   %ebx
  802092:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80209d:	8b 06                	mov    (%esi),%eax
  80209f:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a9:	e8 93 ff ff ff       	call   802041 <nsipc>
  8020ae:	89 c3                	mov    %eax,%ebx
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	79 09                	jns    8020bd <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020b4:	89 d8                	mov    %ebx,%eax
  8020b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020b9:	5b                   	pop    %ebx
  8020ba:	5e                   	pop    %esi
  8020bb:	5d                   	pop    %ebp
  8020bc:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020bd:	83 ec 04             	sub    $0x4,%esp
  8020c0:	ff 35 10 70 80 00    	pushl  0x807010
  8020c6:	68 00 70 80 00       	push   $0x807000
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	e8 66 ed ff ff       	call   800e39 <memmove>
		*addrlen = ret->ret_addrlen;
  8020d3:	a1 10 70 80 00       	mov    0x807010,%eax
  8020d8:	89 06                	mov    %eax,(%esi)
  8020da:	83 c4 10             	add    $0x10,%esp
	return r;
  8020dd:	eb d5                	jmp    8020b4 <nsipc_accept+0x27>

008020df <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	53                   	push   %ebx
  8020e3:	83 ec 08             	sub    $0x8,%esp
  8020e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020f1:	53                   	push   %ebx
  8020f2:	ff 75 0c             	pushl  0xc(%ebp)
  8020f5:	68 04 70 80 00       	push   $0x807004
  8020fa:	e8 3a ed ff ff       	call   800e39 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020ff:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802105:	b8 02 00 00 00       	mov    $0x2,%eax
  80210a:	e8 32 ff ff ff       	call   802041 <nsipc>
}
  80210f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802122:	8b 45 0c             	mov    0xc(%ebp),%eax
  802125:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80212a:	b8 03 00 00 00       	mov    $0x3,%eax
  80212f:	e8 0d ff ff ff       	call   802041 <nsipc>
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <nsipc_close>:

int
nsipc_close(int s)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802144:	b8 04 00 00 00       	mov    $0x4,%eax
  802149:	e8 f3 fe ff ff       	call   802041 <nsipc>
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	53                   	push   %ebx
  802154:	83 ec 08             	sub    $0x8,%esp
  802157:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802162:	53                   	push   %ebx
  802163:	ff 75 0c             	pushl  0xc(%ebp)
  802166:	68 04 70 80 00       	push   $0x807004
  80216b:	e8 c9 ec ff ff       	call   800e39 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802170:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802176:	b8 05 00 00 00       	mov    $0x5,%eax
  80217b:	e8 c1 fe ff ff       	call   802041 <nsipc>
}
  802180:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802193:	8b 45 0c             	mov    0xc(%ebp),%eax
  802196:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80219b:	b8 06 00 00 00       	mov    $0x6,%eax
  8021a0:	e8 9c fe ff ff       	call   802041 <nsipc>
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	56                   	push   %esi
  8021ab:	53                   	push   %ebx
  8021ac:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021b7:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8021c0:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021c5:	b8 07 00 00 00       	mov    $0x7,%eax
  8021ca:	e8 72 fe ff ff       	call   802041 <nsipc>
  8021cf:	89 c3                	mov    %eax,%ebx
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	78 1f                	js     8021f4 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021d5:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021da:	7f 21                	jg     8021fd <nsipc_recv+0x56>
  8021dc:	39 c6                	cmp    %eax,%esi
  8021de:	7c 1d                	jl     8021fd <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021e0:	83 ec 04             	sub    $0x4,%esp
  8021e3:	50                   	push   %eax
  8021e4:	68 00 70 80 00       	push   $0x807000
  8021e9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ec:	e8 48 ec ff ff       	call   800e39 <memmove>
  8021f1:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021f4:	89 d8                	mov    %ebx,%eax
  8021f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f9:	5b                   	pop    %ebx
  8021fa:	5e                   	pop    %esi
  8021fb:	5d                   	pop    %ebp
  8021fc:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021fd:	68 66 30 80 00       	push   $0x803066
  802202:	68 08 30 80 00       	push   $0x803008
  802207:	6a 62                	push   $0x62
  802209:	68 7b 30 80 00       	push   $0x80307b
  80220e:	e8 e1 e3 ff ff       	call   8005f4 <_panic>

00802213 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
  802216:	53                   	push   %ebx
  802217:	83 ec 04             	sub    $0x4,%esp
  80221a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802225:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80222b:	7f 2e                	jg     80225b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80222d:	83 ec 04             	sub    $0x4,%esp
  802230:	53                   	push   %ebx
  802231:	ff 75 0c             	pushl  0xc(%ebp)
  802234:	68 0c 70 80 00       	push   $0x80700c
  802239:	e8 fb eb ff ff       	call   800e39 <memmove>
	nsipcbuf.send.req_size = size;
  80223e:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802244:	8b 45 14             	mov    0x14(%ebp),%eax
  802247:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80224c:	b8 08 00 00 00       	mov    $0x8,%eax
  802251:	e8 eb fd ff ff       	call   802041 <nsipc>
}
  802256:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802259:	c9                   	leave  
  80225a:	c3                   	ret    
	assert(size < 1600);
  80225b:	68 87 30 80 00       	push   $0x803087
  802260:	68 08 30 80 00       	push   $0x803008
  802265:	6a 6d                	push   $0x6d
  802267:	68 7b 30 80 00       	push   $0x80307b
  80226c:	e8 83 e3 ff ff       	call   8005f4 <_panic>

00802271 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80227f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802282:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802287:	8b 45 10             	mov    0x10(%ebp),%eax
  80228a:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80228f:	b8 09 00 00 00       	mov    $0x9,%eax
  802294:	e8 a8 fd ff ff       	call   802041 <nsipc>
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <free>:
	return v;
}

void
free(void *v)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	53                   	push   %ebx
  80229f:	83 ec 04             	sub    $0x4,%esp
  8022a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  8022a5:	85 db                	test   %ebx,%ebx
  8022a7:	0f 84 85 00 00 00    	je     802332 <free+0x97>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8022ad:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  8022b3:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  8022b8:	77 51                	ja     80230b <free+0x70>

	c = ROUNDDOWN(v, PGSIZE);
  8022ba:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  8022c0:	89 d8                	mov    %ebx,%eax
  8022c2:	c1 e8 0c             	shr    $0xc,%eax
  8022c5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8022cc:	f6 c4 02             	test   $0x2,%ah
  8022cf:	74 50                	je     802321 <free+0x86>
		sys_page_unmap(0, c);
  8022d1:	83 ec 08             	sub    $0x8,%esp
  8022d4:	53                   	push   %ebx
  8022d5:	6a 00                	push   $0x0
  8022d7:	e8 46 ee ff ff       	call   801122 <sys_page_unmap>
		c += PGSIZE;
  8022dc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  8022e2:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  8022e8:	83 c4 10             	add    $0x10,%esp
  8022eb:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  8022f0:	76 ce                	jbe    8022c0 <free+0x25>
  8022f2:	68 cf 30 80 00       	push   $0x8030cf
  8022f7:	68 08 30 80 00       	push   $0x803008
  8022fc:	68 81 00 00 00       	push   $0x81
  802301:	68 c2 30 80 00       	push   $0x8030c2
  802306:	e8 e9 e2 ff ff       	call   8005f4 <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  80230b:	68 94 30 80 00       	push   $0x803094
  802310:	68 08 30 80 00       	push   $0x803008
  802315:	6a 7a                	push   $0x7a
  802317:	68 c2 30 80 00       	push   $0x8030c2
  80231c:	e8 d3 e2 ff ff       	call   8005f4 <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  802321:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  802327:	83 e8 01             	sub    $0x1,%eax
  80232a:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  802330:	74 05                	je     802337 <free+0x9c>
		sys_page_unmap(0, c);
}
  802332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802335:	c9                   	leave  
  802336:	c3                   	ret    
		sys_page_unmap(0, c);
  802337:	83 ec 08             	sub    $0x8,%esp
  80233a:	53                   	push   %ebx
  80233b:	6a 00                	push   $0x0
  80233d:	e8 e0 ed ff ff       	call   801122 <sys_page_unmap>
  802342:	83 c4 10             	add    $0x10,%esp
  802345:	eb eb                	jmp    802332 <free+0x97>

00802347 <malloc>:
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
  80234a:	57                   	push   %edi
  80234b:	56                   	push   %esi
  80234c:	53                   	push   %ebx
  80234d:	83 ec 1c             	sub    $0x1c,%esp
	if (mptr == 0)
  802350:	a1 18 50 80 00       	mov    0x805018,%eax
  802355:	85 c0                	test   %eax,%eax
  802357:	74 74                	je     8023cd <malloc+0x86>
	n = ROUNDUP(n, 4);
  802359:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80235c:	8d 51 03             	lea    0x3(%ecx),%edx
  80235f:	83 e2 fc             	and    $0xfffffffc,%edx
  802362:	89 d6                	mov    %edx,%esi
  802364:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  802367:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  80236d:	0f 87 59 01 00 00    	ja     8024cc <malloc+0x185>
	if ((uintptr_t) mptr % PGSIZE){
  802373:	89 c1                	mov    %eax,%ecx
  802375:	a9 ff 0f 00 00       	test   $0xfff,%eax
  80237a:	74 30                	je     8023ac <malloc+0x65>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  80237c:	89 c3                	mov    %eax,%ebx
  80237e:	c1 eb 0c             	shr    $0xc,%ebx
  802381:	8d 54 10 03          	lea    0x3(%eax,%edx,1),%edx
  802385:	c1 ea 0c             	shr    $0xc,%edx
  802388:	39 d3                	cmp    %edx,%ebx
  80238a:	74 68                	je     8023f4 <malloc+0xad>
		free(mptr);	/* drop reference to this page */
  80238c:	83 ec 0c             	sub    $0xc,%esp
  80238f:	50                   	push   %eax
  802390:	e8 06 ff ff ff       	call   80229b <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  802395:	a1 18 50 80 00       	mov    0x805018,%eax
  80239a:	05 00 10 00 00       	add    $0x1000,%eax
  80239f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8023a4:	a3 18 50 80 00       	mov    %eax,0x805018
  8023a9:	83 c4 10             	add    $0x10,%esp
  8023ac:	8b 15 18 50 80 00    	mov    0x805018,%edx
{
  8023b2:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  8023b9:	be 00 00 00 00       	mov    $0x0,%esi
		if (isfree(mptr, n + 4))
  8023be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023c1:	8d 78 04             	lea    0x4(%eax),%edi
  8023c4:	c6 45 e3 01          	movb   $0x1,-0x1d(%ebp)
  8023c8:	e9 8a 00 00 00       	jmp    802457 <malloc+0x110>
		mptr = mbegin;
  8023cd:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  8023d4:	00 00 08 
	n = ROUNDUP(n, 4);
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	83 c0 03             	add    $0x3,%eax
  8023dd:	83 e0 fc             	and    $0xfffffffc,%eax
  8023e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (n >= MAXMALLOC)
  8023e3:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  8023e8:	76 c2                	jbe    8023ac <malloc+0x65>
		return 0;
  8023ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ef:	e9 fd 00 00 00       	jmp    8024f1 <malloc+0x1aa>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  8023f4:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
  8023fa:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
			(*ref)++;
  802400:	83 41 fc 01          	addl   $0x1,-0x4(%ecx)
			mptr += n;
  802404:	89 f2                	mov    %esi,%edx
  802406:	01 c2                	add    %eax,%edx
  802408:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  80240e:	e9 de 00 00 00       	jmp    8024f1 <malloc+0x1aa>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802413:	05 00 10 00 00       	add    $0x1000,%eax
  802418:	39 c8                	cmp    %ecx,%eax
  80241a:	73 66                	jae    802482 <malloc+0x13b>
		if (va >= (uintptr_t) mend
  80241c:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  802421:	77 22                	ja     802445 <malloc+0xfe>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  802423:	89 c3                	mov    %eax,%ebx
  802425:	c1 eb 16             	shr    $0x16,%ebx
  802428:	8b 1c 9d 00 d0 7b ef 	mov    -0x10843000(,%ebx,4),%ebx
  80242f:	f6 c3 01             	test   $0x1,%bl
  802432:	74 df                	je     802413 <malloc+0xcc>
  802434:	89 c3                	mov    %eax,%ebx
  802436:	c1 eb 0c             	shr    $0xc,%ebx
  802439:	8b 1c 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%ebx
  802440:	f6 c3 01             	test   $0x1,%bl
  802443:	74 ce                	je     802413 <malloc+0xcc>
  802445:	81 c2 00 10 00 00    	add    $0x1000,%edx
  80244b:	0f b6 75 e3          	movzbl -0x1d(%ebp),%esi
		if (mptr == mend) {
  80244f:	81 fa 00 00 00 10    	cmp    $0x10000000,%edx
  802455:	74 0a                	je     802461 <malloc+0x11a>
  802457:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  80245a:	89 d0                	mov    %edx,%eax
  80245c:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  80245f:	eb b7                	jmp    802418 <malloc+0xd1>
			mptr = mbegin;
  802461:	ba 00 00 00 08       	mov    $0x8000000,%edx
  802466:	be 01 00 00 00       	mov    $0x1,%esi
			if (++nwrap == 2)
  80246b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80246f:	75 e6                	jne    802457 <malloc+0x110>
  802471:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802478:	00 00 08 
				return 0;	/* out of address space */
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
  802480:	eb 6f                	jmp    8024f1 <malloc+0x1aa>
  802482:	89 f0                	mov    %esi,%eax
  802484:	84 c0                	test   %al,%al
  802486:	74 08                	je     802490 <malloc+0x149>
  802488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80248b:	a3 18 50 80 00       	mov    %eax,0x805018
	for (i = 0; i < n + 4; i += PGSIZE){
  802490:	bb 00 00 00 00       	mov    $0x0,%ebx
  802495:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  802498:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  80249e:	39 f7                	cmp    %esi,%edi
  8024a0:	76 57                	jbe    8024f9 <malloc+0x1b2>
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  8024a2:	83 ec 04             	sub    $0x4,%esp
  8024a5:	68 07 02 00 00       	push   $0x207
  8024aa:	89 d8                	mov    %ebx,%eax
  8024ac:	03 05 18 50 80 00    	add    0x805018,%eax
  8024b2:	50                   	push   %eax
  8024b3:	6a 00                	push   $0x0
  8024b5:	e8 e3 eb ff ff       	call   80109d <sys_page_alloc>
  8024ba:	83 c4 10             	add    $0x10,%esp
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	78 55                	js     802516 <malloc+0x1cf>
	for (i = 0; i < n + 4; i += PGSIZE){
  8024c1:	89 f3                	mov    %esi,%ebx
  8024c3:	eb d0                	jmp    802495 <malloc+0x14e>
			return 0;	/* out of physical memory */
  8024c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ca:	eb 25                	jmp    8024f1 <malloc+0x1aa>
		return 0;
  8024cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d1:	eb 1e                	jmp    8024f1 <malloc+0x1aa>
	ref = (uint32_t*) (mptr + i - 4);
  8024d3:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  8024d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8024db:	c7 84 08 fc 0f 00 00 	movl   $0x2,0xffc(%eax,%ecx,1)
  8024e2:	02 00 00 00 
	mptr += n;
  8024e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024e9:	01 c2                	add    %eax,%edx
  8024eb:	89 15 18 50 80 00    	mov    %edx,0x805018
}
  8024f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024f4:	5b                   	pop    %ebx
  8024f5:	5e                   	pop    %esi
  8024f6:	5f                   	pop    %edi
  8024f7:	5d                   	pop    %ebp
  8024f8:	c3                   	ret    
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  8024f9:	83 ec 04             	sub    $0x4,%esp
  8024fc:	6a 07                	push   $0x7
  8024fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802501:	03 05 18 50 80 00    	add    0x805018,%eax
  802507:	50                   	push   %eax
  802508:	6a 00                	push   $0x0
  80250a:	e8 8e eb ff ff       	call   80109d <sys_page_alloc>
  80250f:	83 c4 10             	add    $0x10,%esp
  802512:	85 c0                	test   %eax,%eax
  802514:	79 bd                	jns    8024d3 <malloc+0x18c>
			for (; i >= 0; i -= PGSIZE)
  802516:	85 db                	test   %ebx,%ebx
  802518:	78 ab                	js     8024c5 <malloc+0x17e>
				sys_page_unmap(0, mptr + i);
  80251a:	83 ec 08             	sub    $0x8,%esp
  80251d:	89 d8                	mov    %ebx,%eax
  80251f:	03 05 18 50 80 00    	add    0x805018,%eax
  802525:	50                   	push   %eax
  802526:	6a 00                	push   $0x0
  802528:	e8 f5 eb ff ff       	call   801122 <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  80252d:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  802533:	83 c4 10             	add    $0x10,%esp
  802536:	eb de                	jmp    802516 <malloc+0x1cf>

00802538 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802538:	b8 00 00 00 00       	mov    $0x0,%eax
  80253d:	c3                   	ret    

0080253e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
  802541:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802544:	68 e7 30 80 00       	push   $0x8030e7
  802549:	ff 75 0c             	pushl  0xc(%ebp)
  80254c:	e8 5a e7 ff ff       	call   800cab <strcpy>
	return 0;
}
  802551:	b8 00 00 00 00       	mov    $0x0,%eax
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <devcons_write>:
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	57                   	push   %edi
  80255c:	56                   	push   %esi
  80255d:	53                   	push   %ebx
  80255e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802564:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802569:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80256f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802572:	73 31                	jae    8025a5 <devcons_write+0x4d>
		m = n - tot;
  802574:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802577:	29 f3                	sub    %esi,%ebx
  802579:	83 fb 7f             	cmp    $0x7f,%ebx
  80257c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802581:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802584:	83 ec 04             	sub    $0x4,%esp
  802587:	53                   	push   %ebx
  802588:	89 f0                	mov    %esi,%eax
  80258a:	03 45 0c             	add    0xc(%ebp),%eax
  80258d:	50                   	push   %eax
  80258e:	57                   	push   %edi
  80258f:	e8 a5 e8 ff ff       	call   800e39 <memmove>
		sys_cputs(buf, m);
  802594:	83 c4 08             	add    $0x8,%esp
  802597:	53                   	push   %ebx
  802598:	57                   	push   %edi
  802599:	e8 43 ea ff ff       	call   800fe1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80259e:	01 de                	add    %ebx,%esi
  8025a0:	83 c4 10             	add    $0x10,%esp
  8025a3:	eb ca                	jmp    80256f <devcons_write+0x17>
}
  8025a5:	89 f0                	mov    %esi,%eax
  8025a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025aa:	5b                   	pop    %ebx
  8025ab:	5e                   	pop    %esi
  8025ac:	5f                   	pop    %edi
  8025ad:	5d                   	pop    %ebp
  8025ae:	c3                   	ret    

008025af <devcons_read>:
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	83 ec 08             	sub    $0x8,%esp
  8025b5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025be:	74 21                	je     8025e1 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8025c0:	e8 3a ea ff ff       	call   800fff <sys_cgetc>
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	75 07                	jne    8025d0 <devcons_read+0x21>
		sys_yield();
  8025c9:	e8 b0 ea ff ff       	call   80107e <sys_yield>
  8025ce:	eb f0                	jmp    8025c0 <devcons_read+0x11>
	if (c < 0)
  8025d0:	78 0f                	js     8025e1 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8025d2:	83 f8 04             	cmp    $0x4,%eax
  8025d5:	74 0c                	je     8025e3 <devcons_read+0x34>
	*(char*)vbuf = c;
  8025d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025da:	88 02                	mov    %al,(%edx)
	return 1;
  8025dc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025e1:	c9                   	leave  
  8025e2:	c3                   	ret    
		return 0;
  8025e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e8:	eb f7                	jmp    8025e1 <devcons_read+0x32>

008025ea <cputchar>:
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8025f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8025f6:	6a 01                	push   $0x1
  8025f8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025fb:	50                   	push   %eax
  8025fc:	e8 e0 e9 ff ff       	call   800fe1 <sys_cputs>
}
  802601:	83 c4 10             	add    $0x10,%esp
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <getchar>:
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
  802609:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80260c:	6a 01                	push   $0x1
  80260e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802611:	50                   	push   %eax
  802612:	6a 00                	push   $0x0
  802614:	e8 7d ef ff ff       	call   801596 <read>
	if (r < 0)
  802619:	83 c4 10             	add    $0x10,%esp
  80261c:	85 c0                	test   %eax,%eax
  80261e:	78 06                	js     802626 <getchar+0x20>
	if (r < 1)
  802620:	74 06                	je     802628 <getchar+0x22>
	return c;
  802622:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802626:	c9                   	leave  
  802627:	c3                   	ret    
		return -E_EOF;
  802628:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80262d:	eb f7                	jmp    802626 <getchar+0x20>

0080262f <iscons>:
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
  802632:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802635:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802638:	50                   	push   %eax
  802639:	ff 75 08             	pushl  0x8(%ebp)
  80263c:	e8 e5 ec ff ff       	call   801326 <fd_lookup>
  802641:	83 c4 10             	add    $0x10,%esp
  802644:	85 c0                	test   %eax,%eax
  802646:	78 11                	js     802659 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802651:	39 10                	cmp    %edx,(%eax)
  802653:	0f 94 c0             	sete   %al
  802656:	0f b6 c0             	movzbl %al,%eax
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <opencons>:
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802661:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802664:	50                   	push   %eax
  802665:	e8 6a ec ff ff       	call   8012d4 <fd_alloc>
  80266a:	83 c4 10             	add    $0x10,%esp
  80266d:	85 c0                	test   %eax,%eax
  80266f:	78 3a                	js     8026ab <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802671:	83 ec 04             	sub    $0x4,%esp
  802674:	68 07 04 00 00       	push   $0x407
  802679:	ff 75 f4             	pushl  -0xc(%ebp)
  80267c:	6a 00                	push   $0x0
  80267e:	e8 1a ea ff ff       	call   80109d <sys_page_alloc>
  802683:	83 c4 10             	add    $0x10,%esp
  802686:	85 c0                	test   %eax,%eax
  802688:	78 21                	js     8026ab <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802693:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80269f:	83 ec 0c             	sub    $0xc,%esp
  8026a2:	50                   	push   %eax
  8026a3:	e8 05 ec ff ff       	call   8012ad <fd2num>
  8026a8:	83 c4 10             	add    $0x10,%esp
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	56                   	push   %esi
  8026b1:	53                   	push   %ebx
  8026b2:	8b 75 08             	mov    0x8(%ebp),%esi
  8026b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	74 4f                	je     80270e <ipc_recv+0x61>
  8026bf:	83 ec 0c             	sub    $0xc,%esp
  8026c2:	50                   	push   %eax
  8026c3:	e8 85 eb ff ff       	call   80124d <sys_ipc_recv>
  8026c8:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  8026cb:	85 f6                	test   %esi,%esi
  8026cd:	74 14                	je     8026e3 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  8026cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	75 09                	jne    8026e1 <ipc_recv+0x34>
  8026d8:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  8026de:	8b 52 74             	mov    0x74(%edx),%edx
  8026e1:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  8026e3:	85 db                	test   %ebx,%ebx
  8026e5:	74 14                	je     8026fb <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  8026e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	75 09                	jne    8026f9 <ipc_recv+0x4c>
  8026f0:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  8026f6:	8b 52 78             	mov    0x78(%edx),%edx
  8026f9:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	75 08                	jne    802707 <ipc_recv+0x5a>
  8026ff:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802704:	8b 40 70             	mov    0x70(%eax),%eax
}
  802707:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80270a:	5b                   	pop    %ebx
  80270b:	5e                   	pop    %esi
  80270c:	5d                   	pop    %ebp
  80270d:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  80270e:	83 ec 0c             	sub    $0xc,%esp
  802711:	68 00 00 c0 ee       	push   $0xeec00000
  802716:	e8 32 eb ff ff       	call   80124d <sys_ipc_recv>
  80271b:	83 c4 10             	add    $0x10,%esp
  80271e:	eb ab                	jmp    8026cb <ipc_recv+0x1e>

00802720 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
  802723:	57                   	push   %edi
  802724:	56                   	push   %esi
  802725:	53                   	push   %ebx
  802726:	83 ec 0c             	sub    $0xc,%esp
  802729:	8b 7d 08             	mov    0x8(%ebp),%edi
  80272c:	8b 75 10             	mov    0x10(%ebp),%esi
  80272f:	eb 20                	jmp    802751 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802731:	6a 00                	push   $0x0
  802733:	68 00 00 c0 ee       	push   $0xeec00000
  802738:	ff 75 0c             	pushl  0xc(%ebp)
  80273b:	57                   	push   %edi
  80273c:	e8 e9 ea ff ff       	call   80122a <sys_ipc_try_send>
  802741:	89 c3                	mov    %eax,%ebx
  802743:	83 c4 10             	add    $0x10,%esp
  802746:	eb 1f                	jmp    802767 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802748:	e8 31 e9 ff ff       	call   80107e <sys_yield>
	while(retval != 0) {
  80274d:	85 db                	test   %ebx,%ebx
  80274f:	74 33                	je     802784 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802751:	85 f6                	test   %esi,%esi
  802753:	74 dc                	je     802731 <ipc_send+0x11>
  802755:	ff 75 14             	pushl  0x14(%ebp)
  802758:	56                   	push   %esi
  802759:	ff 75 0c             	pushl  0xc(%ebp)
  80275c:	57                   	push   %edi
  80275d:	e8 c8 ea ff ff       	call   80122a <sys_ipc_try_send>
  802762:	89 c3                	mov    %eax,%ebx
  802764:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802767:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80276a:	74 dc                	je     802748 <ipc_send+0x28>
  80276c:	85 db                	test   %ebx,%ebx
  80276e:	74 d8                	je     802748 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802770:	83 ec 04             	sub    $0x4,%esp
  802773:	68 f4 30 80 00       	push   $0x8030f4
  802778:	6a 35                	push   $0x35
  80277a:	68 24 31 80 00       	push   $0x803124
  80277f:	e8 70 de ff ff       	call   8005f4 <_panic>
	}
}
  802784:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802787:	5b                   	pop    %ebx
  802788:	5e                   	pop    %esi
  802789:	5f                   	pop    %edi
  80278a:	5d                   	pop    %ebp
  80278b:	c3                   	ret    

0080278c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80278c:	55                   	push   %ebp
  80278d:	89 e5                	mov    %esp,%ebp
  80278f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802792:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802797:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80279a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8027a0:	8b 52 50             	mov    0x50(%edx),%edx
  8027a3:	39 ca                	cmp    %ecx,%edx
  8027a5:	74 11                	je     8027b8 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8027a7:	83 c0 01             	add    $0x1,%eax
  8027aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027af:	75 e6                	jne    802797 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8027b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b6:	eb 0b                	jmp    8027c3 <ipc_find_env+0x37>
			return envs[i].env_id;
  8027b8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8027bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8027c0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8027c3:	5d                   	pop    %ebp
  8027c4:	c3                   	ret    

008027c5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027cb:	89 d0                	mov    %edx,%eax
  8027cd:	c1 e8 16             	shr    $0x16,%eax
  8027d0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8027d7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8027dc:	f6 c1 01             	test   $0x1,%cl
  8027df:	74 1d                	je     8027fe <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8027e1:	c1 ea 0c             	shr    $0xc,%edx
  8027e4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8027eb:	f6 c2 01             	test   $0x1,%dl
  8027ee:	74 0e                	je     8027fe <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027f0:	c1 ea 0c             	shr    $0xc,%edx
  8027f3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8027fa:	ef 
  8027fb:	0f b7 c0             	movzwl %ax,%eax
}
  8027fe:	5d                   	pop    %ebp
  8027ff:	c3                   	ret    

00802800 <__udivdi3>:
  802800:	f3 0f 1e fb          	endbr32 
  802804:	55                   	push   %ebp
  802805:	57                   	push   %edi
  802806:	56                   	push   %esi
  802807:	53                   	push   %ebx
  802808:	83 ec 1c             	sub    $0x1c,%esp
  80280b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80280f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802813:	8b 74 24 34          	mov    0x34(%esp),%esi
  802817:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80281b:	85 d2                	test   %edx,%edx
  80281d:	75 49                	jne    802868 <__udivdi3+0x68>
  80281f:	39 f3                	cmp    %esi,%ebx
  802821:	76 15                	jbe    802838 <__udivdi3+0x38>
  802823:	31 ff                	xor    %edi,%edi
  802825:	89 e8                	mov    %ebp,%eax
  802827:	89 f2                	mov    %esi,%edx
  802829:	f7 f3                	div    %ebx
  80282b:	89 fa                	mov    %edi,%edx
  80282d:	83 c4 1c             	add    $0x1c,%esp
  802830:	5b                   	pop    %ebx
  802831:	5e                   	pop    %esi
  802832:	5f                   	pop    %edi
  802833:	5d                   	pop    %ebp
  802834:	c3                   	ret    
  802835:	8d 76 00             	lea    0x0(%esi),%esi
  802838:	89 d9                	mov    %ebx,%ecx
  80283a:	85 db                	test   %ebx,%ebx
  80283c:	75 0b                	jne    802849 <__udivdi3+0x49>
  80283e:	b8 01 00 00 00       	mov    $0x1,%eax
  802843:	31 d2                	xor    %edx,%edx
  802845:	f7 f3                	div    %ebx
  802847:	89 c1                	mov    %eax,%ecx
  802849:	31 d2                	xor    %edx,%edx
  80284b:	89 f0                	mov    %esi,%eax
  80284d:	f7 f1                	div    %ecx
  80284f:	89 c6                	mov    %eax,%esi
  802851:	89 e8                	mov    %ebp,%eax
  802853:	89 f7                	mov    %esi,%edi
  802855:	f7 f1                	div    %ecx
  802857:	89 fa                	mov    %edi,%edx
  802859:	83 c4 1c             	add    $0x1c,%esp
  80285c:	5b                   	pop    %ebx
  80285d:	5e                   	pop    %esi
  80285e:	5f                   	pop    %edi
  80285f:	5d                   	pop    %ebp
  802860:	c3                   	ret    
  802861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802868:	39 f2                	cmp    %esi,%edx
  80286a:	77 1c                	ja     802888 <__udivdi3+0x88>
  80286c:	0f bd fa             	bsr    %edx,%edi
  80286f:	83 f7 1f             	xor    $0x1f,%edi
  802872:	75 2c                	jne    8028a0 <__udivdi3+0xa0>
  802874:	39 f2                	cmp    %esi,%edx
  802876:	72 06                	jb     80287e <__udivdi3+0x7e>
  802878:	31 c0                	xor    %eax,%eax
  80287a:	39 eb                	cmp    %ebp,%ebx
  80287c:	77 ad                	ja     80282b <__udivdi3+0x2b>
  80287e:	b8 01 00 00 00       	mov    $0x1,%eax
  802883:	eb a6                	jmp    80282b <__udivdi3+0x2b>
  802885:	8d 76 00             	lea    0x0(%esi),%esi
  802888:	31 ff                	xor    %edi,%edi
  80288a:	31 c0                	xor    %eax,%eax
  80288c:	89 fa                	mov    %edi,%edx
  80288e:	83 c4 1c             	add    $0x1c,%esp
  802891:	5b                   	pop    %ebx
  802892:	5e                   	pop    %esi
  802893:	5f                   	pop    %edi
  802894:	5d                   	pop    %ebp
  802895:	c3                   	ret    
  802896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80289d:	8d 76 00             	lea    0x0(%esi),%esi
  8028a0:	89 f9                	mov    %edi,%ecx
  8028a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8028a7:	29 f8                	sub    %edi,%eax
  8028a9:	d3 e2                	shl    %cl,%edx
  8028ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028af:	89 c1                	mov    %eax,%ecx
  8028b1:	89 da                	mov    %ebx,%edx
  8028b3:	d3 ea                	shr    %cl,%edx
  8028b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028b9:	09 d1                	or     %edx,%ecx
  8028bb:	89 f2                	mov    %esi,%edx
  8028bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028c1:	89 f9                	mov    %edi,%ecx
  8028c3:	d3 e3                	shl    %cl,%ebx
  8028c5:	89 c1                	mov    %eax,%ecx
  8028c7:	d3 ea                	shr    %cl,%edx
  8028c9:	89 f9                	mov    %edi,%ecx
  8028cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8028cf:	89 eb                	mov    %ebp,%ebx
  8028d1:	d3 e6                	shl    %cl,%esi
  8028d3:	89 c1                	mov    %eax,%ecx
  8028d5:	d3 eb                	shr    %cl,%ebx
  8028d7:	09 de                	or     %ebx,%esi
  8028d9:	89 f0                	mov    %esi,%eax
  8028db:	f7 74 24 08          	divl   0x8(%esp)
  8028df:	89 d6                	mov    %edx,%esi
  8028e1:	89 c3                	mov    %eax,%ebx
  8028e3:	f7 64 24 0c          	mull   0xc(%esp)
  8028e7:	39 d6                	cmp    %edx,%esi
  8028e9:	72 15                	jb     802900 <__udivdi3+0x100>
  8028eb:	89 f9                	mov    %edi,%ecx
  8028ed:	d3 e5                	shl    %cl,%ebp
  8028ef:	39 c5                	cmp    %eax,%ebp
  8028f1:	73 04                	jae    8028f7 <__udivdi3+0xf7>
  8028f3:	39 d6                	cmp    %edx,%esi
  8028f5:	74 09                	je     802900 <__udivdi3+0x100>
  8028f7:	89 d8                	mov    %ebx,%eax
  8028f9:	31 ff                	xor    %edi,%edi
  8028fb:	e9 2b ff ff ff       	jmp    80282b <__udivdi3+0x2b>
  802900:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802903:	31 ff                	xor    %edi,%edi
  802905:	e9 21 ff ff ff       	jmp    80282b <__udivdi3+0x2b>
  80290a:	66 90                	xchg   %ax,%ax
  80290c:	66 90                	xchg   %ax,%ax
  80290e:	66 90                	xchg   %ax,%ax

00802910 <__umoddi3>:
  802910:	f3 0f 1e fb          	endbr32 
  802914:	55                   	push   %ebp
  802915:	57                   	push   %edi
  802916:	56                   	push   %esi
  802917:	53                   	push   %ebx
  802918:	83 ec 1c             	sub    $0x1c,%esp
  80291b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80291f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802923:	8b 74 24 30          	mov    0x30(%esp),%esi
  802927:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80292b:	89 da                	mov    %ebx,%edx
  80292d:	85 c0                	test   %eax,%eax
  80292f:	75 3f                	jne    802970 <__umoddi3+0x60>
  802931:	39 df                	cmp    %ebx,%edi
  802933:	76 13                	jbe    802948 <__umoddi3+0x38>
  802935:	89 f0                	mov    %esi,%eax
  802937:	f7 f7                	div    %edi
  802939:	89 d0                	mov    %edx,%eax
  80293b:	31 d2                	xor    %edx,%edx
  80293d:	83 c4 1c             	add    $0x1c,%esp
  802940:	5b                   	pop    %ebx
  802941:	5e                   	pop    %esi
  802942:	5f                   	pop    %edi
  802943:	5d                   	pop    %ebp
  802944:	c3                   	ret    
  802945:	8d 76 00             	lea    0x0(%esi),%esi
  802948:	89 fd                	mov    %edi,%ebp
  80294a:	85 ff                	test   %edi,%edi
  80294c:	75 0b                	jne    802959 <__umoddi3+0x49>
  80294e:	b8 01 00 00 00       	mov    $0x1,%eax
  802953:	31 d2                	xor    %edx,%edx
  802955:	f7 f7                	div    %edi
  802957:	89 c5                	mov    %eax,%ebp
  802959:	89 d8                	mov    %ebx,%eax
  80295b:	31 d2                	xor    %edx,%edx
  80295d:	f7 f5                	div    %ebp
  80295f:	89 f0                	mov    %esi,%eax
  802961:	f7 f5                	div    %ebp
  802963:	89 d0                	mov    %edx,%eax
  802965:	eb d4                	jmp    80293b <__umoddi3+0x2b>
  802967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80296e:	66 90                	xchg   %ax,%ax
  802970:	89 f1                	mov    %esi,%ecx
  802972:	39 d8                	cmp    %ebx,%eax
  802974:	76 0a                	jbe    802980 <__umoddi3+0x70>
  802976:	89 f0                	mov    %esi,%eax
  802978:	83 c4 1c             	add    $0x1c,%esp
  80297b:	5b                   	pop    %ebx
  80297c:	5e                   	pop    %esi
  80297d:	5f                   	pop    %edi
  80297e:	5d                   	pop    %ebp
  80297f:	c3                   	ret    
  802980:	0f bd e8             	bsr    %eax,%ebp
  802983:	83 f5 1f             	xor    $0x1f,%ebp
  802986:	75 20                	jne    8029a8 <__umoddi3+0x98>
  802988:	39 d8                	cmp    %ebx,%eax
  80298a:	0f 82 b0 00 00 00    	jb     802a40 <__umoddi3+0x130>
  802990:	39 f7                	cmp    %esi,%edi
  802992:	0f 86 a8 00 00 00    	jbe    802a40 <__umoddi3+0x130>
  802998:	89 c8                	mov    %ecx,%eax
  80299a:	83 c4 1c             	add    $0x1c,%esp
  80299d:	5b                   	pop    %ebx
  80299e:	5e                   	pop    %esi
  80299f:	5f                   	pop    %edi
  8029a0:	5d                   	pop    %ebp
  8029a1:	c3                   	ret    
  8029a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029a8:	89 e9                	mov    %ebp,%ecx
  8029aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8029af:	29 ea                	sub    %ebp,%edx
  8029b1:	d3 e0                	shl    %cl,%eax
  8029b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029b7:	89 d1                	mov    %edx,%ecx
  8029b9:	89 f8                	mov    %edi,%eax
  8029bb:	d3 e8                	shr    %cl,%eax
  8029bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029c9:	09 c1                	or     %eax,%ecx
  8029cb:	89 d8                	mov    %ebx,%eax
  8029cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029d1:	89 e9                	mov    %ebp,%ecx
  8029d3:	d3 e7                	shl    %cl,%edi
  8029d5:	89 d1                	mov    %edx,%ecx
  8029d7:	d3 e8                	shr    %cl,%eax
  8029d9:	89 e9                	mov    %ebp,%ecx
  8029db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029df:	d3 e3                	shl    %cl,%ebx
  8029e1:	89 c7                	mov    %eax,%edi
  8029e3:	89 d1                	mov    %edx,%ecx
  8029e5:	89 f0                	mov    %esi,%eax
  8029e7:	d3 e8                	shr    %cl,%eax
  8029e9:	89 e9                	mov    %ebp,%ecx
  8029eb:	89 fa                	mov    %edi,%edx
  8029ed:	d3 e6                	shl    %cl,%esi
  8029ef:	09 d8                	or     %ebx,%eax
  8029f1:	f7 74 24 08          	divl   0x8(%esp)
  8029f5:	89 d1                	mov    %edx,%ecx
  8029f7:	89 f3                	mov    %esi,%ebx
  8029f9:	f7 64 24 0c          	mull   0xc(%esp)
  8029fd:	89 c6                	mov    %eax,%esi
  8029ff:	89 d7                	mov    %edx,%edi
  802a01:	39 d1                	cmp    %edx,%ecx
  802a03:	72 06                	jb     802a0b <__umoddi3+0xfb>
  802a05:	75 10                	jne    802a17 <__umoddi3+0x107>
  802a07:	39 c3                	cmp    %eax,%ebx
  802a09:	73 0c                	jae    802a17 <__umoddi3+0x107>
  802a0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a13:	89 d7                	mov    %edx,%edi
  802a15:	89 c6                	mov    %eax,%esi
  802a17:	89 ca                	mov    %ecx,%edx
  802a19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a1e:	29 f3                	sub    %esi,%ebx
  802a20:	19 fa                	sbb    %edi,%edx
  802a22:	89 d0                	mov    %edx,%eax
  802a24:	d3 e0                	shl    %cl,%eax
  802a26:	89 e9                	mov    %ebp,%ecx
  802a28:	d3 eb                	shr    %cl,%ebx
  802a2a:	d3 ea                	shr    %cl,%edx
  802a2c:	09 d8                	or     %ebx,%eax
  802a2e:	83 c4 1c             	add    $0x1c,%esp
  802a31:	5b                   	pop    %ebx
  802a32:	5e                   	pop    %esi
  802a33:	5f                   	pop    %edi
  802a34:	5d                   	pop    %ebp
  802a35:	c3                   	ret    
  802a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a3d:	8d 76 00             	lea    0x0(%esi),%esi
  802a40:	89 da                	mov    %ebx,%edx
  802a42:	29 fe                	sub    %edi,%esi
  802a44:	19 c2                	sbb    %eax,%edx
  802a46:	89 f1                	mov    %esi,%ecx
  802a48:	89 c8                	mov    %ecx,%eax
  802a4a:	e9 4b ff ff ff       	jmp    80299a <__umoddi3+0x8a>
