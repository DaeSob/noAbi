# Optional Modules

noABI는 기본적인 Compose / Deploy / Contract Execution 기능 외에도  
확장 가능하도록 설계되어 있으며, 선택적으로 활성화할 수 있는 모듈을 제공합니다.  
아래 모듈들은 프로젝트 또는 배포 환경에 따라 개별적으로 독립 사용이 가능합니다.

---
### 1 EIP-712 / EIP-191 Signing Backend

noABI는 EIP-712(typed structured data) 및 EIP-191(personal_sign) 메시지 서명을  
로컬에서 자동 처리하기 위한 Signing Backend를 제공합니다.  

**목적**  
- 매번 지갑(Metamask 등)을 열어 서명 팝업을 확인해야 하는 번거로움 제거  
- 프론트엔드나 dApp 흐름에 종속되지 않고 단독으로 서명 테스트 가능  
- CI/CD나 스크립트 기반 테스트에서 자동 서명 지원  

**주요 기능**  
- 테스트 환경에서 지갑 없이 서명 가능  
- 버튼 클릭 없이 자동 서명 반환  
- EIP-712 / EIP-191 구조 완전 지원  
- curl 또는 외부 클라이언트(Postman, Golang, Node.js 등) 요청 가능  
- 프론트엔드와 독립적으로 동작하는 서명 엔드포인트 제공  
- 스마트 컨트랙트 인터랙션 테스트 시 UI 없이 자동 진행 가능  

### 2 Event Log 수집기

- 향후 제공 예정  
- 목적: 배포 및 Contract Call 이벤트를 자동으로 수집/분석하여 테스트 및 로깅에 활용 

---
**문서 네비게이션**  
[← 이전: Commands](commands.md) | [다음: README →](../README.md)  
[↑ 목차로 돌아가기](../README.md)