Pkg.add("DataStructures")

#=++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#

compliments = Dict('A' => '1', 'B' => '2', 'C' => '3', 'D' => '4') 
compliments_op = Dict('1' => 'A', '2' => 'B', '3' => 'C', '4' => 'D')

function translate(c)    
    compliments[c] 
end 
function translate_opposite(c)    
    compliments_op[c] 
end

#=+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#

function goalStackPlanning(state, goal_state)
	actions_to_take=[]     
	stack = Stack{Any}()	
    new=deepcopy(goal_state)
	push!(stack, new)
    cur_state=deepcopy(state)
	p_cond = fill(0, (num_blocks*num_blocks+3*num_blocks+1))  
    
	ii = num_blocks*num_blocks+3*num_blocks+1
    for i in 1:ii
		if(new[i]==1)
			push!(stack, i)
        end			
    end
	rou = 0
    while !isempty(stack)
        println("-------------------------------------------------------------------")
		ele=pop!(stack)
		println(ele)
		rou = rou + 1
		typeof_ = string(typeof(ele))

		if rou == 54
		    break
        end

		if(typeof_ == "Array{Int64,1}")
            passed=1
            aa = num_blocks*num_blocks+3*num_blocks+1
			for i in 1:aa
                if(ele[i]==1) & (cur_state[i]==0)
                    passed=0
                    break
				end
            end
            if(passed==0)                                  
                push!(stack, ele)
                bb = num_blocks*num_blocks+3*num_blocks+1
				for i in 1:bb
                    if(ele[i]==1)
                        push!(stack, i)
					end
				end
			end
		elseif(typeof_ == "Int64" )
            if(cur_state[ele]==0)
                act = []
                ano = ele-1
                println("ANO", ano)
				if(ano<num_blocks*num_blocks) 
                    a=floor(Int8,ano/num_blocks)
                    b=floor(Int8,ano%num_blocks)
                    act = string("stack ", string(a+1), " ", string(b+1))
                    push!(stack, act)
                    precond = deepcopy(p_cond)
                    precond[num_blocks*num_blocks+num_blocks+b+1]=1
					precond[num_blocks*num_blocks+2*num_blocks+a+1]=1
                    push!(stack, precond)
                    push!(stack, num_blocks*num_blocks+num_blocks+b+1)
                    push!(stack, num_blocks*num_blocks+2*num_blocks+a+1)
					
                elseif(ano<num_blocks*num_blocks+num_blocks)
					a = ano-(num_blocks*num_blocks)
					act = string("release ", string(a+1))
                    push!(stack, act)
                    precond = deepcopy(p_cond)
                    precond[num_blocks*num_blocks+2*num_blocks+a+1]=1
                    push!(stack, precond)
                    push!(stack, num_blocks*num_blocks+2*num_blocks+a+1)
					
                elseif(ano<num_blocks*num_blocks+2*num_blocks)
                    println("C")
					holdblock=0
					b=ano-(num_blocks*num_blocks+num_blocks)
                    
                    if(cur_state[num_blocks*num_blocks+2*num_blocks+b+1]==1)#make changes
                        holdblock=1
					end
					
                    if(holdblock==1)
                        a=ano-(num_blocks*num_blocks+num_blocks)
                        # Release block only
						act = string("release ", string(a+1))
                        push!(stack, act)
                        precond = deepcopy(p_cond)
                        precond[num_blocks*num_blocks+2*num_blocks+a+1]=1
						push!(stack, precond)
                        push!(stack, num_blocks*num_blocks+2*num_blocks+a+1)
                    else
                        b=ano-(num_blocks*num_blocks+num_blocks)
						a=-1
                        for i in 0:num_blocks
							if(cur_state[i*num_blocks+b+1]==1)
                                a=i
                                break;
							end
						end
                        if(a!=-1)
							act = string("unstack ", string(a+1), " ", string(b+1))
                            push!(stack, act)
                            precond = deepcopy(p_cond)
							precond[num_blocks*a+b+1]=1
							precond[num_blocks*num_blocks+3*num_blocks+1]=1				
                            precond[num_blocks*num_blocks+num_blocks+a+1]=1
							push!(stack, precond)
                            push!(stack, num_blocks*num_blocks+num_blocks+a+1)
                            push!(stack, num_blocks*num_blocks+3*num_blocks+1)
                            push!(stack, num_blocks*a+b+1)
						end
					end
                elseif(ano<num_blocks*num_blocks+3*num_blocks) #If predicate is hold(x), selecting the relevant action to push on the stack
                    a = ano - (num_blocks*num_blocks+2*num_blocks)
					ontable = 0
					if(cur_state[num_blocks*num_blocks+a+1]==1) #made changes
                        ontable = 1
					end
					
                    if(ontable == 1)
                        act = string("pick ", string(a+1))
                        push!(stack, act)
                        precond = deepcopy(p_cond)
                        precond[num_blocks*num_blocks+a+1] = 1
                        precond[num_blocks*num_blocks+num_blocks+a+1] = 1
                        precond[num_blocks*num_blocks+3*num_blocks+1] = 1
                        push!(stack, precond)
                        push!(stack, num_blocks*num_blocks+3*num_blocks+1)
                        push!(stack, num_blocks*num_blocks+num_blocks+a+1)
                        push!(stack, num_blocks*num_blocks+a+1)
                    else
						b = -1
                        b1 = a*num_blocks
						b2 = (a+1)*num_blocks
						for i in b1:b2
                            if(cur_state[i]==1)
                                b=i
                                break
							end
						end
						
                        if(b != -1)
                            b=b-a*num_blocks
                            act = string("unstack ", string(a+1), " ", string(b))
                            push!(stack, act)
                            precond = deepcopy(p_cond)
							precond[num_blocks*a+b]=1
                            precond[num_blocks*num_blocks+3*num_blocks+1]=1
                            precond[num_blocks*num_blocks+num_blocks+a+1]=1
                            push!(stack, precond)
							push!(stack, num_blocks*num_blocks+num_blocks+a+1)
                            push!(stack, num_blocks*num_blocks+3*num_blocks+1)
                            push!(stack, num_blocks*a+b)
                            s
						end
					end
                else
                    a=-1
                    r1 = num_blocks*num_blocks+2*num_blocks
					r2 = num_blocks*num_blocks+3*num_blocks
                    println("Current State : ", cur_state)
					for i in r1:r2
                        if(cur_state[i] == 1)
                            a=i-num_blocks*num_blocks-2*num_blocks
                            break
						end
					end
                    println("A -------------> ", a)
					if(a!=-1)
						act = string("release ", string(a))
                        push!(stack, act)
                        precond = deepcopy(p_cond)
                        precond[num_blocks*num_blocks+2*num_blocks+a]=1
                        push!(stack, precond)
                        push!(stack, num_blocks*num_blocks+2*num_blocks+a)
					end
                end
            end
			println(stack)
        elseif(typeof_ == "String")  
            append!(actions_to_take, string(ele))
            elements=split(ele, " ")
			if(elements[1]=="pick")
				num = parse(Int64, elements[2])
                cur_state[num_blocks*num_blocks+num-1+1]=0                  # Not ontable
                cur_state[num_blocks*num_blocks+num_blocks+num-1+1]=0       # Not Clear
                cur_state[num_blocks*num_blocks+2*num_blocks+num-1+1]=1     # Hold Block
                cur_state[num_blocks*num_blocks+3*num_blocks+1]=0           # Not empty
            elseif(elements[1]=="unstack")
				num1 = parse(Int64, elements[2])
				num2 = parse(Int64, elements[3])
                cur_state[num_blocks*num_blocks+2*num_blocks+num1-1+1]=1     # Hold(A)
                cur_state[num_blocks*num_blocks+num_blocks+num2-1+1]=1       # Clear(B)
                cur_state[num_blocks*(num1-1)+num2-1+1]=0                    # not on(A,B)
                cur_state[num_blocks*num_blocks+3*num_blocks+1]=0            # not empty
                cur_state[num_blocks*num_blocks+num_blocks+num1-1+1]=0       # Not Clear(A)
            elseif(elements[1]=="release")
				num = parse(Int64, elements[2])
                cur_state[num_blocks*num_blocks+num-1+1]=1                  # ontable
                cur_state[num_blocks*num_blocks+num_blocks+num-1+1]=1       # Clear
                cur_state[num_blocks*num_blocks+2*num_blocks+num-1+1]=0     # Not Hold Block
                cur_state[num_blocks*num_blocks+3*num_blocks+1]=1           # empty
            elseif(elements[1]=="stack")
				num1 = parse(Int64, elements[2])
				num2 = parse(Int64, elements[3])
                cur_state[num_blocks*num_blocks+2*num_blocks+num1-1+1]=0     # Not Hold(A)
                cur_state[num_blocks*num_blocks+num_blocks+num2-1+1]=0       # Not Clear(B)
                cur_state[num_blocks*(num1-1)+num2-1+1]=1                    # on(A,B)
                cur_state[num_blocks*num_blocks+3*num_blocks+1]=1            # empty
                cur_state[num_blocks*num_blocks+num_blocks+num1-1+1]=1       # Clear(A)
			end
		end
	end
    return actions_to_take
end

#=+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#

file = readlines("input.txt") 

num_blocks = parse(Int64, file[1]) 
initial_state = file[2] 
goal_state = file[3]

println("NUMBER OF BLOCKS : ", num_blocks) 
println("INITIAL STATE    : ", initial_state) 
println("GOAL STATE       : ", goal_state)


#=+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#

s=[]
g=[]
num_nodes_expanded = 0

#=+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#


s_list = split(initial_state, " ") 
g_list = split(goal_state, " ") 

state_size = num_blocks^2+3*num_blocks+1 

s = fill(0, state_size)                       
g = fill(0, state_size)

#=+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#

for value in s_list   
    ele=value     
        ele=split(ele, "_") 
 
   if(ele[1]=="on")
         
               num1_ = map(translate, ele[2])  
               num2_ = map(translate, ele[3])  
               num1= parse(Int64, num1_) -1  
               num2= parse(Int64, num2_)         
      s[num1*num_blocks+num2]=1     
  elseif(ele[1]=="ontable")  
        
                  num1_ = map(translate, ele[2]) 
                  num1 = parse(Int64, num1_)        
         s[num_blocks*num_blocks+num1]=1  
  elseif(ele[1]=="clear")  
        
                  num1_ = map(translate, ele[2])  
                  num1= parse(Int64, num1_)        
         s[num_blocks*num_blocks+num_blocks+num1]=1         
  elseif(ele[1]=="hold")  
        num1_ = map(translate, ele[2])  
        num1= parse(Int64, num1_) -1        
        s[num_blocks*num_blocks+2*num_blocks+num1]=1
 elseif(ele[1]=="empty") 
            s[num_blocks*num_blocks+3*num_blocks+1]=1
        end 
end

#=+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#


for value in g_list 
    ele=value   
        ele=split(ele, "_") 
 
   if(ele[1]=="on") 
        
        num1_ = map(translate, ele[2])  
        num2_ = map(translate, ele[3])  
        num1= parse(Int64, num1_) -1  
        num2= parse(Int64, num2_)         
     g[num1*num_blocks+num2]=1 
 elseif(ele[1]=="ontable")
        
        num1_ = map(translate, ele[2]) 
        num1 = parse(Int64, num1_)        
     g[num_blocks*num_blocks+num1]=1    
        elseif(ele[1]=="clear") 
        
        num1_ = map(translate, ele[2])  
        num1= parse(Int64, num1_)       
    g[num_blocks*num_blocks+num_blocks+num1]=1     
        elseif(ele[1]=="hold")  num1_ = map(translate, ele[2])
        
        num1= parse(Int64, num1_) -1        
    g[num_blocks*num_blocks+2*num_blocks+num1]=1    
 elseif(ele[1]=="empty") 
        g[num_blocks*num_blocks+3*num_blocks+1]=1 
        end 
end

#=+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#

actions = goalStackPlanning(s, g)

#=+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#

println("Goal Stack Planning Algorithm Used")
println("Solution                 : ", actions)

#=+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#