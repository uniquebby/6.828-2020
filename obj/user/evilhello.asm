
obj/user/evilhello.debug：     文件格式 elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  800039:	6a 64                	push   $0x64
  80003b:	68 0c 00 10 f0       	push   $0xf010000c
  800040:	e8 65 00 00 00       	call   8000aa <sys_cputs>
}
  800045:	83 c4 10             	add    $0x10,%esp
  800048:	c9                   	leave  
  800049:	c3                   	ret    

0080004a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	56                   	push   %esi
  80004e:	53                   	push   %ebx
  80004f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800052:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800055:	e8 ce 00 00 00       	call   800128 <sys_getenvid>
  80005a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800062:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800067:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006c:	85 db                	test   %ebx,%ebx
  80006e:	7e 07                	jle    800077 <libmain+0x2d>
		binaryname = argv[0];
  800070:	8b 06                	mov    (%esi),%eax
  800072:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800077:	83 ec 08             	sub    $0x8,%esp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	e8 b2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800081:	e8 0a 00 00 00       	call   800090 <exit>
}
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008c:	5b                   	pop    %ebx
  80008d:	5e                   	pop    %esi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    

00800090 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800096:	e8 b3 04 00 00       	call   80054e <close_all>
	sys_env_destroy(0);
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	6a 00                	push   $0x0
  8000a0:	e8 42 00 00 00       	call   8000e7 <sys_env_destroy>
}
  8000a5:	83 c4 10             	add    $0x10,%esp
  8000a8:	c9                   	leave  
  8000a9:	c3                   	ret    

008000aa <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000aa:	55                   	push   %ebp
  8000ab:	89 e5                	mov    %esp,%ebp
  8000ad:	57                   	push   %edi
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bb:	89 c3                	mov    %eax,%ebx
  8000bd:	89 c7                	mov    %eax,%edi
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c3:	5b                   	pop    %ebx
  8000c4:	5e                   	pop    %esi
  8000c5:	5f                   	pop    %edi
  8000c6:	5d                   	pop    %ebp
  8000c7:	c3                   	ret    

008000c8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	57                   	push   %edi
  8000cc:	56                   	push   %esi
  8000cd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d8:	89 d1                	mov    %edx,%ecx
  8000da:	89 d3                	mov    %edx,%ebx
  8000dc:	89 d7                	mov    %edx,%edi
  8000de:	89 d6                	mov    %edx,%esi
  8000e0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e2:	5b                   	pop    %ebx
  8000e3:	5e                   	pop    %esi
  8000e4:	5f                   	pop    %edi
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
  8000ea:	57                   	push   %edi
  8000eb:	56                   	push   %esi
  8000ec:	53                   	push   %ebx
  8000ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f8:	b8 03 00 00 00       	mov    $0x3,%eax
  8000fd:	89 cb                	mov    %ecx,%ebx
  8000ff:	89 cf                	mov    %ecx,%edi
  800101:	89 ce                	mov    %ecx,%esi
  800103:	cd 30                	int    $0x30
	if(check && ret > 0)
  800105:	85 c0                	test   %eax,%eax
  800107:	7f 08                	jg     800111 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	50                   	push   %eax
  800115:	6a 03                	push   $0x3
  800117:	68 8a 22 80 00       	push   $0x80228a
  80011c:	6a 23                	push   $0x23
  80011e:	68 a7 22 80 00       	push   $0x8022a7
  800123:	e8 b1 13 00 00       	call   8014d9 <_panic>

00800128 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	57                   	push   %edi
  80012c:	56                   	push   %esi
  80012d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80012e:	ba 00 00 00 00       	mov    $0x0,%edx
  800133:	b8 02 00 00 00       	mov    $0x2,%eax
  800138:	89 d1                	mov    %edx,%ecx
  80013a:	89 d3                	mov    %edx,%ebx
  80013c:	89 d7                	mov    %edx,%edi
  80013e:	89 d6                	mov    %edx,%esi
  800140:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800142:	5b                   	pop    %ebx
  800143:	5e                   	pop    %esi
  800144:	5f                   	pop    %edi
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    

00800147 <sys_yield>:

void
sys_yield(void)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	57                   	push   %edi
  80014b:	56                   	push   %esi
  80014c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014d:	ba 00 00 00 00       	mov    $0x0,%edx
  800152:	b8 0b 00 00 00       	mov    $0xb,%eax
  800157:	89 d1                	mov    %edx,%ecx
  800159:	89 d3                	mov    %edx,%ebx
  80015b:	89 d7                	mov    %edx,%edi
  80015d:	89 d6                	mov    %edx,%esi
  80015f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800161:	5b                   	pop    %ebx
  800162:	5e                   	pop    %esi
  800163:	5f                   	pop    %edi
  800164:	5d                   	pop    %ebp
  800165:	c3                   	ret    

00800166 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800166:	55                   	push   %ebp
  800167:	89 e5                	mov    %esp,%ebp
  800169:	57                   	push   %edi
  80016a:	56                   	push   %esi
  80016b:	53                   	push   %ebx
  80016c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80016f:	be 00 00 00 00       	mov    $0x0,%esi
  800174:	8b 55 08             	mov    0x8(%ebp),%edx
  800177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80017a:	b8 04 00 00 00       	mov    $0x4,%eax
  80017f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800182:	89 f7                	mov    %esi,%edi
  800184:	cd 30                	int    $0x30
	if(check && ret > 0)
  800186:	85 c0                	test   %eax,%eax
  800188:	7f 08                	jg     800192 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80018a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80018d:	5b                   	pop    %ebx
  80018e:	5e                   	pop    %esi
  80018f:	5f                   	pop    %edi
  800190:	5d                   	pop    %ebp
  800191:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	6a 04                	push   $0x4
  800198:	68 8a 22 80 00       	push   $0x80228a
  80019d:	6a 23                	push   $0x23
  80019f:	68 a7 22 80 00       	push   $0x8022a7
  8001a4:	e8 30 13 00 00       	call   8014d9 <_panic>

008001a9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a9:	55                   	push   %ebp
  8001aa:	89 e5                	mov    %esp,%ebp
  8001ac:	57                   	push   %edi
  8001ad:	56                   	push   %esi
  8001ae:	53                   	push   %ebx
  8001af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b8:	b8 05 00 00 00       	mov    $0x5,%eax
  8001bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c3:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c8:	85 c0                	test   %eax,%eax
  8001ca:	7f 08                	jg     8001d4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cf:	5b                   	pop    %ebx
  8001d0:	5e                   	pop    %esi
  8001d1:	5f                   	pop    %edi
  8001d2:	5d                   	pop    %ebp
  8001d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	50                   	push   %eax
  8001d8:	6a 05                	push   $0x5
  8001da:	68 8a 22 80 00       	push   $0x80228a
  8001df:	6a 23                	push   $0x23
  8001e1:	68 a7 22 80 00       	push   $0x8022a7
  8001e6:	e8 ee 12 00 00       	call   8014d9 <_panic>

008001eb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	57                   	push   %edi
  8001ef:	56                   	push   %esi
  8001f0:	53                   	push   %ebx
  8001f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ff:	b8 06 00 00 00       	mov    $0x6,%eax
  800204:	89 df                	mov    %ebx,%edi
  800206:	89 de                	mov    %ebx,%esi
  800208:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020a:	85 c0                	test   %eax,%eax
  80020c:	7f 08                	jg     800216 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80020e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800211:	5b                   	pop    %ebx
  800212:	5e                   	pop    %esi
  800213:	5f                   	pop    %edi
  800214:	5d                   	pop    %ebp
  800215:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	50                   	push   %eax
  80021a:	6a 06                	push   $0x6
  80021c:	68 8a 22 80 00       	push   $0x80228a
  800221:	6a 23                	push   $0x23
  800223:	68 a7 22 80 00       	push   $0x8022a7
  800228:	e8 ac 12 00 00       	call   8014d9 <_panic>

0080022d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	57                   	push   %edi
  800231:	56                   	push   %esi
  800232:	53                   	push   %ebx
  800233:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800236:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023b:	8b 55 08             	mov    0x8(%ebp),%edx
  80023e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800241:	b8 08 00 00 00       	mov    $0x8,%eax
  800246:	89 df                	mov    %ebx,%edi
  800248:	89 de                	mov    %ebx,%esi
  80024a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80024c:	85 c0                	test   %eax,%eax
  80024e:	7f 08                	jg     800258 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800253:	5b                   	pop    %ebx
  800254:	5e                   	pop    %esi
  800255:	5f                   	pop    %edi
  800256:	5d                   	pop    %ebp
  800257:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	50                   	push   %eax
  80025c:	6a 08                	push   $0x8
  80025e:	68 8a 22 80 00       	push   $0x80228a
  800263:	6a 23                	push   $0x23
  800265:	68 a7 22 80 00       	push   $0x8022a7
  80026a:	e8 6a 12 00 00       	call   8014d9 <_panic>

0080026f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	57                   	push   %edi
  800273:	56                   	push   %esi
  800274:	53                   	push   %ebx
  800275:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800278:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027d:	8b 55 08             	mov    0x8(%ebp),%edx
  800280:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800283:	b8 09 00 00 00       	mov    $0x9,%eax
  800288:	89 df                	mov    %ebx,%edi
  80028a:	89 de                	mov    %ebx,%esi
  80028c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80028e:	85 c0                	test   %eax,%eax
  800290:	7f 08                	jg     80029a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800292:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800295:	5b                   	pop    %ebx
  800296:	5e                   	pop    %esi
  800297:	5f                   	pop    %edi
  800298:	5d                   	pop    %ebp
  800299:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	50                   	push   %eax
  80029e:	6a 09                	push   $0x9
  8002a0:	68 8a 22 80 00       	push   $0x80228a
  8002a5:	6a 23                	push   $0x23
  8002a7:	68 a7 22 80 00       	push   $0x8022a7
  8002ac:	e8 28 12 00 00       	call   8014d9 <_panic>

008002b1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ca:	89 df                	mov    %ebx,%edi
  8002cc:	89 de                	mov    %ebx,%esi
  8002ce:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d0:	85 c0                	test   %eax,%eax
  8002d2:	7f 08                	jg     8002dc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d7:	5b                   	pop    %ebx
  8002d8:	5e                   	pop    %esi
  8002d9:	5f                   	pop    %edi
  8002da:	5d                   	pop    %ebp
  8002db:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	50                   	push   %eax
  8002e0:	6a 0a                	push   $0xa
  8002e2:	68 8a 22 80 00       	push   $0x80228a
  8002e7:	6a 23                	push   $0x23
  8002e9:	68 a7 22 80 00       	push   $0x8022a7
  8002ee:	e8 e6 11 00 00       	call   8014d9 <_panic>

008002f3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	57                   	push   %edi
  8002f7:	56                   	push   %esi
  8002f8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ff:	b8 0c 00 00 00       	mov    $0xc,%eax
  800304:	be 00 00 00 00       	mov    $0x0,%esi
  800309:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80030c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80030f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800311:	5b                   	pop    %ebx
  800312:	5e                   	pop    %esi
  800313:	5f                   	pop    %edi
  800314:	5d                   	pop    %ebp
  800315:	c3                   	ret    

00800316 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	57                   	push   %edi
  80031a:	56                   	push   %esi
  80031b:	53                   	push   %ebx
  80031c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80031f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800324:	8b 55 08             	mov    0x8(%ebp),%edx
  800327:	b8 0d 00 00 00       	mov    $0xd,%eax
  80032c:	89 cb                	mov    %ecx,%ebx
  80032e:	89 cf                	mov    %ecx,%edi
  800330:	89 ce                	mov    %ecx,%esi
  800332:	cd 30                	int    $0x30
	if(check && ret > 0)
  800334:	85 c0                	test   %eax,%eax
  800336:	7f 08                	jg     800340 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800338:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033b:	5b                   	pop    %ebx
  80033c:	5e                   	pop    %esi
  80033d:	5f                   	pop    %edi
  80033e:	5d                   	pop    %ebp
  80033f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	50                   	push   %eax
  800344:	6a 0d                	push   $0xd
  800346:	68 8a 22 80 00       	push   $0x80228a
  80034b:	6a 23                	push   $0x23
  80034d:	68 a7 22 80 00       	push   $0x8022a7
  800352:	e8 82 11 00 00       	call   8014d9 <_panic>

00800357 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	57                   	push   %edi
  80035b:	56                   	push   %esi
  80035c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80035d:	ba 00 00 00 00       	mov    $0x0,%edx
  800362:	b8 0e 00 00 00       	mov    $0xe,%eax
  800367:	89 d1                	mov    %edx,%ecx
  800369:	89 d3                	mov    %edx,%ebx
  80036b:	89 d7                	mov    %edx,%edi
  80036d:	89 d6                	mov    %edx,%esi
  80036f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800371:	5b                   	pop    %ebx
  800372:	5e                   	pop    %esi
  800373:	5f                   	pop    %edi
  800374:	5d                   	pop    %ebp
  800375:	c3                   	ret    

00800376 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	05 00 00 00 30       	add    $0x30000000,%eax
  800381:	c1 e8 0c             	shr    $0xc,%eax
}
  800384:	5d                   	pop    %ebp
  800385:	c3                   	ret    

00800386 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800391:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800396:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80039b:	5d                   	pop    %ebp
  80039c:	c3                   	ret    

0080039d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003a5:	89 c2                	mov    %eax,%edx
  8003a7:	c1 ea 16             	shr    $0x16,%edx
  8003aa:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003b1:	f6 c2 01             	test   $0x1,%dl
  8003b4:	74 2d                	je     8003e3 <fd_alloc+0x46>
  8003b6:	89 c2                	mov    %eax,%edx
  8003b8:	c1 ea 0c             	shr    $0xc,%edx
  8003bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003c2:	f6 c2 01             	test   $0x1,%dl
  8003c5:	74 1c                	je     8003e3 <fd_alloc+0x46>
  8003c7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003cc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003d1:	75 d2                	jne    8003a5 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8003dc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003e1:	eb 0a                	jmp    8003ed <fd_alloc+0x50>
			*fd_store = fd;
  8003e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003ed:	5d                   	pop    %ebp
  8003ee:	c3                   	ret    

008003ef <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003f5:	83 f8 1f             	cmp    $0x1f,%eax
  8003f8:	77 30                	ja     80042a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003fa:	c1 e0 0c             	shl    $0xc,%eax
  8003fd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800402:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800408:	f6 c2 01             	test   $0x1,%dl
  80040b:	74 24                	je     800431 <fd_lookup+0x42>
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	c1 ea 0c             	shr    $0xc,%edx
  800412:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800419:	f6 c2 01             	test   $0x1,%dl
  80041c:	74 1a                	je     800438 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80041e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800421:	89 02                	mov    %eax,(%edx)
	return 0;
  800423:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800428:	5d                   	pop    %ebp
  800429:	c3                   	ret    
		return -E_INVAL;
  80042a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80042f:	eb f7                	jmp    800428 <fd_lookup+0x39>
		return -E_INVAL;
  800431:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800436:	eb f0                	jmp    800428 <fd_lookup+0x39>
  800438:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80043d:	eb e9                	jmp    800428 <fd_lookup+0x39>

0080043f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80043f:	55                   	push   %ebp
  800440:	89 e5                	mov    %esp,%ebp
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800448:	ba 00 00 00 00       	mov    $0x0,%edx
  80044d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800452:	39 08                	cmp    %ecx,(%eax)
  800454:	74 38                	je     80048e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800456:	83 c2 01             	add    $0x1,%edx
  800459:	8b 04 95 34 23 80 00 	mov    0x802334(,%edx,4),%eax
  800460:	85 c0                	test   %eax,%eax
  800462:	75 ee                	jne    800452 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800464:	a1 08 40 80 00       	mov    0x804008,%eax
  800469:	8b 40 48             	mov    0x48(%eax),%eax
  80046c:	83 ec 04             	sub    $0x4,%esp
  80046f:	51                   	push   %ecx
  800470:	50                   	push   %eax
  800471:	68 b8 22 80 00       	push   $0x8022b8
  800476:	e8 39 11 00 00       	call   8015b4 <cprintf>
	*dev = 0;
  80047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80048c:	c9                   	leave  
  80048d:	c3                   	ret    
			*dev = devtab[i];
  80048e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800491:	89 01                	mov    %eax,(%ecx)
			return 0;
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	eb f2                	jmp    80048c <dev_lookup+0x4d>

0080049a <fd_close>:
{
  80049a:	55                   	push   %ebp
  80049b:	89 e5                	mov    %esp,%ebp
  80049d:	57                   	push   %edi
  80049e:	56                   	push   %esi
  80049f:	53                   	push   %ebx
  8004a0:	83 ec 24             	sub    $0x24,%esp
  8004a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004ac:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004ad:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004b3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004b6:	50                   	push   %eax
  8004b7:	e8 33 ff ff ff       	call   8003ef <fd_lookup>
  8004bc:	89 c3                	mov    %eax,%ebx
  8004be:	83 c4 10             	add    $0x10,%esp
  8004c1:	85 c0                	test   %eax,%eax
  8004c3:	78 05                	js     8004ca <fd_close+0x30>
	    || fd != fd2)
  8004c5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004c8:	74 16                	je     8004e0 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004ca:	89 f8                	mov    %edi,%eax
  8004cc:	84 c0                	test   %al,%al
  8004ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d3:	0f 44 d8             	cmove  %eax,%ebx
}
  8004d6:	89 d8                	mov    %ebx,%eax
  8004d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004db:	5b                   	pop    %ebx
  8004dc:	5e                   	pop    %esi
  8004dd:	5f                   	pop    %edi
  8004de:	5d                   	pop    %ebp
  8004df:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004e6:	50                   	push   %eax
  8004e7:	ff 36                	pushl  (%esi)
  8004e9:	e8 51 ff ff ff       	call   80043f <dev_lookup>
  8004ee:	89 c3                	mov    %eax,%ebx
  8004f0:	83 c4 10             	add    $0x10,%esp
  8004f3:	85 c0                	test   %eax,%eax
  8004f5:	78 1a                	js     800511 <fd_close+0x77>
		if (dev->dev_close)
  8004f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004fa:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8004fd:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800502:	85 c0                	test   %eax,%eax
  800504:	74 0b                	je     800511 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800506:	83 ec 0c             	sub    $0xc,%esp
  800509:	56                   	push   %esi
  80050a:	ff d0                	call   *%eax
  80050c:	89 c3                	mov    %eax,%ebx
  80050e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800511:	83 ec 08             	sub    $0x8,%esp
  800514:	56                   	push   %esi
  800515:	6a 00                	push   $0x0
  800517:	e8 cf fc ff ff       	call   8001eb <sys_page_unmap>
	return r;
  80051c:	83 c4 10             	add    $0x10,%esp
  80051f:	eb b5                	jmp    8004d6 <fd_close+0x3c>

00800521 <close>:

int
close(int fdnum)
{
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
  800524:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800527:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80052a:	50                   	push   %eax
  80052b:	ff 75 08             	pushl  0x8(%ebp)
  80052e:	e8 bc fe ff ff       	call   8003ef <fd_lookup>
  800533:	83 c4 10             	add    $0x10,%esp
  800536:	85 c0                	test   %eax,%eax
  800538:	79 02                	jns    80053c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    
		return fd_close(fd, 1);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	6a 01                	push   $0x1
  800541:	ff 75 f4             	pushl  -0xc(%ebp)
  800544:	e8 51 ff ff ff       	call   80049a <fd_close>
  800549:	83 c4 10             	add    $0x10,%esp
  80054c:	eb ec                	jmp    80053a <close+0x19>

0080054e <close_all>:

void
close_all(void)
{
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	53                   	push   %ebx
  800552:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800555:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80055a:	83 ec 0c             	sub    $0xc,%esp
  80055d:	53                   	push   %ebx
  80055e:	e8 be ff ff ff       	call   800521 <close>
	for (i = 0; i < MAXFD; i++)
  800563:	83 c3 01             	add    $0x1,%ebx
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	83 fb 20             	cmp    $0x20,%ebx
  80056c:	75 ec                	jne    80055a <close_all+0xc>
}
  80056e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800571:	c9                   	leave  
  800572:	c3                   	ret    

00800573 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800573:	55                   	push   %ebp
  800574:	89 e5                	mov    %esp,%ebp
  800576:	57                   	push   %edi
  800577:	56                   	push   %esi
  800578:	53                   	push   %ebx
  800579:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80057c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80057f:	50                   	push   %eax
  800580:	ff 75 08             	pushl  0x8(%ebp)
  800583:	e8 67 fe ff ff       	call   8003ef <fd_lookup>
  800588:	89 c3                	mov    %eax,%ebx
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	85 c0                	test   %eax,%eax
  80058f:	0f 88 81 00 00 00    	js     800616 <dup+0xa3>
		return r;
	close(newfdnum);
  800595:	83 ec 0c             	sub    $0xc,%esp
  800598:	ff 75 0c             	pushl  0xc(%ebp)
  80059b:	e8 81 ff ff ff       	call   800521 <close>

	newfd = INDEX2FD(newfdnum);
  8005a0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005a3:	c1 e6 0c             	shl    $0xc,%esi
  8005a6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005ac:	83 c4 04             	add    $0x4,%esp
  8005af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005b2:	e8 cf fd ff ff       	call   800386 <fd2data>
  8005b7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005b9:	89 34 24             	mov    %esi,(%esp)
  8005bc:	e8 c5 fd ff ff       	call   800386 <fd2data>
  8005c1:	83 c4 10             	add    $0x10,%esp
  8005c4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005c6:	89 d8                	mov    %ebx,%eax
  8005c8:	c1 e8 16             	shr    $0x16,%eax
  8005cb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005d2:	a8 01                	test   $0x1,%al
  8005d4:	74 11                	je     8005e7 <dup+0x74>
  8005d6:	89 d8                	mov    %ebx,%eax
  8005d8:	c1 e8 0c             	shr    $0xc,%eax
  8005db:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005e2:	f6 c2 01             	test   $0x1,%dl
  8005e5:	75 39                	jne    800620 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ea:	89 d0                	mov    %edx,%eax
  8005ec:	c1 e8 0c             	shr    $0xc,%eax
  8005ef:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005f6:	83 ec 0c             	sub    $0xc,%esp
  8005f9:	25 07 0e 00 00       	and    $0xe07,%eax
  8005fe:	50                   	push   %eax
  8005ff:	56                   	push   %esi
  800600:	6a 00                	push   $0x0
  800602:	52                   	push   %edx
  800603:	6a 00                	push   $0x0
  800605:	e8 9f fb ff ff       	call   8001a9 <sys_page_map>
  80060a:	89 c3                	mov    %eax,%ebx
  80060c:	83 c4 20             	add    $0x20,%esp
  80060f:	85 c0                	test   %eax,%eax
  800611:	78 31                	js     800644 <dup+0xd1>
		goto err;

	return newfdnum;
  800613:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800616:	89 d8                	mov    %ebx,%eax
  800618:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80061b:	5b                   	pop    %ebx
  80061c:	5e                   	pop    %esi
  80061d:	5f                   	pop    %edi
  80061e:	5d                   	pop    %ebp
  80061f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800620:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800627:	83 ec 0c             	sub    $0xc,%esp
  80062a:	25 07 0e 00 00       	and    $0xe07,%eax
  80062f:	50                   	push   %eax
  800630:	57                   	push   %edi
  800631:	6a 00                	push   $0x0
  800633:	53                   	push   %ebx
  800634:	6a 00                	push   $0x0
  800636:	e8 6e fb ff ff       	call   8001a9 <sys_page_map>
  80063b:	89 c3                	mov    %eax,%ebx
  80063d:	83 c4 20             	add    $0x20,%esp
  800640:	85 c0                	test   %eax,%eax
  800642:	79 a3                	jns    8005e7 <dup+0x74>
	sys_page_unmap(0, newfd);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	56                   	push   %esi
  800648:	6a 00                	push   $0x0
  80064a:	e8 9c fb ff ff       	call   8001eb <sys_page_unmap>
	sys_page_unmap(0, nva);
  80064f:	83 c4 08             	add    $0x8,%esp
  800652:	57                   	push   %edi
  800653:	6a 00                	push   $0x0
  800655:	e8 91 fb ff ff       	call   8001eb <sys_page_unmap>
	return r;
  80065a:	83 c4 10             	add    $0x10,%esp
  80065d:	eb b7                	jmp    800616 <dup+0xa3>

0080065f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	53                   	push   %ebx
  800663:	83 ec 1c             	sub    $0x1c,%esp
  800666:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800669:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80066c:	50                   	push   %eax
  80066d:	53                   	push   %ebx
  80066e:	e8 7c fd ff ff       	call   8003ef <fd_lookup>
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	85 c0                	test   %eax,%eax
  800678:	78 3f                	js     8006b9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80067a:	83 ec 08             	sub    $0x8,%esp
  80067d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800680:	50                   	push   %eax
  800681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800684:	ff 30                	pushl  (%eax)
  800686:	e8 b4 fd ff ff       	call   80043f <dev_lookup>
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	85 c0                	test   %eax,%eax
  800690:	78 27                	js     8006b9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800692:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800695:	8b 42 08             	mov    0x8(%edx),%eax
  800698:	83 e0 03             	and    $0x3,%eax
  80069b:	83 f8 01             	cmp    $0x1,%eax
  80069e:	74 1e                	je     8006be <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8b 40 08             	mov    0x8(%eax),%eax
  8006a6:	85 c0                	test   %eax,%eax
  8006a8:	74 35                	je     8006df <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	ff 75 10             	pushl  0x10(%ebp)
  8006b0:	ff 75 0c             	pushl  0xc(%ebp)
  8006b3:	52                   	push   %edx
  8006b4:	ff d0                	call   *%eax
  8006b6:	83 c4 10             	add    $0x10,%esp
}
  8006b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006bc:	c9                   	leave  
  8006bd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006be:	a1 08 40 80 00       	mov    0x804008,%eax
  8006c3:	8b 40 48             	mov    0x48(%eax),%eax
  8006c6:	83 ec 04             	sub    $0x4,%esp
  8006c9:	53                   	push   %ebx
  8006ca:	50                   	push   %eax
  8006cb:	68 f9 22 80 00       	push   $0x8022f9
  8006d0:	e8 df 0e 00 00       	call   8015b4 <cprintf>
		return -E_INVAL;
  8006d5:	83 c4 10             	add    $0x10,%esp
  8006d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006dd:	eb da                	jmp    8006b9 <read+0x5a>
		return -E_NOT_SUPP;
  8006df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006e4:	eb d3                	jmp    8006b9 <read+0x5a>

008006e6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006e6:	55                   	push   %ebp
  8006e7:	89 e5                	mov    %esp,%ebp
  8006e9:	57                   	push   %edi
  8006ea:	56                   	push   %esi
  8006eb:	53                   	push   %ebx
  8006ec:	83 ec 0c             	sub    $0xc,%esp
  8006ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006f2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006fa:	39 f3                	cmp    %esi,%ebx
  8006fc:	73 23                	jae    800721 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	89 f0                	mov    %esi,%eax
  800703:	29 d8                	sub    %ebx,%eax
  800705:	50                   	push   %eax
  800706:	89 d8                	mov    %ebx,%eax
  800708:	03 45 0c             	add    0xc(%ebp),%eax
  80070b:	50                   	push   %eax
  80070c:	57                   	push   %edi
  80070d:	e8 4d ff ff ff       	call   80065f <read>
		if (m < 0)
  800712:	83 c4 10             	add    $0x10,%esp
  800715:	85 c0                	test   %eax,%eax
  800717:	78 06                	js     80071f <readn+0x39>
			return m;
		if (m == 0)
  800719:	74 06                	je     800721 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80071b:	01 c3                	add    %eax,%ebx
  80071d:	eb db                	jmp    8006fa <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80071f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800721:	89 d8                	mov    %ebx,%eax
  800723:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800726:	5b                   	pop    %ebx
  800727:	5e                   	pop    %esi
  800728:	5f                   	pop    %edi
  800729:	5d                   	pop    %ebp
  80072a:	c3                   	ret    

0080072b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	53                   	push   %ebx
  80072f:	83 ec 1c             	sub    $0x1c,%esp
  800732:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800735:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800738:	50                   	push   %eax
  800739:	53                   	push   %ebx
  80073a:	e8 b0 fc ff ff       	call   8003ef <fd_lookup>
  80073f:	83 c4 10             	add    $0x10,%esp
  800742:	85 c0                	test   %eax,%eax
  800744:	78 3a                	js     800780 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80074c:	50                   	push   %eax
  80074d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800750:	ff 30                	pushl  (%eax)
  800752:	e8 e8 fc ff ff       	call   80043f <dev_lookup>
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	85 c0                	test   %eax,%eax
  80075c:	78 22                	js     800780 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80075e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800761:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800765:	74 1e                	je     800785 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800767:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076a:	8b 52 0c             	mov    0xc(%edx),%edx
  80076d:	85 d2                	test   %edx,%edx
  80076f:	74 35                	je     8007a6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800771:	83 ec 04             	sub    $0x4,%esp
  800774:	ff 75 10             	pushl  0x10(%ebp)
  800777:	ff 75 0c             	pushl  0xc(%ebp)
  80077a:	50                   	push   %eax
  80077b:	ff d2                	call   *%edx
  80077d:	83 c4 10             	add    $0x10,%esp
}
  800780:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800783:	c9                   	leave  
  800784:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800785:	a1 08 40 80 00       	mov    0x804008,%eax
  80078a:	8b 40 48             	mov    0x48(%eax),%eax
  80078d:	83 ec 04             	sub    $0x4,%esp
  800790:	53                   	push   %ebx
  800791:	50                   	push   %eax
  800792:	68 15 23 80 00       	push   $0x802315
  800797:	e8 18 0e 00 00       	call   8015b4 <cprintf>
		return -E_INVAL;
  80079c:	83 c4 10             	add    $0x10,%esp
  80079f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a4:	eb da                	jmp    800780 <write+0x55>
		return -E_NOT_SUPP;
  8007a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007ab:	eb d3                	jmp    800780 <write+0x55>

008007ad <seek>:

int
seek(int fdnum, off_t offset)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007b6:	50                   	push   %eax
  8007b7:	ff 75 08             	pushl  0x8(%ebp)
  8007ba:	e8 30 fc ff ff       	call   8003ef <fd_lookup>
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	78 0e                	js     8007d4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007cc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007d4:	c9                   	leave  
  8007d5:	c3                   	ret    

008007d6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	53                   	push   %ebx
  8007da:	83 ec 1c             	sub    $0x1c,%esp
  8007dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007e3:	50                   	push   %eax
  8007e4:	53                   	push   %ebx
  8007e5:	e8 05 fc ff ff       	call   8003ef <fd_lookup>
  8007ea:	83 c4 10             	add    $0x10,%esp
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	78 37                	js     800828 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007f7:	50                   	push   %eax
  8007f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fb:	ff 30                	pushl  (%eax)
  8007fd:	e8 3d fc ff ff       	call   80043f <dev_lookup>
  800802:	83 c4 10             	add    $0x10,%esp
  800805:	85 c0                	test   %eax,%eax
  800807:	78 1f                	js     800828 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800810:	74 1b                	je     80082d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800812:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800815:	8b 52 18             	mov    0x18(%edx),%edx
  800818:	85 d2                	test   %edx,%edx
  80081a:	74 32                	je     80084e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	50                   	push   %eax
  800823:	ff d2                	call   *%edx
  800825:	83 c4 10             	add    $0x10,%esp
}
  800828:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082b:	c9                   	leave  
  80082c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80082d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800832:	8b 40 48             	mov    0x48(%eax),%eax
  800835:	83 ec 04             	sub    $0x4,%esp
  800838:	53                   	push   %ebx
  800839:	50                   	push   %eax
  80083a:	68 d8 22 80 00       	push   $0x8022d8
  80083f:	e8 70 0d 00 00       	call   8015b4 <cprintf>
		return -E_INVAL;
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80084c:	eb da                	jmp    800828 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80084e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800853:	eb d3                	jmp    800828 <ftruncate+0x52>

00800855 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	53                   	push   %ebx
  800859:	83 ec 1c             	sub    $0x1c,%esp
  80085c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80085f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800862:	50                   	push   %eax
  800863:	ff 75 08             	pushl  0x8(%ebp)
  800866:	e8 84 fb ff ff       	call   8003ef <fd_lookup>
  80086b:	83 c4 10             	add    $0x10,%esp
  80086e:	85 c0                	test   %eax,%eax
  800870:	78 4b                	js     8008bd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800878:	50                   	push   %eax
  800879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087c:	ff 30                	pushl  (%eax)
  80087e:	e8 bc fb ff ff       	call   80043f <dev_lookup>
  800883:	83 c4 10             	add    $0x10,%esp
  800886:	85 c0                	test   %eax,%eax
  800888:	78 33                	js     8008bd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80088a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800891:	74 2f                	je     8008c2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800893:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800896:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80089d:	00 00 00 
	stat->st_isdir = 0;
  8008a0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008a7:	00 00 00 
	stat->st_dev = dev;
  8008aa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008b0:	83 ec 08             	sub    $0x8,%esp
  8008b3:	53                   	push   %ebx
  8008b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8008b7:	ff 50 14             	call   *0x14(%eax)
  8008ba:	83 c4 10             	add    $0x10,%esp
}
  8008bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c0:	c9                   	leave  
  8008c1:	c3                   	ret    
		return -E_NOT_SUPP;
  8008c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008c7:	eb f4                	jmp    8008bd <fstat+0x68>

008008c9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	56                   	push   %esi
  8008cd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	6a 00                	push   $0x0
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	e8 2f 02 00 00       	call   800b0a <open>
  8008db:	89 c3                	mov    %eax,%ebx
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	85 c0                	test   %eax,%eax
  8008e2:	78 1b                	js     8008ff <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ea:	50                   	push   %eax
  8008eb:	e8 65 ff ff ff       	call   800855 <fstat>
  8008f0:	89 c6                	mov    %eax,%esi
	close(fd);
  8008f2:	89 1c 24             	mov    %ebx,(%esp)
  8008f5:	e8 27 fc ff ff       	call   800521 <close>
	return r;
  8008fa:	83 c4 10             	add    $0x10,%esp
  8008fd:	89 f3                	mov    %esi,%ebx
}
  8008ff:	89 d8                	mov    %ebx,%eax
  800901:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800904:	5b                   	pop    %ebx
  800905:	5e                   	pop    %esi
  800906:	5d                   	pop    %ebp
  800907:	c3                   	ret    

00800908 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	56                   	push   %esi
  80090c:	53                   	push   %ebx
  80090d:	89 c6                	mov    %eax,%esi
  80090f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800911:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800918:	74 27                	je     800941 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80091a:	6a 07                	push   $0x7
  80091c:	68 00 50 80 00       	push   $0x805000
  800921:	56                   	push   %esi
  800922:	ff 35 00 40 80 00    	pushl  0x804000
  800928:	e8 0c 16 00 00       	call   801f39 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80092d:	83 c4 0c             	add    $0xc,%esp
  800930:	6a 00                	push   $0x0
  800932:	53                   	push   %ebx
  800933:	6a 00                	push   $0x0
  800935:	e8 8c 15 00 00       	call   801ec6 <ipc_recv>
}
  80093a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80093d:	5b                   	pop    %ebx
  80093e:	5e                   	pop    %esi
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800941:	83 ec 0c             	sub    $0xc,%esp
  800944:	6a 01                	push   $0x1
  800946:	e8 5a 16 00 00       	call   801fa5 <ipc_find_env>
  80094b:	a3 00 40 80 00       	mov    %eax,0x804000
  800950:	83 c4 10             	add    $0x10,%esp
  800953:	eb c5                	jmp    80091a <fsipc+0x12>

00800955 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 40 0c             	mov    0xc(%eax),%eax
  800961:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80096e:	ba 00 00 00 00       	mov    $0x0,%edx
  800973:	b8 02 00 00 00       	mov    $0x2,%eax
  800978:	e8 8b ff ff ff       	call   800908 <fsipc>
}
  80097d:	c9                   	leave  
  80097e:	c3                   	ret    

0080097f <devfile_flush>:
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8b 40 0c             	mov    0xc(%eax),%eax
  80098b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800990:	ba 00 00 00 00       	mov    $0x0,%edx
  800995:	b8 06 00 00 00       	mov    $0x6,%eax
  80099a:	e8 69 ff ff ff       	call   800908 <fsipc>
}
  80099f:	c9                   	leave  
  8009a0:	c3                   	ret    

008009a1 <devfile_stat>:
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	53                   	push   %ebx
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8009b1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bb:	b8 05 00 00 00       	mov    $0x5,%eax
  8009c0:	e8 43 ff ff ff       	call   800908 <fsipc>
  8009c5:	85 c0                	test   %eax,%eax
  8009c7:	78 2c                	js     8009f5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009c9:	83 ec 08             	sub    $0x8,%esp
  8009cc:	68 00 50 80 00       	push   $0x805000
  8009d1:	53                   	push   %ebx
  8009d2:	e8 b9 11 00 00       	call   801b90 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009d7:	a1 80 50 80 00       	mov    0x805080,%eax
  8009dc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009e2:	a1 84 50 80 00       	mov    0x805084,%eax
  8009e7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009ed:	83 c4 10             	add    $0x10,%esp
  8009f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f8:	c9                   	leave  
  8009f9:	c3                   	ret    

008009fa <devfile_write>:
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	53                   	push   %ebx
  8009fe:	83 ec 04             	sub    $0x4,%esp
  800a01:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  800a04:	85 db                	test   %ebx,%ebx
  800a06:	75 07                	jne    800a0f <devfile_write+0x15>
	return n_all;
  800a08:	89 d8                	mov    %ebx,%eax
}
  800a0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a0d:	c9                   	leave  
  800a0e:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8b 40 0c             	mov    0xc(%eax),%eax
  800a15:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  800a1a:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  800a20:	83 ec 04             	sub    $0x4,%esp
  800a23:	53                   	push   %ebx
  800a24:	ff 75 0c             	pushl  0xc(%ebp)
  800a27:	68 08 50 80 00       	push   $0x805008
  800a2c:	e8 ed 12 00 00       	call   801d1e <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a31:	ba 00 00 00 00       	mov    $0x0,%edx
  800a36:	b8 04 00 00 00       	mov    $0x4,%eax
  800a3b:	e8 c8 fe ff ff       	call   800908 <fsipc>
  800a40:	83 c4 10             	add    $0x10,%esp
  800a43:	85 c0                	test   %eax,%eax
  800a45:	78 c3                	js     800a0a <devfile_write+0x10>
	  assert(r <= n_left);
  800a47:	39 d8                	cmp    %ebx,%eax
  800a49:	77 0b                	ja     800a56 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  800a4b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a50:	7f 1d                	jg     800a6f <devfile_write+0x75>
    n_all += r;
  800a52:	89 c3                	mov    %eax,%ebx
  800a54:	eb b2                	jmp    800a08 <devfile_write+0xe>
	  assert(r <= n_left);
  800a56:	68 48 23 80 00       	push   $0x802348
  800a5b:	68 54 23 80 00       	push   $0x802354
  800a60:	68 9f 00 00 00       	push   $0x9f
  800a65:	68 69 23 80 00       	push   $0x802369
  800a6a:	e8 6a 0a 00 00       	call   8014d9 <_panic>
	  assert(r <= PGSIZE);
  800a6f:	68 74 23 80 00       	push   $0x802374
  800a74:	68 54 23 80 00       	push   $0x802354
  800a79:	68 a0 00 00 00       	push   $0xa0
  800a7e:	68 69 23 80 00       	push   $0x802369
  800a83:	e8 51 0a 00 00       	call   8014d9 <_panic>

00800a88 <devfile_read>:
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	56                   	push   %esi
  800a8c:	53                   	push   %ebx
  800a8d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8b 40 0c             	mov    0xc(%eax),%eax
  800a96:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a9b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800aa1:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa6:	b8 03 00 00 00       	mov    $0x3,%eax
  800aab:	e8 58 fe ff ff       	call   800908 <fsipc>
  800ab0:	89 c3                	mov    %eax,%ebx
  800ab2:	85 c0                	test   %eax,%eax
  800ab4:	78 1f                	js     800ad5 <devfile_read+0x4d>
	assert(r <= n);
  800ab6:	39 f0                	cmp    %esi,%eax
  800ab8:	77 24                	ja     800ade <devfile_read+0x56>
	assert(r <= PGSIZE);
  800aba:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800abf:	7f 33                	jg     800af4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ac1:	83 ec 04             	sub    $0x4,%esp
  800ac4:	50                   	push   %eax
  800ac5:	68 00 50 80 00       	push   $0x805000
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	e8 4c 12 00 00       	call   801d1e <memmove>
	return r;
  800ad2:	83 c4 10             	add    $0x10,%esp
}
  800ad5:	89 d8                	mov    %ebx,%eax
  800ad7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ada:	5b                   	pop    %ebx
  800adb:	5e                   	pop    %esi
  800adc:	5d                   	pop    %ebp
  800add:	c3                   	ret    
	assert(r <= n);
  800ade:	68 80 23 80 00       	push   $0x802380
  800ae3:	68 54 23 80 00       	push   $0x802354
  800ae8:	6a 7c                	push   $0x7c
  800aea:	68 69 23 80 00       	push   $0x802369
  800aef:	e8 e5 09 00 00       	call   8014d9 <_panic>
	assert(r <= PGSIZE);
  800af4:	68 74 23 80 00       	push   $0x802374
  800af9:	68 54 23 80 00       	push   $0x802354
  800afe:	6a 7d                	push   $0x7d
  800b00:	68 69 23 80 00       	push   $0x802369
  800b05:	e8 cf 09 00 00       	call   8014d9 <_panic>

00800b0a <open>:
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	56                   	push   %esi
  800b0e:	53                   	push   %ebx
  800b0f:	83 ec 1c             	sub    $0x1c,%esp
  800b12:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b15:	56                   	push   %esi
  800b16:	e8 3c 10 00 00       	call   801b57 <strlen>
  800b1b:	83 c4 10             	add    $0x10,%esp
  800b1e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b23:	7f 6c                	jg     800b91 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b25:	83 ec 0c             	sub    $0xc,%esp
  800b28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b2b:	50                   	push   %eax
  800b2c:	e8 6c f8 ff ff       	call   80039d <fd_alloc>
  800b31:	89 c3                	mov    %eax,%ebx
  800b33:	83 c4 10             	add    $0x10,%esp
  800b36:	85 c0                	test   %eax,%eax
  800b38:	78 3c                	js     800b76 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b3a:	83 ec 08             	sub    $0x8,%esp
  800b3d:	56                   	push   %esi
  800b3e:	68 00 50 80 00       	push   $0x805000
  800b43:	e8 48 10 00 00       	call   801b90 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b53:	b8 01 00 00 00       	mov    $0x1,%eax
  800b58:	e8 ab fd ff ff       	call   800908 <fsipc>
  800b5d:	89 c3                	mov    %eax,%ebx
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	85 c0                	test   %eax,%eax
  800b64:	78 19                	js     800b7f <open+0x75>
	return fd2num(fd);
  800b66:	83 ec 0c             	sub    $0xc,%esp
  800b69:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6c:	e8 05 f8 ff ff       	call   800376 <fd2num>
  800b71:	89 c3                	mov    %eax,%ebx
  800b73:	83 c4 10             	add    $0x10,%esp
}
  800b76:	89 d8                	mov    %ebx,%eax
  800b78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b7b:	5b                   	pop    %ebx
  800b7c:	5e                   	pop    %esi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    
		fd_close(fd, 0);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	6a 00                	push   $0x0
  800b84:	ff 75 f4             	pushl  -0xc(%ebp)
  800b87:	e8 0e f9 ff ff       	call   80049a <fd_close>
		return r;
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	eb e5                	jmp    800b76 <open+0x6c>
		return -E_BAD_PATH;
  800b91:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b96:	eb de                	jmp    800b76 <open+0x6c>

00800b98 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba3:	b8 08 00 00 00       	mov    $0x8,%eax
  800ba8:	e8 5b fd ff ff       	call   800908 <fsipc>
}
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
  800bb4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bb7:	83 ec 0c             	sub    $0xc,%esp
  800bba:	ff 75 08             	pushl  0x8(%ebp)
  800bbd:	e8 c4 f7 ff ff       	call   800386 <fd2data>
  800bc2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bc4:	83 c4 08             	add    $0x8,%esp
  800bc7:	68 87 23 80 00       	push   $0x802387
  800bcc:	53                   	push   %ebx
  800bcd:	e8 be 0f 00 00       	call   801b90 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bd2:	8b 46 04             	mov    0x4(%esi),%eax
  800bd5:	2b 06                	sub    (%esi),%eax
  800bd7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bdd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800be4:	00 00 00 
	stat->st_dev = &devpipe;
  800be7:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bee:	30 80 00 
	return 0;
}
  800bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf9:	5b                   	pop    %ebx
  800bfa:	5e                   	pop    %esi
  800bfb:	5d                   	pop    %ebp
  800bfc:	c3                   	ret    

00800bfd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	53                   	push   %ebx
  800c01:	83 ec 0c             	sub    $0xc,%esp
  800c04:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c07:	53                   	push   %ebx
  800c08:	6a 00                	push   $0x0
  800c0a:	e8 dc f5 ff ff       	call   8001eb <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c0f:	89 1c 24             	mov    %ebx,(%esp)
  800c12:	e8 6f f7 ff ff       	call   800386 <fd2data>
  800c17:	83 c4 08             	add    $0x8,%esp
  800c1a:	50                   	push   %eax
  800c1b:	6a 00                	push   $0x0
  800c1d:	e8 c9 f5 ff ff       	call   8001eb <sys_page_unmap>
}
  800c22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <_pipeisclosed>:
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	57                   	push   %edi
  800c2b:	56                   	push   %esi
  800c2c:	53                   	push   %ebx
  800c2d:	83 ec 1c             	sub    $0x1c,%esp
  800c30:	89 c7                	mov    %eax,%edi
  800c32:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c34:	a1 08 40 80 00       	mov    0x804008,%eax
  800c39:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c3c:	83 ec 0c             	sub    $0xc,%esp
  800c3f:	57                   	push   %edi
  800c40:	e8 99 13 00 00       	call   801fde <pageref>
  800c45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c48:	89 34 24             	mov    %esi,(%esp)
  800c4b:	e8 8e 13 00 00       	call   801fde <pageref>
		nn = thisenv->env_runs;
  800c50:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c56:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c59:	83 c4 10             	add    $0x10,%esp
  800c5c:	39 cb                	cmp    %ecx,%ebx
  800c5e:	74 1b                	je     800c7b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c60:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c63:	75 cf                	jne    800c34 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c65:	8b 42 58             	mov    0x58(%edx),%eax
  800c68:	6a 01                	push   $0x1
  800c6a:	50                   	push   %eax
  800c6b:	53                   	push   %ebx
  800c6c:	68 8e 23 80 00       	push   $0x80238e
  800c71:	e8 3e 09 00 00       	call   8015b4 <cprintf>
  800c76:	83 c4 10             	add    $0x10,%esp
  800c79:	eb b9                	jmp    800c34 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c7b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c7e:	0f 94 c0             	sete   %al
  800c81:	0f b6 c0             	movzbl %al,%eax
}
  800c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <devpipe_write>:
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
  800c92:	83 ec 28             	sub    $0x28,%esp
  800c95:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c98:	56                   	push   %esi
  800c99:	e8 e8 f6 ff ff       	call   800386 <fd2data>
  800c9e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800ca0:	83 c4 10             	add    $0x10,%esp
  800ca3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ca8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800cab:	74 4f                	je     800cfc <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800cad:	8b 43 04             	mov    0x4(%ebx),%eax
  800cb0:	8b 0b                	mov    (%ebx),%ecx
  800cb2:	8d 51 20             	lea    0x20(%ecx),%edx
  800cb5:	39 d0                	cmp    %edx,%eax
  800cb7:	72 14                	jb     800ccd <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800cb9:	89 da                	mov    %ebx,%edx
  800cbb:	89 f0                	mov    %esi,%eax
  800cbd:	e8 65 ff ff ff       	call   800c27 <_pipeisclosed>
  800cc2:	85 c0                	test   %eax,%eax
  800cc4:	75 3b                	jne    800d01 <devpipe_write+0x75>
			sys_yield();
  800cc6:	e8 7c f4 ff ff       	call   800147 <sys_yield>
  800ccb:	eb e0                	jmp    800cad <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800ccd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cd4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cd7:	89 c2                	mov    %eax,%edx
  800cd9:	c1 fa 1f             	sar    $0x1f,%edx
  800cdc:	89 d1                	mov    %edx,%ecx
  800cde:	c1 e9 1b             	shr    $0x1b,%ecx
  800ce1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800ce4:	83 e2 1f             	and    $0x1f,%edx
  800ce7:	29 ca                	sub    %ecx,%edx
  800ce9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800ced:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cf1:	83 c0 01             	add    $0x1,%eax
  800cf4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800cf7:	83 c7 01             	add    $0x1,%edi
  800cfa:	eb ac                	jmp    800ca8 <devpipe_write+0x1c>
	return i;
  800cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cff:	eb 05                	jmp    800d06 <devpipe_write+0x7a>
				return 0;
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <devpipe_read>:
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
  800d14:	83 ec 18             	sub    $0x18,%esp
  800d17:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d1a:	57                   	push   %edi
  800d1b:	e8 66 f6 ff ff       	call   800386 <fd2data>
  800d20:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d22:	83 c4 10             	add    $0x10,%esp
  800d25:	be 00 00 00 00       	mov    $0x0,%esi
  800d2a:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d2d:	75 14                	jne    800d43 <devpipe_read+0x35>
	return i;
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	eb 02                	jmp    800d36 <devpipe_read+0x28>
				return i;
  800d34:	89 f0                	mov    %esi,%eax
}
  800d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5f                   	pop    %edi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    
			sys_yield();
  800d3e:	e8 04 f4 ff ff       	call   800147 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d43:	8b 03                	mov    (%ebx),%eax
  800d45:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d48:	75 18                	jne    800d62 <devpipe_read+0x54>
			if (i > 0)
  800d4a:	85 f6                	test   %esi,%esi
  800d4c:	75 e6                	jne    800d34 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  800d4e:	89 da                	mov    %ebx,%edx
  800d50:	89 f8                	mov    %edi,%eax
  800d52:	e8 d0 fe ff ff       	call   800c27 <_pipeisclosed>
  800d57:	85 c0                	test   %eax,%eax
  800d59:	74 e3                	je     800d3e <devpipe_read+0x30>
				return 0;
  800d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d60:	eb d4                	jmp    800d36 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d62:	99                   	cltd   
  800d63:	c1 ea 1b             	shr    $0x1b,%edx
  800d66:	01 d0                	add    %edx,%eax
  800d68:	83 e0 1f             	and    $0x1f,%eax
  800d6b:	29 d0                	sub    %edx,%eax
  800d6d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d75:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d78:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d7b:	83 c6 01             	add    $0x1,%esi
  800d7e:	eb aa                	jmp    800d2a <devpipe_read+0x1c>

00800d80 <pipe>:
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	56                   	push   %esi
  800d84:	53                   	push   %ebx
  800d85:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d8b:	50                   	push   %eax
  800d8c:	e8 0c f6 ff ff       	call   80039d <fd_alloc>
  800d91:	89 c3                	mov    %eax,%ebx
  800d93:	83 c4 10             	add    $0x10,%esp
  800d96:	85 c0                	test   %eax,%eax
  800d98:	0f 88 23 01 00 00    	js     800ec1 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d9e:	83 ec 04             	sub    $0x4,%esp
  800da1:	68 07 04 00 00       	push   $0x407
  800da6:	ff 75 f4             	pushl  -0xc(%ebp)
  800da9:	6a 00                	push   $0x0
  800dab:	e8 b6 f3 ff ff       	call   800166 <sys_page_alloc>
  800db0:	89 c3                	mov    %eax,%ebx
  800db2:	83 c4 10             	add    $0x10,%esp
  800db5:	85 c0                	test   %eax,%eax
  800db7:	0f 88 04 01 00 00    	js     800ec1 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  800dbd:	83 ec 0c             	sub    $0xc,%esp
  800dc0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dc3:	50                   	push   %eax
  800dc4:	e8 d4 f5 ff ff       	call   80039d <fd_alloc>
  800dc9:	89 c3                	mov    %eax,%ebx
  800dcb:	83 c4 10             	add    $0x10,%esp
  800dce:	85 c0                	test   %eax,%eax
  800dd0:	0f 88 db 00 00 00    	js     800eb1 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dd6:	83 ec 04             	sub    $0x4,%esp
  800dd9:	68 07 04 00 00       	push   $0x407
  800dde:	ff 75 f0             	pushl  -0x10(%ebp)
  800de1:	6a 00                	push   $0x0
  800de3:	e8 7e f3 ff ff       	call   800166 <sys_page_alloc>
  800de8:	89 c3                	mov    %eax,%ebx
  800dea:	83 c4 10             	add    $0x10,%esp
  800ded:	85 c0                	test   %eax,%eax
  800def:	0f 88 bc 00 00 00    	js     800eb1 <pipe+0x131>
	va = fd2data(fd0);
  800df5:	83 ec 0c             	sub    $0xc,%esp
  800df8:	ff 75 f4             	pushl  -0xc(%ebp)
  800dfb:	e8 86 f5 ff ff       	call   800386 <fd2data>
  800e00:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e02:	83 c4 0c             	add    $0xc,%esp
  800e05:	68 07 04 00 00       	push   $0x407
  800e0a:	50                   	push   %eax
  800e0b:	6a 00                	push   $0x0
  800e0d:	e8 54 f3 ff ff       	call   800166 <sys_page_alloc>
  800e12:	89 c3                	mov    %eax,%ebx
  800e14:	83 c4 10             	add    $0x10,%esp
  800e17:	85 c0                	test   %eax,%eax
  800e19:	0f 88 82 00 00 00    	js     800ea1 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e1f:	83 ec 0c             	sub    $0xc,%esp
  800e22:	ff 75 f0             	pushl  -0x10(%ebp)
  800e25:	e8 5c f5 ff ff       	call   800386 <fd2data>
  800e2a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e31:	50                   	push   %eax
  800e32:	6a 00                	push   $0x0
  800e34:	56                   	push   %esi
  800e35:	6a 00                	push   $0x0
  800e37:	e8 6d f3 ff ff       	call   8001a9 <sys_page_map>
  800e3c:	89 c3                	mov    %eax,%ebx
  800e3e:	83 c4 20             	add    $0x20,%esp
  800e41:	85 c0                	test   %eax,%eax
  800e43:	78 4e                	js     800e93 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  800e45:	a1 20 30 80 00       	mov    0x803020,%eax
  800e4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e5c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e61:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e68:	83 ec 0c             	sub    $0xc,%esp
  800e6b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e6e:	e8 03 f5 ff ff       	call   800376 <fd2num>
  800e73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e76:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e78:	83 c4 04             	add    $0x4,%esp
  800e7b:	ff 75 f0             	pushl  -0x10(%ebp)
  800e7e:	e8 f3 f4 ff ff       	call   800376 <fd2num>
  800e83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e86:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e89:	83 c4 10             	add    $0x10,%esp
  800e8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e91:	eb 2e                	jmp    800ec1 <pipe+0x141>
	sys_page_unmap(0, va);
  800e93:	83 ec 08             	sub    $0x8,%esp
  800e96:	56                   	push   %esi
  800e97:	6a 00                	push   $0x0
  800e99:	e8 4d f3 ff ff       	call   8001eb <sys_page_unmap>
  800e9e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea7:	6a 00                	push   $0x0
  800ea9:	e8 3d f3 ff ff       	call   8001eb <sys_page_unmap>
  800eae:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800eb1:	83 ec 08             	sub    $0x8,%esp
  800eb4:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb7:	6a 00                	push   $0x0
  800eb9:	e8 2d f3 ff ff       	call   8001eb <sys_page_unmap>
  800ebe:	83 c4 10             	add    $0x10,%esp
}
  800ec1:	89 d8                	mov    %ebx,%eax
  800ec3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    

00800eca <pipeisclosed>:
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ed0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ed3:	50                   	push   %eax
  800ed4:	ff 75 08             	pushl  0x8(%ebp)
  800ed7:	e8 13 f5 ff ff       	call   8003ef <fd_lookup>
  800edc:	83 c4 10             	add    $0x10,%esp
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	78 18                	js     800efb <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ee3:	83 ec 0c             	sub    $0xc,%esp
  800ee6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee9:	e8 98 f4 ff ff       	call   800386 <fd2data>
	return _pipeisclosed(fd, p);
  800eee:	89 c2                	mov    %eax,%edx
  800ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef3:	e8 2f fd ff ff       	call   800c27 <_pipeisclosed>
  800ef8:	83 c4 10             	add    $0x10,%esp
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800f03:	68 a6 23 80 00       	push   $0x8023a6
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	e8 80 0c 00 00       	call   801b90 <strcpy>
	return 0;
}
  800f10:	b8 00 00 00 00       	mov    $0x0,%eax
  800f15:	c9                   	leave  
  800f16:	c3                   	ret    

00800f17 <devsock_close>:
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	53                   	push   %ebx
  800f1b:	83 ec 10             	sub    $0x10,%esp
  800f1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f21:	53                   	push   %ebx
  800f22:	e8 b7 10 00 00       	call   801fde <pageref>
  800f27:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f2a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f2f:	83 f8 01             	cmp    $0x1,%eax
  800f32:	74 07                	je     800f3b <devsock_close+0x24>
}
  800f34:	89 d0                	mov    %edx,%eax
  800f36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f3b:	83 ec 0c             	sub    $0xc,%esp
  800f3e:	ff 73 0c             	pushl  0xc(%ebx)
  800f41:	e8 b9 02 00 00       	call   8011ff <nsipc_close>
  800f46:	89 c2                	mov    %eax,%edx
  800f48:	83 c4 10             	add    $0x10,%esp
  800f4b:	eb e7                	jmp    800f34 <devsock_close+0x1d>

00800f4d <devsock_write>:
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f53:	6a 00                	push   $0x0
  800f55:	ff 75 10             	pushl  0x10(%ebp)
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	ff 70 0c             	pushl  0xc(%eax)
  800f61:	e8 76 03 00 00       	call   8012dc <nsipc_send>
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <devsock_read>:
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f6e:	6a 00                	push   $0x0
  800f70:	ff 75 10             	pushl  0x10(%ebp)
  800f73:	ff 75 0c             	pushl  0xc(%ebp)
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	ff 70 0c             	pushl  0xc(%eax)
  800f7c:	e8 ef 02 00 00       	call   801270 <nsipc_recv>
}
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    

00800f83 <fd2sockid>:
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f89:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f8c:	52                   	push   %edx
  800f8d:	50                   	push   %eax
  800f8e:	e8 5c f4 ff ff       	call   8003ef <fd_lookup>
  800f93:	83 c4 10             	add    $0x10,%esp
  800f96:	85 c0                	test   %eax,%eax
  800f98:	78 10                	js     800faa <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f9d:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800fa3:	39 08                	cmp    %ecx,(%eax)
  800fa5:	75 05                	jne    800fac <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800fa7:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800faa:	c9                   	leave  
  800fab:	c3                   	ret    
		return -E_NOT_SUPP;
  800fac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800fb1:	eb f7                	jmp    800faa <fd2sockid+0x27>

00800fb3 <alloc_sockfd>:
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	56                   	push   %esi
  800fb7:	53                   	push   %ebx
  800fb8:	83 ec 1c             	sub    $0x1c,%esp
  800fbb:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fbd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fc0:	50                   	push   %eax
  800fc1:	e8 d7 f3 ff ff       	call   80039d <fd_alloc>
  800fc6:	89 c3                	mov    %eax,%ebx
  800fc8:	83 c4 10             	add    $0x10,%esp
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	78 43                	js     801012 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fcf:	83 ec 04             	sub    $0x4,%esp
  800fd2:	68 07 04 00 00       	push   $0x407
  800fd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800fda:	6a 00                	push   $0x0
  800fdc:	e8 85 f1 ff ff       	call   800166 <sys_page_alloc>
  800fe1:	89 c3                	mov    %eax,%ebx
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	78 28                	js     801012 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fed:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800ff3:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800fff:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801002:	83 ec 0c             	sub    $0xc,%esp
  801005:	50                   	push   %eax
  801006:	e8 6b f3 ff ff       	call   800376 <fd2num>
  80100b:	89 c3                	mov    %eax,%ebx
  80100d:	83 c4 10             	add    $0x10,%esp
  801010:	eb 0c                	jmp    80101e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801012:	83 ec 0c             	sub    $0xc,%esp
  801015:	56                   	push   %esi
  801016:	e8 e4 01 00 00       	call   8011ff <nsipc_close>
		return r;
  80101b:	83 c4 10             	add    $0x10,%esp
}
  80101e:	89 d8                	mov    %ebx,%eax
  801020:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801023:	5b                   	pop    %ebx
  801024:	5e                   	pop    %esi
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <accept>:
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	e8 4e ff ff ff       	call   800f83 <fd2sockid>
  801035:	85 c0                	test   %eax,%eax
  801037:	78 1b                	js     801054 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801039:	83 ec 04             	sub    $0x4,%esp
  80103c:	ff 75 10             	pushl  0x10(%ebp)
  80103f:	ff 75 0c             	pushl  0xc(%ebp)
  801042:	50                   	push   %eax
  801043:	e8 0e 01 00 00       	call   801156 <nsipc_accept>
  801048:	83 c4 10             	add    $0x10,%esp
  80104b:	85 c0                	test   %eax,%eax
  80104d:	78 05                	js     801054 <accept+0x2d>
	return alloc_sockfd(r);
  80104f:	e8 5f ff ff ff       	call   800fb3 <alloc_sockfd>
}
  801054:	c9                   	leave  
  801055:	c3                   	ret    

00801056 <bind>:
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	e8 1f ff ff ff       	call   800f83 <fd2sockid>
  801064:	85 c0                	test   %eax,%eax
  801066:	78 12                	js     80107a <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801068:	83 ec 04             	sub    $0x4,%esp
  80106b:	ff 75 10             	pushl  0x10(%ebp)
  80106e:	ff 75 0c             	pushl  0xc(%ebp)
  801071:	50                   	push   %eax
  801072:	e8 31 01 00 00       	call   8011a8 <nsipc_bind>
  801077:	83 c4 10             	add    $0x10,%esp
}
  80107a:	c9                   	leave  
  80107b:	c3                   	ret    

0080107c <shutdown>:
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	e8 f9 fe ff ff       	call   800f83 <fd2sockid>
  80108a:	85 c0                	test   %eax,%eax
  80108c:	78 0f                	js     80109d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80108e:	83 ec 08             	sub    $0x8,%esp
  801091:	ff 75 0c             	pushl  0xc(%ebp)
  801094:	50                   	push   %eax
  801095:	e8 43 01 00 00       	call   8011dd <nsipc_shutdown>
  80109a:	83 c4 10             	add    $0x10,%esp
}
  80109d:	c9                   	leave  
  80109e:	c3                   	ret    

0080109f <connect>:
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	e8 d6 fe ff ff       	call   800f83 <fd2sockid>
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	78 12                	js     8010c3 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8010b1:	83 ec 04             	sub    $0x4,%esp
  8010b4:	ff 75 10             	pushl  0x10(%ebp)
  8010b7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ba:	50                   	push   %eax
  8010bb:	e8 59 01 00 00       	call   801219 <nsipc_connect>
  8010c0:	83 c4 10             	add    $0x10,%esp
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <listen>:
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	e8 b0 fe ff ff       	call   800f83 <fd2sockid>
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	78 0f                	js     8010e6 <listen+0x21>
	return nsipc_listen(r, backlog);
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	ff 75 0c             	pushl  0xc(%ebp)
  8010dd:	50                   	push   %eax
  8010de:	e8 6b 01 00 00       	call   80124e <nsipc_listen>
  8010e3:	83 c4 10             	add    $0x10,%esp
}
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    

008010e8 <socket>:

int
socket(int domain, int type, int protocol)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010ee:	ff 75 10             	pushl  0x10(%ebp)
  8010f1:	ff 75 0c             	pushl  0xc(%ebp)
  8010f4:	ff 75 08             	pushl  0x8(%ebp)
  8010f7:	e8 3e 02 00 00       	call   80133a <nsipc_socket>
  8010fc:	83 c4 10             	add    $0x10,%esp
  8010ff:	85 c0                	test   %eax,%eax
  801101:	78 05                	js     801108 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801103:	e8 ab fe ff ff       	call   800fb3 <alloc_sockfd>
}
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	53                   	push   %ebx
  80110e:	83 ec 04             	sub    $0x4,%esp
  801111:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801113:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80111a:	74 26                	je     801142 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80111c:	6a 07                	push   $0x7
  80111e:	68 00 60 80 00       	push   $0x806000
  801123:	53                   	push   %ebx
  801124:	ff 35 04 40 80 00    	pushl  0x804004
  80112a:	e8 0a 0e 00 00       	call   801f39 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80112f:	83 c4 0c             	add    $0xc,%esp
  801132:	6a 00                	push   $0x0
  801134:	6a 00                	push   $0x0
  801136:	6a 00                	push   $0x0
  801138:	e8 89 0d 00 00       	call   801ec6 <ipc_recv>
}
  80113d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801140:	c9                   	leave  
  801141:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	6a 02                	push   $0x2
  801147:	e8 59 0e 00 00       	call   801fa5 <ipc_find_env>
  80114c:	a3 04 40 80 00       	mov    %eax,0x804004
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	eb c6                	jmp    80111c <nsipc+0x12>

00801156 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	56                   	push   %esi
  80115a:	53                   	push   %ebx
  80115b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801166:	8b 06                	mov    (%esi),%eax
  801168:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80116d:	b8 01 00 00 00       	mov    $0x1,%eax
  801172:	e8 93 ff ff ff       	call   80110a <nsipc>
  801177:	89 c3                	mov    %eax,%ebx
  801179:	85 c0                	test   %eax,%eax
  80117b:	79 09                	jns    801186 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80117d:	89 d8                	mov    %ebx,%eax
  80117f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801182:	5b                   	pop    %ebx
  801183:	5e                   	pop    %esi
  801184:	5d                   	pop    %ebp
  801185:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801186:	83 ec 04             	sub    $0x4,%esp
  801189:	ff 35 10 60 80 00    	pushl  0x806010
  80118f:	68 00 60 80 00       	push   $0x806000
  801194:	ff 75 0c             	pushl  0xc(%ebp)
  801197:	e8 82 0b 00 00       	call   801d1e <memmove>
		*addrlen = ret->ret_addrlen;
  80119c:	a1 10 60 80 00       	mov    0x806010,%eax
  8011a1:	89 06                	mov    %eax,(%esi)
  8011a3:	83 c4 10             	add    $0x10,%esp
	return r;
  8011a6:	eb d5                	jmp    80117d <nsipc_accept+0x27>

008011a8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	53                   	push   %ebx
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011ba:	53                   	push   %ebx
  8011bb:	ff 75 0c             	pushl  0xc(%ebp)
  8011be:	68 04 60 80 00       	push   $0x806004
  8011c3:	e8 56 0b 00 00       	call   801d1e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011c8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8011d3:	e8 32 ff ff ff       	call   80110a <nsipc>
}
  8011d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ee:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011f3:	b8 03 00 00 00       	mov    $0x3,%eax
  8011f8:	e8 0d ff ff ff       	call   80110a <nsipc>
}
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <nsipc_close>:

int
nsipc_close(int s)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80120d:	b8 04 00 00 00       	mov    $0x4,%eax
  801212:	e8 f3 fe ff ff       	call   80110a <nsipc>
}
  801217:	c9                   	leave  
  801218:	c3                   	ret    

00801219 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	53                   	push   %ebx
  80121d:	83 ec 08             	sub    $0x8,%esp
  801220:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80122b:	53                   	push   %ebx
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	68 04 60 80 00       	push   $0x806004
  801234:	e8 e5 0a 00 00       	call   801d1e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801239:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80123f:	b8 05 00 00 00       	mov    $0x5,%eax
  801244:	e8 c1 fe ff ff       	call   80110a <nsipc>
}
  801249:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801264:	b8 06 00 00 00       	mov    $0x6,%eax
  801269:	e8 9c fe ff ff       	call   80110a <nsipc>
}
  80126e:	c9                   	leave  
  80126f:	c3                   	ret    

00801270 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
  801273:	56                   	push   %esi
  801274:	53                   	push   %ebx
  801275:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801280:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801286:	8b 45 14             	mov    0x14(%ebp),%eax
  801289:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80128e:	b8 07 00 00 00       	mov    $0x7,%eax
  801293:	e8 72 fe ff ff       	call   80110a <nsipc>
  801298:	89 c3                	mov    %eax,%ebx
  80129a:	85 c0                	test   %eax,%eax
  80129c:	78 1f                	js     8012bd <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80129e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8012a3:	7f 21                	jg     8012c6 <nsipc_recv+0x56>
  8012a5:	39 c6                	cmp    %eax,%esi
  8012a7:	7c 1d                	jl     8012c6 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8012a9:	83 ec 04             	sub    $0x4,%esp
  8012ac:	50                   	push   %eax
  8012ad:	68 00 60 80 00       	push   $0x806000
  8012b2:	ff 75 0c             	pushl  0xc(%ebp)
  8012b5:	e8 64 0a 00 00       	call   801d1e <memmove>
  8012ba:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012bd:	89 d8                	mov    %ebx,%eax
  8012bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012c2:	5b                   	pop    %ebx
  8012c3:	5e                   	pop    %esi
  8012c4:	5d                   	pop    %ebp
  8012c5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012c6:	68 b2 23 80 00       	push   $0x8023b2
  8012cb:	68 54 23 80 00       	push   $0x802354
  8012d0:	6a 62                	push   $0x62
  8012d2:	68 c7 23 80 00       	push   $0x8023c7
  8012d7:	e8 fd 01 00 00       	call   8014d9 <_panic>

008012dc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	53                   	push   %ebx
  8012e0:	83 ec 04             	sub    $0x4,%esp
  8012e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012ee:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012f4:	7f 2e                	jg     801324 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012f6:	83 ec 04             	sub    $0x4,%esp
  8012f9:	53                   	push   %ebx
  8012fa:	ff 75 0c             	pushl  0xc(%ebp)
  8012fd:	68 0c 60 80 00       	push   $0x80600c
  801302:	e8 17 0a 00 00       	call   801d1e <memmove>
	nsipcbuf.send.req_size = size;
  801307:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80130d:	8b 45 14             	mov    0x14(%ebp),%eax
  801310:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801315:	b8 08 00 00 00       	mov    $0x8,%eax
  80131a:	e8 eb fd ff ff       	call   80110a <nsipc>
}
  80131f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801322:	c9                   	leave  
  801323:	c3                   	ret    
	assert(size < 1600);
  801324:	68 d3 23 80 00       	push   $0x8023d3
  801329:	68 54 23 80 00       	push   $0x802354
  80132e:	6a 6d                	push   $0x6d
  801330:	68 c7 23 80 00       	push   $0x8023c7
  801335:	e8 9f 01 00 00       	call   8014d9 <_panic>

0080133a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801350:	8b 45 10             	mov    0x10(%ebp),%eax
  801353:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801358:	b8 09 00 00 00       	mov    $0x9,%eax
  80135d:	e8 a8 fd ff ff       	call   80110a <nsipc>
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801364:	b8 00 00 00 00       	mov    $0x0,%eax
  801369:	c3                   	ret    

0080136a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801370:	68 df 23 80 00       	push   $0x8023df
  801375:	ff 75 0c             	pushl  0xc(%ebp)
  801378:	e8 13 08 00 00       	call   801b90 <strcpy>
	return 0;
}
  80137d:	b8 00 00 00 00       	mov    $0x0,%eax
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <devcons_write>:
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	57                   	push   %edi
  801388:	56                   	push   %esi
  801389:	53                   	push   %ebx
  80138a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801390:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801395:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80139b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80139e:	73 31                	jae    8013d1 <devcons_write+0x4d>
		m = n - tot;
  8013a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013a3:	29 f3                	sub    %esi,%ebx
  8013a5:	83 fb 7f             	cmp    $0x7f,%ebx
  8013a8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8013ad:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013b0:	83 ec 04             	sub    $0x4,%esp
  8013b3:	53                   	push   %ebx
  8013b4:	89 f0                	mov    %esi,%eax
  8013b6:	03 45 0c             	add    0xc(%ebp),%eax
  8013b9:	50                   	push   %eax
  8013ba:	57                   	push   %edi
  8013bb:	e8 5e 09 00 00       	call   801d1e <memmove>
		sys_cputs(buf, m);
  8013c0:	83 c4 08             	add    $0x8,%esp
  8013c3:	53                   	push   %ebx
  8013c4:	57                   	push   %edi
  8013c5:	e8 e0 ec ff ff       	call   8000aa <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013ca:	01 de                	add    %ebx,%esi
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	eb ca                	jmp    80139b <devcons_write+0x17>
}
  8013d1:	89 f0                	mov    %esi,%eax
  8013d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d6:	5b                   	pop    %ebx
  8013d7:	5e                   	pop    %esi
  8013d8:	5f                   	pop    %edi
  8013d9:	5d                   	pop    %ebp
  8013da:	c3                   	ret    

008013db <devcons_read>:
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	83 ec 08             	sub    $0x8,%esp
  8013e1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ea:	74 21                	je     80140d <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8013ec:	e8 d7 ec ff ff       	call   8000c8 <sys_cgetc>
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	75 07                	jne    8013fc <devcons_read+0x21>
		sys_yield();
  8013f5:	e8 4d ed ff ff       	call   800147 <sys_yield>
  8013fa:	eb f0                	jmp    8013ec <devcons_read+0x11>
	if (c < 0)
  8013fc:	78 0f                	js     80140d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8013fe:	83 f8 04             	cmp    $0x4,%eax
  801401:	74 0c                	je     80140f <devcons_read+0x34>
	*(char*)vbuf = c;
  801403:	8b 55 0c             	mov    0xc(%ebp),%edx
  801406:	88 02                	mov    %al,(%edx)
	return 1;
  801408:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    
		return 0;
  80140f:	b8 00 00 00 00       	mov    $0x0,%eax
  801414:	eb f7                	jmp    80140d <devcons_read+0x32>

00801416 <cputchar>:
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801422:	6a 01                	push   $0x1
  801424:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801427:	50                   	push   %eax
  801428:	e8 7d ec ff ff       	call   8000aa <sys_cputs>
}
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <getchar>:
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801438:	6a 01                	push   $0x1
  80143a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80143d:	50                   	push   %eax
  80143e:	6a 00                	push   $0x0
  801440:	e8 1a f2 ff ff       	call   80065f <read>
	if (r < 0)
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 06                	js     801452 <getchar+0x20>
	if (r < 1)
  80144c:	74 06                	je     801454 <getchar+0x22>
	return c;
  80144e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    
		return -E_EOF;
  801454:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801459:	eb f7                	jmp    801452 <getchar+0x20>

0080145b <iscons>:
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801461:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801464:	50                   	push   %eax
  801465:	ff 75 08             	pushl  0x8(%ebp)
  801468:	e8 82 ef ff ff       	call   8003ef <fd_lookup>
  80146d:	83 c4 10             	add    $0x10,%esp
  801470:	85 c0                	test   %eax,%eax
  801472:	78 11                	js     801485 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801477:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80147d:	39 10                	cmp    %edx,(%eax)
  80147f:	0f 94 c0             	sete   %al
  801482:	0f b6 c0             	movzbl %al,%eax
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <opencons>:
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80148d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801490:	50                   	push   %eax
  801491:	e8 07 ef ff ff       	call   80039d <fd_alloc>
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	85 c0                	test   %eax,%eax
  80149b:	78 3a                	js     8014d7 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80149d:	83 ec 04             	sub    $0x4,%esp
  8014a0:	68 07 04 00 00       	push   $0x407
  8014a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a8:	6a 00                	push   $0x0
  8014aa:	e8 b7 ec ff ff       	call   800166 <sys_page_alloc>
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	78 21                	js     8014d7 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014bf:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014cb:	83 ec 0c             	sub    $0xc,%esp
  8014ce:	50                   	push   %eax
  8014cf:	e8 a2 ee ff ff       	call   800376 <fd2num>
  8014d4:	83 c4 10             	add    $0x10,%esp
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	56                   	push   %esi
  8014dd:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014de:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014e1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014e7:	e8 3c ec ff ff       	call   800128 <sys_getenvid>
  8014ec:	83 ec 0c             	sub    $0xc,%esp
  8014ef:	ff 75 0c             	pushl  0xc(%ebp)
  8014f2:	ff 75 08             	pushl  0x8(%ebp)
  8014f5:	56                   	push   %esi
  8014f6:	50                   	push   %eax
  8014f7:	68 ec 23 80 00       	push   $0x8023ec
  8014fc:	e8 b3 00 00 00       	call   8015b4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801501:	83 c4 18             	add    $0x18,%esp
  801504:	53                   	push   %ebx
  801505:	ff 75 10             	pushl  0x10(%ebp)
  801508:	e8 56 00 00 00       	call   801563 <vcprintf>
	cprintf("\n");
  80150d:	c7 04 24 9f 23 80 00 	movl   $0x80239f,(%esp)
  801514:	e8 9b 00 00 00       	call   8015b4 <cprintf>
  801519:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80151c:	cc                   	int3   
  80151d:	eb fd                	jmp    80151c <_panic+0x43>

0080151f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	53                   	push   %ebx
  801523:	83 ec 04             	sub    $0x4,%esp
  801526:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801529:	8b 13                	mov    (%ebx),%edx
  80152b:	8d 42 01             	lea    0x1(%edx),%eax
  80152e:	89 03                	mov    %eax,(%ebx)
  801530:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801533:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801537:	3d ff 00 00 00       	cmp    $0xff,%eax
  80153c:	74 09                	je     801547 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80153e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801545:	c9                   	leave  
  801546:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	68 ff 00 00 00       	push   $0xff
  80154f:	8d 43 08             	lea    0x8(%ebx),%eax
  801552:	50                   	push   %eax
  801553:	e8 52 eb ff ff       	call   8000aa <sys_cputs>
		b->idx = 0;
  801558:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	eb db                	jmp    80153e <putch+0x1f>

00801563 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80156c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801573:	00 00 00 
	b.cnt = 0;
  801576:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80157d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801580:	ff 75 0c             	pushl  0xc(%ebp)
  801583:	ff 75 08             	pushl  0x8(%ebp)
  801586:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80158c:	50                   	push   %eax
  80158d:	68 1f 15 80 00       	push   $0x80151f
  801592:	e8 19 01 00 00       	call   8016b0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801597:	83 c4 08             	add    $0x8,%esp
  80159a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8015a0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8015a6:	50                   	push   %eax
  8015a7:	e8 fe ea ff ff       	call   8000aa <sys_cputs>

	return b.cnt;
}
  8015ac:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015ba:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015bd:	50                   	push   %eax
  8015be:	ff 75 08             	pushl  0x8(%ebp)
  8015c1:	e8 9d ff ff ff       	call   801563 <vcprintf>
	va_end(ap);

	return cnt;
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	57                   	push   %edi
  8015cc:	56                   	push   %esi
  8015cd:	53                   	push   %ebx
  8015ce:	83 ec 1c             	sub    $0x1c,%esp
  8015d1:	89 c7                	mov    %eax,%edi
  8015d3:	89 d6                	mov    %edx,%esi
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015de:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015ec:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015ef:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015f2:	89 d0                	mov    %edx,%eax
  8015f4:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8015f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015fa:	73 15                	jae    801611 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015fc:	83 eb 01             	sub    $0x1,%ebx
  8015ff:	85 db                	test   %ebx,%ebx
  801601:	7e 43                	jle    801646 <printnum+0x7e>
			putch(padc, putdat);
  801603:	83 ec 08             	sub    $0x8,%esp
  801606:	56                   	push   %esi
  801607:	ff 75 18             	pushl  0x18(%ebp)
  80160a:	ff d7                	call   *%edi
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	eb eb                	jmp    8015fc <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801611:	83 ec 0c             	sub    $0xc,%esp
  801614:	ff 75 18             	pushl  0x18(%ebp)
  801617:	8b 45 14             	mov    0x14(%ebp),%eax
  80161a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80161d:	53                   	push   %ebx
  80161e:	ff 75 10             	pushl  0x10(%ebp)
  801621:	83 ec 08             	sub    $0x8,%esp
  801624:	ff 75 e4             	pushl  -0x1c(%ebp)
  801627:	ff 75 e0             	pushl  -0x20(%ebp)
  80162a:	ff 75 dc             	pushl  -0x24(%ebp)
  80162d:	ff 75 d8             	pushl  -0x28(%ebp)
  801630:	e8 eb 09 00 00       	call   802020 <__udivdi3>
  801635:	83 c4 18             	add    $0x18,%esp
  801638:	52                   	push   %edx
  801639:	50                   	push   %eax
  80163a:	89 f2                	mov    %esi,%edx
  80163c:	89 f8                	mov    %edi,%eax
  80163e:	e8 85 ff ff ff       	call   8015c8 <printnum>
  801643:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801646:	83 ec 08             	sub    $0x8,%esp
  801649:	56                   	push   %esi
  80164a:	83 ec 04             	sub    $0x4,%esp
  80164d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801650:	ff 75 e0             	pushl  -0x20(%ebp)
  801653:	ff 75 dc             	pushl  -0x24(%ebp)
  801656:	ff 75 d8             	pushl  -0x28(%ebp)
  801659:	e8 d2 0a 00 00       	call   802130 <__umoddi3>
  80165e:	83 c4 14             	add    $0x14,%esp
  801661:	0f be 80 0f 24 80 00 	movsbl 0x80240f(%eax),%eax
  801668:	50                   	push   %eax
  801669:	ff d7                	call   *%edi
}
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801671:	5b                   	pop    %ebx
  801672:	5e                   	pop    %esi
  801673:	5f                   	pop    %edi
  801674:	5d                   	pop    %ebp
  801675:	c3                   	ret    

00801676 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80167c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801680:	8b 10                	mov    (%eax),%edx
  801682:	3b 50 04             	cmp    0x4(%eax),%edx
  801685:	73 0a                	jae    801691 <sprintputch+0x1b>
		*b->buf++ = ch;
  801687:	8d 4a 01             	lea    0x1(%edx),%ecx
  80168a:	89 08                	mov    %ecx,(%eax)
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	88 02                	mov    %al,(%edx)
}
  801691:	5d                   	pop    %ebp
  801692:	c3                   	ret    

00801693 <printfmt>:
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801699:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80169c:	50                   	push   %eax
  80169d:	ff 75 10             	pushl  0x10(%ebp)
  8016a0:	ff 75 0c             	pushl  0xc(%ebp)
  8016a3:	ff 75 08             	pushl  0x8(%ebp)
  8016a6:	e8 05 00 00 00       	call   8016b0 <vprintfmt>
}
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <vprintfmt>:
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	57                   	push   %edi
  8016b4:	56                   	push   %esi
  8016b5:	53                   	push   %ebx
  8016b6:	83 ec 3c             	sub    $0x3c,%esp
  8016b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8016bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016c2:	eb 0a                	jmp    8016ce <vprintfmt+0x1e>
			putch(ch, putdat);
  8016c4:	83 ec 08             	sub    $0x8,%esp
  8016c7:	53                   	push   %ebx
  8016c8:	50                   	push   %eax
  8016c9:	ff d6                	call   *%esi
  8016cb:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016ce:	83 c7 01             	add    $0x1,%edi
  8016d1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016d5:	83 f8 25             	cmp    $0x25,%eax
  8016d8:	74 0c                	je     8016e6 <vprintfmt+0x36>
			if (ch == '\0')
  8016da:	85 c0                	test   %eax,%eax
  8016dc:	75 e6                	jne    8016c4 <vprintfmt+0x14>
}
  8016de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e1:	5b                   	pop    %ebx
  8016e2:	5e                   	pop    %esi
  8016e3:	5f                   	pop    %edi
  8016e4:	5d                   	pop    %ebp
  8016e5:	c3                   	ret    
		padc = ' ';
  8016e6:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8016ea:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8016f1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8016f8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016ff:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801704:	8d 47 01             	lea    0x1(%edi),%eax
  801707:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80170a:	0f b6 17             	movzbl (%edi),%edx
  80170d:	8d 42 dd             	lea    -0x23(%edx),%eax
  801710:	3c 55                	cmp    $0x55,%al
  801712:	0f 87 ba 03 00 00    	ja     801ad2 <vprintfmt+0x422>
  801718:	0f b6 c0             	movzbl %al,%eax
  80171b:	ff 24 85 60 25 80 00 	jmp    *0x802560(,%eax,4)
  801722:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801725:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801729:	eb d9                	jmp    801704 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80172b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80172e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801732:	eb d0                	jmp    801704 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801734:	0f b6 d2             	movzbl %dl,%edx
  801737:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax
  80173f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801742:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801745:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801749:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80174c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80174f:	83 f9 09             	cmp    $0x9,%ecx
  801752:	77 55                	ja     8017a9 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  801754:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801757:	eb e9                	jmp    801742 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  801759:	8b 45 14             	mov    0x14(%ebp),%eax
  80175c:	8b 00                	mov    (%eax),%eax
  80175e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801761:	8b 45 14             	mov    0x14(%ebp),%eax
  801764:	8d 40 04             	lea    0x4(%eax),%eax
  801767:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80176a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80176d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801771:	79 91                	jns    801704 <vprintfmt+0x54>
				width = precision, precision = -1;
  801773:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801776:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801779:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801780:	eb 82                	jmp    801704 <vprintfmt+0x54>
  801782:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801785:	85 c0                	test   %eax,%eax
  801787:	ba 00 00 00 00       	mov    $0x0,%edx
  80178c:	0f 49 d0             	cmovns %eax,%edx
  80178f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801792:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801795:	e9 6a ff ff ff       	jmp    801704 <vprintfmt+0x54>
  80179a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80179d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8017a4:	e9 5b ff ff ff       	jmp    801704 <vprintfmt+0x54>
  8017a9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8017ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8017af:	eb bc                	jmp    80176d <vprintfmt+0xbd>
			lflag++;
  8017b1:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017b7:	e9 48 ff ff ff       	jmp    801704 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8017bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bf:	8d 78 04             	lea    0x4(%eax),%edi
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	53                   	push   %ebx
  8017c6:	ff 30                	pushl  (%eax)
  8017c8:	ff d6                	call   *%esi
			break;
  8017ca:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017cd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017d0:	e9 9c 02 00 00       	jmp    801a71 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8017d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8017d8:	8d 78 04             	lea    0x4(%eax),%edi
  8017db:	8b 00                	mov    (%eax),%eax
  8017dd:	99                   	cltd   
  8017de:	31 d0                	xor    %edx,%eax
  8017e0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017e2:	83 f8 0f             	cmp    $0xf,%eax
  8017e5:	7f 23                	jg     80180a <vprintfmt+0x15a>
  8017e7:	8b 14 85 c0 26 80 00 	mov    0x8026c0(,%eax,4),%edx
  8017ee:	85 d2                	test   %edx,%edx
  8017f0:	74 18                	je     80180a <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8017f2:	52                   	push   %edx
  8017f3:	68 66 23 80 00       	push   $0x802366
  8017f8:	53                   	push   %ebx
  8017f9:	56                   	push   %esi
  8017fa:	e8 94 fe ff ff       	call   801693 <printfmt>
  8017ff:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801802:	89 7d 14             	mov    %edi,0x14(%ebp)
  801805:	e9 67 02 00 00       	jmp    801a71 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  80180a:	50                   	push   %eax
  80180b:	68 27 24 80 00       	push   $0x802427
  801810:	53                   	push   %ebx
  801811:	56                   	push   %esi
  801812:	e8 7c fe ff ff       	call   801693 <printfmt>
  801817:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80181a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80181d:	e9 4f 02 00 00       	jmp    801a71 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  801822:	8b 45 14             	mov    0x14(%ebp),%eax
  801825:	83 c0 04             	add    $0x4,%eax
  801828:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80182b:	8b 45 14             	mov    0x14(%ebp),%eax
  80182e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801830:	85 d2                	test   %edx,%edx
  801832:	b8 20 24 80 00       	mov    $0x802420,%eax
  801837:	0f 45 c2             	cmovne %edx,%eax
  80183a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80183d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801841:	7e 06                	jle    801849 <vprintfmt+0x199>
  801843:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801847:	75 0d                	jne    801856 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801849:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80184c:	89 c7                	mov    %eax,%edi
  80184e:	03 45 e0             	add    -0x20(%ebp),%eax
  801851:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801854:	eb 3f                	jmp    801895 <vprintfmt+0x1e5>
  801856:	83 ec 08             	sub    $0x8,%esp
  801859:	ff 75 d8             	pushl  -0x28(%ebp)
  80185c:	50                   	push   %eax
  80185d:	e8 0d 03 00 00       	call   801b6f <strnlen>
  801862:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801865:	29 c2                	sub    %eax,%edx
  801867:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80186f:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801873:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801876:	85 ff                	test   %edi,%edi
  801878:	7e 58                	jle    8018d2 <vprintfmt+0x222>
					putch(padc, putdat);
  80187a:	83 ec 08             	sub    $0x8,%esp
  80187d:	53                   	push   %ebx
  80187e:	ff 75 e0             	pushl  -0x20(%ebp)
  801881:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801883:	83 ef 01             	sub    $0x1,%edi
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	eb eb                	jmp    801876 <vprintfmt+0x1c6>
					putch(ch, putdat);
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	53                   	push   %ebx
  80188f:	52                   	push   %edx
  801890:	ff d6                	call   *%esi
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801898:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80189a:	83 c7 01             	add    $0x1,%edi
  80189d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8018a1:	0f be d0             	movsbl %al,%edx
  8018a4:	85 d2                	test   %edx,%edx
  8018a6:	74 45                	je     8018ed <vprintfmt+0x23d>
  8018a8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018ac:	78 06                	js     8018b4 <vprintfmt+0x204>
  8018ae:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8018b2:	78 35                	js     8018e9 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8018b4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8018b8:	74 d1                	je     80188b <vprintfmt+0x1db>
  8018ba:	0f be c0             	movsbl %al,%eax
  8018bd:	83 e8 20             	sub    $0x20,%eax
  8018c0:	83 f8 5e             	cmp    $0x5e,%eax
  8018c3:	76 c6                	jbe    80188b <vprintfmt+0x1db>
					putch('?', putdat);
  8018c5:	83 ec 08             	sub    $0x8,%esp
  8018c8:	53                   	push   %ebx
  8018c9:	6a 3f                	push   $0x3f
  8018cb:	ff d6                	call   *%esi
  8018cd:	83 c4 10             	add    $0x10,%esp
  8018d0:	eb c3                	jmp    801895 <vprintfmt+0x1e5>
  8018d2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8018d5:	85 d2                	test   %edx,%edx
  8018d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018dc:	0f 49 c2             	cmovns %edx,%eax
  8018df:	29 c2                	sub    %eax,%edx
  8018e1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8018e4:	e9 60 ff ff ff       	jmp    801849 <vprintfmt+0x199>
  8018e9:	89 cf                	mov    %ecx,%edi
  8018eb:	eb 02                	jmp    8018ef <vprintfmt+0x23f>
  8018ed:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8018ef:	85 ff                	test   %edi,%edi
  8018f1:	7e 10                	jle    801903 <vprintfmt+0x253>
				putch(' ', putdat);
  8018f3:	83 ec 08             	sub    $0x8,%esp
  8018f6:	53                   	push   %ebx
  8018f7:	6a 20                	push   $0x20
  8018f9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018fb:	83 ef 01             	sub    $0x1,%edi
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	eb ec                	jmp    8018ef <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  801903:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801906:	89 45 14             	mov    %eax,0x14(%ebp)
  801909:	e9 63 01 00 00       	jmp    801a71 <vprintfmt+0x3c1>
	if (lflag >= 2)
  80190e:	83 f9 01             	cmp    $0x1,%ecx
  801911:	7f 1b                	jg     80192e <vprintfmt+0x27e>
	else if (lflag)
  801913:	85 c9                	test   %ecx,%ecx
  801915:	74 63                	je     80197a <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  801917:	8b 45 14             	mov    0x14(%ebp),%eax
  80191a:	8b 00                	mov    (%eax),%eax
  80191c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80191f:	99                   	cltd   
  801920:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801923:	8b 45 14             	mov    0x14(%ebp),%eax
  801926:	8d 40 04             	lea    0x4(%eax),%eax
  801929:	89 45 14             	mov    %eax,0x14(%ebp)
  80192c:	eb 17                	jmp    801945 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  80192e:	8b 45 14             	mov    0x14(%ebp),%eax
  801931:	8b 50 04             	mov    0x4(%eax),%edx
  801934:	8b 00                	mov    (%eax),%eax
  801936:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801939:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80193c:	8b 45 14             	mov    0x14(%ebp),%eax
  80193f:	8d 40 08             	lea    0x8(%eax),%eax
  801942:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801945:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801948:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80194b:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801950:	85 c9                	test   %ecx,%ecx
  801952:	0f 89 ff 00 00 00    	jns    801a57 <vprintfmt+0x3a7>
				putch('-', putdat);
  801958:	83 ec 08             	sub    $0x8,%esp
  80195b:	53                   	push   %ebx
  80195c:	6a 2d                	push   $0x2d
  80195e:	ff d6                	call   *%esi
				num = -(long long) num;
  801960:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801963:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801966:	f7 da                	neg    %edx
  801968:	83 d1 00             	adc    $0x0,%ecx
  80196b:	f7 d9                	neg    %ecx
  80196d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801970:	b8 0a 00 00 00       	mov    $0xa,%eax
  801975:	e9 dd 00 00 00       	jmp    801a57 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80197a:	8b 45 14             	mov    0x14(%ebp),%eax
  80197d:	8b 00                	mov    (%eax),%eax
  80197f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801982:	99                   	cltd   
  801983:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801986:	8b 45 14             	mov    0x14(%ebp),%eax
  801989:	8d 40 04             	lea    0x4(%eax),%eax
  80198c:	89 45 14             	mov    %eax,0x14(%ebp)
  80198f:	eb b4                	jmp    801945 <vprintfmt+0x295>
	if (lflag >= 2)
  801991:	83 f9 01             	cmp    $0x1,%ecx
  801994:	7f 1e                	jg     8019b4 <vprintfmt+0x304>
	else if (lflag)
  801996:	85 c9                	test   %ecx,%ecx
  801998:	74 32                	je     8019cc <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  80199a:	8b 45 14             	mov    0x14(%ebp),%eax
  80199d:	8b 10                	mov    (%eax),%edx
  80199f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a4:	8d 40 04             	lea    0x4(%eax),%eax
  8019a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019aa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019af:	e9 a3 00 00 00       	jmp    801a57 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8019b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b7:	8b 10                	mov    (%eax),%edx
  8019b9:	8b 48 04             	mov    0x4(%eax),%ecx
  8019bc:	8d 40 08             	lea    0x8(%eax),%eax
  8019bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019c2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019c7:	e9 8b 00 00 00       	jmp    801a57 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8019cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cf:	8b 10                	mov    (%eax),%edx
  8019d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d6:	8d 40 04             	lea    0x4(%eax),%eax
  8019d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019e1:	eb 74                	jmp    801a57 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8019e3:	83 f9 01             	cmp    $0x1,%ecx
  8019e6:	7f 1b                	jg     801a03 <vprintfmt+0x353>
	else if (lflag)
  8019e8:	85 c9                	test   %ecx,%ecx
  8019ea:	74 2c                	je     801a18 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8019ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ef:	8b 10                	mov    (%eax),%edx
  8019f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f6:	8d 40 04             	lea    0x4(%eax),%eax
  8019f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019fc:	b8 08 00 00 00       	mov    $0x8,%eax
  801a01:	eb 54                	jmp    801a57 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801a03:	8b 45 14             	mov    0x14(%ebp),%eax
  801a06:	8b 10                	mov    (%eax),%edx
  801a08:	8b 48 04             	mov    0x4(%eax),%ecx
  801a0b:	8d 40 08             	lea    0x8(%eax),%eax
  801a0e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a11:	b8 08 00 00 00       	mov    $0x8,%eax
  801a16:	eb 3f                	jmp    801a57 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801a18:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1b:	8b 10                	mov    (%eax),%edx
  801a1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a22:	8d 40 04             	lea    0x4(%eax),%eax
  801a25:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a28:	b8 08 00 00 00       	mov    $0x8,%eax
  801a2d:	eb 28                	jmp    801a57 <vprintfmt+0x3a7>
			putch('0', putdat);
  801a2f:	83 ec 08             	sub    $0x8,%esp
  801a32:	53                   	push   %ebx
  801a33:	6a 30                	push   $0x30
  801a35:	ff d6                	call   *%esi
			putch('x', putdat);
  801a37:	83 c4 08             	add    $0x8,%esp
  801a3a:	53                   	push   %ebx
  801a3b:	6a 78                	push   $0x78
  801a3d:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a42:	8b 10                	mov    (%eax),%edx
  801a44:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a49:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a4c:	8d 40 04             	lea    0x4(%eax),%eax
  801a4f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a52:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a57:	83 ec 0c             	sub    $0xc,%esp
  801a5a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801a5e:	57                   	push   %edi
  801a5f:	ff 75 e0             	pushl  -0x20(%ebp)
  801a62:	50                   	push   %eax
  801a63:	51                   	push   %ecx
  801a64:	52                   	push   %edx
  801a65:	89 da                	mov    %ebx,%edx
  801a67:	89 f0                	mov    %esi,%eax
  801a69:	e8 5a fb ff ff       	call   8015c8 <printnum>
			break;
  801a6e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801a71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a74:	e9 55 fc ff ff       	jmp    8016ce <vprintfmt+0x1e>
	if (lflag >= 2)
  801a79:	83 f9 01             	cmp    $0x1,%ecx
  801a7c:	7f 1b                	jg     801a99 <vprintfmt+0x3e9>
	else if (lflag)
  801a7e:	85 c9                	test   %ecx,%ecx
  801a80:	74 2c                	je     801aae <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  801a82:	8b 45 14             	mov    0x14(%ebp),%eax
  801a85:	8b 10                	mov    (%eax),%edx
  801a87:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a8c:	8d 40 04             	lea    0x4(%eax),%eax
  801a8f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a92:	b8 10 00 00 00       	mov    $0x10,%eax
  801a97:	eb be                	jmp    801a57 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801a99:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9c:	8b 10                	mov    (%eax),%edx
  801a9e:	8b 48 04             	mov    0x4(%eax),%ecx
  801aa1:	8d 40 08             	lea    0x8(%eax),%eax
  801aa4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aa7:	b8 10 00 00 00       	mov    $0x10,%eax
  801aac:	eb a9                	jmp    801a57 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801aae:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab1:	8b 10                	mov    (%eax),%edx
  801ab3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab8:	8d 40 04             	lea    0x4(%eax),%eax
  801abb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801abe:	b8 10 00 00 00       	mov    $0x10,%eax
  801ac3:	eb 92                	jmp    801a57 <vprintfmt+0x3a7>
			putch(ch, putdat);
  801ac5:	83 ec 08             	sub    $0x8,%esp
  801ac8:	53                   	push   %ebx
  801ac9:	6a 25                	push   $0x25
  801acb:	ff d6                	call   *%esi
			break;
  801acd:	83 c4 10             	add    $0x10,%esp
  801ad0:	eb 9f                	jmp    801a71 <vprintfmt+0x3c1>
			putch('%', putdat);
  801ad2:	83 ec 08             	sub    $0x8,%esp
  801ad5:	53                   	push   %ebx
  801ad6:	6a 25                	push   $0x25
  801ad8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ada:	83 c4 10             	add    $0x10,%esp
  801add:	89 f8                	mov    %edi,%eax
  801adf:	eb 03                	jmp    801ae4 <vprintfmt+0x434>
  801ae1:	83 e8 01             	sub    $0x1,%eax
  801ae4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801ae8:	75 f7                	jne    801ae1 <vprintfmt+0x431>
  801aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801aed:	eb 82                	jmp    801a71 <vprintfmt+0x3c1>

00801aef <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 18             	sub    $0x18,%esp
  801af5:	8b 45 08             	mov    0x8(%ebp),%eax
  801af8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801afb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801afe:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b02:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	74 26                	je     801b36 <vsnprintf+0x47>
  801b10:	85 d2                	test   %edx,%edx
  801b12:	7e 22                	jle    801b36 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b14:	ff 75 14             	pushl  0x14(%ebp)
  801b17:	ff 75 10             	pushl  0x10(%ebp)
  801b1a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b1d:	50                   	push   %eax
  801b1e:	68 76 16 80 00       	push   $0x801676
  801b23:	e8 88 fb ff ff       	call   8016b0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b31:	83 c4 10             	add    $0x10,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    
		return -E_INVAL;
  801b36:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b3b:	eb f7                	jmp    801b34 <vsnprintf+0x45>

00801b3d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b43:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b46:	50                   	push   %eax
  801b47:	ff 75 10             	pushl  0x10(%ebp)
  801b4a:	ff 75 0c             	pushl  0xc(%ebp)
  801b4d:	ff 75 08             	pushl  0x8(%ebp)
  801b50:	e8 9a ff ff ff       	call   801aef <vsnprintf>
	va_end(ap);

	return rc;
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b62:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b66:	74 05                	je     801b6d <strlen+0x16>
		n++;
  801b68:	83 c0 01             	add    $0x1,%eax
  801b6b:	eb f5                	jmp    801b62 <strlen+0xb>
	return n;
}
  801b6d:	5d                   	pop    %ebp
  801b6e:	c3                   	ret    

00801b6f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b75:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b78:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7d:	39 c2                	cmp    %eax,%edx
  801b7f:	74 0d                	je     801b8e <strnlen+0x1f>
  801b81:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801b85:	74 05                	je     801b8c <strnlen+0x1d>
		n++;
  801b87:	83 c2 01             	add    $0x1,%edx
  801b8a:	eb f1                	jmp    801b7d <strnlen+0xe>
  801b8c:	89 d0                	mov    %edx,%eax
	return n;
}
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    

00801b90 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	53                   	push   %ebx
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801ba3:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801ba6:	83 c2 01             	add    $0x1,%edx
  801ba9:	84 c9                	test   %cl,%cl
  801bab:	75 f2                	jne    801b9f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801bad:	5b                   	pop    %ebx
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    

00801bb0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	53                   	push   %ebx
  801bb4:	83 ec 10             	sub    $0x10,%esp
  801bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801bba:	53                   	push   %ebx
  801bbb:	e8 97 ff ff ff       	call   801b57 <strlen>
  801bc0:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801bc3:	ff 75 0c             	pushl  0xc(%ebp)
  801bc6:	01 d8                	add    %ebx,%eax
  801bc8:	50                   	push   %eax
  801bc9:	e8 c2 ff ff ff       	call   801b90 <strcpy>
	return dst;
}
  801bce:	89 d8                	mov    %ebx,%eax
  801bd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	56                   	push   %esi
  801bd9:	53                   	push   %ebx
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801be0:	89 c6                	mov    %eax,%esi
  801be2:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801be5:	89 c2                	mov    %eax,%edx
  801be7:	39 f2                	cmp    %esi,%edx
  801be9:	74 11                	je     801bfc <strncpy+0x27>
		*dst++ = *src;
  801beb:	83 c2 01             	add    $0x1,%edx
  801bee:	0f b6 19             	movzbl (%ecx),%ebx
  801bf1:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801bf4:	80 fb 01             	cmp    $0x1,%bl
  801bf7:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801bfa:	eb eb                	jmp    801be7 <strncpy+0x12>
	}
	return ret;
}
  801bfc:	5b                   	pop    %ebx
  801bfd:	5e                   	pop    %esi
  801bfe:	5d                   	pop    %ebp
  801bff:	c3                   	ret    

00801c00 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	56                   	push   %esi
  801c04:	53                   	push   %ebx
  801c05:	8b 75 08             	mov    0x8(%ebp),%esi
  801c08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c0b:	8b 55 10             	mov    0x10(%ebp),%edx
  801c0e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c10:	85 d2                	test   %edx,%edx
  801c12:	74 21                	je     801c35 <strlcpy+0x35>
  801c14:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801c18:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801c1a:	39 c2                	cmp    %eax,%edx
  801c1c:	74 14                	je     801c32 <strlcpy+0x32>
  801c1e:	0f b6 19             	movzbl (%ecx),%ebx
  801c21:	84 db                	test   %bl,%bl
  801c23:	74 0b                	je     801c30 <strlcpy+0x30>
			*dst++ = *src++;
  801c25:	83 c1 01             	add    $0x1,%ecx
  801c28:	83 c2 01             	add    $0x1,%edx
  801c2b:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c2e:	eb ea                	jmp    801c1a <strlcpy+0x1a>
  801c30:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801c32:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c35:	29 f0                	sub    %esi,%eax
}
  801c37:	5b                   	pop    %ebx
  801c38:	5e                   	pop    %esi
  801c39:	5d                   	pop    %ebp
  801c3a:	c3                   	ret    

00801c3b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c41:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c44:	0f b6 01             	movzbl (%ecx),%eax
  801c47:	84 c0                	test   %al,%al
  801c49:	74 0c                	je     801c57 <strcmp+0x1c>
  801c4b:	3a 02                	cmp    (%edx),%al
  801c4d:	75 08                	jne    801c57 <strcmp+0x1c>
		p++, q++;
  801c4f:	83 c1 01             	add    $0x1,%ecx
  801c52:	83 c2 01             	add    $0x1,%edx
  801c55:	eb ed                	jmp    801c44 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c57:	0f b6 c0             	movzbl %al,%eax
  801c5a:	0f b6 12             	movzbl (%edx),%edx
  801c5d:	29 d0                	sub    %edx,%eax
}
  801c5f:	5d                   	pop    %ebp
  801c60:	c3                   	ret    

00801c61 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	53                   	push   %ebx
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6b:	89 c3                	mov    %eax,%ebx
  801c6d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c70:	eb 06                	jmp    801c78 <strncmp+0x17>
		n--, p++, q++;
  801c72:	83 c0 01             	add    $0x1,%eax
  801c75:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c78:	39 d8                	cmp    %ebx,%eax
  801c7a:	74 16                	je     801c92 <strncmp+0x31>
  801c7c:	0f b6 08             	movzbl (%eax),%ecx
  801c7f:	84 c9                	test   %cl,%cl
  801c81:	74 04                	je     801c87 <strncmp+0x26>
  801c83:	3a 0a                	cmp    (%edx),%cl
  801c85:	74 eb                	je     801c72 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c87:	0f b6 00             	movzbl (%eax),%eax
  801c8a:	0f b6 12             	movzbl (%edx),%edx
  801c8d:	29 d0                	sub    %edx,%eax
}
  801c8f:	5b                   	pop    %ebx
  801c90:	5d                   	pop    %ebp
  801c91:	c3                   	ret    
		return 0;
  801c92:	b8 00 00 00 00       	mov    $0x0,%eax
  801c97:	eb f6                	jmp    801c8f <strncmp+0x2e>

00801c99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801ca3:	0f b6 10             	movzbl (%eax),%edx
  801ca6:	84 d2                	test   %dl,%dl
  801ca8:	74 09                	je     801cb3 <strchr+0x1a>
		if (*s == c)
  801caa:	38 ca                	cmp    %cl,%dl
  801cac:	74 0a                	je     801cb8 <strchr+0x1f>
	for (; *s; s++)
  801cae:	83 c0 01             	add    $0x1,%eax
  801cb1:	eb f0                	jmp    801ca3 <strchr+0xa>
			return (char *) s;
	return 0;
  801cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb8:	5d                   	pop    %ebp
  801cb9:	c3                   	ret    

00801cba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cc4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cc7:	38 ca                	cmp    %cl,%dl
  801cc9:	74 09                	je     801cd4 <strfind+0x1a>
  801ccb:	84 d2                	test   %dl,%dl
  801ccd:	74 05                	je     801cd4 <strfind+0x1a>
	for (; *s; s++)
  801ccf:	83 c0 01             	add    $0x1,%eax
  801cd2:	eb f0                	jmp    801cc4 <strfind+0xa>
			break;
	return (char *) s;
}
  801cd4:	5d                   	pop    %ebp
  801cd5:	c3                   	ret    

00801cd6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	57                   	push   %edi
  801cda:	56                   	push   %esi
  801cdb:	53                   	push   %ebx
  801cdc:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cdf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ce2:	85 c9                	test   %ecx,%ecx
  801ce4:	74 31                	je     801d17 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ce6:	89 f8                	mov    %edi,%eax
  801ce8:	09 c8                	or     %ecx,%eax
  801cea:	a8 03                	test   $0x3,%al
  801cec:	75 23                	jne    801d11 <memset+0x3b>
		c &= 0xFF;
  801cee:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801cf2:	89 d3                	mov    %edx,%ebx
  801cf4:	c1 e3 08             	shl    $0x8,%ebx
  801cf7:	89 d0                	mov    %edx,%eax
  801cf9:	c1 e0 18             	shl    $0x18,%eax
  801cfc:	89 d6                	mov    %edx,%esi
  801cfe:	c1 e6 10             	shl    $0x10,%esi
  801d01:	09 f0                	or     %esi,%eax
  801d03:	09 c2                	or     %eax,%edx
  801d05:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801d07:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d0a:	89 d0                	mov    %edx,%eax
  801d0c:	fc                   	cld    
  801d0d:	f3 ab                	rep stos %eax,%es:(%edi)
  801d0f:	eb 06                	jmp    801d17 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d14:	fc                   	cld    
  801d15:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801d17:	89 f8                	mov    %edi,%eax
  801d19:	5b                   	pop    %ebx
  801d1a:	5e                   	pop    %esi
  801d1b:	5f                   	pop    %edi
  801d1c:	5d                   	pop    %ebp
  801d1d:	c3                   	ret    

00801d1e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
  801d21:	57                   	push   %edi
  801d22:	56                   	push   %esi
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d29:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d2c:	39 c6                	cmp    %eax,%esi
  801d2e:	73 32                	jae    801d62 <memmove+0x44>
  801d30:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d33:	39 c2                	cmp    %eax,%edx
  801d35:	76 2b                	jbe    801d62 <memmove+0x44>
		s += n;
		d += n;
  801d37:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d3a:	89 fe                	mov    %edi,%esi
  801d3c:	09 ce                	or     %ecx,%esi
  801d3e:	09 d6                	or     %edx,%esi
  801d40:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d46:	75 0e                	jne    801d56 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d48:	83 ef 04             	sub    $0x4,%edi
  801d4b:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d4e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d51:	fd                   	std    
  801d52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d54:	eb 09                	jmp    801d5f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d56:	83 ef 01             	sub    $0x1,%edi
  801d59:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d5c:	fd                   	std    
  801d5d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d5f:	fc                   	cld    
  801d60:	eb 1a                	jmp    801d7c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d62:	89 c2                	mov    %eax,%edx
  801d64:	09 ca                	or     %ecx,%edx
  801d66:	09 f2                	or     %esi,%edx
  801d68:	f6 c2 03             	test   $0x3,%dl
  801d6b:	75 0a                	jne    801d77 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d6d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d70:	89 c7                	mov    %eax,%edi
  801d72:	fc                   	cld    
  801d73:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d75:	eb 05                	jmp    801d7c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801d77:	89 c7                	mov    %eax,%edi
  801d79:	fc                   	cld    
  801d7a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d7c:	5e                   	pop    %esi
  801d7d:	5f                   	pop    %edi
  801d7e:	5d                   	pop    %ebp
  801d7f:	c3                   	ret    

00801d80 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801d86:	ff 75 10             	pushl  0x10(%ebp)
  801d89:	ff 75 0c             	pushl  0xc(%ebp)
  801d8c:	ff 75 08             	pushl  0x8(%ebp)
  801d8f:	e8 8a ff ff ff       	call   801d1e <memmove>
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	56                   	push   %esi
  801d9a:	53                   	push   %ebx
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da1:	89 c6                	mov    %eax,%esi
  801da3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801da6:	39 f0                	cmp    %esi,%eax
  801da8:	74 1c                	je     801dc6 <memcmp+0x30>
		if (*s1 != *s2)
  801daa:	0f b6 08             	movzbl (%eax),%ecx
  801dad:	0f b6 1a             	movzbl (%edx),%ebx
  801db0:	38 d9                	cmp    %bl,%cl
  801db2:	75 08                	jne    801dbc <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801db4:	83 c0 01             	add    $0x1,%eax
  801db7:	83 c2 01             	add    $0x1,%edx
  801dba:	eb ea                	jmp    801da6 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801dbc:	0f b6 c1             	movzbl %cl,%eax
  801dbf:	0f b6 db             	movzbl %bl,%ebx
  801dc2:	29 d8                	sub    %ebx,%eax
  801dc4:	eb 05                	jmp    801dcb <memcmp+0x35>
	}

	return 0;
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcb:	5b                   	pop    %ebx
  801dcc:	5e                   	pop    %esi
  801dcd:	5d                   	pop    %ebp
  801dce:	c3                   	ret    

00801dcf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801dd8:	89 c2                	mov    %eax,%edx
  801dda:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801ddd:	39 d0                	cmp    %edx,%eax
  801ddf:	73 09                	jae    801dea <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801de1:	38 08                	cmp    %cl,(%eax)
  801de3:	74 05                	je     801dea <memfind+0x1b>
	for (; s < ends; s++)
  801de5:	83 c0 01             	add    $0x1,%eax
  801de8:	eb f3                	jmp    801ddd <memfind+0xe>
			break;
	return (void *) s;
}
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    

00801dec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	57                   	push   %edi
  801df0:	56                   	push   %esi
  801df1:	53                   	push   %ebx
  801df2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801df8:	eb 03                	jmp    801dfd <strtol+0x11>
		s++;
  801dfa:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801dfd:	0f b6 01             	movzbl (%ecx),%eax
  801e00:	3c 20                	cmp    $0x20,%al
  801e02:	74 f6                	je     801dfa <strtol+0xe>
  801e04:	3c 09                	cmp    $0x9,%al
  801e06:	74 f2                	je     801dfa <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801e08:	3c 2b                	cmp    $0x2b,%al
  801e0a:	74 2a                	je     801e36 <strtol+0x4a>
	int neg = 0;
  801e0c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e11:	3c 2d                	cmp    $0x2d,%al
  801e13:	74 2b                	je     801e40 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e15:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e1b:	75 0f                	jne    801e2c <strtol+0x40>
  801e1d:	80 39 30             	cmpb   $0x30,(%ecx)
  801e20:	74 28                	je     801e4a <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e22:	85 db                	test   %ebx,%ebx
  801e24:	b8 0a 00 00 00       	mov    $0xa,%eax
  801e29:	0f 44 d8             	cmove  %eax,%ebx
  801e2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e31:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e34:	eb 50                	jmp    801e86 <strtol+0x9a>
		s++;
  801e36:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e39:	bf 00 00 00 00       	mov    $0x0,%edi
  801e3e:	eb d5                	jmp    801e15 <strtol+0x29>
		s++, neg = 1;
  801e40:	83 c1 01             	add    $0x1,%ecx
  801e43:	bf 01 00 00 00       	mov    $0x1,%edi
  801e48:	eb cb                	jmp    801e15 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e4a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e4e:	74 0e                	je     801e5e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801e50:	85 db                	test   %ebx,%ebx
  801e52:	75 d8                	jne    801e2c <strtol+0x40>
		s++, base = 8;
  801e54:	83 c1 01             	add    $0x1,%ecx
  801e57:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e5c:	eb ce                	jmp    801e2c <strtol+0x40>
		s += 2, base = 16;
  801e5e:	83 c1 02             	add    $0x2,%ecx
  801e61:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e66:	eb c4                	jmp    801e2c <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e68:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e6b:	89 f3                	mov    %esi,%ebx
  801e6d:	80 fb 19             	cmp    $0x19,%bl
  801e70:	77 29                	ja     801e9b <strtol+0xaf>
			dig = *s - 'a' + 10;
  801e72:	0f be d2             	movsbl %dl,%edx
  801e75:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e78:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e7b:	7d 30                	jge    801ead <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801e7d:	83 c1 01             	add    $0x1,%ecx
  801e80:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e84:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e86:	0f b6 11             	movzbl (%ecx),%edx
  801e89:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e8c:	89 f3                	mov    %esi,%ebx
  801e8e:	80 fb 09             	cmp    $0x9,%bl
  801e91:	77 d5                	ja     801e68 <strtol+0x7c>
			dig = *s - '0';
  801e93:	0f be d2             	movsbl %dl,%edx
  801e96:	83 ea 30             	sub    $0x30,%edx
  801e99:	eb dd                	jmp    801e78 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801e9b:	8d 72 bf             	lea    -0x41(%edx),%esi
  801e9e:	89 f3                	mov    %esi,%ebx
  801ea0:	80 fb 19             	cmp    $0x19,%bl
  801ea3:	77 08                	ja     801ead <strtol+0xc1>
			dig = *s - 'A' + 10;
  801ea5:	0f be d2             	movsbl %dl,%edx
  801ea8:	83 ea 37             	sub    $0x37,%edx
  801eab:	eb cb                	jmp    801e78 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ead:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eb1:	74 05                	je     801eb8 <strtol+0xcc>
		*endptr = (char *) s;
  801eb3:	8b 75 0c             	mov    0xc(%ebp),%esi
  801eb6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801eb8:	89 c2                	mov    %eax,%edx
  801eba:	f7 da                	neg    %edx
  801ebc:	85 ff                	test   %edi,%edi
  801ebe:	0f 45 c2             	cmovne %edx,%eax
}
  801ec1:	5b                   	pop    %ebx
  801ec2:	5e                   	pop    %esi
  801ec3:	5f                   	pop    %edi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    

00801ec6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	56                   	push   %esi
  801eca:	53                   	push   %ebx
  801ecb:	8b 75 08             	mov    0x8(%ebp),%esi
  801ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	74 4f                	je     801f27 <ipc_recv+0x61>
  801ed8:	83 ec 0c             	sub    $0xc,%esp
  801edb:	50                   	push   %eax
  801edc:	e8 35 e4 ff ff       	call   800316 <sys_ipc_recv>
  801ee1:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801ee4:	85 f6                	test   %esi,%esi
  801ee6:	74 14                	je     801efc <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801ee8:	ba 00 00 00 00       	mov    $0x0,%edx
  801eed:	85 c0                	test   %eax,%eax
  801eef:	75 09                	jne    801efa <ipc_recv+0x34>
  801ef1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ef7:	8b 52 74             	mov    0x74(%edx),%edx
  801efa:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801efc:	85 db                	test   %ebx,%ebx
  801efe:	74 14                	je     801f14 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801f00:	ba 00 00 00 00       	mov    $0x0,%edx
  801f05:	85 c0                	test   %eax,%eax
  801f07:	75 09                	jne    801f12 <ipc_recv+0x4c>
  801f09:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f0f:	8b 52 78             	mov    0x78(%edx),%edx
  801f12:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801f14:	85 c0                	test   %eax,%eax
  801f16:	75 08                	jne    801f20 <ipc_recv+0x5a>
  801f18:	a1 08 40 80 00       	mov    0x804008,%eax
  801f1d:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f23:	5b                   	pop    %ebx
  801f24:	5e                   	pop    %esi
  801f25:	5d                   	pop    %ebp
  801f26:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f27:	83 ec 0c             	sub    $0xc,%esp
  801f2a:	68 00 00 c0 ee       	push   $0xeec00000
  801f2f:	e8 e2 e3 ff ff       	call   800316 <sys_ipc_recv>
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	eb ab                	jmp    801ee4 <ipc_recv+0x1e>

00801f39 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	57                   	push   %edi
  801f3d:	56                   	push   %esi
  801f3e:	53                   	push   %ebx
  801f3f:	83 ec 0c             	sub    $0xc,%esp
  801f42:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f45:	8b 75 10             	mov    0x10(%ebp),%esi
  801f48:	eb 20                	jmp    801f6a <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f4a:	6a 00                	push   $0x0
  801f4c:	68 00 00 c0 ee       	push   $0xeec00000
  801f51:	ff 75 0c             	pushl  0xc(%ebp)
  801f54:	57                   	push   %edi
  801f55:	e8 99 e3 ff ff       	call   8002f3 <sys_ipc_try_send>
  801f5a:	89 c3                	mov    %eax,%ebx
  801f5c:	83 c4 10             	add    $0x10,%esp
  801f5f:	eb 1f                	jmp    801f80 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801f61:	e8 e1 e1 ff ff       	call   800147 <sys_yield>
	while(retval != 0) {
  801f66:	85 db                	test   %ebx,%ebx
  801f68:	74 33                	je     801f9d <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f6a:	85 f6                	test   %esi,%esi
  801f6c:	74 dc                	je     801f4a <ipc_send+0x11>
  801f6e:	ff 75 14             	pushl  0x14(%ebp)
  801f71:	56                   	push   %esi
  801f72:	ff 75 0c             	pushl  0xc(%ebp)
  801f75:	57                   	push   %edi
  801f76:	e8 78 e3 ff ff       	call   8002f3 <sys_ipc_try_send>
  801f7b:	89 c3                	mov    %eax,%ebx
  801f7d:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801f80:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801f83:	74 dc                	je     801f61 <ipc_send+0x28>
  801f85:	85 db                	test   %ebx,%ebx
  801f87:	74 d8                	je     801f61 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801f89:	83 ec 04             	sub    $0x4,%esp
  801f8c:	68 20 27 80 00       	push   $0x802720
  801f91:	6a 35                	push   $0x35
  801f93:	68 50 27 80 00       	push   $0x802750
  801f98:	e8 3c f5 ff ff       	call   8014d9 <_panic>
	}
}
  801f9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa0:	5b                   	pop    %ebx
  801fa1:	5e                   	pop    %esi
  801fa2:	5f                   	pop    %edi
  801fa3:	5d                   	pop    %ebp
  801fa4:	c3                   	ret    

00801fa5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fab:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fb0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fb3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fb9:	8b 52 50             	mov    0x50(%edx),%edx
  801fbc:	39 ca                	cmp    %ecx,%edx
  801fbe:	74 11                	je     801fd1 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fc0:	83 c0 01             	add    $0x1,%eax
  801fc3:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fc8:	75 e6                	jne    801fb0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fca:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcf:	eb 0b                	jmp    801fdc <ipc_find_env+0x37>
			return envs[i].env_id;
  801fd1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fd4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fd9:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fdc:	5d                   	pop    %ebp
  801fdd:	c3                   	ret    

00801fde <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fe4:	89 d0                	mov    %edx,%eax
  801fe6:	c1 e8 16             	shr    $0x16,%eax
  801fe9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ff5:	f6 c1 01             	test   $0x1,%cl
  801ff8:	74 1d                	je     802017 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ffa:	c1 ea 0c             	shr    $0xc,%edx
  801ffd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802004:	f6 c2 01             	test   $0x1,%dl
  802007:	74 0e                	je     802017 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802009:	c1 ea 0c             	shr    $0xc,%edx
  80200c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802013:	ef 
  802014:	0f b7 c0             	movzwl %ax,%eax
}
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    
  802019:	66 90                	xchg   %ax,%ax
  80201b:	66 90                	xchg   %ax,%ax
  80201d:	66 90                	xchg   %ax,%ax
  80201f:	90                   	nop

00802020 <__udivdi3>:
  802020:	f3 0f 1e fb          	endbr32 
  802024:	55                   	push   %ebp
  802025:	57                   	push   %edi
  802026:	56                   	push   %esi
  802027:	53                   	push   %ebx
  802028:	83 ec 1c             	sub    $0x1c,%esp
  80202b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80202f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802033:	8b 74 24 34          	mov    0x34(%esp),%esi
  802037:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80203b:	85 d2                	test   %edx,%edx
  80203d:	75 49                	jne    802088 <__udivdi3+0x68>
  80203f:	39 f3                	cmp    %esi,%ebx
  802041:	76 15                	jbe    802058 <__udivdi3+0x38>
  802043:	31 ff                	xor    %edi,%edi
  802045:	89 e8                	mov    %ebp,%eax
  802047:	89 f2                	mov    %esi,%edx
  802049:	f7 f3                	div    %ebx
  80204b:	89 fa                	mov    %edi,%edx
  80204d:	83 c4 1c             	add    $0x1c,%esp
  802050:	5b                   	pop    %ebx
  802051:	5e                   	pop    %esi
  802052:	5f                   	pop    %edi
  802053:	5d                   	pop    %ebp
  802054:	c3                   	ret    
  802055:	8d 76 00             	lea    0x0(%esi),%esi
  802058:	89 d9                	mov    %ebx,%ecx
  80205a:	85 db                	test   %ebx,%ebx
  80205c:	75 0b                	jne    802069 <__udivdi3+0x49>
  80205e:	b8 01 00 00 00       	mov    $0x1,%eax
  802063:	31 d2                	xor    %edx,%edx
  802065:	f7 f3                	div    %ebx
  802067:	89 c1                	mov    %eax,%ecx
  802069:	31 d2                	xor    %edx,%edx
  80206b:	89 f0                	mov    %esi,%eax
  80206d:	f7 f1                	div    %ecx
  80206f:	89 c6                	mov    %eax,%esi
  802071:	89 e8                	mov    %ebp,%eax
  802073:	89 f7                	mov    %esi,%edi
  802075:	f7 f1                	div    %ecx
  802077:	89 fa                	mov    %edi,%edx
  802079:	83 c4 1c             	add    $0x1c,%esp
  80207c:	5b                   	pop    %ebx
  80207d:	5e                   	pop    %esi
  80207e:	5f                   	pop    %edi
  80207f:	5d                   	pop    %ebp
  802080:	c3                   	ret    
  802081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802088:	39 f2                	cmp    %esi,%edx
  80208a:	77 1c                	ja     8020a8 <__udivdi3+0x88>
  80208c:	0f bd fa             	bsr    %edx,%edi
  80208f:	83 f7 1f             	xor    $0x1f,%edi
  802092:	75 2c                	jne    8020c0 <__udivdi3+0xa0>
  802094:	39 f2                	cmp    %esi,%edx
  802096:	72 06                	jb     80209e <__udivdi3+0x7e>
  802098:	31 c0                	xor    %eax,%eax
  80209a:	39 eb                	cmp    %ebp,%ebx
  80209c:	77 ad                	ja     80204b <__udivdi3+0x2b>
  80209e:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a3:	eb a6                	jmp    80204b <__udivdi3+0x2b>
  8020a5:	8d 76 00             	lea    0x0(%esi),%esi
  8020a8:	31 ff                	xor    %edi,%edi
  8020aa:	31 c0                	xor    %eax,%eax
  8020ac:	89 fa                	mov    %edi,%edx
  8020ae:	83 c4 1c             	add    $0x1c,%esp
  8020b1:	5b                   	pop    %ebx
  8020b2:	5e                   	pop    %esi
  8020b3:	5f                   	pop    %edi
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    
  8020b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020bd:	8d 76 00             	lea    0x0(%esi),%esi
  8020c0:	89 f9                	mov    %edi,%ecx
  8020c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020c7:	29 f8                	sub    %edi,%eax
  8020c9:	d3 e2                	shl    %cl,%edx
  8020cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020cf:	89 c1                	mov    %eax,%ecx
  8020d1:	89 da                	mov    %ebx,%edx
  8020d3:	d3 ea                	shr    %cl,%edx
  8020d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020d9:	09 d1                	or     %edx,%ecx
  8020db:	89 f2                	mov    %esi,%edx
  8020dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020e1:	89 f9                	mov    %edi,%ecx
  8020e3:	d3 e3                	shl    %cl,%ebx
  8020e5:	89 c1                	mov    %eax,%ecx
  8020e7:	d3 ea                	shr    %cl,%edx
  8020e9:	89 f9                	mov    %edi,%ecx
  8020eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020ef:	89 eb                	mov    %ebp,%ebx
  8020f1:	d3 e6                	shl    %cl,%esi
  8020f3:	89 c1                	mov    %eax,%ecx
  8020f5:	d3 eb                	shr    %cl,%ebx
  8020f7:	09 de                	or     %ebx,%esi
  8020f9:	89 f0                	mov    %esi,%eax
  8020fb:	f7 74 24 08          	divl   0x8(%esp)
  8020ff:	89 d6                	mov    %edx,%esi
  802101:	89 c3                	mov    %eax,%ebx
  802103:	f7 64 24 0c          	mull   0xc(%esp)
  802107:	39 d6                	cmp    %edx,%esi
  802109:	72 15                	jb     802120 <__udivdi3+0x100>
  80210b:	89 f9                	mov    %edi,%ecx
  80210d:	d3 e5                	shl    %cl,%ebp
  80210f:	39 c5                	cmp    %eax,%ebp
  802111:	73 04                	jae    802117 <__udivdi3+0xf7>
  802113:	39 d6                	cmp    %edx,%esi
  802115:	74 09                	je     802120 <__udivdi3+0x100>
  802117:	89 d8                	mov    %ebx,%eax
  802119:	31 ff                	xor    %edi,%edi
  80211b:	e9 2b ff ff ff       	jmp    80204b <__udivdi3+0x2b>
  802120:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802123:	31 ff                	xor    %edi,%edi
  802125:	e9 21 ff ff ff       	jmp    80204b <__udivdi3+0x2b>
  80212a:	66 90                	xchg   %ax,%ax
  80212c:	66 90                	xchg   %ax,%ax
  80212e:	66 90                	xchg   %ax,%ax

00802130 <__umoddi3>:
  802130:	f3 0f 1e fb          	endbr32 
  802134:	55                   	push   %ebp
  802135:	57                   	push   %edi
  802136:	56                   	push   %esi
  802137:	53                   	push   %ebx
  802138:	83 ec 1c             	sub    $0x1c,%esp
  80213b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80213f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802143:	8b 74 24 30          	mov    0x30(%esp),%esi
  802147:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80214b:	89 da                	mov    %ebx,%edx
  80214d:	85 c0                	test   %eax,%eax
  80214f:	75 3f                	jne    802190 <__umoddi3+0x60>
  802151:	39 df                	cmp    %ebx,%edi
  802153:	76 13                	jbe    802168 <__umoddi3+0x38>
  802155:	89 f0                	mov    %esi,%eax
  802157:	f7 f7                	div    %edi
  802159:	89 d0                	mov    %edx,%eax
  80215b:	31 d2                	xor    %edx,%edx
  80215d:	83 c4 1c             	add    $0x1c,%esp
  802160:	5b                   	pop    %ebx
  802161:	5e                   	pop    %esi
  802162:	5f                   	pop    %edi
  802163:	5d                   	pop    %ebp
  802164:	c3                   	ret    
  802165:	8d 76 00             	lea    0x0(%esi),%esi
  802168:	89 fd                	mov    %edi,%ebp
  80216a:	85 ff                	test   %edi,%edi
  80216c:	75 0b                	jne    802179 <__umoddi3+0x49>
  80216e:	b8 01 00 00 00       	mov    $0x1,%eax
  802173:	31 d2                	xor    %edx,%edx
  802175:	f7 f7                	div    %edi
  802177:	89 c5                	mov    %eax,%ebp
  802179:	89 d8                	mov    %ebx,%eax
  80217b:	31 d2                	xor    %edx,%edx
  80217d:	f7 f5                	div    %ebp
  80217f:	89 f0                	mov    %esi,%eax
  802181:	f7 f5                	div    %ebp
  802183:	89 d0                	mov    %edx,%eax
  802185:	eb d4                	jmp    80215b <__umoddi3+0x2b>
  802187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80218e:	66 90                	xchg   %ax,%ax
  802190:	89 f1                	mov    %esi,%ecx
  802192:	39 d8                	cmp    %ebx,%eax
  802194:	76 0a                	jbe    8021a0 <__umoddi3+0x70>
  802196:	89 f0                	mov    %esi,%eax
  802198:	83 c4 1c             	add    $0x1c,%esp
  80219b:	5b                   	pop    %ebx
  80219c:	5e                   	pop    %esi
  80219d:	5f                   	pop    %edi
  80219e:	5d                   	pop    %ebp
  80219f:	c3                   	ret    
  8021a0:	0f bd e8             	bsr    %eax,%ebp
  8021a3:	83 f5 1f             	xor    $0x1f,%ebp
  8021a6:	75 20                	jne    8021c8 <__umoddi3+0x98>
  8021a8:	39 d8                	cmp    %ebx,%eax
  8021aa:	0f 82 b0 00 00 00    	jb     802260 <__umoddi3+0x130>
  8021b0:	39 f7                	cmp    %esi,%edi
  8021b2:	0f 86 a8 00 00 00    	jbe    802260 <__umoddi3+0x130>
  8021b8:	89 c8                	mov    %ecx,%eax
  8021ba:	83 c4 1c             	add    $0x1c,%esp
  8021bd:	5b                   	pop    %ebx
  8021be:	5e                   	pop    %esi
  8021bf:	5f                   	pop    %edi
  8021c0:	5d                   	pop    %ebp
  8021c1:	c3                   	ret    
  8021c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021c8:	89 e9                	mov    %ebp,%ecx
  8021ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8021cf:	29 ea                	sub    %ebp,%edx
  8021d1:	d3 e0                	shl    %cl,%eax
  8021d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021d7:	89 d1                	mov    %edx,%ecx
  8021d9:	89 f8                	mov    %edi,%eax
  8021db:	d3 e8                	shr    %cl,%eax
  8021dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021e9:	09 c1                	or     %eax,%ecx
  8021eb:	89 d8                	mov    %ebx,%eax
  8021ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021f1:	89 e9                	mov    %ebp,%ecx
  8021f3:	d3 e7                	shl    %cl,%edi
  8021f5:	89 d1                	mov    %edx,%ecx
  8021f7:	d3 e8                	shr    %cl,%eax
  8021f9:	89 e9                	mov    %ebp,%ecx
  8021fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021ff:	d3 e3                	shl    %cl,%ebx
  802201:	89 c7                	mov    %eax,%edi
  802203:	89 d1                	mov    %edx,%ecx
  802205:	89 f0                	mov    %esi,%eax
  802207:	d3 e8                	shr    %cl,%eax
  802209:	89 e9                	mov    %ebp,%ecx
  80220b:	89 fa                	mov    %edi,%edx
  80220d:	d3 e6                	shl    %cl,%esi
  80220f:	09 d8                	or     %ebx,%eax
  802211:	f7 74 24 08          	divl   0x8(%esp)
  802215:	89 d1                	mov    %edx,%ecx
  802217:	89 f3                	mov    %esi,%ebx
  802219:	f7 64 24 0c          	mull   0xc(%esp)
  80221d:	89 c6                	mov    %eax,%esi
  80221f:	89 d7                	mov    %edx,%edi
  802221:	39 d1                	cmp    %edx,%ecx
  802223:	72 06                	jb     80222b <__umoddi3+0xfb>
  802225:	75 10                	jne    802237 <__umoddi3+0x107>
  802227:	39 c3                	cmp    %eax,%ebx
  802229:	73 0c                	jae    802237 <__umoddi3+0x107>
  80222b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80222f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802233:	89 d7                	mov    %edx,%edi
  802235:	89 c6                	mov    %eax,%esi
  802237:	89 ca                	mov    %ecx,%edx
  802239:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80223e:	29 f3                	sub    %esi,%ebx
  802240:	19 fa                	sbb    %edi,%edx
  802242:	89 d0                	mov    %edx,%eax
  802244:	d3 e0                	shl    %cl,%eax
  802246:	89 e9                	mov    %ebp,%ecx
  802248:	d3 eb                	shr    %cl,%ebx
  80224a:	d3 ea                	shr    %cl,%edx
  80224c:	09 d8                	or     %ebx,%eax
  80224e:	83 c4 1c             	add    $0x1c,%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5f                   	pop    %edi
  802254:	5d                   	pop    %ebp
  802255:	c3                   	ret    
  802256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80225d:	8d 76 00             	lea    0x0(%esi),%esi
  802260:	89 da                	mov    %ebx,%edx
  802262:	29 fe                	sub    %edi,%esi
  802264:	19 c2                	sbb    %eax,%edx
  802266:	89 f1                	mov    %esi,%ecx
  802268:	89 c8                	mov    %ecx,%eax
  80226a:	e9 4b ff ff ff       	jmp    8021ba <__umoddi3+0x8a>
