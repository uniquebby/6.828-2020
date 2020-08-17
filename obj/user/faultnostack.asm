
obj/user/faultnostack.debug：     文件格式 elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 80 03 80 00       	push   $0x800380
  80003e:	6a 00                	push   $0x0
  800040:	e8 76 02 00 00       	call   8002bb <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	56                   	push   %esi
  800058:	53                   	push   %ebx
  800059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005f:	e8 ce 00 00 00       	call   800132 <sys_getenvid>
  800064:	25 ff 03 00 00       	and    $0x3ff,%eax
  800069:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800071:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800076:	85 db                	test   %ebx,%ebx
  800078:	7e 07                	jle    800081 <libmain+0x2d>
		binaryname = argv[0];
  80007a:	8b 06                	mov    (%esi),%eax
  80007c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800081:	83 ec 08             	sub    $0x8,%esp
  800084:	56                   	push   %esi
  800085:	53                   	push   %ebx
  800086:	e8 a8 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008b:	e8 0a 00 00 00       	call   80009a <exit>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    

0080009a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a0:	e8 da 04 00 00       	call   80057f <close_all>
	sys_env_destroy(0);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	e8 42 00 00 00       	call   8000f1 <sys_env_destroy>
}
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	c9                   	leave  
  8000b3:	c3                   	ret    

008000b4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b4:	55                   	push   %ebp
  8000b5:	89 e5                	mov    %esp,%ebp
  8000b7:	57                   	push   %edi
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c5:	89 c3                	mov    %eax,%ebx
  8000c7:	89 c7                	mov    %eax,%edi
  8000c9:	89 c6                	mov    %eax,%esi
  8000cb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5f                   	pop    %edi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    

008000d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d2:	55                   	push   %ebp
  8000d3:	89 e5                	mov    %esp,%ebp
  8000d5:	57                   	push   %edi
  8000d6:	56                   	push   %esi
  8000d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8000dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e2:	89 d1                	mov    %edx,%ecx
  8000e4:	89 d3                	mov    %edx,%ebx
  8000e6:	89 d7                	mov    %edx,%edi
  8000e8:	89 d6                	mov    %edx,%esi
  8000ea:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ec:	5b                   	pop    %ebx
  8000ed:	5e                   	pop    %esi
  8000ee:	5f                   	pop    %edi
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    

008000f1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	57                   	push   %edi
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800102:	b8 03 00 00 00       	mov    $0x3,%eax
  800107:	89 cb                	mov    %ecx,%ebx
  800109:	89 cf                	mov    %ecx,%edi
  80010b:	89 ce                	mov    %ecx,%esi
  80010d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80010f:	85 c0                	test   %eax,%eax
  800111:	7f 08                	jg     80011b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800113:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800116:	5b                   	pop    %ebx
  800117:	5e                   	pop    %esi
  800118:	5f                   	pop    %edi
  800119:	5d                   	pop    %ebp
  80011a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	6a 03                	push   $0x3
  800121:	68 2a 23 80 00       	push   $0x80232a
  800126:	6a 23                	push   $0x23
  800128:	68 47 23 80 00       	push   $0x802347
  80012d:	e8 d8 13 00 00       	call   80150a <_panic>

00800132 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	57                   	push   %edi
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
	asm volatile("int %1\n"
  800138:	ba 00 00 00 00       	mov    $0x0,%edx
  80013d:	b8 02 00 00 00       	mov    $0x2,%eax
  800142:	89 d1                	mov    %edx,%ecx
  800144:	89 d3                	mov    %edx,%ebx
  800146:	89 d7                	mov    %edx,%edi
  800148:	89 d6                	mov    %edx,%esi
  80014a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80014c:	5b                   	pop    %ebx
  80014d:	5e                   	pop    %esi
  80014e:	5f                   	pop    %edi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    

00800151 <sys_yield>:

void
sys_yield(void)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	57                   	push   %edi
  800155:	56                   	push   %esi
  800156:	53                   	push   %ebx
	asm volatile("int %1\n"
  800157:	ba 00 00 00 00       	mov    $0x0,%edx
  80015c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800161:	89 d1                	mov    %edx,%ecx
  800163:	89 d3                	mov    %edx,%ebx
  800165:	89 d7                	mov    %edx,%edi
  800167:	89 d6                	mov    %edx,%esi
  800169:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80016b:	5b                   	pop    %ebx
  80016c:	5e                   	pop    %esi
  80016d:	5f                   	pop    %edi
  80016e:	5d                   	pop    %ebp
  80016f:	c3                   	ret    

00800170 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	57                   	push   %edi
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
  800176:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800179:	be 00 00 00 00       	mov    $0x0,%esi
  80017e:	8b 55 08             	mov    0x8(%ebp),%edx
  800181:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800184:	b8 04 00 00 00       	mov    $0x4,%eax
  800189:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80018c:	89 f7                	mov    %esi,%edi
  80018e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800190:	85 c0                	test   %eax,%eax
  800192:	7f 08                	jg     80019c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800194:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800197:	5b                   	pop    %ebx
  800198:	5e                   	pop    %esi
  800199:	5f                   	pop    %edi
  80019a:	5d                   	pop    %ebp
  80019b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	50                   	push   %eax
  8001a0:	6a 04                	push   $0x4
  8001a2:	68 2a 23 80 00       	push   $0x80232a
  8001a7:	6a 23                	push   $0x23
  8001a9:	68 47 23 80 00       	push   $0x802347
  8001ae:	e8 57 13 00 00       	call   80150a <_panic>

008001b3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	57                   	push   %edi
  8001b7:	56                   	push   %esi
  8001b8:	53                   	push   %ebx
  8001b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8001bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c2:	b8 05 00 00 00       	mov    $0x5,%eax
  8001c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ca:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8001d0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001d2:	85 c0                	test   %eax,%eax
  8001d4:	7f 08                	jg     8001de <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d9:	5b                   	pop    %ebx
  8001da:	5e                   	pop    %esi
  8001db:	5f                   	pop    %edi
  8001dc:	5d                   	pop    %ebp
  8001dd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	50                   	push   %eax
  8001e2:	6a 05                	push   $0x5
  8001e4:	68 2a 23 80 00       	push   $0x80232a
  8001e9:	6a 23                	push   $0x23
  8001eb:	68 47 23 80 00       	push   $0x802347
  8001f0:	e8 15 13 00 00       	call   80150a <_panic>

008001f5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	57                   	push   %edi
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
  8001fb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800203:	8b 55 08             	mov    0x8(%ebp),%edx
  800206:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800209:	b8 06 00 00 00       	mov    $0x6,%eax
  80020e:	89 df                	mov    %ebx,%edi
  800210:	89 de                	mov    %ebx,%esi
  800212:	cd 30                	int    $0x30
	if(check && ret > 0)
  800214:	85 c0                	test   %eax,%eax
  800216:	7f 08                	jg     800220 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80021b:	5b                   	pop    %ebx
  80021c:	5e                   	pop    %esi
  80021d:	5f                   	pop    %edi
  80021e:	5d                   	pop    %ebp
  80021f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800220:	83 ec 0c             	sub    $0xc,%esp
  800223:	50                   	push   %eax
  800224:	6a 06                	push   $0x6
  800226:	68 2a 23 80 00       	push   $0x80232a
  80022b:	6a 23                	push   $0x23
  80022d:	68 47 23 80 00       	push   $0x802347
  800232:	e8 d3 12 00 00       	call   80150a <_panic>

00800237 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	57                   	push   %edi
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800240:	bb 00 00 00 00       	mov    $0x0,%ebx
  800245:	8b 55 08             	mov    0x8(%ebp),%edx
  800248:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80024b:	b8 08 00 00 00       	mov    $0x8,%eax
  800250:	89 df                	mov    %ebx,%edi
  800252:	89 de                	mov    %ebx,%esi
  800254:	cd 30                	int    $0x30
	if(check && ret > 0)
  800256:	85 c0                	test   %eax,%eax
  800258:	7f 08                	jg     800262 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80025a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025d:	5b                   	pop    %ebx
  80025e:	5e                   	pop    %esi
  80025f:	5f                   	pop    %edi
  800260:	5d                   	pop    %ebp
  800261:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	50                   	push   %eax
  800266:	6a 08                	push   $0x8
  800268:	68 2a 23 80 00       	push   $0x80232a
  80026d:	6a 23                	push   $0x23
  80026f:	68 47 23 80 00       	push   $0x802347
  800274:	e8 91 12 00 00       	call   80150a <_panic>

00800279 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	57                   	push   %edi
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800282:	bb 00 00 00 00       	mov    $0x0,%ebx
  800287:	8b 55 08             	mov    0x8(%ebp),%edx
  80028a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80028d:	b8 09 00 00 00       	mov    $0x9,%eax
  800292:	89 df                	mov    %ebx,%edi
  800294:	89 de                	mov    %ebx,%esi
  800296:	cd 30                	int    $0x30
	if(check && ret > 0)
  800298:	85 c0                	test   %eax,%eax
  80029a:	7f 08                	jg     8002a4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80029c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5f                   	pop    %edi
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	50                   	push   %eax
  8002a8:	6a 09                	push   $0x9
  8002aa:	68 2a 23 80 00       	push   $0x80232a
  8002af:	6a 23                	push   $0x23
  8002b1:	68 47 23 80 00       	push   $0x802347
  8002b6:	e8 4f 12 00 00       	call   80150a <_panic>

008002bb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	57                   	push   %edi
  8002bf:	56                   	push   %esi
  8002c0:	53                   	push   %ebx
  8002c1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002d4:	89 df                	mov    %ebx,%edi
  8002d6:	89 de                	mov    %ebx,%esi
  8002d8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	7f 08                	jg     8002e6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	50                   	push   %eax
  8002ea:	6a 0a                	push   $0xa
  8002ec:	68 2a 23 80 00       	push   $0x80232a
  8002f1:	6a 23                	push   $0x23
  8002f3:	68 47 23 80 00       	push   $0x802347
  8002f8:	e8 0d 12 00 00       	call   80150a <_panic>

008002fd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	57                   	push   %edi
  800301:	56                   	push   %esi
  800302:	53                   	push   %ebx
	asm volatile("int %1\n"
  800303:	8b 55 08             	mov    0x8(%ebp),%edx
  800306:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800309:	b8 0c 00 00 00       	mov    $0xc,%eax
  80030e:	be 00 00 00 00       	mov    $0x0,%esi
  800313:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800316:	8b 7d 14             	mov    0x14(%ebp),%edi
  800319:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80031b:	5b                   	pop    %ebx
  80031c:	5e                   	pop    %esi
  80031d:	5f                   	pop    %edi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    

00800320 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800329:	b9 00 00 00 00       	mov    $0x0,%ecx
  80032e:	8b 55 08             	mov    0x8(%ebp),%edx
  800331:	b8 0d 00 00 00       	mov    $0xd,%eax
  800336:	89 cb                	mov    %ecx,%ebx
  800338:	89 cf                	mov    %ecx,%edi
  80033a:	89 ce                	mov    %ecx,%esi
  80033c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80033e:	85 c0                	test   %eax,%eax
  800340:	7f 08                	jg     80034a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800345:	5b                   	pop    %ebx
  800346:	5e                   	pop    %esi
  800347:	5f                   	pop    %edi
  800348:	5d                   	pop    %ebp
  800349:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	50                   	push   %eax
  80034e:	6a 0d                	push   $0xd
  800350:	68 2a 23 80 00       	push   $0x80232a
  800355:	6a 23                	push   $0x23
  800357:	68 47 23 80 00       	push   $0x802347
  80035c:	e8 a9 11 00 00       	call   80150a <_panic>

00800361 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	57                   	push   %edi
  800365:	56                   	push   %esi
  800366:	53                   	push   %ebx
	asm volatile("int %1\n"
  800367:	ba 00 00 00 00       	mov    $0x0,%edx
  80036c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800371:	89 d1                	mov    %edx,%ecx
  800373:	89 d3                	mov    %edx,%ebx
  800375:	89 d7                	mov    %edx,%edi
  800377:	89 d6                	mov    %edx,%esi
  800379:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80037b:	5b                   	pop    %ebx
  80037c:	5e                   	pop    %esi
  80037d:	5f                   	pop    %edi
  80037e:	5d                   	pop    %ebp
  80037f:	c3                   	ret    

00800380 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800380:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800381:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  800386:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800388:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
  //将预留的0置为eip，以便使用ret返回，esp指向此处
	movl 48(%esp),%ebp
  80038b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4,%ebp
  80038f:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp,48(%esp)
  800392:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp),%eax
  800396:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax,(%ebp)
  80039a:	89 45 00             	mov    %eax,0x0(%ebp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80039d:	83 c4 08             	add    $0x8,%esp
	popal
  8003a0:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8003a1:	83 c4 04             	add    $0x4,%esp
	popfl
  8003a4:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8003a5:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8003a6:	c3                   	ret    

008003a7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ad:	05 00 00 00 30       	add    $0x30000000,%eax
  8003b2:	c1 e8 0c             	shr    $0xc,%eax
}
  8003b5:	5d                   	pop    %ebp
  8003b6:	c3                   	ret    

008003b7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003cc:	5d                   	pop    %ebp
  8003cd:	c3                   	ret    

008003ce <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003d6:	89 c2                	mov    %eax,%edx
  8003d8:	c1 ea 16             	shr    $0x16,%edx
  8003db:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003e2:	f6 c2 01             	test   $0x1,%dl
  8003e5:	74 2d                	je     800414 <fd_alloc+0x46>
  8003e7:	89 c2                	mov    %eax,%edx
  8003e9:	c1 ea 0c             	shr    $0xc,%edx
  8003ec:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003f3:	f6 c2 01             	test   $0x1,%dl
  8003f6:	74 1c                	je     800414 <fd_alloc+0x46>
  8003f8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003fd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800402:	75 d2                	jne    8003d6 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80040d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800412:	eb 0a                	jmp    80041e <fd_alloc+0x50>
			*fd_store = fd;
  800414:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800417:	89 01                	mov    %eax,(%ecx)
			return 0;
  800419:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80041e:	5d                   	pop    %ebp
  80041f:	c3                   	ret    

00800420 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800426:	83 f8 1f             	cmp    $0x1f,%eax
  800429:	77 30                	ja     80045b <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80042b:	c1 e0 0c             	shl    $0xc,%eax
  80042e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800433:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800439:	f6 c2 01             	test   $0x1,%dl
  80043c:	74 24                	je     800462 <fd_lookup+0x42>
  80043e:	89 c2                	mov    %eax,%edx
  800440:	c1 ea 0c             	shr    $0xc,%edx
  800443:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80044a:	f6 c2 01             	test   $0x1,%dl
  80044d:	74 1a                	je     800469 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80044f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800452:	89 02                	mov    %eax,(%edx)
	return 0;
  800454:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800459:	5d                   	pop    %ebp
  80045a:	c3                   	ret    
		return -E_INVAL;
  80045b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800460:	eb f7                	jmp    800459 <fd_lookup+0x39>
		return -E_INVAL;
  800462:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800467:	eb f0                	jmp    800459 <fd_lookup+0x39>
  800469:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80046e:	eb e9                	jmp    800459 <fd_lookup+0x39>

00800470 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800479:	ba 00 00 00 00       	mov    $0x0,%edx
  80047e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800483:	39 08                	cmp    %ecx,(%eax)
  800485:	74 38                	je     8004bf <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800487:	83 c2 01             	add    $0x1,%edx
  80048a:	8b 04 95 d4 23 80 00 	mov    0x8023d4(,%edx,4),%eax
  800491:	85 c0                	test   %eax,%eax
  800493:	75 ee                	jne    800483 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800495:	a1 08 40 80 00       	mov    0x804008,%eax
  80049a:	8b 40 48             	mov    0x48(%eax),%eax
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	51                   	push   %ecx
  8004a1:	50                   	push   %eax
  8004a2:	68 58 23 80 00       	push   $0x802358
  8004a7:	e8 39 11 00 00       	call   8015e5 <cprintf>
	*dev = 0;
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004bd:	c9                   	leave  
  8004be:	c3                   	ret    
			*dev = devtab[i];
  8004bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c9:	eb f2                	jmp    8004bd <dev_lookup+0x4d>

008004cb <fd_close>:
{
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	57                   	push   %edi
  8004cf:	56                   	push   %esi
  8004d0:	53                   	push   %ebx
  8004d1:	83 ec 24             	sub    $0x24,%esp
  8004d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004dd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004de:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004e4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004e7:	50                   	push   %eax
  8004e8:	e8 33 ff ff ff       	call   800420 <fd_lookup>
  8004ed:	89 c3                	mov    %eax,%ebx
  8004ef:	83 c4 10             	add    $0x10,%esp
  8004f2:	85 c0                	test   %eax,%eax
  8004f4:	78 05                	js     8004fb <fd_close+0x30>
	    || fd != fd2)
  8004f6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004f9:	74 16                	je     800511 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004fb:	89 f8                	mov    %edi,%eax
  8004fd:	84 c0                	test   %al,%al
  8004ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800504:	0f 44 d8             	cmove  %eax,%ebx
}
  800507:	89 d8                	mov    %ebx,%eax
  800509:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80050c:	5b                   	pop    %ebx
  80050d:	5e                   	pop    %esi
  80050e:	5f                   	pop    %edi
  80050f:	5d                   	pop    %ebp
  800510:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800511:	83 ec 08             	sub    $0x8,%esp
  800514:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800517:	50                   	push   %eax
  800518:	ff 36                	pushl  (%esi)
  80051a:	e8 51 ff ff ff       	call   800470 <dev_lookup>
  80051f:	89 c3                	mov    %eax,%ebx
  800521:	83 c4 10             	add    $0x10,%esp
  800524:	85 c0                	test   %eax,%eax
  800526:	78 1a                	js     800542 <fd_close+0x77>
		if (dev->dev_close)
  800528:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80052e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800533:	85 c0                	test   %eax,%eax
  800535:	74 0b                	je     800542 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800537:	83 ec 0c             	sub    $0xc,%esp
  80053a:	56                   	push   %esi
  80053b:	ff d0                	call   *%eax
  80053d:	89 c3                	mov    %eax,%ebx
  80053f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	56                   	push   %esi
  800546:	6a 00                	push   $0x0
  800548:	e8 a8 fc ff ff       	call   8001f5 <sys_page_unmap>
	return r;
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	eb b5                	jmp    800507 <fd_close+0x3c>

00800552 <close>:

int
close(int fdnum)
{
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800558:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80055b:	50                   	push   %eax
  80055c:	ff 75 08             	pushl  0x8(%ebp)
  80055f:	e8 bc fe ff ff       	call   800420 <fd_lookup>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	85 c0                	test   %eax,%eax
  800569:	79 02                	jns    80056d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80056b:	c9                   	leave  
  80056c:	c3                   	ret    
		return fd_close(fd, 1);
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	6a 01                	push   $0x1
  800572:	ff 75 f4             	pushl  -0xc(%ebp)
  800575:	e8 51 ff ff ff       	call   8004cb <fd_close>
  80057a:	83 c4 10             	add    $0x10,%esp
  80057d:	eb ec                	jmp    80056b <close+0x19>

0080057f <close_all>:

void
close_all(void)
{
  80057f:	55                   	push   %ebp
  800580:	89 e5                	mov    %esp,%ebp
  800582:	53                   	push   %ebx
  800583:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800586:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80058b:	83 ec 0c             	sub    $0xc,%esp
  80058e:	53                   	push   %ebx
  80058f:	e8 be ff ff ff       	call   800552 <close>
	for (i = 0; i < MAXFD; i++)
  800594:	83 c3 01             	add    $0x1,%ebx
  800597:	83 c4 10             	add    $0x10,%esp
  80059a:	83 fb 20             	cmp    $0x20,%ebx
  80059d:	75 ec                	jne    80058b <close_all+0xc>
}
  80059f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	57                   	push   %edi
  8005a8:	56                   	push   %esi
  8005a9:	53                   	push   %ebx
  8005aa:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005ad:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005b0:	50                   	push   %eax
  8005b1:	ff 75 08             	pushl  0x8(%ebp)
  8005b4:	e8 67 fe ff ff       	call   800420 <fd_lookup>
  8005b9:	89 c3                	mov    %eax,%ebx
  8005bb:	83 c4 10             	add    $0x10,%esp
  8005be:	85 c0                	test   %eax,%eax
  8005c0:	0f 88 81 00 00 00    	js     800647 <dup+0xa3>
		return r;
	close(newfdnum);
  8005c6:	83 ec 0c             	sub    $0xc,%esp
  8005c9:	ff 75 0c             	pushl  0xc(%ebp)
  8005cc:	e8 81 ff ff ff       	call   800552 <close>

	newfd = INDEX2FD(newfdnum);
  8005d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005d4:	c1 e6 0c             	shl    $0xc,%esi
  8005d7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005dd:	83 c4 04             	add    $0x4,%esp
  8005e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005e3:	e8 cf fd ff ff       	call   8003b7 <fd2data>
  8005e8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005ea:	89 34 24             	mov    %esi,(%esp)
  8005ed:	e8 c5 fd ff ff       	call   8003b7 <fd2data>
  8005f2:	83 c4 10             	add    $0x10,%esp
  8005f5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005f7:	89 d8                	mov    %ebx,%eax
  8005f9:	c1 e8 16             	shr    $0x16,%eax
  8005fc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800603:	a8 01                	test   $0x1,%al
  800605:	74 11                	je     800618 <dup+0x74>
  800607:	89 d8                	mov    %ebx,%eax
  800609:	c1 e8 0c             	shr    $0xc,%eax
  80060c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800613:	f6 c2 01             	test   $0x1,%dl
  800616:	75 39                	jne    800651 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800618:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80061b:	89 d0                	mov    %edx,%eax
  80061d:	c1 e8 0c             	shr    $0xc,%eax
  800620:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800627:	83 ec 0c             	sub    $0xc,%esp
  80062a:	25 07 0e 00 00       	and    $0xe07,%eax
  80062f:	50                   	push   %eax
  800630:	56                   	push   %esi
  800631:	6a 00                	push   $0x0
  800633:	52                   	push   %edx
  800634:	6a 00                	push   $0x0
  800636:	e8 78 fb ff ff       	call   8001b3 <sys_page_map>
  80063b:	89 c3                	mov    %eax,%ebx
  80063d:	83 c4 20             	add    $0x20,%esp
  800640:	85 c0                	test   %eax,%eax
  800642:	78 31                	js     800675 <dup+0xd1>
		goto err;

	return newfdnum;
  800644:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800647:	89 d8                	mov    %ebx,%eax
  800649:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80064c:	5b                   	pop    %ebx
  80064d:	5e                   	pop    %esi
  80064e:	5f                   	pop    %edi
  80064f:	5d                   	pop    %ebp
  800650:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800651:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	25 07 0e 00 00       	and    $0xe07,%eax
  800660:	50                   	push   %eax
  800661:	57                   	push   %edi
  800662:	6a 00                	push   $0x0
  800664:	53                   	push   %ebx
  800665:	6a 00                	push   $0x0
  800667:	e8 47 fb ff ff       	call   8001b3 <sys_page_map>
  80066c:	89 c3                	mov    %eax,%ebx
  80066e:	83 c4 20             	add    $0x20,%esp
  800671:	85 c0                	test   %eax,%eax
  800673:	79 a3                	jns    800618 <dup+0x74>
	sys_page_unmap(0, newfd);
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	56                   	push   %esi
  800679:	6a 00                	push   $0x0
  80067b:	e8 75 fb ff ff       	call   8001f5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800680:	83 c4 08             	add    $0x8,%esp
  800683:	57                   	push   %edi
  800684:	6a 00                	push   $0x0
  800686:	e8 6a fb ff ff       	call   8001f5 <sys_page_unmap>
	return r;
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	eb b7                	jmp    800647 <dup+0xa3>

00800690 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800690:	55                   	push   %ebp
  800691:	89 e5                	mov    %esp,%ebp
  800693:	53                   	push   %ebx
  800694:	83 ec 1c             	sub    $0x1c,%esp
  800697:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80069a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80069d:	50                   	push   %eax
  80069e:	53                   	push   %ebx
  80069f:	e8 7c fd ff ff       	call   800420 <fd_lookup>
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	85 c0                	test   %eax,%eax
  8006a9:	78 3f                	js     8006ea <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006b1:	50                   	push   %eax
  8006b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b5:	ff 30                	pushl  (%eax)
  8006b7:	e8 b4 fd ff ff       	call   800470 <dev_lookup>
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	85 c0                	test   %eax,%eax
  8006c1:	78 27                	js     8006ea <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006c6:	8b 42 08             	mov    0x8(%edx),%eax
  8006c9:	83 e0 03             	and    $0x3,%eax
  8006cc:	83 f8 01             	cmp    $0x1,%eax
  8006cf:	74 1e                	je     8006ef <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d4:	8b 40 08             	mov    0x8(%eax),%eax
  8006d7:	85 c0                	test   %eax,%eax
  8006d9:	74 35                	je     800710 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	ff 75 10             	pushl  0x10(%ebp)
  8006e1:	ff 75 0c             	pushl  0xc(%ebp)
  8006e4:	52                   	push   %edx
  8006e5:	ff d0                	call   *%eax
  8006e7:	83 c4 10             	add    $0x10,%esp
}
  8006ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ed:	c9                   	leave  
  8006ee:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006ef:	a1 08 40 80 00       	mov    0x804008,%eax
  8006f4:	8b 40 48             	mov    0x48(%eax),%eax
  8006f7:	83 ec 04             	sub    $0x4,%esp
  8006fa:	53                   	push   %ebx
  8006fb:	50                   	push   %eax
  8006fc:	68 99 23 80 00       	push   $0x802399
  800701:	e8 df 0e 00 00       	call   8015e5 <cprintf>
		return -E_INVAL;
  800706:	83 c4 10             	add    $0x10,%esp
  800709:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80070e:	eb da                	jmp    8006ea <read+0x5a>
		return -E_NOT_SUPP;
  800710:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800715:	eb d3                	jmp    8006ea <read+0x5a>

00800717 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	57                   	push   %edi
  80071b:	56                   	push   %esi
  80071c:	53                   	push   %ebx
  80071d:	83 ec 0c             	sub    $0xc,%esp
  800720:	8b 7d 08             	mov    0x8(%ebp),%edi
  800723:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800726:	bb 00 00 00 00       	mov    $0x0,%ebx
  80072b:	39 f3                	cmp    %esi,%ebx
  80072d:	73 23                	jae    800752 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80072f:	83 ec 04             	sub    $0x4,%esp
  800732:	89 f0                	mov    %esi,%eax
  800734:	29 d8                	sub    %ebx,%eax
  800736:	50                   	push   %eax
  800737:	89 d8                	mov    %ebx,%eax
  800739:	03 45 0c             	add    0xc(%ebp),%eax
  80073c:	50                   	push   %eax
  80073d:	57                   	push   %edi
  80073e:	e8 4d ff ff ff       	call   800690 <read>
		if (m < 0)
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	85 c0                	test   %eax,%eax
  800748:	78 06                	js     800750 <readn+0x39>
			return m;
		if (m == 0)
  80074a:	74 06                	je     800752 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80074c:	01 c3                	add    %eax,%ebx
  80074e:	eb db                	jmp    80072b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800750:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800752:	89 d8                	mov    %ebx,%eax
  800754:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800757:	5b                   	pop    %ebx
  800758:	5e                   	pop    %esi
  800759:	5f                   	pop    %edi
  80075a:	5d                   	pop    %ebp
  80075b:	c3                   	ret    

0080075c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	53                   	push   %ebx
  800760:	83 ec 1c             	sub    $0x1c,%esp
  800763:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800766:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800769:	50                   	push   %eax
  80076a:	53                   	push   %ebx
  80076b:	e8 b0 fc ff ff       	call   800420 <fd_lookup>
  800770:	83 c4 10             	add    $0x10,%esp
  800773:	85 c0                	test   %eax,%eax
  800775:	78 3a                	js     8007b1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80077d:	50                   	push   %eax
  80077e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800781:	ff 30                	pushl  (%eax)
  800783:	e8 e8 fc ff ff       	call   800470 <dev_lookup>
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	85 c0                	test   %eax,%eax
  80078d:	78 22                	js     8007b1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80078f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800792:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800796:	74 1e                	je     8007b6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800798:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079b:	8b 52 0c             	mov    0xc(%edx),%edx
  80079e:	85 d2                	test   %edx,%edx
  8007a0:	74 35                	je     8007d7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007a2:	83 ec 04             	sub    $0x4,%esp
  8007a5:	ff 75 10             	pushl  0x10(%ebp)
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	50                   	push   %eax
  8007ac:	ff d2                	call   *%edx
  8007ae:	83 c4 10             	add    $0x10,%esp
}
  8007b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b4:	c9                   	leave  
  8007b5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007b6:	a1 08 40 80 00       	mov    0x804008,%eax
  8007bb:	8b 40 48             	mov    0x48(%eax),%eax
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	53                   	push   %ebx
  8007c2:	50                   	push   %eax
  8007c3:	68 b5 23 80 00       	push   $0x8023b5
  8007c8:	e8 18 0e 00 00       	call   8015e5 <cprintf>
		return -E_INVAL;
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d5:	eb da                	jmp    8007b1 <write+0x55>
		return -E_NOT_SUPP;
  8007d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007dc:	eb d3                	jmp    8007b1 <write+0x55>

008007de <seek>:

int
seek(int fdnum, off_t offset)
{
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007e7:	50                   	push   %eax
  8007e8:	ff 75 08             	pushl  0x8(%ebp)
  8007eb:	e8 30 fc ff ff       	call   800420 <fd_lookup>
  8007f0:	83 c4 10             	add    $0x10,%esp
  8007f3:	85 c0                	test   %eax,%eax
  8007f5:	78 0e                	js     800805 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007fd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800800:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800805:	c9                   	leave  
  800806:	c3                   	ret    

00800807 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	53                   	push   %ebx
  80080b:	83 ec 1c             	sub    $0x1c,%esp
  80080e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800811:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800814:	50                   	push   %eax
  800815:	53                   	push   %ebx
  800816:	e8 05 fc ff ff       	call   800420 <fd_lookup>
  80081b:	83 c4 10             	add    $0x10,%esp
  80081e:	85 c0                	test   %eax,%eax
  800820:	78 37                	js     800859 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800828:	50                   	push   %eax
  800829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082c:	ff 30                	pushl  (%eax)
  80082e:	e8 3d fc ff ff       	call   800470 <dev_lookup>
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	85 c0                	test   %eax,%eax
  800838:	78 1f                	js     800859 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80083a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800841:	74 1b                	je     80085e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800843:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800846:	8b 52 18             	mov    0x18(%edx),%edx
  800849:	85 d2                	test   %edx,%edx
  80084b:	74 32                	je     80087f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	ff 75 0c             	pushl  0xc(%ebp)
  800853:	50                   	push   %eax
  800854:	ff d2                	call   *%edx
  800856:	83 c4 10             	add    $0x10,%esp
}
  800859:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085c:	c9                   	leave  
  80085d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80085e:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800863:	8b 40 48             	mov    0x48(%eax),%eax
  800866:	83 ec 04             	sub    $0x4,%esp
  800869:	53                   	push   %ebx
  80086a:	50                   	push   %eax
  80086b:	68 78 23 80 00       	push   $0x802378
  800870:	e8 70 0d 00 00       	call   8015e5 <cprintf>
		return -E_INVAL;
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80087d:	eb da                	jmp    800859 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80087f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800884:	eb d3                	jmp    800859 <ftruncate+0x52>

00800886 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	53                   	push   %ebx
  80088a:	83 ec 1c             	sub    $0x1c,%esp
  80088d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800890:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	ff 75 08             	pushl  0x8(%ebp)
  800897:	e8 84 fb ff ff       	call   800420 <fd_lookup>
  80089c:	83 c4 10             	add    $0x10,%esp
  80089f:	85 c0                	test   %eax,%eax
  8008a1:	78 4b                	js     8008ee <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008a9:	50                   	push   %eax
  8008aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ad:	ff 30                	pushl  (%eax)
  8008af:	e8 bc fb ff ff       	call   800470 <dev_lookup>
  8008b4:	83 c4 10             	add    $0x10,%esp
  8008b7:	85 c0                	test   %eax,%eax
  8008b9:	78 33                	js     8008ee <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8008bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008be:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008c2:	74 2f                	je     8008f3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008c4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008c7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008ce:	00 00 00 
	stat->st_isdir = 0;
  8008d1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008d8:	00 00 00 
	stat->st_dev = dev;
  8008db:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	53                   	push   %ebx
  8008e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8008e8:	ff 50 14             	call   *0x14(%eax)
  8008eb:	83 c4 10             	add    $0x10,%esp
}
  8008ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    
		return -E_NOT_SUPP;
  8008f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008f8:	eb f4                	jmp    8008ee <fstat+0x68>

008008fa <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	56                   	push   %esi
  8008fe:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	6a 00                	push   $0x0
  800904:	ff 75 08             	pushl  0x8(%ebp)
  800907:	e8 2f 02 00 00       	call   800b3b <open>
  80090c:	89 c3                	mov    %eax,%ebx
  80090e:	83 c4 10             	add    $0x10,%esp
  800911:	85 c0                	test   %eax,%eax
  800913:	78 1b                	js     800930 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800915:	83 ec 08             	sub    $0x8,%esp
  800918:	ff 75 0c             	pushl  0xc(%ebp)
  80091b:	50                   	push   %eax
  80091c:	e8 65 ff ff ff       	call   800886 <fstat>
  800921:	89 c6                	mov    %eax,%esi
	close(fd);
  800923:	89 1c 24             	mov    %ebx,(%esp)
  800926:	e8 27 fc ff ff       	call   800552 <close>
	return r;
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	89 f3                	mov    %esi,%ebx
}
  800930:	89 d8                	mov    %ebx,%eax
  800932:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800935:	5b                   	pop    %ebx
  800936:	5e                   	pop    %esi
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    

00800939 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	56                   	push   %esi
  80093d:	53                   	push   %ebx
  80093e:	89 c6                	mov    %eax,%esi
  800940:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800942:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800949:	74 27                	je     800972 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80094b:	6a 07                	push   $0x7
  80094d:	68 00 50 80 00       	push   $0x805000
  800952:	56                   	push   %esi
  800953:	ff 35 00 40 80 00    	pushl  0x804000
  800959:	e8 82 16 00 00       	call   801fe0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80095e:	83 c4 0c             	add    $0xc,%esp
  800961:	6a 00                	push   $0x0
  800963:	53                   	push   %ebx
  800964:	6a 00                	push   $0x0
  800966:	e8 02 16 00 00       	call   801f6d <ipc_recv>
}
  80096b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80096e:	5b                   	pop    %ebx
  80096f:	5e                   	pop    %esi
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800972:	83 ec 0c             	sub    $0xc,%esp
  800975:	6a 01                	push   $0x1
  800977:	e8 d0 16 00 00       	call   80204c <ipc_find_env>
  80097c:	a3 00 40 80 00       	mov    %eax,0x804000
  800981:	83 c4 10             	add    $0x10,%esp
  800984:	eb c5                	jmp    80094b <fsipc+0x12>

00800986 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	8b 40 0c             	mov    0xc(%eax),%eax
  800992:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80099f:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a4:	b8 02 00 00 00       	mov    $0x2,%eax
  8009a9:	e8 8b ff ff ff       	call   800939 <fsipc>
}
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <devfile_flush>:
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8009bc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c6:	b8 06 00 00 00       	mov    $0x6,%eax
  8009cb:	e8 69 ff ff ff       	call   800939 <fsipc>
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <devfile_stat>:
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	53                   	push   %ebx
  8009d6:	83 ec 04             	sub    $0x4,%esp
  8009d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	8b 40 0c             	mov    0xc(%eax),%eax
  8009e2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ec:	b8 05 00 00 00       	mov    $0x5,%eax
  8009f1:	e8 43 ff ff ff       	call   800939 <fsipc>
  8009f6:	85 c0                	test   %eax,%eax
  8009f8:	78 2c                	js     800a26 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	68 00 50 80 00       	push   $0x805000
  800a02:	53                   	push   %ebx
  800a03:	e8 b9 11 00 00       	call   801bc1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a08:	a1 80 50 80 00       	mov    0x805080,%eax
  800a0d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a13:	a1 84 50 80 00       	mov    0x805084,%eax
  800a18:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a1e:	83 c4 10             	add    $0x10,%esp
  800a21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a29:	c9                   	leave  
  800a2a:	c3                   	ret    

00800a2b <devfile_write>:
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	53                   	push   %ebx
  800a2f:	83 ec 04             	sub    $0x4,%esp
  800a32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  800a35:	85 db                	test   %ebx,%ebx
  800a37:	75 07                	jne    800a40 <devfile_write+0x15>
	return n_all;
  800a39:	89 d8                	mov    %ebx,%eax
}
  800a3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a3e:	c9                   	leave  
  800a3f:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	8b 40 0c             	mov    0xc(%eax),%eax
  800a46:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  800a4b:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  800a51:	83 ec 04             	sub    $0x4,%esp
  800a54:	53                   	push   %ebx
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	68 08 50 80 00       	push   $0x805008
  800a5d:	e8 ed 12 00 00       	call   801d4f <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	b8 04 00 00 00       	mov    $0x4,%eax
  800a6c:	e8 c8 fe ff ff       	call   800939 <fsipc>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	85 c0                	test   %eax,%eax
  800a76:	78 c3                	js     800a3b <devfile_write+0x10>
	  assert(r <= n_left);
  800a78:	39 d8                	cmp    %ebx,%eax
  800a7a:	77 0b                	ja     800a87 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  800a7c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a81:	7f 1d                	jg     800aa0 <devfile_write+0x75>
    n_all += r;
  800a83:	89 c3                	mov    %eax,%ebx
  800a85:	eb b2                	jmp    800a39 <devfile_write+0xe>
	  assert(r <= n_left);
  800a87:	68 e8 23 80 00       	push   $0x8023e8
  800a8c:	68 f4 23 80 00       	push   $0x8023f4
  800a91:	68 9f 00 00 00       	push   $0x9f
  800a96:	68 09 24 80 00       	push   $0x802409
  800a9b:	e8 6a 0a 00 00       	call   80150a <_panic>
	  assert(r <= PGSIZE);
  800aa0:	68 14 24 80 00       	push   $0x802414
  800aa5:	68 f4 23 80 00       	push   $0x8023f4
  800aaa:	68 a0 00 00 00       	push   $0xa0
  800aaf:	68 09 24 80 00       	push   $0x802409
  800ab4:	e8 51 0a 00 00       	call   80150a <_panic>

00800ab9 <devfile_read>:
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	56                   	push   %esi
  800abd:	53                   	push   %ebx
  800abe:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	8b 40 0c             	mov    0xc(%eax),%eax
  800ac7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800acc:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ad2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad7:	b8 03 00 00 00       	mov    $0x3,%eax
  800adc:	e8 58 fe ff ff       	call   800939 <fsipc>
  800ae1:	89 c3                	mov    %eax,%ebx
  800ae3:	85 c0                	test   %eax,%eax
  800ae5:	78 1f                	js     800b06 <devfile_read+0x4d>
	assert(r <= n);
  800ae7:	39 f0                	cmp    %esi,%eax
  800ae9:	77 24                	ja     800b0f <devfile_read+0x56>
	assert(r <= PGSIZE);
  800aeb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800af0:	7f 33                	jg     800b25 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800af2:	83 ec 04             	sub    $0x4,%esp
  800af5:	50                   	push   %eax
  800af6:	68 00 50 80 00       	push   $0x805000
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	e8 4c 12 00 00       	call   801d4f <memmove>
	return r;
  800b03:	83 c4 10             	add    $0x10,%esp
}
  800b06:	89 d8                	mov    %ebx,%eax
  800b08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b0b:	5b                   	pop    %ebx
  800b0c:	5e                   	pop    %esi
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    
	assert(r <= n);
  800b0f:	68 20 24 80 00       	push   $0x802420
  800b14:	68 f4 23 80 00       	push   $0x8023f4
  800b19:	6a 7c                	push   $0x7c
  800b1b:	68 09 24 80 00       	push   $0x802409
  800b20:	e8 e5 09 00 00       	call   80150a <_panic>
	assert(r <= PGSIZE);
  800b25:	68 14 24 80 00       	push   $0x802414
  800b2a:	68 f4 23 80 00       	push   $0x8023f4
  800b2f:	6a 7d                	push   $0x7d
  800b31:	68 09 24 80 00       	push   $0x802409
  800b36:	e8 cf 09 00 00       	call   80150a <_panic>

00800b3b <open>:
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	56                   	push   %esi
  800b3f:	53                   	push   %ebx
  800b40:	83 ec 1c             	sub    $0x1c,%esp
  800b43:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b46:	56                   	push   %esi
  800b47:	e8 3c 10 00 00       	call   801b88 <strlen>
  800b4c:	83 c4 10             	add    $0x10,%esp
  800b4f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b54:	7f 6c                	jg     800bc2 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b5c:	50                   	push   %eax
  800b5d:	e8 6c f8 ff ff       	call   8003ce <fd_alloc>
  800b62:	89 c3                	mov    %eax,%ebx
  800b64:	83 c4 10             	add    $0x10,%esp
  800b67:	85 c0                	test   %eax,%eax
  800b69:	78 3c                	js     800ba7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	56                   	push   %esi
  800b6f:	68 00 50 80 00       	push   $0x805000
  800b74:	e8 48 10 00 00       	call   801bc1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b84:	b8 01 00 00 00       	mov    $0x1,%eax
  800b89:	e8 ab fd ff ff       	call   800939 <fsipc>
  800b8e:	89 c3                	mov    %eax,%ebx
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	85 c0                	test   %eax,%eax
  800b95:	78 19                	js     800bb0 <open+0x75>
	return fd2num(fd);
  800b97:	83 ec 0c             	sub    $0xc,%esp
  800b9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9d:	e8 05 f8 ff ff       	call   8003a7 <fd2num>
  800ba2:	89 c3                	mov    %eax,%ebx
  800ba4:	83 c4 10             	add    $0x10,%esp
}
  800ba7:	89 d8                	mov    %ebx,%eax
  800ba9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    
		fd_close(fd, 0);
  800bb0:	83 ec 08             	sub    $0x8,%esp
  800bb3:	6a 00                	push   $0x0
  800bb5:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb8:	e8 0e f9 ff ff       	call   8004cb <fd_close>
		return r;
  800bbd:	83 c4 10             	add    $0x10,%esp
  800bc0:	eb e5                	jmp    800ba7 <open+0x6c>
		return -E_BAD_PATH;
  800bc2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bc7:	eb de                	jmp    800ba7 <open+0x6c>

00800bc9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd4:	b8 08 00 00 00       	mov    $0x8,%eax
  800bd9:	e8 5b fd ff ff       	call   800939 <fsipc>
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	56                   	push   %esi
  800be4:	53                   	push   %ebx
  800be5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800be8:	83 ec 0c             	sub    $0xc,%esp
  800beb:	ff 75 08             	pushl  0x8(%ebp)
  800bee:	e8 c4 f7 ff ff       	call   8003b7 <fd2data>
  800bf3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bf5:	83 c4 08             	add    $0x8,%esp
  800bf8:	68 27 24 80 00       	push   $0x802427
  800bfd:	53                   	push   %ebx
  800bfe:	e8 be 0f 00 00       	call   801bc1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c03:	8b 46 04             	mov    0x4(%esi),%eax
  800c06:	2b 06                	sub    (%esi),%eax
  800c08:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800c0e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c15:	00 00 00 
	stat->st_dev = &devpipe;
  800c18:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c1f:	30 80 00 
	return 0;
}
  800c22:	b8 00 00 00 00       	mov    $0x0,%eax
  800c27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c2a:	5b                   	pop    %ebx
  800c2b:	5e                   	pop    %esi
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    

00800c2e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	53                   	push   %ebx
  800c32:	83 ec 0c             	sub    $0xc,%esp
  800c35:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c38:	53                   	push   %ebx
  800c39:	6a 00                	push   $0x0
  800c3b:	e8 b5 f5 ff ff       	call   8001f5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c40:	89 1c 24             	mov    %ebx,(%esp)
  800c43:	e8 6f f7 ff ff       	call   8003b7 <fd2data>
  800c48:	83 c4 08             	add    $0x8,%esp
  800c4b:	50                   	push   %eax
  800c4c:	6a 00                	push   $0x0
  800c4e:	e8 a2 f5 ff ff       	call   8001f5 <sys_page_unmap>
}
  800c53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <_pipeisclosed>:
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
  800c5e:	83 ec 1c             	sub    $0x1c,%esp
  800c61:	89 c7                	mov    %eax,%edi
  800c63:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c65:	a1 08 40 80 00       	mov    0x804008,%eax
  800c6a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c6d:	83 ec 0c             	sub    $0xc,%esp
  800c70:	57                   	push   %edi
  800c71:	e8 0f 14 00 00       	call   802085 <pageref>
  800c76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c79:	89 34 24             	mov    %esi,(%esp)
  800c7c:	e8 04 14 00 00       	call   802085 <pageref>
		nn = thisenv->env_runs;
  800c81:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c87:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c8a:	83 c4 10             	add    $0x10,%esp
  800c8d:	39 cb                	cmp    %ecx,%ebx
  800c8f:	74 1b                	je     800cac <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c91:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c94:	75 cf                	jne    800c65 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c96:	8b 42 58             	mov    0x58(%edx),%eax
  800c99:	6a 01                	push   $0x1
  800c9b:	50                   	push   %eax
  800c9c:	53                   	push   %ebx
  800c9d:	68 2e 24 80 00       	push   $0x80242e
  800ca2:	e8 3e 09 00 00       	call   8015e5 <cprintf>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	eb b9                	jmp    800c65 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800cac:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800caf:	0f 94 c0             	sete   %al
  800cb2:	0f b6 c0             	movzbl %al,%eax
}
  800cb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb8:	5b                   	pop    %ebx
  800cb9:	5e                   	pop    %esi
  800cba:	5f                   	pop    %edi
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    

00800cbd <devpipe_write>:
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	57                   	push   %edi
  800cc1:	56                   	push   %esi
  800cc2:	53                   	push   %ebx
  800cc3:	83 ec 28             	sub    $0x28,%esp
  800cc6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800cc9:	56                   	push   %esi
  800cca:	e8 e8 f6 ff ff       	call   8003b7 <fd2data>
  800ccf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cd1:	83 c4 10             	add    $0x10,%esp
  800cd4:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800cdc:	74 4f                	je     800d2d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800cde:	8b 43 04             	mov    0x4(%ebx),%eax
  800ce1:	8b 0b                	mov    (%ebx),%ecx
  800ce3:	8d 51 20             	lea    0x20(%ecx),%edx
  800ce6:	39 d0                	cmp    %edx,%eax
  800ce8:	72 14                	jb     800cfe <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800cea:	89 da                	mov    %ebx,%edx
  800cec:	89 f0                	mov    %esi,%eax
  800cee:	e8 65 ff ff ff       	call   800c58 <_pipeisclosed>
  800cf3:	85 c0                	test   %eax,%eax
  800cf5:	75 3b                	jne    800d32 <devpipe_write+0x75>
			sys_yield();
  800cf7:	e8 55 f4 ff ff       	call   800151 <sys_yield>
  800cfc:	eb e0                	jmp    800cde <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d01:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800d05:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d08:	89 c2                	mov    %eax,%edx
  800d0a:	c1 fa 1f             	sar    $0x1f,%edx
  800d0d:	89 d1                	mov    %edx,%ecx
  800d0f:	c1 e9 1b             	shr    $0x1b,%ecx
  800d12:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800d15:	83 e2 1f             	and    $0x1f,%edx
  800d18:	29 ca                	sub    %ecx,%edx
  800d1a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d1e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d22:	83 c0 01             	add    $0x1,%eax
  800d25:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d28:	83 c7 01             	add    $0x1,%edi
  800d2b:	eb ac                	jmp    800cd9 <devpipe_write+0x1c>
	return i;
  800d2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d30:	eb 05                	jmp    800d37 <devpipe_write+0x7a>
				return 0;
  800d32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5f                   	pop    %edi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <devpipe_read>:
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	57                   	push   %edi
  800d43:	56                   	push   %esi
  800d44:	53                   	push   %ebx
  800d45:	83 ec 18             	sub    $0x18,%esp
  800d48:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d4b:	57                   	push   %edi
  800d4c:	e8 66 f6 ff ff       	call   8003b7 <fd2data>
  800d51:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d53:	83 c4 10             	add    $0x10,%esp
  800d56:	be 00 00 00 00       	mov    $0x0,%esi
  800d5b:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d5e:	75 14                	jne    800d74 <devpipe_read+0x35>
	return i;
  800d60:	8b 45 10             	mov    0x10(%ebp),%eax
  800d63:	eb 02                	jmp    800d67 <devpipe_read+0x28>
				return i;
  800d65:	89 f0                	mov    %esi,%eax
}
  800d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    
			sys_yield();
  800d6f:	e8 dd f3 ff ff       	call   800151 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d74:	8b 03                	mov    (%ebx),%eax
  800d76:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d79:	75 18                	jne    800d93 <devpipe_read+0x54>
			if (i > 0)
  800d7b:	85 f6                	test   %esi,%esi
  800d7d:	75 e6                	jne    800d65 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  800d7f:	89 da                	mov    %ebx,%edx
  800d81:	89 f8                	mov    %edi,%eax
  800d83:	e8 d0 fe ff ff       	call   800c58 <_pipeisclosed>
  800d88:	85 c0                	test   %eax,%eax
  800d8a:	74 e3                	je     800d6f <devpipe_read+0x30>
				return 0;
  800d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d91:	eb d4                	jmp    800d67 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d93:	99                   	cltd   
  800d94:	c1 ea 1b             	shr    $0x1b,%edx
  800d97:	01 d0                	add    %edx,%eax
  800d99:	83 e0 1f             	and    $0x1f,%eax
  800d9c:	29 d0                	sub    %edx,%eax
  800d9e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800da3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800da9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800dac:	83 c6 01             	add    $0x1,%esi
  800daf:	eb aa                	jmp    800d5b <devpipe_read+0x1c>

00800db1 <pipe>:
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	56                   	push   %esi
  800db5:	53                   	push   %ebx
  800db6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800db9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dbc:	50                   	push   %eax
  800dbd:	e8 0c f6 ff ff       	call   8003ce <fd_alloc>
  800dc2:	89 c3                	mov    %eax,%ebx
  800dc4:	83 c4 10             	add    $0x10,%esp
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	0f 88 23 01 00 00    	js     800ef2 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	68 07 04 00 00       	push   $0x407
  800dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dda:	6a 00                	push   $0x0
  800ddc:	e8 8f f3 ff ff       	call   800170 <sys_page_alloc>
  800de1:	89 c3                	mov    %eax,%ebx
  800de3:	83 c4 10             	add    $0x10,%esp
  800de6:	85 c0                	test   %eax,%eax
  800de8:	0f 88 04 01 00 00    	js     800ef2 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  800dee:	83 ec 0c             	sub    $0xc,%esp
  800df1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800df4:	50                   	push   %eax
  800df5:	e8 d4 f5 ff ff       	call   8003ce <fd_alloc>
  800dfa:	89 c3                	mov    %eax,%ebx
  800dfc:	83 c4 10             	add    $0x10,%esp
  800dff:	85 c0                	test   %eax,%eax
  800e01:	0f 88 db 00 00 00    	js     800ee2 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e07:	83 ec 04             	sub    $0x4,%esp
  800e0a:	68 07 04 00 00       	push   $0x407
  800e0f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e12:	6a 00                	push   $0x0
  800e14:	e8 57 f3 ff ff       	call   800170 <sys_page_alloc>
  800e19:	89 c3                	mov    %eax,%ebx
  800e1b:	83 c4 10             	add    $0x10,%esp
  800e1e:	85 c0                	test   %eax,%eax
  800e20:	0f 88 bc 00 00 00    	js     800ee2 <pipe+0x131>
	va = fd2data(fd0);
  800e26:	83 ec 0c             	sub    $0xc,%esp
  800e29:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2c:	e8 86 f5 ff ff       	call   8003b7 <fd2data>
  800e31:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e33:	83 c4 0c             	add    $0xc,%esp
  800e36:	68 07 04 00 00       	push   $0x407
  800e3b:	50                   	push   %eax
  800e3c:	6a 00                	push   $0x0
  800e3e:	e8 2d f3 ff ff       	call   800170 <sys_page_alloc>
  800e43:	89 c3                	mov    %eax,%ebx
  800e45:	83 c4 10             	add    $0x10,%esp
  800e48:	85 c0                	test   %eax,%eax
  800e4a:	0f 88 82 00 00 00    	js     800ed2 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e50:	83 ec 0c             	sub    $0xc,%esp
  800e53:	ff 75 f0             	pushl  -0x10(%ebp)
  800e56:	e8 5c f5 ff ff       	call   8003b7 <fd2data>
  800e5b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e62:	50                   	push   %eax
  800e63:	6a 00                	push   $0x0
  800e65:	56                   	push   %esi
  800e66:	6a 00                	push   $0x0
  800e68:	e8 46 f3 ff ff       	call   8001b3 <sys_page_map>
  800e6d:	89 c3                	mov    %eax,%ebx
  800e6f:	83 c4 20             	add    $0x20,%esp
  800e72:	85 c0                	test   %eax,%eax
  800e74:	78 4e                	js     800ec4 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  800e76:	a1 20 30 80 00       	mov    0x803020,%eax
  800e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e83:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e8d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e92:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e99:	83 ec 0c             	sub    $0xc,%esp
  800e9c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e9f:	e8 03 f5 ff ff       	call   8003a7 <fd2num>
  800ea4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800ea9:	83 c4 04             	add    $0x4,%esp
  800eac:	ff 75 f0             	pushl  -0x10(%ebp)
  800eaf:	e8 f3 f4 ff ff       	call   8003a7 <fd2num>
  800eb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800eba:	83 c4 10             	add    $0x10,%esp
  800ebd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec2:	eb 2e                	jmp    800ef2 <pipe+0x141>
	sys_page_unmap(0, va);
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	56                   	push   %esi
  800ec8:	6a 00                	push   $0x0
  800eca:	e8 26 f3 ff ff       	call   8001f5 <sys_page_unmap>
  800ecf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ed2:	83 ec 08             	sub    $0x8,%esp
  800ed5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ed8:	6a 00                	push   $0x0
  800eda:	e8 16 f3 ff ff       	call   8001f5 <sys_page_unmap>
  800edf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800ee2:	83 ec 08             	sub    $0x8,%esp
  800ee5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee8:	6a 00                	push   $0x0
  800eea:	e8 06 f3 ff ff       	call   8001f5 <sys_page_unmap>
  800eef:	83 c4 10             	add    $0x10,%esp
}
  800ef2:	89 d8                	mov    %ebx,%eax
  800ef4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ef7:	5b                   	pop    %ebx
  800ef8:	5e                   	pop    %esi
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <pipeisclosed>:
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f04:	50                   	push   %eax
  800f05:	ff 75 08             	pushl  0x8(%ebp)
  800f08:	e8 13 f5 ff ff       	call   800420 <fd_lookup>
  800f0d:	83 c4 10             	add    $0x10,%esp
  800f10:	85 c0                	test   %eax,%eax
  800f12:	78 18                	js     800f2c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800f14:	83 ec 0c             	sub    $0xc,%esp
  800f17:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1a:	e8 98 f4 ff ff       	call   8003b7 <fd2data>
	return _pipeisclosed(fd, p);
  800f1f:	89 c2                	mov    %eax,%edx
  800f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f24:	e8 2f fd ff ff       	call   800c58 <_pipeisclosed>
  800f29:	83 c4 10             	add    $0x10,%esp
}
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800f34:	68 46 24 80 00       	push   $0x802446
  800f39:	ff 75 0c             	pushl  0xc(%ebp)
  800f3c:	e8 80 0c 00 00       	call   801bc1 <strcpy>
	return 0;
}
  800f41:	b8 00 00 00 00       	mov    $0x0,%eax
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <devsock_close>:
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	53                   	push   %ebx
  800f4c:	83 ec 10             	sub    $0x10,%esp
  800f4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f52:	53                   	push   %ebx
  800f53:	e8 2d 11 00 00       	call   802085 <pageref>
  800f58:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f5b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f60:	83 f8 01             	cmp    $0x1,%eax
  800f63:	74 07                	je     800f6c <devsock_close+0x24>
}
  800f65:	89 d0                	mov    %edx,%eax
  800f67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f6a:	c9                   	leave  
  800f6b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f6c:	83 ec 0c             	sub    $0xc,%esp
  800f6f:	ff 73 0c             	pushl  0xc(%ebx)
  800f72:	e8 b9 02 00 00       	call   801230 <nsipc_close>
  800f77:	89 c2                	mov    %eax,%edx
  800f79:	83 c4 10             	add    $0x10,%esp
  800f7c:	eb e7                	jmp    800f65 <devsock_close+0x1d>

00800f7e <devsock_write>:
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f84:	6a 00                	push   $0x0
  800f86:	ff 75 10             	pushl  0x10(%ebp)
  800f89:	ff 75 0c             	pushl  0xc(%ebp)
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	ff 70 0c             	pushl  0xc(%eax)
  800f92:	e8 76 03 00 00       	call   80130d <nsipc_send>
}
  800f97:	c9                   	leave  
  800f98:	c3                   	ret    

00800f99 <devsock_read>:
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f9f:	6a 00                	push   $0x0
  800fa1:	ff 75 10             	pushl  0x10(%ebp)
  800fa4:	ff 75 0c             	pushl  0xc(%ebp)
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	ff 70 0c             	pushl  0xc(%eax)
  800fad:	e8 ef 02 00 00       	call   8012a1 <nsipc_recv>
}
  800fb2:	c9                   	leave  
  800fb3:	c3                   	ret    

00800fb4 <fd2sockid>:
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800fba:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800fbd:	52                   	push   %edx
  800fbe:	50                   	push   %eax
  800fbf:	e8 5c f4 ff ff       	call   800420 <fd_lookup>
  800fc4:	83 c4 10             	add    $0x10,%esp
  800fc7:	85 c0                	test   %eax,%eax
  800fc9:	78 10                	js     800fdb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fce:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800fd4:	39 08                	cmp    %ecx,(%eax)
  800fd6:	75 05                	jne    800fdd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800fd8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    
		return -E_NOT_SUPP;
  800fdd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800fe2:	eb f7                	jmp    800fdb <fd2sockid+0x27>

00800fe4 <alloc_sockfd>:
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	56                   	push   %esi
  800fe8:	53                   	push   %ebx
  800fe9:	83 ec 1c             	sub    $0x1c,%esp
  800fec:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ff1:	50                   	push   %eax
  800ff2:	e8 d7 f3 ff ff       	call   8003ce <fd_alloc>
  800ff7:	89 c3                	mov    %eax,%ebx
  800ff9:	83 c4 10             	add    $0x10,%esp
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	78 43                	js     801043 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801000:	83 ec 04             	sub    $0x4,%esp
  801003:	68 07 04 00 00       	push   $0x407
  801008:	ff 75 f4             	pushl  -0xc(%ebp)
  80100b:	6a 00                	push   $0x0
  80100d:	e8 5e f1 ff ff       	call   800170 <sys_page_alloc>
  801012:	89 c3                	mov    %eax,%ebx
  801014:	83 c4 10             	add    $0x10,%esp
  801017:	85 c0                	test   %eax,%eax
  801019:	78 28                	js     801043 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80101b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801024:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801029:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801030:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801033:	83 ec 0c             	sub    $0xc,%esp
  801036:	50                   	push   %eax
  801037:	e8 6b f3 ff ff       	call   8003a7 <fd2num>
  80103c:	89 c3                	mov    %eax,%ebx
  80103e:	83 c4 10             	add    $0x10,%esp
  801041:	eb 0c                	jmp    80104f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801043:	83 ec 0c             	sub    $0xc,%esp
  801046:	56                   	push   %esi
  801047:	e8 e4 01 00 00       	call   801230 <nsipc_close>
		return r;
  80104c:	83 c4 10             	add    $0x10,%esp
}
  80104f:	89 d8                	mov    %ebx,%eax
  801051:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801054:	5b                   	pop    %ebx
  801055:	5e                   	pop    %esi
  801056:	5d                   	pop    %ebp
  801057:	c3                   	ret    

00801058 <accept>:
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	e8 4e ff ff ff       	call   800fb4 <fd2sockid>
  801066:	85 c0                	test   %eax,%eax
  801068:	78 1b                	js     801085 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80106a:	83 ec 04             	sub    $0x4,%esp
  80106d:	ff 75 10             	pushl  0x10(%ebp)
  801070:	ff 75 0c             	pushl  0xc(%ebp)
  801073:	50                   	push   %eax
  801074:	e8 0e 01 00 00       	call   801187 <nsipc_accept>
  801079:	83 c4 10             	add    $0x10,%esp
  80107c:	85 c0                	test   %eax,%eax
  80107e:	78 05                	js     801085 <accept+0x2d>
	return alloc_sockfd(r);
  801080:	e8 5f ff ff ff       	call   800fe4 <alloc_sockfd>
}
  801085:	c9                   	leave  
  801086:	c3                   	ret    

00801087 <bind>:
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	e8 1f ff ff ff       	call   800fb4 <fd2sockid>
  801095:	85 c0                	test   %eax,%eax
  801097:	78 12                	js     8010ab <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801099:	83 ec 04             	sub    $0x4,%esp
  80109c:	ff 75 10             	pushl  0x10(%ebp)
  80109f:	ff 75 0c             	pushl  0xc(%ebp)
  8010a2:	50                   	push   %eax
  8010a3:	e8 31 01 00 00       	call   8011d9 <nsipc_bind>
  8010a8:	83 c4 10             	add    $0x10,%esp
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <shutdown>:
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	e8 f9 fe ff ff       	call   800fb4 <fd2sockid>
  8010bb:	85 c0                	test   %eax,%eax
  8010bd:	78 0f                	js     8010ce <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8010bf:	83 ec 08             	sub    $0x8,%esp
  8010c2:	ff 75 0c             	pushl  0xc(%ebp)
  8010c5:	50                   	push   %eax
  8010c6:	e8 43 01 00 00       	call   80120e <nsipc_shutdown>
  8010cb:	83 c4 10             	add    $0x10,%esp
}
  8010ce:	c9                   	leave  
  8010cf:	c3                   	ret    

008010d0 <connect>:
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	e8 d6 fe ff ff       	call   800fb4 <fd2sockid>
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	78 12                	js     8010f4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8010e2:	83 ec 04             	sub    $0x4,%esp
  8010e5:	ff 75 10             	pushl  0x10(%ebp)
  8010e8:	ff 75 0c             	pushl  0xc(%ebp)
  8010eb:	50                   	push   %eax
  8010ec:	e8 59 01 00 00       	call   80124a <nsipc_connect>
  8010f1:	83 c4 10             	add    $0x10,%esp
}
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

008010f6 <listen>:
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	e8 b0 fe ff ff       	call   800fb4 <fd2sockid>
  801104:	85 c0                	test   %eax,%eax
  801106:	78 0f                	js     801117 <listen+0x21>
	return nsipc_listen(r, backlog);
  801108:	83 ec 08             	sub    $0x8,%esp
  80110b:	ff 75 0c             	pushl  0xc(%ebp)
  80110e:	50                   	push   %eax
  80110f:	e8 6b 01 00 00       	call   80127f <nsipc_listen>
  801114:	83 c4 10             	add    $0x10,%esp
}
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <socket>:

int
socket(int domain, int type, int protocol)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80111f:	ff 75 10             	pushl  0x10(%ebp)
  801122:	ff 75 0c             	pushl  0xc(%ebp)
  801125:	ff 75 08             	pushl  0x8(%ebp)
  801128:	e8 3e 02 00 00       	call   80136b <nsipc_socket>
  80112d:	83 c4 10             	add    $0x10,%esp
  801130:	85 c0                	test   %eax,%eax
  801132:	78 05                	js     801139 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801134:	e8 ab fe ff ff       	call   800fe4 <alloc_sockfd>
}
  801139:	c9                   	leave  
  80113a:	c3                   	ret    

0080113b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	53                   	push   %ebx
  80113f:	83 ec 04             	sub    $0x4,%esp
  801142:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801144:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80114b:	74 26                	je     801173 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80114d:	6a 07                	push   $0x7
  80114f:	68 00 60 80 00       	push   $0x806000
  801154:	53                   	push   %ebx
  801155:	ff 35 04 40 80 00    	pushl  0x804004
  80115b:	e8 80 0e 00 00       	call   801fe0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801160:	83 c4 0c             	add    $0xc,%esp
  801163:	6a 00                	push   $0x0
  801165:	6a 00                	push   $0x0
  801167:	6a 00                	push   $0x0
  801169:	e8 ff 0d 00 00       	call   801f6d <ipc_recv>
}
  80116e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801171:	c9                   	leave  
  801172:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801173:	83 ec 0c             	sub    $0xc,%esp
  801176:	6a 02                	push   $0x2
  801178:	e8 cf 0e 00 00       	call   80204c <ipc_find_env>
  80117d:	a3 04 40 80 00       	mov    %eax,0x804004
  801182:	83 c4 10             	add    $0x10,%esp
  801185:	eb c6                	jmp    80114d <nsipc+0x12>

00801187 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	56                   	push   %esi
  80118b:	53                   	push   %ebx
  80118c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801197:	8b 06                	mov    (%esi),%eax
  801199:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80119e:	b8 01 00 00 00       	mov    $0x1,%eax
  8011a3:	e8 93 ff ff ff       	call   80113b <nsipc>
  8011a8:	89 c3                	mov    %eax,%ebx
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	79 09                	jns    8011b7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8011ae:	89 d8                	mov    %ebx,%eax
  8011b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011b3:	5b                   	pop    %ebx
  8011b4:	5e                   	pop    %esi
  8011b5:	5d                   	pop    %ebp
  8011b6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8011b7:	83 ec 04             	sub    $0x4,%esp
  8011ba:	ff 35 10 60 80 00    	pushl  0x806010
  8011c0:	68 00 60 80 00       	push   $0x806000
  8011c5:	ff 75 0c             	pushl  0xc(%ebp)
  8011c8:	e8 82 0b 00 00       	call   801d4f <memmove>
		*addrlen = ret->ret_addrlen;
  8011cd:	a1 10 60 80 00       	mov    0x806010,%eax
  8011d2:	89 06                	mov    %eax,(%esi)
  8011d4:	83 c4 10             	add    $0x10,%esp
	return r;
  8011d7:	eb d5                	jmp    8011ae <nsipc_accept+0x27>

008011d9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	53                   	push   %ebx
  8011dd:	83 ec 08             	sub    $0x8,%esp
  8011e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011eb:	53                   	push   %ebx
  8011ec:	ff 75 0c             	pushl  0xc(%ebp)
  8011ef:	68 04 60 80 00       	push   $0x806004
  8011f4:	e8 56 0b 00 00       	call   801d4f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011f9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011ff:	b8 02 00 00 00       	mov    $0x2,%eax
  801204:	e8 32 ff ff ff       	call   80113b <nsipc>
}
  801209:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801224:	b8 03 00 00 00       	mov    $0x3,%eax
  801229:	e8 0d ff ff ff       	call   80113b <nsipc>
}
  80122e:	c9                   	leave  
  80122f:	c3                   	ret    

00801230 <nsipc_close>:

int
nsipc_close(int s)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80123e:	b8 04 00 00 00       	mov    $0x4,%eax
  801243:	e8 f3 fe ff ff       	call   80113b <nsipc>
}
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	53                   	push   %ebx
  80124e:	83 ec 08             	sub    $0x8,%esp
  801251:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80125c:	53                   	push   %ebx
  80125d:	ff 75 0c             	pushl  0xc(%ebp)
  801260:	68 04 60 80 00       	push   $0x806004
  801265:	e8 e5 0a 00 00       	call   801d4f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80126a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801270:	b8 05 00 00 00       	mov    $0x5,%eax
  801275:	e8 c1 fe ff ff       	call   80113b <nsipc>
}
  80127a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80128d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801290:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801295:	b8 06 00 00 00       	mov    $0x6,%eax
  80129a:	e8 9c fe ff ff       	call   80113b <nsipc>
}
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    

008012a1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	56                   	push   %esi
  8012a5:	53                   	push   %ebx
  8012a6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8012b1:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8012b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ba:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8012bf:	b8 07 00 00 00       	mov    $0x7,%eax
  8012c4:	e8 72 fe ff ff       	call   80113b <nsipc>
  8012c9:	89 c3                	mov    %eax,%ebx
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	78 1f                	js     8012ee <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8012cf:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8012d4:	7f 21                	jg     8012f7 <nsipc_recv+0x56>
  8012d6:	39 c6                	cmp    %eax,%esi
  8012d8:	7c 1d                	jl     8012f7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8012da:	83 ec 04             	sub    $0x4,%esp
  8012dd:	50                   	push   %eax
  8012de:	68 00 60 80 00       	push   $0x806000
  8012e3:	ff 75 0c             	pushl  0xc(%ebp)
  8012e6:	e8 64 0a 00 00       	call   801d4f <memmove>
  8012eb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012ee:	89 d8                	mov    %ebx,%eax
  8012f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012f3:	5b                   	pop    %ebx
  8012f4:	5e                   	pop    %esi
  8012f5:	5d                   	pop    %ebp
  8012f6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012f7:	68 52 24 80 00       	push   $0x802452
  8012fc:	68 f4 23 80 00       	push   $0x8023f4
  801301:	6a 62                	push   $0x62
  801303:	68 67 24 80 00       	push   $0x802467
  801308:	e8 fd 01 00 00       	call   80150a <_panic>

0080130d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	53                   	push   %ebx
  801311:	83 ec 04             	sub    $0x4,%esp
  801314:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80131f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801325:	7f 2e                	jg     801355 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801327:	83 ec 04             	sub    $0x4,%esp
  80132a:	53                   	push   %ebx
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	68 0c 60 80 00       	push   $0x80600c
  801333:	e8 17 0a 00 00       	call   801d4f <memmove>
	nsipcbuf.send.req_size = size;
  801338:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80133e:	8b 45 14             	mov    0x14(%ebp),%eax
  801341:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801346:	b8 08 00 00 00       	mov    $0x8,%eax
  80134b:	e8 eb fd ff ff       	call   80113b <nsipc>
}
  801350:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801353:	c9                   	leave  
  801354:	c3                   	ret    
	assert(size < 1600);
  801355:	68 73 24 80 00       	push   $0x802473
  80135a:	68 f4 23 80 00       	push   $0x8023f4
  80135f:	6a 6d                	push   $0x6d
  801361:	68 67 24 80 00       	push   $0x802467
  801366:	e8 9f 01 00 00       	call   80150a <_panic>

0080136b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137c:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801381:	8b 45 10             	mov    0x10(%ebp),%eax
  801384:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801389:	b8 09 00 00 00       	mov    $0x9,%eax
  80138e:	e8 a8 fd ff ff       	call   80113b <nsipc>
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801395:	b8 00 00 00 00       	mov    $0x0,%eax
  80139a:	c3                   	ret    

0080139b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8013a1:	68 7f 24 80 00       	push   $0x80247f
  8013a6:	ff 75 0c             	pushl  0xc(%ebp)
  8013a9:	e8 13 08 00 00       	call   801bc1 <strcpy>
	return 0;
}
  8013ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <devcons_write>:
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	57                   	push   %edi
  8013b9:	56                   	push   %esi
  8013ba:	53                   	push   %ebx
  8013bb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8013c1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8013c6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8013cc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013cf:	73 31                	jae    801402 <devcons_write+0x4d>
		m = n - tot;
  8013d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013d4:	29 f3                	sub    %esi,%ebx
  8013d6:	83 fb 7f             	cmp    $0x7f,%ebx
  8013d9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8013de:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013e1:	83 ec 04             	sub    $0x4,%esp
  8013e4:	53                   	push   %ebx
  8013e5:	89 f0                	mov    %esi,%eax
  8013e7:	03 45 0c             	add    0xc(%ebp),%eax
  8013ea:	50                   	push   %eax
  8013eb:	57                   	push   %edi
  8013ec:	e8 5e 09 00 00       	call   801d4f <memmove>
		sys_cputs(buf, m);
  8013f1:	83 c4 08             	add    $0x8,%esp
  8013f4:	53                   	push   %ebx
  8013f5:	57                   	push   %edi
  8013f6:	e8 b9 ec ff ff       	call   8000b4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013fb:	01 de                	add    %ebx,%esi
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	eb ca                	jmp    8013cc <devcons_write+0x17>
}
  801402:	89 f0                	mov    %esi,%eax
  801404:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801407:	5b                   	pop    %ebx
  801408:	5e                   	pop    %esi
  801409:	5f                   	pop    %edi
  80140a:	5d                   	pop    %ebp
  80140b:	c3                   	ret    

0080140c <devcons_read>:
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 08             	sub    $0x8,%esp
  801412:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801417:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80141b:	74 21                	je     80143e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80141d:	e8 b0 ec ff ff       	call   8000d2 <sys_cgetc>
  801422:	85 c0                	test   %eax,%eax
  801424:	75 07                	jne    80142d <devcons_read+0x21>
		sys_yield();
  801426:	e8 26 ed ff ff       	call   800151 <sys_yield>
  80142b:	eb f0                	jmp    80141d <devcons_read+0x11>
	if (c < 0)
  80142d:	78 0f                	js     80143e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80142f:	83 f8 04             	cmp    $0x4,%eax
  801432:	74 0c                	je     801440 <devcons_read+0x34>
	*(char*)vbuf = c;
  801434:	8b 55 0c             	mov    0xc(%ebp),%edx
  801437:	88 02                	mov    %al,(%edx)
	return 1;
  801439:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    
		return 0;
  801440:	b8 00 00 00 00       	mov    $0x0,%eax
  801445:	eb f7                	jmp    80143e <devcons_read+0x32>

00801447 <cputchar>:
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801453:	6a 01                	push   $0x1
  801455:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801458:	50                   	push   %eax
  801459:	e8 56 ec ff ff       	call   8000b4 <sys_cputs>
}
  80145e:	83 c4 10             	add    $0x10,%esp
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <getchar>:
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801469:	6a 01                	push   $0x1
  80146b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80146e:	50                   	push   %eax
  80146f:	6a 00                	push   $0x0
  801471:	e8 1a f2 ff ff       	call   800690 <read>
	if (r < 0)
  801476:	83 c4 10             	add    $0x10,%esp
  801479:	85 c0                	test   %eax,%eax
  80147b:	78 06                	js     801483 <getchar+0x20>
	if (r < 1)
  80147d:	74 06                	je     801485 <getchar+0x22>
	return c;
  80147f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801483:	c9                   	leave  
  801484:	c3                   	ret    
		return -E_EOF;
  801485:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80148a:	eb f7                	jmp    801483 <getchar+0x20>

0080148c <iscons>:
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801492:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801495:	50                   	push   %eax
  801496:	ff 75 08             	pushl  0x8(%ebp)
  801499:	e8 82 ef ff ff       	call   800420 <fd_lookup>
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	78 11                	js     8014b6 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8014a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a8:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014ae:	39 10                	cmp    %edx,(%eax)
  8014b0:	0f 94 c0             	sete   %al
  8014b3:	0f b6 c0             	movzbl %al,%eax
}
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <opencons>:
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
  8014bb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8014be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c1:	50                   	push   %eax
  8014c2:	e8 07 ef ff ff       	call   8003ce <fd_alloc>
  8014c7:	83 c4 10             	add    $0x10,%esp
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	78 3a                	js     801508 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	68 07 04 00 00       	push   $0x407
  8014d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d9:	6a 00                	push   $0x0
  8014db:	e8 90 ec ff ff       	call   800170 <sys_page_alloc>
  8014e0:	83 c4 10             	add    $0x10,%esp
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	78 21                	js     801508 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ea:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014f0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014fc:	83 ec 0c             	sub    $0xc,%esp
  8014ff:	50                   	push   %eax
  801500:	e8 a2 ee ff ff       	call   8003a7 <fd2num>
  801505:	83 c4 10             	add    $0x10,%esp
}
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	56                   	push   %esi
  80150e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80150f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801512:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801518:	e8 15 ec ff ff       	call   800132 <sys_getenvid>
  80151d:	83 ec 0c             	sub    $0xc,%esp
  801520:	ff 75 0c             	pushl  0xc(%ebp)
  801523:	ff 75 08             	pushl  0x8(%ebp)
  801526:	56                   	push   %esi
  801527:	50                   	push   %eax
  801528:	68 8c 24 80 00       	push   $0x80248c
  80152d:	e8 b3 00 00 00       	call   8015e5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801532:	83 c4 18             	add    $0x18,%esp
  801535:	53                   	push   %ebx
  801536:	ff 75 10             	pushl  0x10(%ebp)
  801539:	e8 56 00 00 00       	call   801594 <vcprintf>
	cprintf("\n");
  80153e:	c7 04 24 3f 24 80 00 	movl   $0x80243f,(%esp)
  801545:	e8 9b 00 00 00       	call   8015e5 <cprintf>
  80154a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80154d:	cc                   	int3   
  80154e:	eb fd                	jmp    80154d <_panic+0x43>

00801550 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	53                   	push   %ebx
  801554:	83 ec 04             	sub    $0x4,%esp
  801557:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80155a:	8b 13                	mov    (%ebx),%edx
  80155c:	8d 42 01             	lea    0x1(%edx),%eax
  80155f:	89 03                	mov    %eax,(%ebx)
  801561:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801564:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801568:	3d ff 00 00 00       	cmp    $0xff,%eax
  80156d:	74 09                	je     801578 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80156f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801573:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801576:	c9                   	leave  
  801577:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801578:	83 ec 08             	sub    $0x8,%esp
  80157b:	68 ff 00 00 00       	push   $0xff
  801580:	8d 43 08             	lea    0x8(%ebx),%eax
  801583:	50                   	push   %eax
  801584:	e8 2b eb ff ff       	call   8000b4 <sys_cputs>
		b->idx = 0;
  801589:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	eb db                	jmp    80156f <putch+0x1f>

00801594 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80159d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8015a4:	00 00 00 
	b.cnt = 0;
  8015a7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8015ae:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8015b1:	ff 75 0c             	pushl  0xc(%ebp)
  8015b4:	ff 75 08             	pushl  0x8(%ebp)
  8015b7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8015bd:	50                   	push   %eax
  8015be:	68 50 15 80 00       	push   $0x801550
  8015c3:	e8 19 01 00 00       	call   8016e1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8015c8:	83 c4 08             	add    $0x8,%esp
  8015cb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8015d1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8015d7:	50                   	push   %eax
  8015d8:	e8 d7 ea ff ff       	call   8000b4 <sys_cputs>

	return b.cnt;
}
  8015dd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015eb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015ee:	50                   	push   %eax
  8015ef:	ff 75 08             	pushl  0x8(%ebp)
  8015f2:	e8 9d ff ff ff       	call   801594 <vcprintf>
	va_end(ap);

	return cnt;
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	57                   	push   %edi
  8015fd:	56                   	push   %esi
  8015fe:	53                   	push   %ebx
  8015ff:	83 ec 1c             	sub    $0x1c,%esp
  801602:	89 c7                	mov    %eax,%edi
  801604:	89 d6                	mov    %edx,%esi
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80160f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801612:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801615:	bb 00 00 00 00       	mov    $0x0,%ebx
  80161a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80161d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801620:	3b 45 10             	cmp    0x10(%ebp),%eax
  801623:	89 d0                	mov    %edx,%eax
  801625:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  801628:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80162b:	73 15                	jae    801642 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80162d:	83 eb 01             	sub    $0x1,%ebx
  801630:	85 db                	test   %ebx,%ebx
  801632:	7e 43                	jle    801677 <printnum+0x7e>
			putch(padc, putdat);
  801634:	83 ec 08             	sub    $0x8,%esp
  801637:	56                   	push   %esi
  801638:	ff 75 18             	pushl  0x18(%ebp)
  80163b:	ff d7                	call   *%edi
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	eb eb                	jmp    80162d <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801642:	83 ec 0c             	sub    $0xc,%esp
  801645:	ff 75 18             	pushl  0x18(%ebp)
  801648:	8b 45 14             	mov    0x14(%ebp),%eax
  80164b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80164e:	53                   	push   %ebx
  80164f:	ff 75 10             	pushl  0x10(%ebp)
  801652:	83 ec 08             	sub    $0x8,%esp
  801655:	ff 75 e4             	pushl  -0x1c(%ebp)
  801658:	ff 75 e0             	pushl  -0x20(%ebp)
  80165b:	ff 75 dc             	pushl  -0x24(%ebp)
  80165e:	ff 75 d8             	pushl  -0x28(%ebp)
  801661:	e8 5a 0a 00 00       	call   8020c0 <__udivdi3>
  801666:	83 c4 18             	add    $0x18,%esp
  801669:	52                   	push   %edx
  80166a:	50                   	push   %eax
  80166b:	89 f2                	mov    %esi,%edx
  80166d:	89 f8                	mov    %edi,%eax
  80166f:	e8 85 ff ff ff       	call   8015f9 <printnum>
  801674:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801677:	83 ec 08             	sub    $0x8,%esp
  80167a:	56                   	push   %esi
  80167b:	83 ec 04             	sub    $0x4,%esp
  80167e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801681:	ff 75 e0             	pushl  -0x20(%ebp)
  801684:	ff 75 dc             	pushl  -0x24(%ebp)
  801687:	ff 75 d8             	pushl  -0x28(%ebp)
  80168a:	e8 41 0b 00 00       	call   8021d0 <__umoddi3>
  80168f:	83 c4 14             	add    $0x14,%esp
  801692:	0f be 80 af 24 80 00 	movsbl 0x8024af(%eax),%eax
  801699:	50                   	push   %eax
  80169a:	ff d7                	call   *%edi
}
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016a2:	5b                   	pop    %ebx
  8016a3:	5e                   	pop    %esi
  8016a4:	5f                   	pop    %edi
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8016ad:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8016b1:	8b 10                	mov    (%eax),%edx
  8016b3:	3b 50 04             	cmp    0x4(%eax),%edx
  8016b6:	73 0a                	jae    8016c2 <sprintputch+0x1b>
		*b->buf++ = ch;
  8016b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016bb:	89 08                	mov    %ecx,(%eax)
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	88 02                	mov    %al,(%edx)
}
  8016c2:	5d                   	pop    %ebp
  8016c3:	c3                   	ret    

008016c4 <printfmt>:
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8016ca:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8016cd:	50                   	push   %eax
  8016ce:	ff 75 10             	pushl  0x10(%ebp)
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	ff 75 08             	pushl  0x8(%ebp)
  8016d7:	e8 05 00 00 00       	call   8016e1 <vprintfmt>
}
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <vprintfmt>:
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	57                   	push   %edi
  8016e5:	56                   	push   %esi
  8016e6:	53                   	push   %ebx
  8016e7:	83 ec 3c             	sub    $0x3c,%esp
  8016ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8016ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016f0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016f3:	eb 0a                	jmp    8016ff <vprintfmt+0x1e>
			putch(ch, putdat);
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	53                   	push   %ebx
  8016f9:	50                   	push   %eax
  8016fa:	ff d6                	call   *%esi
  8016fc:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016ff:	83 c7 01             	add    $0x1,%edi
  801702:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801706:	83 f8 25             	cmp    $0x25,%eax
  801709:	74 0c                	je     801717 <vprintfmt+0x36>
			if (ch == '\0')
  80170b:	85 c0                	test   %eax,%eax
  80170d:	75 e6                	jne    8016f5 <vprintfmt+0x14>
}
  80170f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801712:	5b                   	pop    %ebx
  801713:	5e                   	pop    %esi
  801714:	5f                   	pop    %edi
  801715:	5d                   	pop    %ebp
  801716:	c3                   	ret    
		padc = ' ';
  801717:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80171b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801722:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801729:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801730:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801735:	8d 47 01             	lea    0x1(%edi),%eax
  801738:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80173b:	0f b6 17             	movzbl (%edi),%edx
  80173e:	8d 42 dd             	lea    -0x23(%edx),%eax
  801741:	3c 55                	cmp    $0x55,%al
  801743:	0f 87 ba 03 00 00    	ja     801b03 <vprintfmt+0x422>
  801749:	0f b6 c0             	movzbl %al,%eax
  80174c:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  801753:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801756:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80175a:	eb d9                	jmp    801735 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80175c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80175f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801763:	eb d0                	jmp    801735 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801765:	0f b6 d2             	movzbl %dl,%edx
  801768:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80176b:	b8 00 00 00 00       	mov    $0x0,%eax
  801770:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801773:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801776:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80177a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80177d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801780:	83 f9 09             	cmp    $0x9,%ecx
  801783:	77 55                	ja     8017da <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  801785:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801788:	eb e9                	jmp    801773 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80178a:	8b 45 14             	mov    0x14(%ebp),%eax
  80178d:	8b 00                	mov    (%eax),%eax
  80178f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801792:	8b 45 14             	mov    0x14(%ebp),%eax
  801795:	8d 40 04             	lea    0x4(%eax),%eax
  801798:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80179b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80179e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017a2:	79 91                	jns    801735 <vprintfmt+0x54>
				width = precision, precision = -1;
  8017a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017aa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8017b1:	eb 82                	jmp    801735 <vprintfmt+0x54>
  8017b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bd:	0f 49 d0             	cmovns %eax,%edx
  8017c0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8017c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8017c6:	e9 6a ff ff ff       	jmp    801735 <vprintfmt+0x54>
  8017cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8017ce:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8017d5:	e9 5b ff ff ff       	jmp    801735 <vprintfmt+0x54>
  8017da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8017dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8017e0:	eb bc                	jmp    80179e <vprintfmt+0xbd>
			lflag++;
  8017e2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017e8:	e9 48 ff ff ff       	jmp    801735 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8017ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f0:	8d 78 04             	lea    0x4(%eax),%edi
  8017f3:	83 ec 08             	sub    $0x8,%esp
  8017f6:	53                   	push   %ebx
  8017f7:	ff 30                	pushl  (%eax)
  8017f9:	ff d6                	call   *%esi
			break;
  8017fb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017fe:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801801:	e9 9c 02 00 00       	jmp    801aa2 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  801806:	8b 45 14             	mov    0x14(%ebp),%eax
  801809:	8d 78 04             	lea    0x4(%eax),%edi
  80180c:	8b 00                	mov    (%eax),%eax
  80180e:	99                   	cltd   
  80180f:	31 d0                	xor    %edx,%eax
  801811:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801813:	83 f8 0f             	cmp    $0xf,%eax
  801816:	7f 23                	jg     80183b <vprintfmt+0x15a>
  801818:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  80181f:	85 d2                	test   %edx,%edx
  801821:	74 18                	je     80183b <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  801823:	52                   	push   %edx
  801824:	68 06 24 80 00       	push   $0x802406
  801829:	53                   	push   %ebx
  80182a:	56                   	push   %esi
  80182b:	e8 94 fe ff ff       	call   8016c4 <printfmt>
  801830:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801833:	89 7d 14             	mov    %edi,0x14(%ebp)
  801836:	e9 67 02 00 00       	jmp    801aa2 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  80183b:	50                   	push   %eax
  80183c:	68 c7 24 80 00       	push   $0x8024c7
  801841:	53                   	push   %ebx
  801842:	56                   	push   %esi
  801843:	e8 7c fe ff ff       	call   8016c4 <printfmt>
  801848:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80184b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80184e:	e9 4f 02 00 00       	jmp    801aa2 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  801853:	8b 45 14             	mov    0x14(%ebp),%eax
  801856:	83 c0 04             	add    $0x4,%eax
  801859:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80185c:	8b 45 14             	mov    0x14(%ebp),%eax
  80185f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801861:	85 d2                	test   %edx,%edx
  801863:	b8 c0 24 80 00       	mov    $0x8024c0,%eax
  801868:	0f 45 c2             	cmovne %edx,%eax
  80186b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80186e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801872:	7e 06                	jle    80187a <vprintfmt+0x199>
  801874:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801878:	75 0d                	jne    801887 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80187a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80187d:	89 c7                	mov    %eax,%edi
  80187f:	03 45 e0             	add    -0x20(%ebp),%eax
  801882:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801885:	eb 3f                	jmp    8018c6 <vprintfmt+0x1e5>
  801887:	83 ec 08             	sub    $0x8,%esp
  80188a:	ff 75 d8             	pushl  -0x28(%ebp)
  80188d:	50                   	push   %eax
  80188e:	e8 0d 03 00 00       	call   801ba0 <strnlen>
  801893:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801896:	29 c2                	sub    %eax,%edx
  801898:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8018a0:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8018a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8018a7:	85 ff                	test   %edi,%edi
  8018a9:	7e 58                	jle    801903 <vprintfmt+0x222>
					putch(padc, putdat);
  8018ab:	83 ec 08             	sub    $0x8,%esp
  8018ae:	53                   	push   %ebx
  8018af:	ff 75 e0             	pushl  -0x20(%ebp)
  8018b2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8018b4:	83 ef 01             	sub    $0x1,%edi
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	eb eb                	jmp    8018a7 <vprintfmt+0x1c6>
					putch(ch, putdat);
  8018bc:	83 ec 08             	sub    $0x8,%esp
  8018bf:	53                   	push   %ebx
  8018c0:	52                   	push   %edx
  8018c1:	ff d6                	call   *%esi
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8018c9:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018cb:	83 c7 01             	add    $0x1,%edi
  8018ce:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8018d2:	0f be d0             	movsbl %al,%edx
  8018d5:	85 d2                	test   %edx,%edx
  8018d7:	74 45                	je     80191e <vprintfmt+0x23d>
  8018d9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018dd:	78 06                	js     8018e5 <vprintfmt+0x204>
  8018df:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8018e3:	78 35                	js     80191a <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8018e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8018e9:	74 d1                	je     8018bc <vprintfmt+0x1db>
  8018eb:	0f be c0             	movsbl %al,%eax
  8018ee:	83 e8 20             	sub    $0x20,%eax
  8018f1:	83 f8 5e             	cmp    $0x5e,%eax
  8018f4:	76 c6                	jbe    8018bc <vprintfmt+0x1db>
					putch('?', putdat);
  8018f6:	83 ec 08             	sub    $0x8,%esp
  8018f9:	53                   	push   %ebx
  8018fa:	6a 3f                	push   $0x3f
  8018fc:	ff d6                	call   *%esi
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	eb c3                	jmp    8018c6 <vprintfmt+0x1e5>
  801903:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801906:	85 d2                	test   %edx,%edx
  801908:	b8 00 00 00 00       	mov    $0x0,%eax
  80190d:	0f 49 c2             	cmovns %edx,%eax
  801910:	29 c2                	sub    %eax,%edx
  801912:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801915:	e9 60 ff ff ff       	jmp    80187a <vprintfmt+0x199>
  80191a:	89 cf                	mov    %ecx,%edi
  80191c:	eb 02                	jmp    801920 <vprintfmt+0x23f>
  80191e:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  801920:	85 ff                	test   %edi,%edi
  801922:	7e 10                	jle    801934 <vprintfmt+0x253>
				putch(' ', putdat);
  801924:	83 ec 08             	sub    $0x8,%esp
  801927:	53                   	push   %ebx
  801928:	6a 20                	push   $0x20
  80192a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80192c:	83 ef 01             	sub    $0x1,%edi
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	eb ec                	jmp    801920 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  801934:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801937:	89 45 14             	mov    %eax,0x14(%ebp)
  80193a:	e9 63 01 00 00       	jmp    801aa2 <vprintfmt+0x3c1>
	if (lflag >= 2)
  80193f:	83 f9 01             	cmp    $0x1,%ecx
  801942:	7f 1b                	jg     80195f <vprintfmt+0x27e>
	else if (lflag)
  801944:	85 c9                	test   %ecx,%ecx
  801946:	74 63                	je     8019ab <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  801948:	8b 45 14             	mov    0x14(%ebp),%eax
  80194b:	8b 00                	mov    (%eax),%eax
  80194d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801950:	99                   	cltd   
  801951:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801954:	8b 45 14             	mov    0x14(%ebp),%eax
  801957:	8d 40 04             	lea    0x4(%eax),%eax
  80195a:	89 45 14             	mov    %eax,0x14(%ebp)
  80195d:	eb 17                	jmp    801976 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  80195f:	8b 45 14             	mov    0x14(%ebp),%eax
  801962:	8b 50 04             	mov    0x4(%eax),%edx
  801965:	8b 00                	mov    (%eax),%eax
  801967:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80196a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80196d:	8b 45 14             	mov    0x14(%ebp),%eax
  801970:	8d 40 08             	lea    0x8(%eax),%eax
  801973:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801976:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801979:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80197c:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801981:	85 c9                	test   %ecx,%ecx
  801983:	0f 89 ff 00 00 00    	jns    801a88 <vprintfmt+0x3a7>
				putch('-', putdat);
  801989:	83 ec 08             	sub    $0x8,%esp
  80198c:	53                   	push   %ebx
  80198d:	6a 2d                	push   $0x2d
  80198f:	ff d6                	call   *%esi
				num = -(long long) num;
  801991:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801994:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801997:	f7 da                	neg    %edx
  801999:	83 d1 00             	adc    $0x0,%ecx
  80199c:	f7 d9                	neg    %ecx
  80199e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8019a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019a6:	e9 dd 00 00 00       	jmp    801a88 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  8019ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ae:	8b 00                	mov    (%eax),%eax
  8019b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019b3:	99                   	cltd   
  8019b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	8d 40 04             	lea    0x4(%eax),%eax
  8019bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8019c0:	eb b4                	jmp    801976 <vprintfmt+0x295>
	if (lflag >= 2)
  8019c2:	83 f9 01             	cmp    $0x1,%ecx
  8019c5:	7f 1e                	jg     8019e5 <vprintfmt+0x304>
	else if (lflag)
  8019c7:	85 c9                	test   %ecx,%ecx
  8019c9:	74 32                	je     8019fd <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  8019cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ce:	8b 10                	mov    (%eax),%edx
  8019d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d5:	8d 40 04             	lea    0x4(%eax),%eax
  8019d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019e0:	e9 a3 00 00 00       	jmp    801a88 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8019e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e8:	8b 10                	mov    (%eax),%edx
  8019ea:	8b 48 04             	mov    0x4(%eax),%ecx
  8019ed:	8d 40 08             	lea    0x8(%eax),%eax
  8019f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019f8:	e9 8b 00 00 00       	jmp    801a88 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8019fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801a00:	8b 10                	mov    (%eax),%edx
  801a02:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a07:	8d 40 04             	lea    0x4(%eax),%eax
  801a0a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a0d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a12:	eb 74                	jmp    801a88 <vprintfmt+0x3a7>
	if (lflag >= 2)
  801a14:	83 f9 01             	cmp    $0x1,%ecx
  801a17:	7f 1b                	jg     801a34 <vprintfmt+0x353>
	else if (lflag)
  801a19:	85 c9                	test   %ecx,%ecx
  801a1b:	74 2c                	je     801a49 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  801a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a20:	8b 10                	mov    (%eax),%edx
  801a22:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a27:	8d 40 04             	lea    0x4(%eax),%eax
  801a2a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a2d:	b8 08 00 00 00       	mov    $0x8,%eax
  801a32:	eb 54                	jmp    801a88 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801a34:	8b 45 14             	mov    0x14(%ebp),%eax
  801a37:	8b 10                	mov    (%eax),%edx
  801a39:	8b 48 04             	mov    0x4(%eax),%ecx
  801a3c:	8d 40 08             	lea    0x8(%eax),%eax
  801a3f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a42:	b8 08 00 00 00       	mov    $0x8,%eax
  801a47:	eb 3f                	jmp    801a88 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801a49:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4c:	8b 10                	mov    (%eax),%edx
  801a4e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a53:	8d 40 04             	lea    0x4(%eax),%eax
  801a56:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a59:	b8 08 00 00 00       	mov    $0x8,%eax
  801a5e:	eb 28                	jmp    801a88 <vprintfmt+0x3a7>
			putch('0', putdat);
  801a60:	83 ec 08             	sub    $0x8,%esp
  801a63:	53                   	push   %ebx
  801a64:	6a 30                	push   $0x30
  801a66:	ff d6                	call   *%esi
			putch('x', putdat);
  801a68:	83 c4 08             	add    $0x8,%esp
  801a6b:	53                   	push   %ebx
  801a6c:	6a 78                	push   $0x78
  801a6e:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a70:	8b 45 14             	mov    0x14(%ebp),%eax
  801a73:	8b 10                	mov    (%eax),%edx
  801a75:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a7a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a7d:	8d 40 04             	lea    0x4(%eax),%eax
  801a80:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a83:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a88:	83 ec 0c             	sub    $0xc,%esp
  801a8b:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801a8f:	57                   	push   %edi
  801a90:	ff 75 e0             	pushl  -0x20(%ebp)
  801a93:	50                   	push   %eax
  801a94:	51                   	push   %ecx
  801a95:	52                   	push   %edx
  801a96:	89 da                	mov    %ebx,%edx
  801a98:	89 f0                	mov    %esi,%eax
  801a9a:	e8 5a fb ff ff       	call   8015f9 <printnum>
			break;
  801a9f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801aa2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801aa5:	e9 55 fc ff ff       	jmp    8016ff <vprintfmt+0x1e>
	if (lflag >= 2)
  801aaa:	83 f9 01             	cmp    $0x1,%ecx
  801aad:	7f 1b                	jg     801aca <vprintfmt+0x3e9>
	else if (lflag)
  801aaf:	85 c9                	test   %ecx,%ecx
  801ab1:	74 2c                	je     801adf <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  801ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab6:	8b 10                	mov    (%eax),%edx
  801ab8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801abd:	8d 40 04             	lea    0x4(%eax),%eax
  801ac0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ac3:	b8 10 00 00 00       	mov    $0x10,%eax
  801ac8:	eb be                	jmp    801a88 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801aca:	8b 45 14             	mov    0x14(%ebp),%eax
  801acd:	8b 10                	mov    (%eax),%edx
  801acf:	8b 48 04             	mov    0x4(%eax),%ecx
  801ad2:	8d 40 08             	lea    0x8(%eax),%eax
  801ad5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ad8:	b8 10 00 00 00       	mov    $0x10,%eax
  801add:	eb a9                	jmp    801a88 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801adf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae2:	8b 10                	mov    (%eax),%edx
  801ae4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae9:	8d 40 04             	lea    0x4(%eax),%eax
  801aec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aef:	b8 10 00 00 00       	mov    $0x10,%eax
  801af4:	eb 92                	jmp    801a88 <vprintfmt+0x3a7>
			putch(ch, putdat);
  801af6:	83 ec 08             	sub    $0x8,%esp
  801af9:	53                   	push   %ebx
  801afa:	6a 25                	push   $0x25
  801afc:	ff d6                	call   *%esi
			break;
  801afe:	83 c4 10             	add    $0x10,%esp
  801b01:	eb 9f                	jmp    801aa2 <vprintfmt+0x3c1>
			putch('%', putdat);
  801b03:	83 ec 08             	sub    $0x8,%esp
  801b06:	53                   	push   %ebx
  801b07:	6a 25                	push   $0x25
  801b09:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b0b:	83 c4 10             	add    $0x10,%esp
  801b0e:	89 f8                	mov    %edi,%eax
  801b10:	eb 03                	jmp    801b15 <vprintfmt+0x434>
  801b12:	83 e8 01             	sub    $0x1,%eax
  801b15:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b19:	75 f7                	jne    801b12 <vprintfmt+0x431>
  801b1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b1e:	eb 82                	jmp    801aa2 <vprintfmt+0x3c1>

00801b20 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 18             	sub    $0x18,%esp
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b2f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b33:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	74 26                	je     801b67 <vsnprintf+0x47>
  801b41:	85 d2                	test   %edx,%edx
  801b43:	7e 22                	jle    801b67 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b45:	ff 75 14             	pushl  0x14(%ebp)
  801b48:	ff 75 10             	pushl  0x10(%ebp)
  801b4b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b4e:	50                   	push   %eax
  801b4f:	68 a7 16 80 00       	push   $0x8016a7
  801b54:	e8 88 fb ff ff       	call   8016e1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b5c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b62:	83 c4 10             	add    $0x10,%esp
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    
		return -E_INVAL;
  801b67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b6c:	eb f7                	jmp    801b65 <vsnprintf+0x45>

00801b6e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b74:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b77:	50                   	push   %eax
  801b78:	ff 75 10             	pushl  0x10(%ebp)
  801b7b:	ff 75 0c             	pushl  0xc(%ebp)
  801b7e:	ff 75 08             	pushl  0x8(%ebp)
  801b81:	e8 9a ff ff ff       	call   801b20 <vsnprintf>
	va_end(ap);

	return rc;
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b97:	74 05                	je     801b9e <strlen+0x16>
		n++;
  801b99:	83 c0 01             	add    $0x1,%eax
  801b9c:	eb f5                	jmp    801b93 <strlen+0xb>
	return n;
}
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    

00801ba0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ba9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bae:	39 c2                	cmp    %eax,%edx
  801bb0:	74 0d                	je     801bbf <strnlen+0x1f>
  801bb2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801bb6:	74 05                	je     801bbd <strnlen+0x1d>
		n++;
  801bb8:	83 c2 01             	add    $0x1,%edx
  801bbb:	eb f1                	jmp    801bae <strnlen+0xe>
  801bbd:	89 d0                	mov    %edx,%eax
	return n;
}
  801bbf:	5d                   	pop    %ebp
  801bc0:	c3                   	ret    

00801bc1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	53                   	push   %ebx
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801bd4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801bd7:	83 c2 01             	add    $0x1,%edx
  801bda:	84 c9                	test   %cl,%cl
  801bdc:	75 f2                	jne    801bd0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801bde:	5b                   	pop    %ebx
  801bdf:	5d                   	pop    %ebp
  801be0:	c3                   	ret    

00801be1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	53                   	push   %ebx
  801be5:	83 ec 10             	sub    $0x10,%esp
  801be8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801beb:	53                   	push   %ebx
  801bec:	e8 97 ff ff ff       	call   801b88 <strlen>
  801bf1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801bf4:	ff 75 0c             	pushl  0xc(%ebp)
  801bf7:	01 d8                	add    %ebx,%eax
  801bf9:	50                   	push   %eax
  801bfa:	e8 c2 ff ff ff       	call   801bc1 <strcpy>
	return dst;
}
  801bff:	89 d8                	mov    %ebx,%eax
  801c01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	56                   	push   %esi
  801c0a:	53                   	push   %ebx
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c11:	89 c6                	mov    %eax,%esi
  801c13:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c16:	89 c2                	mov    %eax,%edx
  801c18:	39 f2                	cmp    %esi,%edx
  801c1a:	74 11                	je     801c2d <strncpy+0x27>
		*dst++ = *src;
  801c1c:	83 c2 01             	add    $0x1,%edx
  801c1f:	0f b6 19             	movzbl (%ecx),%ebx
  801c22:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801c25:	80 fb 01             	cmp    $0x1,%bl
  801c28:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801c2b:	eb eb                	jmp    801c18 <strncpy+0x12>
	}
	return ret;
}
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    

00801c31 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	56                   	push   %esi
  801c35:	53                   	push   %ebx
  801c36:	8b 75 08             	mov    0x8(%ebp),%esi
  801c39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c3c:	8b 55 10             	mov    0x10(%ebp),%edx
  801c3f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c41:	85 d2                	test   %edx,%edx
  801c43:	74 21                	je     801c66 <strlcpy+0x35>
  801c45:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801c49:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801c4b:	39 c2                	cmp    %eax,%edx
  801c4d:	74 14                	je     801c63 <strlcpy+0x32>
  801c4f:	0f b6 19             	movzbl (%ecx),%ebx
  801c52:	84 db                	test   %bl,%bl
  801c54:	74 0b                	je     801c61 <strlcpy+0x30>
			*dst++ = *src++;
  801c56:	83 c1 01             	add    $0x1,%ecx
  801c59:	83 c2 01             	add    $0x1,%edx
  801c5c:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c5f:	eb ea                	jmp    801c4b <strlcpy+0x1a>
  801c61:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801c63:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c66:	29 f0                	sub    %esi,%eax
}
  801c68:	5b                   	pop    %ebx
  801c69:	5e                   	pop    %esi
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    

00801c6c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c72:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c75:	0f b6 01             	movzbl (%ecx),%eax
  801c78:	84 c0                	test   %al,%al
  801c7a:	74 0c                	je     801c88 <strcmp+0x1c>
  801c7c:	3a 02                	cmp    (%edx),%al
  801c7e:	75 08                	jne    801c88 <strcmp+0x1c>
		p++, q++;
  801c80:	83 c1 01             	add    $0x1,%ecx
  801c83:	83 c2 01             	add    $0x1,%edx
  801c86:	eb ed                	jmp    801c75 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c88:	0f b6 c0             	movzbl %al,%eax
  801c8b:	0f b6 12             	movzbl (%edx),%edx
  801c8e:	29 d0                	sub    %edx,%eax
}
  801c90:	5d                   	pop    %ebp
  801c91:	c3                   	ret    

00801c92 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	53                   	push   %ebx
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9c:	89 c3                	mov    %eax,%ebx
  801c9e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801ca1:	eb 06                	jmp    801ca9 <strncmp+0x17>
		n--, p++, q++;
  801ca3:	83 c0 01             	add    $0x1,%eax
  801ca6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801ca9:	39 d8                	cmp    %ebx,%eax
  801cab:	74 16                	je     801cc3 <strncmp+0x31>
  801cad:	0f b6 08             	movzbl (%eax),%ecx
  801cb0:	84 c9                	test   %cl,%cl
  801cb2:	74 04                	je     801cb8 <strncmp+0x26>
  801cb4:	3a 0a                	cmp    (%edx),%cl
  801cb6:	74 eb                	je     801ca3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801cb8:	0f b6 00             	movzbl (%eax),%eax
  801cbb:	0f b6 12             	movzbl (%edx),%edx
  801cbe:	29 d0                	sub    %edx,%eax
}
  801cc0:	5b                   	pop    %ebx
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    
		return 0;
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	eb f6                	jmp    801cc0 <strncmp+0x2e>

00801cca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cd4:	0f b6 10             	movzbl (%eax),%edx
  801cd7:	84 d2                	test   %dl,%dl
  801cd9:	74 09                	je     801ce4 <strchr+0x1a>
		if (*s == c)
  801cdb:	38 ca                	cmp    %cl,%dl
  801cdd:	74 0a                	je     801ce9 <strchr+0x1f>
	for (; *s; s++)
  801cdf:	83 c0 01             	add    $0x1,%eax
  801ce2:	eb f0                	jmp    801cd4 <strchr+0xa>
			return (char *) s;
	return 0;
  801ce4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce9:	5d                   	pop    %ebp
  801cea:	c3                   	ret    

00801ceb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cf5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cf8:	38 ca                	cmp    %cl,%dl
  801cfa:	74 09                	je     801d05 <strfind+0x1a>
  801cfc:	84 d2                	test   %dl,%dl
  801cfe:	74 05                	je     801d05 <strfind+0x1a>
	for (; *s; s++)
  801d00:	83 c0 01             	add    $0x1,%eax
  801d03:	eb f0                	jmp    801cf5 <strfind+0xa>
			break;
	return (char *) s;
}
  801d05:	5d                   	pop    %ebp
  801d06:	c3                   	ret    

00801d07 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	57                   	push   %edi
  801d0b:	56                   	push   %esi
  801d0c:	53                   	push   %ebx
  801d0d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801d13:	85 c9                	test   %ecx,%ecx
  801d15:	74 31                	je     801d48 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801d17:	89 f8                	mov    %edi,%eax
  801d19:	09 c8                	or     %ecx,%eax
  801d1b:	a8 03                	test   $0x3,%al
  801d1d:	75 23                	jne    801d42 <memset+0x3b>
		c &= 0xFF;
  801d1f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801d23:	89 d3                	mov    %edx,%ebx
  801d25:	c1 e3 08             	shl    $0x8,%ebx
  801d28:	89 d0                	mov    %edx,%eax
  801d2a:	c1 e0 18             	shl    $0x18,%eax
  801d2d:	89 d6                	mov    %edx,%esi
  801d2f:	c1 e6 10             	shl    $0x10,%esi
  801d32:	09 f0                	or     %esi,%eax
  801d34:	09 c2                	or     %eax,%edx
  801d36:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801d38:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d3b:	89 d0                	mov    %edx,%eax
  801d3d:	fc                   	cld    
  801d3e:	f3 ab                	rep stos %eax,%es:(%edi)
  801d40:	eb 06                	jmp    801d48 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d45:	fc                   	cld    
  801d46:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801d48:	89 f8                	mov    %edi,%eax
  801d4a:	5b                   	pop    %ebx
  801d4b:	5e                   	pop    %esi
  801d4c:	5f                   	pop    %edi
  801d4d:	5d                   	pop    %ebp
  801d4e:	c3                   	ret    

00801d4f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	57                   	push   %edi
  801d53:	56                   	push   %esi
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d5d:	39 c6                	cmp    %eax,%esi
  801d5f:	73 32                	jae    801d93 <memmove+0x44>
  801d61:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d64:	39 c2                	cmp    %eax,%edx
  801d66:	76 2b                	jbe    801d93 <memmove+0x44>
		s += n;
		d += n;
  801d68:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d6b:	89 fe                	mov    %edi,%esi
  801d6d:	09 ce                	or     %ecx,%esi
  801d6f:	09 d6                	or     %edx,%esi
  801d71:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d77:	75 0e                	jne    801d87 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d79:	83 ef 04             	sub    $0x4,%edi
  801d7c:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d7f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d82:	fd                   	std    
  801d83:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d85:	eb 09                	jmp    801d90 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d87:	83 ef 01             	sub    $0x1,%edi
  801d8a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d8d:	fd                   	std    
  801d8e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d90:	fc                   	cld    
  801d91:	eb 1a                	jmp    801dad <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d93:	89 c2                	mov    %eax,%edx
  801d95:	09 ca                	or     %ecx,%edx
  801d97:	09 f2                	or     %esi,%edx
  801d99:	f6 c2 03             	test   $0x3,%dl
  801d9c:	75 0a                	jne    801da8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d9e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801da1:	89 c7                	mov    %eax,%edi
  801da3:	fc                   	cld    
  801da4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801da6:	eb 05                	jmp    801dad <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801da8:	89 c7                	mov    %eax,%edi
  801daa:	fc                   	cld    
  801dab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801dad:	5e                   	pop    %esi
  801dae:	5f                   	pop    %edi
  801daf:	5d                   	pop    %ebp
  801db0:	c3                   	ret    

00801db1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801db7:	ff 75 10             	pushl  0x10(%ebp)
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	ff 75 08             	pushl  0x8(%ebp)
  801dc0:	e8 8a ff ff ff       	call   801d4f <memmove>
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	56                   	push   %esi
  801dcb:	53                   	push   %ebx
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd2:	89 c6                	mov    %eax,%esi
  801dd4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801dd7:	39 f0                	cmp    %esi,%eax
  801dd9:	74 1c                	je     801df7 <memcmp+0x30>
		if (*s1 != *s2)
  801ddb:	0f b6 08             	movzbl (%eax),%ecx
  801dde:	0f b6 1a             	movzbl (%edx),%ebx
  801de1:	38 d9                	cmp    %bl,%cl
  801de3:	75 08                	jne    801ded <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801de5:	83 c0 01             	add    $0x1,%eax
  801de8:	83 c2 01             	add    $0x1,%edx
  801deb:	eb ea                	jmp    801dd7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801ded:	0f b6 c1             	movzbl %cl,%eax
  801df0:	0f b6 db             	movzbl %bl,%ebx
  801df3:	29 d8                	sub    %ebx,%eax
  801df5:	eb 05                	jmp    801dfc <memcmp+0x35>
	}

	return 0;
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfc:	5b                   	pop    %ebx
  801dfd:	5e                   	pop    %esi
  801dfe:	5d                   	pop    %ebp
  801dff:	c3                   	ret    

00801e00 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	8b 45 08             	mov    0x8(%ebp),%eax
  801e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801e09:	89 c2                	mov    %eax,%edx
  801e0b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801e0e:	39 d0                	cmp    %edx,%eax
  801e10:	73 09                	jae    801e1b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e12:	38 08                	cmp    %cl,(%eax)
  801e14:	74 05                	je     801e1b <memfind+0x1b>
	for (; s < ends; s++)
  801e16:	83 c0 01             	add    $0x1,%eax
  801e19:	eb f3                	jmp    801e0e <memfind+0xe>
			break;
	return (void *) s;
}
  801e1b:	5d                   	pop    %ebp
  801e1c:	c3                   	ret    

00801e1d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	57                   	push   %edi
  801e21:	56                   	push   %esi
  801e22:	53                   	push   %ebx
  801e23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e29:	eb 03                	jmp    801e2e <strtol+0x11>
		s++;
  801e2b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801e2e:	0f b6 01             	movzbl (%ecx),%eax
  801e31:	3c 20                	cmp    $0x20,%al
  801e33:	74 f6                	je     801e2b <strtol+0xe>
  801e35:	3c 09                	cmp    $0x9,%al
  801e37:	74 f2                	je     801e2b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801e39:	3c 2b                	cmp    $0x2b,%al
  801e3b:	74 2a                	je     801e67 <strtol+0x4a>
	int neg = 0;
  801e3d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e42:	3c 2d                	cmp    $0x2d,%al
  801e44:	74 2b                	je     801e71 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e46:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e4c:	75 0f                	jne    801e5d <strtol+0x40>
  801e4e:	80 39 30             	cmpb   $0x30,(%ecx)
  801e51:	74 28                	je     801e7b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e53:	85 db                	test   %ebx,%ebx
  801e55:	b8 0a 00 00 00       	mov    $0xa,%eax
  801e5a:	0f 44 d8             	cmove  %eax,%ebx
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e62:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e65:	eb 50                	jmp    801eb7 <strtol+0x9a>
		s++;
  801e67:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e6a:	bf 00 00 00 00       	mov    $0x0,%edi
  801e6f:	eb d5                	jmp    801e46 <strtol+0x29>
		s++, neg = 1;
  801e71:	83 c1 01             	add    $0x1,%ecx
  801e74:	bf 01 00 00 00       	mov    $0x1,%edi
  801e79:	eb cb                	jmp    801e46 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e7b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e7f:	74 0e                	je     801e8f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801e81:	85 db                	test   %ebx,%ebx
  801e83:	75 d8                	jne    801e5d <strtol+0x40>
		s++, base = 8;
  801e85:	83 c1 01             	add    $0x1,%ecx
  801e88:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e8d:	eb ce                	jmp    801e5d <strtol+0x40>
		s += 2, base = 16;
  801e8f:	83 c1 02             	add    $0x2,%ecx
  801e92:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e97:	eb c4                	jmp    801e5d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e99:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e9c:	89 f3                	mov    %esi,%ebx
  801e9e:	80 fb 19             	cmp    $0x19,%bl
  801ea1:	77 29                	ja     801ecc <strtol+0xaf>
			dig = *s - 'a' + 10;
  801ea3:	0f be d2             	movsbl %dl,%edx
  801ea6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801ea9:	3b 55 10             	cmp    0x10(%ebp),%edx
  801eac:	7d 30                	jge    801ede <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801eae:	83 c1 01             	add    $0x1,%ecx
  801eb1:	0f af 45 10          	imul   0x10(%ebp),%eax
  801eb5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801eb7:	0f b6 11             	movzbl (%ecx),%edx
  801eba:	8d 72 d0             	lea    -0x30(%edx),%esi
  801ebd:	89 f3                	mov    %esi,%ebx
  801ebf:	80 fb 09             	cmp    $0x9,%bl
  801ec2:	77 d5                	ja     801e99 <strtol+0x7c>
			dig = *s - '0';
  801ec4:	0f be d2             	movsbl %dl,%edx
  801ec7:	83 ea 30             	sub    $0x30,%edx
  801eca:	eb dd                	jmp    801ea9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801ecc:	8d 72 bf             	lea    -0x41(%edx),%esi
  801ecf:	89 f3                	mov    %esi,%ebx
  801ed1:	80 fb 19             	cmp    $0x19,%bl
  801ed4:	77 08                	ja     801ede <strtol+0xc1>
			dig = *s - 'A' + 10;
  801ed6:	0f be d2             	movsbl %dl,%edx
  801ed9:	83 ea 37             	sub    $0x37,%edx
  801edc:	eb cb                	jmp    801ea9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ede:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ee2:	74 05                	je     801ee9 <strtol+0xcc>
		*endptr = (char *) s;
  801ee4:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ee7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801ee9:	89 c2                	mov    %eax,%edx
  801eeb:	f7 da                	neg    %edx
  801eed:	85 ff                	test   %edi,%edi
  801eef:	0f 45 c2             	cmovne %edx,%eax
}
  801ef2:	5b                   	pop    %ebx
  801ef3:	5e                   	pop    %esi
  801ef4:	5f                   	pop    %edi
  801ef5:	5d                   	pop    %ebp
  801ef6:	c3                   	ret    

00801ef7 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801efd:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  801f04:	74 0a                	je     801f10 <set_pgfault_handler+0x19>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
    if (r < 0) panic("set_pgfault_handler: %e", r);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	a3 00 70 80 00       	mov    %eax,0x807000
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    
    r = sys_page_alloc(thisenv->env_id, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  801f10:	a1 08 40 80 00       	mov    0x804008,%eax
  801f15:	8b 40 48             	mov    0x48(%eax),%eax
  801f18:	83 ec 04             	sub    $0x4,%esp
  801f1b:	6a 07                	push   $0x7
  801f1d:	68 00 f0 bf ee       	push   $0xeebff000
  801f22:	50                   	push   %eax
  801f23:	e8 48 e2 ff ff       	call   800170 <sys_page_alloc>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  801f28:	83 c4 10             	add    $0x10,%esp
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	78 2c                	js     801f5b <set_pgfault_handler+0x64>
    r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801f2f:	e8 fe e1 ff ff       	call   800132 <sys_getenvid>
  801f34:	83 ec 08             	sub    $0x8,%esp
  801f37:	68 80 03 80 00       	push   $0x800380
  801f3c:	50                   	push   %eax
  801f3d:	e8 79 e3 ff ff       	call   8002bb <sys_env_set_pgfault_upcall>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  801f42:	83 c4 10             	add    $0x10,%esp
  801f45:	85 c0                	test   %eax,%eax
  801f47:	79 bd                	jns    801f06 <set_pgfault_handler+0xf>
  801f49:	50                   	push   %eax
  801f4a:	68 bf 27 80 00       	push   $0x8027bf
  801f4f:	6a 23                	push   $0x23
  801f51:	68 d7 27 80 00       	push   $0x8027d7
  801f56:	e8 af f5 ff ff       	call   80150a <_panic>
    if (r < 0) panic("set_pgfault_handler: %e", r);
  801f5b:	50                   	push   %eax
  801f5c:	68 bf 27 80 00       	push   $0x8027bf
  801f61:	6a 21                	push   $0x21
  801f63:	68 d7 27 80 00       	push   $0x8027d7
  801f68:	e8 9d f5 ff ff       	call   80150a <_panic>

00801f6d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	56                   	push   %esi
  801f71:	53                   	push   %ebx
  801f72:	8b 75 08             	mov    0x8(%ebp),%esi
  801f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	74 4f                	je     801fce <ipc_recv+0x61>
  801f7f:	83 ec 0c             	sub    $0xc,%esp
  801f82:	50                   	push   %eax
  801f83:	e8 98 e3 ff ff       	call   800320 <sys_ipc_recv>
  801f88:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801f8b:	85 f6                	test   %esi,%esi
  801f8d:	74 14                	je     801fa3 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801f8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f94:	85 c0                	test   %eax,%eax
  801f96:	75 09                	jne    801fa1 <ipc_recv+0x34>
  801f98:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f9e:	8b 52 74             	mov    0x74(%edx),%edx
  801fa1:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801fa3:	85 db                	test   %ebx,%ebx
  801fa5:	74 14                	je     801fbb <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801fa7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fac:	85 c0                	test   %eax,%eax
  801fae:	75 09                	jne    801fb9 <ipc_recv+0x4c>
  801fb0:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fb6:	8b 52 78             	mov    0x78(%edx),%edx
  801fb9:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	75 08                	jne    801fc7 <ipc_recv+0x5a>
  801fbf:	a1 08 40 80 00       	mov    0x804008,%eax
  801fc4:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fca:	5b                   	pop    %ebx
  801fcb:	5e                   	pop    %esi
  801fcc:	5d                   	pop    %ebp
  801fcd:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801fce:	83 ec 0c             	sub    $0xc,%esp
  801fd1:	68 00 00 c0 ee       	push   $0xeec00000
  801fd6:	e8 45 e3 ff ff       	call   800320 <sys_ipc_recv>
  801fdb:	83 c4 10             	add    $0x10,%esp
  801fde:	eb ab                	jmp    801f8b <ipc_recv+0x1e>

00801fe0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	57                   	push   %edi
  801fe4:	56                   	push   %esi
  801fe5:	53                   	push   %ebx
  801fe6:	83 ec 0c             	sub    $0xc,%esp
  801fe9:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fec:	8b 75 10             	mov    0x10(%ebp),%esi
  801fef:	eb 20                	jmp    802011 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801ff1:	6a 00                	push   $0x0
  801ff3:	68 00 00 c0 ee       	push   $0xeec00000
  801ff8:	ff 75 0c             	pushl  0xc(%ebp)
  801ffb:	57                   	push   %edi
  801ffc:	e8 fc e2 ff ff       	call   8002fd <sys_ipc_try_send>
  802001:	89 c3                	mov    %eax,%ebx
  802003:	83 c4 10             	add    $0x10,%esp
  802006:	eb 1f                	jmp    802027 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  802008:	e8 44 e1 ff ff       	call   800151 <sys_yield>
	while(retval != 0) {
  80200d:	85 db                	test   %ebx,%ebx
  80200f:	74 33                	je     802044 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802011:	85 f6                	test   %esi,%esi
  802013:	74 dc                	je     801ff1 <ipc_send+0x11>
  802015:	ff 75 14             	pushl  0x14(%ebp)
  802018:	56                   	push   %esi
  802019:	ff 75 0c             	pushl  0xc(%ebp)
  80201c:	57                   	push   %edi
  80201d:	e8 db e2 ff ff       	call   8002fd <sys_ipc_try_send>
  802022:	89 c3                	mov    %eax,%ebx
  802024:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  802027:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80202a:	74 dc                	je     802008 <ipc_send+0x28>
  80202c:	85 db                	test   %ebx,%ebx
  80202e:	74 d8                	je     802008 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802030:	83 ec 04             	sub    $0x4,%esp
  802033:	68 e8 27 80 00       	push   $0x8027e8
  802038:	6a 35                	push   $0x35
  80203a:	68 18 28 80 00       	push   $0x802818
  80203f:	e8 c6 f4 ff ff       	call   80150a <_panic>
	}
}
  802044:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802047:	5b                   	pop    %ebx
  802048:	5e                   	pop    %esi
  802049:	5f                   	pop    %edi
  80204a:	5d                   	pop    %ebp
  80204b:	c3                   	ret    

0080204c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802052:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802057:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80205a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802060:	8b 52 50             	mov    0x50(%edx),%edx
  802063:	39 ca                	cmp    %ecx,%edx
  802065:	74 11                	je     802078 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802067:	83 c0 01             	add    $0x1,%eax
  80206a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80206f:	75 e6                	jne    802057 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
  802076:	eb 0b                	jmp    802083 <ipc_find_env+0x37>
			return envs[i].env_id;
  802078:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80207b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802080:	8b 40 48             	mov    0x48(%eax),%eax
}
  802083:	5d                   	pop    %ebp
  802084:	c3                   	ret    

00802085 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80208b:	89 d0                	mov    %edx,%eax
  80208d:	c1 e8 16             	shr    $0x16,%eax
  802090:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802097:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80209c:	f6 c1 01             	test   $0x1,%cl
  80209f:	74 1d                	je     8020be <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020a1:	c1 ea 0c             	shr    $0xc,%edx
  8020a4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020ab:	f6 c2 01             	test   $0x1,%dl
  8020ae:	74 0e                	je     8020be <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020b0:	c1 ea 0c             	shr    $0xc,%edx
  8020b3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020ba:	ef 
  8020bb:	0f b7 c0             	movzwl %ax,%eax
}
  8020be:	5d                   	pop    %ebp
  8020bf:	c3                   	ret    

008020c0 <__udivdi3>:
  8020c0:	f3 0f 1e fb          	endbr32 
  8020c4:	55                   	push   %ebp
  8020c5:	57                   	push   %edi
  8020c6:	56                   	push   %esi
  8020c7:	53                   	push   %ebx
  8020c8:	83 ec 1c             	sub    $0x1c,%esp
  8020cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020db:	85 d2                	test   %edx,%edx
  8020dd:	75 49                	jne    802128 <__udivdi3+0x68>
  8020df:	39 f3                	cmp    %esi,%ebx
  8020e1:	76 15                	jbe    8020f8 <__udivdi3+0x38>
  8020e3:	31 ff                	xor    %edi,%edi
  8020e5:	89 e8                	mov    %ebp,%eax
  8020e7:	89 f2                	mov    %esi,%edx
  8020e9:	f7 f3                	div    %ebx
  8020eb:	89 fa                	mov    %edi,%edx
  8020ed:	83 c4 1c             	add    $0x1c,%esp
  8020f0:	5b                   	pop    %ebx
  8020f1:	5e                   	pop    %esi
  8020f2:	5f                   	pop    %edi
  8020f3:	5d                   	pop    %ebp
  8020f4:	c3                   	ret    
  8020f5:	8d 76 00             	lea    0x0(%esi),%esi
  8020f8:	89 d9                	mov    %ebx,%ecx
  8020fa:	85 db                	test   %ebx,%ebx
  8020fc:	75 0b                	jne    802109 <__udivdi3+0x49>
  8020fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802103:	31 d2                	xor    %edx,%edx
  802105:	f7 f3                	div    %ebx
  802107:	89 c1                	mov    %eax,%ecx
  802109:	31 d2                	xor    %edx,%edx
  80210b:	89 f0                	mov    %esi,%eax
  80210d:	f7 f1                	div    %ecx
  80210f:	89 c6                	mov    %eax,%esi
  802111:	89 e8                	mov    %ebp,%eax
  802113:	89 f7                	mov    %esi,%edi
  802115:	f7 f1                	div    %ecx
  802117:	89 fa                	mov    %edi,%edx
  802119:	83 c4 1c             	add    $0x1c,%esp
  80211c:	5b                   	pop    %ebx
  80211d:	5e                   	pop    %esi
  80211e:	5f                   	pop    %edi
  80211f:	5d                   	pop    %ebp
  802120:	c3                   	ret    
  802121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802128:	39 f2                	cmp    %esi,%edx
  80212a:	77 1c                	ja     802148 <__udivdi3+0x88>
  80212c:	0f bd fa             	bsr    %edx,%edi
  80212f:	83 f7 1f             	xor    $0x1f,%edi
  802132:	75 2c                	jne    802160 <__udivdi3+0xa0>
  802134:	39 f2                	cmp    %esi,%edx
  802136:	72 06                	jb     80213e <__udivdi3+0x7e>
  802138:	31 c0                	xor    %eax,%eax
  80213a:	39 eb                	cmp    %ebp,%ebx
  80213c:	77 ad                	ja     8020eb <__udivdi3+0x2b>
  80213e:	b8 01 00 00 00       	mov    $0x1,%eax
  802143:	eb a6                	jmp    8020eb <__udivdi3+0x2b>
  802145:	8d 76 00             	lea    0x0(%esi),%esi
  802148:	31 ff                	xor    %edi,%edi
  80214a:	31 c0                	xor    %eax,%eax
  80214c:	89 fa                	mov    %edi,%edx
  80214e:	83 c4 1c             	add    $0x1c,%esp
  802151:	5b                   	pop    %ebx
  802152:	5e                   	pop    %esi
  802153:	5f                   	pop    %edi
  802154:	5d                   	pop    %ebp
  802155:	c3                   	ret    
  802156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80215d:	8d 76 00             	lea    0x0(%esi),%esi
  802160:	89 f9                	mov    %edi,%ecx
  802162:	b8 20 00 00 00       	mov    $0x20,%eax
  802167:	29 f8                	sub    %edi,%eax
  802169:	d3 e2                	shl    %cl,%edx
  80216b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80216f:	89 c1                	mov    %eax,%ecx
  802171:	89 da                	mov    %ebx,%edx
  802173:	d3 ea                	shr    %cl,%edx
  802175:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802179:	09 d1                	or     %edx,%ecx
  80217b:	89 f2                	mov    %esi,%edx
  80217d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802181:	89 f9                	mov    %edi,%ecx
  802183:	d3 e3                	shl    %cl,%ebx
  802185:	89 c1                	mov    %eax,%ecx
  802187:	d3 ea                	shr    %cl,%edx
  802189:	89 f9                	mov    %edi,%ecx
  80218b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80218f:	89 eb                	mov    %ebp,%ebx
  802191:	d3 e6                	shl    %cl,%esi
  802193:	89 c1                	mov    %eax,%ecx
  802195:	d3 eb                	shr    %cl,%ebx
  802197:	09 de                	or     %ebx,%esi
  802199:	89 f0                	mov    %esi,%eax
  80219b:	f7 74 24 08          	divl   0x8(%esp)
  80219f:	89 d6                	mov    %edx,%esi
  8021a1:	89 c3                	mov    %eax,%ebx
  8021a3:	f7 64 24 0c          	mull   0xc(%esp)
  8021a7:	39 d6                	cmp    %edx,%esi
  8021a9:	72 15                	jb     8021c0 <__udivdi3+0x100>
  8021ab:	89 f9                	mov    %edi,%ecx
  8021ad:	d3 e5                	shl    %cl,%ebp
  8021af:	39 c5                	cmp    %eax,%ebp
  8021b1:	73 04                	jae    8021b7 <__udivdi3+0xf7>
  8021b3:	39 d6                	cmp    %edx,%esi
  8021b5:	74 09                	je     8021c0 <__udivdi3+0x100>
  8021b7:	89 d8                	mov    %ebx,%eax
  8021b9:	31 ff                	xor    %edi,%edi
  8021bb:	e9 2b ff ff ff       	jmp    8020eb <__udivdi3+0x2b>
  8021c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021c3:	31 ff                	xor    %edi,%edi
  8021c5:	e9 21 ff ff ff       	jmp    8020eb <__udivdi3+0x2b>
  8021ca:	66 90                	xchg   %ax,%ax
  8021cc:	66 90                	xchg   %ax,%ax
  8021ce:	66 90                	xchg   %ax,%ax

008021d0 <__umoddi3>:
  8021d0:	f3 0f 1e fb          	endbr32 
  8021d4:	55                   	push   %ebp
  8021d5:	57                   	push   %edi
  8021d6:	56                   	push   %esi
  8021d7:	53                   	push   %ebx
  8021d8:	83 ec 1c             	sub    $0x1c,%esp
  8021db:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021e3:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021eb:	89 da                	mov    %ebx,%edx
  8021ed:	85 c0                	test   %eax,%eax
  8021ef:	75 3f                	jne    802230 <__umoddi3+0x60>
  8021f1:	39 df                	cmp    %ebx,%edi
  8021f3:	76 13                	jbe    802208 <__umoddi3+0x38>
  8021f5:	89 f0                	mov    %esi,%eax
  8021f7:	f7 f7                	div    %edi
  8021f9:	89 d0                	mov    %edx,%eax
  8021fb:	31 d2                	xor    %edx,%edx
  8021fd:	83 c4 1c             	add    $0x1c,%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5f                   	pop    %edi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    
  802205:	8d 76 00             	lea    0x0(%esi),%esi
  802208:	89 fd                	mov    %edi,%ebp
  80220a:	85 ff                	test   %edi,%edi
  80220c:	75 0b                	jne    802219 <__umoddi3+0x49>
  80220e:	b8 01 00 00 00       	mov    $0x1,%eax
  802213:	31 d2                	xor    %edx,%edx
  802215:	f7 f7                	div    %edi
  802217:	89 c5                	mov    %eax,%ebp
  802219:	89 d8                	mov    %ebx,%eax
  80221b:	31 d2                	xor    %edx,%edx
  80221d:	f7 f5                	div    %ebp
  80221f:	89 f0                	mov    %esi,%eax
  802221:	f7 f5                	div    %ebp
  802223:	89 d0                	mov    %edx,%eax
  802225:	eb d4                	jmp    8021fb <__umoddi3+0x2b>
  802227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80222e:	66 90                	xchg   %ax,%ax
  802230:	89 f1                	mov    %esi,%ecx
  802232:	39 d8                	cmp    %ebx,%eax
  802234:	76 0a                	jbe    802240 <__umoddi3+0x70>
  802236:	89 f0                	mov    %esi,%eax
  802238:	83 c4 1c             	add    $0x1c,%esp
  80223b:	5b                   	pop    %ebx
  80223c:	5e                   	pop    %esi
  80223d:	5f                   	pop    %edi
  80223e:	5d                   	pop    %ebp
  80223f:	c3                   	ret    
  802240:	0f bd e8             	bsr    %eax,%ebp
  802243:	83 f5 1f             	xor    $0x1f,%ebp
  802246:	75 20                	jne    802268 <__umoddi3+0x98>
  802248:	39 d8                	cmp    %ebx,%eax
  80224a:	0f 82 b0 00 00 00    	jb     802300 <__umoddi3+0x130>
  802250:	39 f7                	cmp    %esi,%edi
  802252:	0f 86 a8 00 00 00    	jbe    802300 <__umoddi3+0x130>
  802258:	89 c8                	mov    %ecx,%eax
  80225a:	83 c4 1c             	add    $0x1c,%esp
  80225d:	5b                   	pop    %ebx
  80225e:	5e                   	pop    %esi
  80225f:	5f                   	pop    %edi
  802260:	5d                   	pop    %ebp
  802261:	c3                   	ret    
  802262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802268:	89 e9                	mov    %ebp,%ecx
  80226a:	ba 20 00 00 00       	mov    $0x20,%edx
  80226f:	29 ea                	sub    %ebp,%edx
  802271:	d3 e0                	shl    %cl,%eax
  802273:	89 44 24 08          	mov    %eax,0x8(%esp)
  802277:	89 d1                	mov    %edx,%ecx
  802279:	89 f8                	mov    %edi,%eax
  80227b:	d3 e8                	shr    %cl,%eax
  80227d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802281:	89 54 24 04          	mov    %edx,0x4(%esp)
  802285:	8b 54 24 04          	mov    0x4(%esp),%edx
  802289:	09 c1                	or     %eax,%ecx
  80228b:	89 d8                	mov    %ebx,%eax
  80228d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802291:	89 e9                	mov    %ebp,%ecx
  802293:	d3 e7                	shl    %cl,%edi
  802295:	89 d1                	mov    %edx,%ecx
  802297:	d3 e8                	shr    %cl,%eax
  802299:	89 e9                	mov    %ebp,%ecx
  80229b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80229f:	d3 e3                	shl    %cl,%ebx
  8022a1:	89 c7                	mov    %eax,%edi
  8022a3:	89 d1                	mov    %edx,%ecx
  8022a5:	89 f0                	mov    %esi,%eax
  8022a7:	d3 e8                	shr    %cl,%eax
  8022a9:	89 e9                	mov    %ebp,%ecx
  8022ab:	89 fa                	mov    %edi,%edx
  8022ad:	d3 e6                	shl    %cl,%esi
  8022af:	09 d8                	or     %ebx,%eax
  8022b1:	f7 74 24 08          	divl   0x8(%esp)
  8022b5:	89 d1                	mov    %edx,%ecx
  8022b7:	89 f3                	mov    %esi,%ebx
  8022b9:	f7 64 24 0c          	mull   0xc(%esp)
  8022bd:	89 c6                	mov    %eax,%esi
  8022bf:	89 d7                	mov    %edx,%edi
  8022c1:	39 d1                	cmp    %edx,%ecx
  8022c3:	72 06                	jb     8022cb <__umoddi3+0xfb>
  8022c5:	75 10                	jne    8022d7 <__umoddi3+0x107>
  8022c7:	39 c3                	cmp    %eax,%ebx
  8022c9:	73 0c                	jae    8022d7 <__umoddi3+0x107>
  8022cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8022cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8022d3:	89 d7                	mov    %edx,%edi
  8022d5:	89 c6                	mov    %eax,%esi
  8022d7:	89 ca                	mov    %ecx,%edx
  8022d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022de:	29 f3                	sub    %esi,%ebx
  8022e0:	19 fa                	sbb    %edi,%edx
  8022e2:	89 d0                	mov    %edx,%eax
  8022e4:	d3 e0                	shl    %cl,%eax
  8022e6:	89 e9                	mov    %ebp,%ecx
  8022e8:	d3 eb                	shr    %cl,%ebx
  8022ea:	d3 ea                	shr    %cl,%edx
  8022ec:	09 d8                	or     %ebx,%eax
  8022ee:	83 c4 1c             	add    $0x1c,%esp
  8022f1:	5b                   	pop    %ebx
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    
  8022f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022fd:	8d 76 00             	lea    0x0(%esi),%esi
  802300:	89 da                	mov    %ebx,%edx
  802302:	29 fe                	sub    %edi,%esi
  802304:	19 c2                	sbb    %eax,%edx
  802306:	89 f1                	mov    %esi,%ecx
  802308:	89 c8                	mov    %ecx,%eax
  80230a:	e9 4b ff ff ff       	jmp    80225a <__umoddi3+0x8a>
