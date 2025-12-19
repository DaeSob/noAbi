// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title EIP712RecoverTest
 * @dev EIP-712 서명 복구 및 검증을 테스트하는 컨트랙트
 */
contract EIP712RecoverTest {

    // EIP-712 타입 해시
    bytes32 private constant PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value)");

    // EIP-712 도메인 타입 해시
    bytes32 private constant DOMAIN_TYPEHASH =
        keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");

    // 도메인 정보
    string public name;
    string public version;
    uint256 public chainId;
    address public verifyingContract;


    /**
     * @dev 컨트랙트 초기화
     * @param _name 도메인 이름
     * @param _version 도메인 버전
     */
    constructor(string memory _name, string memory _version) {
        name = _name;
        version = _version;
        chainId = block.chainid;
        verifyingContract = address(this);
    }

    /**
     * @dev 도메인 분리자(Domain Separator) 계산
     * @return domainSeparator 도메인 분리자
     */
    function _domainSeparator() private view returns (bytes32 domainSeparator) {
        return keccak256(
            abi.encode(
                DOMAIN_TYPEHASH,
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                chainId,
                verifyingContract
            )
        );
    }

    /**
     * @dev EIP-712 메시지 해시 계산
     * @param structHash 구조화된 데이터 해시
     * @return messageHash EIP-712 메시지 해시
     */
    function _hashTypedDataV4(bytes32 structHash) private view returns (bytes32 messageHash) {
        bytes32 domainSeparator = _domainSeparator();
        return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
    }

    /**
     * @dev ECDSA 서명 복구
     * @param hash 메시지 해시
     * @param signature 서명
     * @return signer 복구된 서명자 주소
     */
    function _recover(bytes32 hash, bytes memory signature) private pure returns (address signer) {
        require(signature.length == 65, "EIP712RecoverTest: invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }

        if (v < 27) {
            v += 27;
        }

        require(v == 27 || v == 28, "EIP712RecoverTest: invalid signature v value");

        signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "EIP712RecoverTest: invalid signature");
    }

    /**
     * @dev EIP-712 서명을 복구하여 서명자 주소를 반환
     * @param owner 서명자 주소
     * @param spender 허용받는 주소
     * @param value 허용 금액
     * @param signature 서명
     * @return recoveredAddress 복구된 서명자 주소
     */
    function recoverSigner(
        address owner,
        address spender,
        uint256 value,
        bytes memory signature
    ) public view returns (address recoveredAddress) {
        bytes32 structHash = keccak256(
            abi.encode(
                PERMIT_TYPEHASH,
                owner,
                spender,
                value
            )
        );

        bytes32 hash = _hashTypedDataV4(structHash);
        recoveredAddress = _recover(hash, signature);
    }

    /**
     * @dev 서명이 유효한지 검증
     * @param owner 서명자 주소
     * @param spender 허용받는 주소
     * @param value 허용 금액
     * @param signature 서명
     * @return isValid 서명 유효성
     */
    function verifySignature(
        address owner,
        address spender,
        uint256 value,
        bytes memory signature
    ) public view returns (bool isValid) {
        address recovered = recoverSigner(owner, spender, value, signature);
        isValid = (recovered == owner && recovered != address(0));
    }

    /**
     * @dev 도메인 분리자(Domain Separator) 반환
     * @return domainSeparator 도메인 분리자
     */
    function getDomainSeparator() external view returns (bytes32 domainSeparator) {
        return _domainSeparator();
    }

    /**
     * @dev 타입 해시 반환
     * @return typeHash Permit 타입 해시
     */
    function getTypeHash() external pure returns (bytes32 typeHash) {
        return PERMIT_TYPEHASH;
    }

    /**
     * @dev 구조화된 데이터 해시 계산
     * @param owner 서명자 주소
     * @param spender 허용받는 주소
     * @param value 허용 금액
     * @return structHash 구조화된 데이터 해시
     */
    function getStructHash(
        address owner,
        address spender,
        uint256 value
    ) external pure returns (bytes32 structHash) {
        return keccak256(
            abi.encode(
                PERMIT_TYPEHASH,
                owner,
                spender,
                value
            )
        );
    }

    /**
     * @dev EIP-712 메시지 해시 계산 (_hashTypedDataV4 결과)
     * @param owner 서명자 주소
     * @param spender 허용받는 주소
     * @param value 허용 금액
     * @return messageHash EIP-712 메시지 해시
     */
    function getMessageHash(
        address owner,
        address spender,
        uint256 value
    ) external view returns (bytes32 messageHash) {
        bytes32 structHash = keccak256(
            abi.encode(
                PERMIT_TYPEHASH,
                owner,
                spender,
                value
            )
        );
        messageHash = _hashTypedDataV4(structHash);
    }

}

