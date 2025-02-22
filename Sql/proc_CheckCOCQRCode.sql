USE [ERP2015]
GO
/****** Object:  StoredProcedure [dbo].[proc_CheckCOCQRCode]    Script Date: 1/6/2025 2:36:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	kaikai
-- Create date: 2017/9/23
-- Description:	檢查二維碼內容
-- =============================================
ALTER PROCEDURE [dbo].[proc_CheckCOCQRCode]
	@bu nvarchar(6),	--營運中心
	@dno nvarchar(20),	--流水號
	@ditem int			--序號	
AS	
	declare @orderno nvarchar(10)
	declare @orderitem int
	declare @custno nvarchar(10)
	declare @custno_1 nvarchar(10)
	declare @remark nvarchar(400)
	declare @isccl bit
	
	declare @ischk bit				--檢查二維碼
	declare @iscy bit				--超毅客戶
	declare @isfz bit				--方正客戶
	declare @ad nvarchar(1)			--膠系
	declare @strip float			--條數
	declare @struct nvarchar(50)	--結構:dli150
	declare @sizes nvarchar(50)		--經偉、尺寸、幅寬
	declare @fzpo nvarchar(50)		--方正po
	
	declare @A bit --c_orderno
	declare @B bit --c_pno
	declare @C bit --c_sizes
	declare @D bit --struct @struct
	declare @E bit --sizes @sizes
	declare @F bit --grade

	declare @oea10 nvarchar(50)		--客戶訂單號
	declare @oeb04 nvarchar(50)		--料號
	declare @oeb11 nvarchar(50)		--客戶料號
	declare @ta_oeb01 float			--經向
	declare @ta_oeb02 float			--緯向
	declare @ta_oeb10 nvarchar(200)	--客戶品名
	declare @oao06 nvarchar(100)	--訂單備註:超毅訂單號碼
	
	declare @sno int				--二維碼欄位
	declare @fname1 nvarchar(200)
	declare @fname2 nvarchar(200)
	declare @fname3 nvarchar(200)
	declare @fname4 nvarchar(200)
	declare @fname5 nvarchar(200)
	declare @fname6 nvarchar(200)
	declare @fname7 nvarchar(200)
	declare @fname8 nvarchar(200)
	declare @fname9 nvarchar(200)
	declare @fname10 nvarchar(200)
	declare @fname11 nvarchar(200)
	declare @fname12 nvarchar(200)
	declare @fname13 nvarchar(200)
	declare @fname14 nvarchar(200)
	declare @fname15 nvarchar(200)
	declare @fname16 nvarchar(200)
	declare @fname17 nvarchar(200)
	declare @fname18 nvarchar(200)
	declare @fname19 nvarchar(200)
	declare @fname20 nvarchar(200)
	
	declare @p1 int
	declare @p2 int
	declare @str nvarchar(200)
	declare @s nvarchar(20)
	declare @sql nvarchar(1000)
	declare @t1 table(oea10 nvarchar(50),oeb04 nvarchar(50),oeb11 nvarchar(50),ta_oeb01 float,ta_oeb02 float,ta_oeb10 nvarchar(200),oao06 nvarchar(100))
	declare @t2 table(sno int,remark nvarchar(200)) --sno=0:作業中不顯示(測試用),sno=-1:異常,sno>0:二維碼判斷結果
	declare @t3 table(sno nvarchar(200))

	select @p1=count(*) from dli040 where bu=@bu and dno=@dno and ditem=@ditem
	select @p2=count(*) from dli041 where bu=@bu and dno=@dno and ditem=@ditem
		
	if @p2=0
	begin
		if lower(@bu)='iteqdg'
			insert into @t2(sno,remark) values(-1,'無二維碼資料')
		else
			insert into @t2(sno,remark) values(0,'無二維碼資料')
		select * from @t2
		return
	end
	
	if lower(@bu)='iteqdg'
	begin
		if @p1<>@p2
		begin
			insert into @t2(sno,remark) values(-1,'批號資料筆數<>二維碼資料筆數')
			select * from @t2
			return
		end
	end
	
	--出貨排程		
	select @orderno=orderno,@orderitem=orderitem,@custno=custno,@oeb04=pno,@remark=remark,
		@isccl=(case when left(pno,1) in ('E','T') then 1 else 0 end) from dli010 
	where bu=@bu and dno=@dno and ditem=@ditem
	if len(isnull(@orderno,''))=0 or isnull(@orderitem,0)<=0
		select @orderno=orderno,@orderitem=orderitem,@custno=custno,@remark=remark,
			@isccl=(case when left(pno,1) in ('E','T') then 1 else 0 end) from dli010_20160409 
		where bu=@bu and dno=@dno and ditem=@ditem
	if len(isnull(@orderno,''))=0 or isnull(@orderitem,0)<=0	
	begin
		insert into @t2(sno,remark) values(-1,'出貨排程不存在')
		select * from @t2
		return
	end
	
	--實際客戶編號@custno_1
	set @custno_1=@custno
	set @p1=charindex('-',@remark)
	if @custno in ('N012','N005') and @p1>0
		set @custno_1=left(@remark,@p1-1)
	
	--管控參數設定
	select top 1 @A=c_orderno,@B=c_pno,@C=c_sizes,@D=struct,@E=sizes,@F=grade from dli580
	where bu=@bu and (custno=@custno or custno=@custno_1 or custno='@') and ccl=@isccl
	order by (case when custno='@' then 'ZZZZZ@@@' else custno end)
	set @A=isnull(@A,0)
	set	@B=isnull(@B,0)
	set	@C=isnull(@C,0)
	set	@D=isnull(@D,0)
	set	@E=isnull(@E,0)
	set	@F=isnull(@F,0)
	if (@A=0) and (@B=0) and (@C=0) and (@D=0) and (@E=0) and (@F=0)
	begin
		insert into @t2(sno,remark) values(0,'管控表無設定')
		select * from @t2
		return
	end
	if @isccl=0 --pp不檢查結構
		set @D=0
	
	--原始訂單
	set @sql='select a.oea10,a.oeb04,a.oeb11,a.ta_oeb01,a.ta_oeb02,a.ta_oeb10,b.oao06 from (
			select oea01,oea10,oeb03,oeb04,oeb11,ta_oeb01,ta_oeb02,ta_oeb10
			from oea_file,oeb_file where oea01=oeb01 
			and oea01='''''+@orderno+''''' and oeb03='+cast(@orderitem as nvarchar(10))+') a left join oao_file b 
			on a.oea01=b.oao01 and a.oeb03=b.oao03'
	if lower(@bu)='iteqdg'
		set @sql='select * from openquery(iteqdg,'''+@sql+''')'
	else
		set @sql='select * from openquery(iteqgz,'''+@sql+''')'
	insert into @t1(oea10,oeb04,oeb11,ta_oeb01,ta_oeb02,ta_oeb10,oao06) exec (@sql)
	if not exists(select 1 from @t1)
	begin
		insert into @t2(sno,remark) values(-1,'原始訂單不存在')
		select * from @t2
		return
	end
	update @t1 set ta_oeb10=custname from dli010 where bu=@bu and remark=oao06 and isnull(ta_oeb10,'')=''
	select top 1 @oea10=isnull(oea10,''),@oeb04=isnull(oeb04,''),@oeb11=isnull(oeb11,''),
		@ta_oeb01=ta_oeb01,@ta_oeb02=ta_oeb02,@ta_oeb10=isnull(ta_oeb10,''),@oao06=isnull(oao06,'')
	from @t1
	
	set @iscy=0
	set @isfz=0
	set @ischk=0
	if charindex(@custno,'AC405/AC311/AC310/AC075/AC950')>0
		set @iscy=1
		
	if charindex(@custno,'AC114/ACG16/AC365/AC388/AC434/ACD39')>0 or charindex(@custno_1,'AC114/ACG16/AC365/AC388/AC434/ACD39')>0
		set @isfz=1
			
	if @iscy=1 or @isfz=1 or charindex(@custno,'AC108/ACC58/ACD04/AC084')>0 or charindex(@custno_1,'AC108/ACC58/ACD04/AC084')>0
		set @ischk=1
			
	--@oea10:超毅客戶訂單號在備註
	if @iscy=1 and (charindex('RD0086',@oao06)>0 or charindex('50249-',@oao06)>0)
	begin
		set @oea10=@oao06
		set @p1=charindex(';',@oea10)
		set @p2=charindex('；',@oea10)
		if (@p1=0) or ((@p1>@p2) and (@p2>0))
		   set @p1=@p2
		if @p1>0
			set @oea10=left(@oea10,@p1-1)
		if charindex('50249-',@oea10)>0
		begin
			set @oea10=replace(@oea10,'50249-','')
			set @p1=charindex('-',@oea10)
			if @p1>0
				set @oea10=left(@oea10,@p1-1)
		end
	end

	--無錫訂單終端料號
	if @custno='N006'
	begin
		declare @wx table(remark varchar(100),oea10 varchar(100),oeb11 varchar(100),ta_oeb10 varchar(100),oea04 varchar(100),occ02 varchar(100))
		insert into @wx exec proc_GetWxOrderInfo @oao06  
		select @oeb11=oeb11 from @wx
	end
	
	--@oea10:方正客戶訂單號在備註,備註中找不到取原oea10
	if @isfz=1
	begin
		exec [dbo].[proc_GetFZPO] @bu,@oao06,@fzpo output
		if len(@fzpo)>0
			set @oea10=@fzpo
		else if (@custno='ACD39' and left(@oao06,1)='4') or left(@oao06,2)='PO'
		begin
			set @oea10=@oao06
			set @p1=charindex(',',@oea10)
			if @p1>0
				set @oea10=left(@oea10,@p1-1)
		end
	end
	
	--@struct結構
	if @isccl=1
		set @strip=cast(substring(@oeb04,3,4) as float)/10000
	else
		set @strip=0
	if @D=1 and @isccl=1
	begin
		set @str=left(right(@oeb04,3),1)
		if @str in ('A','B','C','D','E','F','G','V')
		begin
			set @str='struct'+@str
			set @ad=substring(@oeb04,2,1)
			--set @strip=cast(substring(@oeb04,3,4) as float)/10000
			if exists(select 1 from dli150 where bu=@bu and custno=@custno and adhesive=@ad and strip=@strip)
			begin
				set @sql='select @struct='+@str+' from dli150 where bu=@bu and custno=@custno and adhesive=@ad and strip=@strip'
				exec sp_executesql @sql,N'@struct nvarchar(50) out,@bu nvarchar(6),@custno nvarchar(10),@ad nvarchar(1),@strip float',@struct out,@bu,@custno,@ad,@strip
			end else
			if exists(select 1 from dli150 where bu=@bu and custno='@' and adhesive=@ad and strip=@strip)
			begin
				set @sql='select @struct='+@str+' from dli150 where bu=@bu and custno=''@'' and adhesive=@ad and strip=@strip'
				exec sp_executesql @sql,N'@struct nvarchar(20) out,@bu nvarchar(6),@ad nvarchar(1),@strip float',@struct out,@bu,@ad,@strip
			end	else	
			if exists(select 1 from dli150 where bu=@bu and custno='@' and adhesive='@' and strip=@strip)
			begin
				set @sql='select @struct='+@str+' from dli150 where bu=@bu and custno=''@'' and adhesive=''@'' and strip=@strip'
				exec sp_executesql @sql,N'@struct nvarchar(20) out,@bu nvarchar(6),@strip float',@struct out,@bu,@strip
			end
			
			if len(isnull(@struct,''))=0
			begin
				insert into @t2(sno,remark) values(-1,'結構表設定不存在')
				select * from @t2
				return
			end
		end		
	end
	
	--@sizes尺寸,pnl尺寸另外處理
	if @E=1
	begin
		if @isccl=1 and len(@oeb04)=17
			set @sizes=cast(cast(substring(@oeb04,9,3) as float)/10 as nvarchar(10))+'*'+cast(cast(substring(@oeb04,12,3) as float)/10 as nvarchar(10))
		else 
		if @isccl=0 and len(@oeb04)=18
			set @sizes=cast(cast(substring(@oeb04,14,3) as float)/10 as nvarchar(10))
	end
		
	declare c cursor for
	select sno,isnull(fname1,'') fname1,isnull(fname2,'') fname2,isnull(fname3,'') fname3,isnull(fname4,'') fname4,isnull(fname5,'') fname5,
		isnull(fname6,'') fname6,isnull(fname7,'') fname7,isnull(fname8,'') fname8,isnull(fname9,'') fname9,isnull(fname10,'') fname10,
		isnull(fname11,'') fname11,isnull(fname12,'') fname12,isnull(fname13,'') fname13,isnull(fname14,'') fname14,isnull(fname15,'') fname15,
		isnull(fname16,'') fname16,isnull(fname17,'') fname17,isnull(fname18,'') fname18,isnull(fname19,'') fname19,isnull(fname20,'') fname20 from dli041 
	where bu=@bu and dno=@dno and ditem=@ditem order by sno
	open c
	fetch next from c into @sno,@fname1,@fname2,@fname3,@fname4,@fname5,@fname6,@fname7,@fname8,@fname9,@fname10,@fname11,@fname12,@fname13,@fname14,@fname15,@fname16,@fname17,@fname18,@fname19,@fname20
	while(@@fetch_status=0)
	begin
		if @isccl=1
		begin
			--板厚
			if @bu='ITEQDG'
			begin
				declare @banhou varchar(50)
				if CHARINDEX('不含銅',@fname5)>0
				begin
				  select @banhou=ltrim(rtrim(exccu)) from dli032 where bu=@bu and custno=@custno_1 and adhesive=@ad and thick=substring(@oeb04,3,4) and copper=substring(@oeb04,7,2)
				end
				else if CHARINDEX('含銅',@fname5)>0
				begin
				  select @banhou=ltrim(rtrim(inccu)) from dli032 where bu=@bu and custno=@custno_1 and adhesive=@ad and thick=substring(@oeb04,3,4)	and copper=substring(@oeb04,7,2)	
				end
				if isnull(@banhou,'')<>''-- is not null
				begin
				  if CHARINDEX(@banhou,@fname5)=0	
					insert into @t2(sno,remark) values(@sno,'板厚不符:'+@fname5+'  板厚設定:'+@banhou)
				end    
			end  -- select * from dli032 where custno='AC365'  ' 30+/-3'
			--板厚
		
			if CHARINDEX(@ad,'9XYZt')>0 
			begin
			  if CHARINDEX(ltrim(rtrim(@fname7)),@fname5)=0
					insert into @t2(sno,remark) values(@sno,'結構與客戶品名不符:'+@fname7)
			end
		
			if @A=1 and @oea10<>@fname9
			begin
				set @str=@fname9
				if @iscy=1 and charindex('50249-',@str)>0
				begin
					set @str=replace(@str,'50249-','')
					set @p1=charindex('-',@str)
					if @p1>0
						set @str=left(@str,@p1-1)
				end
				if @oea10<>@str
					insert into @t2(sno,remark) values(@sno,'客戶訂單號不符:'+@oea10)
			end
			
			if @B=1 and @oeb11<>@fname6
				insert into @t2(sno,remark) values(@sno,'客戶產品編號不符:'+@oeb11)
			
			if @C=1 and @ta_oeb10<>@fname5
				insert into @t2(sno,remark) values(@sno,'客戶品名不符:'+@ta_oeb10)
			
			if @D=1
			begin
				set @str=replace(@fname7,' ','')
				print('struct:'+@struct)
				print('str:'+@str)
				if @struct<>@str
				begin
					set @p1=charindex('+',@struct)
					if @p1>0 --反過來再比較一次
						set @struct=right(@struct,len(@struct)-@p1)+'+'+left(@struct,@p1-1)
					if @struct<>@str
						insert into @t2(sno,remark) values(@sno,'結構不符:'+@struct)	
				end
			end
			
			if @E=1
			begin
				set @str=replace(replace(replace(replace(replace(replace(@fname8,'G',''),'經',''),'緯',''),'向',''),'(',''),')','')
				set @str=replace(replace(@str,'g',''),'n','')
				if len(@oeb04)=17
				begin
					set @p1=charindex('.0*',@str)
					if @p1>0
						set @str=replace(@str,'.0*','*')
					if right(@str,2)='.0'
						set @str=left(@str,len(@str)-2)
					if @sizes<>@str
						insert into @t2(sno,remark) values(@sno,'尺寸不符:'+@sizes)	
				end else
				begin
					set @p1=charindex('*',@str)
					if @p1>0
					begin
						set @s=left(@str,@p1-1)						
						if isnumeric(@s)=1
						begin
							if @ta_oeb01<>cast(@s as float)
								insert into @t2(sno,remark) values(@sno,'尺寸經向不符:'+cast(@ta_oeb01 as nvarchar(10))+'<>'+@s)
						end else
							insert into @t2(sno,remark) values(@sno,'尺寸無法轉換為數字:'+@s)						
						
						set @s=right(@str,len(@str)-@p1)
						if isnumeric(@s)=1
						begin
							if @ta_oeb02<>cast(@s as float)
								insert into @t2(sno,remark) values(@sno,'尺寸緯向不符:'+cast(@ta_oeb02 as nvarchar(10))+'<>'+@s)
						end else
							insert into @t2(sno,remark) values(@sno,'尺寸無法轉換為數字:'+@s)	
					end else
						insert into @t2(sno,remark) values(@sno,'尺寸不符:'+@sizes)	
				end
			end
			
			if @F=1
			begin
				set @str=isnull(@fname11,'')			
				if len(@str)>0
				begin
					if @custno_1 in ('AC096','AC093','AC394','AC152','AC172','ACC19','AH017','AH036')
					begin
						if @str<>'A+'
							insert into @t2(sno,remark) values(@sno,'級別應為A+,當前:'+@str)
					end	else
					if @custno_1 in ('AC116') and (@strip>=0.0037) 
					begin
						if @str<>'A+'
							insert into @t2(sno,remark) values(@sno,'級別應為A+,當前:'+@str)
					end else
					begin
						if @str<>'A'
							insert into @t2(sno,remark) values(@sno,'級別應為A,當前:'+@str)
					end
				end
			end	
		end else
		begin
			if @A=1 and @oea10<>@fname9
			begin
				set @str=@fname9
				if @iscy=1 and charindex('50249-',@str)>0
				begin
					set @str=replace(@str,'50249-','')
					set @p1=charindex('-',@str)
					if @p1>0
						set @str=left(@str,@p1-1)
				end
				if @oea10<>@str
					insert into @t2(sno,remark) values(@sno,'客戶訂單號不符:'+@oea10)
			end
			
			if @B=1 and @oeb11<>@fname7
				insert into @t2(sno,remark) values(@sno,'客戶產品編號不符:'+@oeb11)

			if @C=1 and @ta_oeb10<>@fname6
				insert into @t2(sno,remark) values(@sno,'客戶品名不符:'+@ta_oeb10)

			if @E=1
			begin
				set @str=replace(replace(replace(replace(replace(replace(@fname8,'G',''),'經',''),'緯',''),'向',''),'(',''),')','')
				set @str=replace(replace(@str,'g',''),'n','')
				if len(@oeb04)=18
				begin
					if right(@str,2)='.0'
						set @str=left(@str,len(@str)-2)
					if @sizes<>@str
						insert into @t2(sno,remark) values(@sno,'尺寸不符:'+@sizes)	
				end else
				begin
					set @p1=charindex('*',@str)
					if @p1>0
					begin
						set @s=left(@str,@p1-1)						
						if isnumeric(@s)=1
						begin
							if @ta_oeb01<>cast(@s as float)
								insert into @t2(sno,remark) values(@sno,'尺寸經向不符:'+cast(@ta_oeb01 as nvarchar(10))+'<>'+@s)
						end else
							insert into @t2(sno,remark) values(@sno,'尺寸無法轉換為數字:'+@s)						
						
						set @s=right(@str,len(@str)-@p1)
						if isnumeric(@s)=1
						begin
							if @ta_oeb02<>cast(@s as float)
								insert into @t2(sno,remark) values(@sno,'尺寸緯向不符:'+cast(@ta_oeb02 as nvarchar(10))+'<>'+@s)
						end else
							insert into @t2(sno,remark) values(@sno,'尺寸無法轉換為數字:'+@s)	
					end else
						insert into @t2(sno,remark) values(@sno,'尺寸不符:'+@sizes)
				end
			end		
		end

		if @ischk=1
		begin
			if @isccl=1
				set @str=@fname10
			else
				set @str=@fname11
			/*	
			if @iscy=1 
			begin
				if len(@str)<>17
					insert into @t2(sno,remark) values(@sno,'超毅集團流水號錯誤,應為17碼:'+@str)
			end
			else */
			if @isfz=1 
			begin
				if len(@str)<>13
					insert into @t2(sno,remark) values(@sno,'方正集團流水號錯誤,應為13碼:'+@str)
			end
			else if (@custno='AC108' or @custno_1='AC108') 
			begin
				if len(@str)<>9
					insert into @t2(sno,remark) values(@sno,'至卓曲江流水號錯誤,應為9碼:'+@str)
			end
			else if (@custno='ACC58' or @custno_1='ACC58')
			begin
				if len(@str)<>16
					insert into @t2(sno,remark) values(@sno,'江西志浩流水號錯誤,應為16碼:'+@str)
			end
			/*  胡美香 取消 20221107
			else if (charindex(@custno,'ACD04/AC084')>0 or charindex(@custno_1,'ACD04/AC084')>0)
			begin
				if len(@str)<>10
					insert into @t2(sno,remark) values(@sno,'生益流水號錯誤,應為10碼:'+@str)
			end
			*/
		end
		
		fetch next from c into @sno,@fname1,@fname2,@fname3,@fname4,@fname5,@fname6,@fname7,@fname8,@fname9,@fname10,@fname11,@fname12,@fname13,@fname14,@fname15,@fname16,@fname17,@fname18,@fname19,@fname20
	end
	close c
	dealLocate c
	
	--檢查流水號是否重復
	/*
	if @ischk=1
	begin
		select top 1 @str=custno from dli041 where bu=@bu and dno=@dno and ditem=@ditem and len(isnull(custno,''))>0
		
		if @isccl=1
		begin
			insert into @t3(sno)
			select fname10 from dli041 where bu=@bu and dno=@dno and ditem=@ditem and len(isnull(fname10,''))>0
			
			if exists(select 1 from @t3)
			begin
				insert into @t2(sno,remark)
				select 999,'流水號重復:'+fname10 from(
				select fname10 from dli041 where bu=@bu and fname10 in (select sno from @t3) and custno=@str
				union all
				select fname10 from dli041_bak where bu=@bu and fname10 in (select sno from @t3) and custno=@str) t
				group by fname10
				having count(*)>1
			end
		end else
		begin
			insert into @t3(sno)
			select fname11 from dli041 where bu=@bu and dno=@dno and ditem=@ditem and len(isnull(fname11,''))>0
			
			if exists(select 1 from @t3)
			begin
				insert into @t2(sno,remark)
				select 999,'流水號重復:'+fname11 from(
				select fname11 from dli041 where bu=@bu and fname11 in (select sno from @t3) and custno=@str
				union all
				select fname11 from dli041_bak where bu=@bu and fname11 in (select sno from @t3) and custno=@str) t
				group by fname11
				having count(*)>1
			end
		end		
	end
	*/

	select * from @t2
