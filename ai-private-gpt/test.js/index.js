const assert = require('assert');
const axios = require('axios');

describe('Test', () => {
    it('should return the sum of two numbers', async function() {
        this.timeout(300000); // Set the timeout to 300 seconds
        let docIds = [];

        console.log('before injectDoc');
        docIds.push(await injectDoc('copper', '銅（英語：Copper），是最早發現的化學元素，化學符號為Cu（源於拉丁語：Cuprum[3]），原子序數為29，原子量為63.546 u。純銅是柔軟的金屬，表面剛切開時為紅橙色帶金屬光澤、延展性好、導熱性和導電性高，因此在電纜、電氣和電子元件是最常用的材料，也可用作建築材料，以及組成眾多種合金，例如用於珠寶的紋銀，用於製作船用五金和硬幣的白銅以及用於應變片和熱電偶的康銅。銅合金機械性能優異，電阻率很低，其中最重要的是青銅和黃銅。此外，銅也是耐用的金屬，可以多次回收而無損其機械性能。'));
        console.log("docIds: " + docIds);
        await ask(docIds, '铜的化学符号');
    });
});

async function injectDoc(filename, text) {
    const requestData = {
        file_name: filename,
        text: text,
    };
	console.log("before axios.post");
    const response = await axios.post('http://ai-private-gpt.local/v1/ingest/text', requestData, {
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
        }
    });
	console.log("after axios.post");
    // {
    //     "object":"list",
    //     "model":"private-gpt",
    //     "data":[{
    //         "ob:"ingest.document",
    //         "doc_id":"076e5763-cb59-47ce-8a9d-d731033e90d8",
    //         "doc_metadata":{"file_name":"冬季校服要求"}
    //     }]
    // }
    console.log('ingestDocument: ', response.status);
    assert.strictEqual(response.status, 200);
    console.log(response.data);
    return response.data.data[0].doc_id;
}

async function ask(docIds, prompt) {
    const requestData = {
        prompt: prompt,
        context_filter: {docs_ids: docIds},
        use_context: true,
    };
    const response = await axios.post('http://ai-private-gpt.local/v1/completions', requestData, {
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
        }
    });
    console.log('completions: ', response.status);
    assert.strictEqual(response.status, 200);
    console.log(JSON.stringify(response.data));
}
