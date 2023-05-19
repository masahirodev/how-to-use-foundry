// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// forge test --match-contract WriteReadFileTest --match-test testWriteReadArray2Json -vvvvv --gas-report

contract WriteReadFileTest is Test {
    using stdJson for string;
    using Strings for uint256;

    // attenstion name sort ASC
    struct Json {
        address addr;
        uint256 id;
    }

    // dict {...}
    function testWriteReadJson(uint256 number, address addr) public {
        string memory path = "./data/example.json";

        // create writeJson
        // {"addr": addrs[0],"id": ids[0]}
        string memory obj1 = "key";
        string memory writeJson = vm.serializeUint(obj1, "id", number);
        writeJson = vm.serializeAddress(obj1, "addr", addr);

        // write to file
        vm.writeJson(writeJson, path);

        // read to file
        string memory readJson = vm.readFile(path);

        // decode
        bytes memory abiEncodedData = vm.parseJson(readJson);
        Json memory result = abi.decode(abiEncodedData, (Json));

        // check write data === read data
        assertEq(result.id, number);
        assertEq(result.addr, addr);
    }

    // array dict [{...},{...},...,{...}]
    function testWriteReadArrayJson(address[100] memory addrs, uint16[100] memory ids) public {
        string memory path = "./data/example.json";

        // create writeJson
        // [{"addr": addrs[0],"id": ids[0]},{"addr": addrs[1],"id": ids[1]}...]
        string memory obj1 = "key";
        string memory writeJson = "[";
        string memory last;

        uint256 len = addrs.length;
        for (uint256 i; i < len;) {
            unchecked {
                if (i != len - 1) {
                    last = ",";
                } else {
                    last = "]";
                }

                string memory writeJson1 = vm.serializeUint(obj1, "id", ids[i]);
                writeJson1 = vm.serializeAddress(obj1, "addr", addrs[i]);

                writeJson = string(abi.encodePacked(writeJson, writeJson1, last));
                i++;
            }
        }

        // write to file
        vm.writeJson(writeJson, path);

        // read to file
        string memory readJson = vm.readFile(path);

        // check write data === read data
        for (uint256 i; i < len;) {
            unchecked {
                // decode
                bytes memory abiEncodedData = readJson.parseRaw(string(abi.encodePacked("[", i.toString(), "]")));
                Json memory result = abi.decode(abiEncodedData, (Json));

                // check
                assertEq(result.id, ids[i]);
                assertEq(result.addr, addrs[i]);
                i++;
            }
        }
    }

    // dict array dict {...:[{...},{...},...,{...}]}
    function testWriteReadArray2Json(address[100] memory addrs, uint16[100] memory ids) public {
        string memory path = "./data/example.json";

        // create writeJson
        // {"result":[{"addr": addrs[0],"id": ids[0]},{"addr": addrs[1],"id": ids[1]}...]}
        string memory obj1 = "key";
        string memory writeJson = '{"result":[';
        string memory last;

        uint256 len = addrs.length;
        for (uint256 i; i < len;) {
            unchecked {
                if (i != len - 1) {
                    last = ",";
                } else {
                    last = "]}";
                }

                string memory writeJson1 = vm.serializeUint(obj1, "id", ids[i]);
                writeJson1 = vm.serializeAddress(obj1, "addr", addrs[i]);

                writeJson = string(abi.encodePacked(writeJson, writeJson1, last));
                i++;
            }
        }

        // write to file
        vm.writeJson(writeJson, path);

        // read to file
        string memory readJson = vm.readFile(path);

        // check write data === read data
        for (uint256 i; i < len;) {
            unchecked {
                // decode
                bytes memory abiEncodedData = readJson.parseRaw(string(abi.encodePacked(".result[", i.toString(), "]")));
                Json memory result = abi.decode(abiEncodedData, (Json));

                // check
                assertEq(result.id, ids[i]);
                assertEq(result.addr, addrs[i]);
                i++;
            }
        }
    }

    function testWriteReadTxtDatas() public {
        string memory path = "./data/datas.txt";
        string memory data = "hello world";

        // write to file
        vm.writeFile(path, data);

        // read to file
        assertEq(vm.readFile(path), data);
    }

    function testWriteReadTxtLineData() public {
        // reset line.txt data
        string memory path = "./data/line.txt";
        vm.writeFile(path, "");

        // write to line1
        string memory line1 = "first line";
        vm.writeLine(path, line1);

        // write to line2
        string memory line2 = "second line";
        vm.writeLine(path, line2);

        // write to line3
        string memory line3 = "third line";
        vm.writeLine(path, line3);

        // read to line1
        assertEq(vm.readLine(path), line1);

        // read to line2
        assertEq(vm.readLine(path), line2);

        // if you need reset offset(read line) --> closeFile
        // offset 2 --> 0
        vm.closeFile(path);
        // read to line1
        assertEq(vm.readLine(path), line1);
    }
}
