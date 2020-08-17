
obj/user/badsegment.debug：     文件格式 elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void
umain(int argc, char **argv)
{
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800033:	66 b8 28 00          	mov    $0x28,%ax
  800037:	8e d8                	mov    %eax,%ds
}
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800042:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800045:	e8 ce 00 00 00       	call   800118 <sys_getenvid>
  80004a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800052:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800057:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005c:	85 db                	test   %ebx,%ebx
  80005e:	7e 07                	jle    800067 <libmain+0x2d>
		binaryname = argv[0];
  800060:	8b 06                	mov    (%esi),%eax
  800062:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800067:	83 ec 08             	sub    $0x8,%esp
  80006a:	56                   	push   %esi
  80006b:	53                   	push   %ebx
  80006c:	e8 c2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800071:	e8 0a 00 00 00       	call   800080 <exit>
}
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007c:	5b                   	pop    %ebx
  80007d:	5e                   	pop    %esi
  80007e:	5d                   	pop    %ebp
  80007f:	c3                   	ret    

00800080 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800086:	e8 b3 04 00 00       	call   80053e <close_all>
	sys_env_destroy(0);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	6a 00                	push   $0x0
  800090:	e8 42 00 00 00       	call   8000d7 <sys_env_destroy>
}
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	57                   	push   %edi
  80009e:	56                   	push   %esi
  80009f:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ab:	89 c3                	mov    %eax,%ebx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 c6                	mov    %eax,%esi
  8000b1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b3:	5b                   	pop    %ebx
  8000b4:	5e                   	pop    %esi
  8000b5:	5f                   	pop    %edi
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	57                   	push   %edi
  8000bc:	56                   	push   %esi
  8000bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000be:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c8:	89 d1                	mov    %edx,%ecx
  8000ca:	89 d3                	mov    %edx,%ebx
  8000cc:	89 d7                	mov    %edx,%edi
  8000ce:	89 d6                	mov    %edx,%esi
  8000d0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d2:	5b                   	pop    %ebx
  8000d3:	5e                   	pop    %esi
  8000d4:	5f                   	pop    %edi
  8000d5:	5d                   	pop    %ebp
  8000d6:	c3                   	ret    

008000d7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d7:	55                   	push   %ebp
  8000d8:	89 e5                	mov    %esp,%ebp
  8000da:	57                   	push   %edi
  8000db:	56                   	push   %esi
  8000dc:	53                   	push   %ebx
  8000dd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e8:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ed:	89 cb                	mov    %ecx,%ebx
  8000ef:	89 cf                	mov    %ecx,%edi
  8000f1:	89 ce                	mov    %ecx,%esi
  8000f3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f5:	85 c0                	test   %eax,%eax
  8000f7:	7f 08                	jg     800101 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fc:	5b                   	pop    %ebx
  8000fd:	5e                   	pop    %esi
  8000fe:	5f                   	pop    %edi
  8000ff:	5d                   	pop    %ebp
  800100:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	50                   	push   %eax
  800105:	6a 03                	push   $0x3
  800107:	68 6a 22 80 00       	push   $0x80226a
  80010c:	6a 23                	push   $0x23
  80010e:	68 87 22 80 00       	push   $0x802287
  800113:	e8 b1 13 00 00       	call   8014c9 <_panic>

00800118 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80011e:	ba 00 00 00 00       	mov    $0x0,%edx
  800123:	b8 02 00 00 00       	mov    $0x2,%eax
  800128:	89 d1                	mov    %edx,%ecx
  80012a:	89 d3                	mov    %edx,%ebx
  80012c:	89 d7                	mov    %edx,%edi
  80012e:	89 d6                	mov    %edx,%esi
  800130:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800132:	5b                   	pop    %ebx
  800133:	5e                   	pop    %esi
  800134:	5f                   	pop    %edi
  800135:	5d                   	pop    %ebp
  800136:	c3                   	ret    

00800137 <sys_yield>:

void
sys_yield(void)
{
  800137:	55                   	push   %ebp
  800138:	89 e5                	mov    %esp,%ebp
  80013a:	57                   	push   %edi
  80013b:	56                   	push   %esi
  80013c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013d:	ba 00 00 00 00       	mov    $0x0,%edx
  800142:	b8 0b 00 00 00       	mov    $0xb,%eax
  800147:	89 d1                	mov    %edx,%ecx
  800149:	89 d3                	mov    %edx,%ebx
  80014b:	89 d7                	mov    %edx,%edi
  80014d:	89 d6                	mov    %edx,%esi
  80014f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800151:	5b                   	pop    %ebx
  800152:	5e                   	pop    %esi
  800153:	5f                   	pop    %edi
  800154:	5d                   	pop    %ebp
  800155:	c3                   	ret    

00800156 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800156:	55                   	push   %ebp
  800157:	89 e5                	mov    %esp,%ebp
  800159:	57                   	push   %edi
  80015a:	56                   	push   %esi
  80015b:	53                   	push   %ebx
  80015c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015f:	be 00 00 00 00       	mov    $0x0,%esi
  800164:	8b 55 08             	mov    0x8(%ebp),%edx
  800167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016a:	b8 04 00 00 00       	mov    $0x4,%eax
  80016f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800172:	89 f7                	mov    %esi,%edi
  800174:	cd 30                	int    $0x30
	if(check && ret > 0)
  800176:	85 c0                	test   %eax,%eax
  800178:	7f 08                	jg     800182 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017d:	5b                   	pop    %ebx
  80017e:	5e                   	pop    %esi
  80017f:	5f                   	pop    %edi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	6a 04                	push   $0x4
  800188:	68 6a 22 80 00       	push   $0x80226a
  80018d:	6a 23                	push   $0x23
  80018f:	68 87 22 80 00       	push   $0x802287
  800194:	e8 30 13 00 00       	call   8014c9 <_panic>

00800199 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800199:	55                   	push   %ebp
  80019a:	89 e5                	mov    %esp,%ebp
  80019c:	57                   	push   %edi
  80019d:	56                   	push   %esi
  80019e:	53                   	push   %ebx
  80019f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a8:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b8:	85 c0                	test   %eax,%eax
  8001ba:	7f 08                	jg     8001c4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bf:	5b                   	pop    %ebx
  8001c0:	5e                   	pop    %esi
  8001c1:	5f                   	pop    %edi
  8001c2:	5d                   	pop    %ebp
  8001c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	50                   	push   %eax
  8001c8:	6a 05                	push   $0x5
  8001ca:	68 6a 22 80 00       	push   $0x80226a
  8001cf:	6a 23                	push   $0x23
  8001d1:	68 87 22 80 00       	push   $0x802287
  8001d6:	e8 ee 12 00 00       	call   8014c9 <_panic>

008001db <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	57                   	push   %edi
  8001df:	56                   	push   %esi
  8001e0:	53                   	push   %ebx
  8001e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f4:	89 df                	mov    %ebx,%edi
  8001f6:	89 de                	mov    %ebx,%esi
  8001f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fa:	85 c0                	test   %eax,%eax
  8001fc:	7f 08                	jg     800206 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800201:	5b                   	pop    %ebx
  800202:	5e                   	pop    %esi
  800203:	5f                   	pop    %edi
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	50                   	push   %eax
  80020a:	6a 06                	push   $0x6
  80020c:	68 6a 22 80 00       	push   $0x80226a
  800211:	6a 23                	push   $0x23
  800213:	68 87 22 80 00       	push   $0x802287
  800218:	e8 ac 12 00 00       	call   8014c9 <_panic>

0080021d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	57                   	push   %edi
  800221:	56                   	push   %esi
  800222:	53                   	push   %ebx
  800223:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800226:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022b:	8b 55 08             	mov    0x8(%ebp),%edx
  80022e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800231:	b8 08 00 00 00       	mov    $0x8,%eax
  800236:	89 df                	mov    %ebx,%edi
  800238:	89 de                	mov    %ebx,%esi
  80023a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80023c:	85 c0                	test   %eax,%eax
  80023e:	7f 08                	jg     800248 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800243:	5b                   	pop    %ebx
  800244:	5e                   	pop    %esi
  800245:	5f                   	pop    %edi
  800246:	5d                   	pop    %ebp
  800247:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	50                   	push   %eax
  80024c:	6a 08                	push   $0x8
  80024e:	68 6a 22 80 00       	push   $0x80226a
  800253:	6a 23                	push   $0x23
  800255:	68 87 22 80 00       	push   $0x802287
  80025a:	e8 6a 12 00 00       	call   8014c9 <_panic>

0080025f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	57                   	push   %edi
  800263:	56                   	push   %esi
  800264:	53                   	push   %ebx
  800265:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800268:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026d:	8b 55 08             	mov    0x8(%ebp),%edx
  800270:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800273:	b8 09 00 00 00       	mov    $0x9,%eax
  800278:	89 df                	mov    %ebx,%edi
  80027a:	89 de                	mov    %ebx,%esi
  80027c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027e:	85 c0                	test   %eax,%eax
  800280:	7f 08                	jg     80028a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800282:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800285:	5b                   	pop    %ebx
  800286:	5e                   	pop    %esi
  800287:	5f                   	pop    %edi
  800288:	5d                   	pop    %ebp
  800289:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	50                   	push   %eax
  80028e:	6a 09                	push   $0x9
  800290:	68 6a 22 80 00       	push   $0x80226a
  800295:	6a 23                	push   $0x23
  800297:	68 87 22 80 00       	push   $0x802287
  80029c:	e8 28 12 00 00       	call   8014c9 <_panic>

008002a1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	57                   	push   %edi
  8002a5:	56                   	push   %esi
  8002a6:	53                   	push   %ebx
  8002a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002af:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ba:	89 df                	mov    %ebx,%edi
  8002bc:	89 de                	mov    %ebx,%esi
  8002be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c0:	85 c0                	test   %eax,%eax
  8002c2:	7f 08                	jg     8002cc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c7:	5b                   	pop    %ebx
  8002c8:	5e                   	pop    %esi
  8002c9:	5f                   	pop    %edi
  8002ca:	5d                   	pop    %ebp
  8002cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	50                   	push   %eax
  8002d0:	6a 0a                	push   $0xa
  8002d2:	68 6a 22 80 00       	push   $0x80226a
  8002d7:	6a 23                	push   $0x23
  8002d9:	68 87 22 80 00       	push   $0x802287
  8002de:	e8 e6 11 00 00       	call   8014c9 <_panic>

008002e3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	57                   	push   %edi
  8002e7:	56                   	push   %esi
  8002e8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ef:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f4:	be 00 00 00 00       	mov    $0x0,%esi
  8002f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002fc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002ff:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800301:	5b                   	pop    %ebx
  800302:	5e                   	pop    %esi
  800303:	5f                   	pop    %edi
  800304:	5d                   	pop    %ebp
  800305:	c3                   	ret    

00800306 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	57                   	push   %edi
  80030a:	56                   	push   %esi
  80030b:	53                   	push   %ebx
  80030c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800314:	8b 55 08             	mov    0x8(%ebp),%edx
  800317:	b8 0d 00 00 00       	mov    $0xd,%eax
  80031c:	89 cb                	mov    %ecx,%ebx
  80031e:	89 cf                	mov    %ecx,%edi
  800320:	89 ce                	mov    %ecx,%esi
  800322:	cd 30                	int    $0x30
	if(check && ret > 0)
  800324:	85 c0                	test   %eax,%eax
  800326:	7f 08                	jg     800330 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800328:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5f                   	pop    %edi
  80032e:	5d                   	pop    %ebp
  80032f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800330:	83 ec 0c             	sub    $0xc,%esp
  800333:	50                   	push   %eax
  800334:	6a 0d                	push   $0xd
  800336:	68 6a 22 80 00       	push   $0x80226a
  80033b:	6a 23                	push   $0x23
  80033d:	68 87 22 80 00       	push   $0x802287
  800342:	e8 82 11 00 00       	call   8014c9 <_panic>

00800347 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	57                   	push   %edi
  80034b:	56                   	push   %esi
  80034c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80034d:	ba 00 00 00 00       	mov    $0x0,%edx
  800352:	b8 0e 00 00 00       	mov    $0xe,%eax
  800357:	89 d1                	mov    %edx,%ecx
  800359:	89 d3                	mov    %edx,%ebx
  80035b:	89 d7                	mov    %edx,%edi
  80035d:	89 d6                	mov    %edx,%esi
  80035f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800361:	5b                   	pop    %ebx
  800362:	5e                   	pop    %esi
  800363:	5f                   	pop    %edi
  800364:	5d                   	pop    %ebp
  800365:	c3                   	ret    

00800366 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800366:	55                   	push   %ebp
  800367:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800369:	8b 45 08             	mov    0x8(%ebp),%eax
  80036c:	05 00 00 00 30       	add    $0x30000000,%eax
  800371:	c1 e8 0c             	shr    $0xc,%eax
}
  800374:	5d                   	pop    %ebp
  800375:	c3                   	ret    

00800376 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800381:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800386:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80038b:	5d                   	pop    %ebp
  80038c:	c3                   	ret    

0080038d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80038d:	55                   	push   %ebp
  80038e:	89 e5                	mov    %esp,%ebp
  800390:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800395:	89 c2                	mov    %eax,%edx
  800397:	c1 ea 16             	shr    $0x16,%edx
  80039a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003a1:	f6 c2 01             	test   $0x1,%dl
  8003a4:	74 2d                	je     8003d3 <fd_alloc+0x46>
  8003a6:	89 c2                	mov    %eax,%edx
  8003a8:	c1 ea 0c             	shr    $0xc,%edx
  8003ab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003b2:	f6 c2 01             	test   $0x1,%dl
  8003b5:	74 1c                	je     8003d3 <fd_alloc+0x46>
  8003b7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003bc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003c1:	75 d2                	jne    800395 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8003cc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003d1:	eb 0a                	jmp    8003dd <fd_alloc+0x50>
			*fd_store = fd;
  8003d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003dd:	5d                   	pop    %ebp
  8003de:	c3                   	ret    

008003df <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003e5:	83 f8 1f             	cmp    $0x1f,%eax
  8003e8:	77 30                	ja     80041a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003ea:	c1 e0 0c             	shl    $0xc,%eax
  8003ed:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003f2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8003f8:	f6 c2 01             	test   $0x1,%dl
  8003fb:	74 24                	je     800421 <fd_lookup+0x42>
  8003fd:	89 c2                	mov    %eax,%edx
  8003ff:	c1 ea 0c             	shr    $0xc,%edx
  800402:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800409:	f6 c2 01             	test   $0x1,%dl
  80040c:	74 1a                	je     800428 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80040e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800411:	89 02                	mov    %eax,(%edx)
	return 0;
  800413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800418:	5d                   	pop    %ebp
  800419:	c3                   	ret    
		return -E_INVAL;
  80041a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80041f:	eb f7                	jmp    800418 <fd_lookup+0x39>
		return -E_INVAL;
  800421:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800426:	eb f0                	jmp    800418 <fd_lookup+0x39>
  800428:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80042d:	eb e9                	jmp    800418 <fd_lookup+0x39>

0080042f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	83 ec 08             	sub    $0x8,%esp
  800435:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800438:	ba 00 00 00 00       	mov    $0x0,%edx
  80043d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800442:	39 08                	cmp    %ecx,(%eax)
  800444:	74 38                	je     80047e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800446:	83 c2 01             	add    $0x1,%edx
  800449:	8b 04 95 14 23 80 00 	mov    0x802314(,%edx,4),%eax
  800450:	85 c0                	test   %eax,%eax
  800452:	75 ee                	jne    800442 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800454:	a1 08 40 80 00       	mov    0x804008,%eax
  800459:	8b 40 48             	mov    0x48(%eax),%eax
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	51                   	push   %ecx
  800460:	50                   	push   %eax
  800461:	68 98 22 80 00       	push   $0x802298
  800466:	e8 39 11 00 00       	call   8015a4 <cprintf>
	*dev = 0;
  80046b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800474:	83 c4 10             	add    $0x10,%esp
  800477:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80047c:	c9                   	leave  
  80047d:	c3                   	ret    
			*dev = devtab[i];
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	89 01                	mov    %eax,(%ecx)
			return 0;
  800483:	b8 00 00 00 00       	mov    $0x0,%eax
  800488:	eb f2                	jmp    80047c <dev_lookup+0x4d>

0080048a <fd_close>:
{
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	57                   	push   %edi
  80048e:	56                   	push   %esi
  80048f:	53                   	push   %ebx
  800490:	83 ec 24             	sub    $0x24,%esp
  800493:	8b 75 08             	mov    0x8(%ebp),%esi
  800496:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800499:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80049c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80049d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004a3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a6:	50                   	push   %eax
  8004a7:	e8 33 ff ff ff       	call   8003df <fd_lookup>
  8004ac:	89 c3                	mov    %eax,%ebx
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	85 c0                	test   %eax,%eax
  8004b3:	78 05                	js     8004ba <fd_close+0x30>
	    || fd != fd2)
  8004b5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004b8:	74 16                	je     8004d0 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004ba:	89 f8                	mov    %edi,%eax
  8004bc:	84 c0                	test   %al,%al
  8004be:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c3:	0f 44 d8             	cmove  %eax,%ebx
}
  8004c6:	89 d8                	mov    %ebx,%eax
  8004c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004cb:	5b                   	pop    %ebx
  8004cc:	5e                   	pop    %esi
  8004cd:	5f                   	pop    %edi
  8004ce:	5d                   	pop    %ebp
  8004cf:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004d0:	83 ec 08             	sub    $0x8,%esp
  8004d3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004d6:	50                   	push   %eax
  8004d7:	ff 36                	pushl  (%esi)
  8004d9:	e8 51 ff ff ff       	call   80042f <dev_lookup>
  8004de:	89 c3                	mov    %eax,%ebx
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	78 1a                	js     800501 <fd_close+0x77>
		if (dev->dev_close)
  8004e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ea:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8004ed:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8004f2:	85 c0                	test   %eax,%eax
  8004f4:	74 0b                	je     800501 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8004f6:	83 ec 0c             	sub    $0xc,%esp
  8004f9:	56                   	push   %esi
  8004fa:	ff d0                	call   *%eax
  8004fc:	89 c3                	mov    %eax,%ebx
  8004fe:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	56                   	push   %esi
  800505:	6a 00                	push   $0x0
  800507:	e8 cf fc ff ff       	call   8001db <sys_page_unmap>
	return r;
  80050c:	83 c4 10             	add    $0x10,%esp
  80050f:	eb b5                	jmp    8004c6 <fd_close+0x3c>

00800511 <close>:

int
close(int fdnum)
{
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800517:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80051a:	50                   	push   %eax
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	e8 bc fe ff ff       	call   8003df <fd_lookup>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	85 c0                	test   %eax,%eax
  800528:	79 02                	jns    80052c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80052a:	c9                   	leave  
  80052b:	c3                   	ret    
		return fd_close(fd, 1);
  80052c:	83 ec 08             	sub    $0x8,%esp
  80052f:	6a 01                	push   $0x1
  800531:	ff 75 f4             	pushl  -0xc(%ebp)
  800534:	e8 51 ff ff ff       	call   80048a <fd_close>
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	eb ec                	jmp    80052a <close+0x19>

0080053e <close_all>:

void
close_all(void)
{
  80053e:	55                   	push   %ebp
  80053f:	89 e5                	mov    %esp,%ebp
  800541:	53                   	push   %ebx
  800542:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800545:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80054a:	83 ec 0c             	sub    $0xc,%esp
  80054d:	53                   	push   %ebx
  80054e:	e8 be ff ff ff       	call   800511 <close>
	for (i = 0; i < MAXFD; i++)
  800553:	83 c3 01             	add    $0x1,%ebx
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	83 fb 20             	cmp    $0x20,%ebx
  80055c:	75 ec                	jne    80054a <close_all+0xc>
}
  80055e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	57                   	push   %edi
  800567:	56                   	push   %esi
  800568:	53                   	push   %ebx
  800569:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80056c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80056f:	50                   	push   %eax
  800570:	ff 75 08             	pushl  0x8(%ebp)
  800573:	e8 67 fe ff ff       	call   8003df <fd_lookup>
  800578:	89 c3                	mov    %eax,%ebx
  80057a:	83 c4 10             	add    $0x10,%esp
  80057d:	85 c0                	test   %eax,%eax
  80057f:	0f 88 81 00 00 00    	js     800606 <dup+0xa3>
		return r;
	close(newfdnum);
  800585:	83 ec 0c             	sub    $0xc,%esp
  800588:	ff 75 0c             	pushl  0xc(%ebp)
  80058b:	e8 81 ff ff ff       	call   800511 <close>

	newfd = INDEX2FD(newfdnum);
  800590:	8b 75 0c             	mov    0xc(%ebp),%esi
  800593:	c1 e6 0c             	shl    $0xc,%esi
  800596:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80059c:	83 c4 04             	add    $0x4,%esp
  80059f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005a2:	e8 cf fd ff ff       	call   800376 <fd2data>
  8005a7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005a9:	89 34 24             	mov    %esi,(%esp)
  8005ac:	e8 c5 fd ff ff       	call   800376 <fd2data>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005b6:	89 d8                	mov    %ebx,%eax
  8005b8:	c1 e8 16             	shr    $0x16,%eax
  8005bb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005c2:	a8 01                	test   $0x1,%al
  8005c4:	74 11                	je     8005d7 <dup+0x74>
  8005c6:	89 d8                	mov    %ebx,%eax
  8005c8:	c1 e8 0c             	shr    $0xc,%eax
  8005cb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005d2:	f6 c2 01             	test   $0x1,%dl
  8005d5:	75 39                	jne    800610 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005da:	89 d0                	mov    %edx,%eax
  8005dc:	c1 e8 0c             	shr    $0xc,%eax
  8005df:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005e6:	83 ec 0c             	sub    $0xc,%esp
  8005e9:	25 07 0e 00 00       	and    $0xe07,%eax
  8005ee:	50                   	push   %eax
  8005ef:	56                   	push   %esi
  8005f0:	6a 00                	push   $0x0
  8005f2:	52                   	push   %edx
  8005f3:	6a 00                	push   $0x0
  8005f5:	e8 9f fb ff ff       	call   800199 <sys_page_map>
  8005fa:	89 c3                	mov    %eax,%ebx
  8005fc:	83 c4 20             	add    $0x20,%esp
  8005ff:	85 c0                	test   %eax,%eax
  800601:	78 31                	js     800634 <dup+0xd1>
		goto err;

	return newfdnum;
  800603:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800606:	89 d8                	mov    %ebx,%eax
  800608:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80060b:	5b                   	pop    %ebx
  80060c:	5e                   	pop    %esi
  80060d:	5f                   	pop    %edi
  80060e:	5d                   	pop    %ebp
  80060f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800610:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800617:	83 ec 0c             	sub    $0xc,%esp
  80061a:	25 07 0e 00 00       	and    $0xe07,%eax
  80061f:	50                   	push   %eax
  800620:	57                   	push   %edi
  800621:	6a 00                	push   $0x0
  800623:	53                   	push   %ebx
  800624:	6a 00                	push   $0x0
  800626:	e8 6e fb ff ff       	call   800199 <sys_page_map>
  80062b:	89 c3                	mov    %eax,%ebx
  80062d:	83 c4 20             	add    $0x20,%esp
  800630:	85 c0                	test   %eax,%eax
  800632:	79 a3                	jns    8005d7 <dup+0x74>
	sys_page_unmap(0, newfd);
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	56                   	push   %esi
  800638:	6a 00                	push   $0x0
  80063a:	e8 9c fb ff ff       	call   8001db <sys_page_unmap>
	sys_page_unmap(0, nva);
  80063f:	83 c4 08             	add    $0x8,%esp
  800642:	57                   	push   %edi
  800643:	6a 00                	push   $0x0
  800645:	e8 91 fb ff ff       	call   8001db <sys_page_unmap>
	return r;
  80064a:	83 c4 10             	add    $0x10,%esp
  80064d:	eb b7                	jmp    800606 <dup+0xa3>

0080064f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	53                   	push   %ebx
  800653:	83 ec 1c             	sub    $0x1c,%esp
  800656:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800659:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80065c:	50                   	push   %eax
  80065d:	53                   	push   %ebx
  80065e:	e8 7c fd ff ff       	call   8003df <fd_lookup>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	85 c0                	test   %eax,%eax
  800668:	78 3f                	js     8006a9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80066a:	83 ec 08             	sub    $0x8,%esp
  80066d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800670:	50                   	push   %eax
  800671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800674:	ff 30                	pushl  (%eax)
  800676:	e8 b4 fd ff ff       	call   80042f <dev_lookup>
  80067b:	83 c4 10             	add    $0x10,%esp
  80067e:	85 c0                	test   %eax,%eax
  800680:	78 27                	js     8006a9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800682:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800685:	8b 42 08             	mov    0x8(%edx),%eax
  800688:	83 e0 03             	and    $0x3,%eax
  80068b:	83 f8 01             	cmp    $0x1,%eax
  80068e:	74 1e                	je     8006ae <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800693:	8b 40 08             	mov    0x8(%eax),%eax
  800696:	85 c0                	test   %eax,%eax
  800698:	74 35                	je     8006cf <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80069a:	83 ec 04             	sub    $0x4,%esp
  80069d:	ff 75 10             	pushl  0x10(%ebp)
  8006a0:	ff 75 0c             	pushl  0xc(%ebp)
  8006a3:	52                   	push   %edx
  8006a4:	ff d0                	call   *%eax
  8006a6:	83 c4 10             	add    $0x10,%esp
}
  8006a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006ae:	a1 08 40 80 00       	mov    0x804008,%eax
  8006b3:	8b 40 48             	mov    0x48(%eax),%eax
  8006b6:	83 ec 04             	sub    $0x4,%esp
  8006b9:	53                   	push   %ebx
  8006ba:	50                   	push   %eax
  8006bb:	68 d9 22 80 00       	push   $0x8022d9
  8006c0:	e8 df 0e 00 00       	call   8015a4 <cprintf>
		return -E_INVAL;
  8006c5:	83 c4 10             	add    $0x10,%esp
  8006c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006cd:	eb da                	jmp    8006a9 <read+0x5a>
		return -E_NOT_SUPP;
  8006cf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006d4:	eb d3                	jmp    8006a9 <read+0x5a>

008006d6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006d6:	55                   	push   %ebp
  8006d7:	89 e5                	mov    %esp,%ebp
  8006d9:	57                   	push   %edi
  8006da:	56                   	push   %esi
  8006db:	53                   	push   %ebx
  8006dc:	83 ec 0c             	sub    $0xc,%esp
  8006df:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006e2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ea:	39 f3                	cmp    %esi,%ebx
  8006ec:	73 23                	jae    800711 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006ee:	83 ec 04             	sub    $0x4,%esp
  8006f1:	89 f0                	mov    %esi,%eax
  8006f3:	29 d8                	sub    %ebx,%eax
  8006f5:	50                   	push   %eax
  8006f6:	89 d8                	mov    %ebx,%eax
  8006f8:	03 45 0c             	add    0xc(%ebp),%eax
  8006fb:	50                   	push   %eax
  8006fc:	57                   	push   %edi
  8006fd:	e8 4d ff ff ff       	call   80064f <read>
		if (m < 0)
  800702:	83 c4 10             	add    $0x10,%esp
  800705:	85 c0                	test   %eax,%eax
  800707:	78 06                	js     80070f <readn+0x39>
			return m;
		if (m == 0)
  800709:	74 06                	je     800711 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80070b:	01 c3                	add    %eax,%ebx
  80070d:	eb db                	jmp    8006ea <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80070f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800711:	89 d8                	mov    %ebx,%eax
  800713:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800716:	5b                   	pop    %ebx
  800717:	5e                   	pop    %esi
  800718:	5f                   	pop    %edi
  800719:	5d                   	pop    %ebp
  80071a:	c3                   	ret    

0080071b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	53                   	push   %ebx
  80071f:	83 ec 1c             	sub    $0x1c,%esp
  800722:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800725:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800728:	50                   	push   %eax
  800729:	53                   	push   %ebx
  80072a:	e8 b0 fc ff ff       	call   8003df <fd_lookup>
  80072f:	83 c4 10             	add    $0x10,%esp
  800732:	85 c0                	test   %eax,%eax
  800734:	78 3a                	js     800770 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80073c:	50                   	push   %eax
  80073d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800740:	ff 30                	pushl  (%eax)
  800742:	e8 e8 fc ff ff       	call   80042f <dev_lookup>
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	85 c0                	test   %eax,%eax
  80074c:	78 22                	js     800770 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80074e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800751:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800755:	74 1e                	je     800775 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800757:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80075a:	8b 52 0c             	mov    0xc(%edx),%edx
  80075d:	85 d2                	test   %edx,%edx
  80075f:	74 35                	je     800796 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800761:	83 ec 04             	sub    $0x4,%esp
  800764:	ff 75 10             	pushl  0x10(%ebp)
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	50                   	push   %eax
  80076b:	ff d2                	call   *%edx
  80076d:	83 c4 10             	add    $0x10,%esp
}
  800770:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800773:	c9                   	leave  
  800774:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800775:	a1 08 40 80 00       	mov    0x804008,%eax
  80077a:	8b 40 48             	mov    0x48(%eax),%eax
  80077d:	83 ec 04             	sub    $0x4,%esp
  800780:	53                   	push   %ebx
  800781:	50                   	push   %eax
  800782:	68 f5 22 80 00       	push   $0x8022f5
  800787:	e8 18 0e 00 00       	call   8015a4 <cprintf>
		return -E_INVAL;
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800794:	eb da                	jmp    800770 <write+0x55>
		return -E_NOT_SUPP;
  800796:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80079b:	eb d3                	jmp    800770 <write+0x55>

0080079d <seek>:

int
seek(int fdnum, off_t offset)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007a6:	50                   	push   %eax
  8007a7:	ff 75 08             	pushl  0x8(%ebp)
  8007aa:	e8 30 fc ff ff       	call   8003df <fd_lookup>
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	85 c0                	test   %eax,%eax
  8007b4:	78 0e                	js     8007c4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007bc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	53                   	push   %ebx
  8007ca:	83 ec 1c             	sub    $0x1c,%esp
  8007cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007d3:	50                   	push   %eax
  8007d4:	53                   	push   %ebx
  8007d5:	e8 05 fc ff ff       	call   8003df <fd_lookup>
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	78 37                	js     800818 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007e7:	50                   	push   %eax
  8007e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007eb:	ff 30                	pushl  (%eax)
  8007ed:	e8 3d fc ff ff       	call   80042f <dev_lookup>
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	85 c0                	test   %eax,%eax
  8007f7:	78 1f                	js     800818 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800800:	74 1b                	je     80081d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800805:	8b 52 18             	mov    0x18(%edx),%edx
  800808:	85 d2                	test   %edx,%edx
  80080a:	74 32                	je     80083e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	ff 75 0c             	pushl  0xc(%ebp)
  800812:	50                   	push   %eax
  800813:	ff d2                	call   *%edx
  800815:	83 c4 10             	add    $0x10,%esp
}
  800818:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081b:	c9                   	leave  
  80081c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80081d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800822:	8b 40 48             	mov    0x48(%eax),%eax
  800825:	83 ec 04             	sub    $0x4,%esp
  800828:	53                   	push   %ebx
  800829:	50                   	push   %eax
  80082a:	68 b8 22 80 00       	push   $0x8022b8
  80082f:	e8 70 0d 00 00       	call   8015a4 <cprintf>
		return -E_INVAL;
  800834:	83 c4 10             	add    $0x10,%esp
  800837:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80083c:	eb da                	jmp    800818 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80083e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800843:	eb d3                	jmp    800818 <ftruncate+0x52>

00800845 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	53                   	push   %ebx
  800849:	83 ec 1c             	sub    $0x1c,%esp
  80084c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80084f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800852:	50                   	push   %eax
  800853:	ff 75 08             	pushl  0x8(%ebp)
  800856:	e8 84 fb ff ff       	call   8003df <fd_lookup>
  80085b:	83 c4 10             	add    $0x10,%esp
  80085e:	85 c0                	test   %eax,%eax
  800860:	78 4b                	js     8008ad <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800868:	50                   	push   %eax
  800869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086c:	ff 30                	pushl  (%eax)
  80086e:	e8 bc fb ff ff       	call   80042f <dev_lookup>
  800873:	83 c4 10             	add    $0x10,%esp
  800876:	85 c0                	test   %eax,%eax
  800878:	78 33                	js     8008ad <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80087a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800881:	74 2f                	je     8008b2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800883:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800886:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80088d:	00 00 00 
	stat->st_isdir = 0;
  800890:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800897:	00 00 00 
	stat->st_dev = dev;
  80089a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	53                   	push   %ebx
  8008a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a7:	ff 50 14             	call   *0x14(%eax)
  8008aa:	83 c4 10             	add    $0x10,%esp
}
  8008ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    
		return -E_NOT_SUPP;
  8008b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008b7:	eb f4                	jmp    8008ad <fstat+0x68>

008008b9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	56                   	push   %esi
  8008bd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008be:	83 ec 08             	sub    $0x8,%esp
  8008c1:	6a 00                	push   $0x0
  8008c3:	ff 75 08             	pushl  0x8(%ebp)
  8008c6:	e8 2f 02 00 00       	call   800afa <open>
  8008cb:	89 c3                	mov    %eax,%ebx
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	85 c0                	test   %eax,%eax
  8008d2:	78 1b                	js     8008ef <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	50                   	push   %eax
  8008db:	e8 65 ff ff ff       	call   800845 <fstat>
  8008e0:	89 c6                	mov    %eax,%esi
	close(fd);
  8008e2:	89 1c 24             	mov    %ebx,(%esp)
  8008e5:	e8 27 fc ff ff       	call   800511 <close>
	return r;
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 f3                	mov    %esi,%ebx
}
  8008ef:	89 d8                	mov    %ebx,%eax
  8008f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f4:	5b                   	pop    %ebx
  8008f5:	5e                   	pop    %esi
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	56                   	push   %esi
  8008fc:	53                   	push   %ebx
  8008fd:	89 c6                	mov    %eax,%esi
  8008ff:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800901:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800908:	74 27                	je     800931 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80090a:	6a 07                	push   $0x7
  80090c:	68 00 50 80 00       	push   $0x805000
  800911:	56                   	push   %esi
  800912:	ff 35 00 40 80 00    	pushl  0x804000
  800918:	e8 0c 16 00 00       	call   801f29 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80091d:	83 c4 0c             	add    $0xc,%esp
  800920:	6a 00                	push   $0x0
  800922:	53                   	push   %ebx
  800923:	6a 00                	push   $0x0
  800925:	e8 8c 15 00 00       	call   801eb6 <ipc_recv>
}
  80092a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80092d:	5b                   	pop    %ebx
  80092e:	5e                   	pop    %esi
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800931:	83 ec 0c             	sub    $0xc,%esp
  800934:	6a 01                	push   $0x1
  800936:	e8 5a 16 00 00       	call   801f95 <ipc_find_env>
  80093b:	a3 00 40 80 00       	mov    %eax,0x804000
  800940:	83 c4 10             	add    $0x10,%esp
  800943:	eb c5                	jmp    80090a <fsipc+0x12>

00800945 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 40 0c             	mov    0xc(%eax),%eax
  800951:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800956:	8b 45 0c             	mov    0xc(%ebp),%eax
  800959:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80095e:	ba 00 00 00 00       	mov    $0x0,%edx
  800963:	b8 02 00 00 00       	mov    $0x2,%eax
  800968:	e8 8b ff ff ff       	call   8008f8 <fsipc>
}
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <devfile_flush>:
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 40 0c             	mov    0xc(%eax),%eax
  80097b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800980:	ba 00 00 00 00       	mov    $0x0,%edx
  800985:	b8 06 00 00 00       	mov    $0x6,%eax
  80098a:	e8 69 ff ff ff       	call   8008f8 <fsipc>
}
  80098f:	c9                   	leave  
  800990:	c3                   	ret    

00800991 <devfile_stat>:
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	53                   	push   %ebx
  800995:	83 ec 04             	sub    $0x4,%esp
  800998:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8b 40 0c             	mov    0xc(%eax),%eax
  8009a1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ab:	b8 05 00 00 00       	mov    $0x5,%eax
  8009b0:	e8 43 ff ff ff       	call   8008f8 <fsipc>
  8009b5:	85 c0                	test   %eax,%eax
  8009b7:	78 2c                	js     8009e5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009b9:	83 ec 08             	sub    $0x8,%esp
  8009bc:	68 00 50 80 00       	push   $0x805000
  8009c1:	53                   	push   %ebx
  8009c2:	e8 b9 11 00 00       	call   801b80 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009c7:	a1 80 50 80 00       	mov    0x805080,%eax
  8009cc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009d2:	a1 84 50 80 00       	mov    0x805084,%eax
  8009d7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    

008009ea <devfile_write>:
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	53                   	push   %ebx
  8009ee:	83 ec 04             	sub    $0x4,%esp
  8009f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8009f4:	85 db                	test   %ebx,%ebx
  8009f6:	75 07                	jne    8009ff <devfile_write+0x15>
	return n_all;
  8009f8:	89 d8                	mov    %ebx,%eax
}
  8009fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 40 0c             	mov    0xc(%eax),%eax
  800a05:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  800a0a:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  800a10:	83 ec 04             	sub    $0x4,%esp
  800a13:	53                   	push   %ebx
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	68 08 50 80 00       	push   $0x805008
  800a1c:	e8 ed 12 00 00       	call   801d0e <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a21:	ba 00 00 00 00       	mov    $0x0,%edx
  800a26:	b8 04 00 00 00       	mov    $0x4,%eax
  800a2b:	e8 c8 fe ff ff       	call   8008f8 <fsipc>
  800a30:	83 c4 10             	add    $0x10,%esp
  800a33:	85 c0                	test   %eax,%eax
  800a35:	78 c3                	js     8009fa <devfile_write+0x10>
	  assert(r <= n_left);
  800a37:	39 d8                	cmp    %ebx,%eax
  800a39:	77 0b                	ja     800a46 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  800a3b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a40:	7f 1d                	jg     800a5f <devfile_write+0x75>
    n_all += r;
  800a42:	89 c3                	mov    %eax,%ebx
  800a44:	eb b2                	jmp    8009f8 <devfile_write+0xe>
	  assert(r <= n_left);
  800a46:	68 28 23 80 00       	push   $0x802328
  800a4b:	68 34 23 80 00       	push   $0x802334
  800a50:	68 9f 00 00 00       	push   $0x9f
  800a55:	68 49 23 80 00       	push   $0x802349
  800a5a:	e8 6a 0a 00 00       	call   8014c9 <_panic>
	  assert(r <= PGSIZE);
  800a5f:	68 54 23 80 00       	push   $0x802354
  800a64:	68 34 23 80 00       	push   $0x802334
  800a69:	68 a0 00 00 00       	push   $0xa0
  800a6e:	68 49 23 80 00       	push   $0x802349
  800a73:	e8 51 0a 00 00       	call   8014c9 <_panic>

00800a78 <devfile_read>:
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	56                   	push   %esi
  800a7c:	53                   	push   %ebx
  800a7d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	8b 40 0c             	mov    0xc(%eax),%eax
  800a86:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a8b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a91:	ba 00 00 00 00       	mov    $0x0,%edx
  800a96:	b8 03 00 00 00       	mov    $0x3,%eax
  800a9b:	e8 58 fe ff ff       	call   8008f8 <fsipc>
  800aa0:	89 c3                	mov    %eax,%ebx
  800aa2:	85 c0                	test   %eax,%eax
  800aa4:	78 1f                	js     800ac5 <devfile_read+0x4d>
	assert(r <= n);
  800aa6:	39 f0                	cmp    %esi,%eax
  800aa8:	77 24                	ja     800ace <devfile_read+0x56>
	assert(r <= PGSIZE);
  800aaa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aaf:	7f 33                	jg     800ae4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	50                   	push   %eax
  800ab5:	68 00 50 80 00       	push   $0x805000
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	e8 4c 12 00 00       	call   801d0e <memmove>
	return r;
  800ac2:	83 c4 10             	add    $0x10,%esp
}
  800ac5:	89 d8                	mov    %ebx,%eax
  800ac7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aca:	5b                   	pop    %ebx
  800acb:	5e                   	pop    %esi
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    
	assert(r <= n);
  800ace:	68 60 23 80 00       	push   $0x802360
  800ad3:	68 34 23 80 00       	push   $0x802334
  800ad8:	6a 7c                	push   $0x7c
  800ada:	68 49 23 80 00       	push   $0x802349
  800adf:	e8 e5 09 00 00       	call   8014c9 <_panic>
	assert(r <= PGSIZE);
  800ae4:	68 54 23 80 00       	push   $0x802354
  800ae9:	68 34 23 80 00       	push   $0x802334
  800aee:	6a 7d                	push   $0x7d
  800af0:	68 49 23 80 00       	push   $0x802349
  800af5:	e8 cf 09 00 00       	call   8014c9 <_panic>

00800afa <open>:
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	56                   	push   %esi
  800afe:	53                   	push   %ebx
  800aff:	83 ec 1c             	sub    $0x1c,%esp
  800b02:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b05:	56                   	push   %esi
  800b06:	e8 3c 10 00 00       	call   801b47 <strlen>
  800b0b:	83 c4 10             	add    $0x10,%esp
  800b0e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b13:	7f 6c                	jg     800b81 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b15:	83 ec 0c             	sub    $0xc,%esp
  800b18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b1b:	50                   	push   %eax
  800b1c:	e8 6c f8 ff ff       	call   80038d <fd_alloc>
  800b21:	89 c3                	mov    %eax,%ebx
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	85 c0                	test   %eax,%eax
  800b28:	78 3c                	js     800b66 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	56                   	push   %esi
  800b2e:	68 00 50 80 00       	push   $0x805000
  800b33:	e8 48 10 00 00       	call   801b80 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b43:	b8 01 00 00 00       	mov    $0x1,%eax
  800b48:	e8 ab fd ff ff       	call   8008f8 <fsipc>
  800b4d:	89 c3                	mov    %eax,%ebx
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	85 c0                	test   %eax,%eax
  800b54:	78 19                	js     800b6f <open+0x75>
	return fd2num(fd);
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5c:	e8 05 f8 ff ff       	call   800366 <fd2num>
  800b61:	89 c3                	mov    %eax,%ebx
  800b63:	83 c4 10             	add    $0x10,%esp
}
  800b66:	89 d8                	mov    %ebx,%eax
  800b68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    
		fd_close(fd, 0);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	6a 00                	push   $0x0
  800b74:	ff 75 f4             	pushl  -0xc(%ebp)
  800b77:	e8 0e f9 ff ff       	call   80048a <fd_close>
		return r;
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	eb e5                	jmp    800b66 <open+0x6c>
		return -E_BAD_PATH;
  800b81:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b86:	eb de                	jmp    800b66 <open+0x6c>

00800b88 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b93:	b8 08 00 00 00       	mov    $0x8,%eax
  800b98:	e8 5b fd ff ff       	call   8008f8 <fsipc>
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    

00800b9f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	56                   	push   %esi
  800ba3:	53                   	push   %ebx
  800ba4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800ba7:	83 ec 0c             	sub    $0xc,%esp
  800baa:	ff 75 08             	pushl  0x8(%ebp)
  800bad:	e8 c4 f7 ff ff       	call   800376 <fd2data>
  800bb2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bb4:	83 c4 08             	add    $0x8,%esp
  800bb7:	68 67 23 80 00       	push   $0x802367
  800bbc:	53                   	push   %ebx
  800bbd:	e8 be 0f 00 00       	call   801b80 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bc2:	8b 46 04             	mov    0x4(%esi),%eax
  800bc5:	2b 06                	sub    (%esi),%eax
  800bc7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bcd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bd4:	00 00 00 
	stat->st_dev = &devpipe;
  800bd7:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bde:	30 80 00 
	return 0;
}
  800be1:	b8 00 00 00 00       	mov    $0x0,%eax
  800be6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be9:	5b                   	pop    %ebx
  800bea:	5e                   	pop    %esi
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	53                   	push   %ebx
  800bf1:	83 ec 0c             	sub    $0xc,%esp
  800bf4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bf7:	53                   	push   %ebx
  800bf8:	6a 00                	push   $0x0
  800bfa:	e8 dc f5 ff ff       	call   8001db <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800bff:	89 1c 24             	mov    %ebx,(%esp)
  800c02:	e8 6f f7 ff ff       	call   800376 <fd2data>
  800c07:	83 c4 08             	add    $0x8,%esp
  800c0a:	50                   	push   %eax
  800c0b:	6a 00                	push   $0x0
  800c0d:	e8 c9 f5 ff ff       	call   8001db <sys_page_unmap>
}
  800c12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c15:	c9                   	leave  
  800c16:	c3                   	ret    

00800c17 <_pipeisclosed>:
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	57                   	push   %edi
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
  800c1d:	83 ec 1c             	sub    $0x1c,%esp
  800c20:	89 c7                	mov    %eax,%edi
  800c22:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c24:	a1 08 40 80 00       	mov    0x804008,%eax
  800c29:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c2c:	83 ec 0c             	sub    $0xc,%esp
  800c2f:	57                   	push   %edi
  800c30:	e8 99 13 00 00       	call   801fce <pageref>
  800c35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c38:	89 34 24             	mov    %esi,(%esp)
  800c3b:	e8 8e 13 00 00       	call   801fce <pageref>
		nn = thisenv->env_runs;
  800c40:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c46:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	39 cb                	cmp    %ecx,%ebx
  800c4e:	74 1b                	je     800c6b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c50:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c53:	75 cf                	jne    800c24 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c55:	8b 42 58             	mov    0x58(%edx),%eax
  800c58:	6a 01                	push   $0x1
  800c5a:	50                   	push   %eax
  800c5b:	53                   	push   %ebx
  800c5c:	68 6e 23 80 00       	push   $0x80236e
  800c61:	e8 3e 09 00 00       	call   8015a4 <cprintf>
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	eb b9                	jmp    800c24 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c6b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c6e:	0f 94 c0             	sete   %al
  800c71:	0f b6 c0             	movzbl %al,%eax
}
  800c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c77:	5b                   	pop    %ebx
  800c78:	5e                   	pop    %esi
  800c79:	5f                   	pop    %edi
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    

00800c7c <devpipe_write>:
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	57                   	push   %edi
  800c80:	56                   	push   %esi
  800c81:	53                   	push   %ebx
  800c82:	83 ec 28             	sub    $0x28,%esp
  800c85:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c88:	56                   	push   %esi
  800c89:	e8 e8 f6 ff ff       	call   800376 <fd2data>
  800c8e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c90:	83 c4 10             	add    $0x10,%esp
  800c93:	bf 00 00 00 00       	mov    $0x0,%edi
  800c98:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c9b:	74 4f                	je     800cec <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c9d:	8b 43 04             	mov    0x4(%ebx),%eax
  800ca0:	8b 0b                	mov    (%ebx),%ecx
  800ca2:	8d 51 20             	lea    0x20(%ecx),%edx
  800ca5:	39 d0                	cmp    %edx,%eax
  800ca7:	72 14                	jb     800cbd <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800ca9:	89 da                	mov    %ebx,%edx
  800cab:	89 f0                	mov    %esi,%eax
  800cad:	e8 65 ff ff ff       	call   800c17 <_pipeisclosed>
  800cb2:	85 c0                	test   %eax,%eax
  800cb4:	75 3b                	jne    800cf1 <devpipe_write+0x75>
			sys_yield();
  800cb6:	e8 7c f4 ff ff       	call   800137 <sys_yield>
  800cbb:	eb e0                	jmp    800c9d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cc4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cc7:	89 c2                	mov    %eax,%edx
  800cc9:	c1 fa 1f             	sar    $0x1f,%edx
  800ccc:	89 d1                	mov    %edx,%ecx
  800cce:	c1 e9 1b             	shr    $0x1b,%ecx
  800cd1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cd4:	83 e2 1f             	and    $0x1f,%edx
  800cd7:	29 ca                	sub    %ecx,%edx
  800cd9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cdd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800ce1:	83 c0 01             	add    $0x1,%eax
  800ce4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800ce7:	83 c7 01             	add    $0x1,%edi
  800cea:	eb ac                	jmp    800c98 <devpipe_write+0x1c>
	return i;
  800cec:	8b 45 10             	mov    0x10(%ebp),%eax
  800cef:	eb 05                	jmp    800cf6 <devpipe_write+0x7a>
				return 0;
  800cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf9:	5b                   	pop    %ebx
  800cfa:	5e                   	pop    %esi
  800cfb:	5f                   	pop    %edi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <devpipe_read>:
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	57                   	push   %edi
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
  800d04:	83 ec 18             	sub    $0x18,%esp
  800d07:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d0a:	57                   	push   %edi
  800d0b:	e8 66 f6 ff ff       	call   800376 <fd2data>
  800d10:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d12:	83 c4 10             	add    $0x10,%esp
  800d15:	be 00 00 00 00       	mov    $0x0,%esi
  800d1a:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d1d:	75 14                	jne    800d33 <devpipe_read+0x35>
	return i;
  800d1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d22:	eb 02                	jmp    800d26 <devpipe_read+0x28>
				return i;
  800d24:	89 f0                	mov    %esi,%eax
}
  800d26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5f                   	pop    %edi
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    
			sys_yield();
  800d2e:	e8 04 f4 ff ff       	call   800137 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d33:	8b 03                	mov    (%ebx),%eax
  800d35:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d38:	75 18                	jne    800d52 <devpipe_read+0x54>
			if (i > 0)
  800d3a:	85 f6                	test   %esi,%esi
  800d3c:	75 e6                	jne    800d24 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  800d3e:	89 da                	mov    %ebx,%edx
  800d40:	89 f8                	mov    %edi,%eax
  800d42:	e8 d0 fe ff ff       	call   800c17 <_pipeisclosed>
  800d47:	85 c0                	test   %eax,%eax
  800d49:	74 e3                	je     800d2e <devpipe_read+0x30>
				return 0;
  800d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d50:	eb d4                	jmp    800d26 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d52:	99                   	cltd   
  800d53:	c1 ea 1b             	shr    $0x1b,%edx
  800d56:	01 d0                	add    %edx,%eax
  800d58:	83 e0 1f             	and    $0x1f,%eax
  800d5b:	29 d0                	sub    %edx,%eax
  800d5d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d65:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d68:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d6b:	83 c6 01             	add    $0x1,%esi
  800d6e:	eb aa                	jmp    800d1a <devpipe_read+0x1c>

00800d70 <pipe>:
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	56                   	push   %esi
  800d74:	53                   	push   %ebx
  800d75:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d7b:	50                   	push   %eax
  800d7c:	e8 0c f6 ff ff       	call   80038d <fd_alloc>
  800d81:	89 c3                	mov    %eax,%ebx
  800d83:	83 c4 10             	add    $0x10,%esp
  800d86:	85 c0                	test   %eax,%eax
  800d88:	0f 88 23 01 00 00    	js     800eb1 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d8e:	83 ec 04             	sub    $0x4,%esp
  800d91:	68 07 04 00 00       	push   $0x407
  800d96:	ff 75 f4             	pushl  -0xc(%ebp)
  800d99:	6a 00                	push   $0x0
  800d9b:	e8 b6 f3 ff ff       	call   800156 <sys_page_alloc>
  800da0:	89 c3                	mov    %eax,%ebx
  800da2:	83 c4 10             	add    $0x10,%esp
  800da5:	85 c0                	test   %eax,%eax
  800da7:	0f 88 04 01 00 00    	js     800eb1 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800db3:	50                   	push   %eax
  800db4:	e8 d4 f5 ff ff       	call   80038d <fd_alloc>
  800db9:	89 c3                	mov    %eax,%ebx
  800dbb:	83 c4 10             	add    $0x10,%esp
  800dbe:	85 c0                	test   %eax,%eax
  800dc0:	0f 88 db 00 00 00    	js     800ea1 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dc6:	83 ec 04             	sub    $0x4,%esp
  800dc9:	68 07 04 00 00       	push   $0x407
  800dce:	ff 75 f0             	pushl  -0x10(%ebp)
  800dd1:	6a 00                	push   $0x0
  800dd3:	e8 7e f3 ff ff       	call   800156 <sys_page_alloc>
  800dd8:	89 c3                	mov    %eax,%ebx
  800dda:	83 c4 10             	add    $0x10,%esp
  800ddd:	85 c0                	test   %eax,%eax
  800ddf:	0f 88 bc 00 00 00    	js     800ea1 <pipe+0x131>
	va = fd2data(fd0);
  800de5:	83 ec 0c             	sub    $0xc,%esp
  800de8:	ff 75 f4             	pushl  -0xc(%ebp)
  800deb:	e8 86 f5 ff ff       	call   800376 <fd2data>
  800df0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800df2:	83 c4 0c             	add    $0xc,%esp
  800df5:	68 07 04 00 00       	push   $0x407
  800dfa:	50                   	push   %eax
  800dfb:	6a 00                	push   $0x0
  800dfd:	e8 54 f3 ff ff       	call   800156 <sys_page_alloc>
  800e02:	89 c3                	mov    %eax,%ebx
  800e04:	83 c4 10             	add    $0x10,%esp
  800e07:	85 c0                	test   %eax,%eax
  800e09:	0f 88 82 00 00 00    	js     800e91 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e0f:	83 ec 0c             	sub    $0xc,%esp
  800e12:	ff 75 f0             	pushl  -0x10(%ebp)
  800e15:	e8 5c f5 ff ff       	call   800376 <fd2data>
  800e1a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e21:	50                   	push   %eax
  800e22:	6a 00                	push   $0x0
  800e24:	56                   	push   %esi
  800e25:	6a 00                	push   $0x0
  800e27:	e8 6d f3 ff ff       	call   800199 <sys_page_map>
  800e2c:	89 c3                	mov    %eax,%ebx
  800e2e:	83 c4 20             	add    $0x20,%esp
  800e31:	85 c0                	test   %eax,%eax
  800e33:	78 4e                	js     800e83 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  800e35:	a1 20 30 80 00       	mov    0x803020,%eax
  800e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e42:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e4c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e51:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e58:	83 ec 0c             	sub    $0xc,%esp
  800e5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e5e:	e8 03 f5 ff ff       	call   800366 <fd2num>
  800e63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e66:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e68:	83 c4 04             	add    $0x4,%esp
  800e6b:	ff 75 f0             	pushl  -0x10(%ebp)
  800e6e:	e8 f3 f4 ff ff       	call   800366 <fd2num>
  800e73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e76:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e79:	83 c4 10             	add    $0x10,%esp
  800e7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e81:	eb 2e                	jmp    800eb1 <pipe+0x141>
	sys_page_unmap(0, va);
  800e83:	83 ec 08             	sub    $0x8,%esp
  800e86:	56                   	push   %esi
  800e87:	6a 00                	push   $0x0
  800e89:	e8 4d f3 ff ff       	call   8001db <sys_page_unmap>
  800e8e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e91:	83 ec 08             	sub    $0x8,%esp
  800e94:	ff 75 f0             	pushl  -0x10(%ebp)
  800e97:	6a 00                	push   $0x0
  800e99:	e8 3d f3 ff ff       	call   8001db <sys_page_unmap>
  800e9e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea7:	6a 00                	push   $0x0
  800ea9:	e8 2d f3 ff ff       	call   8001db <sys_page_unmap>
  800eae:	83 c4 10             	add    $0x10,%esp
}
  800eb1:	89 d8                	mov    %ebx,%eax
  800eb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eb6:	5b                   	pop    %ebx
  800eb7:	5e                   	pop    %esi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    

00800eba <pipeisclosed>:
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ec0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ec3:	50                   	push   %eax
  800ec4:	ff 75 08             	pushl  0x8(%ebp)
  800ec7:	e8 13 f5 ff ff       	call   8003df <fd_lookup>
  800ecc:	83 c4 10             	add    $0x10,%esp
  800ecf:	85 c0                	test   %eax,%eax
  800ed1:	78 18                	js     800eeb <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ed3:	83 ec 0c             	sub    $0xc,%esp
  800ed6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed9:	e8 98 f4 ff ff       	call   800376 <fd2data>
	return _pipeisclosed(fd, p);
  800ede:	89 c2                	mov    %eax,%edx
  800ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee3:	e8 2f fd ff ff       	call   800c17 <_pipeisclosed>
  800ee8:	83 c4 10             	add    $0x10,%esp
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    

00800eed <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800ef3:	68 86 23 80 00       	push   $0x802386
  800ef8:	ff 75 0c             	pushl  0xc(%ebp)
  800efb:	e8 80 0c 00 00       	call   801b80 <strcpy>
	return 0;
}
  800f00:	b8 00 00 00 00       	mov    $0x0,%eax
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <devsock_close>:
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	53                   	push   %ebx
  800f0b:	83 ec 10             	sub    $0x10,%esp
  800f0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f11:	53                   	push   %ebx
  800f12:	e8 b7 10 00 00       	call   801fce <pageref>
  800f17:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f1a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f1f:	83 f8 01             	cmp    $0x1,%eax
  800f22:	74 07                	je     800f2b <devsock_close+0x24>
}
  800f24:	89 d0                	mov    %edx,%eax
  800f26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f2b:	83 ec 0c             	sub    $0xc,%esp
  800f2e:	ff 73 0c             	pushl  0xc(%ebx)
  800f31:	e8 b9 02 00 00       	call   8011ef <nsipc_close>
  800f36:	89 c2                	mov    %eax,%edx
  800f38:	83 c4 10             	add    $0x10,%esp
  800f3b:	eb e7                	jmp    800f24 <devsock_close+0x1d>

00800f3d <devsock_write>:
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f43:	6a 00                	push   $0x0
  800f45:	ff 75 10             	pushl  0x10(%ebp)
  800f48:	ff 75 0c             	pushl  0xc(%ebp)
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	ff 70 0c             	pushl  0xc(%eax)
  800f51:	e8 76 03 00 00       	call   8012cc <nsipc_send>
}
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <devsock_read>:
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f5e:	6a 00                	push   $0x0
  800f60:	ff 75 10             	pushl  0x10(%ebp)
  800f63:	ff 75 0c             	pushl  0xc(%ebp)
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	ff 70 0c             	pushl  0xc(%eax)
  800f6c:	e8 ef 02 00 00       	call   801260 <nsipc_recv>
}
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <fd2sockid>:
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f79:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f7c:	52                   	push   %edx
  800f7d:	50                   	push   %eax
  800f7e:	e8 5c f4 ff ff       	call   8003df <fd_lookup>
  800f83:	83 c4 10             	add    $0x10,%esp
  800f86:	85 c0                	test   %eax,%eax
  800f88:	78 10                	js     800f9a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f8d:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800f93:	39 08                	cmp    %ecx,(%eax)
  800f95:	75 05                	jne    800f9c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800f97:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    
		return -E_NOT_SUPP;
  800f9c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800fa1:	eb f7                	jmp    800f9a <fd2sockid+0x27>

00800fa3 <alloc_sockfd>:
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	56                   	push   %esi
  800fa7:	53                   	push   %ebx
  800fa8:	83 ec 1c             	sub    $0x1c,%esp
  800fab:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fb0:	50                   	push   %eax
  800fb1:	e8 d7 f3 ff ff       	call   80038d <fd_alloc>
  800fb6:	89 c3                	mov    %eax,%ebx
  800fb8:	83 c4 10             	add    $0x10,%esp
  800fbb:	85 c0                	test   %eax,%eax
  800fbd:	78 43                	js     801002 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fbf:	83 ec 04             	sub    $0x4,%esp
  800fc2:	68 07 04 00 00       	push   $0x407
  800fc7:	ff 75 f4             	pushl  -0xc(%ebp)
  800fca:	6a 00                	push   $0x0
  800fcc:	e8 85 f1 ff ff       	call   800156 <sys_page_alloc>
  800fd1:	89 c3                	mov    %eax,%ebx
  800fd3:	83 c4 10             	add    $0x10,%esp
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	78 28                	js     801002 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fdd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fe3:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800fef:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800ff2:	83 ec 0c             	sub    $0xc,%esp
  800ff5:	50                   	push   %eax
  800ff6:	e8 6b f3 ff ff       	call   800366 <fd2num>
  800ffb:	89 c3                	mov    %eax,%ebx
  800ffd:	83 c4 10             	add    $0x10,%esp
  801000:	eb 0c                	jmp    80100e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801002:	83 ec 0c             	sub    $0xc,%esp
  801005:	56                   	push   %esi
  801006:	e8 e4 01 00 00       	call   8011ef <nsipc_close>
		return r;
  80100b:	83 c4 10             	add    $0x10,%esp
}
  80100e:	89 d8                	mov    %ebx,%eax
  801010:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801013:	5b                   	pop    %ebx
  801014:	5e                   	pop    %esi
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    

00801017 <accept>:
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	e8 4e ff ff ff       	call   800f73 <fd2sockid>
  801025:	85 c0                	test   %eax,%eax
  801027:	78 1b                	js     801044 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801029:	83 ec 04             	sub    $0x4,%esp
  80102c:	ff 75 10             	pushl  0x10(%ebp)
  80102f:	ff 75 0c             	pushl  0xc(%ebp)
  801032:	50                   	push   %eax
  801033:	e8 0e 01 00 00       	call   801146 <nsipc_accept>
  801038:	83 c4 10             	add    $0x10,%esp
  80103b:	85 c0                	test   %eax,%eax
  80103d:	78 05                	js     801044 <accept+0x2d>
	return alloc_sockfd(r);
  80103f:	e8 5f ff ff ff       	call   800fa3 <alloc_sockfd>
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <bind>:
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	e8 1f ff ff ff       	call   800f73 <fd2sockid>
  801054:	85 c0                	test   %eax,%eax
  801056:	78 12                	js     80106a <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801058:	83 ec 04             	sub    $0x4,%esp
  80105b:	ff 75 10             	pushl  0x10(%ebp)
  80105e:	ff 75 0c             	pushl  0xc(%ebp)
  801061:	50                   	push   %eax
  801062:	e8 31 01 00 00       	call   801198 <nsipc_bind>
  801067:	83 c4 10             	add    $0x10,%esp
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <shutdown>:
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	e8 f9 fe ff ff       	call   800f73 <fd2sockid>
  80107a:	85 c0                	test   %eax,%eax
  80107c:	78 0f                	js     80108d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80107e:	83 ec 08             	sub    $0x8,%esp
  801081:	ff 75 0c             	pushl  0xc(%ebp)
  801084:	50                   	push   %eax
  801085:	e8 43 01 00 00       	call   8011cd <nsipc_shutdown>
  80108a:	83 c4 10             	add    $0x10,%esp
}
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <connect>:
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	e8 d6 fe ff ff       	call   800f73 <fd2sockid>
  80109d:	85 c0                	test   %eax,%eax
  80109f:	78 12                	js     8010b3 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8010a1:	83 ec 04             	sub    $0x4,%esp
  8010a4:	ff 75 10             	pushl  0x10(%ebp)
  8010a7:	ff 75 0c             	pushl  0xc(%ebp)
  8010aa:	50                   	push   %eax
  8010ab:	e8 59 01 00 00       	call   801209 <nsipc_connect>
  8010b0:	83 c4 10             	add    $0x10,%esp
}
  8010b3:	c9                   	leave  
  8010b4:	c3                   	ret    

008010b5 <listen>:
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	e8 b0 fe ff ff       	call   800f73 <fd2sockid>
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	78 0f                	js     8010d6 <listen+0x21>
	return nsipc_listen(r, backlog);
  8010c7:	83 ec 08             	sub    $0x8,%esp
  8010ca:	ff 75 0c             	pushl  0xc(%ebp)
  8010cd:	50                   	push   %eax
  8010ce:	e8 6b 01 00 00       	call   80123e <nsipc_listen>
  8010d3:	83 c4 10             	add    $0x10,%esp
}
  8010d6:	c9                   	leave  
  8010d7:	c3                   	ret    

008010d8 <socket>:

int
socket(int domain, int type, int protocol)
{
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
  8010db:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010de:	ff 75 10             	pushl  0x10(%ebp)
  8010e1:	ff 75 0c             	pushl  0xc(%ebp)
  8010e4:	ff 75 08             	pushl  0x8(%ebp)
  8010e7:	e8 3e 02 00 00       	call   80132a <nsipc_socket>
  8010ec:	83 c4 10             	add    $0x10,%esp
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	78 05                	js     8010f8 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8010f3:	e8 ab fe ff ff       	call   800fa3 <alloc_sockfd>
}
  8010f8:	c9                   	leave  
  8010f9:	c3                   	ret    

008010fa <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	53                   	push   %ebx
  8010fe:	83 ec 04             	sub    $0x4,%esp
  801101:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801103:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80110a:	74 26                	je     801132 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80110c:	6a 07                	push   $0x7
  80110e:	68 00 60 80 00       	push   $0x806000
  801113:	53                   	push   %ebx
  801114:	ff 35 04 40 80 00    	pushl  0x804004
  80111a:	e8 0a 0e 00 00       	call   801f29 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80111f:	83 c4 0c             	add    $0xc,%esp
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	6a 00                	push   $0x0
  801128:	e8 89 0d 00 00       	call   801eb6 <ipc_recv>
}
  80112d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801130:	c9                   	leave  
  801131:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801132:	83 ec 0c             	sub    $0xc,%esp
  801135:	6a 02                	push   $0x2
  801137:	e8 59 0e 00 00       	call   801f95 <ipc_find_env>
  80113c:	a3 04 40 80 00       	mov    %eax,0x804004
  801141:	83 c4 10             	add    $0x10,%esp
  801144:	eb c6                	jmp    80110c <nsipc+0x12>

00801146 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	56                   	push   %esi
  80114a:	53                   	push   %ebx
  80114b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801156:	8b 06                	mov    (%esi),%eax
  801158:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80115d:	b8 01 00 00 00       	mov    $0x1,%eax
  801162:	e8 93 ff ff ff       	call   8010fa <nsipc>
  801167:	89 c3                	mov    %eax,%ebx
  801169:	85 c0                	test   %eax,%eax
  80116b:	79 09                	jns    801176 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80116d:	89 d8                	mov    %ebx,%eax
  80116f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801172:	5b                   	pop    %ebx
  801173:	5e                   	pop    %esi
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801176:	83 ec 04             	sub    $0x4,%esp
  801179:	ff 35 10 60 80 00    	pushl  0x806010
  80117f:	68 00 60 80 00       	push   $0x806000
  801184:	ff 75 0c             	pushl  0xc(%ebp)
  801187:	e8 82 0b 00 00       	call   801d0e <memmove>
		*addrlen = ret->ret_addrlen;
  80118c:	a1 10 60 80 00       	mov    0x806010,%eax
  801191:	89 06                	mov    %eax,(%esi)
  801193:	83 c4 10             	add    $0x10,%esp
	return r;
  801196:	eb d5                	jmp    80116d <nsipc_accept+0x27>

00801198 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	53                   	push   %ebx
  80119c:	83 ec 08             	sub    $0x8,%esp
  80119f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011aa:	53                   	push   %ebx
  8011ab:	ff 75 0c             	pushl  0xc(%ebp)
  8011ae:	68 04 60 80 00       	push   $0x806004
  8011b3:	e8 56 0b 00 00       	call   801d0e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011b8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011be:	b8 02 00 00 00       	mov    $0x2,%eax
  8011c3:	e8 32 ff ff ff       	call   8010fa <nsipc>
}
  8011c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cb:	c9                   	leave  
  8011cc:	c3                   	ret    

008011cd <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011de:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011e3:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e8:	e8 0d ff ff ff       	call   8010fa <nsipc>
}
  8011ed:	c9                   	leave  
  8011ee:	c3                   	ret    

008011ef <nsipc_close>:

int
nsipc_close(int s)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8011fd:	b8 04 00 00 00       	mov    $0x4,%eax
  801202:	e8 f3 fe ff ff       	call   8010fa <nsipc>
}
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	53                   	push   %ebx
  80120d:	83 ec 08             	sub    $0x8,%esp
  801210:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80121b:	53                   	push   %ebx
  80121c:	ff 75 0c             	pushl  0xc(%ebp)
  80121f:	68 04 60 80 00       	push   $0x806004
  801224:	e8 e5 0a 00 00       	call   801d0e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801229:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80122f:	b8 05 00 00 00       	mov    $0x5,%eax
  801234:	e8 c1 fe ff ff       	call   8010fa <nsipc>
}
  801239:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801254:	b8 06 00 00 00       	mov    $0x6,%eax
  801259:	e8 9c fe ff ff       	call   8010fa <nsipc>
}
  80125e:	c9                   	leave  
  80125f:	c3                   	ret    

00801260 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
  801263:	56                   	push   %esi
  801264:	53                   	push   %ebx
  801265:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801270:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801276:	8b 45 14             	mov    0x14(%ebp),%eax
  801279:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80127e:	b8 07 00 00 00       	mov    $0x7,%eax
  801283:	e8 72 fe ff ff       	call   8010fa <nsipc>
  801288:	89 c3                	mov    %eax,%ebx
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 1f                	js     8012ad <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80128e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801293:	7f 21                	jg     8012b6 <nsipc_recv+0x56>
  801295:	39 c6                	cmp    %eax,%esi
  801297:	7c 1d                	jl     8012b6 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801299:	83 ec 04             	sub    $0x4,%esp
  80129c:	50                   	push   %eax
  80129d:	68 00 60 80 00       	push   $0x806000
  8012a2:	ff 75 0c             	pushl  0xc(%ebp)
  8012a5:	e8 64 0a 00 00       	call   801d0e <memmove>
  8012aa:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012ad:	89 d8                	mov    %ebx,%eax
  8012af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012b2:	5b                   	pop    %ebx
  8012b3:	5e                   	pop    %esi
  8012b4:	5d                   	pop    %ebp
  8012b5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012b6:	68 92 23 80 00       	push   $0x802392
  8012bb:	68 34 23 80 00       	push   $0x802334
  8012c0:	6a 62                	push   $0x62
  8012c2:	68 a7 23 80 00       	push   $0x8023a7
  8012c7:	e8 fd 01 00 00       	call   8014c9 <_panic>

008012cc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	53                   	push   %ebx
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012de:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012e4:	7f 2e                	jg     801314 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012e6:	83 ec 04             	sub    $0x4,%esp
  8012e9:	53                   	push   %ebx
  8012ea:	ff 75 0c             	pushl  0xc(%ebp)
  8012ed:	68 0c 60 80 00       	push   $0x80600c
  8012f2:	e8 17 0a 00 00       	call   801d0e <memmove>
	nsipcbuf.send.req_size = size;
  8012f7:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801300:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801305:	b8 08 00 00 00       	mov    $0x8,%eax
  80130a:	e8 eb fd ff ff       	call   8010fa <nsipc>
}
  80130f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801312:	c9                   	leave  
  801313:	c3                   	ret    
	assert(size < 1600);
  801314:	68 b3 23 80 00       	push   $0x8023b3
  801319:	68 34 23 80 00       	push   $0x802334
  80131e:	6a 6d                	push   $0x6d
  801320:	68 a7 23 80 00       	push   $0x8023a7
  801325:	e8 9f 01 00 00       	call   8014c9 <_panic>

0080132a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801338:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801348:	b8 09 00 00 00       	mov    $0x9,%eax
  80134d:	e8 a8 fd ff ff       	call   8010fa <nsipc>
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801354:	b8 00 00 00 00       	mov    $0x0,%eax
  801359:	c3                   	ret    

0080135a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801360:	68 bf 23 80 00       	push   $0x8023bf
  801365:	ff 75 0c             	pushl  0xc(%ebp)
  801368:	e8 13 08 00 00       	call   801b80 <strcpy>
	return 0;
}
  80136d:	b8 00 00 00 00       	mov    $0x0,%eax
  801372:	c9                   	leave  
  801373:	c3                   	ret    

00801374 <devcons_write>:
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
  801377:	57                   	push   %edi
  801378:	56                   	push   %esi
  801379:	53                   	push   %ebx
  80137a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801380:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801385:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80138b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80138e:	73 31                	jae    8013c1 <devcons_write+0x4d>
		m = n - tot;
  801390:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801393:	29 f3                	sub    %esi,%ebx
  801395:	83 fb 7f             	cmp    $0x7f,%ebx
  801398:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80139d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013a0:	83 ec 04             	sub    $0x4,%esp
  8013a3:	53                   	push   %ebx
  8013a4:	89 f0                	mov    %esi,%eax
  8013a6:	03 45 0c             	add    0xc(%ebp),%eax
  8013a9:	50                   	push   %eax
  8013aa:	57                   	push   %edi
  8013ab:	e8 5e 09 00 00       	call   801d0e <memmove>
		sys_cputs(buf, m);
  8013b0:	83 c4 08             	add    $0x8,%esp
  8013b3:	53                   	push   %ebx
  8013b4:	57                   	push   %edi
  8013b5:	e8 e0 ec ff ff       	call   80009a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013ba:	01 de                	add    %ebx,%esi
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	eb ca                	jmp    80138b <devcons_write+0x17>
}
  8013c1:	89 f0                	mov    %esi,%eax
  8013c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c6:	5b                   	pop    %ebx
  8013c7:	5e                   	pop    %esi
  8013c8:	5f                   	pop    %edi
  8013c9:	5d                   	pop    %ebp
  8013ca:	c3                   	ret    

008013cb <devcons_read>:
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	83 ec 08             	sub    $0x8,%esp
  8013d1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013da:	74 21                	je     8013fd <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8013dc:	e8 d7 ec ff ff       	call   8000b8 <sys_cgetc>
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	75 07                	jne    8013ec <devcons_read+0x21>
		sys_yield();
  8013e5:	e8 4d ed ff ff       	call   800137 <sys_yield>
  8013ea:	eb f0                	jmp    8013dc <devcons_read+0x11>
	if (c < 0)
  8013ec:	78 0f                	js     8013fd <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8013ee:	83 f8 04             	cmp    $0x4,%eax
  8013f1:	74 0c                	je     8013ff <devcons_read+0x34>
	*(char*)vbuf = c;
  8013f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f6:	88 02                	mov    %al,(%edx)
	return 1;
  8013f8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    
		return 0;
  8013ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801404:	eb f7                	jmp    8013fd <devcons_read+0x32>

00801406 <cputchar>:
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801412:	6a 01                	push   $0x1
  801414:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801417:	50                   	push   %eax
  801418:	e8 7d ec ff ff       	call   80009a <sys_cputs>
}
  80141d:	83 c4 10             	add    $0x10,%esp
  801420:	c9                   	leave  
  801421:	c3                   	ret    

00801422 <getchar>:
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801428:	6a 01                	push   $0x1
  80142a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80142d:	50                   	push   %eax
  80142e:	6a 00                	push   $0x0
  801430:	e8 1a f2 ff ff       	call   80064f <read>
	if (r < 0)
  801435:	83 c4 10             	add    $0x10,%esp
  801438:	85 c0                	test   %eax,%eax
  80143a:	78 06                	js     801442 <getchar+0x20>
	if (r < 1)
  80143c:	74 06                	je     801444 <getchar+0x22>
	return c;
  80143e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    
		return -E_EOF;
  801444:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801449:	eb f7                	jmp    801442 <getchar+0x20>

0080144b <iscons>:
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801451:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801454:	50                   	push   %eax
  801455:	ff 75 08             	pushl  0x8(%ebp)
  801458:	e8 82 ef ff ff       	call   8003df <fd_lookup>
  80145d:	83 c4 10             	add    $0x10,%esp
  801460:	85 c0                	test   %eax,%eax
  801462:	78 11                	js     801475 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801467:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80146d:	39 10                	cmp    %edx,(%eax)
  80146f:	0f 94 c0             	sete   %al
  801472:	0f b6 c0             	movzbl %al,%eax
}
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <opencons>:
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80147d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801480:	50                   	push   %eax
  801481:	e8 07 ef ff ff       	call   80038d <fd_alloc>
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	85 c0                	test   %eax,%eax
  80148b:	78 3a                	js     8014c7 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	68 07 04 00 00       	push   $0x407
  801495:	ff 75 f4             	pushl  -0xc(%ebp)
  801498:	6a 00                	push   $0x0
  80149a:	e8 b7 ec ff ff       	call   800156 <sys_page_alloc>
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	78 21                	js     8014c7 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014af:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014bb:	83 ec 0c             	sub    $0xc,%esp
  8014be:	50                   	push   %eax
  8014bf:	e8 a2 ee ff ff       	call   800366 <fd2num>
  8014c4:	83 c4 10             	add    $0x10,%esp
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	56                   	push   %esi
  8014cd:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014ce:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014d1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014d7:	e8 3c ec ff ff       	call   800118 <sys_getenvid>
  8014dc:	83 ec 0c             	sub    $0xc,%esp
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	ff 75 08             	pushl  0x8(%ebp)
  8014e5:	56                   	push   %esi
  8014e6:	50                   	push   %eax
  8014e7:	68 cc 23 80 00       	push   $0x8023cc
  8014ec:	e8 b3 00 00 00       	call   8015a4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014f1:	83 c4 18             	add    $0x18,%esp
  8014f4:	53                   	push   %ebx
  8014f5:	ff 75 10             	pushl  0x10(%ebp)
  8014f8:	e8 56 00 00 00       	call   801553 <vcprintf>
	cprintf("\n");
  8014fd:	c7 04 24 7f 23 80 00 	movl   $0x80237f,(%esp)
  801504:	e8 9b 00 00 00       	call   8015a4 <cprintf>
  801509:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80150c:	cc                   	int3   
  80150d:	eb fd                	jmp    80150c <_panic+0x43>

0080150f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	53                   	push   %ebx
  801513:	83 ec 04             	sub    $0x4,%esp
  801516:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801519:	8b 13                	mov    (%ebx),%edx
  80151b:	8d 42 01             	lea    0x1(%edx),%eax
  80151e:	89 03                	mov    %eax,(%ebx)
  801520:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801523:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801527:	3d ff 00 00 00       	cmp    $0xff,%eax
  80152c:	74 09                	je     801537 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80152e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801532:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801535:	c9                   	leave  
  801536:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801537:	83 ec 08             	sub    $0x8,%esp
  80153a:	68 ff 00 00 00       	push   $0xff
  80153f:	8d 43 08             	lea    0x8(%ebx),%eax
  801542:	50                   	push   %eax
  801543:	e8 52 eb ff ff       	call   80009a <sys_cputs>
		b->idx = 0;
  801548:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	eb db                	jmp    80152e <putch+0x1f>

00801553 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80155c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801563:	00 00 00 
	b.cnt = 0;
  801566:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80156d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801570:	ff 75 0c             	pushl  0xc(%ebp)
  801573:	ff 75 08             	pushl  0x8(%ebp)
  801576:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80157c:	50                   	push   %eax
  80157d:	68 0f 15 80 00       	push   $0x80150f
  801582:	e8 19 01 00 00       	call   8016a0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801587:	83 c4 08             	add    $0x8,%esp
  80158a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801590:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801596:	50                   	push   %eax
  801597:	e8 fe ea ff ff       	call   80009a <sys_cputs>

	return b.cnt;
}
  80159c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015aa:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015ad:	50                   	push   %eax
  8015ae:	ff 75 08             	pushl  0x8(%ebp)
  8015b1:	e8 9d ff ff ff       	call   801553 <vcprintf>
	va_end(ap);

	return cnt;
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	57                   	push   %edi
  8015bc:	56                   	push   %esi
  8015bd:	53                   	push   %ebx
  8015be:	83 ec 1c             	sub    $0x1c,%esp
  8015c1:	89 c7                	mov    %eax,%edi
  8015c3:	89 d6                	mov    %edx,%esi
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015dc:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015df:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015e2:	89 d0                	mov    %edx,%eax
  8015e4:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8015e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015ea:	73 15                	jae    801601 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015ec:	83 eb 01             	sub    $0x1,%ebx
  8015ef:	85 db                	test   %ebx,%ebx
  8015f1:	7e 43                	jle    801636 <printnum+0x7e>
			putch(padc, putdat);
  8015f3:	83 ec 08             	sub    $0x8,%esp
  8015f6:	56                   	push   %esi
  8015f7:	ff 75 18             	pushl  0x18(%ebp)
  8015fa:	ff d7                	call   *%edi
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	eb eb                	jmp    8015ec <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	ff 75 18             	pushl  0x18(%ebp)
  801607:	8b 45 14             	mov    0x14(%ebp),%eax
  80160a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80160d:	53                   	push   %ebx
  80160e:	ff 75 10             	pushl  0x10(%ebp)
  801611:	83 ec 08             	sub    $0x8,%esp
  801614:	ff 75 e4             	pushl  -0x1c(%ebp)
  801617:	ff 75 e0             	pushl  -0x20(%ebp)
  80161a:	ff 75 dc             	pushl  -0x24(%ebp)
  80161d:	ff 75 d8             	pushl  -0x28(%ebp)
  801620:	e8 eb 09 00 00       	call   802010 <__udivdi3>
  801625:	83 c4 18             	add    $0x18,%esp
  801628:	52                   	push   %edx
  801629:	50                   	push   %eax
  80162a:	89 f2                	mov    %esi,%edx
  80162c:	89 f8                	mov    %edi,%eax
  80162e:	e8 85 ff ff ff       	call   8015b8 <printnum>
  801633:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801636:	83 ec 08             	sub    $0x8,%esp
  801639:	56                   	push   %esi
  80163a:	83 ec 04             	sub    $0x4,%esp
  80163d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801640:	ff 75 e0             	pushl  -0x20(%ebp)
  801643:	ff 75 dc             	pushl  -0x24(%ebp)
  801646:	ff 75 d8             	pushl  -0x28(%ebp)
  801649:	e8 d2 0a 00 00       	call   802120 <__umoddi3>
  80164e:	83 c4 14             	add    $0x14,%esp
  801651:	0f be 80 ef 23 80 00 	movsbl 0x8023ef(%eax),%eax
  801658:	50                   	push   %eax
  801659:	ff d7                	call   *%edi
}
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801661:	5b                   	pop    %ebx
  801662:	5e                   	pop    %esi
  801663:	5f                   	pop    %edi
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    

00801666 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80166c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801670:	8b 10                	mov    (%eax),%edx
  801672:	3b 50 04             	cmp    0x4(%eax),%edx
  801675:	73 0a                	jae    801681 <sprintputch+0x1b>
		*b->buf++ = ch;
  801677:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167a:	89 08                	mov    %ecx,(%eax)
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	88 02                	mov    %al,(%edx)
}
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <printfmt>:
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801689:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80168c:	50                   	push   %eax
  80168d:	ff 75 10             	pushl  0x10(%ebp)
  801690:	ff 75 0c             	pushl  0xc(%ebp)
  801693:	ff 75 08             	pushl  0x8(%ebp)
  801696:	e8 05 00 00 00       	call   8016a0 <vprintfmt>
}
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <vprintfmt>:
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	57                   	push   %edi
  8016a4:	56                   	push   %esi
  8016a5:	53                   	push   %ebx
  8016a6:	83 ec 3c             	sub    $0x3c,%esp
  8016a9:	8b 75 08             	mov    0x8(%ebp),%esi
  8016ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016af:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016b2:	eb 0a                	jmp    8016be <vprintfmt+0x1e>
			putch(ch, putdat);
  8016b4:	83 ec 08             	sub    $0x8,%esp
  8016b7:	53                   	push   %ebx
  8016b8:	50                   	push   %eax
  8016b9:	ff d6                	call   *%esi
  8016bb:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016be:	83 c7 01             	add    $0x1,%edi
  8016c1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016c5:	83 f8 25             	cmp    $0x25,%eax
  8016c8:	74 0c                	je     8016d6 <vprintfmt+0x36>
			if (ch == '\0')
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	75 e6                	jne    8016b4 <vprintfmt+0x14>
}
  8016ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d1:	5b                   	pop    %ebx
  8016d2:	5e                   	pop    %esi
  8016d3:	5f                   	pop    %edi
  8016d4:	5d                   	pop    %ebp
  8016d5:	c3                   	ret    
		padc = ' ';
  8016d6:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8016da:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8016e1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8016e8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016ef:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016f4:	8d 47 01             	lea    0x1(%edi),%eax
  8016f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016fa:	0f b6 17             	movzbl (%edi),%edx
  8016fd:	8d 42 dd             	lea    -0x23(%edx),%eax
  801700:	3c 55                	cmp    $0x55,%al
  801702:	0f 87 ba 03 00 00    	ja     801ac2 <vprintfmt+0x422>
  801708:	0f b6 c0             	movzbl %al,%eax
  80170b:	ff 24 85 40 25 80 00 	jmp    *0x802540(,%eax,4)
  801712:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801715:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801719:	eb d9                	jmp    8016f4 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80171b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80171e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801722:	eb d0                	jmp    8016f4 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801724:	0f b6 d2             	movzbl %dl,%edx
  801727:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80172a:	b8 00 00 00 00       	mov    $0x0,%eax
  80172f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801732:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801735:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801739:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80173c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80173f:	83 f9 09             	cmp    $0x9,%ecx
  801742:	77 55                	ja     801799 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  801744:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801747:	eb e9                	jmp    801732 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  801749:	8b 45 14             	mov    0x14(%ebp),%eax
  80174c:	8b 00                	mov    (%eax),%eax
  80174e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801751:	8b 45 14             	mov    0x14(%ebp),%eax
  801754:	8d 40 04             	lea    0x4(%eax),%eax
  801757:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80175a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80175d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801761:	79 91                	jns    8016f4 <vprintfmt+0x54>
				width = precision, precision = -1;
  801763:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801766:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801769:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801770:	eb 82                	jmp    8016f4 <vprintfmt+0x54>
  801772:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801775:	85 c0                	test   %eax,%eax
  801777:	ba 00 00 00 00       	mov    $0x0,%edx
  80177c:	0f 49 d0             	cmovns %eax,%edx
  80177f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801782:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801785:	e9 6a ff ff ff       	jmp    8016f4 <vprintfmt+0x54>
  80178a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80178d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801794:	e9 5b ff ff ff       	jmp    8016f4 <vprintfmt+0x54>
  801799:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80179c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80179f:	eb bc                	jmp    80175d <vprintfmt+0xbd>
			lflag++;
  8017a1:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017a7:	e9 48 ff ff ff       	jmp    8016f4 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8017ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8017af:	8d 78 04             	lea    0x4(%eax),%edi
  8017b2:	83 ec 08             	sub    $0x8,%esp
  8017b5:	53                   	push   %ebx
  8017b6:	ff 30                	pushl  (%eax)
  8017b8:	ff d6                	call   *%esi
			break;
  8017ba:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017bd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017c0:	e9 9c 02 00 00       	jmp    801a61 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8017c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c8:	8d 78 04             	lea    0x4(%eax),%edi
  8017cb:	8b 00                	mov    (%eax),%eax
  8017cd:	99                   	cltd   
  8017ce:	31 d0                	xor    %edx,%eax
  8017d0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017d2:	83 f8 0f             	cmp    $0xf,%eax
  8017d5:	7f 23                	jg     8017fa <vprintfmt+0x15a>
  8017d7:	8b 14 85 a0 26 80 00 	mov    0x8026a0(,%eax,4),%edx
  8017de:	85 d2                	test   %edx,%edx
  8017e0:	74 18                	je     8017fa <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8017e2:	52                   	push   %edx
  8017e3:	68 46 23 80 00       	push   $0x802346
  8017e8:	53                   	push   %ebx
  8017e9:	56                   	push   %esi
  8017ea:	e8 94 fe ff ff       	call   801683 <printfmt>
  8017ef:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017f2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017f5:	e9 67 02 00 00       	jmp    801a61 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8017fa:	50                   	push   %eax
  8017fb:	68 07 24 80 00       	push   $0x802407
  801800:	53                   	push   %ebx
  801801:	56                   	push   %esi
  801802:	e8 7c fe ff ff       	call   801683 <printfmt>
  801807:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80180a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80180d:	e9 4f 02 00 00       	jmp    801a61 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  801812:	8b 45 14             	mov    0x14(%ebp),%eax
  801815:	83 c0 04             	add    $0x4,%eax
  801818:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80181b:	8b 45 14             	mov    0x14(%ebp),%eax
  80181e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801820:	85 d2                	test   %edx,%edx
  801822:	b8 00 24 80 00       	mov    $0x802400,%eax
  801827:	0f 45 c2             	cmovne %edx,%eax
  80182a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80182d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801831:	7e 06                	jle    801839 <vprintfmt+0x199>
  801833:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801837:	75 0d                	jne    801846 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801839:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80183c:	89 c7                	mov    %eax,%edi
  80183e:	03 45 e0             	add    -0x20(%ebp),%eax
  801841:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801844:	eb 3f                	jmp    801885 <vprintfmt+0x1e5>
  801846:	83 ec 08             	sub    $0x8,%esp
  801849:	ff 75 d8             	pushl  -0x28(%ebp)
  80184c:	50                   	push   %eax
  80184d:	e8 0d 03 00 00       	call   801b5f <strnlen>
  801852:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801855:	29 c2                	sub    %eax,%edx
  801857:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80185f:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801863:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801866:	85 ff                	test   %edi,%edi
  801868:	7e 58                	jle    8018c2 <vprintfmt+0x222>
					putch(padc, putdat);
  80186a:	83 ec 08             	sub    $0x8,%esp
  80186d:	53                   	push   %ebx
  80186e:	ff 75 e0             	pushl  -0x20(%ebp)
  801871:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801873:	83 ef 01             	sub    $0x1,%edi
  801876:	83 c4 10             	add    $0x10,%esp
  801879:	eb eb                	jmp    801866 <vprintfmt+0x1c6>
					putch(ch, putdat);
  80187b:	83 ec 08             	sub    $0x8,%esp
  80187e:	53                   	push   %ebx
  80187f:	52                   	push   %edx
  801880:	ff d6                	call   *%esi
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801888:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80188a:	83 c7 01             	add    $0x1,%edi
  80188d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801891:	0f be d0             	movsbl %al,%edx
  801894:	85 d2                	test   %edx,%edx
  801896:	74 45                	je     8018dd <vprintfmt+0x23d>
  801898:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80189c:	78 06                	js     8018a4 <vprintfmt+0x204>
  80189e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8018a2:	78 35                	js     8018d9 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8018a4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8018a8:	74 d1                	je     80187b <vprintfmt+0x1db>
  8018aa:	0f be c0             	movsbl %al,%eax
  8018ad:	83 e8 20             	sub    $0x20,%eax
  8018b0:	83 f8 5e             	cmp    $0x5e,%eax
  8018b3:	76 c6                	jbe    80187b <vprintfmt+0x1db>
					putch('?', putdat);
  8018b5:	83 ec 08             	sub    $0x8,%esp
  8018b8:	53                   	push   %ebx
  8018b9:	6a 3f                	push   $0x3f
  8018bb:	ff d6                	call   *%esi
  8018bd:	83 c4 10             	add    $0x10,%esp
  8018c0:	eb c3                	jmp    801885 <vprintfmt+0x1e5>
  8018c2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8018c5:	85 d2                	test   %edx,%edx
  8018c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cc:	0f 49 c2             	cmovns %edx,%eax
  8018cf:	29 c2                	sub    %eax,%edx
  8018d1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8018d4:	e9 60 ff ff ff       	jmp    801839 <vprintfmt+0x199>
  8018d9:	89 cf                	mov    %ecx,%edi
  8018db:	eb 02                	jmp    8018df <vprintfmt+0x23f>
  8018dd:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8018df:	85 ff                	test   %edi,%edi
  8018e1:	7e 10                	jle    8018f3 <vprintfmt+0x253>
				putch(' ', putdat);
  8018e3:	83 ec 08             	sub    $0x8,%esp
  8018e6:	53                   	push   %ebx
  8018e7:	6a 20                	push   $0x20
  8018e9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018eb:	83 ef 01             	sub    $0x1,%edi
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	eb ec                	jmp    8018df <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8018f3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8018f9:	e9 63 01 00 00       	jmp    801a61 <vprintfmt+0x3c1>
	if (lflag >= 2)
  8018fe:	83 f9 01             	cmp    $0x1,%ecx
  801901:	7f 1b                	jg     80191e <vprintfmt+0x27e>
	else if (lflag)
  801903:	85 c9                	test   %ecx,%ecx
  801905:	74 63                	je     80196a <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  801907:	8b 45 14             	mov    0x14(%ebp),%eax
  80190a:	8b 00                	mov    (%eax),%eax
  80190c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80190f:	99                   	cltd   
  801910:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801913:	8b 45 14             	mov    0x14(%ebp),%eax
  801916:	8d 40 04             	lea    0x4(%eax),%eax
  801919:	89 45 14             	mov    %eax,0x14(%ebp)
  80191c:	eb 17                	jmp    801935 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  80191e:	8b 45 14             	mov    0x14(%ebp),%eax
  801921:	8b 50 04             	mov    0x4(%eax),%edx
  801924:	8b 00                	mov    (%eax),%eax
  801926:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801929:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80192c:	8b 45 14             	mov    0x14(%ebp),%eax
  80192f:	8d 40 08             	lea    0x8(%eax),%eax
  801932:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801935:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801938:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80193b:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801940:	85 c9                	test   %ecx,%ecx
  801942:	0f 89 ff 00 00 00    	jns    801a47 <vprintfmt+0x3a7>
				putch('-', putdat);
  801948:	83 ec 08             	sub    $0x8,%esp
  80194b:	53                   	push   %ebx
  80194c:	6a 2d                	push   $0x2d
  80194e:	ff d6                	call   *%esi
				num = -(long long) num;
  801950:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801953:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801956:	f7 da                	neg    %edx
  801958:	83 d1 00             	adc    $0x0,%ecx
  80195b:	f7 d9                	neg    %ecx
  80195d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801960:	b8 0a 00 00 00       	mov    $0xa,%eax
  801965:	e9 dd 00 00 00       	jmp    801a47 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80196a:	8b 45 14             	mov    0x14(%ebp),%eax
  80196d:	8b 00                	mov    (%eax),%eax
  80196f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801972:	99                   	cltd   
  801973:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801976:	8b 45 14             	mov    0x14(%ebp),%eax
  801979:	8d 40 04             	lea    0x4(%eax),%eax
  80197c:	89 45 14             	mov    %eax,0x14(%ebp)
  80197f:	eb b4                	jmp    801935 <vprintfmt+0x295>
	if (lflag >= 2)
  801981:	83 f9 01             	cmp    $0x1,%ecx
  801984:	7f 1e                	jg     8019a4 <vprintfmt+0x304>
	else if (lflag)
  801986:	85 c9                	test   %ecx,%ecx
  801988:	74 32                	je     8019bc <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  80198a:	8b 45 14             	mov    0x14(%ebp),%eax
  80198d:	8b 10                	mov    (%eax),%edx
  80198f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801994:	8d 40 04             	lea    0x4(%eax),%eax
  801997:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80199a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80199f:	e9 a3 00 00 00       	jmp    801a47 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8019a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a7:	8b 10                	mov    (%eax),%edx
  8019a9:	8b 48 04             	mov    0x4(%eax),%ecx
  8019ac:	8d 40 08             	lea    0x8(%eax),%eax
  8019af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019b7:	e9 8b 00 00 00       	jmp    801a47 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8019bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bf:	8b 10                	mov    (%eax),%edx
  8019c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c6:	8d 40 04             	lea    0x4(%eax),%eax
  8019c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019d1:	eb 74                	jmp    801a47 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8019d3:	83 f9 01             	cmp    $0x1,%ecx
  8019d6:	7f 1b                	jg     8019f3 <vprintfmt+0x353>
	else if (lflag)
  8019d8:	85 c9                	test   %ecx,%ecx
  8019da:	74 2c                	je     801a08 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8019dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019df:	8b 10                	mov    (%eax),%edx
  8019e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e6:	8d 40 04             	lea    0x4(%eax),%eax
  8019e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019ec:	b8 08 00 00 00       	mov    $0x8,%eax
  8019f1:	eb 54                	jmp    801a47 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8019f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f6:	8b 10                	mov    (%eax),%edx
  8019f8:	8b 48 04             	mov    0x4(%eax),%ecx
  8019fb:	8d 40 08             	lea    0x8(%eax),%eax
  8019fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a01:	b8 08 00 00 00       	mov    $0x8,%eax
  801a06:	eb 3f                	jmp    801a47 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801a08:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0b:	8b 10                	mov    (%eax),%edx
  801a0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a12:	8d 40 04             	lea    0x4(%eax),%eax
  801a15:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a18:	b8 08 00 00 00       	mov    $0x8,%eax
  801a1d:	eb 28                	jmp    801a47 <vprintfmt+0x3a7>
			putch('0', putdat);
  801a1f:	83 ec 08             	sub    $0x8,%esp
  801a22:	53                   	push   %ebx
  801a23:	6a 30                	push   $0x30
  801a25:	ff d6                	call   *%esi
			putch('x', putdat);
  801a27:	83 c4 08             	add    $0x8,%esp
  801a2a:	53                   	push   %ebx
  801a2b:	6a 78                	push   $0x78
  801a2d:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a2f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a32:	8b 10                	mov    (%eax),%edx
  801a34:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a39:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a3c:	8d 40 04             	lea    0x4(%eax),%eax
  801a3f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a42:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a47:	83 ec 0c             	sub    $0xc,%esp
  801a4a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801a4e:	57                   	push   %edi
  801a4f:	ff 75 e0             	pushl  -0x20(%ebp)
  801a52:	50                   	push   %eax
  801a53:	51                   	push   %ecx
  801a54:	52                   	push   %edx
  801a55:	89 da                	mov    %ebx,%edx
  801a57:	89 f0                	mov    %esi,%eax
  801a59:	e8 5a fb ff ff       	call   8015b8 <printnum>
			break;
  801a5e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801a61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a64:	e9 55 fc ff ff       	jmp    8016be <vprintfmt+0x1e>
	if (lflag >= 2)
  801a69:	83 f9 01             	cmp    $0x1,%ecx
  801a6c:	7f 1b                	jg     801a89 <vprintfmt+0x3e9>
	else if (lflag)
  801a6e:	85 c9                	test   %ecx,%ecx
  801a70:	74 2c                	je     801a9e <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  801a72:	8b 45 14             	mov    0x14(%ebp),%eax
  801a75:	8b 10                	mov    (%eax),%edx
  801a77:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a7c:	8d 40 04             	lea    0x4(%eax),%eax
  801a7f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a82:	b8 10 00 00 00       	mov    $0x10,%eax
  801a87:	eb be                	jmp    801a47 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801a89:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8c:	8b 10                	mov    (%eax),%edx
  801a8e:	8b 48 04             	mov    0x4(%eax),%ecx
  801a91:	8d 40 08             	lea    0x8(%eax),%eax
  801a94:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a97:	b8 10 00 00 00       	mov    $0x10,%eax
  801a9c:	eb a9                	jmp    801a47 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa1:	8b 10                	mov    (%eax),%edx
  801aa3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa8:	8d 40 04             	lea    0x4(%eax),%eax
  801aab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aae:	b8 10 00 00 00       	mov    $0x10,%eax
  801ab3:	eb 92                	jmp    801a47 <vprintfmt+0x3a7>
			putch(ch, putdat);
  801ab5:	83 ec 08             	sub    $0x8,%esp
  801ab8:	53                   	push   %ebx
  801ab9:	6a 25                	push   $0x25
  801abb:	ff d6                	call   *%esi
			break;
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	eb 9f                	jmp    801a61 <vprintfmt+0x3c1>
			putch('%', putdat);
  801ac2:	83 ec 08             	sub    $0x8,%esp
  801ac5:	53                   	push   %ebx
  801ac6:	6a 25                	push   $0x25
  801ac8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	89 f8                	mov    %edi,%eax
  801acf:	eb 03                	jmp    801ad4 <vprintfmt+0x434>
  801ad1:	83 e8 01             	sub    $0x1,%eax
  801ad4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801ad8:	75 f7                	jne    801ad1 <vprintfmt+0x431>
  801ada:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801add:	eb 82                	jmp    801a61 <vprintfmt+0x3c1>

00801adf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 18             	sub    $0x18,%esp
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801aeb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801aee:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801af2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801af5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801afc:	85 c0                	test   %eax,%eax
  801afe:	74 26                	je     801b26 <vsnprintf+0x47>
  801b00:	85 d2                	test   %edx,%edx
  801b02:	7e 22                	jle    801b26 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b04:	ff 75 14             	pushl  0x14(%ebp)
  801b07:	ff 75 10             	pushl  0x10(%ebp)
  801b0a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b0d:	50                   	push   %eax
  801b0e:	68 66 16 80 00       	push   $0x801666
  801b13:	e8 88 fb ff ff       	call   8016a0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b1b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b21:	83 c4 10             	add    $0x10,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    
		return -E_INVAL;
  801b26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b2b:	eb f7                	jmp    801b24 <vsnprintf+0x45>

00801b2d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b33:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b36:	50                   	push   %eax
  801b37:	ff 75 10             	pushl  0x10(%ebp)
  801b3a:	ff 75 0c             	pushl  0xc(%ebp)
  801b3d:	ff 75 08             	pushl  0x8(%ebp)
  801b40:	e8 9a ff ff ff       	call   801adf <vsnprintf>
	va_end(ap);

	return rc;
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b52:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b56:	74 05                	je     801b5d <strlen+0x16>
		n++;
  801b58:	83 c0 01             	add    $0x1,%eax
  801b5b:	eb f5                	jmp    801b52 <strlen+0xb>
	return n;
}
  801b5d:	5d                   	pop    %ebp
  801b5e:	c3                   	ret    

00801b5f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b65:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b68:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6d:	39 c2                	cmp    %eax,%edx
  801b6f:	74 0d                	je     801b7e <strnlen+0x1f>
  801b71:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801b75:	74 05                	je     801b7c <strnlen+0x1d>
		n++;
  801b77:	83 c2 01             	add    $0x1,%edx
  801b7a:	eb f1                	jmp    801b6d <strnlen+0xe>
  801b7c:	89 d0                	mov    %edx,%eax
	return n;
}
  801b7e:	5d                   	pop    %ebp
  801b7f:	c3                   	ret    

00801b80 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	53                   	push   %ebx
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801b93:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801b96:	83 c2 01             	add    $0x1,%edx
  801b99:	84 c9                	test   %cl,%cl
  801b9b:	75 f2                	jne    801b8f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801b9d:	5b                   	pop    %ebx
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    

00801ba0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	53                   	push   %ebx
  801ba4:	83 ec 10             	sub    $0x10,%esp
  801ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801baa:	53                   	push   %ebx
  801bab:	e8 97 ff ff ff       	call   801b47 <strlen>
  801bb0:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	01 d8                	add    %ebx,%eax
  801bb8:	50                   	push   %eax
  801bb9:	e8 c2 ff ff ff       	call   801b80 <strcpy>
	return dst;
}
  801bbe:	89 d8                	mov    %ebx,%eax
  801bc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	56                   	push   %esi
  801bc9:	53                   	push   %ebx
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bd0:	89 c6                	mov    %eax,%esi
  801bd2:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bd5:	89 c2                	mov    %eax,%edx
  801bd7:	39 f2                	cmp    %esi,%edx
  801bd9:	74 11                	je     801bec <strncpy+0x27>
		*dst++ = *src;
  801bdb:	83 c2 01             	add    $0x1,%edx
  801bde:	0f b6 19             	movzbl (%ecx),%ebx
  801be1:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801be4:	80 fb 01             	cmp    $0x1,%bl
  801be7:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801bea:	eb eb                	jmp    801bd7 <strncpy+0x12>
	}
	return ret;
}
  801bec:	5b                   	pop    %ebx
  801bed:	5e                   	pop    %esi
  801bee:	5d                   	pop    %ebp
  801bef:	c3                   	ret    

00801bf0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	56                   	push   %esi
  801bf4:	53                   	push   %ebx
  801bf5:	8b 75 08             	mov    0x8(%ebp),%esi
  801bf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bfb:	8b 55 10             	mov    0x10(%ebp),%edx
  801bfe:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c00:	85 d2                	test   %edx,%edx
  801c02:	74 21                	je     801c25 <strlcpy+0x35>
  801c04:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801c08:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801c0a:	39 c2                	cmp    %eax,%edx
  801c0c:	74 14                	je     801c22 <strlcpy+0x32>
  801c0e:	0f b6 19             	movzbl (%ecx),%ebx
  801c11:	84 db                	test   %bl,%bl
  801c13:	74 0b                	je     801c20 <strlcpy+0x30>
			*dst++ = *src++;
  801c15:	83 c1 01             	add    $0x1,%ecx
  801c18:	83 c2 01             	add    $0x1,%edx
  801c1b:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c1e:	eb ea                	jmp    801c0a <strlcpy+0x1a>
  801c20:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801c22:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c25:	29 f0                	sub    %esi,%eax
}
  801c27:	5b                   	pop    %ebx
  801c28:	5e                   	pop    %esi
  801c29:	5d                   	pop    %ebp
  801c2a:	c3                   	ret    

00801c2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c31:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c34:	0f b6 01             	movzbl (%ecx),%eax
  801c37:	84 c0                	test   %al,%al
  801c39:	74 0c                	je     801c47 <strcmp+0x1c>
  801c3b:	3a 02                	cmp    (%edx),%al
  801c3d:	75 08                	jne    801c47 <strcmp+0x1c>
		p++, q++;
  801c3f:	83 c1 01             	add    $0x1,%ecx
  801c42:	83 c2 01             	add    $0x1,%edx
  801c45:	eb ed                	jmp    801c34 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c47:	0f b6 c0             	movzbl %al,%eax
  801c4a:	0f b6 12             	movzbl (%edx),%edx
  801c4d:	29 d0                	sub    %edx,%eax
}
  801c4f:	5d                   	pop    %ebp
  801c50:	c3                   	ret    

00801c51 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	53                   	push   %ebx
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5b:	89 c3                	mov    %eax,%ebx
  801c5d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c60:	eb 06                	jmp    801c68 <strncmp+0x17>
		n--, p++, q++;
  801c62:	83 c0 01             	add    $0x1,%eax
  801c65:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c68:	39 d8                	cmp    %ebx,%eax
  801c6a:	74 16                	je     801c82 <strncmp+0x31>
  801c6c:	0f b6 08             	movzbl (%eax),%ecx
  801c6f:	84 c9                	test   %cl,%cl
  801c71:	74 04                	je     801c77 <strncmp+0x26>
  801c73:	3a 0a                	cmp    (%edx),%cl
  801c75:	74 eb                	je     801c62 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c77:	0f b6 00             	movzbl (%eax),%eax
  801c7a:	0f b6 12             	movzbl (%edx),%edx
  801c7d:	29 d0                	sub    %edx,%eax
}
  801c7f:	5b                   	pop    %ebx
  801c80:	5d                   	pop    %ebp
  801c81:	c3                   	ret    
		return 0;
  801c82:	b8 00 00 00 00       	mov    $0x0,%eax
  801c87:	eb f6                	jmp    801c7f <strncmp+0x2e>

00801c89 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801c93:	0f b6 10             	movzbl (%eax),%edx
  801c96:	84 d2                	test   %dl,%dl
  801c98:	74 09                	je     801ca3 <strchr+0x1a>
		if (*s == c)
  801c9a:	38 ca                	cmp    %cl,%dl
  801c9c:	74 0a                	je     801ca8 <strchr+0x1f>
	for (; *s; s++)
  801c9e:	83 c0 01             	add    $0x1,%eax
  801ca1:	eb f0                	jmp    801c93 <strchr+0xa>
			return (char *) s;
	return 0;
  801ca3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca8:	5d                   	pop    %ebp
  801ca9:	c3                   	ret    

00801caa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cb4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cb7:	38 ca                	cmp    %cl,%dl
  801cb9:	74 09                	je     801cc4 <strfind+0x1a>
  801cbb:	84 d2                	test   %dl,%dl
  801cbd:	74 05                	je     801cc4 <strfind+0x1a>
	for (; *s; s++)
  801cbf:	83 c0 01             	add    $0x1,%eax
  801cc2:	eb f0                	jmp    801cb4 <strfind+0xa>
			break;
	return (char *) s;
}
  801cc4:	5d                   	pop    %ebp
  801cc5:	c3                   	ret    

00801cc6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	57                   	push   %edi
  801cca:	56                   	push   %esi
  801ccb:	53                   	push   %ebx
  801ccc:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ccf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801cd2:	85 c9                	test   %ecx,%ecx
  801cd4:	74 31                	je     801d07 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801cd6:	89 f8                	mov    %edi,%eax
  801cd8:	09 c8                	or     %ecx,%eax
  801cda:	a8 03                	test   $0x3,%al
  801cdc:	75 23                	jne    801d01 <memset+0x3b>
		c &= 0xFF;
  801cde:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801ce2:	89 d3                	mov    %edx,%ebx
  801ce4:	c1 e3 08             	shl    $0x8,%ebx
  801ce7:	89 d0                	mov    %edx,%eax
  801ce9:	c1 e0 18             	shl    $0x18,%eax
  801cec:	89 d6                	mov    %edx,%esi
  801cee:	c1 e6 10             	shl    $0x10,%esi
  801cf1:	09 f0                	or     %esi,%eax
  801cf3:	09 c2                	or     %eax,%edx
  801cf5:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801cf7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801cfa:	89 d0                	mov    %edx,%eax
  801cfc:	fc                   	cld    
  801cfd:	f3 ab                	rep stos %eax,%es:(%edi)
  801cff:	eb 06                	jmp    801d07 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d04:	fc                   	cld    
  801d05:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801d07:	89 f8                	mov    %edi,%eax
  801d09:	5b                   	pop    %ebx
  801d0a:	5e                   	pop    %esi
  801d0b:	5f                   	pop    %edi
  801d0c:	5d                   	pop    %ebp
  801d0d:	c3                   	ret    

00801d0e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	57                   	push   %edi
  801d12:	56                   	push   %esi
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d19:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d1c:	39 c6                	cmp    %eax,%esi
  801d1e:	73 32                	jae    801d52 <memmove+0x44>
  801d20:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d23:	39 c2                	cmp    %eax,%edx
  801d25:	76 2b                	jbe    801d52 <memmove+0x44>
		s += n;
		d += n;
  801d27:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d2a:	89 fe                	mov    %edi,%esi
  801d2c:	09 ce                	or     %ecx,%esi
  801d2e:	09 d6                	or     %edx,%esi
  801d30:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d36:	75 0e                	jne    801d46 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d38:	83 ef 04             	sub    $0x4,%edi
  801d3b:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d3e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d41:	fd                   	std    
  801d42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d44:	eb 09                	jmp    801d4f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d46:	83 ef 01             	sub    $0x1,%edi
  801d49:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d4c:	fd                   	std    
  801d4d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d4f:	fc                   	cld    
  801d50:	eb 1a                	jmp    801d6c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d52:	89 c2                	mov    %eax,%edx
  801d54:	09 ca                	or     %ecx,%edx
  801d56:	09 f2                	or     %esi,%edx
  801d58:	f6 c2 03             	test   $0x3,%dl
  801d5b:	75 0a                	jne    801d67 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d5d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d60:	89 c7                	mov    %eax,%edi
  801d62:	fc                   	cld    
  801d63:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d65:	eb 05                	jmp    801d6c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801d67:	89 c7                	mov    %eax,%edi
  801d69:	fc                   	cld    
  801d6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d6c:	5e                   	pop    %esi
  801d6d:	5f                   	pop    %edi
  801d6e:	5d                   	pop    %ebp
  801d6f:	c3                   	ret    

00801d70 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801d76:	ff 75 10             	pushl  0x10(%ebp)
  801d79:	ff 75 0c             	pushl  0xc(%ebp)
  801d7c:	ff 75 08             	pushl  0x8(%ebp)
  801d7f:	e8 8a ff ff ff       	call   801d0e <memmove>
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	56                   	push   %esi
  801d8a:	53                   	push   %ebx
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d91:	89 c6                	mov    %eax,%esi
  801d93:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801d96:	39 f0                	cmp    %esi,%eax
  801d98:	74 1c                	je     801db6 <memcmp+0x30>
		if (*s1 != *s2)
  801d9a:	0f b6 08             	movzbl (%eax),%ecx
  801d9d:	0f b6 1a             	movzbl (%edx),%ebx
  801da0:	38 d9                	cmp    %bl,%cl
  801da2:	75 08                	jne    801dac <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801da4:	83 c0 01             	add    $0x1,%eax
  801da7:	83 c2 01             	add    $0x1,%edx
  801daa:	eb ea                	jmp    801d96 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801dac:	0f b6 c1             	movzbl %cl,%eax
  801daf:	0f b6 db             	movzbl %bl,%ebx
  801db2:	29 d8                	sub    %ebx,%eax
  801db4:	eb 05                	jmp    801dbb <memcmp+0x35>
	}

	return 0;
  801db6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbb:	5b                   	pop    %ebx
  801dbc:	5e                   	pop    %esi
  801dbd:	5d                   	pop    %ebp
  801dbe:	c3                   	ret    

00801dbf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801dc8:	89 c2                	mov    %eax,%edx
  801dca:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801dcd:	39 d0                	cmp    %edx,%eax
  801dcf:	73 09                	jae    801dda <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dd1:	38 08                	cmp    %cl,(%eax)
  801dd3:	74 05                	je     801dda <memfind+0x1b>
	for (; s < ends; s++)
  801dd5:	83 c0 01             	add    $0x1,%eax
  801dd8:	eb f3                	jmp    801dcd <memfind+0xe>
			break;
	return (void *) s;
}
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    

00801ddc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	57                   	push   %edi
  801de0:	56                   	push   %esi
  801de1:	53                   	push   %ebx
  801de2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801de8:	eb 03                	jmp    801ded <strtol+0x11>
		s++;
  801dea:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801ded:	0f b6 01             	movzbl (%ecx),%eax
  801df0:	3c 20                	cmp    $0x20,%al
  801df2:	74 f6                	je     801dea <strtol+0xe>
  801df4:	3c 09                	cmp    $0x9,%al
  801df6:	74 f2                	je     801dea <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801df8:	3c 2b                	cmp    $0x2b,%al
  801dfa:	74 2a                	je     801e26 <strtol+0x4a>
	int neg = 0;
  801dfc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e01:	3c 2d                	cmp    $0x2d,%al
  801e03:	74 2b                	je     801e30 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e05:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e0b:	75 0f                	jne    801e1c <strtol+0x40>
  801e0d:	80 39 30             	cmpb   $0x30,(%ecx)
  801e10:	74 28                	je     801e3a <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e12:	85 db                	test   %ebx,%ebx
  801e14:	b8 0a 00 00 00       	mov    $0xa,%eax
  801e19:	0f 44 d8             	cmove  %eax,%ebx
  801e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e21:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e24:	eb 50                	jmp    801e76 <strtol+0x9a>
		s++;
  801e26:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e29:	bf 00 00 00 00       	mov    $0x0,%edi
  801e2e:	eb d5                	jmp    801e05 <strtol+0x29>
		s++, neg = 1;
  801e30:	83 c1 01             	add    $0x1,%ecx
  801e33:	bf 01 00 00 00       	mov    $0x1,%edi
  801e38:	eb cb                	jmp    801e05 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e3a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e3e:	74 0e                	je     801e4e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801e40:	85 db                	test   %ebx,%ebx
  801e42:	75 d8                	jne    801e1c <strtol+0x40>
		s++, base = 8;
  801e44:	83 c1 01             	add    $0x1,%ecx
  801e47:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e4c:	eb ce                	jmp    801e1c <strtol+0x40>
		s += 2, base = 16;
  801e4e:	83 c1 02             	add    $0x2,%ecx
  801e51:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e56:	eb c4                	jmp    801e1c <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e58:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e5b:	89 f3                	mov    %esi,%ebx
  801e5d:	80 fb 19             	cmp    $0x19,%bl
  801e60:	77 29                	ja     801e8b <strtol+0xaf>
			dig = *s - 'a' + 10;
  801e62:	0f be d2             	movsbl %dl,%edx
  801e65:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e68:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e6b:	7d 30                	jge    801e9d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801e6d:	83 c1 01             	add    $0x1,%ecx
  801e70:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e74:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e76:	0f b6 11             	movzbl (%ecx),%edx
  801e79:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e7c:	89 f3                	mov    %esi,%ebx
  801e7e:	80 fb 09             	cmp    $0x9,%bl
  801e81:	77 d5                	ja     801e58 <strtol+0x7c>
			dig = *s - '0';
  801e83:	0f be d2             	movsbl %dl,%edx
  801e86:	83 ea 30             	sub    $0x30,%edx
  801e89:	eb dd                	jmp    801e68 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801e8b:	8d 72 bf             	lea    -0x41(%edx),%esi
  801e8e:	89 f3                	mov    %esi,%ebx
  801e90:	80 fb 19             	cmp    $0x19,%bl
  801e93:	77 08                	ja     801e9d <strtol+0xc1>
			dig = *s - 'A' + 10;
  801e95:	0f be d2             	movsbl %dl,%edx
  801e98:	83 ea 37             	sub    $0x37,%edx
  801e9b:	eb cb                	jmp    801e68 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801e9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ea1:	74 05                	je     801ea8 <strtol+0xcc>
		*endptr = (char *) s;
  801ea3:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ea6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801ea8:	89 c2                	mov    %eax,%edx
  801eaa:	f7 da                	neg    %edx
  801eac:	85 ff                	test   %edi,%edi
  801eae:	0f 45 c2             	cmovne %edx,%eax
}
  801eb1:	5b                   	pop    %ebx
  801eb2:	5e                   	pop    %esi
  801eb3:	5f                   	pop    %edi
  801eb4:	5d                   	pop    %ebp
  801eb5:	c3                   	ret    

00801eb6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	56                   	push   %esi
  801eba:	53                   	push   %ebx
  801ebb:	8b 75 08             	mov    0x8(%ebp),%esi
  801ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	74 4f                	je     801f17 <ipc_recv+0x61>
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	50                   	push   %eax
  801ecc:	e8 35 e4 ff ff       	call   800306 <sys_ipc_recv>
  801ed1:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801ed4:	85 f6                	test   %esi,%esi
  801ed6:	74 14                	je     801eec <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801ed8:	ba 00 00 00 00       	mov    $0x0,%edx
  801edd:	85 c0                	test   %eax,%eax
  801edf:	75 09                	jne    801eea <ipc_recv+0x34>
  801ee1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ee7:	8b 52 74             	mov    0x74(%edx),%edx
  801eea:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801eec:	85 db                	test   %ebx,%ebx
  801eee:	74 14                	je     801f04 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801ef0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef5:	85 c0                	test   %eax,%eax
  801ef7:	75 09                	jne    801f02 <ipc_recv+0x4c>
  801ef9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801eff:	8b 52 78             	mov    0x78(%edx),%edx
  801f02:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801f04:	85 c0                	test   %eax,%eax
  801f06:	75 08                	jne    801f10 <ipc_recv+0x5a>
  801f08:	a1 08 40 80 00       	mov    0x804008,%eax
  801f0d:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f13:	5b                   	pop    %ebx
  801f14:	5e                   	pop    %esi
  801f15:	5d                   	pop    %ebp
  801f16:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f17:	83 ec 0c             	sub    $0xc,%esp
  801f1a:	68 00 00 c0 ee       	push   $0xeec00000
  801f1f:	e8 e2 e3 ff ff       	call   800306 <sys_ipc_recv>
  801f24:	83 c4 10             	add    $0x10,%esp
  801f27:	eb ab                	jmp    801ed4 <ipc_recv+0x1e>

00801f29 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	57                   	push   %edi
  801f2d:	56                   	push   %esi
  801f2e:	53                   	push   %ebx
  801f2f:	83 ec 0c             	sub    $0xc,%esp
  801f32:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f35:	8b 75 10             	mov    0x10(%ebp),%esi
  801f38:	eb 20                	jmp    801f5a <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f3a:	6a 00                	push   $0x0
  801f3c:	68 00 00 c0 ee       	push   $0xeec00000
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	57                   	push   %edi
  801f45:	e8 99 e3 ff ff       	call   8002e3 <sys_ipc_try_send>
  801f4a:	89 c3                	mov    %eax,%ebx
  801f4c:	83 c4 10             	add    $0x10,%esp
  801f4f:	eb 1f                	jmp    801f70 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801f51:	e8 e1 e1 ff ff       	call   800137 <sys_yield>
	while(retval != 0) {
  801f56:	85 db                	test   %ebx,%ebx
  801f58:	74 33                	je     801f8d <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f5a:	85 f6                	test   %esi,%esi
  801f5c:	74 dc                	je     801f3a <ipc_send+0x11>
  801f5e:	ff 75 14             	pushl  0x14(%ebp)
  801f61:	56                   	push   %esi
  801f62:	ff 75 0c             	pushl  0xc(%ebp)
  801f65:	57                   	push   %edi
  801f66:	e8 78 e3 ff ff       	call   8002e3 <sys_ipc_try_send>
  801f6b:	89 c3                	mov    %eax,%ebx
  801f6d:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801f70:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801f73:	74 dc                	je     801f51 <ipc_send+0x28>
  801f75:	85 db                	test   %ebx,%ebx
  801f77:	74 d8                	je     801f51 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801f79:	83 ec 04             	sub    $0x4,%esp
  801f7c:	68 00 27 80 00       	push   $0x802700
  801f81:	6a 35                	push   $0x35
  801f83:	68 30 27 80 00       	push   $0x802730
  801f88:	e8 3c f5 ff ff       	call   8014c9 <_panic>
	}
}
  801f8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f90:	5b                   	pop    %ebx
  801f91:	5e                   	pop    %esi
  801f92:	5f                   	pop    %edi
  801f93:	5d                   	pop    %ebp
  801f94:	c3                   	ret    

00801f95 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f9b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fa0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fa3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fa9:	8b 52 50             	mov    0x50(%edx),%edx
  801fac:	39 ca                	cmp    %ecx,%edx
  801fae:	74 11                	je     801fc1 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fb0:	83 c0 01             	add    $0x1,%eax
  801fb3:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fb8:	75 e6                	jne    801fa0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fba:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbf:	eb 0b                	jmp    801fcc <ipc_find_env+0x37>
			return envs[i].env_id;
  801fc1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fc4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fc9:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fcc:	5d                   	pop    %ebp
  801fcd:	c3                   	ret    

00801fce <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fd4:	89 d0                	mov    %edx,%eax
  801fd6:	c1 e8 16             	shr    $0x16,%eax
  801fd9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fe0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fe5:	f6 c1 01             	test   $0x1,%cl
  801fe8:	74 1d                	je     802007 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fea:	c1 ea 0c             	shr    $0xc,%edx
  801fed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ff4:	f6 c2 01             	test   $0x1,%dl
  801ff7:	74 0e                	je     802007 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ff9:	c1 ea 0c             	shr    $0xc,%edx
  801ffc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802003:	ef 
  802004:	0f b7 c0             	movzwl %ax,%eax
}
  802007:	5d                   	pop    %ebp
  802008:	c3                   	ret    
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
