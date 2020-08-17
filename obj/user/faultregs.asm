
obj/user/faultregs.debug：     文件格式 elf32-i386


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
  80002c:	e8 b0 05 00 00       	call   8005e1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	ff 75 08             	pushl  0x8(%ebp)
  800043:	52                   	push   %edx
  800044:	68 d1 28 80 00       	push   $0x8028d1
  800049:	68 a0 28 80 00       	push   $0x8028a0
  80004e:	e8 c9 06 00 00       	call   80071c <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 b0 28 80 00       	push   $0x8028b0
  80005c:	68 b4 28 80 00       	push   $0x8028b4
  800061:	e8 b6 06 00 00       	call   80071c <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 c8 28 80 00       	push   $0x8028c8
  80007b:	e8 9c 06 00 00       	call   80071c <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 d2 28 80 00       	push   $0x8028d2
  800093:	68 b4 28 80 00       	push   $0x8028b4
  800098:	e8 7f 06 00 00       	call   80071c <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 c8 28 80 00       	push   $0x8028c8
  8000b4:	e8 63 06 00 00       	call   80071c <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 d6 28 80 00       	push   $0x8028d6
  8000cc:	68 b4 28 80 00       	push   $0x8028b4
  8000d1:	e8 46 06 00 00       	call   80071c <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 c8 28 80 00       	push   $0x8028c8
  8000ed:	e8 2a 06 00 00       	call   80071c <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 da 28 80 00       	push   $0x8028da
  800105:	68 b4 28 80 00       	push   $0x8028b4
  80010a:	e8 0d 06 00 00       	call   80071c <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 c8 28 80 00       	push   $0x8028c8
  800126:	e8 f1 05 00 00       	call   80071c <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 de 28 80 00       	push   $0x8028de
  80013e:	68 b4 28 80 00       	push   $0x8028b4
  800143:	e8 d4 05 00 00       	call   80071c <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 c8 28 80 00       	push   $0x8028c8
  80015f:	e8 b8 05 00 00       	call   80071c <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 e2 28 80 00       	push   $0x8028e2
  800177:	68 b4 28 80 00       	push   $0x8028b4
  80017c:	e8 9b 05 00 00       	call   80071c <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 c8 28 80 00       	push   $0x8028c8
  800198:	e8 7f 05 00 00       	call   80071c <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 e6 28 80 00       	push   $0x8028e6
  8001b0:	68 b4 28 80 00       	push   $0x8028b4
  8001b5:	e8 62 05 00 00       	call   80071c <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 c8 28 80 00       	push   $0x8028c8
  8001d1:	e8 46 05 00 00       	call   80071c <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 ea 28 80 00       	push   $0x8028ea
  8001e9:	68 b4 28 80 00       	push   $0x8028b4
  8001ee:	e8 29 05 00 00       	call   80071c <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 c8 28 80 00       	push   $0x8028c8
  80020a:	e8 0d 05 00 00       	call   80071c <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 ee 28 80 00       	push   $0x8028ee
  800222:	68 b4 28 80 00       	push   $0x8028b4
  800227:	e8 f0 04 00 00       	call   80071c <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 c8 28 80 00       	push   $0x8028c8
  800243:	e8 d4 04 00 00       	call   80071c <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 f5 28 80 00       	push   $0x8028f5
  800253:	68 b4 28 80 00       	push   $0x8028b4
  800258:	e8 bf 04 00 00       	call   80071c <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 c8 28 80 00       	push   $0x8028c8
  800274:	e8 a3 04 00 00       	call   80071c <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 f9 28 80 00       	push   $0x8028f9
  800284:	e8 93 04 00 00       	call   80071c <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 c8 28 80 00       	push   $0x8028c8
  800294:	e8 83 04 00 00       	call   80071c <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 c4 28 80 00       	push   $0x8028c4
  8002a9:	e8 6e 04 00 00       	call   80071c <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 c4 28 80 00       	push   $0x8028c4
  8002c3:	e8 54 04 00 00       	call   80071c <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 c4 28 80 00       	push   $0x8028c4
  8002d8:	e8 3f 04 00 00       	call   80071c <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 c4 28 80 00       	push   $0x8028c4
  8002ed:	e8 2a 04 00 00       	call   80071c <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 c4 28 80 00       	push   $0x8028c4
  800302:	e8 15 04 00 00       	call   80071c <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 c4 28 80 00       	push   $0x8028c4
  800317:	e8 00 04 00 00       	call   80071c <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 c4 28 80 00       	push   $0x8028c4
  80032c:	e8 eb 03 00 00       	call   80071c <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 c4 28 80 00       	push   $0x8028c4
  800341:	e8 d6 03 00 00       	call   80071c <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 c4 28 80 00       	push   $0x8028c4
  800356:	e8 c1 03 00 00       	call   80071c <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	pushl  0x28(%ebx)
  80035e:	ff 76 28             	pushl  0x28(%esi)
  800361:	68 f5 28 80 00       	push   $0x8028f5
  800366:	68 b4 28 80 00       	push   $0x8028b4
  80036b:	e8 ac 03 00 00       	call   80071c <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 c4 28 80 00       	push   $0x8028c4
  800387:	e8 90 03 00 00       	call   80071c <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	68 f9 28 80 00       	push   $0x8028f9
  800397:	e8 80 03 00 00       	call   80071c <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 c4 28 80 00       	push   $0x8028c4
  8003af:	e8 68 03 00 00       	call   80071c <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
}
  8003b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 c4 28 80 00       	push   $0x8028c4
  8003c7:	e8 50 03 00 00       	call   80071c <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 f9 28 80 00       	push   $0x8028f9
  8003d7:	e8 40 03 00 00       	call   80071c <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	e9 a8 fe ff ff       	jmp    80028c <check_regs+0x259>

008003e4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003ed:	8b 10                	mov    (%eax),%edx
  8003ef:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003f5:	0f 85 a3 00 00 00    	jne    80049e <pgfault+0xba>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003fb:	8b 50 08             	mov    0x8(%eax),%edx
  8003fe:	89 15 40 40 80 00    	mov    %edx,0x804040
  800404:	8b 50 0c             	mov    0xc(%eax),%edx
  800407:	89 15 44 40 80 00    	mov    %edx,0x804044
  80040d:	8b 50 10             	mov    0x10(%eax),%edx
  800410:	89 15 48 40 80 00    	mov    %edx,0x804048
  800416:	8b 50 14             	mov    0x14(%eax),%edx
  800419:	89 15 4c 40 80 00    	mov    %edx,0x80404c
  80041f:	8b 50 18             	mov    0x18(%eax),%edx
  800422:	89 15 50 40 80 00    	mov    %edx,0x804050
  800428:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042b:	89 15 54 40 80 00    	mov    %edx,0x804054
  800431:	8b 50 20             	mov    0x20(%eax),%edx
  800434:	89 15 58 40 80 00    	mov    %edx,0x804058
  80043a:	8b 50 24             	mov    0x24(%eax),%edx
  80043d:	89 15 5c 40 80 00    	mov    %edx,0x80405c
	during.eip = utf->utf_eip;
  800443:	8b 50 28             	mov    0x28(%eax),%edx
  800446:	89 15 60 40 80 00    	mov    %edx,0x804060
	during.eflags = utf->utf_eflags & ~FL_RF;
  80044c:	8b 50 2c             	mov    0x2c(%eax),%edx
  80044f:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800455:	89 15 64 40 80 00    	mov    %edx,0x804064
	during.esp = utf->utf_esp;
  80045b:	8b 40 30             	mov    0x30(%eax),%eax
  80045e:	a3 68 40 80 00       	mov    %eax,0x804068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	68 1f 29 80 00       	push   $0x80291f
  80046b:	68 2d 29 80 00       	push   $0x80292d
  800470:	b9 40 40 80 00       	mov    $0x804040,%ecx
  800475:	ba 18 29 80 00       	mov    $0x802918,%edx
  80047a:	b8 80 40 80 00       	mov    $0x804080,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 55 0c 00 00       	call   8010ea <sys_page_alloc>
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	85 c0                	test   %eax,%eax
  80049a:	78 1a                	js     8004b6 <pgfault+0xd2>
		panic("sys_page_alloc: %e", r);
}
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	ff 70 28             	pushl  0x28(%eax)
  8004a4:	52                   	push   %edx
  8004a5:	68 60 29 80 00       	push   $0x802960
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 07 29 80 00       	push   $0x802907
  8004b1:	e8 8b 01 00 00       	call   800641 <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 34 29 80 00       	push   $0x802934
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 07 29 80 00       	push   $0x802907
  8004c3:	e8 79 01 00 00       	call   800641 <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 22 0e 00 00       	call   8012fa <set_pgfault_handler>

	asm volatile(
  8004d8:	50                   	push   %eax
  8004d9:	9c                   	pushf  
  8004da:	58                   	pop    %eax
  8004db:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e0:	50                   	push   %eax
  8004e1:	9d                   	popf   
  8004e2:	a3 a4 40 80 00       	mov    %eax,0x8040a4
  8004e7:	8d 05 22 05 80 00    	lea    0x800522,%eax
  8004ed:	a3 a0 40 80 00       	mov    %eax,0x8040a0
  8004f2:	58                   	pop    %eax
  8004f3:	89 3d 80 40 80 00    	mov    %edi,0x804080
  8004f9:	89 35 84 40 80 00    	mov    %esi,0x804084
  8004ff:	89 2d 88 40 80 00    	mov    %ebp,0x804088
  800505:	89 1d 90 40 80 00    	mov    %ebx,0x804090
  80050b:	89 15 94 40 80 00    	mov    %edx,0x804094
  800511:	89 0d 98 40 80 00    	mov    %ecx,0x804098
  800517:	a3 9c 40 80 00       	mov    %eax,0x80409c
  80051c:	89 25 a8 40 80 00    	mov    %esp,0x8040a8
  800522:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800529:	00 00 00 
  80052c:	89 3d 00 40 80 00    	mov    %edi,0x804000
  800532:	89 35 04 40 80 00    	mov    %esi,0x804004
  800538:	89 2d 08 40 80 00    	mov    %ebp,0x804008
  80053e:	89 1d 10 40 80 00    	mov    %ebx,0x804010
  800544:	89 15 14 40 80 00    	mov    %edx,0x804014
  80054a:	89 0d 18 40 80 00    	mov    %ecx,0x804018
  800550:	a3 1c 40 80 00       	mov    %eax,0x80401c
  800555:	89 25 28 40 80 00    	mov    %esp,0x804028
  80055b:	8b 3d 80 40 80 00    	mov    0x804080,%edi
  800561:	8b 35 84 40 80 00    	mov    0x804084,%esi
  800567:	8b 2d 88 40 80 00    	mov    0x804088,%ebp
  80056d:	8b 1d 90 40 80 00    	mov    0x804090,%ebx
  800573:	8b 15 94 40 80 00    	mov    0x804094,%edx
  800579:	8b 0d 98 40 80 00    	mov    0x804098,%ecx
  80057f:	a1 9c 40 80 00       	mov    0x80409c,%eax
  800584:	8b 25 a8 40 80 00    	mov    0x8040a8,%esp
  80058a:	50                   	push   %eax
  80058b:	9c                   	pushf  
  80058c:	58                   	pop    %eax
  80058d:	a3 24 40 80 00       	mov    %eax,0x804024
  800592:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  80059d:	75 30                	jne    8005cf <umain+0x107>
		cprintf("EIP after page-fault MISMATCH\n");
	after.eip = before.eip;
  80059f:	a1 a0 40 80 00       	mov    0x8040a0,%eax
  8005a4:	a3 20 40 80 00       	mov    %eax,0x804020

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	68 47 29 80 00       	push   $0x802947
  8005b1:	68 58 29 80 00       	push   $0x802958
  8005b6:	b9 00 40 80 00       	mov    $0x804000,%ecx
  8005bb:	ba 18 29 80 00       	mov    $0x802918,%edx
  8005c0:	b8 80 40 80 00       	mov    $0x804080,%eax
  8005c5:	e8 69 fa ff ff       	call   800033 <check_regs>
}
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	68 94 29 80 00       	push   $0x802994
  8005d7:	e8 40 01 00 00       	call   80071c <cprintf>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	eb be                	jmp    80059f <umain+0xd7>

008005e1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	56                   	push   %esi
  8005e5:	53                   	push   %ebx
  8005e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005e9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8005ec:	e8 bb 0a 00 00       	call   8010ac <sys_getenvid>
  8005f1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005f6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005f9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005fe:	a3 b4 40 80 00       	mov    %eax,0x8040b4

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800603:	85 db                	test   %ebx,%ebx
  800605:	7e 07                	jle    80060e <libmain+0x2d>
		binaryname = argv[0];
  800607:	8b 06                	mov    (%esi),%eax
  800609:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	56                   	push   %esi
  800612:	53                   	push   %ebx
  800613:	e8 b0 fe ff ff       	call   8004c8 <umain>

	// exit gracefully
	exit();
  800618:	e8 0a 00 00 00       	call   800627 <exit>
}
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800623:	5b                   	pop    %ebx
  800624:	5e                   	pop    %esi
  800625:	5d                   	pop    %ebp
  800626:	c3                   	ret    

00800627 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800627:	55                   	push   %ebp
  800628:	89 e5                	mov    %esp,%ebp
  80062a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80062d:	e8 3d 0f 00 00       	call   80156f <close_all>
	sys_env_destroy(0);
  800632:	83 ec 0c             	sub    $0xc,%esp
  800635:	6a 00                	push   $0x0
  800637:	e8 2f 0a 00 00       	call   80106b <sys_env_destroy>
}
  80063c:	83 c4 10             	add    $0x10,%esp
  80063f:	c9                   	leave  
  800640:	c3                   	ret    

00800641 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800641:	55                   	push   %ebp
  800642:	89 e5                	mov    %esp,%ebp
  800644:	56                   	push   %esi
  800645:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800646:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800649:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80064f:	e8 58 0a 00 00       	call   8010ac <sys_getenvid>
  800654:	83 ec 0c             	sub    $0xc,%esp
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	ff 75 08             	pushl  0x8(%ebp)
  80065d:	56                   	push   %esi
  80065e:	50                   	push   %eax
  80065f:	68 c0 29 80 00       	push   $0x8029c0
  800664:	e8 b3 00 00 00       	call   80071c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800669:	83 c4 18             	add    $0x18,%esp
  80066c:	53                   	push   %ebx
  80066d:	ff 75 10             	pushl  0x10(%ebp)
  800670:	e8 56 00 00 00       	call   8006cb <vcprintf>
	cprintf("\n");
  800675:	c7 04 24 d0 28 80 00 	movl   $0x8028d0,(%esp)
  80067c:	e8 9b 00 00 00       	call   80071c <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800684:	cc                   	int3   
  800685:	eb fd                	jmp    800684 <_panic+0x43>

00800687 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800687:	55                   	push   %ebp
  800688:	89 e5                	mov    %esp,%ebp
  80068a:	53                   	push   %ebx
  80068b:	83 ec 04             	sub    $0x4,%esp
  80068e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800691:	8b 13                	mov    (%ebx),%edx
  800693:	8d 42 01             	lea    0x1(%edx),%eax
  800696:	89 03                	mov    %eax,(%ebx)
  800698:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80069b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80069f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a4:	74 09                	je     8006af <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8006a6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ad:	c9                   	leave  
  8006ae:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	68 ff 00 00 00       	push   $0xff
  8006b7:	8d 43 08             	lea    0x8(%ebx),%eax
  8006ba:	50                   	push   %eax
  8006bb:	e8 6e 09 00 00       	call   80102e <sys_cputs>
		b->idx = 0;
  8006c0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006c6:	83 c4 10             	add    $0x10,%esp
  8006c9:	eb db                	jmp    8006a6 <putch+0x1f>

008006cb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006db:	00 00 00 
	b.cnt = 0;
  8006de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006e5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006e8:	ff 75 0c             	pushl  0xc(%ebp)
  8006eb:	ff 75 08             	pushl  0x8(%ebp)
  8006ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f4:	50                   	push   %eax
  8006f5:	68 87 06 80 00       	push   $0x800687
  8006fa:	e8 19 01 00 00       	call   800818 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006ff:	83 c4 08             	add    $0x8,%esp
  800702:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800708:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80070e:	50                   	push   %eax
  80070f:	e8 1a 09 00 00       	call   80102e <sys_cputs>

	return b.cnt;
}
  800714:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80071a:	c9                   	leave  
  80071b:	c3                   	ret    

0080071c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
  80071f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800722:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800725:	50                   	push   %eax
  800726:	ff 75 08             	pushl  0x8(%ebp)
  800729:	e8 9d ff ff ff       	call   8006cb <vcprintf>
	va_end(ap);

	return cnt;
}
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	57                   	push   %edi
  800734:	56                   	push   %esi
  800735:	53                   	push   %ebx
  800736:	83 ec 1c             	sub    $0x1c,%esp
  800739:	89 c7                	mov    %eax,%edi
  80073b:	89 d6                	mov    %edx,%esi
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	8b 55 0c             	mov    0xc(%ebp),%edx
  800743:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800746:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800749:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80074c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800751:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800754:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800757:	3b 45 10             	cmp    0x10(%ebp),%eax
  80075a:	89 d0                	mov    %edx,%eax
  80075c:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  80075f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800762:	73 15                	jae    800779 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800764:	83 eb 01             	sub    $0x1,%ebx
  800767:	85 db                	test   %ebx,%ebx
  800769:	7e 43                	jle    8007ae <printnum+0x7e>
			putch(padc, putdat);
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	56                   	push   %esi
  80076f:	ff 75 18             	pushl  0x18(%ebp)
  800772:	ff d7                	call   *%edi
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	eb eb                	jmp    800764 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800779:	83 ec 0c             	sub    $0xc,%esp
  80077c:	ff 75 18             	pushl  0x18(%ebp)
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800785:	53                   	push   %ebx
  800786:	ff 75 10             	pushl  0x10(%ebp)
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80078f:	ff 75 e0             	pushl  -0x20(%ebp)
  800792:	ff 75 dc             	pushl  -0x24(%ebp)
  800795:	ff 75 d8             	pushl  -0x28(%ebp)
  800798:	e8 b3 1e 00 00       	call   802650 <__udivdi3>
  80079d:	83 c4 18             	add    $0x18,%esp
  8007a0:	52                   	push   %edx
  8007a1:	50                   	push   %eax
  8007a2:	89 f2                	mov    %esi,%edx
  8007a4:	89 f8                	mov    %edi,%eax
  8007a6:	e8 85 ff ff ff       	call   800730 <printnum>
  8007ab:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	56                   	push   %esi
  8007b2:	83 ec 04             	sub    $0x4,%esp
  8007b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8007bb:	ff 75 dc             	pushl  -0x24(%ebp)
  8007be:	ff 75 d8             	pushl  -0x28(%ebp)
  8007c1:	e8 9a 1f 00 00       	call   802760 <__umoddi3>
  8007c6:	83 c4 14             	add    $0x14,%esp
  8007c9:	0f be 80 e3 29 80 00 	movsbl 0x8029e3(%eax),%eax
  8007d0:	50                   	push   %eax
  8007d1:	ff d7                	call   *%edi
}
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d9:	5b                   	pop    %ebx
  8007da:	5e                   	pop    %esi
  8007db:	5f                   	pop    %edi
  8007dc:	5d                   	pop    %ebp
  8007dd:	c3                   	ret    

008007de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007e4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007e8:	8b 10                	mov    (%eax),%edx
  8007ea:	3b 50 04             	cmp    0x4(%eax),%edx
  8007ed:	73 0a                	jae    8007f9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8007ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007f2:	89 08                	mov    %ecx,(%eax)
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	88 02                	mov    %al,(%edx)
}
  8007f9:	5d                   	pop    %ebp
  8007fa:	c3                   	ret    

008007fb <printfmt>:
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
  8007fe:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800801:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800804:	50                   	push   %eax
  800805:	ff 75 10             	pushl  0x10(%ebp)
  800808:	ff 75 0c             	pushl  0xc(%ebp)
  80080b:	ff 75 08             	pushl  0x8(%ebp)
  80080e:	e8 05 00 00 00       	call   800818 <vprintfmt>
}
  800813:	83 c4 10             	add    $0x10,%esp
  800816:	c9                   	leave  
  800817:	c3                   	ret    

00800818 <vprintfmt>:
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	57                   	push   %edi
  80081c:	56                   	push   %esi
  80081d:	53                   	push   %ebx
  80081e:	83 ec 3c             	sub    $0x3c,%esp
  800821:	8b 75 08             	mov    0x8(%ebp),%esi
  800824:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800827:	8b 7d 10             	mov    0x10(%ebp),%edi
  80082a:	eb 0a                	jmp    800836 <vprintfmt+0x1e>
			putch(ch, putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	53                   	push   %ebx
  800830:	50                   	push   %eax
  800831:	ff d6                	call   *%esi
  800833:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800836:	83 c7 01             	add    $0x1,%edi
  800839:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80083d:	83 f8 25             	cmp    $0x25,%eax
  800840:	74 0c                	je     80084e <vprintfmt+0x36>
			if (ch == '\0')
  800842:	85 c0                	test   %eax,%eax
  800844:	75 e6                	jne    80082c <vprintfmt+0x14>
}
  800846:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800849:	5b                   	pop    %ebx
  80084a:	5e                   	pop    %esi
  80084b:	5f                   	pop    %edi
  80084c:	5d                   	pop    %ebp
  80084d:	c3                   	ret    
		padc = ' ';
  80084e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800852:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800859:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800860:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800867:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80086c:	8d 47 01             	lea    0x1(%edi),%eax
  80086f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800872:	0f b6 17             	movzbl (%edi),%edx
  800875:	8d 42 dd             	lea    -0x23(%edx),%eax
  800878:	3c 55                	cmp    $0x55,%al
  80087a:	0f 87 ba 03 00 00    	ja     800c3a <vprintfmt+0x422>
  800880:	0f b6 c0             	movzbl %al,%eax
  800883:	ff 24 85 20 2b 80 00 	jmp    *0x802b20(,%eax,4)
  80088a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80088d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800891:	eb d9                	jmp    80086c <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  800893:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800896:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80089a:	eb d0                	jmp    80086c <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80089c:	0f b6 d2             	movzbl %dl,%edx
  80089f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8008a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8008aa:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8008ad:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8008b1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8008b4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8008b7:	83 f9 09             	cmp    $0x9,%ecx
  8008ba:	77 55                	ja     800911 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  8008bc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8008bf:	eb e9                	jmp    8008aa <vprintfmt+0x92>
			precision = va_arg(ap, int);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8d 40 04             	lea    0x4(%eax),%eax
  8008cf:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8008d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008d9:	79 91                	jns    80086c <vprintfmt+0x54>
				width = precision, precision = -1;
  8008db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008e1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8008e8:	eb 82                	jmp    80086c <vprintfmt+0x54>
  8008ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ed:	85 c0                	test   %eax,%eax
  8008ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f4:	0f 49 d0             	cmovns %eax,%edx
  8008f7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8008fd:	e9 6a ff ff ff       	jmp    80086c <vprintfmt+0x54>
  800902:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800905:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80090c:	e9 5b ff ff ff       	jmp    80086c <vprintfmt+0x54>
  800911:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800914:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800917:	eb bc                	jmp    8008d5 <vprintfmt+0xbd>
			lflag++;
  800919:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80091c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80091f:	e9 48 ff ff ff       	jmp    80086c <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  800924:	8b 45 14             	mov    0x14(%ebp),%eax
  800927:	8d 78 04             	lea    0x4(%eax),%edi
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	53                   	push   %ebx
  80092e:	ff 30                	pushl  (%eax)
  800930:	ff d6                	call   *%esi
			break;
  800932:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800935:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800938:	e9 9c 02 00 00       	jmp    800bd9 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8d 78 04             	lea    0x4(%eax),%edi
  800943:	8b 00                	mov    (%eax),%eax
  800945:	99                   	cltd   
  800946:	31 d0                	xor    %edx,%eax
  800948:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80094a:	83 f8 0f             	cmp    $0xf,%eax
  80094d:	7f 23                	jg     800972 <vprintfmt+0x15a>
  80094f:	8b 14 85 80 2c 80 00 	mov    0x802c80(,%eax,4),%edx
  800956:	85 d2                	test   %edx,%edx
  800958:	74 18                	je     800972 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  80095a:	52                   	push   %edx
  80095b:	68 de 2d 80 00       	push   $0x802dde
  800960:	53                   	push   %ebx
  800961:	56                   	push   %esi
  800962:	e8 94 fe ff ff       	call   8007fb <printfmt>
  800967:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80096a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80096d:	e9 67 02 00 00       	jmp    800bd9 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  800972:	50                   	push   %eax
  800973:	68 fb 29 80 00       	push   $0x8029fb
  800978:	53                   	push   %ebx
  800979:	56                   	push   %esi
  80097a:	e8 7c fe ff ff       	call   8007fb <printfmt>
  80097f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800982:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800985:	e9 4f 02 00 00       	jmp    800bd9 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80098a:	8b 45 14             	mov    0x14(%ebp),%eax
  80098d:	83 c0 04             	add    $0x4,%eax
  800990:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800998:	85 d2                	test   %edx,%edx
  80099a:	b8 f4 29 80 00       	mov    $0x8029f4,%eax
  80099f:	0f 45 c2             	cmovne %edx,%eax
  8009a2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8009a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a9:	7e 06                	jle    8009b1 <vprintfmt+0x199>
  8009ab:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8009af:	75 0d                	jne    8009be <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8009b4:	89 c7                	mov    %eax,%edi
  8009b6:	03 45 e0             	add    -0x20(%ebp),%eax
  8009b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009bc:	eb 3f                	jmp    8009fd <vprintfmt+0x1e5>
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8009c4:	50                   	push   %eax
  8009c5:	e8 0d 03 00 00       	call   800cd7 <strnlen>
  8009ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009cd:	29 c2                	sub    %eax,%edx
  8009cf:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8009d2:	83 c4 10             	add    $0x10,%esp
  8009d5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8009d7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8009de:	85 ff                	test   %edi,%edi
  8009e0:	7e 58                	jle    800a3a <vprintfmt+0x222>
					putch(padc, putdat);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	53                   	push   %ebx
  8009e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8009e9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009eb:	83 ef 01             	sub    $0x1,%edi
  8009ee:	83 c4 10             	add    $0x10,%esp
  8009f1:	eb eb                	jmp    8009de <vprintfmt+0x1c6>
					putch(ch, putdat);
  8009f3:	83 ec 08             	sub    $0x8,%esp
  8009f6:	53                   	push   %ebx
  8009f7:	52                   	push   %edx
  8009f8:	ff d6                	call   *%esi
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a00:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a02:	83 c7 01             	add    $0x1,%edi
  800a05:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a09:	0f be d0             	movsbl %al,%edx
  800a0c:	85 d2                	test   %edx,%edx
  800a0e:	74 45                	je     800a55 <vprintfmt+0x23d>
  800a10:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a14:	78 06                	js     800a1c <vprintfmt+0x204>
  800a16:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800a1a:	78 35                	js     800a51 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  800a1c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a20:	74 d1                	je     8009f3 <vprintfmt+0x1db>
  800a22:	0f be c0             	movsbl %al,%eax
  800a25:	83 e8 20             	sub    $0x20,%eax
  800a28:	83 f8 5e             	cmp    $0x5e,%eax
  800a2b:	76 c6                	jbe    8009f3 <vprintfmt+0x1db>
					putch('?', putdat);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	53                   	push   %ebx
  800a31:	6a 3f                	push   $0x3f
  800a33:	ff d6                	call   *%esi
  800a35:	83 c4 10             	add    $0x10,%esp
  800a38:	eb c3                	jmp    8009fd <vprintfmt+0x1e5>
  800a3a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a3d:	85 d2                	test   %edx,%edx
  800a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a44:	0f 49 c2             	cmovns %edx,%eax
  800a47:	29 c2                	sub    %eax,%edx
  800a49:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800a4c:	e9 60 ff ff ff       	jmp    8009b1 <vprintfmt+0x199>
  800a51:	89 cf                	mov    %ecx,%edi
  800a53:	eb 02                	jmp    800a57 <vprintfmt+0x23f>
  800a55:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  800a57:	85 ff                	test   %edi,%edi
  800a59:	7e 10                	jle    800a6b <vprintfmt+0x253>
				putch(' ', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	53                   	push   %ebx
  800a5f:	6a 20                	push   $0x20
  800a61:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a63:	83 ef 01             	sub    $0x1,%edi
  800a66:	83 c4 10             	add    $0x10,%esp
  800a69:	eb ec                	jmp    800a57 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  800a6b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a71:	e9 63 01 00 00       	jmp    800bd9 <vprintfmt+0x3c1>
	if (lflag >= 2)
  800a76:	83 f9 01             	cmp    $0x1,%ecx
  800a79:	7f 1b                	jg     800a96 <vprintfmt+0x27e>
	else if (lflag)
  800a7b:	85 c9                	test   %ecx,%ecx
  800a7d:	74 63                	je     800ae2 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	8b 00                	mov    (%eax),%eax
  800a84:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a87:	99                   	cltd   
  800a88:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	8d 40 04             	lea    0x4(%eax),%eax
  800a91:	89 45 14             	mov    %eax,0x14(%ebp)
  800a94:	eb 17                	jmp    800aad <vprintfmt+0x295>
		return va_arg(*ap, long long);
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	8b 50 04             	mov    0x4(%eax),%edx
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aa4:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa7:	8d 40 08             	lea    0x8(%eax),%eax
  800aaa:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800aad:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ab0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800ab3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800ab8:	85 c9                	test   %ecx,%ecx
  800aba:	0f 89 ff 00 00 00    	jns    800bbf <vprintfmt+0x3a7>
				putch('-', putdat);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	53                   	push   %ebx
  800ac4:	6a 2d                	push   $0x2d
  800ac6:	ff d6                	call   *%esi
				num = -(long long) num;
  800ac8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800acb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800ace:	f7 da                	neg    %edx
  800ad0:	83 d1 00             	adc    $0x0,%ecx
  800ad3:	f7 d9                	neg    %ecx
  800ad5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ad8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800add:	e9 dd 00 00 00       	jmp    800bbf <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  800ae2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aea:	99                   	cltd   
  800aeb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aee:	8b 45 14             	mov    0x14(%ebp),%eax
  800af1:	8d 40 04             	lea    0x4(%eax),%eax
  800af4:	89 45 14             	mov    %eax,0x14(%ebp)
  800af7:	eb b4                	jmp    800aad <vprintfmt+0x295>
	if (lflag >= 2)
  800af9:	83 f9 01             	cmp    $0x1,%ecx
  800afc:	7f 1e                	jg     800b1c <vprintfmt+0x304>
	else if (lflag)
  800afe:	85 c9                	test   %ecx,%ecx
  800b00:	74 32                	je     800b34 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	8b 10                	mov    (%eax),%edx
  800b07:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b0c:	8d 40 04             	lea    0x4(%eax),%eax
  800b0f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b12:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b17:	e9 a3 00 00 00       	jmp    800bbf <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	8b 10                	mov    (%eax),%edx
  800b21:	8b 48 04             	mov    0x4(%eax),%ecx
  800b24:	8d 40 08             	lea    0x8(%eax),%eax
  800b27:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b2a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b2f:	e9 8b 00 00 00       	jmp    800bbf <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800b34:	8b 45 14             	mov    0x14(%ebp),%eax
  800b37:	8b 10                	mov    (%eax),%edx
  800b39:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3e:	8d 40 04             	lea    0x4(%eax),%eax
  800b41:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b44:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b49:	eb 74                	jmp    800bbf <vprintfmt+0x3a7>
	if (lflag >= 2)
  800b4b:	83 f9 01             	cmp    $0x1,%ecx
  800b4e:	7f 1b                	jg     800b6b <vprintfmt+0x353>
	else if (lflag)
  800b50:	85 c9                	test   %ecx,%ecx
  800b52:	74 2c                	je     800b80 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	8b 10                	mov    (%eax),%edx
  800b59:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b5e:	8d 40 04             	lea    0x4(%eax),%eax
  800b61:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b64:	b8 08 00 00 00       	mov    $0x8,%eax
  800b69:	eb 54                	jmp    800bbf <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6e:	8b 10                	mov    (%eax),%edx
  800b70:	8b 48 04             	mov    0x4(%eax),%ecx
  800b73:	8d 40 08             	lea    0x8(%eax),%eax
  800b76:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b79:	b8 08 00 00 00       	mov    $0x8,%eax
  800b7e:	eb 3f                	jmp    800bbf <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800b80:	8b 45 14             	mov    0x14(%ebp),%eax
  800b83:	8b 10                	mov    (%eax),%edx
  800b85:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b8a:	8d 40 04             	lea    0x4(%eax),%eax
  800b8d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b90:	b8 08 00 00 00       	mov    $0x8,%eax
  800b95:	eb 28                	jmp    800bbf <vprintfmt+0x3a7>
			putch('0', putdat);
  800b97:	83 ec 08             	sub    $0x8,%esp
  800b9a:	53                   	push   %ebx
  800b9b:	6a 30                	push   $0x30
  800b9d:	ff d6                	call   *%esi
			putch('x', putdat);
  800b9f:	83 c4 08             	add    $0x8,%esp
  800ba2:	53                   	push   %ebx
  800ba3:	6a 78                	push   $0x78
  800ba5:	ff d6                	call   *%esi
			num = (unsigned long long)
  800ba7:	8b 45 14             	mov    0x14(%ebp),%eax
  800baa:	8b 10                	mov    (%eax),%edx
  800bac:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800bb1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800bb4:	8d 40 04             	lea    0x4(%eax),%eax
  800bb7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bba:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800bbf:	83 ec 0c             	sub    $0xc,%esp
  800bc2:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800bc6:	57                   	push   %edi
  800bc7:	ff 75 e0             	pushl  -0x20(%ebp)
  800bca:	50                   	push   %eax
  800bcb:	51                   	push   %ecx
  800bcc:	52                   	push   %edx
  800bcd:	89 da                	mov    %ebx,%edx
  800bcf:	89 f0                	mov    %esi,%eax
  800bd1:	e8 5a fb ff ff       	call   800730 <printnum>
			break;
  800bd6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800bd9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bdc:	e9 55 fc ff ff       	jmp    800836 <vprintfmt+0x1e>
	if (lflag >= 2)
  800be1:	83 f9 01             	cmp    $0x1,%ecx
  800be4:	7f 1b                	jg     800c01 <vprintfmt+0x3e9>
	else if (lflag)
  800be6:	85 c9                	test   %ecx,%ecx
  800be8:	74 2c                	je     800c16 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  800bea:	8b 45 14             	mov    0x14(%ebp),%eax
  800bed:	8b 10                	mov    (%eax),%edx
  800bef:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf4:	8d 40 04             	lea    0x4(%eax),%eax
  800bf7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bfa:	b8 10 00 00 00       	mov    $0x10,%eax
  800bff:	eb be                	jmp    800bbf <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  800c01:	8b 45 14             	mov    0x14(%ebp),%eax
  800c04:	8b 10                	mov    (%eax),%edx
  800c06:	8b 48 04             	mov    0x4(%eax),%ecx
  800c09:	8d 40 08             	lea    0x8(%eax),%eax
  800c0c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c0f:	b8 10 00 00 00       	mov    $0x10,%eax
  800c14:	eb a9                	jmp    800bbf <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  800c16:	8b 45 14             	mov    0x14(%ebp),%eax
  800c19:	8b 10                	mov    (%eax),%edx
  800c1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c20:	8d 40 04             	lea    0x4(%eax),%eax
  800c23:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c26:	b8 10 00 00 00       	mov    $0x10,%eax
  800c2b:	eb 92                	jmp    800bbf <vprintfmt+0x3a7>
			putch(ch, putdat);
  800c2d:	83 ec 08             	sub    $0x8,%esp
  800c30:	53                   	push   %ebx
  800c31:	6a 25                	push   $0x25
  800c33:	ff d6                	call   *%esi
			break;
  800c35:	83 c4 10             	add    $0x10,%esp
  800c38:	eb 9f                	jmp    800bd9 <vprintfmt+0x3c1>
			putch('%', putdat);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	53                   	push   %ebx
  800c3e:	6a 25                	push   $0x25
  800c40:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c42:	83 c4 10             	add    $0x10,%esp
  800c45:	89 f8                	mov    %edi,%eax
  800c47:	eb 03                	jmp    800c4c <vprintfmt+0x434>
  800c49:	83 e8 01             	sub    $0x1,%eax
  800c4c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c50:	75 f7                	jne    800c49 <vprintfmt+0x431>
  800c52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c55:	eb 82                	jmp    800bd9 <vprintfmt+0x3c1>

00800c57 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 18             	sub    $0x18,%esp
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c66:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c6a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c74:	85 c0                	test   %eax,%eax
  800c76:	74 26                	je     800c9e <vsnprintf+0x47>
  800c78:	85 d2                	test   %edx,%edx
  800c7a:	7e 22                	jle    800c9e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c7c:	ff 75 14             	pushl  0x14(%ebp)
  800c7f:	ff 75 10             	pushl  0x10(%ebp)
  800c82:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c85:	50                   	push   %eax
  800c86:	68 de 07 80 00       	push   $0x8007de
  800c8b:	e8 88 fb ff ff       	call   800818 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c93:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c99:	83 c4 10             	add    $0x10,%esp
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    
		return -E_INVAL;
  800c9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ca3:	eb f7                	jmp    800c9c <vsnprintf+0x45>

00800ca5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cab:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cae:	50                   	push   %eax
  800caf:	ff 75 10             	pushl  0x10(%ebp)
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	ff 75 08             	pushl  0x8(%ebp)
  800cb8:	e8 9a ff ff ff       	call   800c57 <vsnprintf>
	va_end(ap);

	return rc;
}
  800cbd:	c9                   	leave  
  800cbe:	c3                   	ret    

00800cbf <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cca:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cce:	74 05                	je     800cd5 <strlen+0x16>
		n++;
  800cd0:	83 c0 01             	add    $0x1,%eax
  800cd3:	eb f5                	jmp    800cca <strlen+0xb>
	return n;
}
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce5:	39 c2                	cmp    %eax,%edx
  800ce7:	74 0d                	je     800cf6 <strnlen+0x1f>
  800ce9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ced:	74 05                	je     800cf4 <strnlen+0x1d>
		n++;
  800cef:	83 c2 01             	add    $0x1,%edx
  800cf2:	eb f1                	jmp    800ce5 <strnlen+0xe>
  800cf4:	89 d0                	mov    %edx,%eax
	return n;
}
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	53                   	push   %ebx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d02:	ba 00 00 00 00       	mov    $0x0,%edx
  800d07:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d0b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d0e:	83 c2 01             	add    $0x1,%edx
  800d11:	84 c9                	test   %cl,%cl
  800d13:	75 f2                	jne    800d07 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800d15:	5b                   	pop    %ebx
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    

00800d18 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	53                   	push   %ebx
  800d1c:	83 ec 10             	sub    $0x10,%esp
  800d1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d22:	53                   	push   %ebx
  800d23:	e8 97 ff ff ff       	call   800cbf <strlen>
  800d28:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	01 d8                	add    %ebx,%eax
  800d30:	50                   	push   %eax
  800d31:	e8 c2 ff ff ff       	call   800cf8 <strcpy>
	return dst;
}
  800d36:	89 d8                	mov    %ebx,%eax
  800d38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d3b:	c9                   	leave  
  800d3c:	c3                   	ret    

00800d3d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d48:	89 c6                	mov    %eax,%esi
  800d4a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d4d:	89 c2                	mov    %eax,%edx
  800d4f:	39 f2                	cmp    %esi,%edx
  800d51:	74 11                	je     800d64 <strncpy+0x27>
		*dst++ = *src;
  800d53:	83 c2 01             	add    $0x1,%edx
  800d56:	0f b6 19             	movzbl (%ecx),%ebx
  800d59:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d5c:	80 fb 01             	cmp    $0x1,%bl
  800d5f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800d62:	eb eb                	jmp    800d4f <strncpy+0x12>
	}
	return ret;
}
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	56                   	push   %esi
  800d6c:	53                   	push   %ebx
  800d6d:	8b 75 08             	mov    0x8(%ebp),%esi
  800d70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d73:	8b 55 10             	mov    0x10(%ebp),%edx
  800d76:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d78:	85 d2                	test   %edx,%edx
  800d7a:	74 21                	je     800d9d <strlcpy+0x35>
  800d7c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d80:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800d82:	39 c2                	cmp    %eax,%edx
  800d84:	74 14                	je     800d9a <strlcpy+0x32>
  800d86:	0f b6 19             	movzbl (%ecx),%ebx
  800d89:	84 db                	test   %bl,%bl
  800d8b:	74 0b                	je     800d98 <strlcpy+0x30>
			*dst++ = *src++;
  800d8d:	83 c1 01             	add    $0x1,%ecx
  800d90:	83 c2 01             	add    $0x1,%edx
  800d93:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d96:	eb ea                	jmp    800d82 <strlcpy+0x1a>
  800d98:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d9a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d9d:	29 f0                	sub    %esi,%eax
}
  800d9f:	5b                   	pop    %ebx
  800da0:	5e                   	pop    %esi
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    

00800da3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800dac:	0f b6 01             	movzbl (%ecx),%eax
  800daf:	84 c0                	test   %al,%al
  800db1:	74 0c                	je     800dbf <strcmp+0x1c>
  800db3:	3a 02                	cmp    (%edx),%al
  800db5:	75 08                	jne    800dbf <strcmp+0x1c>
		p++, q++;
  800db7:	83 c1 01             	add    $0x1,%ecx
  800dba:	83 c2 01             	add    $0x1,%edx
  800dbd:	eb ed                	jmp    800dac <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dbf:	0f b6 c0             	movzbl %al,%eax
  800dc2:	0f b6 12             	movzbl (%edx),%edx
  800dc5:	29 d0                	sub    %edx,%eax
}
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    

00800dc9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	53                   	push   %ebx
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd3:	89 c3                	mov    %eax,%ebx
  800dd5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800dd8:	eb 06                	jmp    800de0 <strncmp+0x17>
		n--, p++, q++;
  800dda:	83 c0 01             	add    $0x1,%eax
  800ddd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800de0:	39 d8                	cmp    %ebx,%eax
  800de2:	74 16                	je     800dfa <strncmp+0x31>
  800de4:	0f b6 08             	movzbl (%eax),%ecx
  800de7:	84 c9                	test   %cl,%cl
  800de9:	74 04                	je     800def <strncmp+0x26>
  800deb:	3a 0a                	cmp    (%edx),%cl
  800ded:	74 eb                	je     800dda <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800def:	0f b6 00             	movzbl (%eax),%eax
  800df2:	0f b6 12             	movzbl (%edx),%edx
  800df5:	29 d0                	sub    %edx,%eax
}
  800df7:	5b                   	pop    %ebx
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    
		return 0;
  800dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  800dff:	eb f6                	jmp    800df7 <strncmp+0x2e>

00800e01 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e0b:	0f b6 10             	movzbl (%eax),%edx
  800e0e:	84 d2                	test   %dl,%dl
  800e10:	74 09                	je     800e1b <strchr+0x1a>
		if (*s == c)
  800e12:	38 ca                	cmp    %cl,%dl
  800e14:	74 0a                	je     800e20 <strchr+0x1f>
	for (; *s; s++)
  800e16:	83 c0 01             	add    $0x1,%eax
  800e19:	eb f0                	jmp    800e0b <strchr+0xa>
			return (char *) s;
	return 0;
  800e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e2c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e2f:	38 ca                	cmp    %cl,%dl
  800e31:	74 09                	je     800e3c <strfind+0x1a>
  800e33:	84 d2                	test   %dl,%dl
  800e35:	74 05                	je     800e3c <strfind+0x1a>
	for (; *s; s++)
  800e37:	83 c0 01             	add    $0x1,%eax
  800e3a:	eb f0                	jmp    800e2c <strfind+0xa>
			break;
	return (char *) s;
}
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    

00800e3e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	57                   	push   %edi
  800e42:	56                   	push   %esi
  800e43:	53                   	push   %ebx
  800e44:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e47:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e4a:	85 c9                	test   %ecx,%ecx
  800e4c:	74 31                	je     800e7f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e4e:	89 f8                	mov    %edi,%eax
  800e50:	09 c8                	or     %ecx,%eax
  800e52:	a8 03                	test   $0x3,%al
  800e54:	75 23                	jne    800e79 <memset+0x3b>
		c &= 0xFF;
  800e56:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e5a:	89 d3                	mov    %edx,%ebx
  800e5c:	c1 e3 08             	shl    $0x8,%ebx
  800e5f:	89 d0                	mov    %edx,%eax
  800e61:	c1 e0 18             	shl    $0x18,%eax
  800e64:	89 d6                	mov    %edx,%esi
  800e66:	c1 e6 10             	shl    $0x10,%esi
  800e69:	09 f0                	or     %esi,%eax
  800e6b:	09 c2                	or     %eax,%edx
  800e6d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e6f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e72:	89 d0                	mov    %edx,%eax
  800e74:	fc                   	cld    
  800e75:	f3 ab                	rep stos %eax,%es:(%edi)
  800e77:	eb 06                	jmp    800e7f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7c:	fc                   	cld    
  800e7d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e7f:	89 f8                	mov    %edi,%eax
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e91:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e94:	39 c6                	cmp    %eax,%esi
  800e96:	73 32                	jae    800eca <memmove+0x44>
  800e98:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e9b:	39 c2                	cmp    %eax,%edx
  800e9d:	76 2b                	jbe    800eca <memmove+0x44>
		s += n;
		d += n;
  800e9f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ea2:	89 fe                	mov    %edi,%esi
  800ea4:	09 ce                	or     %ecx,%esi
  800ea6:	09 d6                	or     %edx,%esi
  800ea8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800eae:	75 0e                	jne    800ebe <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800eb0:	83 ef 04             	sub    $0x4,%edi
  800eb3:	8d 72 fc             	lea    -0x4(%edx),%esi
  800eb6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800eb9:	fd                   	std    
  800eba:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ebc:	eb 09                	jmp    800ec7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ebe:	83 ef 01             	sub    $0x1,%edi
  800ec1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ec4:	fd                   	std    
  800ec5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ec7:	fc                   	cld    
  800ec8:	eb 1a                	jmp    800ee4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eca:	89 c2                	mov    %eax,%edx
  800ecc:	09 ca                	or     %ecx,%edx
  800ece:	09 f2                	or     %esi,%edx
  800ed0:	f6 c2 03             	test   $0x3,%dl
  800ed3:	75 0a                	jne    800edf <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ed5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ed8:	89 c7                	mov    %eax,%edi
  800eda:	fc                   	cld    
  800edb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800edd:	eb 05                	jmp    800ee4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800edf:	89 c7                	mov    %eax,%edi
  800ee1:	fc                   	cld    
  800ee2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ee4:	5e                   	pop    %esi
  800ee5:	5f                   	pop    %edi
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    

00800ee8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800eee:	ff 75 10             	pushl  0x10(%ebp)
  800ef1:	ff 75 0c             	pushl  0xc(%ebp)
  800ef4:	ff 75 08             	pushl  0x8(%ebp)
  800ef7:	e8 8a ff ff ff       	call   800e86 <memmove>
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f09:	89 c6                	mov    %eax,%esi
  800f0b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f0e:	39 f0                	cmp    %esi,%eax
  800f10:	74 1c                	je     800f2e <memcmp+0x30>
		if (*s1 != *s2)
  800f12:	0f b6 08             	movzbl (%eax),%ecx
  800f15:	0f b6 1a             	movzbl (%edx),%ebx
  800f18:	38 d9                	cmp    %bl,%cl
  800f1a:	75 08                	jne    800f24 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f1c:	83 c0 01             	add    $0x1,%eax
  800f1f:	83 c2 01             	add    $0x1,%edx
  800f22:	eb ea                	jmp    800f0e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f24:	0f b6 c1             	movzbl %cl,%eax
  800f27:	0f b6 db             	movzbl %bl,%ebx
  800f2a:	29 d8                	sub    %ebx,%eax
  800f2c:	eb 05                	jmp    800f33 <memcmp+0x35>
	}

	return 0;
  800f2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f40:	89 c2                	mov    %eax,%edx
  800f42:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f45:	39 d0                	cmp    %edx,%eax
  800f47:	73 09                	jae    800f52 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f49:	38 08                	cmp    %cl,(%eax)
  800f4b:	74 05                	je     800f52 <memfind+0x1b>
	for (; s < ends; s++)
  800f4d:	83 c0 01             	add    $0x1,%eax
  800f50:	eb f3                	jmp    800f45 <memfind+0xe>
			break;
	return (void *) s;
}
  800f52:	5d                   	pop    %ebp
  800f53:	c3                   	ret    

00800f54 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	57                   	push   %edi
  800f58:	56                   	push   %esi
  800f59:	53                   	push   %ebx
  800f5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f60:	eb 03                	jmp    800f65 <strtol+0x11>
		s++;
  800f62:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f65:	0f b6 01             	movzbl (%ecx),%eax
  800f68:	3c 20                	cmp    $0x20,%al
  800f6a:	74 f6                	je     800f62 <strtol+0xe>
  800f6c:	3c 09                	cmp    $0x9,%al
  800f6e:	74 f2                	je     800f62 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f70:	3c 2b                	cmp    $0x2b,%al
  800f72:	74 2a                	je     800f9e <strtol+0x4a>
	int neg = 0;
  800f74:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f79:	3c 2d                	cmp    $0x2d,%al
  800f7b:	74 2b                	je     800fa8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f7d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f83:	75 0f                	jne    800f94 <strtol+0x40>
  800f85:	80 39 30             	cmpb   $0x30,(%ecx)
  800f88:	74 28                	je     800fb2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f8a:	85 db                	test   %ebx,%ebx
  800f8c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f91:	0f 44 d8             	cmove  %eax,%ebx
  800f94:	b8 00 00 00 00       	mov    $0x0,%eax
  800f99:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f9c:	eb 50                	jmp    800fee <strtol+0x9a>
		s++;
  800f9e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800fa1:	bf 00 00 00 00       	mov    $0x0,%edi
  800fa6:	eb d5                	jmp    800f7d <strtol+0x29>
		s++, neg = 1;
  800fa8:	83 c1 01             	add    $0x1,%ecx
  800fab:	bf 01 00 00 00       	mov    $0x1,%edi
  800fb0:	eb cb                	jmp    800f7d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800fb6:	74 0e                	je     800fc6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800fb8:	85 db                	test   %ebx,%ebx
  800fba:	75 d8                	jne    800f94 <strtol+0x40>
		s++, base = 8;
  800fbc:	83 c1 01             	add    $0x1,%ecx
  800fbf:	bb 08 00 00 00       	mov    $0x8,%ebx
  800fc4:	eb ce                	jmp    800f94 <strtol+0x40>
		s += 2, base = 16;
  800fc6:	83 c1 02             	add    $0x2,%ecx
  800fc9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800fce:	eb c4                	jmp    800f94 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800fd0:	8d 72 9f             	lea    -0x61(%edx),%esi
  800fd3:	89 f3                	mov    %esi,%ebx
  800fd5:	80 fb 19             	cmp    $0x19,%bl
  800fd8:	77 29                	ja     801003 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800fda:	0f be d2             	movsbl %dl,%edx
  800fdd:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800fe0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800fe3:	7d 30                	jge    801015 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800fe5:	83 c1 01             	add    $0x1,%ecx
  800fe8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fec:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800fee:	0f b6 11             	movzbl (%ecx),%edx
  800ff1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ff4:	89 f3                	mov    %esi,%ebx
  800ff6:	80 fb 09             	cmp    $0x9,%bl
  800ff9:	77 d5                	ja     800fd0 <strtol+0x7c>
			dig = *s - '0';
  800ffb:	0f be d2             	movsbl %dl,%edx
  800ffe:	83 ea 30             	sub    $0x30,%edx
  801001:	eb dd                	jmp    800fe0 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801003:	8d 72 bf             	lea    -0x41(%edx),%esi
  801006:	89 f3                	mov    %esi,%ebx
  801008:	80 fb 19             	cmp    $0x19,%bl
  80100b:	77 08                	ja     801015 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80100d:	0f be d2             	movsbl %dl,%edx
  801010:	83 ea 37             	sub    $0x37,%edx
  801013:	eb cb                	jmp    800fe0 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801015:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801019:	74 05                	je     801020 <strtol+0xcc>
		*endptr = (char *) s;
  80101b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80101e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801020:	89 c2                	mov    %eax,%edx
  801022:	f7 da                	neg    %edx
  801024:	85 ff                	test   %edi,%edi
  801026:	0f 45 c2             	cmovne %edx,%eax
}
  801029:	5b                   	pop    %ebx
  80102a:	5e                   	pop    %esi
  80102b:	5f                   	pop    %edi
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    

0080102e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	57                   	push   %edi
  801032:	56                   	push   %esi
  801033:	53                   	push   %ebx
	asm volatile("int %1\n"
  801034:	b8 00 00 00 00       	mov    $0x0,%eax
  801039:	8b 55 08             	mov    0x8(%ebp),%edx
  80103c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103f:	89 c3                	mov    %eax,%ebx
  801041:	89 c7                	mov    %eax,%edi
  801043:	89 c6                	mov    %eax,%esi
  801045:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801047:	5b                   	pop    %ebx
  801048:	5e                   	pop    %esi
  801049:	5f                   	pop    %edi
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    

0080104c <sys_cgetc>:

int
sys_cgetc(void)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	57                   	push   %edi
  801050:	56                   	push   %esi
  801051:	53                   	push   %ebx
	asm volatile("int %1\n"
  801052:	ba 00 00 00 00       	mov    $0x0,%edx
  801057:	b8 01 00 00 00       	mov    $0x1,%eax
  80105c:	89 d1                	mov    %edx,%ecx
  80105e:	89 d3                	mov    %edx,%ebx
  801060:	89 d7                	mov    %edx,%edi
  801062:	89 d6                	mov    %edx,%esi
  801064:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    

0080106b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	53                   	push   %ebx
  801071:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801074:	b9 00 00 00 00       	mov    $0x0,%ecx
  801079:	8b 55 08             	mov    0x8(%ebp),%edx
  80107c:	b8 03 00 00 00       	mov    $0x3,%eax
  801081:	89 cb                	mov    %ecx,%ebx
  801083:	89 cf                	mov    %ecx,%edi
  801085:	89 ce                	mov    %ecx,%esi
  801087:	cd 30                	int    $0x30
	if(check && ret > 0)
  801089:	85 c0                	test   %eax,%eax
  80108b:	7f 08                	jg     801095 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80108d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801095:	83 ec 0c             	sub    $0xc,%esp
  801098:	50                   	push   %eax
  801099:	6a 03                	push   $0x3
  80109b:	68 df 2c 80 00       	push   $0x802cdf
  8010a0:	6a 23                	push   $0x23
  8010a2:	68 fc 2c 80 00       	push   $0x802cfc
  8010a7:	e8 95 f5 ff ff       	call   800641 <_panic>

008010ac <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	57                   	push   %edi
  8010b0:	56                   	push   %esi
  8010b1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8010bc:	89 d1                	mov    %edx,%ecx
  8010be:	89 d3                	mov    %edx,%ebx
  8010c0:	89 d7                	mov    %edx,%edi
  8010c2:	89 d6                	mov    %edx,%esi
  8010c4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010c6:	5b                   	pop    %ebx
  8010c7:	5e                   	pop    %esi
  8010c8:	5f                   	pop    %edi
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <sys_yield>:

void
sys_yield(void)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	57                   	push   %edi
  8010cf:	56                   	push   %esi
  8010d0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d6:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010db:	89 d1                	mov    %edx,%ecx
  8010dd:	89 d3                	mov    %edx,%ebx
  8010df:	89 d7                	mov    %edx,%edi
  8010e1:	89 d6                	mov    %edx,%esi
  8010e3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5f                   	pop    %edi
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	57                   	push   %edi
  8010ee:	56                   	push   %esi
  8010ef:	53                   	push   %ebx
  8010f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f3:	be 00 00 00 00       	mov    $0x0,%esi
  8010f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fe:	b8 04 00 00 00       	mov    $0x4,%eax
  801103:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801106:	89 f7                	mov    %esi,%edi
  801108:	cd 30                	int    $0x30
	if(check && ret > 0)
  80110a:	85 c0                	test   %eax,%eax
  80110c:	7f 08                	jg     801116 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80110e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5f                   	pop    %edi
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801116:	83 ec 0c             	sub    $0xc,%esp
  801119:	50                   	push   %eax
  80111a:	6a 04                	push   $0x4
  80111c:	68 df 2c 80 00       	push   $0x802cdf
  801121:	6a 23                	push   $0x23
  801123:	68 fc 2c 80 00       	push   $0x802cfc
  801128:	e8 14 f5 ff ff       	call   800641 <_panic>

0080112d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	57                   	push   %edi
  801131:	56                   	push   %esi
  801132:	53                   	push   %ebx
  801133:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801136:	8b 55 08             	mov    0x8(%ebp),%edx
  801139:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113c:	b8 05 00 00 00       	mov    $0x5,%eax
  801141:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801144:	8b 7d 14             	mov    0x14(%ebp),%edi
  801147:	8b 75 18             	mov    0x18(%ebp),%esi
  80114a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80114c:	85 c0                	test   %eax,%eax
  80114e:	7f 08                	jg     801158 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801153:	5b                   	pop    %ebx
  801154:	5e                   	pop    %esi
  801155:	5f                   	pop    %edi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801158:	83 ec 0c             	sub    $0xc,%esp
  80115b:	50                   	push   %eax
  80115c:	6a 05                	push   $0x5
  80115e:	68 df 2c 80 00       	push   $0x802cdf
  801163:	6a 23                	push   $0x23
  801165:	68 fc 2c 80 00       	push   $0x802cfc
  80116a:	e8 d2 f4 ff ff       	call   800641 <_panic>

0080116f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	57                   	push   %edi
  801173:	56                   	push   %esi
  801174:	53                   	push   %ebx
  801175:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801178:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117d:	8b 55 08             	mov    0x8(%ebp),%edx
  801180:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801183:	b8 06 00 00 00       	mov    $0x6,%eax
  801188:	89 df                	mov    %ebx,%edi
  80118a:	89 de                	mov    %ebx,%esi
  80118c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80118e:	85 c0                	test   %eax,%eax
  801190:	7f 08                	jg     80119a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801192:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5f                   	pop    %edi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80119a:	83 ec 0c             	sub    $0xc,%esp
  80119d:	50                   	push   %eax
  80119e:	6a 06                	push   $0x6
  8011a0:	68 df 2c 80 00       	push   $0x802cdf
  8011a5:	6a 23                	push   $0x23
  8011a7:	68 fc 2c 80 00       	push   $0x802cfc
  8011ac:	e8 90 f4 ff ff       	call   800641 <_panic>

008011b1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	57                   	push   %edi
  8011b5:	56                   	push   %esi
  8011b6:	53                   	push   %ebx
  8011b7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8011ca:	89 df                	mov    %ebx,%edi
  8011cc:	89 de                	mov    %ebx,%esi
  8011ce:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	7f 08                	jg     8011dc <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d7:	5b                   	pop    %ebx
  8011d8:	5e                   	pop    %esi
  8011d9:	5f                   	pop    %edi
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011dc:	83 ec 0c             	sub    $0xc,%esp
  8011df:	50                   	push   %eax
  8011e0:	6a 08                	push   $0x8
  8011e2:	68 df 2c 80 00       	push   $0x802cdf
  8011e7:	6a 23                	push   $0x23
  8011e9:	68 fc 2c 80 00       	push   $0x802cfc
  8011ee:	e8 4e f4 ff ff       	call   800641 <_panic>

008011f3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	57                   	push   %edi
  8011f7:	56                   	push   %esi
  8011f8:	53                   	push   %ebx
  8011f9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801201:	8b 55 08             	mov    0x8(%ebp),%edx
  801204:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801207:	b8 09 00 00 00       	mov    $0x9,%eax
  80120c:	89 df                	mov    %ebx,%edi
  80120e:	89 de                	mov    %ebx,%esi
  801210:	cd 30                	int    $0x30
	if(check && ret > 0)
  801212:	85 c0                	test   %eax,%eax
  801214:	7f 08                	jg     80121e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801216:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801219:	5b                   	pop    %ebx
  80121a:	5e                   	pop    %esi
  80121b:	5f                   	pop    %edi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80121e:	83 ec 0c             	sub    $0xc,%esp
  801221:	50                   	push   %eax
  801222:	6a 09                	push   $0x9
  801224:	68 df 2c 80 00       	push   $0x802cdf
  801229:	6a 23                	push   $0x23
  80122b:	68 fc 2c 80 00       	push   $0x802cfc
  801230:	e8 0c f4 ff ff       	call   800641 <_panic>

00801235 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	57                   	push   %edi
  801239:	56                   	push   %esi
  80123a:	53                   	push   %ebx
  80123b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80123e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801243:	8b 55 08             	mov    0x8(%ebp),%edx
  801246:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801249:	b8 0a 00 00 00       	mov    $0xa,%eax
  80124e:	89 df                	mov    %ebx,%edi
  801250:	89 de                	mov    %ebx,%esi
  801252:	cd 30                	int    $0x30
	if(check && ret > 0)
  801254:	85 c0                	test   %eax,%eax
  801256:	7f 08                	jg     801260 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125b:	5b                   	pop    %ebx
  80125c:	5e                   	pop    %esi
  80125d:	5f                   	pop    %edi
  80125e:	5d                   	pop    %ebp
  80125f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801260:	83 ec 0c             	sub    $0xc,%esp
  801263:	50                   	push   %eax
  801264:	6a 0a                	push   $0xa
  801266:	68 df 2c 80 00       	push   $0x802cdf
  80126b:	6a 23                	push   $0x23
  80126d:	68 fc 2c 80 00       	push   $0x802cfc
  801272:	e8 ca f3 ff ff       	call   800641 <_panic>

00801277 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	57                   	push   %edi
  80127b:	56                   	push   %esi
  80127c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80127d:	8b 55 08             	mov    0x8(%ebp),%edx
  801280:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801283:	b8 0c 00 00 00       	mov    $0xc,%eax
  801288:	be 00 00 00 00       	mov    $0x0,%esi
  80128d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801290:	8b 7d 14             	mov    0x14(%ebp),%edi
  801293:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801295:	5b                   	pop    %ebx
  801296:	5e                   	pop    %esi
  801297:	5f                   	pop    %edi
  801298:	5d                   	pop    %ebp
  801299:	c3                   	ret    

0080129a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	57                   	push   %edi
  80129e:	56                   	push   %esi
  80129f:	53                   	push   %ebx
  8012a0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ab:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012b0:	89 cb                	mov    %ecx,%ebx
  8012b2:	89 cf                	mov    %ecx,%edi
  8012b4:	89 ce                	mov    %ecx,%esi
  8012b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	7f 08                	jg     8012c4 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012bf:	5b                   	pop    %ebx
  8012c0:	5e                   	pop    %esi
  8012c1:	5f                   	pop    %edi
  8012c2:	5d                   	pop    %ebp
  8012c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c4:	83 ec 0c             	sub    $0xc,%esp
  8012c7:	50                   	push   %eax
  8012c8:	6a 0d                	push   $0xd
  8012ca:	68 df 2c 80 00       	push   $0x802cdf
  8012cf:	6a 23                	push   $0x23
  8012d1:	68 fc 2c 80 00       	push   $0x802cfc
  8012d6:	e8 66 f3 ff ff       	call   800641 <_panic>

008012db <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	57                   	push   %edi
  8012df:	56                   	push   %esi
  8012e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012eb:	89 d1                	mov    %edx,%ecx
  8012ed:	89 d3                	mov    %edx,%ebx
  8012ef:	89 d7                	mov    %edx,%edi
  8012f1:	89 d6                	mov    %edx,%esi
  8012f3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012f5:	5b                   	pop    %ebx
  8012f6:	5e                   	pop    %esi
  8012f7:	5f                   	pop    %edi
  8012f8:	5d                   	pop    %ebp
  8012f9:	c3                   	ret    

008012fa <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801300:	83 3d b8 40 80 00 00 	cmpl   $0x0,0x8040b8
  801307:	74 0a                	je     801313 <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	a3 b8 40 80 00       	mov    %eax,0x8040b8
}
  801311:	c9                   	leave  
  801312:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  801313:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  801318:	8b 40 48             	mov    0x48(%eax),%eax
  80131b:	83 ec 04             	sub    $0x4,%esp
  80131e:	6a 07                	push   $0x7
  801320:	68 00 f0 bf ee       	push   $0xeebff000
  801325:	50                   	push   %eax
  801326:	e8 bf fd ff ff       	call   8010ea <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	78 2c                	js     80135e <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801332:	e8 75 fd ff ff       	call   8010ac <sys_getenvid>
  801337:	83 ec 08             	sub    $0x8,%esp
  80133a:	68 70 13 80 00       	push   $0x801370
  80133f:	50                   	push   %eax
  801340:	e8 f0 fe ff ff       	call   801235 <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	79 bd                	jns    801309 <set_pgfault_handler+0xf>
  80134c:	50                   	push   %eax
  80134d:	68 0a 2d 80 00       	push   $0x802d0a
  801352:	6a 23                	push   $0x23
  801354:	68 22 2d 80 00       	push   $0x802d22
  801359:	e8 e3 f2 ff ff       	call   800641 <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  80135e:	50                   	push   %eax
  80135f:	68 0a 2d 80 00       	push   $0x802d0a
  801364:	6a 21                	push   $0x21
  801366:	68 22 2d 80 00       	push   $0x802d22
  80136b:	e8 d1 f2 ff ff       	call   800641 <_panic>

00801370 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801370:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801371:	a1 b8 40 80 00       	mov    0x8040b8,%eax
	call *%eax
  801376:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801378:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  80137b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  80137f:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  801382:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  801386:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  80138a:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80138d:	83 c4 08             	add    $0x8,%esp
	popal
  801390:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  801391:	83 c4 04             	add    $0x4,%esp
	popfl
  801394:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801395:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801396:	c3                   	ret    

00801397 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	05 00 00 00 30       	add    $0x30000000,%eax
  8013a2:	c1 e8 0c             	shr    $0xc,%eax
}
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013bc:	5d                   	pop    %ebp
  8013bd:	c3                   	ret    

008013be <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013c6:	89 c2                	mov    %eax,%edx
  8013c8:	c1 ea 16             	shr    $0x16,%edx
  8013cb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013d2:	f6 c2 01             	test   $0x1,%dl
  8013d5:	74 2d                	je     801404 <fd_alloc+0x46>
  8013d7:	89 c2                	mov    %eax,%edx
  8013d9:	c1 ea 0c             	shr    $0xc,%edx
  8013dc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013e3:	f6 c2 01             	test   $0x1,%dl
  8013e6:	74 1c                	je     801404 <fd_alloc+0x46>
  8013e8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013ed:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013f2:	75 d2                	jne    8013c6 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013fd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801402:	eb 0a                	jmp    80140e <fd_alloc+0x50>
			*fd_store = fd;
  801404:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801407:	89 01                	mov    %eax,(%ecx)
			return 0;
  801409:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140e:	5d                   	pop    %ebp
  80140f:	c3                   	ret    

00801410 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801416:	83 f8 1f             	cmp    $0x1f,%eax
  801419:	77 30                	ja     80144b <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80141b:	c1 e0 0c             	shl    $0xc,%eax
  80141e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801423:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801429:	f6 c2 01             	test   $0x1,%dl
  80142c:	74 24                	je     801452 <fd_lookup+0x42>
  80142e:	89 c2                	mov    %eax,%edx
  801430:	c1 ea 0c             	shr    $0xc,%edx
  801433:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80143a:	f6 c2 01             	test   $0x1,%dl
  80143d:	74 1a                	je     801459 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80143f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801442:	89 02                	mov    %eax,(%edx)
	return 0;
  801444:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801449:	5d                   	pop    %ebp
  80144a:	c3                   	ret    
		return -E_INVAL;
  80144b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801450:	eb f7                	jmp    801449 <fd_lookup+0x39>
		return -E_INVAL;
  801452:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801457:	eb f0                	jmp    801449 <fd_lookup+0x39>
  801459:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145e:	eb e9                	jmp    801449 <fd_lookup+0x39>

00801460 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 08             	sub    $0x8,%esp
  801466:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801469:	ba 00 00 00 00       	mov    $0x0,%edx
  80146e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801473:	39 08                	cmp    %ecx,(%eax)
  801475:	74 38                	je     8014af <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801477:	83 c2 01             	add    $0x1,%edx
  80147a:	8b 04 95 ac 2d 80 00 	mov    0x802dac(,%edx,4),%eax
  801481:	85 c0                	test   %eax,%eax
  801483:	75 ee                	jne    801473 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801485:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  80148a:	8b 40 48             	mov    0x48(%eax),%eax
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	51                   	push   %ecx
  801491:	50                   	push   %eax
  801492:	68 30 2d 80 00       	push   $0x802d30
  801497:	e8 80 f2 ff ff       	call   80071c <cprintf>
	*dev = 0;
  80149c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    
			*dev = devtab[i];
  8014af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b9:	eb f2                	jmp    8014ad <dev_lookup+0x4d>

008014bb <fd_close>:
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	57                   	push   %edi
  8014bf:	56                   	push   %esi
  8014c0:	53                   	push   %ebx
  8014c1:	83 ec 24             	sub    $0x24,%esp
  8014c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8014c7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014cd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014ce:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014d4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d7:	50                   	push   %eax
  8014d8:	e8 33 ff ff ff       	call   801410 <fd_lookup>
  8014dd:	89 c3                	mov    %eax,%ebx
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	78 05                	js     8014eb <fd_close+0x30>
	    || fd != fd2)
  8014e6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014e9:	74 16                	je     801501 <fd_close+0x46>
		return (must_exist ? r : 0);
  8014eb:	89 f8                	mov    %edi,%eax
  8014ed:	84 c0                	test   %al,%al
  8014ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f4:	0f 44 d8             	cmove  %eax,%ebx
}
  8014f7:	89 d8                	mov    %ebx,%eax
  8014f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014fc:	5b                   	pop    %ebx
  8014fd:	5e                   	pop    %esi
  8014fe:	5f                   	pop    %edi
  8014ff:	5d                   	pop    %ebp
  801500:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801501:	83 ec 08             	sub    $0x8,%esp
  801504:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801507:	50                   	push   %eax
  801508:	ff 36                	pushl  (%esi)
  80150a:	e8 51 ff ff ff       	call   801460 <dev_lookup>
  80150f:	89 c3                	mov    %eax,%ebx
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	85 c0                	test   %eax,%eax
  801516:	78 1a                	js     801532 <fd_close+0x77>
		if (dev->dev_close)
  801518:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80151e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801523:	85 c0                	test   %eax,%eax
  801525:	74 0b                	je     801532 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801527:	83 ec 0c             	sub    $0xc,%esp
  80152a:	56                   	push   %esi
  80152b:	ff d0                	call   *%eax
  80152d:	89 c3                	mov    %eax,%ebx
  80152f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801532:	83 ec 08             	sub    $0x8,%esp
  801535:	56                   	push   %esi
  801536:	6a 00                	push   $0x0
  801538:	e8 32 fc ff ff       	call   80116f <sys_page_unmap>
	return r;
  80153d:	83 c4 10             	add    $0x10,%esp
  801540:	eb b5                	jmp    8014f7 <fd_close+0x3c>

00801542 <close>:

int
close(int fdnum)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801548:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154b:	50                   	push   %eax
  80154c:	ff 75 08             	pushl  0x8(%ebp)
  80154f:	e8 bc fe ff ff       	call   801410 <fd_lookup>
  801554:	83 c4 10             	add    $0x10,%esp
  801557:	85 c0                	test   %eax,%eax
  801559:	79 02                	jns    80155d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    
		return fd_close(fd, 1);
  80155d:	83 ec 08             	sub    $0x8,%esp
  801560:	6a 01                	push   $0x1
  801562:	ff 75 f4             	pushl  -0xc(%ebp)
  801565:	e8 51 ff ff ff       	call   8014bb <fd_close>
  80156a:	83 c4 10             	add    $0x10,%esp
  80156d:	eb ec                	jmp    80155b <close+0x19>

0080156f <close_all>:

void
close_all(void)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	53                   	push   %ebx
  801573:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801576:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80157b:	83 ec 0c             	sub    $0xc,%esp
  80157e:	53                   	push   %ebx
  80157f:	e8 be ff ff ff       	call   801542 <close>
	for (i = 0; i < MAXFD; i++)
  801584:	83 c3 01             	add    $0x1,%ebx
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	83 fb 20             	cmp    $0x20,%ebx
  80158d:	75 ec                	jne    80157b <close_all+0xc>
}
  80158f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	57                   	push   %edi
  801598:	56                   	push   %esi
  801599:	53                   	push   %ebx
  80159a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80159d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015a0:	50                   	push   %eax
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 67 fe ff ff       	call   801410 <fd_lookup>
  8015a9:	89 c3                	mov    %eax,%ebx
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	0f 88 81 00 00 00    	js     801637 <dup+0xa3>
		return r;
	close(newfdnum);
  8015b6:	83 ec 0c             	sub    $0xc,%esp
  8015b9:	ff 75 0c             	pushl  0xc(%ebp)
  8015bc:	e8 81 ff ff ff       	call   801542 <close>

	newfd = INDEX2FD(newfdnum);
  8015c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015c4:	c1 e6 0c             	shl    $0xc,%esi
  8015c7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015cd:	83 c4 04             	add    $0x4,%esp
  8015d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015d3:	e8 cf fd ff ff       	call   8013a7 <fd2data>
  8015d8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015da:	89 34 24             	mov    %esi,(%esp)
  8015dd:	e8 c5 fd ff ff       	call   8013a7 <fd2data>
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015e7:	89 d8                	mov    %ebx,%eax
  8015e9:	c1 e8 16             	shr    $0x16,%eax
  8015ec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015f3:	a8 01                	test   $0x1,%al
  8015f5:	74 11                	je     801608 <dup+0x74>
  8015f7:	89 d8                	mov    %ebx,%eax
  8015f9:	c1 e8 0c             	shr    $0xc,%eax
  8015fc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801603:	f6 c2 01             	test   $0x1,%dl
  801606:	75 39                	jne    801641 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801608:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80160b:	89 d0                	mov    %edx,%eax
  80160d:	c1 e8 0c             	shr    $0xc,%eax
  801610:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801617:	83 ec 0c             	sub    $0xc,%esp
  80161a:	25 07 0e 00 00       	and    $0xe07,%eax
  80161f:	50                   	push   %eax
  801620:	56                   	push   %esi
  801621:	6a 00                	push   $0x0
  801623:	52                   	push   %edx
  801624:	6a 00                	push   $0x0
  801626:	e8 02 fb ff ff       	call   80112d <sys_page_map>
  80162b:	89 c3                	mov    %eax,%ebx
  80162d:	83 c4 20             	add    $0x20,%esp
  801630:	85 c0                	test   %eax,%eax
  801632:	78 31                	js     801665 <dup+0xd1>
		goto err;

	return newfdnum;
  801634:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801637:	89 d8                	mov    %ebx,%eax
  801639:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80163c:	5b                   	pop    %ebx
  80163d:	5e                   	pop    %esi
  80163e:	5f                   	pop    %edi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801641:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801648:	83 ec 0c             	sub    $0xc,%esp
  80164b:	25 07 0e 00 00       	and    $0xe07,%eax
  801650:	50                   	push   %eax
  801651:	57                   	push   %edi
  801652:	6a 00                	push   $0x0
  801654:	53                   	push   %ebx
  801655:	6a 00                	push   $0x0
  801657:	e8 d1 fa ff ff       	call   80112d <sys_page_map>
  80165c:	89 c3                	mov    %eax,%ebx
  80165e:	83 c4 20             	add    $0x20,%esp
  801661:	85 c0                	test   %eax,%eax
  801663:	79 a3                	jns    801608 <dup+0x74>
	sys_page_unmap(0, newfd);
  801665:	83 ec 08             	sub    $0x8,%esp
  801668:	56                   	push   %esi
  801669:	6a 00                	push   $0x0
  80166b:	e8 ff fa ff ff       	call   80116f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801670:	83 c4 08             	add    $0x8,%esp
  801673:	57                   	push   %edi
  801674:	6a 00                	push   $0x0
  801676:	e8 f4 fa ff ff       	call   80116f <sys_page_unmap>
	return r;
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	eb b7                	jmp    801637 <dup+0xa3>

00801680 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	53                   	push   %ebx
  801684:	83 ec 1c             	sub    $0x1c,%esp
  801687:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80168a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80168d:	50                   	push   %eax
  80168e:	53                   	push   %ebx
  80168f:	e8 7c fd ff ff       	call   801410 <fd_lookup>
  801694:	83 c4 10             	add    $0x10,%esp
  801697:	85 c0                	test   %eax,%eax
  801699:	78 3f                	js     8016da <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a1:	50                   	push   %eax
  8016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a5:	ff 30                	pushl  (%eax)
  8016a7:	e8 b4 fd ff ff       	call   801460 <dev_lookup>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	78 27                	js     8016da <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016b6:	8b 42 08             	mov    0x8(%edx),%eax
  8016b9:	83 e0 03             	and    $0x3,%eax
  8016bc:	83 f8 01             	cmp    $0x1,%eax
  8016bf:	74 1e                	je     8016df <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c4:	8b 40 08             	mov    0x8(%eax),%eax
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	74 35                	je     801700 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016cb:	83 ec 04             	sub    $0x4,%esp
  8016ce:	ff 75 10             	pushl  0x10(%ebp)
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	52                   	push   %edx
  8016d5:	ff d0                	call   *%eax
  8016d7:	83 c4 10             	add    $0x10,%esp
}
  8016da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016df:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  8016e4:	8b 40 48             	mov    0x48(%eax),%eax
  8016e7:	83 ec 04             	sub    $0x4,%esp
  8016ea:	53                   	push   %ebx
  8016eb:	50                   	push   %eax
  8016ec:	68 71 2d 80 00       	push   $0x802d71
  8016f1:	e8 26 f0 ff ff       	call   80071c <cprintf>
		return -E_INVAL;
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016fe:	eb da                	jmp    8016da <read+0x5a>
		return -E_NOT_SUPP;
  801700:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801705:	eb d3                	jmp    8016da <read+0x5a>

00801707 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	57                   	push   %edi
  80170b:	56                   	push   %esi
  80170c:	53                   	push   %ebx
  80170d:	83 ec 0c             	sub    $0xc,%esp
  801710:	8b 7d 08             	mov    0x8(%ebp),%edi
  801713:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801716:	bb 00 00 00 00       	mov    $0x0,%ebx
  80171b:	39 f3                	cmp    %esi,%ebx
  80171d:	73 23                	jae    801742 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80171f:	83 ec 04             	sub    $0x4,%esp
  801722:	89 f0                	mov    %esi,%eax
  801724:	29 d8                	sub    %ebx,%eax
  801726:	50                   	push   %eax
  801727:	89 d8                	mov    %ebx,%eax
  801729:	03 45 0c             	add    0xc(%ebp),%eax
  80172c:	50                   	push   %eax
  80172d:	57                   	push   %edi
  80172e:	e8 4d ff ff ff       	call   801680 <read>
		if (m < 0)
  801733:	83 c4 10             	add    $0x10,%esp
  801736:	85 c0                	test   %eax,%eax
  801738:	78 06                	js     801740 <readn+0x39>
			return m;
		if (m == 0)
  80173a:	74 06                	je     801742 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80173c:	01 c3                	add    %eax,%ebx
  80173e:	eb db                	jmp    80171b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801740:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801742:	89 d8                	mov    %ebx,%eax
  801744:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801747:	5b                   	pop    %ebx
  801748:	5e                   	pop    %esi
  801749:	5f                   	pop    %edi
  80174a:	5d                   	pop    %ebp
  80174b:	c3                   	ret    

0080174c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	53                   	push   %ebx
  801750:	83 ec 1c             	sub    $0x1c,%esp
  801753:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801756:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801759:	50                   	push   %eax
  80175a:	53                   	push   %ebx
  80175b:	e8 b0 fc ff ff       	call   801410 <fd_lookup>
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	85 c0                	test   %eax,%eax
  801765:	78 3a                	js     8017a1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801767:	83 ec 08             	sub    $0x8,%esp
  80176a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176d:	50                   	push   %eax
  80176e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801771:	ff 30                	pushl  (%eax)
  801773:	e8 e8 fc ff ff       	call   801460 <dev_lookup>
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	85 c0                	test   %eax,%eax
  80177d:	78 22                	js     8017a1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80177f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801782:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801786:	74 1e                	je     8017a6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801788:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178b:	8b 52 0c             	mov    0xc(%edx),%edx
  80178e:	85 d2                	test   %edx,%edx
  801790:	74 35                	je     8017c7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801792:	83 ec 04             	sub    $0x4,%esp
  801795:	ff 75 10             	pushl  0x10(%ebp)
  801798:	ff 75 0c             	pushl  0xc(%ebp)
  80179b:	50                   	push   %eax
  80179c:	ff d2                	call   *%edx
  80179e:	83 c4 10             	add    $0x10,%esp
}
  8017a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017a6:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  8017ab:	8b 40 48             	mov    0x48(%eax),%eax
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	53                   	push   %ebx
  8017b2:	50                   	push   %eax
  8017b3:	68 8d 2d 80 00       	push   $0x802d8d
  8017b8:	e8 5f ef ff ff       	call   80071c <cprintf>
		return -E_INVAL;
  8017bd:	83 c4 10             	add    $0x10,%esp
  8017c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c5:	eb da                	jmp    8017a1 <write+0x55>
		return -E_NOT_SUPP;
  8017c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017cc:	eb d3                	jmp    8017a1 <write+0x55>

008017ce <seek>:

int
seek(int fdnum, off_t offset)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d7:	50                   	push   %eax
  8017d8:	ff 75 08             	pushl  0x8(%ebp)
  8017db:	e8 30 fc ff ff       	call   801410 <fd_lookup>
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	78 0e                	js     8017f5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ed:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	53                   	push   %ebx
  8017fb:	83 ec 1c             	sub    $0x1c,%esp
  8017fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801801:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801804:	50                   	push   %eax
  801805:	53                   	push   %ebx
  801806:	e8 05 fc ff ff       	call   801410 <fd_lookup>
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	85 c0                	test   %eax,%eax
  801810:	78 37                	js     801849 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801812:	83 ec 08             	sub    $0x8,%esp
  801815:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801818:	50                   	push   %eax
  801819:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181c:	ff 30                	pushl  (%eax)
  80181e:	e8 3d fc ff ff       	call   801460 <dev_lookup>
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	85 c0                	test   %eax,%eax
  801828:	78 1f                	js     801849 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80182a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801831:	74 1b                	je     80184e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801836:	8b 52 18             	mov    0x18(%edx),%edx
  801839:	85 d2                	test   %edx,%edx
  80183b:	74 32                	je     80186f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80183d:	83 ec 08             	sub    $0x8,%esp
  801840:	ff 75 0c             	pushl  0xc(%ebp)
  801843:	50                   	push   %eax
  801844:	ff d2                	call   *%edx
  801846:	83 c4 10             	add    $0x10,%esp
}
  801849:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80184e:	a1 b4 40 80 00       	mov    0x8040b4,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801853:	8b 40 48             	mov    0x48(%eax),%eax
  801856:	83 ec 04             	sub    $0x4,%esp
  801859:	53                   	push   %ebx
  80185a:	50                   	push   %eax
  80185b:	68 50 2d 80 00       	push   $0x802d50
  801860:	e8 b7 ee ff ff       	call   80071c <cprintf>
		return -E_INVAL;
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80186d:	eb da                	jmp    801849 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80186f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801874:	eb d3                	jmp    801849 <ftruncate+0x52>

00801876 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	53                   	push   %ebx
  80187a:	83 ec 1c             	sub    $0x1c,%esp
  80187d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801880:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801883:	50                   	push   %eax
  801884:	ff 75 08             	pushl  0x8(%ebp)
  801887:	e8 84 fb ff ff       	call   801410 <fd_lookup>
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	85 c0                	test   %eax,%eax
  801891:	78 4b                	js     8018de <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801893:	83 ec 08             	sub    $0x8,%esp
  801896:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801899:	50                   	push   %eax
  80189a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189d:	ff 30                	pushl  (%eax)
  80189f:	e8 bc fb ff ff       	call   801460 <dev_lookup>
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	78 33                	js     8018de <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ae:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018b2:	74 2f                	je     8018e3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018b4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018b7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018be:	00 00 00 
	stat->st_isdir = 0;
  8018c1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018c8:	00 00 00 
	stat->st_dev = dev;
  8018cb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018d1:	83 ec 08             	sub    $0x8,%esp
  8018d4:	53                   	push   %ebx
  8018d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8018d8:	ff 50 14             	call   *0x14(%eax)
  8018db:	83 c4 10             	add    $0x10,%esp
}
  8018de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    
		return -E_NOT_SUPP;
  8018e3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018e8:	eb f4                	jmp    8018de <fstat+0x68>

008018ea <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	56                   	push   %esi
  8018ee:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018ef:	83 ec 08             	sub    $0x8,%esp
  8018f2:	6a 00                	push   $0x0
  8018f4:	ff 75 08             	pushl  0x8(%ebp)
  8018f7:	e8 2f 02 00 00       	call   801b2b <open>
  8018fc:	89 c3                	mov    %eax,%ebx
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	85 c0                	test   %eax,%eax
  801903:	78 1b                	js     801920 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801905:	83 ec 08             	sub    $0x8,%esp
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	50                   	push   %eax
  80190c:	e8 65 ff ff ff       	call   801876 <fstat>
  801911:	89 c6                	mov    %eax,%esi
	close(fd);
  801913:	89 1c 24             	mov    %ebx,(%esp)
  801916:	e8 27 fc ff ff       	call   801542 <close>
	return r;
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	89 f3                	mov    %esi,%ebx
}
  801920:	89 d8                	mov    %ebx,%eax
  801922:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801925:	5b                   	pop    %ebx
  801926:	5e                   	pop    %esi
  801927:	5d                   	pop    %ebp
  801928:	c3                   	ret    

00801929 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	56                   	push   %esi
  80192d:	53                   	push   %ebx
  80192e:	89 c6                	mov    %eax,%esi
  801930:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801932:	83 3d ac 40 80 00 00 	cmpl   $0x0,0x8040ac
  801939:	74 27                	je     801962 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80193b:	6a 07                	push   $0x7
  80193d:	68 00 50 80 00       	push   $0x805000
  801942:	56                   	push   %esi
  801943:	ff 35 ac 40 80 00    	pushl  0x8040ac
  801949:	e8 1f 0c 00 00       	call   80256d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80194e:	83 c4 0c             	add    $0xc,%esp
  801951:	6a 00                	push   $0x0
  801953:	53                   	push   %ebx
  801954:	6a 00                	push   $0x0
  801956:	e8 9f 0b 00 00       	call   8024fa <ipc_recv>
}
  80195b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195e:	5b                   	pop    %ebx
  80195f:	5e                   	pop    %esi
  801960:	5d                   	pop    %ebp
  801961:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801962:	83 ec 0c             	sub    $0xc,%esp
  801965:	6a 01                	push   $0x1
  801967:	e8 6d 0c 00 00       	call   8025d9 <ipc_find_env>
  80196c:	a3 ac 40 80 00       	mov    %eax,0x8040ac
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	eb c5                	jmp    80193b <fsipc+0x12>

00801976 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	8b 40 0c             	mov    0xc(%eax),%eax
  801982:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80198f:	ba 00 00 00 00       	mov    $0x0,%edx
  801994:	b8 02 00 00 00       	mov    $0x2,%eax
  801999:	e8 8b ff ff ff       	call   801929 <fsipc>
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <devfile_flush>:
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ac:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b6:	b8 06 00 00 00       	mov    $0x6,%eax
  8019bb:	e8 69 ff ff ff       	call   801929 <fsipc>
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <devfile_stat>:
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	53                   	push   %ebx
  8019c6:	83 ec 04             	sub    $0x4,%esp
  8019c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019dc:	b8 05 00 00 00       	mov    $0x5,%eax
  8019e1:	e8 43 ff ff ff       	call   801929 <fsipc>
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 2c                	js     801a16 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019ea:	83 ec 08             	sub    $0x8,%esp
  8019ed:	68 00 50 80 00       	push   $0x805000
  8019f2:	53                   	push   %ebx
  8019f3:	e8 00 f3 ff ff       	call   800cf8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019f8:	a1 80 50 80 00       	mov    0x805080,%eax
  8019fd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a03:	a1 84 50 80 00       	mov    0x805084,%eax
  801a08:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a0e:	83 c4 10             	add    $0x10,%esp
  801a11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <devfile_write>:
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	53                   	push   %ebx
  801a1f:	83 ec 04             	sub    $0x4,%esp
  801a22:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  801a25:	85 db                	test   %ebx,%ebx
  801a27:	75 07                	jne    801a30 <devfile_write+0x15>
	return n_all;
  801a29:	89 d8                	mov    %ebx,%eax
}
  801a2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	8b 40 0c             	mov    0xc(%eax),%eax
  801a36:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  801a3b:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  801a41:	83 ec 04             	sub    $0x4,%esp
  801a44:	53                   	push   %ebx
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	68 08 50 80 00       	push   $0x805008
  801a4d:	e8 34 f4 ff ff       	call   800e86 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a52:	ba 00 00 00 00       	mov    $0x0,%edx
  801a57:	b8 04 00 00 00       	mov    $0x4,%eax
  801a5c:	e8 c8 fe ff ff       	call   801929 <fsipc>
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	85 c0                	test   %eax,%eax
  801a66:	78 c3                	js     801a2b <devfile_write+0x10>
	  assert(r <= n_left);
  801a68:	39 d8                	cmp    %ebx,%eax
  801a6a:	77 0b                	ja     801a77 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  801a6c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a71:	7f 1d                	jg     801a90 <devfile_write+0x75>
    n_all += r;
  801a73:	89 c3                	mov    %eax,%ebx
  801a75:	eb b2                	jmp    801a29 <devfile_write+0xe>
	  assert(r <= n_left);
  801a77:	68 c0 2d 80 00       	push   $0x802dc0
  801a7c:	68 cc 2d 80 00       	push   $0x802dcc
  801a81:	68 9f 00 00 00       	push   $0x9f
  801a86:	68 e1 2d 80 00       	push   $0x802de1
  801a8b:	e8 b1 eb ff ff       	call   800641 <_panic>
	  assert(r <= PGSIZE);
  801a90:	68 ec 2d 80 00       	push   $0x802dec
  801a95:	68 cc 2d 80 00       	push   $0x802dcc
  801a9a:	68 a0 00 00 00       	push   $0xa0
  801a9f:	68 e1 2d 80 00       	push   $0x802de1
  801aa4:	e8 98 eb ff ff       	call   800641 <_panic>

00801aa9 <devfile_read>:
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	56                   	push   %esi
  801aad:	53                   	push   %ebx
  801aae:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801abc:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac7:	b8 03 00 00 00       	mov    $0x3,%eax
  801acc:	e8 58 fe ff ff       	call   801929 <fsipc>
  801ad1:	89 c3                	mov    %eax,%ebx
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	78 1f                	js     801af6 <devfile_read+0x4d>
	assert(r <= n);
  801ad7:	39 f0                	cmp    %esi,%eax
  801ad9:	77 24                	ja     801aff <devfile_read+0x56>
	assert(r <= PGSIZE);
  801adb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ae0:	7f 33                	jg     801b15 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ae2:	83 ec 04             	sub    $0x4,%esp
  801ae5:	50                   	push   %eax
  801ae6:	68 00 50 80 00       	push   $0x805000
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	e8 93 f3 ff ff       	call   800e86 <memmove>
	return r;
  801af3:	83 c4 10             	add    $0x10,%esp
}
  801af6:	89 d8                	mov    %ebx,%eax
  801af8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afb:	5b                   	pop    %ebx
  801afc:	5e                   	pop    %esi
  801afd:	5d                   	pop    %ebp
  801afe:	c3                   	ret    
	assert(r <= n);
  801aff:	68 f8 2d 80 00       	push   $0x802df8
  801b04:	68 cc 2d 80 00       	push   $0x802dcc
  801b09:	6a 7c                	push   $0x7c
  801b0b:	68 e1 2d 80 00       	push   $0x802de1
  801b10:	e8 2c eb ff ff       	call   800641 <_panic>
	assert(r <= PGSIZE);
  801b15:	68 ec 2d 80 00       	push   $0x802dec
  801b1a:	68 cc 2d 80 00       	push   $0x802dcc
  801b1f:	6a 7d                	push   $0x7d
  801b21:	68 e1 2d 80 00       	push   $0x802de1
  801b26:	e8 16 eb ff ff       	call   800641 <_panic>

00801b2b <open>:
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	56                   	push   %esi
  801b2f:	53                   	push   %ebx
  801b30:	83 ec 1c             	sub    $0x1c,%esp
  801b33:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b36:	56                   	push   %esi
  801b37:	e8 83 f1 ff ff       	call   800cbf <strlen>
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b44:	7f 6c                	jg     801bb2 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b46:	83 ec 0c             	sub    $0xc,%esp
  801b49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b4c:	50                   	push   %eax
  801b4d:	e8 6c f8 ff ff       	call   8013be <fd_alloc>
  801b52:	89 c3                	mov    %eax,%ebx
  801b54:	83 c4 10             	add    $0x10,%esp
  801b57:	85 c0                	test   %eax,%eax
  801b59:	78 3c                	js     801b97 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b5b:	83 ec 08             	sub    $0x8,%esp
  801b5e:	56                   	push   %esi
  801b5f:	68 00 50 80 00       	push   $0x805000
  801b64:	e8 8f f1 ff ff       	call   800cf8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b74:	b8 01 00 00 00       	mov    $0x1,%eax
  801b79:	e8 ab fd ff ff       	call   801929 <fsipc>
  801b7e:	89 c3                	mov    %eax,%ebx
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	85 c0                	test   %eax,%eax
  801b85:	78 19                	js     801ba0 <open+0x75>
	return fd2num(fd);
  801b87:	83 ec 0c             	sub    $0xc,%esp
  801b8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b8d:	e8 05 f8 ff ff       	call   801397 <fd2num>
  801b92:	89 c3                	mov    %eax,%ebx
  801b94:	83 c4 10             	add    $0x10,%esp
}
  801b97:	89 d8                	mov    %ebx,%eax
  801b99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b9c:	5b                   	pop    %ebx
  801b9d:	5e                   	pop    %esi
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    
		fd_close(fd, 0);
  801ba0:	83 ec 08             	sub    $0x8,%esp
  801ba3:	6a 00                	push   $0x0
  801ba5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba8:	e8 0e f9 ff ff       	call   8014bb <fd_close>
		return r;
  801bad:	83 c4 10             	add    $0x10,%esp
  801bb0:	eb e5                	jmp    801b97 <open+0x6c>
		return -E_BAD_PATH;
  801bb2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bb7:	eb de                	jmp    801b97 <open+0x6c>

00801bb9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bbf:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc4:	b8 08 00 00 00       	mov    $0x8,%eax
  801bc9:	e8 5b fd ff ff       	call   801929 <fsipc>
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	56                   	push   %esi
  801bd4:	53                   	push   %ebx
  801bd5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bd8:	83 ec 0c             	sub    $0xc,%esp
  801bdb:	ff 75 08             	pushl  0x8(%ebp)
  801bde:	e8 c4 f7 ff ff       	call   8013a7 <fd2data>
  801be3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801be5:	83 c4 08             	add    $0x8,%esp
  801be8:	68 ff 2d 80 00       	push   $0x802dff
  801bed:	53                   	push   %ebx
  801bee:	e8 05 f1 ff ff       	call   800cf8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bf3:	8b 46 04             	mov    0x4(%esi),%eax
  801bf6:	2b 06                	sub    (%esi),%eax
  801bf8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bfe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c05:	00 00 00 
	stat->st_dev = &devpipe;
  801c08:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c0f:	30 80 00 
	return 0;
}
  801c12:	b8 00 00 00 00       	mov    $0x0,%eax
  801c17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1a:	5b                   	pop    %ebx
  801c1b:	5e                   	pop    %esi
  801c1c:	5d                   	pop    %ebp
  801c1d:	c3                   	ret    

00801c1e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	53                   	push   %ebx
  801c22:	83 ec 0c             	sub    $0xc,%esp
  801c25:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c28:	53                   	push   %ebx
  801c29:	6a 00                	push   $0x0
  801c2b:	e8 3f f5 ff ff       	call   80116f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c30:	89 1c 24             	mov    %ebx,(%esp)
  801c33:	e8 6f f7 ff ff       	call   8013a7 <fd2data>
  801c38:	83 c4 08             	add    $0x8,%esp
  801c3b:	50                   	push   %eax
  801c3c:	6a 00                	push   $0x0
  801c3e:	e8 2c f5 ff ff       	call   80116f <sys_page_unmap>
}
  801c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <_pipeisclosed>:
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	57                   	push   %edi
  801c4c:	56                   	push   %esi
  801c4d:	53                   	push   %ebx
  801c4e:	83 ec 1c             	sub    $0x1c,%esp
  801c51:	89 c7                	mov    %eax,%edi
  801c53:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c55:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  801c5a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c5d:	83 ec 0c             	sub    $0xc,%esp
  801c60:	57                   	push   %edi
  801c61:	e8 ac 09 00 00       	call   802612 <pageref>
  801c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c69:	89 34 24             	mov    %esi,(%esp)
  801c6c:	e8 a1 09 00 00       	call   802612 <pageref>
		nn = thisenv->env_runs;
  801c71:	8b 15 b4 40 80 00    	mov    0x8040b4,%edx
  801c77:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	39 cb                	cmp    %ecx,%ebx
  801c7f:	74 1b                	je     801c9c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c81:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c84:	75 cf                	jne    801c55 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c86:	8b 42 58             	mov    0x58(%edx),%eax
  801c89:	6a 01                	push   $0x1
  801c8b:	50                   	push   %eax
  801c8c:	53                   	push   %ebx
  801c8d:	68 06 2e 80 00       	push   $0x802e06
  801c92:	e8 85 ea ff ff       	call   80071c <cprintf>
  801c97:	83 c4 10             	add    $0x10,%esp
  801c9a:	eb b9                	jmp    801c55 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c9c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c9f:	0f 94 c0             	sete   %al
  801ca2:	0f b6 c0             	movzbl %al,%eax
}
  801ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ca8:	5b                   	pop    %ebx
  801ca9:	5e                   	pop    %esi
  801caa:	5f                   	pop    %edi
  801cab:	5d                   	pop    %ebp
  801cac:	c3                   	ret    

00801cad <devpipe_write>:
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	57                   	push   %edi
  801cb1:	56                   	push   %esi
  801cb2:	53                   	push   %ebx
  801cb3:	83 ec 28             	sub    $0x28,%esp
  801cb6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cb9:	56                   	push   %esi
  801cba:	e8 e8 f6 ff ff       	call   8013a7 <fd2data>
  801cbf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	bf 00 00 00 00       	mov    $0x0,%edi
  801cc9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ccc:	74 4f                	je     801d1d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cce:	8b 43 04             	mov    0x4(%ebx),%eax
  801cd1:	8b 0b                	mov    (%ebx),%ecx
  801cd3:	8d 51 20             	lea    0x20(%ecx),%edx
  801cd6:	39 d0                	cmp    %edx,%eax
  801cd8:	72 14                	jb     801cee <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801cda:	89 da                	mov    %ebx,%edx
  801cdc:	89 f0                	mov    %esi,%eax
  801cde:	e8 65 ff ff ff       	call   801c48 <_pipeisclosed>
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	75 3b                	jne    801d22 <devpipe_write+0x75>
			sys_yield();
  801ce7:	e8 df f3 ff ff       	call   8010cb <sys_yield>
  801cec:	eb e0                	jmp    801cce <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cf1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cf5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cf8:	89 c2                	mov    %eax,%edx
  801cfa:	c1 fa 1f             	sar    $0x1f,%edx
  801cfd:	89 d1                	mov    %edx,%ecx
  801cff:	c1 e9 1b             	shr    $0x1b,%ecx
  801d02:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d05:	83 e2 1f             	and    $0x1f,%edx
  801d08:	29 ca                	sub    %ecx,%edx
  801d0a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d0e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d12:	83 c0 01             	add    $0x1,%eax
  801d15:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d18:	83 c7 01             	add    $0x1,%edi
  801d1b:	eb ac                	jmp    801cc9 <devpipe_write+0x1c>
	return i;
  801d1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d20:	eb 05                	jmp    801d27 <devpipe_write+0x7a>
				return 0;
  801d22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d2a:	5b                   	pop    %ebx
  801d2b:	5e                   	pop    %esi
  801d2c:	5f                   	pop    %edi
  801d2d:	5d                   	pop    %ebp
  801d2e:	c3                   	ret    

00801d2f <devpipe_read>:
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	57                   	push   %edi
  801d33:	56                   	push   %esi
  801d34:	53                   	push   %ebx
  801d35:	83 ec 18             	sub    $0x18,%esp
  801d38:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d3b:	57                   	push   %edi
  801d3c:	e8 66 f6 ff ff       	call   8013a7 <fd2data>
  801d41:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	be 00 00 00 00       	mov    $0x0,%esi
  801d4b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d4e:	75 14                	jne    801d64 <devpipe_read+0x35>
	return i;
  801d50:	8b 45 10             	mov    0x10(%ebp),%eax
  801d53:	eb 02                	jmp    801d57 <devpipe_read+0x28>
				return i;
  801d55:	89 f0                	mov    %esi,%eax
}
  801d57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d5a:	5b                   	pop    %ebx
  801d5b:	5e                   	pop    %esi
  801d5c:	5f                   	pop    %edi
  801d5d:	5d                   	pop    %ebp
  801d5e:	c3                   	ret    
			sys_yield();
  801d5f:	e8 67 f3 ff ff       	call   8010cb <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d64:	8b 03                	mov    (%ebx),%eax
  801d66:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d69:	75 18                	jne    801d83 <devpipe_read+0x54>
			if (i > 0)
  801d6b:	85 f6                	test   %esi,%esi
  801d6d:	75 e6                	jne    801d55 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801d6f:	89 da                	mov    %ebx,%edx
  801d71:	89 f8                	mov    %edi,%eax
  801d73:	e8 d0 fe ff ff       	call   801c48 <_pipeisclosed>
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	74 e3                	je     801d5f <devpipe_read+0x30>
				return 0;
  801d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d81:	eb d4                	jmp    801d57 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d83:	99                   	cltd   
  801d84:	c1 ea 1b             	shr    $0x1b,%edx
  801d87:	01 d0                	add    %edx,%eax
  801d89:	83 e0 1f             	and    $0x1f,%eax
  801d8c:	29 d0                	sub    %edx,%eax
  801d8e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d96:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d99:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d9c:	83 c6 01             	add    $0x1,%esi
  801d9f:	eb aa                	jmp    801d4b <devpipe_read+0x1c>

00801da1 <pipe>:
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	56                   	push   %esi
  801da5:	53                   	push   %ebx
  801da6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801da9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dac:	50                   	push   %eax
  801dad:	e8 0c f6 ff ff       	call   8013be <fd_alloc>
  801db2:	89 c3                	mov    %eax,%ebx
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	85 c0                	test   %eax,%eax
  801db9:	0f 88 23 01 00 00    	js     801ee2 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dbf:	83 ec 04             	sub    $0x4,%esp
  801dc2:	68 07 04 00 00       	push   $0x407
  801dc7:	ff 75 f4             	pushl  -0xc(%ebp)
  801dca:	6a 00                	push   $0x0
  801dcc:	e8 19 f3 ff ff       	call   8010ea <sys_page_alloc>
  801dd1:	89 c3                	mov    %eax,%ebx
  801dd3:	83 c4 10             	add    $0x10,%esp
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	0f 88 04 01 00 00    	js     801ee2 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801dde:	83 ec 0c             	sub    $0xc,%esp
  801de1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801de4:	50                   	push   %eax
  801de5:	e8 d4 f5 ff ff       	call   8013be <fd_alloc>
  801dea:	89 c3                	mov    %eax,%ebx
  801dec:	83 c4 10             	add    $0x10,%esp
  801def:	85 c0                	test   %eax,%eax
  801df1:	0f 88 db 00 00 00    	js     801ed2 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801df7:	83 ec 04             	sub    $0x4,%esp
  801dfa:	68 07 04 00 00       	push   $0x407
  801dff:	ff 75 f0             	pushl  -0x10(%ebp)
  801e02:	6a 00                	push   $0x0
  801e04:	e8 e1 f2 ff ff       	call   8010ea <sys_page_alloc>
  801e09:	89 c3                	mov    %eax,%ebx
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	85 c0                	test   %eax,%eax
  801e10:	0f 88 bc 00 00 00    	js     801ed2 <pipe+0x131>
	va = fd2data(fd0);
  801e16:	83 ec 0c             	sub    $0xc,%esp
  801e19:	ff 75 f4             	pushl  -0xc(%ebp)
  801e1c:	e8 86 f5 ff ff       	call   8013a7 <fd2data>
  801e21:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e23:	83 c4 0c             	add    $0xc,%esp
  801e26:	68 07 04 00 00       	push   $0x407
  801e2b:	50                   	push   %eax
  801e2c:	6a 00                	push   $0x0
  801e2e:	e8 b7 f2 ff ff       	call   8010ea <sys_page_alloc>
  801e33:	89 c3                	mov    %eax,%ebx
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	0f 88 82 00 00 00    	js     801ec2 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e40:	83 ec 0c             	sub    $0xc,%esp
  801e43:	ff 75 f0             	pushl  -0x10(%ebp)
  801e46:	e8 5c f5 ff ff       	call   8013a7 <fd2data>
  801e4b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e52:	50                   	push   %eax
  801e53:	6a 00                	push   $0x0
  801e55:	56                   	push   %esi
  801e56:	6a 00                	push   $0x0
  801e58:	e8 d0 f2 ff ff       	call   80112d <sys_page_map>
  801e5d:	89 c3                	mov    %eax,%ebx
  801e5f:	83 c4 20             	add    $0x20,%esp
  801e62:	85 c0                	test   %eax,%eax
  801e64:	78 4e                	js     801eb4 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801e66:	a1 20 30 80 00       	mov    0x803020,%eax
  801e6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e73:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e7d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e82:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e89:	83 ec 0c             	sub    $0xc,%esp
  801e8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8f:	e8 03 f5 ff ff       	call   801397 <fd2num>
  801e94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e97:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e99:	83 c4 04             	add    $0x4,%esp
  801e9c:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9f:	e8 f3 f4 ff ff       	call   801397 <fd2num>
  801ea4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801eaa:	83 c4 10             	add    $0x10,%esp
  801ead:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eb2:	eb 2e                	jmp    801ee2 <pipe+0x141>
	sys_page_unmap(0, va);
  801eb4:	83 ec 08             	sub    $0x8,%esp
  801eb7:	56                   	push   %esi
  801eb8:	6a 00                	push   $0x0
  801eba:	e8 b0 f2 ff ff       	call   80116f <sys_page_unmap>
  801ebf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ec2:	83 ec 08             	sub    $0x8,%esp
  801ec5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec8:	6a 00                	push   $0x0
  801eca:	e8 a0 f2 ff ff       	call   80116f <sys_page_unmap>
  801ecf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ed2:	83 ec 08             	sub    $0x8,%esp
  801ed5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed8:	6a 00                	push   $0x0
  801eda:	e8 90 f2 ff ff       	call   80116f <sys_page_unmap>
  801edf:	83 c4 10             	add    $0x10,%esp
}
  801ee2:	89 d8                	mov    %ebx,%eax
  801ee4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee7:	5b                   	pop    %ebx
  801ee8:	5e                   	pop    %esi
  801ee9:	5d                   	pop    %ebp
  801eea:	c3                   	ret    

00801eeb <pipeisclosed>:
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ef1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef4:	50                   	push   %eax
  801ef5:	ff 75 08             	pushl  0x8(%ebp)
  801ef8:	e8 13 f5 ff ff       	call   801410 <fd_lookup>
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	85 c0                	test   %eax,%eax
  801f02:	78 18                	js     801f1c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f04:	83 ec 0c             	sub    $0xc,%esp
  801f07:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0a:	e8 98 f4 ff ff       	call   8013a7 <fd2data>
	return _pipeisclosed(fd, p);
  801f0f:	89 c2                	mov    %eax,%edx
  801f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f14:	e8 2f fd ff ff       	call   801c48 <_pipeisclosed>
  801f19:	83 c4 10             	add    $0x10,%esp
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f24:	68 1e 2e 80 00       	push   $0x802e1e
  801f29:	ff 75 0c             	pushl  0xc(%ebp)
  801f2c:	e8 c7 ed ff ff       	call   800cf8 <strcpy>
	return 0;
}
  801f31:	b8 00 00 00 00       	mov    $0x0,%eax
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <devsock_close>:
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
  801f3b:	53                   	push   %ebx
  801f3c:	83 ec 10             	sub    $0x10,%esp
  801f3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f42:	53                   	push   %ebx
  801f43:	e8 ca 06 00 00       	call   802612 <pageref>
  801f48:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f4b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f50:	83 f8 01             	cmp    $0x1,%eax
  801f53:	74 07                	je     801f5c <devsock_close+0x24>
}
  801f55:	89 d0                	mov    %edx,%eax
  801f57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f5c:	83 ec 0c             	sub    $0xc,%esp
  801f5f:	ff 73 0c             	pushl  0xc(%ebx)
  801f62:	e8 b9 02 00 00       	call   802220 <nsipc_close>
  801f67:	89 c2                	mov    %eax,%edx
  801f69:	83 c4 10             	add    $0x10,%esp
  801f6c:	eb e7                	jmp    801f55 <devsock_close+0x1d>

00801f6e <devsock_write>:
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f74:	6a 00                	push   $0x0
  801f76:	ff 75 10             	pushl  0x10(%ebp)
  801f79:	ff 75 0c             	pushl  0xc(%ebp)
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	ff 70 0c             	pushl  0xc(%eax)
  801f82:	e8 76 03 00 00       	call   8022fd <nsipc_send>
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <devsock_read>:
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f8f:	6a 00                	push   $0x0
  801f91:	ff 75 10             	pushl  0x10(%ebp)
  801f94:	ff 75 0c             	pushl  0xc(%ebp)
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	ff 70 0c             	pushl  0xc(%eax)
  801f9d:	e8 ef 02 00 00       	call   802291 <nsipc_recv>
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <fd2sockid>:
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801faa:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fad:	52                   	push   %edx
  801fae:	50                   	push   %eax
  801faf:	e8 5c f4 ff ff       	call   801410 <fd_lookup>
  801fb4:	83 c4 10             	add    $0x10,%esp
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	78 10                	js     801fcb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbe:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801fc4:	39 08                	cmp    %ecx,(%eax)
  801fc6:	75 05                	jne    801fcd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fc8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    
		return -E_NOT_SUPP;
  801fcd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fd2:	eb f7                	jmp    801fcb <fd2sockid+0x27>

00801fd4 <alloc_sockfd>:
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	56                   	push   %esi
  801fd8:	53                   	push   %ebx
  801fd9:	83 ec 1c             	sub    $0x1c,%esp
  801fdc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fde:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe1:	50                   	push   %eax
  801fe2:	e8 d7 f3 ff ff       	call   8013be <fd_alloc>
  801fe7:	89 c3                	mov    %eax,%ebx
  801fe9:	83 c4 10             	add    $0x10,%esp
  801fec:	85 c0                	test   %eax,%eax
  801fee:	78 43                	js     802033 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ff0:	83 ec 04             	sub    $0x4,%esp
  801ff3:	68 07 04 00 00       	push   $0x407
  801ff8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffb:	6a 00                	push   $0x0
  801ffd:	e8 e8 f0 ff ff       	call   8010ea <sys_page_alloc>
  802002:	89 c3                	mov    %eax,%ebx
  802004:	83 c4 10             	add    $0x10,%esp
  802007:	85 c0                	test   %eax,%eax
  802009:	78 28                	js     802033 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80200b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802014:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802019:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802020:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802023:	83 ec 0c             	sub    $0xc,%esp
  802026:	50                   	push   %eax
  802027:	e8 6b f3 ff ff       	call   801397 <fd2num>
  80202c:	89 c3                	mov    %eax,%ebx
  80202e:	83 c4 10             	add    $0x10,%esp
  802031:	eb 0c                	jmp    80203f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802033:	83 ec 0c             	sub    $0xc,%esp
  802036:	56                   	push   %esi
  802037:	e8 e4 01 00 00       	call   802220 <nsipc_close>
		return r;
  80203c:	83 c4 10             	add    $0x10,%esp
}
  80203f:	89 d8                	mov    %ebx,%eax
  802041:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802044:	5b                   	pop    %ebx
  802045:	5e                   	pop    %esi
  802046:	5d                   	pop    %ebp
  802047:	c3                   	ret    

00802048 <accept>:
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	e8 4e ff ff ff       	call   801fa4 <fd2sockid>
  802056:	85 c0                	test   %eax,%eax
  802058:	78 1b                	js     802075 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	ff 75 10             	pushl  0x10(%ebp)
  802060:	ff 75 0c             	pushl  0xc(%ebp)
  802063:	50                   	push   %eax
  802064:	e8 0e 01 00 00       	call   802177 <nsipc_accept>
  802069:	83 c4 10             	add    $0x10,%esp
  80206c:	85 c0                	test   %eax,%eax
  80206e:	78 05                	js     802075 <accept+0x2d>
	return alloc_sockfd(r);
  802070:	e8 5f ff ff ff       	call   801fd4 <alloc_sockfd>
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <bind>:
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	e8 1f ff ff ff       	call   801fa4 <fd2sockid>
  802085:	85 c0                	test   %eax,%eax
  802087:	78 12                	js     80209b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	ff 75 10             	pushl  0x10(%ebp)
  80208f:	ff 75 0c             	pushl  0xc(%ebp)
  802092:	50                   	push   %eax
  802093:	e8 31 01 00 00       	call   8021c9 <nsipc_bind>
  802098:	83 c4 10             	add    $0x10,%esp
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <shutdown>:
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	e8 f9 fe ff ff       	call   801fa4 <fd2sockid>
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	78 0f                	js     8020be <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020af:	83 ec 08             	sub    $0x8,%esp
  8020b2:	ff 75 0c             	pushl  0xc(%ebp)
  8020b5:	50                   	push   %eax
  8020b6:	e8 43 01 00 00       	call   8021fe <nsipc_shutdown>
  8020bb:	83 c4 10             	add    $0x10,%esp
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <connect>:
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	e8 d6 fe ff ff       	call   801fa4 <fd2sockid>
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	78 12                	js     8020e4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	ff 75 10             	pushl  0x10(%ebp)
  8020d8:	ff 75 0c             	pushl  0xc(%ebp)
  8020db:	50                   	push   %eax
  8020dc:	e8 59 01 00 00       	call   80223a <nsipc_connect>
  8020e1:	83 c4 10             	add    $0x10,%esp
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <listen>:
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	e8 b0 fe ff ff       	call   801fa4 <fd2sockid>
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	78 0f                	js     802107 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020f8:	83 ec 08             	sub    $0x8,%esp
  8020fb:	ff 75 0c             	pushl  0xc(%ebp)
  8020fe:	50                   	push   %eax
  8020ff:	e8 6b 01 00 00       	call   80226f <nsipc_listen>
  802104:	83 c4 10             	add    $0x10,%esp
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <socket>:

int
socket(int domain, int type, int protocol)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80210f:	ff 75 10             	pushl  0x10(%ebp)
  802112:	ff 75 0c             	pushl  0xc(%ebp)
  802115:	ff 75 08             	pushl  0x8(%ebp)
  802118:	e8 3e 02 00 00       	call   80235b <nsipc_socket>
  80211d:	83 c4 10             	add    $0x10,%esp
  802120:	85 c0                	test   %eax,%eax
  802122:	78 05                	js     802129 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802124:	e8 ab fe ff ff       	call   801fd4 <alloc_sockfd>
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	53                   	push   %ebx
  80212f:	83 ec 04             	sub    $0x4,%esp
  802132:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802134:	83 3d b0 40 80 00 00 	cmpl   $0x0,0x8040b0
  80213b:	74 26                	je     802163 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80213d:	6a 07                	push   $0x7
  80213f:	68 00 60 80 00       	push   $0x806000
  802144:	53                   	push   %ebx
  802145:	ff 35 b0 40 80 00    	pushl  0x8040b0
  80214b:	e8 1d 04 00 00       	call   80256d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802150:	83 c4 0c             	add    $0xc,%esp
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	e8 9c 03 00 00       	call   8024fa <ipc_recv>
}
  80215e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802161:	c9                   	leave  
  802162:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802163:	83 ec 0c             	sub    $0xc,%esp
  802166:	6a 02                	push   $0x2
  802168:	e8 6c 04 00 00       	call   8025d9 <ipc_find_env>
  80216d:	a3 b0 40 80 00       	mov    %eax,0x8040b0
  802172:	83 c4 10             	add    $0x10,%esp
  802175:	eb c6                	jmp    80213d <nsipc+0x12>

00802177 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	56                   	push   %esi
  80217b:	53                   	push   %ebx
  80217c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802187:	8b 06                	mov    (%esi),%eax
  802189:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80218e:	b8 01 00 00 00       	mov    $0x1,%eax
  802193:	e8 93 ff ff ff       	call   80212b <nsipc>
  802198:	89 c3                	mov    %eax,%ebx
  80219a:	85 c0                	test   %eax,%eax
  80219c:	79 09                	jns    8021a7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80219e:	89 d8                	mov    %ebx,%eax
  8021a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a3:	5b                   	pop    %ebx
  8021a4:	5e                   	pop    %esi
  8021a5:	5d                   	pop    %ebp
  8021a6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021a7:	83 ec 04             	sub    $0x4,%esp
  8021aa:	ff 35 10 60 80 00    	pushl  0x806010
  8021b0:	68 00 60 80 00       	push   $0x806000
  8021b5:	ff 75 0c             	pushl  0xc(%ebp)
  8021b8:	e8 c9 ec ff ff       	call   800e86 <memmove>
		*addrlen = ret->ret_addrlen;
  8021bd:	a1 10 60 80 00       	mov    0x806010,%eax
  8021c2:	89 06                	mov    %eax,(%esi)
  8021c4:	83 c4 10             	add    $0x10,%esp
	return r;
  8021c7:	eb d5                	jmp    80219e <nsipc_accept+0x27>

008021c9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	53                   	push   %ebx
  8021cd:	83 ec 08             	sub    $0x8,%esp
  8021d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021db:	53                   	push   %ebx
  8021dc:	ff 75 0c             	pushl  0xc(%ebp)
  8021df:	68 04 60 80 00       	push   $0x806004
  8021e4:	e8 9d ec ff ff       	call   800e86 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021e9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8021ef:	b8 02 00 00 00       	mov    $0x2,%eax
  8021f4:	e8 32 ff ff ff       	call   80212b <nsipc>
}
  8021f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80220c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802214:	b8 03 00 00 00       	mov    $0x3,%eax
  802219:	e8 0d ff ff ff       	call   80212b <nsipc>
}
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <nsipc_close>:

int
nsipc_close(int s)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
  802223:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80222e:	b8 04 00 00 00       	mov    $0x4,%eax
  802233:	e8 f3 fe ff ff       	call   80212b <nsipc>
}
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	53                   	push   %ebx
  80223e:	83 ec 08             	sub    $0x8,%esp
  802241:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80224c:	53                   	push   %ebx
  80224d:	ff 75 0c             	pushl  0xc(%ebp)
  802250:	68 04 60 80 00       	push   $0x806004
  802255:	e8 2c ec ff ff       	call   800e86 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80225a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802260:	b8 05 00 00 00       	mov    $0x5,%eax
  802265:	e8 c1 fe ff ff       	call   80212b <nsipc>
}
  80226a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80227d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802280:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802285:	b8 06 00 00 00       	mov    $0x6,%eax
  80228a:	e8 9c fe ff ff       	call   80212b <nsipc>
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	56                   	push   %esi
  802295:	53                   	push   %ebx
  802296:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8022a1:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8022a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8022aa:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022af:	b8 07 00 00 00       	mov    $0x7,%eax
  8022b4:	e8 72 fe ff ff       	call   80212b <nsipc>
  8022b9:	89 c3                	mov    %eax,%ebx
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	78 1f                	js     8022de <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022bf:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022c4:	7f 21                	jg     8022e7 <nsipc_recv+0x56>
  8022c6:	39 c6                	cmp    %eax,%esi
  8022c8:	7c 1d                	jl     8022e7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022ca:	83 ec 04             	sub    $0x4,%esp
  8022cd:	50                   	push   %eax
  8022ce:	68 00 60 80 00       	push   $0x806000
  8022d3:	ff 75 0c             	pushl  0xc(%ebp)
  8022d6:	e8 ab eb ff ff       	call   800e86 <memmove>
  8022db:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022de:	89 d8                	mov    %ebx,%eax
  8022e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022e3:	5b                   	pop    %ebx
  8022e4:	5e                   	pop    %esi
  8022e5:	5d                   	pop    %ebp
  8022e6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022e7:	68 2a 2e 80 00       	push   $0x802e2a
  8022ec:	68 cc 2d 80 00       	push   $0x802dcc
  8022f1:	6a 62                	push   $0x62
  8022f3:	68 3f 2e 80 00       	push   $0x802e3f
  8022f8:	e8 44 e3 ff ff       	call   800641 <_panic>

008022fd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	53                   	push   %ebx
  802301:	83 ec 04             	sub    $0x4,%esp
  802304:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80230f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802315:	7f 2e                	jg     802345 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802317:	83 ec 04             	sub    $0x4,%esp
  80231a:	53                   	push   %ebx
  80231b:	ff 75 0c             	pushl  0xc(%ebp)
  80231e:	68 0c 60 80 00       	push   $0x80600c
  802323:	e8 5e eb ff ff       	call   800e86 <memmove>
	nsipcbuf.send.req_size = size;
  802328:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80232e:	8b 45 14             	mov    0x14(%ebp),%eax
  802331:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802336:	b8 08 00 00 00       	mov    $0x8,%eax
  80233b:	e8 eb fd ff ff       	call   80212b <nsipc>
}
  802340:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802343:	c9                   	leave  
  802344:	c3                   	ret    
	assert(size < 1600);
  802345:	68 4b 2e 80 00       	push   $0x802e4b
  80234a:	68 cc 2d 80 00       	push   $0x802dcc
  80234f:	6a 6d                	push   $0x6d
  802351:	68 3f 2e 80 00       	push   $0x802e3f
  802356:	e8 e6 e2 ff ff       	call   800641 <_panic>

0080235b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
  80235e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236c:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802371:	8b 45 10             	mov    0x10(%ebp),%eax
  802374:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802379:	b8 09 00 00 00       	mov    $0x9,%eax
  80237e:	e8 a8 fd ff ff       	call   80212b <nsipc>
}
  802383:	c9                   	leave  
  802384:	c3                   	ret    

00802385 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802385:	b8 00 00 00 00       	mov    $0x0,%eax
  80238a:	c3                   	ret    

0080238b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802391:	68 57 2e 80 00       	push   $0x802e57
  802396:	ff 75 0c             	pushl  0xc(%ebp)
  802399:	e8 5a e9 ff ff       	call   800cf8 <strcpy>
	return 0;
}
  80239e:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <devcons_write>:
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
  8023a8:	57                   	push   %edi
  8023a9:	56                   	push   %esi
  8023aa:	53                   	push   %ebx
  8023ab:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023b1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023b6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023bc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023bf:	73 31                	jae    8023f2 <devcons_write+0x4d>
		m = n - tot;
  8023c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023c4:	29 f3                	sub    %esi,%ebx
  8023c6:	83 fb 7f             	cmp    $0x7f,%ebx
  8023c9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023ce:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023d1:	83 ec 04             	sub    $0x4,%esp
  8023d4:	53                   	push   %ebx
  8023d5:	89 f0                	mov    %esi,%eax
  8023d7:	03 45 0c             	add    0xc(%ebp),%eax
  8023da:	50                   	push   %eax
  8023db:	57                   	push   %edi
  8023dc:	e8 a5 ea ff ff       	call   800e86 <memmove>
		sys_cputs(buf, m);
  8023e1:	83 c4 08             	add    $0x8,%esp
  8023e4:	53                   	push   %ebx
  8023e5:	57                   	push   %edi
  8023e6:	e8 43 ec ff ff       	call   80102e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023eb:	01 de                	add    %ebx,%esi
  8023ed:	83 c4 10             	add    $0x10,%esp
  8023f0:	eb ca                	jmp    8023bc <devcons_write+0x17>
}
  8023f2:	89 f0                	mov    %esi,%eax
  8023f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023f7:	5b                   	pop    %ebx
  8023f8:	5e                   	pop    %esi
  8023f9:	5f                   	pop    %edi
  8023fa:	5d                   	pop    %ebp
  8023fb:	c3                   	ret    

008023fc <devcons_read>:
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	83 ec 08             	sub    $0x8,%esp
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802407:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80240b:	74 21                	je     80242e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80240d:	e8 3a ec ff ff       	call   80104c <sys_cgetc>
  802412:	85 c0                	test   %eax,%eax
  802414:	75 07                	jne    80241d <devcons_read+0x21>
		sys_yield();
  802416:	e8 b0 ec ff ff       	call   8010cb <sys_yield>
  80241b:	eb f0                	jmp    80240d <devcons_read+0x11>
	if (c < 0)
  80241d:	78 0f                	js     80242e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80241f:	83 f8 04             	cmp    $0x4,%eax
  802422:	74 0c                	je     802430 <devcons_read+0x34>
	*(char*)vbuf = c;
  802424:	8b 55 0c             	mov    0xc(%ebp),%edx
  802427:	88 02                	mov    %al,(%edx)
	return 1;
  802429:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    
		return 0;
  802430:	b8 00 00 00 00       	mov    $0x0,%eax
  802435:	eb f7                	jmp    80242e <devcons_read+0x32>

00802437 <cputchar>:
{
  802437:	55                   	push   %ebp
  802438:	89 e5                	mov    %esp,%ebp
  80243a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802443:	6a 01                	push   $0x1
  802445:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802448:	50                   	push   %eax
  802449:	e8 e0 eb ff ff       	call   80102e <sys_cputs>
}
  80244e:	83 c4 10             	add    $0x10,%esp
  802451:	c9                   	leave  
  802452:	c3                   	ret    

00802453 <getchar>:
{
  802453:	55                   	push   %ebp
  802454:	89 e5                	mov    %esp,%ebp
  802456:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802459:	6a 01                	push   $0x1
  80245b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80245e:	50                   	push   %eax
  80245f:	6a 00                	push   $0x0
  802461:	e8 1a f2 ff ff       	call   801680 <read>
	if (r < 0)
  802466:	83 c4 10             	add    $0x10,%esp
  802469:	85 c0                	test   %eax,%eax
  80246b:	78 06                	js     802473 <getchar+0x20>
	if (r < 1)
  80246d:	74 06                	je     802475 <getchar+0x22>
	return c;
  80246f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802473:	c9                   	leave  
  802474:	c3                   	ret    
		return -E_EOF;
  802475:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80247a:	eb f7                	jmp    802473 <getchar+0x20>

0080247c <iscons>:
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
  80247f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802482:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802485:	50                   	push   %eax
  802486:	ff 75 08             	pushl  0x8(%ebp)
  802489:	e8 82 ef ff ff       	call   801410 <fd_lookup>
  80248e:	83 c4 10             	add    $0x10,%esp
  802491:	85 c0                	test   %eax,%eax
  802493:	78 11                	js     8024a6 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80249e:	39 10                	cmp    %edx,(%eax)
  8024a0:	0f 94 c0             	sete   %al
  8024a3:	0f b6 c0             	movzbl %al,%eax
}
  8024a6:	c9                   	leave  
  8024a7:	c3                   	ret    

008024a8 <opencons>:
{
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
  8024ab:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024b1:	50                   	push   %eax
  8024b2:	e8 07 ef ff ff       	call   8013be <fd_alloc>
  8024b7:	83 c4 10             	add    $0x10,%esp
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	78 3a                	js     8024f8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024be:	83 ec 04             	sub    $0x4,%esp
  8024c1:	68 07 04 00 00       	push   $0x407
  8024c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c9:	6a 00                	push   $0x0
  8024cb:	e8 1a ec ff ff       	call   8010ea <sys_page_alloc>
  8024d0:	83 c4 10             	add    $0x10,%esp
  8024d3:	85 c0                	test   %eax,%eax
  8024d5:	78 21                	js     8024f8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024e0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024ec:	83 ec 0c             	sub    $0xc,%esp
  8024ef:	50                   	push   %eax
  8024f0:	e8 a2 ee ff ff       	call   801397 <fd2num>
  8024f5:	83 c4 10             	add    $0x10,%esp
}
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
  8024fd:	56                   	push   %esi
  8024fe:	53                   	push   %ebx
  8024ff:	8b 75 08             	mov    0x8(%ebp),%esi
  802502:	8b 45 0c             	mov    0xc(%ebp),%eax
  802505:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  802508:	85 c0                	test   %eax,%eax
  80250a:	74 4f                	je     80255b <ipc_recv+0x61>
  80250c:	83 ec 0c             	sub    $0xc,%esp
  80250f:	50                   	push   %eax
  802510:	e8 85 ed ff ff       	call   80129a <sys_ipc_recv>
  802515:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  802518:	85 f6                	test   %esi,%esi
  80251a:	74 14                	je     802530 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  80251c:	ba 00 00 00 00       	mov    $0x0,%edx
  802521:	85 c0                	test   %eax,%eax
  802523:	75 09                	jne    80252e <ipc_recv+0x34>
  802525:	8b 15 b4 40 80 00    	mov    0x8040b4,%edx
  80252b:	8b 52 74             	mov    0x74(%edx),%edx
  80252e:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  802530:	85 db                	test   %ebx,%ebx
  802532:	74 14                	je     802548 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  802534:	ba 00 00 00 00       	mov    $0x0,%edx
  802539:	85 c0                	test   %eax,%eax
  80253b:	75 09                	jne    802546 <ipc_recv+0x4c>
  80253d:	8b 15 b4 40 80 00    	mov    0x8040b4,%edx
  802543:	8b 52 78             	mov    0x78(%edx),%edx
  802546:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  802548:	85 c0                	test   %eax,%eax
  80254a:	75 08                	jne    802554 <ipc_recv+0x5a>
  80254c:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  802551:	8b 40 70             	mov    0x70(%eax),%eax
}
  802554:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802557:	5b                   	pop    %ebx
  802558:	5e                   	pop    %esi
  802559:	5d                   	pop    %ebp
  80255a:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  80255b:	83 ec 0c             	sub    $0xc,%esp
  80255e:	68 00 00 c0 ee       	push   $0xeec00000
  802563:	e8 32 ed ff ff       	call   80129a <sys_ipc_recv>
  802568:	83 c4 10             	add    $0x10,%esp
  80256b:	eb ab                	jmp    802518 <ipc_recv+0x1e>

0080256d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
  802570:	57                   	push   %edi
  802571:	56                   	push   %esi
  802572:	53                   	push   %ebx
  802573:	83 ec 0c             	sub    $0xc,%esp
  802576:	8b 7d 08             	mov    0x8(%ebp),%edi
  802579:	8b 75 10             	mov    0x10(%ebp),%esi
  80257c:	eb 20                	jmp    80259e <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80257e:	6a 00                	push   $0x0
  802580:	68 00 00 c0 ee       	push   $0xeec00000
  802585:	ff 75 0c             	pushl  0xc(%ebp)
  802588:	57                   	push   %edi
  802589:	e8 e9 ec ff ff       	call   801277 <sys_ipc_try_send>
  80258e:	89 c3                	mov    %eax,%ebx
  802590:	83 c4 10             	add    $0x10,%esp
  802593:	eb 1f                	jmp    8025b4 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802595:	e8 31 eb ff ff       	call   8010cb <sys_yield>
	while(retval != 0) {
  80259a:	85 db                	test   %ebx,%ebx
  80259c:	74 33                	je     8025d1 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  80259e:	85 f6                	test   %esi,%esi
  8025a0:	74 dc                	je     80257e <ipc_send+0x11>
  8025a2:	ff 75 14             	pushl  0x14(%ebp)
  8025a5:	56                   	push   %esi
  8025a6:	ff 75 0c             	pushl  0xc(%ebp)
  8025a9:	57                   	push   %edi
  8025aa:	e8 c8 ec ff ff       	call   801277 <sys_ipc_try_send>
  8025af:	89 c3                	mov    %eax,%ebx
  8025b1:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  8025b4:	83 fb f9             	cmp    $0xfffffff9,%ebx
  8025b7:	74 dc                	je     802595 <ipc_send+0x28>
  8025b9:	85 db                	test   %ebx,%ebx
  8025bb:	74 d8                	je     802595 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  8025bd:	83 ec 04             	sub    $0x4,%esp
  8025c0:	68 64 2e 80 00       	push   $0x802e64
  8025c5:	6a 35                	push   $0x35
  8025c7:	68 94 2e 80 00       	push   $0x802e94
  8025cc:	e8 70 e0 ff ff       	call   800641 <_panic>
	}
}
  8025d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025d4:	5b                   	pop    %ebx
  8025d5:	5e                   	pop    %esi
  8025d6:	5f                   	pop    %edi
  8025d7:	5d                   	pop    %ebp
  8025d8:	c3                   	ret    

008025d9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025df:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025e4:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025e7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025ed:	8b 52 50             	mov    0x50(%edx),%edx
  8025f0:	39 ca                	cmp    %ecx,%edx
  8025f2:	74 11                	je     802605 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8025f4:	83 c0 01             	add    $0x1,%eax
  8025f7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025fc:	75 e6                	jne    8025e4 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802603:	eb 0b                	jmp    802610 <ipc_find_env+0x37>
			return envs[i].env_id;
  802605:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802608:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80260d:	8b 40 48             	mov    0x48(%eax),%eax
}
  802610:	5d                   	pop    %ebp
  802611:	c3                   	ret    

00802612 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802612:	55                   	push   %ebp
  802613:	89 e5                	mov    %esp,%ebp
  802615:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802618:	89 d0                	mov    %edx,%eax
  80261a:	c1 e8 16             	shr    $0x16,%eax
  80261d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802624:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802629:	f6 c1 01             	test   $0x1,%cl
  80262c:	74 1d                	je     80264b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80262e:	c1 ea 0c             	shr    $0xc,%edx
  802631:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802638:	f6 c2 01             	test   $0x1,%dl
  80263b:	74 0e                	je     80264b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80263d:	c1 ea 0c             	shr    $0xc,%edx
  802640:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802647:	ef 
  802648:	0f b7 c0             	movzwl %ax,%eax
}
  80264b:	5d                   	pop    %ebp
  80264c:	c3                   	ret    
  80264d:	66 90                	xchg   %ax,%ax
  80264f:	90                   	nop

00802650 <__udivdi3>:
  802650:	f3 0f 1e fb          	endbr32 
  802654:	55                   	push   %ebp
  802655:	57                   	push   %edi
  802656:	56                   	push   %esi
  802657:	53                   	push   %ebx
  802658:	83 ec 1c             	sub    $0x1c,%esp
  80265b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80265f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802663:	8b 74 24 34          	mov    0x34(%esp),%esi
  802667:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80266b:	85 d2                	test   %edx,%edx
  80266d:	75 49                	jne    8026b8 <__udivdi3+0x68>
  80266f:	39 f3                	cmp    %esi,%ebx
  802671:	76 15                	jbe    802688 <__udivdi3+0x38>
  802673:	31 ff                	xor    %edi,%edi
  802675:	89 e8                	mov    %ebp,%eax
  802677:	89 f2                	mov    %esi,%edx
  802679:	f7 f3                	div    %ebx
  80267b:	89 fa                	mov    %edi,%edx
  80267d:	83 c4 1c             	add    $0x1c,%esp
  802680:	5b                   	pop    %ebx
  802681:	5e                   	pop    %esi
  802682:	5f                   	pop    %edi
  802683:	5d                   	pop    %ebp
  802684:	c3                   	ret    
  802685:	8d 76 00             	lea    0x0(%esi),%esi
  802688:	89 d9                	mov    %ebx,%ecx
  80268a:	85 db                	test   %ebx,%ebx
  80268c:	75 0b                	jne    802699 <__udivdi3+0x49>
  80268e:	b8 01 00 00 00       	mov    $0x1,%eax
  802693:	31 d2                	xor    %edx,%edx
  802695:	f7 f3                	div    %ebx
  802697:	89 c1                	mov    %eax,%ecx
  802699:	31 d2                	xor    %edx,%edx
  80269b:	89 f0                	mov    %esi,%eax
  80269d:	f7 f1                	div    %ecx
  80269f:	89 c6                	mov    %eax,%esi
  8026a1:	89 e8                	mov    %ebp,%eax
  8026a3:	89 f7                	mov    %esi,%edi
  8026a5:	f7 f1                	div    %ecx
  8026a7:	89 fa                	mov    %edi,%edx
  8026a9:	83 c4 1c             	add    $0x1c,%esp
  8026ac:	5b                   	pop    %ebx
  8026ad:	5e                   	pop    %esi
  8026ae:	5f                   	pop    %edi
  8026af:	5d                   	pop    %ebp
  8026b0:	c3                   	ret    
  8026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026b8:	39 f2                	cmp    %esi,%edx
  8026ba:	77 1c                	ja     8026d8 <__udivdi3+0x88>
  8026bc:	0f bd fa             	bsr    %edx,%edi
  8026bf:	83 f7 1f             	xor    $0x1f,%edi
  8026c2:	75 2c                	jne    8026f0 <__udivdi3+0xa0>
  8026c4:	39 f2                	cmp    %esi,%edx
  8026c6:	72 06                	jb     8026ce <__udivdi3+0x7e>
  8026c8:	31 c0                	xor    %eax,%eax
  8026ca:	39 eb                	cmp    %ebp,%ebx
  8026cc:	77 ad                	ja     80267b <__udivdi3+0x2b>
  8026ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d3:	eb a6                	jmp    80267b <__udivdi3+0x2b>
  8026d5:	8d 76 00             	lea    0x0(%esi),%esi
  8026d8:	31 ff                	xor    %edi,%edi
  8026da:	31 c0                	xor    %eax,%eax
  8026dc:	89 fa                	mov    %edi,%edx
  8026de:	83 c4 1c             	add    $0x1c,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5f                   	pop    %edi
  8026e4:	5d                   	pop    %ebp
  8026e5:	c3                   	ret    
  8026e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026ed:	8d 76 00             	lea    0x0(%esi),%esi
  8026f0:	89 f9                	mov    %edi,%ecx
  8026f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026f7:	29 f8                	sub    %edi,%eax
  8026f9:	d3 e2                	shl    %cl,%edx
  8026fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026ff:	89 c1                	mov    %eax,%ecx
  802701:	89 da                	mov    %ebx,%edx
  802703:	d3 ea                	shr    %cl,%edx
  802705:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802709:	09 d1                	or     %edx,%ecx
  80270b:	89 f2                	mov    %esi,%edx
  80270d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802711:	89 f9                	mov    %edi,%ecx
  802713:	d3 e3                	shl    %cl,%ebx
  802715:	89 c1                	mov    %eax,%ecx
  802717:	d3 ea                	shr    %cl,%edx
  802719:	89 f9                	mov    %edi,%ecx
  80271b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80271f:	89 eb                	mov    %ebp,%ebx
  802721:	d3 e6                	shl    %cl,%esi
  802723:	89 c1                	mov    %eax,%ecx
  802725:	d3 eb                	shr    %cl,%ebx
  802727:	09 de                	or     %ebx,%esi
  802729:	89 f0                	mov    %esi,%eax
  80272b:	f7 74 24 08          	divl   0x8(%esp)
  80272f:	89 d6                	mov    %edx,%esi
  802731:	89 c3                	mov    %eax,%ebx
  802733:	f7 64 24 0c          	mull   0xc(%esp)
  802737:	39 d6                	cmp    %edx,%esi
  802739:	72 15                	jb     802750 <__udivdi3+0x100>
  80273b:	89 f9                	mov    %edi,%ecx
  80273d:	d3 e5                	shl    %cl,%ebp
  80273f:	39 c5                	cmp    %eax,%ebp
  802741:	73 04                	jae    802747 <__udivdi3+0xf7>
  802743:	39 d6                	cmp    %edx,%esi
  802745:	74 09                	je     802750 <__udivdi3+0x100>
  802747:	89 d8                	mov    %ebx,%eax
  802749:	31 ff                	xor    %edi,%edi
  80274b:	e9 2b ff ff ff       	jmp    80267b <__udivdi3+0x2b>
  802750:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802753:	31 ff                	xor    %edi,%edi
  802755:	e9 21 ff ff ff       	jmp    80267b <__udivdi3+0x2b>
  80275a:	66 90                	xchg   %ax,%ax
  80275c:	66 90                	xchg   %ax,%ax
  80275e:	66 90                	xchg   %ax,%ax

00802760 <__umoddi3>:
  802760:	f3 0f 1e fb          	endbr32 
  802764:	55                   	push   %ebp
  802765:	57                   	push   %edi
  802766:	56                   	push   %esi
  802767:	53                   	push   %ebx
  802768:	83 ec 1c             	sub    $0x1c,%esp
  80276b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80276f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802773:	8b 74 24 30          	mov    0x30(%esp),%esi
  802777:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80277b:	89 da                	mov    %ebx,%edx
  80277d:	85 c0                	test   %eax,%eax
  80277f:	75 3f                	jne    8027c0 <__umoddi3+0x60>
  802781:	39 df                	cmp    %ebx,%edi
  802783:	76 13                	jbe    802798 <__umoddi3+0x38>
  802785:	89 f0                	mov    %esi,%eax
  802787:	f7 f7                	div    %edi
  802789:	89 d0                	mov    %edx,%eax
  80278b:	31 d2                	xor    %edx,%edx
  80278d:	83 c4 1c             	add    $0x1c,%esp
  802790:	5b                   	pop    %ebx
  802791:	5e                   	pop    %esi
  802792:	5f                   	pop    %edi
  802793:	5d                   	pop    %ebp
  802794:	c3                   	ret    
  802795:	8d 76 00             	lea    0x0(%esi),%esi
  802798:	89 fd                	mov    %edi,%ebp
  80279a:	85 ff                	test   %edi,%edi
  80279c:	75 0b                	jne    8027a9 <__umoddi3+0x49>
  80279e:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a3:	31 d2                	xor    %edx,%edx
  8027a5:	f7 f7                	div    %edi
  8027a7:	89 c5                	mov    %eax,%ebp
  8027a9:	89 d8                	mov    %ebx,%eax
  8027ab:	31 d2                	xor    %edx,%edx
  8027ad:	f7 f5                	div    %ebp
  8027af:	89 f0                	mov    %esi,%eax
  8027b1:	f7 f5                	div    %ebp
  8027b3:	89 d0                	mov    %edx,%eax
  8027b5:	eb d4                	jmp    80278b <__umoddi3+0x2b>
  8027b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027be:	66 90                	xchg   %ax,%ax
  8027c0:	89 f1                	mov    %esi,%ecx
  8027c2:	39 d8                	cmp    %ebx,%eax
  8027c4:	76 0a                	jbe    8027d0 <__umoddi3+0x70>
  8027c6:	89 f0                	mov    %esi,%eax
  8027c8:	83 c4 1c             	add    $0x1c,%esp
  8027cb:	5b                   	pop    %ebx
  8027cc:	5e                   	pop    %esi
  8027cd:	5f                   	pop    %edi
  8027ce:	5d                   	pop    %ebp
  8027cf:	c3                   	ret    
  8027d0:	0f bd e8             	bsr    %eax,%ebp
  8027d3:	83 f5 1f             	xor    $0x1f,%ebp
  8027d6:	75 20                	jne    8027f8 <__umoddi3+0x98>
  8027d8:	39 d8                	cmp    %ebx,%eax
  8027da:	0f 82 b0 00 00 00    	jb     802890 <__umoddi3+0x130>
  8027e0:	39 f7                	cmp    %esi,%edi
  8027e2:	0f 86 a8 00 00 00    	jbe    802890 <__umoddi3+0x130>
  8027e8:	89 c8                	mov    %ecx,%eax
  8027ea:	83 c4 1c             	add    $0x1c,%esp
  8027ed:	5b                   	pop    %ebx
  8027ee:	5e                   	pop    %esi
  8027ef:	5f                   	pop    %edi
  8027f0:	5d                   	pop    %ebp
  8027f1:	c3                   	ret    
  8027f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027f8:	89 e9                	mov    %ebp,%ecx
  8027fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8027ff:	29 ea                	sub    %ebp,%edx
  802801:	d3 e0                	shl    %cl,%eax
  802803:	89 44 24 08          	mov    %eax,0x8(%esp)
  802807:	89 d1                	mov    %edx,%ecx
  802809:	89 f8                	mov    %edi,%eax
  80280b:	d3 e8                	shr    %cl,%eax
  80280d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802811:	89 54 24 04          	mov    %edx,0x4(%esp)
  802815:	8b 54 24 04          	mov    0x4(%esp),%edx
  802819:	09 c1                	or     %eax,%ecx
  80281b:	89 d8                	mov    %ebx,%eax
  80281d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802821:	89 e9                	mov    %ebp,%ecx
  802823:	d3 e7                	shl    %cl,%edi
  802825:	89 d1                	mov    %edx,%ecx
  802827:	d3 e8                	shr    %cl,%eax
  802829:	89 e9                	mov    %ebp,%ecx
  80282b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80282f:	d3 e3                	shl    %cl,%ebx
  802831:	89 c7                	mov    %eax,%edi
  802833:	89 d1                	mov    %edx,%ecx
  802835:	89 f0                	mov    %esi,%eax
  802837:	d3 e8                	shr    %cl,%eax
  802839:	89 e9                	mov    %ebp,%ecx
  80283b:	89 fa                	mov    %edi,%edx
  80283d:	d3 e6                	shl    %cl,%esi
  80283f:	09 d8                	or     %ebx,%eax
  802841:	f7 74 24 08          	divl   0x8(%esp)
  802845:	89 d1                	mov    %edx,%ecx
  802847:	89 f3                	mov    %esi,%ebx
  802849:	f7 64 24 0c          	mull   0xc(%esp)
  80284d:	89 c6                	mov    %eax,%esi
  80284f:	89 d7                	mov    %edx,%edi
  802851:	39 d1                	cmp    %edx,%ecx
  802853:	72 06                	jb     80285b <__umoddi3+0xfb>
  802855:	75 10                	jne    802867 <__umoddi3+0x107>
  802857:	39 c3                	cmp    %eax,%ebx
  802859:	73 0c                	jae    802867 <__umoddi3+0x107>
  80285b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80285f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802863:	89 d7                	mov    %edx,%edi
  802865:	89 c6                	mov    %eax,%esi
  802867:	89 ca                	mov    %ecx,%edx
  802869:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80286e:	29 f3                	sub    %esi,%ebx
  802870:	19 fa                	sbb    %edi,%edx
  802872:	89 d0                	mov    %edx,%eax
  802874:	d3 e0                	shl    %cl,%eax
  802876:	89 e9                	mov    %ebp,%ecx
  802878:	d3 eb                	shr    %cl,%ebx
  80287a:	d3 ea                	shr    %cl,%edx
  80287c:	09 d8                	or     %ebx,%eax
  80287e:	83 c4 1c             	add    $0x1c,%esp
  802881:	5b                   	pop    %ebx
  802882:	5e                   	pop    %esi
  802883:	5f                   	pop    %edi
  802884:	5d                   	pop    %ebp
  802885:	c3                   	ret    
  802886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80288d:	8d 76 00             	lea    0x0(%esi),%esi
  802890:	89 da                	mov    %ebx,%edx
  802892:	29 fe                	sub    %edi,%esi
  802894:	19 c2                	sbb    %eax,%edx
  802896:	89 f1                	mov    %esi,%ecx
  802898:	89 c8                	mov    %ecx,%eax
  80289a:	e9 4b ff ff ff       	jmp    8027ea <__umoddi3+0x8a>
