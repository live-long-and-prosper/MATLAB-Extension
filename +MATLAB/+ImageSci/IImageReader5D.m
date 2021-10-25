classdef IImageReader5D<handle
	%5D图像读取器接口类
	properties(Abstract,SetAccess=immutable)
		%图像宽度
		SizeX(1,1)uint16
		%图像高度
		SizeY(1,1)uint16
		%图像颜色通道数
		SizeC(1,1)uint16
		%图像采样时点数
		SizeT(1,1)uint16
		%图像深度
		SizeZ(1,1)uint16
		%像素值的数据类型
		PixelType(1,:)char
		%元数据
		Metadata(1,1)
	end	
	methods(Abstract)
		%按照指定的5D范围从文件中读取图像数据。
		%示例：Image=obj.Read5D(MATLAB.IOFun.MmfArray('uint16',512,100,2,100,1),X=1:100,C=2:3,T=200:-2:2,Z=1);
		%可选参数：Target，一个自定义对象，用于存储读取到的数据。对象必须支持subsasgn方法。
		%名称值参数：X, Y, C, T, Z，5个维度上的读取范围。
		%返回值：Image(:,:,:,:,:)，相应的图像数据。如果指定了Target，将返回此Target
		Image=Read5D(obj,Target,Range)
		%按照指定的CTZ范围从文件中读取图像数据。当不需要指定XY范围时，这样读取应当性能更高。
		%示例：Image=obj.Read3D(MATLAB.IOFun.MmfArray('uint16',512,100,2,100,1),C=2:3,T=200:-2:2,Z=1);
		%可选参数：Target，一个自定义对象，用于存储读取到的数据。对象必须支持subsasgn方法。
		%名称值参数：C, T, Z，3个维度上的读取范围
		%返回值：Image(:,:,:,:,:)，相应的图像数据。如果指定了Target，将返回此Target
		Image=Read3D(obj,Target,Range)
	end
end