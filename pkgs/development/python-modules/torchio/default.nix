{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  deprecated,
  humanize,
  matplotlib,
  nibabel,
  numpy,
  parameterized,
  scipy,
  simpleitk,
  torch,
  tqdm,
  typer,
}:

buildPythonPackage rec {
  pname = "torchio";
  version = "0.19.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fepegar";
    repo = "torchio";
    rev = "refs/tags/v${version}";
    hash = "sha256-RqKJStUZhnSmsifn3WjYLfmRkkme+GOe6dp0E0MW9tE=";
  };

  propagatedBuildInputs = [
    deprecated
    humanize
    nibabel
    numpy
    scipy
    simpleitk
    torch
    tqdm
    typer
  ] ++ typer.passthru.optional-dependencies.all;

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
    parameterized
  ];
  disabledTests =
    [
      # tries to download models:
      "test_load_all"
    ]
    ++ lib.optionals stdenv.isAarch64 [
      # RuntimeError: DataLoader worker (pid(s) <...>) exited unexpectedly
      "test_queue_multiprocessing"
    ];
  pythonImportsCheck = [
    "torchio"
    "torchio.data"
  ];

  meta = with lib; {
    description = "Medical imaging toolkit for deep learning";
    homepage = "https://torchio.readthedocs.io";
    license = licenses.asl20;
    maintainers = [ maintainers.bcdarwin ];
  };
}
