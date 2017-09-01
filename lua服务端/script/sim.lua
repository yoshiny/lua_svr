dofile("script/PacketHandler.lua")
 
function StartUp( )
	print("StartUp")
 
	--连接sqlite3数据库
	env = luasql.sqlite3() 
	db = env:connect("test.db") 

	--启动网络
	net= G_NetInit("0.0.0.0",123)
	if net ~=nil then
		print(  "G_NetInit  ok" )
	else	
		print(  "G_NetInit  err" )
	end
	
 
end

TickCount=1
function Update( )
	print("Update "..TickCount )

	G_NetUpdate(net)

	print("当前连接数: "..G_NetConnNums(net) )

	db:execute [[ drop  TABLE people ]] 

	db:execute [[CREATE TABLE people(name text, sex text)]] 

	db:execute [[INSERT INTO people VALUES('张三','男')]] 
	db:execute [[INSERT INTO people VALUES('李四', '女')]] 
  

	rs =  db:execute [[SELECT * FROM people]] 
	row = fetch( rs )
	while row do
	  print (string.format("Name: %s, sex: %s", row.name, row.sex))
	  row =  next ( rs,row ) 
	end
	
	rs:close()


	--TickCount=TickCount+1
	--if TickCount>5 then 
	--	G_Exit()
	--end 
end
  
function Shutdown( )
	print("Shutdown")

	G_NetShutdown(net)

	db:close()
	env:close()
end


function fetch(c)
	return c:fetch ({}, "a") 
end
function next(c,row)
	return c:fetch (row, "a")
end
  
 
 
 
--数据接收
function OnRecvData(idx,data,len)
 
	print("------------OnRecvData--------------")
	print("------------idx["..idx.."]" )
	print("----------len["..len.."]--data[" .. data .. "]--------------")
	  
	ParsePacket(idx,data,len)
	  
end

-- 连接断开
function OnClose(idx)
 	print(  "OnClose idx:"..idx );
 
end
