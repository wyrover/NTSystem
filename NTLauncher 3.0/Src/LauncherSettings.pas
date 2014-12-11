unit LauncherSettings;

interface


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{$I Definitions.inc}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


const
  LauncherVersion: Byte = 0; // ������ ��������, ������ ��������� � ������� � �������

  GlobalSalt: string = '����';

{$IFDEF BEACON}
// �������� ����� ���������� ����������� ���� �� ����� ����:
  BeaconDelay: Cardinal = 10000; // � �������������!
{$ENDIF}

{$IFDEF EURISTIC_DEFENCE}
// �������� ����� ������� ����������� ���������� ��������:
  EuristicDelay: Cardinal = 15000;
{$ENDIF}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

var
// IP � ���� ��������� ������� � Bukkit-�������:
  PrimaryIP: string = '127.0.0.1'; // �������� IP
  SecondaryIP: string = '127.0.0.1'; // �������� IP - ������������, ���� �� �������
                                     // �������������� � ���������

  ServerPort: Word = 65533;   // ���� �������
  GamePort: string = '25565'; // ���� �������

// IP � ���� �������������� (���� ������������):
  {$IFDEF MULTISERVER}
  DistributorPrimaryIP: PAnsiChar = '127.0.0.1';
  DistributorSecondaryIP: PAnsiChar = '127.0.0.1';
  DistributorPort: Word = 65534;
  {$ENDIF}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// ������ �������� �������� ������ � ������ �� �����:
  SkinUploadAddress: string = 'http://froggystyle.ru/Minecraft/upload_skin.php';
  CloakUploadAddress: string = 'http://froggystyle.ru/Minecraft/upload_cloak.php';

// ������ ����� �� ������� � ������� �� �����:
  SkinDownloadAddress: string = 'http://froggystyle.ru/Minecraft/MinecraftSkins';
  CloakDownloadAddress: string = 'http://froggystyle.ru/Minecraft/MinecraftCloaks';

// ������ ������� � ����� �� �����:
  ClientAddress: string = 'http://froggystyle.ru/Minecraft/Main.zip';
  AssetsAddress: string = 'http://froggystyle.ru/Minecraft/Assets.zip';

// ����� �������� ��� ��������������:
  {$IFDEF AUTOUPDATE}
  LauncherAddress: string = 'http://froggystyle.ru/Minecraft/NTLauncher.exe';
  {$ENDIF}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// ��� �� �������:
  ClientTempArchiveName: string = '_$RCVR.bin';
  AssetsTempArchiveName: string = '_$ASTS.bin';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// ������� ����������� ������ (java.exe - � ��������, javaw.exe - ��� �������):
  JavaApp: string = 'java.exe';

// � ��� ��������� ����������� ������, �� �������� �����:
  JVMParams: string = '';
{
  JVMParams: string = '-server ' +
                      '-D64 ' +
                      '-XX:MaxPermSize=512m ' +
                      '-XX:+UnlockCommercialFeatures ' +
                      '-XX:+UseLargePages ' +
                      '-XX:+AggressiveOpts ' +
                      '-XX:+UseAdaptiveSizePolicy ' +
                      '-XX:+UnlockExperimentalVMOptions ' +
                      '-XX:+UseG1GC ' +
                      '-XX:UseSSE=4 ' +
                      '-XX:+DisableExplicitGC ' +
                      '-XX:MaxGCPauseMillis=100 ' +
                      '-XX:ParallelGCThreads=8 ' +
                      '-DJINTEGRA_NATIVE_MODE ' +
                      '-DJINTEGRA_COINIT_VALUE=0 ' +
                      '-Dsun.io.useCanonCaches=false ' +
                      '-Djline.terminal=jline.UnsupportedTerminal ' +
                      '-XX:ThreadPriorityPolicy=42 ' +
                      '-XX:CompileThreshold=1500 ' +
                      '-XX:+TieredCompilation ' +
                      '-XX:TargetSurvivorRatio=90 ' +
                      '-XX:MaxTenuringThreshold=15 ' +
                      '-XX:+UnlockExperimentalVMOptions ' +
                      '-XX:+UseAdaptiveGCBoundary ' +
                      '-XX:PermSize=1024M ' +
                      '-XX:+UseGCOverheadLimit ' +
                      '-XX:+UseBiasedLocking ' +
                      '-Xnoclassgc ' +
                      '-Xverify:none ' +
                      '-XX:+UseThreadPriorities ' +
                      '-Djava.net.preferIPv4Stack=true ' +
                      '-XX:+UseStringCache ' +
                      '-XX:+OptimizeStringConcat ' +
                      '-XX:+UseFastAccessorMethods ' +
                      '-Xrs ' +
                      '-XX:+UseCompressedOops ';
}

// ���� ������������ MainFolder, ��� ����� ������ java(w).exe ����
// ��������� ���� ������������� ����������� �����, ����������� � ������
// ������ � �������� (Main.zip):
  {$IFDEF CUSTOM_JAVA}
  JavaDir: string = 'java\bin'; // ���� � java(w).exe � %APPDATA%\MainFolder\
  {$ENDIF}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  MainFolder: string = '\.NTLauncher'; // ����� � %APPDATA%: %APPDATA\MainFolder
  RegistryPath: string = 'NTLauncher'; // �������� ������ � ������� � ����� HKEY_CURRENT_USER\\Software\\

// ���� � ����� � Natives ������������ ����� MainFolder (%APPDATA%\MainFolder\NativesPath):
  NativesPath: string = 'versions\LL4GOF\natives';

// ���� � ����� � �������� ������������ MainFolder (%APPDATA%\MainFolder\MineJarPath):
  MineJarFolder: string = 'versions\LL4GOF';

// ���� � ����� � ������������ ������������ MainFolder (%APPDATA%\MainFolder\LibrariesFolder):
  LibrariesFolder: string = 'libraries'; // ��� ������ ������ (1.5.2 � ������) ������ ���� ������ �������!

// ���� � ����� � ��������� (Assets) ������������ MainFolder (%APPDATA%\MainFolder\MineJarPath):
  AssetsFolder: string = 'assets';

  GameVersion: string = '1.7.10'; // ������ ���� ��� �������
  AssetIndex: string = '1.7.10';  // ������ �������� ����

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// ������� �����:

  // ������ Minecraft �� 1.5.2 ������������:
  //MainClass: string = 'net.minecraft.client.Minecraft';

  // ������ Minecraft, ������� � 1.6:
  //MainClass: string = 'net.minecraft.client.main.Main';

  // Forge, Optifine:
  MainClass: string = 'net.minecraft.launchwrapper.Launch';


// �������������� ������ ��� ��������� Forge, LiteLoader, Optifine, GLSL Shaders � �.�.:
// TweakClass'� ����� �������������


  // ������ Minecraft:
  //TweakClass: string = '';

  // Forge:
  //TweakClass: string = '--tweakClass cpw.mods.fml.common.launcher.FMLTweaker';

  // OptiFine ��� Forge:
  //TweakClass: string = '--tweakClass optifine.OptiFineTweaker';

  // OptiFine + GLSL Shaders ��� Forge:
  //TweakClass: string = '--tweakClass optifine.OptiFineTweaker --tweakClass shadersmodcore.loading.SMCTweaker';

  // LiteLoader:
  //TweakClass: string = '--tweakClass com.mumfrey.liteloader.launch.LiteLoaderTweaker';

  // LiteLoader � Forge:
  TweakClass: string = '--tweakClass com.mumfrey.liteloader.launch.LiteLoaderTweaker --tweakClass cpw.mods.fml.common.launcher.FMLTweaker';

implementation

end.
