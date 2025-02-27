using LiveServer;
cd(joinpath(@__DIR__, "build")) do
    LiveServer.serve()
end
