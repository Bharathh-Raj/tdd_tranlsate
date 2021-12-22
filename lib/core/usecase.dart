import 'package:dartz/dartz.dart';

import 'failure.dart';

abstract class UseCaseAbs {}

abstract class UseCase<Type, Param> implements UseCaseAbs {
  Future<Type> call(Param param);
}

abstract class UseCaseWithFailure<Type, Param> implements UseCaseAbs {
  Future<Either<Failure, Type>> call(Param param);
}

class NoParam {
  const NoParam();
}
