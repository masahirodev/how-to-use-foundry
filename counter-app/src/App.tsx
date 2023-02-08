import { useState } from "react";
import { CodeBlock } from "./components/CodeBlock";
import { useHandleContract } from "./hooks/useHandleContract";
import "./App.css";

const initInputs = {
  a: 0,
  b: 0,
};
export type Inputs = typeof initInputs & { [key: string]: number };

function App() {
  const [inputs, setInputs] = useState<Inputs>(initInputs);
  const [data, functions] = useHandleContract(inputs);

  return (
    <>
      <div className="App" style={{ paddingTop: "100px" }}>
        <div>
          {Object.keys(initInputs).map((v, i) => {
            return (
              <div key={i}>
                <label>{v}:</label>
                <input
                  type="number"
                  id={v}
                  onChange={(e) =>
                    setInputs({
                      ...inputs,
                      ...{ [e.target.id]: Number(e.target.value) },
                    })
                  }
                  defaultValue={inputs[v]}
                ></input>
              </div>
            );
          })}
        </div>
        {Object.values(functions).map((v, i) => {
          return (
            <button key={i} onClick={v}>
              {v.name}
            </button>
          );
        })}
        <div>Current Number or Return Number:{data}</div>
        <CodeBlock />
      </div>
    </>
  );
}

export default App;
