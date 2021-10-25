classdef IImageWriter5D<handle
	%5D图像写出器接口类
	methods(Abstract)
		%按照指定的5D范围向文件中写出图像数据。
		%示例：obj.Write5D(Image,X=1:100,C=2:3,T=200:-2:2,Z=1);
		%必需参数：Image(:,:,:,:,:)，要写出的图像数据
		%名称值参数：X, Y, C, T, Z，5个维度上的写出范围。这些范围的尺寸应当和Image对应维度尺寸相同。
		Write5D(obj,Image,Range)
		%按照指定的CTZ范围向文件中写出图像数据。当不需要指定XY范围时，这样写出应当性能更高。
		%示例：obj.Write3D(Image,C=2:3,T=200:-2:2,Z=1);
		%必需参数：Image(:,:,:,:,:)，要写出的图像数据
		%名称值参数：C, T, Z，3个维度上的写出范围。这些范围的尺寸应当和Image对应维度尺寸相同。
		Write3D(obj,Image,Range)
	end
end