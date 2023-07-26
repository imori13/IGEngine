#pragma once

#pragma warning(push, 0)
#include <codeanalysis/warnings.h>
#pragma warning(disable: ALL_CODE_ANALYSIS_WARNINGS)

#pragma comment(lib, "vulkan-1.lib")

#include <SDL2/SDL.h>
#include <gsl/gsl>
#include <vulkan/vulkan.h>

#undef main

#include <iostream>
#include <stdexcept>
#include <vector>
#include <memory>

#pragma warning(pop)