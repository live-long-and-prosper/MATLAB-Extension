classdef MmfArray<handle
	%内存映射文件数组，可以将数组自动存储到文件中，节省内存，并可以在进程间共享
	%完成构造后，该类对象可以当作一个数组进行索引读取和赋值，但尺寸和数据类型不可变
	properties(Access=private)
		NeedCleanUp(1,1)logical
	end
	properties(GetAccess=private,SetAccess=immutable,Hidden)
		Path(1,1)string
		Mmf(1,1)
	end
	methods
		function obj = MmfArray(ArrayClass,varargin)
			%% 构造语法
			% import MATLAB.IOFun.MmfArray
			% obj=MmfArray(Array);
			% obj=MmfArray(Class,Size);
			% obj=MmfArray(Class,Size1,Size2,…);
			% obj=MmfArray(____,Path);
			%% 输入参数
			% Array：任意现有数组，将写入内存映射文件
			% Class(1,1)string：数据类型，支持所有MATLAB基本实数数据类型
			% Size(1,:)uint64，数组尺寸向量，至少应包含2个元素
			% Size1,Size2,…(1,1)uint64，重复输入各维尺寸，至少应输入前两维尺寸
			% Path(1,1)string，文件路径，默认自动生成临时文件路径。该参数可以加在上述任意组合之后。指定相同的路径可以在进程间共享数据。
			TempFile=fullfile(tempdir,char(java.util.UUID.randomUUID));
			switch numel(varargin)
				case 0
					Size=size(ArrayClass);
					Class=class(ArrayClass);
					obj.Path=TempFile;
					Array=ArrayClass;
				case 1
					SizePath=varargin{1};
					if isnumeric(SizePath)
						Class=ArrayClass;
						Size=SizePath;
						obj.Path=TempFile;
						Array=[];
					else
						Size=size(ArrayClass);
						Class=class(ArrayClass);
						obj.Path=SizePath;
						Array=ArrayClass;
					end
				otherwise
					if isnumeric(varargin{end})
						obj.Path=TempFile;
						Size=cell2mat(varargin);
						Class=ArrayClass;
					else
						obj.Path=varargin{end};
						Size=cell2mat(varargin(1:end-1));
						Class=ArrayClass;
					end
					Array=[];
			end
			FileSize=str2double(extract(Class,digitsPattern))/8*prod(Size);
			CreateCommand=sprintf('fsutil file createNew "%s" %u',obj.Path,FileSize);
			obj.NeedCleanUp=~isfile(obj.Path);
			if obj.NeedCleanUp
				system(CreateCommand);
			else
				if dir(obj.Path).bytes<FileSize
					delete(obj.Path);
					system(CreateCommand);
				end
			end
			obj.Mmf=memmapfile(obj.Path,Writable=true,Format={Class,Size,'Data'});
			if ~isempty(Array)
				obj.Mmf.Data.Data(:)=Array(:);
			end
		end
		function delete(obj)
			if obj.NeedCleanUp
				delete(obj.Path);
			end
		end
		function obj=subsasgn(obj,S,B)
			obj.Mmf.Data.Data(S.subs{:})=B;
		end
		function B=subsref(obj,S)
			B=obj.Mmf.Data.Data(S.subs{:});
		end
		function S=size(obj,varargin)
			S=size(obj.Mmf.Data.Data,varargin{:});
		end
	end
end