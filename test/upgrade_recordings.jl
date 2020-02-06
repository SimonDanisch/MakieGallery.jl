using MakieGallery

# load the database.  TODO this is a global and should be changed.
# Here, we reorder the database, to make it easier to see.
database = MakieGallery.load_database([
    "tutorials.jl",
    "layouting.jl",
    "statsmakie.jl",
    "geomakie.jl",
    "examples2d.jl",
    "examples3d.jl",
    "interactive.jl",
    "documentation.jl",
    "diffeq.jl",
    "implicits.jl",
    "recipes.jl",
    "bigdata.jl",
    "short_tests.jl",
    "attributes.jl",
    "intermediate.jl",
]);

# where is the refimage repo?
repo = joinpath(get(ENV, "MAKIEGALLERY_REFIMG_PATH", joinpath(homedir(), ".julia", "dev", "MakieReferenceImages")), "gallery")

recordings = joinpath(@__DIR__, "test_recordings")

# MakieGallery.generate_preview(recordings, joinpath(recordings, "index.html"))

# Here, we redefine the order of the refimages, to our preferred order.

preferred_order = abspath.(joinpath.(
    dirname(pathof(MakieGallery)),
    "..",
    "examples",
    [
    "tutorials.jl",
    "statsmakie.jl",
    "examples2d.jl",
    "examples3d.jl",
    "layouting.jl",
    "interactive.jl",
    "diffeq.jl",
    "implicits.jl",
    "geomakie.jl",
    "documentation.jl",
    "recipes.jl",
    "bigdata.jl",
    "attributes.jl",
    "intermediate.jl",
    "short_tests.jl",
    ]
))

svec = sort(database, by = x -> findfirst(==(x.file), preferred_order)) |> Vector

empty!(MakieGallery.database)
append!(MakieGallery.database, svec)
MakieGallery.database
# generate `thumb.jpg` for every directory in `recordings`
MakieGallery.generate_thumbnails(recordings)

# move this content to the repo
# cp(recordings, repo, force = true)

empty!(MakieGallery.plotting_backends)
append!(MakieGallery.plotting_backends, ["Makie"])
MakieGallery.plotting_backends
# generate HTML pages for the Gallery and
MakieGallery.gallery_from_recordings(
    repo,
    joinpath(repo, "index.html");
    hltheme = MakieGallery.Highlights.Themes.DefaultTheme
)

MakieGallery.generate_preview(repo)

run(`open ./src/preview.html`)
