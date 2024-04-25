#!/bin/bash

curl -X POST \
	--url "http://ai-private-gpt.local/v1/ingest/text" \
	--header "Content-Type: application/json" \
	--header "Accept: application/json" \
	--data '
{
  "file_name": "冬季校服要求",
  "text": "男学生冬季校服要求白色长衬衫和灰色长西裤。女学生则是浅蓝色上衣服和深蓝色长裙。男女学生皆需要打领带。"
}
'

curl -X POST \
	--url "http://ai-private-gpt.local/v1/ingest/text" \
	--header "Content-Type: application/json" \
	--header "Accept: application/json" \
	--data '
{
  "file_name": "中国舞每周六排练",
  "text": "中国舞校队每周六的排练时间是早上9点半到下午5点。同学们需要自备金钱购买午餐。"
}
'

curl -X GET --url "http://ai-private-gpt.local/v1/ingest/list" --header "Accept: application/json"
