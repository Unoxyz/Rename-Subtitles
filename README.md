Rename-Subtitles
================

드라마 자막 파일명 맞추기
같은 폴더 내에 영상과 자막 파일명을 동일하게 맞춥니다.

## 인식 파일 패턴
name.s01e02.2HD.ext
name.s1e2.2HD.ext
name.s01.e02.2HD.ext
name.s01_e02.2HD.ext
name.1x02.2HD.ext
name.102.2HD.ext

## 사용법
ruby RenameSubtitles.rb [폴더명(옵션)]

## TODO
- 매칭되지 않은 드라마, 자막 파일 표시
- 자막 내려받기

## Change Log
### 1.2
폴더명 지정 시 자막 파일이 현재 폴더로 이동하는 현상 수정

### 1.1
인식 파일 패턴 확장.
전반적 수정

### 1.0
초기 버전
