
obj/net/testinput：     文件格式 elf32-i386


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
  80002c:	e8 15 07 00 00       	call   800746 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 7c             	sub    $0x7c,%esp
	envid_t ns_envid = sys_getenvid();
  80003c:	e8 d0 11 00 00       	call   801211 <sys_getenvid>
  800041:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800043:	c7 05 00 40 80 00 c0 	movl   $0x802dc0,0x804000
  80004a:	2d 80 00 

	output_envid = fork();
  80004d:	e8 84 15 00 00       	call   8015d6 <fork>
  800052:	a3 04 50 80 00       	mov    %eax,0x805004
	if (output_envid < 0)
  800057:	85 c0                	test   %eax,%eax
  800059:	0f 88 86 01 00 00    	js     8001e5 <umain+0x1b2>
		panic("error forking");
	else if (output_envid == 0) {
  80005f:	0f 84 94 01 00 00    	je     8001f9 <umain+0x1c6>
		output(ns_envid);
		return;
	}

	input_envid = fork();
  800065:	e8 6c 15 00 00       	call   8015d6 <fork>
  80006a:	a3 00 50 80 00       	mov    %eax,0x805000
	if (input_envid < 0)
  80006f:	85 c0                	test   %eax,%eax
  800071:	0f 88 96 01 00 00    	js     80020d <umain+0x1da>
		panic("error forking");
	else if (input_envid == 0) {
  800077:	0f 84 a4 01 00 00    	je     800221 <umain+0x1ee>
		input(ns_envid);
		return;
	}

	cprintf("Sending ARP announcement...\n");
  80007d:	83 ec 0c             	sub    $0xc,%esp
  800080:	68 e8 2d 80 00       	push   $0x802de8
  800085:	e8 f7 07 00 00       	call   800881 <cprintf>
	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80008a:	c6 45 98 52          	movb   $0x52,-0x68(%ebp)
  80008e:	c6 45 99 54          	movb   $0x54,-0x67(%ebp)
  800092:	c6 45 9a 00          	movb   $0x0,-0x66(%ebp)
  800096:	c6 45 9b 12          	movb   $0x12,-0x65(%ebp)
  80009a:	c6 45 9c 34          	movb   $0x34,-0x64(%ebp)
  80009e:	c6 45 9d 56          	movb   $0x56,-0x63(%ebp)
	uint32_t myip = inet_addr(IP);
  8000a2:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8000a9:	e8 63 06 00 00       	call   800711 <inet_addr>
  8000ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  8000b1:	c7 04 24 0f 2e 80 00 	movl   $0x802e0f,(%esp)
  8000b8:	e8 54 06 00 00       	call   800711 <inet_addr>
  8000bd:	89 45 94             	mov    %eax,-0x6c(%ebp)
	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000c0:	83 c4 0c             	add    $0xc,%esp
  8000c3:	6a 07                	push   $0x7
  8000c5:	68 00 b0 fe 0f       	push   $0xffeb000
  8000ca:	6a 00                	push   $0x0
  8000cc:	e8 7e 11 00 00       	call   80124f <sys_page_alloc>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	85 c0                	test   %eax,%eax
  8000d6:	0f 88 53 01 00 00    	js     80022f <umain+0x1fc>
	pkt->jp_len = sizeof(*arp);
  8000dc:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  8000e3:	00 00 00 
	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	6a 06                	push   $0x6
  8000eb:	68 ff 00 00 00       	push   $0xff
  8000f0:	68 04 b0 fe 0f       	push   $0xffeb004
  8000f5:	e8 a9 0e 00 00       	call   800fa3 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  8000fa:	83 c4 0c             	add    $0xc,%esp
  8000fd:	6a 06                	push   $0x6
  8000ff:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  800102:	53                   	push   %ebx
  800103:	68 0a b0 fe 0f       	push   $0xffeb00a
  800108:	e8 40 0f 00 00       	call   80104d <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  80010d:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  800114:	e8 e9 03 00 00       	call   800502 <htons>
  800119:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  80011f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800126:	e8 d7 03 00 00       	call   800502 <htons>
  80012b:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  800131:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  800138:	e8 c5 03 00 00       	call   800502 <htons>
  80013d:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  800143:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  80014a:	e8 b3 03 00 00       	call   800502 <htons>
  80014f:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  800155:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80015c:	e8 a1 03 00 00       	call   800502 <htons>
  800161:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  800167:	83 c4 0c             	add    $0xc,%esp
  80016a:	6a 06                	push   $0x6
  80016c:	53                   	push   %ebx
  80016d:	68 1a b0 fe 0f       	push   $0xffeb01a
  800172:	e8 d6 0e 00 00       	call   80104d <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  800177:	83 c4 0c             	add    $0xc,%esp
  80017a:	6a 04                	push   $0x4
  80017c:	8d 45 90             	lea    -0x70(%ebp),%eax
  80017f:	50                   	push   %eax
  800180:	68 20 b0 fe 0f       	push   $0xffeb020
  800185:	e8 c3 0e 00 00       	call   80104d <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  80018a:	83 c4 0c             	add    $0xc,%esp
  80018d:	6a 06                	push   $0x6
  80018f:	6a 00                	push   $0x0
  800191:	68 24 b0 fe 0f       	push   $0xffeb024
  800196:	e8 08 0e 00 00       	call   800fa3 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  80019b:	83 c4 0c             	add    $0xc,%esp
  80019e:	6a 04                	push   $0x4
  8001a0:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001a3:	50                   	push   %eax
  8001a4:	68 2a b0 fe 0f       	push   $0xffeb02a
  8001a9:	e8 9f 0e 00 00       	call   80104d <memcpy>
	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001ae:	6a 07                	push   $0x7
  8001b0:	68 00 b0 fe 0f       	push   $0xffeb000
  8001b5:	6a 0b                	push   $0xb
  8001b7:	ff 35 04 50 80 00    	pushl  0x805004
  8001bd:	e8 b5 16 00 00       	call   801877 <ipc_send>
	sys_page_unmap(0, pkt);
  8001c2:	83 c4 18             	add    $0x18,%esp
  8001c5:	68 00 b0 fe 0f       	push   $0xffeb000
  8001ca:	6a 00                	push   $0x0
  8001cc:	e8 03 11 00 00       	call   8012d4 <sys_page_unmap>
  8001d1:	83 c4 10             	add    $0x10,%esp
	int i, r, first = 1;
  8001d4:	c7 85 78 ff ff ff 01 	movl   $0x1,-0x88(%ebp)
  8001db:	00 00 00 
			out = buf + snprintf(buf, end - buf,
  8001de:	89 df                	mov    %ebx,%edi
  8001e0:	e9 6a 01 00 00       	jmp    80034f <umain+0x31c>
		panic("error forking");
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 ca 2d 80 00       	push   $0x802dca
  8001ed:	6a 4d                	push   $0x4d
  8001ef:	68 d8 2d 80 00       	push   $0x802dd8
  8001f4:	e8 ad 05 00 00       	call   8007a6 <_panic>
		output(ns_envid);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	53                   	push   %ebx
  8001fd:	e8 55 02 00 00       	call   800457 <output>
		return;
  800202:	83 c4 10             	add    $0x10,%esp
		// we've received the ARP reply
		if (first)
			cprintf("Waiting for packets...\n");
		first = 0;
	}
}
  800205:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800208:	5b                   	pop    %ebx
  800209:	5e                   	pop    %esi
  80020a:	5f                   	pop    %edi
  80020b:	5d                   	pop    %ebp
  80020c:	c3                   	ret    
		panic("error forking");
  80020d:	83 ec 04             	sub    $0x4,%esp
  800210:	68 ca 2d 80 00       	push   $0x802dca
  800215:	6a 55                	push   $0x55
  800217:	68 d8 2d 80 00       	push   $0x802dd8
  80021c:	e8 85 05 00 00       	call   8007a6 <_panic>
		input(ns_envid);
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	53                   	push   %ebx
  800225:	e8 22 02 00 00       	call   80044c <input>
		return;
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	eb d6                	jmp    800205 <umain+0x1d2>
		panic("sys_page_map: %e", r);
  80022f:	50                   	push   %eax
  800230:	68 18 2e 80 00       	push   $0x802e18
  800235:	6a 19                	push   $0x19
  800237:	68 d8 2d 80 00       	push   $0x802dd8
  80023c:	e8 65 05 00 00       	call   8007a6 <_panic>
			panic("ipc_recv: %e", req);
  800241:	50                   	push   %eax
  800242:	68 29 2e 80 00       	push   $0x802e29
  800247:	6a 64                	push   $0x64
  800249:	68 d8 2d 80 00       	push   $0x802dd8
  80024e:	e8 53 05 00 00       	call   8007a6 <_panic>
			panic("IPC from unexpected environment %08x", whom);
  800253:	52                   	push   %edx
  800254:	68 80 2e 80 00       	push   $0x802e80
  800259:	6a 66                	push   $0x66
  80025b:	68 d8 2d 80 00       	push   $0x802dd8
  800260:	e8 41 05 00 00       	call   8007a6 <_panic>
			panic("Unexpected IPC %d", req);
  800265:	50                   	push   %eax
  800266:	68 36 2e 80 00       	push   $0x802e36
  80026b:	6a 68                	push   $0x68
  80026d:	68 d8 2d 80 00       	push   $0x802dd8
  800272:	e8 2f 05 00 00       	call   8007a6 <_panic>
			out = buf + snprintf(buf, end - buf,
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	56                   	push   %esi
  80027b:	68 48 2e 80 00       	push   $0x802e48
  800280:	68 50 2e 80 00       	push   $0x802e50
  800285:	6a 50                	push   $0x50
  800287:	57                   	push   %edi
  800288:	e8 7d 0b 00 00       	call   800e0a <snprintf>
  80028d:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
  800290:	83 c4 20             	add    $0x20,%esp
  800293:	eb 41                	jmp    8002d6 <umain+0x2a3>
			cprintf("%.*s\n", out - buf, buf);
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	57                   	push   %edi
  800299:	89 d8                	mov    %ebx,%eax
  80029b:	29 f8                	sub    %edi,%eax
  80029d:	50                   	push   %eax
  80029e:	68 5f 2e 80 00       	push   $0x802e5f
  8002a3:	e8 d9 05 00 00       	call   800881 <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
		if (i % 2 == 1)
  8002ab:	89 f2                	mov    %esi,%edx
  8002ad:	c1 ea 1f             	shr    $0x1f,%edx
  8002b0:	8d 04 16             	lea    (%esi,%edx,1),%eax
  8002b3:	83 e0 01             	and    $0x1,%eax
  8002b6:	29 d0                	sub    %edx,%eax
  8002b8:	83 f8 01             	cmp    $0x1,%eax
  8002bb:	74 5f                	je     80031c <umain+0x2e9>
		if (i % 16 == 7)
  8002bd:	83 7d 84 07          	cmpl   $0x7,-0x7c(%ebp)
  8002c1:	74 61                	je     800324 <umain+0x2f1>
	for (i = 0; i < len; i++) {
  8002c3:	83 c6 01             	add    $0x1,%esi
  8002c6:	39 75 80             	cmp    %esi,-0x80(%ebp)
  8002c9:	7e 61                	jle    80032c <umain+0x2f9>
  8002cb:	89 75 84             	mov    %esi,-0x7c(%ebp)
		if (i % 16 == 0)
  8002ce:	f7 c6 0f 00 00 00    	test   $0xf,%esi
  8002d4:	74 a1                	je     800277 <umain+0x244>
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  8002d6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8002d9:	0f b6 80 04 b0 fe 0f 	movzbl 0xffeb004(%eax),%eax
  8002e0:	50                   	push   %eax
  8002e1:	68 5a 2e 80 00       	push   $0x802e5a
  8002e6:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002e9:	29 d8                	sub    %ebx,%eax
  8002eb:	50                   	push   %eax
  8002ec:	53                   	push   %ebx
  8002ed:	e8 18 0b 00 00       	call   800e0a <snprintf>
  8002f2:	01 c3                	add    %eax,%ebx
		if (i % 16 == 15 || i == len - 1)
  8002f4:	89 f0                	mov    %esi,%eax
  8002f6:	c1 f8 1f             	sar    $0x1f,%eax
  8002f9:	c1 e8 1c             	shr    $0x1c,%eax
  8002fc:	8d 14 06             	lea    (%esi,%eax,1),%edx
  8002ff:	83 e2 0f             	and    $0xf,%edx
  800302:	29 c2                	sub    %eax,%edx
  800304:	89 55 84             	mov    %edx,-0x7c(%ebp)
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	83 fa 0f             	cmp    $0xf,%edx
  80030d:	74 86                	je     800295 <umain+0x262>
  80030f:	3b b5 7c ff ff ff    	cmp    -0x84(%ebp),%esi
  800315:	75 94                	jne    8002ab <umain+0x278>
  800317:	e9 79 ff ff ff       	jmp    800295 <umain+0x262>
			*(out++) = ' ';
  80031c:	c6 03 20             	movb   $0x20,(%ebx)
  80031f:	8d 5b 01             	lea    0x1(%ebx),%ebx
  800322:	eb 99                	jmp    8002bd <umain+0x28a>
			*(out++) = ' ';
  800324:	c6 03 20             	movb   $0x20,(%ebx)
  800327:	8d 5b 01             	lea    0x1(%ebx),%ebx
  80032a:	eb 97                	jmp    8002c3 <umain+0x290>
		cprintf("\n");
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	68 7b 2e 80 00       	push   $0x802e7b
  800334:	e8 48 05 00 00       	call   800881 <cprintf>
		if (first)
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	83 bd 78 ff ff ff 00 	cmpl   $0x0,-0x88(%ebp)
  800343:	75 62                	jne    8003a7 <umain+0x374>
		first = 0;
  800345:	c7 85 78 ff ff ff 00 	movl   $0x0,-0x88(%ebp)
  80034c:	00 00 00 
		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  80034f:	83 ec 04             	sub    $0x4,%esp
  800352:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800355:	50                   	push   %eax
  800356:	68 00 b0 fe 0f       	push   $0xffeb000
  80035b:	8d 45 90             	lea    -0x70(%ebp),%eax
  80035e:	50                   	push   %eax
  80035f:	e8 a0 14 00 00       	call   801804 <ipc_recv>
		if (req < 0)
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	85 c0                	test   %eax,%eax
  800369:	0f 88 d2 fe ff ff    	js     800241 <umain+0x20e>
		if (whom != input_envid)
  80036f:	8b 55 90             	mov    -0x70(%ebp),%edx
  800372:	3b 15 00 50 80 00    	cmp    0x805000,%edx
  800378:	0f 85 d5 fe ff ff    	jne    800253 <umain+0x220>
		if (req != NSREQ_INPUT)
  80037e:	83 f8 0a             	cmp    $0xa,%eax
  800381:	0f 85 de fe ff ff    	jne    800265 <umain+0x232>
		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  800387:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  80038c:	89 45 80             	mov    %eax,-0x80(%ebp)
	char *out = NULL;
  80038f:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < len; i++) {
  800394:	be 00 00 00 00       	mov    $0x0,%esi
		if (i % 16 == 15 || i == len - 1)
  800399:	83 e8 01             	sub    $0x1,%eax
  80039c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  8003a2:	e9 1f ff ff ff       	jmp    8002c6 <umain+0x293>
			cprintf("Waiting for packets...\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 65 2e 80 00       	push   $0x802e65
  8003af:	e8 cd 04 00 00       	call   800881 <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
  8003b7:	eb 8c                	jmp    800345 <umain+0x312>

008003b9 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  8003b9:	55                   	push   %ebp
  8003ba:	89 e5                	mov    %esp,%ebp
  8003bc:	57                   	push   %edi
  8003bd:	56                   	push   %esi
  8003be:	53                   	push   %ebx
  8003bf:	83 ec 1c             	sub    $0x1c,%esp
  8003c2:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  8003c5:	e8 76 10 00 00       	call   801440 <sys_time_msec>
  8003ca:	03 45 0c             	add    0xc(%ebp),%eax
  8003cd:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  8003cf:	c7 05 00 40 80 00 a5 	movl   $0x802ea5,0x804000
  8003d6:	2e 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003d9:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  8003dc:	eb 33                	jmp    800411 <timer+0x58>
		if (r < 0)
  8003de:	85 c0                	test   %eax,%eax
  8003e0:	78 45                	js     800427 <timer+0x6e>
		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8003e2:	6a 00                	push   $0x0
  8003e4:	6a 00                	push   $0x0
  8003e6:	6a 0c                	push   $0xc
  8003e8:	56                   	push   %esi
  8003e9:	e8 89 14 00 00       	call   801877 <ipc_send>
  8003ee:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	6a 00                	push   $0x0
  8003f6:	6a 00                	push   $0x0
  8003f8:	57                   	push   %edi
  8003f9:	e8 06 14 00 00       	call   801804 <ipc_recv>
  8003fe:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  800400:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800403:	83 c4 10             	add    $0x10,%esp
  800406:	39 f0                	cmp    %esi,%eax
  800408:	75 2f                	jne    800439 <timer+0x80>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  80040a:	e8 31 10 00 00       	call   801440 <sys_time_msec>
  80040f:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  800411:	e8 2a 10 00 00       	call   801440 <sys_time_msec>
  800416:	89 c2                	mov    %eax,%edx
  800418:	85 c0                	test   %eax,%eax
  80041a:	78 c2                	js     8003de <timer+0x25>
  80041c:	39 d8                	cmp    %ebx,%eax
  80041e:	73 be                	jae    8003de <timer+0x25>
			sys_yield();
  800420:	e8 0b 0e 00 00       	call   801230 <sys_yield>
  800425:	eb ea                	jmp    800411 <timer+0x58>
			panic("sys_time_msec: %e", r);
  800427:	52                   	push   %edx
  800428:	68 ae 2e 80 00       	push   $0x802eae
  80042d:	6a 0f                	push   $0xf
  80042f:	68 c0 2e 80 00       	push   $0x802ec0
  800434:	e8 6d 03 00 00       	call   8007a6 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	50                   	push   %eax
  80043d:	68 cc 2e 80 00       	push   $0x802ecc
  800442:	e8 3a 04 00 00       	call   800881 <cprintf>
				continue;
  800447:	83 c4 10             	add    $0x10,%esp
  80044a:	eb a5                	jmp    8003f1 <timer+0x38>

0080044c <input>:
extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
	binaryname = "ns_input";
  80044c:	c7 05 00 40 80 00 07 	movl   $0x802f07,0x804000
  800453:	2f 80 00 
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
}
  800456:	c3                   	ret    

00800457 <output>:
extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
	binaryname = "ns_output";
  800457:	c7 05 00 40 80 00 10 	movl   $0x802f10,0x804000
  80045e:	2f 80 00 

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
}
  800461:	c3                   	ret    

00800462 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	57                   	push   %edi
  800466:	56                   	push   %esi
  800467:	53                   	push   %ebx
  800468:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800471:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  800475:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  800478:	bf 08 50 80 00       	mov    $0x805008,%edi
  80047d:	eb 1a                	jmp    800499 <inet_ntoa+0x37>
  80047f:	0f b6 db             	movzbl %bl,%ebx
  800482:	01 fb                	add    %edi,%ebx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800484:	8d 7b 01             	lea    0x1(%ebx),%edi
  800487:	c6 03 2e             	movb   $0x2e,(%ebx)
  80048a:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  80048d:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  800491:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  800495:	3c 04                	cmp    $0x4,%al
  800497:	74 59                	je     8004f2 <inet_ntoa+0x90>
  rp = str;
  800499:	ba 00 00 00 00       	mov    $0x0,%edx
      rem = *ap % (u8_t)10;
  80049e:	0f b6 0e             	movzbl (%esi),%ecx
      *ap /= (u8_t)10;
  8004a1:	0f b6 d9             	movzbl %cl,%ebx
  8004a4:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  8004a7:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  8004aa:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004ad:	66 c1 e8 0b          	shr    $0xb,%ax
  8004b1:	88 06                	mov    %al,(%esi)
      inv[i++] = '0' + rem;
  8004b3:	8d 5a 01             	lea    0x1(%edx),%ebx
  8004b6:	0f b6 d2             	movzbl %dl,%edx
  8004b9:	89 55 e0             	mov    %edx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  8004bc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004bf:	01 c0                	add    %eax,%eax
  8004c1:	89 ca                	mov    %ecx,%edx
  8004c3:	29 c2                	sub    %eax,%edx
  8004c5:	89 d0                	mov    %edx,%eax
      inv[i++] = '0' + rem;
  8004c7:	83 c0 30             	add    $0x30,%eax
  8004ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cd:	88 44 15 ed          	mov    %al,-0x13(%ebp,%edx,1)
  8004d1:	89 da                	mov    %ebx,%edx
    } while(*ap);
  8004d3:	80 f9 09             	cmp    $0x9,%cl
  8004d6:	77 c6                	ja     80049e <inet_ntoa+0x3c>
  8004d8:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  8004da:	89 d8                	mov    %ebx,%eax
    while(i--)
  8004dc:	83 e8 01             	sub    $0x1,%eax
  8004df:	3c ff                	cmp    $0xff,%al
  8004e1:	74 9c                	je     80047f <inet_ntoa+0x1d>
      *rp++ = inv[i];
  8004e3:	0f b6 c8             	movzbl %al,%ecx
  8004e6:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  8004eb:	88 0a                	mov    %cl,(%edx)
  8004ed:	83 c2 01             	add    $0x1,%edx
  8004f0:	eb ea                	jmp    8004dc <inet_ntoa+0x7a>
    ap++;
  }
  *--rp = 0;
  8004f2:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  8004f5:	b8 08 50 80 00       	mov    $0x805008,%eax
  8004fa:	83 c4 18             	add    $0x18,%esp
  8004fd:	5b                   	pop    %ebx
  8004fe:	5e                   	pop    %esi
  8004ff:	5f                   	pop    %edi
  800500:	5d                   	pop    %ebp
  800501:	c3                   	ret    

00800502 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800502:	55                   	push   %ebp
  800503:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800505:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800509:	66 c1 c0 08          	rol    $0x8,%ax
}
  80050d:	5d                   	pop    %ebp
  80050e:	c3                   	ret    

0080050f <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800512:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800516:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  80051a:	5d                   	pop    %ebp
  80051b:	c3                   	ret    

0080051c <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80051c:	55                   	push   %ebp
  80051d:	89 e5                	mov    %esp,%ebp
  80051f:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800522:	89 d0                	mov    %edx,%eax
  800524:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800527:	89 d1                	mov    %edx,%ecx
  800529:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  80052c:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  80052e:	89 d1                	mov    %edx,%ecx
  800530:	c1 e1 08             	shl    $0x8,%ecx
  800533:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  800539:	09 c8                	or     %ecx,%eax
  80053b:	c1 ea 08             	shr    $0x8,%edx
  80053e:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  800544:	09 d0                	or     %edx,%eax
}
  800546:	5d                   	pop    %ebp
  800547:	c3                   	ret    

00800548 <inet_aton>:
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	57                   	push   %edi
  80054c:	56                   	push   %esi
  80054d:	53                   	push   %ebx
  80054e:	83 ec 2c             	sub    $0x2c,%esp
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  800554:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  800557:	8d 75 d8             	lea    -0x28(%ebp),%esi
  80055a:	89 75 cc             	mov    %esi,-0x34(%ebp)
  80055d:	e9 a7 00 00 00       	jmp    800609 <inet_aton+0xc1>
      c = *++cp;
  800562:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  800566:	89 d1                	mov    %edx,%ecx
  800568:	83 e1 df             	and    $0xffffffdf,%ecx
  80056b:	80 f9 58             	cmp    $0x58,%cl
  80056e:	74 10                	je     800580 <inet_aton+0x38>
      c = *++cp;
  800570:	83 c0 01             	add    $0x1,%eax
  800573:	0f be d2             	movsbl %dl,%edx
        base = 8;
  800576:	be 08 00 00 00       	mov    $0x8,%esi
  80057b:	e9 a3 00 00 00       	jmp    800623 <inet_aton+0xdb>
        c = *++cp;
  800580:	0f be 50 02          	movsbl 0x2(%eax),%edx
  800584:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  800587:	be 10 00 00 00       	mov    $0x10,%esi
  80058c:	e9 92 00 00 00       	jmp    800623 <inet_aton+0xdb>
      } else if (base == 16 && isxdigit(c)) {
  800591:	83 fe 10             	cmp    $0x10,%esi
  800594:	75 4d                	jne    8005e3 <inet_aton+0x9b>
  800596:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  800599:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  80059c:	89 d1                	mov    %edx,%ecx
  80059e:	83 e1 df             	and    $0xffffffdf,%ecx
  8005a1:	83 e9 41             	sub    $0x41,%ecx
  8005a4:	80 f9 05             	cmp    $0x5,%cl
  8005a7:	77 3a                	ja     8005e3 <inet_aton+0x9b>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8005a9:	c1 e3 04             	shl    $0x4,%ebx
  8005ac:	83 c2 0a             	add    $0xa,%edx
  8005af:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  8005b3:	19 c9                	sbb    %ecx,%ecx
  8005b5:	83 e1 20             	and    $0x20,%ecx
  8005b8:	83 c1 41             	add    $0x41,%ecx
  8005bb:	29 ca                	sub    %ecx,%edx
  8005bd:	09 d3                	or     %edx,%ebx
        c = *++cp;
  8005bf:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005c2:	0f be 57 01          	movsbl 0x1(%edi),%edx
  8005c6:	83 c0 01             	add    $0x1,%eax
  8005c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if (isdigit(c)) {
  8005cc:	89 d7                	mov    %edx,%edi
  8005ce:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005d1:	80 f9 09             	cmp    $0x9,%cl
  8005d4:	77 bb                	ja     800591 <inet_aton+0x49>
        val = (val * base) + (int)(c - '0');
  8005d6:	0f af de             	imul   %esi,%ebx
  8005d9:	8d 5c 1a d0          	lea    -0x30(%edx,%ebx,1),%ebx
        c = *++cp;
  8005dd:	0f be 50 01          	movsbl 0x1(%eax),%edx
  8005e1:	eb e3                	jmp    8005c6 <inet_aton+0x7e>
    if (c == '.') {
  8005e3:	83 fa 2e             	cmp    $0x2e,%edx
  8005e6:	75 42                	jne    80062a <inet_aton+0xe2>
      if (pp >= parts + 3)
  8005e8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005eb:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005ee:	39 c6                	cmp    %eax,%esi
  8005f0:	0f 84 0e 01 00 00    	je     800704 <inet_aton+0x1bc>
      *pp++ = val;
  8005f6:	83 c6 04             	add    $0x4,%esi
  8005f9:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8005fc:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  8005ff:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  800602:	8d 46 01             	lea    0x1(%esi),%eax
  800605:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  800609:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80060c:	80 f9 09             	cmp    $0x9,%cl
  80060f:	0f 87 e8 00 00 00    	ja     8006fd <inet_aton+0x1b5>
    base = 10;
  800615:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  80061a:	83 fa 30             	cmp    $0x30,%edx
  80061d:	0f 84 3f ff ff ff    	je     800562 <inet_aton+0x1a>
    base = 10;
  800623:	bb 00 00 00 00       	mov    $0x0,%ebx
  800628:	eb 9f                	jmp    8005c9 <inet_aton+0x81>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80062a:	85 d2                	test   %edx,%edx
  80062c:	74 26                	je     800654 <inet_aton+0x10c>
    return (0);
  80062e:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800633:	89 f9                	mov    %edi,%ecx
  800635:	80 f9 1f             	cmp    $0x1f,%cl
  800638:	0f 86 cb 00 00 00    	jbe    800709 <inet_aton+0x1c1>
  80063e:	84 d2                	test   %dl,%dl
  800640:	0f 88 c3 00 00 00    	js     800709 <inet_aton+0x1c1>
  800646:	83 fa 20             	cmp    $0x20,%edx
  800649:	74 09                	je     800654 <inet_aton+0x10c>
  80064b:	83 fa 0c             	cmp    $0xc,%edx
  80064e:	0f 85 b5 00 00 00    	jne    800709 <inet_aton+0x1c1>
  n = pp - parts + 1;
  800654:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800657:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80065a:	29 c6                	sub    %eax,%esi
  80065c:	89 f0                	mov    %esi,%eax
  80065e:	c1 f8 02             	sar    $0x2,%eax
  800661:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  800664:	83 f8 02             	cmp    $0x2,%eax
  800667:	74 5e                	je     8006c7 <inet_aton+0x17f>
  800669:	7e 35                	jle    8006a0 <inet_aton+0x158>
  80066b:	83 f8 03             	cmp    $0x3,%eax
  80066e:	74 6e                	je     8006de <inet_aton+0x196>
  800670:	83 f8 04             	cmp    $0x4,%eax
  800673:	75 2f                	jne    8006a4 <inet_aton+0x15c>
      return (0);
  800675:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  80067a:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  800680:	0f 87 83 00 00 00    	ja     800709 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800686:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800689:	c1 e0 18             	shl    $0x18,%eax
  80068c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80068f:	c1 e2 10             	shl    $0x10,%edx
  800692:	09 d0                	or     %edx,%eax
  800694:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800697:	c1 e2 08             	shl    $0x8,%edx
  80069a:	09 d0                	or     %edx,%eax
  80069c:	09 c3                	or     %eax,%ebx
    break;
  80069e:	eb 04                	jmp    8006a4 <inet_aton+0x15c>
  switch (n) {
  8006a0:	85 c0                	test   %eax,%eax
  8006a2:	74 65                	je     800709 <inet_aton+0x1c1>
  return (1);
  8006a4:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  8006a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ad:	74 5a                	je     800709 <inet_aton+0x1c1>
    addr->s_addr = htonl(val);
  8006af:	83 ec 0c             	sub    $0xc,%esp
  8006b2:	53                   	push   %ebx
  8006b3:	e8 64 fe ff ff       	call   80051c <htonl>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006be:	89 06                	mov    %eax,(%esi)
  return (1);
  8006c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8006c5:	eb 42                	jmp    800709 <inet_aton+0x1c1>
      return (0);
  8006c7:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  8006cc:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  8006d2:	77 35                	ja     800709 <inet_aton+0x1c1>
    val |= parts[0] << 24;
  8006d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006d7:	c1 e0 18             	shl    $0x18,%eax
  8006da:	09 c3                	or     %eax,%ebx
    break;
  8006dc:	eb c6                	jmp    8006a4 <inet_aton+0x15c>
      return (0);
  8006de:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  8006e3:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  8006e9:	77 1e                	ja     800709 <inet_aton+0x1c1>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8006eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006ee:	c1 e0 18             	shl    $0x18,%eax
  8006f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006f4:	c1 e2 10             	shl    $0x10,%edx
  8006f7:	09 d0                	or     %edx,%eax
  8006f9:	09 c3                	or     %eax,%ebx
    break;
  8006fb:	eb a7                	jmp    8006a4 <inet_aton+0x15c>
      return (0);
  8006fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800702:	eb 05                	jmp    800709 <inet_aton+0x1c1>
        return (0);
  800704:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800709:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80070c:	5b                   	pop    %ebx
  80070d:	5e                   	pop    %esi
  80070e:	5f                   	pop    %edi
  80070f:	5d                   	pop    %ebp
  800710:	c3                   	ret    

00800711 <inet_addr>:
{
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  800717:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80071a:	50                   	push   %eax
  80071b:	ff 75 08             	pushl  0x8(%ebp)
  80071e:	e8 25 fe ff ff       	call   800548 <inet_aton>
  800723:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  800726:	85 c0                	test   %eax,%eax
  800728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80072d:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  800731:	c9                   	leave  
  800732:	c3                   	ret    

00800733 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
  800736:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  800739:	ff 75 08             	pushl  0x8(%ebp)
  80073c:	e8 db fd ff ff       	call   80051c <htonl>
  800741:	83 c4 10             	add    $0x10,%esp
}
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	56                   	push   %esi
  80074a:	53                   	push   %ebx
  80074b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80074e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800751:	e8 bb 0a 00 00       	call   801211 <sys_getenvid>
  800756:	25 ff 03 00 00       	and    $0x3ff,%eax
  80075b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80075e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800763:	a3 20 50 80 00       	mov    %eax,0x805020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800768:	85 db                	test   %ebx,%ebx
  80076a:	7e 07                	jle    800773 <libmain+0x2d>
		binaryname = argv[0];
  80076c:	8b 06                	mov    (%esi),%eax
  80076e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	56                   	push   %esi
  800777:	53                   	push   %ebx
  800778:	e8 b6 f8 ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80077d:	e8 0a 00 00 00       	call   80078c <exit>
}
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800788:	5b                   	pop    %ebx
  800789:	5e                   	pop    %esi
  80078a:	5d                   	pop    %ebp
  80078b:	c3                   	ret    

0080078c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800792:	e8 5d 13 00 00       	call   801af4 <close_all>
	sys_env_destroy(0);
  800797:	83 ec 0c             	sub    $0xc,%esp
  80079a:	6a 00                	push   $0x0
  80079c:	e8 2f 0a 00 00       	call   8011d0 <sys_env_destroy>
}
  8007a1:	83 c4 10             	add    $0x10,%esp
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	56                   	push   %esi
  8007aa:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8007ab:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007ae:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8007b4:	e8 58 0a 00 00       	call   801211 <sys_getenvid>
  8007b9:	83 ec 0c             	sub    $0xc,%esp
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	ff 75 08             	pushl  0x8(%ebp)
  8007c2:	56                   	push   %esi
  8007c3:	50                   	push   %eax
  8007c4:	68 24 2f 80 00       	push   $0x802f24
  8007c9:	e8 b3 00 00 00       	call   800881 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8007ce:	83 c4 18             	add    $0x18,%esp
  8007d1:	53                   	push   %ebx
  8007d2:	ff 75 10             	pushl  0x10(%ebp)
  8007d5:	e8 56 00 00 00       	call   800830 <vcprintf>
	cprintf("\n");
  8007da:	c7 04 24 7b 2e 80 00 	movl   $0x802e7b,(%esp)
  8007e1:	e8 9b 00 00 00       	call   800881 <cprintf>
  8007e6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8007e9:	cc                   	int3   
  8007ea:	eb fd                	jmp    8007e9 <_panic+0x43>

008007ec <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	53                   	push   %ebx
  8007f0:	83 ec 04             	sub    $0x4,%esp
  8007f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8007f6:	8b 13                	mov    (%ebx),%edx
  8007f8:	8d 42 01             	lea    0x1(%edx),%eax
  8007fb:	89 03                	mov    %eax,(%ebx)
  8007fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800800:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800804:	3d ff 00 00 00       	cmp    $0xff,%eax
  800809:	74 09                	je     800814 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80080b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80080f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800812:	c9                   	leave  
  800813:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	68 ff 00 00 00       	push   $0xff
  80081c:	8d 43 08             	lea    0x8(%ebx),%eax
  80081f:	50                   	push   %eax
  800820:	e8 6e 09 00 00       	call   801193 <sys_cputs>
		b->idx = 0;
  800825:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	eb db                	jmp    80080b <putch+0x1f>

00800830 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800839:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800840:	00 00 00 
	b.cnt = 0;
  800843:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80084a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80084d:	ff 75 0c             	pushl  0xc(%ebp)
  800850:	ff 75 08             	pushl  0x8(%ebp)
  800853:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800859:	50                   	push   %eax
  80085a:	68 ec 07 80 00       	push   $0x8007ec
  80085f:	e8 19 01 00 00       	call   80097d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800864:	83 c4 08             	add    $0x8,%esp
  800867:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80086d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800873:	50                   	push   %eax
  800874:	e8 1a 09 00 00       	call   801193 <sys_cputs>

	return b.cnt;
}
  800879:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80087f:	c9                   	leave  
  800880:	c3                   	ret    

00800881 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800887:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80088a:	50                   	push   %eax
  80088b:	ff 75 08             	pushl  0x8(%ebp)
  80088e:	e8 9d ff ff ff       	call   800830 <vcprintf>
	va_end(ap);

	return cnt;
}
  800893:	c9                   	leave  
  800894:	c3                   	ret    

00800895 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	57                   	push   %edi
  800899:	56                   	push   %esi
  80089a:	53                   	push   %ebx
  80089b:	83 ec 1c             	sub    $0x1c,%esp
  80089e:	89 c7                	mov    %eax,%edi
  8008a0:	89 d6                	mov    %edx,%esi
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8008b9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8008bc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8008bf:	89 d0                	mov    %edx,%eax
  8008c1:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8008c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8008c7:	73 15                	jae    8008de <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008c9:	83 eb 01             	sub    $0x1,%ebx
  8008cc:	85 db                	test   %ebx,%ebx
  8008ce:	7e 43                	jle    800913 <printnum+0x7e>
			putch(padc, putdat);
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	56                   	push   %esi
  8008d4:	ff 75 18             	pushl  0x18(%ebp)
  8008d7:	ff d7                	call   *%edi
  8008d9:	83 c4 10             	add    $0x10,%esp
  8008dc:	eb eb                	jmp    8008c9 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008de:	83 ec 0c             	sub    $0xc,%esp
  8008e1:	ff 75 18             	pushl  0x18(%ebp)
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008ea:	53                   	push   %ebx
  8008eb:	ff 75 10             	pushl  0x10(%ebp)
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8008f7:	ff 75 dc             	pushl  -0x24(%ebp)
  8008fa:	ff 75 d8             	pushl  -0x28(%ebp)
  8008fd:	e8 5e 22 00 00       	call   802b60 <__udivdi3>
  800902:	83 c4 18             	add    $0x18,%esp
  800905:	52                   	push   %edx
  800906:	50                   	push   %eax
  800907:	89 f2                	mov    %esi,%edx
  800909:	89 f8                	mov    %edi,%eax
  80090b:	e8 85 ff ff ff       	call   800895 <printnum>
  800910:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	56                   	push   %esi
  800917:	83 ec 04             	sub    $0x4,%esp
  80091a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80091d:	ff 75 e0             	pushl  -0x20(%ebp)
  800920:	ff 75 dc             	pushl  -0x24(%ebp)
  800923:	ff 75 d8             	pushl  -0x28(%ebp)
  800926:	e8 45 23 00 00       	call   802c70 <__umoddi3>
  80092b:	83 c4 14             	add    $0x14,%esp
  80092e:	0f be 80 47 2f 80 00 	movsbl 0x802f47(%eax),%eax
  800935:	50                   	push   %eax
  800936:	ff d7                	call   *%edi
}
  800938:	83 c4 10             	add    $0x10,%esp
  80093b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80093e:	5b                   	pop    %ebx
  80093f:	5e                   	pop    %esi
  800940:	5f                   	pop    %edi
  800941:	5d                   	pop    %ebp
  800942:	c3                   	ret    

00800943 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800949:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80094d:	8b 10                	mov    (%eax),%edx
  80094f:	3b 50 04             	cmp    0x4(%eax),%edx
  800952:	73 0a                	jae    80095e <sprintputch+0x1b>
		*b->buf++ = ch;
  800954:	8d 4a 01             	lea    0x1(%edx),%ecx
  800957:	89 08                	mov    %ecx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	88 02                	mov    %al,(%edx)
}
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    

00800960 <printfmt>:
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800966:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800969:	50                   	push   %eax
  80096a:	ff 75 10             	pushl  0x10(%ebp)
  80096d:	ff 75 0c             	pushl  0xc(%ebp)
  800970:	ff 75 08             	pushl  0x8(%ebp)
  800973:	e8 05 00 00 00       	call   80097d <vprintfmt>
}
  800978:	83 c4 10             	add    $0x10,%esp
  80097b:	c9                   	leave  
  80097c:	c3                   	ret    

0080097d <vprintfmt>:
{
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	57                   	push   %edi
  800981:	56                   	push   %esi
  800982:	53                   	push   %ebx
  800983:	83 ec 3c             	sub    $0x3c,%esp
  800986:	8b 75 08             	mov    0x8(%ebp),%esi
  800989:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80098c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80098f:	eb 0a                	jmp    80099b <vprintfmt+0x1e>
			putch(ch, putdat);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	53                   	push   %ebx
  800995:	50                   	push   %eax
  800996:	ff d6                	call   *%esi
  800998:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099b:	83 c7 01             	add    $0x1,%edi
  80099e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009a2:	83 f8 25             	cmp    $0x25,%eax
  8009a5:	74 0c                	je     8009b3 <vprintfmt+0x36>
			if (ch == '\0')
  8009a7:	85 c0                	test   %eax,%eax
  8009a9:	75 e6                	jne    800991 <vprintfmt+0x14>
}
  8009ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009ae:	5b                   	pop    %ebx
  8009af:	5e                   	pop    %esi
  8009b0:	5f                   	pop    %edi
  8009b1:	5d                   	pop    %ebp
  8009b2:	c3                   	ret    
		padc = ' ';
  8009b3:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8009b7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8009be:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8009c5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009cc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009d1:	8d 47 01             	lea    0x1(%edi),%eax
  8009d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009d7:	0f b6 17             	movzbl (%edi),%edx
  8009da:	8d 42 dd             	lea    -0x23(%edx),%eax
  8009dd:	3c 55                	cmp    $0x55,%al
  8009df:	0f 87 ba 03 00 00    	ja     800d9f <vprintfmt+0x422>
  8009e5:	0f b6 c0             	movzbl %al,%eax
  8009e8:	ff 24 85 80 30 80 00 	jmp    *0x803080(,%eax,4)
  8009ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8009f2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8009f6:	eb d9                	jmp    8009d1 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  8009f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8009fb:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8009ff:	eb d0                	jmp    8009d1 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800a01:	0f b6 d2             	movzbl %dl,%edx
  800a04:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800a07:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800a0f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800a12:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800a16:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800a19:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800a1c:	83 f9 09             	cmp    $0x9,%ecx
  800a1f:	77 55                	ja     800a76 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  800a21:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800a24:	eb e9                	jmp    800a0f <vprintfmt+0x92>
			precision = va_arg(ap, int);
  800a26:	8b 45 14             	mov    0x14(%ebp),%eax
  800a29:	8b 00                	mov    (%eax),%eax
  800a2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	8d 40 04             	lea    0x4(%eax),%eax
  800a34:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800a3a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a3e:	79 91                	jns    8009d1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a40:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a43:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a46:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800a4d:	eb 82                	jmp    8009d1 <vprintfmt+0x54>
  800a4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a52:	85 c0                	test   %eax,%eax
  800a54:	ba 00 00 00 00       	mov    $0x0,%edx
  800a59:	0f 49 d0             	cmovns %eax,%edx
  800a5c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a5f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800a62:	e9 6a ff ff ff       	jmp    8009d1 <vprintfmt+0x54>
  800a67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800a6a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800a71:	e9 5b ff ff ff       	jmp    8009d1 <vprintfmt+0x54>
  800a76:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800a79:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a7c:	eb bc                	jmp    800a3a <vprintfmt+0xbd>
			lflag++;
  800a7e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800a81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800a84:	e9 48 ff ff ff       	jmp    8009d1 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800a89:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8c:	8d 78 04             	lea    0x4(%eax),%edi
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	53                   	push   %ebx
  800a93:	ff 30                	pushl  (%eax)
  800a95:	ff d6                	call   *%esi
			break;
  800a97:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800a9a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800a9d:	e9 9c 02 00 00       	jmp    800d3e <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	8d 78 04             	lea    0x4(%eax),%edi
  800aa8:	8b 00                	mov    (%eax),%eax
  800aaa:	99                   	cltd   
  800aab:	31 d0                	xor    %edx,%eax
  800aad:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800aaf:	83 f8 0f             	cmp    $0xf,%eax
  800ab2:	7f 23                	jg     800ad7 <vprintfmt+0x15a>
  800ab4:	8b 14 85 e0 31 80 00 	mov    0x8031e0(,%eax,4),%edx
  800abb:	85 d2                	test   %edx,%edx
  800abd:	74 18                	je     800ad7 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  800abf:	52                   	push   %edx
  800ac0:	68 c6 34 80 00       	push   $0x8034c6
  800ac5:	53                   	push   %ebx
  800ac6:	56                   	push   %esi
  800ac7:	e8 94 fe ff ff       	call   800960 <printfmt>
  800acc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800acf:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ad2:	e9 67 02 00 00       	jmp    800d3e <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800ad7:	50                   	push   %eax
  800ad8:	68 5f 2f 80 00       	push   $0x802f5f
  800add:	53                   	push   %ebx
  800ade:	56                   	push   %esi
  800adf:	e8 7c fe ff ff       	call   800960 <printfmt>
  800ae4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800ae7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800aea:	e9 4f 02 00 00       	jmp    800d3e <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  800aef:	8b 45 14             	mov    0x14(%ebp),%eax
  800af2:	83 c0 04             	add    $0x4,%eax
  800af5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800af8:	8b 45 14             	mov    0x14(%ebp),%eax
  800afb:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800afd:	85 d2                	test   %edx,%edx
  800aff:	b8 58 2f 80 00       	mov    $0x802f58,%eax
  800b04:	0f 45 c2             	cmovne %edx,%eax
  800b07:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800b0a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b0e:	7e 06                	jle    800b16 <vprintfmt+0x199>
  800b10:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800b14:	75 0d                	jne    800b23 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b16:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b19:	89 c7                	mov    %eax,%edi
  800b1b:	03 45 e0             	add    -0x20(%ebp),%eax
  800b1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b21:	eb 3f                	jmp    800b62 <vprintfmt+0x1e5>
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	ff 75 d8             	pushl  -0x28(%ebp)
  800b29:	50                   	push   %eax
  800b2a:	e8 0d 03 00 00       	call   800e3c <strnlen>
  800b2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b32:	29 c2                	sub    %eax,%edx
  800b34:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800b3c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800b40:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800b43:	85 ff                	test   %edi,%edi
  800b45:	7e 58                	jle    800b9f <vprintfmt+0x222>
					putch(padc, putdat);
  800b47:	83 ec 08             	sub    $0x8,%esp
  800b4a:	53                   	push   %ebx
  800b4b:	ff 75 e0             	pushl  -0x20(%ebp)
  800b4e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800b50:	83 ef 01             	sub    $0x1,%edi
  800b53:	83 c4 10             	add    $0x10,%esp
  800b56:	eb eb                	jmp    800b43 <vprintfmt+0x1c6>
					putch(ch, putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	53                   	push   %ebx
  800b5c:	52                   	push   %edx
  800b5d:	ff d6                	call   *%esi
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800b65:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b67:	83 c7 01             	add    $0x1,%edi
  800b6a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b6e:	0f be d0             	movsbl %al,%edx
  800b71:	85 d2                	test   %edx,%edx
  800b73:	74 45                	je     800bba <vprintfmt+0x23d>
  800b75:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800b79:	78 06                	js     800b81 <vprintfmt+0x204>
  800b7b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800b7f:	78 35                	js     800bb6 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800b81:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800b85:	74 d1                	je     800b58 <vprintfmt+0x1db>
  800b87:	0f be c0             	movsbl %al,%eax
  800b8a:	83 e8 20             	sub    $0x20,%eax
  800b8d:	83 f8 5e             	cmp    $0x5e,%eax
  800b90:	76 c6                	jbe    800b58 <vprintfmt+0x1db>
					putch('?', putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	53                   	push   %ebx
  800b96:	6a 3f                	push   $0x3f
  800b98:	ff d6                	call   *%esi
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	eb c3                	jmp    800b62 <vprintfmt+0x1e5>
  800b9f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800ba2:	85 d2                	test   %edx,%edx
  800ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba9:	0f 49 c2             	cmovns %edx,%eax
  800bac:	29 c2                	sub    %eax,%edx
  800bae:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800bb1:	e9 60 ff ff ff       	jmp    800b16 <vprintfmt+0x199>
  800bb6:	89 cf                	mov    %ecx,%edi
  800bb8:	eb 02                	jmp    800bbc <vprintfmt+0x23f>
  800bba:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800bbc:	85 ff                	test   %edi,%edi
  800bbe:	7e 10                	jle    800bd0 <vprintfmt+0x253>
				putch(' ', putdat);
  800bc0:	83 ec 08             	sub    $0x8,%esp
  800bc3:	53                   	push   %ebx
  800bc4:	6a 20                	push   $0x20
  800bc6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800bc8:	83 ef 01             	sub    $0x1,%edi
  800bcb:	83 c4 10             	add    $0x10,%esp
  800bce:	eb ec                	jmp    800bbc <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800bd0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800bd3:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd6:	e9 63 01 00 00       	jmp    800d3e <vprintfmt+0x3c1>
	if (lflag >= 2)
  800bdb:	83 f9 01             	cmp    $0x1,%ecx
  800bde:	7f 1b                	jg     800bfb <vprintfmt+0x27e>
	else if (lflag)
  800be0:	85 c9                	test   %ecx,%ecx
  800be2:	74 63                	je     800c47 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800be4:	8b 45 14             	mov    0x14(%ebp),%eax
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bec:	99                   	cltd   
  800bed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf3:	8d 40 04             	lea    0x4(%eax),%eax
  800bf6:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf9:	eb 17                	jmp    800c12 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800bfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfe:	8b 50 04             	mov    0x4(%eax),%edx
  800c01:	8b 00                	mov    (%eax),%eax
  800c03:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c06:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c09:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0c:	8d 40 08             	lea    0x8(%eax),%eax
  800c0f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800c12:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c15:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800c18:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800c1d:	85 c9                	test   %ecx,%ecx
  800c1f:	0f 89 ff 00 00 00    	jns    800d24 <vprintfmt+0x3a7>
				putch('-', putdat);
  800c25:	83 ec 08             	sub    $0x8,%esp
  800c28:	53                   	push   %ebx
  800c29:	6a 2d                	push   $0x2d
  800c2b:	ff d6                	call   *%esi
				num = -(long long) num;
  800c2d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c30:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800c33:	f7 da                	neg    %edx
  800c35:	83 d1 00             	adc    $0x0,%ecx
  800c38:	f7 d9                	neg    %ecx
  800c3a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c3d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c42:	e9 dd 00 00 00       	jmp    800d24 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800c47:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4a:	8b 00                	mov    (%eax),%eax
  800c4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c4f:	99                   	cltd   
  800c50:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c53:	8b 45 14             	mov    0x14(%ebp),%eax
  800c56:	8d 40 04             	lea    0x4(%eax),%eax
  800c59:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5c:	eb b4                	jmp    800c12 <vprintfmt+0x295>
	if (lflag >= 2)
  800c5e:	83 f9 01             	cmp    $0x1,%ecx
  800c61:	7f 1e                	jg     800c81 <vprintfmt+0x304>
	else if (lflag)
  800c63:	85 c9                	test   %ecx,%ecx
  800c65:	74 32                	je     800c99 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800c67:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6a:	8b 10                	mov    (%eax),%edx
  800c6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c71:	8d 40 04             	lea    0x4(%eax),%eax
  800c74:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c77:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c7c:	e9 a3 00 00 00       	jmp    800d24 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800c81:	8b 45 14             	mov    0x14(%ebp),%eax
  800c84:	8b 10                	mov    (%eax),%edx
  800c86:	8b 48 04             	mov    0x4(%eax),%ecx
  800c89:	8d 40 08             	lea    0x8(%eax),%eax
  800c8c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c8f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c94:	e9 8b 00 00 00       	jmp    800d24 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800c99:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9c:	8b 10                	mov    (%eax),%edx
  800c9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca3:	8d 40 04             	lea    0x4(%eax),%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ca9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cae:	eb 74                	jmp    800d24 <vprintfmt+0x3a7>
	if (lflag >= 2)
  800cb0:	83 f9 01             	cmp    $0x1,%ecx
  800cb3:	7f 1b                	jg     800cd0 <vprintfmt+0x353>
	else if (lflag)
  800cb5:	85 c9                	test   %ecx,%ecx
  800cb7:	74 2c                	je     800ce5 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800cb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbc:	8b 10                	mov    (%eax),%edx
  800cbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc3:	8d 40 04             	lea    0x4(%eax),%eax
  800cc6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cc9:	b8 08 00 00 00       	mov    $0x8,%eax
  800cce:	eb 54                	jmp    800d24 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800cd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd3:	8b 10                	mov    (%eax),%edx
  800cd5:	8b 48 04             	mov    0x4(%eax),%ecx
  800cd8:	8d 40 08             	lea    0x8(%eax),%eax
  800cdb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cde:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce3:	eb 3f                	jmp    800d24 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce8:	8b 10                	mov    (%eax),%edx
  800cea:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cef:	8d 40 04             	lea    0x4(%eax),%eax
  800cf2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cf5:	b8 08 00 00 00       	mov    $0x8,%eax
  800cfa:	eb 28                	jmp    800d24 <vprintfmt+0x3a7>
			putch('0', putdat);
  800cfc:	83 ec 08             	sub    $0x8,%esp
  800cff:	53                   	push   %ebx
  800d00:	6a 30                	push   $0x30
  800d02:	ff d6                	call   *%esi
			putch('x', putdat);
  800d04:	83 c4 08             	add    $0x8,%esp
  800d07:	53                   	push   %ebx
  800d08:	6a 78                	push   $0x78
  800d0a:	ff d6                	call   *%esi
			num = (unsigned long long)
  800d0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0f:	8b 10                	mov    (%eax),%edx
  800d11:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800d16:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800d19:	8d 40 04             	lea    0x4(%eax),%eax
  800d1c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d1f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800d24:	83 ec 0c             	sub    $0xc,%esp
  800d27:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800d2b:	57                   	push   %edi
  800d2c:	ff 75 e0             	pushl  -0x20(%ebp)
  800d2f:	50                   	push   %eax
  800d30:	51                   	push   %ecx
  800d31:	52                   	push   %edx
  800d32:	89 da                	mov    %ebx,%edx
  800d34:	89 f0                	mov    %esi,%eax
  800d36:	e8 5a fb ff ff       	call   800895 <printnum>
			break;
  800d3b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800d3e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d41:	e9 55 fc ff ff       	jmp    80099b <vprintfmt+0x1e>
	if (lflag >= 2)
  800d46:	83 f9 01             	cmp    $0x1,%ecx
  800d49:	7f 1b                	jg     800d66 <vprintfmt+0x3e9>
	else if (lflag)
  800d4b:	85 c9                	test   %ecx,%ecx
  800d4d:	74 2c                	je     800d7b <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800d4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d52:	8b 10                	mov    (%eax),%edx
  800d54:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d59:	8d 40 04             	lea    0x4(%eax),%eax
  800d5c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d5f:	b8 10 00 00 00       	mov    $0x10,%eax
  800d64:	eb be                	jmp    800d24 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	8b 10                	mov    (%eax),%edx
  800d6b:	8b 48 04             	mov    0x4(%eax),%ecx
  800d6e:	8d 40 08             	lea    0x8(%eax),%eax
  800d71:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d74:	b8 10 00 00 00       	mov    $0x10,%eax
  800d79:	eb a9                	jmp    800d24 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800d7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7e:	8b 10                	mov    (%eax),%edx
  800d80:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d85:	8d 40 04             	lea    0x4(%eax),%eax
  800d88:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d8b:	b8 10 00 00 00       	mov    $0x10,%eax
  800d90:	eb 92                	jmp    800d24 <vprintfmt+0x3a7>
			putch(ch, putdat);
  800d92:	83 ec 08             	sub    $0x8,%esp
  800d95:	53                   	push   %ebx
  800d96:	6a 25                	push   $0x25
  800d98:	ff d6                	call   *%esi
			break;
  800d9a:	83 c4 10             	add    $0x10,%esp
  800d9d:	eb 9f                	jmp    800d3e <vprintfmt+0x3c1>
			putch('%', putdat);
  800d9f:	83 ec 08             	sub    $0x8,%esp
  800da2:	53                   	push   %ebx
  800da3:	6a 25                	push   $0x25
  800da5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800da7:	83 c4 10             	add    $0x10,%esp
  800daa:	89 f8                	mov    %edi,%eax
  800dac:	eb 03                	jmp    800db1 <vprintfmt+0x434>
  800dae:	83 e8 01             	sub    $0x1,%eax
  800db1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800db5:	75 f7                	jne    800dae <vprintfmt+0x431>
  800db7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dba:	eb 82                	jmp    800d3e <vprintfmt+0x3c1>

00800dbc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 18             	sub    $0x18,%esp
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dcb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800dcf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800dd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	74 26                	je     800e03 <vsnprintf+0x47>
  800ddd:	85 d2                	test   %edx,%edx
  800ddf:	7e 22                	jle    800e03 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de1:	ff 75 14             	pushl  0x14(%ebp)
  800de4:	ff 75 10             	pushl  0x10(%ebp)
  800de7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dea:	50                   	push   %eax
  800deb:	68 43 09 80 00       	push   $0x800943
  800df0:	e8 88 fb ff ff       	call   80097d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dfe:	83 c4 10             	add    $0x10,%esp
}
  800e01:	c9                   	leave  
  800e02:	c3                   	ret    
		return -E_INVAL;
  800e03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e08:	eb f7                	jmp    800e01 <vsnprintf+0x45>

00800e0a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e10:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800e13:	50                   	push   %eax
  800e14:	ff 75 10             	pushl  0x10(%ebp)
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	ff 75 08             	pushl  0x8(%ebp)
  800e1d:	e8 9a ff ff ff       	call   800dbc <vsnprintf>
	va_end(ap);

	return rc;
}
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800e33:	74 05                	je     800e3a <strlen+0x16>
		n++;
  800e35:	83 c0 01             	add    $0x1,%eax
  800e38:	eb f5                	jmp    800e2f <strlen+0xb>
	return n;
}
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e45:	ba 00 00 00 00       	mov    $0x0,%edx
  800e4a:	39 c2                	cmp    %eax,%edx
  800e4c:	74 0d                	je     800e5b <strnlen+0x1f>
  800e4e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800e52:	74 05                	je     800e59 <strnlen+0x1d>
		n++;
  800e54:	83 c2 01             	add    $0x1,%edx
  800e57:	eb f1                	jmp    800e4a <strnlen+0xe>
  800e59:	89 d0                	mov    %edx,%eax
	return n;
}
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    

00800e5d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	53                   	push   %ebx
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800e67:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800e70:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800e73:	83 c2 01             	add    $0x1,%edx
  800e76:	84 c9                	test   %cl,%cl
  800e78:	75 f2                	jne    800e6c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800e7a:	5b                   	pop    %ebx
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    

00800e7d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	53                   	push   %ebx
  800e81:	83 ec 10             	sub    $0x10,%esp
  800e84:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800e87:	53                   	push   %ebx
  800e88:	e8 97 ff ff ff       	call   800e24 <strlen>
  800e8d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800e90:	ff 75 0c             	pushl  0xc(%ebp)
  800e93:	01 d8                	add    %ebx,%eax
  800e95:	50                   	push   %eax
  800e96:	e8 c2 ff ff ff       	call   800e5d <strcpy>
	return dst;
}
  800e9b:	89 d8                	mov    %ebx,%eax
  800e9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    

00800ea2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ead:	89 c6                	mov    %eax,%esi
  800eaf:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eb2:	89 c2                	mov    %eax,%edx
  800eb4:	39 f2                	cmp    %esi,%edx
  800eb6:	74 11                	je     800ec9 <strncpy+0x27>
		*dst++ = *src;
  800eb8:	83 c2 01             	add    $0x1,%edx
  800ebb:	0f b6 19             	movzbl (%ecx),%ebx
  800ebe:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ec1:	80 fb 01             	cmp    $0x1,%bl
  800ec4:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ec7:	eb eb                	jmp    800eb4 <strncpy+0x12>
	}
	return ret;
}
  800ec9:	5b                   	pop    %ebx
  800eca:	5e                   	pop    %esi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
  800ed2:	8b 75 08             	mov    0x8(%ebp),%esi
  800ed5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed8:	8b 55 10             	mov    0x10(%ebp),%edx
  800edb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800edd:	85 d2                	test   %edx,%edx
  800edf:	74 21                	je     800f02 <strlcpy+0x35>
  800ee1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ee5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ee7:	39 c2                	cmp    %eax,%edx
  800ee9:	74 14                	je     800eff <strlcpy+0x32>
  800eeb:	0f b6 19             	movzbl (%ecx),%ebx
  800eee:	84 db                	test   %bl,%bl
  800ef0:	74 0b                	je     800efd <strlcpy+0x30>
			*dst++ = *src++;
  800ef2:	83 c1 01             	add    $0x1,%ecx
  800ef5:	83 c2 01             	add    $0x1,%edx
  800ef8:	88 5a ff             	mov    %bl,-0x1(%edx)
  800efb:	eb ea                	jmp    800ee7 <strlcpy+0x1a>
  800efd:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800eff:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f02:	29 f0                	sub    %esi,%eax
}
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800f11:	0f b6 01             	movzbl (%ecx),%eax
  800f14:	84 c0                	test   %al,%al
  800f16:	74 0c                	je     800f24 <strcmp+0x1c>
  800f18:	3a 02                	cmp    (%edx),%al
  800f1a:	75 08                	jne    800f24 <strcmp+0x1c>
		p++, q++;
  800f1c:	83 c1 01             	add    $0x1,%ecx
  800f1f:	83 c2 01             	add    $0x1,%edx
  800f22:	eb ed                	jmp    800f11 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f24:	0f b6 c0             	movzbl %al,%eax
  800f27:	0f b6 12             	movzbl (%edx),%edx
  800f2a:	29 d0                	sub    %edx,%eax
}
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	53                   	push   %ebx
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f38:	89 c3                	mov    %eax,%ebx
  800f3a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800f3d:	eb 06                	jmp    800f45 <strncmp+0x17>
		n--, p++, q++;
  800f3f:	83 c0 01             	add    $0x1,%eax
  800f42:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800f45:	39 d8                	cmp    %ebx,%eax
  800f47:	74 16                	je     800f5f <strncmp+0x31>
  800f49:	0f b6 08             	movzbl (%eax),%ecx
  800f4c:	84 c9                	test   %cl,%cl
  800f4e:	74 04                	je     800f54 <strncmp+0x26>
  800f50:	3a 0a                	cmp    (%edx),%cl
  800f52:	74 eb                	je     800f3f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f54:	0f b6 00             	movzbl (%eax),%eax
  800f57:	0f b6 12             	movzbl (%edx),%edx
  800f5a:	29 d0                	sub    %edx,%eax
}
  800f5c:	5b                   	pop    %ebx
  800f5d:	5d                   	pop    %ebp
  800f5e:	c3                   	ret    
		return 0;
  800f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f64:	eb f6                	jmp    800f5c <strncmp+0x2e>

00800f66 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f70:	0f b6 10             	movzbl (%eax),%edx
  800f73:	84 d2                	test   %dl,%dl
  800f75:	74 09                	je     800f80 <strchr+0x1a>
		if (*s == c)
  800f77:	38 ca                	cmp    %cl,%dl
  800f79:	74 0a                	je     800f85 <strchr+0x1f>
	for (; *s; s++)
  800f7b:	83 c0 01             	add    $0x1,%eax
  800f7e:	eb f0                	jmp    800f70 <strchr+0xa>
			return (char *) s;
	return 0;
  800f80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    

00800f87 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f91:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800f94:	38 ca                	cmp    %cl,%dl
  800f96:	74 09                	je     800fa1 <strfind+0x1a>
  800f98:	84 d2                	test   %dl,%dl
  800f9a:	74 05                	je     800fa1 <strfind+0x1a>
	for (; *s; s++)
  800f9c:	83 c0 01             	add    $0x1,%eax
  800f9f:	eb f0                	jmp    800f91 <strfind+0xa>
			break;
	return (char *) s;
}
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	57                   	push   %edi
  800fa7:	56                   	push   %esi
  800fa8:	53                   	push   %ebx
  800fa9:	8b 7d 08             	mov    0x8(%ebp),%edi
  800fac:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800faf:	85 c9                	test   %ecx,%ecx
  800fb1:	74 31                	je     800fe4 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800fb3:	89 f8                	mov    %edi,%eax
  800fb5:	09 c8                	or     %ecx,%eax
  800fb7:	a8 03                	test   $0x3,%al
  800fb9:	75 23                	jne    800fde <memset+0x3b>
		c &= 0xFF;
  800fbb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800fbf:	89 d3                	mov    %edx,%ebx
  800fc1:	c1 e3 08             	shl    $0x8,%ebx
  800fc4:	89 d0                	mov    %edx,%eax
  800fc6:	c1 e0 18             	shl    $0x18,%eax
  800fc9:	89 d6                	mov    %edx,%esi
  800fcb:	c1 e6 10             	shl    $0x10,%esi
  800fce:	09 f0                	or     %esi,%eax
  800fd0:	09 c2                	or     %eax,%edx
  800fd2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800fd4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800fd7:	89 d0                	mov    %edx,%eax
  800fd9:	fc                   	cld    
  800fda:	f3 ab                	rep stos %eax,%es:(%edi)
  800fdc:	eb 06                	jmp    800fe4 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	fc                   	cld    
  800fe2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800fe4:	89 f8                	mov    %edi,%eax
  800fe6:	5b                   	pop    %ebx
  800fe7:	5e                   	pop    %esi
  800fe8:	5f                   	pop    %edi
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    

00800feb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ff6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ff9:	39 c6                	cmp    %eax,%esi
  800ffb:	73 32                	jae    80102f <memmove+0x44>
  800ffd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801000:	39 c2                	cmp    %eax,%edx
  801002:	76 2b                	jbe    80102f <memmove+0x44>
		s += n;
		d += n;
  801004:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801007:	89 fe                	mov    %edi,%esi
  801009:	09 ce                	or     %ecx,%esi
  80100b:	09 d6                	or     %edx,%esi
  80100d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801013:	75 0e                	jne    801023 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801015:	83 ef 04             	sub    $0x4,%edi
  801018:	8d 72 fc             	lea    -0x4(%edx),%esi
  80101b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80101e:	fd                   	std    
  80101f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801021:	eb 09                	jmp    80102c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801023:	83 ef 01             	sub    $0x1,%edi
  801026:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801029:	fd                   	std    
  80102a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80102c:	fc                   	cld    
  80102d:	eb 1a                	jmp    801049 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80102f:	89 c2                	mov    %eax,%edx
  801031:	09 ca                	or     %ecx,%edx
  801033:	09 f2                	or     %esi,%edx
  801035:	f6 c2 03             	test   $0x3,%dl
  801038:	75 0a                	jne    801044 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80103a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80103d:	89 c7                	mov    %eax,%edi
  80103f:	fc                   	cld    
  801040:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801042:	eb 05                	jmp    801049 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801044:	89 c7                	mov    %eax,%edi
  801046:	fc                   	cld    
  801047:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801053:	ff 75 10             	pushl  0x10(%ebp)
  801056:	ff 75 0c             	pushl  0xc(%ebp)
  801059:	ff 75 08             	pushl  0x8(%ebp)
  80105c:	e8 8a ff ff ff       	call   800feb <memmove>
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	56                   	push   %esi
  801067:	53                   	push   %ebx
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106e:	89 c6                	mov    %eax,%esi
  801070:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801073:	39 f0                	cmp    %esi,%eax
  801075:	74 1c                	je     801093 <memcmp+0x30>
		if (*s1 != *s2)
  801077:	0f b6 08             	movzbl (%eax),%ecx
  80107a:	0f b6 1a             	movzbl (%edx),%ebx
  80107d:	38 d9                	cmp    %bl,%cl
  80107f:	75 08                	jne    801089 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801081:	83 c0 01             	add    $0x1,%eax
  801084:	83 c2 01             	add    $0x1,%edx
  801087:	eb ea                	jmp    801073 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801089:	0f b6 c1             	movzbl %cl,%eax
  80108c:	0f b6 db             	movzbl %bl,%ebx
  80108f:	29 d8                	sub    %ebx,%eax
  801091:	eb 05                	jmp    801098 <memcmp+0x35>
	}

	return 0;
  801093:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5d                   	pop    %ebp
  80109b:	c3                   	ret    

0080109c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8010a5:	89 c2                	mov    %eax,%edx
  8010a7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8010aa:	39 d0                	cmp    %edx,%eax
  8010ac:	73 09                	jae    8010b7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010ae:	38 08                	cmp    %cl,(%eax)
  8010b0:	74 05                	je     8010b7 <memfind+0x1b>
	for (; s < ends; s++)
  8010b2:	83 c0 01             	add    $0x1,%eax
  8010b5:	eb f3                	jmp    8010aa <memfind+0xe>
			break;
	return (void *) s;
}
  8010b7:	5d                   	pop    %ebp
  8010b8:	c3                   	ret    

008010b9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	57                   	push   %edi
  8010bd:	56                   	push   %esi
  8010be:	53                   	push   %ebx
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c5:	eb 03                	jmp    8010ca <strtol+0x11>
		s++;
  8010c7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8010ca:	0f b6 01             	movzbl (%ecx),%eax
  8010cd:	3c 20                	cmp    $0x20,%al
  8010cf:	74 f6                	je     8010c7 <strtol+0xe>
  8010d1:	3c 09                	cmp    $0x9,%al
  8010d3:	74 f2                	je     8010c7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8010d5:	3c 2b                	cmp    $0x2b,%al
  8010d7:	74 2a                	je     801103 <strtol+0x4a>
	int neg = 0;
  8010d9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8010de:	3c 2d                	cmp    $0x2d,%al
  8010e0:	74 2b                	je     80110d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010e2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8010e8:	75 0f                	jne    8010f9 <strtol+0x40>
  8010ea:	80 39 30             	cmpb   $0x30,(%ecx)
  8010ed:	74 28                	je     801117 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8010ef:	85 db                	test   %ebx,%ebx
  8010f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010f6:	0f 44 d8             	cmove  %eax,%ebx
  8010f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801101:	eb 50                	jmp    801153 <strtol+0x9a>
		s++;
  801103:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801106:	bf 00 00 00 00       	mov    $0x0,%edi
  80110b:	eb d5                	jmp    8010e2 <strtol+0x29>
		s++, neg = 1;
  80110d:	83 c1 01             	add    $0x1,%ecx
  801110:	bf 01 00 00 00       	mov    $0x1,%edi
  801115:	eb cb                	jmp    8010e2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801117:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80111b:	74 0e                	je     80112b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  80111d:	85 db                	test   %ebx,%ebx
  80111f:	75 d8                	jne    8010f9 <strtol+0x40>
		s++, base = 8;
  801121:	83 c1 01             	add    $0x1,%ecx
  801124:	bb 08 00 00 00       	mov    $0x8,%ebx
  801129:	eb ce                	jmp    8010f9 <strtol+0x40>
		s += 2, base = 16;
  80112b:	83 c1 02             	add    $0x2,%ecx
  80112e:	bb 10 00 00 00       	mov    $0x10,%ebx
  801133:	eb c4                	jmp    8010f9 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801135:	8d 72 9f             	lea    -0x61(%edx),%esi
  801138:	89 f3                	mov    %esi,%ebx
  80113a:	80 fb 19             	cmp    $0x19,%bl
  80113d:	77 29                	ja     801168 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80113f:	0f be d2             	movsbl %dl,%edx
  801142:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801145:	3b 55 10             	cmp    0x10(%ebp),%edx
  801148:	7d 30                	jge    80117a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80114a:	83 c1 01             	add    $0x1,%ecx
  80114d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801151:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801153:	0f b6 11             	movzbl (%ecx),%edx
  801156:	8d 72 d0             	lea    -0x30(%edx),%esi
  801159:	89 f3                	mov    %esi,%ebx
  80115b:	80 fb 09             	cmp    $0x9,%bl
  80115e:	77 d5                	ja     801135 <strtol+0x7c>
			dig = *s - '0';
  801160:	0f be d2             	movsbl %dl,%edx
  801163:	83 ea 30             	sub    $0x30,%edx
  801166:	eb dd                	jmp    801145 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801168:	8d 72 bf             	lea    -0x41(%edx),%esi
  80116b:	89 f3                	mov    %esi,%ebx
  80116d:	80 fb 19             	cmp    $0x19,%bl
  801170:	77 08                	ja     80117a <strtol+0xc1>
			dig = *s - 'A' + 10;
  801172:	0f be d2             	movsbl %dl,%edx
  801175:	83 ea 37             	sub    $0x37,%edx
  801178:	eb cb                	jmp    801145 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80117a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80117e:	74 05                	je     801185 <strtol+0xcc>
		*endptr = (char *) s;
  801180:	8b 75 0c             	mov    0xc(%ebp),%esi
  801183:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801185:	89 c2                	mov    %eax,%edx
  801187:	f7 da                	neg    %edx
  801189:	85 ff                	test   %edi,%edi
  80118b:	0f 45 c2             	cmovne %edx,%eax
}
  80118e:	5b                   	pop    %ebx
  80118f:	5e                   	pop    %esi
  801190:	5f                   	pop    %edi
  801191:	5d                   	pop    %ebp
  801192:	c3                   	ret    

00801193 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	57                   	push   %edi
  801197:	56                   	push   %esi
  801198:	53                   	push   %ebx
	asm volatile("int %1\n"
  801199:	b8 00 00 00 00       	mov    $0x0,%eax
  80119e:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a4:	89 c3                	mov    %eax,%ebx
  8011a6:	89 c7                	mov    %eax,%edi
  8011a8:	89 c6                	mov    %eax,%esi
  8011aa:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8011ac:	5b                   	pop    %ebx
  8011ad:	5e                   	pop    %esi
  8011ae:	5f                   	pop    %edi
  8011af:	5d                   	pop    %ebp
  8011b0:	c3                   	ret    

008011b1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	57                   	push   %edi
  8011b5:	56                   	push   %esi
  8011b6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8011c1:	89 d1                	mov    %edx,%ecx
  8011c3:	89 d3                	mov    %edx,%ebx
  8011c5:	89 d7                	mov    %edx,%edi
  8011c7:	89 d6                	mov    %edx,%esi
  8011c9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8011cb:	5b                   	pop    %ebx
  8011cc:	5e                   	pop    %esi
  8011cd:	5f                   	pop    %edi
  8011ce:	5d                   	pop    %ebp
  8011cf:	c3                   	ret    

008011d0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	57                   	push   %edi
  8011d4:	56                   	push   %esi
  8011d5:	53                   	push   %ebx
  8011d6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011de:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e6:	89 cb                	mov    %ecx,%ebx
  8011e8:	89 cf                	mov    %ecx,%edi
  8011ea:	89 ce                	mov    %ecx,%esi
  8011ec:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	7f 08                	jg     8011fa <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5f                   	pop    %edi
  8011f8:	5d                   	pop    %ebp
  8011f9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	50                   	push   %eax
  8011fe:	6a 03                	push   $0x3
  801200:	68 3f 32 80 00       	push   $0x80323f
  801205:	6a 23                	push   $0x23
  801207:	68 5c 32 80 00       	push   $0x80325c
  80120c:	e8 95 f5 ff ff       	call   8007a6 <_panic>

00801211 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	57                   	push   %edi
  801215:	56                   	push   %esi
  801216:	53                   	push   %ebx
	asm volatile("int %1\n"
  801217:	ba 00 00 00 00       	mov    $0x0,%edx
  80121c:	b8 02 00 00 00       	mov    $0x2,%eax
  801221:	89 d1                	mov    %edx,%ecx
  801223:	89 d3                	mov    %edx,%ebx
  801225:	89 d7                	mov    %edx,%edi
  801227:	89 d6                	mov    %edx,%esi
  801229:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80122b:	5b                   	pop    %ebx
  80122c:	5e                   	pop    %esi
  80122d:	5f                   	pop    %edi
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    

00801230 <sys_yield>:

void
sys_yield(void)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	57                   	push   %edi
  801234:	56                   	push   %esi
  801235:	53                   	push   %ebx
	asm volatile("int %1\n"
  801236:	ba 00 00 00 00       	mov    $0x0,%edx
  80123b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801240:	89 d1                	mov    %edx,%ecx
  801242:	89 d3                	mov    %edx,%ebx
  801244:	89 d7                	mov    %edx,%edi
  801246:	89 d6                	mov    %edx,%esi
  801248:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80124a:	5b                   	pop    %ebx
  80124b:	5e                   	pop    %esi
  80124c:	5f                   	pop    %edi
  80124d:	5d                   	pop    %ebp
  80124e:	c3                   	ret    

0080124f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
  801252:	57                   	push   %edi
  801253:	56                   	push   %esi
  801254:	53                   	push   %ebx
  801255:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801258:	be 00 00 00 00       	mov    $0x0,%esi
  80125d:	8b 55 08             	mov    0x8(%ebp),%edx
  801260:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801263:	b8 04 00 00 00       	mov    $0x4,%eax
  801268:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80126b:	89 f7                	mov    %esi,%edi
  80126d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80126f:	85 c0                	test   %eax,%eax
  801271:	7f 08                	jg     80127b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801273:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801276:	5b                   	pop    %ebx
  801277:	5e                   	pop    %esi
  801278:	5f                   	pop    %edi
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80127b:	83 ec 0c             	sub    $0xc,%esp
  80127e:	50                   	push   %eax
  80127f:	6a 04                	push   $0x4
  801281:	68 3f 32 80 00       	push   $0x80323f
  801286:	6a 23                	push   $0x23
  801288:	68 5c 32 80 00       	push   $0x80325c
  80128d:	e8 14 f5 ff ff       	call   8007a6 <_panic>

00801292 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	57                   	push   %edi
  801296:	56                   	push   %esi
  801297:	53                   	push   %ebx
  801298:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a1:	b8 05 00 00 00       	mov    $0x5,%eax
  8012a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012a9:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012ac:	8b 75 18             	mov    0x18(%ebp),%esi
  8012af:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012b1:	85 c0                	test   %eax,%eax
  8012b3:	7f 08                	jg     8012bd <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8012b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b8:	5b                   	pop    %ebx
  8012b9:	5e                   	pop    %esi
  8012ba:	5f                   	pop    %edi
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012bd:	83 ec 0c             	sub    $0xc,%esp
  8012c0:	50                   	push   %eax
  8012c1:	6a 05                	push   $0x5
  8012c3:	68 3f 32 80 00       	push   $0x80323f
  8012c8:	6a 23                	push   $0x23
  8012ca:	68 5c 32 80 00       	push   $0x80325c
  8012cf:	e8 d2 f4 ff ff       	call   8007a6 <_panic>

008012d4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	57                   	push   %edi
  8012d8:	56                   	push   %esi
  8012d9:	53                   	push   %ebx
  8012da:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e8:	b8 06 00 00 00       	mov    $0x6,%eax
  8012ed:	89 df                	mov    %ebx,%edi
  8012ef:	89 de                	mov    %ebx,%esi
  8012f1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	7f 08                	jg     8012ff <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012fa:	5b                   	pop    %ebx
  8012fb:	5e                   	pop    %esi
  8012fc:	5f                   	pop    %edi
  8012fd:	5d                   	pop    %ebp
  8012fe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ff:	83 ec 0c             	sub    $0xc,%esp
  801302:	50                   	push   %eax
  801303:	6a 06                	push   $0x6
  801305:	68 3f 32 80 00       	push   $0x80323f
  80130a:	6a 23                	push   $0x23
  80130c:	68 5c 32 80 00       	push   $0x80325c
  801311:	e8 90 f4 ff ff       	call   8007a6 <_panic>

00801316 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	57                   	push   %edi
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
  80131c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80131f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801324:	8b 55 08             	mov    0x8(%ebp),%edx
  801327:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80132a:	b8 08 00 00 00       	mov    $0x8,%eax
  80132f:	89 df                	mov    %ebx,%edi
  801331:	89 de                	mov    %ebx,%esi
  801333:	cd 30                	int    $0x30
	if(check && ret > 0)
  801335:	85 c0                	test   %eax,%eax
  801337:	7f 08                	jg     801341 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801339:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80133c:	5b                   	pop    %ebx
  80133d:	5e                   	pop    %esi
  80133e:	5f                   	pop    %edi
  80133f:	5d                   	pop    %ebp
  801340:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801341:	83 ec 0c             	sub    $0xc,%esp
  801344:	50                   	push   %eax
  801345:	6a 08                	push   $0x8
  801347:	68 3f 32 80 00       	push   $0x80323f
  80134c:	6a 23                	push   $0x23
  80134e:	68 5c 32 80 00       	push   $0x80325c
  801353:	e8 4e f4 ff ff       	call   8007a6 <_panic>

00801358 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	57                   	push   %edi
  80135c:	56                   	push   %esi
  80135d:	53                   	push   %ebx
  80135e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801361:	bb 00 00 00 00       	mov    $0x0,%ebx
  801366:	8b 55 08             	mov    0x8(%ebp),%edx
  801369:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80136c:	b8 09 00 00 00       	mov    $0x9,%eax
  801371:	89 df                	mov    %ebx,%edi
  801373:	89 de                	mov    %ebx,%esi
  801375:	cd 30                	int    $0x30
	if(check && ret > 0)
  801377:	85 c0                	test   %eax,%eax
  801379:	7f 08                	jg     801383 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80137b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137e:	5b                   	pop    %ebx
  80137f:	5e                   	pop    %esi
  801380:	5f                   	pop    %edi
  801381:	5d                   	pop    %ebp
  801382:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801383:	83 ec 0c             	sub    $0xc,%esp
  801386:	50                   	push   %eax
  801387:	6a 09                	push   $0x9
  801389:	68 3f 32 80 00       	push   $0x80323f
  80138e:	6a 23                	push   $0x23
  801390:	68 5c 32 80 00       	push   $0x80325c
  801395:	e8 0c f4 ff ff       	call   8007a6 <_panic>

0080139a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	57                   	push   %edi
  80139e:	56                   	push   %esi
  80139f:	53                   	push   %ebx
  8013a0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013b3:	89 df                	mov    %ebx,%edi
  8013b5:	89 de                	mov    %ebx,%esi
  8013b7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	7f 08                	jg     8013c5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8013bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c0:	5b                   	pop    %ebx
  8013c1:	5e                   	pop    %esi
  8013c2:	5f                   	pop    %edi
  8013c3:	5d                   	pop    %ebp
  8013c4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013c5:	83 ec 0c             	sub    $0xc,%esp
  8013c8:	50                   	push   %eax
  8013c9:	6a 0a                	push   $0xa
  8013cb:	68 3f 32 80 00       	push   $0x80323f
  8013d0:	6a 23                	push   $0x23
  8013d2:	68 5c 32 80 00       	push   $0x80325c
  8013d7:	e8 ca f3 ff ff       	call   8007a6 <_panic>

008013dc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	57                   	push   %edi
  8013e0:	56                   	push   %esi
  8013e1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e8:	b8 0c 00 00 00       	mov    $0xc,%eax
  8013ed:	be 00 00 00 00       	mov    $0x0,%esi
  8013f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013f5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013f8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8013fa:	5b                   	pop    %ebx
  8013fb:	5e                   	pop    %esi
  8013fc:	5f                   	pop    %edi
  8013fd:	5d                   	pop    %ebp
  8013fe:	c3                   	ret    

008013ff <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	57                   	push   %edi
  801403:	56                   	push   %esi
  801404:	53                   	push   %ebx
  801405:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801408:	b9 00 00 00 00       	mov    $0x0,%ecx
  80140d:	8b 55 08             	mov    0x8(%ebp),%edx
  801410:	b8 0d 00 00 00       	mov    $0xd,%eax
  801415:	89 cb                	mov    %ecx,%ebx
  801417:	89 cf                	mov    %ecx,%edi
  801419:	89 ce                	mov    %ecx,%esi
  80141b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80141d:	85 c0                	test   %eax,%eax
  80141f:	7f 08                	jg     801429 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801421:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801424:	5b                   	pop    %ebx
  801425:	5e                   	pop    %esi
  801426:	5f                   	pop    %edi
  801427:	5d                   	pop    %ebp
  801428:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801429:	83 ec 0c             	sub    $0xc,%esp
  80142c:	50                   	push   %eax
  80142d:	6a 0d                	push   $0xd
  80142f:	68 3f 32 80 00       	push   $0x80323f
  801434:	6a 23                	push   $0x23
  801436:	68 5c 32 80 00       	push   $0x80325c
  80143b:	e8 66 f3 ff ff       	call   8007a6 <_panic>

00801440 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	57                   	push   %edi
  801444:	56                   	push   %esi
  801445:	53                   	push   %ebx
	asm volatile("int %1\n"
  801446:	ba 00 00 00 00       	mov    $0x0,%edx
  80144b:	b8 0e 00 00 00       	mov    $0xe,%eax
  801450:	89 d1                	mov    %edx,%ecx
  801452:	89 d3                	mov    %edx,%ebx
  801454:	89 d7                	mov    %edx,%edi
  801456:	89 d6                	mov    %edx,%esi
  801458:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80145a:	5b                   	pop    %ebx
  80145b:	5e                   	pop    %esi
  80145c:	5f                   	pop    %edi
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    

0080145f <pgfault>:
	return uvpt[PGNUM((uintptr_t)addr)];
}

static void
pgfault(struct UTrapframe *utf)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	57                   	push   %edi
  801463:	56                   	push   %esi
  801464:	53                   	push   %ebx
  801465:	83 ec 0c             	sub    $0xc,%esp
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80146b:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  80146d:	8b 50 04             	mov    0x4(%eax),%edx
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  801470:	89 d9                	mov    %ebx,%ecx
  801472:	c1 e9 16             	shr    $0x16,%ecx
  801475:	8b 0c 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%ecx
		return 0;
  80147c:	be 00 00 00 00       	mov    $0x0,%esi
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  801481:	f6 c1 01             	test   $0x1,%cl
  801484:	74 0c                	je     801492 <pgfault+0x33>
	return uvpt[PGNUM((uintptr_t)addr)];
  801486:	89 d9                	mov    %ebx,%ecx
  801488:	c1 e9 0c             	shr    $0xc,%ecx
  80148b:	8b 34 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
  if ((err & FEC_WR) == 0) {
  801492:	f6 c2 02             	test   $0x2,%dl
  801495:	0f 84 a3 00 00 00    	je     80153e <pgfault+0xdf>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  }
  if ((uvpt[PGNUM(addr)] & PTE_COW) == 0) {
  80149b:	89 da                	mov    %ebx,%edx
  80149d:	c1 ea 0c             	shr    $0xc,%edx
  8014a0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014a7:	f6 c6 08             	test   $0x8,%dh
  8014aa:	0f 84 b7 00 00 00    	je     801567 <pgfault+0x108>
	// LAB 4: Your code here.
  // 对于某一页来说,父进程必须在子进程标记为cow后才能进行写操作
  // 而且在写操作之前它（父进程）的该页标记必须是cow，否则父进程
  // 会对子进程指向的页进行写操作而不是触发写时复制错误，这会导致
  // 父进程触发了cow后两个进程还指向相同的物理页。
  envid_t envid = sys_getenvid();
  8014b0:	e8 5c fd ff ff       	call   801211 <sys_getenvid>
  8014b5:	89 c6                	mov    %eax,%esi
  if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  8014b7:	83 ec 04             	sub    $0x4,%esp
  8014ba:	6a 07                	push   $0x7
  8014bc:	68 00 f0 7f 00       	push   $0x7ff000
  8014c1:	50                   	push   %eax
  8014c2:	e8 88 fd ff ff       	call   80124f <sys_page_alloc>
  8014c7:	83 c4 10             	add    $0x10,%esp
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	0f 88 bc 00 00 00    	js     80158e <pgfault+0x12f>
      panic("pgfault: page allocation failed %e", r);

  addr = ROUNDDOWN(addr, PGSIZE);
  8014d2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(PFTEMP, addr, PGSIZE);
  8014d8:	83 ec 04             	sub    $0x4,%esp
  8014db:	68 00 10 00 00       	push   $0x1000
  8014e0:	53                   	push   %ebx
  8014e1:	68 00 f0 7f 00       	push   $0x7ff000
  8014e6:	e8 00 fb ff ff       	call   800feb <memmove>
  if ((r = sys_page_unmap(envid, addr)) < 0)
  8014eb:	83 c4 08             	add    $0x8,%esp
  8014ee:	53                   	push   %ebx
  8014ef:	56                   	push   %esi
  8014f0:	e8 df fd ff ff       	call   8012d4 <sys_page_unmap>
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	0f 88 a0 00 00 00    	js     8015a0 <pgfault+0x141>
      panic("pgfault: page unmap failed (%e)", r);
  if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  801500:	83 ec 0c             	sub    $0xc,%esp
  801503:	6a 07                	push   $0x7
  801505:	53                   	push   %ebx
  801506:	56                   	push   %esi
  801507:	68 00 f0 7f 00       	push   $0x7ff000
  80150c:	56                   	push   %esi
  80150d:	e8 80 fd ff ff       	call   801292 <sys_page_map>
  801512:	83 c4 20             	add    $0x20,%esp
  801515:	85 c0                	test   %eax,%eax
  801517:	0f 88 95 00 00 00    	js     8015b2 <pgfault+0x153>
      panic("pgfault: page map failed (%e)", r);
  if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  80151d:	83 ec 08             	sub    $0x8,%esp
  801520:	68 00 f0 7f 00       	push   $0x7ff000
  801525:	56                   	push   %esi
  801526:	e8 a9 fd ff ff       	call   8012d4 <sys_page_unmap>
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	0f 88 8e 00 00 00    	js     8015c4 <pgfault+0x165>
      panic("pgfault: page unmap failed (%e)", r);

}
  801536:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801539:	5b                   	pop    %ebx
  80153a:	5e                   	pop    %esi
  80153b:	5f                   	pop    %edi
  80153c:	5d                   	pop    %ebp
  80153d:	c3                   	ret    
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  80153e:	8b 70 28             	mov    0x28(%eax),%esi
  801541:	e8 cb fc ff ff       	call   801211 <sys_getenvid>
  801546:	56                   	push   %esi
  801547:	53                   	push   %ebx
  801548:	50                   	push   %eax
  801549:	68 6c 32 80 00       	push   $0x80326c
  80154e:	e8 2e f3 ff ff       	call   800881 <cprintf>
    panic("pgfault: invalid UtrapFrame that not write err.\n");
  801553:	83 c4 0c             	add    $0xc,%esp
  801556:	68 90 32 80 00       	push   $0x803290
  80155b:	6a 27                	push   $0x27
  80155d:	68 64 33 80 00       	push   $0x803364
  801562:	e8 3f f2 ff ff       	call   8007a6 <_panic>
    cprintf("[%08x] user fault va %08x ip %08x\n", sys_getenvid(), addr, utf->utf_eip);
  801567:	8b 78 28             	mov    0x28(%eax),%edi
  80156a:	e8 a2 fc ff ff       	call   801211 <sys_getenvid>
  80156f:	57                   	push   %edi
  801570:	53                   	push   %ebx
  801571:	50                   	push   %eax
  801572:	68 6c 32 80 00       	push   $0x80326c
  801577:	e8 05 f3 ff ff       	call   800881 <cprintf>
    panic("pgfault: invalid UtrapFrame that not cow and pte=%08x.\n", pte);
  80157c:	56                   	push   %esi
  80157d:	68 c4 32 80 00       	push   $0x8032c4
  801582:	6a 2b                	push   $0x2b
  801584:	68 64 33 80 00       	push   $0x803364
  801589:	e8 18 f2 ff ff       	call   8007a6 <_panic>
      panic("pgfault: page allocation failed %e", r);
  80158e:	50                   	push   %eax
  80158f:	68 fc 32 80 00       	push   $0x8032fc
  801594:	6a 39                	push   $0x39
  801596:	68 64 33 80 00       	push   $0x803364
  80159b:	e8 06 f2 ff ff       	call   8007a6 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  8015a0:	50                   	push   %eax
  8015a1:	68 20 33 80 00       	push   $0x803320
  8015a6:	6a 3e                	push   $0x3e
  8015a8:	68 64 33 80 00       	push   $0x803364
  8015ad:	e8 f4 f1 ff ff       	call   8007a6 <_panic>
      panic("pgfault: page map failed (%e)", r);
  8015b2:	50                   	push   %eax
  8015b3:	68 6f 33 80 00       	push   $0x80336f
  8015b8:	6a 40                	push   $0x40
  8015ba:	68 64 33 80 00       	push   $0x803364
  8015bf:	e8 e2 f1 ff ff       	call   8007a6 <_panic>
      panic("pgfault: page unmap failed (%e)", r);
  8015c4:	50                   	push   %eax
  8015c5:	68 20 33 80 00       	push   $0x803320
  8015ca:	6a 42                	push   $0x42
  8015cc:	68 64 33 80 00       	push   $0x803364
  8015d1:	e8 d0 f1 ff ff       	call   8007a6 <_panic>

008015d6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	57                   	push   %edi
  8015da:	56                   	push   %esi
  8015db:	53                   	push   %ebx
  8015dc:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
  set_pgfault_handler(pgfault);
  8015df:	68 5f 14 80 00       	push   $0x80145f
  8015e4:	e8 96 14 00 00       	call   802a7f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8015e9:	b8 07 00 00 00       	mov    $0x7,%eax
  8015ee:	cd 30                	int    $0x30
  8015f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  envid_t e_id = sys_exofork();
  if (e_id < 0) panic("fork: %e", e_id);
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 2d                	js     801627 <fork+0x51>
  8015fa:	89 c7                	mov    %eax,%edi
      thisenv = &envs[ENVX(sys_getenvid())];
      return 0;
  }

  // parent
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8015fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (e_id == 0) {
  801601:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801605:	0f 85 a6 00 00 00    	jne    8016b1 <fork+0xdb>
      thisenv = &envs[ENVX(sys_getenvid())];
  80160b:	e8 01 fc ff ff       	call   801211 <sys_getenvid>
  801610:	25 ff 03 00 00       	and    $0x3ff,%eax
  801615:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801618:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80161d:	a3 20 50 80 00       	mov    %eax,0x805020
      return 0;
  801622:	e9 79 01 00 00       	jmp    8017a0 <fork+0x1ca>
  if (e_id < 0) panic("fork: %e", e_id);
  801627:	50                   	push   %eax
  801628:	68 8d 33 80 00       	push   $0x80338d
  80162d:	68 aa 00 00 00       	push   $0xaa
  801632:	68 64 33 80 00       	push   $0x803364
  801637:	e8 6a f1 ff ff       	call   8007a6 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_P)) < 0)
  80163c:	83 ec 0c             	sub    $0xc,%esp
  80163f:	6a 05                	push   $0x5
  801641:	53                   	push   %ebx
  801642:	57                   	push   %edi
  801643:	53                   	push   %ebx
  801644:	6a 00                	push   $0x0
  801646:	e8 47 fc ff ff       	call   801292 <sys_page_map>
  80164b:	83 c4 20             	add    $0x20,%esp
  80164e:	85 c0                	test   %eax,%eax
  801650:	79 4d                	jns    80169f <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  801652:	50                   	push   %eax
  801653:	68 96 33 80 00       	push   $0x803396
  801658:	6a 61                	push   $0x61
  80165a:	68 64 33 80 00       	push   $0x803364
  80165f:	e8 42 f1 ff ff       	call   8007a6 <_panic>
		if((error_code = sys_page_map(0, addr, envid, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  801664:	83 ec 0c             	sub    $0xc,%esp
  801667:	68 05 08 00 00       	push   $0x805
  80166c:	53                   	push   %ebx
  80166d:	57                   	push   %edi
  80166e:	53                   	push   %ebx
  80166f:	6a 00                	push   $0x0
  801671:	e8 1c fc ff ff       	call   801292 <sys_page_map>
  801676:	83 c4 20             	add    $0x20,%esp
  801679:	85 c0                	test   %eax,%eax
  80167b:	0f 88 b7 00 00 00    	js     801738 <fork+0x162>
		if((error_code = sys_page_map(0, addr, 0, addr, PTE_U | PTE_COW | PTE_P)) < 0)
  801681:	83 ec 0c             	sub    $0xc,%esp
  801684:	68 05 08 00 00       	push   $0x805
  801689:	53                   	push   %ebx
  80168a:	6a 00                	push   $0x0
  80168c:	53                   	push   %ebx
  80168d:	6a 00                	push   $0x0
  80168f:	e8 fe fb ff ff       	call   801292 <sys_page_map>
  801694:	83 c4 20             	add    $0x20,%esp
  801697:	85 c0                	test   %eax,%eax
  801699:	0f 88 ab 00 00 00    	js     80174a <fork+0x174>
  for (uintptr_t addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80169f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8016a5:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8016ab:	0f 84 ab 00 00 00    	je     80175c <fork+0x186>
      if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) {
  8016b1:	89 d8                	mov    %ebx,%eax
  8016b3:	c1 e8 16             	shr    $0x16,%eax
  8016b6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016bd:	a8 01                	test   $0x1,%al
  8016bf:	74 de                	je     80169f <fork+0xc9>
  8016c1:	89 d8                	mov    %ebx,%eax
  8016c3:	c1 e8 0c             	shr    $0xc,%eax
  8016c6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016cd:	f6 c2 01             	test   $0x1,%dl
  8016d0:	74 cd                	je     80169f <fork+0xc9>
	pte_t pte = get_pte((void*)(pn * PGSIZE));
  8016d2:	c1 e0 0c             	shl    $0xc,%eax
	if((uvpd[PDX((uintptr_t)addr)] & PTE_P) == 0)
  8016d5:	89 c2                	mov    %eax,%edx
  8016d7:	c1 ea 16             	shr    $0x16,%edx
  8016da:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016e1:	f6 c2 01             	test   $0x1,%dl
  8016e4:	74 b9                	je     80169f <fork+0xc9>
	return uvpt[PGNUM((uintptr_t)addr)];
  8016e6:	c1 e8 0c             	shr    $0xc,%eax
  8016e9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if(!(pte & PTE_P))
  8016f0:	a8 01                	test   $0x1,%al
  8016f2:	74 ab                	je     80169f <fork+0xc9>
	if(!(pte & PTE_W) && !(pte & PTE_COW))
  8016f4:	a9 02 08 00 00       	test   $0x802,%eax
  8016f9:	0f 84 3d ff ff ff    	je     80163c <fork+0x66>
	else if(pte & PTE_SHARE)
  8016ff:	f6 c4 04             	test   $0x4,%ah
  801702:	0f 84 5c ff ff ff    	je     801664 <fork+0x8e>
		if((error_code = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801708:	83 ec 0c             	sub    $0xc,%esp
  80170b:	25 07 0e 00 00       	and    $0xe07,%eax
  801710:	50                   	push   %eax
  801711:	53                   	push   %ebx
  801712:	57                   	push   %edi
  801713:	53                   	push   %ebx
  801714:	6a 00                	push   $0x0
  801716:	e8 77 fb ff ff       	call   801292 <sys_page_map>
  80171b:	83 c4 20             	add    $0x20,%esp
  80171e:	85 c0                	test   %eax,%eax
  801720:	0f 89 79 ff ff ff    	jns    80169f <fork+0xc9>
			panic("Page Map Failed: %e", error_code);
  801726:	50                   	push   %eax
  801727:	68 96 33 80 00       	push   $0x803396
  80172c:	6a 67                	push   $0x67
  80172e:	68 64 33 80 00       	push   $0x803364
  801733:	e8 6e f0 ff ff       	call   8007a6 <_panic>
			panic("Page Map Failed: %e", error_code);
  801738:	50                   	push   %eax
  801739:	68 96 33 80 00       	push   $0x803396
  80173e:	6a 6d                	push   $0x6d
  801740:	68 64 33 80 00       	push   $0x803364
  801745:	e8 5c f0 ff ff       	call   8007a6 <_panic>
			panic("Page Map Failed: %e", error_code);
  80174a:	50                   	push   %eax
  80174b:	68 96 33 80 00       	push   $0x803396
  801750:	6a 70                	push   $0x70
  801752:	68 64 33 80 00       	push   $0x803364
  801757:	e8 4a f0 ff ff       	call   8007a6 <_panic>
          // dup page to child
          duppage(e_id, PGNUM(addr));
      }
  }
  // alloc page for exception stack
  int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	6a 07                	push   $0x7
  801761:	68 00 f0 bf ee       	push   $0xeebff000
  801766:	ff 75 e4             	pushl  -0x1c(%ebp)
  801769:	e8 e1 fa ff ff       	call   80124f <sys_page_alloc>
  if (r < 0) panic("fork: %e",r);
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	85 c0                	test   %eax,%eax
  801773:	78 36                	js     8017ab <fork+0x1d5>

  // DO NOT FORGET
  extern void _pgfault_upcall();
  r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801775:	83 ec 08             	sub    $0x8,%esp
  801778:	68 f5 2a 80 00       	push   $0x802af5
  80177d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801780:	e8 15 fc ff ff       	call   80139a <sys_env_set_pgfault_upcall>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	85 c0                	test   %eax,%eax
  80178a:	78 34                	js     8017c0 <fork+0x1ea>

  // mark the child environment runnable
  if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  80178c:	83 ec 08             	sub    $0x8,%esp
  80178f:	6a 02                	push   $0x2
  801791:	ff 75 e4             	pushl  -0x1c(%ebp)
  801794:	e8 7d fb ff ff       	call   801316 <sys_env_set_status>
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	85 c0                	test   %eax,%eax
  80179e:	78 35                	js     8017d5 <fork+0x1ff>
      panic("sys_env_set_status: %e", r);

  return e_id;
}
  8017a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017a6:	5b                   	pop    %ebx
  8017a7:	5e                   	pop    %esi
  8017a8:	5f                   	pop    %edi
  8017a9:	5d                   	pop    %ebp
  8017aa:	c3                   	ret    
  if (r < 0) panic("fork: %e",r);
  8017ab:	50                   	push   %eax
  8017ac:	68 8d 33 80 00       	push   $0x80338d
  8017b1:	68 ba 00 00 00       	push   $0xba
  8017b6:	68 64 33 80 00       	push   $0x803364
  8017bb:	e8 e6 ef ff ff       	call   8007a6 <_panic>
  if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8017c0:	50                   	push   %eax
  8017c1:	68 40 33 80 00       	push   $0x803340
  8017c6:	68 bf 00 00 00       	push   $0xbf
  8017cb:	68 64 33 80 00       	push   $0x803364
  8017d0:	e8 d1 ef ff ff       	call   8007a6 <_panic>
      panic("sys_env_set_status: %e", r);
  8017d5:	50                   	push   %eax
  8017d6:	68 aa 33 80 00       	push   $0x8033aa
  8017db:	68 c3 00 00 00       	push   $0xc3
  8017e0:	68 64 33 80 00       	push   $0x803364
  8017e5:	e8 bc ef ff ff       	call   8007a6 <_panic>

008017ea <sfork>:

// Challenge!
int
sfork(void)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8017f0:	68 c1 33 80 00       	push   $0x8033c1
  8017f5:	68 cc 00 00 00       	push   $0xcc
  8017fa:	68 64 33 80 00       	push   $0x803364
  8017ff:	e8 a2 ef ff ff       	call   8007a6 <_panic>

00801804 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	56                   	push   %esi
  801808:	53                   	push   %ebx
  801809:	8b 75 08             	mov    0x8(%ebp),%esi
  80180c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801812:	85 c0                	test   %eax,%eax
  801814:	74 4f                	je     801865 <ipc_recv+0x61>
  801816:	83 ec 0c             	sub    $0xc,%esp
  801819:	50                   	push   %eax
  80181a:	e8 e0 fb ff ff       	call   8013ff <sys_ipc_recv>
  80181f:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801822:	85 f6                	test   %esi,%esi
  801824:	74 14                	je     80183a <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801826:	ba 00 00 00 00       	mov    $0x0,%edx
  80182b:	85 c0                	test   %eax,%eax
  80182d:	75 09                	jne    801838 <ipc_recv+0x34>
  80182f:	8b 15 20 50 80 00    	mov    0x805020,%edx
  801835:	8b 52 74             	mov    0x74(%edx),%edx
  801838:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  80183a:	85 db                	test   %ebx,%ebx
  80183c:	74 14                	je     801852 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  80183e:	ba 00 00 00 00       	mov    $0x0,%edx
  801843:	85 c0                	test   %eax,%eax
  801845:	75 09                	jne    801850 <ipc_recv+0x4c>
  801847:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80184d:	8b 52 78             	mov    0x78(%edx),%edx
  801850:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801852:	85 c0                	test   %eax,%eax
  801854:	75 08                	jne    80185e <ipc_recv+0x5a>
  801856:	a1 20 50 80 00       	mov    0x805020,%eax
  80185b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80185e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801861:	5b                   	pop    %ebx
  801862:	5e                   	pop    %esi
  801863:	5d                   	pop    %ebp
  801864:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801865:	83 ec 0c             	sub    $0xc,%esp
  801868:	68 00 00 c0 ee       	push   $0xeec00000
  80186d:	e8 8d fb ff ff       	call   8013ff <sys_ipc_recv>
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	eb ab                	jmp    801822 <ipc_recv+0x1e>

00801877 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	57                   	push   %edi
  80187b:	56                   	push   %esi
  80187c:	53                   	push   %ebx
  80187d:	83 ec 0c             	sub    $0xc,%esp
  801880:	8b 7d 08             	mov    0x8(%ebp),%edi
  801883:	8b 75 10             	mov    0x10(%ebp),%esi
  801886:	eb 20                	jmp    8018a8 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801888:	6a 00                	push   $0x0
  80188a:	68 00 00 c0 ee       	push   $0xeec00000
  80188f:	ff 75 0c             	pushl  0xc(%ebp)
  801892:	57                   	push   %edi
  801893:	e8 44 fb ff ff       	call   8013dc <sys_ipc_try_send>
  801898:	89 c3                	mov    %eax,%ebx
  80189a:	83 c4 10             	add    $0x10,%esp
  80189d:	eb 1f                	jmp    8018be <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  80189f:	e8 8c f9 ff ff       	call   801230 <sys_yield>
	while(retval != 0) {
  8018a4:	85 db                	test   %ebx,%ebx
  8018a6:	74 33                	je     8018db <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  8018a8:	85 f6                	test   %esi,%esi
  8018aa:	74 dc                	je     801888 <ipc_send+0x11>
  8018ac:	ff 75 14             	pushl  0x14(%ebp)
  8018af:	56                   	push   %esi
  8018b0:	ff 75 0c             	pushl  0xc(%ebp)
  8018b3:	57                   	push   %edi
  8018b4:	e8 23 fb ff ff       	call   8013dc <sys_ipc_try_send>
  8018b9:	89 c3                	mov    %eax,%ebx
  8018bb:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  8018be:	83 fb f9             	cmp    $0xfffffff9,%ebx
  8018c1:	74 dc                	je     80189f <ipc_send+0x28>
  8018c3:	85 db                	test   %ebx,%ebx
  8018c5:	74 d8                	je     80189f <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  8018c7:	83 ec 04             	sub    $0x4,%esp
  8018ca:	68 d8 33 80 00       	push   $0x8033d8
  8018cf:	6a 35                	push   $0x35
  8018d1:	68 08 34 80 00       	push   $0x803408
  8018d6:	e8 cb ee ff ff       	call   8007a6 <_panic>
	}
}
  8018db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018de:	5b                   	pop    %ebx
  8018df:	5e                   	pop    %esi
  8018e0:	5f                   	pop    %edi
  8018e1:	5d                   	pop    %ebp
  8018e2:	c3                   	ret    

008018e3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8018e9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8018ee:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8018f1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8018f7:	8b 52 50             	mov    0x50(%edx),%edx
  8018fa:	39 ca                	cmp    %ecx,%edx
  8018fc:	74 11                	je     80190f <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8018fe:	83 c0 01             	add    $0x1,%eax
  801901:	3d 00 04 00 00       	cmp    $0x400,%eax
  801906:	75 e6                	jne    8018ee <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801908:	b8 00 00 00 00       	mov    $0x0,%eax
  80190d:	eb 0b                	jmp    80191a <ipc_find_env+0x37>
			return envs[i].env_id;
  80190f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801912:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801917:	8b 40 48             	mov    0x48(%eax),%eax
}
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    

0080191c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	05 00 00 00 30       	add    $0x30000000,%eax
  801927:	c1 e8 0c             	shr    $0xc,%eax
}
  80192a:	5d                   	pop    %ebp
  80192b:	c3                   	ret    

0080192c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801937:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80193c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    

00801943 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80194b:	89 c2                	mov    %eax,%edx
  80194d:	c1 ea 16             	shr    $0x16,%edx
  801950:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801957:	f6 c2 01             	test   $0x1,%dl
  80195a:	74 2d                	je     801989 <fd_alloc+0x46>
  80195c:	89 c2                	mov    %eax,%edx
  80195e:	c1 ea 0c             	shr    $0xc,%edx
  801961:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801968:	f6 c2 01             	test   $0x1,%dl
  80196b:	74 1c                	je     801989 <fd_alloc+0x46>
  80196d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801972:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801977:	75 d2                	jne    80194b <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801982:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801987:	eb 0a                	jmp    801993 <fd_alloc+0x50>
			*fd_store = fd;
  801989:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80198c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80198e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801993:	5d                   	pop    %ebp
  801994:	c3                   	ret    

00801995 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80199b:	83 f8 1f             	cmp    $0x1f,%eax
  80199e:	77 30                	ja     8019d0 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8019a0:	c1 e0 0c             	shl    $0xc,%eax
  8019a3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8019a8:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8019ae:	f6 c2 01             	test   $0x1,%dl
  8019b1:	74 24                	je     8019d7 <fd_lookup+0x42>
  8019b3:	89 c2                	mov    %eax,%edx
  8019b5:	c1 ea 0c             	shr    $0xc,%edx
  8019b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019bf:	f6 c2 01             	test   $0x1,%dl
  8019c2:	74 1a                	je     8019de <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8019c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c7:	89 02                	mov    %eax,(%edx)
	return 0;
  8019c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    
		return -E_INVAL;
  8019d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d5:	eb f7                	jmp    8019ce <fd_lookup+0x39>
		return -E_INVAL;
  8019d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019dc:	eb f0                	jmp    8019ce <fd_lookup+0x39>
  8019de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e3:	eb e9                	jmp    8019ce <fd_lookup+0x39>

008019e5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 08             	sub    $0x8,%esp
  8019eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8019ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f3:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8019f8:	39 08                	cmp    %ecx,(%eax)
  8019fa:	74 38                	je     801a34 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8019fc:	83 c2 01             	add    $0x1,%edx
  8019ff:	8b 04 95 94 34 80 00 	mov    0x803494(,%edx,4),%eax
  801a06:	85 c0                	test   %eax,%eax
  801a08:	75 ee                	jne    8019f8 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a0a:	a1 20 50 80 00       	mov    0x805020,%eax
  801a0f:	8b 40 48             	mov    0x48(%eax),%eax
  801a12:	83 ec 04             	sub    $0x4,%esp
  801a15:	51                   	push   %ecx
  801a16:	50                   	push   %eax
  801a17:	68 14 34 80 00       	push   $0x803414
  801a1c:	e8 60 ee ff ff       	call   800881 <cprintf>
	*dev = 0;
  801a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801a2a:	83 c4 10             	add    $0x10,%esp
  801a2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    
			*dev = devtab[i];
  801a34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a37:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3e:	eb f2                	jmp    801a32 <dev_lookup+0x4d>

00801a40 <fd_close>:
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	57                   	push   %edi
  801a44:	56                   	push   %esi
  801a45:	53                   	push   %ebx
  801a46:	83 ec 24             	sub    $0x24,%esp
  801a49:	8b 75 08             	mov    0x8(%ebp),%esi
  801a4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a4f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a52:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a53:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801a59:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a5c:	50                   	push   %eax
  801a5d:	e8 33 ff ff ff       	call   801995 <fd_lookup>
  801a62:	89 c3                	mov    %eax,%ebx
  801a64:	83 c4 10             	add    $0x10,%esp
  801a67:	85 c0                	test   %eax,%eax
  801a69:	78 05                	js     801a70 <fd_close+0x30>
	    || fd != fd2)
  801a6b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801a6e:	74 16                	je     801a86 <fd_close+0x46>
		return (must_exist ? r : 0);
  801a70:	89 f8                	mov    %edi,%eax
  801a72:	84 c0                	test   %al,%al
  801a74:	b8 00 00 00 00       	mov    $0x0,%eax
  801a79:	0f 44 d8             	cmove  %eax,%ebx
}
  801a7c:	89 d8                	mov    %ebx,%eax
  801a7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a81:	5b                   	pop    %ebx
  801a82:	5e                   	pop    %esi
  801a83:	5f                   	pop    %edi
  801a84:	5d                   	pop    %ebp
  801a85:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a86:	83 ec 08             	sub    $0x8,%esp
  801a89:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a8c:	50                   	push   %eax
  801a8d:	ff 36                	pushl  (%esi)
  801a8f:	e8 51 ff ff ff       	call   8019e5 <dev_lookup>
  801a94:	89 c3                	mov    %eax,%ebx
  801a96:	83 c4 10             	add    $0x10,%esp
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	78 1a                	js     801ab7 <fd_close+0x77>
		if (dev->dev_close)
  801a9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa0:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801aa3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	74 0b                	je     801ab7 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801aac:	83 ec 0c             	sub    $0xc,%esp
  801aaf:	56                   	push   %esi
  801ab0:	ff d0                	call   *%eax
  801ab2:	89 c3                	mov    %eax,%ebx
  801ab4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801ab7:	83 ec 08             	sub    $0x8,%esp
  801aba:	56                   	push   %esi
  801abb:	6a 00                	push   $0x0
  801abd:	e8 12 f8 ff ff       	call   8012d4 <sys_page_unmap>
	return r;
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	eb b5                	jmp    801a7c <fd_close+0x3c>

00801ac7 <close>:

int
close(int fdnum)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801acd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad0:	50                   	push   %eax
  801ad1:	ff 75 08             	pushl  0x8(%ebp)
  801ad4:	e8 bc fe ff ff       	call   801995 <fd_lookup>
  801ad9:	83 c4 10             	add    $0x10,%esp
  801adc:	85 c0                	test   %eax,%eax
  801ade:	79 02                	jns    801ae2 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    
		return fd_close(fd, 1);
  801ae2:	83 ec 08             	sub    $0x8,%esp
  801ae5:	6a 01                	push   $0x1
  801ae7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aea:	e8 51 ff ff ff       	call   801a40 <fd_close>
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	eb ec                	jmp    801ae0 <close+0x19>

00801af4 <close_all>:

void
close_all(void)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	53                   	push   %ebx
  801af8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801afb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801b00:	83 ec 0c             	sub    $0xc,%esp
  801b03:	53                   	push   %ebx
  801b04:	e8 be ff ff ff       	call   801ac7 <close>
	for (i = 0; i < MAXFD; i++)
  801b09:	83 c3 01             	add    $0x1,%ebx
  801b0c:	83 c4 10             	add    $0x10,%esp
  801b0f:	83 fb 20             	cmp    $0x20,%ebx
  801b12:	75 ec                	jne    801b00 <close_all+0xc>
}
  801b14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	57                   	push   %edi
  801b1d:	56                   	push   %esi
  801b1e:	53                   	push   %ebx
  801b1f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b22:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b25:	50                   	push   %eax
  801b26:	ff 75 08             	pushl  0x8(%ebp)
  801b29:	e8 67 fe ff ff       	call   801995 <fd_lookup>
  801b2e:	89 c3                	mov    %eax,%ebx
  801b30:	83 c4 10             	add    $0x10,%esp
  801b33:	85 c0                	test   %eax,%eax
  801b35:	0f 88 81 00 00 00    	js     801bbc <dup+0xa3>
		return r;
	close(newfdnum);
  801b3b:	83 ec 0c             	sub    $0xc,%esp
  801b3e:	ff 75 0c             	pushl  0xc(%ebp)
  801b41:	e8 81 ff ff ff       	call   801ac7 <close>

	newfd = INDEX2FD(newfdnum);
  801b46:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b49:	c1 e6 0c             	shl    $0xc,%esi
  801b4c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801b52:	83 c4 04             	add    $0x4,%esp
  801b55:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b58:	e8 cf fd ff ff       	call   80192c <fd2data>
  801b5d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b5f:	89 34 24             	mov    %esi,(%esp)
  801b62:	e8 c5 fd ff ff       	call   80192c <fd2data>
  801b67:	83 c4 10             	add    $0x10,%esp
  801b6a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801b6c:	89 d8                	mov    %ebx,%eax
  801b6e:	c1 e8 16             	shr    $0x16,%eax
  801b71:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b78:	a8 01                	test   $0x1,%al
  801b7a:	74 11                	je     801b8d <dup+0x74>
  801b7c:	89 d8                	mov    %ebx,%eax
  801b7e:	c1 e8 0c             	shr    $0xc,%eax
  801b81:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b88:	f6 c2 01             	test   $0x1,%dl
  801b8b:	75 39                	jne    801bc6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b90:	89 d0                	mov    %edx,%eax
  801b92:	c1 e8 0c             	shr    $0xc,%eax
  801b95:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b9c:	83 ec 0c             	sub    $0xc,%esp
  801b9f:	25 07 0e 00 00       	and    $0xe07,%eax
  801ba4:	50                   	push   %eax
  801ba5:	56                   	push   %esi
  801ba6:	6a 00                	push   $0x0
  801ba8:	52                   	push   %edx
  801ba9:	6a 00                	push   $0x0
  801bab:	e8 e2 f6 ff ff       	call   801292 <sys_page_map>
  801bb0:	89 c3                	mov    %eax,%ebx
  801bb2:	83 c4 20             	add    $0x20,%esp
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	78 31                	js     801bea <dup+0xd1>
		goto err;

	return newfdnum;
  801bb9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801bbc:	89 d8                	mov    %ebx,%eax
  801bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc1:	5b                   	pop    %ebx
  801bc2:	5e                   	pop    %esi
  801bc3:	5f                   	pop    %edi
  801bc4:	5d                   	pop    %ebp
  801bc5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801bc6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bcd:	83 ec 0c             	sub    $0xc,%esp
  801bd0:	25 07 0e 00 00       	and    $0xe07,%eax
  801bd5:	50                   	push   %eax
  801bd6:	57                   	push   %edi
  801bd7:	6a 00                	push   $0x0
  801bd9:	53                   	push   %ebx
  801bda:	6a 00                	push   $0x0
  801bdc:	e8 b1 f6 ff ff       	call   801292 <sys_page_map>
  801be1:	89 c3                	mov    %eax,%ebx
  801be3:	83 c4 20             	add    $0x20,%esp
  801be6:	85 c0                	test   %eax,%eax
  801be8:	79 a3                	jns    801b8d <dup+0x74>
	sys_page_unmap(0, newfd);
  801bea:	83 ec 08             	sub    $0x8,%esp
  801bed:	56                   	push   %esi
  801bee:	6a 00                	push   $0x0
  801bf0:	e8 df f6 ff ff       	call   8012d4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801bf5:	83 c4 08             	add    $0x8,%esp
  801bf8:	57                   	push   %edi
  801bf9:	6a 00                	push   $0x0
  801bfb:	e8 d4 f6 ff ff       	call   8012d4 <sys_page_unmap>
	return r;
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	eb b7                	jmp    801bbc <dup+0xa3>

00801c05 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	53                   	push   %ebx
  801c09:	83 ec 1c             	sub    $0x1c,%esp
  801c0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c0f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c12:	50                   	push   %eax
  801c13:	53                   	push   %ebx
  801c14:	e8 7c fd ff ff       	call   801995 <fd_lookup>
  801c19:	83 c4 10             	add    $0x10,%esp
  801c1c:	85 c0                	test   %eax,%eax
  801c1e:	78 3f                	js     801c5f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c20:	83 ec 08             	sub    $0x8,%esp
  801c23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c26:	50                   	push   %eax
  801c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2a:	ff 30                	pushl  (%eax)
  801c2c:	e8 b4 fd ff ff       	call   8019e5 <dev_lookup>
  801c31:	83 c4 10             	add    $0x10,%esp
  801c34:	85 c0                	test   %eax,%eax
  801c36:	78 27                	js     801c5f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c3b:	8b 42 08             	mov    0x8(%edx),%eax
  801c3e:	83 e0 03             	and    $0x3,%eax
  801c41:	83 f8 01             	cmp    $0x1,%eax
  801c44:	74 1e                	je     801c64 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c49:	8b 40 08             	mov    0x8(%eax),%eax
  801c4c:	85 c0                	test   %eax,%eax
  801c4e:	74 35                	je     801c85 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c50:	83 ec 04             	sub    $0x4,%esp
  801c53:	ff 75 10             	pushl  0x10(%ebp)
  801c56:	ff 75 0c             	pushl  0xc(%ebp)
  801c59:	52                   	push   %edx
  801c5a:	ff d0                	call   *%eax
  801c5c:	83 c4 10             	add    $0x10,%esp
}
  801c5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c64:	a1 20 50 80 00       	mov    0x805020,%eax
  801c69:	8b 40 48             	mov    0x48(%eax),%eax
  801c6c:	83 ec 04             	sub    $0x4,%esp
  801c6f:	53                   	push   %ebx
  801c70:	50                   	push   %eax
  801c71:	68 58 34 80 00       	push   $0x803458
  801c76:	e8 06 ec ff ff       	call   800881 <cprintf>
		return -E_INVAL;
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c83:	eb da                	jmp    801c5f <read+0x5a>
		return -E_NOT_SUPP;
  801c85:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c8a:	eb d3                	jmp    801c5f <read+0x5a>

00801c8c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	57                   	push   %edi
  801c90:	56                   	push   %esi
  801c91:	53                   	push   %ebx
  801c92:	83 ec 0c             	sub    $0xc,%esp
  801c95:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c98:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ca0:	39 f3                	cmp    %esi,%ebx
  801ca2:	73 23                	jae    801cc7 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ca4:	83 ec 04             	sub    $0x4,%esp
  801ca7:	89 f0                	mov    %esi,%eax
  801ca9:	29 d8                	sub    %ebx,%eax
  801cab:	50                   	push   %eax
  801cac:	89 d8                	mov    %ebx,%eax
  801cae:	03 45 0c             	add    0xc(%ebp),%eax
  801cb1:	50                   	push   %eax
  801cb2:	57                   	push   %edi
  801cb3:	e8 4d ff ff ff       	call   801c05 <read>
		if (m < 0)
  801cb8:	83 c4 10             	add    $0x10,%esp
  801cbb:	85 c0                	test   %eax,%eax
  801cbd:	78 06                	js     801cc5 <readn+0x39>
			return m;
		if (m == 0)
  801cbf:	74 06                	je     801cc7 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801cc1:	01 c3                	add    %eax,%ebx
  801cc3:	eb db                	jmp    801ca0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801cc5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801cc7:	89 d8                	mov    %ebx,%eax
  801cc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ccc:	5b                   	pop    %ebx
  801ccd:	5e                   	pop    %esi
  801cce:	5f                   	pop    %edi
  801ccf:	5d                   	pop    %ebp
  801cd0:	c3                   	ret    

00801cd1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	53                   	push   %ebx
  801cd5:	83 ec 1c             	sub    $0x1c,%esp
  801cd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cdb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cde:	50                   	push   %eax
  801cdf:	53                   	push   %ebx
  801ce0:	e8 b0 fc ff ff       	call   801995 <fd_lookup>
  801ce5:	83 c4 10             	add    $0x10,%esp
  801ce8:	85 c0                	test   %eax,%eax
  801cea:	78 3a                	js     801d26 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cec:	83 ec 08             	sub    $0x8,%esp
  801cef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf2:	50                   	push   %eax
  801cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf6:	ff 30                	pushl  (%eax)
  801cf8:	e8 e8 fc ff ff       	call   8019e5 <dev_lookup>
  801cfd:	83 c4 10             	add    $0x10,%esp
  801d00:	85 c0                	test   %eax,%eax
  801d02:	78 22                	js     801d26 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d07:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d0b:	74 1e                	je     801d2b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801d0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d10:	8b 52 0c             	mov    0xc(%edx),%edx
  801d13:	85 d2                	test   %edx,%edx
  801d15:	74 35                	je     801d4c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801d17:	83 ec 04             	sub    $0x4,%esp
  801d1a:	ff 75 10             	pushl  0x10(%ebp)
  801d1d:	ff 75 0c             	pushl  0xc(%ebp)
  801d20:	50                   	push   %eax
  801d21:	ff d2                	call   *%edx
  801d23:	83 c4 10             	add    $0x10,%esp
}
  801d26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d2b:	a1 20 50 80 00       	mov    0x805020,%eax
  801d30:	8b 40 48             	mov    0x48(%eax),%eax
  801d33:	83 ec 04             	sub    $0x4,%esp
  801d36:	53                   	push   %ebx
  801d37:	50                   	push   %eax
  801d38:	68 74 34 80 00       	push   $0x803474
  801d3d:	e8 3f eb ff ff       	call   800881 <cprintf>
		return -E_INVAL;
  801d42:	83 c4 10             	add    $0x10,%esp
  801d45:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d4a:	eb da                	jmp    801d26 <write+0x55>
		return -E_NOT_SUPP;
  801d4c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d51:	eb d3                	jmp    801d26 <write+0x55>

00801d53 <seek>:

int
seek(int fdnum, off_t offset)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d5c:	50                   	push   %eax
  801d5d:	ff 75 08             	pushl  0x8(%ebp)
  801d60:	e8 30 fc ff ff       	call   801995 <fd_lookup>
  801d65:	83 c4 10             	add    $0x10,%esp
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	78 0e                	js     801d7a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801d6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d72:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	53                   	push   %ebx
  801d80:	83 ec 1c             	sub    $0x1c,%esp
  801d83:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d89:	50                   	push   %eax
  801d8a:	53                   	push   %ebx
  801d8b:	e8 05 fc ff ff       	call   801995 <fd_lookup>
  801d90:	83 c4 10             	add    $0x10,%esp
  801d93:	85 c0                	test   %eax,%eax
  801d95:	78 37                	js     801dce <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d97:	83 ec 08             	sub    $0x8,%esp
  801d9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d9d:	50                   	push   %eax
  801d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da1:	ff 30                	pushl  (%eax)
  801da3:	e8 3d fc ff ff       	call   8019e5 <dev_lookup>
  801da8:	83 c4 10             	add    $0x10,%esp
  801dab:	85 c0                	test   %eax,%eax
  801dad:	78 1f                	js     801dce <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801db6:	74 1b                	je     801dd3 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801db8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbb:	8b 52 18             	mov    0x18(%edx),%edx
  801dbe:	85 d2                	test   %edx,%edx
  801dc0:	74 32                	je     801df4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801dc2:	83 ec 08             	sub    $0x8,%esp
  801dc5:	ff 75 0c             	pushl  0xc(%ebp)
  801dc8:	50                   	push   %eax
  801dc9:	ff d2                	call   *%edx
  801dcb:	83 c4 10             	add    $0x10,%esp
}
  801dce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    
			thisenv->env_id, fdnum);
  801dd3:	a1 20 50 80 00       	mov    0x805020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801dd8:	8b 40 48             	mov    0x48(%eax),%eax
  801ddb:	83 ec 04             	sub    $0x4,%esp
  801dde:	53                   	push   %ebx
  801ddf:	50                   	push   %eax
  801de0:	68 34 34 80 00       	push   $0x803434
  801de5:	e8 97 ea ff ff       	call   800881 <cprintf>
		return -E_INVAL;
  801dea:	83 c4 10             	add    $0x10,%esp
  801ded:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801df2:	eb da                	jmp    801dce <ftruncate+0x52>
		return -E_NOT_SUPP;
  801df4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801df9:	eb d3                	jmp    801dce <ftruncate+0x52>

00801dfb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	53                   	push   %ebx
  801dff:	83 ec 1c             	sub    $0x1c,%esp
  801e02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e05:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e08:	50                   	push   %eax
  801e09:	ff 75 08             	pushl  0x8(%ebp)
  801e0c:	e8 84 fb ff ff       	call   801995 <fd_lookup>
  801e11:	83 c4 10             	add    $0x10,%esp
  801e14:	85 c0                	test   %eax,%eax
  801e16:	78 4b                	js     801e63 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e18:	83 ec 08             	sub    $0x8,%esp
  801e1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e1e:	50                   	push   %eax
  801e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e22:	ff 30                	pushl  (%eax)
  801e24:	e8 bc fb ff ff       	call   8019e5 <dev_lookup>
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	78 33                	js     801e63 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e33:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801e37:	74 2f                	je     801e68 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e39:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801e3c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801e43:	00 00 00 
	stat->st_isdir = 0;
  801e46:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e4d:	00 00 00 
	stat->st_dev = dev;
  801e50:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e56:	83 ec 08             	sub    $0x8,%esp
  801e59:	53                   	push   %ebx
  801e5a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5d:	ff 50 14             	call   *0x14(%eax)
  801e60:	83 c4 10             	add    $0x10,%esp
}
  801e63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    
		return -E_NOT_SUPP;
  801e68:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e6d:	eb f4                	jmp    801e63 <fstat+0x68>

00801e6f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	56                   	push   %esi
  801e73:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e74:	83 ec 08             	sub    $0x8,%esp
  801e77:	6a 00                	push   $0x0
  801e79:	ff 75 08             	pushl  0x8(%ebp)
  801e7c:	e8 2f 02 00 00       	call   8020b0 <open>
  801e81:	89 c3                	mov    %eax,%ebx
  801e83:	83 c4 10             	add    $0x10,%esp
  801e86:	85 c0                	test   %eax,%eax
  801e88:	78 1b                	js     801ea5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801e8a:	83 ec 08             	sub    $0x8,%esp
  801e8d:	ff 75 0c             	pushl  0xc(%ebp)
  801e90:	50                   	push   %eax
  801e91:	e8 65 ff ff ff       	call   801dfb <fstat>
  801e96:	89 c6                	mov    %eax,%esi
	close(fd);
  801e98:	89 1c 24             	mov    %ebx,(%esp)
  801e9b:	e8 27 fc ff ff       	call   801ac7 <close>
	return r;
  801ea0:	83 c4 10             	add    $0x10,%esp
  801ea3:	89 f3                	mov    %esi,%ebx
}
  801ea5:	89 d8                	mov    %ebx,%eax
  801ea7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eaa:	5b                   	pop    %ebx
  801eab:	5e                   	pop    %esi
  801eac:	5d                   	pop    %ebp
  801ead:	c3                   	ret    

00801eae <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	56                   	push   %esi
  801eb2:	53                   	push   %ebx
  801eb3:	89 c6                	mov    %eax,%esi
  801eb5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801eb7:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  801ebe:	74 27                	je     801ee7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ec0:	6a 07                	push   $0x7
  801ec2:	68 00 60 80 00       	push   $0x806000
  801ec7:	56                   	push   %esi
  801ec8:	ff 35 18 50 80 00    	pushl  0x805018
  801ece:	e8 a4 f9 ff ff       	call   801877 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ed3:	83 c4 0c             	add    $0xc,%esp
  801ed6:	6a 00                	push   $0x0
  801ed8:	53                   	push   %ebx
  801ed9:	6a 00                	push   $0x0
  801edb:	e8 24 f9 ff ff       	call   801804 <ipc_recv>
}
  801ee0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee3:	5b                   	pop    %ebx
  801ee4:	5e                   	pop    %esi
  801ee5:	5d                   	pop    %ebp
  801ee6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ee7:	83 ec 0c             	sub    $0xc,%esp
  801eea:	6a 01                	push   $0x1
  801eec:	e8 f2 f9 ff ff       	call   8018e3 <ipc_find_env>
  801ef1:	a3 18 50 80 00       	mov    %eax,0x805018
  801ef6:	83 c4 10             	add    $0x10,%esp
  801ef9:	eb c5                	jmp    801ec0 <fsipc+0x12>

00801efb <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	8b 40 0c             	mov    0xc(%eax),%eax
  801f07:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0f:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801f14:	ba 00 00 00 00       	mov    $0x0,%edx
  801f19:	b8 02 00 00 00       	mov    $0x2,%eax
  801f1e:	e8 8b ff ff ff       	call   801eae <fsipc>
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <devfile_flush>:
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f31:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801f36:	ba 00 00 00 00       	mov    $0x0,%edx
  801f3b:	b8 06 00 00 00       	mov    $0x6,%eax
  801f40:	e8 69 ff ff ff       	call   801eae <fsipc>
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <devfile_stat>:
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	53                   	push   %ebx
  801f4b:	83 ec 04             	sub    $0x4,%esp
  801f4e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	8b 40 0c             	mov    0xc(%eax),%eax
  801f57:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f61:	b8 05 00 00 00       	mov    $0x5,%eax
  801f66:	e8 43 ff ff ff       	call   801eae <fsipc>
  801f6b:	85 c0                	test   %eax,%eax
  801f6d:	78 2c                	js     801f9b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f6f:	83 ec 08             	sub    $0x8,%esp
  801f72:	68 00 60 80 00       	push   $0x806000
  801f77:	53                   	push   %ebx
  801f78:	e8 e0 ee ff ff       	call   800e5d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801f7d:	a1 80 60 80 00       	mov    0x806080,%eax
  801f82:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f88:	a1 84 60 80 00       	mov    0x806084,%eax
  801f8d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801f93:	83 c4 10             	add    $0x10,%esp
  801f96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <devfile_write>:
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	53                   	push   %ebx
  801fa4:	83 ec 04             	sub    $0x4,%esp
  801fa7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801faa:	85 db                	test   %ebx,%ebx
  801fac:	75 07                	jne    801fb5 <devfile_write+0x15>
	return n_all;
  801fae:	89 d8                	mov    %ebx,%eax
}
  801fb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	8b 40 0c             	mov    0xc(%eax),%eax
  801fbb:	a3 00 60 80 00       	mov    %eax,0x806000
	  fsipcbuf.write.req_n = n_left;
  801fc0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801fc6:	83 ec 04             	sub    $0x4,%esp
  801fc9:	53                   	push   %ebx
  801fca:	ff 75 0c             	pushl  0xc(%ebp)
  801fcd:	68 08 60 80 00       	push   $0x806008
  801fd2:	e8 14 f0 ff ff       	call   800feb <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801fd7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fdc:	b8 04 00 00 00       	mov    $0x4,%eax
  801fe1:	e8 c8 fe ff ff       	call   801eae <fsipc>
  801fe6:	83 c4 10             	add    $0x10,%esp
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	78 c3                	js     801fb0 <devfile_write+0x10>
	  assert(r <= n_left);
  801fed:	39 d8                	cmp    %ebx,%eax
  801fef:	77 0b                	ja     801ffc <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801ff1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ff6:	7f 1d                	jg     802015 <devfile_write+0x75>
    n_all += r;
  801ff8:	89 c3                	mov    %eax,%ebx
  801ffa:	eb b2                	jmp    801fae <devfile_write+0xe>
	  assert(r <= n_left);
  801ffc:	68 a8 34 80 00       	push   $0x8034a8
  802001:	68 b4 34 80 00       	push   $0x8034b4
  802006:	68 9f 00 00 00       	push   $0x9f
  80200b:	68 c9 34 80 00       	push   $0x8034c9
  802010:	e8 91 e7 ff ff       	call   8007a6 <_panic>
	  assert(r <= PGSIZE);
  802015:	68 d4 34 80 00       	push   $0x8034d4
  80201a:	68 b4 34 80 00       	push   $0x8034b4
  80201f:	68 a0 00 00 00       	push   $0xa0
  802024:	68 c9 34 80 00       	push   $0x8034c9
  802029:	e8 78 e7 ff ff       	call   8007a6 <_panic>

0080202e <devfile_read>:
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	56                   	push   %esi
  802032:	53                   	push   %ebx
  802033:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8b 40 0c             	mov    0xc(%eax),%eax
  80203c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802041:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802047:	ba 00 00 00 00       	mov    $0x0,%edx
  80204c:	b8 03 00 00 00       	mov    $0x3,%eax
  802051:	e8 58 fe ff ff       	call   801eae <fsipc>
  802056:	89 c3                	mov    %eax,%ebx
  802058:	85 c0                	test   %eax,%eax
  80205a:	78 1f                	js     80207b <devfile_read+0x4d>
	assert(r <= n);
  80205c:	39 f0                	cmp    %esi,%eax
  80205e:	77 24                	ja     802084 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802060:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802065:	7f 33                	jg     80209a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802067:	83 ec 04             	sub    $0x4,%esp
  80206a:	50                   	push   %eax
  80206b:	68 00 60 80 00       	push   $0x806000
  802070:	ff 75 0c             	pushl  0xc(%ebp)
  802073:	e8 73 ef ff ff       	call   800feb <memmove>
	return r;
  802078:	83 c4 10             	add    $0x10,%esp
}
  80207b:	89 d8                	mov    %ebx,%eax
  80207d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802080:	5b                   	pop    %ebx
  802081:	5e                   	pop    %esi
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    
	assert(r <= n);
  802084:	68 e0 34 80 00       	push   $0x8034e0
  802089:	68 b4 34 80 00       	push   $0x8034b4
  80208e:	6a 7c                	push   $0x7c
  802090:	68 c9 34 80 00       	push   $0x8034c9
  802095:	e8 0c e7 ff ff       	call   8007a6 <_panic>
	assert(r <= PGSIZE);
  80209a:	68 d4 34 80 00       	push   $0x8034d4
  80209f:	68 b4 34 80 00       	push   $0x8034b4
  8020a4:	6a 7d                	push   $0x7d
  8020a6:	68 c9 34 80 00       	push   $0x8034c9
  8020ab:	e8 f6 e6 ff ff       	call   8007a6 <_panic>

008020b0 <open>:
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	56                   	push   %esi
  8020b4:	53                   	push   %ebx
  8020b5:	83 ec 1c             	sub    $0x1c,%esp
  8020b8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8020bb:	56                   	push   %esi
  8020bc:	e8 63 ed ff ff       	call   800e24 <strlen>
  8020c1:	83 c4 10             	add    $0x10,%esp
  8020c4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8020c9:	7f 6c                	jg     802137 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8020cb:	83 ec 0c             	sub    $0xc,%esp
  8020ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d1:	50                   	push   %eax
  8020d2:	e8 6c f8 ff ff       	call   801943 <fd_alloc>
  8020d7:	89 c3                	mov    %eax,%ebx
  8020d9:	83 c4 10             	add    $0x10,%esp
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	78 3c                	js     80211c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8020e0:	83 ec 08             	sub    $0x8,%esp
  8020e3:	56                   	push   %esi
  8020e4:	68 00 60 80 00       	push   $0x806000
  8020e9:	e8 6f ed ff ff       	call   800e5d <strcpy>
	fsipcbuf.open.req_omode = mode;
  8020ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f1:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8020f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020fe:	e8 ab fd ff ff       	call   801eae <fsipc>
  802103:	89 c3                	mov    %eax,%ebx
  802105:	83 c4 10             	add    $0x10,%esp
  802108:	85 c0                	test   %eax,%eax
  80210a:	78 19                	js     802125 <open+0x75>
	return fd2num(fd);
  80210c:	83 ec 0c             	sub    $0xc,%esp
  80210f:	ff 75 f4             	pushl  -0xc(%ebp)
  802112:	e8 05 f8 ff ff       	call   80191c <fd2num>
  802117:	89 c3                	mov    %eax,%ebx
  802119:	83 c4 10             	add    $0x10,%esp
}
  80211c:	89 d8                	mov    %ebx,%eax
  80211e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802121:	5b                   	pop    %ebx
  802122:	5e                   	pop    %esi
  802123:	5d                   	pop    %ebp
  802124:	c3                   	ret    
		fd_close(fd, 0);
  802125:	83 ec 08             	sub    $0x8,%esp
  802128:	6a 00                	push   $0x0
  80212a:	ff 75 f4             	pushl  -0xc(%ebp)
  80212d:	e8 0e f9 ff ff       	call   801a40 <fd_close>
		return r;
  802132:	83 c4 10             	add    $0x10,%esp
  802135:	eb e5                	jmp    80211c <open+0x6c>
		return -E_BAD_PATH;
  802137:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80213c:	eb de                	jmp    80211c <open+0x6c>

0080213e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802144:	ba 00 00 00 00       	mov    $0x0,%edx
  802149:	b8 08 00 00 00       	mov    $0x8,%eax
  80214e:	e8 5b fd ff ff       	call   801eae <fsipc>
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	56                   	push   %esi
  802159:	53                   	push   %ebx
  80215a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80215d:	83 ec 0c             	sub    $0xc,%esp
  802160:	ff 75 08             	pushl  0x8(%ebp)
  802163:	e8 c4 f7 ff ff       	call   80192c <fd2data>
  802168:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80216a:	83 c4 08             	add    $0x8,%esp
  80216d:	68 e7 34 80 00       	push   $0x8034e7
  802172:	53                   	push   %ebx
  802173:	e8 e5 ec ff ff       	call   800e5d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802178:	8b 46 04             	mov    0x4(%esi),%eax
  80217b:	2b 06                	sub    (%esi),%eax
  80217d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802183:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80218a:	00 00 00 
	stat->st_dev = &devpipe;
  80218d:	c7 83 88 00 00 00 20 	movl   $0x804020,0x88(%ebx)
  802194:	40 80 00 
	return 0;
}
  802197:	b8 00 00 00 00       	mov    $0x0,%eax
  80219c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80219f:	5b                   	pop    %ebx
  8021a0:	5e                   	pop    %esi
  8021a1:	5d                   	pop    %ebp
  8021a2:	c3                   	ret    

008021a3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	53                   	push   %ebx
  8021a7:	83 ec 0c             	sub    $0xc,%esp
  8021aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021ad:	53                   	push   %ebx
  8021ae:	6a 00                	push   $0x0
  8021b0:	e8 1f f1 ff ff       	call   8012d4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021b5:	89 1c 24             	mov    %ebx,(%esp)
  8021b8:	e8 6f f7 ff ff       	call   80192c <fd2data>
  8021bd:	83 c4 08             	add    $0x8,%esp
  8021c0:	50                   	push   %eax
  8021c1:	6a 00                	push   $0x0
  8021c3:	e8 0c f1 ff ff       	call   8012d4 <sys_page_unmap>
}
  8021c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <_pipeisclosed>:
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	57                   	push   %edi
  8021d1:	56                   	push   %esi
  8021d2:	53                   	push   %ebx
  8021d3:	83 ec 1c             	sub    $0x1c,%esp
  8021d6:	89 c7                	mov    %eax,%edi
  8021d8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021da:	a1 20 50 80 00       	mov    0x805020,%eax
  8021df:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021e2:	83 ec 0c             	sub    $0xc,%esp
  8021e5:	57                   	push   %edi
  8021e6:	e8 31 09 00 00       	call   802b1c <pageref>
  8021eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021ee:	89 34 24             	mov    %esi,(%esp)
  8021f1:	e8 26 09 00 00       	call   802b1c <pageref>
		nn = thisenv->env_runs;
  8021f6:	8b 15 20 50 80 00    	mov    0x805020,%edx
  8021fc:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021ff:	83 c4 10             	add    $0x10,%esp
  802202:	39 cb                	cmp    %ecx,%ebx
  802204:	74 1b                	je     802221 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802206:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802209:	75 cf                	jne    8021da <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80220b:	8b 42 58             	mov    0x58(%edx),%eax
  80220e:	6a 01                	push   $0x1
  802210:	50                   	push   %eax
  802211:	53                   	push   %ebx
  802212:	68 ee 34 80 00       	push   $0x8034ee
  802217:	e8 65 e6 ff ff       	call   800881 <cprintf>
  80221c:	83 c4 10             	add    $0x10,%esp
  80221f:	eb b9                	jmp    8021da <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802221:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802224:	0f 94 c0             	sete   %al
  802227:	0f b6 c0             	movzbl %al,%eax
}
  80222a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80222d:	5b                   	pop    %ebx
  80222e:	5e                   	pop    %esi
  80222f:	5f                   	pop    %edi
  802230:	5d                   	pop    %ebp
  802231:	c3                   	ret    

00802232 <devpipe_write>:
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	57                   	push   %edi
  802236:	56                   	push   %esi
  802237:	53                   	push   %ebx
  802238:	83 ec 28             	sub    $0x28,%esp
  80223b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80223e:	56                   	push   %esi
  80223f:	e8 e8 f6 ff ff       	call   80192c <fd2data>
  802244:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802246:	83 c4 10             	add    $0x10,%esp
  802249:	bf 00 00 00 00       	mov    $0x0,%edi
  80224e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802251:	74 4f                	je     8022a2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802253:	8b 43 04             	mov    0x4(%ebx),%eax
  802256:	8b 0b                	mov    (%ebx),%ecx
  802258:	8d 51 20             	lea    0x20(%ecx),%edx
  80225b:	39 d0                	cmp    %edx,%eax
  80225d:	72 14                	jb     802273 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80225f:	89 da                	mov    %ebx,%edx
  802261:	89 f0                	mov    %esi,%eax
  802263:	e8 65 ff ff ff       	call   8021cd <_pipeisclosed>
  802268:	85 c0                	test   %eax,%eax
  80226a:	75 3b                	jne    8022a7 <devpipe_write+0x75>
			sys_yield();
  80226c:	e8 bf ef ff ff       	call   801230 <sys_yield>
  802271:	eb e0                	jmp    802253 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802273:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802276:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80227a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80227d:	89 c2                	mov    %eax,%edx
  80227f:	c1 fa 1f             	sar    $0x1f,%edx
  802282:	89 d1                	mov    %edx,%ecx
  802284:	c1 e9 1b             	shr    $0x1b,%ecx
  802287:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80228a:	83 e2 1f             	and    $0x1f,%edx
  80228d:	29 ca                	sub    %ecx,%edx
  80228f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802293:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802297:	83 c0 01             	add    $0x1,%eax
  80229a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80229d:	83 c7 01             	add    $0x1,%edi
  8022a0:	eb ac                	jmp    80224e <devpipe_write+0x1c>
	return i;
  8022a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a5:	eb 05                	jmp    8022ac <devpipe_write+0x7a>
				return 0;
  8022a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022af:	5b                   	pop    %ebx
  8022b0:	5e                   	pop    %esi
  8022b1:	5f                   	pop    %edi
  8022b2:	5d                   	pop    %ebp
  8022b3:	c3                   	ret    

008022b4 <devpipe_read>:
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
  8022b7:	57                   	push   %edi
  8022b8:	56                   	push   %esi
  8022b9:	53                   	push   %ebx
  8022ba:	83 ec 18             	sub    $0x18,%esp
  8022bd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022c0:	57                   	push   %edi
  8022c1:	e8 66 f6 ff ff       	call   80192c <fd2data>
  8022c6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022c8:	83 c4 10             	add    $0x10,%esp
  8022cb:	be 00 00 00 00       	mov    $0x0,%esi
  8022d0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022d3:	75 14                	jne    8022e9 <devpipe_read+0x35>
	return i;
  8022d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d8:	eb 02                	jmp    8022dc <devpipe_read+0x28>
				return i;
  8022da:	89 f0                	mov    %esi,%eax
}
  8022dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022df:	5b                   	pop    %ebx
  8022e0:	5e                   	pop    %esi
  8022e1:	5f                   	pop    %edi
  8022e2:	5d                   	pop    %ebp
  8022e3:	c3                   	ret    
			sys_yield();
  8022e4:	e8 47 ef ff ff       	call   801230 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8022e9:	8b 03                	mov    (%ebx),%eax
  8022eb:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022ee:	75 18                	jne    802308 <devpipe_read+0x54>
			if (i > 0)
  8022f0:	85 f6                	test   %esi,%esi
  8022f2:	75 e6                	jne    8022da <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8022f4:	89 da                	mov    %ebx,%edx
  8022f6:	89 f8                	mov    %edi,%eax
  8022f8:	e8 d0 fe ff ff       	call   8021cd <_pipeisclosed>
  8022fd:	85 c0                	test   %eax,%eax
  8022ff:	74 e3                	je     8022e4 <devpipe_read+0x30>
				return 0;
  802301:	b8 00 00 00 00       	mov    $0x0,%eax
  802306:	eb d4                	jmp    8022dc <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802308:	99                   	cltd   
  802309:	c1 ea 1b             	shr    $0x1b,%edx
  80230c:	01 d0                	add    %edx,%eax
  80230e:	83 e0 1f             	and    $0x1f,%eax
  802311:	29 d0                	sub    %edx,%eax
  802313:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802318:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80231b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80231e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802321:	83 c6 01             	add    $0x1,%esi
  802324:	eb aa                	jmp    8022d0 <devpipe_read+0x1c>

00802326 <pipe>:
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	56                   	push   %esi
  80232a:	53                   	push   %ebx
  80232b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80232e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802331:	50                   	push   %eax
  802332:	e8 0c f6 ff ff       	call   801943 <fd_alloc>
  802337:	89 c3                	mov    %eax,%ebx
  802339:	83 c4 10             	add    $0x10,%esp
  80233c:	85 c0                	test   %eax,%eax
  80233e:	0f 88 23 01 00 00    	js     802467 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802344:	83 ec 04             	sub    $0x4,%esp
  802347:	68 07 04 00 00       	push   $0x407
  80234c:	ff 75 f4             	pushl  -0xc(%ebp)
  80234f:	6a 00                	push   $0x0
  802351:	e8 f9 ee ff ff       	call   80124f <sys_page_alloc>
  802356:	89 c3                	mov    %eax,%ebx
  802358:	83 c4 10             	add    $0x10,%esp
  80235b:	85 c0                	test   %eax,%eax
  80235d:	0f 88 04 01 00 00    	js     802467 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802363:	83 ec 0c             	sub    $0xc,%esp
  802366:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802369:	50                   	push   %eax
  80236a:	e8 d4 f5 ff ff       	call   801943 <fd_alloc>
  80236f:	89 c3                	mov    %eax,%ebx
  802371:	83 c4 10             	add    $0x10,%esp
  802374:	85 c0                	test   %eax,%eax
  802376:	0f 88 db 00 00 00    	js     802457 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80237c:	83 ec 04             	sub    $0x4,%esp
  80237f:	68 07 04 00 00       	push   $0x407
  802384:	ff 75 f0             	pushl  -0x10(%ebp)
  802387:	6a 00                	push   $0x0
  802389:	e8 c1 ee ff ff       	call   80124f <sys_page_alloc>
  80238e:	89 c3                	mov    %eax,%ebx
  802390:	83 c4 10             	add    $0x10,%esp
  802393:	85 c0                	test   %eax,%eax
  802395:	0f 88 bc 00 00 00    	js     802457 <pipe+0x131>
	va = fd2data(fd0);
  80239b:	83 ec 0c             	sub    $0xc,%esp
  80239e:	ff 75 f4             	pushl  -0xc(%ebp)
  8023a1:	e8 86 f5 ff ff       	call   80192c <fd2data>
  8023a6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023a8:	83 c4 0c             	add    $0xc,%esp
  8023ab:	68 07 04 00 00       	push   $0x407
  8023b0:	50                   	push   %eax
  8023b1:	6a 00                	push   $0x0
  8023b3:	e8 97 ee ff ff       	call   80124f <sys_page_alloc>
  8023b8:	89 c3                	mov    %eax,%ebx
  8023ba:	83 c4 10             	add    $0x10,%esp
  8023bd:	85 c0                	test   %eax,%eax
  8023bf:	0f 88 82 00 00 00    	js     802447 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023c5:	83 ec 0c             	sub    $0xc,%esp
  8023c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8023cb:	e8 5c f5 ff ff       	call   80192c <fd2data>
  8023d0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023d7:	50                   	push   %eax
  8023d8:	6a 00                	push   $0x0
  8023da:	56                   	push   %esi
  8023db:	6a 00                	push   $0x0
  8023dd:	e8 b0 ee ff ff       	call   801292 <sys_page_map>
  8023e2:	89 c3                	mov    %eax,%ebx
  8023e4:	83 c4 20             	add    $0x20,%esp
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	78 4e                	js     802439 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8023eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8023f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8023f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8023ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802402:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802407:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80240e:	83 ec 0c             	sub    $0xc,%esp
  802411:	ff 75 f4             	pushl  -0xc(%ebp)
  802414:	e8 03 f5 ff ff       	call   80191c <fd2num>
  802419:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80241c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80241e:	83 c4 04             	add    $0x4,%esp
  802421:	ff 75 f0             	pushl  -0x10(%ebp)
  802424:	e8 f3 f4 ff ff       	call   80191c <fd2num>
  802429:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80242c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80242f:	83 c4 10             	add    $0x10,%esp
  802432:	bb 00 00 00 00       	mov    $0x0,%ebx
  802437:	eb 2e                	jmp    802467 <pipe+0x141>
	sys_page_unmap(0, va);
  802439:	83 ec 08             	sub    $0x8,%esp
  80243c:	56                   	push   %esi
  80243d:	6a 00                	push   $0x0
  80243f:	e8 90 ee ff ff       	call   8012d4 <sys_page_unmap>
  802444:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802447:	83 ec 08             	sub    $0x8,%esp
  80244a:	ff 75 f0             	pushl  -0x10(%ebp)
  80244d:	6a 00                	push   $0x0
  80244f:	e8 80 ee ff ff       	call   8012d4 <sys_page_unmap>
  802454:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802457:	83 ec 08             	sub    $0x8,%esp
  80245a:	ff 75 f4             	pushl  -0xc(%ebp)
  80245d:	6a 00                	push   $0x0
  80245f:	e8 70 ee ff ff       	call   8012d4 <sys_page_unmap>
  802464:	83 c4 10             	add    $0x10,%esp
}
  802467:	89 d8                	mov    %ebx,%eax
  802469:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    

00802470 <pipeisclosed>:
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
  802473:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802476:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802479:	50                   	push   %eax
  80247a:	ff 75 08             	pushl  0x8(%ebp)
  80247d:	e8 13 f5 ff ff       	call   801995 <fd_lookup>
  802482:	83 c4 10             	add    $0x10,%esp
  802485:	85 c0                	test   %eax,%eax
  802487:	78 18                	js     8024a1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802489:	83 ec 0c             	sub    $0xc,%esp
  80248c:	ff 75 f4             	pushl  -0xc(%ebp)
  80248f:	e8 98 f4 ff ff       	call   80192c <fd2data>
	return _pipeisclosed(fd, p);
  802494:	89 c2                	mov    %eax,%edx
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	e8 2f fd ff ff       	call   8021cd <_pipeisclosed>
  80249e:	83 c4 10             	add    $0x10,%esp
}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    

008024a3 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
  8024a6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8024a9:	68 06 35 80 00       	push   $0x803506
  8024ae:	ff 75 0c             	pushl  0xc(%ebp)
  8024b1:	e8 a7 e9 ff ff       	call   800e5d <strcpy>
	return 0;
}
  8024b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bb:	c9                   	leave  
  8024bc:	c3                   	ret    

008024bd <devsock_close>:
{
  8024bd:	55                   	push   %ebp
  8024be:	89 e5                	mov    %esp,%ebp
  8024c0:	53                   	push   %ebx
  8024c1:	83 ec 10             	sub    $0x10,%esp
  8024c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8024c7:	53                   	push   %ebx
  8024c8:	e8 4f 06 00 00       	call   802b1c <pageref>
  8024cd:	83 c4 10             	add    $0x10,%esp
		return 0;
  8024d0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8024d5:	83 f8 01             	cmp    $0x1,%eax
  8024d8:	74 07                	je     8024e1 <devsock_close+0x24>
}
  8024da:	89 d0                	mov    %edx,%eax
  8024dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024df:	c9                   	leave  
  8024e0:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8024e1:	83 ec 0c             	sub    $0xc,%esp
  8024e4:	ff 73 0c             	pushl  0xc(%ebx)
  8024e7:	e8 b9 02 00 00       	call   8027a5 <nsipc_close>
  8024ec:	89 c2                	mov    %eax,%edx
  8024ee:	83 c4 10             	add    $0x10,%esp
  8024f1:	eb e7                	jmp    8024da <devsock_close+0x1d>

008024f3 <devsock_write>:
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8024f9:	6a 00                	push   $0x0
  8024fb:	ff 75 10             	pushl  0x10(%ebp)
  8024fe:	ff 75 0c             	pushl  0xc(%ebp)
  802501:	8b 45 08             	mov    0x8(%ebp),%eax
  802504:	ff 70 0c             	pushl  0xc(%eax)
  802507:	e8 76 03 00 00       	call   802882 <nsipc_send>
}
  80250c:	c9                   	leave  
  80250d:	c3                   	ret    

0080250e <devsock_read>:
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
  802511:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802514:	6a 00                	push   $0x0
  802516:	ff 75 10             	pushl  0x10(%ebp)
  802519:	ff 75 0c             	pushl  0xc(%ebp)
  80251c:	8b 45 08             	mov    0x8(%ebp),%eax
  80251f:	ff 70 0c             	pushl  0xc(%eax)
  802522:	e8 ef 02 00 00       	call   802816 <nsipc_recv>
}
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <fd2sockid>:
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80252f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802532:	52                   	push   %edx
  802533:	50                   	push   %eax
  802534:	e8 5c f4 ff ff       	call   801995 <fd_lookup>
  802539:	83 c4 10             	add    $0x10,%esp
  80253c:	85 c0                	test   %eax,%eax
  80253e:	78 10                	js     802550 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  802549:	39 08                	cmp    %ecx,(%eax)
  80254b:	75 05                	jne    802552 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80254d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802550:	c9                   	leave  
  802551:	c3                   	ret    
		return -E_NOT_SUPP;
  802552:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802557:	eb f7                	jmp    802550 <fd2sockid+0x27>

00802559 <alloc_sockfd>:
{
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
  80255c:	56                   	push   %esi
  80255d:	53                   	push   %ebx
  80255e:	83 ec 1c             	sub    $0x1c,%esp
  802561:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802563:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802566:	50                   	push   %eax
  802567:	e8 d7 f3 ff ff       	call   801943 <fd_alloc>
  80256c:	89 c3                	mov    %eax,%ebx
  80256e:	83 c4 10             	add    $0x10,%esp
  802571:	85 c0                	test   %eax,%eax
  802573:	78 43                	js     8025b8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802575:	83 ec 04             	sub    $0x4,%esp
  802578:	68 07 04 00 00       	push   $0x407
  80257d:	ff 75 f4             	pushl  -0xc(%ebp)
  802580:	6a 00                	push   $0x0
  802582:	e8 c8 ec ff ff       	call   80124f <sys_page_alloc>
  802587:	89 c3                	mov    %eax,%ebx
  802589:	83 c4 10             	add    $0x10,%esp
  80258c:	85 c0                	test   %eax,%eax
  80258e:	78 28                	js     8025b8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802599:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8025a5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8025a8:	83 ec 0c             	sub    $0xc,%esp
  8025ab:	50                   	push   %eax
  8025ac:	e8 6b f3 ff ff       	call   80191c <fd2num>
  8025b1:	89 c3                	mov    %eax,%ebx
  8025b3:	83 c4 10             	add    $0x10,%esp
  8025b6:	eb 0c                	jmp    8025c4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8025b8:	83 ec 0c             	sub    $0xc,%esp
  8025bb:	56                   	push   %esi
  8025bc:	e8 e4 01 00 00       	call   8027a5 <nsipc_close>
		return r;
  8025c1:	83 c4 10             	add    $0x10,%esp
}
  8025c4:	89 d8                	mov    %ebx,%eax
  8025c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025c9:	5b                   	pop    %ebx
  8025ca:	5e                   	pop    %esi
  8025cb:	5d                   	pop    %ebp
  8025cc:	c3                   	ret    

008025cd <accept>:
{
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
  8025d0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d6:	e8 4e ff ff ff       	call   802529 <fd2sockid>
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	78 1b                	js     8025fa <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8025df:	83 ec 04             	sub    $0x4,%esp
  8025e2:	ff 75 10             	pushl  0x10(%ebp)
  8025e5:	ff 75 0c             	pushl  0xc(%ebp)
  8025e8:	50                   	push   %eax
  8025e9:	e8 0e 01 00 00       	call   8026fc <nsipc_accept>
  8025ee:	83 c4 10             	add    $0x10,%esp
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	78 05                	js     8025fa <accept+0x2d>
	return alloc_sockfd(r);
  8025f5:	e8 5f ff ff ff       	call   802559 <alloc_sockfd>
}
  8025fa:	c9                   	leave  
  8025fb:	c3                   	ret    

008025fc <bind>:
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802602:	8b 45 08             	mov    0x8(%ebp),%eax
  802605:	e8 1f ff ff ff       	call   802529 <fd2sockid>
  80260a:	85 c0                	test   %eax,%eax
  80260c:	78 12                	js     802620 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80260e:	83 ec 04             	sub    $0x4,%esp
  802611:	ff 75 10             	pushl  0x10(%ebp)
  802614:	ff 75 0c             	pushl  0xc(%ebp)
  802617:	50                   	push   %eax
  802618:	e8 31 01 00 00       	call   80274e <nsipc_bind>
  80261d:	83 c4 10             	add    $0x10,%esp
}
  802620:	c9                   	leave  
  802621:	c3                   	ret    

00802622 <shutdown>:
{
  802622:	55                   	push   %ebp
  802623:	89 e5                	mov    %esp,%ebp
  802625:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802628:	8b 45 08             	mov    0x8(%ebp),%eax
  80262b:	e8 f9 fe ff ff       	call   802529 <fd2sockid>
  802630:	85 c0                	test   %eax,%eax
  802632:	78 0f                	js     802643 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802634:	83 ec 08             	sub    $0x8,%esp
  802637:	ff 75 0c             	pushl  0xc(%ebp)
  80263a:	50                   	push   %eax
  80263b:	e8 43 01 00 00       	call   802783 <nsipc_shutdown>
  802640:	83 c4 10             	add    $0x10,%esp
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <connect>:
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	e8 d6 fe ff ff       	call   802529 <fd2sockid>
  802653:	85 c0                	test   %eax,%eax
  802655:	78 12                	js     802669 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802657:	83 ec 04             	sub    $0x4,%esp
  80265a:	ff 75 10             	pushl  0x10(%ebp)
  80265d:	ff 75 0c             	pushl  0xc(%ebp)
  802660:	50                   	push   %eax
  802661:	e8 59 01 00 00       	call   8027bf <nsipc_connect>
  802666:	83 c4 10             	add    $0x10,%esp
}
  802669:	c9                   	leave  
  80266a:	c3                   	ret    

0080266b <listen>:
{
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
  80266e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	e8 b0 fe ff ff       	call   802529 <fd2sockid>
  802679:	85 c0                	test   %eax,%eax
  80267b:	78 0f                	js     80268c <listen+0x21>
	return nsipc_listen(r, backlog);
  80267d:	83 ec 08             	sub    $0x8,%esp
  802680:	ff 75 0c             	pushl  0xc(%ebp)
  802683:	50                   	push   %eax
  802684:	e8 6b 01 00 00       	call   8027f4 <nsipc_listen>
  802689:	83 c4 10             	add    $0x10,%esp
}
  80268c:	c9                   	leave  
  80268d:	c3                   	ret    

0080268e <socket>:

int
socket(int domain, int type, int protocol)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802694:	ff 75 10             	pushl  0x10(%ebp)
  802697:	ff 75 0c             	pushl  0xc(%ebp)
  80269a:	ff 75 08             	pushl  0x8(%ebp)
  80269d:	e8 3e 02 00 00       	call   8028e0 <nsipc_socket>
  8026a2:	83 c4 10             	add    $0x10,%esp
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	78 05                	js     8026ae <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8026a9:	e8 ab fe ff ff       	call   802559 <alloc_sockfd>
}
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
  8026b3:	53                   	push   %ebx
  8026b4:	83 ec 04             	sub    $0x4,%esp
  8026b7:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8026b9:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  8026c0:	74 26                	je     8026e8 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8026c2:	6a 07                	push   $0x7
  8026c4:	68 00 70 80 00       	push   $0x807000
  8026c9:	53                   	push   %ebx
  8026ca:	ff 35 1c 50 80 00    	pushl  0x80501c
  8026d0:	e8 a2 f1 ff ff       	call   801877 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8026d5:	83 c4 0c             	add    $0xc,%esp
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	e8 21 f1 ff ff       	call   801804 <ipc_recv>
}
  8026e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8026e8:	83 ec 0c             	sub    $0xc,%esp
  8026eb:	6a 02                	push   $0x2
  8026ed:	e8 f1 f1 ff ff       	call   8018e3 <ipc_find_env>
  8026f2:	a3 1c 50 80 00       	mov    %eax,0x80501c
  8026f7:	83 c4 10             	add    $0x10,%esp
  8026fa:	eb c6                	jmp    8026c2 <nsipc+0x12>

008026fc <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
  8026ff:	56                   	push   %esi
  802700:	53                   	push   %ebx
  802701:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80270c:	8b 06                	mov    (%esi),%eax
  80270e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802713:	b8 01 00 00 00       	mov    $0x1,%eax
  802718:	e8 93 ff ff ff       	call   8026b0 <nsipc>
  80271d:	89 c3                	mov    %eax,%ebx
  80271f:	85 c0                	test   %eax,%eax
  802721:	79 09                	jns    80272c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802723:	89 d8                	mov    %ebx,%eax
  802725:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802728:	5b                   	pop    %ebx
  802729:	5e                   	pop    %esi
  80272a:	5d                   	pop    %ebp
  80272b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80272c:	83 ec 04             	sub    $0x4,%esp
  80272f:	ff 35 10 70 80 00    	pushl  0x807010
  802735:	68 00 70 80 00       	push   $0x807000
  80273a:	ff 75 0c             	pushl  0xc(%ebp)
  80273d:	e8 a9 e8 ff ff       	call   800feb <memmove>
		*addrlen = ret->ret_addrlen;
  802742:	a1 10 70 80 00       	mov    0x807010,%eax
  802747:	89 06                	mov    %eax,(%esi)
  802749:	83 c4 10             	add    $0x10,%esp
	return r;
  80274c:	eb d5                	jmp    802723 <nsipc_accept+0x27>

0080274e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	53                   	push   %ebx
  802752:	83 ec 08             	sub    $0x8,%esp
  802755:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802760:	53                   	push   %ebx
  802761:	ff 75 0c             	pushl  0xc(%ebp)
  802764:	68 04 70 80 00       	push   $0x807004
  802769:	e8 7d e8 ff ff       	call   800feb <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80276e:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802774:	b8 02 00 00 00       	mov    $0x2,%eax
  802779:	e8 32 ff ff ff       	call   8026b0 <nsipc>
}
  80277e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802781:	c9                   	leave  
  802782:	c3                   	ret    

00802783 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802783:	55                   	push   %ebp
  802784:	89 e5                	mov    %esp,%ebp
  802786:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802789:	8b 45 08             	mov    0x8(%ebp),%eax
  80278c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802791:	8b 45 0c             	mov    0xc(%ebp),%eax
  802794:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802799:	b8 03 00 00 00       	mov    $0x3,%eax
  80279e:	e8 0d ff ff ff       	call   8026b0 <nsipc>
}
  8027a3:	c9                   	leave  
  8027a4:	c3                   	ret    

008027a5 <nsipc_close>:

int
nsipc_close(int s)
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
  8027a8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8027b3:	b8 04 00 00 00       	mov    $0x4,%eax
  8027b8:	e8 f3 fe ff ff       	call   8026b0 <nsipc>
}
  8027bd:	c9                   	leave  
  8027be:	c3                   	ret    

008027bf <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8027bf:	55                   	push   %ebp
  8027c0:	89 e5                	mov    %esp,%ebp
  8027c2:	53                   	push   %ebx
  8027c3:	83 ec 08             	sub    $0x8,%esp
  8027c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8027d1:	53                   	push   %ebx
  8027d2:	ff 75 0c             	pushl  0xc(%ebp)
  8027d5:	68 04 70 80 00       	push   $0x807004
  8027da:	e8 0c e8 ff ff       	call   800feb <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8027df:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8027e5:	b8 05 00 00 00       	mov    $0x5,%eax
  8027ea:	e8 c1 fe ff ff       	call   8026b0 <nsipc>
}
  8027ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027f2:	c9                   	leave  
  8027f3:	c3                   	ret    

008027f4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
  8027f7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802802:	8b 45 0c             	mov    0xc(%ebp),%eax
  802805:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80280a:	b8 06 00 00 00       	mov    $0x6,%eax
  80280f:	e8 9c fe ff ff       	call   8026b0 <nsipc>
}
  802814:	c9                   	leave  
  802815:	c3                   	ret    

00802816 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802816:	55                   	push   %ebp
  802817:	89 e5                	mov    %esp,%ebp
  802819:	56                   	push   %esi
  80281a:	53                   	push   %ebx
  80281b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80281e:	8b 45 08             	mov    0x8(%ebp),%eax
  802821:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802826:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80282c:	8b 45 14             	mov    0x14(%ebp),%eax
  80282f:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802834:	b8 07 00 00 00       	mov    $0x7,%eax
  802839:	e8 72 fe ff ff       	call   8026b0 <nsipc>
  80283e:	89 c3                	mov    %eax,%ebx
  802840:	85 c0                	test   %eax,%eax
  802842:	78 1f                	js     802863 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802844:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802849:	7f 21                	jg     80286c <nsipc_recv+0x56>
  80284b:	39 c6                	cmp    %eax,%esi
  80284d:	7c 1d                	jl     80286c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80284f:	83 ec 04             	sub    $0x4,%esp
  802852:	50                   	push   %eax
  802853:	68 00 70 80 00       	push   $0x807000
  802858:	ff 75 0c             	pushl  0xc(%ebp)
  80285b:	e8 8b e7 ff ff       	call   800feb <memmove>
  802860:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802863:	89 d8                	mov    %ebx,%eax
  802865:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802868:	5b                   	pop    %ebx
  802869:	5e                   	pop    %esi
  80286a:	5d                   	pop    %ebp
  80286b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80286c:	68 12 35 80 00       	push   $0x803512
  802871:	68 b4 34 80 00       	push   $0x8034b4
  802876:	6a 62                	push   $0x62
  802878:	68 27 35 80 00       	push   $0x803527
  80287d:	e8 24 df ff ff       	call   8007a6 <_panic>

00802882 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802882:	55                   	push   %ebp
  802883:	89 e5                	mov    %esp,%ebp
  802885:	53                   	push   %ebx
  802886:	83 ec 04             	sub    $0x4,%esp
  802889:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802894:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80289a:	7f 2e                	jg     8028ca <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80289c:	83 ec 04             	sub    $0x4,%esp
  80289f:	53                   	push   %ebx
  8028a0:	ff 75 0c             	pushl  0xc(%ebp)
  8028a3:	68 0c 70 80 00       	push   $0x80700c
  8028a8:	e8 3e e7 ff ff       	call   800feb <memmove>
	nsipcbuf.send.req_size = size;
  8028ad:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8028b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8028b6:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8028bb:	b8 08 00 00 00       	mov    $0x8,%eax
  8028c0:	e8 eb fd ff ff       	call   8026b0 <nsipc>
}
  8028c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028c8:	c9                   	leave  
  8028c9:	c3                   	ret    
	assert(size < 1600);
  8028ca:	68 33 35 80 00       	push   $0x803533
  8028cf:	68 b4 34 80 00       	push   $0x8034b4
  8028d4:	6a 6d                	push   $0x6d
  8028d6:	68 27 35 80 00       	push   $0x803527
  8028db:	e8 c6 de ff ff       	call   8007a6 <_panic>

008028e0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
  8028e3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8028e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8028ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028f1:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8028f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8028f9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8028fe:	b8 09 00 00 00       	mov    $0x9,%eax
  802903:	e8 a8 fd ff ff       	call   8026b0 <nsipc>
}
  802908:	c9                   	leave  
  802909:	c3                   	ret    

0080290a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80290a:	b8 00 00 00 00       	mov    $0x0,%eax
  80290f:	c3                   	ret    

00802910 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802910:	55                   	push   %ebp
  802911:	89 e5                	mov    %esp,%ebp
  802913:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802916:	68 3f 35 80 00       	push   $0x80353f
  80291b:	ff 75 0c             	pushl  0xc(%ebp)
  80291e:	e8 3a e5 ff ff       	call   800e5d <strcpy>
	return 0;
}
  802923:	b8 00 00 00 00       	mov    $0x0,%eax
  802928:	c9                   	leave  
  802929:	c3                   	ret    

0080292a <devcons_write>:
{
  80292a:	55                   	push   %ebp
  80292b:	89 e5                	mov    %esp,%ebp
  80292d:	57                   	push   %edi
  80292e:	56                   	push   %esi
  80292f:	53                   	push   %ebx
  802930:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802936:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80293b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802941:	3b 75 10             	cmp    0x10(%ebp),%esi
  802944:	73 31                	jae    802977 <devcons_write+0x4d>
		m = n - tot;
  802946:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802949:	29 f3                	sub    %esi,%ebx
  80294b:	83 fb 7f             	cmp    $0x7f,%ebx
  80294e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802953:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802956:	83 ec 04             	sub    $0x4,%esp
  802959:	53                   	push   %ebx
  80295a:	89 f0                	mov    %esi,%eax
  80295c:	03 45 0c             	add    0xc(%ebp),%eax
  80295f:	50                   	push   %eax
  802960:	57                   	push   %edi
  802961:	e8 85 e6 ff ff       	call   800feb <memmove>
		sys_cputs(buf, m);
  802966:	83 c4 08             	add    $0x8,%esp
  802969:	53                   	push   %ebx
  80296a:	57                   	push   %edi
  80296b:	e8 23 e8 ff ff       	call   801193 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802970:	01 de                	add    %ebx,%esi
  802972:	83 c4 10             	add    $0x10,%esp
  802975:	eb ca                	jmp    802941 <devcons_write+0x17>
}
  802977:	89 f0                	mov    %esi,%eax
  802979:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80297c:	5b                   	pop    %ebx
  80297d:	5e                   	pop    %esi
  80297e:	5f                   	pop    %edi
  80297f:	5d                   	pop    %ebp
  802980:	c3                   	ret    

00802981 <devcons_read>:
{
  802981:	55                   	push   %ebp
  802982:	89 e5                	mov    %esp,%ebp
  802984:	83 ec 08             	sub    $0x8,%esp
  802987:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80298c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802990:	74 21                	je     8029b3 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802992:	e8 1a e8 ff ff       	call   8011b1 <sys_cgetc>
  802997:	85 c0                	test   %eax,%eax
  802999:	75 07                	jne    8029a2 <devcons_read+0x21>
		sys_yield();
  80299b:	e8 90 e8 ff ff       	call   801230 <sys_yield>
  8029a0:	eb f0                	jmp    802992 <devcons_read+0x11>
	if (c < 0)
  8029a2:	78 0f                	js     8029b3 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8029a4:	83 f8 04             	cmp    $0x4,%eax
  8029a7:	74 0c                	je     8029b5 <devcons_read+0x34>
	*(char*)vbuf = c;
  8029a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ac:	88 02                	mov    %al,(%edx)
	return 1;
  8029ae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8029b3:	c9                   	leave  
  8029b4:	c3                   	ret    
		return 0;
  8029b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ba:	eb f7                	jmp    8029b3 <devcons_read+0x32>

008029bc <cputchar>:
{
  8029bc:	55                   	push   %ebp
  8029bd:	89 e5                	mov    %esp,%ebp
  8029bf:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8029c8:	6a 01                	push   $0x1
  8029ca:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029cd:	50                   	push   %eax
  8029ce:	e8 c0 e7 ff ff       	call   801193 <sys_cputs>
}
  8029d3:	83 c4 10             	add    $0x10,%esp
  8029d6:	c9                   	leave  
  8029d7:	c3                   	ret    

008029d8 <getchar>:
{
  8029d8:	55                   	push   %ebp
  8029d9:	89 e5                	mov    %esp,%ebp
  8029db:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8029de:	6a 01                	push   $0x1
  8029e0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029e3:	50                   	push   %eax
  8029e4:	6a 00                	push   $0x0
  8029e6:	e8 1a f2 ff ff       	call   801c05 <read>
	if (r < 0)
  8029eb:	83 c4 10             	add    $0x10,%esp
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	78 06                	js     8029f8 <getchar+0x20>
	if (r < 1)
  8029f2:	74 06                	je     8029fa <getchar+0x22>
	return c;
  8029f4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8029f8:	c9                   	leave  
  8029f9:	c3                   	ret    
		return -E_EOF;
  8029fa:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8029ff:	eb f7                	jmp    8029f8 <getchar+0x20>

00802a01 <iscons>:
{
  802a01:	55                   	push   %ebp
  802a02:	89 e5                	mov    %esp,%ebp
  802a04:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a0a:	50                   	push   %eax
  802a0b:	ff 75 08             	pushl  0x8(%ebp)
  802a0e:	e8 82 ef ff ff       	call   801995 <fd_lookup>
  802a13:	83 c4 10             	add    $0x10,%esp
  802a16:	85 c0                	test   %eax,%eax
  802a18:	78 11                	js     802a2b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a23:	39 10                	cmp    %edx,(%eax)
  802a25:	0f 94 c0             	sete   %al
  802a28:	0f b6 c0             	movzbl %al,%eax
}
  802a2b:	c9                   	leave  
  802a2c:	c3                   	ret    

00802a2d <opencons>:
{
  802a2d:	55                   	push   %ebp
  802a2e:	89 e5                	mov    %esp,%ebp
  802a30:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802a33:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a36:	50                   	push   %eax
  802a37:	e8 07 ef ff ff       	call   801943 <fd_alloc>
  802a3c:	83 c4 10             	add    $0x10,%esp
  802a3f:	85 c0                	test   %eax,%eax
  802a41:	78 3a                	js     802a7d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a43:	83 ec 04             	sub    $0x4,%esp
  802a46:	68 07 04 00 00       	push   $0x407
  802a4b:	ff 75 f4             	pushl  -0xc(%ebp)
  802a4e:	6a 00                	push   $0x0
  802a50:	e8 fa e7 ff ff       	call   80124f <sys_page_alloc>
  802a55:	83 c4 10             	add    $0x10,%esp
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	78 21                	js     802a7d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a65:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a71:	83 ec 0c             	sub    $0xc,%esp
  802a74:	50                   	push   %eax
  802a75:	e8 a2 ee ff ff       	call   80191c <fd2num>
  802a7a:	83 c4 10             	add    $0x10,%esp
}
  802a7d:	c9                   	leave  
  802a7e:	c3                   	ret    

00802a7f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a7f:	55                   	push   %ebp
  802a80:	89 e5                	mov    %esp,%ebp
  802a82:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802a85:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802a8c:	74 0a                	je     802a98 <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a91:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802a96:	c9                   	leave  
  802a97:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802a98:	a1 20 50 80 00       	mov    0x805020,%eax
  802a9d:	8b 40 48             	mov    0x48(%eax),%eax
  802aa0:	83 ec 04             	sub    $0x4,%esp
  802aa3:	6a 07                	push   $0x7
  802aa5:	68 00 f0 bf ee       	push   $0xeebff000
  802aaa:	50                   	push   %eax
  802aab:	e8 9f e7 ff ff       	call   80124f <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802ab0:	83 c4 10             	add    $0x10,%esp
  802ab3:	85 c0                	test   %eax,%eax
  802ab5:	78 2c                	js     802ae3 <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802ab7:	e8 55 e7 ff ff       	call   801211 <sys_getenvid>
  802abc:	83 ec 08             	sub    $0x8,%esp
  802abf:	68 f5 2a 80 00       	push   $0x802af5
  802ac4:	50                   	push   %eax
  802ac5:	e8 d0 e8 ff ff       	call   80139a <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802aca:	83 c4 10             	add    $0x10,%esp
  802acd:	85 c0                	test   %eax,%eax
  802acf:	79 bd                	jns    802a8e <set_pgfault_handler+0xf>
  802ad1:	50                   	push   %eax
  802ad2:	68 4b 35 80 00       	push   $0x80354b
  802ad7:	6a 23                	push   $0x23
  802ad9:	68 63 35 80 00       	push   $0x803563
  802ade:	e8 c3 dc ff ff       	call   8007a6 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  802ae3:	50                   	push   %eax
  802ae4:	68 4b 35 80 00       	push   $0x80354b
  802ae9:	6a 21                	push   $0x21
  802aeb:	68 63 35 80 00       	push   $0x803563
  802af0:	e8 b1 dc ff ff       	call   8007a6 <_panic>

00802af5 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802af5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802af6:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802afb:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802afd:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  802b00:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  802b04:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  802b07:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  802b0b:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  802b0f:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802b12:	83 c4 08             	add    $0x8,%esp
	popal
  802b15:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802b16:	83 c4 04             	add    $0x4,%esp
	popfl
  802b19:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802b1a:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802b1b:	c3                   	ret    

00802b1c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b1c:	55                   	push   %ebp
  802b1d:	89 e5                	mov    %esp,%ebp
  802b1f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b22:	89 d0                	mov    %edx,%eax
  802b24:	c1 e8 16             	shr    $0x16,%eax
  802b27:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b2e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802b33:	f6 c1 01             	test   $0x1,%cl
  802b36:	74 1d                	je     802b55 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802b38:	c1 ea 0c             	shr    $0xc,%edx
  802b3b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b42:	f6 c2 01             	test   $0x1,%dl
  802b45:	74 0e                	je     802b55 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b47:	c1 ea 0c             	shr    $0xc,%edx
  802b4a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b51:	ef 
  802b52:	0f b7 c0             	movzwl %ax,%eax
}
  802b55:	5d                   	pop    %ebp
  802b56:	c3                   	ret    
  802b57:	66 90                	xchg   %ax,%ax
  802b59:	66 90                	xchg   %ax,%ax
  802b5b:	66 90                	xchg   %ax,%ax
  802b5d:	66 90                	xchg   %ax,%ax
  802b5f:	90                   	nop

00802b60 <__udivdi3>:
  802b60:	f3 0f 1e fb          	endbr32 
  802b64:	55                   	push   %ebp
  802b65:	57                   	push   %edi
  802b66:	56                   	push   %esi
  802b67:	53                   	push   %ebx
  802b68:	83 ec 1c             	sub    $0x1c,%esp
  802b6b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802b6f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802b73:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b77:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b7b:	85 d2                	test   %edx,%edx
  802b7d:	75 49                	jne    802bc8 <__udivdi3+0x68>
  802b7f:	39 f3                	cmp    %esi,%ebx
  802b81:	76 15                	jbe    802b98 <__udivdi3+0x38>
  802b83:	31 ff                	xor    %edi,%edi
  802b85:	89 e8                	mov    %ebp,%eax
  802b87:	89 f2                	mov    %esi,%edx
  802b89:	f7 f3                	div    %ebx
  802b8b:	89 fa                	mov    %edi,%edx
  802b8d:	83 c4 1c             	add    $0x1c,%esp
  802b90:	5b                   	pop    %ebx
  802b91:	5e                   	pop    %esi
  802b92:	5f                   	pop    %edi
  802b93:	5d                   	pop    %ebp
  802b94:	c3                   	ret    
  802b95:	8d 76 00             	lea    0x0(%esi),%esi
  802b98:	89 d9                	mov    %ebx,%ecx
  802b9a:	85 db                	test   %ebx,%ebx
  802b9c:	75 0b                	jne    802ba9 <__udivdi3+0x49>
  802b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802ba3:	31 d2                	xor    %edx,%edx
  802ba5:	f7 f3                	div    %ebx
  802ba7:	89 c1                	mov    %eax,%ecx
  802ba9:	31 d2                	xor    %edx,%edx
  802bab:	89 f0                	mov    %esi,%eax
  802bad:	f7 f1                	div    %ecx
  802baf:	89 c6                	mov    %eax,%esi
  802bb1:	89 e8                	mov    %ebp,%eax
  802bb3:	89 f7                	mov    %esi,%edi
  802bb5:	f7 f1                	div    %ecx
  802bb7:	89 fa                	mov    %edi,%edx
  802bb9:	83 c4 1c             	add    $0x1c,%esp
  802bbc:	5b                   	pop    %ebx
  802bbd:	5e                   	pop    %esi
  802bbe:	5f                   	pop    %edi
  802bbf:	5d                   	pop    %ebp
  802bc0:	c3                   	ret    
  802bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bc8:	39 f2                	cmp    %esi,%edx
  802bca:	77 1c                	ja     802be8 <__udivdi3+0x88>
  802bcc:	0f bd fa             	bsr    %edx,%edi
  802bcf:	83 f7 1f             	xor    $0x1f,%edi
  802bd2:	75 2c                	jne    802c00 <__udivdi3+0xa0>
  802bd4:	39 f2                	cmp    %esi,%edx
  802bd6:	72 06                	jb     802bde <__udivdi3+0x7e>
  802bd8:	31 c0                	xor    %eax,%eax
  802bda:	39 eb                	cmp    %ebp,%ebx
  802bdc:	77 ad                	ja     802b8b <__udivdi3+0x2b>
  802bde:	b8 01 00 00 00       	mov    $0x1,%eax
  802be3:	eb a6                	jmp    802b8b <__udivdi3+0x2b>
  802be5:	8d 76 00             	lea    0x0(%esi),%esi
  802be8:	31 ff                	xor    %edi,%edi
  802bea:	31 c0                	xor    %eax,%eax
  802bec:	89 fa                	mov    %edi,%edx
  802bee:	83 c4 1c             	add    $0x1c,%esp
  802bf1:	5b                   	pop    %ebx
  802bf2:	5e                   	pop    %esi
  802bf3:	5f                   	pop    %edi
  802bf4:	5d                   	pop    %ebp
  802bf5:	c3                   	ret    
  802bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bfd:	8d 76 00             	lea    0x0(%esi),%esi
  802c00:	89 f9                	mov    %edi,%ecx
  802c02:	b8 20 00 00 00       	mov    $0x20,%eax
  802c07:	29 f8                	sub    %edi,%eax
  802c09:	d3 e2                	shl    %cl,%edx
  802c0b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c0f:	89 c1                	mov    %eax,%ecx
  802c11:	89 da                	mov    %ebx,%edx
  802c13:	d3 ea                	shr    %cl,%edx
  802c15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c19:	09 d1                	or     %edx,%ecx
  802c1b:	89 f2                	mov    %esi,%edx
  802c1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c21:	89 f9                	mov    %edi,%ecx
  802c23:	d3 e3                	shl    %cl,%ebx
  802c25:	89 c1                	mov    %eax,%ecx
  802c27:	d3 ea                	shr    %cl,%edx
  802c29:	89 f9                	mov    %edi,%ecx
  802c2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802c2f:	89 eb                	mov    %ebp,%ebx
  802c31:	d3 e6                	shl    %cl,%esi
  802c33:	89 c1                	mov    %eax,%ecx
  802c35:	d3 eb                	shr    %cl,%ebx
  802c37:	09 de                	or     %ebx,%esi
  802c39:	89 f0                	mov    %esi,%eax
  802c3b:	f7 74 24 08          	divl   0x8(%esp)
  802c3f:	89 d6                	mov    %edx,%esi
  802c41:	89 c3                	mov    %eax,%ebx
  802c43:	f7 64 24 0c          	mull   0xc(%esp)
  802c47:	39 d6                	cmp    %edx,%esi
  802c49:	72 15                	jb     802c60 <__udivdi3+0x100>
  802c4b:	89 f9                	mov    %edi,%ecx
  802c4d:	d3 e5                	shl    %cl,%ebp
  802c4f:	39 c5                	cmp    %eax,%ebp
  802c51:	73 04                	jae    802c57 <__udivdi3+0xf7>
  802c53:	39 d6                	cmp    %edx,%esi
  802c55:	74 09                	je     802c60 <__udivdi3+0x100>
  802c57:	89 d8                	mov    %ebx,%eax
  802c59:	31 ff                	xor    %edi,%edi
  802c5b:	e9 2b ff ff ff       	jmp    802b8b <__udivdi3+0x2b>
  802c60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c63:	31 ff                	xor    %edi,%edi
  802c65:	e9 21 ff ff ff       	jmp    802b8b <__udivdi3+0x2b>
  802c6a:	66 90                	xchg   %ax,%ax
  802c6c:	66 90                	xchg   %ax,%ax
  802c6e:	66 90                	xchg   %ax,%ax

00802c70 <__umoddi3>:
  802c70:	f3 0f 1e fb          	endbr32 
  802c74:	55                   	push   %ebp
  802c75:	57                   	push   %edi
  802c76:	56                   	push   %esi
  802c77:	53                   	push   %ebx
  802c78:	83 ec 1c             	sub    $0x1c,%esp
  802c7b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802c7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c83:	8b 74 24 30          	mov    0x30(%esp),%esi
  802c87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c8b:	89 da                	mov    %ebx,%edx
  802c8d:	85 c0                	test   %eax,%eax
  802c8f:	75 3f                	jne    802cd0 <__umoddi3+0x60>
  802c91:	39 df                	cmp    %ebx,%edi
  802c93:	76 13                	jbe    802ca8 <__umoddi3+0x38>
  802c95:	89 f0                	mov    %esi,%eax
  802c97:	f7 f7                	div    %edi
  802c99:	89 d0                	mov    %edx,%eax
  802c9b:	31 d2                	xor    %edx,%edx
  802c9d:	83 c4 1c             	add    $0x1c,%esp
  802ca0:	5b                   	pop    %ebx
  802ca1:	5e                   	pop    %esi
  802ca2:	5f                   	pop    %edi
  802ca3:	5d                   	pop    %ebp
  802ca4:	c3                   	ret    
  802ca5:	8d 76 00             	lea    0x0(%esi),%esi
  802ca8:	89 fd                	mov    %edi,%ebp
  802caa:	85 ff                	test   %edi,%edi
  802cac:	75 0b                	jne    802cb9 <__umoddi3+0x49>
  802cae:	b8 01 00 00 00       	mov    $0x1,%eax
  802cb3:	31 d2                	xor    %edx,%edx
  802cb5:	f7 f7                	div    %edi
  802cb7:	89 c5                	mov    %eax,%ebp
  802cb9:	89 d8                	mov    %ebx,%eax
  802cbb:	31 d2                	xor    %edx,%edx
  802cbd:	f7 f5                	div    %ebp
  802cbf:	89 f0                	mov    %esi,%eax
  802cc1:	f7 f5                	div    %ebp
  802cc3:	89 d0                	mov    %edx,%eax
  802cc5:	eb d4                	jmp    802c9b <__umoddi3+0x2b>
  802cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cce:	66 90                	xchg   %ax,%ax
  802cd0:	89 f1                	mov    %esi,%ecx
  802cd2:	39 d8                	cmp    %ebx,%eax
  802cd4:	76 0a                	jbe    802ce0 <__umoddi3+0x70>
  802cd6:	89 f0                	mov    %esi,%eax
  802cd8:	83 c4 1c             	add    $0x1c,%esp
  802cdb:	5b                   	pop    %ebx
  802cdc:	5e                   	pop    %esi
  802cdd:	5f                   	pop    %edi
  802cde:	5d                   	pop    %ebp
  802cdf:	c3                   	ret    
  802ce0:	0f bd e8             	bsr    %eax,%ebp
  802ce3:	83 f5 1f             	xor    $0x1f,%ebp
  802ce6:	75 20                	jne    802d08 <__umoddi3+0x98>
  802ce8:	39 d8                	cmp    %ebx,%eax
  802cea:	0f 82 b0 00 00 00    	jb     802da0 <__umoddi3+0x130>
  802cf0:	39 f7                	cmp    %esi,%edi
  802cf2:	0f 86 a8 00 00 00    	jbe    802da0 <__umoddi3+0x130>
  802cf8:	89 c8                	mov    %ecx,%eax
  802cfa:	83 c4 1c             	add    $0x1c,%esp
  802cfd:	5b                   	pop    %ebx
  802cfe:	5e                   	pop    %esi
  802cff:	5f                   	pop    %edi
  802d00:	5d                   	pop    %ebp
  802d01:	c3                   	ret    
  802d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d08:	89 e9                	mov    %ebp,%ecx
  802d0a:	ba 20 00 00 00       	mov    $0x20,%edx
  802d0f:	29 ea                	sub    %ebp,%edx
  802d11:	d3 e0                	shl    %cl,%eax
  802d13:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d17:	89 d1                	mov    %edx,%ecx
  802d19:	89 f8                	mov    %edi,%eax
  802d1b:	d3 e8                	shr    %cl,%eax
  802d1d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802d21:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d25:	8b 54 24 04          	mov    0x4(%esp),%edx
  802d29:	09 c1                	or     %eax,%ecx
  802d2b:	89 d8                	mov    %ebx,%eax
  802d2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d31:	89 e9                	mov    %ebp,%ecx
  802d33:	d3 e7                	shl    %cl,%edi
  802d35:	89 d1                	mov    %edx,%ecx
  802d37:	d3 e8                	shr    %cl,%eax
  802d39:	89 e9                	mov    %ebp,%ecx
  802d3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d3f:	d3 e3                	shl    %cl,%ebx
  802d41:	89 c7                	mov    %eax,%edi
  802d43:	89 d1                	mov    %edx,%ecx
  802d45:	89 f0                	mov    %esi,%eax
  802d47:	d3 e8                	shr    %cl,%eax
  802d49:	89 e9                	mov    %ebp,%ecx
  802d4b:	89 fa                	mov    %edi,%edx
  802d4d:	d3 e6                	shl    %cl,%esi
  802d4f:	09 d8                	or     %ebx,%eax
  802d51:	f7 74 24 08          	divl   0x8(%esp)
  802d55:	89 d1                	mov    %edx,%ecx
  802d57:	89 f3                	mov    %esi,%ebx
  802d59:	f7 64 24 0c          	mull   0xc(%esp)
  802d5d:	89 c6                	mov    %eax,%esi
  802d5f:	89 d7                	mov    %edx,%edi
  802d61:	39 d1                	cmp    %edx,%ecx
  802d63:	72 06                	jb     802d6b <__umoddi3+0xfb>
  802d65:	75 10                	jne    802d77 <__umoddi3+0x107>
  802d67:	39 c3                	cmp    %eax,%ebx
  802d69:	73 0c                	jae    802d77 <__umoddi3+0x107>
  802d6b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802d6f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802d73:	89 d7                	mov    %edx,%edi
  802d75:	89 c6                	mov    %eax,%esi
  802d77:	89 ca                	mov    %ecx,%edx
  802d79:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d7e:	29 f3                	sub    %esi,%ebx
  802d80:	19 fa                	sbb    %edi,%edx
  802d82:	89 d0                	mov    %edx,%eax
  802d84:	d3 e0                	shl    %cl,%eax
  802d86:	89 e9                	mov    %ebp,%ecx
  802d88:	d3 eb                	shr    %cl,%ebx
  802d8a:	d3 ea                	shr    %cl,%edx
  802d8c:	09 d8                	or     %ebx,%eax
  802d8e:	83 c4 1c             	add    $0x1c,%esp
  802d91:	5b                   	pop    %ebx
  802d92:	5e                   	pop    %esi
  802d93:	5f                   	pop    %edi
  802d94:	5d                   	pop    %ebp
  802d95:	c3                   	ret    
  802d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d9d:	8d 76 00             	lea    0x0(%esi),%esi
  802da0:	89 da                	mov    %ebx,%edx
  802da2:	29 fe                	sub    %edi,%esi
  802da4:	19 c2                	sbb    %eax,%edx
  802da6:	89 f1                	mov    %esi,%ecx
  802da8:	89 c8                	mov    %ecx,%eax
  802daa:	e9 4b ff ff ff       	jmp    802cfa <__umoddi3+0x8a>
