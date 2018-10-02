module Graphics exposing (..)
import WebGL exposing (Mesh, Shader, entity)
import Model exposing (Model, getAngle)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Color exposing (Color)
 
type alias Vertex = 
    { color : Vec3
    , position : Vec3
    }
    
type alias Uniforms = 
    { rotation : Mat4
    , perspective : Mat4
    , camera : Mat4
    , shade : Float
    }    

cube : Model -> WebGL.Entity
cube model =
    let uni = model |> getAngle |> uniforms in
    entity vertexShader fragmentShader cubeMesh uni

uniforms : Float -> Uniforms
uniforms theta = 
    { rotation =
        Mat4.mul
            ( Mat4.makeRotate ( Basics.pi/8 ) ( vec3 1 0 0 ) )        
            ( Mat4.makeRotate ( 2 * theta ) ( vec3 0 1 0 ) )              
    , perspective = Mat4.makePerspective 45 1 0.01 100
    , camera = Mat4.makeLookAt ( vec3 0 0 5 ) ( vec3 0 0 0 ) ( vec3 0 1 0 )
    , shade = 0.8 
    }

face : Color -> Vec3 -> Vec3 -> Vec3 -> Vec3 -> List ( Vertex, Vertex, Vertex )
face rawColor a b c d = 
    let
        color = 
            let parsedColor = Color.toRgba rawColor
            in 
                vec3
                    ( parsedColor.red  )
                    ( parsedColor.green )
                    ( parsedColor.blue )
        vertex position = 
            Vertex color position
    in
        [ ( vertex a, vertex b, vertex c )
        , ( vertex c, vertex d, vertex a )
        ]

vertexShader : Shader Vertex Uniforms { vcolor : Vec3 }
vertexShader = 
    [glsl|

        attribute vec3 position;
        attribute vec3 color;
        uniform mat4 perspective;
        uniform mat4 camera;
        uniform mat4 rotation;
        varying vec3 vcolor;
        void main() {
            gl_Position = perspective * camera * rotation * vec4(position, 1.0);
            vcolor = color;
        }

    |]

fragmentShader : Shader {} Uniforms { vcolor : Vec3 }
fragmentShader = 
    [glsl|
        
        precision mediump float;
        uniform float shade;
        varying vec3 vcolor;
        void main() {
            gl_FragColor = shade * vec4(vcolor, 1.0);
        }
    |]

cubeMesh : Mesh Vertex
cubeMesh = 
    let
        rft = vec3 1 1 1
        lft = vec3 -1 1 1
        lbt = vec3 -1 -1 1
        rbt = vec3 1 -1 1
        rbb = vec3 1 -1 -1
        rfb = vec3 1 1 -1
        lfb = vec3 -1 1 -1
        lbb = vec3 -1 -1 -1
    in
        [ face Color.green rft rfb rbb rbt
        , face Color.blue rft rfb lfb lft
        , face Color.yellow rft lft lbt rbt
        , face Color.red rfb lfb lbb rbb
        , face Color.purple lft lfb lbb lbt
        , face Color.orange rbt rbb lbb lbt
        ]
        |> List.concat
        |> WebGL.triangles