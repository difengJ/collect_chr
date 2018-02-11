import random 

def collect(people_num,chr_num,chance_num,chr_type):
# @para people_num: how many people join
# @para chr_num: how many in each chr
# @para chr_type:how many types are there
# @para chance_num: how many chance per person
	pool = {}
	result = {}
	for i in range(chr_type):
		pool[str(i)] = chr_num
	for j in range(people_num):
		for m in range(chance_num):
			index = random.randint(0,chr_type-1)
			str_index = str(index)
			if j in result.keys():
				if pool[str_index] == 0:continue
				pool[str_index] -= 1
				result[j].append(str_index)
			else:
				result[j] = []
				result[j].append(str_index)
	return result

def cal_win(result,people_num):
	count = 0
	for k,v in result.items():
		if {"0","1","2","3"} == set(v):
			count += 1
	return count/people_num

result = collect(1000,500,8,4)
print (cal_win(result,1000))




