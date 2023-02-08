import { PrismLight as SyntaxHighlighter } from "react-syntax-highlighter";
import syntaxStyle from "react-syntax-highlighter/dist/cjs/styles/prism/tomorrow";

export const CodeBlock: React.FC = () => {
  return (
    <SyntaxHighlighter
      language="js"
      style={syntaxStyle}
      customStyle={{
        display: "flex",
        justifyContent: "center",
        marginTop: "100px",
        paddingTop: 0,
      }}
    >
      {codeString}
    </SyntaxHighlighter>
  );
};

const codeString = `
contract Counter {
  uint256 public number;

  function setNumber(uint256 newNumber) public {
      number = newNumber;
  }

  function increment() public {
      number++;
  }

  function decrement() public {
      number--;
  }

  function add(uint256 a, uint256 b) public pure returns (uint256) {
      return a + b;
  }

  function setAdd(uint256 a, uint256 b) public {
      number = a + b;
  }
}
`;
