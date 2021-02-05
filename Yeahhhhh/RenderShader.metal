//
//  RenderShader.metal
//  Yeahhhhh
//
//  Created by クワシマ・ユウキ on 2021/02/04.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct RasterizerData{
    float4 position [[position]];
    float4 color;
};

vertex RasterizerData test_vertex (const VertexIn vIn [[ stage_in ]]){
    RasterizerData rd;
    rd.position = float4(vIn.position, 1);
    rd.color = vIn.color;
    return rd;
}

//vertex float4 basic_vertex_shader(device VertexIn *vertices [[buffer(0)]], uint vertexID [[vertex_id]]){
//    return float4(vertices[vertexID].position, 1);
//}

fragment half4 test_fragment (RasterizerData rd [[stage_in]]){
    float4 color = rd.color;
    return half4(color.r, color.g, color.b, color.a);
}
