unit ProcessorUsage;

interface

uses Windows;

type
  NTStatus = Cardinal;


CONST  //Статус константы
  STATUS_SUCCESS              = NTStatus($00000000);
  STATUS_ACCESS_DENIED        = NTStatus($C0000022);
  STATUS_INFO_LENGTH_MISMATCH = NTStatus($C0000004);
  SEVERITY_ERROR              = NTStatus($C0000000);

const// SYSTEM_INFORMATION_CLASS
  SystemProcessorTimes                	=	8;


type
  _SYSTEM_BASIC_INFORMATION = packed record
   Unknown,
   MaximumIncrement,
   PhysicalPageSize,
   NumberOfPhysicalPages,
   LowestPhysicalPage,
   HighestPhysicalPage,
   AllocationGranularity,
   LowestUserAddress,
   HighestUserAddress,
   ActiveProcessors:ULONG;
   NumberProcessors:Byte;
  end;
  SYSTEM_BASIC_INFORMATION = _SYSTEM_BASIC_INFORMATION;
  PSYSTEM_BASIC_INFORMATION = ^ SYSTEM_BASIC_INFORMATION;

   _SYSTEM_PROCESSOR_TIMES =  record
    IdleTime,
    KernelTime,
    UserTime,
    DpcTime,
    InterruptTime:LARGE_INTEGER;
    InterruptCount:ULONG;
   end;
   SYSTEM_PROCESSOR_TIMES = _SYSTEM_PROCESSOR_TIMES;
   PSYSTEM_PROCESSOR_TIMES = ^ SYSTEM_PROCESSOR_TIMES;

   PROCESSOR_USAGES = packed record
     IdleTime,
     KernelTime,
     UserTime,
     DpcTime,
     InterruptTime:Single;
    end;
   PPROCESSOR_USAGES = ^ PROCESSOR_USAGES;

const
  MAX_PROCESSORS = 32;

type
  PROCESSORS_USAGES = array[0..MAX_PROCESSORS-1] of PROCESSOR_USAGES;
  PPROCESSORS_USAGES = ^ PROCESSORS_USAGES;

var
   CurrentTickCount : DWORD = 0;
   PreviousTickCount: DWORD = 0;

   CurrentSysProcTimes : PSYSTEM_PROCESSOR_TIMES = nil;
   PreviousSysProcTimes: PSYSTEM_PROCESSOR_TIMES = nil;

function GetNativeSystemInfo(InfoClass: DWORD): Pointer;
function GetProcessorsCount: Byte;
procedure GetProcessorUsage(ProcTimes: PPROCESSORS_USAGES);
procedure InitProcessors;


implementation

function ZwQuerySystemInformation(ASystemInformationClass: DWORD; ASystemInformation: Pointer;
  ASystemInformationLength: DWORD; AReturnLength:PDWORD): NTStatus; stdcall; external 'ntdll.dll';

function GetNativeSystemInfo(InfoClass: DWORD): Pointer;
var
  mSize: DWORD;
  pInfoDATA: Pointer;
  NTRes: NTStatus;
begin
  Result := nil;
  mSize := $2000;

  repeat
    pInfoDATA := VirtualAlloc(nil, mSize, MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE);

    if pInfoDATA = nil then Exit;

    NTRes := ZwQuerySystemInformation(InfoClass, pInfoDATA, mSize, nil);

    if NTRes = STATUS_INFO_LENGTH_MISMATCH then
    begin
      VirtualFree(pInfoDATA, 0, MEM_RELEASE);
      mSize := mSize + $1000;
    end;
  until NTRes <> STATUS_INFO_LENGTH_MISMATCH;

  if NTRes = STATUS_SUCCESS then
    Result := pInfoDATA
  else
    VirtualFree(pInfoDATA, 0, MEM_RELEASE);
end;


function GetProcessorsCount: Byte;
var
  SYSINFO: SYSTEM_INFO;
begin
  GetSystemInfo(SYSINFO);
  Result := SYSINFO.dwNumberOfProcessors;
end;

var
  ProcessorsCount: WORD;

procedure InitProcessors;
begin
  PreviousTickCount := GetTickCount;
  ProcessorsCount := GetProcessorsCount;
  PreviousSysProcTimes := GetNativeSystemInfo(SystemProcessorTimes);
end;

procedure GetProcessorUsage(ProcTimes: PPROCESSORS_USAGES);
var
  _Interval: DWORD;
  PRTIME: Int64;
  CurrentEntry, PreviousEntry: PSYSTEM_PROCESSOR_TIMES;
  I: Integer;
begin

  CurrentTickCount := GetTickCount;
  CurrentSysProcTimes := GetNativeSystemInfo(SystemProcessorTimes);

  _Interval := CurrentTickCount-PreviousTickCount;
  if _Interval = 0 then _Interval := 1;


  CurrentEntry := CurrentSysProcTimes;
  PreviousEntry := PreviousSysProcTimes;

  for i := 0 to ProcessorsCount - 1 do
   begin
    PRTime := CurrentEntry^.IdleTime.QuadPart - PreviousEntry^.IdleTime.QuadPart;
    PRTime := Round(PRTime / 10000);
    ProcTimes^[i].IdleTime := (PRTIME / _Interval) * 100;

    PRTime := CurrentEntry^.KernelTime.QuadPart - PreviousEntry^.KernelTime.QuadPart;
    PRTime := Round(PRTime / 10000);
    ProcTimes^[i].KernelTime := (PRTIME / _Interval) * 100;

    PRTime := CurrentEntry^.UserTime.QuadPart - PreviousEntry^.UserTime.QuadPart;
    PRTime := Round(PRTime / 10000);
    ProcTimes^[i].UserTime := (PRTIME / _Interval) * 100;

    PRTime := CurrentEntry^.DpcTime.QuadPart - PreviousEntry^.DpcTime.QuadPart;
    PRTime := Round(PRTime / 10000);
    ProcTimes^[i].DpcTime := (PRTIME / _Interval) * 100;

    PRTime := CurrentEntry^.InterruptTime.QuadPart - PreviousEntry^.InterruptTime.QuadPart;
    PRTime := Round(PRTime / 10000);
    ProcTimes^[i].InterruptTime := (PRTIME / _Interval) * 100;

    CurrentEntry := Pointer(DWORD(CurrentEntry) + SizeOf(SYSTEM_PROCESSOR_TIMES));
    PreviousEntry := Pointer(DWORD(PreviousEntry) + SizeOf(SYSTEM_PROCESSOR_TIMES));
   end;

  VirtualFree(PreviousSysProcTimes, 0, MEM_RELEASE);
  PreviousSysProcTimes := CurrentSysProcTimes;
  PreviousTickCount := CurrentTickCount;
end;

end.
