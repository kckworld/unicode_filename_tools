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

> 폴더를 다른 위치로 이동한 경우, `install_normalize_filename_context_menu.ps1` 을 다시 실행하면 레지스트리 경로가 자동으로 업데이트됩니다.

## 제거 방법

`uninstall_normalize_filename_context_menu.ps1` 을 **우클릭 → PowerShell로 실행** 합니다.

## 동작 방식

- 폴더 우클릭 메뉴에서 실행 시 해당 폴더와 모든 하위 폴더를 재귀적으로 검색하여 파일/폴더명을 NFC 정규화합니다.
- 배경(빈 공간) 우클릭 메뉴에서 실행 시 현재 폴더를 대상으로 합니다.
- 모든 경로는 스크립트 위치 기준 상대 경로로 동작하므로 폴더 이동에 영향 없습니다.