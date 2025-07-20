#include "husradiusgenerator.h"

HusRadiusGenerator::HusRadiusGenerator(QObject *parent)
    : QObject{parent}
{

}

HusRadiusGenerator::~HusRadiusGenerator()
{

}

QList<int> HusRadiusGenerator::generateRadius(int radiusBase)
{
    auto radiusLG = radiusBase;
    auto radiusSM = radiusBase;
    auto radiusXS = radiusBase;
    auto radiusOuter = radiusBase;

    // radiusLG
    if (radiusBase < 6 && radiusBase >= 5) {
        radiusLG = radiusBase + 1;
    } else if (radiusBase < 16 && radiusBase >= 6) {
        radiusLG = radiusBase + 2;
    } else if (radiusBase >= 16) {
        radiusLG = 16;
    }

    // radiusSM
    if (radiusBase < 7 && radiusBase >= 5) {
        radiusSM = 4;
    } else if (radiusBase < 8 && radiusBase >= 7) {
        radiusSM = 5;
    } else if (radiusBase < 14 && radiusBase >= 8) {
        radiusSM = 6;
    } else if (radiusBase < 16 && radiusBase >= 14) {
        radiusSM = 7;
    } else if (radiusBase >= 16) {
        radiusSM = 8;
    }

    // radiusXS
    if (radiusBase < 6 && radiusBase >= 2) {
        radiusXS = 1;
    } else if (radiusBase >= 6) {
        radiusXS = 2;
    }

    // radiusOuter
    if (radiusBase > 4 && radiusBase < 8) {
        radiusOuter = 4;
    } else if (radiusBase >= 8) {
        radiusOuter = 6;
    }

    return {
        radiusBase,
        radiusLG,
        radiusSM,
        radiusXS,
        radiusOuter
    };
}
