
obj/user/breakpoint.debug：     文件格式 elf32-i386


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
  80002c:	e8 04 00 00 00       	call   800035 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $3");
  800033:	cc                   	int3   
}
  800034:	c3                   	ret    

00800035 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800035:	55                   	push   %ebp
  800036:	89 e5                	mov    %esp,%ebp
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800040:	e8 ce 00 00 00       	call   800113 <sys_getenvid>
  800045:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80004d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800052:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800057:	85 db                	test   %ebx,%ebx
  800059:	7e 07                	jle    800062 <libmain+0x2d>
		binaryname = argv[0];
  80005b:	8b 06                	mov    (%esi),%eax
  80005d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800062:	83 ec 08             	sub    $0x8,%esp
  800065:	56                   	push   %esi
  800066:	53                   	push   %ebx
  800067:	e8 c7 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80006c:	e8 0a 00 00 00       	call   80007b <exit>
}
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800077:	5b                   	pop    %ebx
  800078:	5e                   	pop    %esi
  800079:	5d                   	pop    %ebp
  80007a:	c3                   	ret    

0080007b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800081:	e8 b3 04 00 00       	call   800539 <close_all>
	sys_env_destroy(0);
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 00                	push   $0x0
  80008b:	e8 42 00 00 00       	call   8000d2 <sys_env_destroy>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	c9                   	leave  
  800094:	c3                   	ret    

00800095 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800095:	55                   	push   %ebp
  800096:	89 e5                	mov    %esp,%ebp
  800098:	57                   	push   %edi
  800099:	56                   	push   %esi
  80009a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a6:	89 c3                	mov    %eax,%ebx
  8000a8:	89 c7                	mov    %eax,%edi
  8000aa:	89 c6                	mov    %eax,%esi
  8000ac:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ae:	5b                   	pop    %ebx
  8000af:	5e                   	pop    %esi
  8000b0:	5f                   	pop    %edi
  8000b1:	5d                   	pop    %ebp
  8000b2:	c3                   	ret    

008000b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b3:	55                   	push   %ebp
  8000b4:	89 e5                	mov    %esp,%ebp
  8000b6:	57                   	push   %edi
  8000b7:	56                   	push   %esi
  8000b8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000be:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c3:	89 d1                	mov    %edx,%ecx
  8000c5:	89 d3                	mov    %edx,%ebx
  8000c7:	89 d7                	mov    %edx,%edi
  8000c9:	89 d6                	mov    %edx,%esi
  8000cb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5f                   	pop    %edi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    

008000d2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d2:	55                   	push   %ebp
  8000d3:	89 e5                	mov    %esp,%ebp
  8000d5:	57                   	push   %edi
  8000d6:	56                   	push   %esi
  8000d7:	53                   	push   %ebx
  8000d8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e3:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e8:	89 cb                	mov    %ecx,%ebx
  8000ea:	89 cf                	mov    %ecx,%edi
  8000ec:	89 ce                	mov    %ecx,%esi
  8000ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f0:	85 c0                	test   %eax,%eax
  8000f2:	7f 08                	jg     8000fc <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5f                   	pop    %edi
  8000fa:	5d                   	pop    %ebp
  8000fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	50                   	push   %eax
  800100:	6a 03                	push   $0x3
  800102:	68 6a 22 80 00       	push   $0x80226a
  800107:	6a 23                	push   $0x23
  800109:	68 87 22 80 00       	push   $0x802287
  80010e:	e8 b1 13 00 00       	call   8014c4 <_panic>

00800113 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	57                   	push   %edi
  800117:	56                   	push   %esi
  800118:	53                   	push   %ebx
	asm volatile("int %1\n"
  800119:	ba 00 00 00 00       	mov    $0x0,%edx
  80011e:	b8 02 00 00 00       	mov    $0x2,%eax
  800123:	89 d1                	mov    %edx,%ecx
  800125:	89 d3                	mov    %edx,%ebx
  800127:	89 d7                	mov    %edx,%edi
  800129:	89 d6                	mov    %edx,%esi
  80012b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5f                   	pop    %edi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <sys_yield>:

void
sys_yield(void)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	57                   	push   %edi
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
	asm volatile("int %1\n"
  800138:	ba 00 00 00 00       	mov    $0x0,%edx
  80013d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800142:	89 d1                	mov    %edx,%ecx
  800144:	89 d3                	mov    %edx,%ebx
  800146:	89 d7                	mov    %edx,%edi
  800148:	89 d6                	mov    %edx,%esi
  80014a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80014c:	5b                   	pop    %ebx
  80014d:	5e                   	pop    %esi
  80014e:	5f                   	pop    %edi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    

00800151 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	57                   	push   %edi
  800155:	56                   	push   %esi
  800156:	53                   	push   %ebx
  800157:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015a:	be 00 00 00 00       	mov    $0x0,%esi
  80015f:	8b 55 08             	mov    0x8(%ebp),%edx
  800162:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800165:	b8 04 00 00 00       	mov    $0x4,%eax
  80016a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80016d:	89 f7                	mov    %esi,%edi
  80016f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800171:	85 c0                	test   %eax,%eax
  800173:	7f 08                	jg     80017d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800175:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800178:	5b                   	pop    %ebx
  800179:	5e                   	pop    %esi
  80017a:	5f                   	pop    %edi
  80017b:	5d                   	pop    %ebp
  80017c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	50                   	push   %eax
  800181:	6a 04                	push   $0x4
  800183:	68 6a 22 80 00       	push   $0x80226a
  800188:	6a 23                	push   $0x23
  80018a:	68 87 22 80 00       	push   $0x802287
  80018f:	e8 30 13 00 00       	call   8014c4 <_panic>

00800194 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	57                   	push   %edi
  800198:	56                   	push   %esi
  800199:	53                   	push   %ebx
  80019a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80019d:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a3:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ab:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b3:	85 c0                	test   %eax,%eax
  8001b5:	7f 08                	jg     8001bf <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ba:	5b                   	pop    %ebx
  8001bb:	5e                   	pop    %esi
  8001bc:	5f                   	pop    %edi
  8001bd:	5d                   	pop    %ebp
  8001be:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	50                   	push   %eax
  8001c3:	6a 05                	push   $0x5
  8001c5:	68 6a 22 80 00       	push   $0x80226a
  8001ca:	6a 23                	push   $0x23
  8001cc:	68 87 22 80 00       	push   $0x802287
  8001d1:	e8 ee 12 00 00       	call   8014c4 <_panic>

008001d6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	57                   	push   %edi
  8001da:	56                   	push   %esi
  8001db:	53                   	push   %ebx
  8001dc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ea:	b8 06 00 00 00       	mov    $0x6,%eax
  8001ef:	89 df                	mov    %ebx,%edi
  8001f1:	89 de                	mov    %ebx,%esi
  8001f3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f5:	85 c0                	test   %eax,%eax
  8001f7:	7f 08                	jg     800201 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fc:	5b                   	pop    %ebx
  8001fd:	5e                   	pop    %esi
  8001fe:	5f                   	pop    %edi
  8001ff:	5d                   	pop    %ebp
  800200:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	50                   	push   %eax
  800205:	6a 06                	push   $0x6
  800207:	68 6a 22 80 00       	push   $0x80226a
  80020c:	6a 23                	push   $0x23
  80020e:	68 87 22 80 00       	push   $0x802287
  800213:	e8 ac 12 00 00       	call   8014c4 <_panic>

00800218 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	57                   	push   %edi
  80021c:	56                   	push   %esi
  80021d:	53                   	push   %ebx
  80021e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800221:	bb 00 00 00 00       	mov    $0x0,%ebx
  800226:	8b 55 08             	mov    0x8(%ebp),%edx
  800229:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80022c:	b8 08 00 00 00       	mov    $0x8,%eax
  800231:	89 df                	mov    %ebx,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	cd 30                	int    $0x30
	if(check && ret > 0)
  800237:	85 c0                	test   %eax,%eax
  800239:	7f 08                	jg     800243 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80023b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023e:	5b                   	pop    %ebx
  80023f:	5e                   	pop    %esi
  800240:	5f                   	pop    %edi
  800241:	5d                   	pop    %ebp
  800242:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800243:	83 ec 0c             	sub    $0xc,%esp
  800246:	50                   	push   %eax
  800247:	6a 08                	push   $0x8
  800249:	68 6a 22 80 00       	push   $0x80226a
  80024e:	6a 23                	push   $0x23
  800250:	68 87 22 80 00       	push   $0x802287
  800255:	e8 6a 12 00 00       	call   8014c4 <_panic>

0080025a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	57                   	push   %edi
  80025e:	56                   	push   %esi
  80025f:	53                   	push   %ebx
  800260:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800263:	bb 00 00 00 00       	mov    $0x0,%ebx
  800268:	8b 55 08             	mov    0x8(%ebp),%edx
  80026b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026e:	b8 09 00 00 00       	mov    $0x9,%eax
  800273:	89 df                	mov    %ebx,%edi
  800275:	89 de                	mov    %ebx,%esi
  800277:	cd 30                	int    $0x30
	if(check && ret > 0)
  800279:	85 c0                	test   %eax,%eax
  80027b:	7f 08                	jg     800285 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80027d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800280:	5b                   	pop    %ebx
  800281:	5e                   	pop    %esi
  800282:	5f                   	pop    %edi
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	50                   	push   %eax
  800289:	6a 09                	push   $0x9
  80028b:	68 6a 22 80 00       	push   $0x80226a
  800290:	6a 23                	push   $0x23
  800292:	68 87 22 80 00       	push   $0x802287
  800297:	e8 28 12 00 00       	call   8014c4 <_panic>

0080029c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	57                   	push   %edi
  8002a0:	56                   	push   %esi
  8002a1:	53                   	push   %ebx
  8002a2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b5:	89 df                	mov    %ebx,%edi
  8002b7:	89 de                	mov    %ebx,%esi
  8002b9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002bb:	85 c0                	test   %eax,%eax
  8002bd:	7f 08                	jg     8002c7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c2:	5b                   	pop    %ebx
  8002c3:	5e                   	pop    %esi
  8002c4:	5f                   	pop    %edi
  8002c5:	5d                   	pop    %ebp
  8002c6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	50                   	push   %eax
  8002cb:	6a 0a                	push   $0xa
  8002cd:	68 6a 22 80 00       	push   $0x80226a
  8002d2:	6a 23                	push   $0x23
  8002d4:	68 87 22 80 00       	push   $0x802287
  8002d9:	e8 e6 11 00 00       	call   8014c4 <_panic>

008002de <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ea:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002ef:	be 00 00 00 00       	mov    $0x0,%esi
  8002f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002f7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002fa:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002fc:	5b                   	pop    %ebx
  8002fd:	5e                   	pop    %esi
  8002fe:	5f                   	pop    %edi
  8002ff:	5d                   	pop    %ebp
  800300:	c3                   	ret    

00800301 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	57                   	push   %edi
  800305:	56                   	push   %esi
  800306:	53                   	push   %ebx
  800307:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80030f:	8b 55 08             	mov    0x8(%ebp),%edx
  800312:	b8 0d 00 00 00       	mov    $0xd,%eax
  800317:	89 cb                	mov    %ecx,%ebx
  800319:	89 cf                	mov    %ecx,%edi
  80031b:	89 ce                	mov    %ecx,%esi
  80031d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80031f:	85 c0                	test   %eax,%eax
  800321:	7f 08                	jg     80032b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800323:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800326:	5b                   	pop    %ebx
  800327:	5e                   	pop    %esi
  800328:	5f                   	pop    %edi
  800329:	5d                   	pop    %ebp
  80032a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032b:	83 ec 0c             	sub    $0xc,%esp
  80032e:	50                   	push   %eax
  80032f:	6a 0d                	push   $0xd
  800331:	68 6a 22 80 00       	push   $0x80226a
  800336:	6a 23                	push   $0x23
  800338:	68 87 22 80 00       	push   $0x802287
  80033d:	e8 82 11 00 00       	call   8014c4 <_panic>

00800342 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	57                   	push   %edi
  800346:	56                   	push   %esi
  800347:	53                   	push   %ebx
	asm volatile("int %1\n"
  800348:	ba 00 00 00 00       	mov    $0x0,%edx
  80034d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800352:	89 d1                	mov    %edx,%ecx
  800354:	89 d3                	mov    %edx,%ebx
  800356:	89 d7                	mov    %edx,%edi
  800358:	89 d6                	mov    %edx,%esi
  80035a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80035c:	5b                   	pop    %ebx
  80035d:	5e                   	pop    %esi
  80035e:	5f                   	pop    %edi
  80035f:	5d                   	pop    %ebp
  800360:	c3                   	ret    

00800361 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800364:	8b 45 08             	mov    0x8(%ebp),%eax
  800367:	05 00 00 00 30       	add    $0x30000000,%eax
  80036c:	c1 e8 0c             	shr    $0xc,%eax
}
  80036f:	5d                   	pop    %ebp
  800370:	c3                   	ret    

00800371 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800371:	55                   	push   %ebp
  800372:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80037c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800381:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800386:	5d                   	pop    %ebp
  800387:	c3                   	ret    

00800388 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800390:	89 c2                	mov    %eax,%edx
  800392:	c1 ea 16             	shr    $0x16,%edx
  800395:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80039c:	f6 c2 01             	test   $0x1,%dl
  80039f:	74 2d                	je     8003ce <fd_alloc+0x46>
  8003a1:	89 c2                	mov    %eax,%edx
  8003a3:	c1 ea 0c             	shr    $0xc,%edx
  8003a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003ad:	f6 c2 01             	test   $0x1,%dl
  8003b0:	74 1c                	je     8003ce <fd_alloc+0x46>
  8003b2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003b7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003bc:	75 d2                	jne    800390 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8003c7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003cc:	eb 0a                	jmp    8003d8 <fd_alloc+0x50>
			*fd_store = fd;
  8003ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003d8:	5d                   	pop    %ebp
  8003d9:	c3                   	ret    

008003da <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003e0:	83 f8 1f             	cmp    $0x1f,%eax
  8003e3:	77 30                	ja     800415 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003e5:	c1 e0 0c             	shl    $0xc,%eax
  8003e8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003ed:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8003f3:	f6 c2 01             	test   $0x1,%dl
  8003f6:	74 24                	je     80041c <fd_lookup+0x42>
  8003f8:	89 c2                	mov    %eax,%edx
  8003fa:	c1 ea 0c             	shr    $0xc,%edx
  8003fd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800404:	f6 c2 01             	test   $0x1,%dl
  800407:	74 1a                	je     800423 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800409:	8b 55 0c             	mov    0xc(%ebp),%edx
  80040c:	89 02                	mov    %eax,(%edx)
	return 0;
  80040e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800413:	5d                   	pop    %ebp
  800414:	c3                   	ret    
		return -E_INVAL;
  800415:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80041a:	eb f7                	jmp    800413 <fd_lookup+0x39>
		return -E_INVAL;
  80041c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800421:	eb f0                	jmp    800413 <fd_lookup+0x39>
  800423:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800428:	eb e9                	jmp    800413 <fd_lookup+0x39>

0080042a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 08             	sub    $0x8,%esp
  800430:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800433:	ba 00 00 00 00       	mov    $0x0,%edx
  800438:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80043d:	39 08                	cmp    %ecx,(%eax)
  80043f:	74 38                	je     800479 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800441:	83 c2 01             	add    $0x1,%edx
  800444:	8b 04 95 14 23 80 00 	mov    0x802314(,%edx,4),%eax
  80044b:	85 c0                	test   %eax,%eax
  80044d:	75 ee                	jne    80043d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80044f:	a1 08 40 80 00       	mov    0x804008,%eax
  800454:	8b 40 48             	mov    0x48(%eax),%eax
  800457:	83 ec 04             	sub    $0x4,%esp
  80045a:	51                   	push   %ecx
  80045b:	50                   	push   %eax
  80045c:	68 98 22 80 00       	push   $0x802298
  800461:	e8 39 11 00 00       	call   80159f <cprintf>
	*dev = 0;
  800466:	8b 45 0c             	mov    0xc(%ebp),%eax
  800469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80046f:	83 c4 10             	add    $0x10,%esp
  800472:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800477:	c9                   	leave  
  800478:	c3                   	ret    
			*dev = devtab[i];
  800479:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80047c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80047e:	b8 00 00 00 00       	mov    $0x0,%eax
  800483:	eb f2                	jmp    800477 <dev_lookup+0x4d>

00800485 <fd_close>:
{
  800485:	55                   	push   %ebp
  800486:	89 e5                	mov    %esp,%ebp
  800488:	57                   	push   %edi
  800489:	56                   	push   %esi
  80048a:	53                   	push   %ebx
  80048b:	83 ec 24             	sub    $0x24,%esp
  80048e:	8b 75 08             	mov    0x8(%ebp),%esi
  800491:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800494:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800497:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800498:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80049e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a1:	50                   	push   %eax
  8004a2:	e8 33 ff ff ff       	call   8003da <fd_lookup>
  8004a7:	89 c3                	mov    %eax,%ebx
  8004a9:	83 c4 10             	add    $0x10,%esp
  8004ac:	85 c0                	test   %eax,%eax
  8004ae:	78 05                	js     8004b5 <fd_close+0x30>
	    || fd != fd2)
  8004b0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004b3:	74 16                	je     8004cb <fd_close+0x46>
		return (must_exist ? r : 0);
  8004b5:	89 f8                	mov    %edi,%eax
  8004b7:	84 c0                	test   %al,%al
  8004b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004be:	0f 44 d8             	cmove  %eax,%ebx
}
  8004c1:	89 d8                	mov    %ebx,%eax
  8004c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004c6:	5b                   	pop    %ebx
  8004c7:	5e                   	pop    %esi
  8004c8:	5f                   	pop    %edi
  8004c9:	5d                   	pop    %ebp
  8004ca:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004d1:	50                   	push   %eax
  8004d2:	ff 36                	pushl  (%esi)
  8004d4:	e8 51 ff ff ff       	call   80042a <dev_lookup>
  8004d9:	89 c3                	mov    %eax,%ebx
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	85 c0                	test   %eax,%eax
  8004e0:	78 1a                	js     8004fc <fd_close+0x77>
		if (dev->dev_close)
  8004e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8004e8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8004ed:	85 c0                	test   %eax,%eax
  8004ef:	74 0b                	je     8004fc <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8004f1:	83 ec 0c             	sub    $0xc,%esp
  8004f4:	56                   	push   %esi
  8004f5:	ff d0                	call   *%eax
  8004f7:	89 c3                	mov    %eax,%ebx
  8004f9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	56                   	push   %esi
  800500:	6a 00                	push   $0x0
  800502:	e8 cf fc ff ff       	call   8001d6 <sys_page_unmap>
	return r;
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	eb b5                	jmp    8004c1 <fd_close+0x3c>

0080050c <close>:

int
close(int fdnum)
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800512:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800515:	50                   	push   %eax
  800516:	ff 75 08             	pushl  0x8(%ebp)
  800519:	e8 bc fe ff ff       	call   8003da <fd_lookup>
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	85 c0                	test   %eax,%eax
  800523:	79 02                	jns    800527 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800525:	c9                   	leave  
  800526:	c3                   	ret    
		return fd_close(fd, 1);
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	6a 01                	push   $0x1
  80052c:	ff 75 f4             	pushl  -0xc(%ebp)
  80052f:	e8 51 ff ff ff       	call   800485 <fd_close>
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	eb ec                	jmp    800525 <close+0x19>

00800539 <close_all>:

void
close_all(void)
{
  800539:	55                   	push   %ebp
  80053a:	89 e5                	mov    %esp,%ebp
  80053c:	53                   	push   %ebx
  80053d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800540:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800545:	83 ec 0c             	sub    $0xc,%esp
  800548:	53                   	push   %ebx
  800549:	e8 be ff ff ff       	call   80050c <close>
	for (i = 0; i < MAXFD; i++)
  80054e:	83 c3 01             	add    $0x1,%ebx
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	83 fb 20             	cmp    $0x20,%ebx
  800557:	75 ec                	jne    800545 <close_all+0xc>
}
  800559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	57                   	push   %edi
  800562:	56                   	push   %esi
  800563:	53                   	push   %ebx
  800564:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800567:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80056a:	50                   	push   %eax
  80056b:	ff 75 08             	pushl  0x8(%ebp)
  80056e:	e8 67 fe ff ff       	call   8003da <fd_lookup>
  800573:	89 c3                	mov    %eax,%ebx
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	85 c0                	test   %eax,%eax
  80057a:	0f 88 81 00 00 00    	js     800601 <dup+0xa3>
		return r;
	close(newfdnum);
  800580:	83 ec 0c             	sub    $0xc,%esp
  800583:	ff 75 0c             	pushl  0xc(%ebp)
  800586:	e8 81 ff ff ff       	call   80050c <close>

	newfd = INDEX2FD(newfdnum);
  80058b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80058e:	c1 e6 0c             	shl    $0xc,%esi
  800591:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800597:	83 c4 04             	add    $0x4,%esp
  80059a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80059d:	e8 cf fd ff ff       	call   800371 <fd2data>
  8005a2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005a4:	89 34 24             	mov    %esi,(%esp)
  8005a7:	e8 c5 fd ff ff       	call   800371 <fd2data>
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005b1:	89 d8                	mov    %ebx,%eax
  8005b3:	c1 e8 16             	shr    $0x16,%eax
  8005b6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005bd:	a8 01                	test   $0x1,%al
  8005bf:	74 11                	je     8005d2 <dup+0x74>
  8005c1:	89 d8                	mov    %ebx,%eax
  8005c3:	c1 e8 0c             	shr    $0xc,%eax
  8005c6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005cd:	f6 c2 01             	test   $0x1,%dl
  8005d0:	75 39                	jne    80060b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d5:	89 d0                	mov    %edx,%eax
  8005d7:	c1 e8 0c             	shr    $0xc,%eax
  8005da:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005e1:	83 ec 0c             	sub    $0xc,%esp
  8005e4:	25 07 0e 00 00       	and    $0xe07,%eax
  8005e9:	50                   	push   %eax
  8005ea:	56                   	push   %esi
  8005eb:	6a 00                	push   $0x0
  8005ed:	52                   	push   %edx
  8005ee:	6a 00                	push   $0x0
  8005f0:	e8 9f fb ff ff       	call   800194 <sys_page_map>
  8005f5:	89 c3                	mov    %eax,%ebx
  8005f7:	83 c4 20             	add    $0x20,%esp
  8005fa:	85 c0                	test   %eax,%eax
  8005fc:	78 31                	js     80062f <dup+0xd1>
		goto err;

	return newfdnum;
  8005fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800601:	89 d8                	mov    %ebx,%eax
  800603:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800606:	5b                   	pop    %ebx
  800607:	5e                   	pop    %esi
  800608:	5f                   	pop    %edi
  800609:	5d                   	pop    %ebp
  80060a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80060b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800612:	83 ec 0c             	sub    $0xc,%esp
  800615:	25 07 0e 00 00       	and    $0xe07,%eax
  80061a:	50                   	push   %eax
  80061b:	57                   	push   %edi
  80061c:	6a 00                	push   $0x0
  80061e:	53                   	push   %ebx
  80061f:	6a 00                	push   $0x0
  800621:	e8 6e fb ff ff       	call   800194 <sys_page_map>
  800626:	89 c3                	mov    %eax,%ebx
  800628:	83 c4 20             	add    $0x20,%esp
  80062b:	85 c0                	test   %eax,%eax
  80062d:	79 a3                	jns    8005d2 <dup+0x74>
	sys_page_unmap(0, newfd);
  80062f:	83 ec 08             	sub    $0x8,%esp
  800632:	56                   	push   %esi
  800633:	6a 00                	push   $0x0
  800635:	e8 9c fb ff ff       	call   8001d6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80063a:	83 c4 08             	add    $0x8,%esp
  80063d:	57                   	push   %edi
  80063e:	6a 00                	push   $0x0
  800640:	e8 91 fb ff ff       	call   8001d6 <sys_page_unmap>
	return r;
  800645:	83 c4 10             	add    $0x10,%esp
  800648:	eb b7                	jmp    800601 <dup+0xa3>

0080064a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80064a:	55                   	push   %ebp
  80064b:	89 e5                	mov    %esp,%ebp
  80064d:	53                   	push   %ebx
  80064e:	83 ec 1c             	sub    $0x1c,%esp
  800651:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800654:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800657:	50                   	push   %eax
  800658:	53                   	push   %ebx
  800659:	e8 7c fd ff ff       	call   8003da <fd_lookup>
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	85 c0                	test   %eax,%eax
  800663:	78 3f                	js     8006a4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80066b:	50                   	push   %eax
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066f:	ff 30                	pushl  (%eax)
  800671:	e8 b4 fd ff ff       	call   80042a <dev_lookup>
  800676:	83 c4 10             	add    $0x10,%esp
  800679:	85 c0                	test   %eax,%eax
  80067b:	78 27                	js     8006a4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80067d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800680:	8b 42 08             	mov    0x8(%edx),%eax
  800683:	83 e0 03             	and    $0x3,%eax
  800686:	83 f8 01             	cmp    $0x1,%eax
  800689:	74 1e                	je     8006a9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80068b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068e:	8b 40 08             	mov    0x8(%eax),%eax
  800691:	85 c0                	test   %eax,%eax
  800693:	74 35                	je     8006ca <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800695:	83 ec 04             	sub    $0x4,%esp
  800698:	ff 75 10             	pushl  0x10(%ebp)
  80069b:	ff 75 0c             	pushl  0xc(%ebp)
  80069e:	52                   	push   %edx
  80069f:	ff d0                	call   *%eax
  8006a1:	83 c4 10             	add    $0x10,%esp
}
  8006a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a7:	c9                   	leave  
  8006a8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006a9:	a1 08 40 80 00       	mov    0x804008,%eax
  8006ae:	8b 40 48             	mov    0x48(%eax),%eax
  8006b1:	83 ec 04             	sub    $0x4,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	50                   	push   %eax
  8006b6:	68 d9 22 80 00       	push   $0x8022d9
  8006bb:	e8 df 0e 00 00       	call   80159f <cprintf>
		return -E_INVAL;
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006c8:	eb da                	jmp    8006a4 <read+0x5a>
		return -E_NOT_SUPP;
  8006ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006cf:	eb d3                	jmp    8006a4 <read+0x5a>

008006d1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006d1:	55                   	push   %ebp
  8006d2:	89 e5                	mov    %esp,%ebp
  8006d4:	57                   	push   %edi
  8006d5:	56                   	push   %esi
  8006d6:	53                   	push   %ebx
  8006d7:	83 ec 0c             	sub    $0xc,%esp
  8006da:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006dd:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e5:	39 f3                	cmp    %esi,%ebx
  8006e7:	73 23                	jae    80070c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006e9:	83 ec 04             	sub    $0x4,%esp
  8006ec:	89 f0                	mov    %esi,%eax
  8006ee:	29 d8                	sub    %ebx,%eax
  8006f0:	50                   	push   %eax
  8006f1:	89 d8                	mov    %ebx,%eax
  8006f3:	03 45 0c             	add    0xc(%ebp),%eax
  8006f6:	50                   	push   %eax
  8006f7:	57                   	push   %edi
  8006f8:	e8 4d ff ff ff       	call   80064a <read>
		if (m < 0)
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	85 c0                	test   %eax,%eax
  800702:	78 06                	js     80070a <readn+0x39>
			return m;
		if (m == 0)
  800704:	74 06                	je     80070c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  800706:	01 c3                	add    %eax,%ebx
  800708:	eb db                	jmp    8006e5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80070a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80070c:	89 d8                	mov    %ebx,%eax
  80070e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800711:	5b                   	pop    %ebx
  800712:	5e                   	pop    %esi
  800713:	5f                   	pop    %edi
  800714:	5d                   	pop    %ebp
  800715:	c3                   	ret    

00800716 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800716:	55                   	push   %ebp
  800717:	89 e5                	mov    %esp,%ebp
  800719:	53                   	push   %ebx
  80071a:	83 ec 1c             	sub    $0x1c,%esp
  80071d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800720:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800723:	50                   	push   %eax
  800724:	53                   	push   %ebx
  800725:	e8 b0 fc ff ff       	call   8003da <fd_lookup>
  80072a:	83 c4 10             	add    $0x10,%esp
  80072d:	85 c0                	test   %eax,%eax
  80072f:	78 3a                	js     80076b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800737:	50                   	push   %eax
  800738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073b:	ff 30                	pushl  (%eax)
  80073d:	e8 e8 fc ff ff       	call   80042a <dev_lookup>
  800742:	83 c4 10             	add    $0x10,%esp
  800745:	85 c0                	test   %eax,%eax
  800747:	78 22                	js     80076b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800750:	74 1e                	je     800770 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800752:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800755:	8b 52 0c             	mov    0xc(%edx),%edx
  800758:	85 d2                	test   %edx,%edx
  80075a:	74 35                	je     800791 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80075c:	83 ec 04             	sub    $0x4,%esp
  80075f:	ff 75 10             	pushl  0x10(%ebp)
  800762:	ff 75 0c             	pushl  0xc(%ebp)
  800765:	50                   	push   %eax
  800766:	ff d2                	call   *%edx
  800768:	83 c4 10             	add    $0x10,%esp
}
  80076b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80076e:	c9                   	leave  
  80076f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800770:	a1 08 40 80 00       	mov    0x804008,%eax
  800775:	8b 40 48             	mov    0x48(%eax),%eax
  800778:	83 ec 04             	sub    $0x4,%esp
  80077b:	53                   	push   %ebx
  80077c:	50                   	push   %eax
  80077d:	68 f5 22 80 00       	push   $0x8022f5
  800782:	e8 18 0e 00 00       	call   80159f <cprintf>
		return -E_INVAL;
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80078f:	eb da                	jmp    80076b <write+0x55>
		return -E_NOT_SUPP;
  800791:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800796:	eb d3                	jmp    80076b <write+0x55>

00800798 <seek>:

int
seek(int fdnum, off_t offset)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80079e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007a1:	50                   	push   %eax
  8007a2:	ff 75 08             	pushl  0x8(%ebp)
  8007a5:	e8 30 fc ff ff       	call   8003da <fd_lookup>
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	85 c0                	test   %eax,%eax
  8007af:	78 0e                	js     8007bf <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007bf:	c9                   	leave  
  8007c0:	c3                   	ret    

008007c1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	53                   	push   %ebx
  8007c5:	83 ec 1c             	sub    $0x1c,%esp
  8007c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007ce:	50                   	push   %eax
  8007cf:	53                   	push   %ebx
  8007d0:	e8 05 fc ff ff       	call   8003da <fd_lookup>
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	85 c0                	test   %eax,%eax
  8007da:	78 37                	js     800813 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007e2:	50                   	push   %eax
  8007e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e6:	ff 30                	pushl  (%eax)
  8007e8:	e8 3d fc ff ff       	call   80042a <dev_lookup>
  8007ed:	83 c4 10             	add    $0x10,%esp
  8007f0:	85 c0                	test   %eax,%eax
  8007f2:	78 1f                	js     800813 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007fb:	74 1b                	je     800818 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8007fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800800:	8b 52 18             	mov    0x18(%edx),%edx
  800803:	85 d2                	test   %edx,%edx
  800805:	74 32                	je     800839 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	ff 75 0c             	pushl  0xc(%ebp)
  80080d:	50                   	push   %eax
  80080e:	ff d2                	call   *%edx
  800810:	83 c4 10             	add    $0x10,%esp
}
  800813:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800816:	c9                   	leave  
  800817:	c3                   	ret    
			thisenv->env_id, fdnum);
  800818:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80081d:	8b 40 48             	mov    0x48(%eax),%eax
  800820:	83 ec 04             	sub    $0x4,%esp
  800823:	53                   	push   %ebx
  800824:	50                   	push   %eax
  800825:	68 b8 22 80 00       	push   $0x8022b8
  80082a:	e8 70 0d 00 00       	call   80159f <cprintf>
		return -E_INVAL;
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800837:	eb da                	jmp    800813 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800839:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80083e:	eb d3                	jmp    800813 <ftruncate+0x52>

00800840 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	53                   	push   %ebx
  800844:	83 ec 1c             	sub    $0x1c,%esp
  800847:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80084a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80084d:	50                   	push   %eax
  80084e:	ff 75 08             	pushl  0x8(%ebp)
  800851:	e8 84 fb ff ff       	call   8003da <fd_lookup>
  800856:	83 c4 10             	add    $0x10,%esp
  800859:	85 c0                	test   %eax,%eax
  80085b:	78 4b                	js     8008a8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800863:	50                   	push   %eax
  800864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800867:	ff 30                	pushl  (%eax)
  800869:	e8 bc fb ff ff       	call   80042a <dev_lookup>
  80086e:	83 c4 10             	add    $0x10,%esp
  800871:	85 c0                	test   %eax,%eax
  800873:	78 33                	js     8008a8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800878:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80087c:	74 2f                	je     8008ad <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80087e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800881:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800888:	00 00 00 
	stat->st_isdir = 0;
  80088b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800892:	00 00 00 
	stat->st_dev = dev;
  800895:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	53                   	push   %ebx
  80089f:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a2:	ff 50 14             	call   *0x14(%eax)
  8008a5:	83 c4 10             	add    $0x10,%esp
}
  8008a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ab:	c9                   	leave  
  8008ac:	c3                   	ret    
		return -E_NOT_SUPP;
  8008ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008b2:	eb f4                	jmp    8008a8 <fstat+0x68>

008008b4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	56                   	push   %esi
  8008b8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	6a 00                	push   $0x0
  8008be:	ff 75 08             	pushl  0x8(%ebp)
  8008c1:	e8 2f 02 00 00       	call   800af5 <open>
  8008c6:	89 c3                	mov    %eax,%ebx
  8008c8:	83 c4 10             	add    $0x10,%esp
  8008cb:	85 c0                	test   %eax,%eax
  8008cd:	78 1b                	js     8008ea <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	ff 75 0c             	pushl  0xc(%ebp)
  8008d5:	50                   	push   %eax
  8008d6:	e8 65 ff ff ff       	call   800840 <fstat>
  8008db:	89 c6                	mov    %eax,%esi
	close(fd);
  8008dd:	89 1c 24             	mov    %ebx,(%esp)
  8008e0:	e8 27 fc ff ff       	call   80050c <close>
	return r;
  8008e5:	83 c4 10             	add    $0x10,%esp
  8008e8:	89 f3                	mov    %esi,%ebx
}
  8008ea:	89 d8                	mov    %ebx,%eax
  8008ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008ef:	5b                   	pop    %ebx
  8008f0:	5e                   	pop    %esi
  8008f1:	5d                   	pop    %ebp
  8008f2:	c3                   	ret    

008008f3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	56                   	push   %esi
  8008f7:	53                   	push   %ebx
  8008f8:	89 c6                	mov    %eax,%esi
  8008fa:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8008fc:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800903:	74 27                	je     80092c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800905:	6a 07                	push   $0x7
  800907:	68 00 50 80 00       	push   $0x805000
  80090c:	56                   	push   %esi
  80090d:	ff 35 00 40 80 00    	pushl  0x804000
  800913:	e8 0c 16 00 00       	call   801f24 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800918:	83 c4 0c             	add    $0xc,%esp
  80091b:	6a 00                	push   $0x0
  80091d:	53                   	push   %ebx
  80091e:	6a 00                	push   $0x0
  800920:	e8 8c 15 00 00       	call   801eb1 <ipc_recv>
}
  800925:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800928:	5b                   	pop    %ebx
  800929:	5e                   	pop    %esi
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80092c:	83 ec 0c             	sub    $0xc,%esp
  80092f:	6a 01                	push   $0x1
  800931:	e8 5a 16 00 00       	call   801f90 <ipc_find_env>
  800936:	a3 00 40 80 00       	mov    %eax,0x804000
  80093b:	83 c4 10             	add    $0x10,%esp
  80093e:	eb c5                	jmp    800905 <fsipc+0x12>

00800940 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 40 0c             	mov    0xc(%eax),%eax
  80094c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800959:	ba 00 00 00 00       	mov    $0x0,%edx
  80095e:	b8 02 00 00 00       	mov    $0x2,%eax
  800963:	e8 8b ff ff ff       	call   8008f3 <fsipc>
}
  800968:	c9                   	leave  
  800969:	c3                   	ret    

0080096a <devfile_flush>:
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8b 40 0c             	mov    0xc(%eax),%eax
  800976:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80097b:	ba 00 00 00 00       	mov    $0x0,%edx
  800980:	b8 06 00 00 00       	mov    $0x6,%eax
  800985:	e8 69 ff ff ff       	call   8008f3 <fsipc>
}
  80098a:	c9                   	leave  
  80098b:	c3                   	ret    

0080098c <devfile_stat>:
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	53                   	push   %ebx
  800990:	83 ec 04             	sub    $0x4,%esp
  800993:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	8b 40 0c             	mov    0xc(%eax),%eax
  80099c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a6:	b8 05 00 00 00       	mov    $0x5,%eax
  8009ab:	e8 43 ff ff ff       	call   8008f3 <fsipc>
  8009b0:	85 c0                	test   %eax,%eax
  8009b2:	78 2c                	js     8009e0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	68 00 50 80 00       	push   $0x805000
  8009bc:	53                   	push   %ebx
  8009bd:	e8 b9 11 00 00       	call   801b7b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009c2:	a1 80 50 80 00       	mov    0x805080,%eax
  8009c7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009cd:	a1 84 50 80 00       	mov    0x805084,%eax
  8009d2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009d8:	83 c4 10             	add    $0x10,%esp
  8009db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e3:	c9                   	leave  
  8009e4:	c3                   	ret    

008009e5 <devfile_write>:
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	53                   	push   %ebx
  8009e9:	83 ec 04             	sub    $0x4,%esp
  8009ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8009ef:	85 db                	test   %ebx,%ebx
  8009f1:	75 07                	jne    8009fa <devfile_write+0x15>
	return n_all;
  8009f3:	89 d8                	mov    %ebx,%eax
}
  8009f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f8:	c9                   	leave  
  8009f9:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8b 40 0c             	mov    0xc(%eax),%eax
  800a00:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  800a05:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  800a0b:	83 ec 04             	sub    $0x4,%esp
  800a0e:	53                   	push   %ebx
  800a0f:	ff 75 0c             	pushl  0xc(%ebp)
  800a12:	68 08 50 80 00       	push   $0x805008
  800a17:	e8 ed 12 00 00       	call   801d09 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a21:	b8 04 00 00 00       	mov    $0x4,%eax
  800a26:	e8 c8 fe ff ff       	call   8008f3 <fsipc>
  800a2b:	83 c4 10             	add    $0x10,%esp
  800a2e:	85 c0                	test   %eax,%eax
  800a30:	78 c3                	js     8009f5 <devfile_write+0x10>
	  assert(r <= n_left);
  800a32:	39 d8                	cmp    %ebx,%eax
  800a34:	77 0b                	ja     800a41 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  800a36:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a3b:	7f 1d                	jg     800a5a <devfile_write+0x75>
    n_all += r;
  800a3d:	89 c3                	mov    %eax,%ebx
  800a3f:	eb b2                	jmp    8009f3 <devfile_write+0xe>
	  assert(r <= n_left);
  800a41:	68 28 23 80 00       	push   $0x802328
  800a46:	68 34 23 80 00       	push   $0x802334
  800a4b:	68 9f 00 00 00       	push   $0x9f
  800a50:	68 49 23 80 00       	push   $0x802349
  800a55:	e8 6a 0a 00 00       	call   8014c4 <_panic>
	  assert(r <= PGSIZE);
  800a5a:	68 54 23 80 00       	push   $0x802354
  800a5f:	68 34 23 80 00       	push   $0x802334
  800a64:	68 a0 00 00 00       	push   $0xa0
  800a69:	68 49 23 80 00       	push   $0x802349
  800a6e:	e8 51 0a 00 00       	call   8014c4 <_panic>

00800a73 <devfile_read>:
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	56                   	push   %esi
  800a77:	53                   	push   %ebx
  800a78:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 40 0c             	mov    0xc(%eax),%eax
  800a81:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a86:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a91:	b8 03 00 00 00       	mov    $0x3,%eax
  800a96:	e8 58 fe ff ff       	call   8008f3 <fsipc>
  800a9b:	89 c3                	mov    %eax,%ebx
  800a9d:	85 c0                	test   %eax,%eax
  800a9f:	78 1f                	js     800ac0 <devfile_read+0x4d>
	assert(r <= n);
  800aa1:	39 f0                	cmp    %esi,%eax
  800aa3:	77 24                	ja     800ac9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800aa5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aaa:	7f 33                	jg     800adf <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	50                   	push   %eax
  800ab0:	68 00 50 80 00       	push   $0x805000
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	e8 4c 12 00 00       	call   801d09 <memmove>
	return r;
  800abd:	83 c4 10             	add    $0x10,%esp
}
  800ac0:	89 d8                	mov    %ebx,%eax
  800ac2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac5:	5b                   	pop    %ebx
  800ac6:	5e                   	pop    %esi
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    
	assert(r <= n);
  800ac9:	68 60 23 80 00       	push   $0x802360
  800ace:	68 34 23 80 00       	push   $0x802334
  800ad3:	6a 7c                	push   $0x7c
  800ad5:	68 49 23 80 00       	push   $0x802349
  800ada:	e8 e5 09 00 00       	call   8014c4 <_panic>
	assert(r <= PGSIZE);
  800adf:	68 54 23 80 00       	push   $0x802354
  800ae4:	68 34 23 80 00       	push   $0x802334
  800ae9:	6a 7d                	push   $0x7d
  800aeb:	68 49 23 80 00       	push   $0x802349
  800af0:	e8 cf 09 00 00       	call   8014c4 <_panic>

00800af5 <open>:
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
  800afa:	83 ec 1c             	sub    $0x1c,%esp
  800afd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b00:	56                   	push   %esi
  800b01:	e8 3c 10 00 00       	call   801b42 <strlen>
  800b06:	83 c4 10             	add    $0x10,%esp
  800b09:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b0e:	7f 6c                	jg     800b7c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b10:	83 ec 0c             	sub    $0xc,%esp
  800b13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b16:	50                   	push   %eax
  800b17:	e8 6c f8 ff ff       	call   800388 <fd_alloc>
  800b1c:	89 c3                	mov    %eax,%ebx
  800b1e:	83 c4 10             	add    $0x10,%esp
  800b21:	85 c0                	test   %eax,%eax
  800b23:	78 3c                	js     800b61 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	56                   	push   %esi
  800b29:	68 00 50 80 00       	push   $0x805000
  800b2e:	e8 48 10 00 00       	call   801b7b <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b3e:	b8 01 00 00 00       	mov    $0x1,%eax
  800b43:	e8 ab fd ff ff       	call   8008f3 <fsipc>
  800b48:	89 c3                	mov    %eax,%ebx
  800b4a:	83 c4 10             	add    $0x10,%esp
  800b4d:	85 c0                	test   %eax,%eax
  800b4f:	78 19                	js     800b6a <open+0x75>
	return fd2num(fd);
  800b51:	83 ec 0c             	sub    $0xc,%esp
  800b54:	ff 75 f4             	pushl  -0xc(%ebp)
  800b57:	e8 05 f8 ff ff       	call   800361 <fd2num>
  800b5c:	89 c3                	mov    %eax,%ebx
  800b5e:	83 c4 10             	add    $0x10,%esp
}
  800b61:	89 d8                	mov    %ebx,%eax
  800b63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b66:	5b                   	pop    %ebx
  800b67:	5e                   	pop    %esi
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    
		fd_close(fd, 0);
  800b6a:	83 ec 08             	sub    $0x8,%esp
  800b6d:	6a 00                	push   $0x0
  800b6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b72:	e8 0e f9 ff ff       	call   800485 <fd_close>
		return r;
  800b77:	83 c4 10             	add    $0x10,%esp
  800b7a:	eb e5                	jmp    800b61 <open+0x6c>
		return -E_BAD_PATH;
  800b7c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b81:	eb de                	jmp    800b61 <open+0x6c>

00800b83 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b89:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8e:	b8 08 00 00 00       	mov    $0x8,%eax
  800b93:	e8 5b fd ff ff       	call   8008f3 <fsipc>
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	56                   	push   %esi
  800b9e:	53                   	push   %ebx
  800b9f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800ba2:	83 ec 0c             	sub    $0xc,%esp
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 c4 f7 ff ff       	call   800371 <fd2data>
  800bad:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800baf:	83 c4 08             	add    $0x8,%esp
  800bb2:	68 67 23 80 00       	push   $0x802367
  800bb7:	53                   	push   %ebx
  800bb8:	e8 be 0f 00 00       	call   801b7b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bbd:	8b 46 04             	mov    0x4(%esi),%eax
  800bc0:	2b 06                	sub    (%esi),%eax
  800bc2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bc8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bcf:	00 00 00 
	stat->st_dev = &devpipe;
  800bd2:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bd9:	30 80 00 
	return 0;
}
  800bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800be1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	53                   	push   %ebx
  800bec:	83 ec 0c             	sub    $0xc,%esp
  800bef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bf2:	53                   	push   %ebx
  800bf3:	6a 00                	push   $0x0
  800bf5:	e8 dc f5 ff ff       	call   8001d6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800bfa:	89 1c 24             	mov    %ebx,(%esp)
  800bfd:	e8 6f f7 ff ff       	call   800371 <fd2data>
  800c02:	83 c4 08             	add    $0x8,%esp
  800c05:	50                   	push   %eax
  800c06:	6a 00                	push   $0x0
  800c08:	e8 c9 f5 ff ff       	call   8001d6 <sys_page_unmap>
}
  800c0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <_pipeisclosed>:
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	83 ec 1c             	sub    $0x1c,%esp
  800c1b:	89 c7                	mov    %eax,%edi
  800c1d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c1f:	a1 08 40 80 00       	mov    0x804008,%eax
  800c24:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c27:	83 ec 0c             	sub    $0xc,%esp
  800c2a:	57                   	push   %edi
  800c2b:	e8 99 13 00 00       	call   801fc9 <pageref>
  800c30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c33:	89 34 24             	mov    %esi,(%esp)
  800c36:	e8 8e 13 00 00       	call   801fc9 <pageref>
		nn = thisenv->env_runs;
  800c3b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c41:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c44:	83 c4 10             	add    $0x10,%esp
  800c47:	39 cb                	cmp    %ecx,%ebx
  800c49:	74 1b                	je     800c66 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c4b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c4e:	75 cf                	jne    800c1f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c50:	8b 42 58             	mov    0x58(%edx),%eax
  800c53:	6a 01                	push   $0x1
  800c55:	50                   	push   %eax
  800c56:	53                   	push   %ebx
  800c57:	68 6e 23 80 00       	push   $0x80236e
  800c5c:	e8 3e 09 00 00       	call   80159f <cprintf>
  800c61:	83 c4 10             	add    $0x10,%esp
  800c64:	eb b9                	jmp    800c1f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c66:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c69:	0f 94 c0             	sete   %al
  800c6c:	0f b6 c0             	movzbl %al,%eax
}
  800c6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5f                   	pop    %edi
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <devpipe_write>:
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	57                   	push   %edi
  800c7b:	56                   	push   %esi
  800c7c:	53                   	push   %ebx
  800c7d:	83 ec 28             	sub    $0x28,%esp
  800c80:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c83:	56                   	push   %esi
  800c84:	e8 e8 f6 ff ff       	call   800371 <fd2data>
  800c89:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c8b:	83 c4 10             	add    $0x10,%esp
  800c8e:	bf 00 00 00 00       	mov    $0x0,%edi
  800c93:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c96:	74 4f                	je     800ce7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c98:	8b 43 04             	mov    0x4(%ebx),%eax
  800c9b:	8b 0b                	mov    (%ebx),%ecx
  800c9d:	8d 51 20             	lea    0x20(%ecx),%edx
  800ca0:	39 d0                	cmp    %edx,%eax
  800ca2:	72 14                	jb     800cb8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800ca4:	89 da                	mov    %ebx,%edx
  800ca6:	89 f0                	mov    %esi,%eax
  800ca8:	e8 65 ff ff ff       	call   800c12 <_pipeisclosed>
  800cad:	85 c0                	test   %eax,%eax
  800caf:	75 3b                	jne    800cec <devpipe_write+0x75>
			sys_yield();
  800cb1:	e8 7c f4 ff ff       	call   800132 <sys_yield>
  800cb6:	eb e0                	jmp    800c98 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cbf:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cc2:	89 c2                	mov    %eax,%edx
  800cc4:	c1 fa 1f             	sar    $0x1f,%edx
  800cc7:	89 d1                	mov    %edx,%ecx
  800cc9:	c1 e9 1b             	shr    $0x1b,%ecx
  800ccc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800ccf:	83 e2 1f             	and    $0x1f,%edx
  800cd2:	29 ca                	sub    %ecx,%edx
  800cd4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cd8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cdc:	83 c0 01             	add    $0x1,%eax
  800cdf:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800ce2:	83 c7 01             	add    $0x1,%edi
  800ce5:	eb ac                	jmp    800c93 <devpipe_write+0x1c>
	return i;
  800ce7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cea:	eb 05                	jmp    800cf1 <devpipe_write+0x7a>
				return 0;
  800cec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <devpipe_read>:
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	57                   	push   %edi
  800cfd:	56                   	push   %esi
  800cfe:	53                   	push   %ebx
  800cff:	83 ec 18             	sub    $0x18,%esp
  800d02:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d05:	57                   	push   %edi
  800d06:	e8 66 f6 ff ff       	call   800371 <fd2data>
  800d0b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d0d:	83 c4 10             	add    $0x10,%esp
  800d10:	be 00 00 00 00       	mov    $0x0,%esi
  800d15:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d18:	75 14                	jne    800d2e <devpipe_read+0x35>
	return i;
  800d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1d:	eb 02                	jmp    800d21 <devpipe_read+0x28>
				return i;
  800d1f:	89 f0                	mov    %esi,%eax
}
  800d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    
			sys_yield();
  800d29:	e8 04 f4 ff ff       	call   800132 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d2e:	8b 03                	mov    (%ebx),%eax
  800d30:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d33:	75 18                	jne    800d4d <devpipe_read+0x54>
			if (i > 0)
  800d35:	85 f6                	test   %esi,%esi
  800d37:	75 e6                	jne    800d1f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  800d39:	89 da                	mov    %ebx,%edx
  800d3b:	89 f8                	mov    %edi,%eax
  800d3d:	e8 d0 fe ff ff       	call   800c12 <_pipeisclosed>
  800d42:	85 c0                	test   %eax,%eax
  800d44:	74 e3                	je     800d29 <devpipe_read+0x30>
				return 0;
  800d46:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4b:	eb d4                	jmp    800d21 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d4d:	99                   	cltd   
  800d4e:	c1 ea 1b             	shr    $0x1b,%edx
  800d51:	01 d0                	add    %edx,%eax
  800d53:	83 e0 1f             	and    $0x1f,%eax
  800d56:	29 d0                	sub    %edx,%eax
  800d58:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d60:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d63:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d66:	83 c6 01             	add    $0x1,%esi
  800d69:	eb aa                	jmp    800d15 <devpipe_read+0x1c>

00800d6b <pipe>:
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	56                   	push   %esi
  800d6f:	53                   	push   %ebx
  800d70:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d76:	50                   	push   %eax
  800d77:	e8 0c f6 ff ff       	call   800388 <fd_alloc>
  800d7c:	89 c3                	mov    %eax,%ebx
  800d7e:	83 c4 10             	add    $0x10,%esp
  800d81:	85 c0                	test   %eax,%eax
  800d83:	0f 88 23 01 00 00    	js     800eac <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d89:	83 ec 04             	sub    $0x4,%esp
  800d8c:	68 07 04 00 00       	push   $0x407
  800d91:	ff 75 f4             	pushl  -0xc(%ebp)
  800d94:	6a 00                	push   $0x0
  800d96:	e8 b6 f3 ff ff       	call   800151 <sys_page_alloc>
  800d9b:	89 c3                	mov    %eax,%ebx
  800d9d:	83 c4 10             	add    $0x10,%esp
  800da0:	85 c0                	test   %eax,%eax
  800da2:	0f 88 04 01 00 00    	js     800eac <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  800da8:	83 ec 0c             	sub    $0xc,%esp
  800dab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dae:	50                   	push   %eax
  800daf:	e8 d4 f5 ff ff       	call   800388 <fd_alloc>
  800db4:	89 c3                	mov    %eax,%ebx
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	0f 88 db 00 00 00    	js     800e9c <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dc1:	83 ec 04             	sub    $0x4,%esp
  800dc4:	68 07 04 00 00       	push   $0x407
  800dc9:	ff 75 f0             	pushl  -0x10(%ebp)
  800dcc:	6a 00                	push   $0x0
  800dce:	e8 7e f3 ff ff       	call   800151 <sys_page_alloc>
  800dd3:	89 c3                	mov    %eax,%ebx
  800dd5:	83 c4 10             	add    $0x10,%esp
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	0f 88 bc 00 00 00    	js     800e9c <pipe+0x131>
	va = fd2data(fd0);
  800de0:	83 ec 0c             	sub    $0xc,%esp
  800de3:	ff 75 f4             	pushl  -0xc(%ebp)
  800de6:	e8 86 f5 ff ff       	call   800371 <fd2data>
  800deb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ded:	83 c4 0c             	add    $0xc,%esp
  800df0:	68 07 04 00 00       	push   $0x407
  800df5:	50                   	push   %eax
  800df6:	6a 00                	push   $0x0
  800df8:	e8 54 f3 ff ff       	call   800151 <sys_page_alloc>
  800dfd:	89 c3                	mov    %eax,%ebx
  800dff:	83 c4 10             	add    $0x10,%esp
  800e02:	85 c0                	test   %eax,%eax
  800e04:	0f 88 82 00 00 00    	js     800e8c <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e0a:	83 ec 0c             	sub    $0xc,%esp
  800e0d:	ff 75 f0             	pushl  -0x10(%ebp)
  800e10:	e8 5c f5 ff ff       	call   800371 <fd2data>
  800e15:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e1c:	50                   	push   %eax
  800e1d:	6a 00                	push   $0x0
  800e1f:	56                   	push   %esi
  800e20:	6a 00                	push   $0x0
  800e22:	e8 6d f3 ff ff       	call   800194 <sys_page_map>
  800e27:	89 c3                	mov    %eax,%ebx
  800e29:	83 c4 20             	add    $0x20,%esp
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	78 4e                	js     800e7e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  800e30:	a1 20 30 80 00       	mov    0x803020,%eax
  800e35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e38:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e47:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	ff 75 f4             	pushl  -0xc(%ebp)
  800e59:	e8 03 f5 ff ff       	call   800361 <fd2num>
  800e5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e61:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e63:	83 c4 04             	add    $0x4,%esp
  800e66:	ff 75 f0             	pushl  -0x10(%ebp)
  800e69:	e8 f3 f4 ff ff       	call   800361 <fd2num>
  800e6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e71:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7c:	eb 2e                	jmp    800eac <pipe+0x141>
	sys_page_unmap(0, va);
  800e7e:	83 ec 08             	sub    $0x8,%esp
  800e81:	56                   	push   %esi
  800e82:	6a 00                	push   $0x0
  800e84:	e8 4d f3 ff ff       	call   8001d6 <sys_page_unmap>
  800e89:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e8c:	83 ec 08             	sub    $0x8,%esp
  800e8f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e92:	6a 00                	push   $0x0
  800e94:	e8 3d f3 ff ff       	call   8001d6 <sys_page_unmap>
  800e99:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800e9c:	83 ec 08             	sub    $0x8,%esp
  800e9f:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea2:	6a 00                	push   $0x0
  800ea4:	e8 2d f3 ff ff       	call   8001d6 <sys_page_unmap>
  800ea9:	83 c4 10             	add    $0x10,%esp
}
  800eac:	89 d8                	mov    %ebx,%eax
  800eae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <pipeisclosed>:
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ebb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ebe:	50                   	push   %eax
  800ebf:	ff 75 08             	pushl  0x8(%ebp)
  800ec2:	e8 13 f5 ff ff       	call   8003da <fd_lookup>
  800ec7:	83 c4 10             	add    $0x10,%esp
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	78 18                	js     800ee6 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ece:	83 ec 0c             	sub    $0xc,%esp
  800ed1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed4:	e8 98 f4 ff ff       	call   800371 <fd2data>
	return _pipeisclosed(fd, p);
  800ed9:	89 c2                	mov    %eax,%edx
  800edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ede:	e8 2f fd ff ff       	call   800c12 <_pipeisclosed>
  800ee3:	83 c4 10             	add    $0x10,%esp
}
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800eee:	68 86 23 80 00       	push   $0x802386
  800ef3:	ff 75 0c             	pushl  0xc(%ebp)
  800ef6:	e8 80 0c 00 00       	call   801b7b <strcpy>
	return 0;
}
  800efb:	b8 00 00 00 00       	mov    $0x0,%eax
  800f00:	c9                   	leave  
  800f01:	c3                   	ret    

00800f02 <devsock_close>:
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	53                   	push   %ebx
  800f06:	83 ec 10             	sub    $0x10,%esp
  800f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f0c:	53                   	push   %ebx
  800f0d:	e8 b7 10 00 00       	call   801fc9 <pageref>
  800f12:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f15:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f1a:	83 f8 01             	cmp    $0x1,%eax
  800f1d:	74 07                	je     800f26 <devsock_close+0x24>
}
  800f1f:	89 d0                	mov    %edx,%eax
  800f21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f26:	83 ec 0c             	sub    $0xc,%esp
  800f29:	ff 73 0c             	pushl  0xc(%ebx)
  800f2c:	e8 b9 02 00 00       	call   8011ea <nsipc_close>
  800f31:	89 c2                	mov    %eax,%edx
  800f33:	83 c4 10             	add    $0x10,%esp
  800f36:	eb e7                	jmp    800f1f <devsock_close+0x1d>

00800f38 <devsock_write>:
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f3e:	6a 00                	push   $0x0
  800f40:	ff 75 10             	pushl  0x10(%ebp)
  800f43:	ff 75 0c             	pushl  0xc(%ebp)
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	ff 70 0c             	pushl  0xc(%eax)
  800f4c:	e8 76 03 00 00       	call   8012c7 <nsipc_send>
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <devsock_read>:
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f59:	6a 00                	push   $0x0
  800f5b:	ff 75 10             	pushl  0x10(%ebp)
  800f5e:	ff 75 0c             	pushl  0xc(%ebp)
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	ff 70 0c             	pushl  0xc(%eax)
  800f67:	e8 ef 02 00 00       	call   80125b <nsipc_recv>
}
  800f6c:	c9                   	leave  
  800f6d:	c3                   	ret    

00800f6e <fd2sockid>:
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f74:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f77:	52                   	push   %edx
  800f78:	50                   	push   %eax
  800f79:	e8 5c f4 ff ff       	call   8003da <fd_lookup>
  800f7e:	83 c4 10             	add    $0x10,%esp
  800f81:	85 c0                	test   %eax,%eax
  800f83:	78 10                	js     800f95 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f88:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800f8e:	39 08                	cmp    %ecx,(%eax)
  800f90:	75 05                	jne    800f97 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800f92:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800f95:	c9                   	leave  
  800f96:	c3                   	ret    
		return -E_NOT_SUPP;
  800f97:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800f9c:	eb f7                	jmp    800f95 <fd2sockid+0x27>

00800f9e <alloc_sockfd>:
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	56                   	push   %esi
  800fa2:	53                   	push   %ebx
  800fa3:	83 ec 1c             	sub    $0x1c,%esp
  800fa6:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fa8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fab:	50                   	push   %eax
  800fac:	e8 d7 f3 ff ff       	call   800388 <fd_alloc>
  800fb1:	89 c3                	mov    %eax,%ebx
  800fb3:	83 c4 10             	add    $0x10,%esp
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	78 43                	js     800ffd <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fba:	83 ec 04             	sub    $0x4,%esp
  800fbd:	68 07 04 00 00       	push   $0x407
  800fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc5:	6a 00                	push   $0x0
  800fc7:	e8 85 f1 ff ff       	call   800151 <sys_page_alloc>
  800fcc:	89 c3                	mov    %eax,%ebx
  800fce:	83 c4 10             	add    $0x10,%esp
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	78 28                	js     800ffd <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd8:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fde:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800fea:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800fed:	83 ec 0c             	sub    $0xc,%esp
  800ff0:	50                   	push   %eax
  800ff1:	e8 6b f3 ff ff       	call   800361 <fd2num>
  800ff6:	89 c3                	mov    %eax,%ebx
  800ff8:	83 c4 10             	add    $0x10,%esp
  800ffb:	eb 0c                	jmp    801009 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800ffd:	83 ec 0c             	sub    $0xc,%esp
  801000:	56                   	push   %esi
  801001:	e8 e4 01 00 00       	call   8011ea <nsipc_close>
		return r;
  801006:	83 c4 10             	add    $0x10,%esp
}
  801009:	89 d8                	mov    %ebx,%eax
  80100b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    

00801012 <accept>:
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	e8 4e ff ff ff       	call   800f6e <fd2sockid>
  801020:	85 c0                	test   %eax,%eax
  801022:	78 1b                	js     80103f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801024:	83 ec 04             	sub    $0x4,%esp
  801027:	ff 75 10             	pushl  0x10(%ebp)
  80102a:	ff 75 0c             	pushl  0xc(%ebp)
  80102d:	50                   	push   %eax
  80102e:	e8 0e 01 00 00       	call   801141 <nsipc_accept>
  801033:	83 c4 10             	add    $0x10,%esp
  801036:	85 c0                	test   %eax,%eax
  801038:	78 05                	js     80103f <accept+0x2d>
	return alloc_sockfd(r);
  80103a:	e8 5f ff ff ff       	call   800f9e <alloc_sockfd>
}
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <bind>:
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	e8 1f ff ff ff       	call   800f6e <fd2sockid>
  80104f:	85 c0                	test   %eax,%eax
  801051:	78 12                	js     801065 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801053:	83 ec 04             	sub    $0x4,%esp
  801056:	ff 75 10             	pushl  0x10(%ebp)
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	50                   	push   %eax
  80105d:	e8 31 01 00 00       	call   801193 <nsipc_bind>
  801062:	83 c4 10             	add    $0x10,%esp
}
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <shutdown>:
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	e8 f9 fe ff ff       	call   800f6e <fd2sockid>
  801075:	85 c0                	test   %eax,%eax
  801077:	78 0f                	js     801088 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801079:	83 ec 08             	sub    $0x8,%esp
  80107c:	ff 75 0c             	pushl  0xc(%ebp)
  80107f:	50                   	push   %eax
  801080:	e8 43 01 00 00       	call   8011c8 <nsipc_shutdown>
  801085:	83 c4 10             	add    $0x10,%esp
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <connect>:
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	e8 d6 fe ff ff       	call   800f6e <fd2sockid>
  801098:	85 c0                	test   %eax,%eax
  80109a:	78 12                	js     8010ae <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80109c:	83 ec 04             	sub    $0x4,%esp
  80109f:	ff 75 10             	pushl  0x10(%ebp)
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	50                   	push   %eax
  8010a6:	e8 59 01 00 00       	call   801204 <nsipc_connect>
  8010ab:	83 c4 10             	add    $0x10,%esp
}
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <listen>:
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	e8 b0 fe ff ff       	call   800f6e <fd2sockid>
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	78 0f                	js     8010d1 <listen+0x21>
	return nsipc_listen(r, backlog);
  8010c2:	83 ec 08             	sub    $0x8,%esp
  8010c5:	ff 75 0c             	pushl  0xc(%ebp)
  8010c8:	50                   	push   %eax
  8010c9:	e8 6b 01 00 00       	call   801239 <nsipc_listen>
  8010ce:	83 c4 10             	add    $0x10,%esp
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <socket>:

int
socket(int domain, int type, int protocol)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010d9:	ff 75 10             	pushl  0x10(%ebp)
  8010dc:	ff 75 0c             	pushl  0xc(%ebp)
  8010df:	ff 75 08             	pushl  0x8(%ebp)
  8010e2:	e8 3e 02 00 00       	call   801325 <nsipc_socket>
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	85 c0                	test   %eax,%eax
  8010ec:	78 05                	js     8010f3 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8010ee:	e8 ab fe ff ff       	call   800f9e <alloc_sockfd>
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	53                   	push   %ebx
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8010fe:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801105:	74 26                	je     80112d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801107:	6a 07                	push   $0x7
  801109:	68 00 60 80 00       	push   $0x806000
  80110e:	53                   	push   %ebx
  80110f:	ff 35 04 40 80 00    	pushl  0x804004
  801115:	e8 0a 0e 00 00       	call   801f24 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80111a:	83 c4 0c             	add    $0xc,%esp
  80111d:	6a 00                	push   $0x0
  80111f:	6a 00                	push   $0x0
  801121:	6a 00                	push   $0x0
  801123:	e8 89 0d 00 00       	call   801eb1 <ipc_recv>
}
  801128:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112b:	c9                   	leave  
  80112c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80112d:	83 ec 0c             	sub    $0xc,%esp
  801130:	6a 02                	push   $0x2
  801132:	e8 59 0e 00 00       	call   801f90 <ipc_find_env>
  801137:	a3 04 40 80 00       	mov    %eax,0x804004
  80113c:	83 c4 10             	add    $0x10,%esp
  80113f:	eb c6                	jmp    801107 <nsipc+0x12>

00801141 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	56                   	push   %esi
  801145:	53                   	push   %ebx
  801146:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801151:	8b 06                	mov    (%esi),%eax
  801153:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801158:	b8 01 00 00 00       	mov    $0x1,%eax
  80115d:	e8 93 ff ff ff       	call   8010f5 <nsipc>
  801162:	89 c3                	mov    %eax,%ebx
  801164:	85 c0                	test   %eax,%eax
  801166:	79 09                	jns    801171 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801168:	89 d8                	mov    %ebx,%eax
  80116a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116d:	5b                   	pop    %ebx
  80116e:	5e                   	pop    %esi
  80116f:	5d                   	pop    %ebp
  801170:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801171:	83 ec 04             	sub    $0x4,%esp
  801174:	ff 35 10 60 80 00    	pushl  0x806010
  80117a:	68 00 60 80 00       	push   $0x806000
  80117f:	ff 75 0c             	pushl  0xc(%ebp)
  801182:	e8 82 0b 00 00       	call   801d09 <memmove>
		*addrlen = ret->ret_addrlen;
  801187:	a1 10 60 80 00       	mov    0x806010,%eax
  80118c:	89 06                	mov    %eax,(%esi)
  80118e:	83 c4 10             	add    $0x10,%esp
	return r;
  801191:	eb d5                	jmp    801168 <nsipc_accept+0x27>

00801193 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	53                   	push   %ebx
  801197:	83 ec 08             	sub    $0x8,%esp
  80119a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011a5:	53                   	push   %ebx
  8011a6:	ff 75 0c             	pushl  0xc(%ebp)
  8011a9:	68 04 60 80 00       	push   $0x806004
  8011ae:	e8 56 0b 00 00       	call   801d09 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011b3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011b9:	b8 02 00 00 00       	mov    $0x2,%eax
  8011be:	e8 32 ff ff ff       	call   8010f5 <nsipc>
}
  8011c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011de:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e3:	e8 0d ff ff ff       	call   8010f5 <nsipc>
}
  8011e8:	c9                   	leave  
  8011e9:	c3                   	ret    

008011ea <nsipc_close>:

int
nsipc_close(int s)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8011f8:	b8 04 00 00 00       	mov    $0x4,%eax
  8011fd:	e8 f3 fe ff ff       	call   8010f5 <nsipc>
}
  801202:	c9                   	leave  
  801203:	c3                   	ret    

00801204 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	53                   	push   %ebx
  801208:	83 ec 08             	sub    $0x8,%esp
  80120b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801216:	53                   	push   %ebx
  801217:	ff 75 0c             	pushl  0xc(%ebp)
  80121a:	68 04 60 80 00       	push   $0x806004
  80121f:	e8 e5 0a 00 00       	call   801d09 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801224:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80122a:	b8 05 00 00 00       	mov    $0x5,%eax
  80122f:	e8 c1 fe ff ff       	call   8010f5 <nsipc>
}
  801234:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801237:	c9                   	leave  
  801238:	c3                   	ret    

00801239 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80124f:	b8 06 00 00 00       	mov    $0x6,%eax
  801254:	e8 9c fe ff ff       	call   8010f5 <nsipc>
}
  801259:	c9                   	leave  
  80125a:	c3                   	ret    

0080125b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	56                   	push   %esi
  80125f:	53                   	push   %ebx
  801260:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80126b:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801271:	8b 45 14             	mov    0x14(%ebp),%eax
  801274:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801279:	b8 07 00 00 00       	mov    $0x7,%eax
  80127e:	e8 72 fe ff ff       	call   8010f5 <nsipc>
  801283:	89 c3                	mov    %eax,%ebx
  801285:	85 c0                	test   %eax,%eax
  801287:	78 1f                	js     8012a8 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801289:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80128e:	7f 21                	jg     8012b1 <nsipc_recv+0x56>
  801290:	39 c6                	cmp    %eax,%esi
  801292:	7c 1d                	jl     8012b1 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801294:	83 ec 04             	sub    $0x4,%esp
  801297:	50                   	push   %eax
  801298:	68 00 60 80 00       	push   $0x806000
  80129d:	ff 75 0c             	pushl  0xc(%ebp)
  8012a0:	e8 64 0a 00 00       	call   801d09 <memmove>
  8012a5:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012a8:	89 d8                	mov    %ebx,%eax
  8012aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ad:	5b                   	pop    %ebx
  8012ae:	5e                   	pop    %esi
  8012af:	5d                   	pop    %ebp
  8012b0:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012b1:	68 92 23 80 00       	push   $0x802392
  8012b6:	68 34 23 80 00       	push   $0x802334
  8012bb:	6a 62                	push   $0x62
  8012bd:	68 a7 23 80 00       	push   $0x8023a7
  8012c2:	e8 fd 01 00 00       	call   8014c4 <_panic>

008012c7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	53                   	push   %ebx
  8012cb:	83 ec 04             	sub    $0x4,%esp
  8012ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012d9:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012df:	7f 2e                	jg     80130f <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012e1:	83 ec 04             	sub    $0x4,%esp
  8012e4:	53                   	push   %ebx
  8012e5:	ff 75 0c             	pushl  0xc(%ebp)
  8012e8:	68 0c 60 80 00       	push   $0x80600c
  8012ed:	e8 17 0a 00 00       	call   801d09 <memmove>
	nsipcbuf.send.req_size = size;
  8012f2:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fb:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801300:	b8 08 00 00 00       	mov    $0x8,%eax
  801305:	e8 eb fd ff ff       	call   8010f5 <nsipc>
}
  80130a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    
	assert(size < 1600);
  80130f:	68 b3 23 80 00       	push   $0x8023b3
  801314:	68 34 23 80 00       	push   $0x802334
  801319:	6a 6d                	push   $0x6d
  80131b:	68 a7 23 80 00       	push   $0x8023a7
  801320:	e8 9f 01 00 00       	call   8014c4 <_panic>

00801325 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80133b:	8b 45 10             	mov    0x10(%ebp),%eax
  80133e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801343:	b8 09 00 00 00       	mov    $0x9,%eax
  801348:	e8 a8 fd ff ff       	call   8010f5 <nsipc>
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80134f:	b8 00 00 00 00       	mov    $0x0,%eax
  801354:	c3                   	ret    

00801355 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80135b:	68 bf 23 80 00       	push   $0x8023bf
  801360:	ff 75 0c             	pushl  0xc(%ebp)
  801363:	e8 13 08 00 00       	call   801b7b <strcpy>
	return 0;
}
  801368:	b8 00 00 00 00       	mov    $0x0,%eax
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <devcons_write>:
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	57                   	push   %edi
  801373:	56                   	push   %esi
  801374:	53                   	push   %ebx
  801375:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80137b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801380:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801386:	3b 75 10             	cmp    0x10(%ebp),%esi
  801389:	73 31                	jae    8013bc <devcons_write+0x4d>
		m = n - tot;
  80138b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80138e:	29 f3                	sub    %esi,%ebx
  801390:	83 fb 7f             	cmp    $0x7f,%ebx
  801393:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801398:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80139b:	83 ec 04             	sub    $0x4,%esp
  80139e:	53                   	push   %ebx
  80139f:	89 f0                	mov    %esi,%eax
  8013a1:	03 45 0c             	add    0xc(%ebp),%eax
  8013a4:	50                   	push   %eax
  8013a5:	57                   	push   %edi
  8013a6:	e8 5e 09 00 00       	call   801d09 <memmove>
		sys_cputs(buf, m);
  8013ab:	83 c4 08             	add    $0x8,%esp
  8013ae:	53                   	push   %ebx
  8013af:	57                   	push   %edi
  8013b0:	e8 e0 ec ff ff       	call   800095 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013b5:	01 de                	add    %ebx,%esi
  8013b7:	83 c4 10             	add    $0x10,%esp
  8013ba:	eb ca                	jmp    801386 <devcons_write+0x17>
}
  8013bc:	89 f0                	mov    %esi,%eax
  8013be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c1:	5b                   	pop    %ebx
  8013c2:	5e                   	pop    %esi
  8013c3:	5f                   	pop    %edi
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    

008013c6 <devcons_read>:
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 08             	sub    $0x8,%esp
  8013cc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d5:	74 21                	je     8013f8 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8013d7:	e8 d7 ec ff ff       	call   8000b3 <sys_cgetc>
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	75 07                	jne    8013e7 <devcons_read+0x21>
		sys_yield();
  8013e0:	e8 4d ed ff ff       	call   800132 <sys_yield>
  8013e5:	eb f0                	jmp    8013d7 <devcons_read+0x11>
	if (c < 0)
  8013e7:	78 0f                	js     8013f8 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8013e9:	83 f8 04             	cmp    $0x4,%eax
  8013ec:	74 0c                	je     8013fa <devcons_read+0x34>
	*(char*)vbuf = c;
  8013ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f1:	88 02                	mov    %al,(%edx)
	return 1;
  8013f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    
		return 0;
  8013fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ff:	eb f7                	jmp    8013f8 <devcons_read+0x32>

00801401 <cputchar>:
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80140d:	6a 01                	push   $0x1
  80140f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801412:	50                   	push   %eax
  801413:	e8 7d ec ff ff       	call   800095 <sys_cputs>
}
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <getchar>:
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801423:	6a 01                	push   $0x1
  801425:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801428:	50                   	push   %eax
  801429:	6a 00                	push   $0x0
  80142b:	e8 1a f2 ff ff       	call   80064a <read>
	if (r < 0)
  801430:	83 c4 10             	add    $0x10,%esp
  801433:	85 c0                	test   %eax,%eax
  801435:	78 06                	js     80143d <getchar+0x20>
	if (r < 1)
  801437:	74 06                	je     80143f <getchar+0x22>
	return c;
  801439:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    
		return -E_EOF;
  80143f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801444:	eb f7                	jmp    80143d <getchar+0x20>

00801446 <iscons>:
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80144c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144f:	50                   	push   %eax
  801450:	ff 75 08             	pushl  0x8(%ebp)
  801453:	e8 82 ef ff ff       	call   8003da <fd_lookup>
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	85 c0                	test   %eax,%eax
  80145d:	78 11                	js     801470 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80145f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801462:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801468:	39 10                	cmp    %edx,(%eax)
  80146a:	0f 94 c0             	sete   %al
  80146d:	0f b6 c0             	movzbl %al,%eax
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <opencons>:
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801478:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147b:	50                   	push   %eax
  80147c:	e8 07 ef ff ff       	call   800388 <fd_alloc>
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	85 c0                	test   %eax,%eax
  801486:	78 3a                	js     8014c2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801488:	83 ec 04             	sub    $0x4,%esp
  80148b:	68 07 04 00 00       	push   $0x407
  801490:	ff 75 f4             	pushl  -0xc(%ebp)
  801493:	6a 00                	push   $0x0
  801495:	e8 b7 ec ff ff       	call   800151 <sys_page_alloc>
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	85 c0                	test   %eax,%eax
  80149f:	78 21                	js     8014c2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014aa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014af:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014b6:	83 ec 0c             	sub    $0xc,%esp
  8014b9:	50                   	push   %eax
  8014ba:	e8 a2 ee ff ff       	call   800361 <fd2num>
  8014bf:	83 c4 10             	add    $0x10,%esp
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	56                   	push   %esi
  8014c8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014c9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014cc:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014d2:	e8 3c ec ff ff       	call   800113 <sys_getenvid>
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	ff 75 0c             	pushl  0xc(%ebp)
  8014dd:	ff 75 08             	pushl  0x8(%ebp)
  8014e0:	56                   	push   %esi
  8014e1:	50                   	push   %eax
  8014e2:	68 cc 23 80 00       	push   $0x8023cc
  8014e7:	e8 b3 00 00 00       	call   80159f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014ec:	83 c4 18             	add    $0x18,%esp
  8014ef:	53                   	push   %ebx
  8014f0:	ff 75 10             	pushl  0x10(%ebp)
  8014f3:	e8 56 00 00 00       	call   80154e <vcprintf>
	cprintf("\n");
  8014f8:	c7 04 24 7f 23 80 00 	movl   $0x80237f,(%esp)
  8014ff:	e8 9b 00 00 00       	call   80159f <cprintf>
  801504:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801507:	cc                   	int3   
  801508:	eb fd                	jmp    801507 <_panic+0x43>

0080150a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	53                   	push   %ebx
  80150e:	83 ec 04             	sub    $0x4,%esp
  801511:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801514:	8b 13                	mov    (%ebx),%edx
  801516:	8d 42 01             	lea    0x1(%edx),%eax
  801519:	89 03                	mov    %eax,(%ebx)
  80151b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801522:	3d ff 00 00 00       	cmp    $0xff,%eax
  801527:	74 09                	je     801532 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801529:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80152d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801530:	c9                   	leave  
  801531:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801532:	83 ec 08             	sub    $0x8,%esp
  801535:	68 ff 00 00 00       	push   $0xff
  80153a:	8d 43 08             	lea    0x8(%ebx),%eax
  80153d:	50                   	push   %eax
  80153e:	e8 52 eb ff ff       	call   800095 <sys_cputs>
		b->idx = 0;
  801543:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	eb db                	jmp    801529 <putch+0x1f>

0080154e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801557:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80155e:	00 00 00 
	b.cnt = 0;
  801561:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801568:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80156b:	ff 75 0c             	pushl  0xc(%ebp)
  80156e:	ff 75 08             	pushl  0x8(%ebp)
  801571:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801577:	50                   	push   %eax
  801578:	68 0a 15 80 00       	push   $0x80150a
  80157d:	e8 19 01 00 00       	call   80169b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801582:	83 c4 08             	add    $0x8,%esp
  801585:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80158b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801591:	50                   	push   %eax
  801592:	e8 fe ea ff ff       	call   800095 <sys_cputs>

	return b.cnt;
}
  801597:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015a5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015a8:	50                   	push   %eax
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	e8 9d ff ff ff       	call   80154e <vcprintf>
	va_end(ap);

	return cnt;
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	57                   	push   %edi
  8015b7:	56                   	push   %esi
  8015b8:	53                   	push   %ebx
  8015b9:	83 ec 1c             	sub    $0x1c,%esp
  8015bc:	89 c7                	mov    %eax,%edi
  8015be:	89 d6                	mov    %edx,%esi
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015d7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015da:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015dd:	89 d0                	mov    %edx,%eax
  8015df:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8015e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015e5:	73 15                	jae    8015fc <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015e7:	83 eb 01             	sub    $0x1,%ebx
  8015ea:	85 db                	test   %ebx,%ebx
  8015ec:	7e 43                	jle    801631 <printnum+0x7e>
			putch(padc, putdat);
  8015ee:	83 ec 08             	sub    $0x8,%esp
  8015f1:	56                   	push   %esi
  8015f2:	ff 75 18             	pushl  0x18(%ebp)
  8015f5:	ff d7                	call   *%edi
  8015f7:	83 c4 10             	add    $0x10,%esp
  8015fa:	eb eb                	jmp    8015e7 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015fc:	83 ec 0c             	sub    $0xc,%esp
  8015ff:	ff 75 18             	pushl  0x18(%ebp)
  801602:	8b 45 14             	mov    0x14(%ebp),%eax
  801605:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801608:	53                   	push   %ebx
  801609:	ff 75 10             	pushl  0x10(%ebp)
  80160c:	83 ec 08             	sub    $0x8,%esp
  80160f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801612:	ff 75 e0             	pushl  -0x20(%ebp)
  801615:	ff 75 dc             	pushl  -0x24(%ebp)
  801618:	ff 75 d8             	pushl  -0x28(%ebp)
  80161b:	e8 f0 09 00 00       	call   802010 <__udivdi3>
  801620:	83 c4 18             	add    $0x18,%esp
  801623:	52                   	push   %edx
  801624:	50                   	push   %eax
  801625:	89 f2                	mov    %esi,%edx
  801627:	89 f8                	mov    %edi,%eax
  801629:	e8 85 ff ff ff       	call   8015b3 <printnum>
  80162e:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801631:	83 ec 08             	sub    $0x8,%esp
  801634:	56                   	push   %esi
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	ff 75 e4             	pushl  -0x1c(%ebp)
  80163b:	ff 75 e0             	pushl  -0x20(%ebp)
  80163e:	ff 75 dc             	pushl  -0x24(%ebp)
  801641:	ff 75 d8             	pushl  -0x28(%ebp)
  801644:	e8 d7 0a 00 00       	call   802120 <__umoddi3>
  801649:	83 c4 14             	add    $0x14,%esp
  80164c:	0f be 80 ef 23 80 00 	movsbl 0x8023ef(%eax),%eax
  801653:	50                   	push   %eax
  801654:	ff d7                	call   *%edi
}
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165c:	5b                   	pop    %ebx
  80165d:	5e                   	pop    %esi
  80165e:	5f                   	pop    %edi
  80165f:	5d                   	pop    %ebp
  801660:	c3                   	ret    

00801661 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801667:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80166b:	8b 10                	mov    (%eax),%edx
  80166d:	3b 50 04             	cmp    0x4(%eax),%edx
  801670:	73 0a                	jae    80167c <sprintputch+0x1b>
		*b->buf++ = ch;
  801672:	8d 4a 01             	lea    0x1(%edx),%ecx
  801675:	89 08                	mov    %ecx,(%eax)
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	88 02                	mov    %al,(%edx)
}
  80167c:	5d                   	pop    %ebp
  80167d:	c3                   	ret    

0080167e <printfmt>:
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801684:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801687:	50                   	push   %eax
  801688:	ff 75 10             	pushl  0x10(%ebp)
  80168b:	ff 75 0c             	pushl  0xc(%ebp)
  80168e:	ff 75 08             	pushl  0x8(%ebp)
  801691:	e8 05 00 00 00       	call   80169b <vprintfmt>
}
  801696:	83 c4 10             	add    $0x10,%esp
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <vprintfmt>:
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	57                   	push   %edi
  80169f:	56                   	push   %esi
  8016a0:	53                   	push   %ebx
  8016a1:	83 ec 3c             	sub    $0x3c,%esp
  8016a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8016a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016aa:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016ad:	eb 0a                	jmp    8016b9 <vprintfmt+0x1e>
			putch(ch, putdat);
  8016af:	83 ec 08             	sub    $0x8,%esp
  8016b2:	53                   	push   %ebx
  8016b3:	50                   	push   %eax
  8016b4:	ff d6                	call   *%esi
  8016b6:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016b9:	83 c7 01             	add    $0x1,%edi
  8016bc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016c0:	83 f8 25             	cmp    $0x25,%eax
  8016c3:	74 0c                	je     8016d1 <vprintfmt+0x36>
			if (ch == '\0')
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	75 e6                	jne    8016af <vprintfmt+0x14>
}
  8016c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016cc:	5b                   	pop    %ebx
  8016cd:	5e                   	pop    %esi
  8016ce:	5f                   	pop    %edi
  8016cf:	5d                   	pop    %ebp
  8016d0:	c3                   	ret    
		padc = ' ';
  8016d1:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8016d5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8016dc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8016e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016ea:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016ef:	8d 47 01             	lea    0x1(%edi),%eax
  8016f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016f5:	0f b6 17             	movzbl (%edi),%edx
  8016f8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016fb:	3c 55                	cmp    $0x55,%al
  8016fd:	0f 87 ba 03 00 00    	ja     801abd <vprintfmt+0x422>
  801703:	0f b6 c0             	movzbl %al,%eax
  801706:	ff 24 85 40 25 80 00 	jmp    *0x802540(,%eax,4)
  80170d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801710:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801714:	eb d9                	jmp    8016ef <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801716:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801719:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80171d:	eb d0                	jmp    8016ef <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80171f:	0f b6 d2             	movzbl %dl,%edx
  801722:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
  80172a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80172d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801730:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801734:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801737:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80173a:	83 f9 09             	cmp    $0x9,%ecx
  80173d:	77 55                	ja     801794 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  80173f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801742:	eb e9                	jmp    80172d <vprintfmt+0x92>
			precision = va_arg(ap, int);
  801744:	8b 45 14             	mov    0x14(%ebp),%eax
  801747:	8b 00                	mov    (%eax),%eax
  801749:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80174c:	8b 45 14             	mov    0x14(%ebp),%eax
  80174f:	8d 40 04             	lea    0x4(%eax),%eax
  801752:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801755:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801758:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80175c:	79 91                	jns    8016ef <vprintfmt+0x54>
				width = precision, precision = -1;
  80175e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801761:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801764:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80176b:	eb 82                	jmp    8016ef <vprintfmt+0x54>
  80176d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801770:	85 c0                	test   %eax,%eax
  801772:	ba 00 00 00 00       	mov    $0x0,%edx
  801777:	0f 49 d0             	cmovns %eax,%edx
  80177a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80177d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801780:	e9 6a ff ff ff       	jmp    8016ef <vprintfmt+0x54>
  801785:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801788:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80178f:	e9 5b ff ff ff       	jmp    8016ef <vprintfmt+0x54>
  801794:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801797:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80179a:	eb bc                	jmp    801758 <vprintfmt+0xbd>
			lflag++;
  80179c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80179f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017a2:	e9 48 ff ff ff       	jmp    8016ef <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8017a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017aa:	8d 78 04             	lea    0x4(%eax),%edi
  8017ad:	83 ec 08             	sub    $0x8,%esp
  8017b0:	53                   	push   %ebx
  8017b1:	ff 30                	pushl  (%eax)
  8017b3:	ff d6                	call   *%esi
			break;
  8017b5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017b8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017bb:	e9 9c 02 00 00       	jmp    801a5c <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8017c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c3:	8d 78 04             	lea    0x4(%eax),%edi
  8017c6:	8b 00                	mov    (%eax),%eax
  8017c8:	99                   	cltd   
  8017c9:	31 d0                	xor    %edx,%eax
  8017cb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017cd:	83 f8 0f             	cmp    $0xf,%eax
  8017d0:	7f 23                	jg     8017f5 <vprintfmt+0x15a>
  8017d2:	8b 14 85 a0 26 80 00 	mov    0x8026a0(,%eax,4),%edx
  8017d9:	85 d2                	test   %edx,%edx
  8017db:	74 18                	je     8017f5 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8017dd:	52                   	push   %edx
  8017de:	68 46 23 80 00       	push   $0x802346
  8017e3:	53                   	push   %ebx
  8017e4:	56                   	push   %esi
  8017e5:	e8 94 fe ff ff       	call   80167e <printfmt>
  8017ea:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017ed:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017f0:	e9 67 02 00 00       	jmp    801a5c <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8017f5:	50                   	push   %eax
  8017f6:	68 07 24 80 00       	push   $0x802407
  8017fb:	53                   	push   %ebx
  8017fc:	56                   	push   %esi
  8017fd:	e8 7c fe ff ff       	call   80167e <printfmt>
  801802:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801805:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801808:	e9 4f 02 00 00       	jmp    801a5c <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80180d:	8b 45 14             	mov    0x14(%ebp),%eax
  801810:	83 c0 04             	add    $0x4,%eax
  801813:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801816:	8b 45 14             	mov    0x14(%ebp),%eax
  801819:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80181b:	85 d2                	test   %edx,%edx
  80181d:	b8 00 24 80 00       	mov    $0x802400,%eax
  801822:	0f 45 c2             	cmovne %edx,%eax
  801825:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801828:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80182c:	7e 06                	jle    801834 <vprintfmt+0x199>
  80182e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801832:	75 0d                	jne    801841 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801834:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801837:	89 c7                	mov    %eax,%edi
  801839:	03 45 e0             	add    -0x20(%ebp),%eax
  80183c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80183f:	eb 3f                	jmp    801880 <vprintfmt+0x1e5>
  801841:	83 ec 08             	sub    $0x8,%esp
  801844:	ff 75 d8             	pushl  -0x28(%ebp)
  801847:	50                   	push   %eax
  801848:	e8 0d 03 00 00       	call   801b5a <strnlen>
  80184d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801850:	29 c2                	sub    %eax,%edx
  801852:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80185a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80185e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801861:	85 ff                	test   %edi,%edi
  801863:	7e 58                	jle    8018bd <vprintfmt+0x222>
					putch(padc, putdat);
  801865:	83 ec 08             	sub    $0x8,%esp
  801868:	53                   	push   %ebx
  801869:	ff 75 e0             	pushl  -0x20(%ebp)
  80186c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80186e:	83 ef 01             	sub    $0x1,%edi
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	eb eb                	jmp    801861 <vprintfmt+0x1c6>
					putch(ch, putdat);
  801876:	83 ec 08             	sub    $0x8,%esp
  801879:	53                   	push   %ebx
  80187a:	52                   	push   %edx
  80187b:	ff d6                	call   *%esi
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801883:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801885:	83 c7 01             	add    $0x1,%edi
  801888:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80188c:	0f be d0             	movsbl %al,%edx
  80188f:	85 d2                	test   %edx,%edx
  801891:	74 45                	je     8018d8 <vprintfmt+0x23d>
  801893:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801897:	78 06                	js     80189f <vprintfmt+0x204>
  801899:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80189d:	78 35                	js     8018d4 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  80189f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8018a3:	74 d1                	je     801876 <vprintfmt+0x1db>
  8018a5:	0f be c0             	movsbl %al,%eax
  8018a8:	83 e8 20             	sub    $0x20,%eax
  8018ab:	83 f8 5e             	cmp    $0x5e,%eax
  8018ae:	76 c6                	jbe    801876 <vprintfmt+0x1db>
					putch('?', putdat);
  8018b0:	83 ec 08             	sub    $0x8,%esp
  8018b3:	53                   	push   %ebx
  8018b4:	6a 3f                	push   $0x3f
  8018b6:	ff d6                	call   *%esi
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	eb c3                	jmp    801880 <vprintfmt+0x1e5>
  8018bd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8018c0:	85 d2                	test   %edx,%edx
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c7:	0f 49 c2             	cmovns %edx,%eax
  8018ca:	29 c2                	sub    %eax,%edx
  8018cc:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8018cf:	e9 60 ff ff ff       	jmp    801834 <vprintfmt+0x199>
  8018d4:	89 cf                	mov    %ecx,%edi
  8018d6:	eb 02                	jmp    8018da <vprintfmt+0x23f>
  8018d8:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8018da:	85 ff                	test   %edi,%edi
  8018dc:	7e 10                	jle    8018ee <vprintfmt+0x253>
				putch(' ', putdat);
  8018de:	83 ec 08             	sub    $0x8,%esp
  8018e1:	53                   	push   %ebx
  8018e2:	6a 20                	push   $0x20
  8018e4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018e6:	83 ef 01             	sub    $0x1,%edi
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	eb ec                	jmp    8018da <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8018ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8018f4:	e9 63 01 00 00       	jmp    801a5c <vprintfmt+0x3c1>
	if (lflag >= 2)
  8018f9:	83 f9 01             	cmp    $0x1,%ecx
  8018fc:	7f 1b                	jg     801919 <vprintfmt+0x27e>
	else if (lflag)
  8018fe:	85 c9                	test   %ecx,%ecx
  801900:	74 63                	je     801965 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  801902:	8b 45 14             	mov    0x14(%ebp),%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80190a:	99                   	cltd   
  80190b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80190e:	8b 45 14             	mov    0x14(%ebp),%eax
  801911:	8d 40 04             	lea    0x4(%eax),%eax
  801914:	89 45 14             	mov    %eax,0x14(%ebp)
  801917:	eb 17                	jmp    801930 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  801919:	8b 45 14             	mov    0x14(%ebp),%eax
  80191c:	8b 50 04             	mov    0x4(%eax),%edx
  80191f:	8b 00                	mov    (%eax),%eax
  801921:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801924:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801927:	8b 45 14             	mov    0x14(%ebp),%eax
  80192a:	8d 40 08             	lea    0x8(%eax),%eax
  80192d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801930:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801933:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801936:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80193b:	85 c9                	test   %ecx,%ecx
  80193d:	0f 89 ff 00 00 00    	jns    801a42 <vprintfmt+0x3a7>
				putch('-', putdat);
  801943:	83 ec 08             	sub    $0x8,%esp
  801946:	53                   	push   %ebx
  801947:	6a 2d                	push   $0x2d
  801949:	ff d6                	call   *%esi
				num = -(long long) num;
  80194b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80194e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801951:	f7 da                	neg    %edx
  801953:	83 d1 00             	adc    $0x0,%ecx
  801956:	f7 d9                	neg    %ecx
  801958:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80195b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801960:	e9 dd 00 00 00       	jmp    801a42 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  801965:	8b 45 14             	mov    0x14(%ebp),%eax
  801968:	8b 00                	mov    (%eax),%eax
  80196a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80196d:	99                   	cltd   
  80196e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801971:	8b 45 14             	mov    0x14(%ebp),%eax
  801974:	8d 40 04             	lea    0x4(%eax),%eax
  801977:	89 45 14             	mov    %eax,0x14(%ebp)
  80197a:	eb b4                	jmp    801930 <vprintfmt+0x295>
	if (lflag >= 2)
  80197c:	83 f9 01             	cmp    $0x1,%ecx
  80197f:	7f 1e                	jg     80199f <vprintfmt+0x304>
	else if (lflag)
  801981:	85 c9                	test   %ecx,%ecx
  801983:	74 32                	je     8019b7 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  801985:	8b 45 14             	mov    0x14(%ebp),%eax
  801988:	8b 10                	mov    (%eax),%edx
  80198a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80198f:	8d 40 04             	lea    0x4(%eax),%eax
  801992:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801995:	b8 0a 00 00 00       	mov    $0xa,%eax
  80199a:	e9 a3 00 00 00       	jmp    801a42 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  80199f:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a2:	8b 10                	mov    (%eax),%edx
  8019a4:	8b 48 04             	mov    0x4(%eax),%ecx
  8019a7:	8d 40 08             	lea    0x8(%eax),%eax
  8019aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019b2:	e9 8b 00 00 00       	jmp    801a42 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	8b 10                	mov    (%eax),%edx
  8019bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c1:	8d 40 04             	lea    0x4(%eax),%eax
  8019c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019cc:	eb 74                	jmp    801a42 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8019ce:	83 f9 01             	cmp    $0x1,%ecx
  8019d1:	7f 1b                	jg     8019ee <vprintfmt+0x353>
	else if (lflag)
  8019d3:	85 c9                	test   %ecx,%ecx
  8019d5:	74 2c                	je     801a03 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8019d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019da:	8b 10                	mov    (%eax),%edx
  8019dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e1:	8d 40 04             	lea    0x4(%eax),%eax
  8019e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019e7:	b8 08 00 00 00       	mov    $0x8,%eax
  8019ec:	eb 54                	jmp    801a42 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8019ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f1:	8b 10                	mov    (%eax),%edx
  8019f3:	8b 48 04             	mov    0x4(%eax),%ecx
  8019f6:	8d 40 08             	lea    0x8(%eax),%eax
  8019f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019fc:	b8 08 00 00 00       	mov    $0x8,%eax
  801a01:	eb 3f                	jmp    801a42 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801a03:	8b 45 14             	mov    0x14(%ebp),%eax
  801a06:	8b 10                	mov    (%eax),%edx
  801a08:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0d:	8d 40 04             	lea    0x4(%eax),%eax
  801a10:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a13:	b8 08 00 00 00       	mov    $0x8,%eax
  801a18:	eb 28                	jmp    801a42 <vprintfmt+0x3a7>
			putch('0', putdat);
  801a1a:	83 ec 08             	sub    $0x8,%esp
  801a1d:	53                   	push   %ebx
  801a1e:	6a 30                	push   $0x30
  801a20:	ff d6                	call   *%esi
			putch('x', putdat);
  801a22:	83 c4 08             	add    $0x8,%esp
  801a25:	53                   	push   %ebx
  801a26:	6a 78                	push   $0x78
  801a28:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2d:	8b 10                	mov    (%eax),%edx
  801a2f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a34:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a37:	8d 40 04             	lea    0x4(%eax),%eax
  801a3a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a3d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a42:	83 ec 0c             	sub    $0xc,%esp
  801a45:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801a49:	57                   	push   %edi
  801a4a:	ff 75 e0             	pushl  -0x20(%ebp)
  801a4d:	50                   	push   %eax
  801a4e:	51                   	push   %ecx
  801a4f:	52                   	push   %edx
  801a50:	89 da                	mov    %ebx,%edx
  801a52:	89 f0                	mov    %esi,%eax
  801a54:	e8 5a fb ff ff       	call   8015b3 <printnum>
			break;
  801a59:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801a5c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a5f:	e9 55 fc ff ff       	jmp    8016b9 <vprintfmt+0x1e>
	if (lflag >= 2)
  801a64:	83 f9 01             	cmp    $0x1,%ecx
  801a67:	7f 1b                	jg     801a84 <vprintfmt+0x3e9>
	else if (lflag)
  801a69:	85 c9                	test   %ecx,%ecx
  801a6b:	74 2c                	je     801a99 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  801a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a70:	8b 10                	mov    (%eax),%edx
  801a72:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a77:	8d 40 04             	lea    0x4(%eax),%eax
  801a7a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a7d:	b8 10 00 00 00       	mov    $0x10,%eax
  801a82:	eb be                	jmp    801a42 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801a84:	8b 45 14             	mov    0x14(%ebp),%eax
  801a87:	8b 10                	mov    (%eax),%edx
  801a89:	8b 48 04             	mov    0x4(%eax),%ecx
  801a8c:	8d 40 08             	lea    0x8(%eax),%eax
  801a8f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a92:	b8 10 00 00 00       	mov    $0x10,%eax
  801a97:	eb a9                	jmp    801a42 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801a99:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9c:	8b 10                	mov    (%eax),%edx
  801a9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa3:	8d 40 04             	lea    0x4(%eax),%eax
  801aa6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aa9:	b8 10 00 00 00       	mov    $0x10,%eax
  801aae:	eb 92                	jmp    801a42 <vprintfmt+0x3a7>
			putch(ch, putdat);
  801ab0:	83 ec 08             	sub    $0x8,%esp
  801ab3:	53                   	push   %ebx
  801ab4:	6a 25                	push   $0x25
  801ab6:	ff d6                	call   *%esi
			break;
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	eb 9f                	jmp    801a5c <vprintfmt+0x3c1>
			putch('%', putdat);
  801abd:	83 ec 08             	sub    $0x8,%esp
  801ac0:	53                   	push   %ebx
  801ac1:	6a 25                	push   $0x25
  801ac3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	89 f8                	mov    %edi,%eax
  801aca:	eb 03                	jmp    801acf <vprintfmt+0x434>
  801acc:	83 e8 01             	sub    $0x1,%eax
  801acf:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801ad3:	75 f7                	jne    801acc <vprintfmt+0x431>
  801ad5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ad8:	eb 82                	jmp    801a5c <vprintfmt+0x3c1>

00801ada <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 18             	sub    $0x18,%esp
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ae6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ae9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801aed:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801af0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801af7:	85 c0                	test   %eax,%eax
  801af9:	74 26                	je     801b21 <vsnprintf+0x47>
  801afb:	85 d2                	test   %edx,%edx
  801afd:	7e 22                	jle    801b21 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801aff:	ff 75 14             	pushl  0x14(%ebp)
  801b02:	ff 75 10             	pushl  0x10(%ebp)
  801b05:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b08:	50                   	push   %eax
  801b09:	68 61 16 80 00       	push   $0x801661
  801b0e:	e8 88 fb ff ff       	call   80169b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b16:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1c:	83 c4 10             	add    $0x10,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    
		return -E_INVAL;
  801b21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b26:	eb f7                	jmp    801b1f <vsnprintf+0x45>

00801b28 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b2e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b31:	50                   	push   %eax
  801b32:	ff 75 10             	pushl  0x10(%ebp)
  801b35:	ff 75 0c             	pushl  0xc(%ebp)
  801b38:	ff 75 08             	pushl  0x8(%ebp)
  801b3b:	e8 9a ff ff ff       	call   801ada <vsnprintf>
	va_end(ap);

	return rc;
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b48:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b51:	74 05                	je     801b58 <strlen+0x16>
		n++;
  801b53:	83 c0 01             	add    $0x1,%eax
  801b56:	eb f5                	jmp    801b4d <strlen+0xb>
	return n;
}
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    

00801b5a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b60:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b63:	ba 00 00 00 00       	mov    $0x0,%edx
  801b68:	39 c2                	cmp    %eax,%edx
  801b6a:	74 0d                	je     801b79 <strnlen+0x1f>
  801b6c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801b70:	74 05                	je     801b77 <strnlen+0x1d>
		n++;
  801b72:	83 c2 01             	add    $0x1,%edx
  801b75:	eb f1                	jmp    801b68 <strnlen+0xe>
  801b77:	89 d0                	mov    %edx,%eax
	return n;
}
  801b79:	5d                   	pop    %ebp
  801b7a:	c3                   	ret    

00801b7b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	53                   	push   %ebx
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b85:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801b8e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801b91:	83 c2 01             	add    $0x1,%edx
  801b94:	84 c9                	test   %cl,%cl
  801b96:	75 f2                	jne    801b8a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801b98:	5b                   	pop    %ebx
  801b99:	5d                   	pop    %ebp
  801b9a:	c3                   	ret    

00801b9b <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	53                   	push   %ebx
  801b9f:	83 ec 10             	sub    $0x10,%esp
  801ba2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801ba5:	53                   	push   %ebx
  801ba6:	e8 97 ff ff ff       	call   801b42 <strlen>
  801bab:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801bae:	ff 75 0c             	pushl  0xc(%ebp)
  801bb1:	01 d8                	add    %ebx,%eax
  801bb3:	50                   	push   %eax
  801bb4:	e8 c2 ff ff ff       	call   801b7b <strcpy>
	return dst;
}
  801bb9:	89 d8                	mov    %ebx,%eax
  801bbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	56                   	push   %esi
  801bc4:	53                   	push   %ebx
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bcb:	89 c6                	mov    %eax,%esi
  801bcd:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bd0:	89 c2                	mov    %eax,%edx
  801bd2:	39 f2                	cmp    %esi,%edx
  801bd4:	74 11                	je     801be7 <strncpy+0x27>
		*dst++ = *src;
  801bd6:	83 c2 01             	add    $0x1,%edx
  801bd9:	0f b6 19             	movzbl (%ecx),%ebx
  801bdc:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801bdf:	80 fb 01             	cmp    $0x1,%bl
  801be2:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801be5:	eb eb                	jmp    801bd2 <strncpy+0x12>
	}
	return ret;
}
  801be7:	5b                   	pop    %ebx
  801be8:	5e                   	pop    %esi
  801be9:	5d                   	pop    %ebp
  801bea:	c3                   	ret    

00801beb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	56                   	push   %esi
  801bef:	53                   	push   %ebx
  801bf0:	8b 75 08             	mov    0x8(%ebp),%esi
  801bf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bf6:	8b 55 10             	mov    0x10(%ebp),%edx
  801bf9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801bfb:	85 d2                	test   %edx,%edx
  801bfd:	74 21                	je     801c20 <strlcpy+0x35>
  801bff:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801c03:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801c05:	39 c2                	cmp    %eax,%edx
  801c07:	74 14                	je     801c1d <strlcpy+0x32>
  801c09:	0f b6 19             	movzbl (%ecx),%ebx
  801c0c:	84 db                	test   %bl,%bl
  801c0e:	74 0b                	je     801c1b <strlcpy+0x30>
			*dst++ = *src++;
  801c10:	83 c1 01             	add    $0x1,%ecx
  801c13:	83 c2 01             	add    $0x1,%edx
  801c16:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c19:	eb ea                	jmp    801c05 <strlcpy+0x1a>
  801c1b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801c1d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c20:	29 f0                	sub    %esi,%eax
}
  801c22:	5b                   	pop    %ebx
  801c23:	5e                   	pop    %esi
  801c24:	5d                   	pop    %ebp
  801c25:	c3                   	ret    

00801c26 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c2f:	0f b6 01             	movzbl (%ecx),%eax
  801c32:	84 c0                	test   %al,%al
  801c34:	74 0c                	je     801c42 <strcmp+0x1c>
  801c36:	3a 02                	cmp    (%edx),%al
  801c38:	75 08                	jne    801c42 <strcmp+0x1c>
		p++, q++;
  801c3a:	83 c1 01             	add    $0x1,%ecx
  801c3d:	83 c2 01             	add    $0x1,%edx
  801c40:	eb ed                	jmp    801c2f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c42:	0f b6 c0             	movzbl %al,%eax
  801c45:	0f b6 12             	movzbl (%edx),%edx
  801c48:	29 d0                	sub    %edx,%eax
}
  801c4a:	5d                   	pop    %ebp
  801c4b:	c3                   	ret    

00801c4c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	53                   	push   %ebx
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c56:	89 c3                	mov    %eax,%ebx
  801c58:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c5b:	eb 06                	jmp    801c63 <strncmp+0x17>
		n--, p++, q++;
  801c5d:	83 c0 01             	add    $0x1,%eax
  801c60:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c63:	39 d8                	cmp    %ebx,%eax
  801c65:	74 16                	je     801c7d <strncmp+0x31>
  801c67:	0f b6 08             	movzbl (%eax),%ecx
  801c6a:	84 c9                	test   %cl,%cl
  801c6c:	74 04                	je     801c72 <strncmp+0x26>
  801c6e:	3a 0a                	cmp    (%edx),%cl
  801c70:	74 eb                	je     801c5d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c72:	0f b6 00             	movzbl (%eax),%eax
  801c75:	0f b6 12             	movzbl (%edx),%edx
  801c78:	29 d0                	sub    %edx,%eax
}
  801c7a:	5b                   	pop    %ebx
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    
		return 0;
  801c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c82:	eb f6                	jmp    801c7a <strncmp+0x2e>

00801c84 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801c8e:	0f b6 10             	movzbl (%eax),%edx
  801c91:	84 d2                	test   %dl,%dl
  801c93:	74 09                	je     801c9e <strchr+0x1a>
		if (*s == c)
  801c95:	38 ca                	cmp    %cl,%dl
  801c97:	74 0a                	je     801ca3 <strchr+0x1f>
	for (; *s; s++)
  801c99:	83 c0 01             	add    $0x1,%eax
  801c9c:	eb f0                	jmp    801c8e <strchr+0xa>
			return (char *) s;
	return 0;
  801c9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca3:	5d                   	pop    %ebp
  801ca4:	c3                   	ret    

00801ca5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801caf:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cb2:	38 ca                	cmp    %cl,%dl
  801cb4:	74 09                	je     801cbf <strfind+0x1a>
  801cb6:	84 d2                	test   %dl,%dl
  801cb8:	74 05                	je     801cbf <strfind+0x1a>
	for (; *s; s++)
  801cba:	83 c0 01             	add    $0x1,%eax
  801cbd:	eb f0                	jmp    801caf <strfind+0xa>
			break;
	return (char *) s;
}
  801cbf:	5d                   	pop    %ebp
  801cc0:	c3                   	ret    

00801cc1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	57                   	push   %edi
  801cc5:	56                   	push   %esi
  801cc6:	53                   	push   %ebx
  801cc7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cca:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ccd:	85 c9                	test   %ecx,%ecx
  801ccf:	74 31                	je     801d02 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801cd1:	89 f8                	mov    %edi,%eax
  801cd3:	09 c8                	or     %ecx,%eax
  801cd5:	a8 03                	test   $0x3,%al
  801cd7:	75 23                	jne    801cfc <memset+0x3b>
		c &= 0xFF;
  801cd9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801cdd:	89 d3                	mov    %edx,%ebx
  801cdf:	c1 e3 08             	shl    $0x8,%ebx
  801ce2:	89 d0                	mov    %edx,%eax
  801ce4:	c1 e0 18             	shl    $0x18,%eax
  801ce7:	89 d6                	mov    %edx,%esi
  801ce9:	c1 e6 10             	shl    $0x10,%esi
  801cec:	09 f0                	or     %esi,%eax
  801cee:	09 c2                	or     %eax,%edx
  801cf0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801cf2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801cf5:	89 d0                	mov    %edx,%eax
  801cf7:	fc                   	cld    
  801cf8:	f3 ab                	rep stos %eax,%es:(%edi)
  801cfa:	eb 06                	jmp    801d02 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cff:	fc                   	cld    
  801d00:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801d02:	89 f8                	mov    %edi,%eax
  801d04:	5b                   	pop    %ebx
  801d05:	5e                   	pop    %esi
  801d06:	5f                   	pop    %edi
  801d07:	5d                   	pop    %ebp
  801d08:	c3                   	ret    

00801d09 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	57                   	push   %edi
  801d0d:	56                   	push   %esi
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d14:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d17:	39 c6                	cmp    %eax,%esi
  801d19:	73 32                	jae    801d4d <memmove+0x44>
  801d1b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d1e:	39 c2                	cmp    %eax,%edx
  801d20:	76 2b                	jbe    801d4d <memmove+0x44>
		s += n;
		d += n;
  801d22:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d25:	89 fe                	mov    %edi,%esi
  801d27:	09 ce                	or     %ecx,%esi
  801d29:	09 d6                	or     %edx,%esi
  801d2b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d31:	75 0e                	jne    801d41 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d33:	83 ef 04             	sub    $0x4,%edi
  801d36:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d39:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d3c:	fd                   	std    
  801d3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d3f:	eb 09                	jmp    801d4a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d41:	83 ef 01             	sub    $0x1,%edi
  801d44:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d47:	fd                   	std    
  801d48:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d4a:	fc                   	cld    
  801d4b:	eb 1a                	jmp    801d67 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d4d:	89 c2                	mov    %eax,%edx
  801d4f:	09 ca                	or     %ecx,%edx
  801d51:	09 f2                	or     %esi,%edx
  801d53:	f6 c2 03             	test   $0x3,%dl
  801d56:	75 0a                	jne    801d62 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d58:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d5b:	89 c7                	mov    %eax,%edi
  801d5d:	fc                   	cld    
  801d5e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d60:	eb 05                	jmp    801d67 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801d62:	89 c7                	mov    %eax,%edi
  801d64:	fc                   	cld    
  801d65:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d67:	5e                   	pop    %esi
  801d68:	5f                   	pop    %edi
  801d69:	5d                   	pop    %ebp
  801d6a:	c3                   	ret    

00801d6b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801d71:	ff 75 10             	pushl  0x10(%ebp)
  801d74:	ff 75 0c             	pushl  0xc(%ebp)
  801d77:	ff 75 08             	pushl  0x8(%ebp)
  801d7a:	e8 8a ff ff ff       	call   801d09 <memmove>
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	56                   	push   %esi
  801d85:	53                   	push   %ebx
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8c:	89 c6                	mov    %eax,%esi
  801d8e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801d91:	39 f0                	cmp    %esi,%eax
  801d93:	74 1c                	je     801db1 <memcmp+0x30>
		if (*s1 != *s2)
  801d95:	0f b6 08             	movzbl (%eax),%ecx
  801d98:	0f b6 1a             	movzbl (%edx),%ebx
  801d9b:	38 d9                	cmp    %bl,%cl
  801d9d:	75 08                	jne    801da7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801d9f:	83 c0 01             	add    $0x1,%eax
  801da2:	83 c2 01             	add    $0x1,%edx
  801da5:	eb ea                	jmp    801d91 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801da7:	0f b6 c1             	movzbl %cl,%eax
  801daa:	0f b6 db             	movzbl %bl,%ebx
  801dad:	29 d8                	sub    %ebx,%eax
  801daf:	eb 05                	jmp    801db6 <memcmp+0x35>
	}

	return 0;
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db6:	5b                   	pop    %ebx
  801db7:	5e                   	pop    %esi
  801db8:	5d                   	pop    %ebp
  801db9:	c3                   	ret    

00801dba <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801dc3:	89 c2                	mov    %eax,%edx
  801dc5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801dc8:	39 d0                	cmp    %edx,%eax
  801dca:	73 09                	jae    801dd5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dcc:	38 08                	cmp    %cl,(%eax)
  801dce:	74 05                	je     801dd5 <memfind+0x1b>
	for (; s < ends; s++)
  801dd0:	83 c0 01             	add    $0x1,%eax
  801dd3:	eb f3                	jmp    801dc8 <memfind+0xe>
			break;
	return (void *) s;
}
  801dd5:	5d                   	pop    %ebp
  801dd6:	c3                   	ret    

00801dd7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	57                   	push   %edi
  801ddb:	56                   	push   %esi
  801ddc:	53                   	push   %ebx
  801ddd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801de3:	eb 03                	jmp    801de8 <strtol+0x11>
		s++;
  801de5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801de8:	0f b6 01             	movzbl (%ecx),%eax
  801deb:	3c 20                	cmp    $0x20,%al
  801ded:	74 f6                	je     801de5 <strtol+0xe>
  801def:	3c 09                	cmp    $0x9,%al
  801df1:	74 f2                	je     801de5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801df3:	3c 2b                	cmp    $0x2b,%al
  801df5:	74 2a                	je     801e21 <strtol+0x4a>
	int neg = 0;
  801df7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801dfc:	3c 2d                	cmp    $0x2d,%al
  801dfe:	74 2b                	je     801e2b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e00:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e06:	75 0f                	jne    801e17 <strtol+0x40>
  801e08:	80 39 30             	cmpb   $0x30,(%ecx)
  801e0b:	74 28                	je     801e35 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e0d:	85 db                	test   %ebx,%ebx
  801e0f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801e14:	0f 44 d8             	cmove  %eax,%ebx
  801e17:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e1f:	eb 50                	jmp    801e71 <strtol+0x9a>
		s++;
  801e21:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e24:	bf 00 00 00 00       	mov    $0x0,%edi
  801e29:	eb d5                	jmp    801e00 <strtol+0x29>
		s++, neg = 1;
  801e2b:	83 c1 01             	add    $0x1,%ecx
  801e2e:	bf 01 00 00 00       	mov    $0x1,%edi
  801e33:	eb cb                	jmp    801e00 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e35:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e39:	74 0e                	je     801e49 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801e3b:	85 db                	test   %ebx,%ebx
  801e3d:	75 d8                	jne    801e17 <strtol+0x40>
		s++, base = 8;
  801e3f:	83 c1 01             	add    $0x1,%ecx
  801e42:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e47:	eb ce                	jmp    801e17 <strtol+0x40>
		s += 2, base = 16;
  801e49:	83 c1 02             	add    $0x2,%ecx
  801e4c:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e51:	eb c4                	jmp    801e17 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e53:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e56:	89 f3                	mov    %esi,%ebx
  801e58:	80 fb 19             	cmp    $0x19,%bl
  801e5b:	77 29                	ja     801e86 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801e5d:	0f be d2             	movsbl %dl,%edx
  801e60:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e63:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e66:	7d 30                	jge    801e98 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801e68:	83 c1 01             	add    $0x1,%ecx
  801e6b:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e6f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e71:	0f b6 11             	movzbl (%ecx),%edx
  801e74:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e77:	89 f3                	mov    %esi,%ebx
  801e79:	80 fb 09             	cmp    $0x9,%bl
  801e7c:	77 d5                	ja     801e53 <strtol+0x7c>
			dig = *s - '0';
  801e7e:	0f be d2             	movsbl %dl,%edx
  801e81:	83 ea 30             	sub    $0x30,%edx
  801e84:	eb dd                	jmp    801e63 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801e86:	8d 72 bf             	lea    -0x41(%edx),%esi
  801e89:	89 f3                	mov    %esi,%ebx
  801e8b:	80 fb 19             	cmp    $0x19,%bl
  801e8e:	77 08                	ja     801e98 <strtol+0xc1>
			dig = *s - 'A' + 10;
  801e90:	0f be d2             	movsbl %dl,%edx
  801e93:	83 ea 37             	sub    $0x37,%edx
  801e96:	eb cb                	jmp    801e63 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801e98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e9c:	74 05                	je     801ea3 <strtol+0xcc>
		*endptr = (char *) s;
  801e9e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ea1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801ea3:	89 c2                	mov    %eax,%edx
  801ea5:	f7 da                	neg    %edx
  801ea7:	85 ff                	test   %edi,%edi
  801ea9:	0f 45 c2             	cmovne %edx,%eax
}
  801eac:	5b                   	pop    %ebx
  801ead:	5e                   	pop    %esi
  801eae:	5f                   	pop    %edi
  801eaf:	5d                   	pop    %ebp
  801eb0:	c3                   	ret    

00801eb1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	56                   	push   %esi
  801eb5:	53                   	push   %ebx
  801eb6:	8b 75 08             	mov    0x8(%ebp),%esi
  801eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	74 4f                	je     801f12 <ipc_recv+0x61>
  801ec3:	83 ec 0c             	sub    $0xc,%esp
  801ec6:	50                   	push   %eax
  801ec7:	e8 35 e4 ff ff       	call   800301 <sys_ipc_recv>
  801ecc:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801ecf:	85 f6                	test   %esi,%esi
  801ed1:	74 14                	je     801ee7 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801ed3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	75 09                	jne    801ee5 <ipc_recv+0x34>
  801edc:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ee2:	8b 52 74             	mov    0x74(%edx),%edx
  801ee5:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801ee7:	85 db                	test   %ebx,%ebx
  801ee9:	74 14                	je     801eff <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801eeb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	75 09                	jne    801efd <ipc_recv+0x4c>
  801ef4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801efa:	8b 52 78             	mov    0x78(%edx),%edx
  801efd:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801eff:	85 c0                	test   %eax,%eax
  801f01:	75 08                	jne    801f0b <ipc_recv+0x5a>
  801f03:	a1 08 40 80 00       	mov    0x804008,%eax
  801f08:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f0e:	5b                   	pop    %ebx
  801f0f:	5e                   	pop    %esi
  801f10:	5d                   	pop    %ebp
  801f11:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f12:	83 ec 0c             	sub    $0xc,%esp
  801f15:	68 00 00 c0 ee       	push   $0xeec00000
  801f1a:	e8 e2 e3 ff ff       	call   800301 <sys_ipc_recv>
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	eb ab                	jmp    801ecf <ipc_recv+0x1e>

00801f24 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	57                   	push   %edi
  801f28:	56                   	push   %esi
  801f29:	53                   	push   %ebx
  801f2a:	83 ec 0c             	sub    $0xc,%esp
  801f2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f30:	8b 75 10             	mov    0x10(%ebp),%esi
  801f33:	eb 20                	jmp    801f55 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f35:	6a 00                	push   $0x0
  801f37:	68 00 00 c0 ee       	push   $0xeec00000
  801f3c:	ff 75 0c             	pushl  0xc(%ebp)
  801f3f:	57                   	push   %edi
  801f40:	e8 99 e3 ff ff       	call   8002de <sys_ipc_try_send>
  801f45:	89 c3                	mov    %eax,%ebx
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	eb 1f                	jmp    801f6b <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801f4c:	e8 e1 e1 ff ff       	call   800132 <sys_yield>
	while(retval != 0) {
  801f51:	85 db                	test   %ebx,%ebx
  801f53:	74 33                	je     801f88 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f55:	85 f6                	test   %esi,%esi
  801f57:	74 dc                	je     801f35 <ipc_send+0x11>
  801f59:	ff 75 14             	pushl  0x14(%ebp)
  801f5c:	56                   	push   %esi
  801f5d:	ff 75 0c             	pushl  0xc(%ebp)
  801f60:	57                   	push   %edi
  801f61:	e8 78 e3 ff ff       	call   8002de <sys_ipc_try_send>
  801f66:	89 c3                	mov    %eax,%ebx
  801f68:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801f6b:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801f6e:	74 dc                	je     801f4c <ipc_send+0x28>
  801f70:	85 db                	test   %ebx,%ebx
  801f72:	74 d8                	je     801f4c <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801f74:	83 ec 04             	sub    $0x4,%esp
  801f77:	68 00 27 80 00       	push   $0x802700
  801f7c:	6a 35                	push   $0x35
  801f7e:	68 30 27 80 00       	push   $0x802730
  801f83:	e8 3c f5 ff ff       	call   8014c4 <_panic>
	}
}
  801f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f8b:	5b                   	pop    %ebx
  801f8c:	5e                   	pop    %esi
  801f8d:	5f                   	pop    %edi
  801f8e:	5d                   	pop    %ebp
  801f8f:	c3                   	ret    

00801f90 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f96:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f9b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f9e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fa4:	8b 52 50             	mov    0x50(%edx),%edx
  801fa7:	39 ca                	cmp    %ecx,%edx
  801fa9:	74 11                	je     801fbc <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fab:	83 c0 01             	add    $0x1,%eax
  801fae:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fb3:	75 e6                	jne    801f9b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fba:	eb 0b                	jmp    801fc7 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fbc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fbf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fc4:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fc7:	5d                   	pop    %ebp
  801fc8:	c3                   	ret    

00801fc9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fcf:	89 d0                	mov    %edx,%eax
  801fd1:	c1 e8 16             	shr    $0x16,%eax
  801fd4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fdb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fe0:	f6 c1 01             	test   $0x1,%cl
  801fe3:	74 1d                	je     802002 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fe5:	c1 ea 0c             	shr    $0xc,%edx
  801fe8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801fef:	f6 c2 01             	test   $0x1,%dl
  801ff2:	74 0e                	je     802002 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ff4:	c1 ea 0c             	shr    $0xc,%edx
  801ff7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ffe:	ef 
  801fff:	0f b7 c0             	movzwl %ax,%eax
}
  802002:	5d                   	pop    %ebp
  802003:	c3                   	ret    
  802004:	66 90                	xchg   %ax,%ax
  802006:	66 90                	xchg   %ax,%ax
  802008:	66 90                	xchg   %ax,%ax
  80200a:	66 90                	xchg   %ax,%ax
  80200c:	66 90                	xchg   %ax,%ax
  80200e:	66 90                	xchg   %ax,%ax

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
