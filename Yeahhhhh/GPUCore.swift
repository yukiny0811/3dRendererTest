//
//  GPUCore.swift
//  Yeahhhhh
//
//  Created by クワシマ・ユウキ on 2021/02/04.
//

import Metal
import simd

class GPUCore {
    
    public static let shared = GPUCore()
    
    public var device: MTLDevice!
    public var library: MTLLibrary!
    public var commandQueue: MTLCommandQueue!
    
    private static var computePipelineStates: [String: MTLComputePipelineState] = [:]
    
    private init() {
        self.device = MTLCreateSystemDefaultDevice()!
        let frameworkBundle = Bundle(for: GPUCore.self)
        library = try! self.device.makeDefaultLibrary(bundle: frameworkBundle)
        commandQueue = self.device.makeCommandQueue()!
    }
    
    public func RunRender_Default(_ vertexFunctionName: String, _ fragmentFunctionName: String, _ renderCommandEncoder: inout MTLRenderCommandEncoder, _ vertexDatas: [Vertex]) {
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        let vertexFunction = self.library.makeFunction(name: vertexFunctionName)
        renderPipelineDescriptor.vertexFunction = vertexFunction
        
        let fragmentFunction = self.library.makeFunction(name: fragmentFunctionName)
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.size
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        let renderPipelineState = try! self.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        
        let vertexBuffer = self.device.makeBuffer(bytes: vertexDatas, length: MemoryLayout<Vertex>.stride * vertexDatas.count, options: [])
        
        renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexDatas.count)
    }
}

struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
}
