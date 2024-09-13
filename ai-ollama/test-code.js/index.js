const axios = require('axios');

const url = 'http://ollama-api.local/api/chat';
const data = {
	"model": "llama3.1",
	"messages": [
		{
			"role":"system",
			"content":"You are an expert frontend React engineer woh is also a great UI/UX designer. Follow the instructions carefully, I will tip you \$1 million if you do a good job:\n\n- Create a React component for whatever the user asked you to create and make sure it can run by itself by using a default export\n- Make sure the React app is interactive and functional by creating state when needed and having no required props\n- if you use any imports from React like useState or useEffect, maek sure to import them directly\n- Use TypeScript as the language for the React component\n- Use Tailwind classes for styling. DO NOT USE ARBITRARY VALUES (e.g. \`h-[600px]\`). Make sure to use a consistent color palette.\n- Use Tailwind margin and padding classes to style the components and ensure the components are spaced out nicely\n- Please ONLY return the full React code starting with the imports, nothing else. It's very important for my job that you only return the React code with imports. DO NOT START WITH \`\`\`typescript or \`\`\`javascript or \`\`\`tsx or \`\`\`.\n- ONLY IF the user asks for a dashboard, graph or chart, the recharts library is available to be imported, e.g. \`import { LineChart, XAxis, ... } from \"recharts\"\` & \`<LineChart ...><XAxis dataKey=\"name\"> ... \`. Please only use this when needed.\n\nNO OTHER LIBRARIES (e.g. zod, hookform) ARE INSTALLED OR ABLE TO BE IMPORTED."
		},
		{
			"role":"user",
			"content":"Build me a calculator app\nPlease ONLY return code, NO backticks or language names."
		}
	],
	"stream":true,
	"temperature":0.2
};

axios.post(url, data, {responseType: 'stream'})
	.then(response => {
		response.data.on('data', (chunk) => {
			try {
				const json = JSON.parse(chunk.toString());
				// console.log('Received JSON:', json);
				process.stdout.write(json.message.content);
			} catch (error) {
				console.error('Error parsing JSON:', error);
			}
		});
		response.data.on('end', () => {
			// console.log('Stream ended');
		});
		response.data.on('error', (error) => {
			console.error('Stream error:', error);
		});
		// console.log('Response:', response.data);
	})
	.catch(error => {
		console.error('Request Error:', error);
	});
