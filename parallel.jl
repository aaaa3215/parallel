function test2d()
    comm = MPI.COMM_WORLD
    myrank = MPI.Comm_rank(comm)

    Nx = 100
    Ny = 100
    N = Nx*Ny
    wa = 0
    dkx = 2π/(Nx-1)
    dky = 2π/(Ny-1)

    ista,iend,nbun = start_and_end(N,comm)
    for i=ista:iend
        ikx,iky=i2xy(i,Nx)
        kx = (ikx-1)*dkx -π
        ky = (iky-1)*dky -π
        wa += cos(kx)+cos(ky)
    end
    wa /= Nx*Ny
    println("$myrank: pertial sum = $wa")
    wa = MPI.Allreduce(wa,MPI.SUM,comm)
    println("$myrank: sum = $wa")

    return wa
end

function i2xy(i,Nx)
    x = ((i-1) % Nx)+1
    y = div((i-x),Nx)+1
    return x,y
end

MPI.Init() # MPI初期化
test2d()
MPI.Finalize() #MPI終了

