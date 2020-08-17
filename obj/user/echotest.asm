
obj/user/echotest.debug：     文件格式 elf32-i386


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
  80002c:	e8 88 04 00 00       	call   8004b9 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 e0 26 80 00       	push   $0x8026e0
  80003f:	e8 6a 05 00 00       	call   8005ae <cprintf>
	exit();
  800044:	e8 b6 04 00 00       	call   8004ff <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <umain>:

void umain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 58             	sub    $0x58,%esp
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	cprintf("Connecting to:\n");
  800057:	68 e4 26 80 00       	push   $0x8026e4
  80005c:	e8 4d 05 00 00       	call   8005ae <cprintf>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800061:	c7 04 24 f4 26 80 00 	movl   $0x8026f4,(%esp)
  800068:	e8 17 04 00 00       	call   800484 <inet_addr>
  80006d:	83 c4 0c             	add    $0xc,%esp
  800070:	50                   	push   %eax
  800071:	68 f4 26 80 00       	push   $0x8026f4
  800076:	68 fe 26 80 00       	push   $0x8026fe
  80007b:	e8 2e 05 00 00       	call   8005ae <cprintf>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800080:	83 c4 0c             	add    $0xc,%esp
  800083:	6a 06                	push   $0x6
  800085:	6a 01                	push   $0x1
  800087:	6a 02                	push   $0x2
  800089:	e8 70 1e 00 00       	call   801efe <socket>
  80008e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	0f 88 b4 00 00 00    	js     800150 <umain+0x102>
		die("Failed to create socket");

	cprintf("opened socket\n");
  80009c:	83 ec 0c             	sub    $0xc,%esp
  80009f:	68 2b 27 80 00       	push   $0x80272b
  8000a4:	e8 05 05 00 00       	call   8005ae <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000a9:	83 c4 0c             	add    $0xc,%esp
  8000ac:	6a 10                	push   $0x10
  8000ae:	6a 00                	push   $0x0
  8000b0:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000b3:	53                   	push   %ebx
  8000b4:	e8 17 0c 00 00       	call   800cd0 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000b9:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000bd:	c7 04 24 f4 26 80 00 	movl   $0x8026f4,(%esp)
  8000c4:	e8 bb 03 00 00       	call   800484 <inet_addr>
  8000c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000cc:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000d3:	e8 9d 01 00 00       	call   800275 <htons>
  8000d8:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  8000dc:	c7 04 24 3a 27 80 00 	movl   $0x80273a,(%esp)
  8000e3:	e8 c6 04 00 00       	call   8005ae <cprintf>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8000e8:	83 c4 0c             	add    $0xc,%esp
  8000eb:	6a 10                	push   $0x10
  8000ed:	53                   	push   %ebx
  8000ee:	ff 75 b4             	pushl  -0x4c(%ebp)
  8000f1:	e8 bf 1d 00 00       	call   801eb5 <connect>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	85 c0                	test   %eax,%eax
  8000fb:	78 62                	js     80015f <umain+0x111>
		die("Failed to connect with server");

	cprintf("connected to server\n");
  8000fd:	83 ec 0c             	sub    $0xc,%esp
  800100:	68 75 27 80 00       	push   $0x802775
  800105:	e8 a4 04 00 00       	call   8005ae <cprintf>

	// Send the word to the server
	echolen = strlen(msg);
  80010a:	83 c4 04             	add    $0x4,%esp
  80010d:	ff 35 00 30 80 00    	pushl  0x803000
  800113:	e8 39 0a 00 00       	call   800b51 <strlen>
  800118:	89 c7                	mov    %eax,%edi
  80011a:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (write(sock, msg, echolen) != echolen)
  80011d:	83 c4 0c             	add    $0xc,%esp
  800120:	50                   	push   %eax
  800121:	ff 35 00 30 80 00    	pushl  0x803000
  800127:	ff 75 b4             	pushl  -0x4c(%ebp)
  80012a:	e8 12 14 00 00       	call   801541 <write>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	39 c7                	cmp    %eax,%edi
  800134:	75 35                	jne    80016b <umain+0x11d>
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 8a 27 80 00       	push   $0x80278a
  80013e:	e8 6b 04 00 00       	call   8005ae <cprintf>
	while (received < echolen) {
  800143:	83 c4 10             	add    $0x10,%esp
	int received = 0;
  800146:	be 00 00 00 00       	mov    $0x0,%esi
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80014b:	8d 7d b8             	lea    -0x48(%ebp),%edi
	while (received < echolen) {
  80014e:	eb 3a                	jmp    80018a <umain+0x13c>
		die("Failed to create socket");
  800150:	b8 13 27 80 00       	mov    $0x802713,%eax
  800155:	e8 d9 fe ff ff       	call   800033 <die>
  80015a:	e9 3d ff ff ff       	jmp    80009c <umain+0x4e>
		die("Failed to connect with server");
  80015f:	b8 57 27 80 00       	mov    $0x802757,%eax
  800164:	e8 ca fe ff ff       	call   800033 <die>
  800169:	eb 92                	jmp    8000fd <umain+0xaf>
		die("Mismatch in number of sent bytes");
  80016b:	b8 a4 27 80 00       	mov    $0x8027a4,%eax
  800170:	e8 be fe ff ff       	call   800033 <die>
  800175:	eb bf                	jmp    800136 <umain+0xe8>
			die("Failed to receive bytes from server");
		}
		received += bytes;
  800177:	01 de                	add    %ebx,%esi
		buffer[bytes] = '\0';        // Assure null terminated string
  800179:	c6 44 1d b8 00       	movb   $0x0,-0x48(%ebp,%ebx,1)
		cprintf(buffer);
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	57                   	push   %edi
  800182:	e8 27 04 00 00       	call   8005ae <cprintf>
  800187:	83 c4 10             	add    $0x10,%esp
	while (received < echolen) {
  80018a:	3b 75 b0             	cmp    -0x50(%ebp),%esi
  80018d:	73 23                	jae    8001b2 <umain+0x164>
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	6a 1f                	push   $0x1f
  800194:	57                   	push   %edi
  800195:	ff 75 b4             	pushl  -0x4c(%ebp)
  800198:	e8 d8 12 00 00       	call   801475 <read>
  80019d:	89 c3                	mov    %eax,%ebx
  80019f:	83 c4 10             	add    $0x10,%esp
  8001a2:	85 c0                	test   %eax,%eax
  8001a4:	7f d1                	jg     800177 <umain+0x129>
			die("Failed to receive bytes from server");
  8001a6:	b8 c8 27 80 00       	mov    $0x8027c8,%eax
  8001ab:	e8 83 fe ff ff       	call   800033 <die>
  8001b0:	eb c5                	jmp    800177 <umain+0x129>
	}
	cprintf("\n");
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	68 94 27 80 00       	push   $0x802794
  8001ba:	e8 ef 03 00 00       	call   8005ae <cprintf>

	close(sock);
  8001bf:	83 c4 04             	add    $0x4,%esp
  8001c2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8001c5:	e8 6d 11 00 00       	call   801337 <close>
}
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d0:	5b                   	pop    %ebx
  8001d1:	5e                   	pop    %esi
  8001d2:	5f                   	pop    %edi
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    

008001d5 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	57                   	push   %edi
  8001d9:	56                   	push   %esi
  8001da:	53                   	push   %ebx
  8001db:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001de:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8001e4:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  8001e8:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  8001eb:	bf 00 40 80 00       	mov    $0x804000,%edi
  8001f0:	eb 1a                	jmp    80020c <inet_ntoa+0x37>
  8001f2:	0f b6 db             	movzbl %bl,%ebx
  8001f5:	01 fb                	add    %edi,%ebx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8001f7:	8d 7b 01             	lea    0x1(%ebx),%edi
  8001fa:	c6 03 2e             	movb   $0x2e,(%ebx)
  8001fd:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  800200:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  800204:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  800208:	3c 04                	cmp    $0x4,%al
  80020a:	74 59                	je     800265 <inet_ntoa+0x90>
  rp = str;
  80020c:	ba 00 00 00 00       	mov    $0x0,%edx
      rem = *ap % (u8_t)10;
  800211:	0f b6 0e             	movzbl (%esi),%ecx
      *ap /= (u8_t)10;
  800214:	0f b6 d9             	movzbl %cl,%ebx
  800217:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  80021a:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  80021d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800220:	66 c1 e8 0b          	shr    $0xb,%ax
  800224:	88 06                	mov    %al,(%esi)
      inv[i++] = '0' + rem;
  800226:	8d 5a 01             	lea    0x1(%edx),%ebx
  800229:	0f b6 d2             	movzbl %dl,%edx
  80022c:	89 55 e0             	mov    %edx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  80022f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800232:	01 c0                	add    %eax,%eax
  800234:	89 ca                	mov    %ecx,%edx
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
      inv[i++] = '0' + rem;
  80023a:	83 c0 30             	add    $0x30,%eax
  80023d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800240:	88 44 15 ed          	mov    %al,-0x13(%ebp,%edx,1)
  800244:	89 da                	mov    %ebx,%edx
    } while(*ap);
  800246:	80 f9 09             	cmp    $0x9,%cl
  800249:	77 c6                	ja     800211 <inet_ntoa+0x3c>
  80024b:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  80024d:	89 d8                	mov    %ebx,%eax
    while(i--)
  80024f:	83 e8 01             	sub    $0x1,%eax
  800252:	3c ff                	cmp    $0xff,%al
  800254:	74 9c                	je     8001f2 <inet_ntoa+0x1d>
      *rp++ = inv[i];
  800256:	0f b6 c8             	movzbl %al,%ecx
  800259:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  80025e:	88 0a                	mov    %cl,(%edx)
  800260:	83 c2 01             	add    $0x1,%edx
  800263:	eb ea                	jmp    80024f <inet_ntoa+0x7a>
    ap++;
  }
  *--rp = 0;
  800265:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  800268:	b8 00 40 80 00       	mov    $0x804000,%eax
  80026d:	83 c4 18             	add    $0x18,%esp
  800270:	5b                   	pop    %ebx
  800271:	5e                   	pop    %esi
  800272:	5f                   	pop    %edi
  800273:	5d                   	pop    %ebp
  800274:	c3                   	ret    

00800275 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800278:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80027c:	66 c1 c0 08          	rol    $0x8,%ax
}
  800280:	5d                   	pop    %ebp
  800281:	c3                   	ret    

00800282 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800285:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800289:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    

0080028f <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800295:	89 d0                	mov    %edx,%eax
  800297:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80029a:	89 d1                	mov    %edx,%ecx
  80029c:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  80029f:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002a1:	89 d1                	mov    %edx,%ecx
  8002a3:	c1 e1 08             	shl    $0x8,%ecx
  8002a6:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002ac:	09 c8                	or     %ecx,%eax
  8002ae:	c1 ea 08             	shr    $0x8,%edx
  8002b1:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8002b7:	09 d0                	or     %edx,%eax
}
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    

008002bb <inet_aton>:
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	57                   	push   %edi
  8002bf:	56                   	push   %esi
  8002c0:	53                   	push   %ebx
  8002c1:	83 ec 2c             	sub    $0x2c,%esp
  8002c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  8002c7:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  8002ca:	8d 75 d8             	lea    -0x28(%ebp),%esi
  8002cd:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8002d0:	e9 a7 00 00 00       	jmp    80037c <inet_aton+0xc1>
      c = *++cp;
  8002d5:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8002d9:	89 d1                	mov    %edx,%ecx
  8002db:	83 e1 df             	and    $0xffffffdf,%ecx
  8002de:	80 f9 58             	cmp    $0x58,%cl
  8002e1:	74 10                	je     8002f3 <inet_aton+0x38>
      c = *++cp;
  8002e3:	83 c0 01             	add    $0x1,%eax
  8002e6:	0f be d2             	movsbl %dl,%edx
        base = 8;
  8002e9:	be 08 00 00 00       	mov    $0x8,%esi
  8002ee:	e9 a3 00 00 00       	jmp    800396 <inet_aton+0xdb>
        c = *++cp;
  8002f3:	0f be 50 02          	movsbl 0x2(%eax),%edx
  8002f7:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  8002fa:	be 10 00 00 00       	mov    $0x10,%esi
  8002ff:	e9 92 00 00 00       	jmp    800396 <inet_aton+0xdb>
      } else if (base == 16 && isxdigit(c)) {
  800304:	83 fe 10             	cmp    $0x10,%esi
  800307:	75 4d                	jne    800356 <inet_aton+0x9b>
  800309:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  80030c:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  80030f:	89 d1                	mov    %edx,%ecx
  800311:	83 e1 df             	and    $0xffffffdf,%ecx
  800314:	83 e9 41             	sub    $0x41,%ecx
  800317:	80 f9 05             	cmp    $0x5,%cl
  80031a:	77 3a                	ja     800356 <inet_aton+0x9b>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  80031c:	c1 e3 04             	shl    $0x4,%ebx
  80031f:	83 c2 0a             	add    $0xa,%edx
  800322:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  800326:	19 c9                	sbb    %ecx,%ecx
  800328:	83 e1 20             	and    $0x20,%ecx
  80032b:	83 c1 41             	add    $0x41,%ecx
  80032e:	29 ca                	sub    %ecx,%edx
  800330:	09 d3                	or     %edx,%ebx
        c = *++cp;
  800332:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800335:	0f be 57 01          	movsbl 0x1(%edi),%edx
  800339:	83 c0 01             	add    $0x1,%eax
  80033c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if (isdigit(c)) {
  80033f:	89 d7                	mov    %edx,%edi
  800341:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800344:	80 f9 09             	cmp    $0x9,%cl
  800347:	77 bb                	ja     800304 <inet_aton+0x49>
        val = (val * base) + (int)(c - '0');
  800349:	0f af de             	imul   %esi,%ebx
  80034c:	8d 5c 1a d0          	lea    -0x30(%edx,%ebx,1),%ebx
        c = *++cp;
  800350:	0f be 50 01          	movsbl 0x1(%eax),%edx
  800354:	eb e3                	jmp    800339 <inet_aton+0x7e>
    if (c == '.') {
  800356:	83 fa 2e             	cmp    $0x2e,%edx
  800359:	75 42                	jne    80039d <inet_aton+0xe2>
      if (pp >= parts + 3)
  80035b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80035e:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800361:	39 c6                	cmp    %eax,%esi
  800363:	0f 84 0e 01 00 00    	je     800477 <inet_aton+0x1bc>
      *pp++ = val;
  800369:	83 c6 04             	add    $0x4,%esi
  80036c:	89 75 cc             	mov    %esi,-0x34(%ebp)
  80036f:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  800372:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  800375:	8d 46 01             	lea    0x1(%esi),%eax
  800378:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  80037c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80037f:	80 f9 09             	cmp    $0x9,%cl
  800382:	0f 87 e8 00 00 00    	ja     800470 <inet_aton+0x1b5>
    base = 10;
  800388:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  80038d:	83 fa 30             	cmp    $0x30,%edx
  800390:	0f 84 3f ff ff ff    	je     8002d5 <inet_aton+0x1a>
    base = 10;
  800396:	bb 00 00 00 00       	mov    $0x0,%ebx
  80039b:	eb 9f                	jmp    80033c <inet_aton+0x81>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80039d:	85 d2                	test   %edx,%edx
  80039f:	74 26                	je     8003c7 <inet_aton+0x10c>
    return (0);
  8003a1:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003a6:	89 f9                	mov    %edi,%ecx
  8003a8:	80 f9 1f             	cmp    $0x1f,%cl
  8003ab:	0f 86 cb 00 00 00    	jbe    80047c <inet_aton+0x1c1>
  8003b1:	84 d2                	test   %dl,%dl
  8003b3:	0f 88 c3 00 00 00    	js     80047c <inet_aton+0x1c1>
  8003b9:	83 fa 20             	cmp    $0x20,%edx
  8003bc:	74 09                	je     8003c7 <inet_aton+0x10c>
  8003be:	83 fa 0c             	cmp    $0xc,%edx
  8003c1:	0f 85 b5 00 00 00    	jne    80047c <inet_aton+0x1c1>
  n = pp - parts + 1;
  8003c7:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8003ca:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8003cd:	29 c6                	sub    %eax,%esi
  8003cf:	89 f0                	mov    %esi,%eax
  8003d1:	c1 f8 02             	sar    $0x2,%eax
  8003d4:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  8003d7:	83 f8 02             	cmp    $0x2,%eax
  8003da:	74 5e                	je     80043a <inet_aton+0x17f>
  8003dc:	7e 35                	jle    800413 <inet_aton+0x158>
  8003de:	83 f8 03             	cmp    $0x3,%eax
  8003e1:	74 6e                	je     800451 <inet_aton+0x196>
  8003e3:	83 f8 04             	cmp    $0x4,%eax
  8003e6:	75 2f                	jne    800417 <inet_aton+0x15c>
      return (0);
  8003e8:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  8003ed:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  8003f3:	0f 87 83 00 00 00    	ja     80047c <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8003f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003fc:	c1 e0 18             	shl    $0x18,%eax
  8003ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800402:	c1 e2 10             	shl    $0x10,%edx
  800405:	09 d0                	or     %edx,%eax
  800407:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80040a:	c1 e2 08             	shl    $0x8,%edx
  80040d:	09 d0                	or     %edx,%eax
  80040f:	09 c3                	or     %eax,%ebx
    break;
  800411:	eb 04                	jmp    800417 <inet_aton+0x15c>
  switch (n) {
  800413:	85 c0                	test   %eax,%eax
  800415:	74 65                	je     80047c <inet_aton+0x1c1>
  return (1);
  800417:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  80041c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800420:	74 5a                	je     80047c <inet_aton+0x1c1>
    addr->s_addr = htonl(val);
  800422:	83 ec 0c             	sub    $0xc,%esp
  800425:	53                   	push   %ebx
  800426:	e8 64 fe ff ff       	call   80028f <htonl>
  80042b:	83 c4 10             	add    $0x10,%esp
  80042e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800431:	89 06                	mov    %eax,(%esi)
  return (1);
  800433:	b8 01 00 00 00       	mov    $0x1,%eax
  800438:	eb 42                	jmp    80047c <inet_aton+0x1c1>
      return (0);
  80043a:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  80043f:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  800445:	77 35                	ja     80047c <inet_aton+0x1c1>
    val |= parts[0] << 24;
  800447:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80044a:	c1 e0 18             	shl    $0x18,%eax
  80044d:	09 c3                	or     %eax,%ebx
    break;
  80044f:	eb c6                	jmp    800417 <inet_aton+0x15c>
      return (0);
  800451:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  800456:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  80045c:	77 1e                	ja     80047c <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80045e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800461:	c1 e0 18             	shl    $0x18,%eax
  800464:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800467:	c1 e2 10             	shl    $0x10,%edx
  80046a:	09 d0                	or     %edx,%eax
  80046c:	09 c3                	or     %eax,%ebx
    break;
  80046e:	eb a7                	jmp    800417 <inet_aton+0x15c>
      return (0);
  800470:	b8 00 00 00 00       	mov    $0x0,%eax
  800475:	eb 05                	jmp    80047c <inet_aton+0x1c1>
        return (0);
  800477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80047c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80047f:	5b                   	pop    %ebx
  800480:	5e                   	pop    %esi
  800481:	5f                   	pop    %edi
  800482:	5d                   	pop    %ebp
  800483:	c3                   	ret    

00800484 <inet_addr>:
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  80048a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80048d:	50                   	push   %eax
  80048e:	ff 75 08             	pushl  0x8(%ebp)
  800491:	e8 25 fe ff ff       	call   8002bb <inet_aton>
  800496:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  800499:	85 c0                	test   %eax,%eax
  80049b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004a0:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  8004ac:	ff 75 08             	pushl  0x8(%ebp)
  8004af:	e8 db fd ff ff       	call   80028f <htonl>
  8004b4:	83 c4 10             	add    $0x10,%esp
}
  8004b7:	c9                   	leave  
  8004b8:	c3                   	ret    

008004b9 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
  8004bc:	56                   	push   %esi
  8004bd:	53                   	push   %ebx
  8004be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004c1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8004c4:	e8 75 0a 00 00       	call   800f3e <sys_getenvid>
  8004c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004ce:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004d1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004d6:	a3 18 40 80 00       	mov    %eax,0x804018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004db:	85 db                	test   %ebx,%ebx
  8004dd:	7e 07                	jle    8004e6 <libmain+0x2d>
		binaryname = argv[0];
  8004df:	8b 06                	mov    (%esi),%eax
  8004e1:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	56                   	push   %esi
  8004ea:	53                   	push   %ebx
  8004eb:	e8 5e fb ff ff       	call   80004e <umain>

	// exit gracefully
	exit();
  8004f0:	e8 0a 00 00 00       	call   8004ff <exit>
}
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004fb:	5b                   	pop    %ebx
  8004fc:	5e                   	pop    %esi
  8004fd:	5d                   	pop    %ebp
  8004fe:	c3                   	ret    

008004ff <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800505:	e8 5a 0e 00 00       	call   801364 <close_all>
	sys_env_destroy(0);
  80050a:	83 ec 0c             	sub    $0xc,%esp
  80050d:	6a 00                	push   $0x0
  80050f:	e8 e9 09 00 00       	call   800efd <sys_env_destroy>
}
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	53                   	push   %ebx
  80051d:	83 ec 04             	sub    $0x4,%esp
  800520:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800523:	8b 13                	mov    (%ebx),%edx
  800525:	8d 42 01             	lea    0x1(%edx),%eax
  800528:	89 03                	mov    %eax,(%ebx)
  80052a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80052d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800531:	3d ff 00 00 00       	cmp    $0xff,%eax
  800536:	74 09                	je     800541 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800538:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80053c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80053f:	c9                   	leave  
  800540:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	68 ff 00 00 00       	push   $0xff
  800549:	8d 43 08             	lea    0x8(%ebx),%eax
  80054c:	50                   	push   %eax
  80054d:	e8 6e 09 00 00       	call   800ec0 <sys_cputs>
		b->idx = 0;
  800552:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	eb db                	jmp    800538 <putch+0x1f>

0080055d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80055d:	55                   	push   %ebp
  80055e:	89 e5                	mov    %esp,%ebp
  800560:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800566:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80056d:	00 00 00 
	b.cnt = 0;
  800570:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800577:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80057a:	ff 75 0c             	pushl  0xc(%ebp)
  80057d:	ff 75 08             	pushl  0x8(%ebp)
  800580:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800586:	50                   	push   %eax
  800587:	68 19 05 80 00       	push   $0x800519
  80058c:	e8 19 01 00 00       	call   8006aa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800591:	83 c4 08             	add    $0x8,%esp
  800594:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80059a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005a0:	50                   	push   %eax
  8005a1:	e8 1a 09 00 00       	call   800ec0 <sys_cputs>

	return b.cnt;
}
  8005a6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005ac:	c9                   	leave  
  8005ad:	c3                   	ret    

008005ae <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005ae:	55                   	push   %ebp
  8005af:	89 e5                	mov    %esp,%ebp
  8005b1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005b4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005b7:	50                   	push   %eax
  8005b8:	ff 75 08             	pushl  0x8(%ebp)
  8005bb:	e8 9d ff ff ff       	call   80055d <vcprintf>
	va_end(ap);

	return cnt;
}
  8005c0:	c9                   	leave  
  8005c1:	c3                   	ret    

008005c2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c2:	55                   	push   %ebp
  8005c3:	89 e5                	mov    %esp,%ebp
  8005c5:	57                   	push   %edi
  8005c6:	56                   	push   %esi
  8005c7:	53                   	push   %ebx
  8005c8:	83 ec 1c             	sub    $0x1c,%esp
  8005cb:	89 c7                	mov    %eax,%edi
  8005cd:	89 d6                	mov    %edx,%esi
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005e3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005e6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005e9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8005ec:	89 d0                	mov    %edx,%eax
  8005ee:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8005f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8005f4:	73 15                	jae    80060b <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f6:	83 eb 01             	sub    $0x1,%ebx
  8005f9:	85 db                	test   %ebx,%ebx
  8005fb:	7e 43                	jle    800640 <printnum+0x7e>
			putch(padc, putdat);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	56                   	push   %esi
  800601:	ff 75 18             	pushl  0x18(%ebp)
  800604:	ff d7                	call   *%edi
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	eb eb                	jmp    8005f6 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	ff 75 18             	pushl  0x18(%ebp)
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800617:	53                   	push   %ebx
  800618:	ff 75 10             	pushl  0x10(%ebp)
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800621:	ff 75 e0             	pushl  -0x20(%ebp)
  800624:	ff 75 dc             	pushl  -0x24(%ebp)
  800627:	ff 75 d8             	pushl  -0x28(%ebp)
  80062a:	e8 61 1e 00 00       	call   802490 <__udivdi3>
  80062f:	83 c4 18             	add    $0x18,%esp
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	89 f2                	mov    %esi,%edx
  800636:	89 f8                	mov    %edi,%eax
  800638:	e8 85 ff ff ff       	call   8005c2 <printnum>
  80063d:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	56                   	push   %esi
  800644:	83 ec 04             	sub    $0x4,%esp
  800647:	ff 75 e4             	pushl  -0x1c(%ebp)
  80064a:	ff 75 e0             	pushl  -0x20(%ebp)
  80064d:	ff 75 dc             	pushl  -0x24(%ebp)
  800650:	ff 75 d8             	pushl  -0x28(%ebp)
  800653:	e8 48 1f 00 00       	call   8025a0 <__umoddi3>
  800658:	83 c4 14             	add    $0x14,%esp
  80065b:	0f be 80 f6 27 80 00 	movsbl 0x8027f6(%eax),%eax
  800662:	50                   	push   %eax
  800663:	ff d7                	call   *%edi
}
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80066b:	5b                   	pop    %ebx
  80066c:	5e                   	pop    %esi
  80066d:	5f                   	pop    %edi
  80066e:	5d                   	pop    %ebp
  80066f:	c3                   	ret    

00800670 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800670:	55                   	push   %ebp
  800671:	89 e5                	mov    %esp,%ebp
  800673:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800676:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80067a:	8b 10                	mov    (%eax),%edx
  80067c:	3b 50 04             	cmp    0x4(%eax),%edx
  80067f:	73 0a                	jae    80068b <sprintputch+0x1b>
		*b->buf++ = ch;
  800681:	8d 4a 01             	lea    0x1(%edx),%ecx
  800684:	89 08                	mov    %ecx,(%eax)
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	88 02                	mov    %al,(%edx)
}
  80068b:	5d                   	pop    %ebp
  80068c:	c3                   	ret    

0080068d <printfmt>:
{
  80068d:	55                   	push   %ebp
  80068e:	89 e5                	mov    %esp,%ebp
  800690:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800693:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800696:	50                   	push   %eax
  800697:	ff 75 10             	pushl  0x10(%ebp)
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	ff 75 08             	pushl  0x8(%ebp)
  8006a0:	e8 05 00 00 00       	call   8006aa <vprintfmt>
}
  8006a5:	83 c4 10             	add    $0x10,%esp
  8006a8:	c9                   	leave  
  8006a9:	c3                   	ret    

008006aa <vprintfmt>:
{
  8006aa:	55                   	push   %ebp
  8006ab:	89 e5                	mov    %esp,%ebp
  8006ad:	57                   	push   %edi
  8006ae:	56                   	push   %esi
  8006af:	53                   	push   %ebx
  8006b0:	83 ec 3c             	sub    $0x3c,%esp
  8006b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8006b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006b9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006bc:	eb 0a                	jmp    8006c8 <vprintfmt+0x1e>
			putch(ch, putdat);
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	53                   	push   %ebx
  8006c2:	50                   	push   %eax
  8006c3:	ff d6                	call   *%esi
  8006c5:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c8:	83 c7 01             	add    $0x1,%edi
  8006cb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006cf:	83 f8 25             	cmp    $0x25,%eax
  8006d2:	74 0c                	je     8006e0 <vprintfmt+0x36>
			if (ch == '\0')
  8006d4:	85 c0                	test   %eax,%eax
  8006d6:	75 e6                	jne    8006be <vprintfmt+0x14>
}
  8006d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006db:	5b                   	pop    %ebx
  8006dc:	5e                   	pop    %esi
  8006dd:	5f                   	pop    %edi
  8006de:	5d                   	pop    %ebp
  8006df:	c3                   	ret    
		padc = ' ';
  8006e0:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8006e4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8006eb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8006f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006f9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006fe:	8d 47 01             	lea    0x1(%edi),%eax
  800701:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800704:	0f b6 17             	movzbl (%edi),%edx
  800707:	8d 42 dd             	lea    -0x23(%edx),%eax
  80070a:	3c 55                	cmp    $0x55,%al
  80070c:	0f 87 ba 03 00 00    	ja     800acc <vprintfmt+0x422>
  800712:	0f b6 c0             	movzbl %al,%eax
  800715:	ff 24 85 40 29 80 00 	jmp    *0x802940(,%eax,4)
  80071c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80071f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800723:	eb d9                	jmp    8006fe <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800725:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800728:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80072c:	eb d0                	jmp    8006fe <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80072e:	0f b6 d2             	movzbl %dl,%edx
  800731:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800734:	b8 00 00 00 00       	mov    $0x0,%eax
  800739:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80073c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80073f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800743:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800746:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800749:	83 f9 09             	cmp    $0x9,%ecx
  80074c:	77 55                	ja     8007a3 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80074e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800751:	eb e9                	jmp    80073c <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8d 40 04             	lea    0x4(%eax),%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800764:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800767:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80076b:	79 91                	jns    8006fe <vprintfmt+0x54>
				width = precision, precision = -1;
  80076d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800770:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800773:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80077a:	eb 82                	jmp    8006fe <vprintfmt+0x54>
  80077c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80077f:	85 c0                	test   %eax,%eax
  800781:	ba 00 00 00 00       	mov    $0x0,%edx
  800786:	0f 49 d0             	cmovns %eax,%edx
  800789:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80078c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80078f:	e9 6a ff ff ff       	jmp    8006fe <vprintfmt+0x54>
  800794:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800797:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80079e:	e9 5b ff ff ff       	jmp    8006fe <vprintfmt+0x54>
  8007a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a9:	eb bc                	jmp    800767 <vprintfmt+0xbd>
			lflag++;
  8007ab:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007b1:	e9 48 ff ff ff       	jmp    8006fe <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8d 78 04             	lea    0x4(%eax),%edi
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	53                   	push   %ebx
  8007c0:	ff 30                	pushl  (%eax)
  8007c2:	ff d6                	call   *%esi
			break;
  8007c4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007c7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007ca:	e9 9c 02 00 00       	jmp    800a6b <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8d 78 04             	lea    0x4(%eax),%edi
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	99                   	cltd   
  8007d8:	31 d0                	xor    %edx,%eax
  8007da:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007dc:	83 f8 0f             	cmp    $0xf,%eax
  8007df:	7f 23                	jg     800804 <vprintfmt+0x15a>
  8007e1:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  8007e8:	85 d2                	test   %edx,%edx
  8007ea:	74 18                	je     800804 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8007ec:	52                   	push   %edx
  8007ed:	68 da 2b 80 00       	push   $0x802bda
  8007f2:	53                   	push   %ebx
  8007f3:	56                   	push   %esi
  8007f4:	e8 94 fe ff ff       	call   80068d <printfmt>
  8007f9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007fc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007ff:	e9 67 02 00 00       	jmp    800a6b <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800804:	50                   	push   %eax
  800805:	68 0e 28 80 00       	push   $0x80280e
  80080a:	53                   	push   %ebx
  80080b:	56                   	push   %esi
  80080c:	e8 7c fe ff ff       	call   80068d <printfmt>
  800811:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800814:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800817:	e9 4f 02 00 00       	jmp    800a6b <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 c0 04             	add    $0x4,%eax
  800822:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80082a:	85 d2                	test   %edx,%edx
  80082c:	b8 07 28 80 00       	mov    $0x802807,%eax
  800831:	0f 45 c2             	cmovne %edx,%eax
  800834:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800837:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80083b:	7e 06                	jle    800843 <vprintfmt+0x199>
  80083d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800841:	75 0d                	jne    800850 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800843:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800846:	89 c7                	mov    %eax,%edi
  800848:	03 45 e0             	add    -0x20(%ebp),%eax
  80084b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80084e:	eb 3f                	jmp    80088f <vprintfmt+0x1e5>
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 d8             	pushl  -0x28(%ebp)
  800856:	50                   	push   %eax
  800857:	e8 0d 03 00 00       	call   800b69 <strnlen>
  80085c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80085f:	29 c2                	sub    %eax,%edx
  800861:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800864:	83 c4 10             	add    $0x10,%esp
  800867:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800869:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80086d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800870:	85 ff                	test   %edi,%edi
  800872:	7e 58                	jle    8008cc <vprintfmt+0x222>
					putch(padc, putdat);
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	53                   	push   %ebx
  800878:	ff 75 e0             	pushl  -0x20(%ebp)
  80087b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80087d:	83 ef 01             	sub    $0x1,%edi
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	eb eb                	jmp    800870 <vprintfmt+0x1c6>
					putch(ch, putdat);
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	53                   	push   %ebx
  800889:	52                   	push   %edx
  80088a:	ff d6                	call   *%esi
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800892:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800894:	83 c7 01             	add    $0x1,%edi
  800897:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80089b:	0f be d0             	movsbl %al,%edx
  80089e:	85 d2                	test   %edx,%edx
  8008a0:	74 45                	je     8008e7 <vprintfmt+0x23d>
  8008a2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008a6:	78 06                	js     8008ae <vprintfmt+0x204>
  8008a8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008ac:	78 35                	js     8008e3 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ae:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008b2:	74 d1                	je     800885 <vprintfmt+0x1db>
  8008b4:	0f be c0             	movsbl %al,%eax
  8008b7:	83 e8 20             	sub    $0x20,%eax
  8008ba:	83 f8 5e             	cmp    $0x5e,%eax
  8008bd:	76 c6                	jbe    800885 <vprintfmt+0x1db>
					putch('?', putdat);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	53                   	push   %ebx
  8008c3:	6a 3f                	push   $0x3f
  8008c5:	ff d6                	call   *%esi
  8008c7:	83 c4 10             	add    $0x10,%esp
  8008ca:	eb c3                	jmp    80088f <vprintfmt+0x1e5>
  8008cc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008cf:	85 d2                	test   %edx,%edx
  8008d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d6:	0f 49 c2             	cmovns %edx,%eax
  8008d9:	29 c2                	sub    %eax,%edx
  8008db:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8008de:	e9 60 ff ff ff       	jmp    800843 <vprintfmt+0x199>
  8008e3:	89 cf                	mov    %ecx,%edi
  8008e5:	eb 02                	jmp    8008e9 <vprintfmt+0x23f>
  8008e7:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8008e9:	85 ff                	test   %edi,%edi
  8008eb:	7e 10                	jle    8008fd <vprintfmt+0x253>
				putch(' ', putdat);
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	53                   	push   %ebx
  8008f1:	6a 20                	push   $0x20
  8008f3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8008f5:	83 ef 01             	sub    $0x1,%edi
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	eb ec                	jmp    8008e9 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8008fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800900:	89 45 14             	mov    %eax,0x14(%ebp)
  800903:	e9 63 01 00 00       	jmp    800a6b <vprintfmt+0x3c1>
	if (lflag >= 2)
  800908:	83 f9 01             	cmp    $0x1,%ecx
  80090b:	7f 1b                	jg     800928 <vprintfmt+0x27e>
	else if (lflag)
  80090d:	85 c9                	test   %ecx,%ecx
  80090f:	74 63                	je     800974 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	8b 00                	mov    (%eax),%eax
  800916:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800919:	99                   	cltd   
  80091a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8d 40 04             	lea    0x4(%eax),%eax
  800923:	89 45 14             	mov    %eax,0x14(%ebp)
  800926:	eb 17                	jmp    80093f <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8b 50 04             	mov    0x4(%eax),%edx
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800933:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800936:	8b 45 14             	mov    0x14(%ebp),%eax
  800939:	8d 40 08             	lea    0x8(%eax),%eax
  80093c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80093f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800942:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800945:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80094a:	85 c9                	test   %ecx,%ecx
  80094c:	0f 89 ff 00 00 00    	jns    800a51 <vprintfmt+0x3a7>
				putch('-', putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	53                   	push   %ebx
  800956:	6a 2d                	push   $0x2d
  800958:	ff d6                	call   *%esi
				num = -(long long) num;
  80095a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80095d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800960:	f7 da                	neg    %edx
  800962:	83 d1 00             	adc    $0x0,%ecx
  800965:	f7 d9                	neg    %ecx
  800967:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80096a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80096f:	e9 dd 00 00 00       	jmp    800a51 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	8b 00                	mov    (%eax),%eax
  800979:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097c:	99                   	cltd   
  80097d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	8d 40 04             	lea    0x4(%eax),%eax
  800986:	89 45 14             	mov    %eax,0x14(%ebp)
  800989:	eb b4                	jmp    80093f <vprintfmt+0x295>
	if (lflag >= 2)
  80098b:	83 f9 01             	cmp    $0x1,%ecx
  80098e:	7f 1e                	jg     8009ae <vprintfmt+0x304>
	else if (lflag)
  800990:	85 c9                	test   %ecx,%ecx
  800992:	74 32                	je     8009c6 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800994:	8b 45 14             	mov    0x14(%ebp),%eax
  800997:	8b 10                	mov    (%eax),%edx
  800999:	b9 00 00 00 00       	mov    $0x0,%ecx
  80099e:	8d 40 04             	lea    0x4(%eax),%eax
  8009a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009a9:	e9 a3 00 00 00       	jmp    800a51 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8009ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b1:	8b 10                	mov    (%eax),%edx
  8009b3:	8b 48 04             	mov    0x4(%eax),%ecx
  8009b6:	8d 40 08             	lea    0x8(%eax),%eax
  8009b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009bc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009c1:	e9 8b 00 00 00       	jmp    800a51 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	8b 10                	mov    (%eax),%edx
  8009cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009d0:	8d 40 04             	lea    0x4(%eax),%eax
  8009d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009d6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009db:	eb 74                	jmp    800a51 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8009dd:	83 f9 01             	cmp    $0x1,%ecx
  8009e0:	7f 1b                	jg     8009fd <vprintfmt+0x353>
	else if (lflag)
  8009e2:	85 c9                	test   %ecx,%ecx
  8009e4:	74 2c                	je     800a12 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8009e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e9:	8b 10                	mov    (%eax),%edx
  8009eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009f0:	8d 40 04             	lea    0x4(%eax),%eax
  8009f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009f6:	b8 08 00 00 00       	mov    $0x8,%eax
  8009fb:	eb 54                	jmp    800a51 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8009fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800a00:	8b 10                	mov    (%eax),%edx
  800a02:	8b 48 04             	mov    0x4(%eax),%ecx
  800a05:	8d 40 08             	lea    0x8(%eax),%eax
  800a08:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a0b:	b8 08 00 00 00       	mov    $0x8,%eax
  800a10:	eb 3f                	jmp    800a51 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800a12:	8b 45 14             	mov    0x14(%ebp),%eax
  800a15:	8b 10                	mov    (%eax),%edx
  800a17:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a1c:	8d 40 04             	lea    0x4(%eax),%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a22:	b8 08 00 00 00       	mov    $0x8,%eax
  800a27:	eb 28                	jmp    800a51 <vprintfmt+0x3a7>
			putch('0', putdat);
  800a29:	83 ec 08             	sub    $0x8,%esp
  800a2c:	53                   	push   %ebx
  800a2d:	6a 30                	push   $0x30
  800a2f:	ff d6                	call   *%esi
			putch('x', putdat);
  800a31:	83 c4 08             	add    $0x8,%esp
  800a34:	53                   	push   %ebx
  800a35:	6a 78                	push   $0x78
  800a37:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	8b 10                	mov    (%eax),%edx
  800a3e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a43:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a46:	8d 40 04             	lea    0x4(%eax),%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a4c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a51:	83 ec 0c             	sub    $0xc,%esp
  800a54:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800a58:	57                   	push   %edi
  800a59:	ff 75 e0             	pushl  -0x20(%ebp)
  800a5c:	50                   	push   %eax
  800a5d:	51                   	push   %ecx
  800a5e:	52                   	push   %edx
  800a5f:	89 da                	mov    %ebx,%edx
  800a61:	89 f0                	mov    %esi,%eax
  800a63:	e8 5a fb ff ff       	call   8005c2 <printnum>
			break;
  800a68:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a6b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a6e:	e9 55 fc ff ff       	jmp    8006c8 <vprintfmt+0x1e>
	if (lflag >= 2)
  800a73:	83 f9 01             	cmp    $0x1,%ecx
  800a76:	7f 1b                	jg     800a93 <vprintfmt+0x3e9>
	else if (lflag)
  800a78:	85 c9                	test   %ecx,%ecx
  800a7a:	74 2c                	je     800aa8 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	8b 10                	mov    (%eax),%edx
  800a81:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a86:	8d 40 04             	lea    0x4(%eax),%eax
  800a89:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a8c:	b8 10 00 00 00       	mov    $0x10,%eax
  800a91:	eb be                	jmp    800a51 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800a93:	8b 45 14             	mov    0x14(%ebp),%eax
  800a96:	8b 10                	mov    (%eax),%edx
  800a98:	8b 48 04             	mov    0x4(%eax),%ecx
  800a9b:	8d 40 08             	lea    0x8(%eax),%eax
  800a9e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aa1:	b8 10 00 00 00       	mov    $0x10,%eax
  800aa6:	eb a9                	jmp    800a51 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aab:	8b 10                	mov    (%eax),%edx
  800aad:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ab2:	8d 40 04             	lea    0x4(%eax),%eax
  800ab5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ab8:	b8 10 00 00 00       	mov    $0x10,%eax
  800abd:	eb 92                	jmp    800a51 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	53                   	push   %ebx
  800ac3:	6a 25                	push   $0x25
  800ac5:	ff d6                	call   *%esi
			break;
  800ac7:	83 c4 10             	add    $0x10,%esp
  800aca:	eb 9f                	jmp    800a6b <vprintfmt+0x3c1>
			putch('%', putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	53                   	push   %ebx
  800ad0:	6a 25                	push   $0x25
  800ad2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 f8                	mov    %edi,%eax
  800ad9:	eb 03                	jmp    800ade <vprintfmt+0x434>
  800adb:	83 e8 01             	sub    $0x1,%eax
  800ade:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ae2:	75 f7                	jne    800adb <vprintfmt+0x431>
  800ae4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ae7:	eb 82                	jmp    800a6b <vprintfmt+0x3c1>

00800ae9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	83 ec 18             	sub    $0x18,%esp
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800af5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800af8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800afc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800aff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b06:	85 c0                	test   %eax,%eax
  800b08:	74 26                	je     800b30 <vsnprintf+0x47>
  800b0a:	85 d2                	test   %edx,%edx
  800b0c:	7e 22                	jle    800b30 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b0e:	ff 75 14             	pushl  0x14(%ebp)
  800b11:	ff 75 10             	pushl  0x10(%ebp)
  800b14:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b17:	50                   	push   %eax
  800b18:	68 70 06 80 00       	push   $0x800670
  800b1d:	e8 88 fb ff ff       	call   8006aa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b25:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
}
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    
		return -E_INVAL;
  800b30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b35:	eb f7                	jmp    800b2e <vsnprintf+0x45>

00800b37 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b3d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b40:	50                   	push   %eax
  800b41:	ff 75 10             	pushl  0x10(%ebp)
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	ff 75 08             	pushl  0x8(%ebp)
  800b4a:	e8 9a ff ff ff       	call   800ae9 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b57:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b60:	74 05                	je     800b67 <strlen+0x16>
		n++;
  800b62:	83 c0 01             	add    $0x1,%eax
  800b65:	eb f5                	jmp    800b5c <strlen+0xb>
	return n;
}
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b72:	ba 00 00 00 00       	mov    $0x0,%edx
  800b77:	39 c2                	cmp    %eax,%edx
  800b79:	74 0d                	je     800b88 <strnlen+0x1f>
  800b7b:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b7f:	74 05                	je     800b86 <strnlen+0x1d>
		n++;
  800b81:	83 c2 01             	add    $0x1,%edx
  800b84:	eb f1                	jmp    800b77 <strnlen+0xe>
  800b86:	89 d0                	mov    %edx,%eax
	return n;
}
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b94:	ba 00 00 00 00       	mov    $0x0,%edx
  800b99:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b9d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ba0:	83 c2 01             	add    $0x1,%edx
  800ba3:	84 c9                	test   %cl,%cl
  800ba5:	75 f2                	jne    800b99 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ba7:	5b                   	pop    %ebx
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <strcat>:

char *
strcat(char *dst, const char *src)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	53                   	push   %ebx
  800bae:	83 ec 10             	sub    $0x10,%esp
  800bb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bb4:	53                   	push   %ebx
  800bb5:	e8 97 ff ff ff       	call   800b51 <strlen>
  800bba:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bbd:	ff 75 0c             	pushl  0xc(%ebp)
  800bc0:	01 d8                	add    %ebx,%eax
  800bc2:	50                   	push   %eax
  800bc3:	e8 c2 ff ff ff       	call   800b8a <strcpy>
	return dst;
}
  800bc8:	89 d8                	mov    %ebx,%eax
  800bca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bcd:	c9                   	leave  
  800bce:	c3                   	ret    

00800bcf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bda:	89 c6                	mov    %eax,%esi
  800bdc:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bdf:	89 c2                	mov    %eax,%edx
  800be1:	39 f2                	cmp    %esi,%edx
  800be3:	74 11                	je     800bf6 <strncpy+0x27>
		*dst++ = *src;
  800be5:	83 c2 01             	add    $0x1,%edx
  800be8:	0f b6 19             	movzbl (%ecx),%ebx
  800beb:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bee:	80 fb 01             	cmp    $0x1,%bl
  800bf1:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bf4:	eb eb                	jmp    800be1 <strncpy+0x12>
	}
	return ret;
}
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	56                   	push   %esi
  800bfe:	53                   	push   %ebx
  800bff:	8b 75 08             	mov    0x8(%ebp),%esi
  800c02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c05:	8b 55 10             	mov    0x10(%ebp),%edx
  800c08:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c0a:	85 d2                	test   %edx,%edx
  800c0c:	74 21                	je     800c2f <strlcpy+0x35>
  800c0e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c12:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c14:	39 c2                	cmp    %eax,%edx
  800c16:	74 14                	je     800c2c <strlcpy+0x32>
  800c18:	0f b6 19             	movzbl (%ecx),%ebx
  800c1b:	84 db                	test   %bl,%bl
  800c1d:	74 0b                	je     800c2a <strlcpy+0x30>
			*dst++ = *src++;
  800c1f:	83 c1 01             	add    $0x1,%ecx
  800c22:	83 c2 01             	add    $0x1,%edx
  800c25:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c28:	eb ea                	jmp    800c14 <strlcpy+0x1a>
  800c2a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c2c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c2f:	29 f0                	sub    %esi,%eax
}
  800c31:	5b                   	pop    %ebx
  800c32:	5e                   	pop    %esi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c3e:	0f b6 01             	movzbl (%ecx),%eax
  800c41:	84 c0                	test   %al,%al
  800c43:	74 0c                	je     800c51 <strcmp+0x1c>
  800c45:	3a 02                	cmp    (%edx),%al
  800c47:	75 08                	jne    800c51 <strcmp+0x1c>
		p++, q++;
  800c49:	83 c1 01             	add    $0x1,%ecx
  800c4c:	83 c2 01             	add    $0x1,%edx
  800c4f:	eb ed                	jmp    800c3e <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c51:	0f b6 c0             	movzbl %al,%eax
  800c54:	0f b6 12             	movzbl (%edx),%edx
  800c57:	29 d0                	sub    %edx,%eax
}
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	53                   	push   %ebx
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c65:	89 c3                	mov    %eax,%ebx
  800c67:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c6a:	eb 06                	jmp    800c72 <strncmp+0x17>
		n--, p++, q++;
  800c6c:	83 c0 01             	add    $0x1,%eax
  800c6f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c72:	39 d8                	cmp    %ebx,%eax
  800c74:	74 16                	je     800c8c <strncmp+0x31>
  800c76:	0f b6 08             	movzbl (%eax),%ecx
  800c79:	84 c9                	test   %cl,%cl
  800c7b:	74 04                	je     800c81 <strncmp+0x26>
  800c7d:	3a 0a                	cmp    (%edx),%cl
  800c7f:	74 eb                	je     800c6c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c81:	0f b6 00             	movzbl (%eax),%eax
  800c84:	0f b6 12             	movzbl (%edx),%edx
  800c87:	29 d0                	sub    %edx,%eax
}
  800c89:	5b                   	pop    %ebx
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    
		return 0;
  800c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c91:	eb f6                	jmp    800c89 <strncmp+0x2e>

00800c93 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c9d:	0f b6 10             	movzbl (%eax),%edx
  800ca0:	84 d2                	test   %dl,%dl
  800ca2:	74 09                	je     800cad <strchr+0x1a>
		if (*s == c)
  800ca4:	38 ca                	cmp    %cl,%dl
  800ca6:	74 0a                	je     800cb2 <strchr+0x1f>
	for (; *s; s++)
  800ca8:	83 c0 01             	add    $0x1,%eax
  800cab:	eb f0                	jmp    800c9d <strchr+0xa>
			return (char *) s;
	return 0;
  800cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cbe:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cc1:	38 ca                	cmp    %cl,%dl
  800cc3:	74 09                	je     800cce <strfind+0x1a>
  800cc5:	84 d2                	test   %dl,%dl
  800cc7:	74 05                	je     800cce <strfind+0x1a>
	for (; *s; s++)
  800cc9:	83 c0 01             	add    $0x1,%eax
  800ccc:	eb f0                	jmp    800cbe <strfind+0xa>
			break;
	return (char *) s;
}
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	57                   	push   %edi
  800cd4:	56                   	push   %esi
  800cd5:	53                   	push   %ebx
  800cd6:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cd9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cdc:	85 c9                	test   %ecx,%ecx
  800cde:	74 31                	je     800d11 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ce0:	89 f8                	mov    %edi,%eax
  800ce2:	09 c8                	or     %ecx,%eax
  800ce4:	a8 03                	test   $0x3,%al
  800ce6:	75 23                	jne    800d0b <memset+0x3b>
		c &= 0xFF;
  800ce8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cec:	89 d3                	mov    %edx,%ebx
  800cee:	c1 e3 08             	shl    $0x8,%ebx
  800cf1:	89 d0                	mov    %edx,%eax
  800cf3:	c1 e0 18             	shl    $0x18,%eax
  800cf6:	89 d6                	mov    %edx,%esi
  800cf8:	c1 e6 10             	shl    $0x10,%esi
  800cfb:	09 f0                	or     %esi,%eax
  800cfd:	09 c2                	or     %eax,%edx
  800cff:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d01:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d04:	89 d0                	mov    %edx,%eax
  800d06:	fc                   	cld    
  800d07:	f3 ab                	rep stos %eax,%es:(%edi)
  800d09:	eb 06                	jmp    800d11 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	fc                   	cld    
  800d0f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d11:	89 f8                	mov    %edi,%eax
  800d13:	5b                   	pop    %ebx
  800d14:	5e                   	pop    %esi
  800d15:	5f                   	pop    %edi
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    

00800d18 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	57                   	push   %edi
  800d1c:	56                   	push   %esi
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d23:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d26:	39 c6                	cmp    %eax,%esi
  800d28:	73 32                	jae    800d5c <memmove+0x44>
  800d2a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d2d:	39 c2                	cmp    %eax,%edx
  800d2f:	76 2b                	jbe    800d5c <memmove+0x44>
		s += n;
		d += n;
  800d31:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d34:	89 fe                	mov    %edi,%esi
  800d36:	09 ce                	or     %ecx,%esi
  800d38:	09 d6                	or     %edx,%esi
  800d3a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d40:	75 0e                	jne    800d50 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d42:	83 ef 04             	sub    $0x4,%edi
  800d45:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d48:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d4b:	fd                   	std    
  800d4c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d4e:	eb 09                	jmp    800d59 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d50:	83 ef 01             	sub    $0x1,%edi
  800d53:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d56:	fd                   	std    
  800d57:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d59:	fc                   	cld    
  800d5a:	eb 1a                	jmp    800d76 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d5c:	89 c2                	mov    %eax,%edx
  800d5e:	09 ca                	or     %ecx,%edx
  800d60:	09 f2                	or     %esi,%edx
  800d62:	f6 c2 03             	test   $0x3,%dl
  800d65:	75 0a                	jne    800d71 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d67:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d6a:	89 c7                	mov    %eax,%edi
  800d6c:	fc                   	cld    
  800d6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d6f:	eb 05                	jmp    800d76 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d71:	89 c7                	mov    %eax,%edi
  800d73:	fc                   	cld    
  800d74:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d76:	5e                   	pop    %esi
  800d77:	5f                   	pop    %edi
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d80:	ff 75 10             	pushl  0x10(%ebp)
  800d83:	ff 75 0c             	pushl  0xc(%ebp)
  800d86:	ff 75 08             	pushl  0x8(%ebp)
  800d89:	e8 8a ff ff ff       	call   800d18 <memmove>
}
  800d8e:	c9                   	leave  
  800d8f:	c3                   	ret    

00800d90 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	56                   	push   %esi
  800d94:	53                   	push   %ebx
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9b:	89 c6                	mov    %eax,%esi
  800d9d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800da0:	39 f0                	cmp    %esi,%eax
  800da2:	74 1c                	je     800dc0 <memcmp+0x30>
		if (*s1 != *s2)
  800da4:	0f b6 08             	movzbl (%eax),%ecx
  800da7:	0f b6 1a             	movzbl (%edx),%ebx
  800daa:	38 d9                	cmp    %bl,%cl
  800dac:	75 08                	jne    800db6 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dae:	83 c0 01             	add    $0x1,%eax
  800db1:	83 c2 01             	add    $0x1,%edx
  800db4:	eb ea                	jmp    800da0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800db6:	0f b6 c1             	movzbl %cl,%eax
  800db9:	0f b6 db             	movzbl %bl,%ebx
  800dbc:	29 d8                	sub    %ebx,%eax
  800dbe:	eb 05                	jmp    800dc5 <memcmp+0x35>
	}

	return 0;
  800dc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    

00800dc9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dd2:	89 c2                	mov    %eax,%edx
  800dd4:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dd7:	39 d0                	cmp    %edx,%eax
  800dd9:	73 09                	jae    800de4 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ddb:	38 08                	cmp    %cl,(%eax)
  800ddd:	74 05                	je     800de4 <memfind+0x1b>
	for (; s < ends; s++)
  800ddf:	83 c0 01             	add    $0x1,%eax
  800de2:	eb f3                	jmp    800dd7 <memfind+0xe>
			break;
	return (void *) s;
}
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	57                   	push   %edi
  800dea:	56                   	push   %esi
  800deb:	53                   	push   %ebx
  800dec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800def:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df2:	eb 03                	jmp    800df7 <strtol+0x11>
		s++;
  800df4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800df7:	0f b6 01             	movzbl (%ecx),%eax
  800dfa:	3c 20                	cmp    $0x20,%al
  800dfc:	74 f6                	je     800df4 <strtol+0xe>
  800dfe:	3c 09                	cmp    $0x9,%al
  800e00:	74 f2                	je     800df4 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e02:	3c 2b                	cmp    $0x2b,%al
  800e04:	74 2a                	je     800e30 <strtol+0x4a>
	int neg = 0;
  800e06:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e0b:	3c 2d                	cmp    $0x2d,%al
  800e0d:	74 2b                	je     800e3a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e0f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e15:	75 0f                	jne    800e26 <strtol+0x40>
  800e17:	80 39 30             	cmpb   $0x30,(%ecx)
  800e1a:	74 28                	je     800e44 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e1c:	85 db                	test   %ebx,%ebx
  800e1e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e23:	0f 44 d8             	cmove  %eax,%ebx
  800e26:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e2e:	eb 50                	jmp    800e80 <strtol+0x9a>
		s++;
  800e30:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e33:	bf 00 00 00 00       	mov    $0x0,%edi
  800e38:	eb d5                	jmp    800e0f <strtol+0x29>
		s++, neg = 1;
  800e3a:	83 c1 01             	add    $0x1,%ecx
  800e3d:	bf 01 00 00 00       	mov    $0x1,%edi
  800e42:	eb cb                	jmp    800e0f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e44:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e48:	74 0e                	je     800e58 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e4a:	85 db                	test   %ebx,%ebx
  800e4c:	75 d8                	jne    800e26 <strtol+0x40>
		s++, base = 8;
  800e4e:	83 c1 01             	add    $0x1,%ecx
  800e51:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e56:	eb ce                	jmp    800e26 <strtol+0x40>
		s += 2, base = 16;
  800e58:	83 c1 02             	add    $0x2,%ecx
  800e5b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e60:	eb c4                	jmp    800e26 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e62:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e65:	89 f3                	mov    %esi,%ebx
  800e67:	80 fb 19             	cmp    $0x19,%bl
  800e6a:	77 29                	ja     800e95 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e6c:	0f be d2             	movsbl %dl,%edx
  800e6f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e72:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e75:	7d 30                	jge    800ea7 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e77:	83 c1 01             	add    $0x1,%ecx
  800e7a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e7e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e80:	0f b6 11             	movzbl (%ecx),%edx
  800e83:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e86:	89 f3                	mov    %esi,%ebx
  800e88:	80 fb 09             	cmp    $0x9,%bl
  800e8b:	77 d5                	ja     800e62 <strtol+0x7c>
			dig = *s - '0';
  800e8d:	0f be d2             	movsbl %dl,%edx
  800e90:	83 ea 30             	sub    $0x30,%edx
  800e93:	eb dd                	jmp    800e72 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e95:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e98:	89 f3                	mov    %esi,%ebx
  800e9a:	80 fb 19             	cmp    $0x19,%bl
  800e9d:	77 08                	ja     800ea7 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e9f:	0f be d2             	movsbl %dl,%edx
  800ea2:	83 ea 37             	sub    $0x37,%edx
  800ea5:	eb cb                	jmp    800e72 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ea7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eab:	74 05                	je     800eb2 <strtol+0xcc>
		*endptr = (char *) s;
  800ead:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eb0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800eb2:	89 c2                	mov    %eax,%edx
  800eb4:	f7 da                	neg    %edx
  800eb6:	85 ff                	test   %edi,%edi
  800eb8:	0f 45 c2             	cmovne %edx,%eax
}
  800ebb:	5b                   	pop    %ebx
  800ebc:	5e                   	pop    %esi
  800ebd:	5f                   	pop    %edi
  800ebe:	5d                   	pop    %ebp
  800ebf:	c3                   	ret    

00800ec0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	57                   	push   %edi
  800ec4:	56                   	push   %esi
  800ec5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ece:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed1:	89 c3                	mov    %eax,%ebx
  800ed3:	89 c7                	mov    %eax,%edi
  800ed5:	89 c6                	mov    %eax,%esi
  800ed7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ed9:	5b                   	pop    %ebx
  800eda:	5e                   	pop    %esi
  800edb:	5f                   	pop    %edi
  800edc:	5d                   	pop    %ebp
  800edd:	c3                   	ret    

00800ede <sys_cgetc>:

int
sys_cgetc(void)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	57                   	push   %edi
  800ee2:	56                   	push   %esi
  800ee3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee9:	b8 01 00 00 00       	mov    $0x1,%eax
  800eee:	89 d1                	mov    %edx,%ecx
  800ef0:	89 d3                	mov    %edx,%ebx
  800ef2:	89 d7                	mov    %edx,%edi
  800ef4:	89 d6                	mov    %edx,%esi
  800ef6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
  800f03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f06:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0e:	b8 03 00 00 00       	mov    $0x3,%eax
  800f13:	89 cb                	mov    %ecx,%ebx
  800f15:	89 cf                	mov    %ecx,%edi
  800f17:	89 ce                	mov    %ecx,%esi
  800f19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1b:	85 c0                	test   %eax,%eax
  800f1d:	7f 08                	jg     800f27 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5f                   	pop    %edi
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f27:	83 ec 0c             	sub    $0xc,%esp
  800f2a:	50                   	push   %eax
  800f2b:	6a 03                	push   $0x3
  800f2d:	68 ff 2a 80 00       	push   $0x802aff
  800f32:	6a 23                	push   $0x23
  800f34:	68 1c 2b 80 00       	push   $0x802b1c
  800f39:	e8 b1 13 00 00       	call   8022ef <_panic>

00800f3e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	57                   	push   %edi
  800f42:	56                   	push   %esi
  800f43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f44:	ba 00 00 00 00       	mov    $0x0,%edx
  800f49:	b8 02 00 00 00       	mov    $0x2,%eax
  800f4e:	89 d1                	mov    %edx,%ecx
  800f50:	89 d3                	mov    %edx,%ebx
  800f52:	89 d7                	mov    %edx,%edi
  800f54:	89 d6                	mov    %edx,%esi
  800f56:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f58:	5b                   	pop    %ebx
  800f59:	5e                   	pop    %esi
  800f5a:	5f                   	pop    %edi
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    

00800f5d <sys_yield>:

void
sys_yield(void)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	57                   	push   %edi
  800f61:	56                   	push   %esi
  800f62:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f63:	ba 00 00 00 00       	mov    $0x0,%edx
  800f68:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f6d:	89 d1                	mov    %edx,%ecx
  800f6f:	89 d3                	mov    %edx,%ebx
  800f71:	89 d7                	mov    %edx,%edi
  800f73:	89 d6                	mov    %edx,%esi
  800f75:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
  800f82:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f85:	be 00 00 00 00       	mov    $0x0,%esi
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f90:	b8 04 00 00 00       	mov    $0x4,%eax
  800f95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f98:	89 f7                	mov    %esi,%edi
  800f9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9c:	85 c0                	test   %eax,%eax
  800f9e:	7f 08                	jg     800fa8 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5f                   	pop    %edi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa8:	83 ec 0c             	sub    $0xc,%esp
  800fab:	50                   	push   %eax
  800fac:	6a 04                	push   $0x4
  800fae:	68 ff 2a 80 00       	push   $0x802aff
  800fb3:	6a 23                	push   $0x23
  800fb5:	68 1c 2b 80 00       	push   $0x802b1c
  800fba:	e8 30 13 00 00       	call   8022ef <_panic>

00800fbf <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	57                   	push   %edi
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
  800fc5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fce:	b8 05 00 00 00       	mov    $0x5,%eax
  800fd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd9:	8b 75 18             	mov    0x18(%ebp),%esi
  800fdc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fde:	85 c0                	test   %eax,%eax
  800fe0:	7f 08                	jg     800fea <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fe2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe5:	5b                   	pop    %ebx
  800fe6:	5e                   	pop    %esi
  800fe7:	5f                   	pop    %edi
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fea:	83 ec 0c             	sub    $0xc,%esp
  800fed:	50                   	push   %eax
  800fee:	6a 05                	push   $0x5
  800ff0:	68 ff 2a 80 00       	push   $0x802aff
  800ff5:	6a 23                	push   $0x23
  800ff7:	68 1c 2b 80 00       	push   $0x802b1c
  800ffc:	e8 ee 12 00 00       	call   8022ef <_panic>

00801001 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	57                   	push   %edi
  801005:	56                   	push   %esi
  801006:	53                   	push   %ebx
  801007:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80100a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100f:	8b 55 08             	mov    0x8(%ebp),%edx
  801012:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801015:	b8 06 00 00 00       	mov    $0x6,%eax
  80101a:	89 df                	mov    %ebx,%edi
  80101c:	89 de                	mov    %ebx,%esi
  80101e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801020:	85 c0                	test   %eax,%eax
  801022:	7f 08                	jg     80102c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801024:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801027:	5b                   	pop    %ebx
  801028:	5e                   	pop    %esi
  801029:	5f                   	pop    %edi
  80102a:	5d                   	pop    %ebp
  80102b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80102c:	83 ec 0c             	sub    $0xc,%esp
  80102f:	50                   	push   %eax
  801030:	6a 06                	push   $0x6
  801032:	68 ff 2a 80 00       	push   $0x802aff
  801037:	6a 23                	push   $0x23
  801039:	68 1c 2b 80 00       	push   $0x802b1c
  80103e:	e8 ac 12 00 00       	call   8022ef <_panic>

00801043 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	57                   	push   %edi
  801047:	56                   	push   %esi
  801048:	53                   	push   %ebx
  801049:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801051:	8b 55 08             	mov    0x8(%ebp),%edx
  801054:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801057:	b8 08 00 00 00       	mov    $0x8,%eax
  80105c:	89 df                	mov    %ebx,%edi
  80105e:	89 de                	mov    %ebx,%esi
  801060:	cd 30                	int    $0x30
	if(check && ret > 0)
  801062:	85 c0                	test   %eax,%eax
  801064:	7f 08                	jg     80106e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801066:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801069:	5b                   	pop    %ebx
  80106a:	5e                   	pop    %esi
  80106b:	5f                   	pop    %edi
  80106c:	5d                   	pop    %ebp
  80106d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80106e:	83 ec 0c             	sub    $0xc,%esp
  801071:	50                   	push   %eax
  801072:	6a 08                	push   $0x8
  801074:	68 ff 2a 80 00       	push   $0x802aff
  801079:	6a 23                	push   $0x23
  80107b:	68 1c 2b 80 00       	push   $0x802b1c
  801080:	e8 6a 12 00 00       	call   8022ef <_panic>

00801085 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	57                   	push   %edi
  801089:	56                   	push   %esi
  80108a:	53                   	push   %ebx
  80108b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80108e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801099:	b8 09 00 00 00       	mov    $0x9,%eax
  80109e:	89 df                	mov    %ebx,%edi
  8010a0:	89 de                	mov    %ebx,%esi
  8010a2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	7f 08                	jg     8010b0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ab:	5b                   	pop    %ebx
  8010ac:	5e                   	pop    %esi
  8010ad:	5f                   	pop    %edi
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	50                   	push   %eax
  8010b4:	6a 09                	push   $0x9
  8010b6:	68 ff 2a 80 00       	push   $0x802aff
  8010bb:	6a 23                	push   $0x23
  8010bd:	68 1c 2b 80 00       	push   $0x802b1c
  8010c2:	e8 28 12 00 00       	call   8022ef <_panic>

008010c7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	57                   	push   %edi
  8010cb:	56                   	push   %esi
  8010cc:	53                   	push   %ebx
  8010cd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010e0:	89 df                	mov    %ebx,%edi
  8010e2:	89 de                	mov    %ebx,%esi
  8010e4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	7f 08                	jg     8010f2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ed:	5b                   	pop    %ebx
  8010ee:	5e                   	pop    %esi
  8010ef:	5f                   	pop    %edi
  8010f0:	5d                   	pop    %ebp
  8010f1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f2:	83 ec 0c             	sub    $0xc,%esp
  8010f5:	50                   	push   %eax
  8010f6:	6a 0a                	push   $0xa
  8010f8:	68 ff 2a 80 00       	push   $0x802aff
  8010fd:	6a 23                	push   $0x23
  8010ff:	68 1c 2b 80 00       	push   $0x802b1c
  801104:	e8 e6 11 00 00       	call   8022ef <_panic>

00801109 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	57                   	push   %edi
  80110d:	56                   	push   %esi
  80110e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110f:	8b 55 08             	mov    0x8(%ebp),%edx
  801112:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801115:	b8 0c 00 00 00       	mov    $0xc,%eax
  80111a:	be 00 00 00 00       	mov    $0x0,%esi
  80111f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801122:	8b 7d 14             	mov    0x14(%ebp),%edi
  801125:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801127:	5b                   	pop    %ebx
  801128:	5e                   	pop    %esi
  801129:	5f                   	pop    %edi
  80112a:	5d                   	pop    %ebp
  80112b:	c3                   	ret    

0080112c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	57                   	push   %edi
  801130:	56                   	push   %esi
  801131:	53                   	push   %ebx
  801132:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801135:	b9 00 00 00 00       	mov    $0x0,%ecx
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801142:	89 cb                	mov    %ecx,%ebx
  801144:	89 cf                	mov    %ecx,%edi
  801146:	89 ce                	mov    %ecx,%esi
  801148:	cd 30                	int    $0x30
	if(check && ret > 0)
  80114a:	85 c0                	test   %eax,%eax
  80114c:	7f 08                	jg     801156 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80114e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801151:	5b                   	pop    %ebx
  801152:	5e                   	pop    %esi
  801153:	5f                   	pop    %edi
  801154:	5d                   	pop    %ebp
  801155:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	50                   	push   %eax
  80115a:	6a 0d                	push   $0xd
  80115c:	68 ff 2a 80 00       	push   $0x802aff
  801161:	6a 23                	push   $0x23
  801163:	68 1c 2b 80 00       	push   $0x802b1c
  801168:	e8 82 11 00 00       	call   8022ef <_panic>

0080116d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	57                   	push   %edi
  801171:	56                   	push   %esi
  801172:	53                   	push   %ebx
	asm volatile("int %1\n"
  801173:	ba 00 00 00 00       	mov    $0x0,%edx
  801178:	b8 0e 00 00 00       	mov    $0xe,%eax
  80117d:	89 d1                	mov    %edx,%ecx
  80117f:	89 d3                	mov    %edx,%ebx
  801181:	89 d7                	mov    %edx,%edi
  801183:	89 d6                	mov    %edx,%esi
  801185:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801187:	5b                   	pop    %ebx
  801188:	5e                   	pop    %esi
  801189:	5f                   	pop    %edi
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    

0080118c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	05 00 00 00 30       	add    $0x30000000,%eax
  801197:	c1 e8 0c             	shr    $0xc,%eax
}
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    

0080119c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ac:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011b1:	5d                   	pop    %ebp
  8011b2:	c3                   	ret    

008011b3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011bb:	89 c2                	mov    %eax,%edx
  8011bd:	c1 ea 16             	shr    $0x16,%edx
  8011c0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011c7:	f6 c2 01             	test   $0x1,%dl
  8011ca:	74 2d                	je     8011f9 <fd_alloc+0x46>
  8011cc:	89 c2                	mov    %eax,%edx
  8011ce:	c1 ea 0c             	shr    $0xc,%edx
  8011d1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d8:	f6 c2 01             	test   $0x1,%dl
  8011db:	74 1c                	je     8011f9 <fd_alloc+0x46>
  8011dd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011e2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011e7:	75 d2                	jne    8011bb <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011f2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011f7:	eb 0a                	jmp    801203 <fd_alloc+0x50>
			*fd_store = fd;
  8011f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011fc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801203:	5d                   	pop    %ebp
  801204:	c3                   	ret    

00801205 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80120b:	83 f8 1f             	cmp    $0x1f,%eax
  80120e:	77 30                	ja     801240 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801210:	c1 e0 0c             	shl    $0xc,%eax
  801213:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801218:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80121e:	f6 c2 01             	test   $0x1,%dl
  801221:	74 24                	je     801247 <fd_lookup+0x42>
  801223:	89 c2                	mov    %eax,%edx
  801225:	c1 ea 0c             	shr    $0xc,%edx
  801228:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80122f:	f6 c2 01             	test   $0x1,%dl
  801232:	74 1a                	je     80124e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801234:	8b 55 0c             	mov    0xc(%ebp),%edx
  801237:	89 02                	mov    %eax,(%edx)
	return 0;
  801239:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    
		return -E_INVAL;
  801240:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801245:	eb f7                	jmp    80123e <fd_lookup+0x39>
		return -E_INVAL;
  801247:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80124c:	eb f0                	jmp    80123e <fd_lookup+0x39>
  80124e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801253:	eb e9                	jmp    80123e <fd_lookup+0x39>

00801255 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80125e:	ba 00 00 00 00       	mov    $0x0,%edx
  801263:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801268:	39 08                	cmp    %ecx,(%eax)
  80126a:	74 38                	je     8012a4 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80126c:	83 c2 01             	add    $0x1,%edx
  80126f:	8b 04 95 a8 2b 80 00 	mov    0x802ba8(,%edx,4),%eax
  801276:	85 c0                	test   %eax,%eax
  801278:	75 ee                	jne    801268 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80127a:	a1 18 40 80 00       	mov    0x804018,%eax
  80127f:	8b 40 48             	mov    0x48(%eax),%eax
  801282:	83 ec 04             	sub    $0x4,%esp
  801285:	51                   	push   %ecx
  801286:	50                   	push   %eax
  801287:	68 2c 2b 80 00       	push   $0x802b2c
  80128c:	e8 1d f3 ff ff       	call   8005ae <cprintf>
	*dev = 0;
  801291:	8b 45 0c             	mov    0xc(%ebp),%eax
  801294:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80129a:	83 c4 10             	add    $0x10,%esp
  80129d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    
			*dev = devtab[i];
  8012a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ae:	eb f2                	jmp    8012a2 <dev_lookup+0x4d>

008012b0 <fd_close>:
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	57                   	push   %edi
  8012b4:	56                   	push   %esi
  8012b5:	53                   	push   %ebx
  8012b6:	83 ec 24             	sub    $0x24,%esp
  8012b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8012bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012c2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012c3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012c9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012cc:	50                   	push   %eax
  8012cd:	e8 33 ff ff ff       	call   801205 <fd_lookup>
  8012d2:	89 c3                	mov    %eax,%ebx
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	78 05                	js     8012e0 <fd_close+0x30>
	    || fd != fd2)
  8012db:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012de:	74 16                	je     8012f6 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012e0:	89 f8                	mov    %edi,%eax
  8012e2:	84 c0                	test   %al,%al
  8012e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e9:	0f 44 d8             	cmove  %eax,%ebx
}
  8012ec:	89 d8                	mov    %ebx,%eax
  8012ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f1:	5b                   	pop    %ebx
  8012f2:	5e                   	pop    %esi
  8012f3:	5f                   	pop    %edi
  8012f4:	5d                   	pop    %ebp
  8012f5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012f6:	83 ec 08             	sub    $0x8,%esp
  8012f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012fc:	50                   	push   %eax
  8012fd:	ff 36                	pushl  (%esi)
  8012ff:	e8 51 ff ff ff       	call   801255 <dev_lookup>
  801304:	89 c3                	mov    %eax,%ebx
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	85 c0                	test   %eax,%eax
  80130b:	78 1a                	js     801327 <fd_close+0x77>
		if (dev->dev_close)
  80130d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801310:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801313:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801318:	85 c0                	test   %eax,%eax
  80131a:	74 0b                	je     801327 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80131c:	83 ec 0c             	sub    $0xc,%esp
  80131f:	56                   	push   %esi
  801320:	ff d0                	call   *%eax
  801322:	89 c3                	mov    %eax,%ebx
  801324:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801327:	83 ec 08             	sub    $0x8,%esp
  80132a:	56                   	push   %esi
  80132b:	6a 00                	push   $0x0
  80132d:	e8 cf fc ff ff       	call   801001 <sys_page_unmap>
	return r;
  801332:	83 c4 10             	add    $0x10,%esp
  801335:	eb b5                	jmp    8012ec <fd_close+0x3c>

00801337 <close>:

int
close(int fdnum)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80133d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801340:	50                   	push   %eax
  801341:	ff 75 08             	pushl  0x8(%ebp)
  801344:	e8 bc fe ff ff       	call   801205 <fd_lookup>
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	79 02                	jns    801352 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801350:	c9                   	leave  
  801351:	c3                   	ret    
		return fd_close(fd, 1);
  801352:	83 ec 08             	sub    $0x8,%esp
  801355:	6a 01                	push   $0x1
  801357:	ff 75 f4             	pushl  -0xc(%ebp)
  80135a:	e8 51 ff ff ff       	call   8012b0 <fd_close>
  80135f:	83 c4 10             	add    $0x10,%esp
  801362:	eb ec                	jmp    801350 <close+0x19>

00801364 <close_all>:

void
close_all(void)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	53                   	push   %ebx
  801368:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80136b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801370:	83 ec 0c             	sub    $0xc,%esp
  801373:	53                   	push   %ebx
  801374:	e8 be ff ff ff       	call   801337 <close>
	for (i = 0; i < MAXFD; i++)
  801379:	83 c3 01             	add    $0x1,%ebx
  80137c:	83 c4 10             	add    $0x10,%esp
  80137f:	83 fb 20             	cmp    $0x20,%ebx
  801382:	75 ec                	jne    801370 <close_all+0xc>
}
  801384:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	57                   	push   %edi
  80138d:	56                   	push   %esi
  80138e:	53                   	push   %ebx
  80138f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801392:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801395:	50                   	push   %eax
  801396:	ff 75 08             	pushl  0x8(%ebp)
  801399:	e8 67 fe ff ff       	call   801205 <fd_lookup>
  80139e:	89 c3                	mov    %eax,%ebx
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	0f 88 81 00 00 00    	js     80142c <dup+0xa3>
		return r;
	close(newfdnum);
  8013ab:	83 ec 0c             	sub    $0xc,%esp
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	e8 81 ff ff ff       	call   801337 <close>

	newfd = INDEX2FD(newfdnum);
  8013b6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013b9:	c1 e6 0c             	shl    $0xc,%esi
  8013bc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013c2:	83 c4 04             	add    $0x4,%esp
  8013c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013c8:	e8 cf fd ff ff       	call   80119c <fd2data>
  8013cd:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013cf:	89 34 24             	mov    %esi,(%esp)
  8013d2:	e8 c5 fd ff ff       	call   80119c <fd2data>
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013dc:	89 d8                	mov    %ebx,%eax
  8013de:	c1 e8 16             	shr    $0x16,%eax
  8013e1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013e8:	a8 01                	test   $0x1,%al
  8013ea:	74 11                	je     8013fd <dup+0x74>
  8013ec:	89 d8                	mov    %ebx,%eax
  8013ee:	c1 e8 0c             	shr    $0xc,%eax
  8013f1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013f8:	f6 c2 01             	test   $0x1,%dl
  8013fb:	75 39                	jne    801436 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801400:	89 d0                	mov    %edx,%eax
  801402:	c1 e8 0c             	shr    $0xc,%eax
  801405:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80140c:	83 ec 0c             	sub    $0xc,%esp
  80140f:	25 07 0e 00 00       	and    $0xe07,%eax
  801414:	50                   	push   %eax
  801415:	56                   	push   %esi
  801416:	6a 00                	push   $0x0
  801418:	52                   	push   %edx
  801419:	6a 00                	push   $0x0
  80141b:	e8 9f fb ff ff       	call   800fbf <sys_page_map>
  801420:	89 c3                	mov    %eax,%ebx
  801422:	83 c4 20             	add    $0x20,%esp
  801425:	85 c0                	test   %eax,%eax
  801427:	78 31                	js     80145a <dup+0xd1>
		goto err;

	return newfdnum;
  801429:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80142c:	89 d8                	mov    %ebx,%eax
  80142e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801431:	5b                   	pop    %ebx
  801432:	5e                   	pop    %esi
  801433:	5f                   	pop    %edi
  801434:	5d                   	pop    %ebp
  801435:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801436:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80143d:	83 ec 0c             	sub    $0xc,%esp
  801440:	25 07 0e 00 00       	and    $0xe07,%eax
  801445:	50                   	push   %eax
  801446:	57                   	push   %edi
  801447:	6a 00                	push   $0x0
  801449:	53                   	push   %ebx
  80144a:	6a 00                	push   $0x0
  80144c:	e8 6e fb ff ff       	call   800fbf <sys_page_map>
  801451:	89 c3                	mov    %eax,%ebx
  801453:	83 c4 20             	add    $0x20,%esp
  801456:	85 c0                	test   %eax,%eax
  801458:	79 a3                	jns    8013fd <dup+0x74>
	sys_page_unmap(0, newfd);
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	56                   	push   %esi
  80145e:	6a 00                	push   $0x0
  801460:	e8 9c fb ff ff       	call   801001 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801465:	83 c4 08             	add    $0x8,%esp
  801468:	57                   	push   %edi
  801469:	6a 00                	push   $0x0
  80146b:	e8 91 fb ff ff       	call   801001 <sys_page_unmap>
	return r;
  801470:	83 c4 10             	add    $0x10,%esp
  801473:	eb b7                	jmp    80142c <dup+0xa3>

00801475 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	53                   	push   %ebx
  801479:	83 ec 1c             	sub    $0x1c,%esp
  80147c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801482:	50                   	push   %eax
  801483:	53                   	push   %ebx
  801484:	e8 7c fd ff ff       	call   801205 <fd_lookup>
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	85 c0                	test   %eax,%eax
  80148e:	78 3f                	js     8014cf <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801490:	83 ec 08             	sub    $0x8,%esp
  801493:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801496:	50                   	push   %eax
  801497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149a:	ff 30                	pushl  (%eax)
  80149c:	e8 b4 fd ff ff       	call   801255 <dev_lookup>
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	78 27                	js     8014cf <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ab:	8b 42 08             	mov    0x8(%edx),%eax
  8014ae:	83 e0 03             	and    $0x3,%eax
  8014b1:	83 f8 01             	cmp    $0x1,%eax
  8014b4:	74 1e                	je     8014d4 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b9:	8b 40 08             	mov    0x8(%eax),%eax
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	74 35                	je     8014f5 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	ff 75 10             	pushl  0x10(%ebp)
  8014c6:	ff 75 0c             	pushl  0xc(%ebp)
  8014c9:	52                   	push   %edx
  8014ca:	ff d0                	call   *%eax
  8014cc:	83 c4 10             	add    $0x10,%esp
}
  8014cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d4:	a1 18 40 80 00       	mov    0x804018,%eax
  8014d9:	8b 40 48             	mov    0x48(%eax),%eax
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	53                   	push   %ebx
  8014e0:	50                   	push   %eax
  8014e1:	68 6d 2b 80 00       	push   $0x802b6d
  8014e6:	e8 c3 f0 ff ff       	call   8005ae <cprintf>
		return -E_INVAL;
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f3:	eb da                	jmp    8014cf <read+0x5a>
		return -E_NOT_SUPP;
  8014f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014fa:	eb d3                	jmp    8014cf <read+0x5a>

008014fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	57                   	push   %edi
  801500:	56                   	push   %esi
  801501:	53                   	push   %ebx
  801502:	83 ec 0c             	sub    $0xc,%esp
  801505:	8b 7d 08             	mov    0x8(%ebp),%edi
  801508:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80150b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801510:	39 f3                	cmp    %esi,%ebx
  801512:	73 23                	jae    801537 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801514:	83 ec 04             	sub    $0x4,%esp
  801517:	89 f0                	mov    %esi,%eax
  801519:	29 d8                	sub    %ebx,%eax
  80151b:	50                   	push   %eax
  80151c:	89 d8                	mov    %ebx,%eax
  80151e:	03 45 0c             	add    0xc(%ebp),%eax
  801521:	50                   	push   %eax
  801522:	57                   	push   %edi
  801523:	e8 4d ff ff ff       	call   801475 <read>
		if (m < 0)
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	85 c0                	test   %eax,%eax
  80152d:	78 06                	js     801535 <readn+0x39>
			return m;
		if (m == 0)
  80152f:	74 06                	je     801537 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801531:	01 c3                	add    %eax,%ebx
  801533:	eb db                	jmp    801510 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801535:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801537:	89 d8                	mov    %ebx,%eax
  801539:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153c:	5b                   	pop    %ebx
  80153d:	5e                   	pop    %esi
  80153e:	5f                   	pop    %edi
  80153f:	5d                   	pop    %ebp
  801540:	c3                   	ret    

00801541 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	53                   	push   %ebx
  801545:	83 ec 1c             	sub    $0x1c,%esp
  801548:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80154e:	50                   	push   %eax
  80154f:	53                   	push   %ebx
  801550:	e8 b0 fc ff ff       	call   801205 <fd_lookup>
  801555:	83 c4 10             	add    $0x10,%esp
  801558:	85 c0                	test   %eax,%eax
  80155a:	78 3a                	js     801596 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801562:	50                   	push   %eax
  801563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801566:	ff 30                	pushl  (%eax)
  801568:	e8 e8 fc ff ff       	call   801255 <dev_lookup>
  80156d:	83 c4 10             	add    $0x10,%esp
  801570:	85 c0                	test   %eax,%eax
  801572:	78 22                	js     801596 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801577:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80157b:	74 1e                	je     80159b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80157d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801580:	8b 52 0c             	mov    0xc(%edx),%edx
  801583:	85 d2                	test   %edx,%edx
  801585:	74 35                	je     8015bc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801587:	83 ec 04             	sub    $0x4,%esp
  80158a:	ff 75 10             	pushl  0x10(%ebp)
  80158d:	ff 75 0c             	pushl  0xc(%ebp)
  801590:	50                   	push   %eax
  801591:	ff d2                	call   *%edx
  801593:	83 c4 10             	add    $0x10,%esp
}
  801596:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801599:	c9                   	leave  
  80159a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80159b:	a1 18 40 80 00       	mov    0x804018,%eax
  8015a0:	8b 40 48             	mov    0x48(%eax),%eax
  8015a3:	83 ec 04             	sub    $0x4,%esp
  8015a6:	53                   	push   %ebx
  8015a7:	50                   	push   %eax
  8015a8:	68 89 2b 80 00       	push   $0x802b89
  8015ad:	e8 fc ef ff ff       	call   8005ae <cprintf>
		return -E_INVAL;
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ba:	eb da                	jmp    801596 <write+0x55>
		return -E_NOT_SUPP;
  8015bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015c1:	eb d3                	jmp    801596 <write+0x55>

008015c3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015cc:	50                   	push   %eax
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	e8 30 fc ff ff       	call   801205 <fd_lookup>
  8015d5:	83 c4 10             	add    $0x10,%esp
  8015d8:	85 c0                	test   %eax,%eax
  8015da:	78 0e                	js     8015ea <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	53                   	push   %ebx
  8015f0:	83 ec 1c             	sub    $0x1c,%esp
  8015f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f9:	50                   	push   %eax
  8015fa:	53                   	push   %ebx
  8015fb:	e8 05 fc ff ff       	call   801205 <fd_lookup>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	85 c0                	test   %eax,%eax
  801605:	78 37                	js     80163e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801607:	83 ec 08             	sub    $0x8,%esp
  80160a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160d:	50                   	push   %eax
  80160e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801611:	ff 30                	pushl  (%eax)
  801613:	e8 3d fc ff ff       	call   801255 <dev_lookup>
  801618:	83 c4 10             	add    $0x10,%esp
  80161b:	85 c0                	test   %eax,%eax
  80161d:	78 1f                	js     80163e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80161f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801622:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801626:	74 1b                	je     801643 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801628:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162b:	8b 52 18             	mov    0x18(%edx),%edx
  80162e:	85 d2                	test   %edx,%edx
  801630:	74 32                	je     801664 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801632:	83 ec 08             	sub    $0x8,%esp
  801635:	ff 75 0c             	pushl  0xc(%ebp)
  801638:	50                   	push   %eax
  801639:	ff d2                	call   *%edx
  80163b:	83 c4 10             	add    $0x10,%esp
}
  80163e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801641:	c9                   	leave  
  801642:	c3                   	ret    
			thisenv->env_id, fdnum);
  801643:	a1 18 40 80 00       	mov    0x804018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801648:	8b 40 48             	mov    0x48(%eax),%eax
  80164b:	83 ec 04             	sub    $0x4,%esp
  80164e:	53                   	push   %ebx
  80164f:	50                   	push   %eax
  801650:	68 4c 2b 80 00       	push   $0x802b4c
  801655:	e8 54 ef ff ff       	call   8005ae <cprintf>
		return -E_INVAL;
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801662:	eb da                	jmp    80163e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801664:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801669:	eb d3                	jmp    80163e <ftruncate+0x52>

0080166b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	53                   	push   %ebx
  80166f:	83 ec 1c             	sub    $0x1c,%esp
  801672:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801675:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801678:	50                   	push   %eax
  801679:	ff 75 08             	pushl  0x8(%ebp)
  80167c:	e8 84 fb ff ff       	call   801205 <fd_lookup>
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	85 c0                	test   %eax,%eax
  801686:	78 4b                	js     8016d3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801688:	83 ec 08             	sub    $0x8,%esp
  80168b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80168e:	50                   	push   %eax
  80168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801692:	ff 30                	pushl  (%eax)
  801694:	e8 bc fb ff ff       	call   801255 <dev_lookup>
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	85 c0                	test   %eax,%eax
  80169e:	78 33                	js     8016d3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016a7:	74 2f                	je     8016d8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016b3:	00 00 00 
	stat->st_isdir = 0;
  8016b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016bd:	00 00 00 
	stat->st_dev = dev;
  8016c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016c6:	83 ec 08             	sub    $0x8,%esp
  8016c9:	53                   	push   %ebx
  8016ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8016cd:	ff 50 14             	call   *0x14(%eax)
  8016d0:	83 c4 10             	add    $0x10,%esp
}
  8016d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    
		return -E_NOT_SUPP;
  8016d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016dd:	eb f4                	jmp    8016d3 <fstat+0x68>

008016df <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	56                   	push   %esi
  8016e3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016e4:	83 ec 08             	sub    $0x8,%esp
  8016e7:	6a 00                	push   $0x0
  8016e9:	ff 75 08             	pushl  0x8(%ebp)
  8016ec:	e8 2f 02 00 00       	call   801920 <open>
  8016f1:	89 c3                	mov    %eax,%ebx
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	78 1b                	js     801715 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	ff 75 0c             	pushl  0xc(%ebp)
  801700:	50                   	push   %eax
  801701:	e8 65 ff ff ff       	call   80166b <fstat>
  801706:	89 c6                	mov    %eax,%esi
	close(fd);
  801708:	89 1c 24             	mov    %ebx,(%esp)
  80170b:	e8 27 fc ff ff       	call   801337 <close>
	return r;
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	89 f3                	mov    %esi,%ebx
}
  801715:	89 d8                	mov    %ebx,%eax
  801717:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80171a:	5b                   	pop    %ebx
  80171b:	5e                   	pop    %esi
  80171c:	5d                   	pop    %ebp
  80171d:	c3                   	ret    

0080171e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	56                   	push   %esi
  801722:	53                   	push   %ebx
  801723:	89 c6                	mov    %eax,%esi
  801725:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801727:	83 3d 10 40 80 00 00 	cmpl   $0x0,0x804010
  80172e:	74 27                	je     801757 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801730:	6a 07                	push   $0x7
  801732:	68 00 50 80 00       	push   $0x805000
  801737:	56                   	push   %esi
  801738:	ff 35 10 40 80 00    	pushl  0x804010
  80173e:	e8 65 0c 00 00       	call   8023a8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801743:	83 c4 0c             	add    $0xc,%esp
  801746:	6a 00                	push   $0x0
  801748:	53                   	push   %ebx
  801749:	6a 00                	push   $0x0
  80174b:	e8 e5 0b 00 00       	call   802335 <ipc_recv>
}
  801750:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801753:	5b                   	pop    %ebx
  801754:	5e                   	pop    %esi
  801755:	5d                   	pop    %ebp
  801756:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801757:	83 ec 0c             	sub    $0xc,%esp
  80175a:	6a 01                	push   $0x1
  80175c:	e8 b3 0c 00 00       	call   802414 <ipc_find_env>
  801761:	a3 10 40 80 00       	mov    %eax,0x804010
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	eb c5                	jmp    801730 <fsipc+0x12>

0080176b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	8b 40 0c             	mov    0xc(%eax),%eax
  801777:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80177c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801784:	ba 00 00 00 00       	mov    $0x0,%edx
  801789:	b8 02 00 00 00       	mov    $0x2,%eax
  80178e:	e8 8b ff ff ff       	call   80171e <fsipc>
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <devfile_flush>:
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ab:	b8 06 00 00 00       	mov    $0x6,%eax
  8017b0:	e8 69 ff ff ff       	call   80171e <fsipc>
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <devfile_stat>:
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	53                   	push   %ebx
  8017bb:	83 ec 04             	sub    $0x4,%esp
  8017be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d1:	b8 05 00 00 00       	mov    $0x5,%eax
  8017d6:	e8 43 ff ff ff       	call   80171e <fsipc>
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	78 2c                	js     80180b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017df:	83 ec 08             	sub    $0x8,%esp
  8017e2:	68 00 50 80 00       	push   $0x805000
  8017e7:	53                   	push   %ebx
  8017e8:	e8 9d f3 ff ff       	call   800b8a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017ed:	a1 80 50 80 00       	mov    0x805080,%eax
  8017f2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017f8:	a1 84 50 80 00       	mov    0x805084,%eax
  8017fd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <devfile_write>:
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	53                   	push   %ebx
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  80181a:	85 db                	test   %ebx,%ebx
  80181c:	75 07                	jne    801825 <devfile_write+0x15>
	return n_all;
  80181e:	89 d8                	mov    %ebx,%eax
}
  801820:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801823:	c9                   	leave  
  801824:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8b 40 0c             	mov    0xc(%eax),%eax
  80182b:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801830:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	53                   	push   %ebx
  80183a:	ff 75 0c             	pushl  0xc(%ebp)
  80183d:	68 08 50 80 00       	push   $0x805008
  801842:	e8 d1 f4 ff ff       	call   800d18 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801847:	ba 00 00 00 00       	mov    $0x0,%edx
  80184c:	b8 04 00 00 00       	mov    $0x4,%eax
  801851:	e8 c8 fe ff ff       	call   80171e <fsipc>
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	85 c0                	test   %eax,%eax
  80185b:	78 c3                	js     801820 <devfile_write+0x10>
	  assert(r <= n_left);
  80185d:	39 d8                	cmp    %ebx,%eax
  80185f:	77 0b                	ja     80186c <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801861:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801866:	7f 1d                	jg     801885 <devfile_write+0x75>
    n_all += r;
  801868:	89 c3                	mov    %eax,%ebx
  80186a:	eb b2                	jmp    80181e <devfile_write+0xe>
	  assert(r <= n_left);
  80186c:	68 bc 2b 80 00       	push   $0x802bbc
  801871:	68 c8 2b 80 00       	push   $0x802bc8
  801876:	68 9f 00 00 00       	push   $0x9f
  80187b:	68 dd 2b 80 00       	push   $0x802bdd
  801880:	e8 6a 0a 00 00       	call   8022ef <_panic>
	  assert(r <= PGSIZE);
  801885:	68 e8 2b 80 00       	push   $0x802be8
  80188a:	68 c8 2b 80 00       	push   $0x802bc8
  80188f:	68 a0 00 00 00       	push   $0xa0
  801894:	68 dd 2b 80 00       	push   $0x802bdd
  801899:	e8 51 0a 00 00       	call   8022ef <_panic>

0080189e <devfile_read>:
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	56                   	push   %esi
  8018a2:	53                   	push   %ebx
  8018a3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ac:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018b1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8018c1:	e8 58 fe ff ff       	call   80171e <fsipc>
  8018c6:	89 c3                	mov    %eax,%ebx
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	78 1f                	js     8018eb <devfile_read+0x4d>
	assert(r <= n);
  8018cc:	39 f0                	cmp    %esi,%eax
  8018ce:	77 24                	ja     8018f4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018d0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018d5:	7f 33                	jg     80190a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018d7:	83 ec 04             	sub    $0x4,%esp
  8018da:	50                   	push   %eax
  8018db:	68 00 50 80 00       	push   $0x805000
  8018e0:	ff 75 0c             	pushl  0xc(%ebp)
  8018e3:	e8 30 f4 ff ff       	call   800d18 <memmove>
	return r;
  8018e8:	83 c4 10             	add    $0x10,%esp
}
  8018eb:	89 d8                	mov    %ebx,%eax
  8018ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f0:	5b                   	pop    %ebx
  8018f1:	5e                   	pop    %esi
  8018f2:	5d                   	pop    %ebp
  8018f3:	c3                   	ret    
	assert(r <= n);
  8018f4:	68 f4 2b 80 00       	push   $0x802bf4
  8018f9:	68 c8 2b 80 00       	push   $0x802bc8
  8018fe:	6a 7c                	push   $0x7c
  801900:	68 dd 2b 80 00       	push   $0x802bdd
  801905:	e8 e5 09 00 00       	call   8022ef <_panic>
	assert(r <= PGSIZE);
  80190a:	68 e8 2b 80 00       	push   $0x802be8
  80190f:	68 c8 2b 80 00       	push   $0x802bc8
  801914:	6a 7d                	push   $0x7d
  801916:	68 dd 2b 80 00       	push   $0x802bdd
  80191b:	e8 cf 09 00 00       	call   8022ef <_panic>

00801920 <open>:
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	56                   	push   %esi
  801924:	53                   	push   %ebx
  801925:	83 ec 1c             	sub    $0x1c,%esp
  801928:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80192b:	56                   	push   %esi
  80192c:	e8 20 f2 ff ff       	call   800b51 <strlen>
  801931:	83 c4 10             	add    $0x10,%esp
  801934:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801939:	7f 6c                	jg     8019a7 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80193b:	83 ec 0c             	sub    $0xc,%esp
  80193e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801941:	50                   	push   %eax
  801942:	e8 6c f8 ff ff       	call   8011b3 <fd_alloc>
  801947:	89 c3                	mov    %eax,%ebx
  801949:	83 c4 10             	add    $0x10,%esp
  80194c:	85 c0                	test   %eax,%eax
  80194e:	78 3c                	js     80198c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801950:	83 ec 08             	sub    $0x8,%esp
  801953:	56                   	push   %esi
  801954:	68 00 50 80 00       	push   $0x805000
  801959:	e8 2c f2 ff ff       	call   800b8a <strcpy>
	fsipcbuf.open.req_omode = mode;
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801966:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801969:	b8 01 00 00 00       	mov    $0x1,%eax
  80196e:	e8 ab fd ff ff       	call   80171e <fsipc>
  801973:	89 c3                	mov    %eax,%ebx
  801975:	83 c4 10             	add    $0x10,%esp
  801978:	85 c0                	test   %eax,%eax
  80197a:	78 19                	js     801995 <open+0x75>
	return fd2num(fd);
  80197c:	83 ec 0c             	sub    $0xc,%esp
  80197f:	ff 75 f4             	pushl  -0xc(%ebp)
  801982:	e8 05 f8 ff ff       	call   80118c <fd2num>
  801987:	89 c3                	mov    %eax,%ebx
  801989:	83 c4 10             	add    $0x10,%esp
}
  80198c:	89 d8                	mov    %ebx,%eax
  80198e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801991:	5b                   	pop    %ebx
  801992:	5e                   	pop    %esi
  801993:	5d                   	pop    %ebp
  801994:	c3                   	ret    
		fd_close(fd, 0);
  801995:	83 ec 08             	sub    $0x8,%esp
  801998:	6a 00                	push   $0x0
  80199a:	ff 75 f4             	pushl  -0xc(%ebp)
  80199d:	e8 0e f9 ff ff       	call   8012b0 <fd_close>
		return r;
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	eb e5                	jmp    80198c <open+0x6c>
		return -E_BAD_PATH;
  8019a7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019ac:	eb de                	jmp    80198c <open+0x6c>

008019ae <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b9:	b8 08 00 00 00       	mov    $0x8,%eax
  8019be:	e8 5b fd ff ff       	call   80171e <fsipc>
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
  8019c8:	56                   	push   %esi
  8019c9:	53                   	push   %ebx
  8019ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019cd:	83 ec 0c             	sub    $0xc,%esp
  8019d0:	ff 75 08             	pushl  0x8(%ebp)
  8019d3:	e8 c4 f7 ff ff       	call   80119c <fd2data>
  8019d8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019da:	83 c4 08             	add    $0x8,%esp
  8019dd:	68 fb 2b 80 00       	push   $0x802bfb
  8019e2:	53                   	push   %ebx
  8019e3:	e8 a2 f1 ff ff       	call   800b8a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019e8:	8b 46 04             	mov    0x4(%esi),%eax
  8019eb:	2b 06                	sub    (%esi),%eax
  8019ed:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019f3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019fa:	00 00 00 
	stat->st_dev = &devpipe;
  8019fd:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801a04:	30 80 00 
	return 0;
}
  801a07:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0f:	5b                   	pop    %ebx
  801a10:	5e                   	pop    %esi
  801a11:	5d                   	pop    %ebp
  801a12:	c3                   	ret    

00801a13 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	53                   	push   %ebx
  801a17:	83 ec 0c             	sub    $0xc,%esp
  801a1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a1d:	53                   	push   %ebx
  801a1e:	6a 00                	push   $0x0
  801a20:	e8 dc f5 ff ff       	call   801001 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a25:	89 1c 24             	mov    %ebx,(%esp)
  801a28:	e8 6f f7 ff ff       	call   80119c <fd2data>
  801a2d:	83 c4 08             	add    $0x8,%esp
  801a30:	50                   	push   %eax
  801a31:	6a 00                	push   $0x0
  801a33:	e8 c9 f5 ff ff       	call   801001 <sys_page_unmap>
}
  801a38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <_pipeisclosed>:
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	57                   	push   %edi
  801a41:	56                   	push   %esi
  801a42:	53                   	push   %ebx
  801a43:	83 ec 1c             	sub    $0x1c,%esp
  801a46:	89 c7                	mov    %eax,%edi
  801a48:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a4a:	a1 18 40 80 00       	mov    0x804018,%eax
  801a4f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a52:	83 ec 0c             	sub    $0xc,%esp
  801a55:	57                   	push   %edi
  801a56:	e8 f2 09 00 00       	call   80244d <pageref>
  801a5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a5e:	89 34 24             	mov    %esi,(%esp)
  801a61:	e8 e7 09 00 00       	call   80244d <pageref>
		nn = thisenv->env_runs;
  801a66:	8b 15 18 40 80 00    	mov    0x804018,%edx
  801a6c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a6f:	83 c4 10             	add    $0x10,%esp
  801a72:	39 cb                	cmp    %ecx,%ebx
  801a74:	74 1b                	je     801a91 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a76:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a79:	75 cf                	jne    801a4a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a7b:	8b 42 58             	mov    0x58(%edx),%eax
  801a7e:	6a 01                	push   $0x1
  801a80:	50                   	push   %eax
  801a81:	53                   	push   %ebx
  801a82:	68 02 2c 80 00       	push   $0x802c02
  801a87:	e8 22 eb ff ff       	call   8005ae <cprintf>
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	eb b9                	jmp    801a4a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a91:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a94:	0f 94 c0             	sete   %al
  801a97:	0f b6 c0             	movzbl %al,%eax
}
  801a9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5e                   	pop    %esi
  801a9f:	5f                   	pop    %edi
  801aa0:	5d                   	pop    %ebp
  801aa1:	c3                   	ret    

00801aa2 <devpipe_write>:
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	57                   	push   %edi
  801aa6:	56                   	push   %esi
  801aa7:	53                   	push   %ebx
  801aa8:	83 ec 28             	sub    $0x28,%esp
  801aab:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801aae:	56                   	push   %esi
  801aaf:	e8 e8 f6 ff ff       	call   80119c <fd2data>
  801ab4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ab6:	83 c4 10             	add    $0x10,%esp
  801ab9:	bf 00 00 00 00       	mov    $0x0,%edi
  801abe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ac1:	74 4f                	je     801b12 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ac3:	8b 43 04             	mov    0x4(%ebx),%eax
  801ac6:	8b 0b                	mov    (%ebx),%ecx
  801ac8:	8d 51 20             	lea    0x20(%ecx),%edx
  801acb:	39 d0                	cmp    %edx,%eax
  801acd:	72 14                	jb     801ae3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801acf:	89 da                	mov    %ebx,%edx
  801ad1:	89 f0                	mov    %esi,%eax
  801ad3:	e8 65 ff ff ff       	call   801a3d <_pipeisclosed>
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	75 3b                	jne    801b17 <devpipe_write+0x75>
			sys_yield();
  801adc:	e8 7c f4 ff ff       	call   800f5d <sys_yield>
  801ae1:	eb e0                	jmp    801ac3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ae3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ae6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801aea:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801aed:	89 c2                	mov    %eax,%edx
  801aef:	c1 fa 1f             	sar    $0x1f,%edx
  801af2:	89 d1                	mov    %edx,%ecx
  801af4:	c1 e9 1b             	shr    $0x1b,%ecx
  801af7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801afa:	83 e2 1f             	and    $0x1f,%edx
  801afd:	29 ca                	sub    %ecx,%edx
  801aff:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b03:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b07:	83 c0 01             	add    $0x1,%eax
  801b0a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b0d:	83 c7 01             	add    $0x1,%edi
  801b10:	eb ac                	jmp    801abe <devpipe_write+0x1c>
	return i;
  801b12:	8b 45 10             	mov    0x10(%ebp),%eax
  801b15:	eb 05                	jmp    801b1c <devpipe_write+0x7a>
				return 0;
  801b17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b1f:	5b                   	pop    %ebx
  801b20:	5e                   	pop    %esi
  801b21:	5f                   	pop    %edi
  801b22:	5d                   	pop    %ebp
  801b23:	c3                   	ret    

00801b24 <devpipe_read>:
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	57                   	push   %edi
  801b28:	56                   	push   %esi
  801b29:	53                   	push   %ebx
  801b2a:	83 ec 18             	sub    $0x18,%esp
  801b2d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b30:	57                   	push   %edi
  801b31:	e8 66 f6 ff ff       	call   80119c <fd2data>
  801b36:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	be 00 00 00 00       	mov    $0x0,%esi
  801b40:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b43:	75 14                	jne    801b59 <devpipe_read+0x35>
	return i;
  801b45:	8b 45 10             	mov    0x10(%ebp),%eax
  801b48:	eb 02                	jmp    801b4c <devpipe_read+0x28>
				return i;
  801b4a:	89 f0                	mov    %esi,%eax
}
  801b4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5f                   	pop    %edi
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    
			sys_yield();
  801b54:	e8 04 f4 ff ff       	call   800f5d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b59:	8b 03                	mov    (%ebx),%eax
  801b5b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b5e:	75 18                	jne    801b78 <devpipe_read+0x54>
			if (i > 0)
  801b60:	85 f6                	test   %esi,%esi
  801b62:	75 e6                	jne    801b4a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801b64:	89 da                	mov    %ebx,%edx
  801b66:	89 f8                	mov    %edi,%eax
  801b68:	e8 d0 fe ff ff       	call   801a3d <_pipeisclosed>
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	74 e3                	je     801b54 <devpipe_read+0x30>
				return 0;
  801b71:	b8 00 00 00 00       	mov    $0x0,%eax
  801b76:	eb d4                	jmp    801b4c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b78:	99                   	cltd   
  801b79:	c1 ea 1b             	shr    $0x1b,%edx
  801b7c:	01 d0                	add    %edx,%eax
  801b7e:	83 e0 1f             	and    $0x1f,%eax
  801b81:	29 d0                	sub    %edx,%eax
  801b83:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b8b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b8e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b91:	83 c6 01             	add    $0x1,%esi
  801b94:	eb aa                	jmp    801b40 <devpipe_read+0x1c>

00801b96 <pipe>:
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	56                   	push   %esi
  801b9a:	53                   	push   %ebx
  801b9b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba1:	50                   	push   %eax
  801ba2:	e8 0c f6 ff ff       	call   8011b3 <fd_alloc>
  801ba7:	89 c3                	mov    %eax,%ebx
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	85 c0                	test   %eax,%eax
  801bae:	0f 88 23 01 00 00    	js     801cd7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	68 07 04 00 00       	push   $0x407
  801bbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbf:	6a 00                	push   $0x0
  801bc1:	e8 b6 f3 ff ff       	call   800f7c <sys_page_alloc>
  801bc6:	89 c3                	mov    %eax,%ebx
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	0f 88 04 01 00 00    	js     801cd7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801bd3:	83 ec 0c             	sub    $0xc,%esp
  801bd6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bd9:	50                   	push   %eax
  801bda:	e8 d4 f5 ff ff       	call   8011b3 <fd_alloc>
  801bdf:	89 c3                	mov    %eax,%ebx
  801be1:	83 c4 10             	add    $0x10,%esp
  801be4:	85 c0                	test   %eax,%eax
  801be6:	0f 88 db 00 00 00    	js     801cc7 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bec:	83 ec 04             	sub    $0x4,%esp
  801bef:	68 07 04 00 00       	push   $0x407
  801bf4:	ff 75 f0             	pushl  -0x10(%ebp)
  801bf7:	6a 00                	push   $0x0
  801bf9:	e8 7e f3 ff ff       	call   800f7c <sys_page_alloc>
  801bfe:	89 c3                	mov    %eax,%ebx
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	85 c0                	test   %eax,%eax
  801c05:	0f 88 bc 00 00 00    	js     801cc7 <pipe+0x131>
	va = fd2data(fd0);
  801c0b:	83 ec 0c             	sub    $0xc,%esp
  801c0e:	ff 75 f4             	pushl  -0xc(%ebp)
  801c11:	e8 86 f5 ff ff       	call   80119c <fd2data>
  801c16:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c18:	83 c4 0c             	add    $0xc,%esp
  801c1b:	68 07 04 00 00       	push   $0x407
  801c20:	50                   	push   %eax
  801c21:	6a 00                	push   $0x0
  801c23:	e8 54 f3 ff ff       	call   800f7c <sys_page_alloc>
  801c28:	89 c3                	mov    %eax,%ebx
  801c2a:	83 c4 10             	add    $0x10,%esp
  801c2d:	85 c0                	test   %eax,%eax
  801c2f:	0f 88 82 00 00 00    	js     801cb7 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c35:	83 ec 0c             	sub    $0xc,%esp
  801c38:	ff 75 f0             	pushl  -0x10(%ebp)
  801c3b:	e8 5c f5 ff ff       	call   80119c <fd2data>
  801c40:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c47:	50                   	push   %eax
  801c48:	6a 00                	push   $0x0
  801c4a:	56                   	push   %esi
  801c4b:	6a 00                	push   $0x0
  801c4d:	e8 6d f3 ff ff       	call   800fbf <sys_page_map>
  801c52:	89 c3                	mov    %eax,%ebx
  801c54:	83 c4 20             	add    $0x20,%esp
  801c57:	85 c0                	test   %eax,%eax
  801c59:	78 4e                	js     801ca9 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801c5b:	a1 24 30 80 00       	mov    0x803024,%eax
  801c60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c63:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c68:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c72:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c77:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c7e:	83 ec 0c             	sub    $0xc,%esp
  801c81:	ff 75 f4             	pushl  -0xc(%ebp)
  801c84:	e8 03 f5 ff ff       	call   80118c <fd2num>
  801c89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c8c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c8e:	83 c4 04             	add    $0x4,%esp
  801c91:	ff 75 f0             	pushl  -0x10(%ebp)
  801c94:	e8 f3 f4 ff ff       	call   80118c <fd2num>
  801c99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c9c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c9f:	83 c4 10             	add    $0x10,%esp
  801ca2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ca7:	eb 2e                	jmp    801cd7 <pipe+0x141>
	sys_page_unmap(0, va);
  801ca9:	83 ec 08             	sub    $0x8,%esp
  801cac:	56                   	push   %esi
  801cad:	6a 00                	push   $0x0
  801caf:	e8 4d f3 ff ff       	call   801001 <sys_page_unmap>
  801cb4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801cb7:	83 ec 08             	sub    $0x8,%esp
  801cba:	ff 75 f0             	pushl  -0x10(%ebp)
  801cbd:	6a 00                	push   $0x0
  801cbf:	e8 3d f3 ff ff       	call   801001 <sys_page_unmap>
  801cc4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801cc7:	83 ec 08             	sub    $0x8,%esp
  801cca:	ff 75 f4             	pushl  -0xc(%ebp)
  801ccd:	6a 00                	push   $0x0
  801ccf:	e8 2d f3 ff ff       	call   801001 <sys_page_unmap>
  801cd4:	83 c4 10             	add    $0x10,%esp
}
  801cd7:	89 d8                	mov    %ebx,%eax
  801cd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cdc:	5b                   	pop    %ebx
  801cdd:	5e                   	pop    %esi
  801cde:	5d                   	pop    %ebp
  801cdf:	c3                   	ret    

00801ce0 <pipeisclosed>:
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ce6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce9:	50                   	push   %eax
  801cea:	ff 75 08             	pushl  0x8(%ebp)
  801ced:	e8 13 f5 ff ff       	call   801205 <fd_lookup>
  801cf2:	83 c4 10             	add    $0x10,%esp
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	78 18                	js     801d11 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801cf9:	83 ec 0c             	sub    $0xc,%esp
  801cfc:	ff 75 f4             	pushl  -0xc(%ebp)
  801cff:	e8 98 f4 ff ff       	call   80119c <fd2data>
	return _pipeisclosed(fd, p);
  801d04:	89 c2                	mov    %eax,%edx
  801d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d09:	e8 2f fd ff ff       	call   801a3d <_pipeisclosed>
  801d0e:	83 c4 10             	add    $0x10,%esp
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d19:	68 1a 2c 80 00       	push   $0x802c1a
  801d1e:	ff 75 0c             	pushl  0xc(%ebp)
  801d21:	e8 64 ee ff ff       	call   800b8a <strcpy>
	return 0;
}
  801d26:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <devsock_close>:
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	53                   	push   %ebx
  801d31:	83 ec 10             	sub    $0x10,%esp
  801d34:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d37:	53                   	push   %ebx
  801d38:	e8 10 07 00 00       	call   80244d <pageref>
  801d3d:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d40:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d45:	83 f8 01             	cmp    $0x1,%eax
  801d48:	74 07                	je     801d51 <devsock_close+0x24>
}
  801d4a:	89 d0                	mov    %edx,%eax
  801d4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d51:	83 ec 0c             	sub    $0xc,%esp
  801d54:	ff 73 0c             	pushl  0xc(%ebx)
  801d57:	e8 b9 02 00 00       	call   802015 <nsipc_close>
  801d5c:	89 c2                	mov    %eax,%edx
  801d5e:	83 c4 10             	add    $0x10,%esp
  801d61:	eb e7                	jmp    801d4a <devsock_close+0x1d>

00801d63 <devsock_write>:
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	ff 75 10             	pushl  0x10(%ebp)
  801d6e:	ff 75 0c             	pushl  0xc(%ebp)
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	ff 70 0c             	pushl  0xc(%eax)
  801d77:	e8 76 03 00 00       	call   8020f2 <nsipc_send>
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <devsock_read>:
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	ff 75 10             	pushl  0x10(%ebp)
  801d89:	ff 75 0c             	pushl  0xc(%ebp)
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	ff 70 0c             	pushl  0xc(%eax)
  801d92:	e8 ef 02 00 00       	call   802086 <nsipc_recv>
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <fd2sockid>:
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d9f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801da2:	52                   	push   %edx
  801da3:	50                   	push   %eax
  801da4:	e8 5c f4 ff ff       	call   801205 <fd_lookup>
  801da9:	83 c4 10             	add    $0x10,%esp
  801dac:	85 c0                	test   %eax,%eax
  801dae:	78 10                	js     801dc0 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db3:	8b 0d 40 30 80 00    	mov    0x803040,%ecx
  801db9:	39 08                	cmp    %ecx,(%eax)
  801dbb:	75 05                	jne    801dc2 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801dbd:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    
		return -E_NOT_SUPP;
  801dc2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801dc7:	eb f7                	jmp    801dc0 <fd2sockid+0x27>

00801dc9 <alloc_sockfd>:
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	56                   	push   %esi
  801dcd:	53                   	push   %ebx
  801dce:	83 ec 1c             	sub    $0x1c,%esp
  801dd1:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801dd3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd6:	50                   	push   %eax
  801dd7:	e8 d7 f3 ff ff       	call   8011b3 <fd_alloc>
  801ddc:	89 c3                	mov    %eax,%ebx
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	85 c0                	test   %eax,%eax
  801de3:	78 43                	js     801e28 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801de5:	83 ec 04             	sub    $0x4,%esp
  801de8:	68 07 04 00 00       	push   $0x407
  801ded:	ff 75 f4             	pushl  -0xc(%ebp)
  801df0:	6a 00                	push   $0x0
  801df2:	e8 85 f1 ff ff       	call   800f7c <sys_page_alloc>
  801df7:	89 c3                	mov    %eax,%ebx
  801df9:	83 c4 10             	add    $0x10,%esp
  801dfc:	85 c0                	test   %eax,%eax
  801dfe:	78 28                	js     801e28 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e03:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801e09:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e15:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e18:	83 ec 0c             	sub    $0xc,%esp
  801e1b:	50                   	push   %eax
  801e1c:	e8 6b f3 ff ff       	call   80118c <fd2num>
  801e21:	89 c3                	mov    %eax,%ebx
  801e23:	83 c4 10             	add    $0x10,%esp
  801e26:	eb 0c                	jmp    801e34 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e28:	83 ec 0c             	sub    $0xc,%esp
  801e2b:	56                   	push   %esi
  801e2c:	e8 e4 01 00 00       	call   802015 <nsipc_close>
		return r;
  801e31:	83 c4 10             	add    $0x10,%esp
}
  801e34:	89 d8                	mov    %ebx,%eax
  801e36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e39:	5b                   	pop    %ebx
  801e3a:	5e                   	pop    %esi
  801e3b:	5d                   	pop    %ebp
  801e3c:	c3                   	ret    

00801e3d <accept>:
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e43:	8b 45 08             	mov    0x8(%ebp),%eax
  801e46:	e8 4e ff ff ff       	call   801d99 <fd2sockid>
  801e4b:	85 c0                	test   %eax,%eax
  801e4d:	78 1b                	js     801e6a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e4f:	83 ec 04             	sub    $0x4,%esp
  801e52:	ff 75 10             	pushl  0x10(%ebp)
  801e55:	ff 75 0c             	pushl  0xc(%ebp)
  801e58:	50                   	push   %eax
  801e59:	e8 0e 01 00 00       	call   801f6c <nsipc_accept>
  801e5e:	83 c4 10             	add    $0x10,%esp
  801e61:	85 c0                	test   %eax,%eax
  801e63:	78 05                	js     801e6a <accept+0x2d>
	return alloc_sockfd(r);
  801e65:	e8 5f ff ff ff       	call   801dc9 <alloc_sockfd>
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <bind>:
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	e8 1f ff ff ff       	call   801d99 <fd2sockid>
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	78 12                	js     801e90 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e7e:	83 ec 04             	sub    $0x4,%esp
  801e81:	ff 75 10             	pushl  0x10(%ebp)
  801e84:	ff 75 0c             	pushl  0xc(%ebp)
  801e87:	50                   	push   %eax
  801e88:	e8 31 01 00 00       	call   801fbe <nsipc_bind>
  801e8d:	83 c4 10             	add    $0x10,%esp
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <shutdown>:
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	e8 f9 fe ff ff       	call   801d99 <fd2sockid>
  801ea0:	85 c0                	test   %eax,%eax
  801ea2:	78 0f                	js     801eb3 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ea4:	83 ec 08             	sub    $0x8,%esp
  801ea7:	ff 75 0c             	pushl  0xc(%ebp)
  801eaa:	50                   	push   %eax
  801eab:	e8 43 01 00 00       	call   801ff3 <nsipc_shutdown>
  801eb0:	83 c4 10             	add    $0x10,%esp
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <connect>:
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	e8 d6 fe ff ff       	call   801d99 <fd2sockid>
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	78 12                	js     801ed9 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ec7:	83 ec 04             	sub    $0x4,%esp
  801eca:	ff 75 10             	pushl  0x10(%ebp)
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	50                   	push   %eax
  801ed1:	e8 59 01 00 00       	call   80202f <nsipc_connect>
  801ed6:	83 c4 10             	add    $0x10,%esp
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <listen>:
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	e8 b0 fe ff ff       	call   801d99 <fd2sockid>
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	78 0f                	js     801efc <listen+0x21>
	return nsipc_listen(r, backlog);
  801eed:	83 ec 08             	sub    $0x8,%esp
  801ef0:	ff 75 0c             	pushl  0xc(%ebp)
  801ef3:	50                   	push   %eax
  801ef4:	e8 6b 01 00 00       	call   802064 <nsipc_listen>
  801ef9:	83 c4 10             	add    $0x10,%esp
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <socket>:

int
socket(int domain, int type, int protocol)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f04:	ff 75 10             	pushl  0x10(%ebp)
  801f07:	ff 75 0c             	pushl  0xc(%ebp)
  801f0a:	ff 75 08             	pushl  0x8(%ebp)
  801f0d:	e8 3e 02 00 00       	call   802150 <nsipc_socket>
  801f12:	83 c4 10             	add    $0x10,%esp
  801f15:	85 c0                	test   %eax,%eax
  801f17:	78 05                	js     801f1e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f19:	e8 ab fe ff ff       	call   801dc9 <alloc_sockfd>
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	53                   	push   %ebx
  801f24:	83 ec 04             	sub    $0x4,%esp
  801f27:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f29:	83 3d 14 40 80 00 00 	cmpl   $0x0,0x804014
  801f30:	74 26                	je     801f58 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f32:	6a 07                	push   $0x7
  801f34:	68 00 60 80 00       	push   $0x806000
  801f39:	53                   	push   %ebx
  801f3a:	ff 35 14 40 80 00    	pushl  0x804014
  801f40:	e8 63 04 00 00       	call   8023a8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f45:	83 c4 0c             	add    $0xc,%esp
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	e8 e2 03 00 00       	call   802335 <ipc_recv>
}
  801f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f58:	83 ec 0c             	sub    $0xc,%esp
  801f5b:	6a 02                	push   $0x2
  801f5d:	e8 b2 04 00 00       	call   802414 <ipc_find_env>
  801f62:	a3 14 40 80 00       	mov    %eax,0x804014
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	eb c6                	jmp    801f32 <nsipc+0x12>

00801f6c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	56                   	push   %esi
  801f70:	53                   	push   %ebx
  801f71:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f7c:	8b 06                	mov    (%esi),%eax
  801f7e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f83:	b8 01 00 00 00       	mov    $0x1,%eax
  801f88:	e8 93 ff ff ff       	call   801f20 <nsipc>
  801f8d:	89 c3                	mov    %eax,%ebx
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	79 09                	jns    801f9c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f93:	89 d8                	mov    %ebx,%eax
  801f95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f98:	5b                   	pop    %ebx
  801f99:	5e                   	pop    %esi
  801f9a:	5d                   	pop    %ebp
  801f9b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f9c:	83 ec 04             	sub    $0x4,%esp
  801f9f:	ff 35 10 60 80 00    	pushl  0x806010
  801fa5:	68 00 60 80 00       	push   $0x806000
  801faa:	ff 75 0c             	pushl  0xc(%ebp)
  801fad:	e8 66 ed ff ff       	call   800d18 <memmove>
		*addrlen = ret->ret_addrlen;
  801fb2:	a1 10 60 80 00       	mov    0x806010,%eax
  801fb7:	89 06                	mov    %eax,(%esi)
  801fb9:	83 c4 10             	add    $0x10,%esp
	return r;
  801fbc:	eb d5                	jmp    801f93 <nsipc_accept+0x27>

00801fbe <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	53                   	push   %ebx
  801fc2:	83 ec 08             	sub    $0x8,%esp
  801fc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fd0:	53                   	push   %ebx
  801fd1:	ff 75 0c             	pushl  0xc(%ebp)
  801fd4:	68 04 60 80 00       	push   $0x806004
  801fd9:	e8 3a ed ff ff       	call   800d18 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fde:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801fe4:	b8 02 00 00 00       	mov    $0x2,%eax
  801fe9:	e8 32 ff ff ff       	call   801f20 <nsipc>
}
  801fee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802001:	8b 45 0c             	mov    0xc(%ebp),%eax
  802004:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802009:	b8 03 00 00 00       	mov    $0x3,%eax
  80200e:	e8 0d ff ff ff       	call   801f20 <nsipc>
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <nsipc_close>:

int
nsipc_close(int s)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802023:	b8 04 00 00 00       	mov    $0x4,%eax
  802028:	e8 f3 fe ff ff       	call   801f20 <nsipc>
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	53                   	push   %ebx
  802033:	83 ec 08             	sub    $0x8,%esp
  802036:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802041:	53                   	push   %ebx
  802042:	ff 75 0c             	pushl  0xc(%ebp)
  802045:	68 04 60 80 00       	push   $0x806004
  80204a:	e8 c9 ec ff ff       	call   800d18 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80204f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802055:	b8 05 00 00 00       	mov    $0x5,%eax
  80205a:	e8 c1 fe ff ff       	call   801f20 <nsipc>
}
  80205f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802072:	8b 45 0c             	mov    0xc(%ebp),%eax
  802075:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80207a:	b8 06 00 00 00       	mov    $0x6,%eax
  80207f:	e8 9c fe ff ff       	call   801f20 <nsipc>
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	56                   	push   %esi
  80208a:	53                   	push   %ebx
  80208b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802096:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80209c:	8b 45 14             	mov    0x14(%ebp),%eax
  80209f:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020a4:	b8 07 00 00 00       	mov    $0x7,%eax
  8020a9:	e8 72 fe ff ff       	call   801f20 <nsipc>
  8020ae:	89 c3                	mov    %eax,%ebx
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	78 1f                	js     8020d3 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8020b4:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020b9:	7f 21                	jg     8020dc <nsipc_recv+0x56>
  8020bb:	39 c6                	cmp    %eax,%esi
  8020bd:	7c 1d                	jl     8020dc <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020bf:	83 ec 04             	sub    $0x4,%esp
  8020c2:	50                   	push   %eax
  8020c3:	68 00 60 80 00       	push   $0x806000
  8020c8:	ff 75 0c             	pushl  0xc(%ebp)
  8020cb:	e8 48 ec ff ff       	call   800d18 <memmove>
  8020d0:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020d3:	89 d8                	mov    %ebx,%eax
  8020d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d8:	5b                   	pop    %ebx
  8020d9:	5e                   	pop    %esi
  8020da:	5d                   	pop    %ebp
  8020db:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020dc:	68 26 2c 80 00       	push   $0x802c26
  8020e1:	68 c8 2b 80 00       	push   $0x802bc8
  8020e6:	6a 62                	push   $0x62
  8020e8:	68 3b 2c 80 00       	push   $0x802c3b
  8020ed:	e8 fd 01 00 00       	call   8022ef <_panic>

008020f2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	53                   	push   %ebx
  8020f6:	83 ec 04             	sub    $0x4,%esp
  8020f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802104:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80210a:	7f 2e                	jg     80213a <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80210c:	83 ec 04             	sub    $0x4,%esp
  80210f:	53                   	push   %ebx
  802110:	ff 75 0c             	pushl  0xc(%ebp)
  802113:	68 0c 60 80 00       	push   $0x80600c
  802118:	e8 fb eb ff ff       	call   800d18 <memmove>
	nsipcbuf.send.req_size = size;
  80211d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802123:	8b 45 14             	mov    0x14(%ebp),%eax
  802126:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80212b:	b8 08 00 00 00       	mov    $0x8,%eax
  802130:	e8 eb fd ff ff       	call   801f20 <nsipc>
}
  802135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802138:	c9                   	leave  
  802139:	c3                   	ret    
	assert(size < 1600);
  80213a:	68 47 2c 80 00       	push   $0x802c47
  80213f:	68 c8 2b 80 00       	push   $0x802bc8
  802144:	6a 6d                	push   $0x6d
  802146:	68 3b 2c 80 00       	push   $0x802c3b
  80214b:	e8 9f 01 00 00       	call   8022ef <_panic>

00802150 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80215e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802161:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802166:	8b 45 10             	mov    0x10(%ebp),%eax
  802169:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80216e:	b8 09 00 00 00       	mov    $0x9,%eax
  802173:	e8 a8 fd ff ff       	call   801f20 <nsipc>
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80217a:	b8 00 00 00 00       	mov    $0x0,%eax
  80217f:	c3                   	ret    

00802180 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802186:	68 53 2c 80 00       	push   $0x802c53
  80218b:	ff 75 0c             	pushl  0xc(%ebp)
  80218e:	e8 f7 e9 ff ff       	call   800b8a <strcpy>
	return 0;
}
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <devcons_write>:
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	57                   	push   %edi
  80219e:	56                   	push   %esi
  80219f:	53                   	push   %ebx
  8021a0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021a6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021b1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021b4:	73 31                	jae    8021e7 <devcons_write+0x4d>
		m = n - tot;
  8021b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021b9:	29 f3                	sub    %esi,%ebx
  8021bb:	83 fb 7f             	cmp    $0x7f,%ebx
  8021be:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021c3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021c6:	83 ec 04             	sub    $0x4,%esp
  8021c9:	53                   	push   %ebx
  8021ca:	89 f0                	mov    %esi,%eax
  8021cc:	03 45 0c             	add    0xc(%ebp),%eax
  8021cf:	50                   	push   %eax
  8021d0:	57                   	push   %edi
  8021d1:	e8 42 eb ff ff       	call   800d18 <memmove>
		sys_cputs(buf, m);
  8021d6:	83 c4 08             	add    $0x8,%esp
  8021d9:	53                   	push   %ebx
  8021da:	57                   	push   %edi
  8021db:	e8 e0 ec ff ff       	call   800ec0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021e0:	01 de                	add    %ebx,%esi
  8021e2:	83 c4 10             	add    $0x10,%esp
  8021e5:	eb ca                	jmp    8021b1 <devcons_write+0x17>
}
  8021e7:	89 f0                	mov    %esi,%eax
  8021e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021ec:	5b                   	pop    %ebx
  8021ed:	5e                   	pop    %esi
  8021ee:	5f                   	pop    %edi
  8021ef:	5d                   	pop    %ebp
  8021f0:	c3                   	ret    

008021f1 <devcons_read>:
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	83 ec 08             	sub    $0x8,%esp
  8021f7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802200:	74 21                	je     802223 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802202:	e8 d7 ec ff ff       	call   800ede <sys_cgetc>
  802207:	85 c0                	test   %eax,%eax
  802209:	75 07                	jne    802212 <devcons_read+0x21>
		sys_yield();
  80220b:	e8 4d ed ff ff       	call   800f5d <sys_yield>
  802210:	eb f0                	jmp    802202 <devcons_read+0x11>
	if (c < 0)
  802212:	78 0f                	js     802223 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802214:	83 f8 04             	cmp    $0x4,%eax
  802217:	74 0c                	je     802225 <devcons_read+0x34>
	*(char*)vbuf = c;
  802219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221c:	88 02                	mov    %al,(%edx)
	return 1;
  80221e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    
		return 0;
  802225:	b8 00 00 00 00       	mov    $0x0,%eax
  80222a:	eb f7                	jmp    802223 <devcons_read+0x32>

0080222c <cputchar>:
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802238:	6a 01                	push   $0x1
  80223a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80223d:	50                   	push   %eax
  80223e:	e8 7d ec ff ff       	call   800ec0 <sys_cputs>
}
  802243:	83 c4 10             	add    $0x10,%esp
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <getchar>:
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80224e:	6a 01                	push   $0x1
  802250:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802253:	50                   	push   %eax
  802254:	6a 00                	push   $0x0
  802256:	e8 1a f2 ff ff       	call   801475 <read>
	if (r < 0)
  80225b:	83 c4 10             	add    $0x10,%esp
  80225e:	85 c0                	test   %eax,%eax
  802260:	78 06                	js     802268 <getchar+0x20>
	if (r < 1)
  802262:	74 06                	je     80226a <getchar+0x22>
	return c;
  802264:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    
		return -E_EOF;
  80226a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80226f:	eb f7                	jmp    802268 <getchar+0x20>

00802271 <iscons>:
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802277:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80227a:	50                   	push   %eax
  80227b:	ff 75 08             	pushl  0x8(%ebp)
  80227e:	e8 82 ef ff ff       	call   801205 <fd_lookup>
  802283:	83 c4 10             	add    $0x10,%esp
  802286:	85 c0                	test   %eax,%eax
  802288:	78 11                	js     80229b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802293:	39 10                	cmp    %edx,(%eax)
  802295:	0f 94 c0             	sete   %al
  802298:	0f b6 c0             	movzbl %al,%eax
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <opencons>:
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
  8022a0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022a6:	50                   	push   %eax
  8022a7:	e8 07 ef ff ff       	call   8011b3 <fd_alloc>
  8022ac:	83 c4 10             	add    $0x10,%esp
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	78 3a                	js     8022ed <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022b3:	83 ec 04             	sub    $0x4,%esp
  8022b6:	68 07 04 00 00       	push   $0x407
  8022bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8022be:	6a 00                	push   $0x0
  8022c0:	e8 b7 ec ff ff       	call   800f7c <sys_page_alloc>
  8022c5:	83 c4 10             	add    $0x10,%esp
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	78 21                	js     8022ed <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8022d5:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022e1:	83 ec 0c             	sub    $0xc,%esp
  8022e4:	50                   	push   %eax
  8022e5:	e8 a2 ee ff ff       	call   80118c <fd2num>
  8022ea:	83 c4 10             	add    $0x10,%esp
}
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    

008022ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
  8022f2:	56                   	push   %esi
  8022f3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8022f4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022f7:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8022fd:	e8 3c ec ff ff       	call   800f3e <sys_getenvid>
  802302:	83 ec 0c             	sub    $0xc,%esp
  802305:	ff 75 0c             	pushl  0xc(%ebp)
  802308:	ff 75 08             	pushl  0x8(%ebp)
  80230b:	56                   	push   %esi
  80230c:	50                   	push   %eax
  80230d:	68 60 2c 80 00       	push   $0x802c60
  802312:	e8 97 e2 ff ff       	call   8005ae <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802317:	83 c4 18             	add    $0x18,%esp
  80231a:	53                   	push   %ebx
  80231b:	ff 75 10             	pushl  0x10(%ebp)
  80231e:	e8 3a e2 ff ff       	call   80055d <vcprintf>
	cprintf("\n");
  802323:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  80232a:	e8 7f e2 ff ff       	call   8005ae <cprintf>
  80232f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802332:	cc                   	int3   
  802333:	eb fd                	jmp    802332 <_panic+0x43>

00802335 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	56                   	push   %esi
  802339:	53                   	push   %ebx
  80233a:	8b 75 08             	mov    0x8(%ebp),%esi
  80233d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802340:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802343:	85 c0                	test   %eax,%eax
  802345:	74 4f                	je     802396 <ipc_recv+0x61>
  802347:	83 ec 0c             	sub    $0xc,%esp
  80234a:	50                   	push   %eax
  80234b:	e8 dc ed ff ff       	call   80112c <sys_ipc_recv>
  802350:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  802353:	85 f6                	test   %esi,%esi
  802355:	74 14                	je     80236b <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  802357:	ba 00 00 00 00       	mov    $0x0,%edx
  80235c:	85 c0                	test   %eax,%eax
  80235e:	75 09                	jne    802369 <ipc_recv+0x34>
  802360:	8b 15 18 40 80 00    	mov    0x804018,%edx
  802366:	8b 52 74             	mov    0x74(%edx),%edx
  802369:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  80236b:	85 db                	test   %ebx,%ebx
  80236d:	74 14                	je     802383 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  80236f:	ba 00 00 00 00       	mov    $0x0,%edx
  802374:	85 c0                	test   %eax,%eax
  802376:	75 09                	jne    802381 <ipc_recv+0x4c>
  802378:	8b 15 18 40 80 00    	mov    0x804018,%edx
  80237e:	8b 52 78             	mov    0x78(%edx),%edx
  802381:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  802383:	85 c0                	test   %eax,%eax
  802385:	75 08                	jne    80238f <ipc_recv+0x5a>
  802387:	a1 18 40 80 00       	mov    0x804018,%eax
  80238c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80238f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802392:	5b                   	pop    %ebx
  802393:	5e                   	pop    %esi
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802396:	83 ec 0c             	sub    $0xc,%esp
  802399:	68 00 00 c0 ee       	push   $0xeec00000
  80239e:	e8 89 ed ff ff       	call   80112c <sys_ipc_recv>
  8023a3:	83 c4 10             	add    $0x10,%esp
  8023a6:	eb ab                	jmp    802353 <ipc_recv+0x1e>

008023a8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
  8023ab:	57                   	push   %edi
  8023ac:	56                   	push   %esi
  8023ad:	53                   	push   %ebx
  8023ae:	83 ec 0c             	sub    $0xc,%esp
  8023b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023b4:	8b 75 10             	mov    0x10(%ebp),%esi
  8023b7:	eb 20                	jmp    8023d9 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8023b9:	6a 00                	push   $0x0
  8023bb:	68 00 00 c0 ee       	push   $0xeec00000
  8023c0:	ff 75 0c             	pushl  0xc(%ebp)
  8023c3:	57                   	push   %edi
  8023c4:	e8 40 ed ff ff       	call   801109 <sys_ipc_try_send>
  8023c9:	89 c3                	mov    %eax,%ebx
  8023cb:	83 c4 10             	add    $0x10,%esp
  8023ce:	eb 1f                	jmp    8023ef <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  8023d0:	e8 88 eb ff ff       	call   800f5d <sys_yield>
	while(retval != 0) {
  8023d5:	85 db                	test   %ebx,%ebx
  8023d7:	74 33                	je     80240c <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8023d9:	85 f6                	test   %esi,%esi
  8023db:	74 dc                	je     8023b9 <ipc_send+0x11>
  8023dd:	ff 75 14             	pushl  0x14(%ebp)
  8023e0:	56                   	push   %esi
  8023e1:	ff 75 0c             	pushl  0xc(%ebp)
  8023e4:	57                   	push   %edi
  8023e5:	e8 1f ed ff ff       	call   801109 <sys_ipc_try_send>
  8023ea:	89 c3                	mov    %eax,%ebx
  8023ec:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  8023ef:	83 fb f9             	cmp    $0xfffffff9,%ebx
  8023f2:	74 dc                	je     8023d0 <ipc_send+0x28>
  8023f4:	85 db                	test   %ebx,%ebx
  8023f6:	74 d8                	je     8023d0 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  8023f8:	83 ec 04             	sub    $0x4,%esp
  8023fb:	68 84 2c 80 00       	push   $0x802c84
  802400:	6a 35                	push   $0x35
  802402:	68 b4 2c 80 00       	push   $0x802cb4
  802407:	e8 e3 fe ff ff       	call   8022ef <_panic>
	}
}
  80240c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80240f:	5b                   	pop    %ebx
  802410:	5e                   	pop    %esi
  802411:	5f                   	pop    %edi
  802412:	5d                   	pop    %ebp
  802413:	c3                   	ret    

00802414 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80241a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80241f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802422:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802428:	8b 52 50             	mov    0x50(%edx),%edx
  80242b:	39 ca                	cmp    %ecx,%edx
  80242d:	74 11                	je     802440 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80242f:	83 c0 01             	add    $0x1,%eax
  802432:	3d 00 04 00 00       	cmp    $0x400,%eax
  802437:	75 e6                	jne    80241f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802439:	b8 00 00 00 00       	mov    $0x0,%eax
  80243e:	eb 0b                	jmp    80244b <ipc_find_env+0x37>
			return envs[i].env_id;
  802440:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802443:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802448:	8b 40 48             	mov    0x48(%eax),%eax
}
  80244b:	5d                   	pop    %ebp
  80244c:	c3                   	ret    

0080244d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
  802450:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802453:	89 d0                	mov    %edx,%eax
  802455:	c1 e8 16             	shr    $0x16,%eax
  802458:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80245f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802464:	f6 c1 01             	test   $0x1,%cl
  802467:	74 1d                	je     802486 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802469:	c1 ea 0c             	shr    $0xc,%edx
  80246c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802473:	f6 c2 01             	test   $0x1,%dl
  802476:	74 0e                	je     802486 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802478:	c1 ea 0c             	shr    $0xc,%edx
  80247b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802482:	ef 
  802483:	0f b7 c0             	movzwl %ax,%eax
}
  802486:	5d                   	pop    %ebp
  802487:	c3                   	ret    
  802488:	66 90                	xchg   %ax,%ax
  80248a:	66 90                	xchg   %ax,%ax
  80248c:	66 90                	xchg   %ax,%ax
  80248e:	66 90                	xchg   %ax,%ax

00802490 <__udivdi3>:
  802490:	f3 0f 1e fb          	endbr32 
  802494:	55                   	push   %ebp
  802495:	57                   	push   %edi
  802496:	56                   	push   %esi
  802497:	53                   	push   %ebx
  802498:	83 ec 1c             	sub    $0x1c,%esp
  80249b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80249f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024ab:	85 d2                	test   %edx,%edx
  8024ad:	75 49                	jne    8024f8 <__udivdi3+0x68>
  8024af:	39 f3                	cmp    %esi,%ebx
  8024b1:	76 15                	jbe    8024c8 <__udivdi3+0x38>
  8024b3:	31 ff                	xor    %edi,%edi
  8024b5:	89 e8                	mov    %ebp,%eax
  8024b7:	89 f2                	mov    %esi,%edx
  8024b9:	f7 f3                	div    %ebx
  8024bb:	89 fa                	mov    %edi,%edx
  8024bd:	83 c4 1c             	add    $0x1c,%esp
  8024c0:	5b                   	pop    %ebx
  8024c1:	5e                   	pop    %esi
  8024c2:	5f                   	pop    %edi
  8024c3:	5d                   	pop    %ebp
  8024c4:	c3                   	ret    
  8024c5:	8d 76 00             	lea    0x0(%esi),%esi
  8024c8:	89 d9                	mov    %ebx,%ecx
  8024ca:	85 db                	test   %ebx,%ebx
  8024cc:	75 0b                	jne    8024d9 <__udivdi3+0x49>
  8024ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d3:	31 d2                	xor    %edx,%edx
  8024d5:	f7 f3                	div    %ebx
  8024d7:	89 c1                	mov    %eax,%ecx
  8024d9:	31 d2                	xor    %edx,%edx
  8024db:	89 f0                	mov    %esi,%eax
  8024dd:	f7 f1                	div    %ecx
  8024df:	89 c6                	mov    %eax,%esi
  8024e1:	89 e8                	mov    %ebp,%eax
  8024e3:	89 f7                	mov    %esi,%edi
  8024e5:	f7 f1                	div    %ecx
  8024e7:	89 fa                	mov    %edi,%edx
  8024e9:	83 c4 1c             	add    $0x1c,%esp
  8024ec:	5b                   	pop    %ebx
  8024ed:	5e                   	pop    %esi
  8024ee:	5f                   	pop    %edi
  8024ef:	5d                   	pop    %ebp
  8024f0:	c3                   	ret    
  8024f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024f8:	39 f2                	cmp    %esi,%edx
  8024fa:	77 1c                	ja     802518 <__udivdi3+0x88>
  8024fc:	0f bd fa             	bsr    %edx,%edi
  8024ff:	83 f7 1f             	xor    $0x1f,%edi
  802502:	75 2c                	jne    802530 <__udivdi3+0xa0>
  802504:	39 f2                	cmp    %esi,%edx
  802506:	72 06                	jb     80250e <__udivdi3+0x7e>
  802508:	31 c0                	xor    %eax,%eax
  80250a:	39 eb                	cmp    %ebp,%ebx
  80250c:	77 ad                	ja     8024bb <__udivdi3+0x2b>
  80250e:	b8 01 00 00 00       	mov    $0x1,%eax
  802513:	eb a6                	jmp    8024bb <__udivdi3+0x2b>
  802515:	8d 76 00             	lea    0x0(%esi),%esi
  802518:	31 ff                	xor    %edi,%edi
  80251a:	31 c0                	xor    %eax,%eax
  80251c:	89 fa                	mov    %edi,%edx
  80251e:	83 c4 1c             	add    $0x1c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    
  802526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	89 f9                	mov    %edi,%ecx
  802532:	b8 20 00 00 00       	mov    $0x20,%eax
  802537:	29 f8                	sub    %edi,%eax
  802539:	d3 e2                	shl    %cl,%edx
  80253b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80253f:	89 c1                	mov    %eax,%ecx
  802541:	89 da                	mov    %ebx,%edx
  802543:	d3 ea                	shr    %cl,%edx
  802545:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802549:	09 d1                	or     %edx,%ecx
  80254b:	89 f2                	mov    %esi,%edx
  80254d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802551:	89 f9                	mov    %edi,%ecx
  802553:	d3 e3                	shl    %cl,%ebx
  802555:	89 c1                	mov    %eax,%ecx
  802557:	d3 ea                	shr    %cl,%edx
  802559:	89 f9                	mov    %edi,%ecx
  80255b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80255f:	89 eb                	mov    %ebp,%ebx
  802561:	d3 e6                	shl    %cl,%esi
  802563:	89 c1                	mov    %eax,%ecx
  802565:	d3 eb                	shr    %cl,%ebx
  802567:	09 de                	or     %ebx,%esi
  802569:	89 f0                	mov    %esi,%eax
  80256b:	f7 74 24 08          	divl   0x8(%esp)
  80256f:	89 d6                	mov    %edx,%esi
  802571:	89 c3                	mov    %eax,%ebx
  802573:	f7 64 24 0c          	mull   0xc(%esp)
  802577:	39 d6                	cmp    %edx,%esi
  802579:	72 15                	jb     802590 <__udivdi3+0x100>
  80257b:	89 f9                	mov    %edi,%ecx
  80257d:	d3 e5                	shl    %cl,%ebp
  80257f:	39 c5                	cmp    %eax,%ebp
  802581:	73 04                	jae    802587 <__udivdi3+0xf7>
  802583:	39 d6                	cmp    %edx,%esi
  802585:	74 09                	je     802590 <__udivdi3+0x100>
  802587:	89 d8                	mov    %ebx,%eax
  802589:	31 ff                	xor    %edi,%edi
  80258b:	e9 2b ff ff ff       	jmp    8024bb <__udivdi3+0x2b>
  802590:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802593:	31 ff                	xor    %edi,%edi
  802595:	e9 21 ff ff ff       	jmp    8024bb <__udivdi3+0x2b>
  80259a:	66 90                	xchg   %ax,%ax
  80259c:	66 90                	xchg   %ax,%ax
  80259e:	66 90                	xchg   %ax,%ax

008025a0 <__umoddi3>:
  8025a0:	f3 0f 1e fb          	endbr32 
  8025a4:	55                   	push   %ebp
  8025a5:	57                   	push   %edi
  8025a6:	56                   	push   %esi
  8025a7:	53                   	push   %ebx
  8025a8:	83 ec 1c             	sub    $0x1c,%esp
  8025ab:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025b3:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025bb:	89 da                	mov    %ebx,%edx
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	75 3f                	jne    802600 <__umoddi3+0x60>
  8025c1:	39 df                	cmp    %ebx,%edi
  8025c3:	76 13                	jbe    8025d8 <__umoddi3+0x38>
  8025c5:	89 f0                	mov    %esi,%eax
  8025c7:	f7 f7                	div    %edi
  8025c9:	89 d0                	mov    %edx,%eax
  8025cb:	31 d2                	xor    %edx,%edx
  8025cd:	83 c4 1c             	add    $0x1c,%esp
  8025d0:	5b                   	pop    %ebx
  8025d1:	5e                   	pop    %esi
  8025d2:	5f                   	pop    %edi
  8025d3:	5d                   	pop    %ebp
  8025d4:	c3                   	ret    
  8025d5:	8d 76 00             	lea    0x0(%esi),%esi
  8025d8:	89 fd                	mov    %edi,%ebp
  8025da:	85 ff                	test   %edi,%edi
  8025dc:	75 0b                	jne    8025e9 <__umoddi3+0x49>
  8025de:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e3:	31 d2                	xor    %edx,%edx
  8025e5:	f7 f7                	div    %edi
  8025e7:	89 c5                	mov    %eax,%ebp
  8025e9:	89 d8                	mov    %ebx,%eax
  8025eb:	31 d2                	xor    %edx,%edx
  8025ed:	f7 f5                	div    %ebp
  8025ef:	89 f0                	mov    %esi,%eax
  8025f1:	f7 f5                	div    %ebp
  8025f3:	89 d0                	mov    %edx,%eax
  8025f5:	eb d4                	jmp    8025cb <__umoddi3+0x2b>
  8025f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025fe:	66 90                	xchg   %ax,%ax
  802600:	89 f1                	mov    %esi,%ecx
  802602:	39 d8                	cmp    %ebx,%eax
  802604:	76 0a                	jbe    802610 <__umoddi3+0x70>
  802606:	89 f0                	mov    %esi,%eax
  802608:	83 c4 1c             	add    $0x1c,%esp
  80260b:	5b                   	pop    %ebx
  80260c:	5e                   	pop    %esi
  80260d:	5f                   	pop    %edi
  80260e:	5d                   	pop    %ebp
  80260f:	c3                   	ret    
  802610:	0f bd e8             	bsr    %eax,%ebp
  802613:	83 f5 1f             	xor    $0x1f,%ebp
  802616:	75 20                	jne    802638 <__umoddi3+0x98>
  802618:	39 d8                	cmp    %ebx,%eax
  80261a:	0f 82 b0 00 00 00    	jb     8026d0 <__umoddi3+0x130>
  802620:	39 f7                	cmp    %esi,%edi
  802622:	0f 86 a8 00 00 00    	jbe    8026d0 <__umoddi3+0x130>
  802628:	89 c8                	mov    %ecx,%eax
  80262a:	83 c4 1c             	add    $0x1c,%esp
  80262d:	5b                   	pop    %ebx
  80262e:	5e                   	pop    %esi
  80262f:	5f                   	pop    %edi
  802630:	5d                   	pop    %ebp
  802631:	c3                   	ret    
  802632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802638:	89 e9                	mov    %ebp,%ecx
  80263a:	ba 20 00 00 00       	mov    $0x20,%edx
  80263f:	29 ea                	sub    %ebp,%edx
  802641:	d3 e0                	shl    %cl,%eax
  802643:	89 44 24 08          	mov    %eax,0x8(%esp)
  802647:	89 d1                	mov    %edx,%ecx
  802649:	89 f8                	mov    %edi,%eax
  80264b:	d3 e8                	shr    %cl,%eax
  80264d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802651:	89 54 24 04          	mov    %edx,0x4(%esp)
  802655:	8b 54 24 04          	mov    0x4(%esp),%edx
  802659:	09 c1                	or     %eax,%ecx
  80265b:	89 d8                	mov    %ebx,%eax
  80265d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802661:	89 e9                	mov    %ebp,%ecx
  802663:	d3 e7                	shl    %cl,%edi
  802665:	89 d1                	mov    %edx,%ecx
  802667:	d3 e8                	shr    %cl,%eax
  802669:	89 e9                	mov    %ebp,%ecx
  80266b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80266f:	d3 e3                	shl    %cl,%ebx
  802671:	89 c7                	mov    %eax,%edi
  802673:	89 d1                	mov    %edx,%ecx
  802675:	89 f0                	mov    %esi,%eax
  802677:	d3 e8                	shr    %cl,%eax
  802679:	89 e9                	mov    %ebp,%ecx
  80267b:	89 fa                	mov    %edi,%edx
  80267d:	d3 e6                	shl    %cl,%esi
  80267f:	09 d8                	or     %ebx,%eax
  802681:	f7 74 24 08          	divl   0x8(%esp)
  802685:	89 d1                	mov    %edx,%ecx
  802687:	89 f3                	mov    %esi,%ebx
  802689:	f7 64 24 0c          	mull   0xc(%esp)
  80268d:	89 c6                	mov    %eax,%esi
  80268f:	89 d7                	mov    %edx,%edi
  802691:	39 d1                	cmp    %edx,%ecx
  802693:	72 06                	jb     80269b <__umoddi3+0xfb>
  802695:	75 10                	jne    8026a7 <__umoddi3+0x107>
  802697:	39 c3                	cmp    %eax,%ebx
  802699:	73 0c                	jae    8026a7 <__umoddi3+0x107>
  80269b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80269f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8026a3:	89 d7                	mov    %edx,%edi
  8026a5:	89 c6                	mov    %eax,%esi
  8026a7:	89 ca                	mov    %ecx,%edx
  8026a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ae:	29 f3                	sub    %esi,%ebx
  8026b0:	19 fa                	sbb    %edi,%edx
  8026b2:	89 d0                	mov    %edx,%eax
  8026b4:	d3 e0                	shl    %cl,%eax
  8026b6:	89 e9                	mov    %ebp,%ecx
  8026b8:	d3 eb                	shr    %cl,%ebx
  8026ba:	d3 ea                	shr    %cl,%edx
  8026bc:	09 d8                	or     %ebx,%eax
  8026be:	83 c4 1c             	add    $0x1c,%esp
  8026c1:	5b                   	pop    %ebx
  8026c2:	5e                   	pop    %esi
  8026c3:	5f                   	pop    %edi
  8026c4:	5d                   	pop    %ebp
  8026c5:	c3                   	ret    
  8026c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026cd:	8d 76 00             	lea    0x0(%esi),%esi
  8026d0:	89 da                	mov    %ebx,%edx
  8026d2:	29 fe                	sub    %edi,%esi
  8026d4:	19 c2                	sbb    %eax,%edx
  8026d6:	89 f1                	mov    %esi,%ecx
  8026d8:	89 c8                	mov    %ecx,%eax
  8026da:	e9 4b ff ff ff       	jmp    80262a <__umoddi3+0x8a>
