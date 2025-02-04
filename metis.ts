const express = require('express');
const axios = require('axios').default;
const dotenv = require('dotenv');

dotenv.config({
  path: '.env',
  override: true,
});

const app = express();
const port = 3000;
const baseUrl = process.env.RPC_METIS;

app.use(express.json());

const gasTransactionByHash = (txHash) => {
  return axios.post(baseUrl, {
    id: 1,
    jsonrpc: '2.0',
    method: 'eth_getTransactionByHash',
    params: [txHash],
  });
};

app.use('/', async (req, res) => {
  try {
    console.log(req.path);
    const url = new URL(req.pathname, baseUrl);
    console.log(req.headers);
    const remoteResponse = await axios({
      method: req.method,
      // headers: { ...req.headers },
      // params: req.params,
      data: req.body,
      url: 'https://metis-mainnet.g.alchemy.com/v2/LmIVDfxN2WtA3izy9kJCDjk06INXb9j4',
    });
    console.log(url);
    if (req.body.method === 'eth_getTransactionReceipt' && remoteResponse.data.result) {
      const txHash = remoteResponse.data.result.transactionHash;
      const txByHash = await gasTransactionByHash(txHash);
      console.log(txByHash);
      const gasPrice = txByHash.data.result.gasPrice;
      remoteResponse.data.result.effectiveGasPrice = gasPrice;
      remoteResponse.data.result.type = '0x1';
      // res.status(200).json({
      //     ...remoteResponse.data,
      // })
      console.log(remoteResponse.data);
    }
    res.status(200).json(remoteResponse.data);
  } catch (e) {
    console.log(req.body.method, e);
    res.status(500).send('what');
  }
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
