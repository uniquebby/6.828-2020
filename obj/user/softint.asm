
obj/user/softint.debug：     文件格式 elf32-i386


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
  80002c:	e8 05 00 00 00       	call   800036 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $14");	// page fault
  800033:	cd 0e                	int    $0xe
}
  800035:	c3                   	ret    

00800036 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800036:	55                   	push   %ebp
  800037:	89 e5                	mov    %esp,%ebp
  800039:	56                   	push   %esi
  80003a:	53                   	push   %ebx
  80003b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800041:	e8 ce 00 00 00       	call   800114 <sys_getenvid>
  800046:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80004e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800053:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800058:	85 db                	test   %ebx,%ebx
  80005a:	7e 07                	jle    800063 <libmain+0x2d>
		binaryname = argv[0];
  80005c:	8b 06                	mov    (%esi),%eax
  80005e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800063:	83 ec 08             	sub    $0x8,%esp
  800066:	56                   	push   %esi
  800067:	53                   	push   %ebx
  800068:	e8 c6 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80006d:	e8 0a 00 00 00       	call   80007c <exit>
}
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800078:	5b                   	pop    %ebx
  800079:	5e                   	pop    %esi
  80007a:	5d                   	pop    %ebp
  80007b:	c3                   	ret    

0080007c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80007c:	55                   	push   %ebp
  80007d:	89 e5                	mov    %esp,%ebp
  80007f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800082:	e8 b3 04 00 00       	call   80053a <close_all>
	sys_env_destroy(0);
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	6a 00                	push   $0x0
  80008c:	e8 42 00 00 00       	call   8000d3 <sys_env_destroy>
}
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	c9                   	leave  
  800095:	c3                   	ret    

00800096 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	57                   	push   %edi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80009c:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a7:	89 c3                	mov    %eax,%ebx
  8000a9:	89 c7                	mov    %eax,%edi
  8000ab:	89 c6                	mov    %eax,%esi
  8000ad:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000af:	5b                   	pop    %ebx
  8000b0:	5e                   	pop    %esi
  8000b1:	5f                   	pop    %edi
  8000b2:	5d                   	pop    %ebp
  8000b3:	c3                   	ret    

008000b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b4:	55                   	push   %ebp
  8000b5:	89 e5                	mov    %esp,%ebp
  8000b7:	57                   	push   %edi
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8000bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c4:	89 d1                	mov    %edx,%ecx
  8000c6:	89 d3                	mov    %edx,%ebx
  8000c8:	89 d7                	mov    %edx,%edi
  8000ca:	89 d6                	mov    %edx,%esi
  8000cc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ce:	5b                   	pop    %ebx
  8000cf:	5e                   	pop    %esi
  8000d0:	5f                   	pop    %edi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e9:	89 cb                	mov    %ecx,%ebx
  8000eb:	89 cf                	mov    %ecx,%edi
  8000ed:	89 ce                	mov    %ecx,%esi
  8000ef:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f1:	85 c0                	test   %eax,%eax
  8000f3:	7f 08                	jg     8000fd <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f8:	5b                   	pop    %ebx
  8000f9:	5e                   	pop    %esi
  8000fa:	5f                   	pop    %edi
  8000fb:	5d                   	pop    %ebp
  8000fc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000fd:	83 ec 0c             	sub    $0xc,%esp
  800100:	50                   	push   %eax
  800101:	6a 03                	push   $0x3
  800103:	68 6a 22 80 00       	push   $0x80226a
  800108:	6a 23                	push   $0x23
  80010a:	68 87 22 80 00       	push   $0x802287
  80010f:	e8 b1 13 00 00       	call   8014c5 <_panic>

00800114 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800114:	55                   	push   %ebp
  800115:	89 e5                	mov    %esp,%ebp
  800117:	57                   	push   %edi
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
	asm volatile("int %1\n"
  80011a:	ba 00 00 00 00       	mov    $0x0,%edx
  80011f:	b8 02 00 00 00       	mov    $0x2,%eax
  800124:	89 d1                	mov    %edx,%ecx
  800126:	89 d3                	mov    %edx,%ebx
  800128:	89 d7                	mov    %edx,%edi
  80012a:	89 d6                	mov    %edx,%esi
  80012c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80012e:	5b                   	pop    %ebx
  80012f:	5e                   	pop    %esi
  800130:	5f                   	pop    %edi
  800131:	5d                   	pop    %ebp
  800132:	c3                   	ret    

00800133 <sys_yield>:

void
sys_yield(void)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	57                   	push   %edi
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
	asm volatile("int %1\n"
  800139:	ba 00 00 00 00       	mov    $0x0,%edx
  80013e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800143:	89 d1                	mov    %edx,%ecx
  800145:	89 d3                	mov    %edx,%ebx
  800147:	89 d7                	mov    %edx,%edi
  800149:	89 d6                	mov    %edx,%esi
  80014b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80014d:	5b                   	pop    %ebx
  80014e:	5e                   	pop    %esi
  80014f:	5f                   	pop    %edi
  800150:	5d                   	pop    %ebp
  800151:	c3                   	ret    

00800152 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800152:	55                   	push   %ebp
  800153:	89 e5                	mov    %esp,%ebp
  800155:	57                   	push   %edi
  800156:	56                   	push   %esi
  800157:	53                   	push   %ebx
  800158:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015b:	be 00 00 00 00       	mov    $0x0,%esi
  800160:	8b 55 08             	mov    0x8(%ebp),%edx
  800163:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800166:	b8 04 00 00 00       	mov    $0x4,%eax
  80016b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80016e:	89 f7                	mov    %esi,%edi
  800170:	cd 30                	int    $0x30
	if(check && ret > 0)
  800172:	85 c0                	test   %eax,%eax
  800174:	7f 08                	jg     80017e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800176:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5f                   	pop    %edi
  80017c:	5d                   	pop    %ebp
  80017d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	50                   	push   %eax
  800182:	6a 04                	push   $0x4
  800184:	68 6a 22 80 00       	push   $0x80226a
  800189:	6a 23                	push   $0x23
  80018b:	68 87 22 80 00       	push   $0x802287
  800190:	e8 30 13 00 00       	call   8014c5 <_panic>

00800195 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	57                   	push   %edi
  800199:	56                   	push   %esi
  80019a:	53                   	push   %ebx
  80019b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80019e:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a4:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ac:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001af:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	7f 08                	jg     8001c0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bb:	5b                   	pop    %ebx
  8001bc:	5e                   	pop    %esi
  8001bd:	5f                   	pop    %edi
  8001be:	5d                   	pop    %ebp
  8001bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	6a 05                	push   $0x5
  8001c6:	68 6a 22 80 00       	push   $0x80226a
  8001cb:	6a 23                	push   $0x23
  8001cd:	68 87 22 80 00       	push   $0x802287
  8001d2:	e8 ee 12 00 00       	call   8014c5 <_panic>

008001d7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	57                   	push   %edi
  8001db:	56                   	push   %esi
  8001dc:	53                   	push   %ebx
  8001dd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001eb:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f0:	89 df                	mov    %ebx,%edi
  8001f2:	89 de                	mov    %ebx,%esi
  8001f4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f6:	85 c0                	test   %eax,%eax
  8001f8:	7f 08                	jg     800202 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fd:	5b                   	pop    %ebx
  8001fe:	5e                   	pop    %esi
  8001ff:	5f                   	pop    %edi
  800200:	5d                   	pop    %ebp
  800201:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	6a 06                	push   $0x6
  800208:	68 6a 22 80 00       	push   $0x80226a
  80020d:	6a 23                	push   $0x23
  80020f:	68 87 22 80 00       	push   $0x802287
  800214:	e8 ac 12 00 00       	call   8014c5 <_panic>

00800219 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	57                   	push   %edi
  80021d:	56                   	push   %esi
  80021e:	53                   	push   %ebx
  80021f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800222:	bb 00 00 00 00       	mov    $0x0,%ebx
  800227:	8b 55 08             	mov    0x8(%ebp),%edx
  80022a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80022d:	b8 08 00 00 00       	mov    $0x8,%eax
  800232:	89 df                	mov    %ebx,%edi
  800234:	89 de                	mov    %ebx,%esi
  800236:	cd 30                	int    $0x30
	if(check && ret > 0)
  800238:	85 c0                	test   %eax,%eax
  80023a:	7f 08                	jg     800244 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80023c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023f:	5b                   	pop    %ebx
  800240:	5e                   	pop    %esi
  800241:	5f                   	pop    %edi
  800242:	5d                   	pop    %ebp
  800243:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	50                   	push   %eax
  800248:	6a 08                	push   $0x8
  80024a:	68 6a 22 80 00       	push   $0x80226a
  80024f:	6a 23                	push   $0x23
  800251:	68 87 22 80 00       	push   $0x802287
  800256:	e8 6a 12 00 00       	call   8014c5 <_panic>

0080025b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	57                   	push   %edi
  80025f:	56                   	push   %esi
  800260:	53                   	push   %ebx
  800261:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800264:	bb 00 00 00 00       	mov    $0x0,%ebx
  800269:	8b 55 08             	mov    0x8(%ebp),%edx
  80026c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026f:	b8 09 00 00 00       	mov    $0x9,%eax
  800274:	89 df                	mov    %ebx,%edi
  800276:	89 de                	mov    %ebx,%esi
  800278:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027a:	85 c0                	test   %eax,%eax
  80027c:	7f 08                	jg     800286 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80027e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800281:	5b                   	pop    %ebx
  800282:	5e                   	pop    %esi
  800283:	5f                   	pop    %edi
  800284:	5d                   	pop    %ebp
  800285:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	6a 09                	push   $0x9
  80028c:	68 6a 22 80 00       	push   $0x80226a
  800291:	6a 23                	push   $0x23
  800293:	68 87 22 80 00       	push   $0x802287
  800298:	e8 28 12 00 00       	call   8014c5 <_panic>

0080029d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	57                   	push   %edi
  8002a1:	56                   	push   %esi
  8002a2:	53                   	push   %ebx
  8002a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b6:	89 df                	mov    %ebx,%edi
  8002b8:	89 de                	mov    %ebx,%esi
  8002ba:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002bc:	85 c0                	test   %eax,%eax
  8002be:	7f 08                	jg     8002c8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c3:	5b                   	pop    %ebx
  8002c4:	5e                   	pop    %esi
  8002c5:	5f                   	pop    %edi
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	6a 0a                	push   $0xa
  8002ce:	68 6a 22 80 00       	push   $0x80226a
  8002d3:	6a 23                	push   $0x23
  8002d5:	68 87 22 80 00       	push   $0x802287
  8002da:	e8 e6 11 00 00       	call   8014c5 <_panic>

008002df <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	57                   	push   %edi
  8002e3:	56                   	push   %esi
  8002e4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002eb:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f0:	be 00 00 00 00       	mov    $0x0,%esi
  8002f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002f8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002fb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002fd:	5b                   	pop    %ebx
  8002fe:	5e                   	pop    %esi
  8002ff:	5f                   	pop    %edi
  800300:	5d                   	pop    %ebp
  800301:	c3                   	ret    

00800302 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	57                   	push   %edi
  800306:	56                   	push   %esi
  800307:	53                   	push   %ebx
  800308:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800310:	8b 55 08             	mov    0x8(%ebp),%edx
  800313:	b8 0d 00 00 00       	mov    $0xd,%eax
  800318:	89 cb                	mov    %ecx,%ebx
  80031a:	89 cf                	mov    %ecx,%edi
  80031c:	89 ce                	mov    %ecx,%esi
  80031e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800320:	85 c0                	test   %eax,%eax
  800322:	7f 08                	jg     80032c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800324:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800327:	5b                   	pop    %ebx
  800328:	5e                   	pop    %esi
  800329:	5f                   	pop    %edi
  80032a:	5d                   	pop    %ebp
  80032b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	50                   	push   %eax
  800330:	6a 0d                	push   $0xd
  800332:	68 6a 22 80 00       	push   $0x80226a
  800337:	6a 23                	push   $0x23
  800339:	68 87 22 80 00       	push   $0x802287
  80033e:	e8 82 11 00 00       	call   8014c5 <_panic>

00800343 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	57                   	push   %edi
  800347:	56                   	push   %esi
  800348:	53                   	push   %ebx
	asm volatile("int %1\n"
  800349:	ba 00 00 00 00       	mov    $0x0,%edx
  80034e:	b8 0e 00 00 00       	mov    $0xe,%eax
  800353:	89 d1                	mov    %edx,%ecx
  800355:	89 d3                	mov    %edx,%ebx
  800357:	89 d7                	mov    %edx,%edi
  800359:	89 d6                	mov    %edx,%esi
  80035b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80035d:	5b                   	pop    %ebx
  80035e:	5e                   	pop    %esi
  80035f:	5f                   	pop    %edi
  800360:	5d                   	pop    %ebp
  800361:	c3                   	ret    

00800362 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	05 00 00 00 30       	add    $0x30000000,%eax
  80036d:	c1 e8 0c             	shr    $0xc,%eax
}
  800370:	5d                   	pop    %ebp
  800371:	c3                   	ret    

00800372 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80037d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800382:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800387:	5d                   	pop    %ebp
  800388:	c3                   	ret    

00800389 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800391:	89 c2                	mov    %eax,%edx
  800393:	c1 ea 16             	shr    $0x16,%edx
  800396:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80039d:	f6 c2 01             	test   $0x1,%dl
  8003a0:	74 2d                	je     8003cf <fd_alloc+0x46>
  8003a2:	89 c2                	mov    %eax,%edx
  8003a4:	c1 ea 0c             	shr    $0xc,%edx
  8003a7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003ae:	f6 c2 01             	test   $0x1,%dl
  8003b1:	74 1c                	je     8003cf <fd_alloc+0x46>
  8003b3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003b8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003bd:	75 d2                	jne    800391 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8003c8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003cd:	eb 0a                	jmp    8003d9 <fd_alloc+0x50>
			*fd_store = fd;
  8003cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003d9:	5d                   	pop    %ebp
  8003da:	c3                   	ret    

008003db <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003e1:	83 f8 1f             	cmp    $0x1f,%eax
  8003e4:	77 30                	ja     800416 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003e6:	c1 e0 0c             	shl    $0xc,%eax
  8003e9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003ee:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8003f4:	f6 c2 01             	test   $0x1,%dl
  8003f7:	74 24                	je     80041d <fd_lookup+0x42>
  8003f9:	89 c2                	mov    %eax,%edx
  8003fb:	c1 ea 0c             	shr    $0xc,%edx
  8003fe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800405:	f6 c2 01             	test   $0x1,%dl
  800408:	74 1a                	je     800424 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80040a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80040d:	89 02                	mov    %eax,(%edx)
	return 0;
  80040f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800414:	5d                   	pop    %ebp
  800415:	c3                   	ret    
		return -E_INVAL;
  800416:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80041b:	eb f7                	jmp    800414 <fd_lookup+0x39>
		return -E_INVAL;
  80041d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800422:	eb f0                	jmp    800414 <fd_lookup+0x39>
  800424:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800429:	eb e9                	jmp    800414 <fd_lookup+0x39>

0080042b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
  80042e:	83 ec 08             	sub    $0x8,%esp
  800431:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800434:	ba 00 00 00 00       	mov    $0x0,%edx
  800439:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80043e:	39 08                	cmp    %ecx,(%eax)
  800440:	74 38                	je     80047a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800442:	83 c2 01             	add    $0x1,%edx
  800445:	8b 04 95 14 23 80 00 	mov    0x802314(,%edx,4),%eax
  80044c:	85 c0                	test   %eax,%eax
  80044e:	75 ee                	jne    80043e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800450:	a1 08 40 80 00       	mov    0x804008,%eax
  800455:	8b 40 48             	mov    0x48(%eax),%eax
  800458:	83 ec 04             	sub    $0x4,%esp
  80045b:	51                   	push   %ecx
  80045c:	50                   	push   %eax
  80045d:	68 98 22 80 00       	push   $0x802298
  800462:	e8 39 11 00 00       	call   8015a0 <cprintf>
	*dev = 0;
  800467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800470:	83 c4 10             	add    $0x10,%esp
  800473:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800478:	c9                   	leave  
  800479:	c3                   	ret    
			*dev = devtab[i];
  80047a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80047d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80047f:	b8 00 00 00 00       	mov    $0x0,%eax
  800484:	eb f2                	jmp    800478 <dev_lookup+0x4d>

00800486 <fd_close>:
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	57                   	push   %edi
  80048a:	56                   	push   %esi
  80048b:	53                   	push   %ebx
  80048c:	83 ec 24             	sub    $0x24,%esp
  80048f:	8b 75 08             	mov    0x8(%ebp),%esi
  800492:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800495:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800498:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800499:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80049f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a2:	50                   	push   %eax
  8004a3:	e8 33 ff ff ff       	call   8003db <fd_lookup>
  8004a8:	89 c3                	mov    %eax,%ebx
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	85 c0                	test   %eax,%eax
  8004af:	78 05                	js     8004b6 <fd_close+0x30>
	    || fd != fd2)
  8004b1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004b4:	74 16                	je     8004cc <fd_close+0x46>
		return (must_exist ? r : 0);
  8004b6:	89 f8                	mov    %edi,%eax
  8004b8:	84 c0                	test   %al,%al
  8004ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bf:	0f 44 d8             	cmove  %eax,%ebx
}
  8004c2:	89 d8                	mov    %ebx,%eax
  8004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004c7:	5b                   	pop    %ebx
  8004c8:	5e                   	pop    %esi
  8004c9:	5f                   	pop    %edi
  8004ca:	5d                   	pop    %ebp
  8004cb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004d2:	50                   	push   %eax
  8004d3:	ff 36                	pushl  (%esi)
  8004d5:	e8 51 ff ff ff       	call   80042b <dev_lookup>
  8004da:	89 c3                	mov    %eax,%ebx
  8004dc:	83 c4 10             	add    $0x10,%esp
  8004df:	85 c0                	test   %eax,%eax
  8004e1:	78 1a                	js     8004fd <fd_close+0x77>
		if (dev->dev_close)
  8004e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8004e9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8004ee:	85 c0                	test   %eax,%eax
  8004f0:	74 0b                	je     8004fd <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	56                   	push   %esi
  8004f6:	ff d0                	call   *%eax
  8004f8:	89 c3                	mov    %eax,%ebx
  8004fa:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	56                   	push   %esi
  800501:	6a 00                	push   $0x0
  800503:	e8 cf fc ff ff       	call   8001d7 <sys_page_unmap>
	return r;
  800508:	83 c4 10             	add    $0x10,%esp
  80050b:	eb b5                	jmp    8004c2 <fd_close+0x3c>

0080050d <close>:

int
close(int fdnum)
{
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800513:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800516:	50                   	push   %eax
  800517:	ff 75 08             	pushl  0x8(%ebp)
  80051a:	e8 bc fe ff ff       	call   8003db <fd_lookup>
  80051f:	83 c4 10             	add    $0x10,%esp
  800522:	85 c0                	test   %eax,%eax
  800524:	79 02                	jns    800528 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800526:	c9                   	leave  
  800527:	c3                   	ret    
		return fd_close(fd, 1);
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	6a 01                	push   $0x1
  80052d:	ff 75 f4             	pushl  -0xc(%ebp)
  800530:	e8 51 ff ff ff       	call   800486 <fd_close>
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	eb ec                	jmp    800526 <close+0x19>

0080053a <close_all>:

void
close_all(void)
{
  80053a:	55                   	push   %ebp
  80053b:	89 e5                	mov    %esp,%ebp
  80053d:	53                   	push   %ebx
  80053e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800541:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	53                   	push   %ebx
  80054a:	e8 be ff ff ff       	call   80050d <close>
	for (i = 0; i < MAXFD; i++)
  80054f:	83 c3 01             	add    $0x1,%ebx
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	83 fb 20             	cmp    $0x20,%ebx
  800558:	75 ec                	jne    800546 <close_all+0xc>
}
  80055a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055d:	c9                   	leave  
  80055e:	c3                   	ret    

0080055f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80055f:	55                   	push   %ebp
  800560:	89 e5                	mov    %esp,%ebp
  800562:	57                   	push   %edi
  800563:	56                   	push   %esi
  800564:	53                   	push   %ebx
  800565:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800568:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80056b:	50                   	push   %eax
  80056c:	ff 75 08             	pushl  0x8(%ebp)
  80056f:	e8 67 fe ff ff       	call   8003db <fd_lookup>
  800574:	89 c3                	mov    %eax,%ebx
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	85 c0                	test   %eax,%eax
  80057b:	0f 88 81 00 00 00    	js     800602 <dup+0xa3>
		return r;
	close(newfdnum);
  800581:	83 ec 0c             	sub    $0xc,%esp
  800584:	ff 75 0c             	pushl  0xc(%ebp)
  800587:	e8 81 ff ff ff       	call   80050d <close>

	newfd = INDEX2FD(newfdnum);
  80058c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80058f:	c1 e6 0c             	shl    $0xc,%esi
  800592:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800598:	83 c4 04             	add    $0x4,%esp
  80059b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80059e:	e8 cf fd ff ff       	call   800372 <fd2data>
  8005a3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005a5:	89 34 24             	mov    %esi,(%esp)
  8005a8:	e8 c5 fd ff ff       	call   800372 <fd2data>
  8005ad:	83 c4 10             	add    $0x10,%esp
  8005b0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005b2:	89 d8                	mov    %ebx,%eax
  8005b4:	c1 e8 16             	shr    $0x16,%eax
  8005b7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005be:	a8 01                	test   $0x1,%al
  8005c0:	74 11                	je     8005d3 <dup+0x74>
  8005c2:	89 d8                	mov    %ebx,%eax
  8005c4:	c1 e8 0c             	shr    $0xc,%eax
  8005c7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005ce:	f6 c2 01             	test   $0x1,%dl
  8005d1:	75 39                	jne    80060c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d6:	89 d0                	mov    %edx,%eax
  8005d8:	c1 e8 0c             	shr    $0xc,%eax
  8005db:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005e2:	83 ec 0c             	sub    $0xc,%esp
  8005e5:	25 07 0e 00 00       	and    $0xe07,%eax
  8005ea:	50                   	push   %eax
  8005eb:	56                   	push   %esi
  8005ec:	6a 00                	push   $0x0
  8005ee:	52                   	push   %edx
  8005ef:	6a 00                	push   $0x0
  8005f1:	e8 9f fb ff ff       	call   800195 <sys_page_map>
  8005f6:	89 c3                	mov    %eax,%ebx
  8005f8:	83 c4 20             	add    $0x20,%esp
  8005fb:	85 c0                	test   %eax,%eax
  8005fd:	78 31                	js     800630 <dup+0xd1>
		goto err;

	return newfdnum;
  8005ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800602:	89 d8                	mov    %ebx,%eax
  800604:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800607:	5b                   	pop    %ebx
  800608:	5e                   	pop    %esi
  800609:	5f                   	pop    %edi
  80060a:	5d                   	pop    %ebp
  80060b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80060c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800613:	83 ec 0c             	sub    $0xc,%esp
  800616:	25 07 0e 00 00       	and    $0xe07,%eax
  80061b:	50                   	push   %eax
  80061c:	57                   	push   %edi
  80061d:	6a 00                	push   $0x0
  80061f:	53                   	push   %ebx
  800620:	6a 00                	push   $0x0
  800622:	e8 6e fb ff ff       	call   800195 <sys_page_map>
  800627:	89 c3                	mov    %eax,%ebx
  800629:	83 c4 20             	add    $0x20,%esp
  80062c:	85 c0                	test   %eax,%eax
  80062e:	79 a3                	jns    8005d3 <dup+0x74>
	sys_page_unmap(0, newfd);
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	56                   	push   %esi
  800634:	6a 00                	push   $0x0
  800636:	e8 9c fb ff ff       	call   8001d7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80063b:	83 c4 08             	add    $0x8,%esp
  80063e:	57                   	push   %edi
  80063f:	6a 00                	push   $0x0
  800641:	e8 91 fb ff ff       	call   8001d7 <sys_page_unmap>
	return r;
  800646:	83 c4 10             	add    $0x10,%esp
  800649:	eb b7                	jmp    800602 <dup+0xa3>

0080064b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
  80064e:	53                   	push   %ebx
  80064f:	83 ec 1c             	sub    $0x1c,%esp
  800652:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800655:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800658:	50                   	push   %eax
  800659:	53                   	push   %ebx
  80065a:	e8 7c fd ff ff       	call   8003db <fd_lookup>
  80065f:	83 c4 10             	add    $0x10,%esp
  800662:	85 c0                	test   %eax,%eax
  800664:	78 3f                	js     8006a5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80066c:	50                   	push   %eax
  80066d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800670:	ff 30                	pushl  (%eax)
  800672:	e8 b4 fd ff ff       	call   80042b <dev_lookup>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	85 c0                	test   %eax,%eax
  80067c:	78 27                	js     8006a5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80067e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800681:	8b 42 08             	mov    0x8(%edx),%eax
  800684:	83 e0 03             	and    $0x3,%eax
  800687:	83 f8 01             	cmp    $0x1,%eax
  80068a:	74 1e                	je     8006aa <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80068c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068f:	8b 40 08             	mov    0x8(%eax),%eax
  800692:	85 c0                	test   %eax,%eax
  800694:	74 35                	je     8006cb <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800696:	83 ec 04             	sub    $0x4,%esp
  800699:	ff 75 10             	pushl  0x10(%ebp)
  80069c:	ff 75 0c             	pushl  0xc(%ebp)
  80069f:	52                   	push   %edx
  8006a0:	ff d0                	call   *%eax
  8006a2:	83 c4 10             	add    $0x10,%esp
}
  8006a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a8:	c9                   	leave  
  8006a9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006aa:	a1 08 40 80 00       	mov    0x804008,%eax
  8006af:	8b 40 48             	mov    0x48(%eax),%eax
  8006b2:	83 ec 04             	sub    $0x4,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	50                   	push   %eax
  8006b7:	68 d9 22 80 00       	push   $0x8022d9
  8006bc:	e8 df 0e 00 00       	call   8015a0 <cprintf>
		return -E_INVAL;
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006c9:	eb da                	jmp    8006a5 <read+0x5a>
		return -E_NOT_SUPP;
  8006cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006d0:	eb d3                	jmp    8006a5 <read+0x5a>

008006d2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	57                   	push   %edi
  8006d6:	56                   	push   %esi
  8006d7:	53                   	push   %ebx
  8006d8:	83 ec 0c             	sub    $0xc,%esp
  8006db:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006de:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e6:	39 f3                	cmp    %esi,%ebx
  8006e8:	73 23                	jae    80070d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006ea:	83 ec 04             	sub    $0x4,%esp
  8006ed:	89 f0                	mov    %esi,%eax
  8006ef:	29 d8                	sub    %ebx,%eax
  8006f1:	50                   	push   %eax
  8006f2:	89 d8                	mov    %ebx,%eax
  8006f4:	03 45 0c             	add    0xc(%ebp),%eax
  8006f7:	50                   	push   %eax
  8006f8:	57                   	push   %edi
  8006f9:	e8 4d ff ff ff       	call   80064b <read>
		if (m < 0)
  8006fe:	83 c4 10             	add    $0x10,%esp
  800701:	85 c0                	test   %eax,%eax
  800703:	78 06                	js     80070b <readn+0x39>
			return m;
		if (m == 0)
  800705:	74 06                	je     80070d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  800707:	01 c3                	add    %eax,%ebx
  800709:	eb db                	jmp    8006e6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80070b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80070d:	89 d8                	mov    %ebx,%eax
  80070f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800712:	5b                   	pop    %ebx
  800713:	5e                   	pop    %esi
  800714:	5f                   	pop    %edi
  800715:	5d                   	pop    %ebp
  800716:	c3                   	ret    

00800717 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	53                   	push   %ebx
  80071b:	83 ec 1c             	sub    $0x1c,%esp
  80071e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800721:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800724:	50                   	push   %eax
  800725:	53                   	push   %ebx
  800726:	e8 b0 fc ff ff       	call   8003db <fd_lookup>
  80072b:	83 c4 10             	add    $0x10,%esp
  80072e:	85 c0                	test   %eax,%eax
  800730:	78 3a                	js     80076c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800738:	50                   	push   %eax
  800739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073c:	ff 30                	pushl  (%eax)
  80073e:	e8 e8 fc ff ff       	call   80042b <dev_lookup>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	85 c0                	test   %eax,%eax
  800748:	78 22                	js     80076c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80074a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800751:	74 1e                	je     800771 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800753:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800756:	8b 52 0c             	mov    0xc(%edx),%edx
  800759:	85 d2                	test   %edx,%edx
  80075b:	74 35                	je     800792 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80075d:	83 ec 04             	sub    $0x4,%esp
  800760:	ff 75 10             	pushl  0x10(%ebp)
  800763:	ff 75 0c             	pushl  0xc(%ebp)
  800766:	50                   	push   %eax
  800767:	ff d2                	call   *%edx
  800769:	83 c4 10             	add    $0x10,%esp
}
  80076c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80076f:	c9                   	leave  
  800770:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800771:	a1 08 40 80 00       	mov    0x804008,%eax
  800776:	8b 40 48             	mov    0x48(%eax),%eax
  800779:	83 ec 04             	sub    $0x4,%esp
  80077c:	53                   	push   %ebx
  80077d:	50                   	push   %eax
  80077e:	68 f5 22 80 00       	push   $0x8022f5
  800783:	e8 18 0e 00 00       	call   8015a0 <cprintf>
		return -E_INVAL;
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800790:	eb da                	jmp    80076c <write+0x55>
		return -E_NOT_SUPP;
  800792:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800797:	eb d3                	jmp    80076c <write+0x55>

00800799 <seek>:

int
seek(int fdnum, off_t offset)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80079f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007a2:	50                   	push   %eax
  8007a3:	ff 75 08             	pushl  0x8(%ebp)
  8007a6:	e8 30 fc ff ff       	call   8003db <fd_lookup>
  8007ab:	83 c4 10             	add    $0x10,%esp
  8007ae:	85 c0                	test   %eax,%eax
  8007b0:	78 0e                	js     8007c0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007c0:	c9                   	leave  
  8007c1:	c3                   	ret    

008007c2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	53                   	push   %ebx
  8007c6:	83 ec 1c             	sub    $0x1c,%esp
  8007c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007cf:	50                   	push   %eax
  8007d0:	53                   	push   %ebx
  8007d1:	e8 05 fc ff ff       	call   8003db <fd_lookup>
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	85 c0                	test   %eax,%eax
  8007db:	78 37                	js     800814 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007e3:	50                   	push   %eax
  8007e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e7:	ff 30                	pushl  (%eax)
  8007e9:	e8 3d fc ff ff       	call   80042b <dev_lookup>
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	85 c0                	test   %eax,%eax
  8007f3:	78 1f                	js     800814 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007fc:	74 1b                	je     800819 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8007fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800801:	8b 52 18             	mov    0x18(%edx),%edx
  800804:	85 d2                	test   %edx,%edx
  800806:	74 32                	je     80083a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	ff d2                	call   *%edx
  800811:	83 c4 10             	add    $0x10,%esp
}
  800814:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800817:	c9                   	leave  
  800818:	c3                   	ret    
			thisenv->env_id, fdnum);
  800819:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80081e:	8b 40 48             	mov    0x48(%eax),%eax
  800821:	83 ec 04             	sub    $0x4,%esp
  800824:	53                   	push   %ebx
  800825:	50                   	push   %eax
  800826:	68 b8 22 80 00       	push   $0x8022b8
  80082b:	e8 70 0d 00 00       	call   8015a0 <cprintf>
		return -E_INVAL;
  800830:	83 c4 10             	add    $0x10,%esp
  800833:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800838:	eb da                	jmp    800814 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80083a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80083f:	eb d3                	jmp    800814 <ftruncate+0x52>

00800841 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800841:	55                   	push   %ebp
  800842:	89 e5                	mov    %esp,%ebp
  800844:	53                   	push   %ebx
  800845:	83 ec 1c             	sub    $0x1c,%esp
  800848:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80084b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80084e:	50                   	push   %eax
  80084f:	ff 75 08             	pushl  0x8(%ebp)
  800852:	e8 84 fb ff ff       	call   8003db <fd_lookup>
  800857:	83 c4 10             	add    $0x10,%esp
  80085a:	85 c0                	test   %eax,%eax
  80085c:	78 4b                	js     8008a9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800864:	50                   	push   %eax
  800865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800868:	ff 30                	pushl  (%eax)
  80086a:	e8 bc fb ff ff       	call   80042b <dev_lookup>
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	85 c0                	test   %eax,%eax
  800874:	78 33                	js     8008a9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800879:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80087d:	74 2f                	je     8008ae <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80087f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800882:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800889:	00 00 00 
	stat->st_isdir = 0;
  80088c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800893:	00 00 00 
	stat->st_dev = dev;
  800896:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	53                   	push   %ebx
  8008a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a3:	ff 50 14             	call   *0x14(%eax)
  8008a6:	83 c4 10             	add    $0x10,%esp
}
  8008a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ac:	c9                   	leave  
  8008ad:	c3                   	ret    
		return -E_NOT_SUPP;
  8008ae:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008b3:	eb f4                	jmp    8008a9 <fstat+0x68>

008008b5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	56                   	push   %esi
  8008b9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	6a 00                	push   $0x0
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 2f 02 00 00       	call   800af6 <open>
  8008c7:	89 c3                	mov    %eax,%ebx
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	85 c0                	test   %eax,%eax
  8008ce:	78 1b                	js     8008eb <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	e8 65 ff ff ff       	call   800841 <fstat>
  8008dc:	89 c6                	mov    %eax,%esi
	close(fd);
  8008de:	89 1c 24             	mov    %ebx,(%esp)
  8008e1:	e8 27 fc ff ff       	call   80050d <close>
	return r;
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	89 f3                	mov    %esi,%ebx
}
  8008eb:	89 d8                	mov    %ebx,%eax
  8008ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f0:	5b                   	pop    %ebx
  8008f1:	5e                   	pop    %esi
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	56                   	push   %esi
  8008f8:	53                   	push   %ebx
  8008f9:	89 c6                	mov    %eax,%esi
  8008fb:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8008fd:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800904:	74 27                	je     80092d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800906:	6a 07                	push   $0x7
  800908:	68 00 50 80 00       	push   $0x805000
  80090d:	56                   	push   %esi
  80090e:	ff 35 00 40 80 00    	pushl  0x804000
  800914:	e8 0c 16 00 00       	call   801f25 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800919:	83 c4 0c             	add    $0xc,%esp
  80091c:	6a 00                	push   $0x0
  80091e:	53                   	push   %ebx
  80091f:	6a 00                	push   $0x0
  800921:	e8 8c 15 00 00       	call   801eb2 <ipc_recv>
}
  800926:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800929:	5b                   	pop    %ebx
  80092a:	5e                   	pop    %esi
  80092b:	5d                   	pop    %ebp
  80092c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80092d:	83 ec 0c             	sub    $0xc,%esp
  800930:	6a 01                	push   $0x1
  800932:	e8 5a 16 00 00       	call   801f91 <ipc_find_env>
  800937:	a3 00 40 80 00       	mov    %eax,0x804000
  80093c:	83 c4 10             	add    $0x10,%esp
  80093f:	eb c5                	jmp    800906 <fsipc+0x12>

00800941 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	8b 40 0c             	mov    0xc(%eax),%eax
  80094d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800952:	8b 45 0c             	mov    0xc(%ebp),%eax
  800955:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80095a:	ba 00 00 00 00       	mov    $0x0,%edx
  80095f:	b8 02 00 00 00       	mov    $0x2,%eax
  800964:	e8 8b ff ff ff       	call   8008f4 <fsipc>
}
  800969:	c9                   	leave  
  80096a:	c3                   	ret    

0080096b <devfile_flush>:
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	8b 40 0c             	mov    0xc(%eax),%eax
  800977:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80097c:	ba 00 00 00 00       	mov    $0x0,%edx
  800981:	b8 06 00 00 00       	mov    $0x6,%eax
  800986:	e8 69 ff ff ff       	call   8008f4 <fsipc>
}
  80098b:	c9                   	leave  
  80098c:	c3                   	ret    

0080098d <devfile_stat>:
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	53                   	push   %ebx
  800991:	83 ec 04             	sub    $0x4,%esp
  800994:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8b 40 0c             	mov    0xc(%eax),%eax
  80099d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8009ac:	e8 43 ff ff ff       	call   8008f4 <fsipc>
  8009b1:	85 c0                	test   %eax,%eax
  8009b3:	78 2c                	js     8009e1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	68 00 50 80 00       	push   $0x805000
  8009bd:	53                   	push   %ebx
  8009be:	e8 b9 11 00 00       	call   801b7c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009c3:	a1 80 50 80 00       	mov    0x805080,%eax
  8009c8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009ce:	a1 84 50 80 00       	mov    0x805084,%eax
  8009d3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009d9:	83 c4 10             	add    $0x10,%esp
  8009dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e4:	c9                   	leave  
  8009e5:	c3                   	ret    

008009e6 <devfile_write>:
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	53                   	push   %ebx
  8009ea:	83 ec 04             	sub    $0x4,%esp
  8009ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8009f0:	85 db                	test   %ebx,%ebx
  8009f2:	75 07                	jne    8009fb <devfile_write+0x15>
	return n_all;
  8009f4:	89 d8                	mov    %ebx,%eax
}
  8009f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	8b 40 0c             	mov    0xc(%eax),%eax
  800a01:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  800a06:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	53                   	push   %ebx
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	68 08 50 80 00       	push   $0x805008
  800a18:	e8 ed 12 00 00       	call   801d0a <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a22:	b8 04 00 00 00       	mov    $0x4,%eax
  800a27:	e8 c8 fe ff ff       	call   8008f4 <fsipc>
  800a2c:	83 c4 10             	add    $0x10,%esp
  800a2f:	85 c0                	test   %eax,%eax
  800a31:	78 c3                	js     8009f6 <devfile_write+0x10>
	  assert(r <= n_left);
  800a33:	39 d8                	cmp    %ebx,%eax
  800a35:	77 0b                	ja     800a42 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  800a37:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a3c:	7f 1d                	jg     800a5b <devfile_write+0x75>
    n_all += r;
  800a3e:	89 c3                	mov    %eax,%ebx
  800a40:	eb b2                	jmp    8009f4 <devfile_write+0xe>
	  assert(r <= n_left);
  800a42:	68 28 23 80 00       	push   $0x802328
  800a47:	68 34 23 80 00       	push   $0x802334
  800a4c:	68 9f 00 00 00       	push   $0x9f
  800a51:	68 49 23 80 00       	push   $0x802349
  800a56:	e8 6a 0a 00 00       	call   8014c5 <_panic>
	  assert(r <= PGSIZE);
  800a5b:	68 54 23 80 00       	push   $0x802354
  800a60:	68 34 23 80 00       	push   $0x802334
  800a65:	68 a0 00 00 00       	push   $0xa0
  800a6a:	68 49 23 80 00       	push   $0x802349
  800a6f:	e8 51 0a 00 00       	call   8014c5 <_panic>

00800a74 <devfile_read>:
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	56                   	push   %esi
  800a78:	53                   	push   %ebx
  800a79:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	8b 40 0c             	mov    0xc(%eax),%eax
  800a82:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a87:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a92:	b8 03 00 00 00       	mov    $0x3,%eax
  800a97:	e8 58 fe ff ff       	call   8008f4 <fsipc>
  800a9c:	89 c3                	mov    %eax,%ebx
  800a9e:	85 c0                	test   %eax,%eax
  800aa0:	78 1f                	js     800ac1 <devfile_read+0x4d>
	assert(r <= n);
  800aa2:	39 f0                	cmp    %esi,%eax
  800aa4:	77 24                	ja     800aca <devfile_read+0x56>
	assert(r <= PGSIZE);
  800aa6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aab:	7f 33                	jg     800ae0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800aad:	83 ec 04             	sub    $0x4,%esp
  800ab0:	50                   	push   %eax
  800ab1:	68 00 50 80 00       	push   $0x805000
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	e8 4c 12 00 00       	call   801d0a <memmove>
	return r;
  800abe:	83 c4 10             	add    $0x10,%esp
}
  800ac1:	89 d8                	mov    %ebx,%eax
  800ac3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac6:	5b                   	pop    %ebx
  800ac7:	5e                   	pop    %esi
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    
	assert(r <= n);
  800aca:	68 60 23 80 00       	push   $0x802360
  800acf:	68 34 23 80 00       	push   $0x802334
  800ad4:	6a 7c                	push   $0x7c
  800ad6:	68 49 23 80 00       	push   $0x802349
  800adb:	e8 e5 09 00 00       	call   8014c5 <_panic>
	assert(r <= PGSIZE);
  800ae0:	68 54 23 80 00       	push   $0x802354
  800ae5:	68 34 23 80 00       	push   $0x802334
  800aea:	6a 7d                	push   $0x7d
  800aec:	68 49 23 80 00       	push   $0x802349
  800af1:	e8 cf 09 00 00       	call   8014c5 <_panic>

00800af6 <open>:
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	56                   	push   %esi
  800afa:	53                   	push   %ebx
  800afb:	83 ec 1c             	sub    $0x1c,%esp
  800afe:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b01:	56                   	push   %esi
  800b02:	e8 3c 10 00 00       	call   801b43 <strlen>
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b0f:	7f 6c                	jg     800b7d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b11:	83 ec 0c             	sub    $0xc,%esp
  800b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b17:	50                   	push   %eax
  800b18:	e8 6c f8 ff ff       	call   800389 <fd_alloc>
  800b1d:	89 c3                	mov    %eax,%ebx
  800b1f:	83 c4 10             	add    $0x10,%esp
  800b22:	85 c0                	test   %eax,%eax
  800b24:	78 3c                	js     800b62 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	56                   	push   %esi
  800b2a:	68 00 50 80 00       	push   $0x805000
  800b2f:	e8 48 10 00 00       	call   801b7c <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b3f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b44:	e8 ab fd ff ff       	call   8008f4 <fsipc>
  800b49:	89 c3                	mov    %eax,%ebx
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	85 c0                	test   %eax,%eax
  800b50:	78 19                	js     800b6b <open+0x75>
	return fd2num(fd);
  800b52:	83 ec 0c             	sub    $0xc,%esp
  800b55:	ff 75 f4             	pushl  -0xc(%ebp)
  800b58:	e8 05 f8 ff ff       	call   800362 <fd2num>
  800b5d:	89 c3                	mov    %eax,%ebx
  800b5f:	83 c4 10             	add    $0x10,%esp
}
  800b62:	89 d8                	mov    %ebx,%eax
  800b64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b67:	5b                   	pop    %ebx
  800b68:	5e                   	pop    %esi
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    
		fd_close(fd, 0);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	6a 00                	push   $0x0
  800b70:	ff 75 f4             	pushl  -0xc(%ebp)
  800b73:	e8 0e f9 ff ff       	call   800486 <fd_close>
		return r;
  800b78:	83 c4 10             	add    $0x10,%esp
  800b7b:	eb e5                	jmp    800b62 <open+0x6c>
		return -E_BAD_PATH;
  800b7d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b82:	eb de                	jmp    800b62 <open+0x6c>

00800b84 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	b8 08 00 00 00       	mov    $0x8,%eax
  800b94:	e8 5b fd ff ff       	call   8008f4 <fsipc>
}
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	56                   	push   %esi
  800b9f:	53                   	push   %ebx
  800ba0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800ba3:	83 ec 0c             	sub    $0xc,%esp
  800ba6:	ff 75 08             	pushl  0x8(%ebp)
  800ba9:	e8 c4 f7 ff ff       	call   800372 <fd2data>
  800bae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bb0:	83 c4 08             	add    $0x8,%esp
  800bb3:	68 67 23 80 00       	push   $0x802367
  800bb8:	53                   	push   %ebx
  800bb9:	e8 be 0f 00 00       	call   801b7c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bbe:	8b 46 04             	mov    0x4(%esi),%eax
  800bc1:	2b 06                	sub    (%esi),%eax
  800bc3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bc9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bd0:	00 00 00 
	stat->st_dev = &devpipe;
  800bd3:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bda:	30 80 00 
	return 0;
}
  800bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800be2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be5:	5b                   	pop    %ebx
  800be6:	5e                   	pop    %esi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	53                   	push   %ebx
  800bed:	83 ec 0c             	sub    $0xc,%esp
  800bf0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bf3:	53                   	push   %ebx
  800bf4:	6a 00                	push   $0x0
  800bf6:	e8 dc f5 ff ff       	call   8001d7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800bfb:	89 1c 24             	mov    %ebx,(%esp)
  800bfe:	e8 6f f7 ff ff       	call   800372 <fd2data>
  800c03:	83 c4 08             	add    $0x8,%esp
  800c06:	50                   	push   %eax
  800c07:	6a 00                	push   $0x0
  800c09:	e8 c9 f5 ff ff       	call   8001d7 <sys_page_unmap>
}
  800c0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c11:	c9                   	leave  
  800c12:	c3                   	ret    

00800c13 <_pipeisclosed>:
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	57                   	push   %edi
  800c17:	56                   	push   %esi
  800c18:	53                   	push   %ebx
  800c19:	83 ec 1c             	sub    $0x1c,%esp
  800c1c:	89 c7                	mov    %eax,%edi
  800c1e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c20:	a1 08 40 80 00       	mov    0x804008,%eax
  800c25:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c28:	83 ec 0c             	sub    $0xc,%esp
  800c2b:	57                   	push   %edi
  800c2c:	e8 99 13 00 00       	call   801fca <pageref>
  800c31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c34:	89 34 24             	mov    %esi,(%esp)
  800c37:	e8 8e 13 00 00       	call   801fca <pageref>
		nn = thisenv->env_runs;
  800c3c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c42:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	39 cb                	cmp    %ecx,%ebx
  800c4a:	74 1b                	je     800c67 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c4c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c4f:	75 cf                	jne    800c20 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c51:	8b 42 58             	mov    0x58(%edx),%eax
  800c54:	6a 01                	push   $0x1
  800c56:	50                   	push   %eax
  800c57:	53                   	push   %ebx
  800c58:	68 6e 23 80 00       	push   $0x80236e
  800c5d:	e8 3e 09 00 00       	call   8015a0 <cprintf>
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	eb b9                	jmp    800c20 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c67:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c6a:	0f 94 c0             	sete   %al
  800c6d:	0f b6 c0             	movzbl %al,%eax
}
  800c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c73:	5b                   	pop    %ebx
  800c74:	5e                   	pop    %esi
  800c75:	5f                   	pop    %edi
  800c76:	5d                   	pop    %ebp
  800c77:	c3                   	ret    

00800c78 <devpipe_write>:
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	57                   	push   %edi
  800c7c:	56                   	push   %esi
  800c7d:	53                   	push   %ebx
  800c7e:	83 ec 28             	sub    $0x28,%esp
  800c81:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c84:	56                   	push   %esi
  800c85:	e8 e8 f6 ff ff       	call   800372 <fd2data>
  800c8a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c8c:	83 c4 10             	add    $0x10,%esp
  800c8f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c94:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c97:	74 4f                	je     800ce8 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c99:	8b 43 04             	mov    0x4(%ebx),%eax
  800c9c:	8b 0b                	mov    (%ebx),%ecx
  800c9e:	8d 51 20             	lea    0x20(%ecx),%edx
  800ca1:	39 d0                	cmp    %edx,%eax
  800ca3:	72 14                	jb     800cb9 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800ca5:	89 da                	mov    %ebx,%edx
  800ca7:	89 f0                	mov    %esi,%eax
  800ca9:	e8 65 ff ff ff       	call   800c13 <_pipeisclosed>
  800cae:	85 c0                	test   %eax,%eax
  800cb0:	75 3b                	jne    800ced <devpipe_write+0x75>
			sys_yield();
  800cb2:	e8 7c f4 ff ff       	call   800133 <sys_yield>
  800cb7:	eb e0                	jmp    800c99 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbc:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cc0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cc3:	89 c2                	mov    %eax,%edx
  800cc5:	c1 fa 1f             	sar    $0x1f,%edx
  800cc8:	89 d1                	mov    %edx,%ecx
  800cca:	c1 e9 1b             	shr    $0x1b,%ecx
  800ccd:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cd0:	83 e2 1f             	and    $0x1f,%edx
  800cd3:	29 ca                	sub    %ecx,%edx
  800cd5:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cd9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cdd:	83 c0 01             	add    $0x1,%eax
  800ce0:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800ce3:	83 c7 01             	add    $0x1,%edi
  800ce6:	eb ac                	jmp    800c94 <devpipe_write+0x1c>
	return i;
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	eb 05                	jmp    800cf2 <devpipe_write+0x7a>
				return 0;
  800ced:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf5:	5b                   	pop    %ebx
  800cf6:	5e                   	pop    %esi
  800cf7:	5f                   	pop    %edi
  800cf8:	5d                   	pop    %ebp
  800cf9:	c3                   	ret    

00800cfa <devpipe_read>:
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	57                   	push   %edi
  800cfe:	56                   	push   %esi
  800cff:	53                   	push   %ebx
  800d00:	83 ec 18             	sub    $0x18,%esp
  800d03:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d06:	57                   	push   %edi
  800d07:	e8 66 f6 ff ff       	call   800372 <fd2data>
  800d0c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d0e:	83 c4 10             	add    $0x10,%esp
  800d11:	be 00 00 00 00       	mov    $0x0,%esi
  800d16:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d19:	75 14                	jne    800d2f <devpipe_read+0x35>
	return i;
  800d1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1e:	eb 02                	jmp    800d22 <devpipe_read+0x28>
				return i;
  800d20:	89 f0                	mov    %esi,%eax
}
  800d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    
			sys_yield();
  800d2a:	e8 04 f4 ff ff       	call   800133 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d2f:	8b 03                	mov    (%ebx),%eax
  800d31:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d34:	75 18                	jne    800d4e <devpipe_read+0x54>
			if (i > 0)
  800d36:	85 f6                	test   %esi,%esi
  800d38:	75 e6                	jne    800d20 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  800d3a:	89 da                	mov    %ebx,%edx
  800d3c:	89 f8                	mov    %edi,%eax
  800d3e:	e8 d0 fe ff ff       	call   800c13 <_pipeisclosed>
  800d43:	85 c0                	test   %eax,%eax
  800d45:	74 e3                	je     800d2a <devpipe_read+0x30>
				return 0;
  800d47:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4c:	eb d4                	jmp    800d22 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d4e:	99                   	cltd   
  800d4f:	c1 ea 1b             	shr    $0x1b,%edx
  800d52:	01 d0                	add    %edx,%eax
  800d54:	83 e0 1f             	and    $0x1f,%eax
  800d57:	29 d0                	sub    %edx,%eax
  800d59:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d61:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d64:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d67:	83 c6 01             	add    $0x1,%esi
  800d6a:	eb aa                	jmp    800d16 <devpipe_read+0x1c>

00800d6c <pipe>:
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	56                   	push   %esi
  800d70:	53                   	push   %ebx
  800d71:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d77:	50                   	push   %eax
  800d78:	e8 0c f6 ff ff       	call   800389 <fd_alloc>
  800d7d:	89 c3                	mov    %eax,%ebx
  800d7f:	83 c4 10             	add    $0x10,%esp
  800d82:	85 c0                	test   %eax,%eax
  800d84:	0f 88 23 01 00 00    	js     800ead <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d8a:	83 ec 04             	sub    $0x4,%esp
  800d8d:	68 07 04 00 00       	push   $0x407
  800d92:	ff 75 f4             	pushl  -0xc(%ebp)
  800d95:	6a 00                	push   $0x0
  800d97:	e8 b6 f3 ff ff       	call   800152 <sys_page_alloc>
  800d9c:	89 c3                	mov    %eax,%ebx
  800d9e:	83 c4 10             	add    $0x10,%esp
  800da1:	85 c0                	test   %eax,%eax
  800da3:	0f 88 04 01 00 00    	js     800ead <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  800da9:	83 ec 0c             	sub    $0xc,%esp
  800dac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800daf:	50                   	push   %eax
  800db0:	e8 d4 f5 ff ff       	call   800389 <fd_alloc>
  800db5:	89 c3                	mov    %eax,%ebx
  800db7:	83 c4 10             	add    $0x10,%esp
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	0f 88 db 00 00 00    	js     800e9d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dc2:	83 ec 04             	sub    $0x4,%esp
  800dc5:	68 07 04 00 00       	push   $0x407
  800dca:	ff 75 f0             	pushl  -0x10(%ebp)
  800dcd:	6a 00                	push   $0x0
  800dcf:	e8 7e f3 ff ff       	call   800152 <sys_page_alloc>
  800dd4:	89 c3                	mov    %eax,%ebx
  800dd6:	83 c4 10             	add    $0x10,%esp
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	0f 88 bc 00 00 00    	js     800e9d <pipe+0x131>
	va = fd2data(fd0);
  800de1:	83 ec 0c             	sub    $0xc,%esp
  800de4:	ff 75 f4             	pushl  -0xc(%ebp)
  800de7:	e8 86 f5 ff ff       	call   800372 <fd2data>
  800dec:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dee:	83 c4 0c             	add    $0xc,%esp
  800df1:	68 07 04 00 00       	push   $0x407
  800df6:	50                   	push   %eax
  800df7:	6a 00                	push   $0x0
  800df9:	e8 54 f3 ff ff       	call   800152 <sys_page_alloc>
  800dfe:	89 c3                	mov    %eax,%ebx
  800e00:	83 c4 10             	add    $0x10,%esp
  800e03:	85 c0                	test   %eax,%eax
  800e05:	0f 88 82 00 00 00    	js     800e8d <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e0b:	83 ec 0c             	sub    $0xc,%esp
  800e0e:	ff 75 f0             	pushl  -0x10(%ebp)
  800e11:	e8 5c f5 ff ff       	call   800372 <fd2data>
  800e16:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e1d:	50                   	push   %eax
  800e1e:	6a 00                	push   $0x0
  800e20:	56                   	push   %esi
  800e21:	6a 00                	push   $0x0
  800e23:	e8 6d f3 ff ff       	call   800195 <sys_page_map>
  800e28:	89 c3                	mov    %eax,%ebx
  800e2a:	83 c4 20             	add    $0x20,%esp
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	78 4e                	js     800e7f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  800e31:	a1 20 30 80 00       	mov    0x803020,%eax
  800e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e39:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e48:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e54:	83 ec 0c             	sub    $0xc,%esp
  800e57:	ff 75 f4             	pushl  -0xc(%ebp)
  800e5a:	e8 03 f5 ff ff       	call   800362 <fd2num>
  800e5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e62:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e64:	83 c4 04             	add    $0x4,%esp
  800e67:	ff 75 f0             	pushl  -0x10(%ebp)
  800e6a:	e8 f3 f4 ff ff       	call   800362 <fd2num>
  800e6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e72:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e75:	83 c4 10             	add    $0x10,%esp
  800e78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7d:	eb 2e                	jmp    800ead <pipe+0x141>
	sys_page_unmap(0, va);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	56                   	push   %esi
  800e83:	6a 00                	push   $0x0
  800e85:	e8 4d f3 ff ff       	call   8001d7 <sys_page_unmap>
  800e8a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e8d:	83 ec 08             	sub    $0x8,%esp
  800e90:	ff 75 f0             	pushl  -0x10(%ebp)
  800e93:	6a 00                	push   $0x0
  800e95:	e8 3d f3 ff ff       	call   8001d7 <sys_page_unmap>
  800e9a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea3:	6a 00                	push   $0x0
  800ea5:	e8 2d f3 ff ff       	call   8001d7 <sys_page_unmap>
  800eaa:	83 c4 10             	add    $0x10,%esp
}
  800ead:	89 d8                	mov    %ebx,%eax
  800eaf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eb2:	5b                   	pop    %ebx
  800eb3:	5e                   	pop    %esi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    

00800eb6 <pipeisclosed>:
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ebc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ebf:	50                   	push   %eax
  800ec0:	ff 75 08             	pushl  0x8(%ebp)
  800ec3:	e8 13 f5 ff ff       	call   8003db <fd_lookup>
  800ec8:	83 c4 10             	add    $0x10,%esp
  800ecb:	85 c0                	test   %eax,%eax
  800ecd:	78 18                	js     800ee7 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ecf:	83 ec 0c             	sub    $0xc,%esp
  800ed2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed5:	e8 98 f4 ff ff       	call   800372 <fd2data>
	return _pipeisclosed(fd, p);
  800eda:	89 c2                	mov    %eax,%edx
  800edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800edf:	e8 2f fd ff ff       	call   800c13 <_pipeisclosed>
  800ee4:	83 c4 10             	add    $0x10,%esp
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800eef:	68 86 23 80 00       	push   $0x802386
  800ef4:	ff 75 0c             	pushl  0xc(%ebp)
  800ef7:	e8 80 0c 00 00       	call   801b7c <strcpy>
	return 0;
}
  800efc:	b8 00 00 00 00       	mov    $0x0,%eax
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    

00800f03 <devsock_close>:
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	53                   	push   %ebx
  800f07:	83 ec 10             	sub    $0x10,%esp
  800f0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f0d:	53                   	push   %ebx
  800f0e:	e8 b7 10 00 00       	call   801fca <pageref>
  800f13:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f16:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f1b:	83 f8 01             	cmp    $0x1,%eax
  800f1e:	74 07                	je     800f27 <devsock_close+0x24>
}
  800f20:	89 d0                	mov    %edx,%eax
  800f22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f25:	c9                   	leave  
  800f26:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f27:	83 ec 0c             	sub    $0xc,%esp
  800f2a:	ff 73 0c             	pushl  0xc(%ebx)
  800f2d:	e8 b9 02 00 00       	call   8011eb <nsipc_close>
  800f32:	89 c2                	mov    %eax,%edx
  800f34:	83 c4 10             	add    $0x10,%esp
  800f37:	eb e7                	jmp    800f20 <devsock_close+0x1d>

00800f39 <devsock_write>:
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f3f:	6a 00                	push   $0x0
  800f41:	ff 75 10             	pushl  0x10(%ebp)
  800f44:	ff 75 0c             	pushl  0xc(%ebp)
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	ff 70 0c             	pushl  0xc(%eax)
  800f4d:	e8 76 03 00 00       	call   8012c8 <nsipc_send>
}
  800f52:	c9                   	leave  
  800f53:	c3                   	ret    

00800f54 <devsock_read>:
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f5a:	6a 00                	push   $0x0
  800f5c:	ff 75 10             	pushl  0x10(%ebp)
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff 70 0c             	pushl  0xc(%eax)
  800f68:	e8 ef 02 00 00       	call   80125c <nsipc_recv>
}
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

00800f6f <fd2sockid>:
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f75:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f78:	52                   	push   %edx
  800f79:	50                   	push   %eax
  800f7a:	e8 5c f4 ff ff       	call   8003db <fd_lookup>
  800f7f:	83 c4 10             	add    $0x10,%esp
  800f82:	85 c0                	test   %eax,%eax
  800f84:	78 10                	js     800f96 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f89:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800f8f:	39 08                	cmp    %ecx,(%eax)
  800f91:	75 05                	jne    800f98 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800f93:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    
		return -E_NOT_SUPP;
  800f98:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800f9d:	eb f7                	jmp    800f96 <fd2sockid+0x27>

00800f9f <alloc_sockfd>:
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	56                   	push   %esi
  800fa3:	53                   	push   %ebx
  800fa4:	83 ec 1c             	sub    $0x1c,%esp
  800fa7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fac:	50                   	push   %eax
  800fad:	e8 d7 f3 ff ff       	call   800389 <fd_alloc>
  800fb2:	89 c3                	mov    %eax,%ebx
  800fb4:	83 c4 10             	add    $0x10,%esp
  800fb7:	85 c0                	test   %eax,%eax
  800fb9:	78 43                	js     800ffe <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fbb:	83 ec 04             	sub    $0x4,%esp
  800fbe:	68 07 04 00 00       	push   $0x407
  800fc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc6:	6a 00                	push   $0x0
  800fc8:	e8 85 f1 ff ff       	call   800152 <sys_page_alloc>
  800fcd:	89 c3                	mov    %eax,%ebx
  800fcf:	83 c4 10             	add    $0x10,%esp
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	78 28                	js     800ffe <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fdf:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800feb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800fee:	83 ec 0c             	sub    $0xc,%esp
  800ff1:	50                   	push   %eax
  800ff2:	e8 6b f3 ff ff       	call   800362 <fd2num>
  800ff7:	89 c3                	mov    %eax,%ebx
  800ff9:	83 c4 10             	add    $0x10,%esp
  800ffc:	eb 0c                	jmp    80100a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800ffe:	83 ec 0c             	sub    $0xc,%esp
  801001:	56                   	push   %esi
  801002:	e8 e4 01 00 00       	call   8011eb <nsipc_close>
		return r;
  801007:	83 c4 10             	add    $0x10,%esp
}
  80100a:	89 d8                	mov    %ebx,%eax
  80100c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100f:	5b                   	pop    %ebx
  801010:	5e                   	pop    %esi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <accept>:
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	e8 4e ff ff ff       	call   800f6f <fd2sockid>
  801021:	85 c0                	test   %eax,%eax
  801023:	78 1b                	js     801040 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801025:	83 ec 04             	sub    $0x4,%esp
  801028:	ff 75 10             	pushl  0x10(%ebp)
  80102b:	ff 75 0c             	pushl  0xc(%ebp)
  80102e:	50                   	push   %eax
  80102f:	e8 0e 01 00 00       	call   801142 <nsipc_accept>
  801034:	83 c4 10             	add    $0x10,%esp
  801037:	85 c0                	test   %eax,%eax
  801039:	78 05                	js     801040 <accept+0x2d>
	return alloc_sockfd(r);
  80103b:	e8 5f ff ff ff       	call   800f9f <alloc_sockfd>
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <bind>:
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	e8 1f ff ff ff       	call   800f6f <fd2sockid>
  801050:	85 c0                	test   %eax,%eax
  801052:	78 12                	js     801066 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801054:	83 ec 04             	sub    $0x4,%esp
  801057:	ff 75 10             	pushl  0x10(%ebp)
  80105a:	ff 75 0c             	pushl  0xc(%ebp)
  80105d:	50                   	push   %eax
  80105e:	e8 31 01 00 00       	call   801194 <nsipc_bind>
  801063:	83 c4 10             	add    $0x10,%esp
}
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <shutdown>:
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	e8 f9 fe ff ff       	call   800f6f <fd2sockid>
  801076:	85 c0                	test   %eax,%eax
  801078:	78 0f                	js     801089 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	50                   	push   %eax
  801081:	e8 43 01 00 00       	call   8011c9 <nsipc_shutdown>
  801086:	83 c4 10             	add    $0x10,%esp
}
  801089:	c9                   	leave  
  80108a:	c3                   	ret    

0080108b <connect>:
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	e8 d6 fe ff ff       	call   800f6f <fd2sockid>
  801099:	85 c0                	test   %eax,%eax
  80109b:	78 12                	js     8010af <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	ff 75 10             	pushl  0x10(%ebp)
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	50                   	push   %eax
  8010a7:	e8 59 01 00 00       	call   801205 <nsipc_connect>
  8010ac:	83 c4 10             	add    $0x10,%esp
}
  8010af:	c9                   	leave  
  8010b0:	c3                   	ret    

008010b1 <listen>:
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	e8 b0 fe ff ff       	call   800f6f <fd2sockid>
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	78 0f                	js     8010d2 <listen+0x21>
	return nsipc_listen(r, backlog);
  8010c3:	83 ec 08             	sub    $0x8,%esp
  8010c6:	ff 75 0c             	pushl  0xc(%ebp)
  8010c9:	50                   	push   %eax
  8010ca:	e8 6b 01 00 00       	call   80123a <nsipc_listen>
  8010cf:	83 c4 10             	add    $0x10,%esp
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <socket>:

int
socket(int domain, int type, int protocol)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010da:	ff 75 10             	pushl  0x10(%ebp)
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	ff 75 08             	pushl  0x8(%ebp)
  8010e3:	e8 3e 02 00 00       	call   801326 <nsipc_socket>
  8010e8:	83 c4 10             	add    $0x10,%esp
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	78 05                	js     8010f4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8010ef:	e8 ab fe ff ff       	call   800f9f <alloc_sockfd>
}
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

008010f6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	53                   	push   %ebx
  8010fa:	83 ec 04             	sub    $0x4,%esp
  8010fd:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8010ff:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801106:	74 26                	je     80112e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801108:	6a 07                	push   $0x7
  80110a:	68 00 60 80 00       	push   $0x806000
  80110f:	53                   	push   %ebx
  801110:	ff 35 04 40 80 00    	pushl  0x804004
  801116:	e8 0a 0e 00 00       	call   801f25 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80111b:	83 c4 0c             	add    $0xc,%esp
  80111e:	6a 00                	push   $0x0
  801120:	6a 00                	push   $0x0
  801122:	6a 00                	push   $0x0
  801124:	e8 89 0d 00 00       	call   801eb2 <ipc_recv>
}
  801129:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112c:	c9                   	leave  
  80112d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80112e:	83 ec 0c             	sub    $0xc,%esp
  801131:	6a 02                	push   $0x2
  801133:	e8 59 0e 00 00       	call   801f91 <ipc_find_env>
  801138:	a3 04 40 80 00       	mov    %eax,0x804004
  80113d:	83 c4 10             	add    $0x10,%esp
  801140:	eb c6                	jmp    801108 <nsipc+0x12>

00801142 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	56                   	push   %esi
  801146:	53                   	push   %ebx
  801147:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801152:	8b 06                	mov    (%esi),%eax
  801154:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801159:	b8 01 00 00 00       	mov    $0x1,%eax
  80115e:	e8 93 ff ff ff       	call   8010f6 <nsipc>
  801163:	89 c3                	mov    %eax,%ebx
  801165:	85 c0                	test   %eax,%eax
  801167:	79 09                	jns    801172 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801169:	89 d8                	mov    %ebx,%eax
  80116b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116e:	5b                   	pop    %ebx
  80116f:	5e                   	pop    %esi
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801172:	83 ec 04             	sub    $0x4,%esp
  801175:	ff 35 10 60 80 00    	pushl  0x806010
  80117b:	68 00 60 80 00       	push   $0x806000
  801180:	ff 75 0c             	pushl  0xc(%ebp)
  801183:	e8 82 0b 00 00       	call   801d0a <memmove>
		*addrlen = ret->ret_addrlen;
  801188:	a1 10 60 80 00       	mov    0x806010,%eax
  80118d:	89 06                	mov    %eax,(%esi)
  80118f:	83 c4 10             	add    $0x10,%esp
	return r;
  801192:	eb d5                	jmp    801169 <nsipc_accept+0x27>

00801194 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801194:	55                   	push   %ebp
  801195:	89 e5                	mov    %esp,%ebp
  801197:	53                   	push   %ebx
  801198:	83 ec 08             	sub    $0x8,%esp
  80119b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011a6:	53                   	push   %ebx
  8011a7:	ff 75 0c             	pushl  0xc(%ebp)
  8011aa:	68 04 60 80 00       	push   $0x806004
  8011af:	e8 56 0b 00 00       	call   801d0a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011b4:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011ba:	b8 02 00 00 00       	mov    $0x2,%eax
  8011bf:	e8 32 ff ff ff       	call   8010f6 <nsipc>
}
  8011c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c7:	c9                   	leave  
  8011c8:	c3                   	ret    

008011c9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011df:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e4:	e8 0d ff ff ff       	call   8010f6 <nsipc>
}
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    

008011eb <nsipc_close>:

int
nsipc_close(int s)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8011f9:	b8 04 00 00 00       	mov    $0x4,%eax
  8011fe:	e8 f3 fe ff ff       	call   8010f6 <nsipc>
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	53                   	push   %ebx
  801209:	83 ec 08             	sub    $0x8,%esp
  80120c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801217:	53                   	push   %ebx
  801218:	ff 75 0c             	pushl  0xc(%ebp)
  80121b:	68 04 60 80 00       	push   $0x806004
  801220:	e8 e5 0a 00 00       	call   801d0a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801225:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80122b:	b8 05 00 00 00       	mov    $0x5,%eax
  801230:	e8 c1 fe ff ff       	call   8010f6 <nsipc>
}
  801235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801238:	c9                   	leave  
  801239:	c3                   	ret    

0080123a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801250:	b8 06 00 00 00       	mov    $0x6,%eax
  801255:	e8 9c fe ff ff       	call   8010f6 <nsipc>
}
  80125a:	c9                   	leave  
  80125b:	c3                   	ret    

0080125c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	56                   	push   %esi
  801260:	53                   	push   %ebx
  801261:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80126c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801272:	8b 45 14             	mov    0x14(%ebp),%eax
  801275:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80127a:	b8 07 00 00 00       	mov    $0x7,%eax
  80127f:	e8 72 fe ff ff       	call   8010f6 <nsipc>
  801284:	89 c3                	mov    %eax,%ebx
  801286:	85 c0                	test   %eax,%eax
  801288:	78 1f                	js     8012a9 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80128a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80128f:	7f 21                	jg     8012b2 <nsipc_recv+0x56>
  801291:	39 c6                	cmp    %eax,%esi
  801293:	7c 1d                	jl     8012b2 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801295:	83 ec 04             	sub    $0x4,%esp
  801298:	50                   	push   %eax
  801299:	68 00 60 80 00       	push   $0x806000
  80129e:	ff 75 0c             	pushl  0xc(%ebp)
  8012a1:	e8 64 0a 00 00       	call   801d0a <memmove>
  8012a6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012a9:	89 d8                	mov    %ebx,%eax
  8012ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ae:	5b                   	pop    %ebx
  8012af:	5e                   	pop    %esi
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012b2:	68 92 23 80 00       	push   $0x802392
  8012b7:	68 34 23 80 00       	push   $0x802334
  8012bc:	6a 62                	push   $0x62
  8012be:	68 a7 23 80 00       	push   $0x8023a7
  8012c3:	e8 fd 01 00 00       	call   8014c5 <_panic>

008012c8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	53                   	push   %ebx
  8012cc:	83 ec 04             	sub    $0x4,%esp
  8012cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012da:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012e0:	7f 2e                	jg     801310 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012e2:	83 ec 04             	sub    $0x4,%esp
  8012e5:	53                   	push   %ebx
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	68 0c 60 80 00       	push   $0x80600c
  8012ee:	e8 17 0a 00 00       	call   801d0a <memmove>
	nsipcbuf.send.req_size = size;
  8012f3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801301:	b8 08 00 00 00       	mov    $0x8,%eax
  801306:	e8 eb fd ff ff       	call   8010f6 <nsipc>
}
  80130b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    
	assert(size < 1600);
  801310:	68 b3 23 80 00       	push   $0x8023b3
  801315:	68 34 23 80 00       	push   $0x802334
  80131a:	6a 6d                	push   $0x6d
  80131c:	68 a7 23 80 00       	push   $0x8023a7
  801321:	e8 9f 01 00 00       	call   8014c5 <_panic>

00801326 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80133c:	8b 45 10             	mov    0x10(%ebp),%eax
  80133f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801344:	b8 09 00 00 00       	mov    $0x9,%eax
  801349:	e8 a8 fd ff ff       	call   8010f6 <nsipc>
}
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801350:	b8 00 00 00 00       	mov    $0x0,%eax
  801355:	c3                   	ret    

00801356 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80135c:	68 bf 23 80 00       	push   $0x8023bf
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	e8 13 08 00 00       	call   801b7c <strcpy>
	return 0;
}
  801369:	b8 00 00 00 00       	mov    $0x0,%eax
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <devcons_write>:
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	57                   	push   %edi
  801374:	56                   	push   %esi
  801375:	53                   	push   %ebx
  801376:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80137c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801381:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801387:	3b 75 10             	cmp    0x10(%ebp),%esi
  80138a:	73 31                	jae    8013bd <devcons_write+0x4d>
		m = n - tot;
  80138c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80138f:	29 f3                	sub    %esi,%ebx
  801391:	83 fb 7f             	cmp    $0x7f,%ebx
  801394:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801399:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80139c:	83 ec 04             	sub    $0x4,%esp
  80139f:	53                   	push   %ebx
  8013a0:	89 f0                	mov    %esi,%eax
  8013a2:	03 45 0c             	add    0xc(%ebp),%eax
  8013a5:	50                   	push   %eax
  8013a6:	57                   	push   %edi
  8013a7:	e8 5e 09 00 00       	call   801d0a <memmove>
		sys_cputs(buf, m);
  8013ac:	83 c4 08             	add    $0x8,%esp
  8013af:	53                   	push   %ebx
  8013b0:	57                   	push   %edi
  8013b1:	e8 e0 ec ff ff       	call   800096 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013b6:	01 de                	add    %ebx,%esi
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	eb ca                	jmp    801387 <devcons_write+0x17>
}
  8013bd:	89 f0                	mov    %esi,%eax
  8013bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c2:	5b                   	pop    %ebx
  8013c3:	5e                   	pop    %esi
  8013c4:	5f                   	pop    %edi
  8013c5:	5d                   	pop    %ebp
  8013c6:	c3                   	ret    

008013c7 <devcons_read>:
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	83 ec 08             	sub    $0x8,%esp
  8013cd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d6:	74 21                	je     8013f9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8013d8:	e8 d7 ec ff ff       	call   8000b4 <sys_cgetc>
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	75 07                	jne    8013e8 <devcons_read+0x21>
		sys_yield();
  8013e1:	e8 4d ed ff ff       	call   800133 <sys_yield>
  8013e6:	eb f0                	jmp    8013d8 <devcons_read+0x11>
	if (c < 0)
  8013e8:	78 0f                	js     8013f9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8013ea:	83 f8 04             	cmp    $0x4,%eax
  8013ed:	74 0c                	je     8013fb <devcons_read+0x34>
	*(char*)vbuf = c;
  8013ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f2:	88 02                	mov    %al,(%edx)
	return 1;
  8013f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    
		return 0;
  8013fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801400:	eb f7                	jmp    8013f9 <devcons_read+0x32>

00801402 <cputchar>:
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80140e:	6a 01                	push   $0x1
  801410:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801413:	50                   	push   %eax
  801414:	e8 7d ec ff ff       	call   800096 <sys_cputs>
}
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <getchar>:
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801424:	6a 01                	push   $0x1
  801426:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801429:	50                   	push   %eax
  80142a:	6a 00                	push   $0x0
  80142c:	e8 1a f2 ff ff       	call   80064b <read>
	if (r < 0)
  801431:	83 c4 10             	add    $0x10,%esp
  801434:	85 c0                	test   %eax,%eax
  801436:	78 06                	js     80143e <getchar+0x20>
	if (r < 1)
  801438:	74 06                	je     801440 <getchar+0x22>
	return c;
  80143a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    
		return -E_EOF;
  801440:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801445:	eb f7                	jmp    80143e <getchar+0x20>

00801447 <iscons>:
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80144d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801450:	50                   	push   %eax
  801451:	ff 75 08             	pushl  0x8(%ebp)
  801454:	e8 82 ef ff ff       	call   8003db <fd_lookup>
  801459:	83 c4 10             	add    $0x10,%esp
  80145c:	85 c0                	test   %eax,%eax
  80145e:	78 11                	js     801471 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801463:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801469:	39 10                	cmp    %edx,(%eax)
  80146b:	0f 94 c0             	sete   %al
  80146e:	0f b6 c0             	movzbl %al,%eax
}
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <opencons>:
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801479:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147c:	50                   	push   %eax
  80147d:	e8 07 ef ff ff       	call   800389 <fd_alloc>
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 3a                	js     8014c3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801489:	83 ec 04             	sub    $0x4,%esp
  80148c:	68 07 04 00 00       	push   $0x407
  801491:	ff 75 f4             	pushl  -0xc(%ebp)
  801494:	6a 00                	push   $0x0
  801496:	e8 b7 ec ff ff       	call   800152 <sys_page_alloc>
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	78 21                	js     8014c3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014ab:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	50                   	push   %eax
  8014bb:	e8 a2 ee ff ff       	call   800362 <fd2num>
  8014c0:	83 c4 10             	add    $0x10,%esp
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	56                   	push   %esi
  8014c9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014ca:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014cd:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014d3:	e8 3c ec ff ff       	call   800114 <sys_getenvid>
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	ff 75 0c             	pushl  0xc(%ebp)
  8014de:	ff 75 08             	pushl  0x8(%ebp)
  8014e1:	56                   	push   %esi
  8014e2:	50                   	push   %eax
  8014e3:	68 cc 23 80 00       	push   $0x8023cc
  8014e8:	e8 b3 00 00 00       	call   8015a0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014ed:	83 c4 18             	add    $0x18,%esp
  8014f0:	53                   	push   %ebx
  8014f1:	ff 75 10             	pushl  0x10(%ebp)
  8014f4:	e8 56 00 00 00       	call   80154f <vcprintf>
	cprintf("\n");
  8014f9:	c7 04 24 7f 23 80 00 	movl   $0x80237f,(%esp)
  801500:	e8 9b 00 00 00       	call   8015a0 <cprintf>
  801505:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801508:	cc                   	int3   
  801509:	eb fd                	jmp    801508 <_panic+0x43>

0080150b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	53                   	push   %ebx
  80150f:	83 ec 04             	sub    $0x4,%esp
  801512:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801515:	8b 13                	mov    (%ebx),%edx
  801517:	8d 42 01             	lea    0x1(%edx),%eax
  80151a:	89 03                	mov    %eax,(%ebx)
  80151c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801523:	3d ff 00 00 00       	cmp    $0xff,%eax
  801528:	74 09                	je     801533 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80152a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80152e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801531:	c9                   	leave  
  801532:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801533:	83 ec 08             	sub    $0x8,%esp
  801536:	68 ff 00 00 00       	push   $0xff
  80153b:	8d 43 08             	lea    0x8(%ebx),%eax
  80153e:	50                   	push   %eax
  80153f:	e8 52 eb ff ff       	call   800096 <sys_cputs>
		b->idx = 0;
  801544:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	eb db                	jmp    80152a <putch+0x1f>

0080154f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801558:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80155f:	00 00 00 
	b.cnt = 0;
  801562:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801569:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80156c:	ff 75 0c             	pushl  0xc(%ebp)
  80156f:	ff 75 08             	pushl  0x8(%ebp)
  801572:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801578:	50                   	push   %eax
  801579:	68 0b 15 80 00       	push   $0x80150b
  80157e:	e8 19 01 00 00       	call   80169c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801583:	83 c4 08             	add    $0x8,%esp
  801586:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80158c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801592:	50                   	push   %eax
  801593:	e8 fe ea ff ff       	call   800096 <sys_cputs>

	return b.cnt;
}
  801598:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015a6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015a9:	50                   	push   %eax
  8015aa:	ff 75 08             	pushl  0x8(%ebp)
  8015ad:	e8 9d ff ff ff       	call   80154f <vcprintf>
	va_end(ap);

	return cnt;
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	57                   	push   %edi
  8015b8:	56                   	push   %esi
  8015b9:	53                   	push   %ebx
  8015ba:	83 ec 1c             	sub    $0x1c,%esp
  8015bd:	89 c7                	mov    %eax,%edi
  8015bf:	89 d6                	mov    %edx,%esi
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015d8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015db:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015de:	89 d0                	mov    %edx,%eax
  8015e0:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8015e3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015e6:	73 15                	jae    8015fd <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015e8:	83 eb 01             	sub    $0x1,%ebx
  8015eb:	85 db                	test   %ebx,%ebx
  8015ed:	7e 43                	jle    801632 <printnum+0x7e>
			putch(padc, putdat);
  8015ef:	83 ec 08             	sub    $0x8,%esp
  8015f2:	56                   	push   %esi
  8015f3:	ff 75 18             	pushl  0x18(%ebp)
  8015f6:	ff d7                	call   *%edi
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	eb eb                	jmp    8015e8 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015fd:	83 ec 0c             	sub    $0xc,%esp
  801600:	ff 75 18             	pushl  0x18(%ebp)
  801603:	8b 45 14             	mov    0x14(%ebp),%eax
  801606:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801609:	53                   	push   %ebx
  80160a:	ff 75 10             	pushl  0x10(%ebp)
  80160d:	83 ec 08             	sub    $0x8,%esp
  801610:	ff 75 e4             	pushl  -0x1c(%ebp)
  801613:	ff 75 e0             	pushl  -0x20(%ebp)
  801616:	ff 75 dc             	pushl  -0x24(%ebp)
  801619:	ff 75 d8             	pushl  -0x28(%ebp)
  80161c:	e8 ef 09 00 00       	call   802010 <__udivdi3>
  801621:	83 c4 18             	add    $0x18,%esp
  801624:	52                   	push   %edx
  801625:	50                   	push   %eax
  801626:	89 f2                	mov    %esi,%edx
  801628:	89 f8                	mov    %edi,%eax
  80162a:	e8 85 ff ff ff       	call   8015b4 <printnum>
  80162f:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801632:	83 ec 08             	sub    $0x8,%esp
  801635:	56                   	push   %esi
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	ff 75 e4             	pushl  -0x1c(%ebp)
  80163c:	ff 75 e0             	pushl  -0x20(%ebp)
  80163f:	ff 75 dc             	pushl  -0x24(%ebp)
  801642:	ff 75 d8             	pushl  -0x28(%ebp)
  801645:	e8 d6 0a 00 00       	call   802120 <__umoddi3>
  80164a:	83 c4 14             	add    $0x14,%esp
  80164d:	0f be 80 ef 23 80 00 	movsbl 0x8023ef(%eax),%eax
  801654:	50                   	push   %eax
  801655:	ff d7                	call   *%edi
}
  801657:	83 c4 10             	add    $0x10,%esp
  80165a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165d:	5b                   	pop    %ebx
  80165e:	5e                   	pop    %esi
  80165f:	5f                   	pop    %edi
  801660:	5d                   	pop    %ebp
  801661:	c3                   	ret    

00801662 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801668:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80166c:	8b 10                	mov    (%eax),%edx
  80166e:	3b 50 04             	cmp    0x4(%eax),%edx
  801671:	73 0a                	jae    80167d <sprintputch+0x1b>
		*b->buf++ = ch;
  801673:	8d 4a 01             	lea    0x1(%edx),%ecx
  801676:	89 08                	mov    %ecx,(%eax)
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	88 02                	mov    %al,(%edx)
}
  80167d:	5d                   	pop    %ebp
  80167e:	c3                   	ret    

0080167f <printfmt>:
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801685:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801688:	50                   	push   %eax
  801689:	ff 75 10             	pushl  0x10(%ebp)
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	ff 75 08             	pushl  0x8(%ebp)
  801692:	e8 05 00 00 00       	call   80169c <vprintfmt>
}
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <vprintfmt>:
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	57                   	push   %edi
  8016a0:	56                   	push   %esi
  8016a1:	53                   	push   %ebx
  8016a2:	83 ec 3c             	sub    $0x3c,%esp
  8016a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8016a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016ab:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016ae:	eb 0a                	jmp    8016ba <vprintfmt+0x1e>
			putch(ch, putdat);
  8016b0:	83 ec 08             	sub    $0x8,%esp
  8016b3:	53                   	push   %ebx
  8016b4:	50                   	push   %eax
  8016b5:	ff d6                	call   *%esi
  8016b7:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016ba:	83 c7 01             	add    $0x1,%edi
  8016bd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016c1:	83 f8 25             	cmp    $0x25,%eax
  8016c4:	74 0c                	je     8016d2 <vprintfmt+0x36>
			if (ch == '\0')
  8016c6:	85 c0                	test   %eax,%eax
  8016c8:	75 e6                	jne    8016b0 <vprintfmt+0x14>
}
  8016ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016cd:	5b                   	pop    %ebx
  8016ce:	5e                   	pop    %esi
  8016cf:	5f                   	pop    %edi
  8016d0:	5d                   	pop    %ebp
  8016d1:	c3                   	ret    
		padc = ' ';
  8016d2:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8016d6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8016dd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8016e4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016eb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016f0:	8d 47 01             	lea    0x1(%edi),%eax
  8016f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016f6:	0f b6 17             	movzbl (%edi),%edx
  8016f9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016fc:	3c 55                	cmp    $0x55,%al
  8016fe:	0f 87 ba 03 00 00    	ja     801abe <vprintfmt+0x422>
  801704:	0f b6 c0             	movzbl %al,%eax
  801707:	ff 24 85 40 25 80 00 	jmp    *0x802540(,%eax,4)
  80170e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801711:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801715:	eb d9                	jmp    8016f0 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801717:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80171a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80171e:	eb d0                	jmp    8016f0 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801720:	0f b6 d2             	movzbl %dl,%edx
  801723:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801726:	b8 00 00 00 00       	mov    $0x0,%eax
  80172b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80172e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801731:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801735:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801738:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80173b:	83 f9 09             	cmp    $0x9,%ecx
  80173e:	77 55                	ja     801795 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  801740:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801743:	eb e9                	jmp    80172e <vprintfmt+0x92>
			precision = va_arg(ap, int);
  801745:	8b 45 14             	mov    0x14(%ebp),%eax
  801748:	8b 00                	mov    (%eax),%eax
  80174a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80174d:	8b 45 14             	mov    0x14(%ebp),%eax
  801750:	8d 40 04             	lea    0x4(%eax),%eax
  801753:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801756:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801759:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80175d:	79 91                	jns    8016f0 <vprintfmt+0x54>
				width = precision, precision = -1;
  80175f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801762:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801765:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80176c:	eb 82                	jmp    8016f0 <vprintfmt+0x54>
  80176e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801771:	85 c0                	test   %eax,%eax
  801773:	ba 00 00 00 00       	mov    $0x0,%edx
  801778:	0f 49 d0             	cmovns %eax,%edx
  80177b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80177e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801781:	e9 6a ff ff ff       	jmp    8016f0 <vprintfmt+0x54>
  801786:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801789:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801790:	e9 5b ff ff ff       	jmp    8016f0 <vprintfmt+0x54>
  801795:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801798:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80179b:	eb bc                	jmp    801759 <vprintfmt+0xbd>
			lflag++;
  80179d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017a3:	e9 48 ff ff ff       	jmp    8016f0 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8017a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ab:	8d 78 04             	lea    0x4(%eax),%edi
  8017ae:	83 ec 08             	sub    $0x8,%esp
  8017b1:	53                   	push   %ebx
  8017b2:	ff 30                	pushl  (%eax)
  8017b4:	ff d6                	call   *%esi
			break;
  8017b6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017b9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017bc:	e9 9c 02 00 00       	jmp    801a5d <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8017c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c4:	8d 78 04             	lea    0x4(%eax),%edi
  8017c7:	8b 00                	mov    (%eax),%eax
  8017c9:	99                   	cltd   
  8017ca:	31 d0                	xor    %edx,%eax
  8017cc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017ce:	83 f8 0f             	cmp    $0xf,%eax
  8017d1:	7f 23                	jg     8017f6 <vprintfmt+0x15a>
  8017d3:	8b 14 85 a0 26 80 00 	mov    0x8026a0(,%eax,4),%edx
  8017da:	85 d2                	test   %edx,%edx
  8017dc:	74 18                	je     8017f6 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8017de:	52                   	push   %edx
  8017df:	68 46 23 80 00       	push   $0x802346
  8017e4:	53                   	push   %ebx
  8017e5:	56                   	push   %esi
  8017e6:	e8 94 fe ff ff       	call   80167f <printfmt>
  8017eb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017ee:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017f1:	e9 67 02 00 00       	jmp    801a5d <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8017f6:	50                   	push   %eax
  8017f7:	68 07 24 80 00       	push   $0x802407
  8017fc:	53                   	push   %ebx
  8017fd:	56                   	push   %esi
  8017fe:	e8 7c fe ff ff       	call   80167f <printfmt>
  801803:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801806:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801809:	e9 4f 02 00 00       	jmp    801a5d <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80180e:	8b 45 14             	mov    0x14(%ebp),%eax
  801811:	83 c0 04             	add    $0x4,%eax
  801814:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801817:	8b 45 14             	mov    0x14(%ebp),%eax
  80181a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80181c:	85 d2                	test   %edx,%edx
  80181e:	b8 00 24 80 00       	mov    $0x802400,%eax
  801823:	0f 45 c2             	cmovne %edx,%eax
  801826:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801829:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80182d:	7e 06                	jle    801835 <vprintfmt+0x199>
  80182f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801833:	75 0d                	jne    801842 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801835:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801838:	89 c7                	mov    %eax,%edi
  80183a:	03 45 e0             	add    -0x20(%ebp),%eax
  80183d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801840:	eb 3f                	jmp    801881 <vprintfmt+0x1e5>
  801842:	83 ec 08             	sub    $0x8,%esp
  801845:	ff 75 d8             	pushl  -0x28(%ebp)
  801848:	50                   	push   %eax
  801849:	e8 0d 03 00 00       	call   801b5b <strnlen>
  80184e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801851:	29 c2                	sub    %eax,%edx
  801853:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80185b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80185f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801862:	85 ff                	test   %edi,%edi
  801864:	7e 58                	jle    8018be <vprintfmt+0x222>
					putch(padc, putdat);
  801866:	83 ec 08             	sub    $0x8,%esp
  801869:	53                   	push   %ebx
  80186a:	ff 75 e0             	pushl  -0x20(%ebp)
  80186d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80186f:	83 ef 01             	sub    $0x1,%edi
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	eb eb                	jmp    801862 <vprintfmt+0x1c6>
					putch(ch, putdat);
  801877:	83 ec 08             	sub    $0x8,%esp
  80187a:	53                   	push   %ebx
  80187b:	52                   	push   %edx
  80187c:	ff d6                	call   *%esi
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801884:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801886:	83 c7 01             	add    $0x1,%edi
  801889:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80188d:	0f be d0             	movsbl %al,%edx
  801890:	85 d2                	test   %edx,%edx
  801892:	74 45                	je     8018d9 <vprintfmt+0x23d>
  801894:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801898:	78 06                	js     8018a0 <vprintfmt+0x204>
  80189a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80189e:	78 35                	js     8018d5 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8018a0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8018a4:	74 d1                	je     801877 <vprintfmt+0x1db>
  8018a6:	0f be c0             	movsbl %al,%eax
  8018a9:	83 e8 20             	sub    $0x20,%eax
  8018ac:	83 f8 5e             	cmp    $0x5e,%eax
  8018af:	76 c6                	jbe    801877 <vprintfmt+0x1db>
					putch('?', putdat);
  8018b1:	83 ec 08             	sub    $0x8,%esp
  8018b4:	53                   	push   %ebx
  8018b5:	6a 3f                	push   $0x3f
  8018b7:	ff d6                	call   *%esi
  8018b9:	83 c4 10             	add    $0x10,%esp
  8018bc:	eb c3                	jmp    801881 <vprintfmt+0x1e5>
  8018be:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8018c1:	85 d2                	test   %edx,%edx
  8018c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c8:	0f 49 c2             	cmovns %edx,%eax
  8018cb:	29 c2                	sub    %eax,%edx
  8018cd:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8018d0:	e9 60 ff ff ff       	jmp    801835 <vprintfmt+0x199>
  8018d5:	89 cf                	mov    %ecx,%edi
  8018d7:	eb 02                	jmp    8018db <vprintfmt+0x23f>
  8018d9:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8018db:	85 ff                	test   %edi,%edi
  8018dd:	7e 10                	jle    8018ef <vprintfmt+0x253>
				putch(' ', putdat);
  8018df:	83 ec 08             	sub    $0x8,%esp
  8018e2:	53                   	push   %ebx
  8018e3:	6a 20                	push   $0x20
  8018e5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018e7:	83 ef 01             	sub    $0x1,%edi
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	eb ec                	jmp    8018db <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8018ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8018f5:	e9 63 01 00 00       	jmp    801a5d <vprintfmt+0x3c1>
	if (lflag >= 2)
  8018fa:	83 f9 01             	cmp    $0x1,%ecx
  8018fd:	7f 1b                	jg     80191a <vprintfmt+0x27e>
	else if (lflag)
  8018ff:	85 c9                	test   %ecx,%ecx
  801901:	74 63                	je     801966 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  801903:	8b 45 14             	mov    0x14(%ebp),%eax
  801906:	8b 00                	mov    (%eax),%eax
  801908:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80190b:	99                   	cltd   
  80190c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80190f:	8b 45 14             	mov    0x14(%ebp),%eax
  801912:	8d 40 04             	lea    0x4(%eax),%eax
  801915:	89 45 14             	mov    %eax,0x14(%ebp)
  801918:	eb 17                	jmp    801931 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  80191a:	8b 45 14             	mov    0x14(%ebp),%eax
  80191d:	8b 50 04             	mov    0x4(%eax),%edx
  801920:	8b 00                	mov    (%eax),%eax
  801922:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801925:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801928:	8b 45 14             	mov    0x14(%ebp),%eax
  80192b:	8d 40 08             	lea    0x8(%eax),%eax
  80192e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801931:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801934:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801937:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80193c:	85 c9                	test   %ecx,%ecx
  80193e:	0f 89 ff 00 00 00    	jns    801a43 <vprintfmt+0x3a7>
				putch('-', putdat);
  801944:	83 ec 08             	sub    $0x8,%esp
  801947:	53                   	push   %ebx
  801948:	6a 2d                	push   $0x2d
  80194a:	ff d6                	call   *%esi
				num = -(long long) num;
  80194c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80194f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801952:	f7 da                	neg    %edx
  801954:	83 d1 00             	adc    $0x0,%ecx
  801957:	f7 d9                	neg    %ecx
  801959:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80195c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801961:	e9 dd 00 00 00       	jmp    801a43 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  801966:	8b 45 14             	mov    0x14(%ebp),%eax
  801969:	8b 00                	mov    (%eax),%eax
  80196b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80196e:	99                   	cltd   
  80196f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801972:	8b 45 14             	mov    0x14(%ebp),%eax
  801975:	8d 40 04             	lea    0x4(%eax),%eax
  801978:	89 45 14             	mov    %eax,0x14(%ebp)
  80197b:	eb b4                	jmp    801931 <vprintfmt+0x295>
	if (lflag >= 2)
  80197d:	83 f9 01             	cmp    $0x1,%ecx
  801980:	7f 1e                	jg     8019a0 <vprintfmt+0x304>
	else if (lflag)
  801982:	85 c9                	test   %ecx,%ecx
  801984:	74 32                	je     8019b8 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  801986:	8b 45 14             	mov    0x14(%ebp),%eax
  801989:	8b 10                	mov    (%eax),%edx
  80198b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801990:	8d 40 04             	lea    0x4(%eax),%eax
  801993:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801996:	b8 0a 00 00 00       	mov    $0xa,%eax
  80199b:	e9 a3 00 00 00       	jmp    801a43 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8019a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a3:	8b 10                	mov    (%eax),%edx
  8019a5:	8b 48 04             	mov    0x4(%eax),%ecx
  8019a8:	8d 40 08             	lea    0x8(%eax),%eax
  8019ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019b3:	e9 8b 00 00 00       	jmp    801a43 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8019b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bb:	8b 10                	mov    (%eax),%edx
  8019bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c2:	8d 40 04             	lea    0x4(%eax),%eax
  8019c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019cd:	eb 74                	jmp    801a43 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8019cf:	83 f9 01             	cmp    $0x1,%ecx
  8019d2:	7f 1b                	jg     8019ef <vprintfmt+0x353>
	else if (lflag)
  8019d4:	85 c9                	test   %ecx,%ecx
  8019d6:	74 2c                	je     801a04 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8019d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019db:	8b 10                	mov    (%eax),%edx
  8019dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e2:	8d 40 04             	lea    0x4(%eax),%eax
  8019e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019e8:	b8 08 00 00 00       	mov    $0x8,%eax
  8019ed:	eb 54                	jmp    801a43 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8019ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f2:	8b 10                	mov    (%eax),%edx
  8019f4:	8b 48 04             	mov    0x4(%eax),%ecx
  8019f7:	8d 40 08             	lea    0x8(%eax),%eax
  8019fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019fd:	b8 08 00 00 00       	mov    $0x8,%eax
  801a02:	eb 3f                	jmp    801a43 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801a04:	8b 45 14             	mov    0x14(%ebp),%eax
  801a07:	8b 10                	mov    (%eax),%edx
  801a09:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0e:	8d 40 04             	lea    0x4(%eax),%eax
  801a11:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a14:	b8 08 00 00 00       	mov    $0x8,%eax
  801a19:	eb 28                	jmp    801a43 <vprintfmt+0x3a7>
			putch('0', putdat);
  801a1b:	83 ec 08             	sub    $0x8,%esp
  801a1e:	53                   	push   %ebx
  801a1f:	6a 30                	push   $0x30
  801a21:	ff d6                	call   *%esi
			putch('x', putdat);
  801a23:	83 c4 08             	add    $0x8,%esp
  801a26:	53                   	push   %ebx
  801a27:	6a 78                	push   $0x78
  801a29:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2e:	8b 10                	mov    (%eax),%edx
  801a30:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a35:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a38:	8d 40 04             	lea    0x4(%eax),%eax
  801a3b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a3e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a43:	83 ec 0c             	sub    $0xc,%esp
  801a46:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801a4a:	57                   	push   %edi
  801a4b:	ff 75 e0             	pushl  -0x20(%ebp)
  801a4e:	50                   	push   %eax
  801a4f:	51                   	push   %ecx
  801a50:	52                   	push   %edx
  801a51:	89 da                	mov    %ebx,%edx
  801a53:	89 f0                	mov    %esi,%eax
  801a55:	e8 5a fb ff ff       	call   8015b4 <printnum>
			break;
  801a5a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801a5d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a60:	e9 55 fc ff ff       	jmp    8016ba <vprintfmt+0x1e>
	if (lflag >= 2)
  801a65:	83 f9 01             	cmp    $0x1,%ecx
  801a68:	7f 1b                	jg     801a85 <vprintfmt+0x3e9>
	else if (lflag)
  801a6a:	85 c9                	test   %ecx,%ecx
  801a6c:	74 2c                	je     801a9a <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  801a6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a71:	8b 10                	mov    (%eax),%edx
  801a73:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a78:	8d 40 04             	lea    0x4(%eax),%eax
  801a7b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a7e:	b8 10 00 00 00       	mov    $0x10,%eax
  801a83:	eb be                	jmp    801a43 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801a85:	8b 45 14             	mov    0x14(%ebp),%eax
  801a88:	8b 10                	mov    (%eax),%edx
  801a8a:	8b 48 04             	mov    0x4(%eax),%ecx
  801a8d:	8d 40 08             	lea    0x8(%eax),%eax
  801a90:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a93:	b8 10 00 00 00       	mov    $0x10,%eax
  801a98:	eb a9                	jmp    801a43 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801a9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9d:	8b 10                	mov    (%eax),%edx
  801a9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa4:	8d 40 04             	lea    0x4(%eax),%eax
  801aa7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aaa:	b8 10 00 00 00       	mov    $0x10,%eax
  801aaf:	eb 92                	jmp    801a43 <vprintfmt+0x3a7>
			putch(ch, putdat);
  801ab1:	83 ec 08             	sub    $0x8,%esp
  801ab4:	53                   	push   %ebx
  801ab5:	6a 25                	push   $0x25
  801ab7:	ff d6                	call   *%esi
			break;
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	eb 9f                	jmp    801a5d <vprintfmt+0x3c1>
			putch('%', putdat);
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	53                   	push   %ebx
  801ac2:	6a 25                	push   $0x25
  801ac4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ac6:	83 c4 10             	add    $0x10,%esp
  801ac9:	89 f8                	mov    %edi,%eax
  801acb:	eb 03                	jmp    801ad0 <vprintfmt+0x434>
  801acd:	83 e8 01             	sub    $0x1,%eax
  801ad0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801ad4:	75 f7                	jne    801acd <vprintfmt+0x431>
  801ad6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ad9:	eb 82                	jmp    801a5d <vprintfmt+0x3c1>

00801adb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 18             	sub    $0x18,%esp
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ae7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801aea:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801aee:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801af1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801af8:	85 c0                	test   %eax,%eax
  801afa:	74 26                	je     801b22 <vsnprintf+0x47>
  801afc:	85 d2                	test   %edx,%edx
  801afe:	7e 22                	jle    801b22 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b00:	ff 75 14             	pushl  0x14(%ebp)
  801b03:	ff 75 10             	pushl  0x10(%ebp)
  801b06:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b09:	50                   	push   %eax
  801b0a:	68 62 16 80 00       	push   $0x801662
  801b0f:	e8 88 fb ff ff       	call   80169c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b17:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1d:	83 c4 10             	add    $0x10,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    
		return -E_INVAL;
  801b22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b27:	eb f7                	jmp    801b20 <vsnprintf+0x45>

00801b29 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b2f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b32:	50                   	push   %eax
  801b33:	ff 75 10             	pushl  0x10(%ebp)
  801b36:	ff 75 0c             	pushl  0xc(%ebp)
  801b39:	ff 75 08             	pushl  0x8(%ebp)
  801b3c:	e8 9a ff ff ff       	call   801adb <vsnprintf>
	va_end(ap);

	return rc;
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b49:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b52:	74 05                	je     801b59 <strlen+0x16>
		n++;
  801b54:	83 c0 01             	add    $0x1,%eax
  801b57:	eb f5                	jmp    801b4e <strlen+0xb>
	return n;
}
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    

00801b5b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b61:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b64:	ba 00 00 00 00       	mov    $0x0,%edx
  801b69:	39 c2                	cmp    %eax,%edx
  801b6b:	74 0d                	je     801b7a <strnlen+0x1f>
  801b6d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801b71:	74 05                	je     801b78 <strnlen+0x1d>
		n++;
  801b73:	83 c2 01             	add    $0x1,%edx
  801b76:	eb f1                	jmp    801b69 <strnlen+0xe>
  801b78:	89 d0                	mov    %edx,%eax
	return n;
}
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    

00801b7c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	53                   	push   %ebx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b86:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801b8f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801b92:	83 c2 01             	add    $0x1,%edx
  801b95:	84 c9                	test   %cl,%cl
  801b97:	75 f2                	jne    801b8b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801b99:	5b                   	pop    %ebx
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    

00801b9c <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	53                   	push   %ebx
  801ba0:	83 ec 10             	sub    $0x10,%esp
  801ba3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801ba6:	53                   	push   %ebx
  801ba7:	e8 97 ff ff ff       	call   801b43 <strlen>
  801bac:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801baf:	ff 75 0c             	pushl  0xc(%ebp)
  801bb2:	01 d8                	add    %ebx,%eax
  801bb4:	50                   	push   %eax
  801bb5:	e8 c2 ff ff ff       	call   801b7c <strcpy>
	return dst;
}
  801bba:	89 d8                	mov    %ebx,%eax
  801bbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	56                   	push   %esi
  801bc5:	53                   	push   %ebx
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bcc:	89 c6                	mov    %eax,%esi
  801bce:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bd1:	89 c2                	mov    %eax,%edx
  801bd3:	39 f2                	cmp    %esi,%edx
  801bd5:	74 11                	je     801be8 <strncpy+0x27>
		*dst++ = *src;
  801bd7:	83 c2 01             	add    $0x1,%edx
  801bda:	0f b6 19             	movzbl (%ecx),%ebx
  801bdd:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801be0:	80 fb 01             	cmp    $0x1,%bl
  801be3:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801be6:	eb eb                	jmp    801bd3 <strncpy+0x12>
	}
	return ret;
}
  801be8:	5b                   	pop    %ebx
  801be9:	5e                   	pop    %esi
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    

00801bec <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	56                   	push   %esi
  801bf0:	53                   	push   %ebx
  801bf1:	8b 75 08             	mov    0x8(%ebp),%esi
  801bf4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bf7:	8b 55 10             	mov    0x10(%ebp),%edx
  801bfa:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801bfc:	85 d2                	test   %edx,%edx
  801bfe:	74 21                	je     801c21 <strlcpy+0x35>
  801c00:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801c04:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801c06:	39 c2                	cmp    %eax,%edx
  801c08:	74 14                	je     801c1e <strlcpy+0x32>
  801c0a:	0f b6 19             	movzbl (%ecx),%ebx
  801c0d:	84 db                	test   %bl,%bl
  801c0f:	74 0b                	je     801c1c <strlcpy+0x30>
			*dst++ = *src++;
  801c11:	83 c1 01             	add    $0x1,%ecx
  801c14:	83 c2 01             	add    $0x1,%edx
  801c17:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c1a:	eb ea                	jmp    801c06 <strlcpy+0x1a>
  801c1c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801c1e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c21:	29 f0                	sub    %esi,%eax
}
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5d                   	pop    %ebp
  801c26:	c3                   	ret    

00801c27 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c30:	0f b6 01             	movzbl (%ecx),%eax
  801c33:	84 c0                	test   %al,%al
  801c35:	74 0c                	je     801c43 <strcmp+0x1c>
  801c37:	3a 02                	cmp    (%edx),%al
  801c39:	75 08                	jne    801c43 <strcmp+0x1c>
		p++, q++;
  801c3b:	83 c1 01             	add    $0x1,%ecx
  801c3e:	83 c2 01             	add    $0x1,%edx
  801c41:	eb ed                	jmp    801c30 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c43:	0f b6 c0             	movzbl %al,%eax
  801c46:	0f b6 12             	movzbl (%edx),%edx
  801c49:	29 d0                	sub    %edx,%eax
}
  801c4b:	5d                   	pop    %ebp
  801c4c:	c3                   	ret    

00801c4d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	53                   	push   %ebx
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c57:	89 c3                	mov    %eax,%ebx
  801c59:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c5c:	eb 06                	jmp    801c64 <strncmp+0x17>
		n--, p++, q++;
  801c5e:	83 c0 01             	add    $0x1,%eax
  801c61:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c64:	39 d8                	cmp    %ebx,%eax
  801c66:	74 16                	je     801c7e <strncmp+0x31>
  801c68:	0f b6 08             	movzbl (%eax),%ecx
  801c6b:	84 c9                	test   %cl,%cl
  801c6d:	74 04                	je     801c73 <strncmp+0x26>
  801c6f:	3a 0a                	cmp    (%edx),%cl
  801c71:	74 eb                	je     801c5e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c73:	0f b6 00             	movzbl (%eax),%eax
  801c76:	0f b6 12             	movzbl (%edx),%edx
  801c79:	29 d0                	sub    %edx,%eax
}
  801c7b:	5b                   	pop    %ebx
  801c7c:	5d                   	pop    %ebp
  801c7d:	c3                   	ret    
		return 0;
  801c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c83:	eb f6                	jmp    801c7b <strncmp+0x2e>

00801c85 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801c8f:	0f b6 10             	movzbl (%eax),%edx
  801c92:	84 d2                	test   %dl,%dl
  801c94:	74 09                	je     801c9f <strchr+0x1a>
		if (*s == c)
  801c96:	38 ca                	cmp    %cl,%dl
  801c98:	74 0a                	je     801ca4 <strchr+0x1f>
	for (; *s; s++)
  801c9a:	83 c0 01             	add    $0x1,%eax
  801c9d:	eb f0                	jmp    801c8f <strchr+0xa>
			return (char *) s;
	return 0;
  801c9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca4:	5d                   	pop    %ebp
  801ca5:	c3                   	ret    

00801ca6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cb0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cb3:	38 ca                	cmp    %cl,%dl
  801cb5:	74 09                	je     801cc0 <strfind+0x1a>
  801cb7:	84 d2                	test   %dl,%dl
  801cb9:	74 05                	je     801cc0 <strfind+0x1a>
	for (; *s; s++)
  801cbb:	83 c0 01             	add    $0x1,%eax
  801cbe:	eb f0                	jmp    801cb0 <strfind+0xa>
			break;
	return (char *) s;
}
  801cc0:	5d                   	pop    %ebp
  801cc1:	c3                   	ret    

00801cc2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	57                   	push   %edi
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ccb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801cce:	85 c9                	test   %ecx,%ecx
  801cd0:	74 31                	je     801d03 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801cd2:	89 f8                	mov    %edi,%eax
  801cd4:	09 c8                	or     %ecx,%eax
  801cd6:	a8 03                	test   $0x3,%al
  801cd8:	75 23                	jne    801cfd <memset+0x3b>
		c &= 0xFF;
  801cda:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801cde:	89 d3                	mov    %edx,%ebx
  801ce0:	c1 e3 08             	shl    $0x8,%ebx
  801ce3:	89 d0                	mov    %edx,%eax
  801ce5:	c1 e0 18             	shl    $0x18,%eax
  801ce8:	89 d6                	mov    %edx,%esi
  801cea:	c1 e6 10             	shl    $0x10,%esi
  801ced:	09 f0                	or     %esi,%eax
  801cef:	09 c2                	or     %eax,%edx
  801cf1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801cf3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801cf6:	89 d0                	mov    %edx,%eax
  801cf8:	fc                   	cld    
  801cf9:	f3 ab                	rep stos %eax,%es:(%edi)
  801cfb:	eb 06                	jmp    801d03 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d00:	fc                   	cld    
  801d01:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801d03:	89 f8                	mov    %edi,%eax
  801d05:	5b                   	pop    %ebx
  801d06:	5e                   	pop    %esi
  801d07:	5f                   	pop    %edi
  801d08:	5d                   	pop    %ebp
  801d09:	c3                   	ret    

00801d0a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	57                   	push   %edi
  801d0e:	56                   	push   %esi
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d15:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d18:	39 c6                	cmp    %eax,%esi
  801d1a:	73 32                	jae    801d4e <memmove+0x44>
  801d1c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d1f:	39 c2                	cmp    %eax,%edx
  801d21:	76 2b                	jbe    801d4e <memmove+0x44>
		s += n;
		d += n;
  801d23:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d26:	89 fe                	mov    %edi,%esi
  801d28:	09 ce                	or     %ecx,%esi
  801d2a:	09 d6                	or     %edx,%esi
  801d2c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d32:	75 0e                	jne    801d42 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d34:	83 ef 04             	sub    $0x4,%edi
  801d37:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d3a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d3d:	fd                   	std    
  801d3e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d40:	eb 09                	jmp    801d4b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d42:	83 ef 01             	sub    $0x1,%edi
  801d45:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d48:	fd                   	std    
  801d49:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d4b:	fc                   	cld    
  801d4c:	eb 1a                	jmp    801d68 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d4e:	89 c2                	mov    %eax,%edx
  801d50:	09 ca                	or     %ecx,%edx
  801d52:	09 f2                	or     %esi,%edx
  801d54:	f6 c2 03             	test   $0x3,%dl
  801d57:	75 0a                	jne    801d63 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d59:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d5c:	89 c7                	mov    %eax,%edi
  801d5e:	fc                   	cld    
  801d5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d61:	eb 05                	jmp    801d68 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801d63:	89 c7                	mov    %eax,%edi
  801d65:	fc                   	cld    
  801d66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d68:	5e                   	pop    %esi
  801d69:	5f                   	pop    %edi
  801d6a:	5d                   	pop    %ebp
  801d6b:	c3                   	ret    

00801d6c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801d72:	ff 75 10             	pushl  0x10(%ebp)
  801d75:	ff 75 0c             	pushl  0xc(%ebp)
  801d78:	ff 75 08             	pushl  0x8(%ebp)
  801d7b:	e8 8a ff ff ff       	call   801d0a <memmove>
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	56                   	push   %esi
  801d86:	53                   	push   %ebx
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8d:	89 c6                	mov    %eax,%esi
  801d8f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801d92:	39 f0                	cmp    %esi,%eax
  801d94:	74 1c                	je     801db2 <memcmp+0x30>
		if (*s1 != *s2)
  801d96:	0f b6 08             	movzbl (%eax),%ecx
  801d99:	0f b6 1a             	movzbl (%edx),%ebx
  801d9c:	38 d9                	cmp    %bl,%cl
  801d9e:	75 08                	jne    801da8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801da0:	83 c0 01             	add    $0x1,%eax
  801da3:	83 c2 01             	add    $0x1,%edx
  801da6:	eb ea                	jmp    801d92 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801da8:	0f b6 c1             	movzbl %cl,%eax
  801dab:	0f b6 db             	movzbl %bl,%ebx
  801dae:	29 d8                	sub    %ebx,%eax
  801db0:	eb 05                	jmp    801db7 <memcmp+0x35>
	}

	return 0;
  801db2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5d                   	pop    %ebp
  801dba:	c3                   	ret    

00801dbb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801dc4:	89 c2                	mov    %eax,%edx
  801dc6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801dc9:	39 d0                	cmp    %edx,%eax
  801dcb:	73 09                	jae    801dd6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dcd:	38 08                	cmp    %cl,(%eax)
  801dcf:	74 05                	je     801dd6 <memfind+0x1b>
	for (; s < ends; s++)
  801dd1:	83 c0 01             	add    $0x1,%eax
  801dd4:	eb f3                	jmp    801dc9 <memfind+0xe>
			break;
	return (void *) s;
}
  801dd6:	5d                   	pop    %ebp
  801dd7:	c3                   	ret    

00801dd8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	57                   	push   %edi
  801ddc:	56                   	push   %esi
  801ddd:	53                   	push   %ebx
  801dde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801de4:	eb 03                	jmp    801de9 <strtol+0x11>
		s++;
  801de6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801de9:	0f b6 01             	movzbl (%ecx),%eax
  801dec:	3c 20                	cmp    $0x20,%al
  801dee:	74 f6                	je     801de6 <strtol+0xe>
  801df0:	3c 09                	cmp    $0x9,%al
  801df2:	74 f2                	je     801de6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801df4:	3c 2b                	cmp    $0x2b,%al
  801df6:	74 2a                	je     801e22 <strtol+0x4a>
	int neg = 0;
  801df8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801dfd:	3c 2d                	cmp    $0x2d,%al
  801dff:	74 2b                	je     801e2c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e01:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e07:	75 0f                	jne    801e18 <strtol+0x40>
  801e09:	80 39 30             	cmpb   $0x30,(%ecx)
  801e0c:	74 28                	je     801e36 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e0e:	85 db                	test   %ebx,%ebx
  801e10:	b8 0a 00 00 00       	mov    $0xa,%eax
  801e15:	0f 44 d8             	cmove  %eax,%ebx
  801e18:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e20:	eb 50                	jmp    801e72 <strtol+0x9a>
		s++;
  801e22:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e25:	bf 00 00 00 00       	mov    $0x0,%edi
  801e2a:	eb d5                	jmp    801e01 <strtol+0x29>
		s++, neg = 1;
  801e2c:	83 c1 01             	add    $0x1,%ecx
  801e2f:	bf 01 00 00 00       	mov    $0x1,%edi
  801e34:	eb cb                	jmp    801e01 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e36:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e3a:	74 0e                	je     801e4a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801e3c:	85 db                	test   %ebx,%ebx
  801e3e:	75 d8                	jne    801e18 <strtol+0x40>
		s++, base = 8;
  801e40:	83 c1 01             	add    $0x1,%ecx
  801e43:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e48:	eb ce                	jmp    801e18 <strtol+0x40>
		s += 2, base = 16;
  801e4a:	83 c1 02             	add    $0x2,%ecx
  801e4d:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e52:	eb c4                	jmp    801e18 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e54:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e57:	89 f3                	mov    %esi,%ebx
  801e59:	80 fb 19             	cmp    $0x19,%bl
  801e5c:	77 29                	ja     801e87 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801e5e:	0f be d2             	movsbl %dl,%edx
  801e61:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e64:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e67:	7d 30                	jge    801e99 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801e69:	83 c1 01             	add    $0x1,%ecx
  801e6c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e70:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e72:	0f b6 11             	movzbl (%ecx),%edx
  801e75:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e78:	89 f3                	mov    %esi,%ebx
  801e7a:	80 fb 09             	cmp    $0x9,%bl
  801e7d:	77 d5                	ja     801e54 <strtol+0x7c>
			dig = *s - '0';
  801e7f:	0f be d2             	movsbl %dl,%edx
  801e82:	83 ea 30             	sub    $0x30,%edx
  801e85:	eb dd                	jmp    801e64 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801e87:	8d 72 bf             	lea    -0x41(%edx),%esi
  801e8a:	89 f3                	mov    %esi,%ebx
  801e8c:	80 fb 19             	cmp    $0x19,%bl
  801e8f:	77 08                	ja     801e99 <strtol+0xc1>
			dig = *s - 'A' + 10;
  801e91:	0f be d2             	movsbl %dl,%edx
  801e94:	83 ea 37             	sub    $0x37,%edx
  801e97:	eb cb                	jmp    801e64 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801e99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e9d:	74 05                	je     801ea4 <strtol+0xcc>
		*endptr = (char *) s;
  801e9f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ea2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801ea4:	89 c2                	mov    %eax,%edx
  801ea6:	f7 da                	neg    %edx
  801ea8:	85 ff                	test   %edi,%edi
  801eaa:	0f 45 c2             	cmovne %edx,%eax
}
  801ead:	5b                   	pop    %ebx
  801eae:	5e                   	pop    %esi
  801eaf:	5f                   	pop    %edi
  801eb0:	5d                   	pop    %ebp
  801eb1:	c3                   	ret    

00801eb2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	56                   	push   %esi
  801eb6:	53                   	push   %ebx
  801eb7:	8b 75 08             	mov    0x8(%ebp),%esi
  801eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	74 4f                	je     801f13 <ipc_recv+0x61>
  801ec4:	83 ec 0c             	sub    $0xc,%esp
  801ec7:	50                   	push   %eax
  801ec8:	e8 35 e4 ff ff       	call   800302 <sys_ipc_recv>
  801ecd:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801ed0:	85 f6                	test   %esi,%esi
  801ed2:	74 14                	je     801ee8 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801ed4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed9:	85 c0                	test   %eax,%eax
  801edb:	75 09                	jne    801ee6 <ipc_recv+0x34>
  801edd:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ee3:	8b 52 74             	mov    0x74(%edx),%edx
  801ee6:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801ee8:	85 db                	test   %ebx,%ebx
  801eea:	74 14                	je     801f00 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801eec:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	75 09                	jne    801efe <ipc_recv+0x4c>
  801ef5:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801efb:	8b 52 78             	mov    0x78(%edx),%edx
  801efe:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801f00:	85 c0                	test   %eax,%eax
  801f02:	75 08                	jne    801f0c <ipc_recv+0x5a>
  801f04:	a1 08 40 80 00       	mov    0x804008,%eax
  801f09:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f0f:	5b                   	pop    %ebx
  801f10:	5e                   	pop    %esi
  801f11:	5d                   	pop    %ebp
  801f12:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f13:	83 ec 0c             	sub    $0xc,%esp
  801f16:	68 00 00 c0 ee       	push   $0xeec00000
  801f1b:	e8 e2 e3 ff ff       	call   800302 <sys_ipc_recv>
  801f20:	83 c4 10             	add    $0x10,%esp
  801f23:	eb ab                	jmp    801ed0 <ipc_recv+0x1e>

00801f25 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	57                   	push   %edi
  801f29:	56                   	push   %esi
  801f2a:	53                   	push   %ebx
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f31:	8b 75 10             	mov    0x10(%ebp),%esi
  801f34:	eb 20                	jmp    801f56 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f36:	6a 00                	push   $0x0
  801f38:	68 00 00 c0 ee       	push   $0xeec00000
  801f3d:	ff 75 0c             	pushl  0xc(%ebp)
  801f40:	57                   	push   %edi
  801f41:	e8 99 e3 ff ff       	call   8002df <sys_ipc_try_send>
  801f46:	89 c3                	mov    %eax,%ebx
  801f48:	83 c4 10             	add    $0x10,%esp
  801f4b:	eb 1f                	jmp    801f6c <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801f4d:	e8 e1 e1 ff ff       	call   800133 <sys_yield>
	while(retval != 0) {
  801f52:	85 db                	test   %ebx,%ebx
  801f54:	74 33                	je     801f89 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f56:	85 f6                	test   %esi,%esi
  801f58:	74 dc                	je     801f36 <ipc_send+0x11>
  801f5a:	ff 75 14             	pushl  0x14(%ebp)
  801f5d:	56                   	push   %esi
  801f5e:	ff 75 0c             	pushl  0xc(%ebp)
  801f61:	57                   	push   %edi
  801f62:	e8 78 e3 ff ff       	call   8002df <sys_ipc_try_send>
  801f67:	89 c3                	mov    %eax,%ebx
  801f69:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801f6c:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801f6f:	74 dc                	je     801f4d <ipc_send+0x28>
  801f71:	85 db                	test   %ebx,%ebx
  801f73:	74 d8                	je     801f4d <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801f75:	83 ec 04             	sub    $0x4,%esp
  801f78:	68 00 27 80 00       	push   $0x802700
  801f7d:	6a 35                	push   $0x35
  801f7f:	68 30 27 80 00       	push   $0x802730
  801f84:	e8 3c f5 ff ff       	call   8014c5 <_panic>
	}
}
  801f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f8c:	5b                   	pop    %ebx
  801f8d:	5e                   	pop    %esi
  801f8e:	5f                   	pop    %edi
  801f8f:	5d                   	pop    %ebp
  801f90:	c3                   	ret    

00801f91 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f9c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f9f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fa5:	8b 52 50             	mov    0x50(%edx),%edx
  801fa8:	39 ca                	cmp    %ecx,%edx
  801faa:	74 11                	je     801fbd <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fac:	83 c0 01             	add    $0x1,%eax
  801faf:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fb4:	75 e6                	jne    801f9c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbb:	eb 0b                	jmp    801fc8 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fbd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fc0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fc5:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fc8:	5d                   	pop    %ebp
  801fc9:	c3                   	ret    

00801fca <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fd0:	89 d0                	mov    %edx,%eax
  801fd2:	c1 e8 16             	shr    $0x16,%eax
  801fd5:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fdc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fe1:	f6 c1 01             	test   $0x1,%cl
  801fe4:	74 1d                	je     802003 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fe6:	c1 ea 0c             	shr    $0xc,%edx
  801fe9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ff0:	f6 c2 01             	test   $0x1,%dl
  801ff3:	74 0e                	je     802003 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ff5:	c1 ea 0c             	shr    $0xc,%edx
  801ff8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801fff:	ef 
  802000:	0f b7 c0             	movzwl %ax,%eax
}
  802003:	5d                   	pop    %ebp
  802004:	c3                   	ret    
  802005:	66 90                	xchg   %ax,%ax
  802007:	66 90                	xchg   %ax,%ax
  802009:	66 90                	xchg   %ax,%ax
  80200b:	66 90                	xchg   %ax,%ax
  80200d:	66 90                	xchg   %ax,%ax
  80200f:	90                   	nop

00802010 <__udivdi3>:
  802010:	f3 0f 1e fb          	endbr32 
  802014:	55                   	push   %ebp
  802015:	57                   	push   %edi
  802016:	56                   	push   %esi
  802017:	53                   	push   %ebx
  802018:	83 ec 1c             	sub    $0x1c,%esp
  80201b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80201f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802023:	8b 74 24 34          	mov    0x34(%esp),%esi
  802027:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80202b:	85 d2                	test   %edx,%edx
  80202d:	75 49                	jne    802078 <__udivdi3+0x68>
  80202f:	39 f3                	cmp    %esi,%ebx
  802031:	76 15                	jbe    802048 <__udivdi3+0x38>
  802033:	31 ff                	xor    %edi,%edi
  802035:	89 e8                	mov    %ebp,%eax
  802037:	89 f2                	mov    %esi,%edx
  802039:	f7 f3                	div    %ebx
  80203b:	89 fa                	mov    %edi,%edx
  80203d:	83 c4 1c             	add    $0x1c,%esp
  802040:	5b                   	pop    %ebx
  802041:	5e                   	pop    %esi
  802042:	5f                   	pop    %edi
  802043:	5d                   	pop    %ebp
  802044:	c3                   	ret    
  802045:	8d 76 00             	lea    0x0(%esi),%esi
  802048:	89 d9                	mov    %ebx,%ecx
  80204a:	85 db                	test   %ebx,%ebx
  80204c:	75 0b                	jne    802059 <__udivdi3+0x49>
  80204e:	b8 01 00 00 00       	mov    $0x1,%eax
  802053:	31 d2                	xor    %edx,%edx
  802055:	f7 f3                	div    %ebx
  802057:	89 c1                	mov    %eax,%ecx
  802059:	31 d2                	xor    %edx,%edx
  80205b:	89 f0                	mov    %esi,%eax
  80205d:	f7 f1                	div    %ecx
  80205f:	89 c6                	mov    %eax,%esi
  802061:	89 e8                	mov    %ebp,%eax
  802063:	89 f7                	mov    %esi,%edi
  802065:	f7 f1                	div    %ecx
  802067:	89 fa                	mov    %edi,%edx
  802069:	83 c4 1c             	add    $0x1c,%esp
  80206c:	5b                   	pop    %ebx
  80206d:	5e                   	pop    %esi
  80206e:	5f                   	pop    %edi
  80206f:	5d                   	pop    %ebp
  802070:	c3                   	ret    
  802071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802078:	39 f2                	cmp    %esi,%edx
  80207a:	77 1c                	ja     802098 <__udivdi3+0x88>
  80207c:	0f bd fa             	bsr    %edx,%edi
  80207f:	83 f7 1f             	xor    $0x1f,%edi
  802082:	75 2c                	jne    8020b0 <__udivdi3+0xa0>
  802084:	39 f2                	cmp    %esi,%edx
  802086:	72 06                	jb     80208e <__udivdi3+0x7e>
  802088:	31 c0                	xor    %eax,%eax
  80208a:	39 eb                	cmp    %ebp,%ebx
  80208c:	77 ad                	ja     80203b <__udivdi3+0x2b>
  80208e:	b8 01 00 00 00       	mov    $0x1,%eax
  802093:	eb a6                	jmp    80203b <__udivdi3+0x2b>
  802095:	8d 76 00             	lea    0x0(%esi),%esi
  802098:	31 ff                	xor    %edi,%edi
  80209a:	31 c0                	xor    %eax,%eax
  80209c:	89 fa                	mov    %edi,%edx
  80209e:	83 c4 1c             	add    $0x1c,%esp
  8020a1:	5b                   	pop    %ebx
  8020a2:	5e                   	pop    %esi
  8020a3:	5f                   	pop    %edi
  8020a4:	5d                   	pop    %ebp
  8020a5:	c3                   	ret    
  8020a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020ad:	8d 76 00             	lea    0x0(%esi),%esi
  8020b0:	89 f9                	mov    %edi,%ecx
  8020b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020b7:	29 f8                	sub    %edi,%eax
  8020b9:	d3 e2                	shl    %cl,%edx
  8020bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020bf:	89 c1                	mov    %eax,%ecx
  8020c1:	89 da                	mov    %ebx,%edx
  8020c3:	d3 ea                	shr    %cl,%edx
  8020c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020c9:	09 d1                	or     %edx,%ecx
  8020cb:	89 f2                	mov    %esi,%edx
  8020cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020d1:	89 f9                	mov    %edi,%ecx
  8020d3:	d3 e3                	shl    %cl,%ebx
  8020d5:	89 c1                	mov    %eax,%ecx
  8020d7:	d3 ea                	shr    %cl,%edx
  8020d9:	89 f9                	mov    %edi,%ecx
  8020db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020df:	89 eb                	mov    %ebp,%ebx
  8020e1:	d3 e6                	shl    %cl,%esi
  8020e3:	89 c1                	mov    %eax,%ecx
  8020e5:	d3 eb                	shr    %cl,%ebx
  8020e7:	09 de                	or     %ebx,%esi
  8020e9:	89 f0                	mov    %esi,%eax
  8020eb:	f7 74 24 08          	divl   0x8(%esp)
  8020ef:	89 d6                	mov    %edx,%esi
  8020f1:	89 c3                	mov    %eax,%ebx
  8020f3:	f7 64 24 0c          	mull   0xc(%esp)
  8020f7:	39 d6                	cmp    %edx,%esi
  8020f9:	72 15                	jb     802110 <__udivdi3+0x100>
  8020fb:	89 f9                	mov    %edi,%ecx
  8020fd:	d3 e5                	shl    %cl,%ebp
  8020ff:	39 c5                	cmp    %eax,%ebp
  802101:	73 04                	jae    802107 <__udivdi3+0xf7>
  802103:	39 d6                	cmp    %edx,%esi
  802105:	74 09                	je     802110 <__udivdi3+0x100>
  802107:	89 d8                	mov    %ebx,%eax
  802109:	31 ff                	xor    %edi,%edi
  80210b:	e9 2b ff ff ff       	jmp    80203b <__udivdi3+0x2b>
  802110:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802113:	31 ff                	xor    %edi,%edi
  802115:	e9 21 ff ff ff       	jmp    80203b <__udivdi3+0x2b>
  80211a:	66 90                	xchg   %ax,%ax
  80211c:	66 90                	xchg   %ax,%ax
  80211e:	66 90                	xchg   %ax,%ax

00802120 <__umoddi3>:
  802120:	f3 0f 1e fb          	endbr32 
  802124:	55                   	push   %ebp
  802125:	57                   	push   %edi
  802126:	56                   	push   %esi
  802127:	53                   	push   %ebx
  802128:	83 ec 1c             	sub    $0x1c,%esp
  80212b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80212f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802133:	8b 74 24 30          	mov    0x30(%esp),%esi
  802137:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80213b:	89 da                	mov    %ebx,%edx
  80213d:	85 c0                	test   %eax,%eax
  80213f:	75 3f                	jne    802180 <__umoddi3+0x60>
  802141:	39 df                	cmp    %ebx,%edi
  802143:	76 13                	jbe    802158 <__umoddi3+0x38>
  802145:	89 f0                	mov    %esi,%eax
  802147:	f7 f7                	div    %edi
  802149:	89 d0                	mov    %edx,%eax
  80214b:	31 d2                	xor    %edx,%edx
  80214d:	83 c4 1c             	add    $0x1c,%esp
  802150:	5b                   	pop    %ebx
  802151:	5e                   	pop    %esi
  802152:	5f                   	pop    %edi
  802153:	5d                   	pop    %ebp
  802154:	c3                   	ret    
  802155:	8d 76 00             	lea    0x0(%esi),%esi
  802158:	89 fd                	mov    %edi,%ebp
  80215a:	85 ff                	test   %edi,%edi
  80215c:	75 0b                	jne    802169 <__umoddi3+0x49>
  80215e:	b8 01 00 00 00       	mov    $0x1,%eax
  802163:	31 d2                	xor    %edx,%edx
  802165:	f7 f7                	div    %edi
  802167:	89 c5                	mov    %eax,%ebp
  802169:	89 d8                	mov    %ebx,%eax
  80216b:	31 d2                	xor    %edx,%edx
  80216d:	f7 f5                	div    %ebp
  80216f:	89 f0                	mov    %esi,%eax
  802171:	f7 f5                	div    %ebp
  802173:	89 d0                	mov    %edx,%eax
  802175:	eb d4                	jmp    80214b <__umoddi3+0x2b>
  802177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80217e:	66 90                	xchg   %ax,%ax
  802180:	89 f1                	mov    %esi,%ecx
  802182:	39 d8                	cmp    %ebx,%eax
  802184:	76 0a                	jbe    802190 <__umoddi3+0x70>
  802186:	89 f0                	mov    %esi,%eax
  802188:	83 c4 1c             	add    $0x1c,%esp
  80218b:	5b                   	pop    %ebx
  80218c:	5e                   	pop    %esi
  80218d:	5f                   	pop    %edi
  80218e:	5d                   	pop    %ebp
  80218f:	c3                   	ret    
  802190:	0f bd e8             	bsr    %eax,%ebp
  802193:	83 f5 1f             	xor    $0x1f,%ebp
  802196:	75 20                	jne    8021b8 <__umoddi3+0x98>
  802198:	39 d8                	cmp    %ebx,%eax
  80219a:	0f 82 b0 00 00 00    	jb     802250 <__umoddi3+0x130>
  8021a0:	39 f7                	cmp    %esi,%edi
  8021a2:	0f 86 a8 00 00 00    	jbe    802250 <__umoddi3+0x130>
  8021a8:	89 c8                	mov    %ecx,%eax
  8021aa:	83 c4 1c             	add    $0x1c,%esp
  8021ad:	5b                   	pop    %ebx
  8021ae:	5e                   	pop    %esi
  8021af:	5f                   	pop    %edi
  8021b0:	5d                   	pop    %ebp
  8021b1:	c3                   	ret    
  8021b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021b8:	89 e9                	mov    %ebp,%ecx
  8021ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8021bf:	29 ea                	sub    %ebp,%edx
  8021c1:	d3 e0                	shl    %cl,%eax
  8021c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c7:	89 d1                	mov    %edx,%ecx
  8021c9:	89 f8                	mov    %edi,%eax
  8021cb:	d3 e8                	shr    %cl,%eax
  8021cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021d9:	09 c1                	or     %eax,%ecx
  8021db:	89 d8                	mov    %ebx,%eax
  8021dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021e1:	89 e9                	mov    %ebp,%ecx
  8021e3:	d3 e7                	shl    %cl,%edi
  8021e5:	89 d1                	mov    %edx,%ecx
  8021e7:	d3 e8                	shr    %cl,%eax
  8021e9:	89 e9                	mov    %ebp,%ecx
  8021eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021ef:	d3 e3                	shl    %cl,%ebx
  8021f1:	89 c7                	mov    %eax,%edi
  8021f3:	89 d1                	mov    %edx,%ecx
  8021f5:	89 f0                	mov    %esi,%eax
  8021f7:	d3 e8                	shr    %cl,%eax
  8021f9:	89 e9                	mov    %ebp,%ecx
  8021fb:	89 fa                	mov    %edi,%edx
  8021fd:	d3 e6                	shl    %cl,%esi
  8021ff:	09 d8                	or     %ebx,%eax
  802201:	f7 74 24 08          	divl   0x8(%esp)
  802205:	89 d1                	mov    %edx,%ecx
  802207:	89 f3                	mov    %esi,%ebx
  802209:	f7 64 24 0c          	mull   0xc(%esp)
  80220d:	89 c6                	mov    %eax,%esi
  80220f:	89 d7                	mov    %edx,%edi
  802211:	39 d1                	cmp    %edx,%ecx
  802213:	72 06                	jb     80221b <__umoddi3+0xfb>
  802215:	75 10                	jne    802227 <__umoddi3+0x107>
  802217:	39 c3                	cmp    %eax,%ebx
  802219:	73 0c                	jae    802227 <__umoddi3+0x107>
  80221b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80221f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802223:	89 d7                	mov    %edx,%edi
  802225:	89 c6                	mov    %eax,%esi
  802227:	89 ca                	mov    %ecx,%edx
  802229:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80222e:	29 f3                	sub    %esi,%ebx
  802230:	19 fa                	sbb    %edi,%edx
  802232:	89 d0                	mov    %edx,%eax
  802234:	d3 e0                	shl    %cl,%eax
  802236:	89 e9                	mov    %ebp,%ecx
  802238:	d3 eb                	shr    %cl,%ebx
  80223a:	d3 ea                	shr    %cl,%edx
  80223c:	09 d8                	or     %ebx,%eax
  80223e:	83 c4 1c             	add    $0x1c,%esp
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	5f                   	pop    %edi
  802244:	5d                   	pop    %ebp
  802245:	c3                   	ret    
  802246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80224d:	8d 76 00             	lea    0x0(%esi),%esi
  802250:	89 da                	mov    %ebx,%edx
  802252:	29 fe                	sub    %edi,%esi
  802254:	19 c2                	sbb    %eax,%edx
  802256:	89 f1                	mov    %esi,%ecx
  802258:	89 c8                	mov    %ecx,%eax
  80225a:	e9 4b ff ff ff       	jmp    8021aa <__umoddi3+0x8a>
