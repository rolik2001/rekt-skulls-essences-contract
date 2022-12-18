// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/common/ERC2981Upgradeable.sol";


contract RektSkullsEssence is ERC1155Upgradeable, OwnableUpgradeable, ERC2981Upgradeable {
    using ECDSA for bytes32;

    address public signer;
    uint256 public totalNft;
    bool public wlActive;

    string private _contract_url;

    uint256 public constant MAX_NFT = 10000;
    uint256 public constant WL_TOTAL_NFT = 1000;
    string constant public name = "RektSkulls - Essences";

    mapping(uint256 => uint256) public totalSupply;
    mapping(address => uint256) public mintNonce;

    event Mint(address indexed user, uint256 indexed id, uint256 amount);
    event Burn(address indexed user, uint256 indexed id, uint256 amount);


    modifier SupportedId(uint256 id){
        require(id >= 1 && id <= 4, "INCID");
        _;
    }

    modifier CorrectNonce(uint256 nonce) {
        require((mintNonce[msg.sender]+1) == nonce, "NISC");
        _;
        mintNonce[msg.sender]++;
    }


    function initialize() public initializer {
        __ERC1155_init("");
        __Ownable_init();
        __ERC2981_init();


        // Set royalty receiver to the contract creator,
        // at 5% (default denominator is 10000).
        _setDefaultRoyalty(msg.sender, 500);
    }


    function mintWLWithSignature(uint256 id, uint256 nonce, bytes memory sig) external
    SupportedId(id)
    CorrectNonce(nonce)
    {
        require(wlActive, "WLNTSTR");
        require((totalNft + 1) <= WL_TOTAL_NFT, "SUPEXC");

        bytes32 hash = ECDSA.toEthSignedMessageHash(
            keccak256(
                abi.encode(
                    id,
                    nonce,
                    msg.sender
                )
            )
        );

        require(hash.recover(sig) == signer, "INVALID SIGN");
        _mintId(msg.sender, id, 1);
    }

    function burn(uint256 id, uint256 amount) external SupportedId(id) {
        require(amount != 0, "AMIZ");
        _burn(msg.sender, id, amount);
        totalNft -= amount;
        totalSupply[id] -= amount;
        emit Burn(msg.sender,id,amount);
    }


    /************************** View Functions **************************/

    function uri(uint256 id) public view virtual override returns (string memory) {
        return string(abi.encodePacked(super.uri(id), Strings.toString(id)));
    }


    function contractURI() public view returns (string memory) {
        return _contract_url;
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override (ERC1155Upgradeable, ERC2981Upgradeable)
    returns (bool)
    {
        // Supports the following `interfaceId`s:
        // - IERC165: 0x01ffc9a7
        // - IERC1155: 0xd9b67a26
        // - IERC1155MetadataURI: 0x0e89341c
        // - IERC2981: 0x2a55205a
        return ERC1155Upgradeable.supportsInterface(interfaceId)
        || ERC2981Upgradeable.supportsInterface(interfaceId);
    }

    /************************** Owner Functions **************************/

    function mintDev() public onlyOwner {
        require(totalNft == 0, "TTLISNZ");
        _mintId(msg.sender, 1, 1);
    }

    function setSigner(address _signer) public onlyOwner {
        signer = _signer;
    }

    function setUri(string memory _url) public onlyOwner {
        _setURI(_url);
    }

    function setContractUri(string memory _url) public onlyOwner {
        _contract_url = _url;
    }

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    function changeWlStatus(bool active) public onlyOwner {
        wlActive = active;
    }

    /************************** Private Functions **************************/

    function _mintId(address user, uint256 id, uint256 amount) private {
        require(amount != 0, "AMIZ");
        _mint(user, id, amount, "");
        totalNft += amount;
        totalSupply[id] += amount;
        emit Mint(user,id,amount);
    }
}