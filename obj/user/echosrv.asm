
obj/user/echosrv.debug：     文件格式 elf32-i386


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
  80002c:	e8 a2 04 00 00       	call   8004d3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 50 27 80 00       	push   $0x802750
  80003f:	e8 84 05 00 00       	call   8005c8 <cprintf>
	exit();
  800044:	e8 d0 04 00 00       	call   800519 <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <handle_client>:

void
handle_client(int sock)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 30             	sub    $0x30,%esp
  800057:	8b 75 08             	mov    0x8(%ebp),%esi
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005a:	6a 20                	push   $0x20
  80005c:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	56                   	push   %esi
  800061:	e8 29 14 00 00       	call   80148f <read>
  800066:	89 c3                	mov    %eax,%ebx
  800068:	83 c4 10             	add    $0x10,%esp
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  80006b:	8d 7d c8             	lea    -0x38(%ebp),%edi
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 3d                	jns    8000af <handle_client+0x61>
		die("Failed to receive initial bytes from client");
  800072:	b8 54 27 80 00       	mov    $0x802754,%eax
  800077:	e8 b7 ff ff ff       	call   800033 <die>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	56                   	push   %esi
  800080:	e8 cc 12 00 00       	call   801351 <close>
}
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	5f                   	pop    %edi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    
			die("Failed to send bytes to client");
  800090:	b8 80 27 80 00       	mov    $0x802780,%eax
  800095:	e8 99 ff ff ff       	call   800033 <die>
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	6a 20                	push   $0x20
  80009f:	57                   	push   %edi
  8000a0:	56                   	push   %esi
  8000a1:	e8 e9 13 00 00       	call   80148f <read>
  8000a6:	89 c3                	mov    %eax,%ebx
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	85 c0                	test   %eax,%eax
  8000ad:	78 18                	js     8000c7 <handle_client+0x79>
	while (received > 0) {
  8000af:	85 db                	test   %ebx,%ebx
  8000b1:	7e c9                	jle    80007c <handle_client+0x2e>
		if (write(sock, buffer, received) != received)
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	53                   	push   %ebx
  8000b7:	57                   	push   %edi
  8000b8:	56                   	push   %esi
  8000b9:	e8 9d 14 00 00       	call   80155b <write>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	39 d8                	cmp    %ebx,%eax
  8000c3:	74 d5                	je     80009a <handle_client+0x4c>
  8000c5:	eb c9                	jmp    800090 <handle_client+0x42>
			die("Failed to receive additional bytes from client");
  8000c7:	b8 a0 27 80 00       	mov    $0x8027a0,%eax
  8000cc:	e8 62 ff ff ff       	call   800033 <die>
  8000d1:	eb dc                	jmp    8000af <handle_client+0x61>

008000d3 <umain>:

void
umain(int argc, char **argv)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 40             	sub    $0x40,%esp
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000dc:	6a 06                	push   $0x6
  8000de:	6a 01                	push   $0x1
  8000e0:	6a 02                	push   $0x2
  8000e2:	e8 31 1e 00 00       	call   801f18 <socket>
  8000e7:	89 c6                	mov    %eax,%esi
  8000e9:	83 c4 10             	add    $0x10,%esp
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	0f 88 86 00 00 00    	js     80017a <umain+0xa7>
		die("Failed to create socket");

	cprintf("opened socket\n");
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 18 27 80 00       	push   $0x802718
  8000fc:	e8 c7 04 00 00       	call   8005c8 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800101:	83 c4 0c             	add    $0xc,%esp
  800104:	6a 10                	push   $0x10
  800106:	6a 00                	push   $0x0
  800108:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  80010b:	53                   	push   %ebx
  80010c:	e8 d9 0b 00 00       	call   800cea <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  800111:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  800115:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80011c:	e8 88 01 00 00       	call   8002a9 <htonl>
  800121:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  800124:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80012b:	e8 5f 01 00 00       	call   80028f <htons>
  800130:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to bind\n");
  800134:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  80013b:	e8 88 04 00 00       	call   8005c8 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	6a 10                	push   $0x10
  800145:	53                   	push   %ebx
  800146:	56                   	push   %esi
  800147:	e8 3a 1d 00 00       	call   801e86 <bind>
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	85 c0                	test   %eax,%eax
  800151:	78 36                	js     800189 <umain+0xb6>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	6a 05                	push   $0x5
  800158:	56                   	push   %esi
  800159:	e8 97 1d 00 00       	call   801ef5 <listen>
  80015e:	83 c4 10             	add    $0x10,%esp
  800161:	85 c0                	test   %eax,%eax
  800163:	78 30                	js     800195 <umain+0xc2>
		die("Failed to listen on server socket");

	cprintf("bound\n");
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 37 27 80 00       	push   $0x802737
  80016d:	e8 56 04 00 00       	call   8005c8 <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp
	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
		     accept(serversock, (struct sockaddr *) &echoclient,
  800175:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  800178:	eb 55                	jmp    8001cf <umain+0xfc>
		die("Failed to create socket");
  80017a:	b8 00 27 80 00       	mov    $0x802700,%eax
  80017f:	e8 af fe ff ff       	call   800033 <die>
  800184:	e9 6b ff ff ff       	jmp    8000f4 <umain+0x21>
		die("Failed to bind the server socket");
  800189:	b8 d0 27 80 00       	mov    $0x8027d0,%eax
  80018e:	e8 a0 fe ff ff       	call   800033 <die>
  800193:	eb be                	jmp    800153 <umain+0x80>
		die("Failed to listen on server socket");
  800195:	b8 f4 27 80 00       	mov    $0x8027f4,%eax
  80019a:	e8 94 fe ff ff       	call   800033 <die>
  80019f:	eb c4                	jmp    800165 <umain+0x92>
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8001a1:	b8 18 28 80 00       	mov    $0x802818,%eax
  8001a6:	e8 88 fe ff ff       	call   800033 <die>
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 cc             	pushl  -0x34(%ebp)
  8001b1:	e8 39 00 00 00       	call   8001ef <inet_ntoa>
  8001b6:	83 c4 08             	add    $0x8,%esp
  8001b9:	50                   	push   %eax
  8001ba:	68 3e 27 80 00       	push   $0x80273e
  8001bf:	e8 04 04 00 00       	call   8005c8 <cprintf>
		handle_client(clientsock);
  8001c4:	89 1c 24             	mov    %ebx,(%esp)
  8001c7:	e8 82 fe ff ff       	call   80004e <handle_client>
	while (1) {
  8001cc:	83 c4 10             	add    $0x10,%esp
		unsigned int clientlen = sizeof(echoclient);
  8001cf:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		     accept(serversock, (struct sockaddr *) &echoclient,
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	57                   	push   %edi
  8001da:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8001dd:	50                   	push   %eax
  8001de:	56                   	push   %esi
  8001df:	e8 73 1c 00 00       	call   801e57 <accept>
  8001e4:	89 c3                	mov    %eax,%ebx
		if ((clientsock =
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	85 c0                	test   %eax,%eax
  8001eb:	78 b4                	js     8001a1 <umain+0xce>
  8001ed:	eb bc                	jmp    8001ab <umain+0xd8>

008001ef <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	57                   	push   %edi
  8001f3:	56                   	push   %esi
  8001f4:	53                   	push   %ebx
  8001f5:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8001fe:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  800202:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  800205:	bf 00 40 80 00       	mov    $0x804000,%edi
  80020a:	eb 1a                	jmp    800226 <inet_ntoa+0x37>
  80020c:	0f b6 db             	movzbl %bl,%ebx
  80020f:	01 fb                	add    %edi,%ebx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800211:	8d 7b 01             	lea    0x1(%ebx),%edi
  800214:	c6 03 2e             	movb   $0x2e,(%ebx)
  800217:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  80021a:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  80021e:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  800222:	3c 04                	cmp    $0x4,%al
  800224:	74 59                	je     80027f <inet_ntoa+0x90>
  rp = str;
  800226:	ba 00 00 00 00       	mov    $0x0,%edx
      rem = *ap % (u8_t)10;
  80022b:	0f b6 0e             	movzbl (%esi),%ecx
      *ap /= (u8_t)10;
  80022e:	0f b6 d9             	movzbl %cl,%ebx
  800231:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  800234:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  800237:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80023a:	66 c1 e8 0b          	shr    $0xb,%ax
  80023e:	88 06                	mov    %al,(%esi)
      inv[i++] = '0' + rem;
  800240:	8d 5a 01             	lea    0x1(%edx),%ebx
  800243:	0f b6 d2             	movzbl %dl,%edx
  800246:	89 55 e0             	mov    %edx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  800249:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80024c:	01 c0                	add    %eax,%eax
  80024e:	89 ca                	mov    %ecx,%edx
  800250:	29 c2                	sub    %eax,%edx
  800252:	89 d0                	mov    %edx,%eax
      inv[i++] = '0' + rem;
  800254:	83 c0 30             	add    $0x30,%eax
  800257:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80025a:	88 44 15 ed          	mov    %al,-0x13(%ebp,%edx,1)
  80025e:	89 da                	mov    %ebx,%edx
    } while(*ap);
  800260:	80 f9 09             	cmp    $0x9,%cl
  800263:	77 c6                	ja     80022b <inet_ntoa+0x3c>
  800265:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  800267:	89 d8                	mov    %ebx,%eax
    while(i--)
  800269:	83 e8 01             	sub    $0x1,%eax
  80026c:	3c ff                	cmp    $0xff,%al
  80026e:	74 9c                	je     80020c <inet_ntoa+0x1d>
      *rp++ = inv[i];
  800270:	0f b6 c8             	movzbl %al,%ecx
  800273:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800278:	88 0a                	mov    %cl,(%edx)
  80027a:	83 c2 01             	add    $0x1,%edx
  80027d:	eb ea                	jmp    800269 <inet_ntoa+0x7a>
    ap++;
  }
  *--rp = 0;
  80027f:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  800282:	b8 00 40 80 00       	mov    $0x804000,%eax
  800287:	83 c4 18             	add    $0x18,%esp
  80028a:	5b                   	pop    %ebx
  80028b:	5e                   	pop    %esi
  80028c:	5f                   	pop    %edi
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    

0080028f <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800292:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800296:	66 c1 c0 08          	rol    $0x8,%ax
}
  80029a:	5d                   	pop    %ebp
  80029b:	c3                   	ret    

0080029c <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80029f:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002a3:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    

008002a9 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002b4:	89 d1                	mov    %edx,%ecx
  8002b6:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002b9:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002bb:	89 d1                	mov    %edx,%ecx
  8002bd:	c1 e1 08             	shl    $0x8,%ecx
  8002c0:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002c6:	09 c8                	or     %ecx,%eax
  8002c8:	c1 ea 08             	shr    $0x8,%edx
  8002cb:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8002d1:	09 d0                	or     %edx,%eax
}
  8002d3:	5d                   	pop    %ebp
  8002d4:	c3                   	ret    

008002d5 <inet_aton>:
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	57                   	push   %edi
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	83 ec 2c             	sub    $0x2c,%esp
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  8002e1:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  8002e4:	8d 75 d8             	lea    -0x28(%ebp),%esi
  8002e7:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8002ea:	e9 a7 00 00 00       	jmp    800396 <inet_aton+0xc1>
      c = *++cp;
  8002ef:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8002f3:	89 d1                	mov    %edx,%ecx
  8002f5:	83 e1 df             	and    $0xffffffdf,%ecx
  8002f8:	80 f9 58             	cmp    $0x58,%cl
  8002fb:	74 10                	je     80030d <inet_aton+0x38>
      c = *++cp;
  8002fd:	83 c0 01             	add    $0x1,%eax
  800300:	0f be d2             	movsbl %dl,%edx
        base = 8;
  800303:	be 08 00 00 00       	mov    $0x8,%esi
  800308:	e9 a3 00 00 00       	jmp    8003b0 <inet_aton+0xdb>
        c = *++cp;
  80030d:	0f be 50 02          	movsbl 0x2(%eax),%edx
  800311:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  800314:	be 10 00 00 00       	mov    $0x10,%esi
  800319:	e9 92 00 00 00       	jmp    8003b0 <inet_aton+0xdb>
      } else if (base == 16 && isxdigit(c)) {
  80031e:	83 fe 10             	cmp    $0x10,%esi
  800321:	75 4d                	jne    800370 <inet_aton+0x9b>
  800323:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  800326:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  800329:	89 d1                	mov    %edx,%ecx
  80032b:	83 e1 df             	and    $0xffffffdf,%ecx
  80032e:	83 e9 41             	sub    $0x41,%ecx
  800331:	80 f9 05             	cmp    $0x5,%cl
  800334:	77 3a                	ja     800370 <inet_aton+0x9b>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800336:	c1 e3 04             	shl    $0x4,%ebx
  800339:	83 c2 0a             	add    $0xa,%edx
  80033c:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  800340:	19 c9                	sbb    %ecx,%ecx
  800342:	83 e1 20             	and    $0x20,%ecx
  800345:	83 c1 41             	add    $0x41,%ecx
  800348:	29 ca                	sub    %ecx,%edx
  80034a:	09 d3                	or     %edx,%ebx
        c = *++cp;
  80034c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80034f:	0f be 57 01          	movsbl 0x1(%edi),%edx
  800353:	83 c0 01             	add    $0x1,%eax
  800356:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if (isdigit(c)) {
  800359:	89 d7                	mov    %edx,%edi
  80035b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80035e:	80 f9 09             	cmp    $0x9,%cl
  800361:	77 bb                	ja     80031e <inet_aton+0x49>
        val = (val * base) + (int)(c - '0');
  800363:	0f af de             	imul   %esi,%ebx
  800366:	8d 5c 1a d0          	lea    -0x30(%edx,%ebx,1),%ebx
        c = *++cp;
  80036a:	0f be 50 01          	movsbl 0x1(%eax),%edx
  80036e:	eb e3                	jmp    800353 <inet_aton+0x7e>
    if (c == '.') {
  800370:	83 fa 2e             	cmp    $0x2e,%edx
  800373:	75 42                	jne    8003b7 <inet_aton+0xe2>
      if (pp >= parts + 3)
  800375:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800378:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80037b:	39 c6                	cmp    %eax,%esi
  80037d:	0f 84 0e 01 00 00    	je     800491 <inet_aton+0x1bc>
      *pp++ = val;
  800383:	83 c6 04             	add    $0x4,%esi
  800386:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800389:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  80038c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  80038f:	8d 46 01             	lea    0x1(%esi),%eax
  800392:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  800396:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800399:	80 f9 09             	cmp    $0x9,%cl
  80039c:	0f 87 e8 00 00 00    	ja     80048a <inet_aton+0x1b5>
    base = 10;
  8003a2:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  8003a7:	83 fa 30             	cmp    $0x30,%edx
  8003aa:	0f 84 3f ff ff ff    	je     8002ef <inet_aton+0x1a>
    base = 10;
  8003b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b5:	eb 9f                	jmp    800356 <inet_aton+0x81>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003b7:	85 d2                	test   %edx,%edx
  8003b9:	74 26                	je     8003e1 <inet_aton+0x10c>
    return (0);
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003c0:	89 f9                	mov    %edi,%ecx
  8003c2:	80 f9 1f             	cmp    $0x1f,%cl
  8003c5:	0f 86 cb 00 00 00    	jbe    800496 <inet_aton+0x1c1>
  8003cb:	84 d2                	test   %dl,%dl
  8003cd:	0f 88 c3 00 00 00    	js     800496 <inet_aton+0x1c1>
  8003d3:	83 fa 20             	cmp    $0x20,%edx
  8003d6:	74 09                	je     8003e1 <inet_aton+0x10c>
  8003d8:	83 fa 0c             	cmp    $0xc,%edx
  8003db:	0f 85 b5 00 00 00    	jne    800496 <inet_aton+0x1c1>
  n = pp - parts + 1;
  8003e1:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8003e4:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8003e7:	29 c6                	sub    %eax,%esi
  8003e9:	89 f0                	mov    %esi,%eax
  8003eb:	c1 f8 02             	sar    $0x2,%eax
  8003ee:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  8003f1:	83 f8 02             	cmp    $0x2,%eax
  8003f4:	74 5e                	je     800454 <inet_aton+0x17f>
  8003f6:	7e 35                	jle    80042d <inet_aton+0x158>
  8003f8:	83 f8 03             	cmp    $0x3,%eax
  8003fb:	74 6e                	je     80046b <inet_aton+0x196>
  8003fd:	83 f8 04             	cmp    $0x4,%eax
  800400:	75 2f                	jne    800431 <inet_aton+0x15c>
      return (0);
  800402:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  800407:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  80040d:	0f 87 83 00 00 00    	ja     800496 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800413:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800416:	c1 e0 18             	shl    $0x18,%eax
  800419:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80041c:	c1 e2 10             	shl    $0x10,%edx
  80041f:	09 d0                	or     %edx,%eax
  800421:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800424:	c1 e2 08             	shl    $0x8,%edx
  800427:	09 d0                	or     %edx,%eax
  800429:	09 c3                	or     %eax,%ebx
    break;
  80042b:	eb 04                	jmp    800431 <inet_aton+0x15c>
  switch (n) {
  80042d:	85 c0                	test   %eax,%eax
  80042f:	74 65                	je     800496 <inet_aton+0x1c1>
  return (1);
  800431:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  800436:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80043a:	74 5a                	je     800496 <inet_aton+0x1c1>
    addr->s_addr = htonl(val);
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	53                   	push   %ebx
  800440:	e8 64 fe ff ff       	call   8002a9 <htonl>
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	8b 75 0c             	mov    0xc(%ebp),%esi
  80044b:	89 06                	mov    %eax,(%esi)
  return (1);
  80044d:	b8 01 00 00 00       	mov    $0x1,%eax
  800452:	eb 42                	jmp    800496 <inet_aton+0x1c1>
      return (0);
  800454:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  800459:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  80045f:	77 35                	ja     800496 <inet_aton+0x1c1>
    val |= parts[0] << 24;
  800461:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800464:	c1 e0 18             	shl    $0x18,%eax
  800467:	09 c3                	or     %eax,%ebx
    break;
  800469:	eb c6                	jmp    800431 <inet_aton+0x15c>
      return (0);
  80046b:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  800470:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  800476:	77 1e                	ja     800496 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16);
  800478:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80047b:	c1 e0 18             	shl    $0x18,%eax
  80047e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800481:	c1 e2 10             	shl    $0x10,%edx
  800484:	09 d0                	or     %edx,%eax
  800486:	09 c3                	or     %eax,%ebx
    break;
  800488:	eb a7                	jmp    800431 <inet_aton+0x15c>
      return (0);
  80048a:	b8 00 00 00 00       	mov    $0x0,%eax
  80048f:	eb 05                	jmp    800496 <inet_aton+0x1c1>
        return (0);
  800491:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800496:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800499:	5b                   	pop    %ebx
  80049a:	5e                   	pop    %esi
  80049b:	5f                   	pop    %edi
  80049c:	5d                   	pop    %ebp
  80049d:	c3                   	ret    

0080049e <inet_addr>:
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  8004a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004a7:	50                   	push   %eax
  8004a8:	ff 75 08             	pushl  0x8(%ebp)
  8004ab:	e8 25 fe ff ff       	call   8002d5 <inet_aton>
  8004b0:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004ba:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  8004c6:	ff 75 08             	pushl  0x8(%ebp)
  8004c9:	e8 db fd ff ff       	call   8002a9 <htonl>
  8004ce:	83 c4 10             	add    $0x10,%esp
}
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	56                   	push   %esi
  8004d7:	53                   	push   %ebx
  8004d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004db:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8004de:	e8 75 0a 00 00       	call   800f58 <sys_getenvid>
  8004e3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004e8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004eb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004f0:	a3 18 40 80 00       	mov    %eax,0x804018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004f5:	85 db                	test   %ebx,%ebx
  8004f7:	7e 07                	jle    800500 <libmain+0x2d>
		binaryname = argv[0];
  8004f9:	8b 06                	mov    (%esi),%eax
  8004fb:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	56                   	push   %esi
  800504:	53                   	push   %ebx
  800505:	e8 c9 fb ff ff       	call   8000d3 <umain>

	// exit gracefully
	exit();
  80050a:	e8 0a 00 00 00       	call   800519 <exit>
}
  80050f:	83 c4 10             	add    $0x10,%esp
  800512:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800515:	5b                   	pop    %ebx
  800516:	5e                   	pop    %esi
  800517:	5d                   	pop    %ebp
  800518:	c3                   	ret    

00800519 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80051f:	e8 5a 0e 00 00       	call   80137e <close_all>
	sys_env_destroy(0);
  800524:	83 ec 0c             	sub    $0xc,%esp
  800527:	6a 00                	push   $0x0
  800529:	e8 e9 09 00 00       	call   800f17 <sys_env_destroy>
}
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	53                   	push   %ebx
  800537:	83 ec 04             	sub    $0x4,%esp
  80053a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80053d:	8b 13                	mov    (%ebx),%edx
  80053f:	8d 42 01             	lea    0x1(%edx),%eax
  800542:	89 03                	mov    %eax,(%ebx)
  800544:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800547:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80054b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800550:	74 09                	je     80055b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800552:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800556:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800559:	c9                   	leave  
  80055a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	68 ff 00 00 00       	push   $0xff
  800563:	8d 43 08             	lea    0x8(%ebx),%eax
  800566:	50                   	push   %eax
  800567:	e8 6e 09 00 00       	call   800eda <sys_cputs>
		b->idx = 0;
  80056c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	eb db                	jmp    800552 <putch+0x1f>

00800577 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800580:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800587:	00 00 00 
	b.cnt = 0;
  80058a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800591:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800594:	ff 75 0c             	pushl  0xc(%ebp)
  800597:	ff 75 08             	pushl  0x8(%ebp)
  80059a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a0:	50                   	push   %eax
  8005a1:	68 33 05 80 00       	push   $0x800533
  8005a6:	e8 19 01 00 00       	call   8006c4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005ab:	83 c4 08             	add    $0x8,%esp
  8005ae:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005b4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005ba:	50                   	push   %eax
  8005bb:	e8 1a 09 00 00       	call   800eda <sys_cputs>

	return b.cnt;
}
  8005c0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005c6:	c9                   	leave  
  8005c7:	c3                   	ret    

008005c8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005c8:	55                   	push   %ebp
  8005c9:	89 e5                	mov    %esp,%ebp
  8005cb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ce:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005d1:	50                   	push   %eax
  8005d2:	ff 75 08             	pushl  0x8(%ebp)
  8005d5:	e8 9d ff ff ff       	call   800577 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	57                   	push   %edi
  8005e0:	56                   	push   %esi
  8005e1:	53                   	push   %ebx
  8005e2:	83 ec 1c             	sub    $0x1c,%esp
  8005e5:	89 c7                	mov    %eax,%edi
  8005e7:	89 d6                	mov    %edx,%esi
  8005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005fd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800600:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800603:	3b 45 10             	cmp    0x10(%ebp),%eax
  800606:	89 d0                	mov    %edx,%eax
  800608:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  80060b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80060e:	73 15                	jae    800625 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800610:	83 eb 01             	sub    $0x1,%ebx
  800613:	85 db                	test   %ebx,%ebx
  800615:	7e 43                	jle    80065a <printnum+0x7e>
			putch(padc, putdat);
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	56                   	push   %esi
  80061b:	ff 75 18             	pushl  0x18(%ebp)
  80061e:	ff d7                	call   *%edi
  800620:	83 c4 10             	add    $0x10,%esp
  800623:	eb eb                	jmp    800610 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800625:	83 ec 0c             	sub    $0xc,%esp
  800628:	ff 75 18             	pushl  0x18(%ebp)
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800631:	53                   	push   %ebx
  800632:	ff 75 10             	pushl  0x10(%ebp)
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	ff 75 e4             	pushl  -0x1c(%ebp)
  80063b:	ff 75 e0             	pushl  -0x20(%ebp)
  80063e:	ff 75 dc             	pushl  -0x24(%ebp)
  800641:	ff 75 d8             	pushl  -0x28(%ebp)
  800644:	e8 67 1e 00 00       	call   8024b0 <__udivdi3>
  800649:	83 c4 18             	add    $0x18,%esp
  80064c:	52                   	push   %edx
  80064d:	50                   	push   %eax
  80064e:	89 f2                	mov    %esi,%edx
  800650:	89 f8                	mov    %edi,%eax
  800652:	e8 85 ff ff ff       	call   8005dc <printnum>
  800657:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	56                   	push   %esi
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	ff 75 e4             	pushl  -0x1c(%ebp)
  800664:	ff 75 e0             	pushl  -0x20(%ebp)
  800667:	ff 75 dc             	pushl  -0x24(%ebp)
  80066a:	ff 75 d8             	pushl  -0x28(%ebp)
  80066d:	e8 4e 1f 00 00       	call   8025c0 <__umoddi3>
  800672:	83 c4 14             	add    $0x14,%esp
  800675:	0f be 80 45 28 80 00 	movsbl 0x802845(%eax),%eax
  80067c:	50                   	push   %eax
  80067d:	ff d7                	call   *%edi
}
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800685:	5b                   	pop    %ebx
  800686:	5e                   	pop    %esi
  800687:	5f                   	pop    %edi
  800688:	5d                   	pop    %ebp
  800689:	c3                   	ret    

0080068a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
  80068d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800690:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800694:	8b 10                	mov    (%eax),%edx
  800696:	3b 50 04             	cmp    0x4(%eax),%edx
  800699:	73 0a                	jae    8006a5 <sprintputch+0x1b>
		*b->buf++ = ch;
  80069b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80069e:	89 08                	mov    %ecx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	88 02                	mov    %al,(%edx)
}
  8006a5:	5d                   	pop    %ebp
  8006a6:	c3                   	ret    

008006a7 <printfmt>:
{
  8006a7:	55                   	push   %ebp
  8006a8:	89 e5                	mov    %esp,%ebp
  8006aa:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006ad:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006b0:	50                   	push   %eax
  8006b1:	ff 75 10             	pushl  0x10(%ebp)
  8006b4:	ff 75 0c             	pushl  0xc(%ebp)
  8006b7:	ff 75 08             	pushl  0x8(%ebp)
  8006ba:	e8 05 00 00 00       	call   8006c4 <vprintfmt>
}
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	c9                   	leave  
  8006c3:	c3                   	ret    

008006c4 <vprintfmt>:
{
  8006c4:	55                   	push   %ebp
  8006c5:	89 e5                	mov    %esp,%ebp
  8006c7:	57                   	push   %edi
  8006c8:	56                   	push   %esi
  8006c9:	53                   	push   %ebx
  8006ca:	83 ec 3c             	sub    $0x3c,%esp
  8006cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006d3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006d6:	eb 0a                	jmp    8006e2 <vprintfmt+0x1e>
			putch(ch, putdat);
  8006d8:	83 ec 08             	sub    $0x8,%esp
  8006db:	53                   	push   %ebx
  8006dc:	50                   	push   %eax
  8006dd:	ff d6                	call   *%esi
  8006df:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e2:	83 c7 01             	add    $0x1,%edi
  8006e5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e9:	83 f8 25             	cmp    $0x25,%eax
  8006ec:	74 0c                	je     8006fa <vprintfmt+0x36>
			if (ch == '\0')
  8006ee:	85 c0                	test   %eax,%eax
  8006f0:	75 e6                	jne    8006d8 <vprintfmt+0x14>
}
  8006f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006f5:	5b                   	pop    %ebx
  8006f6:	5e                   	pop    %esi
  8006f7:	5f                   	pop    %edi
  8006f8:	5d                   	pop    %ebp
  8006f9:	c3                   	ret    
		padc = ' ';
  8006fa:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8006fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800705:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80070c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800713:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800718:	8d 47 01             	lea    0x1(%edi),%eax
  80071b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80071e:	0f b6 17             	movzbl (%edi),%edx
  800721:	8d 42 dd             	lea    -0x23(%edx),%eax
  800724:	3c 55                	cmp    $0x55,%al
  800726:	0f 87 ba 03 00 00    	ja     800ae6 <vprintfmt+0x422>
  80072c:	0f b6 c0             	movzbl %al,%eax
  80072f:	ff 24 85 80 29 80 00 	jmp    *0x802980(,%eax,4)
  800736:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800739:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80073d:	eb d9                	jmp    800718 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80073f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800742:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800746:	eb d0                	jmp    800718 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800748:	0f b6 d2             	movzbl %dl,%edx
  80074b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80074e:	b8 00 00 00 00       	mov    $0x0,%eax
  800753:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800756:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800759:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80075d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800760:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800763:	83 f9 09             	cmp    $0x9,%ecx
  800766:	77 55                	ja     8007bd <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800768:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80076b:	eb e9                	jmp    800756 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	8d 40 04             	lea    0x4(%eax),%eax
  80077b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80077e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800781:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800785:	79 91                	jns    800718 <vprintfmt+0x54>
				width = precision, precision = -1;
  800787:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80078d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800794:	eb 82                	jmp    800718 <vprintfmt+0x54>
  800796:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800799:	85 c0                	test   %eax,%eax
  80079b:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a0:	0f 49 d0             	cmovns %eax,%edx
  8007a3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007a9:	e9 6a ff ff ff       	jmp    800718 <vprintfmt+0x54>
  8007ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007b1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8007b8:	e9 5b ff ff ff       	jmp    800718 <vprintfmt+0x54>
  8007bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c3:	eb bc                	jmp    800781 <vprintfmt+0xbd>
			lflag++;
  8007c5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007cb:	e9 48 ff ff ff       	jmp    800718 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	8d 78 04             	lea    0x4(%eax),%edi
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	53                   	push   %ebx
  8007da:	ff 30                	pushl  (%eax)
  8007dc:	ff d6                	call   *%esi
			break;
  8007de:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007e1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007e4:	e9 9c 02 00 00       	jmp    800a85 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8d 78 04             	lea    0x4(%eax),%edi
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	99                   	cltd   
  8007f2:	31 d0                	xor    %edx,%eax
  8007f4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007f6:	83 f8 0f             	cmp    $0xf,%eax
  8007f9:	7f 23                	jg     80081e <vprintfmt+0x15a>
  8007fb:	8b 14 85 e0 2a 80 00 	mov    0x802ae0(,%eax,4),%edx
  800802:	85 d2                	test   %edx,%edx
  800804:	74 18                	je     80081e <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800806:	52                   	push   %edx
  800807:	68 1a 2c 80 00       	push   $0x802c1a
  80080c:	53                   	push   %ebx
  80080d:	56                   	push   %esi
  80080e:	e8 94 fe ff ff       	call   8006a7 <printfmt>
  800813:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800816:	89 7d 14             	mov    %edi,0x14(%ebp)
  800819:	e9 67 02 00 00       	jmp    800a85 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  80081e:	50                   	push   %eax
  80081f:	68 5d 28 80 00       	push   $0x80285d
  800824:	53                   	push   %ebx
  800825:	56                   	push   %esi
  800826:	e8 7c fe ff ff       	call   8006a7 <printfmt>
  80082b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80082e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800831:	e9 4f 02 00 00       	jmp    800a85 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	83 c0 04             	add    $0x4,%eax
  80083c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800844:	85 d2                	test   %edx,%edx
  800846:	b8 56 28 80 00       	mov    $0x802856,%eax
  80084b:	0f 45 c2             	cmovne %edx,%eax
  80084e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800851:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800855:	7e 06                	jle    80085d <vprintfmt+0x199>
  800857:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80085b:	75 0d                	jne    80086a <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80085d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800860:	89 c7                	mov    %eax,%edi
  800862:	03 45 e0             	add    -0x20(%ebp),%eax
  800865:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800868:	eb 3f                	jmp    8008a9 <vprintfmt+0x1e5>
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 d8             	pushl  -0x28(%ebp)
  800870:	50                   	push   %eax
  800871:	e8 0d 03 00 00       	call   800b83 <strnlen>
  800876:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800879:	29 c2                	sub    %eax,%edx
  80087b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80087e:	83 c4 10             	add    $0x10,%esp
  800881:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800883:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800887:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80088a:	85 ff                	test   %edi,%edi
  80088c:	7e 58                	jle    8008e6 <vprintfmt+0x222>
					putch(padc, putdat);
  80088e:	83 ec 08             	sub    $0x8,%esp
  800891:	53                   	push   %ebx
  800892:	ff 75 e0             	pushl  -0x20(%ebp)
  800895:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800897:	83 ef 01             	sub    $0x1,%edi
  80089a:	83 c4 10             	add    $0x10,%esp
  80089d:	eb eb                	jmp    80088a <vprintfmt+0x1c6>
					putch(ch, putdat);
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	53                   	push   %ebx
  8008a3:	52                   	push   %edx
  8008a4:	ff d6                	call   *%esi
  8008a6:	83 c4 10             	add    $0x10,%esp
  8008a9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008ac:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ae:	83 c7 01             	add    $0x1,%edi
  8008b1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008b5:	0f be d0             	movsbl %al,%edx
  8008b8:	85 d2                	test   %edx,%edx
  8008ba:	74 45                	je     800901 <vprintfmt+0x23d>
  8008bc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008c0:	78 06                	js     8008c8 <vprintfmt+0x204>
  8008c2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008c6:	78 35                	js     8008fd <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8008c8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008cc:	74 d1                	je     80089f <vprintfmt+0x1db>
  8008ce:	0f be c0             	movsbl %al,%eax
  8008d1:	83 e8 20             	sub    $0x20,%eax
  8008d4:	83 f8 5e             	cmp    $0x5e,%eax
  8008d7:	76 c6                	jbe    80089f <vprintfmt+0x1db>
					putch('?', putdat);
  8008d9:	83 ec 08             	sub    $0x8,%esp
  8008dc:	53                   	push   %ebx
  8008dd:	6a 3f                	push   $0x3f
  8008df:	ff d6                	call   *%esi
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	eb c3                	jmp    8008a9 <vprintfmt+0x1e5>
  8008e6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008e9:	85 d2                	test   %edx,%edx
  8008eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f0:	0f 49 c2             	cmovns %edx,%eax
  8008f3:	29 c2                	sub    %eax,%edx
  8008f5:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8008f8:	e9 60 ff ff ff       	jmp    80085d <vprintfmt+0x199>
  8008fd:	89 cf                	mov    %ecx,%edi
  8008ff:	eb 02                	jmp    800903 <vprintfmt+0x23f>
  800901:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800903:	85 ff                	test   %edi,%edi
  800905:	7e 10                	jle    800917 <vprintfmt+0x253>
				putch(' ', putdat);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	53                   	push   %ebx
  80090b:	6a 20                	push   $0x20
  80090d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80090f:	83 ef 01             	sub    $0x1,%edi
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	eb ec                	jmp    800903 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800917:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80091a:	89 45 14             	mov    %eax,0x14(%ebp)
  80091d:	e9 63 01 00 00       	jmp    800a85 <vprintfmt+0x3c1>
	if (lflag >= 2)
  800922:	83 f9 01             	cmp    $0x1,%ecx
  800925:	7f 1b                	jg     800942 <vprintfmt+0x27e>
	else if (lflag)
  800927:	85 c9                	test   %ecx,%ecx
  800929:	74 63                	je     80098e <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800933:	99                   	cltd   
  800934:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	8d 40 04             	lea    0x4(%eax),%eax
  80093d:	89 45 14             	mov    %eax,0x14(%ebp)
  800940:	eb 17                	jmp    800959 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	8b 50 04             	mov    0x4(%eax),%edx
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	8d 40 08             	lea    0x8(%eax),%eax
  800956:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800959:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80095c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80095f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800964:	85 c9                	test   %ecx,%ecx
  800966:	0f 89 ff 00 00 00    	jns    800a6b <vprintfmt+0x3a7>
				putch('-', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	53                   	push   %ebx
  800970:	6a 2d                	push   $0x2d
  800972:	ff d6                	call   *%esi
				num = -(long long) num;
  800974:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800977:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80097a:	f7 da                	neg    %edx
  80097c:	83 d1 00             	adc    $0x0,%ecx
  80097f:	f7 d9                	neg    %ecx
  800981:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800984:	b8 0a 00 00 00       	mov    $0xa,%eax
  800989:	e9 dd 00 00 00       	jmp    800a6b <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80098e:	8b 45 14             	mov    0x14(%ebp),%eax
  800991:	8b 00                	mov    (%eax),%eax
  800993:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800996:	99                   	cltd   
  800997:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80099a:	8b 45 14             	mov    0x14(%ebp),%eax
  80099d:	8d 40 04             	lea    0x4(%eax),%eax
  8009a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a3:	eb b4                	jmp    800959 <vprintfmt+0x295>
	if (lflag >= 2)
  8009a5:	83 f9 01             	cmp    $0x1,%ecx
  8009a8:	7f 1e                	jg     8009c8 <vprintfmt+0x304>
	else if (lflag)
  8009aa:	85 c9                	test   %ecx,%ecx
  8009ac:	74 32                	je     8009e0 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8009ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b1:	8b 10                	mov    (%eax),%edx
  8009b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009b8:	8d 40 04             	lea    0x4(%eax),%eax
  8009bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009c3:	e9 a3 00 00 00       	jmp    800a6b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	8b 10                	mov    (%eax),%edx
  8009cd:	8b 48 04             	mov    0x4(%eax),%ecx
  8009d0:	8d 40 08             	lea    0x8(%eax),%eax
  8009d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009d6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009db:	e9 8b 00 00 00       	jmp    800a6b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8009e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e3:	8b 10                	mov    (%eax),%edx
  8009e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009ea:	8d 40 04             	lea    0x4(%eax),%eax
  8009ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009f0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009f5:	eb 74                	jmp    800a6b <vprintfmt+0x3a7>
	if (lflag >= 2)
  8009f7:	83 f9 01             	cmp    $0x1,%ecx
  8009fa:	7f 1b                	jg     800a17 <vprintfmt+0x353>
	else if (lflag)
  8009fc:	85 c9                	test   %ecx,%ecx
  8009fe:	74 2c                	je     800a2c <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800a00:	8b 45 14             	mov    0x14(%ebp),%eax
  800a03:	8b 10                	mov    (%eax),%edx
  800a05:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a0a:	8d 40 04             	lea    0x4(%eax),%eax
  800a0d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a10:	b8 08 00 00 00       	mov    $0x8,%eax
  800a15:	eb 54                	jmp    800a6b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	8b 10                	mov    (%eax),%edx
  800a1c:	8b 48 04             	mov    0x4(%eax),%ecx
  800a1f:	8d 40 08             	lea    0x8(%eax),%eax
  800a22:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a25:	b8 08 00 00 00       	mov    $0x8,%eax
  800a2a:	eb 3f                	jmp    800a6b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2f:	8b 10                	mov    (%eax),%edx
  800a31:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a36:	8d 40 04             	lea    0x4(%eax),%eax
  800a39:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a3c:	b8 08 00 00 00       	mov    $0x8,%eax
  800a41:	eb 28                	jmp    800a6b <vprintfmt+0x3a7>
			putch('0', putdat);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	53                   	push   %ebx
  800a47:	6a 30                	push   $0x30
  800a49:	ff d6                	call   *%esi
			putch('x', putdat);
  800a4b:	83 c4 08             	add    $0x8,%esp
  800a4e:	53                   	push   %ebx
  800a4f:	6a 78                	push   $0x78
  800a51:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	8b 10                	mov    (%eax),%edx
  800a58:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a5d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a60:	8d 40 04             	lea    0x4(%eax),%eax
  800a63:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a66:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a6b:	83 ec 0c             	sub    $0xc,%esp
  800a6e:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800a72:	57                   	push   %edi
  800a73:	ff 75 e0             	pushl  -0x20(%ebp)
  800a76:	50                   	push   %eax
  800a77:	51                   	push   %ecx
  800a78:	52                   	push   %edx
  800a79:	89 da                	mov    %ebx,%edx
  800a7b:	89 f0                	mov    %esi,%eax
  800a7d:	e8 5a fb ff ff       	call   8005dc <printnum>
			break;
  800a82:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a85:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a88:	e9 55 fc ff ff       	jmp    8006e2 <vprintfmt+0x1e>
	if (lflag >= 2)
  800a8d:	83 f9 01             	cmp    $0x1,%ecx
  800a90:	7f 1b                	jg     800aad <vprintfmt+0x3e9>
	else if (lflag)
  800a92:	85 c9                	test   %ecx,%ecx
  800a94:	74 2c                	je     800ac2 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	8b 10                	mov    (%eax),%edx
  800a9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800aa0:	8d 40 04             	lea    0x4(%eax),%eax
  800aa3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aa6:	b8 10 00 00 00       	mov    $0x10,%eax
  800aab:	eb be                	jmp    800a6b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800aad:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab0:	8b 10                	mov    (%eax),%edx
  800ab2:	8b 48 04             	mov    0x4(%eax),%ecx
  800ab5:	8d 40 08             	lea    0x8(%eax),%eax
  800ab8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800abb:	b8 10 00 00 00       	mov    $0x10,%eax
  800ac0:	eb a9                	jmp    800a6b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800ac2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac5:	8b 10                	mov    (%eax),%edx
  800ac7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800acc:	8d 40 04             	lea    0x4(%eax),%eax
  800acf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ad2:	b8 10 00 00 00       	mov    $0x10,%eax
  800ad7:	eb 92                	jmp    800a6b <vprintfmt+0x3a7>
			putch(ch, putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	53                   	push   %ebx
  800add:	6a 25                	push   $0x25
  800adf:	ff d6                	call   *%esi
			break;
  800ae1:	83 c4 10             	add    $0x10,%esp
  800ae4:	eb 9f                	jmp    800a85 <vprintfmt+0x3c1>
			putch('%', putdat);
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	53                   	push   %ebx
  800aea:	6a 25                	push   $0x25
  800aec:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aee:	83 c4 10             	add    $0x10,%esp
  800af1:	89 f8                	mov    %edi,%eax
  800af3:	eb 03                	jmp    800af8 <vprintfmt+0x434>
  800af5:	83 e8 01             	sub    $0x1,%eax
  800af8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800afc:	75 f7                	jne    800af5 <vprintfmt+0x431>
  800afe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b01:	eb 82                	jmp    800a85 <vprintfmt+0x3c1>

00800b03 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	83 ec 18             	sub    $0x18,%esp
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b12:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b16:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b20:	85 c0                	test   %eax,%eax
  800b22:	74 26                	je     800b4a <vsnprintf+0x47>
  800b24:	85 d2                	test   %edx,%edx
  800b26:	7e 22                	jle    800b4a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b28:	ff 75 14             	pushl  0x14(%ebp)
  800b2b:	ff 75 10             	pushl  0x10(%ebp)
  800b2e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b31:	50                   	push   %eax
  800b32:	68 8a 06 80 00       	push   $0x80068a
  800b37:	e8 88 fb ff ff       	call   8006c4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b3f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b45:	83 c4 10             	add    $0x10,%esp
}
  800b48:	c9                   	leave  
  800b49:	c3                   	ret    
		return -E_INVAL;
  800b4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b4f:	eb f7                	jmp    800b48 <vsnprintf+0x45>

00800b51 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b57:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b5a:	50                   	push   %eax
  800b5b:	ff 75 10             	pushl  0x10(%ebp)
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	ff 75 08             	pushl  0x8(%ebp)
  800b64:	e8 9a ff ff ff       	call   800b03 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b69:	c9                   	leave  
  800b6a:	c3                   	ret    

00800b6b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b71:	b8 00 00 00 00       	mov    $0x0,%eax
  800b76:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b7a:	74 05                	je     800b81 <strlen+0x16>
		n++;
  800b7c:	83 c0 01             	add    $0x1,%eax
  800b7f:	eb f5                	jmp    800b76 <strlen+0xb>
	return n;
}
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b89:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b91:	39 c2                	cmp    %eax,%edx
  800b93:	74 0d                	je     800ba2 <strnlen+0x1f>
  800b95:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b99:	74 05                	je     800ba0 <strnlen+0x1d>
		n++;
  800b9b:	83 c2 01             	add    $0x1,%edx
  800b9e:	eb f1                	jmp    800b91 <strnlen+0xe>
  800ba0:	89 d0                	mov    %edx,%eax
	return n;
}
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	53                   	push   %ebx
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bae:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb3:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bb7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bba:	83 c2 01             	add    $0x1,%edx
  800bbd:	84 c9                	test   %cl,%cl
  800bbf:	75 f2                	jne    800bb3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	53                   	push   %ebx
  800bc8:	83 ec 10             	sub    $0x10,%esp
  800bcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bce:	53                   	push   %ebx
  800bcf:	e8 97 ff ff ff       	call   800b6b <strlen>
  800bd4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bd7:	ff 75 0c             	pushl  0xc(%ebp)
  800bda:	01 d8                	add    %ebx,%eax
  800bdc:	50                   	push   %eax
  800bdd:	e8 c2 ff ff ff       	call   800ba4 <strcpy>
	return dst;
}
  800be2:	89 d8                	mov    %ebx,%eax
  800be4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	56                   	push   %esi
  800bed:	53                   	push   %ebx
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf4:	89 c6                	mov    %eax,%esi
  800bf6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bf9:	89 c2                	mov    %eax,%edx
  800bfb:	39 f2                	cmp    %esi,%edx
  800bfd:	74 11                	je     800c10 <strncpy+0x27>
		*dst++ = *src;
  800bff:	83 c2 01             	add    $0x1,%edx
  800c02:	0f b6 19             	movzbl (%ecx),%ebx
  800c05:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c08:	80 fb 01             	cmp    $0x1,%bl
  800c0b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c0e:	eb eb                	jmp    800bfb <strncpy+0x12>
	}
	return ret;
}
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	56                   	push   %esi
  800c18:	53                   	push   %ebx
  800c19:	8b 75 08             	mov    0x8(%ebp),%esi
  800c1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1f:	8b 55 10             	mov    0x10(%ebp),%edx
  800c22:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c24:	85 d2                	test   %edx,%edx
  800c26:	74 21                	je     800c49 <strlcpy+0x35>
  800c28:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c2c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c2e:	39 c2                	cmp    %eax,%edx
  800c30:	74 14                	je     800c46 <strlcpy+0x32>
  800c32:	0f b6 19             	movzbl (%ecx),%ebx
  800c35:	84 db                	test   %bl,%bl
  800c37:	74 0b                	je     800c44 <strlcpy+0x30>
			*dst++ = *src++;
  800c39:	83 c1 01             	add    $0x1,%ecx
  800c3c:	83 c2 01             	add    $0x1,%edx
  800c3f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c42:	eb ea                	jmp    800c2e <strlcpy+0x1a>
  800c44:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c46:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c49:	29 f0                	sub    %esi,%eax
}
  800c4b:	5b                   	pop    %ebx
  800c4c:	5e                   	pop    %esi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c55:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c58:	0f b6 01             	movzbl (%ecx),%eax
  800c5b:	84 c0                	test   %al,%al
  800c5d:	74 0c                	je     800c6b <strcmp+0x1c>
  800c5f:	3a 02                	cmp    (%edx),%al
  800c61:	75 08                	jne    800c6b <strcmp+0x1c>
		p++, q++;
  800c63:	83 c1 01             	add    $0x1,%ecx
  800c66:	83 c2 01             	add    $0x1,%edx
  800c69:	eb ed                	jmp    800c58 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c6b:	0f b6 c0             	movzbl %al,%eax
  800c6e:	0f b6 12             	movzbl (%edx),%edx
  800c71:	29 d0                	sub    %edx,%eax
}
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	53                   	push   %ebx
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7f:	89 c3                	mov    %eax,%ebx
  800c81:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c84:	eb 06                	jmp    800c8c <strncmp+0x17>
		n--, p++, q++;
  800c86:	83 c0 01             	add    $0x1,%eax
  800c89:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c8c:	39 d8                	cmp    %ebx,%eax
  800c8e:	74 16                	je     800ca6 <strncmp+0x31>
  800c90:	0f b6 08             	movzbl (%eax),%ecx
  800c93:	84 c9                	test   %cl,%cl
  800c95:	74 04                	je     800c9b <strncmp+0x26>
  800c97:	3a 0a                	cmp    (%edx),%cl
  800c99:	74 eb                	je     800c86 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c9b:	0f b6 00             	movzbl (%eax),%eax
  800c9e:	0f b6 12             	movzbl (%edx),%edx
  800ca1:	29 d0                	sub    %edx,%eax
}
  800ca3:	5b                   	pop    %ebx
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    
		return 0;
  800ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cab:	eb f6                	jmp    800ca3 <strncmp+0x2e>

00800cad <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cb7:	0f b6 10             	movzbl (%eax),%edx
  800cba:	84 d2                	test   %dl,%dl
  800cbc:	74 09                	je     800cc7 <strchr+0x1a>
		if (*s == c)
  800cbe:	38 ca                	cmp    %cl,%dl
  800cc0:	74 0a                	je     800ccc <strchr+0x1f>
	for (; *s; s++)
  800cc2:	83 c0 01             	add    $0x1,%eax
  800cc5:	eb f0                	jmp    800cb7 <strchr+0xa>
			return (char *) s;
	return 0;
  800cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cd8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cdb:	38 ca                	cmp    %cl,%dl
  800cdd:	74 09                	je     800ce8 <strfind+0x1a>
  800cdf:	84 d2                	test   %dl,%dl
  800ce1:	74 05                	je     800ce8 <strfind+0x1a>
	for (; *s; s++)
  800ce3:	83 c0 01             	add    $0x1,%eax
  800ce6:	eb f0                	jmp    800cd8 <strfind+0xa>
			break;
	return (char *) s;
}
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
  800cf0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cf3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cf6:	85 c9                	test   %ecx,%ecx
  800cf8:	74 31                	je     800d2b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cfa:	89 f8                	mov    %edi,%eax
  800cfc:	09 c8                	or     %ecx,%eax
  800cfe:	a8 03                	test   $0x3,%al
  800d00:	75 23                	jne    800d25 <memset+0x3b>
		c &= 0xFF;
  800d02:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d06:	89 d3                	mov    %edx,%ebx
  800d08:	c1 e3 08             	shl    $0x8,%ebx
  800d0b:	89 d0                	mov    %edx,%eax
  800d0d:	c1 e0 18             	shl    $0x18,%eax
  800d10:	89 d6                	mov    %edx,%esi
  800d12:	c1 e6 10             	shl    $0x10,%esi
  800d15:	09 f0                	or     %esi,%eax
  800d17:	09 c2                	or     %eax,%edx
  800d19:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d1b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d1e:	89 d0                	mov    %edx,%eax
  800d20:	fc                   	cld    
  800d21:	f3 ab                	rep stos %eax,%es:(%edi)
  800d23:	eb 06                	jmp    800d2b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d28:	fc                   	cld    
  800d29:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d2b:	89 f8                	mov    %edi,%eax
  800d2d:	5b                   	pop    %ebx
  800d2e:	5e                   	pop    %esi
  800d2f:	5f                   	pop    %edi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    

00800d32 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	57                   	push   %edi
  800d36:	56                   	push   %esi
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d40:	39 c6                	cmp    %eax,%esi
  800d42:	73 32                	jae    800d76 <memmove+0x44>
  800d44:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d47:	39 c2                	cmp    %eax,%edx
  800d49:	76 2b                	jbe    800d76 <memmove+0x44>
		s += n;
		d += n;
  800d4b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d4e:	89 fe                	mov    %edi,%esi
  800d50:	09 ce                	or     %ecx,%esi
  800d52:	09 d6                	or     %edx,%esi
  800d54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d5a:	75 0e                	jne    800d6a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d5c:	83 ef 04             	sub    $0x4,%edi
  800d5f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d62:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d65:	fd                   	std    
  800d66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d68:	eb 09                	jmp    800d73 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d6a:	83 ef 01             	sub    $0x1,%edi
  800d6d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d70:	fd                   	std    
  800d71:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d73:	fc                   	cld    
  800d74:	eb 1a                	jmp    800d90 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d76:	89 c2                	mov    %eax,%edx
  800d78:	09 ca                	or     %ecx,%edx
  800d7a:	09 f2                	or     %esi,%edx
  800d7c:	f6 c2 03             	test   $0x3,%dl
  800d7f:	75 0a                	jne    800d8b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d81:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d84:	89 c7                	mov    %eax,%edi
  800d86:	fc                   	cld    
  800d87:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d89:	eb 05                	jmp    800d90 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d8b:	89 c7                	mov    %eax,%edi
  800d8d:	fc                   	cld    
  800d8e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d9a:	ff 75 10             	pushl  0x10(%ebp)
  800d9d:	ff 75 0c             	pushl  0xc(%ebp)
  800da0:	ff 75 08             	pushl  0x8(%ebp)
  800da3:	e8 8a ff ff ff       	call   800d32 <memmove>
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db5:	89 c6                	mov    %eax,%esi
  800db7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dba:	39 f0                	cmp    %esi,%eax
  800dbc:	74 1c                	je     800dda <memcmp+0x30>
		if (*s1 != *s2)
  800dbe:	0f b6 08             	movzbl (%eax),%ecx
  800dc1:	0f b6 1a             	movzbl (%edx),%ebx
  800dc4:	38 d9                	cmp    %bl,%cl
  800dc6:	75 08                	jne    800dd0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dc8:	83 c0 01             	add    $0x1,%eax
  800dcb:	83 c2 01             	add    $0x1,%edx
  800dce:	eb ea                	jmp    800dba <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dd0:	0f b6 c1             	movzbl %cl,%eax
  800dd3:	0f b6 db             	movzbl %bl,%ebx
  800dd6:	29 d8                	sub    %ebx,%eax
  800dd8:	eb 05                	jmp    800ddf <memcmp+0x35>
	}

	return 0;
  800dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dec:	89 c2                	mov    %eax,%edx
  800dee:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800df1:	39 d0                	cmp    %edx,%eax
  800df3:	73 09                	jae    800dfe <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800df5:	38 08                	cmp    %cl,(%eax)
  800df7:	74 05                	je     800dfe <memfind+0x1b>
	for (; s < ends; s++)
  800df9:	83 c0 01             	add    $0x1,%eax
  800dfc:	eb f3                	jmp    800df1 <memfind+0xe>
			break;
	return (void *) s;
}
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	57                   	push   %edi
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e09:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e0c:	eb 03                	jmp    800e11 <strtol+0x11>
		s++;
  800e0e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e11:	0f b6 01             	movzbl (%ecx),%eax
  800e14:	3c 20                	cmp    $0x20,%al
  800e16:	74 f6                	je     800e0e <strtol+0xe>
  800e18:	3c 09                	cmp    $0x9,%al
  800e1a:	74 f2                	je     800e0e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e1c:	3c 2b                	cmp    $0x2b,%al
  800e1e:	74 2a                	je     800e4a <strtol+0x4a>
	int neg = 0;
  800e20:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e25:	3c 2d                	cmp    $0x2d,%al
  800e27:	74 2b                	je     800e54 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e29:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e2f:	75 0f                	jne    800e40 <strtol+0x40>
  800e31:	80 39 30             	cmpb   $0x30,(%ecx)
  800e34:	74 28                	je     800e5e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e36:	85 db                	test   %ebx,%ebx
  800e38:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e3d:	0f 44 d8             	cmove  %eax,%ebx
  800e40:	b8 00 00 00 00       	mov    $0x0,%eax
  800e45:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e48:	eb 50                	jmp    800e9a <strtol+0x9a>
		s++;
  800e4a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e4d:	bf 00 00 00 00       	mov    $0x0,%edi
  800e52:	eb d5                	jmp    800e29 <strtol+0x29>
		s++, neg = 1;
  800e54:	83 c1 01             	add    $0x1,%ecx
  800e57:	bf 01 00 00 00       	mov    $0x1,%edi
  800e5c:	eb cb                	jmp    800e29 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e5e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e62:	74 0e                	je     800e72 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e64:	85 db                	test   %ebx,%ebx
  800e66:	75 d8                	jne    800e40 <strtol+0x40>
		s++, base = 8;
  800e68:	83 c1 01             	add    $0x1,%ecx
  800e6b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e70:	eb ce                	jmp    800e40 <strtol+0x40>
		s += 2, base = 16;
  800e72:	83 c1 02             	add    $0x2,%ecx
  800e75:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e7a:	eb c4                	jmp    800e40 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e7c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e7f:	89 f3                	mov    %esi,%ebx
  800e81:	80 fb 19             	cmp    $0x19,%bl
  800e84:	77 29                	ja     800eaf <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e86:	0f be d2             	movsbl %dl,%edx
  800e89:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e8c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e8f:	7d 30                	jge    800ec1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e91:	83 c1 01             	add    $0x1,%ecx
  800e94:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e98:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e9a:	0f b6 11             	movzbl (%ecx),%edx
  800e9d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ea0:	89 f3                	mov    %esi,%ebx
  800ea2:	80 fb 09             	cmp    $0x9,%bl
  800ea5:	77 d5                	ja     800e7c <strtol+0x7c>
			dig = *s - '0';
  800ea7:	0f be d2             	movsbl %dl,%edx
  800eaa:	83 ea 30             	sub    $0x30,%edx
  800ead:	eb dd                	jmp    800e8c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800eaf:	8d 72 bf             	lea    -0x41(%edx),%esi
  800eb2:	89 f3                	mov    %esi,%ebx
  800eb4:	80 fb 19             	cmp    $0x19,%bl
  800eb7:	77 08                	ja     800ec1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800eb9:	0f be d2             	movsbl %dl,%edx
  800ebc:	83 ea 37             	sub    $0x37,%edx
  800ebf:	eb cb                	jmp    800e8c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ec1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec5:	74 05                	je     800ecc <strtol+0xcc>
		*endptr = (char *) s;
  800ec7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eca:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ecc:	89 c2                	mov    %eax,%edx
  800ece:	f7 da                	neg    %edx
  800ed0:	85 ff                	test   %edi,%edi
  800ed2:	0f 45 c2             	cmovne %edx,%eax
}
  800ed5:	5b                   	pop    %ebx
  800ed6:	5e                   	pop    %esi
  800ed7:	5f                   	pop    %edi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eeb:	89 c3                	mov    %eax,%ebx
  800eed:	89 c7                	mov    %eax,%edi
  800eef:	89 c6                	mov    %eax,%esi
  800ef1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efe:	ba 00 00 00 00       	mov    $0x0,%edx
  800f03:	b8 01 00 00 00       	mov    $0x1,%eax
  800f08:	89 d1                	mov    %edx,%ecx
  800f0a:	89 d3                	mov    %edx,%ebx
  800f0c:	89 d7                	mov    %edx,%edi
  800f0e:	89 d6                	mov    %edx,%esi
  800f10:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f12:	5b                   	pop    %ebx
  800f13:	5e                   	pop    %esi
  800f14:	5f                   	pop    %edi
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    

00800f17 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	57                   	push   %edi
  800f1b:	56                   	push   %esi
  800f1c:	53                   	push   %ebx
  800f1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f20:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f25:	8b 55 08             	mov    0x8(%ebp),%edx
  800f28:	b8 03 00 00 00       	mov    $0x3,%eax
  800f2d:	89 cb                	mov    %ecx,%ebx
  800f2f:	89 cf                	mov    %ecx,%edi
  800f31:	89 ce                	mov    %ecx,%esi
  800f33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f35:	85 c0                	test   %eax,%eax
  800f37:	7f 08                	jg     800f41 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	50                   	push   %eax
  800f45:	6a 03                	push   $0x3
  800f47:	68 3f 2b 80 00       	push   $0x802b3f
  800f4c:	6a 23                	push   $0x23
  800f4e:	68 5c 2b 80 00       	push   $0x802b5c
  800f53:	e8 b1 13 00 00       	call   802309 <_panic>

00800f58 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f63:	b8 02 00 00 00       	mov    $0x2,%eax
  800f68:	89 d1                	mov    %edx,%ecx
  800f6a:	89 d3                	mov    %edx,%ebx
  800f6c:	89 d7                	mov    %edx,%edi
  800f6e:	89 d6                	mov    %edx,%esi
  800f70:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5f                   	pop    %edi
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    

00800f77 <sys_yield>:

void
sys_yield(void)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	57                   	push   %edi
  800f7b:	56                   	push   %esi
  800f7c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f82:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f87:	89 d1                	mov    %edx,%ecx
  800f89:	89 d3                	mov    %edx,%ebx
  800f8b:	89 d7                	mov    %edx,%edi
  800f8d:	89 d6                	mov    %edx,%esi
  800f8f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f91:	5b                   	pop    %ebx
  800f92:	5e                   	pop    %esi
  800f93:	5f                   	pop    %edi
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    

00800f96 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	57                   	push   %edi
  800f9a:	56                   	push   %esi
  800f9b:	53                   	push   %ebx
  800f9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9f:	be 00 00 00 00       	mov    $0x0,%esi
  800fa4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800faa:	b8 04 00 00 00       	mov    $0x4,%eax
  800faf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fb2:	89 f7                	mov    %esi,%edi
  800fb4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	7f 08                	jg     800fc2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5f                   	pop    %edi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc2:	83 ec 0c             	sub    $0xc,%esp
  800fc5:	50                   	push   %eax
  800fc6:	6a 04                	push   $0x4
  800fc8:	68 3f 2b 80 00       	push   $0x802b3f
  800fcd:	6a 23                	push   $0x23
  800fcf:	68 5c 2b 80 00       	push   $0x802b5c
  800fd4:	e8 30 13 00 00       	call   802309 <_panic>

00800fd9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe8:	b8 05 00 00 00       	mov    $0x5,%eax
  800fed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ff3:	8b 75 18             	mov    0x18(%ebp),%esi
  800ff6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff8:	85 c0                	test   %eax,%eax
  800ffa:	7f 08                	jg     801004 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fff:	5b                   	pop    %ebx
  801000:	5e                   	pop    %esi
  801001:	5f                   	pop    %edi
  801002:	5d                   	pop    %ebp
  801003:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801004:	83 ec 0c             	sub    $0xc,%esp
  801007:	50                   	push   %eax
  801008:	6a 05                	push   $0x5
  80100a:	68 3f 2b 80 00       	push   $0x802b3f
  80100f:	6a 23                	push   $0x23
  801011:	68 5c 2b 80 00       	push   $0x802b5c
  801016:	e8 ee 12 00 00       	call   802309 <_panic>

0080101b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	57                   	push   %edi
  80101f:	56                   	push   %esi
  801020:	53                   	push   %ebx
  801021:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801024:	bb 00 00 00 00       	mov    $0x0,%ebx
  801029:	8b 55 08             	mov    0x8(%ebp),%edx
  80102c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102f:	b8 06 00 00 00       	mov    $0x6,%eax
  801034:	89 df                	mov    %ebx,%edi
  801036:	89 de                	mov    %ebx,%esi
  801038:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103a:	85 c0                	test   %eax,%eax
  80103c:	7f 08                	jg     801046 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80103e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801041:	5b                   	pop    %ebx
  801042:	5e                   	pop    %esi
  801043:	5f                   	pop    %edi
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801046:	83 ec 0c             	sub    $0xc,%esp
  801049:	50                   	push   %eax
  80104a:	6a 06                	push   $0x6
  80104c:	68 3f 2b 80 00       	push   $0x802b3f
  801051:	6a 23                	push   $0x23
  801053:	68 5c 2b 80 00       	push   $0x802b5c
  801058:	e8 ac 12 00 00       	call   802309 <_panic>

0080105d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	57                   	push   %edi
  801061:	56                   	push   %esi
  801062:	53                   	push   %ebx
  801063:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801066:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106b:	8b 55 08             	mov    0x8(%ebp),%edx
  80106e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801071:	b8 08 00 00 00       	mov    $0x8,%eax
  801076:	89 df                	mov    %ebx,%edi
  801078:	89 de                	mov    %ebx,%esi
  80107a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80107c:	85 c0                	test   %eax,%eax
  80107e:	7f 08                	jg     801088 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801080:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801083:	5b                   	pop    %ebx
  801084:	5e                   	pop    %esi
  801085:	5f                   	pop    %edi
  801086:	5d                   	pop    %ebp
  801087:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801088:	83 ec 0c             	sub    $0xc,%esp
  80108b:	50                   	push   %eax
  80108c:	6a 08                	push   $0x8
  80108e:	68 3f 2b 80 00       	push   $0x802b3f
  801093:	6a 23                	push   $0x23
  801095:	68 5c 2b 80 00       	push   $0x802b5c
  80109a:	e8 6a 12 00 00       	call   802309 <_panic>

0080109f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	57                   	push   %edi
  8010a3:	56                   	push   %esi
  8010a4:	53                   	push   %ebx
  8010a5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b3:	b8 09 00 00 00       	mov    $0x9,%eax
  8010b8:	89 df                	mov    %ebx,%edi
  8010ba:	89 de                	mov    %ebx,%esi
  8010bc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	7f 08                	jg     8010ca <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c5:	5b                   	pop    %ebx
  8010c6:	5e                   	pop    %esi
  8010c7:	5f                   	pop    %edi
  8010c8:	5d                   	pop    %ebp
  8010c9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ca:	83 ec 0c             	sub    $0xc,%esp
  8010cd:	50                   	push   %eax
  8010ce:	6a 09                	push   $0x9
  8010d0:	68 3f 2b 80 00       	push   $0x802b3f
  8010d5:	6a 23                	push   $0x23
  8010d7:	68 5c 2b 80 00       	push   $0x802b5c
  8010dc:	e8 28 12 00 00       	call   802309 <_panic>

008010e1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	57                   	push   %edi
  8010e5:	56                   	push   %esi
  8010e6:	53                   	push   %ebx
  8010e7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010fa:	89 df                	mov    %ebx,%edi
  8010fc:	89 de                	mov    %ebx,%esi
  8010fe:	cd 30                	int    $0x30
	if(check && ret > 0)
  801100:	85 c0                	test   %eax,%eax
  801102:	7f 08                	jg     80110c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801104:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801107:	5b                   	pop    %ebx
  801108:	5e                   	pop    %esi
  801109:	5f                   	pop    %edi
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110c:	83 ec 0c             	sub    $0xc,%esp
  80110f:	50                   	push   %eax
  801110:	6a 0a                	push   $0xa
  801112:	68 3f 2b 80 00       	push   $0x802b3f
  801117:	6a 23                	push   $0x23
  801119:	68 5c 2b 80 00       	push   $0x802b5c
  80111e:	e8 e6 11 00 00       	call   802309 <_panic>

00801123 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
  801126:	57                   	push   %edi
  801127:	56                   	push   %esi
  801128:	53                   	push   %ebx
	asm volatile("int %1\n"
  801129:	8b 55 08             	mov    0x8(%ebp),%edx
  80112c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112f:	b8 0c 00 00 00       	mov    $0xc,%eax
  801134:	be 00 00 00 00       	mov    $0x0,%esi
  801139:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80113c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80113f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801141:	5b                   	pop    %ebx
  801142:	5e                   	pop    %esi
  801143:	5f                   	pop    %edi
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    

00801146 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	57                   	push   %edi
  80114a:	56                   	push   %esi
  80114b:	53                   	push   %ebx
  80114c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80114f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	b8 0d 00 00 00       	mov    $0xd,%eax
  80115c:	89 cb                	mov    %ecx,%ebx
  80115e:	89 cf                	mov    %ecx,%edi
  801160:	89 ce                	mov    %ecx,%esi
  801162:	cd 30                	int    $0x30
	if(check && ret > 0)
  801164:	85 c0                	test   %eax,%eax
  801166:	7f 08                	jg     801170 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801168:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116b:	5b                   	pop    %ebx
  80116c:	5e                   	pop    %esi
  80116d:	5f                   	pop    %edi
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801170:	83 ec 0c             	sub    $0xc,%esp
  801173:	50                   	push   %eax
  801174:	6a 0d                	push   $0xd
  801176:	68 3f 2b 80 00       	push   $0x802b3f
  80117b:	6a 23                	push   $0x23
  80117d:	68 5c 2b 80 00       	push   $0x802b5c
  801182:	e8 82 11 00 00       	call   802309 <_panic>

00801187 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	57                   	push   %edi
  80118b:	56                   	push   %esi
  80118c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80118d:	ba 00 00 00 00       	mov    $0x0,%edx
  801192:	b8 0e 00 00 00       	mov    $0xe,%eax
  801197:	89 d1                	mov    %edx,%ecx
  801199:	89 d3                	mov    %edx,%ebx
  80119b:	89 d7                	mov    %edx,%edi
  80119d:	89 d6                	mov    %edx,%esi
  80119f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5f                   	pop    %edi
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    

008011a6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	05 00 00 00 30       	add    $0x30000000,%eax
  8011b1:	c1 e8 0c             	shr    $0xc,%eax
}
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011c6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011cb:	5d                   	pop    %ebp
  8011cc:	c3                   	ret    

008011cd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011d5:	89 c2                	mov    %eax,%edx
  8011d7:	c1 ea 16             	shr    $0x16,%edx
  8011da:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011e1:	f6 c2 01             	test   $0x1,%dl
  8011e4:	74 2d                	je     801213 <fd_alloc+0x46>
  8011e6:	89 c2                	mov    %eax,%edx
  8011e8:	c1 ea 0c             	shr    $0xc,%edx
  8011eb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f2:	f6 c2 01             	test   $0x1,%dl
  8011f5:	74 1c                	je     801213 <fd_alloc+0x46>
  8011f7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011fc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801201:	75 d2                	jne    8011d5 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80120c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801211:	eb 0a                	jmp    80121d <fd_alloc+0x50>
			*fd_store = fd;
  801213:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801216:	89 01                	mov    %eax,(%ecx)
			return 0;
  801218:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80121d:	5d                   	pop    %ebp
  80121e:	c3                   	ret    

0080121f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801225:	83 f8 1f             	cmp    $0x1f,%eax
  801228:	77 30                	ja     80125a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80122a:	c1 e0 0c             	shl    $0xc,%eax
  80122d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801232:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801238:	f6 c2 01             	test   $0x1,%dl
  80123b:	74 24                	je     801261 <fd_lookup+0x42>
  80123d:	89 c2                	mov    %eax,%edx
  80123f:	c1 ea 0c             	shr    $0xc,%edx
  801242:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801249:	f6 c2 01             	test   $0x1,%dl
  80124c:	74 1a                	je     801268 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80124e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801251:	89 02                	mov    %eax,(%edx)
	return 0;
  801253:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801258:	5d                   	pop    %ebp
  801259:	c3                   	ret    
		return -E_INVAL;
  80125a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80125f:	eb f7                	jmp    801258 <fd_lookup+0x39>
		return -E_INVAL;
  801261:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801266:	eb f0                	jmp    801258 <fd_lookup+0x39>
  801268:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126d:	eb e9                	jmp    801258 <fd_lookup+0x39>

0080126f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	83 ec 08             	sub    $0x8,%esp
  801275:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801278:	ba 00 00 00 00       	mov    $0x0,%edx
  80127d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801282:	39 08                	cmp    %ecx,(%eax)
  801284:	74 38                	je     8012be <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801286:	83 c2 01             	add    $0x1,%edx
  801289:	8b 04 95 e8 2b 80 00 	mov    0x802be8(,%edx,4),%eax
  801290:	85 c0                	test   %eax,%eax
  801292:	75 ee                	jne    801282 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801294:	a1 18 40 80 00       	mov    0x804018,%eax
  801299:	8b 40 48             	mov    0x48(%eax),%eax
  80129c:	83 ec 04             	sub    $0x4,%esp
  80129f:	51                   	push   %ecx
  8012a0:	50                   	push   %eax
  8012a1:	68 6c 2b 80 00       	push   $0x802b6c
  8012a6:	e8 1d f3 ff ff       	call   8005c8 <cprintf>
	*dev = 0;
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012b4:	83 c4 10             	add    $0x10,%esp
  8012b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012bc:	c9                   	leave  
  8012bd:	c3                   	ret    
			*dev = devtab[i];
  8012be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c8:	eb f2                	jmp    8012bc <dev_lookup+0x4d>

008012ca <fd_close>:
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	57                   	push   %edi
  8012ce:	56                   	push   %esi
  8012cf:	53                   	push   %ebx
  8012d0:	83 ec 24             	sub    $0x24,%esp
  8012d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8012d6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012d9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012dc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012dd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012e3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012e6:	50                   	push   %eax
  8012e7:	e8 33 ff ff ff       	call   80121f <fd_lookup>
  8012ec:	89 c3                	mov    %eax,%ebx
  8012ee:	83 c4 10             	add    $0x10,%esp
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	78 05                	js     8012fa <fd_close+0x30>
	    || fd != fd2)
  8012f5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012f8:	74 16                	je     801310 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012fa:	89 f8                	mov    %edi,%eax
  8012fc:	84 c0                	test   %al,%al
  8012fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801303:	0f 44 d8             	cmove  %eax,%ebx
}
  801306:	89 d8                	mov    %ebx,%eax
  801308:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130b:	5b                   	pop    %ebx
  80130c:	5e                   	pop    %esi
  80130d:	5f                   	pop    %edi
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801310:	83 ec 08             	sub    $0x8,%esp
  801313:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801316:	50                   	push   %eax
  801317:	ff 36                	pushl  (%esi)
  801319:	e8 51 ff ff ff       	call   80126f <dev_lookup>
  80131e:	89 c3                	mov    %eax,%ebx
  801320:	83 c4 10             	add    $0x10,%esp
  801323:	85 c0                	test   %eax,%eax
  801325:	78 1a                	js     801341 <fd_close+0x77>
		if (dev->dev_close)
  801327:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80132a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80132d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801332:	85 c0                	test   %eax,%eax
  801334:	74 0b                	je     801341 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	56                   	push   %esi
  80133a:	ff d0                	call   *%eax
  80133c:	89 c3                	mov    %eax,%ebx
  80133e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801341:	83 ec 08             	sub    $0x8,%esp
  801344:	56                   	push   %esi
  801345:	6a 00                	push   $0x0
  801347:	e8 cf fc ff ff       	call   80101b <sys_page_unmap>
	return r;
  80134c:	83 c4 10             	add    $0x10,%esp
  80134f:	eb b5                	jmp    801306 <fd_close+0x3c>

00801351 <close>:

int
close(int fdnum)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801357:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80135a:	50                   	push   %eax
  80135b:	ff 75 08             	pushl  0x8(%ebp)
  80135e:	e8 bc fe ff ff       	call   80121f <fd_lookup>
  801363:	83 c4 10             	add    $0x10,%esp
  801366:	85 c0                	test   %eax,%eax
  801368:	79 02                	jns    80136c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    
		return fd_close(fd, 1);
  80136c:	83 ec 08             	sub    $0x8,%esp
  80136f:	6a 01                	push   $0x1
  801371:	ff 75 f4             	pushl  -0xc(%ebp)
  801374:	e8 51 ff ff ff       	call   8012ca <fd_close>
  801379:	83 c4 10             	add    $0x10,%esp
  80137c:	eb ec                	jmp    80136a <close+0x19>

0080137e <close_all>:

void
close_all(void)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	53                   	push   %ebx
  801382:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801385:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80138a:	83 ec 0c             	sub    $0xc,%esp
  80138d:	53                   	push   %ebx
  80138e:	e8 be ff ff ff       	call   801351 <close>
	for (i = 0; i < MAXFD; i++)
  801393:	83 c3 01             	add    $0x1,%ebx
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	83 fb 20             	cmp    $0x20,%ebx
  80139c:	75 ec                	jne    80138a <close_all+0xc>
}
  80139e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
  8013a6:	57                   	push   %edi
  8013a7:	56                   	push   %esi
  8013a8:	53                   	push   %ebx
  8013a9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013af:	50                   	push   %eax
  8013b0:	ff 75 08             	pushl  0x8(%ebp)
  8013b3:	e8 67 fe ff ff       	call   80121f <fd_lookup>
  8013b8:	89 c3                	mov    %eax,%ebx
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	0f 88 81 00 00 00    	js     801446 <dup+0xa3>
		return r;
	close(newfdnum);
  8013c5:	83 ec 0c             	sub    $0xc,%esp
  8013c8:	ff 75 0c             	pushl  0xc(%ebp)
  8013cb:	e8 81 ff ff ff       	call   801351 <close>

	newfd = INDEX2FD(newfdnum);
  8013d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013d3:	c1 e6 0c             	shl    $0xc,%esi
  8013d6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013dc:	83 c4 04             	add    $0x4,%esp
  8013df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013e2:	e8 cf fd ff ff       	call   8011b6 <fd2data>
  8013e7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013e9:	89 34 24             	mov    %esi,(%esp)
  8013ec:	e8 c5 fd ff ff       	call   8011b6 <fd2data>
  8013f1:	83 c4 10             	add    $0x10,%esp
  8013f4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013f6:	89 d8                	mov    %ebx,%eax
  8013f8:	c1 e8 16             	shr    $0x16,%eax
  8013fb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801402:	a8 01                	test   $0x1,%al
  801404:	74 11                	je     801417 <dup+0x74>
  801406:	89 d8                	mov    %ebx,%eax
  801408:	c1 e8 0c             	shr    $0xc,%eax
  80140b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801412:	f6 c2 01             	test   $0x1,%dl
  801415:	75 39                	jne    801450 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801417:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80141a:	89 d0                	mov    %edx,%eax
  80141c:	c1 e8 0c             	shr    $0xc,%eax
  80141f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801426:	83 ec 0c             	sub    $0xc,%esp
  801429:	25 07 0e 00 00       	and    $0xe07,%eax
  80142e:	50                   	push   %eax
  80142f:	56                   	push   %esi
  801430:	6a 00                	push   $0x0
  801432:	52                   	push   %edx
  801433:	6a 00                	push   $0x0
  801435:	e8 9f fb ff ff       	call   800fd9 <sys_page_map>
  80143a:	89 c3                	mov    %eax,%ebx
  80143c:	83 c4 20             	add    $0x20,%esp
  80143f:	85 c0                	test   %eax,%eax
  801441:	78 31                	js     801474 <dup+0xd1>
		goto err;

	return newfdnum;
  801443:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801446:	89 d8                	mov    %ebx,%eax
  801448:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144b:	5b                   	pop    %ebx
  80144c:	5e                   	pop    %esi
  80144d:	5f                   	pop    %edi
  80144e:	5d                   	pop    %ebp
  80144f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801450:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801457:	83 ec 0c             	sub    $0xc,%esp
  80145a:	25 07 0e 00 00       	and    $0xe07,%eax
  80145f:	50                   	push   %eax
  801460:	57                   	push   %edi
  801461:	6a 00                	push   $0x0
  801463:	53                   	push   %ebx
  801464:	6a 00                	push   $0x0
  801466:	e8 6e fb ff ff       	call   800fd9 <sys_page_map>
  80146b:	89 c3                	mov    %eax,%ebx
  80146d:	83 c4 20             	add    $0x20,%esp
  801470:	85 c0                	test   %eax,%eax
  801472:	79 a3                	jns    801417 <dup+0x74>
	sys_page_unmap(0, newfd);
  801474:	83 ec 08             	sub    $0x8,%esp
  801477:	56                   	push   %esi
  801478:	6a 00                	push   $0x0
  80147a:	e8 9c fb ff ff       	call   80101b <sys_page_unmap>
	sys_page_unmap(0, nva);
  80147f:	83 c4 08             	add    $0x8,%esp
  801482:	57                   	push   %edi
  801483:	6a 00                	push   $0x0
  801485:	e8 91 fb ff ff       	call   80101b <sys_page_unmap>
	return r;
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	eb b7                	jmp    801446 <dup+0xa3>

0080148f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	53                   	push   %ebx
  801493:	83 ec 1c             	sub    $0x1c,%esp
  801496:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801499:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149c:	50                   	push   %eax
  80149d:	53                   	push   %ebx
  80149e:	e8 7c fd ff ff       	call   80121f <fd_lookup>
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	78 3f                	js     8014e9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014aa:	83 ec 08             	sub    $0x8,%esp
  8014ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b0:	50                   	push   %eax
  8014b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b4:	ff 30                	pushl  (%eax)
  8014b6:	e8 b4 fd ff ff       	call   80126f <dev_lookup>
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	78 27                	js     8014e9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014c5:	8b 42 08             	mov    0x8(%edx),%eax
  8014c8:	83 e0 03             	and    $0x3,%eax
  8014cb:	83 f8 01             	cmp    $0x1,%eax
  8014ce:	74 1e                	je     8014ee <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d3:	8b 40 08             	mov    0x8(%eax),%eax
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	74 35                	je     80150f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014da:	83 ec 04             	sub    $0x4,%esp
  8014dd:	ff 75 10             	pushl  0x10(%ebp)
  8014e0:	ff 75 0c             	pushl  0xc(%ebp)
  8014e3:	52                   	push   %edx
  8014e4:	ff d0                	call   *%eax
  8014e6:	83 c4 10             	add    $0x10,%esp
}
  8014e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014ee:	a1 18 40 80 00       	mov    0x804018,%eax
  8014f3:	8b 40 48             	mov    0x48(%eax),%eax
  8014f6:	83 ec 04             	sub    $0x4,%esp
  8014f9:	53                   	push   %ebx
  8014fa:	50                   	push   %eax
  8014fb:	68 ad 2b 80 00       	push   $0x802bad
  801500:	e8 c3 f0 ff ff       	call   8005c8 <cprintf>
		return -E_INVAL;
  801505:	83 c4 10             	add    $0x10,%esp
  801508:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150d:	eb da                	jmp    8014e9 <read+0x5a>
		return -E_NOT_SUPP;
  80150f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801514:	eb d3                	jmp    8014e9 <read+0x5a>

00801516 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	57                   	push   %edi
  80151a:	56                   	push   %esi
  80151b:	53                   	push   %ebx
  80151c:	83 ec 0c             	sub    $0xc,%esp
  80151f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801522:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801525:	bb 00 00 00 00       	mov    $0x0,%ebx
  80152a:	39 f3                	cmp    %esi,%ebx
  80152c:	73 23                	jae    801551 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80152e:	83 ec 04             	sub    $0x4,%esp
  801531:	89 f0                	mov    %esi,%eax
  801533:	29 d8                	sub    %ebx,%eax
  801535:	50                   	push   %eax
  801536:	89 d8                	mov    %ebx,%eax
  801538:	03 45 0c             	add    0xc(%ebp),%eax
  80153b:	50                   	push   %eax
  80153c:	57                   	push   %edi
  80153d:	e8 4d ff ff ff       	call   80148f <read>
		if (m < 0)
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	85 c0                	test   %eax,%eax
  801547:	78 06                	js     80154f <readn+0x39>
			return m;
		if (m == 0)
  801549:	74 06                	je     801551 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80154b:	01 c3                	add    %eax,%ebx
  80154d:	eb db                	jmp    80152a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80154f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801551:	89 d8                	mov    %ebx,%eax
  801553:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801556:	5b                   	pop    %ebx
  801557:	5e                   	pop    %esi
  801558:	5f                   	pop    %edi
  801559:	5d                   	pop    %ebp
  80155a:	c3                   	ret    

0080155b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	53                   	push   %ebx
  80155f:	83 ec 1c             	sub    $0x1c,%esp
  801562:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801565:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801568:	50                   	push   %eax
  801569:	53                   	push   %ebx
  80156a:	e8 b0 fc ff ff       	call   80121f <fd_lookup>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	85 c0                	test   %eax,%eax
  801574:	78 3a                	js     8015b0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801576:	83 ec 08             	sub    $0x8,%esp
  801579:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157c:	50                   	push   %eax
  80157d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801580:	ff 30                	pushl  (%eax)
  801582:	e8 e8 fc ff ff       	call   80126f <dev_lookup>
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	85 c0                	test   %eax,%eax
  80158c:	78 22                	js     8015b0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80158e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801591:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801595:	74 1e                	je     8015b5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801597:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159a:	8b 52 0c             	mov    0xc(%edx),%edx
  80159d:	85 d2                	test   %edx,%edx
  80159f:	74 35                	je     8015d6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015a1:	83 ec 04             	sub    $0x4,%esp
  8015a4:	ff 75 10             	pushl  0x10(%ebp)
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	50                   	push   %eax
  8015ab:	ff d2                	call   *%edx
  8015ad:	83 c4 10             	add    $0x10,%esp
}
  8015b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015b5:	a1 18 40 80 00       	mov    0x804018,%eax
  8015ba:	8b 40 48             	mov    0x48(%eax),%eax
  8015bd:	83 ec 04             	sub    $0x4,%esp
  8015c0:	53                   	push   %ebx
  8015c1:	50                   	push   %eax
  8015c2:	68 c9 2b 80 00       	push   $0x802bc9
  8015c7:	e8 fc ef ff ff       	call   8005c8 <cprintf>
		return -E_INVAL;
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d4:	eb da                	jmp    8015b0 <write+0x55>
		return -E_NOT_SUPP;
  8015d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015db:	eb d3                	jmp    8015b0 <write+0x55>

008015dd <seek>:

int
seek(int fdnum, off_t offset)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e6:	50                   	push   %eax
  8015e7:	ff 75 08             	pushl  0x8(%ebp)
  8015ea:	e8 30 fc ff ff       	call   80121f <fd_lookup>
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	78 0e                	js     801604 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	53                   	push   %ebx
  80160a:	83 ec 1c             	sub    $0x1c,%esp
  80160d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801610:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801613:	50                   	push   %eax
  801614:	53                   	push   %ebx
  801615:	e8 05 fc ff ff       	call   80121f <fd_lookup>
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	85 c0                	test   %eax,%eax
  80161f:	78 37                	js     801658 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801621:	83 ec 08             	sub    $0x8,%esp
  801624:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801627:	50                   	push   %eax
  801628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162b:	ff 30                	pushl  (%eax)
  80162d:	e8 3d fc ff ff       	call   80126f <dev_lookup>
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	85 c0                	test   %eax,%eax
  801637:	78 1f                	js     801658 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801640:	74 1b                	je     80165d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801642:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801645:	8b 52 18             	mov    0x18(%edx),%edx
  801648:	85 d2                	test   %edx,%edx
  80164a:	74 32                	je     80167e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	ff 75 0c             	pushl  0xc(%ebp)
  801652:	50                   	push   %eax
  801653:	ff d2                	call   *%edx
  801655:	83 c4 10             	add    $0x10,%esp
}
  801658:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80165d:	a1 18 40 80 00       	mov    0x804018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801662:	8b 40 48             	mov    0x48(%eax),%eax
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	53                   	push   %ebx
  801669:	50                   	push   %eax
  80166a:	68 8c 2b 80 00       	push   $0x802b8c
  80166f:	e8 54 ef ff ff       	call   8005c8 <cprintf>
		return -E_INVAL;
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167c:	eb da                	jmp    801658 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80167e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801683:	eb d3                	jmp    801658 <ftruncate+0x52>

00801685 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	53                   	push   %ebx
  801689:	83 ec 1c             	sub    $0x1c,%esp
  80168c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80168f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801692:	50                   	push   %eax
  801693:	ff 75 08             	pushl  0x8(%ebp)
  801696:	e8 84 fb ff ff       	call   80121f <fd_lookup>
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	85 c0                	test   %eax,%eax
  8016a0:	78 4b                	js     8016ed <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a2:	83 ec 08             	sub    $0x8,%esp
  8016a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a8:	50                   	push   %eax
  8016a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ac:	ff 30                	pushl  (%eax)
  8016ae:	e8 bc fb ff ff       	call   80126f <dev_lookup>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	78 33                	js     8016ed <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016c1:	74 2f                	je     8016f2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016c3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016c6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016cd:	00 00 00 
	stat->st_isdir = 0;
  8016d0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016d7:	00 00 00 
	stat->st_dev = dev;
  8016da:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	53                   	push   %ebx
  8016e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8016e7:	ff 50 14             	call   *0x14(%eax)
  8016ea:	83 c4 10             	add    $0x10,%esp
}
  8016ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    
		return -E_NOT_SUPP;
  8016f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f7:	eb f4                	jmp    8016ed <fstat+0x68>

008016f9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	56                   	push   %esi
  8016fd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016fe:	83 ec 08             	sub    $0x8,%esp
  801701:	6a 00                	push   $0x0
  801703:	ff 75 08             	pushl  0x8(%ebp)
  801706:	e8 2f 02 00 00       	call   80193a <open>
  80170b:	89 c3                	mov    %eax,%ebx
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	85 c0                	test   %eax,%eax
  801712:	78 1b                	js     80172f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801714:	83 ec 08             	sub    $0x8,%esp
  801717:	ff 75 0c             	pushl  0xc(%ebp)
  80171a:	50                   	push   %eax
  80171b:	e8 65 ff ff ff       	call   801685 <fstat>
  801720:	89 c6                	mov    %eax,%esi
	close(fd);
  801722:	89 1c 24             	mov    %ebx,(%esp)
  801725:	e8 27 fc ff ff       	call   801351 <close>
	return r;
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	89 f3                	mov    %esi,%ebx
}
  80172f:	89 d8                	mov    %ebx,%eax
  801731:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801734:	5b                   	pop    %ebx
  801735:	5e                   	pop    %esi
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	89 c6                	mov    %eax,%esi
  80173f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801741:	83 3d 10 40 80 00 00 	cmpl   $0x0,0x804010
  801748:	74 27                	je     801771 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80174a:	6a 07                	push   $0x7
  80174c:	68 00 50 80 00       	push   $0x805000
  801751:	56                   	push   %esi
  801752:	ff 35 10 40 80 00    	pushl  0x804010
  801758:	e8 65 0c 00 00       	call   8023c2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80175d:	83 c4 0c             	add    $0xc,%esp
  801760:	6a 00                	push   $0x0
  801762:	53                   	push   %ebx
  801763:	6a 00                	push   $0x0
  801765:	e8 e5 0b 00 00       	call   80234f <ipc_recv>
}
  80176a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176d:	5b                   	pop    %ebx
  80176e:	5e                   	pop    %esi
  80176f:	5d                   	pop    %ebp
  801770:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801771:	83 ec 0c             	sub    $0xc,%esp
  801774:	6a 01                	push   $0x1
  801776:	e8 b3 0c 00 00       	call   80242e <ipc_find_env>
  80177b:	a3 10 40 80 00       	mov    %eax,0x804010
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	eb c5                	jmp    80174a <fsipc+0x12>

00801785 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	8b 40 0c             	mov    0xc(%eax),%eax
  801791:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801796:	8b 45 0c             	mov    0xc(%ebp),%eax
  801799:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80179e:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a3:	b8 02 00 00 00       	mov    $0x2,%eax
  8017a8:	e8 8b ff ff ff       	call   801738 <fsipc>
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <devfile_flush>:
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bb:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c5:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ca:	e8 69 ff ff ff       	call   801738 <fsipc>
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <devfile_stat>:
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	53                   	push   %ebx
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017eb:	b8 05 00 00 00       	mov    $0x5,%eax
  8017f0:	e8 43 ff ff ff       	call   801738 <fsipc>
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 2c                	js     801825 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017f9:	83 ec 08             	sub    $0x8,%esp
  8017fc:	68 00 50 80 00       	push   $0x805000
  801801:	53                   	push   %ebx
  801802:	e8 9d f3 ff ff       	call   800ba4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801807:	a1 80 50 80 00       	mov    0x805080,%eax
  80180c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801812:	a1 84 50 80 00       	mov    0x805084,%eax
  801817:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <devfile_write>:
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	53                   	push   %ebx
  80182e:	83 ec 04             	sub    $0x4,%esp
  801831:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801834:	85 db                	test   %ebx,%ebx
  801836:	75 07                	jne    80183f <devfile_write+0x15>
	return n_all;
  801838:	89 d8                	mov    %ebx,%eax
}
  80183a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	8b 40 0c             	mov    0xc(%eax),%eax
  801845:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  80184a:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801850:	83 ec 04             	sub    $0x4,%esp
  801853:	53                   	push   %ebx
  801854:	ff 75 0c             	pushl  0xc(%ebp)
  801857:	68 08 50 80 00       	push   $0x805008
  80185c:	e8 d1 f4 ff ff       	call   800d32 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801861:	ba 00 00 00 00       	mov    $0x0,%edx
  801866:	b8 04 00 00 00       	mov    $0x4,%eax
  80186b:	e8 c8 fe ff ff       	call   801738 <fsipc>
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	85 c0                	test   %eax,%eax
  801875:	78 c3                	js     80183a <devfile_write+0x10>
	  assert(r <= n_left);
  801877:	39 d8                	cmp    %ebx,%eax
  801879:	77 0b                	ja     801886 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  80187b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801880:	7f 1d                	jg     80189f <devfile_write+0x75>
    n_all += r;
  801882:	89 c3                	mov    %eax,%ebx
  801884:	eb b2                	jmp    801838 <devfile_write+0xe>
	  assert(r <= n_left);
  801886:	68 fc 2b 80 00       	push   $0x802bfc
  80188b:	68 08 2c 80 00       	push   $0x802c08
  801890:	68 9f 00 00 00       	push   $0x9f
  801895:	68 1d 2c 80 00       	push   $0x802c1d
  80189a:	e8 6a 0a 00 00       	call   802309 <_panic>
	  assert(r <= PGSIZE);
  80189f:	68 28 2c 80 00       	push   $0x802c28
  8018a4:	68 08 2c 80 00       	push   $0x802c08
  8018a9:	68 a0 00 00 00       	push   $0xa0
  8018ae:	68 1d 2c 80 00       	push   $0x802c1d
  8018b3:	e8 51 0a 00 00       	call   802309 <_panic>

008018b8 <devfile_read>:
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	56                   	push   %esi
  8018bc:	53                   	push   %ebx
  8018bd:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018cb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d6:	b8 03 00 00 00       	mov    $0x3,%eax
  8018db:	e8 58 fe ff ff       	call   801738 <fsipc>
  8018e0:	89 c3                	mov    %eax,%ebx
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	78 1f                	js     801905 <devfile_read+0x4d>
	assert(r <= n);
  8018e6:	39 f0                	cmp    %esi,%eax
  8018e8:	77 24                	ja     80190e <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018ea:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ef:	7f 33                	jg     801924 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	50                   	push   %eax
  8018f5:	68 00 50 80 00       	push   $0x805000
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	e8 30 f4 ff ff       	call   800d32 <memmove>
	return r;
  801902:	83 c4 10             	add    $0x10,%esp
}
  801905:	89 d8                	mov    %ebx,%eax
  801907:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80190a:	5b                   	pop    %ebx
  80190b:	5e                   	pop    %esi
  80190c:	5d                   	pop    %ebp
  80190d:	c3                   	ret    
	assert(r <= n);
  80190e:	68 34 2c 80 00       	push   $0x802c34
  801913:	68 08 2c 80 00       	push   $0x802c08
  801918:	6a 7c                	push   $0x7c
  80191a:	68 1d 2c 80 00       	push   $0x802c1d
  80191f:	e8 e5 09 00 00       	call   802309 <_panic>
	assert(r <= PGSIZE);
  801924:	68 28 2c 80 00       	push   $0x802c28
  801929:	68 08 2c 80 00       	push   $0x802c08
  80192e:	6a 7d                	push   $0x7d
  801930:	68 1d 2c 80 00       	push   $0x802c1d
  801935:	e8 cf 09 00 00       	call   802309 <_panic>

0080193a <open>:
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	56                   	push   %esi
  80193e:	53                   	push   %ebx
  80193f:	83 ec 1c             	sub    $0x1c,%esp
  801942:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801945:	56                   	push   %esi
  801946:	e8 20 f2 ff ff       	call   800b6b <strlen>
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801953:	7f 6c                	jg     8019c1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801955:	83 ec 0c             	sub    $0xc,%esp
  801958:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195b:	50                   	push   %eax
  80195c:	e8 6c f8 ff ff       	call   8011cd <fd_alloc>
  801961:	89 c3                	mov    %eax,%ebx
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	85 c0                	test   %eax,%eax
  801968:	78 3c                	js     8019a6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	56                   	push   %esi
  80196e:	68 00 50 80 00       	push   $0x805000
  801973:	e8 2c f2 ff ff       	call   800ba4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801980:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801983:	b8 01 00 00 00       	mov    $0x1,%eax
  801988:	e8 ab fd ff ff       	call   801738 <fsipc>
  80198d:	89 c3                	mov    %eax,%ebx
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	85 c0                	test   %eax,%eax
  801994:	78 19                	js     8019af <open+0x75>
	return fd2num(fd);
  801996:	83 ec 0c             	sub    $0xc,%esp
  801999:	ff 75 f4             	pushl  -0xc(%ebp)
  80199c:	e8 05 f8 ff ff       	call   8011a6 <fd2num>
  8019a1:	89 c3                	mov    %eax,%ebx
  8019a3:	83 c4 10             	add    $0x10,%esp
}
  8019a6:	89 d8                	mov    %ebx,%eax
  8019a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5d                   	pop    %ebp
  8019ae:	c3                   	ret    
		fd_close(fd, 0);
  8019af:	83 ec 08             	sub    $0x8,%esp
  8019b2:	6a 00                	push   $0x0
  8019b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b7:	e8 0e f9 ff ff       	call   8012ca <fd_close>
		return r;
  8019bc:	83 c4 10             	add    $0x10,%esp
  8019bf:	eb e5                	jmp    8019a6 <open+0x6c>
		return -E_BAD_PATH;
  8019c1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019c6:	eb de                	jmp    8019a6 <open+0x6c>

008019c8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8019d8:	e8 5b fd ff ff       	call   801738 <fsipc>
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	56                   	push   %esi
  8019e3:	53                   	push   %ebx
  8019e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019e7:	83 ec 0c             	sub    $0xc,%esp
  8019ea:	ff 75 08             	pushl  0x8(%ebp)
  8019ed:	e8 c4 f7 ff ff       	call   8011b6 <fd2data>
  8019f2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019f4:	83 c4 08             	add    $0x8,%esp
  8019f7:	68 3b 2c 80 00       	push   $0x802c3b
  8019fc:	53                   	push   %ebx
  8019fd:	e8 a2 f1 ff ff       	call   800ba4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a02:	8b 46 04             	mov    0x4(%esi),%eax
  801a05:	2b 06                	sub    (%esi),%eax
  801a07:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a0d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a14:	00 00 00 
	stat->st_dev = &devpipe;
  801a17:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a1e:	30 80 00 
	return 0;
}
  801a21:	b8 00 00 00 00       	mov    $0x0,%eax
  801a26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a29:	5b                   	pop    %ebx
  801a2a:	5e                   	pop    %esi
  801a2b:	5d                   	pop    %ebp
  801a2c:	c3                   	ret    

00801a2d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	53                   	push   %ebx
  801a31:	83 ec 0c             	sub    $0xc,%esp
  801a34:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a37:	53                   	push   %ebx
  801a38:	6a 00                	push   $0x0
  801a3a:	e8 dc f5 ff ff       	call   80101b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a3f:	89 1c 24             	mov    %ebx,(%esp)
  801a42:	e8 6f f7 ff ff       	call   8011b6 <fd2data>
  801a47:	83 c4 08             	add    $0x8,%esp
  801a4a:	50                   	push   %eax
  801a4b:	6a 00                	push   $0x0
  801a4d:	e8 c9 f5 ff ff       	call   80101b <sys_page_unmap>
}
  801a52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <_pipeisclosed>:
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	57                   	push   %edi
  801a5b:	56                   	push   %esi
  801a5c:	53                   	push   %ebx
  801a5d:	83 ec 1c             	sub    $0x1c,%esp
  801a60:	89 c7                	mov    %eax,%edi
  801a62:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a64:	a1 18 40 80 00       	mov    0x804018,%eax
  801a69:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a6c:	83 ec 0c             	sub    $0xc,%esp
  801a6f:	57                   	push   %edi
  801a70:	e8 f2 09 00 00       	call   802467 <pageref>
  801a75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a78:	89 34 24             	mov    %esi,(%esp)
  801a7b:	e8 e7 09 00 00       	call   802467 <pageref>
		nn = thisenv->env_runs;
  801a80:	8b 15 18 40 80 00    	mov    0x804018,%edx
  801a86:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	39 cb                	cmp    %ecx,%ebx
  801a8e:	74 1b                	je     801aab <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a90:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a93:	75 cf                	jne    801a64 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a95:	8b 42 58             	mov    0x58(%edx),%eax
  801a98:	6a 01                	push   $0x1
  801a9a:	50                   	push   %eax
  801a9b:	53                   	push   %ebx
  801a9c:	68 42 2c 80 00       	push   $0x802c42
  801aa1:	e8 22 eb ff ff       	call   8005c8 <cprintf>
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	eb b9                	jmp    801a64 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801aab:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801aae:	0f 94 c0             	sete   %al
  801ab1:	0f b6 c0             	movzbl %al,%eax
}
  801ab4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5f                   	pop    %edi
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    

00801abc <devpipe_write>:
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	57                   	push   %edi
  801ac0:	56                   	push   %esi
  801ac1:	53                   	push   %ebx
  801ac2:	83 ec 28             	sub    $0x28,%esp
  801ac5:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ac8:	56                   	push   %esi
  801ac9:	e8 e8 f6 ff ff       	call   8011b6 <fd2data>
  801ace:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ad0:	83 c4 10             	add    $0x10,%esp
  801ad3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ad8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801adb:	74 4f                	je     801b2c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801add:	8b 43 04             	mov    0x4(%ebx),%eax
  801ae0:	8b 0b                	mov    (%ebx),%ecx
  801ae2:	8d 51 20             	lea    0x20(%ecx),%edx
  801ae5:	39 d0                	cmp    %edx,%eax
  801ae7:	72 14                	jb     801afd <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ae9:	89 da                	mov    %ebx,%edx
  801aeb:	89 f0                	mov    %esi,%eax
  801aed:	e8 65 ff ff ff       	call   801a57 <_pipeisclosed>
  801af2:	85 c0                	test   %eax,%eax
  801af4:	75 3b                	jne    801b31 <devpipe_write+0x75>
			sys_yield();
  801af6:	e8 7c f4 ff ff       	call   800f77 <sys_yield>
  801afb:	eb e0                	jmp    801add <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801afd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b00:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b04:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b07:	89 c2                	mov    %eax,%edx
  801b09:	c1 fa 1f             	sar    $0x1f,%edx
  801b0c:	89 d1                	mov    %edx,%ecx
  801b0e:	c1 e9 1b             	shr    $0x1b,%ecx
  801b11:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b14:	83 e2 1f             	and    $0x1f,%edx
  801b17:	29 ca                	sub    %ecx,%edx
  801b19:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b1d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b21:	83 c0 01             	add    $0x1,%eax
  801b24:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b27:	83 c7 01             	add    $0x1,%edi
  801b2a:	eb ac                	jmp    801ad8 <devpipe_write+0x1c>
	return i;
  801b2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2f:	eb 05                	jmp    801b36 <devpipe_write+0x7a>
				return 0;
  801b31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b39:	5b                   	pop    %ebx
  801b3a:	5e                   	pop    %esi
  801b3b:	5f                   	pop    %edi
  801b3c:	5d                   	pop    %ebp
  801b3d:	c3                   	ret    

00801b3e <devpipe_read>:
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	57                   	push   %edi
  801b42:	56                   	push   %esi
  801b43:	53                   	push   %ebx
  801b44:	83 ec 18             	sub    $0x18,%esp
  801b47:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b4a:	57                   	push   %edi
  801b4b:	e8 66 f6 ff ff       	call   8011b6 <fd2data>
  801b50:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b52:	83 c4 10             	add    $0x10,%esp
  801b55:	be 00 00 00 00       	mov    $0x0,%esi
  801b5a:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b5d:	75 14                	jne    801b73 <devpipe_read+0x35>
	return i;
  801b5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b62:	eb 02                	jmp    801b66 <devpipe_read+0x28>
				return i;
  801b64:	89 f0                	mov    %esi,%eax
}
  801b66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b69:	5b                   	pop    %ebx
  801b6a:	5e                   	pop    %esi
  801b6b:	5f                   	pop    %edi
  801b6c:	5d                   	pop    %ebp
  801b6d:	c3                   	ret    
			sys_yield();
  801b6e:	e8 04 f4 ff ff       	call   800f77 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b73:	8b 03                	mov    (%ebx),%eax
  801b75:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b78:	75 18                	jne    801b92 <devpipe_read+0x54>
			if (i > 0)
  801b7a:	85 f6                	test   %esi,%esi
  801b7c:	75 e6                	jne    801b64 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801b7e:	89 da                	mov    %ebx,%edx
  801b80:	89 f8                	mov    %edi,%eax
  801b82:	e8 d0 fe ff ff       	call   801a57 <_pipeisclosed>
  801b87:	85 c0                	test   %eax,%eax
  801b89:	74 e3                	je     801b6e <devpipe_read+0x30>
				return 0;
  801b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b90:	eb d4                	jmp    801b66 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b92:	99                   	cltd   
  801b93:	c1 ea 1b             	shr    $0x1b,%edx
  801b96:	01 d0                	add    %edx,%eax
  801b98:	83 e0 1f             	and    $0x1f,%eax
  801b9b:	29 d0                	sub    %edx,%eax
  801b9d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ba2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ba5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ba8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801bab:	83 c6 01             	add    $0x1,%esi
  801bae:	eb aa                	jmp    801b5a <devpipe_read+0x1c>

00801bb0 <pipe>:
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	56                   	push   %esi
  801bb4:	53                   	push   %ebx
  801bb5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bbb:	50                   	push   %eax
  801bbc:	e8 0c f6 ff ff       	call   8011cd <fd_alloc>
  801bc1:	89 c3                	mov    %eax,%ebx
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	0f 88 23 01 00 00    	js     801cf1 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bce:	83 ec 04             	sub    $0x4,%esp
  801bd1:	68 07 04 00 00       	push   $0x407
  801bd6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd9:	6a 00                	push   $0x0
  801bdb:	e8 b6 f3 ff ff       	call   800f96 <sys_page_alloc>
  801be0:	89 c3                	mov    %eax,%ebx
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	85 c0                	test   %eax,%eax
  801be7:	0f 88 04 01 00 00    	js     801cf1 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801bed:	83 ec 0c             	sub    $0xc,%esp
  801bf0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bf3:	50                   	push   %eax
  801bf4:	e8 d4 f5 ff ff       	call   8011cd <fd_alloc>
  801bf9:	89 c3                	mov    %eax,%ebx
  801bfb:	83 c4 10             	add    $0x10,%esp
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	0f 88 db 00 00 00    	js     801ce1 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c06:	83 ec 04             	sub    $0x4,%esp
  801c09:	68 07 04 00 00       	push   $0x407
  801c0e:	ff 75 f0             	pushl  -0x10(%ebp)
  801c11:	6a 00                	push   $0x0
  801c13:	e8 7e f3 ff ff       	call   800f96 <sys_page_alloc>
  801c18:	89 c3                	mov    %eax,%ebx
  801c1a:	83 c4 10             	add    $0x10,%esp
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	0f 88 bc 00 00 00    	js     801ce1 <pipe+0x131>
	va = fd2data(fd0);
  801c25:	83 ec 0c             	sub    $0xc,%esp
  801c28:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2b:	e8 86 f5 ff ff       	call   8011b6 <fd2data>
  801c30:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c32:	83 c4 0c             	add    $0xc,%esp
  801c35:	68 07 04 00 00       	push   $0x407
  801c3a:	50                   	push   %eax
  801c3b:	6a 00                	push   $0x0
  801c3d:	e8 54 f3 ff ff       	call   800f96 <sys_page_alloc>
  801c42:	89 c3                	mov    %eax,%ebx
  801c44:	83 c4 10             	add    $0x10,%esp
  801c47:	85 c0                	test   %eax,%eax
  801c49:	0f 88 82 00 00 00    	js     801cd1 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c4f:	83 ec 0c             	sub    $0xc,%esp
  801c52:	ff 75 f0             	pushl  -0x10(%ebp)
  801c55:	e8 5c f5 ff ff       	call   8011b6 <fd2data>
  801c5a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c61:	50                   	push   %eax
  801c62:	6a 00                	push   $0x0
  801c64:	56                   	push   %esi
  801c65:	6a 00                	push   $0x0
  801c67:	e8 6d f3 ff ff       	call   800fd9 <sys_page_map>
  801c6c:	89 c3                	mov    %eax,%ebx
  801c6e:	83 c4 20             	add    $0x20,%esp
  801c71:	85 c0                	test   %eax,%eax
  801c73:	78 4e                	js     801cc3 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801c75:	a1 20 30 80 00       	mov    0x803020,%eax
  801c7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c7d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c82:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c8c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c91:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c98:	83 ec 0c             	sub    $0xc,%esp
  801c9b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9e:	e8 03 f5 ff ff       	call   8011a6 <fd2num>
  801ca3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ca8:	83 c4 04             	add    $0x4,%esp
  801cab:	ff 75 f0             	pushl  -0x10(%ebp)
  801cae:	e8 f3 f4 ff ff       	call   8011a6 <fd2num>
  801cb3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cb9:	83 c4 10             	add    $0x10,%esp
  801cbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cc1:	eb 2e                	jmp    801cf1 <pipe+0x141>
	sys_page_unmap(0, va);
  801cc3:	83 ec 08             	sub    $0x8,%esp
  801cc6:	56                   	push   %esi
  801cc7:	6a 00                	push   $0x0
  801cc9:	e8 4d f3 ff ff       	call   80101b <sys_page_unmap>
  801cce:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801cd1:	83 ec 08             	sub    $0x8,%esp
  801cd4:	ff 75 f0             	pushl  -0x10(%ebp)
  801cd7:	6a 00                	push   $0x0
  801cd9:	e8 3d f3 ff ff       	call   80101b <sys_page_unmap>
  801cde:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ce1:	83 ec 08             	sub    $0x8,%esp
  801ce4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce7:	6a 00                	push   $0x0
  801ce9:	e8 2d f3 ff ff       	call   80101b <sys_page_unmap>
  801cee:	83 c4 10             	add    $0x10,%esp
}
  801cf1:	89 d8                	mov    %ebx,%eax
  801cf3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf6:	5b                   	pop    %ebx
  801cf7:	5e                   	pop    %esi
  801cf8:	5d                   	pop    %ebp
  801cf9:	c3                   	ret    

00801cfa <pipeisclosed>:
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d00:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d03:	50                   	push   %eax
  801d04:	ff 75 08             	pushl  0x8(%ebp)
  801d07:	e8 13 f5 ff ff       	call   80121f <fd_lookup>
  801d0c:	83 c4 10             	add    $0x10,%esp
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	78 18                	js     801d2b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d13:	83 ec 0c             	sub    $0xc,%esp
  801d16:	ff 75 f4             	pushl  -0xc(%ebp)
  801d19:	e8 98 f4 ff ff       	call   8011b6 <fd2data>
	return _pipeisclosed(fd, p);
  801d1e:	89 c2                	mov    %eax,%edx
  801d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d23:	e8 2f fd ff ff       	call   801a57 <_pipeisclosed>
  801d28:	83 c4 10             	add    $0x10,%esp
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d33:	68 5a 2c 80 00       	push   $0x802c5a
  801d38:	ff 75 0c             	pushl  0xc(%ebp)
  801d3b:	e8 64 ee ff ff       	call   800ba4 <strcpy>
	return 0;
}
  801d40:	b8 00 00 00 00       	mov    $0x0,%eax
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <devsock_close>:
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	53                   	push   %ebx
  801d4b:	83 ec 10             	sub    $0x10,%esp
  801d4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d51:	53                   	push   %ebx
  801d52:	e8 10 07 00 00       	call   802467 <pageref>
  801d57:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d5a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d5f:	83 f8 01             	cmp    $0x1,%eax
  801d62:	74 07                	je     801d6b <devsock_close+0x24>
}
  801d64:	89 d0                	mov    %edx,%eax
  801d66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d6b:	83 ec 0c             	sub    $0xc,%esp
  801d6e:	ff 73 0c             	pushl  0xc(%ebx)
  801d71:	e8 b9 02 00 00       	call   80202f <nsipc_close>
  801d76:	89 c2                	mov    %eax,%edx
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	eb e7                	jmp    801d64 <devsock_close+0x1d>

00801d7d <devsock_write>:
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d83:	6a 00                	push   $0x0
  801d85:	ff 75 10             	pushl  0x10(%ebp)
  801d88:	ff 75 0c             	pushl  0xc(%ebp)
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	ff 70 0c             	pushl  0xc(%eax)
  801d91:	e8 76 03 00 00       	call   80210c <nsipc_send>
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <devsock_read>:
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	ff 75 10             	pushl  0x10(%ebp)
  801da3:	ff 75 0c             	pushl  0xc(%ebp)
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	ff 70 0c             	pushl  0xc(%eax)
  801dac:	e8 ef 02 00 00       	call   8020a0 <nsipc_recv>
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <fd2sockid>:
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801db9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dbc:	52                   	push   %edx
  801dbd:	50                   	push   %eax
  801dbe:	e8 5c f4 ff ff       	call   80121f <fd_lookup>
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	78 10                	js     801dda <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcd:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801dd3:	39 08                	cmp    %ecx,(%eax)
  801dd5:	75 05                	jne    801ddc <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801dd7:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    
		return -E_NOT_SUPP;
  801ddc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801de1:	eb f7                	jmp    801dda <fd2sockid+0x27>

00801de3 <alloc_sockfd>:
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	56                   	push   %esi
  801de7:	53                   	push   %ebx
  801de8:	83 ec 1c             	sub    $0x1c,%esp
  801deb:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ded:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df0:	50                   	push   %eax
  801df1:	e8 d7 f3 ff ff       	call   8011cd <fd_alloc>
  801df6:	89 c3                	mov    %eax,%ebx
  801df8:	83 c4 10             	add    $0x10,%esp
  801dfb:	85 c0                	test   %eax,%eax
  801dfd:	78 43                	js     801e42 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801dff:	83 ec 04             	sub    $0x4,%esp
  801e02:	68 07 04 00 00       	push   $0x407
  801e07:	ff 75 f4             	pushl  -0xc(%ebp)
  801e0a:	6a 00                	push   $0x0
  801e0c:	e8 85 f1 ff ff       	call   800f96 <sys_page_alloc>
  801e11:	89 c3                	mov    %eax,%ebx
  801e13:	83 c4 10             	add    $0x10,%esp
  801e16:	85 c0                	test   %eax,%eax
  801e18:	78 28                	js     801e42 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e23:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e28:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e2f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e32:	83 ec 0c             	sub    $0xc,%esp
  801e35:	50                   	push   %eax
  801e36:	e8 6b f3 ff ff       	call   8011a6 <fd2num>
  801e3b:	89 c3                	mov    %eax,%ebx
  801e3d:	83 c4 10             	add    $0x10,%esp
  801e40:	eb 0c                	jmp    801e4e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e42:	83 ec 0c             	sub    $0xc,%esp
  801e45:	56                   	push   %esi
  801e46:	e8 e4 01 00 00       	call   80202f <nsipc_close>
		return r;
  801e4b:	83 c4 10             	add    $0x10,%esp
}
  801e4e:	89 d8                	mov    %ebx,%eax
  801e50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5d                   	pop    %ebp
  801e56:	c3                   	ret    

00801e57 <accept>:
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	e8 4e ff ff ff       	call   801db3 <fd2sockid>
  801e65:	85 c0                	test   %eax,%eax
  801e67:	78 1b                	js     801e84 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	ff 75 10             	pushl  0x10(%ebp)
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	50                   	push   %eax
  801e73:	e8 0e 01 00 00       	call   801f86 <nsipc_accept>
  801e78:	83 c4 10             	add    $0x10,%esp
  801e7b:	85 c0                	test   %eax,%eax
  801e7d:	78 05                	js     801e84 <accept+0x2d>
	return alloc_sockfd(r);
  801e7f:	e8 5f ff ff ff       	call   801de3 <alloc_sockfd>
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <bind>:
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8f:	e8 1f ff ff ff       	call   801db3 <fd2sockid>
  801e94:	85 c0                	test   %eax,%eax
  801e96:	78 12                	js     801eaa <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e98:	83 ec 04             	sub    $0x4,%esp
  801e9b:	ff 75 10             	pushl  0x10(%ebp)
  801e9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ea1:	50                   	push   %eax
  801ea2:	e8 31 01 00 00       	call   801fd8 <nsipc_bind>
  801ea7:	83 c4 10             	add    $0x10,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <shutdown>:
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	e8 f9 fe ff ff       	call   801db3 <fd2sockid>
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	78 0f                	js     801ecd <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ebe:	83 ec 08             	sub    $0x8,%esp
  801ec1:	ff 75 0c             	pushl  0xc(%ebp)
  801ec4:	50                   	push   %eax
  801ec5:	e8 43 01 00 00       	call   80200d <nsipc_shutdown>
  801eca:	83 c4 10             	add    $0x10,%esp
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <connect>:
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	e8 d6 fe ff ff       	call   801db3 <fd2sockid>
  801edd:	85 c0                	test   %eax,%eax
  801edf:	78 12                	js     801ef3 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ee1:	83 ec 04             	sub    $0x4,%esp
  801ee4:	ff 75 10             	pushl  0x10(%ebp)
  801ee7:	ff 75 0c             	pushl  0xc(%ebp)
  801eea:	50                   	push   %eax
  801eeb:	e8 59 01 00 00       	call   802049 <nsipc_connect>
  801ef0:	83 c4 10             	add    $0x10,%esp
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <listen>:
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	e8 b0 fe ff ff       	call   801db3 <fd2sockid>
  801f03:	85 c0                	test   %eax,%eax
  801f05:	78 0f                	js     801f16 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f07:	83 ec 08             	sub    $0x8,%esp
  801f0a:	ff 75 0c             	pushl  0xc(%ebp)
  801f0d:	50                   	push   %eax
  801f0e:	e8 6b 01 00 00       	call   80207e <nsipc_listen>
  801f13:	83 c4 10             	add    $0x10,%esp
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <socket>:

int
socket(int domain, int type, int protocol)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f1e:	ff 75 10             	pushl  0x10(%ebp)
  801f21:	ff 75 0c             	pushl  0xc(%ebp)
  801f24:	ff 75 08             	pushl  0x8(%ebp)
  801f27:	e8 3e 02 00 00       	call   80216a <nsipc_socket>
  801f2c:	83 c4 10             	add    $0x10,%esp
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	78 05                	js     801f38 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f33:	e8 ab fe ff ff       	call   801de3 <alloc_sockfd>
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	53                   	push   %ebx
  801f3e:	83 ec 04             	sub    $0x4,%esp
  801f41:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f43:	83 3d 14 40 80 00 00 	cmpl   $0x0,0x804014
  801f4a:	74 26                	je     801f72 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f4c:	6a 07                	push   $0x7
  801f4e:	68 00 60 80 00       	push   $0x806000
  801f53:	53                   	push   %ebx
  801f54:	ff 35 14 40 80 00    	pushl  0x804014
  801f5a:	e8 63 04 00 00       	call   8023c2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f5f:	83 c4 0c             	add    $0xc,%esp
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	e8 e2 03 00 00       	call   80234f <ipc_recv>
}
  801f6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f72:	83 ec 0c             	sub    $0xc,%esp
  801f75:	6a 02                	push   $0x2
  801f77:	e8 b2 04 00 00       	call   80242e <ipc_find_env>
  801f7c:	a3 14 40 80 00       	mov    %eax,0x804014
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	eb c6                	jmp    801f4c <nsipc+0x12>

00801f86 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	56                   	push   %esi
  801f8a:	53                   	push   %ebx
  801f8b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f96:	8b 06                	mov    (%esi),%eax
  801f98:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa2:	e8 93 ff ff ff       	call   801f3a <nsipc>
  801fa7:	89 c3                	mov    %eax,%ebx
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	79 09                	jns    801fb6 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801fad:	89 d8                	mov    %ebx,%eax
  801faf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb2:	5b                   	pop    %ebx
  801fb3:	5e                   	pop    %esi
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fb6:	83 ec 04             	sub    $0x4,%esp
  801fb9:	ff 35 10 60 80 00    	pushl  0x806010
  801fbf:	68 00 60 80 00       	push   $0x806000
  801fc4:	ff 75 0c             	pushl  0xc(%ebp)
  801fc7:	e8 66 ed ff ff       	call   800d32 <memmove>
		*addrlen = ret->ret_addrlen;
  801fcc:	a1 10 60 80 00       	mov    0x806010,%eax
  801fd1:	89 06                	mov    %eax,(%esi)
  801fd3:	83 c4 10             	add    $0x10,%esp
	return r;
  801fd6:	eb d5                	jmp    801fad <nsipc_accept+0x27>

00801fd8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	53                   	push   %ebx
  801fdc:	83 ec 08             	sub    $0x8,%esp
  801fdf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fea:	53                   	push   %ebx
  801feb:	ff 75 0c             	pushl  0xc(%ebp)
  801fee:	68 04 60 80 00       	push   $0x806004
  801ff3:	e8 3a ed ff ff       	call   800d32 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ff8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ffe:	b8 02 00 00 00       	mov    $0x2,%eax
  802003:	e8 32 ff ff ff       	call   801f3a <nsipc>
}
  802008:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80201b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802023:	b8 03 00 00 00       	mov    $0x3,%eax
  802028:	e8 0d ff ff ff       	call   801f3a <nsipc>
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <nsipc_close>:

int
nsipc_close(int s)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80203d:	b8 04 00 00 00       	mov    $0x4,%eax
  802042:	e8 f3 fe ff ff       	call   801f3a <nsipc>
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	53                   	push   %ebx
  80204d:	83 ec 08             	sub    $0x8,%esp
  802050:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80205b:	53                   	push   %ebx
  80205c:	ff 75 0c             	pushl  0xc(%ebp)
  80205f:	68 04 60 80 00       	push   $0x806004
  802064:	e8 c9 ec ff ff       	call   800d32 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802069:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80206f:	b8 05 00 00 00       	mov    $0x5,%eax
  802074:	e8 c1 fe ff ff       	call   801f3a <nsipc>
}
  802079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80208c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802094:	b8 06 00 00 00       	mov    $0x6,%eax
  802099:	e8 9c fe ff ff       	call   801f3a <nsipc>
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	56                   	push   %esi
  8020a4:	53                   	push   %ebx
  8020a5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8020b0:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8020b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b9:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020be:	b8 07 00 00 00       	mov    $0x7,%eax
  8020c3:	e8 72 fe ff ff       	call   801f3a <nsipc>
  8020c8:	89 c3                	mov    %eax,%ebx
  8020ca:	85 c0                	test   %eax,%eax
  8020cc:	78 1f                	js     8020ed <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8020ce:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020d3:	7f 21                	jg     8020f6 <nsipc_recv+0x56>
  8020d5:	39 c6                	cmp    %eax,%esi
  8020d7:	7c 1d                	jl     8020f6 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020d9:	83 ec 04             	sub    $0x4,%esp
  8020dc:	50                   	push   %eax
  8020dd:	68 00 60 80 00       	push   $0x806000
  8020e2:	ff 75 0c             	pushl  0xc(%ebp)
  8020e5:	e8 48 ec ff ff       	call   800d32 <memmove>
  8020ea:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020ed:	89 d8                	mov    %ebx,%eax
  8020ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f2:	5b                   	pop    %ebx
  8020f3:	5e                   	pop    %esi
  8020f4:	5d                   	pop    %ebp
  8020f5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020f6:	68 66 2c 80 00       	push   $0x802c66
  8020fb:	68 08 2c 80 00       	push   $0x802c08
  802100:	6a 62                	push   $0x62
  802102:	68 7b 2c 80 00       	push   $0x802c7b
  802107:	e8 fd 01 00 00       	call   802309 <_panic>

0080210c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	53                   	push   %ebx
  802110:	83 ec 04             	sub    $0x4,%esp
  802113:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80211e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802124:	7f 2e                	jg     802154 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802126:	83 ec 04             	sub    $0x4,%esp
  802129:	53                   	push   %ebx
  80212a:	ff 75 0c             	pushl  0xc(%ebp)
  80212d:	68 0c 60 80 00       	push   $0x80600c
  802132:	e8 fb eb ff ff       	call   800d32 <memmove>
	nsipcbuf.send.req_size = size;
  802137:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80213d:	8b 45 14             	mov    0x14(%ebp),%eax
  802140:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802145:	b8 08 00 00 00       	mov    $0x8,%eax
  80214a:	e8 eb fd ff ff       	call   801f3a <nsipc>
}
  80214f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802152:	c9                   	leave  
  802153:	c3                   	ret    
	assert(size < 1600);
  802154:	68 87 2c 80 00       	push   $0x802c87
  802159:	68 08 2c 80 00       	push   $0x802c08
  80215e:	6a 6d                	push   $0x6d
  802160:	68 7b 2c 80 00       	push   $0x802c7b
  802165:	e8 9f 01 00 00       	call   802309 <_panic>

0080216a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802180:	8b 45 10             	mov    0x10(%ebp),%eax
  802183:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802188:	b8 09 00 00 00       	mov    $0x9,%eax
  80218d:	e8 a8 fd ff ff       	call   801f3a <nsipc>
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802194:	b8 00 00 00 00       	mov    $0x0,%eax
  802199:	c3                   	ret    

0080219a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021a0:	68 93 2c 80 00       	push   $0x802c93
  8021a5:	ff 75 0c             	pushl  0xc(%ebp)
  8021a8:	e8 f7 e9 ff ff       	call   800ba4 <strcpy>
	return 0;
}
  8021ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <devcons_write>:
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	57                   	push   %edi
  8021b8:	56                   	push   %esi
  8021b9:	53                   	push   %ebx
  8021ba:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021c0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021c5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021cb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021ce:	73 31                	jae    802201 <devcons_write+0x4d>
		m = n - tot;
  8021d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021d3:	29 f3                	sub    %esi,%ebx
  8021d5:	83 fb 7f             	cmp    $0x7f,%ebx
  8021d8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021dd:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021e0:	83 ec 04             	sub    $0x4,%esp
  8021e3:	53                   	push   %ebx
  8021e4:	89 f0                	mov    %esi,%eax
  8021e6:	03 45 0c             	add    0xc(%ebp),%eax
  8021e9:	50                   	push   %eax
  8021ea:	57                   	push   %edi
  8021eb:	e8 42 eb ff ff       	call   800d32 <memmove>
		sys_cputs(buf, m);
  8021f0:	83 c4 08             	add    $0x8,%esp
  8021f3:	53                   	push   %ebx
  8021f4:	57                   	push   %edi
  8021f5:	e8 e0 ec ff ff       	call   800eda <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021fa:	01 de                	add    %ebx,%esi
  8021fc:	83 c4 10             	add    $0x10,%esp
  8021ff:	eb ca                	jmp    8021cb <devcons_write+0x17>
}
  802201:	89 f0                	mov    %esi,%eax
  802203:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802206:	5b                   	pop    %ebx
  802207:	5e                   	pop    %esi
  802208:	5f                   	pop    %edi
  802209:	5d                   	pop    %ebp
  80220a:	c3                   	ret    

0080220b <devcons_read>:
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 08             	sub    $0x8,%esp
  802211:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802216:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80221a:	74 21                	je     80223d <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80221c:	e8 d7 ec ff ff       	call   800ef8 <sys_cgetc>
  802221:	85 c0                	test   %eax,%eax
  802223:	75 07                	jne    80222c <devcons_read+0x21>
		sys_yield();
  802225:	e8 4d ed ff ff       	call   800f77 <sys_yield>
  80222a:	eb f0                	jmp    80221c <devcons_read+0x11>
	if (c < 0)
  80222c:	78 0f                	js     80223d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80222e:	83 f8 04             	cmp    $0x4,%eax
  802231:	74 0c                	je     80223f <devcons_read+0x34>
	*(char*)vbuf = c;
  802233:	8b 55 0c             	mov    0xc(%ebp),%edx
  802236:	88 02                	mov    %al,(%edx)
	return 1;
  802238:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80223d:	c9                   	leave  
  80223e:	c3                   	ret    
		return 0;
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
  802244:	eb f7                	jmp    80223d <devcons_read+0x32>

00802246 <cputchar>:
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802252:	6a 01                	push   $0x1
  802254:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802257:	50                   	push   %eax
  802258:	e8 7d ec ff ff       	call   800eda <sys_cputs>
}
  80225d:	83 c4 10             	add    $0x10,%esp
  802260:	c9                   	leave  
  802261:	c3                   	ret    

00802262 <getchar>:
{
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
  802265:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802268:	6a 01                	push   $0x1
  80226a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80226d:	50                   	push   %eax
  80226e:	6a 00                	push   $0x0
  802270:	e8 1a f2 ff ff       	call   80148f <read>
	if (r < 0)
  802275:	83 c4 10             	add    $0x10,%esp
  802278:	85 c0                	test   %eax,%eax
  80227a:	78 06                	js     802282 <getchar+0x20>
	if (r < 1)
  80227c:	74 06                	je     802284 <getchar+0x22>
	return c;
  80227e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802282:	c9                   	leave  
  802283:	c3                   	ret    
		return -E_EOF;
  802284:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802289:	eb f7                	jmp    802282 <getchar+0x20>

0080228b <iscons>:
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802291:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802294:	50                   	push   %eax
  802295:	ff 75 08             	pushl  0x8(%ebp)
  802298:	e8 82 ef ff ff       	call   80121f <fd_lookup>
  80229d:	83 c4 10             	add    $0x10,%esp
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	78 11                	js     8022b5 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022ad:	39 10                	cmp    %edx,(%eax)
  8022af:	0f 94 c0             	sete   %al
  8022b2:	0f b6 c0             	movzbl %al,%eax
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <opencons>:
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c0:	50                   	push   %eax
  8022c1:	e8 07 ef ff ff       	call   8011cd <fd_alloc>
  8022c6:	83 c4 10             	add    $0x10,%esp
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	78 3a                	js     802307 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022cd:	83 ec 04             	sub    $0x4,%esp
  8022d0:	68 07 04 00 00       	push   $0x407
  8022d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d8:	6a 00                	push   $0x0
  8022da:	e8 b7 ec ff ff       	call   800f96 <sys_page_alloc>
  8022df:	83 c4 10             	add    $0x10,%esp
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	78 21                	js     802307 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022ef:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022fb:	83 ec 0c             	sub    $0xc,%esp
  8022fe:	50                   	push   %eax
  8022ff:	e8 a2 ee ff ff       	call   8011a6 <fd2num>
  802304:	83 c4 10             	add    $0x10,%esp
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	56                   	push   %esi
  80230d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80230e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802311:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802317:	e8 3c ec ff ff       	call   800f58 <sys_getenvid>
  80231c:	83 ec 0c             	sub    $0xc,%esp
  80231f:	ff 75 0c             	pushl  0xc(%ebp)
  802322:	ff 75 08             	pushl  0x8(%ebp)
  802325:	56                   	push   %esi
  802326:	50                   	push   %eax
  802327:	68 a0 2c 80 00       	push   $0x802ca0
  80232c:	e8 97 e2 ff ff       	call   8005c8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802331:	83 c4 18             	add    $0x18,%esp
  802334:	53                   	push   %ebx
  802335:	ff 75 10             	pushl  0x10(%ebp)
  802338:	e8 3a e2 ff ff       	call   800577 <vcprintf>
	cprintf("\n");
  80233d:	c7 04 24 53 2c 80 00 	movl   $0x802c53,(%esp)
  802344:	e8 7f e2 ff ff       	call   8005c8 <cprintf>
  802349:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80234c:	cc                   	int3   
  80234d:	eb fd                	jmp    80234c <_panic+0x43>

0080234f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
  802352:	56                   	push   %esi
  802353:	53                   	push   %ebx
  802354:	8b 75 08             	mov    0x8(%ebp),%esi
  802357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  80235d:	85 c0                	test   %eax,%eax
  80235f:	74 4f                	je     8023b0 <ipc_recv+0x61>
  802361:	83 ec 0c             	sub    $0xc,%esp
  802364:	50                   	push   %eax
  802365:	e8 dc ed ff ff       	call   801146 <sys_ipc_recv>
  80236a:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  80236d:	85 f6                	test   %esi,%esi
  80236f:	74 14                	je     802385 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802371:	ba 00 00 00 00       	mov    $0x0,%edx
  802376:	85 c0                	test   %eax,%eax
  802378:	75 09                	jne    802383 <ipc_recv+0x34>
  80237a:	8b 15 18 40 80 00    	mov    0x804018,%edx
  802380:	8b 52 74             	mov    0x74(%edx),%edx
  802383:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  802385:	85 db                	test   %ebx,%ebx
  802387:	74 14                	je     80239d <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  802389:	ba 00 00 00 00       	mov    $0x0,%edx
  80238e:	85 c0                	test   %eax,%eax
  802390:	75 09                	jne    80239b <ipc_recv+0x4c>
  802392:	8b 15 18 40 80 00    	mov    0x804018,%edx
  802398:	8b 52 78             	mov    0x78(%edx),%edx
  80239b:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  80239d:	85 c0                	test   %eax,%eax
  80239f:	75 08                	jne    8023a9 <ipc_recv+0x5a>
  8023a1:	a1 18 40 80 00       	mov    0x804018,%eax
  8023a6:	8b 40 70             	mov    0x70(%eax),%eax
}
  8023a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023ac:	5b                   	pop    %ebx
  8023ad:	5e                   	pop    %esi
  8023ae:	5d                   	pop    %ebp
  8023af:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  8023b0:	83 ec 0c             	sub    $0xc,%esp
  8023b3:	68 00 00 c0 ee       	push   $0xeec00000
  8023b8:	e8 89 ed ff ff       	call   801146 <sys_ipc_recv>
  8023bd:	83 c4 10             	add    $0x10,%esp
  8023c0:	eb ab                	jmp    80236d <ipc_recv+0x1e>

008023c2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	57                   	push   %edi
  8023c6:	56                   	push   %esi
  8023c7:	53                   	push   %ebx
  8023c8:	83 ec 0c             	sub    $0xc,%esp
  8023cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023ce:	8b 75 10             	mov    0x10(%ebp),%esi
  8023d1:	eb 20                	jmp    8023f3 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8023d3:	6a 00                	push   $0x0
  8023d5:	68 00 00 c0 ee       	push   $0xeec00000
  8023da:	ff 75 0c             	pushl  0xc(%ebp)
  8023dd:	57                   	push   %edi
  8023de:	e8 40 ed ff ff       	call   801123 <sys_ipc_try_send>
  8023e3:	89 c3                	mov    %eax,%ebx
  8023e5:	83 c4 10             	add    $0x10,%esp
  8023e8:	eb 1f                	jmp    802409 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  8023ea:	e8 88 eb ff ff       	call   800f77 <sys_yield>
	while(retval != 0) {
  8023ef:	85 db                	test   %ebx,%ebx
  8023f1:	74 33                	je     802426 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8023f3:	85 f6                	test   %esi,%esi
  8023f5:	74 dc                	je     8023d3 <ipc_send+0x11>
  8023f7:	ff 75 14             	pushl  0x14(%ebp)
  8023fa:	56                   	push   %esi
  8023fb:	ff 75 0c             	pushl  0xc(%ebp)
  8023fe:	57                   	push   %edi
  8023ff:	e8 1f ed ff ff       	call   801123 <sys_ipc_try_send>
  802404:	89 c3                	mov    %eax,%ebx
  802406:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802409:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80240c:	74 dc                	je     8023ea <ipc_send+0x28>
  80240e:	85 db                	test   %ebx,%ebx
  802410:	74 d8                	je     8023ea <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802412:	83 ec 04             	sub    $0x4,%esp
  802415:	68 c4 2c 80 00       	push   $0x802cc4
  80241a:	6a 35                	push   $0x35
  80241c:	68 f4 2c 80 00       	push   $0x802cf4
  802421:	e8 e3 fe ff ff       	call   802309 <_panic>
	}
}
  802426:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802429:	5b                   	pop    %ebx
  80242a:	5e                   	pop    %esi
  80242b:	5f                   	pop    %edi
  80242c:	5d                   	pop    %ebp
  80242d:	c3                   	ret    

0080242e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
  802431:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802434:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802439:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80243c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802442:	8b 52 50             	mov    0x50(%edx),%edx
  802445:	39 ca                	cmp    %ecx,%edx
  802447:	74 11                	je     80245a <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802449:	83 c0 01             	add    $0x1,%eax
  80244c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802451:	75 e6                	jne    802439 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
  802458:	eb 0b                	jmp    802465 <ipc_find_env+0x37>
			return envs[i].env_id;
  80245a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80245d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802462:	8b 40 48             	mov    0x48(%eax),%eax
}
  802465:	5d                   	pop    %ebp
  802466:	c3                   	ret    

00802467 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80246d:	89 d0                	mov    %edx,%eax
  80246f:	c1 e8 16             	shr    $0x16,%eax
  802472:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802479:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80247e:	f6 c1 01             	test   $0x1,%cl
  802481:	74 1d                	je     8024a0 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802483:	c1 ea 0c             	shr    $0xc,%edx
  802486:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80248d:	f6 c2 01             	test   $0x1,%dl
  802490:	74 0e                	je     8024a0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802492:	c1 ea 0c             	shr    $0xc,%edx
  802495:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80249c:	ef 
  80249d:	0f b7 c0             	movzwl %ax,%eax
}
  8024a0:	5d                   	pop    %ebp
  8024a1:	c3                   	ret    
  8024a2:	66 90                	xchg   %ax,%ax
  8024a4:	66 90                	xchg   %ax,%ax
  8024a6:	66 90                	xchg   %ax,%ax
  8024a8:	66 90                	xchg   %ax,%ax
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	66 90                	xchg   %ax,%ax
  8024ae:	66 90                	xchg   %ax,%ax

008024b0 <__udivdi3>:
  8024b0:	f3 0f 1e fb          	endbr32 
  8024b4:	55                   	push   %ebp
  8024b5:	57                   	push   %edi
  8024b6:	56                   	push   %esi
  8024b7:	53                   	push   %ebx
  8024b8:	83 ec 1c             	sub    $0x1c,%esp
  8024bb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024cb:	85 d2                	test   %edx,%edx
  8024cd:	75 49                	jne    802518 <__udivdi3+0x68>
  8024cf:	39 f3                	cmp    %esi,%ebx
  8024d1:	76 15                	jbe    8024e8 <__udivdi3+0x38>
  8024d3:	31 ff                	xor    %edi,%edi
  8024d5:	89 e8                	mov    %ebp,%eax
  8024d7:	89 f2                	mov    %esi,%edx
  8024d9:	f7 f3                	div    %ebx
  8024db:	89 fa                	mov    %edi,%edx
  8024dd:	83 c4 1c             	add    $0x1c,%esp
  8024e0:	5b                   	pop    %ebx
  8024e1:	5e                   	pop    %esi
  8024e2:	5f                   	pop    %edi
  8024e3:	5d                   	pop    %ebp
  8024e4:	c3                   	ret    
  8024e5:	8d 76 00             	lea    0x0(%esi),%esi
  8024e8:	89 d9                	mov    %ebx,%ecx
  8024ea:	85 db                	test   %ebx,%ebx
  8024ec:	75 0b                	jne    8024f9 <__udivdi3+0x49>
  8024ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f3:	31 d2                	xor    %edx,%edx
  8024f5:	f7 f3                	div    %ebx
  8024f7:	89 c1                	mov    %eax,%ecx
  8024f9:	31 d2                	xor    %edx,%edx
  8024fb:	89 f0                	mov    %esi,%eax
  8024fd:	f7 f1                	div    %ecx
  8024ff:	89 c6                	mov    %eax,%esi
  802501:	89 e8                	mov    %ebp,%eax
  802503:	89 f7                	mov    %esi,%edi
  802505:	f7 f1                	div    %ecx
  802507:	89 fa                	mov    %edi,%edx
  802509:	83 c4 1c             	add    $0x1c,%esp
  80250c:	5b                   	pop    %ebx
  80250d:	5e                   	pop    %esi
  80250e:	5f                   	pop    %edi
  80250f:	5d                   	pop    %ebp
  802510:	c3                   	ret    
  802511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802518:	39 f2                	cmp    %esi,%edx
  80251a:	77 1c                	ja     802538 <__udivdi3+0x88>
  80251c:	0f bd fa             	bsr    %edx,%edi
  80251f:	83 f7 1f             	xor    $0x1f,%edi
  802522:	75 2c                	jne    802550 <__udivdi3+0xa0>
  802524:	39 f2                	cmp    %esi,%edx
  802526:	72 06                	jb     80252e <__udivdi3+0x7e>
  802528:	31 c0                	xor    %eax,%eax
  80252a:	39 eb                	cmp    %ebp,%ebx
  80252c:	77 ad                	ja     8024db <__udivdi3+0x2b>
  80252e:	b8 01 00 00 00       	mov    $0x1,%eax
  802533:	eb a6                	jmp    8024db <__udivdi3+0x2b>
  802535:	8d 76 00             	lea    0x0(%esi),%esi
  802538:	31 ff                	xor    %edi,%edi
  80253a:	31 c0                	xor    %eax,%eax
  80253c:	89 fa                	mov    %edi,%edx
  80253e:	83 c4 1c             	add    $0x1c,%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
  802546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80254d:	8d 76 00             	lea    0x0(%esi),%esi
  802550:	89 f9                	mov    %edi,%ecx
  802552:	b8 20 00 00 00       	mov    $0x20,%eax
  802557:	29 f8                	sub    %edi,%eax
  802559:	d3 e2                	shl    %cl,%edx
  80255b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80255f:	89 c1                	mov    %eax,%ecx
  802561:	89 da                	mov    %ebx,%edx
  802563:	d3 ea                	shr    %cl,%edx
  802565:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802569:	09 d1                	or     %edx,%ecx
  80256b:	89 f2                	mov    %esi,%edx
  80256d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802571:	89 f9                	mov    %edi,%ecx
  802573:	d3 e3                	shl    %cl,%ebx
  802575:	89 c1                	mov    %eax,%ecx
  802577:	d3 ea                	shr    %cl,%edx
  802579:	89 f9                	mov    %edi,%ecx
  80257b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80257f:	89 eb                	mov    %ebp,%ebx
  802581:	d3 e6                	shl    %cl,%esi
  802583:	89 c1                	mov    %eax,%ecx
  802585:	d3 eb                	shr    %cl,%ebx
  802587:	09 de                	or     %ebx,%esi
  802589:	89 f0                	mov    %esi,%eax
  80258b:	f7 74 24 08          	divl   0x8(%esp)
  80258f:	89 d6                	mov    %edx,%esi
  802591:	89 c3                	mov    %eax,%ebx
  802593:	f7 64 24 0c          	mull   0xc(%esp)
  802597:	39 d6                	cmp    %edx,%esi
  802599:	72 15                	jb     8025b0 <__udivdi3+0x100>
  80259b:	89 f9                	mov    %edi,%ecx
  80259d:	d3 e5                	shl    %cl,%ebp
  80259f:	39 c5                	cmp    %eax,%ebp
  8025a1:	73 04                	jae    8025a7 <__udivdi3+0xf7>
  8025a3:	39 d6                	cmp    %edx,%esi
  8025a5:	74 09                	je     8025b0 <__udivdi3+0x100>
  8025a7:	89 d8                	mov    %ebx,%eax
  8025a9:	31 ff                	xor    %edi,%edi
  8025ab:	e9 2b ff ff ff       	jmp    8024db <__udivdi3+0x2b>
  8025b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025b3:	31 ff                	xor    %edi,%edi
  8025b5:	e9 21 ff ff ff       	jmp    8024db <__udivdi3+0x2b>
  8025ba:	66 90                	xchg   %ax,%ax
  8025bc:	66 90                	xchg   %ax,%ax
  8025be:	66 90                	xchg   %ax,%ax

008025c0 <__umoddi3>:
  8025c0:	f3 0f 1e fb          	endbr32 
  8025c4:	55                   	push   %ebp
  8025c5:	57                   	push   %edi
  8025c6:	56                   	push   %esi
  8025c7:	53                   	push   %ebx
  8025c8:	83 ec 1c             	sub    $0x1c,%esp
  8025cb:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025d3:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025db:	89 da                	mov    %ebx,%edx
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	75 3f                	jne    802620 <__umoddi3+0x60>
  8025e1:	39 df                	cmp    %ebx,%edi
  8025e3:	76 13                	jbe    8025f8 <__umoddi3+0x38>
  8025e5:	89 f0                	mov    %esi,%eax
  8025e7:	f7 f7                	div    %edi
  8025e9:	89 d0                	mov    %edx,%eax
  8025eb:	31 d2                	xor    %edx,%edx
  8025ed:	83 c4 1c             	add    $0x1c,%esp
  8025f0:	5b                   	pop    %ebx
  8025f1:	5e                   	pop    %esi
  8025f2:	5f                   	pop    %edi
  8025f3:	5d                   	pop    %ebp
  8025f4:	c3                   	ret    
  8025f5:	8d 76 00             	lea    0x0(%esi),%esi
  8025f8:	89 fd                	mov    %edi,%ebp
  8025fa:	85 ff                	test   %edi,%edi
  8025fc:	75 0b                	jne    802609 <__umoddi3+0x49>
  8025fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802603:	31 d2                	xor    %edx,%edx
  802605:	f7 f7                	div    %edi
  802607:	89 c5                	mov    %eax,%ebp
  802609:	89 d8                	mov    %ebx,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	f7 f5                	div    %ebp
  80260f:	89 f0                	mov    %esi,%eax
  802611:	f7 f5                	div    %ebp
  802613:	89 d0                	mov    %edx,%eax
  802615:	eb d4                	jmp    8025eb <__umoddi3+0x2b>
  802617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80261e:	66 90                	xchg   %ax,%ax
  802620:	89 f1                	mov    %esi,%ecx
  802622:	39 d8                	cmp    %ebx,%eax
  802624:	76 0a                	jbe    802630 <__umoddi3+0x70>
  802626:	89 f0                	mov    %esi,%eax
  802628:	83 c4 1c             	add    $0x1c,%esp
  80262b:	5b                   	pop    %ebx
  80262c:	5e                   	pop    %esi
  80262d:	5f                   	pop    %edi
  80262e:	5d                   	pop    %ebp
  80262f:	c3                   	ret    
  802630:	0f bd e8             	bsr    %eax,%ebp
  802633:	83 f5 1f             	xor    $0x1f,%ebp
  802636:	75 20                	jne    802658 <__umoddi3+0x98>
  802638:	39 d8                	cmp    %ebx,%eax
  80263a:	0f 82 b0 00 00 00    	jb     8026f0 <__umoddi3+0x130>
  802640:	39 f7                	cmp    %esi,%edi
  802642:	0f 86 a8 00 00 00    	jbe    8026f0 <__umoddi3+0x130>
  802648:	89 c8                	mov    %ecx,%eax
  80264a:	83 c4 1c             	add    $0x1c,%esp
  80264d:	5b                   	pop    %ebx
  80264e:	5e                   	pop    %esi
  80264f:	5f                   	pop    %edi
  802650:	5d                   	pop    %ebp
  802651:	c3                   	ret    
  802652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802658:	89 e9                	mov    %ebp,%ecx
  80265a:	ba 20 00 00 00       	mov    $0x20,%edx
  80265f:	29 ea                	sub    %ebp,%edx
  802661:	d3 e0                	shl    %cl,%eax
  802663:	89 44 24 08          	mov    %eax,0x8(%esp)
  802667:	89 d1                	mov    %edx,%ecx
  802669:	89 f8                	mov    %edi,%eax
  80266b:	d3 e8                	shr    %cl,%eax
  80266d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802671:	89 54 24 04          	mov    %edx,0x4(%esp)
  802675:	8b 54 24 04          	mov    0x4(%esp),%edx
  802679:	09 c1                	or     %eax,%ecx
  80267b:	89 d8                	mov    %ebx,%eax
  80267d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802681:	89 e9                	mov    %ebp,%ecx
  802683:	d3 e7                	shl    %cl,%edi
  802685:	89 d1                	mov    %edx,%ecx
  802687:	d3 e8                	shr    %cl,%eax
  802689:	89 e9                	mov    %ebp,%ecx
  80268b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80268f:	d3 e3                	shl    %cl,%ebx
  802691:	89 c7                	mov    %eax,%edi
  802693:	89 d1                	mov    %edx,%ecx
  802695:	89 f0                	mov    %esi,%eax
  802697:	d3 e8                	shr    %cl,%eax
  802699:	89 e9                	mov    %ebp,%ecx
  80269b:	89 fa                	mov    %edi,%edx
  80269d:	d3 e6                	shl    %cl,%esi
  80269f:	09 d8                	or     %ebx,%eax
  8026a1:	f7 74 24 08          	divl   0x8(%esp)
  8026a5:	89 d1                	mov    %edx,%ecx
  8026a7:	89 f3                	mov    %esi,%ebx
  8026a9:	f7 64 24 0c          	mull   0xc(%esp)
  8026ad:	89 c6                	mov    %eax,%esi
  8026af:	89 d7                	mov    %edx,%edi
  8026b1:	39 d1                	cmp    %edx,%ecx
  8026b3:	72 06                	jb     8026bb <__umoddi3+0xfb>
  8026b5:	75 10                	jne    8026c7 <__umoddi3+0x107>
  8026b7:	39 c3                	cmp    %eax,%ebx
  8026b9:	73 0c                	jae    8026c7 <__umoddi3+0x107>
  8026bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8026bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8026c3:	89 d7                	mov    %edx,%edi
  8026c5:	89 c6                	mov    %eax,%esi
  8026c7:	89 ca                	mov    %ecx,%edx
  8026c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ce:	29 f3                	sub    %esi,%ebx
  8026d0:	19 fa                	sbb    %edi,%edx
  8026d2:	89 d0                	mov    %edx,%eax
  8026d4:	d3 e0                	shl    %cl,%eax
  8026d6:	89 e9                	mov    %ebp,%ecx
  8026d8:	d3 eb                	shr    %cl,%ebx
  8026da:	d3 ea                	shr    %cl,%edx
  8026dc:	09 d8                	or     %ebx,%eax
  8026de:	83 c4 1c             	add    $0x1c,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5f                   	pop    %edi
  8026e4:	5d                   	pop    %ebp
  8026e5:	c3                   	ret    
  8026e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026ed:	8d 76 00             	lea    0x0(%esi),%esi
  8026f0:	89 da                	mov    %ebx,%edx
  8026f2:	29 fe                	sub    %edi,%esi
  8026f4:	19 c2                	sbb    %eax,%edx
  8026f6:	89 f1                	mov    %esi,%ecx
  8026f8:	89 c8                	mov    %ecx,%eax
  8026fa:	e9 4b ff ff ff       	jmp    80264a <__umoddi3+0x8a>
