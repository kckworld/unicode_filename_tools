# Unicode Filename Tools

Windows 탐색기 우클릭 메뉴에서 파일/폴더명의 유니코드 정규화(NFC)를 수행하는 도구입니다.

## 파일 구성

| 파일 | 설명 |
|------|------|
| `normalize_unicode_filenames.ps1` | 실제 정규화 처리 스크립트 |
| `run_normalize_unicode_filenames.cmd` | 정규화 실행 래퍼 (탐색기 메뉴에서 호출) |
| `install_normalize_filename_context_menu.ps1` | 우클릭 메뉴 등록 스크립트 |
| `uninstall_normalize_filename_context_menu.ps1` | 우클릭 메뉴 제거 스크립트 |
| `install_normalize_filename_context_menu.reg` | 메뉴 등록용 REG 파일 (설치 시 자동 갱신) |
| `uninstall_normalize_filename_context_menu.reg` | 메뉴 제거용 REG 파일 |

## 설치 방법

1. 이 폴더를 원하는 위치에 복사합니다.
2. `install_normalize_filename_context_menu.ps1` 을 **우클릭 → PowerShell로 실행** 합니다.
3. 탐색기에서 폴더 우클릭 시 **"Normalize filenames to NFC"** 메뉴가 나타납니다.

> 설치 시 실행 파일들은 `%LOCALAPPDATA%\UnicodeFilenameTools` 로 복사되고, 레지스트리는 이 고정 경로를 바라봅니다. 따라서 원본 폴더를 이동/삭제해도 메뉴가 깨지지 않습니다.

## 제거 방법

`uninstall_normalize_filename_context_menu.ps1` 을 **우클릭 → PowerShell로 실행** 합니다.

제거 시 레지스트리 메뉴와 `%LOCALAPPDATA%\UnicodeFilenameTools` 폴더를 함께 삭제합니다.

## 동작 방식

- 폴더 우클릭 메뉴에서 실행 시 해당 폴더와 모든 하위 폴더를 재귀적으로 검색하여 파일/폴더명을 NFC 정규화합니다.
- 배경(빈 공간) 우클릭 메뉴에서 실행 시 현재 폴더를 대상으로 합니다.
- 실제 실행 경로는 설치 시 복사된 `%LOCALAPPDATA%\UnicodeFilenameTools` 기준입니다.