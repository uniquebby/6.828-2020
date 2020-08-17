
obj/user/buggyhello2.debug：     文件格式 elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  800039:	68 00 00 10 00       	push   $0x100000
  80003e:	ff 35 00 30 80 00    	pushl  0x803000
  800044:	e8 65 00 00 00       	call   8000ae <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800059:	e8 ce 00 00 00       	call   80012c <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800070:	85 db                	test   %ebx,%ebx
  800072:	7e 07                	jle    80007b <libmain+0x2d>
		binaryname = argv[0];
  800074:	8b 06                	mov    (%esi),%eax
  800076:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	e8 ae ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800085:	e8 0a 00 00 00       	call   800094 <exit>
}
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800090:	5b                   	pop    %ebx
  800091:	5e                   	pop    %esi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    

00800094 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009a:	e8 b3 04 00 00       	call   800552 <close_all>
	sys_env_destroy(0);
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	6a 00                	push   $0x0
  8000a4:	e8 42 00 00 00       	call   8000eb <sys_env_destroy>
}
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	c9                   	leave  
  8000ad:	c3                   	ret    

008000ae <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	57                   	push   %edi
  8000b2:	56                   	push   %esi
  8000b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bf:	89 c3                	mov    %eax,%ebx
  8000c1:	89 c7                	mov    %eax,%edi
  8000c3:	89 c6                	mov    %eax,%esi
  8000c5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c7:	5b                   	pop    %ebx
  8000c8:	5e                   	pop    %esi
  8000c9:	5f                   	pop    %edi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    

008000cc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	57                   	push   %edi
  8000d0:	56                   	push   %esi
  8000d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000dc:	89 d1                	mov    %edx,%ecx
  8000de:	89 d3                	mov    %edx,%ebx
  8000e0:	89 d7                	mov    %edx,%edi
  8000e2:	89 d6                	mov    %edx,%esi
  8000e4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fc:	b8 03 00 00 00       	mov    $0x3,%eax
  800101:	89 cb                	mov    %ecx,%ebx
  800103:	89 cf                	mov    %ecx,%edi
  800105:	89 ce                	mov    %ecx,%esi
  800107:	cd 30                	int    $0x30
	if(check && ret > 0)
  800109:	85 c0                	test   %eax,%eax
  80010b:	7f 08                	jg     800115 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800110:	5b                   	pop    %ebx
  800111:	5e                   	pop    %esi
  800112:	5f                   	pop    %edi
  800113:	5d                   	pop    %ebp
  800114:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	50                   	push   %eax
  800119:	6a 03                	push   $0x3
  80011b:	68 98 22 80 00       	push   $0x802298
  800120:	6a 23                	push   $0x23
  800122:	68 b5 22 80 00       	push   $0x8022b5
  800127:	e8 b1 13 00 00       	call   8014dd <_panic>

0080012c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012c:	55                   	push   %ebp
  80012d:	89 e5                	mov    %esp,%ebp
  80012f:	57                   	push   %edi
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
	asm volatile("int %1\n"
  800132:	ba 00 00 00 00       	mov    $0x0,%edx
  800137:	b8 02 00 00 00       	mov    $0x2,%eax
  80013c:	89 d1                	mov    %edx,%ecx
  80013e:	89 d3                	mov    %edx,%ebx
  800140:	89 d7                	mov    %edx,%edi
  800142:	89 d6                	mov    %edx,%esi
  800144:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800146:	5b                   	pop    %ebx
  800147:	5e                   	pop    %esi
  800148:	5f                   	pop    %edi
  800149:	5d                   	pop    %ebp
  80014a:	c3                   	ret    

0080014b <sys_yield>:

void
sys_yield(void)
{
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	57                   	push   %edi
  80014f:	56                   	push   %esi
  800150:	53                   	push   %ebx
	asm volatile("int %1\n"
  800151:	ba 00 00 00 00       	mov    $0x0,%edx
  800156:	b8 0b 00 00 00       	mov    $0xb,%eax
  80015b:	89 d1                	mov    %edx,%ecx
  80015d:	89 d3                	mov    %edx,%ebx
  80015f:	89 d7                	mov    %edx,%edi
  800161:	89 d6                	mov    %edx,%esi
  800163:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800165:	5b                   	pop    %ebx
  800166:	5e                   	pop    %esi
  800167:	5f                   	pop    %edi
  800168:	5d                   	pop    %ebp
  800169:	c3                   	ret    

0080016a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80016a:	55                   	push   %ebp
  80016b:	89 e5                	mov    %esp,%ebp
  80016d:	57                   	push   %edi
  80016e:	56                   	push   %esi
  80016f:	53                   	push   %ebx
  800170:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800173:	be 00 00 00 00       	mov    $0x0,%esi
  800178:	8b 55 08             	mov    0x8(%ebp),%edx
  80017b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80017e:	b8 04 00 00 00       	mov    $0x4,%eax
  800183:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800186:	89 f7                	mov    %esi,%edi
  800188:	cd 30                	int    $0x30
	if(check && ret > 0)
  80018a:	85 c0                	test   %eax,%eax
  80018c:	7f 08                	jg     800196 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80018e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800191:	5b                   	pop    %ebx
  800192:	5e                   	pop    %esi
  800193:	5f                   	pop    %edi
  800194:	5d                   	pop    %ebp
  800195:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	50                   	push   %eax
  80019a:	6a 04                	push   $0x4
  80019c:	68 98 22 80 00       	push   $0x802298
  8001a1:	6a 23                	push   $0x23
  8001a3:	68 b5 22 80 00       	push   $0x8022b5
  8001a8:	e8 30 13 00 00       	call   8014dd <_panic>

008001ad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	57                   	push   %edi
  8001b1:	56                   	push   %esi
  8001b2:	53                   	push   %ebx
  8001b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001bc:	b8 05 00 00 00       	mov    $0x5,%eax
  8001c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c7:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001cc:	85 c0                	test   %eax,%eax
  8001ce:	7f 08                	jg     8001d8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d3:	5b                   	pop    %ebx
  8001d4:	5e                   	pop    %esi
  8001d5:	5f                   	pop    %edi
  8001d6:	5d                   	pop    %ebp
  8001d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d8:	83 ec 0c             	sub    $0xc,%esp
  8001db:	50                   	push   %eax
  8001dc:	6a 05                	push   $0x5
  8001de:	68 98 22 80 00       	push   $0x802298
  8001e3:	6a 23                	push   $0x23
  8001e5:	68 b5 22 80 00       	push   $0x8022b5
  8001ea:	e8 ee 12 00 00       	call   8014dd <_panic>

008001ef <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	57                   	push   %edi
  8001f3:	56                   	push   %esi
  8001f4:	53                   	push   %ebx
  8001f5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800200:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800203:	b8 06 00 00 00       	mov    $0x6,%eax
  800208:	89 df                	mov    %ebx,%edi
  80020a:	89 de                	mov    %ebx,%esi
  80020c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020e:	85 c0                	test   %eax,%eax
  800210:	7f 08                	jg     80021a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800212:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800215:	5b                   	pop    %ebx
  800216:	5e                   	pop    %esi
  800217:	5f                   	pop    %edi
  800218:	5d                   	pop    %ebp
  800219:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	50                   	push   %eax
  80021e:	6a 06                	push   $0x6
  800220:	68 98 22 80 00       	push   $0x802298
  800225:	6a 23                	push   $0x23
  800227:	68 b5 22 80 00       	push   $0x8022b5
  80022c:	e8 ac 12 00 00       	call   8014dd <_panic>

00800231 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	57                   	push   %edi
  800235:	56                   	push   %esi
  800236:	53                   	push   %ebx
  800237:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80023a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023f:	8b 55 08             	mov    0x8(%ebp),%edx
  800242:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800245:	b8 08 00 00 00       	mov    $0x8,%eax
  80024a:	89 df                	mov    %ebx,%edi
  80024c:	89 de                	mov    %ebx,%esi
  80024e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800250:	85 c0                	test   %eax,%eax
  800252:	7f 08                	jg     80025c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800254:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800257:	5b                   	pop    %ebx
  800258:	5e                   	pop    %esi
  800259:	5f                   	pop    %edi
  80025a:	5d                   	pop    %ebp
  80025b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	6a 08                	push   $0x8
  800262:	68 98 22 80 00       	push   $0x802298
  800267:	6a 23                	push   $0x23
  800269:	68 b5 22 80 00       	push   $0x8022b5
  80026e:	e8 6a 12 00 00       	call   8014dd <_panic>

00800273 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800273:	55                   	push   %ebp
  800274:	89 e5                	mov    %esp,%ebp
  800276:	57                   	push   %edi
  800277:	56                   	push   %esi
  800278:	53                   	push   %ebx
  800279:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80027c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800281:	8b 55 08             	mov    0x8(%ebp),%edx
  800284:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800287:	b8 09 00 00 00       	mov    $0x9,%eax
  80028c:	89 df                	mov    %ebx,%edi
  80028e:	89 de                	mov    %ebx,%esi
  800290:	cd 30                	int    $0x30
	if(check && ret > 0)
  800292:	85 c0                	test   %eax,%eax
  800294:	7f 08                	jg     80029e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029e:	83 ec 0c             	sub    $0xc,%esp
  8002a1:	50                   	push   %eax
  8002a2:	6a 09                	push   $0x9
  8002a4:	68 98 22 80 00       	push   $0x802298
  8002a9:	6a 23                	push   $0x23
  8002ab:	68 b5 22 80 00       	push   $0x8022b5
  8002b0:	e8 28 12 00 00       	call   8014dd <_panic>

008002b5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	57                   	push   %edi
  8002b9:	56                   	push   %esi
  8002ba:	53                   	push   %ebx
  8002bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ce:	89 df                	mov    %ebx,%edi
  8002d0:	89 de                	mov    %ebx,%esi
  8002d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d4:	85 c0                	test   %eax,%eax
  8002d6:	7f 08                	jg     8002e0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002db:	5b                   	pop    %ebx
  8002dc:	5e                   	pop    %esi
  8002dd:	5f                   	pop    %edi
  8002de:	5d                   	pop    %ebp
  8002df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	50                   	push   %eax
  8002e4:	6a 0a                	push   $0xa
  8002e6:	68 98 22 80 00       	push   $0x802298
  8002eb:	6a 23                	push   $0x23
  8002ed:	68 b5 22 80 00       	push   $0x8022b5
  8002f2:	e8 e6 11 00 00       	call   8014dd <_panic>

008002f7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	57                   	push   %edi
  8002fb:	56                   	push   %esi
  8002fc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800300:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800303:	b8 0c 00 00 00       	mov    $0xc,%eax
  800308:	be 00 00 00 00       	mov    $0x0,%esi
  80030d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800310:	8b 7d 14             	mov    0x14(%ebp),%edi
  800313:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800315:	5b                   	pop    %ebx
  800316:	5e                   	pop    %esi
  800317:	5f                   	pop    %edi
  800318:	5d                   	pop    %ebp
  800319:	c3                   	ret    

0080031a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	57                   	push   %edi
  80031e:	56                   	push   %esi
  80031f:	53                   	push   %ebx
  800320:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800323:	b9 00 00 00 00       	mov    $0x0,%ecx
  800328:	8b 55 08             	mov    0x8(%ebp),%edx
  80032b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800330:	89 cb                	mov    %ecx,%ebx
  800332:	89 cf                	mov    %ecx,%edi
  800334:	89 ce                	mov    %ecx,%esi
  800336:	cd 30                	int    $0x30
	if(check && ret > 0)
  800338:	85 c0                	test   %eax,%eax
  80033a:	7f 08                	jg     800344 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80033c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033f:	5b                   	pop    %ebx
  800340:	5e                   	pop    %esi
  800341:	5f                   	pop    %edi
  800342:	5d                   	pop    %ebp
  800343:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800344:	83 ec 0c             	sub    $0xc,%esp
  800347:	50                   	push   %eax
  800348:	6a 0d                	push   $0xd
  80034a:	68 98 22 80 00       	push   $0x802298
  80034f:	6a 23                	push   $0x23
  800351:	68 b5 22 80 00       	push   $0x8022b5
  800356:	e8 82 11 00 00       	call   8014dd <_panic>

0080035b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	57                   	push   %edi
  80035f:	56                   	push   %esi
  800360:	53                   	push   %ebx
	asm volatile("int %1\n"
  800361:	ba 00 00 00 00       	mov    $0x0,%edx
  800366:	b8 0e 00 00 00       	mov    $0xe,%eax
  80036b:	89 d1                	mov    %edx,%ecx
  80036d:	89 d3                	mov    %edx,%ebx
  80036f:	89 d7                	mov    %edx,%edi
  800371:	89 d6                	mov    %edx,%esi
  800373:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800375:	5b                   	pop    %ebx
  800376:	5e                   	pop    %esi
  800377:	5f                   	pop    %edi
  800378:	5d                   	pop    %ebp
  800379:	c3                   	ret    

0080037a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80037d:	8b 45 08             	mov    0x8(%ebp),%eax
  800380:	05 00 00 00 30       	add    $0x30000000,%eax
  800385:	c1 e8 0c             	shr    $0xc,%eax
}
  800388:	5d                   	pop    %ebp
  800389:	c3                   	ret    

0080038a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80038d:	8b 45 08             	mov    0x8(%ebp),%eax
  800390:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800395:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80039a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80039f:	5d                   	pop    %ebp
  8003a0:	c3                   	ret    

008003a1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003a9:	89 c2                	mov    %eax,%edx
  8003ab:	c1 ea 16             	shr    $0x16,%edx
  8003ae:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003b5:	f6 c2 01             	test   $0x1,%dl
  8003b8:	74 2d                	je     8003e7 <fd_alloc+0x46>
  8003ba:	89 c2                	mov    %eax,%edx
  8003bc:	c1 ea 0c             	shr    $0xc,%edx
  8003bf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003c6:	f6 c2 01             	test   $0x1,%dl
  8003c9:	74 1c                	je     8003e7 <fd_alloc+0x46>
  8003cb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003d0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003d5:	75 d2                	jne    8003a9 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8003e0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003e5:	eb 0a                	jmp    8003f1 <fd_alloc+0x50>
			*fd_store = fd;
  8003e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003ea:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003f1:	5d                   	pop    %ebp
  8003f2:	c3                   	ret    

008003f3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003f3:	55                   	push   %ebp
  8003f4:	89 e5                	mov    %esp,%ebp
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003f9:	83 f8 1f             	cmp    $0x1f,%eax
  8003fc:	77 30                	ja     80042e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003fe:	c1 e0 0c             	shl    $0xc,%eax
  800401:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800406:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80040c:	f6 c2 01             	test   $0x1,%dl
  80040f:	74 24                	je     800435 <fd_lookup+0x42>
  800411:	89 c2                	mov    %eax,%edx
  800413:	c1 ea 0c             	shr    $0xc,%edx
  800416:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80041d:	f6 c2 01             	test   $0x1,%dl
  800420:	74 1a                	je     80043c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800422:	8b 55 0c             	mov    0xc(%ebp),%edx
  800425:	89 02                	mov    %eax,(%edx)
	return 0;
  800427:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042c:	5d                   	pop    %ebp
  80042d:	c3                   	ret    
		return -E_INVAL;
  80042e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800433:	eb f7                	jmp    80042c <fd_lookup+0x39>
		return -E_INVAL;
  800435:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80043a:	eb f0                	jmp    80042c <fd_lookup+0x39>
  80043c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800441:	eb e9                	jmp    80042c <fd_lookup+0x39>

00800443 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80044c:	ba 00 00 00 00       	mov    $0x0,%edx
  800451:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  800456:	39 08                	cmp    %ecx,(%eax)
  800458:	74 38                	je     800492 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80045a:	83 c2 01             	add    $0x1,%edx
  80045d:	8b 04 95 40 23 80 00 	mov    0x802340(,%edx,4),%eax
  800464:	85 c0                	test   %eax,%eax
  800466:	75 ee                	jne    800456 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800468:	a1 08 40 80 00       	mov    0x804008,%eax
  80046d:	8b 40 48             	mov    0x48(%eax),%eax
  800470:	83 ec 04             	sub    $0x4,%esp
  800473:	51                   	push   %ecx
  800474:	50                   	push   %eax
  800475:	68 c4 22 80 00       	push   $0x8022c4
  80047a:	e8 39 11 00 00       	call   8015b8 <cprintf>
	*dev = 0;
  80047f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800482:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800490:	c9                   	leave  
  800491:	c3                   	ret    
			*dev = devtab[i];
  800492:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800495:	89 01                	mov    %eax,(%ecx)
			return 0;
  800497:	b8 00 00 00 00       	mov    $0x0,%eax
  80049c:	eb f2                	jmp    800490 <dev_lookup+0x4d>

0080049e <fd_close>:
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	57                   	push   %edi
  8004a2:	56                   	push   %esi
  8004a3:	53                   	push   %ebx
  8004a4:	83 ec 24             	sub    $0x24,%esp
  8004a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8004aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004ad:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004b0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004b1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004b7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004ba:	50                   	push   %eax
  8004bb:	e8 33 ff ff ff       	call   8003f3 <fd_lookup>
  8004c0:	89 c3                	mov    %eax,%ebx
  8004c2:	83 c4 10             	add    $0x10,%esp
  8004c5:	85 c0                	test   %eax,%eax
  8004c7:	78 05                	js     8004ce <fd_close+0x30>
	    || fd != fd2)
  8004c9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004cc:	74 16                	je     8004e4 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004ce:	89 f8                	mov    %edi,%eax
  8004d0:	84 c0                	test   %al,%al
  8004d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d7:	0f 44 d8             	cmove  %eax,%ebx
}
  8004da:	89 d8                	mov    %ebx,%eax
  8004dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004df:	5b                   	pop    %ebx
  8004e0:	5e                   	pop    %esi
  8004e1:	5f                   	pop    %edi
  8004e2:	5d                   	pop    %ebp
  8004e3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004ea:	50                   	push   %eax
  8004eb:	ff 36                	pushl  (%esi)
  8004ed:	e8 51 ff ff ff       	call   800443 <dev_lookup>
  8004f2:	89 c3                	mov    %eax,%ebx
  8004f4:	83 c4 10             	add    $0x10,%esp
  8004f7:	85 c0                	test   %eax,%eax
  8004f9:	78 1a                	js     800515 <fd_close+0x77>
		if (dev->dev_close)
  8004fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004fe:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800501:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800506:	85 c0                	test   %eax,%eax
  800508:	74 0b                	je     800515 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80050a:	83 ec 0c             	sub    $0xc,%esp
  80050d:	56                   	push   %esi
  80050e:	ff d0                	call   *%eax
  800510:	89 c3                	mov    %eax,%ebx
  800512:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	56                   	push   %esi
  800519:	6a 00                	push   $0x0
  80051b:	e8 cf fc ff ff       	call   8001ef <sys_page_unmap>
	return r;
  800520:	83 c4 10             	add    $0x10,%esp
  800523:	eb b5                	jmp    8004da <fd_close+0x3c>

00800525 <close>:

int
close(int fdnum)
{
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80052b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80052e:	50                   	push   %eax
  80052f:	ff 75 08             	pushl  0x8(%ebp)
  800532:	e8 bc fe ff ff       	call   8003f3 <fd_lookup>
  800537:	83 c4 10             	add    $0x10,%esp
  80053a:	85 c0                	test   %eax,%eax
  80053c:	79 02                	jns    800540 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    
		return fd_close(fd, 1);
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	6a 01                	push   $0x1
  800545:	ff 75 f4             	pushl  -0xc(%ebp)
  800548:	e8 51 ff ff ff       	call   80049e <fd_close>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	eb ec                	jmp    80053e <close+0x19>

00800552 <close_all>:

void
close_all(void)
{
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	53                   	push   %ebx
  800556:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800559:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80055e:	83 ec 0c             	sub    $0xc,%esp
  800561:	53                   	push   %ebx
  800562:	e8 be ff ff ff       	call   800525 <close>
	for (i = 0; i < MAXFD; i++)
  800567:	83 c3 01             	add    $0x1,%ebx
  80056a:	83 c4 10             	add    $0x10,%esp
  80056d:	83 fb 20             	cmp    $0x20,%ebx
  800570:	75 ec                	jne    80055e <close_all+0xc>
}
  800572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	57                   	push   %edi
  80057b:	56                   	push   %esi
  80057c:	53                   	push   %ebx
  80057d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800580:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800583:	50                   	push   %eax
  800584:	ff 75 08             	pushl  0x8(%ebp)
  800587:	e8 67 fe ff ff       	call   8003f3 <fd_lookup>
  80058c:	89 c3                	mov    %eax,%ebx
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	85 c0                	test   %eax,%eax
  800593:	0f 88 81 00 00 00    	js     80061a <dup+0xa3>
		return r;
	close(newfdnum);
  800599:	83 ec 0c             	sub    $0xc,%esp
  80059c:	ff 75 0c             	pushl  0xc(%ebp)
  80059f:	e8 81 ff ff ff       	call   800525 <close>

	newfd = INDEX2FD(newfdnum);
  8005a4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005a7:	c1 e6 0c             	shl    $0xc,%esi
  8005aa:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005b0:	83 c4 04             	add    $0x4,%esp
  8005b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005b6:	e8 cf fd ff ff       	call   80038a <fd2data>
  8005bb:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005bd:	89 34 24             	mov    %esi,(%esp)
  8005c0:	e8 c5 fd ff ff       	call   80038a <fd2data>
  8005c5:	83 c4 10             	add    $0x10,%esp
  8005c8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005ca:	89 d8                	mov    %ebx,%eax
  8005cc:	c1 e8 16             	shr    $0x16,%eax
  8005cf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005d6:	a8 01                	test   $0x1,%al
  8005d8:	74 11                	je     8005eb <dup+0x74>
  8005da:	89 d8                	mov    %ebx,%eax
  8005dc:	c1 e8 0c             	shr    $0xc,%eax
  8005df:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005e6:	f6 c2 01             	test   $0x1,%dl
  8005e9:	75 39                	jne    800624 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ee:	89 d0                	mov    %edx,%eax
  8005f0:	c1 e8 0c             	shr    $0xc,%eax
  8005f3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005fa:	83 ec 0c             	sub    $0xc,%esp
  8005fd:	25 07 0e 00 00       	and    $0xe07,%eax
  800602:	50                   	push   %eax
  800603:	56                   	push   %esi
  800604:	6a 00                	push   $0x0
  800606:	52                   	push   %edx
  800607:	6a 00                	push   $0x0
  800609:	e8 9f fb ff ff       	call   8001ad <sys_page_map>
  80060e:	89 c3                	mov    %eax,%ebx
  800610:	83 c4 20             	add    $0x20,%esp
  800613:	85 c0                	test   %eax,%eax
  800615:	78 31                	js     800648 <dup+0xd1>
		goto err;

	return newfdnum;
  800617:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80061a:	89 d8                	mov    %ebx,%eax
  80061c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80061f:	5b                   	pop    %ebx
  800620:	5e                   	pop    %esi
  800621:	5f                   	pop    %edi
  800622:	5d                   	pop    %ebp
  800623:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800624:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80062b:	83 ec 0c             	sub    $0xc,%esp
  80062e:	25 07 0e 00 00       	and    $0xe07,%eax
  800633:	50                   	push   %eax
  800634:	57                   	push   %edi
  800635:	6a 00                	push   $0x0
  800637:	53                   	push   %ebx
  800638:	6a 00                	push   $0x0
  80063a:	e8 6e fb ff ff       	call   8001ad <sys_page_map>
  80063f:	89 c3                	mov    %eax,%ebx
  800641:	83 c4 20             	add    $0x20,%esp
  800644:	85 c0                	test   %eax,%eax
  800646:	79 a3                	jns    8005eb <dup+0x74>
	sys_page_unmap(0, newfd);
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	56                   	push   %esi
  80064c:	6a 00                	push   $0x0
  80064e:	e8 9c fb ff ff       	call   8001ef <sys_page_unmap>
	sys_page_unmap(0, nva);
  800653:	83 c4 08             	add    $0x8,%esp
  800656:	57                   	push   %edi
  800657:	6a 00                	push   $0x0
  800659:	e8 91 fb ff ff       	call   8001ef <sys_page_unmap>
	return r;
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	eb b7                	jmp    80061a <dup+0xa3>

00800663 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800663:	55                   	push   %ebp
  800664:	89 e5                	mov    %esp,%ebp
  800666:	53                   	push   %ebx
  800667:	83 ec 1c             	sub    $0x1c,%esp
  80066a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80066d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800670:	50                   	push   %eax
  800671:	53                   	push   %ebx
  800672:	e8 7c fd ff ff       	call   8003f3 <fd_lookup>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	85 c0                	test   %eax,%eax
  80067c:	78 3f                	js     8006bd <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80067e:	83 ec 08             	sub    $0x8,%esp
  800681:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800684:	50                   	push   %eax
  800685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800688:	ff 30                	pushl  (%eax)
  80068a:	e8 b4 fd ff ff       	call   800443 <dev_lookup>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	85 c0                	test   %eax,%eax
  800694:	78 27                	js     8006bd <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800696:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800699:	8b 42 08             	mov    0x8(%edx),%eax
  80069c:	83 e0 03             	and    $0x3,%eax
  80069f:	83 f8 01             	cmp    $0x1,%eax
  8006a2:	74 1e                	je     8006c2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a7:	8b 40 08             	mov    0x8(%eax),%eax
  8006aa:	85 c0                	test   %eax,%eax
  8006ac:	74 35                	je     8006e3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006ae:	83 ec 04             	sub    $0x4,%esp
  8006b1:	ff 75 10             	pushl  0x10(%ebp)
  8006b4:	ff 75 0c             	pushl  0xc(%ebp)
  8006b7:	52                   	push   %edx
  8006b8:	ff d0                	call   *%eax
  8006ba:	83 c4 10             	add    $0x10,%esp
}
  8006bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006c0:	c9                   	leave  
  8006c1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006c2:	a1 08 40 80 00       	mov    0x804008,%eax
  8006c7:	8b 40 48             	mov    0x48(%eax),%eax
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	53                   	push   %ebx
  8006ce:	50                   	push   %eax
  8006cf:	68 05 23 80 00       	push   $0x802305
  8006d4:	e8 df 0e 00 00       	call   8015b8 <cprintf>
		return -E_INVAL;
  8006d9:	83 c4 10             	add    $0x10,%esp
  8006dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006e1:	eb da                	jmp    8006bd <read+0x5a>
		return -E_NOT_SUPP;
  8006e3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006e8:	eb d3                	jmp    8006bd <read+0x5a>

008006ea <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006ea:	55                   	push   %ebp
  8006eb:	89 e5                	mov    %esp,%ebp
  8006ed:	57                   	push   %edi
  8006ee:	56                   	push   %esi
  8006ef:	53                   	push   %ebx
  8006f0:	83 ec 0c             	sub    $0xc,%esp
  8006f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006f6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006fe:	39 f3                	cmp    %esi,%ebx
  800700:	73 23                	jae    800725 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800702:	83 ec 04             	sub    $0x4,%esp
  800705:	89 f0                	mov    %esi,%eax
  800707:	29 d8                	sub    %ebx,%eax
  800709:	50                   	push   %eax
  80070a:	89 d8                	mov    %ebx,%eax
  80070c:	03 45 0c             	add    0xc(%ebp),%eax
  80070f:	50                   	push   %eax
  800710:	57                   	push   %edi
  800711:	e8 4d ff ff ff       	call   800663 <read>
		if (m < 0)
  800716:	83 c4 10             	add    $0x10,%esp
  800719:	85 c0                	test   %eax,%eax
  80071b:	78 06                	js     800723 <readn+0x39>
			return m;
		if (m == 0)
  80071d:	74 06                	je     800725 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80071f:	01 c3                	add    %eax,%ebx
  800721:	eb db                	jmp    8006fe <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800723:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800725:	89 d8                	mov    %ebx,%eax
  800727:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80072a:	5b                   	pop    %ebx
  80072b:	5e                   	pop    %esi
  80072c:	5f                   	pop    %edi
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    

0080072f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	53                   	push   %ebx
  800733:	83 ec 1c             	sub    $0x1c,%esp
  800736:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800739:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80073c:	50                   	push   %eax
  80073d:	53                   	push   %ebx
  80073e:	e8 b0 fc ff ff       	call   8003f3 <fd_lookup>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	85 c0                	test   %eax,%eax
  800748:	78 3a                	js     800784 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800750:	50                   	push   %eax
  800751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800754:	ff 30                	pushl  (%eax)
  800756:	e8 e8 fc ff ff       	call   800443 <dev_lookup>
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	85 c0                	test   %eax,%eax
  800760:	78 22                	js     800784 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800765:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800769:	74 1e                	je     800789 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80076b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076e:	8b 52 0c             	mov    0xc(%edx),%edx
  800771:	85 d2                	test   %edx,%edx
  800773:	74 35                	je     8007aa <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800775:	83 ec 04             	sub    $0x4,%esp
  800778:	ff 75 10             	pushl  0x10(%ebp)
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	50                   	push   %eax
  80077f:	ff d2                	call   *%edx
  800781:	83 c4 10             	add    $0x10,%esp
}
  800784:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800787:	c9                   	leave  
  800788:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800789:	a1 08 40 80 00       	mov    0x804008,%eax
  80078e:	8b 40 48             	mov    0x48(%eax),%eax
  800791:	83 ec 04             	sub    $0x4,%esp
  800794:	53                   	push   %ebx
  800795:	50                   	push   %eax
  800796:	68 21 23 80 00       	push   $0x802321
  80079b:	e8 18 0e 00 00       	call   8015b8 <cprintf>
		return -E_INVAL;
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a8:	eb da                	jmp    800784 <write+0x55>
		return -E_NOT_SUPP;
  8007aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007af:	eb d3                	jmp    800784 <write+0x55>

008007b1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007b1:	55                   	push   %ebp
  8007b2:	89 e5                	mov    %esp,%ebp
  8007b4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007ba:	50                   	push   %eax
  8007bb:	ff 75 08             	pushl  0x8(%ebp)
  8007be:	e8 30 fc ff ff       	call   8003f3 <fd_lookup>
  8007c3:	83 c4 10             	add    $0x10,%esp
  8007c6:	85 c0                	test   %eax,%eax
  8007c8:	78 0e                	js     8007d8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007d8:	c9                   	leave  
  8007d9:	c3                   	ret    

008007da <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	53                   	push   %ebx
  8007de:	83 ec 1c             	sub    $0x1c,%esp
  8007e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007e7:	50                   	push   %eax
  8007e8:	53                   	push   %ebx
  8007e9:	e8 05 fc ff ff       	call   8003f3 <fd_lookup>
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	85 c0                	test   %eax,%eax
  8007f3:	78 37                	js     80082c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007fb:	50                   	push   %eax
  8007fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ff:	ff 30                	pushl  (%eax)
  800801:	e8 3d fc ff ff       	call   800443 <dev_lookup>
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	85 c0                	test   %eax,%eax
  80080b:	78 1f                	js     80082c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80080d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800810:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800814:	74 1b                	je     800831 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800816:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800819:	8b 52 18             	mov    0x18(%edx),%edx
  80081c:	85 d2                	test   %edx,%edx
  80081e:	74 32                	je     800852 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	50                   	push   %eax
  800827:	ff d2                	call   *%edx
  800829:	83 c4 10             	add    $0x10,%esp
}
  80082c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082f:	c9                   	leave  
  800830:	c3                   	ret    
			thisenv->env_id, fdnum);
  800831:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800836:	8b 40 48             	mov    0x48(%eax),%eax
  800839:	83 ec 04             	sub    $0x4,%esp
  80083c:	53                   	push   %ebx
  80083d:	50                   	push   %eax
  80083e:	68 e4 22 80 00       	push   $0x8022e4
  800843:	e8 70 0d 00 00       	call   8015b8 <cprintf>
		return -E_INVAL;
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800850:	eb da                	jmp    80082c <ftruncate+0x52>
		return -E_NOT_SUPP;
  800852:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800857:	eb d3                	jmp    80082c <ftruncate+0x52>

00800859 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	53                   	push   %ebx
  80085d:	83 ec 1c             	sub    $0x1c,%esp
  800860:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800863:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800866:	50                   	push   %eax
  800867:	ff 75 08             	pushl  0x8(%ebp)
  80086a:	e8 84 fb ff ff       	call   8003f3 <fd_lookup>
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	85 c0                	test   %eax,%eax
  800874:	78 4b                	js     8008c1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80087c:	50                   	push   %eax
  80087d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800880:	ff 30                	pushl  (%eax)
  800882:	e8 bc fb ff ff       	call   800443 <dev_lookup>
  800887:	83 c4 10             	add    $0x10,%esp
  80088a:	85 c0                	test   %eax,%eax
  80088c:	78 33                	js     8008c1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80088e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800891:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800895:	74 2f                	je     8008c6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800897:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80089a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008a1:	00 00 00 
	stat->st_isdir = 0;
  8008a4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008ab:	00 00 00 
	stat->st_dev = dev;
  8008ae:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	53                   	push   %ebx
  8008b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8008bb:	ff 50 14             	call   *0x14(%eax)
  8008be:	83 c4 10             	add    $0x10,%esp
}
  8008c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c4:	c9                   	leave  
  8008c5:	c3                   	ret    
		return -E_NOT_SUPP;
  8008c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008cb:	eb f4                	jmp    8008c1 <fstat+0x68>

008008cd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	56                   	push   %esi
  8008d1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	6a 00                	push   $0x0
  8008d7:	ff 75 08             	pushl  0x8(%ebp)
  8008da:	e8 2f 02 00 00       	call   800b0e <open>
  8008df:	89 c3                	mov    %eax,%ebx
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	85 c0                	test   %eax,%eax
  8008e6:	78 1b                	js     800903 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	50                   	push   %eax
  8008ef:	e8 65 ff ff ff       	call   800859 <fstat>
  8008f4:	89 c6                	mov    %eax,%esi
	close(fd);
  8008f6:	89 1c 24             	mov    %ebx,(%esp)
  8008f9:	e8 27 fc ff ff       	call   800525 <close>
	return r;
  8008fe:	83 c4 10             	add    $0x10,%esp
  800901:	89 f3                	mov    %esi,%ebx
}
  800903:	89 d8                	mov    %ebx,%eax
  800905:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800908:	5b                   	pop    %ebx
  800909:	5e                   	pop    %esi
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	56                   	push   %esi
  800910:	53                   	push   %ebx
  800911:	89 c6                	mov    %eax,%esi
  800913:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800915:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80091c:	74 27                	je     800945 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80091e:	6a 07                	push   $0x7
  800920:	68 00 50 80 00       	push   $0x805000
  800925:	56                   	push   %esi
  800926:	ff 35 00 40 80 00    	pushl  0x804000
  80092c:	e8 0c 16 00 00       	call   801f3d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800931:	83 c4 0c             	add    $0xc,%esp
  800934:	6a 00                	push   $0x0
  800936:	53                   	push   %ebx
  800937:	6a 00                	push   $0x0
  800939:	e8 8c 15 00 00       	call   801eca <ipc_recv>
}
  80093e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800941:	5b                   	pop    %ebx
  800942:	5e                   	pop    %esi
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800945:	83 ec 0c             	sub    $0xc,%esp
  800948:	6a 01                	push   $0x1
  80094a:	e8 5a 16 00 00       	call   801fa9 <ipc_find_env>
  80094f:	a3 00 40 80 00       	mov    %eax,0x804000
  800954:	83 c4 10             	add    $0x10,%esp
  800957:	eb c5                	jmp    80091e <fsipc+0x12>

00800959 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 40 0c             	mov    0xc(%eax),%eax
  800965:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80096a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
  800977:	b8 02 00 00 00       	mov    $0x2,%eax
  80097c:	e8 8b ff ff ff       	call   80090c <fsipc>
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <devfile_flush>:
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 40 0c             	mov    0xc(%eax),%eax
  80098f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800994:	ba 00 00 00 00       	mov    $0x0,%edx
  800999:	b8 06 00 00 00       	mov    $0x6,%eax
  80099e:	e8 69 ff ff ff       	call   80090c <fsipc>
}
  8009a3:	c9                   	leave  
  8009a4:	c3                   	ret    

008009a5 <devfile_stat>:
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	53                   	push   %ebx
  8009a9:	83 ec 04             	sub    $0x4,%esp
  8009ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8009b5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8009c4:	e8 43 ff ff ff       	call   80090c <fsipc>
  8009c9:	85 c0                	test   %eax,%eax
  8009cb:	78 2c                	js     8009f9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	68 00 50 80 00       	push   $0x805000
  8009d5:	53                   	push   %ebx
  8009d6:	e8 b9 11 00 00       	call   801b94 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009db:	a1 80 50 80 00       	mov    0x805080,%eax
  8009e0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009e6:	a1 84 50 80 00       	mov    0x805084,%eax
  8009eb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009f1:	83 c4 10             	add    $0x10,%esp
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <devfile_write>:
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	53                   	push   %ebx
  800a02:	83 ec 04             	sub    $0x4,%esp
  800a05:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  800a08:	85 db                	test   %ebx,%ebx
  800a0a:	75 07                	jne    800a13 <devfile_write+0x15>
	return n_all;
  800a0c:	89 d8                	mov    %ebx,%eax
}
  800a0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a11:	c9                   	leave  
  800a12:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8b 40 0c             	mov    0xc(%eax),%eax
  800a19:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  800a1e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  800a24:	83 ec 04             	sub    $0x4,%esp
  800a27:	53                   	push   %ebx
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	68 08 50 80 00       	push   $0x805008
  800a30:	e8 ed 12 00 00       	call   801d22 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a35:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3a:	b8 04 00 00 00       	mov    $0x4,%eax
  800a3f:	e8 c8 fe ff ff       	call   80090c <fsipc>
  800a44:	83 c4 10             	add    $0x10,%esp
  800a47:	85 c0                	test   %eax,%eax
  800a49:	78 c3                	js     800a0e <devfile_write+0x10>
	  assert(r <= n_left);
  800a4b:	39 d8                	cmp    %ebx,%eax
  800a4d:	77 0b                	ja     800a5a <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  800a4f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a54:	7f 1d                	jg     800a73 <devfile_write+0x75>
    n_all += r;
  800a56:	89 c3                	mov    %eax,%ebx
  800a58:	eb b2                	jmp    800a0c <devfile_write+0xe>
	  assert(r <= n_left);
  800a5a:	68 54 23 80 00       	push   $0x802354
  800a5f:	68 60 23 80 00       	push   $0x802360
  800a64:	68 9f 00 00 00       	push   $0x9f
  800a69:	68 75 23 80 00       	push   $0x802375
  800a6e:	e8 6a 0a 00 00       	call   8014dd <_panic>
	  assert(r <= PGSIZE);
  800a73:	68 80 23 80 00       	push   $0x802380
  800a78:	68 60 23 80 00       	push   $0x802360
  800a7d:	68 a0 00 00 00       	push   $0xa0
  800a82:	68 75 23 80 00       	push   $0x802375
  800a87:	e8 51 0a 00 00       	call   8014dd <_panic>

00800a8c <devfile_read>:
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	56                   	push   %esi
  800a90:	53                   	push   %ebx
  800a91:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8b 40 0c             	mov    0xc(%eax),%eax
  800a9a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a9f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800aa5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aaa:	b8 03 00 00 00       	mov    $0x3,%eax
  800aaf:	e8 58 fe ff ff       	call   80090c <fsipc>
  800ab4:	89 c3                	mov    %eax,%ebx
  800ab6:	85 c0                	test   %eax,%eax
  800ab8:	78 1f                	js     800ad9 <devfile_read+0x4d>
	assert(r <= n);
  800aba:	39 f0                	cmp    %esi,%eax
  800abc:	77 24                	ja     800ae2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800abe:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ac3:	7f 33                	jg     800af8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ac5:	83 ec 04             	sub    $0x4,%esp
  800ac8:	50                   	push   %eax
  800ac9:	68 00 50 80 00       	push   $0x805000
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	e8 4c 12 00 00       	call   801d22 <memmove>
	return r;
  800ad6:	83 c4 10             	add    $0x10,%esp
}
  800ad9:	89 d8                	mov    %ebx,%eax
  800adb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ade:	5b                   	pop    %ebx
  800adf:	5e                   	pop    %esi
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    
	assert(r <= n);
  800ae2:	68 8c 23 80 00       	push   $0x80238c
  800ae7:	68 60 23 80 00       	push   $0x802360
  800aec:	6a 7c                	push   $0x7c
  800aee:	68 75 23 80 00       	push   $0x802375
  800af3:	e8 e5 09 00 00       	call   8014dd <_panic>
	assert(r <= PGSIZE);
  800af8:	68 80 23 80 00       	push   $0x802380
  800afd:	68 60 23 80 00       	push   $0x802360
  800b02:	6a 7d                	push   $0x7d
  800b04:	68 75 23 80 00       	push   $0x802375
  800b09:	e8 cf 09 00 00       	call   8014dd <_panic>

00800b0e <open>:
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	56                   	push   %esi
  800b12:	53                   	push   %ebx
  800b13:	83 ec 1c             	sub    $0x1c,%esp
  800b16:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b19:	56                   	push   %esi
  800b1a:	e8 3c 10 00 00       	call   801b5b <strlen>
  800b1f:	83 c4 10             	add    $0x10,%esp
  800b22:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b27:	7f 6c                	jg     800b95 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b29:	83 ec 0c             	sub    $0xc,%esp
  800b2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b2f:	50                   	push   %eax
  800b30:	e8 6c f8 ff ff       	call   8003a1 <fd_alloc>
  800b35:	89 c3                	mov    %eax,%ebx
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	85 c0                	test   %eax,%eax
  800b3c:	78 3c                	js     800b7a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	56                   	push   %esi
  800b42:	68 00 50 80 00       	push   $0x805000
  800b47:	e8 48 10 00 00       	call   801b94 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b57:	b8 01 00 00 00       	mov    $0x1,%eax
  800b5c:	e8 ab fd ff ff       	call   80090c <fsipc>
  800b61:	89 c3                	mov    %eax,%ebx
  800b63:	83 c4 10             	add    $0x10,%esp
  800b66:	85 c0                	test   %eax,%eax
  800b68:	78 19                	js     800b83 <open+0x75>
	return fd2num(fd);
  800b6a:	83 ec 0c             	sub    $0xc,%esp
  800b6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b70:	e8 05 f8 ff ff       	call   80037a <fd2num>
  800b75:	89 c3                	mov    %eax,%ebx
  800b77:	83 c4 10             	add    $0x10,%esp
}
  800b7a:	89 d8                	mov    %ebx,%eax
  800b7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    
		fd_close(fd, 0);
  800b83:	83 ec 08             	sub    $0x8,%esp
  800b86:	6a 00                	push   $0x0
  800b88:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8b:	e8 0e f9 ff ff       	call   80049e <fd_close>
		return r;
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	eb e5                	jmp    800b7a <open+0x6c>
		return -E_BAD_PATH;
  800b95:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b9a:	eb de                	jmp    800b7a <open+0x6c>

00800b9c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba7:	b8 08 00 00 00       	mov    $0x8,%eax
  800bac:	e8 5b fd ff ff       	call   80090c <fsipc>
}
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	56                   	push   %esi
  800bb7:	53                   	push   %ebx
  800bb8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bbb:	83 ec 0c             	sub    $0xc,%esp
  800bbe:	ff 75 08             	pushl  0x8(%ebp)
  800bc1:	e8 c4 f7 ff ff       	call   80038a <fd2data>
  800bc6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bc8:	83 c4 08             	add    $0x8,%esp
  800bcb:	68 93 23 80 00       	push   $0x802393
  800bd0:	53                   	push   %ebx
  800bd1:	e8 be 0f 00 00       	call   801b94 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bd6:	8b 46 04             	mov    0x4(%esi),%eax
  800bd9:	2b 06                	sub    (%esi),%eax
  800bdb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800be1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800be8:	00 00 00 
	stat->st_dev = &devpipe;
  800beb:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  800bf2:	30 80 00 
	return 0;
}
  800bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bfd:	5b                   	pop    %ebx
  800bfe:	5e                   	pop    %esi
  800bff:	5d                   	pop    %ebp
  800c00:	c3                   	ret    

00800c01 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	53                   	push   %ebx
  800c05:	83 ec 0c             	sub    $0xc,%esp
  800c08:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c0b:	53                   	push   %ebx
  800c0c:	6a 00                	push   $0x0
  800c0e:	e8 dc f5 ff ff       	call   8001ef <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c13:	89 1c 24             	mov    %ebx,(%esp)
  800c16:	e8 6f f7 ff ff       	call   80038a <fd2data>
  800c1b:	83 c4 08             	add    $0x8,%esp
  800c1e:	50                   	push   %eax
  800c1f:	6a 00                	push   $0x0
  800c21:	e8 c9 f5 ff ff       	call   8001ef <sys_page_unmap>
}
  800c26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c29:	c9                   	leave  
  800c2a:	c3                   	ret    

00800c2b <_pipeisclosed>:
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
  800c31:	83 ec 1c             	sub    $0x1c,%esp
  800c34:	89 c7                	mov    %eax,%edi
  800c36:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c38:	a1 08 40 80 00       	mov    0x804008,%eax
  800c3d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c40:	83 ec 0c             	sub    $0xc,%esp
  800c43:	57                   	push   %edi
  800c44:	e8 99 13 00 00       	call   801fe2 <pageref>
  800c49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c4c:	89 34 24             	mov    %esi,(%esp)
  800c4f:	e8 8e 13 00 00       	call   801fe2 <pageref>
		nn = thisenv->env_runs;
  800c54:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c5a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c5d:	83 c4 10             	add    $0x10,%esp
  800c60:	39 cb                	cmp    %ecx,%ebx
  800c62:	74 1b                	je     800c7f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c64:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c67:	75 cf                	jne    800c38 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c69:	8b 42 58             	mov    0x58(%edx),%eax
  800c6c:	6a 01                	push   $0x1
  800c6e:	50                   	push   %eax
  800c6f:	53                   	push   %ebx
  800c70:	68 9a 23 80 00       	push   $0x80239a
  800c75:	e8 3e 09 00 00       	call   8015b8 <cprintf>
  800c7a:	83 c4 10             	add    $0x10,%esp
  800c7d:	eb b9                	jmp    800c38 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c7f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c82:	0f 94 c0             	sete   %al
  800c85:	0f b6 c0             	movzbl %al,%eax
}
  800c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8b:	5b                   	pop    %ebx
  800c8c:	5e                   	pop    %esi
  800c8d:	5f                   	pop    %edi
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <devpipe_write>:
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	57                   	push   %edi
  800c94:	56                   	push   %esi
  800c95:	53                   	push   %ebx
  800c96:	83 ec 28             	sub    $0x28,%esp
  800c99:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c9c:	56                   	push   %esi
  800c9d:	e8 e8 f6 ff ff       	call   80038a <fd2data>
  800ca2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800ca4:	83 c4 10             	add    $0x10,%esp
  800ca7:	bf 00 00 00 00       	mov    $0x0,%edi
  800cac:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800caf:	74 4f                	je     800d00 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800cb1:	8b 43 04             	mov    0x4(%ebx),%eax
  800cb4:	8b 0b                	mov    (%ebx),%ecx
  800cb6:	8d 51 20             	lea    0x20(%ecx),%edx
  800cb9:	39 d0                	cmp    %edx,%eax
  800cbb:	72 14                	jb     800cd1 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800cbd:	89 da                	mov    %ebx,%edx
  800cbf:	89 f0                	mov    %esi,%eax
  800cc1:	e8 65 ff ff ff       	call   800c2b <_pipeisclosed>
  800cc6:	85 c0                	test   %eax,%eax
  800cc8:	75 3b                	jne    800d05 <devpipe_write+0x75>
			sys_yield();
  800cca:	e8 7c f4 ff ff       	call   80014b <sys_yield>
  800ccf:	eb e0                	jmp    800cb1 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cd8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cdb:	89 c2                	mov    %eax,%edx
  800cdd:	c1 fa 1f             	sar    $0x1f,%edx
  800ce0:	89 d1                	mov    %edx,%ecx
  800ce2:	c1 e9 1b             	shr    $0x1b,%ecx
  800ce5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800ce8:	83 e2 1f             	and    $0x1f,%edx
  800ceb:	29 ca                	sub    %ecx,%edx
  800ced:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cf1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cf5:	83 c0 01             	add    $0x1,%eax
  800cf8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800cfb:	83 c7 01             	add    $0x1,%edi
  800cfe:	eb ac                	jmp    800cac <devpipe_write+0x1c>
	return i;
  800d00:	8b 45 10             	mov    0x10(%ebp),%eax
  800d03:	eb 05                	jmp    800d0a <devpipe_write+0x7a>
				return 0;
  800d05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <devpipe_read>:
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	57                   	push   %edi
  800d16:	56                   	push   %esi
  800d17:	53                   	push   %ebx
  800d18:	83 ec 18             	sub    $0x18,%esp
  800d1b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d1e:	57                   	push   %edi
  800d1f:	e8 66 f6 ff ff       	call   80038a <fd2data>
  800d24:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d26:	83 c4 10             	add    $0x10,%esp
  800d29:	be 00 00 00 00       	mov    $0x0,%esi
  800d2e:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d31:	75 14                	jne    800d47 <devpipe_read+0x35>
	return i;
  800d33:	8b 45 10             	mov    0x10(%ebp),%eax
  800d36:	eb 02                	jmp    800d3a <devpipe_read+0x28>
				return i;
  800d38:	89 f0                	mov    %esi,%eax
}
  800d3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5f                   	pop    %edi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    
			sys_yield();
  800d42:	e8 04 f4 ff ff       	call   80014b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d47:	8b 03                	mov    (%ebx),%eax
  800d49:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d4c:	75 18                	jne    800d66 <devpipe_read+0x54>
			if (i > 0)
  800d4e:	85 f6                	test   %esi,%esi
  800d50:	75 e6                	jne    800d38 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  800d52:	89 da                	mov    %ebx,%edx
  800d54:	89 f8                	mov    %edi,%eax
  800d56:	e8 d0 fe ff ff       	call   800c2b <_pipeisclosed>
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	74 e3                	je     800d42 <devpipe_read+0x30>
				return 0;
  800d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d64:	eb d4                	jmp    800d3a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d66:	99                   	cltd   
  800d67:	c1 ea 1b             	shr    $0x1b,%edx
  800d6a:	01 d0                	add    %edx,%eax
  800d6c:	83 e0 1f             	and    $0x1f,%eax
  800d6f:	29 d0                	sub    %edx,%eax
  800d71:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d7c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d7f:	83 c6 01             	add    $0x1,%esi
  800d82:	eb aa                	jmp    800d2e <devpipe_read+0x1c>

00800d84 <pipe>:
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
  800d89:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d8f:	50                   	push   %eax
  800d90:	e8 0c f6 ff ff       	call   8003a1 <fd_alloc>
  800d95:	89 c3                	mov    %eax,%ebx
  800d97:	83 c4 10             	add    $0x10,%esp
  800d9a:	85 c0                	test   %eax,%eax
  800d9c:	0f 88 23 01 00 00    	js     800ec5 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800da2:	83 ec 04             	sub    $0x4,%esp
  800da5:	68 07 04 00 00       	push   $0x407
  800daa:	ff 75 f4             	pushl  -0xc(%ebp)
  800dad:	6a 00                	push   $0x0
  800daf:	e8 b6 f3 ff ff       	call   80016a <sys_page_alloc>
  800db4:	89 c3                	mov    %eax,%ebx
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	0f 88 04 01 00 00    	js     800ec5 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  800dc1:	83 ec 0c             	sub    $0xc,%esp
  800dc4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dc7:	50                   	push   %eax
  800dc8:	e8 d4 f5 ff ff       	call   8003a1 <fd_alloc>
  800dcd:	89 c3                	mov    %eax,%ebx
  800dcf:	83 c4 10             	add    $0x10,%esp
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	0f 88 db 00 00 00    	js     800eb5 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dda:	83 ec 04             	sub    $0x4,%esp
  800ddd:	68 07 04 00 00       	push   $0x407
  800de2:	ff 75 f0             	pushl  -0x10(%ebp)
  800de5:	6a 00                	push   $0x0
  800de7:	e8 7e f3 ff ff       	call   80016a <sys_page_alloc>
  800dec:	89 c3                	mov    %eax,%ebx
  800dee:	83 c4 10             	add    $0x10,%esp
  800df1:	85 c0                	test   %eax,%eax
  800df3:	0f 88 bc 00 00 00    	js     800eb5 <pipe+0x131>
	va = fd2data(fd0);
  800df9:	83 ec 0c             	sub    $0xc,%esp
  800dfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800dff:	e8 86 f5 ff ff       	call   80038a <fd2data>
  800e04:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e06:	83 c4 0c             	add    $0xc,%esp
  800e09:	68 07 04 00 00       	push   $0x407
  800e0e:	50                   	push   %eax
  800e0f:	6a 00                	push   $0x0
  800e11:	e8 54 f3 ff ff       	call   80016a <sys_page_alloc>
  800e16:	89 c3                	mov    %eax,%ebx
  800e18:	83 c4 10             	add    $0x10,%esp
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	0f 88 82 00 00 00    	js     800ea5 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e23:	83 ec 0c             	sub    $0xc,%esp
  800e26:	ff 75 f0             	pushl  -0x10(%ebp)
  800e29:	e8 5c f5 ff ff       	call   80038a <fd2data>
  800e2e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e35:	50                   	push   %eax
  800e36:	6a 00                	push   $0x0
  800e38:	56                   	push   %esi
  800e39:	6a 00                	push   $0x0
  800e3b:	e8 6d f3 ff ff       	call   8001ad <sys_page_map>
  800e40:	89 c3                	mov    %eax,%ebx
  800e42:	83 c4 20             	add    $0x20,%esp
  800e45:	85 c0                	test   %eax,%eax
  800e47:	78 4e                	js     800e97 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  800e49:	a1 24 30 80 00       	mov    0x803024,%eax
  800e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e51:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e56:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e60:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e65:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e6c:	83 ec 0c             	sub    $0xc,%esp
  800e6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e72:	e8 03 f5 ff ff       	call   80037a <fd2num>
  800e77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e7a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e7c:	83 c4 04             	add    $0x4,%esp
  800e7f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e82:	e8 f3 f4 ff ff       	call   80037a <fd2num>
  800e87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e8d:	83 c4 10             	add    $0x10,%esp
  800e90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e95:	eb 2e                	jmp    800ec5 <pipe+0x141>
	sys_page_unmap(0, va);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	56                   	push   %esi
  800e9b:	6a 00                	push   $0x0
  800e9d:	e8 4d f3 ff ff       	call   8001ef <sys_page_unmap>
  800ea2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ea5:	83 ec 08             	sub    $0x8,%esp
  800ea8:	ff 75 f0             	pushl  -0x10(%ebp)
  800eab:	6a 00                	push   $0x0
  800ead:	e8 3d f3 ff ff       	call   8001ef <sys_page_unmap>
  800eb2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	ff 75 f4             	pushl  -0xc(%ebp)
  800ebb:	6a 00                	push   $0x0
  800ebd:	e8 2d f3 ff ff       	call   8001ef <sys_page_unmap>
  800ec2:	83 c4 10             	add    $0x10,%esp
}
  800ec5:	89 d8                	mov    %ebx,%eax
  800ec7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eca:	5b                   	pop    %ebx
  800ecb:	5e                   	pop    %esi
  800ecc:	5d                   	pop    %ebp
  800ecd:	c3                   	ret    

00800ece <pipeisclosed>:
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ed4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ed7:	50                   	push   %eax
  800ed8:	ff 75 08             	pushl  0x8(%ebp)
  800edb:	e8 13 f5 ff ff       	call   8003f3 <fd_lookup>
  800ee0:	83 c4 10             	add    $0x10,%esp
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	78 18                	js     800eff <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ee7:	83 ec 0c             	sub    $0xc,%esp
  800eea:	ff 75 f4             	pushl  -0xc(%ebp)
  800eed:	e8 98 f4 ff ff       	call   80038a <fd2data>
	return _pipeisclosed(fd, p);
  800ef2:	89 c2                	mov    %eax,%edx
  800ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef7:	e8 2f fd ff ff       	call   800c2b <_pipeisclosed>
  800efc:	83 c4 10             	add    $0x10,%esp
}
  800eff:	c9                   	leave  
  800f00:	c3                   	ret    

00800f01 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800f07:	68 b2 23 80 00       	push   $0x8023b2
  800f0c:	ff 75 0c             	pushl  0xc(%ebp)
  800f0f:	e8 80 0c 00 00       	call   801b94 <strcpy>
	return 0;
}
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <devsock_close>:
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	53                   	push   %ebx
  800f1f:	83 ec 10             	sub    $0x10,%esp
  800f22:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f25:	53                   	push   %ebx
  800f26:	e8 b7 10 00 00       	call   801fe2 <pageref>
  800f2b:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f2e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f33:	83 f8 01             	cmp    $0x1,%eax
  800f36:	74 07                	je     800f3f <devsock_close+0x24>
}
  800f38:	89 d0                	mov    %edx,%eax
  800f3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f3d:	c9                   	leave  
  800f3e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f3f:	83 ec 0c             	sub    $0xc,%esp
  800f42:	ff 73 0c             	pushl  0xc(%ebx)
  800f45:	e8 b9 02 00 00       	call   801203 <nsipc_close>
  800f4a:	89 c2                	mov    %eax,%edx
  800f4c:	83 c4 10             	add    $0x10,%esp
  800f4f:	eb e7                	jmp    800f38 <devsock_close+0x1d>

00800f51 <devsock_write>:
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f57:	6a 00                	push   $0x0
  800f59:	ff 75 10             	pushl  0x10(%ebp)
  800f5c:	ff 75 0c             	pushl  0xc(%ebp)
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	ff 70 0c             	pushl  0xc(%eax)
  800f65:	e8 76 03 00 00       	call   8012e0 <nsipc_send>
}
  800f6a:	c9                   	leave  
  800f6b:	c3                   	ret    

00800f6c <devsock_read>:
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f72:	6a 00                	push   $0x0
  800f74:	ff 75 10             	pushl  0x10(%ebp)
  800f77:	ff 75 0c             	pushl  0xc(%ebp)
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	ff 70 0c             	pushl  0xc(%eax)
  800f80:	e8 ef 02 00 00       	call   801274 <nsipc_recv>
}
  800f85:	c9                   	leave  
  800f86:	c3                   	ret    

00800f87 <fd2sockid>:
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f8d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f90:	52                   	push   %edx
  800f91:	50                   	push   %eax
  800f92:	e8 5c f4 ff ff       	call   8003f3 <fd_lookup>
  800f97:	83 c4 10             	add    $0x10,%esp
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	78 10                	js     800fae <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa1:	8b 0d 40 30 80 00    	mov    0x803040,%ecx
  800fa7:	39 08                	cmp    %ecx,(%eax)
  800fa9:	75 05                	jne    800fb0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800fab:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800fae:	c9                   	leave  
  800faf:	c3                   	ret    
		return -E_NOT_SUPP;
  800fb0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800fb5:	eb f7                	jmp    800fae <fd2sockid+0x27>

00800fb7 <alloc_sockfd>:
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
  800fbc:	83 ec 1c             	sub    $0x1c,%esp
  800fbf:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fc1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 d7 f3 ff ff       	call   8003a1 <fd_alloc>
  800fca:	89 c3                	mov    %eax,%ebx
  800fcc:	83 c4 10             	add    $0x10,%esp
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	78 43                	js     801016 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fd3:	83 ec 04             	sub    $0x4,%esp
  800fd6:	68 07 04 00 00       	push   $0x407
  800fdb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fde:	6a 00                	push   $0x0
  800fe0:	e8 85 f1 ff ff       	call   80016a <sys_page_alloc>
  800fe5:	89 c3                	mov    %eax,%ebx
  800fe7:	83 c4 10             	add    $0x10,%esp
  800fea:	85 c0                	test   %eax,%eax
  800fec:	78 28                	js     801016 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff1:	8b 15 40 30 80 00    	mov    0x803040,%edx
  800ff7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801003:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801006:	83 ec 0c             	sub    $0xc,%esp
  801009:	50                   	push   %eax
  80100a:	e8 6b f3 ff ff       	call   80037a <fd2num>
  80100f:	89 c3                	mov    %eax,%ebx
  801011:	83 c4 10             	add    $0x10,%esp
  801014:	eb 0c                	jmp    801022 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801016:	83 ec 0c             	sub    $0xc,%esp
  801019:	56                   	push   %esi
  80101a:	e8 e4 01 00 00       	call   801203 <nsipc_close>
		return r;
  80101f:	83 c4 10             	add    $0x10,%esp
}
  801022:	89 d8                	mov    %ebx,%eax
  801024:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801027:	5b                   	pop    %ebx
  801028:	5e                   	pop    %esi
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <accept>:
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	e8 4e ff ff ff       	call   800f87 <fd2sockid>
  801039:	85 c0                	test   %eax,%eax
  80103b:	78 1b                	js     801058 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80103d:	83 ec 04             	sub    $0x4,%esp
  801040:	ff 75 10             	pushl  0x10(%ebp)
  801043:	ff 75 0c             	pushl  0xc(%ebp)
  801046:	50                   	push   %eax
  801047:	e8 0e 01 00 00       	call   80115a <nsipc_accept>
  80104c:	83 c4 10             	add    $0x10,%esp
  80104f:	85 c0                	test   %eax,%eax
  801051:	78 05                	js     801058 <accept+0x2d>
	return alloc_sockfd(r);
  801053:	e8 5f ff ff ff       	call   800fb7 <alloc_sockfd>
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <bind>:
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	e8 1f ff ff ff       	call   800f87 <fd2sockid>
  801068:	85 c0                	test   %eax,%eax
  80106a:	78 12                	js     80107e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80106c:	83 ec 04             	sub    $0x4,%esp
  80106f:	ff 75 10             	pushl  0x10(%ebp)
  801072:	ff 75 0c             	pushl  0xc(%ebp)
  801075:	50                   	push   %eax
  801076:	e8 31 01 00 00       	call   8011ac <nsipc_bind>
  80107b:	83 c4 10             	add    $0x10,%esp
}
  80107e:	c9                   	leave  
  80107f:	c3                   	ret    

00801080 <shutdown>:
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
  801083:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	e8 f9 fe ff ff       	call   800f87 <fd2sockid>
  80108e:	85 c0                	test   %eax,%eax
  801090:	78 0f                	js     8010a1 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801092:	83 ec 08             	sub    $0x8,%esp
  801095:	ff 75 0c             	pushl  0xc(%ebp)
  801098:	50                   	push   %eax
  801099:	e8 43 01 00 00       	call   8011e1 <nsipc_shutdown>
  80109e:	83 c4 10             	add    $0x10,%esp
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <connect>:
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	e8 d6 fe ff ff       	call   800f87 <fd2sockid>
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	78 12                	js     8010c7 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8010b5:	83 ec 04             	sub    $0x4,%esp
  8010b8:	ff 75 10             	pushl  0x10(%ebp)
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	50                   	push   %eax
  8010bf:	e8 59 01 00 00       	call   80121d <nsipc_connect>
  8010c4:	83 c4 10             	add    $0x10,%esp
}
  8010c7:	c9                   	leave  
  8010c8:	c3                   	ret    

008010c9 <listen>:
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	e8 b0 fe ff ff       	call   800f87 <fd2sockid>
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	78 0f                	js     8010ea <listen+0x21>
	return nsipc_listen(r, backlog);
  8010db:	83 ec 08             	sub    $0x8,%esp
  8010de:	ff 75 0c             	pushl  0xc(%ebp)
  8010e1:	50                   	push   %eax
  8010e2:	e8 6b 01 00 00       	call   801252 <nsipc_listen>
  8010e7:	83 c4 10             	add    $0x10,%esp
}
  8010ea:	c9                   	leave  
  8010eb:	c3                   	ret    

008010ec <socket>:

int
socket(int domain, int type, int protocol)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
  8010ef:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010f2:	ff 75 10             	pushl  0x10(%ebp)
  8010f5:	ff 75 0c             	pushl  0xc(%ebp)
  8010f8:	ff 75 08             	pushl  0x8(%ebp)
  8010fb:	e8 3e 02 00 00       	call   80133e <nsipc_socket>
  801100:	83 c4 10             	add    $0x10,%esp
  801103:	85 c0                	test   %eax,%eax
  801105:	78 05                	js     80110c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801107:	e8 ab fe ff ff       	call   800fb7 <alloc_sockfd>
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	53                   	push   %ebx
  801112:	83 ec 04             	sub    $0x4,%esp
  801115:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801117:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80111e:	74 26                	je     801146 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801120:	6a 07                	push   $0x7
  801122:	68 00 60 80 00       	push   $0x806000
  801127:	53                   	push   %ebx
  801128:	ff 35 04 40 80 00    	pushl  0x804004
  80112e:	e8 0a 0e 00 00       	call   801f3d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801133:	83 c4 0c             	add    $0xc,%esp
  801136:	6a 00                	push   $0x0
  801138:	6a 00                	push   $0x0
  80113a:	6a 00                	push   $0x0
  80113c:	e8 89 0d 00 00       	call   801eca <ipc_recv>
}
  801141:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801144:	c9                   	leave  
  801145:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801146:	83 ec 0c             	sub    $0xc,%esp
  801149:	6a 02                	push   $0x2
  80114b:	e8 59 0e 00 00       	call   801fa9 <ipc_find_env>
  801150:	a3 04 40 80 00       	mov    %eax,0x804004
  801155:	83 c4 10             	add    $0x10,%esp
  801158:	eb c6                	jmp    801120 <nsipc+0x12>

0080115a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	56                   	push   %esi
  80115e:	53                   	push   %ebx
  80115f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80116a:	8b 06                	mov    (%esi),%eax
  80116c:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801171:	b8 01 00 00 00       	mov    $0x1,%eax
  801176:	e8 93 ff ff ff       	call   80110e <nsipc>
  80117b:	89 c3                	mov    %eax,%ebx
  80117d:	85 c0                	test   %eax,%eax
  80117f:	79 09                	jns    80118a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801181:	89 d8                	mov    %ebx,%eax
  801183:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801186:	5b                   	pop    %ebx
  801187:	5e                   	pop    %esi
  801188:	5d                   	pop    %ebp
  801189:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80118a:	83 ec 04             	sub    $0x4,%esp
  80118d:	ff 35 10 60 80 00    	pushl  0x806010
  801193:	68 00 60 80 00       	push   $0x806000
  801198:	ff 75 0c             	pushl  0xc(%ebp)
  80119b:	e8 82 0b 00 00       	call   801d22 <memmove>
		*addrlen = ret->ret_addrlen;
  8011a0:	a1 10 60 80 00       	mov    0x806010,%eax
  8011a5:	89 06                	mov    %eax,(%esi)
  8011a7:	83 c4 10             	add    $0x10,%esp
	return r;
  8011aa:	eb d5                	jmp    801181 <nsipc_accept+0x27>

008011ac <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	53                   	push   %ebx
  8011b0:	83 ec 08             	sub    $0x8,%esp
  8011b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011be:	53                   	push   %ebx
  8011bf:	ff 75 0c             	pushl  0xc(%ebp)
  8011c2:	68 04 60 80 00       	push   $0x806004
  8011c7:	e8 56 0b 00 00       	call   801d22 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011cc:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011d2:	b8 02 00 00 00       	mov    $0x2,%eax
  8011d7:	e8 32 ff ff ff       	call   80110e <nsipc>
}
  8011dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011f7:	b8 03 00 00 00       	mov    $0x3,%eax
  8011fc:	e8 0d ff ff ff       	call   80110e <nsipc>
}
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <nsipc_close>:

int
nsipc_close(int s)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801211:	b8 04 00 00 00       	mov    $0x4,%eax
  801216:	e8 f3 fe ff ff       	call   80110e <nsipc>
}
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	53                   	push   %ebx
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80122f:	53                   	push   %ebx
  801230:	ff 75 0c             	pushl  0xc(%ebp)
  801233:	68 04 60 80 00       	push   $0x806004
  801238:	e8 e5 0a 00 00       	call   801d22 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80123d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801243:	b8 05 00 00 00       	mov    $0x5,%eax
  801248:	e8 c1 fe ff ff       	call   80110e <nsipc>
}
  80124d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801260:	8b 45 0c             	mov    0xc(%ebp),%eax
  801263:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801268:	b8 06 00 00 00       	mov    $0x6,%eax
  80126d:	e8 9c fe ff ff       	call   80110e <nsipc>
}
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	56                   	push   %esi
  801278:	53                   	push   %ebx
  801279:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801284:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80128a:	8b 45 14             	mov    0x14(%ebp),%eax
  80128d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801292:	b8 07 00 00 00       	mov    $0x7,%eax
  801297:	e8 72 fe ff ff       	call   80110e <nsipc>
  80129c:	89 c3                	mov    %eax,%ebx
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	78 1f                	js     8012c1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8012a2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8012a7:	7f 21                	jg     8012ca <nsipc_recv+0x56>
  8012a9:	39 c6                	cmp    %eax,%esi
  8012ab:	7c 1d                	jl     8012ca <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	50                   	push   %eax
  8012b1:	68 00 60 80 00       	push   $0x806000
  8012b6:	ff 75 0c             	pushl  0xc(%ebp)
  8012b9:	e8 64 0a 00 00       	call   801d22 <memmove>
  8012be:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012c1:	89 d8                	mov    %ebx,%eax
  8012c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012c6:	5b                   	pop    %ebx
  8012c7:	5e                   	pop    %esi
  8012c8:	5d                   	pop    %ebp
  8012c9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012ca:	68 be 23 80 00       	push   $0x8023be
  8012cf:	68 60 23 80 00       	push   $0x802360
  8012d4:	6a 62                	push   $0x62
  8012d6:	68 d3 23 80 00       	push   $0x8023d3
  8012db:	e8 fd 01 00 00       	call   8014dd <_panic>

008012e0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	53                   	push   %ebx
  8012e4:	83 ec 04             	sub    $0x4,%esp
  8012e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012f2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012f8:	7f 2e                	jg     801328 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012fa:	83 ec 04             	sub    $0x4,%esp
  8012fd:	53                   	push   %ebx
  8012fe:	ff 75 0c             	pushl  0xc(%ebp)
  801301:	68 0c 60 80 00       	push   $0x80600c
  801306:	e8 17 0a 00 00       	call   801d22 <memmove>
	nsipcbuf.send.req_size = size;
  80130b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801311:	8b 45 14             	mov    0x14(%ebp),%eax
  801314:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801319:	b8 08 00 00 00       	mov    $0x8,%eax
  80131e:	e8 eb fd ff ff       	call   80110e <nsipc>
}
  801323:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801326:	c9                   	leave  
  801327:	c3                   	ret    
	assert(size < 1600);
  801328:	68 df 23 80 00       	push   $0x8023df
  80132d:	68 60 23 80 00       	push   $0x802360
  801332:	6a 6d                	push   $0x6d
  801334:	68 d3 23 80 00       	push   $0x8023d3
  801339:	e8 9f 01 00 00       	call   8014dd <_panic>

0080133e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80134c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80135c:	b8 09 00 00 00       	mov    $0x9,%eax
  801361:	e8 a8 fd ff ff       	call   80110e <nsipc>
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801368:	b8 00 00 00 00       	mov    $0x0,%eax
  80136d:	c3                   	ret    

0080136e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801374:	68 eb 23 80 00       	push   $0x8023eb
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	e8 13 08 00 00       	call   801b94 <strcpy>
	return 0;
}
  801381:	b8 00 00 00 00       	mov    $0x0,%eax
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <devcons_write>:
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	57                   	push   %edi
  80138c:	56                   	push   %esi
  80138d:	53                   	push   %ebx
  80138e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801394:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801399:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80139f:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013a2:	73 31                	jae    8013d5 <devcons_write+0x4d>
		m = n - tot;
  8013a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013a7:	29 f3                	sub    %esi,%ebx
  8013a9:	83 fb 7f             	cmp    $0x7f,%ebx
  8013ac:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8013b1:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013b4:	83 ec 04             	sub    $0x4,%esp
  8013b7:	53                   	push   %ebx
  8013b8:	89 f0                	mov    %esi,%eax
  8013ba:	03 45 0c             	add    0xc(%ebp),%eax
  8013bd:	50                   	push   %eax
  8013be:	57                   	push   %edi
  8013bf:	e8 5e 09 00 00       	call   801d22 <memmove>
		sys_cputs(buf, m);
  8013c4:	83 c4 08             	add    $0x8,%esp
  8013c7:	53                   	push   %ebx
  8013c8:	57                   	push   %edi
  8013c9:	e8 e0 ec ff ff       	call   8000ae <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013ce:	01 de                	add    %ebx,%esi
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	eb ca                	jmp    80139f <devcons_write+0x17>
}
  8013d5:	89 f0                	mov    %esi,%eax
  8013d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013da:	5b                   	pop    %ebx
  8013db:	5e                   	pop    %esi
  8013dc:	5f                   	pop    %edi
  8013dd:	5d                   	pop    %ebp
  8013de:	c3                   	ret    

008013df <devcons_read>:
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ee:	74 21                	je     801411 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8013f0:	e8 d7 ec ff ff       	call   8000cc <sys_cgetc>
  8013f5:	85 c0                	test   %eax,%eax
  8013f7:	75 07                	jne    801400 <devcons_read+0x21>
		sys_yield();
  8013f9:	e8 4d ed ff ff       	call   80014b <sys_yield>
  8013fe:	eb f0                	jmp    8013f0 <devcons_read+0x11>
	if (c < 0)
  801400:	78 0f                	js     801411 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801402:	83 f8 04             	cmp    $0x4,%eax
  801405:	74 0c                	je     801413 <devcons_read+0x34>
	*(char*)vbuf = c;
  801407:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140a:	88 02                	mov    %al,(%edx)
	return 1;
  80140c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    
		return 0;
  801413:	b8 00 00 00 00       	mov    $0x0,%eax
  801418:	eb f7                	jmp    801411 <devcons_read+0x32>

0080141a <cputchar>:
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801426:	6a 01                	push   $0x1
  801428:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80142b:	50                   	push   %eax
  80142c:	e8 7d ec ff ff       	call   8000ae <sys_cputs>
}
  801431:	83 c4 10             	add    $0x10,%esp
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <getchar>:
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80143c:	6a 01                	push   $0x1
  80143e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801441:	50                   	push   %eax
  801442:	6a 00                	push   $0x0
  801444:	e8 1a f2 ff ff       	call   800663 <read>
	if (r < 0)
  801449:	83 c4 10             	add    $0x10,%esp
  80144c:	85 c0                	test   %eax,%eax
  80144e:	78 06                	js     801456 <getchar+0x20>
	if (r < 1)
  801450:	74 06                	je     801458 <getchar+0x22>
	return c;
  801452:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    
		return -E_EOF;
  801458:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80145d:	eb f7                	jmp    801456 <getchar+0x20>

0080145f <iscons>:
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801465:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801468:	50                   	push   %eax
  801469:	ff 75 08             	pushl  0x8(%ebp)
  80146c:	e8 82 ef ff ff       	call   8003f3 <fd_lookup>
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	85 c0                	test   %eax,%eax
  801476:	78 11                	js     801489 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147b:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  801481:	39 10                	cmp    %edx,(%eax)
  801483:	0f 94 c0             	sete   %al
  801486:	0f b6 c0             	movzbl %al,%eax
}
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <opencons>:
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801491:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801494:	50                   	push   %eax
  801495:	e8 07 ef ff ff       	call   8003a1 <fd_alloc>
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	85 c0                	test   %eax,%eax
  80149f:	78 3a                	js     8014db <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8014a1:	83 ec 04             	sub    $0x4,%esp
  8014a4:	68 07 04 00 00       	push   $0x407
  8014a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ac:	6a 00                	push   $0x0
  8014ae:	e8 b7 ec ff ff       	call   80016a <sys_page_alloc>
  8014b3:	83 c4 10             	add    $0x10,%esp
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	78 21                	js     8014db <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bd:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8014c3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014cf:	83 ec 0c             	sub    $0xc,%esp
  8014d2:	50                   	push   %eax
  8014d3:	e8 a2 ee ff ff       	call   80037a <fd2num>
  8014d8:	83 c4 10             	add    $0x10,%esp
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	56                   	push   %esi
  8014e1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014e2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014e5:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8014eb:	e8 3c ec ff ff       	call   80012c <sys_getenvid>
  8014f0:	83 ec 0c             	sub    $0xc,%esp
  8014f3:	ff 75 0c             	pushl  0xc(%ebp)
  8014f6:	ff 75 08             	pushl  0x8(%ebp)
  8014f9:	56                   	push   %esi
  8014fa:	50                   	push   %eax
  8014fb:	68 f8 23 80 00       	push   $0x8023f8
  801500:	e8 b3 00 00 00       	call   8015b8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801505:	83 c4 18             	add    $0x18,%esp
  801508:	53                   	push   %ebx
  801509:	ff 75 10             	pushl  0x10(%ebp)
  80150c:	e8 56 00 00 00       	call   801567 <vcprintf>
	cprintf("\n");
  801511:	c7 04 24 ab 23 80 00 	movl   $0x8023ab,(%esp)
  801518:	e8 9b 00 00 00       	call   8015b8 <cprintf>
  80151d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801520:	cc                   	int3   
  801521:	eb fd                	jmp    801520 <_panic+0x43>

00801523 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	53                   	push   %ebx
  801527:	83 ec 04             	sub    $0x4,%esp
  80152a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80152d:	8b 13                	mov    (%ebx),%edx
  80152f:	8d 42 01             	lea    0x1(%edx),%eax
  801532:	89 03                	mov    %eax,(%ebx)
  801534:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801537:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80153b:	3d ff 00 00 00       	cmp    $0xff,%eax
  801540:	74 09                	je     80154b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801542:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801546:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801549:	c9                   	leave  
  80154a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	68 ff 00 00 00       	push   $0xff
  801553:	8d 43 08             	lea    0x8(%ebx),%eax
  801556:	50                   	push   %eax
  801557:	e8 52 eb ff ff       	call   8000ae <sys_cputs>
		b->idx = 0;
  80155c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	eb db                	jmp    801542 <putch+0x1f>

00801567 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801570:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801577:	00 00 00 
	b.cnt = 0;
  80157a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801581:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	ff 75 08             	pushl  0x8(%ebp)
  80158a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801590:	50                   	push   %eax
  801591:	68 23 15 80 00       	push   $0x801523
  801596:	e8 19 01 00 00       	call   8016b4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80159b:	83 c4 08             	add    $0x8,%esp
  80159e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8015a4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8015aa:	50                   	push   %eax
  8015ab:	e8 fe ea ff ff       	call   8000ae <sys_cputs>

	return b.cnt;
}
  8015b0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015be:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015c1:	50                   	push   %eax
  8015c2:	ff 75 08             	pushl  0x8(%ebp)
  8015c5:	e8 9d ff ff ff       	call   801567 <vcprintf>
	va_end(ap);

	return cnt;
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	57                   	push   %edi
  8015d0:	56                   	push   %esi
  8015d1:	53                   	push   %ebx
  8015d2:	83 ec 1c             	sub    $0x1c,%esp
  8015d5:	89 c7                	mov    %eax,%edi
  8015d7:	89 d6                	mov    %edx,%esi
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015ed:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015f3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015f6:	89 d0                	mov    %edx,%eax
  8015f8:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8015fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015fe:	73 15                	jae    801615 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801600:	83 eb 01             	sub    $0x1,%ebx
  801603:	85 db                	test   %ebx,%ebx
  801605:	7e 43                	jle    80164a <printnum+0x7e>
			putch(padc, putdat);
  801607:	83 ec 08             	sub    $0x8,%esp
  80160a:	56                   	push   %esi
  80160b:	ff 75 18             	pushl  0x18(%ebp)
  80160e:	ff d7                	call   *%edi
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	eb eb                	jmp    801600 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801615:	83 ec 0c             	sub    $0xc,%esp
  801618:	ff 75 18             	pushl  0x18(%ebp)
  80161b:	8b 45 14             	mov    0x14(%ebp),%eax
  80161e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801621:	53                   	push   %ebx
  801622:	ff 75 10             	pushl  0x10(%ebp)
  801625:	83 ec 08             	sub    $0x8,%esp
  801628:	ff 75 e4             	pushl  -0x1c(%ebp)
  80162b:	ff 75 e0             	pushl  -0x20(%ebp)
  80162e:	ff 75 dc             	pushl  -0x24(%ebp)
  801631:	ff 75 d8             	pushl  -0x28(%ebp)
  801634:	e8 e7 09 00 00       	call   802020 <__udivdi3>
  801639:	83 c4 18             	add    $0x18,%esp
  80163c:	52                   	push   %edx
  80163d:	50                   	push   %eax
  80163e:	89 f2                	mov    %esi,%edx
  801640:	89 f8                	mov    %edi,%eax
  801642:	e8 85 ff ff ff       	call   8015cc <printnum>
  801647:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80164a:	83 ec 08             	sub    $0x8,%esp
  80164d:	56                   	push   %esi
  80164e:	83 ec 04             	sub    $0x4,%esp
  801651:	ff 75 e4             	pushl  -0x1c(%ebp)
  801654:	ff 75 e0             	pushl  -0x20(%ebp)
  801657:	ff 75 dc             	pushl  -0x24(%ebp)
  80165a:	ff 75 d8             	pushl  -0x28(%ebp)
  80165d:	e8 ce 0a 00 00       	call   802130 <__umoddi3>
  801662:	83 c4 14             	add    $0x14,%esp
  801665:	0f be 80 1b 24 80 00 	movsbl 0x80241b(%eax),%eax
  80166c:	50                   	push   %eax
  80166d:	ff d7                	call   *%edi
}
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801675:	5b                   	pop    %ebx
  801676:	5e                   	pop    %esi
  801677:	5f                   	pop    %edi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    

0080167a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801680:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801684:	8b 10                	mov    (%eax),%edx
  801686:	3b 50 04             	cmp    0x4(%eax),%edx
  801689:	73 0a                	jae    801695 <sprintputch+0x1b>
		*b->buf++ = ch;
  80168b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80168e:	89 08                	mov    %ecx,(%eax)
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	88 02                	mov    %al,(%edx)
}
  801695:	5d                   	pop    %ebp
  801696:	c3                   	ret    

00801697 <printfmt>:
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80169d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8016a0:	50                   	push   %eax
  8016a1:	ff 75 10             	pushl  0x10(%ebp)
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	ff 75 08             	pushl  0x8(%ebp)
  8016aa:	e8 05 00 00 00       	call   8016b4 <vprintfmt>
}
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <vprintfmt>:
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	57                   	push   %edi
  8016b8:	56                   	push   %esi
  8016b9:	53                   	push   %ebx
  8016ba:	83 ec 3c             	sub    $0x3c,%esp
  8016bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8016c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016c3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016c6:	eb 0a                	jmp    8016d2 <vprintfmt+0x1e>
			putch(ch, putdat);
  8016c8:	83 ec 08             	sub    $0x8,%esp
  8016cb:	53                   	push   %ebx
  8016cc:	50                   	push   %eax
  8016cd:	ff d6                	call   *%esi
  8016cf:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016d2:	83 c7 01             	add    $0x1,%edi
  8016d5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016d9:	83 f8 25             	cmp    $0x25,%eax
  8016dc:	74 0c                	je     8016ea <vprintfmt+0x36>
			if (ch == '\0')
  8016de:	85 c0                	test   %eax,%eax
  8016e0:	75 e6                	jne    8016c8 <vprintfmt+0x14>
}
  8016e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5f                   	pop    %edi
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    
		padc = ' ';
  8016ea:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8016ee:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8016f5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8016fc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801703:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801708:	8d 47 01             	lea    0x1(%edi),%eax
  80170b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80170e:	0f b6 17             	movzbl (%edi),%edx
  801711:	8d 42 dd             	lea    -0x23(%edx),%eax
  801714:	3c 55                	cmp    $0x55,%al
  801716:	0f 87 ba 03 00 00    	ja     801ad6 <vprintfmt+0x422>
  80171c:	0f b6 c0             	movzbl %al,%eax
  80171f:	ff 24 85 60 25 80 00 	jmp    *0x802560(,%eax,4)
  801726:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801729:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80172d:	eb d9                	jmp    801708 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80172f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801732:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801736:	eb d0                	jmp    801708 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801738:	0f b6 d2             	movzbl %dl,%edx
  80173b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
  801743:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801746:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801749:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80174d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801750:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801753:	83 f9 09             	cmp    $0x9,%ecx
  801756:	77 55                	ja     8017ad <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  801758:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80175b:	eb e9                	jmp    801746 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80175d:	8b 45 14             	mov    0x14(%ebp),%eax
  801760:	8b 00                	mov    (%eax),%eax
  801762:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801765:	8b 45 14             	mov    0x14(%ebp),%eax
  801768:	8d 40 04             	lea    0x4(%eax),%eax
  80176b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80176e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801771:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801775:	79 91                	jns    801708 <vprintfmt+0x54>
				width = precision, precision = -1;
  801777:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80177a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80177d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801784:	eb 82                	jmp    801708 <vprintfmt+0x54>
  801786:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801789:	85 c0                	test   %eax,%eax
  80178b:	ba 00 00 00 00       	mov    $0x0,%edx
  801790:	0f 49 d0             	cmovns %eax,%edx
  801793:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801796:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801799:	e9 6a ff ff ff       	jmp    801708 <vprintfmt+0x54>
  80179e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8017a1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8017a8:	e9 5b ff ff ff       	jmp    801708 <vprintfmt+0x54>
  8017ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8017b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8017b3:	eb bc                	jmp    801771 <vprintfmt+0xbd>
			lflag++;
  8017b5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017bb:	e9 48 ff ff ff       	jmp    801708 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8017c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c3:	8d 78 04             	lea    0x4(%eax),%edi
  8017c6:	83 ec 08             	sub    $0x8,%esp
  8017c9:	53                   	push   %ebx
  8017ca:	ff 30                	pushl  (%eax)
  8017cc:	ff d6                	call   *%esi
			break;
  8017ce:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017d1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017d4:	e9 9c 02 00 00       	jmp    801a75 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8017d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017dc:	8d 78 04             	lea    0x4(%eax),%edi
  8017df:	8b 00                	mov    (%eax),%eax
  8017e1:	99                   	cltd   
  8017e2:	31 d0                	xor    %edx,%eax
  8017e4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017e6:	83 f8 0f             	cmp    $0xf,%eax
  8017e9:	7f 23                	jg     80180e <vprintfmt+0x15a>
  8017eb:	8b 14 85 c0 26 80 00 	mov    0x8026c0(,%eax,4),%edx
  8017f2:	85 d2                	test   %edx,%edx
  8017f4:	74 18                	je     80180e <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8017f6:	52                   	push   %edx
  8017f7:	68 72 23 80 00       	push   $0x802372
  8017fc:	53                   	push   %ebx
  8017fd:	56                   	push   %esi
  8017fe:	e8 94 fe ff ff       	call   801697 <printfmt>
  801803:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801806:	89 7d 14             	mov    %edi,0x14(%ebp)
  801809:	e9 67 02 00 00       	jmp    801a75 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  80180e:	50                   	push   %eax
  80180f:	68 33 24 80 00       	push   $0x802433
  801814:	53                   	push   %ebx
  801815:	56                   	push   %esi
  801816:	e8 7c fe ff ff       	call   801697 <printfmt>
  80181b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80181e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801821:	e9 4f 02 00 00       	jmp    801a75 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  801826:	8b 45 14             	mov    0x14(%ebp),%eax
  801829:	83 c0 04             	add    $0x4,%eax
  80182c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80182f:	8b 45 14             	mov    0x14(%ebp),%eax
  801832:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801834:	85 d2                	test   %edx,%edx
  801836:	b8 2c 24 80 00       	mov    $0x80242c,%eax
  80183b:	0f 45 c2             	cmovne %edx,%eax
  80183e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801841:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801845:	7e 06                	jle    80184d <vprintfmt+0x199>
  801847:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80184b:	75 0d                	jne    80185a <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80184d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801850:	89 c7                	mov    %eax,%edi
  801852:	03 45 e0             	add    -0x20(%ebp),%eax
  801855:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801858:	eb 3f                	jmp    801899 <vprintfmt+0x1e5>
  80185a:	83 ec 08             	sub    $0x8,%esp
  80185d:	ff 75 d8             	pushl  -0x28(%ebp)
  801860:	50                   	push   %eax
  801861:	e8 0d 03 00 00       	call   801b73 <strnlen>
  801866:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801869:	29 c2                	sub    %eax,%edx
  80186b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801873:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801877:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80187a:	85 ff                	test   %edi,%edi
  80187c:	7e 58                	jle    8018d6 <vprintfmt+0x222>
					putch(padc, putdat);
  80187e:	83 ec 08             	sub    $0x8,%esp
  801881:	53                   	push   %ebx
  801882:	ff 75 e0             	pushl  -0x20(%ebp)
  801885:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801887:	83 ef 01             	sub    $0x1,%edi
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	eb eb                	jmp    80187a <vprintfmt+0x1c6>
					putch(ch, putdat);
  80188f:	83 ec 08             	sub    $0x8,%esp
  801892:	53                   	push   %ebx
  801893:	52                   	push   %edx
  801894:	ff d6                	call   *%esi
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80189c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80189e:	83 c7 01             	add    $0x1,%edi
  8018a1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8018a5:	0f be d0             	movsbl %al,%edx
  8018a8:	85 d2                	test   %edx,%edx
  8018aa:	74 45                	je     8018f1 <vprintfmt+0x23d>
  8018ac:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018b0:	78 06                	js     8018b8 <vprintfmt+0x204>
  8018b2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8018b6:	78 35                	js     8018ed <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8018b8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8018bc:	74 d1                	je     80188f <vprintfmt+0x1db>
  8018be:	0f be c0             	movsbl %al,%eax
  8018c1:	83 e8 20             	sub    $0x20,%eax
  8018c4:	83 f8 5e             	cmp    $0x5e,%eax
  8018c7:	76 c6                	jbe    80188f <vprintfmt+0x1db>
					putch('?', putdat);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	53                   	push   %ebx
  8018cd:	6a 3f                	push   $0x3f
  8018cf:	ff d6                	call   *%esi
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	eb c3                	jmp    801899 <vprintfmt+0x1e5>
  8018d6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8018d9:	85 d2                	test   %edx,%edx
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e0:	0f 49 c2             	cmovns %edx,%eax
  8018e3:	29 c2                	sub    %eax,%edx
  8018e5:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8018e8:	e9 60 ff ff ff       	jmp    80184d <vprintfmt+0x199>
  8018ed:	89 cf                	mov    %ecx,%edi
  8018ef:	eb 02                	jmp    8018f3 <vprintfmt+0x23f>
  8018f1:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8018f3:	85 ff                	test   %edi,%edi
  8018f5:	7e 10                	jle    801907 <vprintfmt+0x253>
				putch(' ', putdat);
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	53                   	push   %ebx
  8018fb:	6a 20                	push   $0x20
  8018fd:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018ff:	83 ef 01             	sub    $0x1,%edi
  801902:	83 c4 10             	add    $0x10,%esp
  801905:	eb ec                	jmp    8018f3 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  801907:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80190a:	89 45 14             	mov    %eax,0x14(%ebp)
  80190d:	e9 63 01 00 00       	jmp    801a75 <vprintfmt+0x3c1>
	if (lflag >= 2)
  801912:	83 f9 01             	cmp    $0x1,%ecx
  801915:	7f 1b                	jg     801932 <vprintfmt+0x27e>
	else if (lflag)
  801917:	85 c9                	test   %ecx,%ecx
  801919:	74 63                	je     80197e <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  80191b:	8b 45 14             	mov    0x14(%ebp),%eax
  80191e:	8b 00                	mov    (%eax),%eax
  801920:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801923:	99                   	cltd   
  801924:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801927:	8b 45 14             	mov    0x14(%ebp),%eax
  80192a:	8d 40 04             	lea    0x4(%eax),%eax
  80192d:	89 45 14             	mov    %eax,0x14(%ebp)
  801930:	eb 17                	jmp    801949 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  801932:	8b 45 14             	mov    0x14(%ebp),%eax
  801935:	8b 50 04             	mov    0x4(%eax),%edx
  801938:	8b 00                	mov    (%eax),%eax
  80193a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80193d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801940:	8b 45 14             	mov    0x14(%ebp),%eax
  801943:	8d 40 08             	lea    0x8(%eax),%eax
  801946:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801949:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80194c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80194f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801954:	85 c9                	test   %ecx,%ecx
  801956:	0f 89 ff 00 00 00    	jns    801a5b <vprintfmt+0x3a7>
				putch('-', putdat);
  80195c:	83 ec 08             	sub    $0x8,%esp
  80195f:	53                   	push   %ebx
  801960:	6a 2d                	push   $0x2d
  801962:	ff d6                	call   *%esi
				num = -(long long) num;
  801964:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801967:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80196a:	f7 da                	neg    %edx
  80196c:	83 d1 00             	adc    $0x0,%ecx
  80196f:	f7 d9                	neg    %ecx
  801971:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801974:	b8 0a 00 00 00       	mov    $0xa,%eax
  801979:	e9 dd 00 00 00       	jmp    801a5b <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80197e:	8b 45 14             	mov    0x14(%ebp),%eax
  801981:	8b 00                	mov    (%eax),%eax
  801983:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801986:	99                   	cltd   
  801987:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80198a:	8b 45 14             	mov    0x14(%ebp),%eax
  80198d:	8d 40 04             	lea    0x4(%eax),%eax
  801990:	89 45 14             	mov    %eax,0x14(%ebp)
  801993:	eb b4                	jmp    801949 <vprintfmt+0x295>
	if (lflag >= 2)
  801995:	83 f9 01             	cmp    $0x1,%ecx
  801998:	7f 1e                	jg     8019b8 <vprintfmt+0x304>
	else if (lflag)
  80199a:	85 c9                	test   %ecx,%ecx
  80199c:	74 32                	je     8019d0 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  80199e:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a1:	8b 10                	mov    (%eax),%edx
  8019a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a8:	8d 40 04             	lea    0x4(%eax),%eax
  8019ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019b3:	e9 a3 00 00 00       	jmp    801a5b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8019b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bb:	8b 10                	mov    (%eax),%edx
  8019bd:	8b 48 04             	mov    0x4(%eax),%ecx
  8019c0:	8d 40 08             	lea    0x8(%eax),%eax
  8019c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019c6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019cb:	e9 8b 00 00 00       	jmp    801a5b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8019d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d3:	8b 10                	mov    (%eax),%edx
  8019d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019da:	8d 40 04             	lea    0x4(%eax),%eax
  8019dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019e5:	eb 74                	jmp    801a5b <vprintfmt+0x3a7>
	if (lflag >= 2)
  8019e7:	83 f9 01             	cmp    $0x1,%ecx
  8019ea:	7f 1b                	jg     801a07 <vprintfmt+0x353>
	else if (lflag)
  8019ec:	85 c9                	test   %ecx,%ecx
  8019ee:	74 2c                	je     801a1c <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8019f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f3:	8b 10                	mov    (%eax),%edx
  8019f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019fa:	8d 40 04             	lea    0x4(%eax),%eax
  8019fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a00:	b8 08 00 00 00       	mov    $0x8,%eax
  801a05:	eb 54                	jmp    801a5b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801a07:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0a:	8b 10                	mov    (%eax),%edx
  801a0c:	8b 48 04             	mov    0x4(%eax),%ecx
  801a0f:	8d 40 08             	lea    0x8(%eax),%eax
  801a12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a15:	b8 08 00 00 00       	mov    $0x8,%eax
  801a1a:	eb 3f                	jmp    801a5b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1f:	8b 10                	mov    (%eax),%edx
  801a21:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a26:	8d 40 04             	lea    0x4(%eax),%eax
  801a29:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a2c:	b8 08 00 00 00       	mov    $0x8,%eax
  801a31:	eb 28                	jmp    801a5b <vprintfmt+0x3a7>
			putch('0', putdat);
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	53                   	push   %ebx
  801a37:	6a 30                	push   $0x30
  801a39:	ff d6                	call   *%esi
			putch('x', putdat);
  801a3b:	83 c4 08             	add    $0x8,%esp
  801a3e:	53                   	push   %ebx
  801a3f:	6a 78                	push   $0x78
  801a41:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	8b 10                	mov    (%eax),%edx
  801a48:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a4d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a50:	8d 40 04             	lea    0x4(%eax),%eax
  801a53:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a56:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a5b:	83 ec 0c             	sub    $0xc,%esp
  801a5e:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801a62:	57                   	push   %edi
  801a63:	ff 75 e0             	pushl  -0x20(%ebp)
  801a66:	50                   	push   %eax
  801a67:	51                   	push   %ecx
  801a68:	52                   	push   %edx
  801a69:	89 da                	mov    %ebx,%edx
  801a6b:	89 f0                	mov    %esi,%eax
  801a6d:	e8 5a fb ff ff       	call   8015cc <printnum>
			break;
  801a72:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801a75:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a78:	e9 55 fc ff ff       	jmp    8016d2 <vprintfmt+0x1e>
	if (lflag >= 2)
  801a7d:	83 f9 01             	cmp    $0x1,%ecx
  801a80:	7f 1b                	jg     801a9d <vprintfmt+0x3e9>
	else if (lflag)
  801a82:	85 c9                	test   %ecx,%ecx
  801a84:	74 2c                	je     801ab2 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  801a86:	8b 45 14             	mov    0x14(%ebp),%eax
  801a89:	8b 10                	mov    (%eax),%edx
  801a8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a90:	8d 40 04             	lea    0x4(%eax),%eax
  801a93:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a96:	b8 10 00 00 00       	mov    $0x10,%eax
  801a9b:	eb be                	jmp    801a5b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa0:	8b 10                	mov    (%eax),%edx
  801aa2:	8b 48 04             	mov    0x4(%eax),%ecx
  801aa5:	8d 40 08             	lea    0x8(%eax),%eax
  801aa8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aab:	b8 10 00 00 00       	mov    $0x10,%eax
  801ab0:	eb a9                	jmp    801a5b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab5:	8b 10                	mov    (%eax),%edx
  801ab7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801abc:	8d 40 04             	lea    0x4(%eax),%eax
  801abf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ac2:	b8 10 00 00 00       	mov    $0x10,%eax
  801ac7:	eb 92                	jmp    801a5b <vprintfmt+0x3a7>
			putch(ch, putdat);
  801ac9:	83 ec 08             	sub    $0x8,%esp
  801acc:	53                   	push   %ebx
  801acd:	6a 25                	push   $0x25
  801acf:	ff d6                	call   *%esi
			break;
  801ad1:	83 c4 10             	add    $0x10,%esp
  801ad4:	eb 9f                	jmp    801a75 <vprintfmt+0x3c1>
			putch('%', putdat);
  801ad6:	83 ec 08             	sub    $0x8,%esp
  801ad9:	53                   	push   %ebx
  801ada:	6a 25                	push   $0x25
  801adc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ade:	83 c4 10             	add    $0x10,%esp
  801ae1:	89 f8                	mov    %edi,%eax
  801ae3:	eb 03                	jmp    801ae8 <vprintfmt+0x434>
  801ae5:	83 e8 01             	sub    $0x1,%eax
  801ae8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801aec:	75 f7                	jne    801ae5 <vprintfmt+0x431>
  801aee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801af1:	eb 82                	jmp    801a75 <vprintfmt+0x3c1>

00801af3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 18             	sub    $0x18,%esp
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801aff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b02:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b06:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b10:	85 c0                	test   %eax,%eax
  801b12:	74 26                	je     801b3a <vsnprintf+0x47>
  801b14:	85 d2                	test   %edx,%edx
  801b16:	7e 22                	jle    801b3a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b18:	ff 75 14             	pushl  0x14(%ebp)
  801b1b:	ff 75 10             	pushl  0x10(%ebp)
  801b1e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b21:	50                   	push   %eax
  801b22:	68 7a 16 80 00       	push   $0x80167a
  801b27:	e8 88 fb ff ff       	call   8016b4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b2f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b35:	83 c4 10             	add    $0x10,%esp
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    
		return -E_INVAL;
  801b3a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b3f:	eb f7                	jmp    801b38 <vsnprintf+0x45>

00801b41 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b47:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b4a:	50                   	push   %eax
  801b4b:	ff 75 10             	pushl  0x10(%ebp)
  801b4e:	ff 75 0c             	pushl  0xc(%ebp)
  801b51:	ff 75 08             	pushl  0x8(%ebp)
  801b54:	e8 9a ff ff ff       	call   801af3 <vsnprintf>
	va_end(ap);

	return rc;
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b61:	b8 00 00 00 00       	mov    $0x0,%eax
  801b66:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b6a:	74 05                	je     801b71 <strlen+0x16>
		n++;
  801b6c:	83 c0 01             	add    $0x1,%eax
  801b6f:	eb f5                	jmp    801b66 <strlen+0xb>
	return n;
}
  801b71:	5d                   	pop    %ebp
  801b72:	c3                   	ret    

00801b73 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b79:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b81:	39 c2                	cmp    %eax,%edx
  801b83:	74 0d                	je     801b92 <strnlen+0x1f>
  801b85:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801b89:	74 05                	je     801b90 <strnlen+0x1d>
		n++;
  801b8b:	83 c2 01             	add    $0x1,%edx
  801b8e:	eb f1                	jmp    801b81 <strnlen+0xe>
  801b90:	89 d0                	mov    %edx,%eax
	return n;
}
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    

00801b94 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	53                   	push   %ebx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba3:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801ba7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801baa:	83 c2 01             	add    $0x1,%edx
  801bad:	84 c9                	test   %cl,%cl
  801baf:	75 f2                	jne    801ba3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801bb1:	5b                   	pop    %ebx
  801bb2:	5d                   	pop    %ebp
  801bb3:	c3                   	ret    

00801bb4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	53                   	push   %ebx
  801bb8:	83 ec 10             	sub    $0x10,%esp
  801bbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801bbe:	53                   	push   %ebx
  801bbf:	e8 97 ff ff ff       	call   801b5b <strlen>
  801bc4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	01 d8                	add    %ebx,%eax
  801bcc:	50                   	push   %eax
  801bcd:	e8 c2 ff ff ff       	call   801b94 <strcpy>
	return dst;
}
  801bd2:	89 d8                	mov    %ebx,%eax
  801bd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	56                   	push   %esi
  801bdd:	53                   	push   %ebx
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801be4:	89 c6                	mov    %eax,%esi
  801be6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801be9:	89 c2                	mov    %eax,%edx
  801beb:	39 f2                	cmp    %esi,%edx
  801bed:	74 11                	je     801c00 <strncpy+0x27>
		*dst++ = *src;
  801bef:	83 c2 01             	add    $0x1,%edx
  801bf2:	0f b6 19             	movzbl (%ecx),%ebx
  801bf5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801bf8:	80 fb 01             	cmp    $0x1,%bl
  801bfb:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801bfe:	eb eb                	jmp    801beb <strncpy+0x12>
	}
	return ret;
}
  801c00:	5b                   	pop    %ebx
  801c01:	5e                   	pop    %esi
  801c02:	5d                   	pop    %ebp
  801c03:	c3                   	ret    

00801c04 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	56                   	push   %esi
  801c08:	53                   	push   %ebx
  801c09:	8b 75 08             	mov    0x8(%ebp),%esi
  801c0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c0f:	8b 55 10             	mov    0x10(%ebp),%edx
  801c12:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c14:	85 d2                	test   %edx,%edx
  801c16:	74 21                	je     801c39 <strlcpy+0x35>
  801c18:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801c1c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801c1e:	39 c2                	cmp    %eax,%edx
  801c20:	74 14                	je     801c36 <strlcpy+0x32>
  801c22:	0f b6 19             	movzbl (%ecx),%ebx
  801c25:	84 db                	test   %bl,%bl
  801c27:	74 0b                	je     801c34 <strlcpy+0x30>
			*dst++ = *src++;
  801c29:	83 c1 01             	add    $0x1,%ecx
  801c2c:	83 c2 01             	add    $0x1,%edx
  801c2f:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c32:	eb ea                	jmp    801c1e <strlcpy+0x1a>
  801c34:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801c36:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c39:	29 f0                	sub    %esi,%eax
}
  801c3b:	5b                   	pop    %ebx
  801c3c:	5e                   	pop    %esi
  801c3d:	5d                   	pop    %ebp
  801c3e:	c3                   	ret    

00801c3f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c45:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c48:	0f b6 01             	movzbl (%ecx),%eax
  801c4b:	84 c0                	test   %al,%al
  801c4d:	74 0c                	je     801c5b <strcmp+0x1c>
  801c4f:	3a 02                	cmp    (%edx),%al
  801c51:	75 08                	jne    801c5b <strcmp+0x1c>
		p++, q++;
  801c53:	83 c1 01             	add    $0x1,%ecx
  801c56:	83 c2 01             	add    $0x1,%edx
  801c59:	eb ed                	jmp    801c48 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c5b:	0f b6 c0             	movzbl %al,%eax
  801c5e:	0f b6 12             	movzbl (%edx),%edx
  801c61:	29 d0                	sub    %edx,%eax
}
  801c63:	5d                   	pop    %ebp
  801c64:	c3                   	ret    

00801c65 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	53                   	push   %ebx
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6f:	89 c3                	mov    %eax,%ebx
  801c71:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c74:	eb 06                	jmp    801c7c <strncmp+0x17>
		n--, p++, q++;
  801c76:	83 c0 01             	add    $0x1,%eax
  801c79:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c7c:	39 d8                	cmp    %ebx,%eax
  801c7e:	74 16                	je     801c96 <strncmp+0x31>
  801c80:	0f b6 08             	movzbl (%eax),%ecx
  801c83:	84 c9                	test   %cl,%cl
  801c85:	74 04                	je     801c8b <strncmp+0x26>
  801c87:	3a 0a                	cmp    (%edx),%cl
  801c89:	74 eb                	je     801c76 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c8b:	0f b6 00             	movzbl (%eax),%eax
  801c8e:	0f b6 12             	movzbl (%edx),%edx
  801c91:	29 d0                	sub    %edx,%eax
}
  801c93:	5b                   	pop    %ebx
  801c94:	5d                   	pop    %ebp
  801c95:	c3                   	ret    
		return 0;
  801c96:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9b:	eb f6                	jmp    801c93 <strncmp+0x2e>

00801c9d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801ca7:	0f b6 10             	movzbl (%eax),%edx
  801caa:	84 d2                	test   %dl,%dl
  801cac:	74 09                	je     801cb7 <strchr+0x1a>
		if (*s == c)
  801cae:	38 ca                	cmp    %cl,%dl
  801cb0:	74 0a                	je     801cbc <strchr+0x1f>
	for (; *s; s++)
  801cb2:	83 c0 01             	add    $0x1,%eax
  801cb5:	eb f0                	jmp    801ca7 <strchr+0xa>
			return (char *) s;
	return 0;
  801cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cbc:	5d                   	pop    %ebp
  801cbd:	c3                   	ret    

00801cbe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cc8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801ccb:	38 ca                	cmp    %cl,%dl
  801ccd:	74 09                	je     801cd8 <strfind+0x1a>
  801ccf:	84 d2                	test   %dl,%dl
  801cd1:	74 05                	je     801cd8 <strfind+0x1a>
	for (; *s; s++)
  801cd3:	83 c0 01             	add    $0x1,%eax
  801cd6:	eb f0                	jmp    801cc8 <strfind+0xa>
			break;
	return (char *) s;
}
  801cd8:	5d                   	pop    %ebp
  801cd9:	c3                   	ret    

00801cda <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	57                   	push   %edi
  801cde:	56                   	push   %esi
  801cdf:	53                   	push   %ebx
  801ce0:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ce3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ce6:	85 c9                	test   %ecx,%ecx
  801ce8:	74 31                	je     801d1b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801cea:	89 f8                	mov    %edi,%eax
  801cec:	09 c8                	or     %ecx,%eax
  801cee:	a8 03                	test   $0x3,%al
  801cf0:	75 23                	jne    801d15 <memset+0x3b>
		c &= 0xFF;
  801cf2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801cf6:	89 d3                	mov    %edx,%ebx
  801cf8:	c1 e3 08             	shl    $0x8,%ebx
  801cfb:	89 d0                	mov    %edx,%eax
  801cfd:	c1 e0 18             	shl    $0x18,%eax
  801d00:	89 d6                	mov    %edx,%esi
  801d02:	c1 e6 10             	shl    $0x10,%esi
  801d05:	09 f0                	or     %esi,%eax
  801d07:	09 c2                	or     %eax,%edx
  801d09:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801d0b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d0e:	89 d0                	mov    %edx,%eax
  801d10:	fc                   	cld    
  801d11:	f3 ab                	rep stos %eax,%es:(%edi)
  801d13:	eb 06                	jmp    801d1b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d18:	fc                   	cld    
  801d19:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801d1b:	89 f8                	mov    %edi,%eax
  801d1d:	5b                   	pop    %ebx
  801d1e:	5e                   	pop    %esi
  801d1f:	5f                   	pop    %edi
  801d20:	5d                   	pop    %ebp
  801d21:	c3                   	ret    

00801d22 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	57                   	push   %edi
  801d26:	56                   	push   %esi
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d30:	39 c6                	cmp    %eax,%esi
  801d32:	73 32                	jae    801d66 <memmove+0x44>
  801d34:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d37:	39 c2                	cmp    %eax,%edx
  801d39:	76 2b                	jbe    801d66 <memmove+0x44>
		s += n;
		d += n;
  801d3b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d3e:	89 fe                	mov    %edi,%esi
  801d40:	09 ce                	or     %ecx,%esi
  801d42:	09 d6                	or     %edx,%esi
  801d44:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d4a:	75 0e                	jne    801d5a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d4c:	83 ef 04             	sub    $0x4,%edi
  801d4f:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d52:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d55:	fd                   	std    
  801d56:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d58:	eb 09                	jmp    801d63 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d5a:	83 ef 01             	sub    $0x1,%edi
  801d5d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d60:	fd                   	std    
  801d61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d63:	fc                   	cld    
  801d64:	eb 1a                	jmp    801d80 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d66:	89 c2                	mov    %eax,%edx
  801d68:	09 ca                	or     %ecx,%edx
  801d6a:	09 f2                	or     %esi,%edx
  801d6c:	f6 c2 03             	test   $0x3,%dl
  801d6f:	75 0a                	jne    801d7b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d71:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d74:	89 c7                	mov    %eax,%edi
  801d76:	fc                   	cld    
  801d77:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d79:	eb 05                	jmp    801d80 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801d7b:	89 c7                	mov    %eax,%edi
  801d7d:	fc                   	cld    
  801d7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d80:	5e                   	pop    %esi
  801d81:	5f                   	pop    %edi
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    

00801d84 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801d8a:	ff 75 10             	pushl  0x10(%ebp)
  801d8d:	ff 75 0c             	pushl  0xc(%ebp)
  801d90:	ff 75 08             	pushl  0x8(%ebp)
  801d93:	e8 8a ff ff ff       	call   801d22 <memmove>
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	56                   	push   %esi
  801d9e:	53                   	push   %ebx
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da5:	89 c6                	mov    %eax,%esi
  801da7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801daa:	39 f0                	cmp    %esi,%eax
  801dac:	74 1c                	je     801dca <memcmp+0x30>
		if (*s1 != *s2)
  801dae:	0f b6 08             	movzbl (%eax),%ecx
  801db1:	0f b6 1a             	movzbl (%edx),%ebx
  801db4:	38 d9                	cmp    %bl,%cl
  801db6:	75 08                	jne    801dc0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801db8:	83 c0 01             	add    $0x1,%eax
  801dbb:	83 c2 01             	add    $0x1,%edx
  801dbe:	eb ea                	jmp    801daa <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801dc0:	0f b6 c1             	movzbl %cl,%eax
  801dc3:	0f b6 db             	movzbl %bl,%ebx
  801dc6:	29 d8                	sub    %ebx,%eax
  801dc8:	eb 05                	jmp    801dcf <memcmp+0x35>
	}

	return 0;
  801dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcf:	5b                   	pop    %ebx
  801dd0:	5e                   	pop    %esi
  801dd1:	5d                   	pop    %ebp
  801dd2:	c3                   	ret    

00801dd3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801ddc:	89 c2                	mov    %eax,%edx
  801dde:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801de1:	39 d0                	cmp    %edx,%eax
  801de3:	73 09                	jae    801dee <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801de5:	38 08                	cmp    %cl,(%eax)
  801de7:	74 05                	je     801dee <memfind+0x1b>
	for (; s < ends; s++)
  801de9:	83 c0 01             	add    $0x1,%eax
  801dec:	eb f3                	jmp    801de1 <memfind+0xe>
			break;
	return (void *) s;
}
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    

00801df0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	57                   	push   %edi
  801df4:	56                   	push   %esi
  801df5:	53                   	push   %ebx
  801df6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801dfc:	eb 03                	jmp    801e01 <strtol+0x11>
		s++;
  801dfe:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801e01:	0f b6 01             	movzbl (%ecx),%eax
  801e04:	3c 20                	cmp    $0x20,%al
  801e06:	74 f6                	je     801dfe <strtol+0xe>
  801e08:	3c 09                	cmp    $0x9,%al
  801e0a:	74 f2                	je     801dfe <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801e0c:	3c 2b                	cmp    $0x2b,%al
  801e0e:	74 2a                	je     801e3a <strtol+0x4a>
	int neg = 0;
  801e10:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e15:	3c 2d                	cmp    $0x2d,%al
  801e17:	74 2b                	je     801e44 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e19:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e1f:	75 0f                	jne    801e30 <strtol+0x40>
  801e21:	80 39 30             	cmpb   $0x30,(%ecx)
  801e24:	74 28                	je     801e4e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e26:	85 db                	test   %ebx,%ebx
  801e28:	b8 0a 00 00 00       	mov    $0xa,%eax
  801e2d:	0f 44 d8             	cmove  %eax,%ebx
  801e30:	b8 00 00 00 00       	mov    $0x0,%eax
  801e35:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e38:	eb 50                	jmp    801e8a <strtol+0x9a>
		s++;
  801e3a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e3d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e42:	eb d5                	jmp    801e19 <strtol+0x29>
		s++, neg = 1;
  801e44:	83 c1 01             	add    $0x1,%ecx
  801e47:	bf 01 00 00 00       	mov    $0x1,%edi
  801e4c:	eb cb                	jmp    801e19 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e4e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e52:	74 0e                	je     801e62 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801e54:	85 db                	test   %ebx,%ebx
  801e56:	75 d8                	jne    801e30 <strtol+0x40>
		s++, base = 8;
  801e58:	83 c1 01             	add    $0x1,%ecx
  801e5b:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e60:	eb ce                	jmp    801e30 <strtol+0x40>
		s += 2, base = 16;
  801e62:	83 c1 02             	add    $0x2,%ecx
  801e65:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e6a:	eb c4                	jmp    801e30 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e6c:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e6f:	89 f3                	mov    %esi,%ebx
  801e71:	80 fb 19             	cmp    $0x19,%bl
  801e74:	77 29                	ja     801e9f <strtol+0xaf>
			dig = *s - 'a' + 10;
  801e76:	0f be d2             	movsbl %dl,%edx
  801e79:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e7c:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e7f:	7d 30                	jge    801eb1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801e81:	83 c1 01             	add    $0x1,%ecx
  801e84:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e88:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e8a:	0f b6 11             	movzbl (%ecx),%edx
  801e8d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e90:	89 f3                	mov    %esi,%ebx
  801e92:	80 fb 09             	cmp    $0x9,%bl
  801e95:	77 d5                	ja     801e6c <strtol+0x7c>
			dig = *s - '0';
  801e97:	0f be d2             	movsbl %dl,%edx
  801e9a:	83 ea 30             	sub    $0x30,%edx
  801e9d:	eb dd                	jmp    801e7c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801e9f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801ea2:	89 f3                	mov    %esi,%ebx
  801ea4:	80 fb 19             	cmp    $0x19,%bl
  801ea7:	77 08                	ja     801eb1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  801ea9:	0f be d2             	movsbl %dl,%edx
  801eac:	83 ea 37             	sub    $0x37,%edx
  801eaf:	eb cb                	jmp    801e7c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801eb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eb5:	74 05                	je     801ebc <strtol+0xcc>
		*endptr = (char *) s;
  801eb7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801eba:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801ebc:	89 c2                	mov    %eax,%edx
  801ebe:	f7 da                	neg    %edx
  801ec0:	85 ff                	test   %edi,%edi
  801ec2:	0f 45 c2             	cmovne %edx,%eax
}
  801ec5:	5b                   	pop    %ebx
  801ec6:	5e                   	pop    %esi
  801ec7:	5f                   	pop    %edi
  801ec8:	5d                   	pop    %ebp
  801ec9:	c3                   	ret    

00801eca <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	56                   	push   %esi
  801ece:	53                   	push   %ebx
  801ecf:	8b 75 08             	mov    0x8(%ebp),%esi
  801ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	74 4f                	je     801f2b <ipc_recv+0x61>
  801edc:	83 ec 0c             	sub    $0xc,%esp
  801edf:	50                   	push   %eax
  801ee0:	e8 35 e4 ff ff       	call   80031a <sys_ipc_recv>
  801ee5:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801ee8:	85 f6                	test   %esi,%esi
  801eea:	74 14                	je     801f00 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801eec:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	75 09                	jne    801efe <ipc_recv+0x34>
  801ef5:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801efb:	8b 52 74             	mov    0x74(%edx),%edx
  801efe:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801f00:	85 db                	test   %ebx,%ebx
  801f02:	74 14                	je     801f18 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801f04:	ba 00 00 00 00       	mov    $0x0,%edx
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	75 09                	jne    801f16 <ipc_recv+0x4c>
  801f0d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f13:	8b 52 78             	mov    0x78(%edx),%edx
  801f16:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	75 08                	jne    801f24 <ipc_recv+0x5a>
  801f1c:	a1 08 40 80 00       	mov    0x804008,%eax
  801f21:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f27:	5b                   	pop    %ebx
  801f28:	5e                   	pop    %esi
  801f29:	5d                   	pop    %ebp
  801f2a:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	68 00 00 c0 ee       	push   $0xeec00000
  801f33:	e8 e2 e3 ff ff       	call   80031a <sys_ipc_recv>
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	eb ab                	jmp    801ee8 <ipc_recv+0x1e>

00801f3d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	57                   	push   %edi
  801f41:	56                   	push   %esi
  801f42:	53                   	push   %ebx
  801f43:	83 ec 0c             	sub    $0xc,%esp
  801f46:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f49:	8b 75 10             	mov    0x10(%ebp),%esi
  801f4c:	eb 20                	jmp    801f6e <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f4e:	6a 00                	push   $0x0
  801f50:	68 00 00 c0 ee       	push   $0xeec00000
  801f55:	ff 75 0c             	pushl  0xc(%ebp)
  801f58:	57                   	push   %edi
  801f59:	e8 99 e3 ff ff       	call   8002f7 <sys_ipc_try_send>
  801f5e:	89 c3                	mov    %eax,%ebx
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	eb 1f                	jmp    801f84 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801f65:	e8 e1 e1 ff ff       	call   80014b <sys_yield>
	while(retval != 0) {
  801f6a:	85 db                	test   %ebx,%ebx
  801f6c:	74 33                	je     801fa1 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f6e:	85 f6                	test   %esi,%esi
  801f70:	74 dc                	je     801f4e <ipc_send+0x11>
  801f72:	ff 75 14             	pushl  0x14(%ebp)
  801f75:	56                   	push   %esi
  801f76:	ff 75 0c             	pushl  0xc(%ebp)
  801f79:	57                   	push   %edi
  801f7a:	e8 78 e3 ff ff       	call   8002f7 <sys_ipc_try_send>
  801f7f:	89 c3                	mov    %eax,%ebx
  801f81:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801f84:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801f87:	74 dc                	je     801f65 <ipc_send+0x28>
  801f89:	85 db                	test   %ebx,%ebx
  801f8b:	74 d8                	je     801f65 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801f8d:	83 ec 04             	sub    $0x4,%esp
  801f90:	68 20 27 80 00       	push   $0x802720
  801f95:	6a 35                	push   $0x35
  801f97:	68 50 27 80 00       	push   $0x802750
  801f9c:	e8 3c f5 ff ff       	call   8014dd <_panic>
	}
}
  801fa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa4:	5b                   	pop    %ebx
  801fa5:	5e                   	pop    %esi
  801fa6:	5f                   	pop    %edi
  801fa7:	5d                   	pop    %ebp
  801fa8:	c3                   	ret    

00801fa9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fb4:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fb7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fbd:	8b 52 50             	mov    0x50(%edx),%edx
  801fc0:	39 ca                	cmp    %ecx,%edx
  801fc2:	74 11                	je     801fd5 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fc4:	83 c0 01             	add    $0x1,%eax
  801fc7:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fcc:	75 e6                	jne    801fb4 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd3:	eb 0b                	jmp    801fe0 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fd5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fd8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fdd:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fe0:	5d                   	pop    %ebp
  801fe1:	c3                   	ret    

00801fe2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fe8:	89 d0                	mov    %edx,%eax
  801fea:	c1 e8 16             	shr    $0x16,%eax
  801fed:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ff4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ff9:	f6 c1 01             	test   $0x1,%cl
  801ffc:	74 1d                	je     80201b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ffe:	c1 ea 0c             	shr    $0xc,%edx
  802001:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802008:	f6 c2 01             	test   $0x1,%dl
  80200b:	74 0e                	je     80201b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80200d:	c1 ea 0c             	shr    $0xc,%edx
  802010:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802017:	ef 
  802018:	0f b7 c0             	movzwl %ax,%eax
}
  80201b:	5d                   	pop    %ebp
  80201c:	c3                   	ret    
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
